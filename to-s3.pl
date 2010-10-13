#! /usr/bin/perl

use strict;
use Net::Amazon::S3; # libnet-amazon-s3-perl

# File to be uploaded. Is 'reneamed' to today's date.
my $file = "/home/mouse/full_db_backup.sql.bz2";

# Config file. Should be of the form key=value, with no whitespace 
# in the keys or either side of the = 
# Needs to define access_key_id, secret_access_key and bucket.
my $secrets = "/root/s3-backup/secrets";


# 'parse' config file to get S3 details; create S3 object
my ($accessKeyID, $secretAccessKey, $bucketName);
open (my $f, "<", $secrets) or die "Error opening secrets file $secrets";
while (<$f>){
	unless(/^#/){
		$_ =~ s/\s//;
		my ($key, $value)=split(/=/, $_);

		if ($key =~ /^access_key_id$/){
			$accessKeyID = $value;
		}elsif ($key =~ /^secret_access_key$/){
			$secretAccessKey = $value;
		}elsif ($key =~ /^bucket$/){
			$bucketName= $value;
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
my $today="-$year-$month-$now[3]";
my $key = "backup$today";

$key = "initial_test";

# create S3 object
$bucket->add_key_filename($key, $file) or die $s3->err .": ".$s3->errstr;

## list files in the bucket
#my $response = $bucket->list_all or die $s3->err . ": " . $s3->errstr;
#print "Bucket $bucketName contains keys:\n";
#foreach my $key ( @{ $response->{keys} } ) {
#	my $key_name = $key->{key};
#	my $key_size = $key->{size};
#	print "\t$key_name of size $key_size\n";
#}
