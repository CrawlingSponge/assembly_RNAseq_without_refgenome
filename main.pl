#!/usr/bin/perl
use strict;

# step0: download sra
unless(-e "0.down_sra.ok"){system("perl ./scripts/0.run_ascp.pl");}
# step1: fastq dump sra
unless(-e "1.dump.ok"){system("perl ./scripts/1.round_fastq-dump.pl");}

# step2: fastp predeal fastq file
unless(-e "2.fastp.ok"){system("perl ./scripts/2.round_fastp.pl");}

# step3: sortmerna to remove rna (optional)

# step4: run trinity without ref
unless(-e "4.trinity.ok"){system("perl ./scripts/4.round_trinity.pl");}

# step5: run transdecoder
unless(-e "5.transdecoder.ok"){system("perl ./scripts/5.transdecoder.pl");}