package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"time"
)

func main() {
	StartInterface()
}

// StartInterface starts the go server, setting up everything to handle http requests
func StartInterface() {
	http.HandleFunc("/NewProfile", NewProfile)
	http.HandleFunc("/LDAPLogin", LDAPLogin)
	http.HandleFunc("/TokenLogin", TokenLogin)
	http.HandleFunc("/TokenRefresh", TokenRefresh)

	log.Println("Interface will start to listen on localhost:8443")
	err := http.ListenAndServe(":8443", nil)

	if err != nil {
		fmt.Println(err)
		return
	}
}

// UserProfile defines a user
type UserProfile struct {
	id      string
	Name    string
	Surname string
	Email   string
	Year    int
	Others  []string // TODO: define what a user is made of
}

// ErrUnauthorizedOperation is an error which appears when the user tries to do something which he is not allowed to.
//
// Mostly reading or modyfying stuff in the database that he should not be able to.
type ErrUnauthorizedOperation struct {
	err string
}

func (unauthorizedOperation *ErrUnauthorizedOperation) Error() string {
	return unauthorizedOperation.err
}

// NewProfile recieve a POST message with a token and all profile informations
/* 1) Checks if the token is valid */
/* 2) Save new profile info */
/* 3) Asks for the computation of the distance between current user and every other users */
func NewProfile(w http.ResponseWriter, req *http.Request) {

	// Get data from POST form
	err := req.ParseForm()
	if err != nil {
		http.Error(w, "Could not parse the form.", http.StatusBadRequest)
		log.Println(err)
		return
	}
	form := req.Form

	// Get all data while checking if it exists
	var login, name, surname, mail, yearString []string
	var loginExists, nameExists, surnameExists, mailExists, yearExists bool
	login, loginExists = form["login"]
	name, nameExists = form["name"]
	surname, surnameExists = form["surname"]
	mail, mailExists = form["mail"]
	yearString, yearExists = form["year"]
	if !(loginExists && nameExists && surnameExists && mailExists && yearExists) {
		errMessage := fmt.Sprintf("One or more argument on the profile is missing:\nloginExists: %v\nnameExists: %v\nsurnameExists: %v\nmailExists: %v\nyearExists: %v\n",
			loginExists, nameExists, surnameExists, mailExists, yearExists)
		http.Error(w, errMessage, http.StatusUnprocessableEntity)
		log.Printf(errMessage)
		return
	}
	year, err := strconv.Atoi(yearString[0])
	if err != nil {
		http.Error(w, fmt.Sprintf("year should be a number, not %v", yearString), http.StatusUnprocessableEntity)
		log.Println(err)
		return
	}

	// Create a new UserProfile
	userProfile := UserProfile{
		id:      login[0],
		Name:    name[0],
		Surname: surname[0],
		Email:   mail[0],
		Year:    year,
	}

	// Get the token from the cookie
	sessionTokenString, err := getSessionTokenString(req)
	if err != nil {
		http.Error(w, "Could not get token from cookie", http.StatusInternalServerError)
		log.Println(err)
		return
	}
	sessionToken := SessionToken{value: sessionTokenString}

	// Get session token informations
	err = FillSessionToken(&sessionToken)
	if err != nil {
		http.Error(w, "The token send is not valid.", http.StatusUnauthorized)
		log.Println(err)
		return
	}

	// Check if the user is allow to create this new user.
	// A user should only be able to create a new user which has his login as a login
	if sessionToken.associatedLogin != login[0] {
		errMessage := fmt.Sprintf("User \"%v\" can not create a profile with login \"%v\"", sessionToken.associatedLogin, login[0])
		http.Error(w, errMessage, http.StatusUnauthorized)
		log.Println(ErrUnauthorizedOperation{errMessage})
		return
	}

	// Create new user in the database
	err = InsertNewProfile(userProfile)
	if err != nil {
		http.Error(w, "", http.StatusInternalServerError)
		log.Println(err)
		return
	}

	// TODO: Compute the distance between current user and every other users

	// Notify the client that everything went smoothly
	w.WriteHeader(http.StatusOK)
}

