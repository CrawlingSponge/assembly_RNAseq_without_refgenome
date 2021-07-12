#!/usr/bin/perl
use strict;
# change into Trinity env with "conda activate Trinity"
my $main = `pwd`; chomp($main); chdir "$main"; print "working dir: $main\n";

# read fastq lines
my $fastq_dump = "1.fastq-dump_out";
opendir(FD, $fastq_dump); my @fdirs = grep(/_1\.fastq$/, readdir(FD)); close FD; my @sort_fdirs = sort @fdirs;

my $fastp_out = "2.fastp_out"; unless(-e $fastp_out){system("mkdir -p $fastp_out");}
my $pa_fastp = "para_fastp.txt"; open(PA_FASTP, ">$main/$fastp_out/$pa_fastp") or die $!;

chdir $fastp_out; print "working dir: $fastp_out\n";
foreach my $fir (@sort_fdirs){
	my $sec = $fir; $sec =~ s/_1\.fastq$/_2.fastq/;
	print "$fir\t$sec\n";
	#system("nohup fastp -f 10 -i $main/$fastq_dump/$fir -o $fir.fastp -I $main/$fastq_dump/$sec -O $sec.fastp");
	print PA_FASTP "nohup fastp -f 10 -i $main/$fastq_dump/$fir -o $fir.fastp -I $main/$fastq_dump/$sec -O $sec.fastp\n";
}
close PA_FASTP;
system("ParaFly -c $pa_fastp -CPU 16");
chdir $main; 
open(OUT, ">2.fastp.ok") or die $!; close OUT;
