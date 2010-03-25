#! /usr/bin/perl

use strict;
use 5.010;

use XML::RAI;
use XML::RSSLite;
use XML::FeedPP;
use LWP::Simple;
use DateTime;
use DateTime::Format::Atom;
#use DateTime::Format::RSS;

#print "Content-type: text/html\n\n\n";


## Get some data!
my %stuff = &el_reg();
my %stuff = (&slashdot(), %stuff);

## Let's make some HTML!

&start_html();

for my $key (reverse sort (%stuff)){

	if ($stuff{$key}){
		my $date = $key;
		my @array = %stuff->{$key};

		&make_tr($date, @array);
	}
}

# Let's stop.
&end_html();



#	Here Be Subroutines					#
#								#
# Subs to grab content and stick it in a hash. Hashes are of	#
# the form 							#
#	$return{date} = ["url", "text"]				#
# where date is a unix timestamp				#


sub el_reg(){
	my %return;
	my $url="http://forums.theregister.co.uk/feed/user/40790";
	my $feed = XML::FeedPP->new( $url );
	
	foreach my $item ( $feed->get_item() ) {
		my $d = DateTime::Format::Atom->new();
		my $dt = $d->parse_datetime( $item->pubDate );
		my $time = $dt->epoch;

		$return{ $time } = [$item->link, $item->title()];
	}
	return %return;
}

sub slashdot(){
	my %return;
	my $url = "http://slashdot.org/firehose.pl?op=rss&content_type=rss&view=userhomepage&fhfilter=%22home%3Alordandmaker%22&orderdir=DESC&orderby=createtime&color=black&duration=-1&startdate=&user_view_uid=960504&logtoken=960504%3A%3AqQuPZQpQoZTAkoJGfmbG6g";
	my $content = get($url);
	my $rai = XML::RAI->parse_string($content);
	foreach my $item ( @{$rai->items} ) {
		$content = substr($item->content, 0, 100);
		$content.="...";  


		my $time = $item->issued;
		my ($date, $time) = split (/T/, $time);
		my ($time, $tz) = split (/\+/, $time);
		my ($year,$month,$day) = split(/-/, $date);
		my ($h,$m,$s) = split(/:/, $time);
		
		my $dt = DateTime->new( 
			year   => $year,
			month  => $month,
			day    => $day,
			hour   => $h,
			minute => $m,
			second => $s,
                       time_zone => "+$tz",
                 );

		$time = $dt->epoch;
		

#		my $d = DateTime::Format::W3CDTF->new();
#		my $dt = $d->parse_datetime( $item->issued );
#		my $time = $dt->epoch;
		my $link = $item->link;

	$return{$time} = [$link, $content]

#	$return{ $link } = $content;
	}

	return %return
}

# Boring subs 							#

## Accepts as an argument the two items spouted by the above get-data-subs 
## (a string which is the timestamp and a two-element array containing a
## URL and some text to use as the link.

sub make_tr(){
	my ($date, $arrayref) = @_;
	my ($link, $content) = @$arrayref[0,1];

	$date = localtime($date);

	print "\t\t<tr><td>";
	print get_icon($link);
	say "<td><td><a href='$link'>$content</a></td><<td>$date</td></td>";
#print localtime($date);
#say "</td><tr>";
	
	
#	a href='$link'>$content</a><br />";

}



## Decides which icon to use based on (presumably) a URL passed to it, and 
## returns the HTML to display that icon (i.e. <img src=".....">

sub get_icon{
	my $url;
	given (@_[0]){
		when(/slashdot/){
			$url = "http://www.jovianclouds.com/images/slashdot_normal.jpg";
		}
		when(/theregister/){
			$url = "http://www.theregister.co.uk/Design/graphics/icons/vulture_red.png";
		}
	}
	return "<img src='$url'>";

}


sub start_html() {
	say "<html><body><table>";
}
sub end_html() {
	say "</table>";
	say "<a href='http://github.com/BigRedS/play/raw/master/website/index.pl'>sauce</a>, <a href='http://github.com/BigRedS/play/blob/master/website/index.pl'>Git</a></body></html>";
}
