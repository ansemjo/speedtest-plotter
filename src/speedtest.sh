#!/bin/ash

# Copyright (c) 2019 Anton Semjonov
# Licensed under the MIT License

# $RESULTS = results output directory
export RESULTS="${RESULTS:-/results}"
mkdir -p "$RESULTS"
cd "$RESULTS"

# echo csv header once upon creating file
if [ ! -f "results.csv" ]; then
  speedtest-cli --csv-header | tee "results.csv"
fi

# perform speedtest and output results as csv
speedtest-cli --csv | tee -a "results.csv"

# plot results as image for more than 4 measurements
if [ "$(wc -l < results.csv)" -gt 4 ]; then
  gnuplot < plotscript
fi
