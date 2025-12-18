#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I

# Load module book from package nltk and
# import all its objects and functions into the current module
from nltk.book import *

# Objects and functions from nltk.book can be used without
# dotted notation: package.module.object
print("Second token of text1:", text1[1])

# The fully qualified dot notation does not work in this case
print("Second token of text1:", nltk.book.text1[1])
