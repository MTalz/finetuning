#!/bin/bash

# ROOT environment variables
setupSW --quiet
lsetup 'gcc gcc484_x86_64_slc6' --quiet

for folder in {0..50} # Edit folder range
do

export folder

# Generate folders

echo "copy folder..."

cp -r SPheno SPheno_"$folder"

# Copy MSSM SLHA files

echo "edit files..."

mv SPheno_"$folder"/generate_MSSM_rand.sh SPheno_"$folder"/generate_MSSM_rand_"$folder".sh
mv SPheno_"$folder"/run_MSSM_rand.sh SPheno_"$folder"/run_MSSM_rand_"$folder".sh

perl -i -pe 's/.*/#PBS -o \/dev\/null / if $.==2' SPheno_"$folder"/generate_MSSM_rand_"$folder".sh
perl -i -pe 's/.*/#PBS -e \/dev\/null / if $.==3' SPheno_"$folder"/generate_MSSM_rand_"$folder".sh

perl -i -pe 's/.*/#PBS -o \/dev\/null / if $.==2' SPheno_"$folder"/run_MSSM_rand_"$folder".sh
perl -i -pe 's/.*/#PBS -e \/dev\/null / if $.==3' SPheno_"$folder"/run_MSSM_rand_"$folder".sh

perl -i -pe 's/.*/SPHENO="SPheno_$ENV{folder}"/ if $.==5' SPheno_"$folder"/generate_MSSM_rand_"$folder".sh
perl -i -pe 's/.*/SPHENO="SPheno_$ENV{folder}"/ if $.==8' SPheno_"$folder"/run_MSSM_rand_"$folder".sh

perl -i -pe 's/.*/     +    "SPheno_$ENV{folder}\/randominputgenerator\/random_MSSM.dat")/ if $.==12' SPheno_"$folder"/randominputgenerator/random.F


# Compile SPheno program

echo "recompile SPheno..."

cd /home/mtalia/finetuning/SPheno_"$folder"/MSSM

make

cd /home/mtalia/finetuning/

echo "done!"

done

