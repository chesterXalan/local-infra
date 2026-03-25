#!/bin/bash
# 開啟或關閉自動續簽 cron job

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CRON_CMD="0 3 * * * cd $PROJECT_DIR && docker compose run --rm certbot renew --quiet && docker compose exec nginx nginx -s reload"

case "$1" in
    on|enable)
        (crontab -l 2>/dev/null | grep -v "certbot renew"; echo "$CRON_CMD") | crontab -
        echo "✅ 自動續簽已開啟（每天凌晨 3 點檢查）"
        ;;
    off|disable)
        crontab -l 2>/dev/null | grep -v "certbot renew" | crontab -
        echo "❌ 自動續簽已關閉"
        ;;
    status)
        if crontab -l 2>/dev/null | grep -q "certbot renew"; then
            echo "✅ 自動續簽：開啟"
            crontab -l | grep "certbot renew"
        else
            echo "❌ 自動續簽：關閉"
        fi
        ;;
    *)
        echo "用法: $0 {on|off|status}"
        exit 1
        ;;
esac
