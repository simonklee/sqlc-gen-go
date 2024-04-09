#!/usr/bin/env bash

# Sync upstream changes to forked repository
set -o errexit
set -o nounset
set -o pipefail

if [[ $# -ne 1 ]]; then
	echo "Usage: $(basename "$0") <sqlc-repo-path>"
	exit 1
fi

sqlc_repo_path="$1"

if [[ ! -d "$sqlc_repo_path" ]]; then
	echo "Directory does not exist: $sqlc_repo_path"
	exit 1
fi

cp -f "$sqlc_repo_path"/internal/codegen/golang/*.go internal/
cp -f "$sqlc_repo_path"/internal/codegen/golang/opts/*.go internal/opts/

sd 'github.com/sqlc-dev/sqlc/internal/codegen/golang' 'github.com/simonklee/sqlc-gen-go/internal' $(gofiles)
sd 'github.com/sqlc-dev/sqlc/internal/(debug|inflection)' 'github.com/simonklee/sqlc-gen-go/internal/$1' $(gofiles)
sd 'github.com/sqlc-dev/sqlc/internal/codegen/sdk' 'github.com/sqlc-dev/plugin-sdk-go/sdk' $(gofiles)
sd 'github.com/sqlc-dev/sqlc/internal/(plugin|metadata|pattern)' 'github.com/sqlc-dev/plugin-sdk-go/$1' $(gofiles)
