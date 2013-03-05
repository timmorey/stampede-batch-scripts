#!/bin/bash

##
# a10km.sh - Created by Timothy Morey on 2/6/2013
#
# This batch script performs an A10km PISM run on stampede.  The run is based
# on the first control run provided in PISM's 
#   examples/searise-antarctica/experiments.sh.

#SBATCH -J a10km
#SBATCH -o o.a10km.%j
#SBATCH -N 4 -n 64
#SBATCH -p development
#SBATCH -t 01:00:00
#SBATCH --mail-user=timmorey@gmail.com
#SBATCH --mail-type=ALL

INDIR=$SCRATCH/input-c16-s1M
OUTDIR=$SCRATCH/output-c16-s1M/$SLURM_JOB_NAME.$SLURM_JOB_ID

PISM="$WORK/software/pism-dev/build/pismr"
IBRUN_OPTS="tacc_affinity"
CONFIG="-config $WORK/software/pism-dev/build/pism_config.nc"
SKIP="-skip 10"
SIA_ENHANCEMENT="-e 5.6"
PIKPHYS_COUPLING="-atmosphere pik -ocean pik -meltfactor_pik 1.5e-2"
PIKPHYS="-ssa_method fd -e_ssa 0.6 -pik -eigen_calving 2.0e18 -calving_at_thickness 50.0"
FULLPHYS="-ssa_sliding -thk_eff -pseudo_plastic_q 0.25 -plastic_pwfrac 0.97 -topg_to_phi 5.0,20.0,-300.0,700."
PISM_OPTS="$CONFIG $SKIP $SIA_ENHANCEMENT $PIKPHYS_COUPLING $PIKPHYS $FULLPHYS -y 0"

mkdir $OUTDIR

for i in 1 2 3
do

	/usr/bin/time -p ibrun $IBRUN_OPTS $PISM $PISM_OPTS \
                -i $INDIR/a10km.cdf1.nc \
                -o_format hdf5 -o $OUTDIR/a10km.$i.h5 \
                -log_summary

	/usr/bin/time -p ibrun $IBRUN_OPTS $PISM $PISM_OPTS \
                -i $INDIR/a10km.cdf1.nc \
                -o_format netcdf4_parallel -o $OUTDIR/a10km.$i.hdf5.nc \
                -log_summary

	/usr/bin/time -p ibrun $IBRUN_OPTS $PISM $PISM_OPTS \
		-i $INDIR/a10km.cdf1.nc \
		-o_format pnetcdf -o $OUTDIR/a10km.$i.cdf5.nc \
		-log_summary

done

#rm -rf $OUTDIR

