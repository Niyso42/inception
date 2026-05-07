NAME = inception
DATA_PATH = $(HOME)/data
COMPOSE = docker compose -f srcs/docker-compose.yml

all: build
	$(COMPOSE) up --build -d

build:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb

clean:
	$(COMPOSE) down

fclean: clean
	docker system prune -af
	docker volume prune -f
	@$(COMPOSE) down -v --rmi all
	@sudo rm -rf $(DATA_PATH)

re: clean all

.PHONY: all clean fclean re