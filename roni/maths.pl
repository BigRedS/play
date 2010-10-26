#! /usr/bin/perl

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#		Avi's Wonderful q+a Thingy			#
#								#
# By (and (c)) Avi Greenbury, aged 24 3/4			#
# 								#
# Each form of question is a sub, and should be named in the 	#
# array @questions. It should return two values in a list 	#
# context the first being the question, the latter the answer. 	#
# The supplied answer ('$guess') is tested in a 		#
# 		if ($guess == $answer){				#
# so regexps should work. Importantly, no guessing goes on. If 	#
# you're only interested in integers (sensible) then make 	#
# $answer an appropriately rounded integer.			#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# This is free software. It is licensed under the FreeBSD 	#
# license which you can find here:				#
#    http://www.freebsd.org/copyright/freebsd-license.html	#

#use strict; 	# I know, I know. But &{$subName}() doesn't work
		# in strict, and I just need to make it work. I 
		# promise I'll modify it to work in strict. 
use 5.010;
use Math::Trig;
my $home = $ENV{HOME};

## Some configuration:

	# Subs we want to use are listed in @questions. Each time a question is to
	# be asked, the sub to execute is picked at random from @questions


my ($cheatmode, $granular_data, $aggregate_data, $user, $host, $destinationDir);

my $configFile = "$home/.maths/conf";
open ($c, "<", $configFile) or die ("ERROR: Couldn't open configfile $configFile\n");
while(<$c>){
	unless($_ =~ /^#/){
		my ($key,$value)=(split(/=/, $_))[0.1];
		if ($key =~ /cheat/){
			$cheatmode = $value;
		}elsif($key=~/granular_data_file/){
			$granular_data = $value;
		}elsif($key=~/aggregate_data_file/){
			$aggregate_data = $value;
		}elsif($key=~/ssh_user/){
			$user = $value;
		}elsif($key=~/ssh_host/){
			$host = $value;
		}elsif($key=~/ssh_dir/){
			$destinationDir = $value;
		}elsif($key=~/default_number_of_questions/){
			$numQs = $value;
		}elsif($key=~/test_only/){
			$testOnly = $value;
		}else{
			print STDERR "WARN: Unexpected option: $key\n";
		}
	}
}

my $questions;
if($testOnly =~ /yes/){
	@questions = ("test");
}else{
	@questions = ("radians", "differentiation", "sequences_and_series", "coordinate_geometry");
}


close ($c);

my $startTime = time();

$SIG{INT} = \&exit;

&usage if ($ARGV[0] =~ /\D/);
my $num = $ARGV[0];
if (!($num > 0)){
	$num = 100;
}

my $subject = undef;
if ($ARGV[1]){
	$subject = $ARGV[1];
}
my ($now, $count, $pc, $start_time, $score);

# Bunch of welcoming text
&welcome;

## Right then, let's ask some questions:
&quiz ($num); 

## These are the question subs:


sub coordinate_geometry(){
	my ($x1, $y1, $x2, $y2);
	my ($question, $answer);
	my $questiontype = &positive_rand(2);
	my $range = 100;
	my $x1 = &nonzero_rand($range);
	my $x2 = &nonzero_rand($range);
	my $y1 = &nonzero_rand($range);
	my $y2 = &nonzero_rand($range);
	
	given($questiontype){

		when(1){
			$question = "Find the midpoint of ($x1,$y1) and ($x2,$y2).";
			my $answer_x = int (($x1+$x2)/2);
			my $answer_y = int (($y1+$y2)/2);
			$answer = $answer_x.",".$answer_y;
		}
		when(2){
			$question = "Find the distance between ($x1,$y1) and ($x2,$y2).";
			my $x_len = $x2 - $x1;
			my $y_len = $y2 - $y1;
			$answer = int ( sqrt( ($y_len**2) + ($x_len**2)));
		}
	}
		return ($question, $answer);


}

sub differentiation(){
	my ($a, $b, $c, $p, $q, $r, $x);

	# Generate three coefficients
	my $range = 10;	## Max. value of coefficient
	$a = &nonzero_rand($range);
	$b = &nonzero_rand($range);
	$c = &nonzero_rand($range);

	# And three powers
	$range = 4;
	$p = &positive_rand($range);
	$q = &positive_rand($range);
	$r = &positive_rand($range);

	# And a value of X to solve for:
	$x = &nonzero_rand(5);

	my $equation = $a."X^".$p." + ".$b."X^".$q." + ".$c."X^".$r;

	my $answer = ($p*$a * ($x ** ($p-1)));
	my $answer = $answer + ($q*$b * ($x ** ($q-1)));
	my $answer = $answer + ( $r*$c * ($x ** ($r-1)));
	my $question = "Solve dy/dx for $equation where X = $x";
	
	return ($question, $answer);

}

sub radians() {
	my ($a, $r, $l, $theta, $question, $answer);
	my $questiontype = &positive_rand(4);
	given ($questiontype){
		when (1){
			# Find area of sector:
			$r = &positive_rand(100);
			$theta = &positive_rand(2*pi);
			$answer = int ($r * $r * $theta)/2;
			$question = "A circle has radius $r. Find the area of a sector of angle ${theta}rad";
		}
		when(2){
			# Find length of arc:
			$r = &positive_rand(2*pi);
			$theta = &positive_rand(2*pi);
			$answer = int $r * $theta;
			$question = "A circle has radius $r, find the length of the arc of angle ${theta}rad";
		}
		when(3){
			# degs rads:
			$theta = &positive_rand(2*pi);
			$answer = int $theta * (180/pi);
			$question = "express ${theta}rad in degrees";
		}
		default{
			# rads - degs:
			$theta = &positive_rand(360);
			$answer = int $theta * (pi/180);
			$question = "express ${theta}degs in radians";
		}
	}
	return ($question, $answer);
}

