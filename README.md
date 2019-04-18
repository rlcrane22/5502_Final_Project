# 5502_Final_Project

Items you might need to install for this script to work
1.catdoc
2.datamash

To build the index you need to run the below command once you are in the project folder.
bash 5502_program.sh

Once the index is built in section 6 here is how you can search a for a word.
awk -v val='whereas' '$1 == val' index.txt


--------------------------------------------------------------------------------------------------------------------
Portfolio Construction Schedule – INFO 5502

Format:

1. Cover page (include course number and name, date, full name)

2. Index (one entry line per section and subsection, page number – aligned)

3. Introduction of the project

4. Summary on Complexity and Data Science (based on the article circulated earlier in the semester)

5. Sections and their subsections, as needed

All code must include documentation, including a few lines of input and output samples

Week 1: Data downloading and cleaning

· Section 1 (download data): Use any of the datasets introduced during the course (10 documents will be sufficient but feel free to download and use an entire set)

o Keep in its own separate directory

o Brief description of the dataset

o Code used to download raw data

o Document the code

· Section 2: Clean up all documents

o Keep in its own separate directory

o Code used to download raw data

o Document the code

Week 2: Representation: Clauses and nGrams (separate by punctuation to form clauses, create nGrams from 1 to 4 for each clause in each document)

· Section 3 (clauses are separate by punctuation):

o Keep in its own separate directory

o Code used to download raw data

o Document the code

· Section 4 (nGrams from 1 to 4 with frequencies for each term in each clause in each document)

o Keep in its own separate directory

o Code used to download raw data

o Document the code

Week 3: Index nGram files

· Section 5 (create an index file for all the nGrams in the nGram files)

o Keep in its own separate directory

o Code used to download raw data

o Document the code

Week 4: Inverted files

· Section 6 (create an inverted index for all the nGrams in the nGram files)

o Keep in its own separate directory

o Code used to download raw data

o Document the code

Week 5: Presentations

The assigned team member will prepare a PowerPoint presentation of the portfolio to be delivered to the class at the end of the semester.

Each group will turn in the people responsible for the following tasks (coding will be the responsibility of the group):

Coordinating

Documenting

Presenting

Coding
