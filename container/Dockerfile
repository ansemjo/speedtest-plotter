# Copyright (c) 2019 Anton Semjonov
# Licensed under the MIT License

# Check with hadolint:
# $ docker run --rm -i hadolint/hadolint < Dockerfile

# ---------- build taganaka/SpeedTest binary ----------
FROM alpine:3.16.0 as compiler

# install build framework and libraries
# hadolint ignore=DL3018
RUN apk add --no-cache alpine-sdk cmake curl-dev libxml2-dev

# configure and build binary
WORKDIR /build
RUN git clone https://github.com/taganaka/SpeedTest.git . \
  && cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-Wno-psabi" \
    . \
  && make

# --------- build application container ----------
FROM python:3-alpine

# install necessary packages and fonts
# hadolint ignore=DL3018
RUN apk add --no-cache gnuplot ttf-droid libcurl libxml2 libstdc++ libgcc tini

# copy requirements file and install with pip
COPY requirements.txt /requirements.txt
# hadolint ignore=DL3018
RUN apk add --no-cache --virtual build-deps musl-dev gcc g++ postgresql-dev \
  && apk add --no-cache postgresql-libs \
  && pip install --no-cache-dir -r /requirements.txt \
  && apk del --purge build-deps

# default cron interval
ENV MINUTES="15"

# listening port, set to empty string for no webserver
ENV PORT="8000"

# database uri (sqlalchemy uri)
ENV DATABASE="sqlite:////data/speedtests.db"

# copy built binary from first stage
COPY --from=compiler /build/SpeedTest /usr/local/bin/SpeedTest

# copy entrypoint and scripts
WORKDIR /opt/speedtest-plotter
ENV PATH="/opt/speedtest-plotter:${PATH}"
COPY container/entrypoint.sh /entrypoint.sh
COPY plotscript speedtest-plotter ./

# wrapper script to easy docker exec usage
COPY container/wrapper /usr/local/bin/dump
COPY container/wrapper /usr/local/bin/import
COPY container/wrapper /usr/local/bin/measure

# start with entrypoint which exec's crond
ENTRYPOINT ["/sbin/tini", "-wg", "--", "/bin/ash", "/entrypoint.sh"]
CMD ["cron"]
