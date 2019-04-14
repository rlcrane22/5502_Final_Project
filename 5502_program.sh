#!/bin/sh
#This script will take a url to a file create a directory with the file name then break down the file by cleaning it and 
# counting the number of times a word is in the file.

#if check to ee if the user type in help
if [ "$1" = "--help" ] ;
	then
		echo "For this script to work all the pdfs or txt files must exist in a files directory."
		exit
	fi
	
#here is some pre work to create the folders to store each step.
if [ -d "section1" ]; then 
	rm -Rf "section1"; 
fi
	mkdir "section1";
if [ -d "section2" ]; then 
	rm -Rf "section2"; 
fi
	mkdir "section2";
if [ -d "section3" ]; then 
	rm -Rf "section3"; 
fi
	mkdir "section3";
if [ -d "section4" ]; then 
	rm -Rf "section4"; 
fi
	mkdir "section4";
if [ -d "section5" ]; then 
	rm -Rf "section5"; 
fi
	mkdir "section5";
if [ -d "section6" ]; then 
	rm -Rf "section6"; 
fi
	mkdir "section6";
	
if [ -d "section2/files" ]; then 
	rm -Rf "section2/files"; 
fi
	mkdir "section2/files";
	
if [ -d "section2/cleanFiles" ]; then 
	rm -Rf "section2/cleanFiles"; 
fi
	mkdir "section2/cleanFiles";
	
if [ -d "section3/cleanFiles" ]; then 
	rm -Rf "section3/cleanFiles"; 
fi
	mkdir "section3/cleanFiles"
	
if [ -d "section3/ngramFiles" ]; then 
	rm -Rf "section3/ngramFiles"; 
fi
	mkdir "section3/ngramFiles"

#All files must be in the files folder
for file in files/*;
do
#Section 1 the files must be in the files directory or we will wget to download the files and move them to section 1 directory.------------------------------------------------
#echo "Working on file: "$file
cp "$file" section1/


#Section 2 clean up the documents and convert to txt if the document is a pdf.-----------------------------------------------------------------------------------------------------------------
#get the current file name for this loop
currFile=$(basename "$file")
currFileName=`echo $currFile | cut -d\. -f1`;

#check to see if file is a pdf
if [[ $file == *.pdf ]]; then
	#convert to pdf to txt
	pdftotext "$file" "section2/files/$currFileName.txt"
fi

#check to see if file is a doc
if [[ $file == *.doc ]]; then
	#convert to doc to txt
	catdoc "$file"  > "section2/files/$currFileName.txt"
fi

#check to see if file is a txt then copy the file over
if [[ $file == *.txt ]]; then
	#convert to pdf to txt
	cp "$file"  "section2/files/$currFileName.txt"
fi

#clean and prep the file
cat  "section2/files/$currFileName.txt" | tr '.' '\n' | sed $'s/[^[:print:]\t]//g' | tr '[:upper:]' '[:lower:]' |  sed 's/[0-9]*//g' | sed '/^[[:space:]]*$/d' | iconv -c | tr -d '[:punct:]' | sed -e "s/[^ a-zA-Z']//g" -e 's/ \+/ /' | awk '{$1=$1};1' | sed '/^$/d' | awk '{print $0,"\n|||"}' | tr " " "\n" | sed '/^$/d' > "section2/cleanFiles/$currFileName.txt"


#Section 3 Create ngrams by punctuation.-----------------------------------------------------------------------------------------------------------------
cp "section2/cleanFiles/$currFileName.txt" "section3/cleanFiles/$currFileName.txt"
cp "section3/cleanFiles/$currFileName.txt" "section3/tmp1.txt"
tail +2 "section3/cleanFiles/$currFileName.txt" > "section3/tmp2.txt"
tail +3 "section3/cleanFiles/$currFileName.txt" > "section3/tmp3.txt"
tail +4 "section3/cleanFiles/$currFileName.txt" > "section3/tmp4.txt"


paste -d ' ' "section3/tmp1.txt"> "section3/1-grams.txt"
paste -d ' ' "section3/tmp1.txt" "section3/tmp2.txt" > "section3/2-grams.txt"
paste -d ' ' "section3/tmp1.txt" "section3/tmp2.txt" "section3/tmp3.txt" > "section3/3-grams.txt"
paste -d ' ' "section3/tmp1.txt" "section3/tmp2.txt" "section3/tmp3.txt" "section3/tmp4.txt" > "section3/4-grams.txt"


cat "section3/1-grams.txt" | sed 's/|||*//' | awk '{ print NF, $0 }'| awk '$1 != "1" { next } { print }' | colrm 1 2 > section3/ngramFiles/"$currFileName"_1-gram.txt
cat "section3/2-grams.txt" | sed 's/|||*//' | awk '{ print NF, $0 }'| awk '$1 != "2" { next } { print }' | colrm 1 2 > section3/ngramFiles/"$currFileName"_2-gram.txt
cat "section3/3-grams.txt" | sed 's/|||*//' | awk '{ print NF, $0 }'| awk '$1 != "3" { next } { print }' | colrm 1 2 > section3/ngramFiles/"$currFileName"_3-gram.txt
cat "section3/4-grams.txt" | sed 's/|||*//' | awk '{ print NF, $0 }'| awk '$1 != "4" { next } { print }' | colrm 1 2 > section3/ngramFiles/"$currFileName"_4-gram.txt

 #echo "$file";
done

#Section 4 Create ngrams by frequencies.----------------------------------------------------------------------------------------------------------------

if [ -d "section4/ngramFreqFiles" ]; then 
	rm -Rf "section4/ngramFreqFiles"; 
fi
	mkdir "section4/ngramFreqFiles"

cp -R section3/ngramFiles/ section4/ngramFiles/
for file in section4/ngramFiles/*;
do
#get the current file name for this loop
currFile=$(basename "$file")
currFileName=`echo $currFile | cut -d\. -f1`;

sort "$file" | uniq -c | sort -nr > section4/ngramFreqFiles/"$currFileName"_withFreq.txt

done

#Section 5 Create index file for ngrams.----------------------------------------------------------------------------------------------------------------

cp -R section4/ngramFiles/ section5/ngramFiles/

for file in section5/ngramFiles/*;
do
#get the current file name for this loop
currFile=$(basename "$file")
currFileName=`echo $currFile | cut -d\. -f1`;
origFileName=${currFileName::-7}.pdf

cat "$file" | awk -v var="$origFileName" '{print $0, "\x27"var"\x27"}' | sed -e "s/ '/ :'/g" | awk '!seen[$0]++' >> section5/index.txt 

done

#Section 6 Create inverted index file for ngrams.----------------------------------------------------------------------------------------------------------------

#copy index from sec5 to sec6 as staging file
cp section5/index.txt section6/indexStage.txt

datamash -t: -s -g 1 collapse 2 < section6/indexStage.txt > section6/index.txt



#awk -v val='whereas' '$1 == val' index.txt















