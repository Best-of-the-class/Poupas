package main

/*
#include <stdlib.h>
*/
import "C"

import (
	"encoding/json"
	"unsafe"

	"security/crypto"
)

type Input struct {
	Payload string `json:"payload"`
	Pepper  string `json:"pepper"`
}

type Output struct {
	Success bool   `json:"success"`
	Data    string `json:"data"`
	Error   string `json:"error"`
}

func handle(input string) string {
	var in Input
	if err := json.Unmarshal([]byte(input), &in); err != nil {
		out, _ := json.Marshal(Output{Success: false, Error: "invalid input: " + err.Error()})
		return string(out)
	}

	result, err := crypto.HashPassword(in.Payload, in.Pepper)
	if err != nil {
		out, _ := json.Marshal(Output{Success: false, Error: err.Error()})
		return string(out)
	}

	out, _ := json.Marshal(Output{Success: true, Data: result})
	return string(out)
}

//export HashPassword
func HashPassword(input *C.char) *C.char {
	goInput := C.GoString(input)
	res := handle(goInput)
	return C.CString(res)
}

//export FreeString
func FreeString(ptr *C.char) {
	C.free(unsafe.Pointer(ptr))
}

func main() {}