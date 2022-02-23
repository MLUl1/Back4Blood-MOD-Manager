#C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Strawberry Perl

##################
##Author: Alexander Pharo (aka JazzMcNade)
##################
#
#
#
#This script converts the bone rotation data of the first file to the bone rotation data of the second file and outputs the results as output.smd
#The purpose of this script is to create the "reference.smd" for CBB's proportions method.
#
#First Argument is the .smd file of the original character's skeleton data (ie Zoey)
#Second Argument is the .smd file of the replacement character's skeleton data (ie proportions.smd or whoever the replacement character is)


$fileA = $ARGV[0];
$fileB = $ARGV[1];

open fileA, "<", $fileA or die $!;
open fileB, "<", $fileB or die $!;
open fileOutput, ">", "Ref.smd" or die $!;

$nodeBeginFileB = 0;
$skeletonBeginFileB = 0;

$nodemode = 0;
$bonemode = 0;

my %boneHash;


while (<fileB>) {
	if($_ eq "nodes\n") {
		$nodeBeginFileB = tell(fileB);
	} elsif($_ eq "skeleton\n") {
		$skeletonBeginFileB = tell(fileB);
	}
}
$count = 0;
seek(fileB, $nodeBeginFileB, 0);

while (<fileA>) {
	if($_ eq "nodes\n") {
		#begin skeleton
		$nodemode = 1;
		#print $_;
		print fileOutput $_;
	} elsif($_ eq "skeleton\n") {
		seek(fileB, $skeletonBeginFileB, 0);	
		$boneMode = 1;
		#print $_;
		print fileOutput $_;
	} elsif($_ eq "end\n") {
		#print $_;		
		$nodemode = 0;
		$bonemode = 0;
		print fileOutput $_;
	} else {
	
		if($nodemode == 1) {
			print fileOutput $_;
			# Find equivalent bone in FileB
			# Line is organized as such: (int|boneIndex) (string|boneName) (int|parentBoneIndex)
			# Data is stored as a hash where
			# BoneIndex of FileA is the key, BoneIndex of FileB is the value
			$_ =~ s/^\s+//; #trim leading whitespace
			@data = split (/\s+/, $_); 
			#print "Current Line: " . $_ . "1st : " . @data[0] . "\n";
			$fileAindex = $data[0];
			$fileAboneName = $data[1];
			$fileBindex = GetBoneIndex($fileAboneName);
			$boneHash{$fileAindex} = $fileBindex;
		} elsif($boneMode == 1) {
			$_ =~ s/^\s+//; #trim leading whitespace
			@lineData = split (/\s+/, $_);
			$size = @lineData;
			if(@lineData > 2) {
				print fileOutput ConvertQuaternionData($_);				
			} else {
				print fileOutput $_;
			}			
		} else {
			print fileOutput $_;
		}
	}
}

close fileA;
close fileB;
close fileOutput;


sub GetBoneIndex {
	$input = $_[0];
	seek(fileB, $nodeBeginFileB, 0); #set position to being of bone declarations
	#print "Looking for: " . $input . "\n";
	while(<fileB>)
	{
		if($_ eq "end\n") {
			#print("DID NOT FIND!\n");
			return -1;
		}

		if( index($_, $input) != -1)
		{
			$_ =~ s/^\s+//; #trim leading whitespace
			@boneNumber = split(/\s+/,$_);
			#print ("Found: " . $_ . "Returning: " . $boneNumber[0] . "\n");			
			return $boneNumber[0];
		}
	}
	print("SHOULD NEVER EVER PRINT THIS!\n");
	return -2;
		
}


sub ConvertQuaternionData {
	$fileALine = $_[0];

	seek(fileB, $skeletonBeginFileB, 0);
	
	#return $fileALine;
	#print $_[0];
	#$_[0] =~ s/^\s+//; #trim leading whitespace
	@fileALineData = split(/\s+/, $fileALine);
	$fileBindex = $boneHash{$fileALineData[0]};
	#print($fileALineData[0] . "\n");
	#print($fileBindex . "\n");
	while(<fileB>){
		#print $fileALine;
		$_ =~ s/^\s+//; #trim leading whitespace
		@fileBLineData = split(/\s+/,$_);
		$arraysize = @fileBLineData;
		if( $arraysize > 3 && $fileBLineData[0] == $fileBindex) {
			#We have found the correct line. Copy the quaternion data from FileB into FileA's data

			$fileALineData[4] = $fileBLineData[4];
			$fileALineData[5] = $fileBLineData[5];
			$fileALineData[6] = $fileBLineData[6];
			return join(" ", @fileALineData) . "\n";
		} elsif($_ eq "end\n") {
			#print("DID NOT FIND MATCHING BONE DATA!\n");
			return $fileALine;
		}
	}	

}
