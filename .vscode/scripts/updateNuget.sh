#!/usr/bin/env bash

################################################################################
# updateNuget.sh
#
# 1) Locates the newest directory matching "Godot_*_mono_linux_x86_64" within
#    ../../../Engine (relative to this script).
# 2) Writes a NuGet.config that points the LocalPackages source at that folder’s
#    "GodotSharp/Tools/nupkgs" directory.
################################################################################

# -----------------------------------------------------------------------------
# Step 0: Identify this script's directory so we can reference relative paths
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
ENGINE_DIR="${SCRIPT_DIR}/../../../Engine/Engine"

# -----------------------------------------------------------------------------
# Step 1: Find the newest Godot mono folder in ENGINE_DIR
# -----------------------------------------------------------------------------
godot_dir="$(find "${ENGINE_DIR}" \
  -maxdepth 1 \
  -type d \
  -name 'Godot_*_mono_linux_x86_64' \
  2>/dev/null | sort -r | head -n 1)"

if [ -z "$godot_dir" ]; then
  echo "[ERROR] No Godot directory matching 'Godot_*_mono_linux_x86_64' found under '${ENGINE_DIR}'."
  exit 1
fi

echo "[INFO] Found Godot directory: $godot_dir"

# -----------------------------------------------------------------------------
# Step 2: Define the LocalPackages path
# -----------------------------------------------------------------------------
LocalPackagesPath="${godot_dir}/GodotSharp/Tools/nupkgs"

# -----------------------------------------------------------------------------
# Step 3: Ensure the directory exists (just in case)
# -----------------------------------------------------------------------------
mkdir -p "${LocalPackagesPath}"

# -----------------------------------------------------------------------------
# Step 4: Generate NuGet.config
# -----------------------------------------------------------------------------
cat <<EOF > NuGet.config
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
    <add key="LocalPackages" value="${LocalPackagesPath}" />
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
  </packageSources>
</configuration>
EOF

echo "[INFO] NuGet.config generated with LocalPackages = ${LocalPackagesPath}"
