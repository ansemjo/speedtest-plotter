gnuplot << PLOT
set title "Speedtest Results"
set xlabel "Time"
set xdata time
set ylabel "Measured Speed"
set ytics format "%.2s %cBit/s" nomirror
set yrange [0:*]
set linetype 1 lw 2 lc rgb "royalblue"
set linetype 2 lw 2 lc rgb "orange"
set y2label "Ping"
set y2tics format "%.0f ms" nomirror
set grid
set timefmt "%Y-%m-%dT%H:%M:%S.*Z"
set datafile separator ","
set terminal png size 1280, 800
set output "results.png"
plot for [col=7:8] "results.csv" using 4:col title col sm acspl, \
  '' using 4:6 title col axes x1y2 w points
PLOT
