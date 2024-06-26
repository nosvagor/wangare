# ============================================================================
# 👽 vars {{{
define CONFIG
$(shell ./config/parse.sh ./config/config.toml)
endef
$(foreach var,$(CONFIG),$(eval $(var)))
# }}}
# ============================================================================

# 🛳️ Docker {{{
db-pull:
	@docker pull postgres:$(PG_VERSION)

db-run:
	@docker run --name $(DB_DRIVER)-$(DB_NAME) \
			    -e POSTGRES_PASSWORD=$(DB_PASSWORD) \
				-e POSTGRES_USER=$(DB_USER) \
				-p $(DB_PORT):5432 -d postgres:$(PG_VERSION)
db-start:
	@docker start $(DB_DRIVER)-$(DB_NAME)

db-create:
	@docker exec -it $(DB_DRIVER)-$(DB_NAME) createdb --username=$(DB_USER) --owner=$(DB_USER) $(DB_NAME)

db-enter:
	@docker exec -it $(DB_DRIVER)-$(DB_NAME) psql -U $(DB_USER)

db-stop:
	@docker stop $(DB_DRIVER)-$(DB_NAME)

db-rm:
	@docker rm $(DB_DRIVER)-$(DB_NAME)

db-drop:
	@docker exec -it $(DB_DRIVER)-$(DB_NAME) dropdb $(DB_NAME)

db-dump:
	pg_dump -U $(DB_USER) -d $(DB_NAME) -h $(DB_HOST) -p $(DB_PORT) -F t -v -x -O -f "dump.tar"

db-restore:
	pg_restore -U $(DB_USER) -d $(DB_NAME) -h $(DB_HOST) -p $(DB_PORT) -F t -v "dump.tar"

db-creds:
	@echo "DB_DRIVER: $(DB_DRIVER)"
	@echo "DB_NAME: $(DB_NAME)"
	@echo "DB_USER: $(DB_USER)"
	@echo "DB_PASSWORD: $(DB_PASSWORD)"
	@echo "DB_HOST: $(DB_HOST)"
	@echo "DB_PORT: $(DB_PORT)"

.PHONY: db-pull db-run db-start db-create db-enter db-stop db-rm db-drop db-dump db-restore db-creds
# }}}
