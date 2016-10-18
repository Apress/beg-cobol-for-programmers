IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing15-7.
AUTHOR.  Michael Coughlan.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 DateStr       PIC X(15).

01 DateRec.
   02 DayStr     PIC XX.
   02 MonthStr   PIC XX.
   02 YearStr    PIC X(4).

01 Delims.
   02 HoldDelim OCCURS 3 TIMES PIC X.

PROCEDURE DIVISION.
Begin.
*>Unstring example 5
    MOVE "15---07--2013" TO DateStr.
    UNSTRING DateStr DELIMITED BY ALL "-"
       INTO DayStr, MonthStr, YearStr
       ON OVERFLOW DISPLAY "Characters unexamined"
    END-UNSTRING
    DISPLAY DayStr SPACE MonthStr SPACE YearStr
    DISPLAY "__________________________"   
    DISPLAY SPACES    
    
*>Unstring example 6   
    MOVE "15---07--2013" TO DateStr.
    UNSTRING DateStr DELIMITED BY "-"
       INTO DayStr   
            MonthStr 
            YearStr  
       ON OVERFLOW DISPLAY "Characters unexamined"
    END-UNSTRING
    DISPLAY DayStr SPACE MonthStr SPACE YearStr
    DISPLAY "__________________________"   
    DISPLAY SPACES    
    
*>Unstring example 7     
    MOVE "15/07-----2013@" TO DateStr
    UNSTRING DateStr DELIMITED BY "/" OR "@" OR ALL "-"
       INTO DayStr   DELIMITER in HoldDelim(1)
            MonthStr DELIMITER in HoldDelim(2)
            YearStr  DELIMITER in HoldDelim(3)
       ON OVERFLOW DISPLAY "Characters unexamined"
    END-UNSTRING
    DISPLAY HoldDelim(1) " delimits " DayStr 
    DISPLAY HoldDelim(2) " delimits " MonthStr     
    DISPLAY HoldDelim(3) " delimits " YearStr
 
    STOP RUN.

