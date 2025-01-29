package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"log"
	"net/http"
)

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/", DoHealthCheck).Methods("GET")
	router.HandleFunc("/teapot", DoTeapot).Methods("GET")
	log.Fatal(http.ListenAndServe(":8080", router))
}
func DoHealthCheck(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "This is an in class demo, nothing to see here")
	w.WriteHeader(http.StatusAccepted)
}

func DoTeapot(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "I'm a teapot")
	w.WriteHeader(http.StatusTeapot)
}
