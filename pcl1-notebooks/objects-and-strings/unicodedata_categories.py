#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I


import unicodedata
utfstr = '1a* äöü.'

for c in utfstr:
    print(c, "Cat:", unicodedata.category(c))
    print(c, "Name:", unicodedata.name(c))


