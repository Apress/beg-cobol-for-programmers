IDENTIFICATION DIVISION.
PROGRAM-ID. Listing7-3. 
AUTHOR. Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   SELECT EmployeeFile ASSIGN TO "Employee.dat"
          ORGANIZATION IS SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD EmployeeFile.
01 EmployeeDetails.
   88  EndOfEmployeeFile   VALUE HIGH-VALUES.
   02  EmpSSN              PIC 9(9). 
   02  EmpName.
       03 EmpSurname       PIC X(15).
       03 EmpForename      PIC X(10).
   02  EmpDateOfBirth.
       03 EmpYOB           PIC 9(4).
       03 EmpMOB           PIC 99.
       03 EmpDOB           PIC 99.
   02  EmpGender           PIC X.

PROCEDURE DIVISION.
Begin.
   OPEN EXTEND EmployeeFile
   PERFORM GetEmployeeData
   PERFORM UNTIL EmployeeDetails = SPACES
      WRITE EmployeeDetails
      PERFORM GetEmployeeData
   END-PERFORM
   CLOSE EmployeeFile
   DISPLAY "************* End of Input ****************"

   OPEN INPUT EmployeeFile     
   READ EmployeeFile
     AT END SET EndOfEmployeeFile TO TRUE
   END-READ
   PERFORM UNTIL EndOfEmployeeFile
      DISPLAY EmployeeDetails
      READ EmployeeFile
        AT END SET EndOfEmployeeFile TO TRUE
      END-READ
   END-PERFORM
   CLOSE EmployeeFile
   STOP RUN.
   
GetEmployeeData.
   DISPLAY "nnnnnnnnnSSSSSSSSSSSSSSSFFFFFFFFFFyyyyMMddG"
   ACCEPT EmployeeDetails.	


