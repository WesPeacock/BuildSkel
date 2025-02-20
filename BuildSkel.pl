#!/usr/bin/env perl
my $USAGE = "Usage: $0 [--inifile inifile.ini] [--section section] [--recmark lx] [--eolrep #] [--reptag __hash__] [--help] [--debug] [file.sfm]";
=pod
This script is a stub that provides the code for opl'ing and de_opl'ing an input file
It also includes code to:
	- use an ini file (commented out)
	- process command line options including debugging

The ini file should have sections with syntax like this:
[section]
Param1=Value1
Param2=Value2

=cut
use 5.020;
use utf8;
use open qw/:std :utf8/;

use strict;
use warnings;
use English;
use Data::Dumper qw(Dumper);


use File::Basename;
my $scriptname = fileparse($0, qr/\.[^.]*/); # script name without the .pl
use Getopt::Long;
GetOptions (
	'inifile:s'   => \(my $inifilename = "$scriptname.ini"), # ini filename
	'section:s'   => \(my $inisection = "BuildSkel"), # section of ini file to use
# additional options go here.
# 'sampleoption:s' => \(my $sampleoption = "optiondefault"),
	'recmark:s' => \(my $recmark = "lx"), # record marker, default lx
	'eolrep:s' => \(my $eolrep = "#"), # character used to replace EOL
	'reptag:s' => \(my $reptag = "__hash__"), # tag to use in place of the EOL replacement character
	# e.g., an alternative is --eolrep % --reptag __percent__

	# Be aware # is the bash comment character, so quote it if you want to specify it.
	#	Better yet, just don't specify it -- it's the default.
	'help'    => \my $help,
	'debug'       => \my $debug
	) or die $USAGE;

if ($help) {
	say STDERR $USAGE;
	say STDERR "A script that builds skeleton fields for each SFM record. One skeleton field contains a list of all of the SMFs and the other contains some of the SFMs.";
	exit;
	}

say STDERR "recmark:$recmark" if $debug;
# check your options and assign their information to variables here
$recmark =~ s/[\\ ]//g; # no backslashes or spaces in record marker

# if you do not need a config file ucomment the following and modify it for the initialization you need.
# if you have set the $inifilename & $inisection in the options, you only need to set the parameter variables according to the parameter names
# =pod
use Config::Tiny;
my $config = Config::Tiny->read($inifilename, 'crlf');
die "Quitting: couldn't find the INI file $inifilename\n$USAGE\n" if !$config;
say STDERR "Section mark:$inisection" if $debug;
my $fieldmarks = $config->{"$inisection"}->{fieldmarks};
say STDERR "Field marks before cleanup:$fieldmarks" if $debug;
for ($fieldmarks) {
	# remove backslashes and spaces from the SFMs in the INI file
	say STDERR $_ if $debug;
	$fieldmarks =~ s/\\//g;
	$fieldmarks =~ s/ //g;
	$fieldmarks =~ s/\,*$//; # no trailing commas
	$fieldmarks =~ s/\,/\|/g;  # use bars for or'ing
	}
say STDERR "Fieldmarks after cleanup:$fieldmarks" if $debug;
my $srchFieldmarks = qr/$fieldmarks/;
say STDERR "Fieldmarks RE after cleanup:$srchFieldmarks" if $debug;


# =cut

# generate array of the input file with one SFM record per line (opl)
my @opledfile_in;
my $line = ""; # accumulated SFM record
while (<>) {
	s/\R//g; # chomp that doesn't care about Linux & Windows
	#perhaps s/\R*$//; if we want to leave in \r characters in the middle of a line
	s/$eolrep/$reptag/g;
	$_ .= "$eolrep";
	if (/^\\$recmark /) {
		$line =~ s/$eolrep$/\n/;
		push @opledfile_in, $line;
		$line = $_;
		}
	else { $line .= $_ }
	}
push @opledfile_in, $line;

for my $oplline (@opledfile_in) {
# Insert code here to perform on each opl'ed line.
# Note that a next command will prevent the line from printing

say STDERR "oplline before skel:", Dumper($oplline) if $debug;
my $skel =$oplline;
$skel =~ s/[^#]\\//g;
$skel =~ s/#/ /g;
my @skel_array = split (" ", $skel);

for my  $skel_item (@skel_array) {
	$skel_item =~ s/^[^\\].*//;
	}
$skel=join(" ",@skel_array);
$skel =~ s/ +/ /g;
$skel =~ s/\\//g;
$skel =~ s/\ $//;
# say "SKEL:$skel";
$oplline =~  s/#/#\\skel_all $skel#/;
@skel_array = split (" ", $skel);
for my  $skel_item (@skel_array) {
	if (! ($skel_item =~ m/^$srchFieldmarks$/)) {
		$skel_item ="";
		}
	}
$skel=join(" ",@skel_array);
$skel =~ s/ +/ /g;
$skel =~ s/\ $//;
$oplline =~  s/#/#\\skel_part $skel#/;

say STDERR "oplline:", Dumper($oplline) if $debug;
#de_opl this line
	for ($oplline) {
		s/$eolrep/\n/g;
		s/$reptag/$eolrep/g;
		print;
		}
	}
