findfragrmsd
calculates RMSD between the docked ligand and some fragment/scaffold. The fragment is only a part of ligand.

A more detailed description:
v0.1
a very clunky way (but it works) to superpose  
docked ligand onto reference fragment/scaffold
Prerequisites: DockRMSD in the path (https://zhanggroup.org//DockRMSD/)
openbabel in the path
RDKit installed
Notes: 1. change the command 
system("/Users/visvaldas/miniconda3/bin/python3 $pyfile > tmp111");
to run rdkit python script to your system's setting
2. use "" to enter smiles/smarts as the -s option
3. -r reference should contail ONLY the fragment/scaffold, and only in mol2 format

To make it less clunky all should be re-written in python
