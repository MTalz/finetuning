#!/bin/bash

Lambda=16  # Change input scale as log10(Lambda)

for folder in {0..50} # change folder range

do

echo "Folder number = " $folder

export folder

# Seed random numbers for parameter set in file

echo "Edit file..."

for num in {1..20}

do

eval "seed$num=$(expr $[$RANDOM] % 40 + 1)"

done

# Ranges given in paper

echo "seed = " $seed1 $seed2 $seed3 $seed4 $seed5 $seed6 $seed7 $seed8 $seed9 $seed10 $seed11 $seed12 $seed13 $seed14 $seed15 $seed16 $seed17 $seed18 $seed19 $seed20

export Lambda seed1 seed2 seed3 seed4 seed5 seed6 seed7 seed8 seed9 seed10 seed11 seed12 seed13 seed14 seed15 seed16 seed17 seed18 seed19 seed20

perl -i -pe 's/.*/        N=50000/ if $.==14' SPheno_"$folder"/randominputgenerator/random.F

perl -i -pe 's/.*/        M1 = -6000*array($ENV{seed20})+3000/ if $.==22' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        M2 = -6000*array($ENV{seed19})+3000/ if $.==23' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        M3 = 3000*array($ENV{seed18})/ if $.==24' SPheno_"$folder"/randominputgenerator/random.F

perl -i -pe 's/.*/        Mhd = -2*(3000**2)*array($ENV{seed17})+(3000**2)/ if $.==25' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        Mhu = -2*(3000**2)*array($ENV{seed16})+(3000**2)/ if $.==26' SPheno_"$folder"/randominputgenerator/random.F

perl -i -pe 's/.*/        msqii = (3000**2)*array($ENV{seed15})/ if $.==27' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        mslii = (3000**2)*array($ENV{seed14})/ if $.==28' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        msuii = (3000**2)*array($ENV{seed13})/ if $.==29' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        msdii = (3000**2)*array($ENV{seed12})/ if $.==30' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        mseii = (3000**2)*array($ENV{seed11})/ if $.==31' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        msq33 = (3000**2)*array($ENV{seed10})/ if $.==32' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        msl33 = (3000**2)*array($ENV{seed9})/ if $.==33' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        msu33 = (3000**2)*array($ENV{seed8})/ if $.==34' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        msd33 = (3000**2)*array($ENV{seed7})/ if $.==35' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        mse33 = (3000**2)*array($ENV{seed6})/ if $.==36' SPheno_"$folder"/randominputgenerator/random.F

perl -i -pe 's/.*/        Te33 = -6000*array($ENV{seed5})+3000/ if $.==37' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        Tu33 = -6000*array($ENV{seed4})+3000/ if $.==38' SPheno_"$folder"/randominputgenerator/random.F
perl -i -pe 's/.*/        Td33 = -6000*array($ENV{seed3})+3000/ if $.==39' SPheno_"$folder"/randominputgenerator/random.F

perl -i -pe 's/.*/        mu = -2*array($ENV{seed2}) + 1/ if $.==41' SPheno_"$folder"/randominputgenerator/random.F

perl -i -pe 's/.*/        tanb = 49*array($ENV{seed1}) + 1/ if $.==40' SPheno_"$folder"/randominputgenerator/random.F

perl -i -pe 's/.*/hscale="1.0E+$ENV{Lambda}"  # Choose input scale / if $.==16' SPheno_"$folder"/generate_MSSM_rand_"$folder".sh # Change High-scale
perl -i -pe 's/.*/for count in {0..50000}    / if $.==14' SPheno_"$folder"/run_MSSM_rand_"$folder".sh # Change Number to scan

echo "removing SLHA..."

rm -r SPheno_"$folder"/SLHA/

mkdir SPheno_"$folder"/SLHA

# Submit SLHA file generation to cluster
qsub -q syd_long SPheno_"$folder"/generate_MSSM_rand_"$folder".sh 

done
