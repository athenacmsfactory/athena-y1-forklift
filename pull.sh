#!/bin/bash

# Forklift Pull Script
# Syncs data from the Vault to the Playground (Werkplaats)

SITE_NAME=$1

if [ -z "$SITE_NAME" ]; then
    echo "Usage: ./pull.sh <site_name>"
    exit 1
fi

# Safety Check: Prevent path traversal
if [[ "$SITE_NAME" == *"/"* ]] || [[ "$SITE_NAME" == *".."* ]]; then
    echo "❌ Error: Invalid site name '$SITE_NAME'. No slashes or dots allowed."
    exit 1
fi

VAULT_PATH="/home/kareltestspecial/0-IT/3-DEV/y1/sites/$SITE_NAME"
PLAYGROUND_PATH="/home/kareltestspecial/0-IT/3-DEV/y1/y/werkplaats/$SITE_NAME"

if [ ! -d "$VAULT_PATH" ]; then
    echo "❌ Error: Site '$SITE_NAME' not found in Vault ($VAULT_PATH)."
    exit 1
fi

echo "🚚 Pulling '$SITE_NAME' from Vault to Werkplaats..."

# Ensure parent directory exists
mkdir -p "/home/kareltestspecial/0-IT/3-DEV/y1/y/werkplaats"

# Sync data
# -a: archive mode
# -v: verbose
# --exclude: skip node_modules and git
rsync -av --exclude 'node_modules' --exclude '.git' "$VAULT_PATH/" "$PLAYGROUND_PATH/"

# 🚀 Hydration (Automation)
if [ -f "$PLAYGROUND_PATH/package.json" ]; then
    echo "📦 Hydrating '$SITE_NAME' (pnpm install)..."
    (cd "$PLAYGROUND_PATH" && pnpm install)
    if [ $? -eq 0 ]; then
        echo "✅ Hydration successful."
    else
        echo "⚠️  Hydration failed, please run pnpm install manually in $PLAYGROUND_PATH"
    fi
fi

echo "✅ Pull complete. Site is ready in: $PLAYGROUND_PATH"
echo "💡 The Factory can now access this site via its internal 'sites' symlink."
