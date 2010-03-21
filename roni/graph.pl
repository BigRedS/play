#! /usr/bin/perl
use strict;
use 5.010;
use CGI ':standard';
use GD::Graph::lines;

my $data_file = ".maths.data";
my (@dates, @scores);

open (F, "<$data_file")
  or die ("Error opening $data_file");
while (<F>){
	my ($date, $score) = (split(/\s/))[0,2];
	push @dates, $date;
	push @scores, $score;
}

my @data = ( [@dates] , [@scores] );

for (my $i = 0; $i <= @dates; $i++){
	say "$dates[$i]\t$scores[$i]";

}

my $graph = new GD::Graph::lines();

$graph->set(
	x_label           => 'Date',
	y_label           => '% Score',
	title             => 'Maths Scores',
	y_max_value       => 100,
	y_min_value       => '0',
	y_tick_number     => 10,
	y_label_skip      => 2,
	x_label_skip      => 4,
	box_axis          => 0,
	line_width        => 3,
	x_labels_vertical => 1,
);

#$graph->plot(\@dates, \@scores);

my $format = $graph->export_format;
open(IMG, '>graph.$format') or die $!;
binmode IMG;
print IMG $graph->plot(\@data)->$format();

#print IMG $graph->$format;
