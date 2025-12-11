#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# simon.clematide@uzh.ch
# PCL I
# Example from NLTK book p. 107-108

import nltk, re

class RegexStemmer(object):
    def __init__(self, r=r'^(.*?)(ing|ly|ed|ious|ies|ive|es|s|ment)?$'):
        self._r = r

    def stem(self,word):
        m = re.match(self._r, word)
        return m.group(1)


class IndexedText(object):

    def __init__(self, stemmer, text):
        self._text = text
        self._stemmer = stemmer
        self._index = nltk.Index((self._stem(word), i)
                                 for (i, word) in enumerate(text))

    def _stem(self, word):
        return self._stemmer.stem(word).lower()


    def concordance(self, word, width=40):
        key = self._stem(word)		# stemmed keyword
        wc = width//4				# words of context
        for i in self._index[key]:
            lcontext = ' '.join(self._text[i-wc:i])
            rcontext = ' '.join(self._text[i:i+wc])
            ldisplay = '%*s'  % (width, lcontext[-width:])
            rdisplay = '%-*s' % (width, rcontext[:width])
            print(ldisplay, rdisplay)


porter_stemmer = nltk.PorterStemmer()
text = nltk.corpus.webtext.words('grail.txt')

porter_index = IndexedText(porter_stemmer, text)

print("\nKWIC mit Porter-Stemmer\n")
porter_index.concordance('seem')

regex_stemmer = RegexStemmer()
regex_stemmer.stem('seeming')
regex_index = IndexedText(regex_stemmer, text)

print("\nKWIC mit simplem Regex-Stemmer\n")
regex_index.concordance('seem')

## Wie gut ist unser simpler Stemmer?

#porter_index.concordance('dies')
#regex_index.concordance('dies')



#regex_stemmer.stem('dies')
#regex_stemmer.stem('dying')
#regex_stemmer.stem('is')



# regex = r'^(.{2,}?)(ing|ly|ed|ious|ies|ive|es|s|ment)?$'
# better_regex_index = IndexedText(RegexStemmer(r=regex), text)





# regex = r'^(.{2,}?)(ing|ly|ed|ious|ies|ive|es|s|ment)?$'


