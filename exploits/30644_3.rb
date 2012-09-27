require "syslog"

Syslog.open

Thread.new do
 $SAFE = 4
 eval %q{
   Syslog.log(Syslog::LOG_WARNING, "Hello, World!")
   Syslog.mask = Syslog::LOG_UPTO(Syslog::LOG_EMERG)
   Syslog.info("masked")
   Syslog.close
 }
end.join
