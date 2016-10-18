IDENTIFICATION DIVISION.
PROGRAM-ID. Listing15-4.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 TextLine.
   02 Letter           PIC X OCCURS 80 TIMES.
      88 Vowel         VALUE  "A" "E" "I" "O" "U".
      88 Consonant     VALUE  "B" "C" "D" "F" "G" "H" "J" "K" "L" "M" "N" "P" 
                              "Q" "R" "S" "T" "V" "W" "X" "Y" "Z".
01 VowelCount          PIC 99 VALUE ZERO. 
01 ConsonantCount      PIC 99 VALUE ZERO.
01 idx              PIC 99.
PROCEDURE DIVISION.
Begin.
    DISPLAY "Enter text : " WITH NO ADVANCING
    ACCEPT TextLine
    MOVE FUNCTION UPPER-CASE(TextLine) TO TextLine 
    PERFORM VARYING idx FROM 1 BY 1 UNTIL idx > 80
        IF Vowel(idx) ADD 1 TO VowelCount
          ELSE IF Consonant(idx) ADD 1 TO ConsonantCount
        END-IF
    END-PERFORM     
    DISPLAY "The line contains " VowelCount " vowels and " 
            ConsonantCount " consonants."
    STOP RUN.
       