#!perl -w

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
# This script removes unused MARC fields, makes special treatments on DOI (MARC = 024) and journal titles (MARC = 773)
# and sorts the MARC fields if needed

use strict;
use warnings;

my $tag;
my $cle;
my %tab;
my @zones;
my $zone;
my $code;
my $txt;
my %tab_zone;

open IN, '<', 'HEP_records_clean.marc' || die ("$!") ;

# Comparaison ligne par ligne du fichier d'entrée
while (my $line = <IN>) {
    if ($line =~ /^<record/) {  # Début d'un record
        print $line;
    } elsif ($line =~ /^<\/record/) { # Fin d'un record -> print des lignes
        foreach $cle (sort keys %tab) {
            print $tab{$cle};
            delete $tab{$cle};
        }
        print $line;

    # Traitement des lignes
    } elsif ($line =~ /^[35689]/ || $line =~ /^035/ || $line =~ /^084/ || $line =~ /^269/ || $line =~ /^710/ || $line =~ /^780/) {
        # Suppression de certaines lignes
        $line = "";

    } elsif ($line =~ /^024 .*DOI/) {
        # Mise en ordre des sous-champs du DOI avec $2 $a, et suppression des autres sous-champs
        @zones = ();
        @zones = split(/\$/, $line); # Découpe la ligne sur les dollars
        shift(@zones);
        foreach my $zone (@zones) {
            chomp $zone;
            $zone =~ s/ $//;
            $code = substr($zone,0,1);
            $txt = substr($zone,2);
            $tab_zone{$code} = $txt;	# Tableau avec les zones
        }
        # Sortie de la ligne propre
        $line = '024 7  $2 '.$tab_zone{'2'}.' $a '.$tab_zone{'a'}."\n";

    } elsif ($line =~ /^773/) {
        if ($line =~ /ibid\./) {
            next(); # Les lignes avec addendum-ibid. ou erratum-ibid. sont ignorées
        } elsif ($line =~ / \$p /) {
            # Mise en ordre des sous-champs $p $v $c $y, suppression des autres sous-champs
            @zones = ();
            @zones = split(/\$/, $line); # Découpe la ligne sur les dollars
            shift(@zones);
            foreach my $zone (@zones) {
                chomp $zone;
                $zone =~ s/ $//;
                $code = substr($zone,0,1);
                $txt = substr($zone,2);
                $tab_zone{$code} = $txt;	# Tableau avec les zones
            }
            # Sortie de la ligne propre
            $line = '773    $p '.$tab_zone{'p'}.' $v '.$tab_zone{'v'}.' $c '.$tab_zone{'c'}.' $y '.$tab_zone{'y'}."\n";
            
            # Traitement des séries
            $line =~ s/Acta Phys\.Polon\. \$v B/Acta Phys.Polon.B \$v /;
            $line =~ s/Chin\.Phys\. \$v C/Chin.Phys.C \$v /;
            $line =~ s/Eur\.Phys\.J\. \$v C/Eur.Phys.J.C \$v /;
            $line =~ s/Nucl\.Phys\. \$v B/Nucl.Phys.B \$v /;
            $line =~ s/Phys\.Lett\. \$v B/Phys.Lett.B \$v /;
            $line =~ s/Phys\.Rev\. \$v C/Phys.Rev.C \$v /;
            $line =~ s/Phys\.Rev\. \$v D/Phys.Rev.D \$v /;
        } else {
            next(); # Les lignes sans $p sont ignorées
        }
    }

    # Toutes les lignes MARC restantes à ce point sont entrées dans un tableau
    if ($line =~ /^\d\d\d/) {
        $tag = substr($line,0,3);
        if (exists($tab{$tag})) {
            $tab{$tag} .= $line;
        } else {
            $tab{$tag} = $line;
        }
    }
}

