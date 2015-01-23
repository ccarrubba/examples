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

my $cle;
my $flag_doi;
my $notice;
my $cle_doi;
my %tab;

while (my $line = <STDIN>) {
    # Début de la notice
    if ($line =~ /^<record>/) {
        $notice = $line;
        $flag_doi = 0;
        $cle_doi = '';
        
    } elsif ($line =~ /^<\/record>/) {
        $notice .= $line;
        if ($cle_doi) {                 # S'il y a une clé -> les notices sans DOI sont supprimées
            $tab{$cle_doi} = $notice;   # La notice est stockée dans un tableau, en écasant un éventuel doublon
        }

    # Utilisation du DOI pour créer un clé
    } elsif ($line =~ /^024/ && $line =~ /DOI/ && $flag_doi == "0") {
        $notice .= $line;
        $flag_doi = 1;
        chomp $line;
        $cle_doi = $line;
        $cle_doi =~ s/ //g;   # création d'une clé pour le tableau des notices

    } elsif ($line =~ /^024/ && $line =~ /DOI/ && $flag_doi == "1") { # Suppression d'un éventuel deuxième DOI
        $flag_doi = 1;

    } else {
        $notice .= $line;
    }
}

foreach $cle (keys %tab) {
    print $tab{$cle};
}