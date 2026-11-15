#!/bin/sh

# Sync ROMS from the backup to ES-DE

set -euo pipefail

# Change to the directory where the script lives
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
cd $SCRIPT_DIR

if [ $# -ne 1 ]; then
  echo "Usage: $0 <target-dir>"
  exit 1
fi

TARGET_DIR="$(readlink -f "$1")"

# Source dir name -> target dir name mappings
# If not listed, the source name is used as-is
declare -A DIR_MAP=(
  ["GameCube"]="gc"
  ["GBA"]="gba"
  ["GBC"]="gbc"
  ["MegaDrive"]="megadrive"
  ["N64"]="n64"
  ["NES"]="nes"
  ["SNES"]="snes"
  ["PS2"]="ps2"
  ["PSX"]="psx"
  ["Wii"]="wii"
)

for dir in */; do
  [ -d "$dir" ] || continue
  # clean / suffix from dir
  dirname="${dir%/}"

	printf "\n\n==== ${dirname} ====\n\n"
  for item in "$dir"*; do
    [ -e "$item" ] || continue
    SOURCE="${SCRIPT_DIR}/${item}"
    TARGET="${TARGET_DIR}/${DIR_MAP[$dirname]:-$dirname}/$(basename "$item")"
		printf "${SOURCE}\t->\t${TARGET}\n"
    ln -sfn "${SOURCE}" "${TARGET}"
  done
done
