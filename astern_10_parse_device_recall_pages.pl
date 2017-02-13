use strict;
#my $root           = "/export/home/itg/jsheridan/astern/";
#my $root           = "C:/myProjects/astern/";
#my $root            = "C:/myProjects/astern10/working_parse_detail_pages/";
my $root            = "/export/home/dor/jsheridan/astern_10/";
#
# =========================================================
#my $inputRoot      = $root."input/";
#my $inputRoot      = $root."input_test/";
my $inputRoot      = $root."detail_page_input/";
my $outputRoot     = $root."detail_page_output/";
# below test only - trying to get PMA Number from subset of html pages copied to test dir
#my $inputRoot      = $root."with_PMA_copies_input/";
#my $outputRoot     = $root."with_PMA_copies_output/";
# =========================================================
my $outputFileName  = "astern10_device_recall_$$.dat";
my $outputFile      = $outputRoot.$outputFileName;
#
open (OUTPUT,   ">$outputFile")   || (die "can't open $outputFile: $!");
# =========================================================
#
my @headerArray = ("reacallID","recall","datePosted","recallStatus","recallNumber","recallEventID","premarketApprovalPMA_Number",
                   "premarketNotification","productClassification",
                   "product","codeInformation","recallingFirmManufacturer","manufacturerReasonForRecall",
                   "FDA_DeterminedCause","action","quantityInCommerce","distribution","totalProductLifeCycle");
#
print OUTPUT (join "\t", @headerArray),"\n";
# =========================================================
#
my ($id,$recall,$datePosted,$recallStatus,$recallNumber,$recallEventID,$premarketApprovalPMA_Number,
    $premarketNotification,$productClassification,$product,$codeInformation,
	 $recallingFirmManufacturer,$manufacturerReasonForRecall,$FDA_DeterminedCause,
	 $action,$quantityInCommerce,$distribution,$totalProductLifeCycle);
#
my $baseAddress  = "http://www.accessdata.fda.gov/";
#
my @rowsArray;

my @dataFiles=();                          # array to hold full path to all datafiles we're interested in

getDataFileNames(\$inputRoot,\@dataFiles);

my $i;
my $inputFile;
foreach $inputFile ( @dataFiles ) {
	#exit if $inputFile !~ m|01-01-2002|; # DEBUG

	# print ++$i," $inputFile\n"; # DEBUG
	# /export/home/itg/jsheridan/astern/input/set1/1835.html  # DEBUG
	($id) = $inputFile =~ /.+?\/(\d+?).html/;
	#
	#
   open (INPUT,    "<$inputFile")    || (die "can't open $inputFile: $!");
	@rowsArray = ();
   #
   while ( <INPUT> ) {
   	$_ =~ s/\x0D//g;
  	  	$_ =~ s/\x0A//g;
  	  	chomp;
      #
	   if ( /<!DOCTYPE/../<span class="hardbreak">/ ) {
	   	next;                   # we don't need anything in this section of the html markup so just skip
	   }  # end if
	   #
	   if ( /For details about termination of a recall|A record in this database is created/../<\/html>/ ) {
	   	next;                   # these lines are after the lines we need
	   }  # end if
	   #
	   s/<br>/ /g;
	   s/&nbsp;/ /g;
	   s/\t/ /g;
	   #
	   #
	   unless ( $_ =~ m/>TPLC Device Report</ ) {
         s/<.+?>//g;  # The value we want for TPLC Device Report is in one of the html tags
	   } # end unless
	   #
	   next unless $_ =~ m|\S|; # skip blank lines
	   trim(\$_);
		#
	   push @rowsArray, $_;
	   next;
   }  # end while
	#

	#printArray(\@rowsArray) if $inputFile =~ m|01-01-2002|; # DEBUG
	#print "\n=========================================\n"; # DEBUG


   my ($recall,$datePosted,$recallStatus,$recallNumber,$recallEventID,$premarketApprovalPMA_Number,
       $premarketNotification,$productClassification,$product,$codeInformation,
   	 $recallingFirmManufacturer,$manufacturerReasonForRecall,$FDA_DeterminedCause,
   	 $action,$quantityInCommerce,$distribution,$totalProductLifeCycle);

	my $i;
   for ($i = 0; $i <= $#rowsArray; $i++ ) {
   	if ( $rowsArray[$i] =~ /^Class 1 Recall/ ) {
   		($recall) = $rowsArray[$i] =~ /^Class . Recall (.+?)$/;
   		next;
   	}  # end if
   	if ( $rowsArray[$i] =~ /^Date Posted$/ ) {
   		$datePosted = $rowsArray[($i+1)];
   		next;
   	}  # end if
   	if ( $rowsArray[$i] =~ /^Recall Status1$/ ) {
   		$recallStatus = $rowsArray[($i+1)];
   		next;
   	}  # end if
   	if ( $rowsArray[$i] =~ /^Recall Number$/ ) {
   		$recallNumber = $rowsArray[($i+1)];
   		next;
   	}  # end if
   	if ( $rowsArray[$i] =~ /^Recall Event ID$/ ) {
   		$recallEventID = $rowsArray[($i+1)];
   		next;
   	}  # end if

#		if ( $rowsArray[$i] =~ /^Premarket Approval PMA Number$/ ) {
#   		$premarketApprovalPMA_Number = $rowsArray[($i+1)];
#   		next;
#   	}  # end if
# above commented out for modification *below* - astern10 Oct. 2016
#
		if ( $rowsArray[$i] =~ /PMA Number$/ ) {
   		$premarketApprovalPMA_Number = $rowsArray[($i+1)];
   		next;
   	}  # end if

   	if ( $rowsArray[$i] =~ /^Premarket Notification/ ) {
   		#$premarketApprovalPMA_Number = $rowsArray[($i+1)];
   		$premarketNotification = $rowsArray[($i+1)];          # js - astern10 - oct 2016
   		next;
   	}  # end if

   	if ( $rowsArray[$i] =~ /^Product Classification$/ ) {
   		$productClassification = $rowsArray[($i+1)];
   		next;
   	}  # end if
   	if ( $rowsArray[$i] =~ /^Product$/ ) {
   		$product = $rowsArray[($i+1)];
   		next;
   	}  # end if
#   	if ( $rowsArray[$i] =~ /^Code Information$/ ) {
#   		$codeInformation = $rowsArray[($i+1)];
#   		next;
#   	}  # end if
   	if ( $rowsArray[$i] =~ /^Recalling Firm\/ Manufacturer$/ ) {       # nb inbedded "/"
   		$recallingFirmManufacturer = $rowsArray[($i+1)];
   		next;
   	}  # end if
   	if ( $rowsArray[$i] =~ /^Manufacturer Reason for Recall$/ ) {
   		$manufacturerReasonForRecall = $rowsArray[($i+1)];
   		next;
   	}  # end if
   	if ( $rowsArray[$i] =~ /^FDA Determined Cause 2$/ ) {
   		$FDA_DeterminedCause = $rowsArray[($i+1)];
   		next;
   	}  # end if
   	if ( $rowsArray[$i] =~ /^Action$/ ) {
   		$action = $rowsArray[($i+1)];
   		next;
   	}  # end if
   	if ( $rowsArray[$i] =~ /^Quantity in Commerce$/ ) {
   		$quantityInCommerce = $rowsArray[($i+1)];
   		next;
   	}  # end if
   	if ( $rowsArray[$i] =~ /^Distribution$/ ) {
   		$distribution = $rowsArray[($i+1)];
   		next;
   	}  # end if
      #totalProductLifeCycle
   	if ( $rowsArray[$i] =~ /^Total Product Life Cycle$/ ) {
   		$totalProductLifeCycle = $rowsArray[($i+1)];
   		next;
   	}  # end if
   }  # end for

   #<A style="text-decoration:underline;" href="/scripts/cdrh/cfdocs/cfTPLC/tplc.cfm?id=LKK">TPLC Device Report</A>
   #($x)=$totalProductLifeCycle =~ m/<A style="text-decoration:underline;" href="(/scripts/cdrh/cfdocs/cfTPLC/tplc.cfm?id=LKK")>TPLC Device Report</A>/;

	my ($TPLC_address)=$totalProductLifeCycle =~ m|.+?href="\/(scripts\/cdrh\/cfdocs\/cfTPLC\/tplc\.cfm\?id=.+?)">TPLC Device Report<\/A>|i;
	if ($TPLC_address) { # i.e. if not null
   	$totalProductLifeCycle = $baseAddress . $TPLC_address;
	}else{  # end if
   	$totalProductLifeCycle = "";
	}  # end if

	#
   print OUTPUT (join "\t", ($id,$recall,$datePosted,$recallStatus,$recallNumber,$recallEventID,$premarketApprovalPMA_Number,
                             $premarketNotification,$productClassification,$product,$codeInformation,
	                          $recallingFirmManufacturer,$manufacturerReasonForRecall,$FDA_DeterminedCause,
	                          $action,$quantityInCommerce,$distribution,$totalProductLifeCycle)),"\n";
}  # end for


