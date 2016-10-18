IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing5-11.
AUTHOR.  Michael Coughlan.
*> Accepts two numbers and an operator from the user.  
*> Applies the appropriate operation to the two numbers. 

DATA DIVISION.
WORKING-STORAGE SECTION.
01  Num1         PIC 9  VALUE 7.
01  Num2         PIC 9  VALUE 3.
01  Result       PIC --9.99 VALUE ZEROS.
01  Operator     PIC X  VALUE "-".
    88 ValidOperator   VALUES "*", "+", "-", "/".
    
  
PROCEDURE DIVISION.
CalculateResult.
    DISPLAY "Enter a single digit number : " WITH NO ADVANCING
    ACCEPT Num1
    DISPLAY "Enter a single digit number : " WITH NO ADVANCING
    ACCEPT Num2 
    DISPLAY "Enter the operator to be applied : " WITH NO ADVANCING
    ACCEPT Operator  
    EVALUATE Operator
      WHEN "+"   ADD Num2 TO Num1 GIVING Result
      WHEN "-"   SUBTRACT Num2 FROM Num1 GIVING Result
      WHEN "*"   MULTIPLY Num2 BY Num1 GIVING Result
      WHEN "/"   DIVIDE Num1 BY Num2 GIVING Result ROUNDED
      WHEN OTHER DISPLAY "Invalid operator entered"
    END-EVALUATE
    IF ValidOperator 
       DISPLAY "Result is = ", Result
    END-IF
    STOP RUN.
