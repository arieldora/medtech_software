use strict;
use File::Basename;

# this is astern9_word_counts.pl - has same keywords and rules used in astern7 and astrern8
# it was developed from astern7/bin/WORKING_astern7-2001-files.pl
#
# my $root           = "/export/home/dor/jsheridan/astern9/";
#
# =========================================================
# my $inputRoot      = $root."input2/";  # NB for txt files from the OCRed pdf files
# my $outputRoot     = $root."output2/"; # NB for txt files from the OCRed pdf files
#my $inputRoot      = $root."input/";
#my $outputRoot     = $root."output/";
#my $inputRoot      = $root."OCR_input/";
#my $outputRoot     = $root."OCR_output/";
# =========================================================

# changes by RMF to allow flexibility with input/output directories as arguments
use File::Spec;
use Cwd 'abs_path';

my $usage           = qq/$0 input_directory output_directory

 Read in TEXT documents at input_directory and perform word counts on each file. Tab-
 separated output file (rows are files, columns are keywords) is placed in output_directory.
 
/;

# get input parameters
my $inputRoot       = shift || die "Error: 1st parameter must be input_directory!\n\n$usage";
my $outputRoot      = shift || die "Error: 2nd parameter must be output_directory!\n\n$usage";

# transform them to full paths
$inputRoot          = abs_path($inputRoot);
$outputRoot         = abs_path($outputRoot);

# now continue...
my $outputFileName  = "astern9_OCR_output_$$.dat";
my $outputFile      = File::Spec->catfile($outputRoot, $outputFileName);

#
open (OUTPUT,   ">$outputFile")   || (die "can't open $outputFile: $!");
# =========================================================
my @headerArray = ("id","analog","analog data","back end","back-end","backward compatible","bandwidth","bit",
   "bluetooth","broadband","byte","cloud","cloud computing","cloud storage","computer","cpu",
   "cybersecurity","data","data collection","data log","data storage","database","digital","digital data",
   "digital display","digital image","digital search","digital transmi","digitally","display","download","email",
   "encrypt","encryption","enterprise network","enterprise software","ethernet","front end","front-end","FTP",
   "hard disk","i.t.","image","imaging","imaging software","information technology","interface","internet",
   "intranet","IT-","LAN","local area network","microprocessor","network","online","platform",
   "processor","remote access","screen","secure socket layer","server","software","ssl","touchscreen",
   "transmission","transmit","user-facing","WAN","wi-fi","wide-area network","wireless","wireless data",
   "information system","programmable","digital storage","API","application program interface",);
