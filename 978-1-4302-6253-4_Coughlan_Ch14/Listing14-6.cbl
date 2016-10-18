IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing14-6.
AUTHOR.  Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT UnsortedStudentsFile ASSIGN TO "Listing14-6.DAT"
		ORGANIZATION IS LINE SEQUENTIAL.

    SELECT WorkFile ASSIGN TO "Workfile.tmp".

    SELECT SortedStudentsFile  ASSIGN TO "Listing14-6.srt"
                ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD UnsortedStudentsFile.
01 StudentRecUF.
   88  EndOfUnsortedFile  VALUE HIGH-VALUES.
   02  StudentIdUF.
       03 MilleniumUF    PIC 99.
       03 FILLER         PIC 9(5).
   02  RecBodyUF         PIC X(14).

SD WorkFile.
01 StudentRecWF.
   88  EndOfWorkFile  VALUE HIGH-VALUES.
   02  FullStudentIdWF.
       03 MilleniumWF    PIC 99.
       03 StudentIdWF    PIC 9(7).
   02  RecBodyWF         PIC X(14).

FD SortedStudentsFile.
01 StudentRecSF.
   02  StudentIdSF       PIC 9(7).
   02  RecBodySF         PIC X(14).

PROCEDURE DIVISION.
Begin.
   SORT WorkFile ON ASCENDING KEY FullStudentIdWF
       INPUT PROCEDURE  IS AddInMillenium
       OUTPUT PROCEDURE IS RemoveMillenium
   STOP RUN.

AddInMillenium.
   OPEN INPUT UnsortedStudentsFile
   READ UnsortedStudentsFile
      AT END SET EndOfUnsortedFile TO TRUE
   END-READ
   PERFORM UNTIL EndOfUnsortedFile
      MOVE RecBodyUF TO RecBodyWF
      MOVE StudentIDUF   TO StudentIdWF
      IF MilleniumUF < 70
         MOVE 20 TO MilleniumWF
      ELSE
         MOVE 19 TO MilleniumWF
      END-IF
      RELEASE StudentRecWF
      READ UnsortedStudentsFile
        AT END SET EndOfUnsortedFile TO TRUE
      END-READ
   END-PERFORM
   CLOSE UnsortedStudentsFile.

RemoveMillenium.
   OPEN OUTPUT SortedStudentsFile
   RETURN WorkFile
      AT END SET EndOfWorkFile TO TRUE
   END-RETURN
   PERFORM UNTIL EndOfWorkFile
      MOVE RecBodyWF   TO RecBodySF
      MOVE StudentIdWF TO StudentIdSF
      WRITE StudentRecSF
      RETURN WorkFile
        AT END SET EndOfWorkFile TO TRUE
      END-RETURN
   END-PERFORM
   CLOSE SortedStudentsFile.
