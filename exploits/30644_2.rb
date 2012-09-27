class Hello
 def world
   Thread.new do
     $SAFE = 4
     msg = "Hello, World!"
     def msg.size
       self.replace self*10 # replace string
       1 # return wrong size
     end
     msg
   end.value
 end
end

$SAFE = 1 # or 2, or 3
s = Hello.new.world
if s.kind_of?(String)
 puts s if s.size < 20 # print string which size is less than 20
end
