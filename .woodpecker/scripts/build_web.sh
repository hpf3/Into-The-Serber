#!/usr/bin/env bash
set -euo pipefail

# Choose export preset by env (default: single-threaded for maximum compatibility)
: "${GODOT_PRESET:=single}"

# Godot binary defaults to `godot`, allow override for local tasks
GODOT="${GODOT_BIN:-godot}"

# Ensure export presets exist for the project export
EXPORT_PRESETS_SRC=".woodpecker/templates/export_presets.cfg"
EXPORT_PRESETS_DEST="src/export_presets.cfg"
if [[ ! -f "${EXPORT_PRESETS_SRC}" ]]; then
  echo "Missing export preset template: ${EXPORT_PRESETS_SRC}" >&2
  exit 1
fi
mkdir -p "$(dirname "${EXPORT_PRESETS_DEST}")"
cp "${EXPORT_PRESETS_SRC}" "${EXPORT_PRESETS_DEST}"

# Make output dir
mkdir -p build/web

# Export from ./src
$GODOT --headless --path ./src --verbose --export-release "$GODOT_PRESET" ../build/web/index.html

# Zip for artifacts
( cd build/web && zip -r ../web.zip . )
ls -lah build/web build/web.zip
