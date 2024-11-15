#!/usr/bin/perl -w
###################################################################################################
# Script Name: tag-eval.perl
# Description: This script evaluates tag classification by comparing a test file against a key file.
#              It calculates error rates, precision, recall, and F-measure to analyze the performance
#              of tag classification.
#
# Usage:       tag-eval.perl -f <key file> -e <file with errors>
# Options:
#              -f|k <key file>         : Path to the key file treated as a gold standard.
#              -e <file with errors>   : Path to the test file to be evaluated against the key file.
#              -g <file with errors>   : Alias for -e, for compatibility.
#              -h|help                 : Display the help message and exit.
#              --ignore-html           : Ignore lines in the input files starting with HTML tags.
#
# Input Format: Both the key file and the test file should contain token-tag pairs in each line,
#               separated by whitespace. Example:
#               token1 tag1
#               token2 tag2
#
# Output:       The script prints detailed statistics including error counts, precision, recall, and
#               F-measure for each tag. It also includes summaries and macro-averages.
###################################################################################################

# Load necessary libraries for command-line option processing
use Getopt::Long; # Standardbibliothek fuer Optionenverarbeitung laden

# Declare and initialize variables for command-line options
my $HELP;
my $KeyFile;
my $TestFile;
my $IGNOREHTML;

# Script name extraction for usage message
my $SCRIPT = `basename $0` ;
chomp $SCRIPT ;

# Usage message to guide users on how to execute the script
my $USAGE=
    "usage: $SCRIPT -f <key file> -e <file with errors>\n
";

# Process command-line options
&GetOptions
	(
	 "f|k=s" => \$KeyFile,
	 "e=s" => \$TestFile,
	 "h|help" => \$HELP,
	 "ignore-html" => \$IGNOREHTML
	 );
# Display usage message if help is requested or necessary options are missing
die $USAGE if defined $HELP;
die $USAGE unless defined $KeyFile && defined $TestFile;

my $DATE=`date`;
my $PATH= `pwd` ;
chomp $PATH;

open(KEYFILE, $KeyFile)   || die "Couldn't find: $! : $KeyFile\n";
open(TESTFILE, $TestFile) || die "Couldn't find: $! : $TestFile\n";

