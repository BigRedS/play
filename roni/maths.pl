#! /usr/bin/perl

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#		Avi's Wonderful q+a Thingy			#
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



#use strict; 	# I know, I know. But &{$subName}() doesn't work
		# in strict, and I just need to make it work. I 
		# promise I'll modify it to work in strict. 
use 5.010;

## subs implementing questions must be a member of this array:
my @questions = ("differentiation", "test");

&usage if ($ARGV[0] =~ /\D/);

my $num = $ARGV[0];
my $subject = undef;
if ($ARGV[1]){
	$subject = $ARGV[1];
}

&quiz ($num); 

## These are the question subs:

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

sub test(){
	my $question = "Life, the universe and everything?";
	my $answer = 42;
	return ($question, $answer);
}

## Worker Subs ##
# # # # # # # # #

sub quiz(){
	my $num = shift;
	my ($count, $score) = (0,0);
	my $time = time();
	for ($count = 1; $count <= $num; $count++){
		print "$count)\t";	
		my $q = &ask_question();

		if($q =~ /correct/ ){
			$score++;
			say "\tCorrect!";
		}else{
			say "\tNope:";
		}
	}
	$count--;
	$time = time() - $time;
	say "\n\nYou tried $count questions, got $score correct and spent $time seconds doing it.";
	$pc = ( $score / $count  ) * 100;
	say "Pointless accuracy:".$pc."%";
	&simple_progress($count, $pc, $time);
}

sub simple_progress(){
	my $count = shift;
	my $pc = shift;
	my $time = shift;
	
	my $record_file = "./.maths.data";
	unless (-e $record_file){
		qx(touch $record_file);
	}
	unless (-w $record_file){
		warn("Could not write progress data. \$record_file appears to not be readale at $record_file");
	}
	my ($year, $month, $day, $hour, $min, $sec) = (localtime())[5,4,3,2,1,0];
	my $year += 1900;
	my $now = "$year-$month-$day+$hour:$min:$sec";
	open (F,">>$record_file")
	 or warn("Could not open $record_file for appending, but it passed the writable test. If you see this error, something's fucked");
	say  F "$now\t$count\t$pc\t$time";
	close F;
}

## This sub picks a question at random, asks it, and prompts
## for an answer. It returns true if the answer is correct, 
## false (well, undef) otherwise.
sub ask_question() {
	my $q;
	if($_[0] !~ /\w+/){
		my $num_qs = @questions;
		$q = $questions[int(rand($num_qs))];
	}else{
		$q = $_[0];
	}
#	my ($question, $answer) = &{$q}();
	my ($question, $answer) = &differentiation;
	say $question;
	say "($answer)";
	my $guess = <STDIN>;
	if ($guess == $answer){
		say "Correct";
		return "correct";
	}else{
		say "er... expected $answer";
		return $answer;
	}
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
