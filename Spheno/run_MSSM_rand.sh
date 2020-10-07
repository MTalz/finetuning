#!/bin/bash



setupSW --quiet
lsetup 'gcc gcc484_x86_64_slc6' --quiet

SPHENO="SPheno_0"

cd /home/mtalia/finetuning/$SPHENO

pwd

for count in {0..50000}

do
echo "count = " $count

MSSMinput=/home/mtalia/finetuning/$SPHENO/SLHA/MSSM_"$count".dat

echo "Starting 1st executable..."

run="$(timeout 1s $HOME/finetuning/$SPHENO/bin/SPhenoMSSM $MSSMinput)"

if [ -z "$run" ]
then

echo "UNSUCCESSFUL"

else

echo "SUCCESSFUL"

echo "Starting 2nd executable..."

timeout 60s $HOME/finetuning/$SPHENO/bin/SPhenoMSSM $MSSMinput

# Save output

cp /home/mtalia/finetuning/$SPHENO/SPheno.spc.MSSM $HOME/finetuning/$SPHENO/SLHAfiles/MSSMSpectrum_"$count".dat

fi

rm /home/mtalia/finetuning/$SPHENO/SPheno.spc.MSSM

done
