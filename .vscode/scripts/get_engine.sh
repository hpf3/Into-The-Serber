#!/usr/bin/env bash
set -euo pipefail

log() {
    printf '[godot] %s\n' "$*"
}

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf '[godot] missing required command: %s\n' "$1" >&2
        exit 1
    fi
}

require_cmd curl
require_cmd unzip
require_cmd mktemp
if command -v file >/dev/null 2>&1; then
    HAVE_FILE=1
else
    HAVE_FILE=0
    log "warning: 'file' command not found; skipping binary validation"
fi

# Download/cache the Godot 4.5 (non-mono) editor + templates locally and optionally
# launch it with any arguments that follow. The assets live inside the repo under
# .godot to keep CI and teammates in sync without hitting system-wide paths.

ENGINE_VERSION="4.5-stable"
TEMPLATES_VERSION="4.5.stable"
ENGINE_FILENAME="Godot_v${ENGINE_VERSION}_linux.x86_64"
ENGINE_ARCHIVE="${ENGINE_FILENAME}.zip"
ENGINE_URL="https://github.com/godotengine/godot/releases/download/${ENGINE_VERSION}/${ENGINE_ARCHIVE}"
TEMPLATES_ARCHIVE="Godot_v${ENGINE_VERSION}_export_templates.tpz"
TEMPLATES_URL="https://github.com/godotengine/godot/releases/download/${ENGINE_VERSION}/${TEMPLATES_ARCHIVE}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CACHE_DIR="${REPO_ROOT}/.godot"
ENGINE_PATH="${CACHE_DIR}/${ENGINE_FILENAME}"
TEMPLATE_CACHE="${CACHE_DIR}/templates"
TEMPLATE_DEST="${HOME}/.local/share/godot/export_templates/${TEMPLATES_VERSION}"

DOWNLOAD_ONLY=0
if [[ ${1:-} == "--download-only" ]]; then
    DOWNLOAD_ONLY=1
    shift
fi

is_valid_engine() {
    [[ -x "$ENGINE_PATH" ]] || return 1
    [[ $HAVE_FILE -eq 1 ]] || return 0
    file "$ENGINE_PATH" 2>/dev/null | grep -q "ELF 64-bit"
}

ensure_engine() {
    if is_valid_engine; then
        log "reusing cached engine at ${ENGINE_PATH}"
        return
    fi

    log "fetching ${ENGINE_FILENAME}"
    mkdir -p "$CACHE_DIR"
    local tmp_zip
    tmp_zip="$(mktemp "${CACHE_DIR}/engine.XXXXXX.zip")"
    log "downloading ${ENGINE_URL}"
    curl -fL "$ENGINE_URL" -o "$tmp_zip"
    log "unpacking engine to ${CACHE_DIR}"
    unzip -o "$tmp_zip" -d "$CACHE_DIR" >/dev/null
    rm -f "$tmp_zip"
    chmod +x "$ENGINE_PATH"

    if ! is_valid_engine; then
        log "cached engine failed validation, retrying download" >&2
        rm -f "$ENGINE_PATH"
        ensure_engine
    fi
}

ensure_templates() {
    if [[ -f "${TEMPLATE_DEST}/web_release.zip" || -f "${TEMPLATE_DEST}/web_release.pck" ]]; then
        log "export templates already present at ${TEMPLATE_DEST}"
        return
    fi

    log "installing export templates into ${TEMPLATE_DEST}"
    mkdir -p "$CACHE_DIR"
    local tmp_tpz
    tmp_tpz="$(mktemp "${CACHE_DIR}/templates.XXXXXX.tpz")"
    log "downloading ${TEMPLATES_URL}"
    curl -fL "$TEMPLATES_URL" -o "$tmp_tpz"
    rm -rf "$TEMPLATE_CACHE"
    mkdir -p "$TEMPLATE_CACHE"
    log "unpacking templates"
    unzip -o "$tmp_tpz" -d "$TEMPLATE_CACHE" >/dev/null
    rm -f "$tmp_tpz"
    mkdir -p "$TEMPLATE_DEST"
    cp -a "$TEMPLATE_CACHE/templates/." "$TEMPLATE_DEST/"
}

ensure_engine
ensure_templates

if [[ $DOWNLOAD_ONLY -eq 1 ]]; then
    log "download-only mode complete"
    exit 0
fi

log "launching ${ENGINE_PATH} $*"
exec "$ENGINE_PATH" "$@"
