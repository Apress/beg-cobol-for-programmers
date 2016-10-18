IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing8-4.
AUTHOR.  Michael Coughlan.
* This program demonstrates how to read variable length records. 
* It also demonstrates how a file may be assigned its actual name
* at run time rather than compile time (dynamic vs static).
* Since the record buffer is a fixed 40 characters in size but
* the names are variable length Reference Modification is used
* to extract only the characters in the name from the record buffer
* from the record buffer.


ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   SELECT LongNameFile
          ASSIGN TO NameOfFile
          ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD LongNameFile
   RECORD IS VARYING IN SIZE
   DEPENDING ON NameLength.
01 LongNameRec          PIC X(40).
   88 EndOfNames        VALUE HIGH-VALUES.
   

WORKING-STORAGE SECTION.
01 NameLength           PIC 99.
01 NameOfFile           PIC X(20).
01 StudentRec.
   05 StudentId       PIC 9(7).
   05 StudentName.
      10 Forename     PIC X(9).
      10 Surname      PIC X(12).
   05 DateOfBirth.
    10 YOB           PIC 9(4).
    08 MOBandDOB.
      10 MOB          PIC 99.
      10 DOB          PIC 99.
   05 CourseId        PIC X(5).
   04 GPA             PIC 9V99.

PROCEDURE DIVISION.
Begin.
   DISPLAY "Enter the name of the file :- "
      WITH NO ADVANCING
   ACCEPT NameOfFile.
   OPEN INPUT LongNameFile.
   READ LongNameFile
     AT END SET EndOfNames TO TRUE
   END-READ
   PERFORM UNTIL EndOfNames
      DISPLAY "***" LongNameRec(1:NameLength) "***"
      READ LongNameFile
        AT END SET EndOfNames TO TRUE
      END-READ
   END-PERFORM

   CLOSE LongNameFile
   STOP RUN.
