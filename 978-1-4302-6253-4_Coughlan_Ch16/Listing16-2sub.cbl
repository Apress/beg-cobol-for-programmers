IDENTIFICATION DIVISION.
PROGRAM-ID. ValidateCheckDigit IS INITIAL.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 SumOfNums            PIC 9(5).
01 Quotient             PIC 9(5).
01 CalcResult           PIC 99.

LINKAGE SECTION.
01 NumToValidate.
   02  D1               PIC 9.
   02  D2               PIC 9.
   02  D3               PIC 9.
   02  D4               PIC 9.
   02  D5               PIC 9.
   02  D6               PIC 9.
   02  D7               PIC 9.

01 Result               PIC 9.
   88 InvalidCheckDigit VALUE 1.
   88 ValidCheckDigit   VALUE 0.

PROCEDURE DIVISION USING NumToValidate, Result.
*> Returns a Result of 1 (invalid check digit) or 0 (valid check digit)
Begin.
   COMPUTE SumOfNums = (D1 * 7) + (D2 * 6) + (D3 * 5) + (D4 * 4) + (D5 * 3) + (D6 * 2) + (D7).
   DIVIDE SumOfNums BY 11 GIVING Quotient REMAINDER CalcResult
   IF CalcResult EQUAL TO ZERO
      SET ValidCheckDigit TO TRUE
    ELSE
      SET InvalidCheckDigit TO TRUE
   END-IF
   EXIT PROGRAM.