#
print OUTPUT (join "\t", @headerArray),"\n";
# =========================================================
#
my @dataFiles=();                          # array to hold full path to all datafiles we're interested in
#
getDataFileNames(\$inputRoot,\@dataFiles);
#
my $inputFile;
#
foreach $inputFile ( @dataFiles ) {
	#
	# print "$inputFile\n";
	#
   my ($id,$analog,$analogData,$backEnd,$back_end,$backwardCompatible,$bandwidth,$bit,$bluetooth,
      $broadband,$byte,$cloud,$cloudComputing,$cloudStorage,$computer,$cpu,$cybersecurity,
      $data,$dataCollection,$dataLog,$dataStorage,$database,$digital,$digitalData,$digitalDisplay,
      $digitalImage,$digitalSearch,$digitalTransmi,$digitally,$display,$download,$email,$encrypt,
      $encryption,$enterpriseNetwork,$enterpriseSoftware,$ethernet,$frontEnd,$front_end,$FTP,$hardDisk,
      $i_t_,$image,$imaging,$imagingSoftware,$informationTechnology,$interface,$internet,$intranet,
      $IT_,$LAN,$localAreaNetwork,$microprocessor,$network,$online,$platform,$processor,
      $remoteAccess,$screen,$secureSocketLayer,$server,$software,$ssl,$touchscreen,$transmission,
      $transmit,$user_facing,$WAN,$wi_fi,$wide_areaNetwork,$wireless,$wirelessData,$informationSystem,
      $programmable,$digitalStorage,$API,$application_program_interface,);
   #
   #($id) = $inputFile =~ m|.+/(.+/.+?).txt|;
   ($id) = $inputFile =~ m|.+/(.+/.+?).txt|;
   $id =~ s|/|-|;         # change the path separator to a dash

	# ugly kludge below - get rid of "input-"
   $id =~ s|input-||;



	#print ">$id<\n"; # DEBUG
	#
   open (INPUT,    "<$inputFile")    || (die "can't open $inputFile: $!");
	#
 	# ==================================================================================================
	#
	my @documentArray;
	my $documentString;
	while ( <INPUT> ) {
      $_ =~ s/\x0A/ /g;   # subs. space for LineFeed
      chomp;
		next unless $_ =~ /\S/;  # we only want non-null lines
		#
		$documentString .= $_ . " ";
		$documentString =~ s/ $//;
	}  # end while
	# $documentString has all text from the document
   #

   my (@analog) = $documentString =~ m/\banalog\b/gi;
   $analog += scalar @analog;

   my (@analogData) = $documentString =~ m/\banalog data\b/gi;
   $analogData += scalar @analogData;

   my (@backEnd) = $documentString =~ m/\bback end\b/gi;
   $backEnd += scalar @backEnd;

   my (@back_end) = $documentString =~ m/\bback-end\b/gi;
   $back_end += scalar @back_end;

   my (@backwardCompatible) = $documentString =~ m/\bbackward compatible\b/gi;
   $backwardCompatible += scalar @backwardCompatible;

   my (@bandwidth) = $documentString =~ m/\bbandwidth\b/gi;
   $bandwidth += scalar @bandwidth;

   my (@bit) = $documentString =~ m/\bbit\b/gi;
   $bit += scalar @bit;

   my (@bluetooth) = $documentString =~ m/\bbluetooth\b/gi;
   $bluetooth += scalar @bluetooth;

   my (@broadband) = $documentString =~ m/\bbroadband\b/gi;
   $broadband += scalar @broadband;

   my (@byte) = $documentString =~ m/\bbyte\b/gi;
   $byte += scalar @byte;

   my (@cloud) = $documentString =~ m/\bcloud\b/gi;
   $cloud += scalar @cloud;

   my (@cloudComputing) = $documentString =~ m/\bcloud computing\b/gi;
   $cloudComputing += scalar @cloudComputing;

   my (@cloudStorage) = $documentString =~ m/\bcloud storage\b/gi;
   $cloudStorage += scalar @cloudStorage;

   my (@computer) = $documentString =~ m/\bcomputer\b/gi;
   $computer += scalar @computer;

   my (@cpu) = $documentString =~ m/\bcpu\b/gi;
   $cpu += scalar @cpu;

   my (@cybersecurity) = $documentString =~ m/\bcybersecurity\b/gi;
   $cybersecurity += scalar @cybersecurity;

   my (@data) = $documentString =~ m/\bdata\b/gi;
   $data += scalar @data;

   my (@dataCollection) = $documentString =~ m/\bdata collection\b/gi;
   $dataCollection += scalar @dataCollection;

   my (@dataLog) = $documentString =~ m/\bdata log\b/gi;
   $dataLog += scalar @dataLog;

   my (@dataStorage) = $documentString =~ m/\bdata storage\b/gi;
   $dataStorage += scalar @dataStorage;

   my (@database) = $documentString =~ m/\bdatabase\b/gi;
   $database += scalar @database;

   my (@digital) = $documentString =~ m/\bdigital\b/gi;
   $digital += scalar @digital;

   my (@digitalData) = $documentString =~ m/\bdigital data\b/gi;
   $digitalData += scalar @digitalData;

   my (@digitalDisplay) = $documentString =~ m/\bdigital display\b/gi;
   $digitalDisplay += scalar @digitalDisplay;

   my (@digitalImage) = $documentString =~ m/\bdigital image\b/gi;
   $digitalImage += scalar @digitalImage;

   my (@digitalSearch) = $documentString =~ m/\bdigital search\b/gi;
   $digitalSearch += scalar @digitalSearch;

   my (@digitalTransmi) = $documentString =~ m/\bdigital transmi/gi;         # NB need to check
   $digitalTransmi += scalar @digitalTransmi;

   my (@digitally) = $documentString =~ m/\bdigitally\b/gi;
   $digitally += scalar @digitally;

   my (@display) = $documentString =~ m/\bdisplay\b/gi;
   $display += scalar @display;

   my (@download) = $documentString =~ m/\bdownload\b/gi;
   $download += scalar @download;

   my (@email) = $documentString =~ m/\bemail\b/gi;
   $email += scalar @email;

   my (@encrypt) = $documentString =~ m/\bencrypt\b/gi;
   $encrypt += scalar @encrypt;

   my (@encryption) = $documentString =~ m/\bencryption\b/gi;
   $encryption += scalar @encryption;

   my (@enterpriseNetwork) = $documentString =~ m/\benterprise network\b/gi;
   $enterpriseNetwork += scalar @enterpriseNetwork;

   my (@enterpriseSoftware) = $documentString =~ m/\benterprise software\b/gi;
   $enterpriseSoftware += scalar @enterpriseSoftware;

   my (@ethernet) = $documentString =~ m/\bethernet\b/gi;
   $ethernet += scalar @ethernet;

   my (@frontEnd) = $documentString =~ m/\bfront end\b/gi;
   $frontEnd += scalar @frontEnd;

   my (@front_end) = $documentString =~ m/\bfront-end\b/gi;
   $front_end += scalar @front_end;

   my (@FTP) = $documentString =~ m/\bFTP\b/g;          # NB want caps only
   $FTP += scalar @FTP;

   my (@hardDisk) = $documentString =~ m/\bhard disk\b/gi;
   $hardDisk += scalar @hardDisk;

   my (@i_t_) = $documentString =~ m/\bI\.T\.\b/g;              # NB want caps only
   $i_t_ += scalar @i_t_;

   my (@image) = $documentString =~ m/\bimage\b/gi;
   $image += scalar @image;

   my (@imaging) = $documentString =~ m/\bimaging\b/gi;
   $imaging += scalar @imaging;

   my (@imagingSoftware) = $documentString =~ m/\bimaging software\b/gi;
   $imagingSoftware += scalar @imagingSoftware;

   my (@informationTechnology) = $documentString =~ m/\binformation technology\b/gi;
   $informationTechnology += scalar @informationTechnology;

   my (@interface) = $documentString =~ m/\binterface\b/gi;
   $interface += scalar @interface;

   my (@internet) = $documentString =~ m/\binternet\b/gi;
   $internet += scalar @internet;

   my (@intranet) = $documentString =~ m/\bintranet\b/gi;
   $intranet += scalar @intranet;

   my (@IT_) = $documentString =~ m/\bIT-\b/g;           # NB want caps only
   $IT_ += scalar @IT_;

   my (@LAN) = $documentString =~ m/\bLAN\b/g;             # NB want caps only
   $LAN += scalar @LAN;

   my (@localAreaNetwork) = $documentString =~ m/\blocal area network\b/gi;
   $localAreaNetwork += scalar @localAreaNetwork;

   my (@microprocessor) = $documentString =~ m/\bmicroprocessor\b/gi;
   $microprocessor += scalar @microprocessor;

   my (@network) = $documentString =~ m/\bnetwork\b/gi;
   $network += scalar @network;

   my (@online) = $documentString =~ m/\bonline\b/gi;
   $online += scalar @online;

   my (@platform) = $documentString =~ m/\bplatform\b/gi;
   $platform += scalar @platform;

   my (@processor) = $documentString =~ m/\bprocessor\b/gi;
   $processor += scalar @processor;

   my (@remoteAccess) = $documentString =~ m/\bremote access\b/gi;
   $remoteAccess += scalar @remoteAccess;

   my (@screen) = $documentString =~ m/\bscreen\b/gi;
   $screen += scalar @screen;

   my (@secureSocketLayer) = $documentString =~ m/\bsecure socket layer\b/gi;
   $secureSocketLayer += scalar @secureSocketLayer;

   my (@server) = $documentString =~ m/\bserver\b/gi;
   $server += scalar @server;

   my (@software) = $documentString =~ m/\bsoftware\b/gi;
   $software += scalar @software;

   my (@ssl) = $documentString =~ m/\bssl\b/gi;
   $ssl += scalar @ssl;

   my (@touchscreen) = $documentString =~ m/\btouchscreen\b/gi;
   $touchscreen += scalar @touchscreen;

   my (@transmission) = $documentString =~ m/\btransmission\b/gi;
   $transmission += scalar @transmission;

   my (@transmit) = $documentString =~ m/\btransmit\b/gi;
   $transmit += scalar @transmit;

   my (@user_facing) = $documentString =~ m/\buser-facing\b/gi;
   $user_facing += scalar @user_facing;

   my (@WAN) = $documentString =~ m/\bWAN\b/g;          #want caps only
   $WAN += scalar @WAN;

   my (@wi_fi) = $documentString =~ m/\bwi-fi\b/gi;
   $wi_fi += scalar @wi_fi;

   my (@wide_areaNetwork) = $documentString =~ m/\bwide-area network\b/gi;
   $wide_areaNetwork += scalar @wide_areaNetwork;

   my (@wireless) = $documentString =~ m/\bwireless\b/gi;
   $wireless += scalar @wireless;

   my (@wirelessData) = $documentString =~ m/\bwireless data\b/gi;
   $wirelessData += scalar @wirelessData;

   my (@informationSystem) = $documentString =~ m/\binformation system\b/gi;
   $informationSystem += scalar @informationSystem;

   my (@programmable) = $documentString =~ m/\bprogrammable\b/gi;
   $programmable += scalar @programmable;

   my (@digitalStorage) = $documentString =~ m/\bdigital storage\b/gi;
   $digitalStorage += scalar @digitalStorage;

	my (@API) = $documentString =~ m/\bapi\b/gi;         # NB 'api' or 'API'
   $API += scalar @API;

	my (@application_program_interface) = $documentString =~	m/\bapplication program(ming)? interface\b/gi;
   $application_program_interface += scalar @application_program_interface;

   #================================
   #================================
   ##print OUTPUT "$id\t$FDA\t$IRB\t$PMA\t$IDE\t$NDA\t$IND\t$BLA\t$Consent\t$Ethics\t$MEC\t$CPHS\t$CEMark\t$CompetentAuthority\t$NotifiedBody\n";
   ##print OUTPUT "$id\t$analog\t$analogData\t$backEnd\t$backEnd\t$backwardCompatible\t$bandwidth\t$bit\t$bluetooth\t$broadband\t$byte\n";
   print OUTPUT join("\t",($id,$analog,$analogData,$backEnd,$back_end,$backwardCompatible,$bandwidth,$bit,$bluetooth,
      $broadband,$byte,$cloud,$cloudComputing,$cloudStorage,$computer,$cpu,$cybersecurity,
      $data,$dataCollection,$dataLog,$dataStorage,$database,$digital,$digitalData,$digitalDisplay,
      $digitalImage,$digitalSearch,$digitalTransmi,$digitally,$display,$download,$email,$encrypt,
      $encryption,$enterpriseNetwork,$enterpriseSoftware,$ethernet,$frontEnd,$front_end,$FTP,$hardDisk,
      $i_t_,$image,$imaging,$imagingSoftware,$informationTechnology,$interface,$internet,$intranet,
      $IT_,$LAN,$localAreaNetwork,$microprocessor,$network,$online,$platform,$processor,
      $remoteAccess,$screen,$secureSocketLayer,$server,$software,$ssl,$touchscreen,$transmission,
      $transmit,$user_facing,$WAN,$wi_fi,$wide_areaNetwork,$wireless,$wirelessData,$informationSystem,
      $programmable,$digitalStorage,$API,$application_program_interface)),"\n";
	#
 }  # end for
