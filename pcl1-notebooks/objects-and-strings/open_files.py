#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I



# Decode from l1 encoded file into unicode strings
f = open("./ae-l1.txt", "r", encoding="l1")

# Encode unicode strings into UTF-8 encoded file
g = open("./AE-l1-encoded-as-utf8.txt", "w", encoding="utf-8")

for line in f:
    g.write(line.upper())
    print("Type:", type(line))
    print("Canonical:", "==>",repr(line.upper()), "<==")
    print("Printed:","==>",line.upper(), "<==")

f.close()
g.close()


