IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing15-8.
AUTHOR.  Michael Coughlan.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 OldName      PIC X(80).

01 TempName.
   02 NameInitial  PIC X.
   02 FILLER       PIC X(19).
   
01 NewName         PIC X(30).
   
01 UnstrPtr        PIC 99.
   88 NameProcessed VALUE 81.

01 StrPtr          PIC 99.

PROCEDURE DIVISION.
ProcessName.
   DISPLAY "Enter a name - " WITH NO ADVANCING
   ACCEPT OldName
   MOVE 1 TO UnstrPtr, StrPtr
   UNSTRING OldName DELIMITED BY ALL SPACES
      INTO TempName WITH POINTER UnstrPtr 
   END-UNSTRING
   PERFORM UNTIL NameProcessed
      STRING NameInitial "." SPACE DELIMITED BY SIZE 
         INTO NewName WITH POINTER StrPtr      
      END-STRING
      UNSTRING OldName DELIMITED BY ALL SPACES
         INTO TempName WITH POINTER UnstrPtr      
      END-UNSTRING  
   END-PERFORM
   STRING TempName DELIMITED BY SIZE
         INTO NewName WITH POINTER StrPtr   
   END-STRING
   DISPLAY "Processed name = " NewName
   STOP RUN.
