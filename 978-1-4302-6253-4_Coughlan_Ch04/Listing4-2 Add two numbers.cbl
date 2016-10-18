IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing4-2.
AUTHOR.  Michael Coughlan.
*> Accepts two numbers from the user, multiplies them together
*> and then displays the result. 

DATA DIVISION.
WORKING-STORAGE SECTION.
01  Num1         PIC 9  VALUE 5.
01  Num2         PIC 9  VALUE 4.
01  Result       PIC 99 VALUE ZEROS.
  
PROCEDURE DIVISION.
CalculateResult.
    DISPLAY "Enter a single digit number - " WITH NO ADVANCING
    ACCEPT Num1
    DISPLAY "Enter a single digit number - " WITH NO ADVANCING
    ACCEPT Num2 
    MULTIPLY Num1 BY Num2 GIVING Result   
    DISPLAY "Result is = ", Result
    STOP RUN.
