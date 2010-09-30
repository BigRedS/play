#! /usr/bin/perl

# Preconfigures squirrelmail for new email addresses; makes it use
# the correct From: field data.
# 
# Accepts input in three directions:
#   as an argument of the form  "full name" email@address.com
#   in a file given as the first argument
#   piped through on stdin
#
# where the file and stdin are linebreak-separated lists with each
# element of the form
# full name, email@address.com


if ( (!$ARGV[1]) && (! (-f $ARGV[0])) && (-t STDIN) ) {
		print "Usage:\n\t$0 \"[FULL-NAME]\" [EMAIL-ADDRESS]\n";
		print "\t$0 [FILE]\nwhere FILE is a file containing a list of the form\n";
		print "full name, email-address\nalternatively, pipe a list like that in on stdin\n";
	exit 1;
}

if (( -f $ARGV[0] && !$ARGV[1]) || ( !-t STDIN )) {

	if ( !-t STDIN){
		open ($fh, "<&STDIN");
	}else{
		open ($fh, "<", $ARGV[0]);
	}
	while(<$fh>){
		my($name, $email) = split(/,/);
		chomp $email;
		&preconfigure($name, $email);
	}
}else{
	&preconfigure($ARGV[0], $ARGV[1]);
}

sub preconfigure(){
	my $name = shift;
	my $email = shift;
	my $filename;

	## Limitation: for an email address lhs@sub.domain.tld, this makes a file called lhs.sub.pref not lhs.sub.domain.pref
	## I don't know if this is correct.
	if ($email =~ /(.+\@[^\.]+)\.\w+/){
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
