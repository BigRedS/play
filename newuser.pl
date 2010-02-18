#! /usr/bin/perl

use strict;
use warnings;
unless ($ARGV[3]){&usage()}
my ($uname, $email, $firstname, $surname) = @ARGV[0, 1, 2, 3];

## I use this script to add users on my server. It basically runs useradd and groupadd
## with some degree of error checking and all my favourite configurations. It also creates
## an apache vhost and applies the changes.
## It's not a smart script - if anything happens that's not exactly right, it errors and 
## exits. But it's only got a pretty simple job to do, so there's not much to go wrong.
## This script has two exit values - zero and non-zero. Zero means everything went swimmingly
## non-zero means you got something wrong. I like to think the error messages are quite useful.


##########################################################################################
##					Configuration!					##

	## Users' FTP dir:
	my $ftp_dir = "/srv/ftp/".$uname."/";

	## The group the FTP server runs as, used to ensure the
	## FTP daemon can read and write to users' FTP dir
	my $ftp_group = "ftp";

	## This is the lowest UID from the range you want to make
	## available for users
	## UIDs are generated as the lowest free number above this one:
	my $uid_start = 10001;	

	## User's shell. I don't check if it exists:
	my $shell = "/bin/bash";

	## Define arrangement of GECOS field:
	## You want to get the firsname and surname right to get the from:
	## name in emails right. I use the second field for a contact email
	## to warn of impending doom.
	my $gecos_field = "$firstname $surname, $email";

	## Command to restart apache:
	my $restart_apache = "/etc/init.d/apache2 restart";

## To configure the Apache VHost creation, see the top of the sub vhost() at the bottom 
## of this file.

##########################################################################################
##					Thinking!					##

## Warn that 'test' is not a good idea as a username:
if ($uname =~ /^test$/){
	&warn("Test is not a good idea for a username. It is used for general testing, and so gets broken a lot.");
}

## Check whether uname is already in use:
if(getpwnam($uname)){&error("User with name $uname already exists.")}

## New UID should be the lowest available above the number specified
## by $uid_start. Since we'd like this to be the same as the gid,
## we'll check that, too.
while(getpwuid($uid_start) || getgrgid($uid_start)){
	$uid_start++;
}
my $uid = $uid_start;
my $gid = $uid_start;

## If there's already a group with the same name as the user, we'll 
## add them to that group instead of creating a new one:

if(getgrnam($uname)){
	warn("Group with name $uname already exists. New user will be a member of this group");
	$gid = (getgrnam($uname))[2];
}

## create group:
my $cmd = "groupadd $uname -g $gid";
&cotdeath($cmd);

## Generate password:
$cmd = "makepasswd --crypt";
my $password = &cotdeath($cmd);
my ($password_clear, $password_crypt) = (split(/\s+/, $password))[0,1];


## Create user:


$cmd = "useradd -g $gid -u $uid -m -p $password_crypt -s $shell -c \"$gecos_field\" $uname";
#system($cmd);
&cotdeath($cmd);

## Create Vhost
if ($ARGV[4]){
	&vhost($ARGV[4], $uname)
}



## Create FTP dir:
my $ftp_gid = (getgrnam($ftp_group))[2];
mkdir $ftp_dir, 751;
chown $uid, $ftp_gid, $ftp_dir;

print "username\t".$uname."\n";
print "password\t".$password_clear."\n";


## Subroutines live down here:

sub usage() {
	print "Usage:\n";
	print "  newuser USERNAME EMAIL FIRSTNAME SURNAME [URL] \n";
	print "If URL is not supplied, no Vhost is configured.\n";
	exit 1;
}

sub error() {
	my $error_message = $_[0];
	print "Error: $error_message \n";
	exit 1;
}

sub warn() {
	my $message = $_[0];
	print "Warning: $message\n";
}

## This sub executes another command, and responds to its exit value.
## The name's historical from when it just checked how children died.
sub cotdeath() {
	my $command = $_[0];
	my $command_name = (split(m/ /, $command))[0];
	my $return = `$command 2>&1`;
	if ($? != 0 && !$_[1]){
		print "Error: $command_name died with value $?\n";
		print "\t$command\n";
		exit $?;
	}
	return $return;
}

## This sub configures the apache VHost. It's very basic.
 
sub vhost() {
	my ($url, $username) = @_[0,1];
	
	## Directory containing site config files:
	my $vhost_dir = "/etc/apache2/sites-available";
	my $vhost_file = $vhost_dir."/".$url;

	## Document root of the site we're creating. Generally the  
	## directory defined in the mod_UserDir conf, normally either
	## ~/public_html or ~/www.
	my $document_root = "/home/".$username."/www/";
	
	## Path to write user's own log files to. You might not want
	## this.
	my $log_path = "/home/".$username."/.log/apache.log";

	## Command to 'enable' a site called $url in sites-enabled. 
	## Lots of distributions provide a2ensite for this, but this
	## just symlinks .../sites-enabled/$url to .../sites-available/$url
	my $a2ensite = "a2ensite $url";

	## End Config ##

	if ($url =~ /\//){
		&error("URL contains forward slashes. It shouldn't. The url should contain no more than a subdomain, a domain and a tld.");
	}

	## Create the log file for apache's benefit:
	open (L, ">>$log_path") || &error("Couldn't open users' apache log file at $log_path for writing");
		print L " ";
	close L;
	

	## The host file might already exist, in which case we do not want to overwrite it.
	if ( -e $vhost_file){
		open (F, ">>$vhost_file") || &error("Couldn't open vhost file at $vhost_file for appending");
		&warn("Configuration already exists for $url. \n\t I will append this configuration to $vhost_file, \n\t but the current configuration will take precedence.\n\t I suggest you manually edit the file.");
	}else{
		open (F, ">$vhost_file") || &error("Couldn't open vhost file at $vhost_file for writing");
	}
	
	print F << "_EOF_";
<VirtualHost *:80>
	ServerName $url
	DocumentRoot $document_root
	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined
_EOF_
	if ($log_path){	print F "\tCustomLog $log_path combined\n\n" }
	print F << "_EOF_";
</VirtualHost>

<VirtualHost *:80>
	Servername www.$url
	DocumentRoot $document_root
	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined
_EOF_
	if ($log_path){ print F "\tCustomLog $log_path combined\n\n" }
	print F "</virtualhost>";

	close F;

	## Check sanity of apache config files, and reload apache if they're all good:
	&cotdeath($a2ensite);
	my $apache_config = &cotdeath("apache2ctl configtest", "noerror");
	if ($apache_config =~ /OK$/){
		&cotdeath($restart_apache);
	}else{
		&error("Error in apache config files. Run `apache2ctl configtest` to find out what");
	}
}

exit 0;
