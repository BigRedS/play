#! /usr/bin/perl

if (!$ARGV[1]){
	print "Usage:\n\t$0 \"[FULL-NAME]\" [EMAIL-ADDRESS]\n";
	exit 1;
}

my $name = $ARGV[0];
my $email = $ARGV[1];
my $filename;

if ($email =~ /(.+\@[^\.]+)\.+/){
	 $filename = $1;
}else{
	print "Couldn't deduce filename from email address\n";
	print "You'll have to do this one manually, or fix the script";
	exit 1;
}

$filename =~ s/\@/\./;
$filename .= ".pref";

`echo -e \"full_name=$name\" >> /var/lib/squirrelmail/data/$filename`;
`echo -e \"email_address=$email\" >> /var/lib/squirrelmail/data/$filename`;
`chown www-data:www-data /var/lib/squirrelmail/data/$filename`;

