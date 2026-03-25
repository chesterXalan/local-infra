#!/bin/bash
# 手動續簽憑證

set -e
cd "$(dirname "$0")/.."

docker compose run --rm certbot renew

echo "reload nginx..."
docker compose exec nginx nginx -s reload
echo "完成！"
