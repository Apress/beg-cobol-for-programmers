IDENTIFICATION DIVISION.
PROGRAM-ID. Listing5-6. 
AUTHOR. Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   SELECT StudentFile ASSIGN TO "Listing5-6-TData.Dat" 
    ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD StudentFile.
01 StudentDetails.
   88  EndOfStudentFile  VALUE HIGH-VALUES.
   02  StudentId       PIC X(8). 
   02  StudentName     PIC X(25).
   02  CourseCode      PIC X(5). 

PROCEDURE DIVISION.
Begin.
   OPEN INPUT StudentFile 
   READ StudentFile 
      AT END SET EndOfStudentFile TO TRUE
   END-READ
   PERFORM UNTIL EndOfStudentFile 
      DISPLAY StudentName SPACE StudentId SPACE CourseCode 
      READ StudentFile 
         AT END SET EndOfStudentFile TO TRUE
      END-READ 
   END-PERFORM
   CLOSE StudentFile 
   STOP RUN.
