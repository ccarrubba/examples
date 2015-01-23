#!/usr/bin/perl -w

# The MIT License (MIT)

# Copyright (c) 2014 University of Geneva

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

#Date:	    13.10.2014
#Author:	Stéphane Zwahlen
#Goal:      This script is used to clean up and format data retrieved by p0_fetch_HEP_records.pl

use strict;
use warnings;

my $line;
my $no_notice ="";
my $no_notice2 ="";
my $txt;

open IN, '<', 'HEP_records_raw.marc' || die ("$!") ;
open OUT,'>', 'HEP_records_clean.marc' || die "$!" ;

while ($line = <IN>) {
	if ($line =~ /^./) {             #ignore empty lines
		$line =~ s/ 0247./ 024 7/;      #transform 0247 into 024 7
		$line =~ s/\$\$(.)/ \$$1 /g;    #transform $$ in $ 
		$line =~ tr/_/ /;               #delete underscores
		$no_notice = substr($line,0,9);
		$txt = substr($line,10,);
			if($no_notice ne $no_notice2 && $no_notice2 eq "") {
			print OUT "<record>\n".'001    $a '.$no_notice."\n";#start of
			print OUT $txt;
			$no_notice2 = $no_notice;		
		} elsif($no_notice ne $no_notice2) {
			print OUT "</record>\n<record>\n".'001    $a '.$no_notice."\n";#every successive records
			print OUT $txt;
			$no_notice2 = $no_notice;		
		} else {
			print OUT $txt;
		}
	}
}
print OUT "</record>\n";#last
