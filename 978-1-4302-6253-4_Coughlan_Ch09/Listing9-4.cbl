IDENTIFICATION DIVISION.
PROGRAM-ID. Listing9-4.
AUTHOR. Michael Coughlan.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 Stars          PIC  *****.
01 NumOfStars     PIC 9.

PROCEDURE DIVISION.
Begin.
   PERFORM VARYING NumOfStars FROM 0 BY 1 UNTIL NumOfStars > 5 
      COMPUTE Stars = 10 ** (4 - NumOfStars) 
*     INSPECT Stars CONVERTING "10" TO SPACES
      INSPECT Stars REPLACING ALL "1" BY SPACES
                              ALL "0" BY SPACES

      DISPLAY NumOfStars " = " Stars
   END-PERFORM
   STOP RUN.
