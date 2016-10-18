IDENTIFICATION DIVISION.
PROGRAM-ID. Listing16-2.
AUTHOR.  Michael Coughlan. 
DATA DIVISION.
WORKING-STORAGE SECTION.
01 StudentId              PIC 9(7).
   
01 ValidationResult       PIC 9.
   88 ValidStudentId      VALUE ZERO.
   88 InvalidStudentId    VALUE 1.
   
PROCEDURE DIVISION.
Begin.
    PERFORM 3 TIMES
       DISPLAY "Enter a Student Id : " WITH NO ADVANCING
       ACCEPT StudentId
       CALL "ValidateCheckDigit" USING BY CONTENT StudentID
                                       BY REFERENCE ValidationResult                                    
       IF ValidStudentId
          DISPLAY "The Student id - " StudentId " - is valid"
        ELSE 
          DISPLAY "The Student id - " StudentId " - is not valid"
       END-IF
       DISPLAY SPACES
    END-PERFORM
    STOP RUN.