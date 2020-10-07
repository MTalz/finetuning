#!/bin/bash



SPHENO="SPheno_0"

# Initialize random input

gfortran $HOME/finetuning/$SPHENO/randominputgenerator/random.F -o $HOME/finetuning/$SPHENO/randominputgenerator/random.exe
$HOME/finetuning/$SPHENO/randominputgenerator/random.exe

# Read MSSM input

MSSMinput=/home/mtalia/finetuning/$SPHENO/LesHouches.in.MSSM

hscale="1.0E+16"  # Choose input scale 

export hscale

perl -i -pe 's/.*/31 $ENV{hscale}         # fixed GUT scale (-1: dynamical GUT scale) / if $.==93' $MSSMinput

# Start parameter read

count=0

while read -r M1 M2 M3 Mhu Mhd msqii mslii msuii msdii mseii msq33 msl33 msu33 msd33 mse33 Te33 Tu33 Td33 tanb signmu

do count=$[$count+1]
echo "count = " $count

export M1 M2 M3 Mhu Mhd msqii mslii msuii msdii mseii msq33 msl33 msu33 msd33 mse33 Te33 Tu33 Td33 tanb signmu

msq11=$msqii
msq22=$msqii

msl11=$mslii
msl22=$mslii

msu11=$msuii
msu22=$msuii

msd11=$msdii
msd22=$msdii

mse11=$mseii
mse22=$mseii

export msq11 msq22 msl11 msl22 msu11 msu22 msd11 msd22 mse11 mse22

# Write inputs to SLHA file

perl -i -pe 's/.*/1 $ENV{M1}   # MBino / if $.==13' $MSSMinput
perl -i -pe 's/.*/2 $ENV{M2}   # MWino / if $.==14' $MSSMinput
perl -i -pe 's/.*/3 $ENV{M3}   # MGluino / if $.==15' $MSSMinput
perl -i -pe 's/.*/10 $ENV{Mhu} # MHDsq / if $.==22' $MSSMinput
perl -i -pe 's/.*/11 $ENV{Mhd} # MHUsq / if $.==23' $MSSMinput
perl -i -pe 's/.*/25 $ENV{tanb}  # TanBeta / if $.==35' $MSSMinput

perl -i -pe 's/.*/4 $ENV{signmu}  # SignMu / if $.==16' $MSSMinput

perl -i -pe 's/.*/1 1 $ENV{msq11}  # / if $.==37' $MSSMinput
perl -i -pe 's/.*/2 2 $ENV{msq22}  # / if $.==38' $MSSMinput
perl -i -pe 's/.*/3 3 $ENV{msq33}  # / if $.==39' $MSSMinput

perl -i -pe 's/.*/1 1 $ENV{msl11}  # / if $.==41' $MSSMinput
perl -i -pe 's/.*/2 2 $ENV{msl22}  # / if $.==42' $MSSMinput
perl -i -pe 's/.*/3 3 $ENV{msl33}  # / if $.==43' $MSSMinput

perl -i -pe 's/.*/1 1 $ENV{msu11}  # / if $.==45' $MSSMinput
perl -i -pe 's/.*/2 2 $ENV{msu22}  # / if $.==46' $MSSMinput
perl -i -pe 's/.*/3 3 $ENV{msu33}  # / if $.==47' $MSSMinput

perl -i -pe 's/.*/1 1 $ENV{msd11}  # / if $.==49' $MSSMinput
perl -i -pe 's/.*/2 2 $ENV{msd22}  # / if $.==50' $MSSMinput
perl -i -pe 's/.*/3 3 $ENV{msd33}  # / if $.==51' $MSSMinput

perl -i -pe 's/.*/1 1 $ENV{mse11}  # / if $.==53' $MSSMinput
perl -i -pe 's/.*/2 2 $ENV{mse22}  # / if $.==54' $MSSMinput
perl -i -pe 's/.*/3 3 $ENV{mse33}  # / if $.==55' $MSSMinput

perl -i -pe 's/.*/3 3 $ENV{Te33}  # / if $.==72' $MSSMinput
perl -i -pe 's/.*/3 3 $ENV{Tu33}  # / if $.==76' $MSSMinput
perl -i -pe 's/.*/3 3 $ENV{Td33}  # / if $.==80' $MSSMinput

cp $MSSMinput $HOME/finetuning/$SPHENO/SLHA/MSSM_"$count".dat

done < $HOME/finetuning/$SPHENO/randominputgenerator/random_MSSM.dat
