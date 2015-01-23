Documentation for the scripts developed for Swiss-SCOAP3 project

Institution: University of Geneva
Date: January 2015
Author and contact: Jean-Blaise.Claivaz@unige.ch
Disclaimer: This documentation and the attached scripts are given gracefully to anyone who may find them useful without any warranty as they may contains unintentional typos or errors.


Brief overview

During the autumn 2014, we did a bibliometric analysis of swiss authorship (affiliation) on articles published in high energy physics journals during the years 2011 to 2013. The intention was to calculate the relative importance of swiss institutions in order to prepare a new allocation for the costs of the international SCOAP3 project devoluted to Switzerland.

Data extracted from inSPIRE HEP were found to be the most consistent for this study (compared to those of Elsevier Scirus ou InCites-Web of Science). Starting from raw marc records we ran a number of cleaning treatments. Only clean and highly homogeneous records were kept and all the others were discarded. These options are questionnable but we wanted to be precise AND efficient. This is how We filtered the records :
- obviously, only records with at least one swiss institution mentioned as an author affiliation -> during this check, we simplified the affiliation by merging institutes into the main institution.
- only published articles from 2011 to 2013 (that is only records with "773 $y 2011", "773 $y 2012" or "773 $y 2013")
- must have a least one DOI
- only articles published in the journals participating to the SCOAP3 project
- only articles from the HEP field for journals from the B group (with less than 60% of HEP in content - that means hep must appear in the subject arxiv subject code, in "037 $a")

We looked for affiliations into the records, not considering if an institution appears more than once for an article. We didn't look at the total number of authors for an article as it has been done for other bibliographic studies (particularly the one for the SCOAP3 project).

The result of our work is a two entry table with swiss institutions on one side and the years on the other. The figures represent the number of "articles-affiliated-to-the-institution". The yearly total of those figures are obvioulsy greater than the number of articles as multi-institutions collaboration is frequent in high energy physics.


Description of scripts and files
- p1_fetch_HEP_records.pl
    Must be called without parameters: C:\Your_directory\> perl p1_fetch_HEP_records.pl
    
    Script used to fetch records from inSPIRE HEP API search engine.
    Four parameters will be prompted: lower and upper years for the date range, country code, max records.
    The max number of records should be found first via a web (advanced) search in inSPIRE HEP database.

- p2_clean_1_records.pl
    Must be called without parameters. The script will look for the file created by p1_
    
- p3_clean_2_records.pl
    Must be called with an ouput file name: C:> perl p3_clean_2_records.pl > your_file_name.marc
    
    p2_ and p3_ are needed to clean up and sort MARC field. Only needed metadata are kept.
    
- p4_mapping_institutions.pl
    Must be called with input and output files.
    Need a list of affiliations (in a file called: data_affiliations.txt)
    
    This script filtered out the records not affiliated to one of the institutions mentioned in the accompanying file.

- p5_publication_year.pl
    Must be called with input and output files.
    
    This script filters out the records which are not for article and from 2011 to 2013

- p6_find_duplicates.pl
    Must be called with input and output files.
    
    This script finds duplicates using the DOI. Records without DOI are discarded. If more than one DOI, only the first is considered.

- p7_journal_and_hep.pl
    Must be called with input and output files.
    
    Only articles published in defined journal titles are kept (journals are set into group A and B - see SCOAP3 doc for more information)

- p8_split_by_year.pl
    Must be called with input file name. Output files for every year will be produced
    
    This script splits the records into different files for each year as it was difficult to produce a multi-year table in one go.

- p9_find_figures_by_aff.pl
    Must be call without parameters. User will be prompted for a year.
    
    As is, this script is probably useless for you and must be adapted with your institutions. It produces the final count of articles and create files with records for each institution. This files can be sent to the institutions for them to verify the figures.
