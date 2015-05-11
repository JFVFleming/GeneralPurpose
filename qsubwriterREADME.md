# GeneralPurpose
Hallo!

So, script 1 is qsubwriter.pl. Currently optimised to run RAXML, this requires an input first of the directory you want the RAXML output to go into, and then the phylip file you want to run. This is followed by the time you want to run the program, in the format (hours:minutes:seconds), the number of nodes you want to use, and the number of processors you want to use on those nodes.
To run this script for a file called foo.phy, into the directory bar, for seven and a half hours, on two nodes, with seven processors, the format is:

perl qsubwriter.pl bar foo.phy 07:30:00 2 7

It is set up to be easily changeable for any other program, just go in to the script and do the following:
1) Alter the 'module add' line to the program you want to run 
2) change the bit between the speech marks in the 'export RUNFLAGS' line to the command line input of the program you want to run.
3) change the between the speech marks in the 'export APPLICATION' line to the location of the program you want to run (You can find this using module avail to get the big list of modules, loading the module, and then using the which command)

NOTES: THIS SCRIPT ASSUMES THAT IT IS RUNNING IN THE SAME DIRECTORY AS THE INTENDED RUN DIRECTORY.
