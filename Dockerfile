# Copyright (c) 2019 Anton Semjonov
# Licensed under the MIT License

FROM python:3-alpine

# install necessary packages and fonts
RUN apk add --no-cache gnuplot ttf-droid

# copy requirements file and install with pip
COPY requirements.txt /requirements.txt
RUN apk add --no-cache --virtual build-deps musl-dev gcc postgresql-dev \
  && apk add --no-cache postgresql-libs \
  && pip install --no-cache-dir -r /requirements.txt \
  && apk del --purge build-deps

# default cron interval
ENV MINUTES="15"

# listening port, set to empty string for no webserver
ENV PORT="8000"

# database uri (sqlalchemy uri)
ENV DATABASE="sqlite:////data/speedtests.db"

# copy entrypoint and scripts
WORKDIR /opt/speedtest-plotter
COPY entrypoint.sh /entrypoint.sh
COPY plotscript speedtest-plotter ./

# start with entrypoint which exec's crond
CMD ["/bin/ash", "/entrypoint.sh"]
