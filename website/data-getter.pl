#! /usr/bin/perl

use strict;
use 5.010;

use XML::RAI;
use XML::RSSLite;
use XML::FeedPP;
use LWP::Simple;
use DateTime;
use DateTime::Format::Atom;

my $file = "./data";

my %stuff = (&slashdot(), &atom());


open (FILE , ">$file") || die ("Error opening $file");
for my $key (reverse sort (%stuff)){
	if ($stuff{$key}){			# This shouldn't be necessary.
		my $date = $key;
		my $arrayref = %stuff->{$key};
		my $url = ${$arrayref}[0];
		my $content = ${$arrayref}[1];

	#	$url =~ s/&amp;/&/;
	#	$url =~ s/&/&amp;/;
		$url =~ s/&{1}(amp;){0}/&amp;/g;
		my $content = substr($content, 0, 250);


		print FILE "$date\n$url\n$content\n\n";
	}
}
close FILE;

sub atom(){

	my @urls = ("http://identi.ca/api/statuses/user_timeline/99267.atom", "http://forums.theregister.co.uk/feed/user/40790", "http://github.com/BigRedS.atom");
	my %return;

	foreach my $url (@urls){
		my $feed = XML::FeedPP->new( $url );

		foreach my $item ( $feed->get_item() ) {
			my $d = DateTime::Format::Atom->new();
			my $dt = $d->parse_datetime( $item->pubDate );
			my $time = $dt->epoch;
	
			$return{ $time } = [$item->link, $item->title()];
		}
	}
	return %return;
}

sub slashdot(){
	my %return;
	my $url = "http://slashdot.org/firehose.pl?op=rss&content_type=rss&view=userhomepage&fhfilter=%22home%3Alordandmaker%22&orderdir=DESC&orderby=createtime&color=black&duration=-1&startdate=&user_view_uid=960504&logtoken=960504%3A%3AqQuPZQpQoZTAkoJGfmbG6g";
	my $content = get($url);
	my $rai = XML::RAI->parse_string($content);
	foreach my $item ( @{$rai->items} ) {
#		$content = substr($item->content, 0, 100);
#		$content.="...";  
		$content = $item->content;


		## This was supposed to be done by TimeDate::Format::RSS
		## but I couldn't persuade CPAN to tell me why it	
		## couldn't install it.				

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
		my $link = $item->link;
		$return{$time} = [$link, $content]
	}
	return %return
}
