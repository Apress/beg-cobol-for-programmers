IDENTIFICATION DIVISION.
PROGRAM-ID. Listing16-4.
AUTHOR.  Michael Coughlan. 
DATA DIVISION.
WORKING-STORAGE SECTION.
01 Operation              PIC XXX.
01 NumericValue           PIC 999.
   88 EndOfData           VALUE ZEROS.
   
01 FILLER                 PIC 9.
   88 ValidSubprogName    VALUE ZERO.
   88 InvalidSubprogName  VALUE 1.

PROCEDURE DIVISION.
Begin.
    PERFORM 3 TIMES
       SET ValidSubprogName TO TRUE
       DISPLAY SPACES
       DISPLAY "Enter the required operation (Dec or Inc) : " WITH NO ADVANCING
       ACCEPT Operation 
       DISPLAY "Enter a three digit value : " WITH NO ADVANCING
       ACCEPT NumericValue
       PERFORM UNTIL EndofData OR InvalidSubprogName
          CALL Operation USING BY CONTENT NumericValue
               ON EXCEPTION     DISPLAY Operation " is not a valid operation"
                                SET InvalidSubprogName TO TRUE
               NOT ON EXCEPTION SET ValidSubprogName   TO TRUE
                                DISPLAY "Enter a three digit value : " 
                                        WITH NO ADVANCING
                                ACCEPT NumericValue
          END-CALL
       END-PERFORM
       CANCEL Operation       
       END-PERFORM
       STOP RUN.
    

IDENTIFICATION DIVISION.
PROGRAM-ID. Inc.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 RunningTotal     PIC S9(5) VALUE ZEROS.

LINKAGE SECTION.
01 ValueIn          PIC 9(3). 

PROCEDURE DIVISION USING ValueIn.
Begin.
    ADD ValueIn TO RunningTotal
    CALL "DisplayTotal" USING BY CONTENT RunningTotal 
    EXIT PROGRAM.   
END PROGRAM Inc.


 
IDENTIFICATION DIVISION.
PROGRAM-ID. Dec.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 RunningTotal     PIC S9(5) VALUE ZEROS.

LINKAGE SECTION.
01 ValueIn          PIC 9(3). 

PROCEDURE DIVISION USING ValueIn.
Begin.
    SUBTRACT ValueIn FROM RunningTotal
    CALL "DisplayTotal" USING BY CONTENT RunningTotal 
    EXIT PROGRAM.   
END PROGRAM Dec.



IDENTIFICATION DIVISION.
PROGRAM-ID. DisplayTotal IS COMMON INITIAL PROGRAM.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 PrnValue    PIC +++,++9.

LINKAGE SECTION.
01 ValueIn          PIC S9(5). 

PROCEDURE DIVISION USING ValueIn.
Begin.
    MOVE ValueIn TO PrnValue
    DISPLAY "The current value is " PrnValue
    EXIT PROGRAM.   
END PROGRAM DisplayTotal.
END PROGRAM LISTING16-4.