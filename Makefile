.PHONY: build test

build:
	go build ./...

test: bin/sqlc-gen-go
	go test ./... -count=1

all: bin/sqlc-gen-go bin/sqlc-gen-go.wasm

bin/sqlc-gen-go: bin go.mod go.sum $(wildcard **/*.go)
	cd plugin && go build -o ../bin/sqlc-gen-go ./main.go

bin/sqlc-gen-go.wasm: bin bin/sqlc-gen-go
	cd plugin && GOOS=wasip1 GOARCH=wasm go build -o ../bin/sqlc-gen-go.wasm main.go

.PHONY: fmt
bin:
	mkdir -p bin

.PHONY: fmt
fmt:
	@gci write -s 'standard' -s 'default' -s 'prefix(github.com/simonklee)' --skip-generated $(shell fd . -e go)
	@gofumpt -w $(shell fd -e go)
