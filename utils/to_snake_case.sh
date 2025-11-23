#!/bin/bash

# Function to convert string to snake_case
to_snake_case() {
  echo "$1" | sed -E 's/([A-Z])/_\1/g' | sed 's/^_//' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]/_/g' | sed 's/__*/_/g' | sed 's/_$//'
}
