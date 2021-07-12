#!/usr/bin/perl
use strict;
# change into Trinity env with "conda activate Trinity"
my $main = `pwd`; chomp($main); chdir "$main"; print "working dir: $main\n";

# read fastq lines
my $fastp_out = "2.fastp_out";
opendir(FD, $fastp_out); my @fdirs = grep(/_1\.fastq\.fastp$/, readdir(FD)); close FD; my @sort_fdirs = sort @fdirs;

my $trinity_out = "4.trinity_out"; unless(-e $trinity_out){system("mkdir -p $trinity_out");}
my $pa_trinity = "para_trinity.txt"; open(PA_TRINITY, ">$main/$trinity_out/$pa_trinity") or die $!;
chdir $trinity_out; print "working dir: $trinity_out\n";
foreach my $fir (@sort_fdirs){
	my $sec = $fir; $sec =~ s/_1\.fastq\.fastp$/_2.fastq.fastp/;
	my $out = $fir; $out =~ s/_1\.fastq\.fastp$//; 
	my $out_dir = $out.".trinity";
	print "$fir\t$sec\n";
	#system("Trinity --seqType fq --left $main/$fastp_out/$fir --right $main/$fastp_out/$sec --CPU 8 --max_memory 80G --output $out_dir");
	print PA_TRINITY "Trinity --seqType fq --left $main/$fastp_out/$fir --right $main/$fastp_out/$sec --CPU 8 --max_memory 50G --output $out_dir && perl /home/Jiaqing/anaconda3/envs/Trinity/opt/trinity-2.8.5/util/misc/get_longest_isoform_seq_per_trinity_gene.pl $out_dir/Trinity.fasta > $out_dir/$out.longest.trinity.fei.fasta\n";
}
close PA_TRINITY;
system("ParaFly -c $pa_trinity -CPU 16");
chdir $main; 
open(OUT, ">4.trinity.ok") or die $!; close OUT;
