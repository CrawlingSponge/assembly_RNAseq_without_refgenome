#!/usr/bin/perl
use strict;
my $main = `pwd`; chomp($main);
my $sra = "sra.txt";
my $down_out = "0.download_sra"; unless(-e $down_out){system("mkdir -p $down_out");}

#system("ascp -v -QT -l 400m -P33001 -k1 -i /home/yjq/.aspera/connect/etc/asperaweb_id_dsa.openssh --mode recv --host fasp.sra.ebi.ac.uk --user era-fasp --file-list $main/configures/sra.txt ./$down_out");
#system("prefetch -t ascp -a \"/home/Jiaqing/.aspera/connect/bin/ascp|/home/Jiaqing/.aspera/connect/etc/asperaweb_id_dsa.openssh\" --option-file $main/configures/$sra -O ./$down_out");
system("prefetch -t ascp --option-file $main/configures/$sra -O ./$down_out");
#system("prefetch --option-file $main/configures/$sra -O ./$down_out");
#system("prefetch -t ascp -a $ascp|$ssh --option-file $main/configures/$sra -O ./$down_out");
open(OUT, ">0.down_sra.ok") or die $!; close OUT;
