#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I

# Draw a random selection of occurrences of tokens from a corpus
import nltk, random

corpus = nltk.corpus.nps_chat.words()

# for demonstration
for i in random.sample(range(len(corpus)),20):
    print(corpus[i])


# as a reusable function with a generator return value
def sample_corpus1(text, size):
    return (text[i] for i in random.sample(range(len(text)),size))

# as a reusable function with a list return value
def sample_corpus2(text, size):
    return [text[i] for i in random.sample(range(len(text)),size)]


print(sample_corpus2(corpus, 20))
#
