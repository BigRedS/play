#! /usr/bin/perl

# Preconfigures squirrelmail for addresses. Either call it
# sqwebmail-preconfigure "full name" email@address.com
# or with the path to a file as the first argument, that file
# containing a list of the form
# full name, email@address.com

if ( (!$ARGV[1]) && (! (-f $ARGV[0])) ){
	print "Usage:\n\t$0 \"[FULL-NAME]\" [EMAIL-ADDRESS]\n";
	exit 1;
}

if ( -f $ARGV[0] && !$ARGV[1] ){
	open ($fh, "<", $ARGV[0]);
	while(<$fh>){
		my($name, $email) = split(/,/);
		&preconfigure($name, $email);
	}
}else{
	&preconfigure($ARGV[0], $ARGV[1]);
}

sub preconfigure(){
	my $name = shift;
	my $email = shift;
	my $filename;

	if ($email =~ /(.+\@[^\.]+)\.+/){
		 $filename = $1;
	}else{
		print "Couldn't deduce filename from email address ($email); you'll have to do this one manually, or fix the script\n";
		exit 1;
	}

	$filename =~ s/\@/\./;
	$filename .= ".pref";

	print "`echo -e \"full_name=$name\" >> /var/lib/squirrelmail/data/$filename`;\n ";
	print "`echo -e \"email_address=$email\" >> /var/lib/squirrelmail/data/$filename`;\n ";
	print "`chown www-data:www-data /var/lib/squirrelmail/data/$filename`; \n";
}
