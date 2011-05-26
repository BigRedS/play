#! /usr/bin/perl

use strict;
use WWW::Mechanize;
use IO::Uncompress::Gunzip qw(gunzip);
use CGI qw(param);

print "content-type: text/html\n\n";

if(defined(param('url'))){

	my $username = "";
	my $password = "";
	my $page = param('url');

	my $mech = WWW::Mechanize->new();

	$mech->get($page);
	$mech->form_number(1);
	$mech->field("user" => $username);
	$mech->field("passwrd" => $password);
	$mech->field("cookielength" => "60");
	my $request = $mech->click();

	my ($input, $output);
	$input = $request->content;
	
	gunzip (\$input => \$output);
	
	print $output;
}else{
	print <<EOF;
<html>
	<form>
		URL: <input type='text' name='url' />
		<input type='submit' name='submit' />
	</form>
</html>
EOF
}





