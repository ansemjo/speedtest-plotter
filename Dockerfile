# Copyright (c) 2018 Anton Semjonov
# Licensed under the MIT License

FROM alpine:latest

# install necessary packages
RUN apk add --no-cache python3 gnuplot \
  && pip3 install --no-cache-dir livereload speedtest-cli

# default cron interval
ENV MINUTES=15

# listening port
ENV LISTEN=8000

# output directory
ENV RESULTS=/results

# copy entrypoint, run scripts and index.html
COPY src/* /scripts/
COPY plotscript $RESULTS/
COPY index.html $RESULTS/

# start with entrypoint which exec's crond
CMD ["/bin/sh", "/scripts/entrypoint.sh"]
