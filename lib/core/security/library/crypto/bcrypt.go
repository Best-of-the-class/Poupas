package crypto

import (
	"golang.org/x/crypto/bcrypt"
)

func HashPassword(password string, pepper string) (string, error) {
	data := []byte(password + pepper)
	hash, err := bcrypt.GenerateFromPassword(data, bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(hash), nil
}

func Compare(password string, pepper string, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password+pepper))
	return err == nil
}
