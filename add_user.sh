#!/usr/bin/env bash
# manage_user.sh — 管理 nginx/.htpasswd 帳號
#
# 用法：
#   ./add_user.sh add <username> [password]   新增或更新帳號
#   ./add_user.sh del <username>              刪除帳號
#   ./add_user.sh list                        列出所有帳號

set -euo pipefail

HTPASSWD_FILE="$(cd "$(dirname "$0")" && pwd)/nginx/.htpasswd"
NGINX_CONTAINER="security-app-nginx"

# ── 用法說明 ──────────────────────────────────────────────
usage() {
  echo "用法："
  echo "  $0 add <username> [password]   新增或更新帳號"
  echo "  $0 del <username>              刪除帳號"
  echo "  $0 list                        列出所有帳號"
  exit 1
}

[[ $# -lt 1 ]] && usage

# ── nginx reload 輔助函式 ─────────────────────────────────
nginx_reload() {
  if docker ps --format '{{.Names}}' | grep -q "^${NGINX_CONTAINER}$"; then
    echo "🔄 正在 reload nginx..."
    docker exec "$NGINX_CONTAINER" nginx -s reload
    echo "✅ Nginx 已 reload，變更立即生效。"
  else
    echo "⚠️  找不到執行中的 ${NGINX_CONTAINER} 容器，請手動執行："
    echo "   docker exec ${NGINX_CONTAINER} nginx -s reload"
  fi
}

# ── 帳號列表 ─────────────────────────────────────────────
cmd_list() {
  if [[ ! -f "$HTPASSWD_FILE" ]] || ! grep -v '^#' "$HTPASSWD_FILE" | grep -q ':'; then
    echo "（目前沒有任何帳號）"
    return
  fi
  echo "📄 目前帳號列表："
  grep -v '^#' "$HTPASSWD_FILE" | cut -d: -f1 | sed 's/^/   - /'
}

# ── 新增 / 更新帳號 ───────────────────────────────────────
cmd_add() {
  local USERNAME="${1:-}"
  [[ -z "$USERNAME" ]] && usage

  local PASSWORD
  if [[ $# -ge 2 ]]; then
    PASSWORD="$2"
  else
    read -rsp "請輸入 ${USERNAME} 的密碼: " PASSWORD; echo
    local PASSWORD2
    read -rsp "再次確認密碼: "          PASSWORD2; echo
    if [[ "$PASSWORD" != "$PASSWORD2" ]]; then
      echo "❌ 兩次密碼不一致，已取消。" >&2; exit 1
    fi
  fi
  [[ -z "$PASSWORD" ]] && { echo "❌ 密碼不可為空。" >&2; exit 1; }

  mkdir -p "$(dirname "$HTPASSWD_FILE")"

  local HASH
  HASH=$(docker run --rm httpd:alpine htpasswd -nb "$USERNAME" "$PASSWORD")

  if [[ -f "$HTPASSWD_FILE" ]] && grep -q "^${USERNAME}:" "$HTPASSWD_FILE"; then
    sed -i.bak "s|^${USERNAME}:.*|${HASH}|" "$HTPASSWD_FILE"
    rm -f "${HTPASSWD_FILE}.bak"
    echo "✅ 帳號「${USERNAME}」已更新。"
  else
    echo "$HASH" >> "$HTPASSWD_FILE"
    echo "✅ 帳號「${USERNAME}」已新增。"
  fi

  cmd_list
  nginx_reload
}

# ── 刪除帳號 ─────────────────────────────────────────────
cmd_del() {
  local USERNAME="${1:-}"
  [[ -z "$USERNAME" ]] && usage

  if [[ ! -f "$HTPASSWD_FILE" ]] || ! grep -q "^${USERNAME}:" "$HTPASSWD_FILE"; then
    echo "❌ 帳號「${USERNAME}」不存在。" >&2; exit 1
  fi

  sed -i.bak "/^${USERNAME}:/d" "$HTPASSWD_FILE"
  rm -f "${HTPASSWD_FILE}.bak"
  echo "🗑️  帳號「${USERNAME}」已刪除。"

  cmd_list
  nginx_reload
}

# ── 主流程 ───────────────────────────────────────────────
COMMAND="$1"; shift

case "$COMMAND" in
  add)  cmd_add  "$@" ;;
  del)  cmd_del  "$@" ;;
  list) cmd_list      ;;
  *)    usage         ;;
esac
