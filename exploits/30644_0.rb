trace_var(:$VAR) {|val| puts "$VAR = #{val}" }

Thread.new do
 $SAFE = 4
 eval %q{
   proc = untrace_var :$VAR
   proc.first.call("aaa")
 }
end.join
