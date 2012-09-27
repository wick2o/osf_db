#!/usr/bin/env python

import os
import mmap

bin = file("/usr/bin/id").read()

fd = os.open("id", os.O_RDWR | os.O_CREAT | os.O_EXCL, 02750)
os.ftruncate(fd, len(bin))

m = mmap.mmap(fd, len(bin))
m[:] = bin
m.flush()
