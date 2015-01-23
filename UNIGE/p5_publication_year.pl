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

my $i;
my $rec;
my $flag = 0;
my $notice;
my $annee;

while (my $line = <STDIN>) {
    # Début de la notice
    if ($line =~ /^<record>/) {
        $notice = $line;
        $rec = 1;
        $flag = 0;

    } elsif ($line =~ /^<\/record>/) {
        $notice .= $line;
        $rec = 0;

    # Test
    } elsif ($line =~ /^037/ && $line =~ /\$a arXiv/i) {
        $notice .= $line;

    } elsif ($line =~ /^037/) { # Rien = suppression des champs 037 non arXiv

    } elsif ($line =~ /^773/ && $line =~ /\$p .*\$y \d\d\d\d/) {    # 773 avec un titre et une année
        $notice .= $line;
        $flag = 1;
        $line =~ /\$y (\d\d\d\d)/;
        $annee = $1;
        if ($annee < 2011 || $annee > 2013) {   # Exclusion des notices non 2011-2013
            $flag = 0;
        }

    } else {
        $notice .= $line;
    }


# Sortie
  if ($rec == 0)
    {
    if ($flag == 1)  # Notice avec 773 $p et entre 2011 et 2013
      {
      $i++;
      print $notice;
      }
    $flag = 0;
    }
}
