IDENTIFICATION DIVISION.
PROGRAM-ID. Listing16-3.
AUTHOR.  Michael Coughlan. 
DATA DIVISION.
WORKING-STORAGE SECTION.  
01 DaysOfTheWeek  VALUE "MonTueWedThuFriSatSun" IS GLOBAL.
   02 DayName     PIC XXX OCCURS 7 TIMES.

01 Parameters.
   02 Number1             PIC 9(3)  VALUE 456.
   02 Number2             PIC 9(3)  VALUE 321.
   02 FirstString         PIC X(20) VALUE "First parameter  = ".
   02 SecondString        PIC X(20) VALUE "Second parameter = ".
   02 Result              PIC 9(6)  USAGE IS COMP.
   02 DiscountTable VALUE "12430713862362".
      03 Discount         PIC 99 OCCURS 7 TIMES.

01 PrnResult              PIC ZZZ,ZZ9.

PROCEDURE DIVISION.
DemoParameterPassing.
    DISPLAY "FirstString  value is - " FirstString
    DISPLAY "SecondString value is - " SecondString  
    
    CALL "MultiplyNums"
         USING BY CONTENT Number1, Number2, FirstString,
               BY REFERENCE SecondString, Result
               BY CONTENT DiscountTable
               
    DISPLAY SPACES
    DISPLAY "FirstString  value is - " FirstString
    DISPLAY "SecondString value is - " SecondString  
    MOVE Result TO PrnResult
    DISPLAY "COMP value is " PrnResult
    STOP RUN.
    
                         
IDENTIFICATION DIVISION.
PROGRAM-ID. MultiplyNums.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 idx              PIC 9.

LINKAGE SECTION.
01 Param1           PIC 9(3).
01 Param2           PIC 9(3).
01 Answer           PIC 9(6) USAGE IS COMP.
01 StrA             PIC X(20).
01 StrB             PIC X(20).
01 TableIn.
   02 TNum    PIC 99 OCCURS 7 TIMES.
   

PROCEDURE DIVISION USING Param1, Param2, StrA, StrB, Answer, TableIn.
Begin.
    DISPLAY SPACES
    DISPLAY ">>> In the MultiplyNums subprogram"
    DISPLAY StrA Param1
    DISPLAY StrB Param2
    MULTIPLY Param1 BY Param2 GIVING Answer.
    
*>  Displays table values. One passed as a parameter and the other global
    DISPLAY SPACES
    PERFORM VARYING idx FROM 1 BY 1 UNTIL idx > 7
       DISPLAY DayName(idx) " discount is  " Tnum(idx) "%"
    END-PERFORM
    
*>  Transfer control to a subprogram contained within MultiplyNums 
    CALL "InnerSubProg"

    
*>  Demonstrates the difference between BY CONTENT and BY REFERENCE.  
    MOVE "VALUE OVERWRITTEN" TO StrA
    MOVE "VALUE OVERWRITTEN" TO StrB   
    DISPLAY SPACES 
    DISPLAY "<<<< Leaving MultiplyNums"    
    EXIT PROGRAM.    

IDENTIFICATION DIVISION.
PROGRAM-ID. InnerSubProg.
AUTHOR. Michael Coughlan.
PROCEDURE DIVISION.
Begin.
*>  Demonstrates that the GLOBAL data item is even visible here
    DISPLAY SPACES
    DISPLAY ">>>> In InnerSubProg"
    DISPLAY "Days of the week = " DaysOfTheWeek 
    DISPLAY "<<<< Leaving InnerSubProg"  
    EXIT PROGRAM.
    
END PROGRAM InnerSubProg.
END PROGRAM MultiplyNums.
END PROGRAM LISTING16-3.