sub sequences_and_series() {
	my ($a, $r, $n, @terms);
	$a = &positive_rand(100);

	$r = 2 + &positive_rand(8);

	$n = 3 + &positive_rand(8);

	@terms[0] = $a;
	for($i = 1; $i<5; $i++){
		$terms[$i] = $terms[$i-1] * $r;
	}

	$question = "Find the ${n}th term of the series\n\t";
	foreach (@terms){
		$question.=" $_ ";
	}
	$answer = $a * ($r**($n-1));
	return ($question, $answer);

}

sub test(){
	my $question = "Life, the universe and everything?";
	my $answer = 42;
	return ($question, $answer);
}

# # Worker Subs # #
# # # # # # # # # #

# Invokes &ask_question to do the actual asking. This just judges the 
# answer.
# 
# Input: integer, how many questions to ask

sub quiz(){
	my $num = shift;	# How many questions to ask
	$count = 0;
	$start_time = time();
	for ($count = 1; $count <= $num; $count++){
		print "\n\n$count)\t";	
		my ($q,$subject) = &ask_question();
		
		my($sec,$min,$hr,$day,$mon,$yr)=(localtime)[0,1,2,3,4,5];
		$mon++;
		$yr+=1900;
		my $datetime = "$yr $mon $day $hr $min $sec";

		my $line = "$startTime\t$datetime\t$subject\t";
		if($q =~ /correct/ ){
			$score++;
			say "\tCorrect!";
			$line.="1";
		}else{
			say "\tNope. Expected $q";
			$line.="0";
		}
		if ($testOnly =~ /yes/){
			$line.="+";
		}
		push (@stats, $line);
	}
	$count--;
	$time = time() - $start_time;
	say "\n\nYou tried $count questions, got $score correct and spent $time seconds doing it.";
	$pc = ( $score / $count  ) * 100;
	say "Pointless accuracy:".$pc."%";
	if ($last_score = &last_score){
		say "Last time you got ${last_score}%";
	}

	&exit("$count", "$pc", "$time", "$score");
}

## Picks a question at random, asks it, and prompts for an answer. 
## It returns true if the answer is correct, false (well, undef) otherwise.
sub ask_question() {
	my $q;
	if($_[0] !~ /\w+/){
		my $num_qs = @questions;
		$q = $questions[int(rand($num_qs))];
	}else{
		$q = $_[0];
	}
	my ($question, $answer) = &{$q}();
	print "$question\n\t";
	if ($cheatmode != 0){say ($answer)};
	my $guess = <STDIN>;
	if ($guess == $answer){
		return ("correct", $q);
	}else{
		return ($answer, $q);
	}
}

# Writes progress data to file.
sub simple_progress(){
	$granular_data = $mathsDir."/".$granular_data;
	$aggregate_data = $mathsDir."/".$aggregate_data;
	foreach($granular_data, $aggregate_data){
		unless(-e $_){
			`touch $_`;
		}
	}

	unless (-d $mathsDir){
		`mkdir -p $mathsDir`
	}

	
	unless (-w $granular_data){
		warn "Granluar data file $granular_data not writeable. No detailled stats for you\n";
	}else{
		open (F,">>$granular_data");
		foreach(@stats){
			print F $_."\n";
		}
	}

	unless (-w $aggregate_data){
		warn "Summary data file $aggregate_data not writeable. No summarised stats for you\n";
	}else{
		open (F,">>$aggregate_data");
		print F "$w\t$count\t$pc\t$time\n";
	}

	`scp $mathsDir/* $user@$server:$destinationDir`;
}


## Utility  Subs ##
# # # # # # # # # #

## Returns a positive arbitrary integer. Accepts range as an argument
## if no range supplied, defaults to 10.
sub positive_rand() {
	my $range = shift;
	if (!$range) {$range == 10;}
	my $return = 0;
	while ($return == 0){
		$return = int(rand($range));
	}
	return $return;
}

## Returns an arbitrary nonzero integer between -$range and +$range
## where $range is supplied as an argument and defaults to 
## positive_rand()'s default.
sub nonzero_rand() {
	my $range = shift;
	my $sign = int(rand(10));
	my $int = &positive_rand($range);
	if ($sign < 5){
		return (0-$int);
	}else{
		return $int;
	}
}


sub usage() {

	say $0;
	say "USAGE";
	say "\t$0 [number of questions] [subject]";
	say "";
	say "If no number is supplied, I'll go on forever, and there's\nno way of telling me to quit in a way that records your progress\n";
	print "Available subjects:\n";
	foreach (@questions){
		print "\t$_\n";
	}
	exit 1;

}

sub last_score() {
	open(F, $record_file)
	  or return 1;
	my $last_line;
	while(<F>){
		$last_line = $_;
	}
	return (split(/\s/, $last_line))[2];
}


sub exit {
	$time = time() - $start_time;
	$pc = ($score/$count)*100;

	say "You did $count questions in $time seconds"; 
	say "You scored $pc%";

	&simple_progress($count, $pc, $time);
	print "exiting...\n";
	exit 0;

}

sub welcome{
	say "Welcome to Avi's Magical Q+A thingy. You will be answering questions on:\n";
	foreach(@questions){
		print "\t";
		my $subject = $_;
		$subject =~ s/_/ /g;
		say $subject;
	}
	say "\nRemember, all answers are rounded DOWN. That is, truncated to the decimal";
	say "point. 24.7 = 24.";
}
