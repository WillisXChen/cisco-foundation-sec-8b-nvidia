#!/usr/bin/env bash
# manage_user.sh — Manage nginx/.htpasswd accounts
#
# Usage:
#   ./add_user.sh add <username> [password]   Add or update account
#   ./add_user.sh del <username>              Delete account
#   ./add_user.sh list                        List all accounts

set -euo pipefail

HTPASSWD_FILE="$(cd "$(dirname "$0")" && pwd)/nginx/.htpasswd"
NGINX_CONTAINER="security-app-nginx"

# ── Usage Instructions ──────────────────────────────────────────────
usage() {
  echo "Usage:"
  echo "  $0 add <username> [password]   Add or update account"
  echo "  $0 del <username>              Delete account"
  echo "  $0 list                        List all accounts"
  exit 1
}

[[ $# -lt 1 ]] && usage

# ── nginx reload helper ─────────────────────────────────
nginx_reload() {
  if docker ps --format '{{.Names}}' | grep -q "^${NGINX_CONTAINER}$"; then
    echo "🔄 Reloading nginx..."
    docker exec "$NGINX_CONTAINER" nginx -s reload
    echo "✅ Nginx has reloaded, changes take effect immediately."
  else
    echo "⚠️  Cannot find running ${NGINX_CONTAINER} container, please run manually:"
    echo "   docker exec ${NGINX_CONTAINER} nginx -s reload"
  fi
}

# ── Account List ─────────────────────────────────────────────
cmd_list() {
  if [[ ! -f "$HTPASSWD_FILE" ]] || ! grep -v '^#' "$HTPASSWD_FILE" | grep -q ':'; then
    echo "(Currently no accounts exist)"
    return
  fi
  echo "📄 Current account list:"
  grep -v '^#' "$HTPASSWD_FILE" | cut -d: -f1 | sed 's/^/   - /'
}

# ── Add / Update Account ───────────────────────────────────────
cmd_add() {
  local USERNAME="${1:-}"
  [[ -z "$USERNAME" ]] && usage

  local PASSWORD
  if [[ $# -ge 2 ]]; then
    PASSWORD="$2"
  else
    read -rsp "Please enter password for ${USERNAME}: " PASSWORD; echo
    local PASSWORD2
    read -rsp "Confirm password: "          PASSWORD2; echo
    if [[ "$PASSWORD" != "$PASSWORD2" ]]; then
      echo "❌ Passwords do not match, cancelled." >&2; exit 1
    fi
  fi
  [[ -z "$PASSWORD" ]] && { echo "❌ Password cannot be empty." >&2; exit 1; }

  mkdir -p "$(dirname "$HTPASSWD_FILE")"

  local HASH
  HASH=$(docker run --rm httpd:alpine htpasswd -nb "$USERNAME" "$PASSWORD")

  if [[ -f "$HTPASSWD_FILE" ]] && grep -q "^${USERNAME}:" "$HTPASSWD_FILE"; then
    sed -i.bak "s|^${USERNAME}:.*|${HASH}|" "$HTPASSWD_FILE"
    rm -f "${HTPASSWD_FILE}.bak"
    echo "✅ Account '${USERNAME}' updated."
  else
    echo "$HASH" >> "$HTPASSWD_FILE"
    echo "✅ Account '${USERNAME}' added."
  fi

  cmd_list
  nginx_reload
}

# ── Delete Account ─────────────────────────────────────────────
cmd_del() {
  local USERNAME="${1:-}"
  [[ -z "$USERNAME" ]] && usage

  if [[ ! -f "$HTPASSWD_FILE" ]] || ! grep -q "^${USERNAME}:" "$HTPASSWD_FILE"; then
    echo "❌ Account '${USERNAME}' does not exist." >&2; exit 1
  fi

  sed -i.bak "/^${USERNAME}:/d" "$HTPASSWD_FILE"
  rm -f "${HTPASSWD_FILE}.bak"
  echo "🗑️  Account '${USERNAME}' deleted."

  cmd_list
  nginx_reload
}

# ── Main Control Flow ───────────────────────────────────────────────
COMMAND="$1"; shift

case "$COMMAND" in
  add)  cmd_add  "$@" ;;
  del)  cmd_del  "$@" ;;
  list) cmd_list      ;;
  *)    usage         ;;
esac