exit;

# --------------------------------------------------------------------------
sub getDataFileNames
# --------------------------------------------------------------------------
 {
   my ($dataRootRef,$dataFilesArrayRef) = @_;
   my @filenameExclusions  = qw(head); # ignore these files
   my $filenameExclusions  = join "|",@filenameExclusions;        # string them with "|" to use in match
   opendir (DIRHANDLE, $$dataRootRef) || die "Couldn't open data dir $$dataRootRef $!\n";
   my @fileList = grep (!/^\./, (sort(readdir (DIRHANDLE))));        # disregard "." and ".."
   closedir (DIRHANDLE);
   foreach my $filename ( @fileList ) {
      if (($filename =~ /\.txt/)&&($filename !~ /$filenameExclusions/)) {    # filename ends in .txt and isn't an exculsion
         if ( -s $$dataRootRef."/".$filename ) {                # only nonzero size files
            push (@$dataFilesArrayRef,$$dataRootRef.$filename); # windows flavor
         }  # end if
      }  # end if
   }  # end if
}  #  getDataFileNames ----------------------------------------------

# --------------------------------------------------------------------------
#sub getDataFileNames
# --------------------------------------------------------------------------
# {
#	### NB NB NB this is for a situation where the files of interest are in subdirectories
#	### *BELOW* the input directory

