# speedtest logger

This is a Docker container with the tool `speedtest-cli` inside, which
uses a crontab to log speedtest results in csv format every 15 minutes.

## installation

Obviously, you need to have Docker installed. Refer to your distribution or
[the Docker docs](https://docs.docker.com/install/) on how to do that.

From within this directory you can use the makefile to build the image and
run it. This requires [make](https://www.gnu.org/software/make/), of course.
Take a look inside the [makefile](makefile) to see what the targets do.

## usage

See makefile targets:

    make help

Build the image:

    make image

Run the image in the background:

    make run

Check /export the logs after a while. The results are formatted as CSV and
are output to stdout:

    make logs

To transfer the results you should compress and save them to a file. The
uncompressed file can easily be opened with any tabular calculation program
to create graphs, e.g. Microsoft EXCEL or LibreOffice Calc.

    make logs | gzip > my_speedtest_results.csv.gz

Stop the container:

    make stop

You'll need to remove the container manually to prevent you from accidentally
deleting the logs before you exported them.

