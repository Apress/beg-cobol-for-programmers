IDENTIFICATION DIVISION.
PROGRAM-ID. Listing12-3.
AUTHOR.  Michael Coughlan.

DATA DIVISION.
WORKING-STORAGE SECTION. 
01 Counters.
   02 Counter1        PIC 99.
   02 Counter2        PIC 99.
   02 Counter3        PIC 9.

PROCEDURE DIVISION.
Begin.
    DISPLAY "Debug 1.  Discover why I can't stop."
    PERFORM EternalLooping VARYING Counter1
        FROM 13 BY -5 UNTIL Counter1 LESS THAN 2
        AFTER Counter2 FROM 15 BY -4 
              UNTIL Counter2 LESS THAN 1
        AFTER Counter3 FROM 1 BY 1 
              UNTIL Counter3 GREATER THAN 5

    STOP RUN.

EternalLooping.
    DISPLAY "Counters 1, 2 and 3 are -> " 
             Counter1 SPACE  Counter2 SPACE Counter3.
