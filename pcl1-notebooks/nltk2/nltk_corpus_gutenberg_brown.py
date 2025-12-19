#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I

from nltk.corpus import brown

# corpus as a list of tuples (word, POS tag)
brown_tagged_words = brown.tagged_words()


# The balanced corpus includes texts from 15 categories
brown.categories()

# All 500 individual files are processed!
for f in brown.fileids()[1:10]:
    print(brown.abspath(f))

# brown

print(60*'*', '\nCorpus as a list of pairs of words and POS tags:')
print(brown_tagged_words[0:20])


# Where are the files of this corpus located?
print(brown.root)
