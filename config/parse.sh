#!/usr/bin/env bash

# This script parses a simplified TOML-like format
# It only supports basic key-value pairs and sections

while IFS= read -r line
do
    # Ignore comments and empty lines
    [[ $line =~ ^# ]] && continue
    [[ -z $line ]] && continue

    if [[ $line =~ ^\[(.*)\]$ ]]; then
        section=${BASH_REMATCH[1]}
    elif [[ $line =~ ^([^=]+)=(.*)$ ]]; then
        # Key-value pair
        key=${BASH_REMATCH[1]}
        value=${BASH_REMATCH[2]}
        # Remove leading/trailing whitespace
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        if [[ -n $section ]]; then
            echo "${section^^}_${key^^}=${value}"
        else
            echo "${key^^}=${value}"
        fi
    fi
done < "$1"
