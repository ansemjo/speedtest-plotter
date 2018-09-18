#!/bin/ash

# echo csv header once on startup
speedtest-cli --csv-header

# assemble cron schedule from env
# either use '-e MINUTES=n' to run test every n minutes
# or define the complete schedule part with '-e SCHEDULE=...'
export SCHEDULE="${SCHEDULE:-"*/$MINUTES * * * *"}"

# install crontab with schedule from env
echo "$SCHEDULE speedtest-cli --secure --csv" | crontab -

# exec crontab for regular tests
exec crond -f
