# Local Infrastructure

本地開發環境的基礎設施服務，使用 Docker Compose 管理。

## 服務

| 服務 | Port | 說明 |
| ------- | ---- | ---- |
| PostgreSQL | 5432 | 關聯式資料庫 |
| Redis | 6379 | 快取 / 訊息佇列 |
| MinIO | 9000 (API) / 9001 (Console) | S3 相容物件儲存 |
| Ollama | 11434 | 本地與雲端 LLM 推論 |
| Temporal | 7233 | 分散式工作流引擎 |
| Temporal UI | 7234 | Temporal 管理介面 |

## 快速開始

```bash
# 複製環境變數檔案
cp .env.example .env

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
```
