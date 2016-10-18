IDENTIFICATION DIVISION.
PROGRAM-ID.  Lsiting14-4.
AUTHOR.  Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT StudentFile ASSIGN TO "Listing14-4.DAT"
           ORGANIZATION IS LINE SEQUENTIAL.

    SELECT WorkFile ASSIGN TO "WORK.TMP".


DATA DIVISION.
FILE SECTION.
FD StudentFile.
01 StudentDetails      PIC X(32).
* The StudentDetails record has the description shown below.
* But in this program I don't actually need to refer to any
* of the items in the record and so have described it as PIC X(32) 
* 01 StudentDetails
*    02  StudentId       PIC 9(8).
*    02  StudentName.
*        03 Surname      PIC X(8).
*        03 Initials     PIC XX.
*    02  DateOfBirth.
*        03 YOBirth      PIC 9(4).
*        03 MOBirth      PIC 9(2).
*        03 DOBirth      PIC 9(2).
*    02  CourseCode      PIC X(5).
*    02  Gender          PIC X.

SD WorkFile.
01 WorkRec.
   88 EndOfInput         VALUE SPACES.
   02 FILLER             PIC X(8).
   02 SurnameWF          PIC X(8).   
   02 FILLER             PIC X(16).


PROCEDURE DIVISION.
Begin.
   SORT WorkFile ON ASCENDING KEY SurnameWF
        INPUT PROCEDURE IS GetStudentDetails
        GIVING StudentFile
   STOP RUN.


GetStudentDetails.
    DISPLAY "Use the template below"
    DISPLAY "to enter your details."
    DISPLAY "Enter spaces to end.".
    DISPLAY "NNNNNNNNSSSSSSSSIIYYYYMMDDCCCCCG".
    ACCEPT  WorkRec.
    PERFORM UNTIL EndOfInput
       RELEASE WorkRec
       ACCEPT WorkRec
    END-PERFORM.
 
