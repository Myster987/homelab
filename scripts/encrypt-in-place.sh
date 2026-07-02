#!/bin/sh
set -eu

if [ $# -ne 1 ]; then echo "Usage: enc <file>" >&2; exit 1; fi

KEY="../age.agekey"
FILE="$1"

if [ ! -f "$KEY" ]; then echo "Error: $KEY not found" >&2; exit 1; fi
if [ ! -f "$FILE" ]; then echo "Error: $FILE not found" >&2; exit 1; fi

PUBKEY=$(grep "# public key:" "$KEY" | awk '{print $NF}')
if [ -z "$PUBKEY" ]; then echo "Error: could not extract public key from $KEY" >&2; exit 1; fi

sops --encrypt --in-place --input-type yaml --output-type yaml --age "$PUBKEY" "$FILE"
echo "Encrypted in place -> $FILE"
