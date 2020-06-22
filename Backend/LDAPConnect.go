package main

import "errors"

const (
	fakeUsername = "delsol_l"
	fakePassword = "azertyuiop"
	fakeName     = "Lucas"
	fakeSurname  = "Delsol"
	fakeEmail    = "Lucasdelsol@telecom-sudparis.eu"
)

// ErrWrongUsername is triggered when LDAP
// returns a username error
var ErrWrongUsername = errors.New("failed authentification, wrong username")

// ErrWrongPassword is triggered when LDAP
// returns a password error
var ErrWrongPassword = errors.New("failed authentification, wrong password")

// LDAPAuthenticate asks LDAP for authentification
func LDAPAuthenticate(username string, password string) error {

	//TODO: call LDAP for authentification
	if !(username == fakeUsername) {
		return ErrWrongUsername
	} else if !(password == fakePassword) {
		return ErrWrongPassword
	}

	return nil
}

// LDAPGetInformations asks LDAP for user information and fill userProfile with them.
//
// WARNING: the UserProfil should already have the field id filled.
func LDAPGetInformations(userProfile *UserProfile) error {

	if userProfile.id == "" {
		return errors.New("LDAPGetInformations: userProfile should have the field id filled")
	}

	//TODO: call LDAP to get the informations

	userProfile.Name = fakeName
	userProfile.Surname = fakeSurname
	userProfile.Email = fakeEmail
	return nil
}