# --------------------------------------------------------------------------
sub getDataFileNames
# --------------------------------------------------------------------------
 {
	#### NB NB NB this is for a situation where the files of interest are in subdirectories
	#### *BELOW* the input directory
	#
	#getDataFileNames(\$inputRoot,\@dataFiles);
   my ($dataRootRef,$dataFilesArrayRef) = @_;
	opendir (DIRHANDLE, $$dataRootRef) || die "Couldn't open data dir $$dataRootRef $!\n";
   my @dirList = grep (!/^\./, (sort(readdir (DIRHANDLE))));        # disregard "." and ".."
   closedir (DIRHANDLE);

	my @filenameExclusions  = qw(dummy); # ignore these files
   my $filenameExclusions  = join "|",@filenameExclusions;        # string them with "|" to use in match

   foreach my $subDir ( @dirList ) {
      opendir (DIRHANDLE, $$dataRootRef.$subDir) || die "Couldn't open data dir $subDir $!\n";
      my @fileList = grep (!/^\./, (sort(readdir (DIRHANDLE))));        # disregard "." and ".."
		closedir (DIRHANDLE);
		#
		foreach my $filename ( @fileList ) {
			#
			$filename=$$dataRootRef.$subDir.'/'.$filename; # NB NB NB we change $filename to be fully qualified
			#
			if (($filename =~ /\.html$/)&&($filename !~ /$filenameExclusions/)) {   # filename ends in .html and isn't an exculsion
            if ( -s $filename ) {                     # only nonzero size files
               push (@$dataFilesArrayRef,$filename);
            }  # end if
         } # end if
      } # end for
   }  # end for
 } #  getDataFileNames ----------------------------------------------

# --------------------------------------------------------------------------
 sub trim
# --------------------------------------------------------------------------
 {
	 #takes a ref to a scalar or array and trims the referenced object
	 my $ref = @_[0];
	 if ( (ref $ref) =~ /SCALAR/) {
        $$ref =~ s/^\s+//;
        $$ref =~ s/\s+$//;
	 } elsif ((ref $ref) =~ /ARRAY/) {
 	 	for (@$ref) {
           	$_ =~ s/^\s+//;
           	$_ =~ s/\s+$//;
      	}
	 } else {
		return;
	 }  # end if
} #  trim ----------------------------------------------