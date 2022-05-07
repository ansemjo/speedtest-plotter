# speedtest-plotter

This is a collection of scripts, which takes internet speedtest measurements
against the speedtest.net network with [taganaka/SpeedTest](https://github.com/taganaka/SpeedTest) and plots them
with [gnuplot](http://gnuplot.sourceforge.net). A crontab schedule is used
to automate measurements every couple of minutes and save them to a database.
The results can be displayed through a simple Flask webserver.

![example plot of speedtest results](assets/example.png)

## USAGE

For changes between releases check the [changelog](CHANGELOG.md).

### CONTAINER

<a href="https://github.com/ansemjo/speedtest-plotter/actions">

![GitHub Workflow Status](https://github.com/ansemjo/speedtest-plotter/actions/workflows/release.yml/badge.svg)

</a>

The main distribution method is the automatically built container at
[ansemjo/speedtest](https://hub.docker.com/r/ansemjo/speedtest) or
[ghcr.io/ansemjo/speedtest](https://github.com/ansemjo/speedtest-plotter/pkgs/container/speedtest).
Obviously, you need to have a container runtime like `docker` or `podman`
installed to run the container.

To start the container with default settings run:

    docker run -d -p 8000:8000 ansemjo/speedtest

This will take a measurement every 15 minutes, save them to a SQLite database
in `/data/speedtests.db` and run the webserver on port `8000`. Visit http://localhost:8000
to look at the plotted results. (*Note: The smoothed bezier curves require at least two
measurements and the image will stay blank otherwise. So you might have to wait a while first.*)

#### TIMEZONE

Your local timezone can be set with the `TZ` environment variable and a string from
`tzselect`. If none is set usually UTC is assumed. For example users in Japan should use:

    docker run -d -p 8000:8000 -e TZ=Asia/Tokyo ansemjo/speedtest

#### DATABASE

For data persistence, either mount a volume at `/data` to save the database file
or set the environment variable `DATABASE` to an SQLAlchemy-compatible URI. A PostgreSQL
URI might look like this:

    docker run -d \
      -p 8000:8000 \
      -e TZ=Europe/Berlin \
      -e DATABASE=postgresql://user:password@hostname:5432/database' \
      ansemjo/speedtest

#### SCHEDULE

You can modify the measurement schedule with the environment variables `MINUTES` and
`SCHEDULE`. The former takes a measurement every `n` minutes and the latter may define
an entirely custom cron schedule like "four times a day":

    docker run -d -p 8000:8000 -e SCHEDULE="0 3,9,15,21 * * *" ansemjo/speedtest

#### MARKERS AND SCALING

To add horizontal dashed lines in the plot (e.g. to mark your expected bandwidths)
you can use environment variables `MARKER_DOWNLOAD` and `MARKER_UPLOAD`. The values
are given in `MBit/s`. 

In addition or independently from that you can also set a range scaling for the upload
plot relative to the download range with `UPLOAD_SCALE`. For highly asymmetrical connections
this makes it easier to see the upload bandwidth. For example, the above example
picture was created with:

    docker run -d \
      [...] \
      -e MARKER_DOWNLOAD=800 \
      -e MARKER_UPLOAD=40 \
      -e UPLOAD_SCALE=10 \
      ansemjo/speedtest

#### DEFAULT FETCH LIMIT

By default, the webserver will fetch the last seven days (`7d`) for plotting. This can be configured
with the `limit=` query parameter per request and then bookmark this URL; i.e.
`http://localhost:8000/?limit=30d` will fetch the last 30 days. Alternatively, you can set the
environment variable `FETCH_LIMIT` to configure a different default value for all requests
without the query parameter above.

#### FONT AND RESOLUTION

The resolution and font of the SVG output can be configured with environment variables `RESOLUTION` and `FONT` respectively. Output resolution is expected as a comma-separated value of x- and y-size; the default is `1280,800`. The font can take either only a name (`Arial`), only a size (`,18`) or both (`Arial, 18`). Note that for a font in an SVG to work, the client needs to have the font, *not* the server. For example:

    docker run -d \
      [...] \
      -e RESOLUTION=1920,1080 \
      -e FONT="Fira Sans, 14" \
      ansemjo/speedtest

#### SPECIFIC TESTSERVER

If you want to test against a specific server, you can give a `host:port` combination
in the environment variable `TESTSERVER`. You can use the API at
[www.speedtest.net/api/js/servers](https://www.speedtest.net/api/js/servers?&limit=10&search=)
to pick a suitable `host` key from the JSON; supply a parameter for `?search=...` if you need to.
By default it lists servers close to you. **Note** that this is *different* from the
`SERVERID` used previously! But you can use `?id=...` to search for a specific ID.

For example, to test against wilhelm.tel in Norderstedt with the server ID 4087, you'd use:

    docker run -d \
      [...] \
      -e TESTSERVER=speedtest.wtnet.de:8080 \
      ansemjo/speedtest

#### DISABLE WEBSERVER

The webserver is a single-threaded Flask application and pipes the data to gnuplot in a subprocess, which may not be suitable
for production usage. To disable the webserver completely set the `PORT` environment
variable to an empty string. This will only take measurements and save them to the
database.

    docker run -d -e PORT="" -v speedtests:/data ansemjo/speedtest

#### SHORTHAND COMMANDS

To dump the results as CSV from a running container use the `dump` command:

    docker exec $containerid dump > results.csv

To trigger a measurement manually use the `measure` command:

    docker exec $containerid measure

To reimport a previous dump in a fresh container use `import`:

    docker exec -i $containerid import < results.csv

This can also be used to import results obtained manually with `speedtest-cli`.

### PYTHON SCRIPT

You can use the Python script by itself locally, too. First install the requirements:

    pip install -r requirements.txt

Choose a database location and take any number of measurements:

    ./speedtest-plotter -d sqlite:///$PWD/measurements.db measure
    ...

Then start the flask webserver to look at the results:

    TZ=Europe/Berlin ./speedtest-plotter -d sqlite:///$PWD/measurements.db serve

### GNUPLOT SCRIPT

To keep things really simple, you can also take measurements manually with `speedtest-cli` and only
plot an image with `gnuplot`.

The [`plotscript`](plotscript) expects the format that `speedtest-cli` outputs when using the `--csv` flag
and a header line from `--csv-header`. To take some measurements manually with a simple sleep-loop:

    speedtest-cli --csv-header > results.csv
    while true; do speedtest-cli --csv | tee -a results.csv; sleep 600; done
    ^C

Afterwards plot the results to an SVG picture with:

    gnuplot -c plotscript results.csv plot.svg

## LICENSE

Copyright (c) 2019 Anton Semjonov
Licensed under the MIT License
