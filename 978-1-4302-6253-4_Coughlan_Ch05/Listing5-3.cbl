IDENTIFICATION DIVISION.
PROGRAM-ID. Listing5-3.
AUTHOR.  Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 InputChar     PIC X.
   88 Vowel      VALUE  "A","E","I","O","U". 
   88 Consonant  VALUE  "B" THRU "D", "F","G","H"
                        "J" THRU "N", "P" THRU "T"
                        "V" THRU "Z".
   88 Digit      VALUE  "0" THRU "9".
   88 ValidChar  VALUE  "A" THRU "Z", "0" THRU "9".

PROCEDURE DIVISION.
Begin.
   DISPLAY "Enter a character :- " WITH NO ADVANCING
   ACCEPT InputChar 
   IF ValidChar 
      DISPLAY "Input OK"
    ELSE
      DISPLAY "Invalid character entered"
   END-IF   
   IF Vowel
      DISPLAY "Vowel entered"
   END-IF
   IF Digit 
      DISPLAY "Digit entered"
   END-IF
   STOP RUN.
