NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	$(COMPOSE) up --build -d

clean:
	$(COMPOSE) down

fclean: clean
	docker system prune -af
	docker volume prune -f

re: clean all

.PHONY: all clean fclean re