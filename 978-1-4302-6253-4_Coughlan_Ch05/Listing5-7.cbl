IDENTIFICATION DIVISION.
PROGRAM-ID. Listing5-7. 
AUTHOR. Michael Coughlan.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 ValidationReturnCode  PIC 9.
   88 DateIsOK           VALUE 0.
   88 DateIsInvalid      VALUE 1 THRU 8.
   88 ValidCodeSupplied  VALUE 0 THRU 8.

01 DateErrorMessage      PIC X(35) VALUE SPACES.
   88 DateNotNumeric     VALUE "Error - The date must be numeric".
   88 YearIsZero         VALUE "Error - The year cannot be zero".
   88 MonthIsZero        VALUE "Error - The month cannot be zero".
   88 DayIsZero          VALUE "Error - The day cannot be zero".
   88 YearPassed         VALUE "Error - Year has already passed".
   88 MonthTooBig        VALUE "Error - Month is greater than 12".
   88 DayTooBig          VALUE "Error - Day greater than 31".
   88 TooBigForMonth     VALUE "Error - Day too big for this month".

PROCEDURE DIVISION.
Begin.
   PERFORM ValidateDate UNTIL ValidCodeSupplied
   EVALUATE ValidationReturnCode
      WHEN    0   SET DateIsOK       TO TRUE
      WHEN    1   SET DateNotNumeric TO TRUE
      WHEN    2   SET YearIsZero     TO TRUE
      WHEN    3   SET MonthIsZero    TO TRUE
      WHEN    4   SET DayIsZero      TO TRUE
      WHEN    5   SET YearPassed     TO TRUE
      WHEN    6   SET MonthTooBig    TO TRUE
      WHEN    7   SET DayTooBig      TO TRUE
      WHEN    8   SET TooBigForMonth TO TRUE
   END-EVALUATE

   IF DateIsInvalid THEN
      DISPLAY DateErrorMessage
   END-IF
   IF DateIsOK
      DISPLAY "Date is Ok"
   END-IF
   STOP RUN.

ValidateDate.
   DISPLAY "Enter a validation return code (0-8) " WITH NO ADVANCING
   ACCEPT ValidationReturnCode.
