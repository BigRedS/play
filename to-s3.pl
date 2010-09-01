#! /usr/bin/perl

use strict;
use Net::Amazon::S3; # libnet-amazon-s3-perl

my $file = 
my $access_key_id =
my $secret_key = 
my $bucketName = 

my $s3 = Net::Amazon::S3->new(
	{
		aws_access_key_id	=> $access_key_id,
		aws_secret_access_key	=> $secret_key,
		retry			=> 1
	}
);

$bucket = $s3->bucket($bucketName)
   or die ("Error using(?) bucket $bucketName");


