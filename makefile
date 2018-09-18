# image and container names
IMAGE   := speedtest
NAME    := speedtest

# default
MINUTES := 15
SCHEDULE := */$(MINUTES) * * * *

.PHONY: help run stop image logs results remove clean

run:
	docker run -d --name $(NAME) -e SCHEDULE="$(SCHEDULE)" $(IMAGE)

help:
	@echo "make ..."
	@echo "   image   - build docker image"
	@echo " * run     - run docker container in background"
	@echo "   logs    - output csv logs up until now"
	@echo "   stop    - stop container"
	@echo "   results - export logs to $(RESULTS)"
	@echo "   remove  - remove container"
	@echo "   clean   - remove file $(RESULTS)"

stop:
	docker stop $(NAME)

image:
	docker build -t $(IMAGE) .

logs:
	@docker logs $(NAME)

results: $(RESULTS)
$(RESULTS):
	make --quiet logs > $@

remove:
	docker rm $(NAME)

clean:
	rm -f $(RESULTS)
