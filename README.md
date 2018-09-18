# speedtest logger

This is a Docker container with the tool
[speedtest-cli](https://github.com/sivel/speedtest-cli) inside, which
uses a crontab to log speedtest results in csv format every 15 minutes.

## installation

Obviously, you need to have Docker installed. Refer to your distribution or
[the Docker docs](https://docs.docker.com/install/) on how to do that.

From within this directory you can use the makefile to build the image and
run it. This requires [make](https://www.gnu.org/software/make/), of course.
Take a look inside the [makefile](makefile) to see what the targets do.

In order to plot the results [gnuplot](http://gnuplot.sourceforge.net) is
required. Alternatively open the `result.csv` with any tabular calculation
program like Microsoft Excel or LibeOffice Calc.

## usage

See help on available makefile targets:

    make help

### build and run the image

Build the Docker image:

    make image

Run the image in the background:

    make run

You can specify an alternative schedule for the speedtests. If you want to
run tests every 5 minutes (default is 15) use:

    make run MINUTES=5

Or specify the [complete schedule](https://crontab.guru/) directly, e.g.
"four times a day":

    make run SCHEDULE="0 */6 * * *"

### export results

Check / export the logs after a while. The results are formatted as CSV and
are output to stdout:

    make logs

When you have collected enough results you can stop the container:

    make stop

Then export the results to `results.csv` and plot them with `gnuplot`:

    make plot
    xdg-open results.png

### cleanup

Afterwards you can remove the container and clean the result files when they
are not needed anymore:

    make remove
    make clean
