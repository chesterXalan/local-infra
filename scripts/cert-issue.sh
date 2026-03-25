#!/bin/bash
# 首次簽發或手動重新簽發 wildcard 憑證

set -e
cd "$(dirname "$0")/.."

if [ ! -f certbot/cloudflare.ini ]; then
    echo "錯誤: 請先建立 certbot/cloudflare.ini 並填入 Cloudflare API Token"
    exit 1
fi

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "用法: $0 <domain> <email>"
    exit 1
fi

DOMAIN="$1"
EMAIL="$2"

docker compose run --rm certbot certonly \
    --dns-cloudflare \
    --dns-cloudflare-credentials /etc/cloudflare.ini \
    --dns-cloudflare-propagation-seconds 30 \
    -d "$DOMAIN" \
    -d "*.$DOMAIN" \
    --non-interactive \
    --agree-tos \
    --email "$EMAIL"

echo "憑證簽發完成，reload nginx..."
docker compose exec nginx nginx -s reload
echo "完成！"
