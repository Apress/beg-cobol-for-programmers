IDENTIFICATION DIVISION.
PROGRAM-ID. UseZodiac.
AUTHOR.  Michael Coughlan.

CLASS-CONTROL.
    ZodiacFactory IS CLASS "zodiac".

DATA DIVISION.
WORKING-STORAGE SECTION.
01 MyZodiac   USAGE OBJECT REFERENCE.

01 Date-DDMM   PIC X(4).
   88  EndOfData  VALUE SPACES.

01 SignCode    PIC 99.

01 OpStatus1    PIC 9.
   88 CuspSign  VALUE 1.

01 OpStatus2    PIC 9.
   88 OperationOK VALUE ZEROS.

01 SignName     PIC X(11).

01 SignElement   PIC X(5).

PROCEDURE DIVISION.
Begin.
   INVOKE ZodiacFactory "new" RETURNING MyZodiac
   DISPLAY "Enter the Date DDMM :- " WITH NO ADVANCING
   ACCEPT Date-DDMM

   PERFORM GetAndDisplay UNTIL EndOfdata
   INVOKE ZodiacFactory "finalize" RETURNING MyZodiac
   DISPLAY "Enter the Date DDMM :- " WITH NO ADVANCING
   ACCEPT Date-DDMM
   STOP RUN.

GetAndDisplay.
   INVOKE MyZodiac "getSignHouse" USING BY CONTENT Date-DDMM
                                       BY REFERENCE SignCode
                                       RETURNING OpStatus1

   INVOKE MyZodiac "getSignName"       USING BY CONTENT SignCode
                                       BY REFERENCE SignName
                                       RETURNING OpStatus2

   INVOKE MyZodiac "getSignElement"    USING BY CONTENT SignCode
                                       BY REFERENCE SignElement
                                       RETURNING OpStatus2

   DISPLAY "SignCode = " SignCode
   DISPLAY "Sign name is " SignName
   DISPLAY "Sign Element is " SignElement
   IF CuspSign
      DISPLAY "The sign is a cusp"
   END-IF
   DISPLAY "Enter the Date DDMM :- " WITH NO ADVANCING
   ACCEPT Date-DDMM.




