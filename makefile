IMAGE   := speedtest
NAME    := speedtest
RESULTS := results.csv

.PHONY: help run stop image logs results clean

run: image
	docker run -d --name $(NAME) $(IMAGE)

help:
	@echo "make ..."
	@echo "   image   - build docker image"
	@echo " * run     - run docker container in background"
	@echo "   logs    - output csv logs up until now"
	@echo "   stop    - stop container"
	@echo "   results - export logs to $(RESULTS)"
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

clean:
	rm -f $(RESULTS)
