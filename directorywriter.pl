use strict;
use warnings;
use Cwd;

chomp(my $dir = $ARGV[0]); # . here is the input for the current directory                                                                                                          
opendir (DIR, $dir)|| die ("Can not open $dir");
my $name = $ARGV[1];
my $time = $ARGV[2];
my $nodes = $ARGV[3];
my $processors = $ARGV[4];
my $rundir = getcwd();
my $count = 1;
my @list_of_files = readdir(DIR);
my @glob_files = glob ("*.fst.phy");
foreach my $listfile (@glob_files)
{
my $raxml = $name.$count;
my $input = $listfile;

my $outfile = "$raxml.command.pbs";
open (OUT, '>', $outfile) || die ("Can not open $outfile\n");

print OUT
    "\#!/bin/bash                                                                                                                                                                          
\#                                                                                                                                                                                    
\#PBS -N $raxml                                                                                                                                                                    
\#PBS -l walltime=$time,nodes=$nodes:ppn=$processors                                                                                                                                              
\# Where to run this ------------------------------------------------                                                                                                                 
module add apps/RAxML-7.2.8-MPI
export RUNDIR=\"$rundir\"
\# Name of application ---------------------------------------------------                                                                                                            
export APPLICATION=\"/usr/local/apps/RAxML-7.2.8-MPI/RAxML-7.2.8-ALPHA/raxmlHPC-MPI-SSE3\"
\# Any required run flags/input files etc. -------------------------------                                                                                                            
export RUNFLAGS= \"-f a -m PROTGAMMAGTR -p 12345 -x 12345 -d -\# 1000 -s $input -k  -n $raxml.raxml -w $rundir/$raxml\";\n";

print OUT '# Change into the working directory -------------------------------------                                                                                                            
cd $RUNDIR
# No need to change anything below this line -------------------------                                                                                                               
# Generate the list of nodes the code will run on -----------------------                                                                                                            
cat $PBS_NODEFILE
export nodes=`cat $PBS_NODEFILE`
export nnodes=`cat $PBS_NODEFILE | wc -l`
export confile=inf.$PBS_JOBID.conf
for i in $nodes; do
   echo ${i} >>$confile
done
# Execute the code ------------------------------------------------------                                                                                                            
mpirun -q 0 -np $nnodes -machinefile $confile $APPLICATION $RUNFLAGS'
    ;
system ("qsub $outfile");
$count ++;
sleep 10;
}
