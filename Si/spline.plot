# This gnuplot script will generate a table of total energy vs
# lattice constant from the data calculated by alat.sh script
# It uses the cubic spline fitting method available in gnuplot.

set sample 501
set format y '%18.10f'
set format x '%10.5f'
set table 'fit.dat'
plot 'alat_optimization.dat' smooth cspline noti
unset table
