package database

import (
	"fmt"
	"os"

	"codes/go/jwt-authentication/models"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/joho/godotenv"
)

var DB *gorm.DB

func Connect() {
	e := godotenv.Load(".env")
	if e != nil {
		panic("failed to establish env")
	}

	dialect := os.Getenv("DIALECT")
	host := os.Getenv("HOST")
	dbport := os.Getenv("DBPORT")
	user := os.Getenv("USER")
	name := os.Getenv("NAME")
	password := os.Getenv("PASSWORD")

	dbURI := fmt.Sprintf("host=%s user=%s dbname=%s sslmode=disable password=%s port=%s", host, user, name, password, dbport)

	connection, err := gorm.Open(dialect, dbURI)

	if err != nil {
		panic("failed to connect database")
	} else {
		fmt.Println("Successfully connected to database!")
	}

	DB = connection

	// defer connection.Close()

	connection.AutoMigrate(&models.User{})

}
