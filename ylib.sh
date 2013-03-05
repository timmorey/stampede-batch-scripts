#!/bin/bash

##
# ylib.sh - Created by Timothy Morey on 3/4/2013
#

#SBATCH -J ylib
#SBATCH -o o.ylib.%j
#SBATCH -N 32 -n 512
#SBATCH -p normal
#SBATCH -t 00:30:00
#SBATCH --mail-user=timmorey@gmail.com
#SBATCH --mail-type=ALL

EXECDIR=$WORK/sandbox/pncwrite
IBRUN_OPTS="tacc_affinity"
OUTDIR=$SCRATCH/output-c32-s1M/$SLURM_JOB_NAME.$SLURM_JOB_ID

mkdir $OUTDIR
cd $OUTDIR

for i in 1 2 3 4 5
do

	echo "==========="
	echo "=== Default"
	echo "==========="
	/usr/bin/time -p ibrun $IBRUN_OPTS $EXECDIR/pncwrite-default
	rm $OUTDIR/output.nc
	sleep 10

	echo "==========="
	echo "=== Ylib-1 "
	echo "==========="
	/usr/bin/time -p ibrun $IBRUN_OPTS $EXECDIR/pncwrite-ylib1
	rm $OUTDIR/output.nc
	sleep 10

done

rm -rf $OUTDIR

