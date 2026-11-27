#!/usr/bin/env bash
# Back up T3 Code's data, install the freshly built app in /Applications and open it.
# Run it from Terminal with every T3 Code app closed.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

app_name="T3 Code (Rui)"
target="/Applications/$app_name.app"
backups="$HOME/.t3/backups"
keep_backups=2

if pgrep -f 'T3 Code \([A-Za-z]+\)' >/dev/null; then
  echo "A T3 Code app is still running. Quit it (Cmd-Q) and run this again." >&2
  exit 1
fi

dmg=$(ls -t release/*.dmg 2>/dev/null | head -1 || true)
if [ -z "$dmg" ]; then
  echo "No DMG in release/. Run fork/update.sh first." >&2
  exit 1
fi

# APFS clones: instant and free at first; they grow only as the live data changes.
stamp=$(date +%Y%m%d-%H%M%S)
mkdir -p "$backups/$stamp"
cp -cR "$HOME/.t3/userdata" "$backups/$stamp/userdata"
cp -cR "$HOME/Library/Application Support/t3code-v2" "$backups/$stamp/electron-t3code-v2"
echo "Backed up T3 Code data to $backups/$stamp"
ls -1d "$backups"/*/ | sort -r | tail -n +$((keep_backups + 1)) | while read -r old; do
  rm -rf "$old"
  echo "Removed old backup $old"
done

mount_point=$(mktemp -d)
hdiutil attach -nobrowse -readonly -mountpoint "$mount_point" "$dmg" >/dev/null
trap 'hdiutil detach -quiet "$mount_point" || true' EXIT
rm -rf "$target"
ditto "$mount_point/$app_name.app" "$target"
echo "Installed $target from $(basename "$dmg")"

open "$target"
