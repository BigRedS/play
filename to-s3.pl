#! /usr/bin/perl

# Script to backup db dumps to S3, and send an email on completion.

# The latest version is at http://github.com/BigRedS/play/blob/master/to-s3.pl

# There is a config file, cryptically defined as $secrets, which specifies the 
# various parameters of this. It is of the form
# key=value
# with no whitespace surrounding the equals sign. Keys to be defined are:
#   file to backup:	file
#   S3: 		access_key_id, secret_access_key bucket.
#   Reporting email:	email_to email_subject email_body sendmail
#
# sendmail is used in a pipe [ open($m, "|$sendmail"); ] so should be defined
# as something that can be used as such. If sendmail isn't defined, no mail 
# sending is attempted. That's as close to input validation as you get. :)
#
# In email_body, you may use any of these keywords, which are interpreted 
# sensibly. They must be in all-uppercase:
#
# FILE	 local name of the file backed up
# KEY	 key given to the file in the bucket
# BUCKET bucket used
# TODAY  today's date (YYYY-MM-DD)


my $secrets = "/home/avi/s3.secret";

use strict;
use Net::Amazon::S3; # libnet-amazon-s3-perl

# 'parse' config file to get S3 details; create S3 object
my ($accessKeyID, $secretAccessKey, $bucketName, $file, $to, $subject, $body, $sendmail);
open (my $f, "<", $secrets) or die "Error opening secrets file $secrets";
while (<$f>){
	unless(/^#/){
		chomp $_;
		my ($key, $value)=split(/=/, $_);

		if ($key =~ /^access_key_id$/){
			$accessKeyID = $value;
		}elsif ($key =~ /^secret_access_key$/){
			$secretAccessKey = $value;
		}elsif ($key =~ /^bucket$/){
			$bucketName=$value;
		}elsif ($key =~ /^upload_file$/){
			$file=$value;
		}elsif ($key =~ /^email_to$/){
			$to=$value;
		}elsif ($key =~ /^email_subject$/){
			$subject=$value;
		}elsif ($key =~ /^email_body$/){
			$body=$value;
		}elsif ($key =~ /^sendmail$/){
			$sendmail = $value;
		}else{
			print STDERR "WARN: unrecognised option in secrets file ($secrets): $_\n";
		}
	}
}

my $s3 = Net::Amazon::S3->new(
	{
		aws_access_key_id	=> $accessKeyID,
		aws_secret_access_key	=> $secretAccessKey,
		retry			=> 1
	}
);



# list all buckets
#my $response = $s3->buckets;
#print "buckets:\n";
#foreach my $bucket ( @{ $response->{buckets} } ) {
#	print "\t" . $bucket->bucket . "\n";
#}

my $bucket = $s3->bucket($bucketName) or die ("Error using(?) bucket $bucketName");

my @now=localtime(time());
my $year = $now[5] + 1900;
$now[4]++;
my $month = sprintf("%02d", $now[4]);
my $today="$year-$month-$now[3]";
#y $key = "backup$today";
my $key = $today;

$key = "initial_test";

# create S3 object
#$bucket->add_key_filename($key, $file) or die $s3->err .": ".$s3->errstr;

## list files in the bucket
#my $response = $bucket->list_all or die $s3->err . ": " . $s3->errstr;
#print "Bucket $bucketName contains keys:\n";
#foreach my $key ( @{ $response->{keys} } ) {
#	my $key_name = $key->{key};
#	my $key_size = $key->{size};
#	print "\t$key_name of size $key_size\n";
#}


## Send an email, if we want:
if ($sendmail !~ /^$/){
	print `date`;
	$body =~ s/FILE/$file/g;
	$body =~ s/KEY/$key/g;
	$body =~ s/BUCKET/$bucketName/g;
	$body =~ s/TODAY/$today/g;
	$subject =~ s/FILE/$file/g;
	$subject =~ s/KEY/$key/g;
	$subject =~ s/BUCKET/$bucketName/g;
	$subject =~ s/TODAY/$today/g;

	open (my $m, "|$sendmail") or die "Error opening $sendmail for writing";
	print $m "To: $to\n";
	print $m "Subject: $subject\n";
	print $m "$body\n";
	close($m);
}
	
