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
	@echo " image   - build docker image"
	@echo " run     - run docker container in background"
	@echo " direct  - loop speedtest-cli and write to $(RESULTS)"
	@echo " logs    - output csv logs of docker container"
	@echo " stop    - stop container"
	@echo " csv     - export docker logs to $(RESULTS)"
	@echo " plot    - plot $(RESULTS) to $(PLOT)"
	@echo " remove  - remove container"
	@echo " clean   - remove files $(RESULTS) and $(PLOT)"

run:
	docker run -d --name $(NAME) -e SCHEDULE="$(SCHEDULE)" $(IMAGE)

direct:
	speedtest-cli --csv-header | tee $(RESULTS)
	while speedtest-cli --secure --csv | tee -a $(RESULTS) \
		&& sleep $$(( $(MINUTES) * 60 )); do true; done;

stop:
	docker stop $(NAME)

image:
	docker build -t $(IMAGE) .

logs:
	@docker logs $(NAME)

csv: $(RESULTS)
$(RESULTS):
	make --quiet logs > $@

plot: $(PLOT)
$(PLOT): $(RESULTS)
	gnuplot plotscript

remove:
	docker rm -f $(NAME)

clean:
	rm -f $(RESULTS) $(PLOT)
