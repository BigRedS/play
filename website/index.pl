#! /usr/bin/perl

use strict;
use 5.010;

use XML::RAI;
use XML::RSSLite;
use XML::FeedPP;
use LWP::Simple;

print "Content-type: text/html\n\n\n";


## Get some data!
my %stuff = &el_reg();
my %stuff = (&slashdot(), %stuff);

&start_html();


for my $key (keys (%stuff)){
	my $date = $key;
	my @array = %stuff->{$key};

	&make_tr($date, @array);
}


&end_html();


## this is the end of the page.


# Subs to grab content and stick it in a hash. Hashes are of	#
# the form 							#
#	$return{date} = 'url text'				#
# where urls are presumed to not have spaces in, and 'text' is 	#
# the text to display						#

sub el_reg(){
	my %return;
	my $url="http://forums.theregister.co.uk/feed/user/40790";
	my $feed = XML::FeedPP->new( $url );
	foreach my $item ( $feed->get_item() ) {
		$return{ $item->pubDate() } = [$item->link, $item->title()];
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

		my $link = $item->link;

	$return{$item->issued} = [$link, $content]

#	$return{ $link } = $content;
	}

	return %return
}

# Boring subs 							#

sub make_tr(){
	my ($date, $arrayref) = @_;
	my ($link, $content) = @$arrayref[0,1];

	print "<tr><td>";
	print get_icon($link);
	print "</td><td><a href='$link'>$content</a></td></tr>";
	
	
#	a href='$link'>$content</a><br />";

}

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
	say "</table></body></html>";
}
