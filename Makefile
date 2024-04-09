.DEFAULT_GOAL := test

.PHONY: build
build:
	go build ./...

.PHONY: test
test: bin/sqlc-gen-go
	go test ./...

bin/sqlc-gen-go: bin go.mod go.sum $(wildcard **/*.go)
	cd plugin && go build -o ../bin/sqlc-gen-go ./main.go

bin/sqlc-gen-go.wasm: bin bin/sqlc-gen-go
	cd plugin && GOOS=wasip1 GOARCH=wasm go build -o ../bin/sqlc-gen-go.wasm main.go

.PHONY: bin
bin:
	mkdir -p bin

.PHONY: clean
clean:
	rm -rf bin

.PHONY: fmt
fmt:
	@gci write -s 'standard' -s 'default' -s 'prefix(github.com/simonklee)' --skip-generated $(shell fd . -e go)
	@gofumpt -w $(shell fd -e go)

SQLC_VERSION ?= main

.PHONY: install-sqlc

# Temporary directory for installation
TEMP_DIR := $(shell mktemp -d)

install-sqlc:
	# Clone the repository
	@echo "Cloning the sqlc repository..."
	@git clone https://github.com/simonklee/sqlc $(TEMP_DIR)/sqlc

	# Change directory to the cloned repository
	@cd $(TEMP_DIR)/sqlc && \
	echo "Checking out the $(SQLC_VERSION) version..." && \
	git checkout $(SQLC_VERSION) && \
	echo "Building and installing sqlc..." && \
	make sqlc-dev

	# Clean up
	@echo "Cleaning up..."
	@rm -rf $(TEMP_DIR)
	@echo "sqlc installed successfully."
