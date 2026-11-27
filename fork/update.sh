#!/usr/bin/env bash
# Rebase the rui branch onto the newest stable T3 Code release, then build the macOS app.
# Stops on rebase conflicts: resolve them, run `git rebase --continue`, and run this again.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

if [ "$(git branch --show-current)" != rui ]; then
  echo "Switch to the rui branch first." >&2
  exit 1
fi
if [ -n "$(git status --porcelain)" ]; then
  echo "The working tree has uncommitted changes. Commit or stash them first." >&2
  exit 1
fi

git fetch upstream --tags --prune --quiet
current=$(git describe --tags --abbrev=0 --match 'v[0-9]*' --exclude '*-*' HEAD)
latest=$(git tag -l 'v[0-9]*' --sort=-v:refname | awk '!/-/' | head -1)

if [ "$current" = "$latest" ]; then
  echo "rui is already based on $latest."
else
  echo "Rebasing rui from $current onto $latest..."
  git rebase --onto "$latest" "$current" rui
  git push --force-with-lease origin rui
fi

node_version=$(jq -r .engines.node package.json)
fnm install "$node_version" >/dev/null 2>&1 || true
# pnpm comes from Corepack, which switches to the version in packageManager.
fnm exec --using="$node_version" pnpm install --frozen-lockfile
rm -rf release
# Official releases also set the version from the tag; the package.json version lags behind.
fnm exec --using="$node_version" pnpm run dist:desktop:dmg:arm64 --build-version "${latest#v}"

echo
echo "Built ${latest#v} in release/. Quit T3 Code, then run fork/install.sh."
