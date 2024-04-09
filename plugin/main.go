package main

import (
	"github.com/sqlc-dev/plugin-sdk-go/codegen"

	golang "github.com/simonklee/sqlc-gen-go/internal"
)

func main() {
	codegen.Run(golang.Generate)
}
