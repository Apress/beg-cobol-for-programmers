IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing15-6.
AUTHOR.  Michael Coughlan.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 DateStr       PIC X(15).

01 DateRec.
   02 DayStr     PIC XX.
   02 MonthStr   PIC XX.
   02 YearStr    PIC X(4).

PROCEDURE DIVISION.
Begin.
*>Unstring example 2
    MOVE "19-08-2012" TO DateStr.
    UNSTRING DateStr INTO DayStr, MonthStr, YearStr
          ON OVERFLOW DISPLAY "Characters unexamined"
    END-UNSTRING.
    DISPLAY DayStr SPACE MonthStr SPACE YearStr
    DISPLAY "__________________________"   
    DISPLAY SPACES
    
*>Unstring example 3
    MOVE "25-07-2013lost" TO DateStr.
    UNSTRING DateStr DELIMITED BY "-"
          INTO DayStr, MonthStr, YearStr
          ON OVERFLOW DISPLAY "Characters unexamined"
    END-UNSTRING.
    DISPLAY DayStr SPACE MonthStr SPACE YearStr
    DISPLAY "__________________________"   
    DISPLAY SPACES    
    
*>Unstring example 4
    MOVE "30end06end2014" TO DateStr.
    UNSTRING DateStr DELIMITED BY "end"
        INTO DayStr, MonthStr, YearStr
        ON OVERFLOW DISPLAY "Characters unexamined"
    END-UNSTRING.
    DISPLAY DayStr SPACE MonthStr SPACE YearStr
    
    STOP RUN.
    