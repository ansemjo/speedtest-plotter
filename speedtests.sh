#!/bin/ash

# Copyright (c) 2018 Anton Semjonov
# Licensed under the MIT License

# output file
export RESULTS="${RESULTS:-/results.csv}"

# echo csv header once on first startup
if [ ! -f "$RESULTS" ]; then
  mkdir -p "$(dirname "$RESULTS")"
  speedtest-cli --csv-header | tee "$RESULTS"
fi

# assemble cron schedule from env
# either use '-e MINUTES=n' to run test every n minutes
# or define the complete schedule part with '-e SCHEDULE=...'
export SCHEDULE="${SCHEDULE:-"*/$MINUTES * * * *"}"

# install crontab with schedule from env
echo "$SCHEDULE speedtest-cli --secure --csv" | crontab -

# start crontab for regular tests
crond -f | tee "$RESULTS"
