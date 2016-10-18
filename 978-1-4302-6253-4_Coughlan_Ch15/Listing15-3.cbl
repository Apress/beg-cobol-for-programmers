IDENTIFICATION DIVISION.
PROGRAM-ID. Listing15-3.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 TextLine         PIC X(80).

01 VowelCount       PIC 99 VALUE ZERO. 

01 ConsonantCount   PIC 99 VALUE ZERO.

PROCEDURE DIVISION.
Begin.
    DISPLAY "Enter text : " WITH NO ADVANCING
    ACCEPT TextLine 
    INSPECT FUNCTION UPPER-CASE(TextLine) TALLYING 
            VowelCount FOR ALL "A" "E" "I" "O" "U"
            ConsonantCount FOR ALL 
            "B" "C" "D" "F" "G" "H" "J" "K" "L" "M" "N" "P" 
            "Q" "R" "S" "T" "V" "W" "X" "Y" "Z"

    DISPLAY "The line contains " VowelCount " vowels and " 
            ConsonantCount " consonants."
    STOP RUN.
       