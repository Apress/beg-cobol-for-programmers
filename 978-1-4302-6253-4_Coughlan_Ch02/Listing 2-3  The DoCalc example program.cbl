IDENTIFICATION DIVISION.
PROGRAM-ID.  DoCalc.
AUTHOR.  Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 FirstNum       PIC 9     VALUE ZEROS.
01 SecondNum      PIC 9     VALUE ZEROS.
01 CalcResult     PIC 99    VALUE 0.
01 UserPrompt     PIC X(38) VALUE
                  "Please enter two single digit numbers".
PROCEDURE DIVISION.
CalculateResult.
   DISPLAY UserPrompt
   ACCEPT FirstNum
   ACCEPT SecondNum
   COMPUTE CalcResult = FirstNum + SecondNum
   DISPLAY "Result is = ", CalcResult
   STOP RUN.

