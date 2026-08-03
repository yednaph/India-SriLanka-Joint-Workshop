# This gnuplot script will plot the total energy vs attice constant for the data generated from alat.sh script.

# set terminal type
set term postscript enhanced color 'Helvetica-Bold,16'
set output 'a0.ps'
 xmin=10.1
 xmax=10.55
 ymin=-93.454
 ymax=-93.450
 set xr [xmin : xmax]
 set yr [ymin : ymax]
set xl 'alat (Bohr)'
set yl 'Total energy (Ry)'
set format y '%9.4f'
set key top center
# defining line styles
set style line 1 lt 1 lw 3 pt 6 ps 2 lc rgb 'blue'
set style line 2 lt 1 lw 2 pt 6 ps 2 lc rgb 'black'

plot 'alat_optimization.dat' u 1:2 w p ti 'data points' ls 1,\
 'fit.dat' u 1:2 w l ti 'cspline fit' ls 2
set output
! ps2pdf a0.ps
! rm a0.ps
