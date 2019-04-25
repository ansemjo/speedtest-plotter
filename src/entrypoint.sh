#!/bin/ash

# Copyright (c) 2019 Anton Semjonov
# Licensed under the MIT License

# $RESULTS = results output directory
export RESULTS="${RESULTS:-/results}"
mkdir -p "$RESULTS"

# start livereload server in background
livereload --wait 5 --host "0.0.0.0" --port "$LISTEN" "$RESULTS" >/dev/null &

# assemble cron schedule from env
# either use '-e MINUTES=n' to run test every n minutes
# or define the complete schedule part with '-e SCHEDULE=...'
export SCHEDULE="${SCHEDULE:-"*/${MINUTES:-15} * * * *"}"

# install crontab with schedule from env
echo "$SCHEDULE /bin/sh /scripts/speedtest.sh" | crontab -

# start crontab for regular tests
crond -f
