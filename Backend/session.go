package main

import (
	"crypto/rand"
	"database/sql"
	"encoding/base64"
	"errors"
	"fmt"
	"time"
)

// SessionToken represent the session token of a user.
type SessionToken struct {
	value           string
	expirationDate  time.Time
	valid           bool
	associatedLogin string
}

// ErrInvalidToken designate an error which happens when a user try to act with a non valid token.
type ErrInvalidToken struct {
	value string
}

func (invalidToken *ErrInvalidToken) Error() string {
	return fmt.Sprintf("Token \"%v\" is not valid.", invalidToken.value)
}

// ErrExpiredToken designate an error which happens when a user try to act with an expired token
type ErrExpiredToken struct {
	value string
}

func (expiredToken *ErrExpiredToken) Error() string {
	return fmt.Sprintf("Token \"%v\" is not valid.", expiredToken.value)
}

// ErrTokenDontExists designate an error which happens when a user try to act with a token which is not present in the database
// This error could be due to the expiration of a token or a wrong token
type ErrTokenDontExists struct {
	value string
}

func (tokenDontExists *ErrTokenDontExists) Error() string {
	return fmt.Sprintf("Token \"%v\" is not valid.", tokenDontExists.value)
}

// GenerateNewToken Generate unique cryptographically secure token
func GenerateNewToken() (string, error) {
	TOKEN_SIZE := 32

	tokenBytes := make([]byte, TOKEN_SIZE)
	_, err := rand.Read(tokenBytes)
	if err != nil {
		return "", err
	}

	token := base64.URLEncoding.EncodeToString(tokenBytes)

	return token, nil
}

// IsSessionTokenValid is true if the given token is valid
// If the token is expired return false
// If the token is invalid, invalidate all user's token and return false
func IsSessionTokenValid(sessionToken *SessionToken) (bool, error) {

	err := GetTokenData(sessionToken)
	switch err {
	case nil:
		break
	case sql.ErrNoRows:
		return false, nil
	default:
		return false, errors.New("Database internal error")
	}

	if sessionToken.valid && sessionToken.expirationDate.After(time.Now()) {
		return true, nil
	}
	// TODO: delete token if the expirationDate has passed
	// TODO: invalidate all user's token if token is not valid
	return false, nil
}

// FillSessionToken tries to get information of the current session filling the token that was given.
/* If the token does not exists, return ErrTokenDontExists. */
/* If the token is expired return ErrExpiredToken. */
/* If the token is invalid, invalidate all user's token and return ErrInvalidToken. */
func FillSessionToken(sessionToken *SessionToken) error {

	err := GetTokenData(sessionToken)
	switch err {
	case sql.ErrNoRows:
		return &ErrTokenDontExists{sessionToken.value}
	default:
		break // BUG: a (0x0,0x0) error is always returned by GetTokenData, don't know why.
	}

	if sessionToken.valid && sessionToken.expirationDate.After(time.Now()) {
		return nil
	} else if sessionToken.expirationDate.Before(time.Now()) {
		// TODO: delete token if the expirationDate has passed
		return &ErrExpiredToken{sessionToken.value}
	} else {
		// TODO: invalidate all user's token if token is not valid
		return &ErrInvalidToken{sessionToken.value}
	}
}

// RefreshSessionToken generate a new token if the current one is valid
//
// Warning: if the current invalid it should delete all the user token and if
// the expiration date has been exceeded it should remove the given token from
// the database
func RefreshSessionToken(oldSessionToken *SessionToken) (*SessionToken, error) {

	// Check if the given token is valid
	valid, err := IsSessionTokenValid(oldSessionToken)
	if err != nil {
		return nil, errors.New("error while trying to see if token was valid")
	}
	if !valid {
		return nil, &ErrInvalidToken{oldSessionToken.value}
	}

	// Invalidate the current token
	err = InvalidateToken(oldSessionToken)
	if err != nil {
		return nil, err
	}

	// Get a new token
	newSessionToken, err := GetNewSessionToken(oldSessionToken.associatedLogin)
	if err != nil {
		return nil, err
	}

	// Return the newly generated token
	return newSessionToken, nil

}

// GetNewSessionToken generates a new session token.
//
// This session token has the following field:
/* value: A new cryptographically secure token */
/* associatedLogin: the associatedLogin given as an argument, this should not be null*/
/* expirationDate: a date which is X days from now. (X=EXPIRATION_DELAY)*/
/* valid: true*/
func GetNewSessionToken(associatedLogin string) (*SessionToken, error) {
	EXPIRATION_DELAY := 30

	if associatedLogin == "" {
		return nil, errors.New("the argument associated login should not be empty")
	}

	newToken, err := GenerateNewToken()
	if err != nil {
		return nil, err
	}
	newSessionToken := SessionToken{value: newToken}

	// Fill it with informations
	newSessionToken.associatedLogin = associatedLogin
	newSessionToken.expirationDate = time.Now().AddDate(0, 0, EXPIRATION_DELAY)
	newSessionToken.valid = true

	// Store the new token
	err = StoreToken(&newSessionToken)
	if err != nil {
		return nil, err
	}

	return &newSessionToken, nil
}
