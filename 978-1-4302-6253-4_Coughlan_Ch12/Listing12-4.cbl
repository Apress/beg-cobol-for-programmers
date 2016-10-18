IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing12-4. 
AUTHOR.  Michael Coughlan.

     
DATA DIVISION.
WORKING-STORAGE SECTION.
01	Counters.
	02	Counter1		PIC 99.
	02	Counter2		PIC 9.
	02	Counter3		PIC 9.


PROCEDURE DIVISION.
Begin.
   DISPLAY "Debug2.  Why can't I stop?"
   PERFORM EternalLooping VARYING Counter1 
		FROM 1 BY 1 UNTIL Counter1 GREATER THAN 25
		AFTER Counter2 FROM 1 BY 1 
                  UNTIL Counter2 GREATER THAN 9 
		AFTER Counter3 FROM 1 BY 1 
                  UNTIL Counter3 EQUAL TO 5

   STOP RUN.


 EternalLooping. 
   DISPLAY "Counters 1, 2 and 3 are "
           Counter1 SPACE Counter2 SPACE Counter3.
