#!/usr/bin/ruby
  
 
File.open "Crash.png" , "w" do |file|
junk = "A" *1000
file.write junk
end

