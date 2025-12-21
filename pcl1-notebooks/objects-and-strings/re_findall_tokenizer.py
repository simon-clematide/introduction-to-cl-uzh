#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I

import re
text = "That U.S.A. poster-print costs $12.40..."
pattern = r'''(?x)      # set flag (?x) to allow verbose regexps
     (?:[A-Z]\.)+       # abbreviations, e.g. U.S.A.
   | \w+(?:-\w+)*       # words with optional internal hyphens
   | \$?\d+\.?[\d]*%?   # currency and percentages, $12.40, 82%
   | \.\.\.             # ellipsis
   | [.,;?]+            # punctuation
   | \S+                # catch-all for non-layout characters
   '''
m = re.findall(pattern, text)
print(m)
