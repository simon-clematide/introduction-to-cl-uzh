#!/usr/bin/env python
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I

# Demonstration of functions with yield

def squarefun(iterable):
    for i in iterable:
        yield i*i

square = squarefun([10,11])

print(square)
print(type(square))

# next() returns next element.

print(next(square))
print(next(square))
print(next(square))

# If none is available, an exception is made.
# In iteration contexts, this exception will cause the iteration to stop.
# The exception is handled "accordingly".

sum(squarefun([10,11]))


# Generators are exhausted after one pass
print(sum(square))
