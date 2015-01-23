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

# Date:     13.10.2014
# Author:   Stéphane Zwahlen, University of Geneva, Switzerland
# This script fetchs records from inSPIRE HEP
# You will be prompted with some questions. An output files will be created in your directory
# with the retrieved records. Records are fetched 250 by 250. 
# Warning:  Retrieving data for the current year is not precise at all


use strict;
use warnings;
use LWP::Simple;
use URI::URL;

# Name of the output file into which records will be appended
open OUT,'>>', 'HEP_records_raw.marc' or die "$!";

# Interaction with the user
print "Enter the lower year of the date range (YYYY): "; # First year definition
my $year_start = <>;
chomp $year_start;

print "Enter the upper year of the date range (YYYY): "; # Last year definition
my $year_end = <>;
chomp $year_end;

print "Enter the two letters country code: "; # country definition
my $country = <>;
chomp $country;

print "Enter the total number of records: "; # Max number of records
my $max_rec = <>;
chomp $max_rec;

# Start of the loop fetching 250 records at a go
if ($year_start =~ "." && $year_end =~ "." && $country =~ "."){#control for all the insert data, with an error message if something miss
	my $url = "http://inspirehep.net/search?in=en&p=find+cc+".$country."+and+date%3C".$year_end."+and+date%3E".$year_start."&ot=024,037,245,246,260,700,773&of=t&action_search&action_search=search&sf=year&so=a&rm=&rg=250&sc&sc=0"; #Variables are from <IN>, we use API function ot= to define the Marc fields and of=t to select the form text without <...> http://invenio-demo.cern.ch/help/hacking/search-engine-ap
	print $url."\n";#to check on screen
	my $hep = get($url);
	print OUT $hep."\n";

	for (my $jrec = 250; $jrec <= $max_rec; $jrec += 250 ){#use jrec= to call all the search results
		my $url1 = "http://inspirehep.net/search?in=en&p=find+cc+".$country."+and+date%3C".$year_end."+and+date%3E".$year_start."&ot=024,037,245,246,260,700,773&of=t&action_search&action_search=search&sf=year&so=a&rm=&rg=250&jrec&jrec=".$jrec."&ln=en&so=a&sf=year";
		print $url1."\n";#to check on screen
		my $pages = get($url1);
		print OUT $pages."\n";		
	}
} else {
	print "Empty data, check please ! /n";  #prints when an information is missing
}