#	getDataFileNames(\$inputRoot,\@dataFiles);
#   my ($dataRootRef,$dataFilesArrayRef) = @_;
#	opendir (DIRHANDLE, $$dataRootRef) || die "Couldn't open data dir $$dataRootRef $!\n";
#   my @dirList = grep (!/^\./, (sort(readdir (DIRHANDLE))));        # disregard "." and ".."
#   closedir (DIRHANDLE);

#	my @filenameExclusions  = qw(dummy); # ignore these files
#   my $filenameExclusions  = join "|",@filenameExclusions;        # string them with "|" to use in match

#   foreach my $subDir ( @dirList ) {
#      opendir (DIRHANDLE, $$dataRootRef.$subDir) || die "Couldn't open data dir $subDir $!\n";
#      my @fileList = grep (!/^\./, (sort(readdir (DIRHANDLE))));        # disregard "." and ".."
#		closedir (DIRHANDLE);

#		foreach my $filename ( @fileList ) {

#			$filename=$$dataRootRef.$subDir.'/'.$filename; # NB NB NB we change $filename to be fully qualified

#			if (($filename =~ /\.txt$/)&&($filename !~ /$filenameExclusions/)) {   # filename ends in .txt and isn't an exculsion
#            if ( -s $filename ) {                     # only nonzero size files
#               push (@$dataFilesArrayRef,$filename);
#            }  # end if
#         } # end if
#      } # end for
#   }  # end for
# } #  getDataFileNames ----------------------------------------------

# --------------------------------------------------------------------------
sub displayArray
# --------------------------------------------------------------------------
 {

	my $arrayRef=shift;
   print "[", join("|",@$arrayRef),"]\n===\n";

}	#  displayArray ----------------------------------------------

# --------------------------------------------------------------------------
sub printArray
# --------------------------------------------------------------------------
 {
	my $r_ref=shift;
	my $i;
	for ( @$r_ref ) {
		print $i++,"\t>$_<\n";
		#print "$_\n";
	}  # end for
}	#  printArray ----------------------------------------------

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