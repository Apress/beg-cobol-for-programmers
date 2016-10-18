IDENTIFICATION DIVISION.
PROGRAM-ID. Listing15-1.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 TextLine         PIC X(80).

01 LowerCase        PIC X(26) VALUE "abcdefghijklmnopqrstuvwxyz".

01 UpperCase        VALUE "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
   02 Letter        PIC X OCCURS 26 TIMES.
   
01 idx              PIC 99.
 
01 LetterCount      PIC 99 
 
01 PrnLetterCount   PIC Z9.
    
PROCEDURE DIVISION.
Begin.
    DISPLAY "Enter text : " WITH NO ADVANCING
    ACCEPT TextLine
    INSPECT TextLine CONVERTING LowerCase TO UpperCase
                
    PERFORM VARYING idx FROM 1 BY 1 UNTIL idx > 26
       MOVE ZEROS TO LetterCount
       INSPECT TextLine TALLYING LetterCount FOR ALL Letter(idx)
       IF LetterCount > ZERO
          MOVE LetterCount TO PrnLetterCount
          DISPLAY "Letter " Letter(idx) " occurs " PrnLetterCount " times" 
       END-IF
    END-PERFORM
    STOP RUN.


