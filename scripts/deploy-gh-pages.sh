#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
cd "$ROOT_DIR"

BASE_HREF="${BASE_HREF:-/portfolio/}"
COMMIT_MESSAGE="${1:-Update portfolio}"

echo "Building Flutter Web with base href: $BASE_HREF"
flutter build web --base-href "$BASE_HREF" --pwa-strategy=none

echo "Copying service worker retirement file..."
cp web/flutter_service_worker.js build/web/flutter_service_worker.js

echo "Syncing build output to docs/ for GitHub Pages..."
rsync -a --delete build/web/ docs/
touch docs/.nojekyll

echo "Staging changes..."
git add .

if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

echo "Committing changes..."
git commit -m "$COMMIT_MESSAGE"

echo "Pushing to GitHub..."
git push

echo "Done. GitHub Pages will publish from the docs/ folder on the main branch."
