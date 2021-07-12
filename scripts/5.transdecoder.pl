#!/usr/bin/perl
use strict;
# change into Trinity env with "conda activate Trinity"
my $main = `pwd`; chomp($main); chdir "$main"; print "working dir: $main\n";
my $uniprot = "$main/configures/uniprot_sprot.fasta";
# read fastq lines
my $trinity_out = "4.trinity_out";
opendir(FD, $trinity_out); my @fdirs = grep(/\.trinity$/, readdir(FD)); close FD; my @sort_fdirs = sort @fdirs;

my $transd_out = "5.transdecoder_out"; unless(-e $transd_out){system("mkdir -p $transd_out");}
chdir "$main/$transd_out";
foreach my $sec (@sort_fdirs){
	my $transd_tri = $sec; $transd_tri =~ s/\.trinity$//;
	unless(-e "$main/$transd_out/$transd_tri"){system("mkdir -p $main/$transd_out/$transd_tri");} 
	chdir "$transd_tri";
	
	system("cp $main/$trinity_out/$sec/$transd_tri.longest.trinity.fei.fasta ./");
	system("cp $uniprot ./");
	system("TransDecoder.LongOrfs -t $transd_tri.longest.trinity.fei.fasta");
	system("diamond makedb --in ./uniprot_sprot.fasta --db ./uniprot_sprot.fasta");
	system("diamond blastp -d ./uniprot_sprot.fasta -q ./$transd_tri.longest.trinity.fei.fasta --evalue 1e-5 --max-target-seqs 1 > ./$transd_tri.blastp.outfmt6");
	system("TransDecoder.Predict -t ./$transd_tri.longest.trinity.fei.fasta --retain_blastp_hits ./$transd_tri.blastp.outfmt6");
	system("cp ./$transd_tri.longest.trinity.fei.fasta.transdecoder.* ../")
	chdir "../";
}
chdir $main;
open(OUT, ">5.transdecoder.ok") or die $!; close OUT;
