#!/usr/bin/perl

$known_plain = `cat sample.pl`;
$known_cipher_file = "sample";
$sizeline = `tail -c +811048 $known_cipher_file | strings | grep
NAME=_main.pl`;
@line = split /;/, $sizeline;
@size = split /\=/, $line[1];
$known_cipher = `tail -c +811048 $known_cipher_file | head -c $size[1]`;
$key = $known_cipher ^ $known_plain;

$unknown_cipher = `tail -c +811048 perl2exe | head -c $size[1]`;

$unknown_plain = $unknown_cipher ^ $key;
print $unknown_plain, "\n";

