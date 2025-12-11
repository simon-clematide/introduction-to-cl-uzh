#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I

# Demonstration of generator expressions

square = (i*i for i in [10,11])

print(square)
print(type(square))

# len(quadrat)

# next() liefert nächstes Element zurück.

print(next(square))
print(next(square))
print(next(square))

# Falls keines mehr erhältlich ist, entsteht eine Ausnahme.
# In Iterationskontexten führt diese Ausnahme dazu, dass die Iteration
# beendet wird. Die Ausnahme wird "entsprechend" behandelt.

# quadrat = (i*i for i in xrange(10,13))
# for q in quadrat:
#   print q

