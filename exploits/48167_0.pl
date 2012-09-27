#!/opt/perl/5.12/bin/perl

use strict;
use warnings;

use Data::FormValidator;

"some_unrelated_string" =~ m/^.*$/;

my $profile = {
untaint_all_constraints => 1,
required => [qw(a)],
constraint_methods => {
a => qr/will_never_match/,
},
};

my $results = Data::FormValidator->check({ a => 1 }, $profile);
warn $results->valid('a');
