IDENTIFICATION DIVISION.
PROGRAM-ID. Debug3.
AUTHOR.  Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT PersonFile ASSIGN TO "PERSON.DAT"
           ORGANIZATION IS LINE SEQUENTIAL.
           
DATA DIVISION.
FILE SECTION.
FD PersonFile.
01 PersonRec                PIC X(10).
   88 EndOfFile             VALUE HIGH-VALUES.

WORKING-STORAGE SECTION.
01 Surname                  PIC X(10).
   88 EndOfData             VALUE SPACES.
01 Quotient                 PIC 9(3).
01 Rem                      PIC 9(3).
01 NumberOfPeople           PIC 9(3) VALUE ZERO.

PROCEDURE DIVISION.
Begin.
   OPEN OUTPUT PersonFile 
   DISPLAY "Debug3"
   DISPLAY "Enter list of Surnames."
   DISPLAY "Press RETURN after each name."
   DISPLAY "To finish press return with no value."
   DISPLAY "This will fill Surname with spaces"
   DISPLAY "Name -> " WITH NO ADVANCING
   ACCEPT Surname
   PERFORM GetPersons UNTIL EndOfData
   CLOSE PersonFile 

   OPEN INPUT PersonFile
   READ PersonFile 
       AT END SET EndOfFile TO TRUE
   END-READ
   PERFORM CountPersons UNTIL EndOfFile.
   CLOSE PersonFile

   DIVIDE NumberOfPeople BY 2
      GIVING Quotient REMAINDER Rem

   IF Rem = 0
       DISPLAY "Even number of people"
    ELSE
       DISPLAY "Odd number of people"

   STOP RUN.

GetPersons.
   WRITE PersonRec FROM Surname
   DISPLAY "Name -> " WITH NO ADVANCING
   ACCEPT Surname.

CountPersons.
   DISPLAY PersonRec
   ADD 1 TO NumberOfPeople
   READ PersonFile 
      AT END SET EndOfFile TO TRUE
   END-READ.