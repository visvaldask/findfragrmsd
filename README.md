findfragrmsd<br />
calculates RMSD between the docked ligand and some reference fragment/scaffold. The fragment is only a subset of the ligand.

A more detailed description:
v0.1
a very clunky way (but it works) to superpose  
docked ligand onto reference fragment/scaffold

Prerequisites:<br />
1. DockRMSD in the path (https://zhanggroup.org//DockRMSD/)<br />
2. openbabel in the path<br />
3. RDKit installed

Notes:<br />
1. change the command<br /> 
system("/Users/visvaldas/miniconda3/bin/python3 $pyfile > tmp111");<br />
to run rdkit python script to your system's setting<br />
2. enclose  smiles/smarts in "" to use in -s option<br /> 
3. -r reference should contail ONLY the fragment/scaffold, and only in mol2 format

To make it less clunky all should be re-written in python. Also, isn't "-s" option and fragment's mol2 in "-r" sort of a repeat? I left it as it is, need to think if I could get rid of one of them safely.
