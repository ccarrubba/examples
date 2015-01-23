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

print "Enter the year to process: ";
my $annee = <STDIN>;
chomp $annee;

open IN,'<', 'data_affiliations.txt'  or die "$!" ;

my %tab;    # Stockage des affiliations pour les tests
my %tab2;   # Comptage du nombre de notice
my %tab3;   # Stockage des notices
my $key;
my $value;
my $i;
my $notice;
my $flag;

# Parcours du fichier et création d'un tableau
while (my $ligne = <IN>) {
  chomp $ligne;
  $tab{$ligne} = "0";
  $tab2{$ligne} = "0";
  $tab3{$ligne} = "";
}

close IN;

my $fichier = 'inspire-g-'.$annee.'.marc';
open ANNEE, '<', "$fichier" or die "$!";

while (my $line = <ANNEE>) {
    # Début de la notice
    if ($line =~ /^<record>/) {
        $notice = $line;

    # A la fin de la notice, test des affiliations apparues
    } elsif ($line =~ /^<\/record>/) {
        $notice .= $line;
        while (($key, $value) = each(%tab)) {
            if ($value > 0) {
                $tab{$key} = "0";
                $tab2{$key}++;
                $tab3{$key} .= $notice;
            }
        }
    
    # Pour chaque auteur, on test l'affiliation qui peut être multiple
    } elsif ($line =~ /^10/ || $line =~ /^70/) {
        $notice .= $line;
        $line =~ s/U. Bern, AEC/Bern U./;
        $line =~ s/IPT, Lausanne/Ecole Polytechnique, Lausanne/;
        $line =~ s/LPHE, Lausanne/Ecole Polytechnique, Lausanne/;
        $line =~ s/Zurich-Irchel U./Zurich U./;
        foreach $key (keys %tab) {
            if ($line =~ /$key/) {
                $tab{$key}++;
            }
        }

    } else {
        $notice .= $line;
    }
}
close ANNEE;

# Impression du décompte
my $out = "inspire-o-decompte-".$annee.'.txt';
open OUT, "> $out" or die "$!";

foreach $key (sort keys %tab2) {
    if ($tab2{$key} > 0) {
        print OUT $key."\t".$tab2{$key}."\n";
    }
}
close OUT;

my $a_ba = "inspire-rec-UNIBA-".$annee.'.marc';
my $a_be = "inspire-rec-UNIBE-".$annee.'.marc';
my $a_ep = "inspire-rec-EPLF-".$annee.'.marc';
my $a_ge = "inspire-rec-UNIGE-".$annee.'.marc';
my $a_vd = "inspire-rec-UNIL-".$annee.'.marc';
my $a_ps = "inspire-rec-PSI-".$annee.'.marc';
my $a_zh = "inspire-rec-UZH-".$annee.'.marc';
my $a_et = "inspire-rec-ETHZ-".$annee.'.marc';

open UNI1, "> $a_ba" or die "$!";
open UNI2, "> $a_be" or die "$!";
open UNI3, "> $a_ep" or die "$!";
open UNI4, "> $a_ge" or die "$!";
open UNI5, "> $a_vd" or die "$!";
open UNI6, "> $a_ps" or die "$!";
open UNI7, "> $a_zh" or die "$!";
open UNI8, "> $a_et" or die "$!";

while (($key, $value) = each(%tab3)) {
    if ($key eq "Basel U.") {
        print UNI1 $value;
    } elsif ($key eq "Bern U.") {
        print UNI2 $value;
    } elsif ($key eq "Ecole Polytechnique, Lausanne") {
        print UNI3 $value;
    } elsif ($key eq "Geneva U.") {
        print UNI4 $value;
    } elsif ($key eq "Lausanne U.") {
        print UNI5 $value;
    } elsif ($key eq "PSI, Villigen") {
        print UNI6 $value;
    } elsif ($key eq "Zurich U.") {
        print UNI7 $value;
    } elsif ($key eq "Zurich, ETH") {
        print UNI8 $value;
    }
}

close UNI1;
close UNI2;
close UNI3;
close UNI4;
close UNI5;
close UNI6;
close UNI7;
close UNI8;
