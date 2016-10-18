IDENTIFICATION DIVISION.
PROGRAM-ID. Listing6-2.
AUTHOR. Michael Coughlan.
*> in-line and out-of-line PERFORM..TIMES

DATA DIVISION.
WORKING-STORAGE SECTION.
01 NumOfTimes PIC 9 VALUE 5.

PROCEDURE DIVISION.
Begin.
   DISPLAY "About to start in-line Perform"
   PERFORM 4 TIMES
      DISPLAY "> > > > In-line Perform"
   END-PERFORM
   DISPLAY "End of in-line Perform"

   DISPLAY "About to start out-of-line Perform"
   PERFORM OutOfLineCode NumOfTimes TIMES
   DISPLAY "End of out-of-line Perform"
   STOP RUN.

OutOfLineCode.
   DISPLAY "> > > > > Out-of-line Perform".
