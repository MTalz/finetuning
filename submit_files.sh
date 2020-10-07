#!/bin/bash

for folder in {0..50} # Change folder ranges

do

echo "Folder number = " $folder

export folder

echo "deleting old SLHAfiles..."

rm SPheno_"$folder"/SLHAfiles/*

# Submit to cluster for finetuning calcs
qsub -q syd_long SPheno_"$folder"/run_MSSM_rand_"$folder".sh

echo "Submitted!"

done
