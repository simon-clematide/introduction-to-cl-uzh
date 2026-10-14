# introduction-to-cl-uzh

[![Binder](http://mybinder.org/badge_logo.svg)](http://mybinder.org/v2/gh/simon-clematide/introduction-to-cl-uzh/main)

Interactive Jupyter notebooks and demonstrations for courses at the Department of Computational Linguistics, University of Zurich:
- **Introduction to Language Technology (ILT)** (formerly *Einführung in die Computerlinguistik I* / ECL 1)
- **Programmiertechniken in der Computerlinguistik I (PCL 1)**

See the [ILT Table of Contents](ILT%20Table%20of%20Contents.ipynb) and [PCL 1 Table of Contents](PCL%201%20Table%20of%20Contents.ipynb).

### Introduction to Language Technology (ILT)
- **Official Exercise 1 (Lecture 5 — Classification and Tagging: Predicting Labels for Documents and Tokens):**
  - [Exercise 1 Notebook: Training and Evaluating a Simple TnT-like POS Tagger](ilt-notebooks/ex01/ex01.ipynb)
- **Lecture Hands-on & Demonstrations:**
  - Tokenization & Encodings: [tokenization.ipynb](ilt-notebooks/le02/tokenization.ipynb)
  - Tokenizer Experiments (Moses / Cutter): [tokenizer_experiments.ipynb](ilt-notebooks/le02/tokenizer_experiments.ipynb)
  - NER / NEL with spaCy: [ICL1_ex04.ipynb](ilt-notebooks/le_extra/ner_nel/ICL1_ex04.ipynb)

### Programmiertechniken in der Computerlinguistik I (PCL 1)
- Notebooks for PCL 1 can be found in [pcl1-notebooks](pcl1-notebooks).

## For Python hackers:-)

### Local install and running of notebooks

1. Clone this repository `git clone https://github.com/simon-clematide/introduction-to-cl-uzh.git`
2. `cd introduction-to-cl-uzh`
3. Create your own virtual environment:
   1. `python3.11 -mvenv venv`
   2. `source venv/bin/activate`
   3. `python3.11 -mpip install -r requirements.txt`
4. Start Jupyter notebook server: `jupyter lab`