// TokenLogin tries to log a user with a token
// The token is passed in a cookie and should correspond to one in the database
func TokenLogin(w http.ResponseWriter, req *http.Request) {
	sessionTokenString, err := getSessionTokenString(req)
	if err != nil {
		http.Error(w, "Could not get token from cookie", http.StatusInternalServerError)
		log.Println(err)
		return
	}
	sessionToken := SessionToken{value: sessionTokenString}

	isValid, err := IsSessionTokenValid(&sessionToken)
	if err != nil {
		http.Error(w, "Could not get token from cookie", http.StatusInternalServerError)
		log.Println(err)
		return
	}

	if !isValid {
		http.Error(w, "Wrong token", http.StatusUnauthorized)
		log.Println("The user tried to login with a wrong token.")
		return
	}

	// Send response to client
	w.WriteHeader(http.StatusOK)
}

// TokenRefresh allows a user to get a new token if they already have a valid one
//
// Note that this will invalidate the current valid token which should not be used anymore
func TokenRefresh(w http.ResponseWriter, req *http.Request) {
	oldSessionTokenString, err := getSessionTokenString(req)
	if err != nil {
		http.Error(w, "Could not get token from cookie", http.StatusInternalServerError)
		return
	}
	oldSessionToken := SessionToken{value: oldSessionTokenString}

	newSessionToken, err := RefreshSessionToken(&oldSessionToken)
	if err != nil {
		http.Error(w, "The given token is not valid", http.StatusUnauthorized)
		log.Println(err)
		return
	}

	// Send new session token to client
	newSessionToken.HTTPWrite(w)

}

// HTTPWrite is a method of SessionToken which writes
// this token in a cookie in the given http.ResponseWriter
func (sessionToken SessionToken) HTTPWrite(w http.ResponseWriter) {
	http.SetCookie(w, &http.Cookie{
		Name:   "Session_cookie",
		Value:  sessionToken.value,
		MaxAge: int(sessionToken.expirationDate.Sub(time.Now())),
		// TODO: Set cookie to secure
	})
}

func getSessionTokenString(req *http.Request) (string, error) {
	SESSION_COOKIE_NAME := "Session_cookie"

	// Retrieve the token
	sessionTokenCookie, err := req.Cookie(SESSION_COOKIE_NAME)
	if err != nil {
		return "", err
	}

	return sessionTokenCookie.Value, nil
}

// LDAPLogin Authentificate the user via LDAP
// and returns :
/* 1) A fresh new token */
/* 2) Users informations from LDAP if the user is not in the database (since this would mean that it is his/her first login) */
func LDAPLogin(w http.ResponseWriter, req *http.Request) {

	// Get data from POST form
	err := req.ParseForm()
	if err != nil {
		http.Error(w, "Could not parse the form.", http.StatusBadRequest)
		log.Println(err)
		return
	}
	form := req.Form

	// Get user id and password while checking if it exists
	var id, password []string
	var idExists, passwordExists bool
	id, idExists = form["id"]
	password, passwordExists = form["password"]
	if !(idExists && passwordExists) {
		errMessage := fmt.Sprintf("One or more argument of the authentification is missing:\nidExists: %v\npasswordExists: %v\n",
			idExists, passwordExists)
		http.Error(w, errMessage, http.StatusUnprocessableEntity)
		log.Println(errMessage)
		return
	}

	// Create a new userProfile
	userProfile := UserProfile{id: id[0]}

	// Authentificate the user through LDAP
	err = LDAPAuthenticate(id[0], password[0])
	switch err {
	case nil:
		break
	case ErrWrongUsername:
		http.Error(w, "Wrong username.", http.StatusUnauthorized)
		log.Println(err)
		return
	case ErrWrongPassword:
		http.Error(w, "Wrong password.", http.StatusUnauthorized)
		log.Println(err)
		return
	default:
		http.Error(w, "", http.StatusInternalServerError)
		log.Println(err)
		return
	}

	// Generate a new session token for this user
	sessionToken, err := GetNewSessionToken(userProfile.id)
	if err != nil {
		http.Error(w, "", http.StatusInternalServerError)
		log.Println(err)
		return
	}

	// Send session token to the client
	sessionToken.HTTPWrite(w)

	// Check if the user exists in the database
	isKnown, err := IsExistsProfile(userProfile)
	if err != nil {
		http.Error(w, "", http.StatusInternalServerError)
		log.Println(err)
		return
	}

	// If it is the first time someone connects, return LDAP informations
	if !isKnown {

		// Get user informations through LDAP
		err = LDAPGetInformations(&userProfile)
		if err != nil {
			http.Error(w, "", http.StatusInternalServerError)
			log.Println(err)
			return
		}

		// Send user informations to the client
		js, err := json.Marshal(userProfile)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			log.Println(err)
			return
		}
		w.Write(js)
	}

}
