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

my $rec;
my $flag;
my $notice;
my $titre;

# Les titres SCOAP3 sont entrés dans un tableau avec la valeur A pour les titres avec 100% d'articles payés
# et la valeur B pour les autres titres partiellement HEP (< 60% d'articles en HEP)
my %tab = (
    'Acta Phys.Polon.B'=>'B',
    'Adv.High Energy Phys.'=>'A',
    'Chin.Phys.C'=>'B',
    'Eur.Phys.J.C'=>'A',
    'JCAP'=>'B',
    'JHEP'=>'A',
    'New J.Phys.'=>'A',
    'Nucl.Phys.B'=>'A',
    'Phys.Lett.B'=>'A',
    'Phys.Rev.C'=>'B',
    'Phys.Rev.D'=>'A',
    'Prog.Theor.Phys.'=>'B',
    'null'=>'null');

while (my $line = <STDIN>) {
    # Début de la notice
    if ($line =~ /^<record>/) {
        $notice = $line;
        $rec = 1;
        $flag = 0;

    } elsif ($line =~ /^<\/record>/) {
        $notice .= $line;
        $rec = 0;

    } elsif ($line =~ /^037/ && $line =~ /\$c hep/) {
        $notice .= $line;
        $flag = 1;

    } elsif ($line =~ /^773.*\$p (.*?) \$/) {
        $notice .= $line;
        # Extraction du titre
        $titre = $1;
        if (exists $tab{$titre}) {  # Exclusion des titres non-SCOAP3

            # Articles du groupe A sont conservés
            if ($tab{$titre} eq "A") {
                $flag = 2;

            # Articles du groupe B avec HEP en 037 sont conservés
            } elsif ($tab{$titre} eq "B" && $flag == 1) {
                $flag = 2;

            # Articles du groupe B non HEP sont ignorés
            } else {
                $flag = 0;

            }
        }

    } else {
        $notice .= $line;
    }


# Sortie
  if ($rec == 0)
    {
    if ($flag == 2)
      {
      print $notice;
      }
    $flag = 0;
    }
}
