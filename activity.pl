#! /usr/bin/perl

use strict;
use 5.010;

my $logDir = "./logs";
my $hostList = "./hosts.txt";

my %hosts;
open (my $hl, "<$hostList");
	foreach my $line (<$hl>){
		if ($line =~ /\w+/){
			chomp $line;
			$hosts{ $line } = "";
		}
	}
close $hl;


my @logs = `ls -1 $logDir/syslog*`;
my @matches;
my @log;

foreach my $logFile (@logs){
	if ($logFile =~ /\.gz$/){
		foreach (`zcat $logFile`){
			if ($_ =~ /\@/){
				push (@log, $_);
			}
		}
	}else{
		open(my $lf, "<$logFile");
			foreach (<$lf>){
				if ($_ =~ /\@/){
					push(@log, $_);
				}
			}
		close($lf);
	}
}

@log = reverse @log;

foreach my $host (keys %hosts){

	chomp $host;
	LOG:
	foreach my $line (@log){
		if ($line =~ /$host/i){
			my $date = join(" ", (split(/\s/, $line))[0,1,2]);
			$hosts{$host} = $date;
			last;
		}
	}
}

say "Hosts with activity:";
foreach my $host (keys %hosts){
	if ($hosts{$host} =~ /.+/){
		say "\t$host ($hosts{$host})";
	}
}

say "\n\nHosts without activity";
foreach my $host (keys %hosts){
	if ($hosts{$host} !~ /.+/){
		say "\t$host";
	}
}


exit 0;
