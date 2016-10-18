IDENTIFICATION DIVISION.
PROGRAM-ID. Listing12-2
AUTHOR. Michael Coughlan.
* RENAMES clause examples
DATA DIVISION.
WORKING-STORAGE SECTION.
01 StudentRec.
   02 StudentId        PIC 9(8)  VALUE 12345678.
   02 GPA              PIC 9V99  VALUE 3.25.
   02 ForeName         PIC X(6)  VALUE "Matt".
   02 SurName          PIC X(8)  VALUE "Cullen".
   02 Gender           PIC X     VALUE "M".
   02 PhoneNumber      PIC X(14) VALUE "3536120228233".

66 PersonalInfo RENAMES ForeName  THRU PhoneNumber.
66 CollegeInfo  RENAMES StudentId THRU SurName.
66 StudentName  RENAMES ForeName  THRU SurName.
   
01 ContactInfo.
   02 StudName.
      03 StudForename  PIC X(6).
      03 StudSurname   PIC X(8).
   02 StudGender       PIC X.
   02 StudPhone        PIC X(14).     
   
66 MyPhone RENAMES StudPhone.

PROCEDURE DIVISION.
Begin.   
   DISPLAY "Example 1"       
   DISPLAY "All information = " StudentRec
   DISPLAY "College info    = " CollegeInfo
   DISPLAY "Personal Info   = " PersonalInfo

   DISPLAY SPACES
   DISPLAY "Example 2"
   DISPLAY "Combined names  = " StudentName   
   
   MOVE PersonalInfo TO ContactInfo
   
   DISPLAY SPACES
   DISPLAY "Example 3"
   DISPLAY "Name    is " StudName
   DISPLAY "Gender  is " StudGender
   DISPLAY "Phone   is " StudPhone

   DISPLAY SPACES     
   DISPLAY "Example 4"
   DISPLAY "MyPhone is " MyPhone
   STOP RUN.
