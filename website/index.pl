#! /usr/bin/perl

use strict;
use 5.010;

print "Content-type: text/html\n\n\n";

my $data = "./data";

open(DATA, "<$data")
 or print "Error opening data file";

&start_html();
{
	local $/ = "";
	while (<DATA>){
		my ($date, $link, $content) = (split(/\n/, $_))[0,1,2];
		&make_tr($date, $link, $content);
	}
}
&end_html();

close DATA;

# # # 

sub make_tr(){
	my $date = shift;
	my $link = shift;
	my $content = shift;

	$date = &friendly_date($date);

	if (length($content) > 1){

		print "\t\t\t\t<tr><td class='icon'>";
		print get_icon($link);
		say "</td><td class='text'><a href='$link'>$content</a></td><td class='date'>$date</td></tr>";
	}
}

sub get_icon{
	my ($url, $alt, $link);
	given (@_[0]){
		when(/slashdot/){
			$url = "http://www.slashdot.org/favicon.ico";
			$alt = "Slashdot";
			$link = "http://www.slashdot.org";
		}
		when(/theregister/){
			$url = "http://www.theregister.co.uk/favicon.ico";
			$alt = "The Register";
			$link = "http://theregister.co.uk";
		}
		when(/identi/){
			$url = "http://identi.ca/favicon.ico";
			$alt = "Identi.ca";
			$link = "http://identi.ca";
		}
		when(/github/){
			$url = "http://github.com/favicon.ico";
			$alt = "GitHub";
			$link = "http://github.com";
		}
	}
	return "<a href='$link'><img src='$url' alt='$alt' style='border:none;' /></a>";
}


sub friendly_date() {
	my $date = shift;
	my $time;

	my $interval = time() - $date;

	given($interval){
		when ($interval < 600){
			int $interval;
			return "$interval seconds ago";
		}
		when ($interval < 3600){
			$time = int $interval/60;
			return "$time minutes ago";
		}
		when ($interval < 86400){
			$time = int $interval/60;
			return "$time minutes ago";
		}
		when ($interval < 604800){
			$time =int $interval/3600;
			return "$time hours ago";
		}
	}
	return "ages ago";

}


sub start_html() {

print <<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<link rel='stylesheet' type='text/css' href='./styles.css'/>
		<title>Avi</title>
	</head>
	<body>
		<div class='head'>
			<p class='avi'>
				Avi :)
			</p>
			<p>
				There are several hundred thousand terabytes of data on The Internet. Here are my latest contributions to it:
			</p>
		</div>
		<div class='content'>
			<table class='main'>

EOF
}

sub end_html() {
print <<EOF
			</table>
		</div>
		<div class='footer'>
			<a href='http://github.com/BigRedS/play/tree/master/website/'>Git</a>
		</div>
	</body>
</html>
EOF
}