my $KeyFilePath = ($KeyFile =~ /^\//?$KeyFile:$PATH . '/' . $KeyFile);
my $TestFilePath = ($TestFile =~ /^\//?$TestFile:$PATH . '/' . $TestFile);

print
" CLASSIFICATION STATISTICS
 *************************
Date: $DATE

Key File: $KeyFilePath
 (with reference tags, treated as gold standard)

Test File: $TestFilePath
 (with test tags, possibly wrong)

";

# Initialization...
my $testtokencounter = 0;
my %errortags = ();
my %keytags = ();
my %testtags =();
my $keytokencounter=0;

# Main loop for reading and comparing lines from key and test files
while (<KEYFILE>) {
  # Skipping empty lines, comment lines, and optionally lines starting with HTML tags
  next if (/^\s*$/ or /^%%/) ;
  next if ($IGNOREHTML && /^</);
  my $keyfile_line = $. ;
  $keytokencounter++ ;
  ($keytoken,$keytag) = /^(\S+)\s+(\S+)/ ;
  $keytags{$keytag}++ ;

  # Comparison logic: tokens and tags are compared, errors are recorded
  TESTIN: {
	  if (defined( $_ = <TESTFILE> )) {
		goto TESTIN if (/^\s*$/ or /^%%/) ;
		goto TESTIN if ($IGNOREHTML && /^</) ;
		($testtoken,$testtag) = /^(\S+)\s+(\S+)/ ;
		$testtags{$testtag}++;
# include tags which are not part of keyfile for statistics
	$keytags{$testtag} = 0 unless(exists($keytags{$testtag})) ;
	($keytoken eq $testtoken)
	  or die "# Error tag-eval.perl: Tokens not equal!:
File '$KeyFile' on line $keyfile_line has Token '$keytoken'\n
File '$TestFile' on line $. has Token '$testtoken'\n";
	$errortags{"$keytag\t$testtag"}++
	  if ($keytag ne $testtag) ;
	$testtokencounter++ ;
  } else {
	die "# Error tag-eval.perl: Files have different length!\n"
  }
	}
};
close (KEYFILE) ;
close (TESTFILE) ;

# Printing formatted results including various statistics such as error ratios and confusion matrices

$= = 999999; # long pages :)
$^ = 'top';
$~ = 'OUT';

# Ordnungsrelation nach ansteigender Fehlerfrequenz
sub byerrorfreq {$errortags{$b} <=> $errortags{$a};};

print "\
+-----------------------------------------+-----------------+
|confusion matrix                         |     error ratio |\n";

my $errortotal;
my $errorcount;
my $error_percentage;
my $keytag;
my $testtag;
my $tag_rate;
foreach $arg ( sort byerrorfreq (keys %errortags) ) {
	($keytag, $testtag) = ($arg =~ /^(\S+)\t(\S+)/);
	$errorcount = $errortags{$arg};
	$wrongtag{$testtag} += $errortags{$arg};
        $error_percentage = ($errorcount*100)/$keytokencounter;
	$tag_rate = ($errorcount*100)/$keytags{$keytag};
	write;
	$errortotal += $errorcount;
};


printf
"+--------------+-------------+------------+--------+--------+
|  all         |  all        |%11.d |        | %3.2f |
+--------------+-------------+------------+        +--------+\n" ,
  $errortotal, ($errortotal/$keytokencounter)*100;


print "
 total error ratio = proportion of current line to total error
 relative error ratio ct = proportion of this confusion to correct tag
 relative error ratio wt = contribution of this confusion to wrong tag
";




format top =
+--------------+-------------+------------+--------+--------+
| wrong tag    | correct tag |  frequency | rel ct |  total |
+--------------+-------------+------------+--------+--------+
.

format OUT =
| @<<<<<<<<<<<<| @<<<<<<<<<<<| @>>>>>>>>> |@###.## |@###.## |
$testtag, $keytag, $errorcount, $tag_rate, $error_percentage
.
;
#              Correct=Y   Correct=N
#            +-----------+-----------+
# Assigned=Y |     a     |     b     |
#            +-----------+-----------+
# Assigned=N |     c     |     d     |
#            +-----------+-----------+

# accuracy = (a+d)/(a+b+c+d)
# precision = a/(a+b)
# recall = a/(a+c)
# F1 = 2a/(2a + b + c)

# Edge cases:
#  precision(0,0,+,d) = 0
#  precision(a,0,c,d) = 1
#  precision(0,+,c,d) = 0
#     recall(a,b,0,d) = 1 # falls a nicht null ist?
#     recall(0,b,+,d) = 0
#         F1(a,0,0,d) = 1
#         F1(0,+++,d) = 0

# Meine Werte:
# missed = c
# wrong = b
# present = a + c = A
# found = a + b = B
my $PRHeader =
"
+----------+----------+----------+----------+----------+-------+-------+-------+
| tag      |  present |    found |    wrong |   missed |  prec | recal | f-mea |
+----------+----------+----------+----------+----------+-------+-------+-------+
";

format prOUT =
| @<<<<<<<<|@######## |@######## |@######## |@######## |@##.## |@##.## |@##.## |
$theTag, $A,$B,	$wrongTagCount, $missedTagCount,$Precision,$Recall,$FMeasure
.


$~ = "prOUT";

print $PRHeader;

foreach $theTag (sort(keys %keytags)) {
  $i++;
  $wrongTagCount = (exists($wrongtag{$theTag})? $wrongtag{$theTag} : 0) ;

  $A = (exists( $keytags{$theTag}) ? $keytags{$theTag} : 0) ;
  $TotalA += $A;
  $B = (exists($testtags{$theTag})? $testtags{$theTag} : 0) ;
  $TotalB += $B;
  $missedTagCount = $A-$B+$wrongTagCount;

#  warn "B: $B A:$A Wrongtagcount:$wrongTagCount tag2: $testtags{$theTag} tag1:  $keytags{$theTag} \n";
  $Precision = ($B == 0 ? 100 : (($B - $wrongTagCount)*100 / $B));
  $Precision = 0 if ($A - $missedTagCount == 0);
  $Recall = ($A == 0 ? 100 : (($B - $wrongTagCount) / $A)*100);
  $Recall = 0 if ($A - $missedTagCount == 0);
  $FMeasure = ($Precision + $Recall == 0) ? 0 : (2 * $Precision*$Recall) / ($Precision + $Recall);

  $totalMissedTagCount += $missedTagCount;
  $totalWrongTagCount += $wrongTagCount;
  $totalPrecision += $Precision;
  $totalRecall += $Recall;
  $totalFMeasure += $FMeasure;
  write;
}
print "+----------+----------+----------+----------+----------+-------+-------+-------+\n";


$MicroAveragePrecision = ($TotalB == 0 ? 100 : (($TotalB - $totalWrongTagCount)*100 / $TotalB));
$MicroAverageRecall = ($TotalA == 0 ? 100 : (($TotalB - $totalWrongTagCount)/$TotalA)*100);
$MicroAverageFMeasure = ($MicroAveragePrecision + $MicroAverageRecall == 0) ? 0 :
  (2*  $MicroAveragePrecision * $MicroAverageRecall)/( $MicroAveragePrecision + $MicroAverageRecall);

printf
"| macr-avg |%9.d |%9.d |%9.d |%9.d |%6.2f |%6.2f |%6.2f |
+----------+----------+----------+----------+----------+-------+-------+-------+
| micr-avg |%9.d |%9.d |%9.d |%9.d |%6.2f |%6.2f |%6.2f |
+----------+----------+----------+----------+----------+-------+-------+-------+
",
  $keytokencounter, $testtokencounter,$totalWrongTagCount, $totalMissedTagCount, ($totalPrecision/$i), ($totalRecall/$i),($totalFMeasure/$i), $keytokencounter, $testtokencounter,$totalWrongTagCount, $totalMissedTagCount, ($MicroAveragePrecision), ($MicroAverageRecall),($MicroAverageFMeasure);
