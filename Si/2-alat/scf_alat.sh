##!/bin/bash

# This bash script will optimize the lattice constant of cubic crystals scanning from -5% to +5 % of the experimental value 5.4310 Angstrom at a step of 0.005

rm -rf etot.dat stress.dat
for k in {0..20}
  do
    a=`echo "10.263103 *(95.0/100.0+$k*0.005)" | bc -l`
    
#for k in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 
#  do
#    a=`echo "10.263103*(90/100+$k*0.005)" | bc -l`    

cat > scf.in << EOF
&control
    calculation='scf'
    restart_mode='from_scratch'
    pseudo_dir = '../../pseudo/'
    prefix = 'silicon'
    outdir='./silicon/'
    disk_io='none'
    tstress=.true.
    tprnfor=.true.
!    etot_conv_thr=1.0d-04
!    forc_conv_thr=1.0d-03
/
&system
    ibrav=2
!    celldm(1)=5.4310
    celldm(1)=$a
    nat=2
    ntyp=1
    nbnd=8
    ecutwfc=60.0
    occupations='fixed'
/
 &electrons
    conv_thr = 1.0d-8
    mixing_beta = 0.2
/
ATOMIC_SPECIES
  Si  28.085  Si.pbe-n-kjpaw_psl.1.0.0.UPF
  
ATOMIC_POSITIONS {crystal}
  Si  0.00    0.00  0.00
  Si  0.25    0.25  0.25
  
K_POINTS {automatic}
6 6 6 1 1 1
EOF
# mpirun -np 4 pw.x -nk 1 -npw 4 -inp scf.in > scf.out
mpirun -np 4 pw.x < scf.in > scf.out

totenergy=`grep ! scf.out | tail -1 | awk '{print $5}'`
#ft=`grep 'l fo' scf.out|awk '{print $4}'`
sxx=`grep -A1 'l   s' scf.out|tail -1|awk '{print $4}'`
echo "$a  $sxx" >> stress.dat
echo "$a $totenergy" >> alat_optimization.dat
#echo "$alat  $ft" >> force.dat
mv scf.in scf$k.in
mv scf.out scf$k.out
done

