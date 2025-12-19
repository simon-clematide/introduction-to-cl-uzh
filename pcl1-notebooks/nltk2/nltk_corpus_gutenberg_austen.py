#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I

from nltk.corpus import gutenberg

filename = 'austen-emma.txt' # or absolute path of a text file

# Full corpus as a single string
emma_chars = gutenberg.raw(filename)

# Corpus as a list of words (word is string)
emma_words = gutenberg.words(filename)

# Corpus as list of sentences (sentence is list of words)
emma_sents = gutenberg.sents(filename)

# Corpus as list of paragraphs (paragraph is list of sentences)
emma_paras = gutenberg.paras(filename)


print(60*'*', '\ncorpus as a single string:')
print(emma_chars[-324:])

print(60*'*', '\nCorpus as a list of words:')
print(emma_words[-30:])

print(60*'*', '\nCorpus as list of sentences:')
print(emma_sents[-5:])

print(60*'*', '\nCorpus as list of paragraphs:')
print(emma_paras[-2:])

# How many paragraphs?

# How many sentences?

# How many sentences per paragraph on average?

# How many words per sentence on average?

# How can the average word length be calculated?

# Where are the files of this corpus?
# gutenberg.root

# Create your own Gutenberg-like corpora
from nltk.corpus.reader.plaintext import PlaintextCorpusReader


root = '/Users/siclemat/nltk_data/corpora/gutenberg/' # adapt if necessary
file_pattern = r'.+\.txt'
my_gutenberg = PlaintextCorpusReader(root,file_pattern)

print(my_gutenberg.sents('chesterton-ball.txt')[5:10])

# With Encoding

root = '/Users/siclemat/nltk_data/corpora/udhr2/'
file_pattern = r'.+\.txt'
my_humanrights = PlaintextCorpusReader(root,
                    file_pattern,
                    encoding='utf-8')

print(my_humanrights.sents('deu_1901.txt')[:3])
