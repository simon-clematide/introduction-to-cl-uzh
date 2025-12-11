#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I
#
import sys

filename = "with_open.py"

with open(filename,'r') as f:
  for l in f:
    if l.rstrip() != '':
       sys.stdout.write(l)

