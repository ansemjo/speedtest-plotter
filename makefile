IMAGE := speedtest
NAME  := speedtest

help:
	# make {image|run|logs|stop}
	#    image   - build docker image
	#  > run     - run docker image in background
	#    logs    - export csv logs up until now
	#    stop    - stop container

run: image
	docker run -d --name $(NAME) $(IMAGE)

stop:
	docker stop $(NAME)

image:
	docker build -t $(IMAGE) .

logs:
	@docker logs $(NAME)
