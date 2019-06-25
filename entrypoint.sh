#!/bin/ash

# Copyright (c) 2019 Anton Semjonov
# Licensed under the MIT License

# if DATABASE is an SQlite uri, create base directory
if [[ ${DATABASE%%://*} == sqlite ]]; then
  mkdir -pv "$(dirname "${DATABASE##*:///}")"
fi

# assemble cron schedule from env
# either use '-e MINUTES=n' to run test every n minutes
# or define the complete schedule part with '-e SCHEDULE=...'
export SCHEDULE="${SCHEDULE:-"*/${MINUTES:-15} * * * *"}"

# install crontab with schedule from env
echo "$SCHEDULE /opt/speedtest-plotter/speedtest-plotter measure" | crontab -

# run server in background
(cd /opt/speedtest-plotter/ && ./speedtest-plotter serve) &

# start crontab for regular tests
crond -f
