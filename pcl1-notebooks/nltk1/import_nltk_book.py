#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I

# Import module book from package nltk
import nltk.book

# Objects and functions from nltk.book can only
# be accessed with fully qualified dot notation.
print("Second token from text1:", nltk.book.text1[1])

# Objects and functions cannot be accessed directly:
print(text1[1])
