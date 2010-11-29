#! /usr/bin/perl
package Questions;
#use Questions::Uitils;
use Math::Trig;
use strict;
#use diagnostics;
use 5.010;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $subject = shift;
	my $self  = {};
	bless ($self, $class);
	return $self;
}



### World War Two
	package WWII;
	sub new{
		my $proto = shift;
		my $class = ref($proto) || $proto;
		my $subject = shift;
		my $self  = {};
		bless ($self, $class);
		return $self;
	}
	
	sub question() {
		return "When did WWII begin?\n";
	}
	
	sub answer() {
		my $self = shift;
		my $guess = shift;
		if ($guess =~ /1939/){
			return "yes\n";
		}else{
			return "no\n";
		}
	}

### Coordinate Geometry
package CoordinateGeometry;
#use base qw(Questions);
#use Questions::Utils;
	sub new{
		my $proto = shift;
		my $class = ref($proto) || $proto;
		my $self  = {};
		my $range = 100;
		$self->{x1} = int(rand($range));
		$self->{y1} = int(rand($range));
		$self->{x2} = int(rand($range));
		$self->{y2} = int(rand($range));
		$self->{questionType} = int(int(rand($range)));
		

		bless ($self, $class);
		return $self;
	}

	sub question(){
		my $self = shift;
		if($self->{questionType} > 50){
			return "Find the midpoint of ($self->{x1},$self->{y1}) and ($self->{x1},$self->{y1}).\n";
		}else{
                       	return "Find the distance between ($self->{x1},$self->{y1}) and ($self->{x2},$self->{y2}).\n";
		}
	}
	
	sub answer(){
		my $self = shift;
		my $guess = shift;
		if($self->{questiontype} > 50){
			my $answer_x = int (($self->{x1}+$self->{x2})/2);
			my $answer_y = int (($self->{y1}+$self->{y2})/2);
			if ($guess =~ /$answer_x,$answer_y/){
				return "Correct! $guess = $answer_x,$answer_y\n";
			}else{
				return "Wrong! $guess != $answer_x,$answer_y\n";
			}
      		}else{		
			my $x_len = $self->{x2} - $self->{x1};
			my $y_len = $self->{y2} - $self->{y1};
			my $answer = int ( sqrt( ($y_len**2) + ($x_len**2)));
			if ($guess != $answer){
				return "Wrong! $guess != $answer\n";
			}else{
				return "correct! $guess == $answer\n";
			}
		}
	}

package Differentiation;
#use base qw(Questions);
	sub new{
		my $proto = shift;
		my $self = {};
        	my $class = ref($proto) || $proto;
		# Coefficients:
		my $range=10;
		$self->{a}=int(rand($range));
		$self->{b}=int(rand($range));
		$self->{c}=int(rand($range));
	
		# Indicies:
		$range=4;
		$self->{p}=int(rand($range));
		$self->{q}=int(rand($range));
		$self->{r}=int(rand($range));

		# X:
		$range=5;
		$self->{x}=int(rand($range));
		bless($self, $class);
		return $self;
	}
	sub question(){
		my $self = shift;
		my $equation = $self->{a} . "X^" . $self->{p} . " + " . $self->{b} . "X^" . $self->{q} . " + " . $self->{c} . "X" . $self->{r};
		return "Solve dy/dx for ".$equation." where X = $self->{x}";
#		return "Solve dy/dx for ".$a."X^".$p." + ".$b."X^".$q." + ".$c."X^".$r."where X = $x\n";
	}
	sub answer(){
		my $self = shift;
		my $guess = shift;
		$guess = sprintf("%.2f", $guess);

		my $a = $self->{a};
		my $b = $self->{b};
		my $c = $self->{c};
		my $p = $self->{p};
		my $q = $self->{q};
		my $r = $self->{r};
		my $x = $self->{x};


		my $answer = ($p*$a * ($x ** ($p-1)));
		$answer = $answer + ($q*$b * ($x ** ($q-1)));
		$answer = $answer + ( $r*$c * ($x ** ($r-1)));
		$answer = sprintf("%.2f", $answer);
		
		if($guess != $answer){
			return $answer;
		}else{
			return;
		}
	}



package Radians;
	use Math::Trig;
	sub new() {
		my $proto = shift;
		my $class = ref($proto) || $proto;
		my $subject = shift;
		my $self = {};
		bless ($self, $class);
		return $self;

		$self->{questiontype} = rand(!00);
	}

	sub quesition() {
		my $self = shift;
		given($self->{questiontype}){
			when ($_ < 25){
				# Find area of sector
        	                $self->{r} = int(rand(100));
                	        $self->{theta} = int(rand( 2 * pi ));
				return "A circle has radius $self->{r}. Find the area of a sector of angle $self->{theta}rad";
                	}
			when (($_ >= 25) && ($_ < 50)){	
				# Find length of arc
				$self->{r} = int(rand(2 * pi));
				$self->{theta} = int(rand(2 * pi));
                        	return "A circle has radius $self->{r}, find the length of the arc of angle $self->{theta}rad";
			}
			when (($_ >= 50) && ($_ < 75)){
				# degs rads:
				$self->{theta} = int(rand((2 * pi)));
				return "express $self->{theta}rad in degrees";
			}
			default{
				# rads degs
				$self->{theta} = int(rand(360));
			}

		}
	}
	
	sub answer() {
		my $self = shift;
		my $guess = shift;
		$guess = sprintf("%.2f", $guess);
		my $answer;
		given($self->{queistiontype}){
			when ($_ < 25){
				$answer = ($self->{r} * $self->{r} * $self->{theta})/2;
				$answer = sprintf("%.2f", $answer);
			}
			when (($_ >= 25) && ($_< 50)){
				$answer = $self->{r} * $self->{theta};
				$answer = sprintf("%.2f", $answer);
			}
			when (($_ >= 50) && ($_ < 75)){
				$answer = ($self->{theta} / 360) * ( 2 * pi );
				$answer = sprintf("%.2f", $answer);
			}
			default{
				$answer = ($self->{theta} / (2 * pi )) * 360;
				$answer = sprintf("%.2f", $answer);
			}
		}
		if ($guess != $answer){
			return $answer;
		}else{
			return;
		}
	}

package SequencesAndSeries;
	sub new() {
		my $proto = shift;
		my $class = ref($proto) || $proto;
		my $subject = shift;
		my $self = {};
		$self->{a} = int(rand(100));
		$self->{r} = 2 + int(rand(8));
		$self->{n} = 3 + int(rand(8));
		$self->{terms} = [];
		$self->{terms}[0] = $a;
		my $i;
		for($i = 1; $i<5; $i++){
			$self->{terms}[$i] = $self->{terms}[$i-1] * $self->{r};
		}
		bless ($self, $class);
		return $self;
	}

	sub question(){
		my $self = shift;
		my $question = "Find the $self->{n} th term of the series\n\t";
		foreach (@{$self->{terms}}){
			$question.=" $_ ";
		}
		return $question;
	}

	sub answer(){
		my $self = shift;
		my $guess = shift;
		$guess = sprintf("%.2f", $guess);
		my $answer = $self->{a} * ($self->{r}**($self->{n}-1));
		$answer = sprintf("%.2f", $guess);

		if ($answer != $guess){
			return $answer;
		}else{
			return;
		}
	}	






































return 1;
