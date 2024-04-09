#!/usr/bin/env bash

#cd sqlc && rm -f ~/bin/sqlc-dev && make sqlc-dev && cd - >/dev/null

# Capture the output of `fd sqlc.yaml` into an array, splitting by newline
IFS=$'\n' read -r -d '' -a paths_array < <(fd sqlc.yaml internal/endtoend/testdata && printf '\0')

for path in "${paths_array[@]}"; do
	# cd into the directory containing the sqlc.yaml file
	dir=$(dirname "$path")
	cd "$dir" || exit

	# Run the sqlc-dev generate command
	echo "Generate for $dir"
	sqlc-dev generate

	cd - >/dev/null
done
