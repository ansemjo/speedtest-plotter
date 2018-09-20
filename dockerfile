# Copyright (c) 2018 Anton Semjonov
# Licensed under the MIT License

FROM alpine:3.8

# install necessary speedtest-cli
RUN apk add --no-cache speedtest-cli

# create python link in PATH
RUN ln -s python3 /usr/bin/python

# default cron interval
ENV MINUTES=15

# copy and run init, exec'ing crond
COPY speedtests.sh /speedtests.sh
CMD ["/bin/ash", "/speedtests.sh"]
