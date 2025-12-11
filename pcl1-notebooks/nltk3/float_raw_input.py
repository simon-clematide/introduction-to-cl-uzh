#!/usr/bin/env python
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I
#

while True:
  x = input('Please type in a number: ')
  try:
    float(x)
    break
  except ValueError:
    pass
