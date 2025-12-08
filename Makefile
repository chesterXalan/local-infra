# `=`  延遲賦值，不可覆蓋
# `:=` 立即賦值，不可覆蓋
# `?=` 有預設值，可覆蓋
BOLD = \033[1m     # 粗體
GREEN = \033[0;32m # 綠色
NC = \033[0m       # 無色

# ==================== Pre-commit ====================
# 安裝 pre-commit hooks
install:
	uv sync
	uv run pre-commit install
	@echo "$(GREEN)$(BOLD)✅ Pre-commit hooks installed!$(NC)"

# 更新 pre-commit hooks
update:
	uv run pre-commit autoupdate
	@echo "$(GREEN)$(BOLD)✅ Pre-commit hooks updated!$(NC)"

# 執行所有檢查
check:
	uv run pre-commit run --all-files

# push commit without pre-push but run pre-commit
push:
	uv run pre-commit run --all-files
	git push --no-verify

# ==================== Docker Compose ====================
up:
	docker compose up -d
	@echo "$(GREEN)$(BOLD)✅ All services started!$(NC)"

down:
	docker compose down
	@echo "$(GREEN)$(BOLD)✅ All services stopped!$(NC)"

restart:
	docker compose restart
	@echo "$(GREEN)$(BOLD)✅ All services restarted!$(NC)"

ps:
	docker compose ps

logs:
	docker compose logs -f

# 啟動單一服務
# 使用方式: make up-service SERVICE=postgres
up-service:
	docker compose up -d $(SERVICE)
	@echo "$(GREEN)$(BOLD)✅ $(SERVICE) started!$(NC)"

# 重啟單一服務
restart-service:
	docker compose restart $(SERVICE)
	@echo "$(GREEN)$(BOLD)✅ $(SERVICE) restarted!$(NC)"

# 查看單一服務 logs
logs-service:
	docker compose logs -f $(SERVICE)

# ==================== Ollama ====================
# 拉取常用模型
ollama-pull:
	docker exec -it local-ollama ollama pull $(MODEL)

ollama-list:
	docker exec -it local-ollama ollama list

# ==================== Help ====================
help:
	@echo "$(BOLD)Pre-commit:$(NC)"
	@echo "  install        - Install pre-commit hooks"
	@echo "  update         - Update pre-commit hooks"
	@echo "  check          - Run all pre-commit checks"
	@echo "  push           - Run pre-commit and push to remote"
	@echo ""
	@echo "$(BOLD)Docker Compose:$(NC)"
	@echo "  up             - Start all services"
	@echo "  down           - Stop all services"
	@echo "  restart        - Restart all services"
	@echo "  ps             - Show running services"
	@echo "  logs           - Follow logs of all services"
	@echo "  up-service     - Start a single service (SERVICE=xxx)"
	@echo "  restart-service- Restart a single service (SERVICE=xxx)"
	@echo "  logs-service   - Follow logs of a single service (SERVICE=xxx)"
	@echo ""
	@echo "$(BOLD)Ollama:$(NC)"
	@echo "  ollama-pull    - Pull a model (MODEL=xxx)"
	@echo "  ollama-list    - List installed models"
