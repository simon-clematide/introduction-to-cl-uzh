#!/usr/bin/perl -w
# $Id: tag-eval.perl,v 1.6 2006-04-16 11:49:29 siclemat Exp $
# s
my $HELP;
my $KeyFile;
my $TestFile;
my $IGNOREHTML;
my $SCRIPT = `basename $0` ;
chomp $SCRIPT ;

my $USAGE=
    "usage: $SCRIPT -f <key file> -e <file with errors>\n
";


# Optionen der Befehlszeile abarbeiten
use Getopt::Long; # Standardbibliothek fuer Optionenverarbeitung laden
&GetOptions
	(
	 "f|k=s" => \$KeyFile,
	 "e=s" => \$TestFile,
	 "g=s" =>  \$TestFile, # for compatibility
	 "h|help" => \$HELP,
	 "ignore-html" => \$IGNOREHTML
	 );

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
"CLASSIFICATION EVALUATION STATISTICS
*************************************
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


# Read in loop
while (<KEYFILE>) {
  next if (/^\s*$/ or /^%%/) ;
  next if ($IGNOREHTML && /^</);
  my $keyfile_line = $. ;
  $keytokencounter++ ;
  ($keytoken,$keytag) = /^(\S+)\s+(\S+)/ ;
  $keytags{$keytag}++ ;
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

# Formatting
$= = 999999; # long pages :)
$^ = 'top';
$~ = 'OUT';

# Ordnungsrelation nach ansteigender Fehlerfrequenz
sub byerrorfreq {$errortags{$b} <=> $errortags{$a};};

print "
Help:
 total error ratio = percentage points of current line to total error percentage
 relative error ratio ct = percentage of this confusion w.r.t. the correct tag
   (how many errors for the correct tag can be attributed to this type of mistake?)
";


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
|  all         |  all        |%11.d |        |   %3.2f |
+--------------+-------------+------------+        +--------+\n" ,
  $errortotal, ($errortotal/$keytokencounter)*100;

printf "Tagging accuracy: %3.2f%%\n\n", (1-($errortotal/$keytokencounter))*100;



print "
Help:
 present: actual number of tokens with this tag in the key file
 found: number of tokens with this tag in the test file
 wrong: number of tokens in the test file that do not match their key file tag (FP)
 missed: number of tokens in the key file that have a different tag in the test file (FN)
 prec: precision
 recal: recall
 f-mea: f-measure
 macr-avg: macro-average: mean of tag-specific prec/recal/f-mea values 
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
# Assigned=Y |     a (TP)|     b (FP)|
#            +-----------+-----------+
# Assigned=N |     c (FN)|     d (TN)|
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


printf
"| macr-avg |%9.d |%9.d |%9.d |%9.d |%6.2f |%6.2f |%6.2f |
+----------+----------+----------+----------+----------+-------+-------+-------+
",
  $keytokencounter, $testtokencounter,$totalWrongTagCount, $totalMissedTagCount, ($totalPrecision/$i), ($totalRecall/$i),($totalFMeasure/$i);
