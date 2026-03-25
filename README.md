# Local Infrastructure

本地開發環境的基礎設施服務，使用 Docker Compose 管理。

## 服務

| 服務        | 版本       | Port                         | 說明              | Compose 檔案    |
| ----------- | ---------- | ---------------------------- | ----------------- | --------------- |
| PostgreSQL  | 17.7       | 5432                         | 關聯式資料庫      | `datastore`     |
| Redis       | 8.4.0      | 6379                         | 快取 / 訊息佇列   | `datastore`     |
| MinIO       | 2025-04-22 | 9000 (API) / 9001 (Console)  | S3 相容物件儲存   | `datastore`     |
| Ollama      | 0.16.2     | 11434                        | 本地 LLM 推論     | `ollama`        |
| Temporal    | 1.29.1     | 7233                         | 分散式工作流引擎  | `temporal`      |
| Temporal UI | 2.44.0     | 7234                         | Temporal 管理介面 | `temporal`      |
| etcd        | 3.5.25     | -                            | Milvus 分散式協調 | `milvus`        |
| Milvus      | 2.6.11     | 19530 (gRPC) / 9095 (Health) | 向量資料庫        | `milvus`        |
| Attu        | 2.6        | 8088                         | Milvus 管理介面   | `milvus`        |
| Meilisearch | 1.12       | 7700                         | 全文搜尋引擎      | `meilisearch`   |
| Nginx       | alpine     | 80 / 443                     | 反向代理 + SSL   | `nginx`         |
| Certbot     | dns-cf     | -                            | Let's Encrypt 憑證 | `nginx`       |
| OTEL-LGTM   | 0.19.1     | 4000 (Grafana) / 4317 (gRPC) / 4318 (HTTP) | 遙測觀測平台 | `observability` |

## 快速開始

```bash
# 複製環境變數與設定檔
cp .env.example .env
cp config/milvus.example.yaml config/milvus.yaml
cp config/nginx/examples/ssl.conf config/nginx/snippets/ssl.conf           # 修改 DOMAIN
cp certbot/cloudflare.example.ini certbot/cloudflare.ini                  # 填入 API Token

# 安裝 pre-commit hooks
make install

# 啟動所有服務
make up

# 查看狀態
make ps
```

## 常用指令

```bash
make up              # 啟動全部服務
make down            # 停止全部服務
make restart         # 重啟全部服務
make logs            # 追蹤 logs

# 單一服務操作
make up-service SERVICE=postgres
make logs-service SERVICE=redis

# Ollama 模型管理
make ollama-pull MODEL=gpt-oss:20b
make ollama-list

# Nginx / 憑證管理
make cert-issue DOMAIN=example.com EMAIL=admin@example.com  # 簽發 wildcard 憑證
make cert-renew                      # 手動續簽
make nginx-reload                    # 測試並重載設定
./scripts/auto-renew.sh on           # 開啟自動續簽 cron
```

## 連線資訊

```bash
# PostgreSQL
psql -h localhost -U postgres -d postgres

# Redis
redis-cli -a password

# MinIO Console
http://localhost:9001

# Ollama API
curl http://localhost:11434/api/tags

# Temporal UI
http://localhost:7234

# Temporal CLI
temporal workflow list

# Milvus (pymilvus)
from pymilvus import connections
connections.connect(host="localhost", port="19530")

# Attu (Milvus UI)
http://localhost:8088

# Meilisearch
curl http://localhost:7700/health

# Meilisearch UI
http://localhost:7700

# Grafana (OTEL-LGTM)
http://localhost:4000

# OTLP Endpoint (gRPC)
# OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317

# OTLP Endpoint (HTTP)
# OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
```
