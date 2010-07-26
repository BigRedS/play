#! /usr/bin/perl

# Iterates through a list of hostnames, and inspects syslog for
# mention of them, then says who's had attention and makes an 
# educated guess as to when it last had activity.

# Doesn't yet know when to stop with log rotations.

use strict;
use 5.010;

# Looks for files matching syslog* in here, greps them for
# evidence of activity.
my $logDir = "/var/log/";

# File with a list of domains. Like qmail's rcpthosts file.
my $domainList = "/var/qmail/control/rcpthosts";

# Oldest logfile to check, in months;
my $maxLogAge = 4;


my @months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
my $thisMonth = (localtime)[4];
my $spliceOffset = ($thisMonth +1) - $maxLogAge;
my @allowedMonths = splice(@months, $spliceOffset, $maxLogAge);

#foreach (@allowedMonths){
#	print;
#}


# Create array of hostnames consisting of non-empty lines
# from $hostList
my %domains;
open (my $hl, "<$domainList") or die "Error opening \$domainList $domainList";
	foreach my $line (<$hl>){
		if ($line =~ /\w+/){
			chomp $line;
			$domains{ $line } = "";
		}
	}
close $hl;



# Get all the lines containing '@' from all the files named syslog*
# in the $logDir that're newer than $maxLogAge and stick them in
# an array handily called '@log'. 
# Uses zcat for the gzipped ones 'cause it's easier than shouting
# at CPAN.

my @log;
opendir(my $dh, $logDir) or die "Error opening \$logDir $logDir";
my @logFiles = readdir($dh);
close ($dh);
@logFiles = sort @logFiles;
my @logFilesUsed;

foreach my $logFile (@logFiles){
	if ((($logFile =~ /^syslog/) || $logFile =~ /^maillog/ )&& ( -M $logFile < $maxLogAge)){
		push(@logFilesUsed, $logFile);
		$logFile = $logDir."/".$logFile;
		if ($logFile =~ /\.gz$/){
			foreach my $line (`zcat $logFile`){
				foreach my $allowedMonth (@allowedMonths){
					if (($line =~ /\@/) && $line =~ (/^$allowedMonth/)){
						push (@log, $line);
						last;
					}
				}
			}
		}else{
			open(my $lf, "<$logFile");
				foreach my $line (<$lf>){
					foreach my $allowedMonth (@allowedMonths){
						if (($line =~ /\@/) && ($line =~ /^$allowedMonth/)){
							push(@log, $line);
							last;
						}
					}
				}
			close($lf);
		}
	}
}
closedir $dh;


# Iterate through the hosts list, for each one see if we can find 
# mention in @log. If found, sticks the date it found in the hash. 
# Hopefully, that date is the last date we saw the domain.

foreach my $domain (keys %domains){
	chomp $domain;
	foreach my $line (@log){
		if ($line =~ /$domain/i){
			my $date = join(" ", (split(/\s/, $line))[0,1,2]);
			$domains{$domain} = $date;
			last;
		}
	}
}


# This is dumb and should be smarter:
my $withActivity = 0;
say "Domains with activity:";
foreach my $domain (keys %domains){
	if ($domains{$domain} =~ /.+/){
		say "\t$domains{$domain}\t$domain";
		$withActivity++;
	}
}

say "\n\nDomains without activity:";
my $withoutActivity = 0;
foreach my $domain (keys %domains){
	if ($domains{$domain} !~ /.+/){
		say "\t$domain";
		$withoutActivity++;
	}
}

my $logFileCount = @logFilesUsed;
my $logLen = @log;

say "\nRead $logLen lines of $logFileCount logfiles for records dating back $maxLogAge months.";
say "Found $withActivity domains with activity, and $withoutActivity domains without.";
say "Looked in $domainList for the list of domains, and $logDir for the logfiles";

exit 0
