#!/usr/bin/perl -w
# v0.1
# very clunky way (but it works) to superpose  
# docked ligand onto reference fragment/scaffold
# Prerequisites: DockRMSD in the path (https://zhanggroup.org//DockRMSD/)
# openbabel in the path
# RDKit installed
# notes: 1. change the command 
# system("/Users/visvaldas/miniconda3/bin/python3 $pyfile > tmp111");
# to run rdkit python script to your system's setting
# 2. use "" to enter smiles/smarts as the -s option
# 3. -r reference should contail ONLY the fragment/scaffold, and only in mol2 format
#
# To make it less clunky all should be re-written in python
use strict;
use warnings;
use Getopt::Std;

#if (@ARGV ne 2 ) {
#	die "Usage: $0 protfile.pdb  cnafile.pdb\n";
#}


die "Usage: $0 -l docked.pdbqt -r fragment.mol2 -s smiles/smarts\n" if (@ARGV==0);


my %options=();
getopts("r:l:s:",\%options);
my $ref=$options{r};
my $ligf=$options{l};
my $smiles=$options{s};
#(my $root = $flexf) =~ s/\..*$//; #remove extension
(my $root = $ligf) =~ s/(.+)\.[^.]+$/$1/; #remove extension
(my $rootp = $ref) =~ s/(.+)\.[^.]+$/$1/; #remove extension
my $outfile="$rootp" . "_" . "$root" . "_rmsd.txt";
die "no such file $ref" unless (-e $ref);
die "no such file $ligf" unless (-e $ligf);
#my $smiles="C1=CC(=CC(=C1)[OH])[OH]";

print "$ref $ligf root $root $rootp outfile $outfile\n";

system("obabel $ligf -omol -O $root.mol");
print "matching smiles/smarts: $smiles\n";
#write python file for execution
my $pyfile="$rootp" . "_" . "$root" . ".py";
open(OUTF,">$pyfile") or die "Error while opening $pyfile $!\n";
print OUTF "from rdkit import Chem\n";
print OUTF "m = Chem.MolFromMolFile('$root.mol',sanitize=True,removeHs=False)\n";
print OUTF "s = Chem.MolFromSmiles('$smiles')\n";
print OUTF "i = m.GetSubstructMatch(s)\n";
print OUTF "print(i)\n";
close(OUTF);
system("/Users/visvaldas/miniconda3/bin/python3 $pyfile > tmp111");
open(TUPF,"<tmp111") or die "Error while opening tmp111 $!\n";
my @fields=();
while(<TUPF>){
    chomp; #my @tmp=split;
    (my $str1 = $_) =~ s/\(//;
    (my $str2 = $str1) =~ s/\)//;
    (my $str3 = $str2) =~ s/,/ /g;
    print "atoms $str3\n";
    #@fields=split $str3;
    @fields=split /\s+/, $str3;
    #print "$fields[0]\n";
    #@fields = parse_csv($str2); 
    #@fields=parse_line(",",0, $str2);  
}
my $natfrag=@fields;
print "atoms in fragment $natfrag\n";
close(TUPF);
#foreach my $i (@fields) {
#    print "|$i|\n";
#}
unlink("tmp111"); #remove atom list
#convert array into hash
my %fragat = map { $_ => 1 } @fields;
#foreach my $i (keys %fragat){
#    print "key $i\n";
#}
#open mol file and create xyz file of the fragment
open(MOLF,"<$root.mol") or die "Error while opening $root.mol $!\n";
open(XYZF,">frag.xyz") or die "Error while opening frag.xyz $!\n";
    print XYZF "$natfrag\n";
    print XYZF "$root.mol\n";
    while(<MOLF>){
        next if($.<=4);
        my $atno=$. - 5;
        #print "atno $atno $_";
        if(exists  $fragat{$atno}){
            print "atno $atno $_";
            chomp; my @tmp=split;
            print XYZF "$tmp[3] $tmp[0] $tmp[1] $tmp[2]\n";
        }
    }
close(XYZF);
close(MOLF);
system("obabel frag.xyz -omol2 -O frag.mol2");
#system("DockRMSD frag.mol2 2YI7_resorcinol.mol2");
open(RMSOUT,"DockRMSD frag.mol2 $ref|");
my $rmsd="NA";
while(<RMSOUT>){ 
    if(/^Calculated Docking RMSD:/){
        chomp; my @tmp=split;
        $rmsd=$tmp[3];
    }
}
close(RMSOUT);
print "$ligf RMSD: $rmsd\n";

