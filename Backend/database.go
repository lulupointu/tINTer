package main

import (
	"fmt"
	"log"

	"database/sql"

	_ "github.com/lib/pq"
)

type PostgresDatabase struct {
	host     string
	port     int
	user     string
	password string
	dbname   string
	db       *sql.DB
}

func NewPostgresDatabase() PostgresDatabase {
	return PostgresDatabase{
		host:     myPostgresDatabase.host,
		port:     myPostgresDatabase.port,
		user:     myPostgresDatabase.user,
		password: myPostgresDatabase.password,
		dbname:   myPostgresDatabase.dbname,
	}
}

func (psDb *PostgresDatabase) Connect() error {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		psDb.host, psDb.port, psDb.user, psDb.password, psDb.dbname)

	var err error
	psDb.db, err = sql.Open("postgres", psqlInfo)
	if err != nil {
		return err
	}

	log.Printf("Connected with databse %v successful!\n", psDb.dbname)
	return nil
}

func (psDb PostgresDatabase) Close() {
	psDb.db.Close()
	log.Println("Connexion with database closed.")
}

// IsExistsProfile check whether or not a profile exists in the database
func IsExistsProfile(userProfile UserProfile) (bool, error) {
	var isExists bool

	psDb := NewPostgresDatabase()
	err := psDb.Connect()
	if err != nil {
		return false, err
	}
	defer psDb.Close()

	sqlStatement := `
		SELECT EXISTS (SELECT * FROM users WHERE user_id=$1)
	`
	row := psDb.db.QueryRow(sqlStatement, userProfile.id)
	err = row.Scan(&isExists)

	if err != nil && err != sql.ErrNoRows {
		return false, err
	}

	return isExists, nil
}

// InsertNewProfile insert a new profile in the database
func InsertNewProfile(userProfile UserProfile) error {
	psDb := NewPostgresDatabase()
	err := psDb.Connect()
	if err != nil {
		return err
	}
	defer psDb.Close()

	sqlStatement := `
		INSERT INTO users (user_id, name, surname, email, year)
		VALUES ($1, $2, $3, $4, $5)
	`
	_, err = psDb.db.Exec(sqlStatement, userProfile.id, userProfile.Name, userProfile.Surname, userProfile.Email, userProfile.Year)
	if err != nil {
		return err
	}
	log.Println("New user added to db !")

	return nil
}

// GetTokenData retrieves token informations from the database
// and fill the given token with these informations
func GetTokenData(sessionToken *SessionToken) error {
	psDb := NewPostgresDatabase()
	err := psDb.Connect()
	if err != nil {
		return err
	}
	defer psDb.Close()

	sqlStatement := `
		SELECT * FROM sessions WHERE token=$1
	`

	row := psDb.db.QueryRow(sqlStatement, sessionToken.value)
	err = row.Scan(&sessionToken.value, &sessionToken.associatedLogin, &sessionToken.expirationDate, &sessionToken.valid)

	fmt.Printf("Session token fetched:\n    value: %v\n    expirationDate: %v\n    valid: %v\n    associatedLogin: %v\n",
		sessionToken.value, sessionToken.expirationDate, sessionToken.valid, sessionToken.associatedLogin,
	)

	return err
}

// InvalidateToken changes the field "valid" of the given token to false in the database
func InvalidateToken(sessionToken *SessionToken) error {
	psDb := NewPostgresDatabase()
	err := psDb.Connect()
	if err != nil {
		return err
	}
	defer psDb.Close()

	sqlStatement := `
		UPDATE sessions SET valid='false' WHERE token=$1
	`

	_, err = psDb.db.Exec(sqlStatement, sessionToken.value)
	if err != nil {
		return err
	}

	fmt.Printf("Token \"%v\" invalidated.\n", sessionToken.value)

	return nil
}

// StoreToken stores the given token in the database
func StoreToken(sessionToken *SessionToken) error {
	psDb := NewPostgresDatabase()
	err := psDb.Connect()
	if err != nil {
		return err
	}
	defer psDb.Close()

	sqlStatment := `
	INSERT INTO sessions (token, profile_id, expiration_date, valid) VALUES ($1, $2, $3, $4)
	`

	_, err = psDb.db.Exec(sqlStatment, sessionToken.value, sessionToken.associatedLogin, sessionToken.expirationDate, sessionToken.valid)
	if err != nil {
		return err
	}

	fmt.Printf("New token \"%v\" stored in the databse\n", sessionToken.value)

	return nil
}
