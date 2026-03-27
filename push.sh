#!/bin/bash

# Forklift Push Script
# Syncs data from the Playground (Werkplaats) back to the Vault

SITE_NAME=$1

if [ -z "$SITE_NAME" ]; then
    echo "Usage: ./push.sh <site_name>"
    exit 1
fi

# Safety Check: Prevent path traversal
if [[ "$SITE_NAME" == *"/"* ]] || [[ "$SITE_NAME" == *".."* ]]; then
    echo "❌ Error: Invalid site name '$SITE_NAME'. No slashes or dots allowed."
    exit 1
fi

VAULT_PATH="/home/kareltestspecial/0-IT/3-DEV/y1/sites/$SITE_NAME"
PLAYGROUND_PATH="/home/kareltestspecial/0-IT/3-DEV/y1/y/werkplaats/$SITE_NAME"

if [ ! -d "$PLAYGROUND_PATH" ]; then
    echo "❌ Error: Site '$SITE_NAME' not found in Werkplaats ($PLAYGROUND_PATH)."
    exit 1
fi

echo "🚀 Pushing '$SITE_NAME' from Werkplaats to Vault..."
echo "⚠️  WARNING: This will promote your changes to the permanent storage."
echo "   Files in the Vault that are NOT in the Werkplaats will NOT be deleted."

# Manual confirmation required for safety
read -p "Are you sure you want to promote these changes? (y/N): " CONFIRM

if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    # Ensure Vault directory exists (in case it was deleted)
    mkdir -p "$VAULT_PATH"
    
    # Sync data back
    # -a: archive mode
    # -v: verbose
    # --exclude: safety skip
    rsync -av --exclude 'node_modules' --exclude '.git' "$PLAYGROUND_PATH/" "$VAULT_PATH/"
    
    echo "✅ Push complete. Changes have been promoted to the Vault."
else
    echo "🚫 Push cancelled."
fi
