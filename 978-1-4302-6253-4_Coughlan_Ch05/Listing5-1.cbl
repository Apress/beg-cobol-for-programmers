IDENTIFICATION DIVISION.
PROGRAM-ID. Listing5-1.
AUTHOR. Michael Coughlan.
*> Shows how user defined class names are created and used

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CLASS HexNumber IS "0" THRU "9", "A" THRU "F"
    CLASS RealName    IS "A" THRU "Z", "a" THRU "z", "'", SPACE. 
    
DATA DIVISION.
WORKING-STORAGE SECTION.
01 NumIn       PIC X(4).
01 NameIn      PIC X(15).

PROCEDURE DIVISION.
Begin.
   DISPLAY "Enter a Hex number - " WITH NO ADVANCING
   ACCEPT NumIn.
   IF NumIn IS HexNumber THEN
      DISPLAY NumIn " is a Hex number"
    ELSE 
      DISPLAY NumIn " is not a Hex number"
   END-IF
   
   DISPLAY "----------------------------------"
   DISPLAY "Enter a name - " WITH NO ADVANCING
   ACCEPT NameIn
   IF NameIn IS ALPHABETIC
      DISPLAY NameIn " is alphabetic"
    ELSE
      DISPLAY NameIn " is not alphabetic"
   END-IF
   
   IF NameIn IS RealName THEN
      DISPLAY NameIn " is a real name"
    ELSE 
      DISPLAY NameIn " is not a real name"
   END-IF   
   STOP RUN.
