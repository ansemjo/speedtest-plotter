FROM alpine:3.8

# install necessary speedtest-cli
RUN apk add --no-cache speedtest-cli

# fix python in PATH
RUN ln -s python3 /usr/bin/python

# install crontab
COPY crontab /etc/cron/crontab
RUN  crontab /etc/cron/crontab

# copy and run init, exec'ing crond
COPY newlog /bin/newlog
RUN chmod +x /bin/newlog
CMD ["/bin/newlog"]
