IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing13-1.
AUTHOR.  Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 LetterTable.
   02 TableValues.
      03 FILLER PIC X(13) 
         VALUE "ABCDEFGHIJKLM".
      03 FILLER PIC X(13)
         VALUE "NOPQRSTUVWXYZ".
   02 FILLER REDEFINES TableValues.
      03 Letter PIC X OCCURS 26 TIMES
                      INDEXED BY LetterIdx.

01 IdxValue  PIC 99 VALUE ZEROS.

01 LetterIn  PIC X.
   88 ValidLetter VALUE "A" THRU "Z".

PROCEDURE DIVISION.
FindAlphabetLetterPosition.
   PERFORM WITH TEST AFTER UNTIL ValidLetter
      DISPLAY "Enter an upper case letter please - " WITH NO ADVANCING
      ACCEPT LetterIn
   END-PERFORM
   SET LetterIdx TO 1
   SEARCH Letter
      WHEN Letter(LetterIdx) = LetterIn 
          SET IdxValue TO LetterIdx
          DISPLAY LetterIn, " is in position ", IdxValue
   END-SEARCH
   STOP RUN.
