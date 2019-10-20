from nltk.tag import tnt
import sys


def convert(file_name):
    """ Convert the tts file into  a list of lists, used by the nltk TnT-Tagger"""
    data = []

    with open(file_name, "r") as f:
        sentence = []
        for line in f:
            if line[-1] == "\n":        #cut line breaks
                line = line[:-1]
            if line == "":
                data.append(sentence)
                sentence = []
            else:
                sentence.append(tuple(line.split("\t")))
        if sentence != []:             #last sentence
            data.append(sentence)
    return data

def in_tagging(tagger):
    """Read standard input and tag it onto standard output"""
    sentence = []
    for line in sys.stdin:
        if line[-1] == "\n":
            line = line[:-1]
        if line == "":
            result = tagger.tag(sentence)
            for tok_tag in result:
                print("\t".join(tok_tag))
            print("\n")
            sentence = []
        else:
            sentence.append(line)

    if sentence != []:                  #last sentence
        result = tagger.tag(sentence)
        for tok_tag in result:
            print("\t".join(tok_tag))


def main():
    training_data = convert(sys.argv[1])
    print(f"Training data {sys.argv[1]} read.", file=sys.stderr)
    print(f"Number of training sequences: {len(training_data)}", file=sys.stderr)
    tagger = tnt.TnT()
    tagger.train(training_data)
    print(f"Training finished.", file=sys.stderr)
    print(f"Tagging started.", file=sys.stderr)
    in_tagging(tagger)
    print(f"Tagging finished.", file=sys.stderr)


if __name__ == "__main__":
    main()