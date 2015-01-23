#!/usr/local/bin/perl

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

# Auteur : Jean-Blaise Claivaz
# Date : Septembre 2014

use strict;
use warnings;

open OUT1, '>', 'inspire-g-2011.marc';
open OUT2, '>', 'inspire-g-2012.marc';
open OUT3, '>', 'inspire-g-2013.marc';

my $annee;
my $i;
my $i1;
my $i2;
my $i3;
my $rec;
my $flag;
my $notice;
my $tab1;
my $tab2;
my $tab3;

while (my $line = <STDIN>) {
    # Début de la notice
    if ($line =~ /^<record>/) {
        $notice = $line;
        $rec = 1;
        $flag = 0;

    } elsif ($line =~ /^<\/record>/) {
        $notice .= $line;
        $rec = 0;
        if ($annee == 2011) {   # Stockage des notices dans des variables par année
            $i1++;
            $tab1 .= $notice;
        } elsif ($annee == 2012) {
            $tab2 .= $notice;
            $i2++;
        } elsif ($annee == 2013) {
            $tab3 .= $notice;
            $i3++;
        }

    # Test sur l'année de publication
    } elsif ($line =~ /^773/) {
        $notice .= $line;
        $line =~ /\$y (\d\d\d\d)/;
        $annee = $1;

    } else {
        $notice .= $line;
    }
}

print OUT1 $tab1;
print OUT2 $tab2;
print OUT3 $tab3;

close OUT1;
close OUT2;
close OUT3;

$i = $i1 + $i2 + $i3;
print "Notice 2011 : $i1\nNotice 2012 : $i2\nNotice 2013 : $i3\nTotal : $i\n";