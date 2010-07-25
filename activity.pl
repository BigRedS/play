#! /usr/bin/perl

# Iterates through a list of hostnames, and inspects syslog for
# mention of them, then says who's had attention and makes an 
# educated guess as to when it last had activity.

# Doesn't yet know when to stop with log rotations.

use strict;
use 5.010;

# Looks for files matching syslog* in here, greps them for
# evidence of activity.
my $logDir = "./logs";

# File with a list of domains. Like qmail's rcpthosts file.
my $hostList = "./hosts.txt";

# Create array of hostnames consisting of non-empty lines
# from $hostList
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
my @log;

# Get all the lines containing '@' out of the logfiles, and 
# concatenate them into one easy-to-use array
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

# Apparently vain attempt to ensure that the date recorded in the
# hash is the latest one from the logs.
@log = reverse @log;


# Iterate through the hosts list, for each one see if we can find 
# mention in @log. If found, sticks the date it found in the hash. 
# Hopefully, that date is the last date we saw the domain.
foreach my $host (keys %hosts){
	chomp $host;
	foreach my $line (@log){
		if ($line =~ /$host/i){
			my $date = join(" ", (split(/\s/, $line))[0,1,2]);
			$hosts{$host} = $date;
			last;
		}
	}
}


# This is dumb and should be smarter:

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
