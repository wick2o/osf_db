Thread.new do
 $SAFE = 4
 eval %q{$PROGRAM_NAME.replace "Hello, World!"}
end.join

$PROGRAM_NAME #=> "Hello, World!"
