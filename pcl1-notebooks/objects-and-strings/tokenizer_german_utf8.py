#!/usr/bin/env python3
# -*- coding: utf-8 -*-


# simon.clematide@uzh.ch
# PCL I



import sys  # used for diagnostic output on sys.stderr
import re

"""
Module for tokenizing German text files encoded in utf-8

Sentence segmentation has to be done separately.

$ python tokenizer_german_utf8.py max-und-moritz-gutenberg.txt

"""


# module-wide pattern that governs the actual tokenization strategy
# if you have URLs, add
#   | (?:https?:\/\/)?(?:[\w]+\.)(?:[\w\.]{2,6})(?:[\/\w\.-]*)*\/? # URLs....

pattern = r'''(?x)           # set flag (?x) to allow verbose regexps
     (?:z\.B\.|bzw\.|usw\.)  # known abbreviations ...
   | (?:\w\.)+               # abbreviations, e.g. U.S.A. or ordinals
   | \$?\d+(?:[.,]\d+)*[%€]? # currency/percentages, $12.40, 82% 23€
   | \w+(?:['-]\w+)*         # words with optional internal hyphens or apostrophs
   | (?:\.\.\.|---?)         # ellipsis, ASCII long hyphens
   | [.,;?!'"»«[\]()]        # punctuation
   | \S+                     # catch-all for non-layout characters
   '''


def tokenize_line(string):
    """Return list of tokens according to the tokenization pattern"""
    return re.findall(pattern, string)

def verticalize_file(filename):
    """Output verticalized tokens of file filename to stdout"""
    f = open(filename, 'r', encoding='utf-8')
    print('# Processing', filename, file=sys.stderr)
    for line in f:
        for token in tokenize_line(line):
            print(token)
    f.close()


def main():
    """
    Invoke this module as a script.

    Tokenize each file in the argument list to standard output.
    Note, sys.argv[0] is the script itself.
    """

    if len(sys.argv) > 1:
        for arg in sys.argv[1:]:
            verticalize_file(arg)
    else:
        print('# Processing stdin...', file=sys.stderr)
        verticalize_file('/dev/stdin')

if __name__ == '__main__':
    main()
