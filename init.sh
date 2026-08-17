#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
	echo "Error: .env not found at $ENV_FILE" >&2
	exit 1
fi

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

: "${ARRPATH:?ARRPATH is not set in .env}"
: "${PUID:?PUID is not set in .env}"
: "${PGID:?PGID is not set in .env}"

if [[ $EUID -ne 0 ]]; then
	echo "This script needs root to chown folders under ${ARRPATH}. Re-run with sudo." >&2
	exit 1
fi

FOLDERS=(
	"${ARRPATH}Prowlarr/config"
	"${ARRPATH}Prowlarr/backup"
	"${ARRPATH}Sonarr/config"
	"${ARRPATH}Sonarr/backup"
	"${ARRPATH}Sonarr/tvshows"
	"${ARRPATH}Radarr/config"
	"${ARRPATH}Radarr/backup"
	"${ARRPATH}Radarr/movies"
	"${ARRPATH}Jellyfin/config"
	"${ARRPATH}Bazarr/config"
	"${ARRPATH}Lidarr/music"
	"${ARRPATH}Seerr/config"
	"${ARRPATH}qbittorrent/config"
	"${ARRPATH}Downloads"
)

echo "Creating folders under ${ARRPATH}..."
for dir in "${FOLDERS[@]}"; do
	mkdir -p "$dir"
	echo "  ok: $dir"
done

echo "Setting ownership to ${PUID}:${PGID}..."
chown -R "${PUID}:${PGID}" "${ARRPATH}"

echo "Done. You can now run: docker compose up -d"
