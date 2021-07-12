#!/usr/bin/perl
use strict;
# change into Trinity env with "conda activate Trinity"
my $main = `pwd`; chomp($main); chdir "$main"; print "working dir: $main\n";

my $sump_out = "1.fastq-dump_out"; unless(-e $sump_out){system("mkdir -p $sump_out");}
my $pa_dump = "para_fastq_dump.txt"; open(PA_DUMP, ">$main/$sump_out/$pa_dump") or die $!;

my $sra_dir = "0.download_sra";
opendir(FD, $sra_dir); my @fdirs = grep(/^SRR/, readdir(FD)); close FD; my @sort_fdirs = sort @fdirs;
chdir $sra_dir; print "working dir: $sra_dir\n";
foreach my $fir (@sort_fdirs){
	opendir(SD, "$fir"); my @sdirs = grep(/sra$/, readdir(SD)); close SD; my @sort_sdirs = sort @sdirs;
	chdir "$fir"; print "working dir: $fir\n";
	foreach my $sec (@sort_sdirs){
		print "sra_file: $sec\n";
		#system("fastq-dump --split-3 $sec");
		#print PA_DUMP "fastq-dump --split-3 $main/$sra_dir/$fir/$sec -O $main/$sump_out\n";
		my $def_seq = '@$sn[_$rn]/$ri';
		print PA_DUMP "fastq-dump --defline-seq '$def_seq' --split-3 $main/$sra_dir/$fir/$sec -O $main/$sump_out\n";
	}
	chdir "../";
}
close PA_DUMP;
chdir "$main/$sump_out"; print "working dir: $main/$sump_out\n";
system("ParaFly -c $pa_dump -CPU 16");
chdir $main; 
open(OUT, ">1.dump.ok") or die $!; close OUT;
