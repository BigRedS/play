#! /usr/bin/perl

use 5.010;

my $max = $ARGV[0];
my $correct = 0;

for ($i = 0; $i < $max; $i++){
	my ($question, $answer) = &differentiation();
	print $i+1;
	say "\t$question";
	my $guess = <STDIN>;
	if ( $guess == $answer ){
		print "whoop!\n";
		$correct++;
	}else{
		print "Nope - expected: $answer";
	}
	say "";
}

say "Attempted $i questions, got $correct correct";
$pc = ($correct/$i) * 100;
say "Needlesly sort-of-acccurate score: $pc %";

sub differentiation(){
        my ($a, $b, $c, $p, $q, $r, $x);

        # Generate three coefficients
        my $range = 10; ## Max. value of coefficient
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
        ## you can fiddle with the 
        my $sign = int(rand(1));
        my $int = &positive_rand($range);
        if ($sign == 0){
                return (0-$int);
        }else{
                return int;
        }
}

