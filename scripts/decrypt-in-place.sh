#!/bin/sh
set -eu

if [ $# -ne 1 ]; then echo "Usage: dec <file>" >&2; exit 1; fi

KEY="../age.agekey"
FILE="$1"

if [ ! -f "$KEY" ]; then echo "Error: $KEY not found" >&2; exit 1; fi
if [ ! -f "$FILE" ]; then echo "Error: $FILE not found" >&2; exit 1; fi

SOPS_AGE_KEY_FILE="$KEY" sops --input-type yaml --output-type yaml --decrypt --in-place "$FILE"
echo "Decrypted -> $FILE"
