IDENTIFICATION DIVISION.
PROGRAM-ID. Listing6-3.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 RepCount         PIC 9(4).
01 PrnRepCount      PIC Z,ZZ9.
01 NumberOfTimes    PIC 9(4) VALUE 1000.

PROCEDURE DIVISION.
Begin.
   PERFORM VARYING RepCount FROM 0 BY 50 UNTIL RepCount = NumberOfTimes
      MOVE RepCount TO PrnRepCount
      DISPLAY "counting " PrnRepCount
   END-PERFORM
   MOVE RepCount TO PrnRepCount
   DISPLAY "If I have told you once, "
   DISPLAY "I have told you " PrnRepCount " times."
   STOP RUN.


