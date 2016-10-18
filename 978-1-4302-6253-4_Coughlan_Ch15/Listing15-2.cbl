IDENTIFICATION DIVISION.
PROGRAM-ID. Listing15-2.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 TextLine         PIC X(80).

01 Letters          PIC X(26) VALUE "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
   
01 LetterPos        PIC 99.
 
01 LetterCount      PIC 99. 
 
01 PrnLetterCount   PIC Z9.
   
PROCEDURE DIVISION.
Begin.
   DISPLAY "Enter text : " WITH NO ADVANCING
   ACCEPT TextLine            
   PERFORM VARYING LetterPos  FROM 1 BY 1 UNTIL LetterPos  > 26
     MOVE ZEROS TO LetterCount
     INSPECT FUNCTION UPPER-CASE(TextLine)
             TALLYING LetterCount FOR ALL Letters(LetterPos:1)
     IF LetterCount > ZERO
        MOVE LetterCount TO PrnLetterCount
        DISPLAY "Letter " Letters(LetterPos:1) " occurs " PrnLetterCount " times" 
     END-IF
   END-PERFORM
   STOP RUN.