#!/usr/bin/perl


my @x = ("A=B","AAAA=/");
utf8::upgrade $_ for @x;
$x[1] =~ s{/\s*$}{};
for (@x) {
m{^([^=]+?)\s*=.+$};
}