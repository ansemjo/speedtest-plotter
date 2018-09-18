# image and container names
IMAGE   := ansemjo/speedtest
NAME    := speedtest

# output files
RESULTS := results.csv
PLOT    := results.png

# default test schedule
MINUTES := 15
SCHEDULE := */$(MINUTES) * * * *

.PHONY: help run stop image logs results plot remove clean

help:
	@echo "make ..."
	@echo "   image   - build docker image"
	@echo " * run     - run docker container in background"
	@echo "   logs    - output csv logs up until now"
	@echo "   stop    - stop container"
	@echo "   results - export logs to $(RESULTS)"
	@echo "   plot    - plot results to $(PLOT)"
	@echo "   remove  - remove container"
	@echo "   clean   - remove file $(RESULTS)"

run:
	docker run -d --name $(NAME) -e SCHEDULE="$(SCHEDULE)" $(IMAGE)

stop:
	docker stop $(NAME)

image:
	docker build -t $(IMAGE) .

logs:
	@docker logs $(NAME)

results: $(RESULTS)
$(RESULTS):
	make --quiet logs > $@

plot: $(PLOT)
$(PLOT): $(RESULTS)
	gnuplot plotscript

remove:
	docker rm -f $(NAME)

clean:
	rm -f $(RESULTS) $(PLOT)
