#! /usr/bin/perl

use strict;
use 5.010;

use XML::RAI;
use XML::RSSLite;
use LWP::Simple;

# subs return %return = { link => 'description'}
#  get stuck in %data = { date => \%return }
# then sort by date etc.

&el_reg();
#my %stuff = &slashdot;

#while (my ($key, $value) = each(%stuff)){
#	say $key;
#}

print "\n";


sub el_reg(){
	my $url="http://forums.theregister.co.uk/feed/user/40790";
	my $content = get($url);
	
	my %result;

parseRSS(\%result, \$content);

 # print "=== Channel ===\n",
  #      "Title: $result{'title'}\n",
  #      "Desc:  $result{'description'}\n",
  #      "Link:  $result{'link'}\n\n";

#  foreach my $item (@{$result{'item'}}) {
#  print "  --- Item ---\n",
#        "  Title: $item->{'title'}\n",
#        "  Desc:  $item->{'description'}\n",
#        "  Link:  $item->{'link'}\n\n";
#  }
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

		$return{ $link } = $content;
	}

	return %return
}


