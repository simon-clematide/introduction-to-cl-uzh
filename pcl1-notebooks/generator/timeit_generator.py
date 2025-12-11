#!/usr/bin/env python
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I
# Measure computing time and memory efficiency

import nltk, timeit, time, os

print('process id:', os.getpid())

words = nltk.corpus.brown.words()

def test_generator():
    return set(w.lower() for w in words)

# Initialize timer object
tg = timeit.Timer(test_generator)

# Timing of generator expression
print('Timed generator (seconds):', tg.timeit(1))

# Speicherverbrauch muss von ausserhalb gemessen werden.
# Es gibt keinen einfachen Weg, das innerhalb von Python zu machen.
time.sleep(600) # 600 Sekunden

# HOWTO and explanations
# (1) Start program via terminal in background (&):
# $ python3 timeit_listcomprehension.py &
# $ python3 timeit_generator.py &
# The program outputs its process ID.
# This allows to identify the programs.
# In the following PID1 or PID2 stands for the respective numeric ID.

# (2) Measure memory consumption in the terminal with ps (process status):
# $ ps -vp PID1
# $ ps -vp PID2
# The crucial information is in the RSS (resident set size) attribute,
# which stores the physically occupied memory in kilobytes (in contrast to the
# virtual memory).

# (3) Measure memory usage with Task Manager (WIN) or Activity Indicator (MACOS)
# Best to filter on python, then identify the process via its process ID
