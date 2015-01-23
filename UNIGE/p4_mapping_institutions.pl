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

open IN,'<', 'data_affiliations.txt'  or die "$!" ;

my %tab;
my $key;
my $i;
my $rec;
my $flag;
my $notice;

# Parcours du fichier et création d'un tableau
while (my $ligne = <IN>) {
  chomp $ligne;
  $tab{$ligne} = "1";
}

while (my $line = <STDIN>) {
    # Début de la notice
    if ($line =~ /^<record>/) {
        $notice = $line;
        $rec = 1;
        $flag = 0;
    } elsif ($line =~ /^<\/record>/) {
        $notice .= $line;
        $rec = 0;
    } elsif ($line =~ /^10/ || $line =~ /^70/) {
        foreach $key (keys %tab) {
            if ($line =~ /$key/) {
                $flag = 1;
                $notice .= $line;
                last;
            }
        }
    } else {
        $notice .= $line;
    }

# Only records with recognised affiliation are printed
  if ($rec == 0)
    {
    if ($flag == 1)
      {
      $i++;
      print $notice;
      }
    $flag = 0;
    }
}