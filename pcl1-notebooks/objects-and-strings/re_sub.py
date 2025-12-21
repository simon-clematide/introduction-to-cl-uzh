#!/usr/bin/python3
# -*- coding: utf-8 -*-

## simon.clematide@uzh.ch
## PCL I

import re

text = "Hässliche Köche verdürben das Gebräu"

pattern = r"([aeiouäöü]+)"

# Matched groups can be inserted in the replacement text.
# \N (N is the N-th grouping bracket in the pattern)
replacement = r"[\1]"

print(re.sub(pattern, replacement, text))



