IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing18-1.
AUTHOR.  Michael Coughlan.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT SalesFile ASSIGN TO "Listing18-1-Sales.DAT"
           ORGANIZATION IS LINE SEQUENTIAL.
           
    SELECT PrintFile ASSIGN TO "Listing18-1.Rpt".


DATA DIVISION.
FILE SECTION.
FD  SalesFile.
01  SalesRecord.
    88 EndOfFile  VALUE HIGH-VALUES.
    02 StateNum         PIC 99.
    02 SalesAgentNum    PIC 999.
    02 ValueOfSale      PIC 9(5)V99.

FD  PrintFile
    REPORT IS SolaceSalesReport.

WORKING-STORAGE SECTION.
01  StateNameTable.
    02 StateNameValues.            
       03 FILLER  PIC X(14) VALUE "Alabama".
       03 FILLER  PIC X(14) VALUE "Alaska".
       03 FILLER  PIC X(14) VALUE "Arizona".
       03 FILLER  PIC X(14) VALUE "Arkansas".
       03 FILLER  PIC X(14) VALUE "California".
       03 FILLER  PIC X(14) VALUE "Colorado".
       03 FILLER  PIC X(14) VALUE "Connecticut".
       03 FILLER  PIC X(14) VALUE "Delaware".
       03 FILLER  PIC X(14) VALUE "Florida".
       03 FILLER  PIC X(14) VALUE "Georgia".
       03 FILLER  PIC X(14) VALUE "Hawaii".
       03 FILLER  PIC X(14) VALUE "Idaho".
       03 FILLER  PIC X(14) VALUE "Illinois".
       03 FILLER  PIC X(14) VALUE "Indiana".
       03 FILLER  PIC X(14) VALUE "Iowa".
       03 FILLER  PIC X(14) VALUE "Kansas".
       03 FILLER  PIC X(14) VALUE "Kentucky".
       03 FILLER  PIC X(14) VALUE "Louisiana".
       03 FILLER  PIC X(14) VALUE "Maine".
       03 FILLER  PIC X(14) VALUE "Maryland".
       03 FILLER  PIC X(14) VALUE "Massachusetts".
       03 FILLER  PIC X(14) VALUE "Michigan".
       03 FILLER  PIC X(14) VALUE "Minnesota".
       03 FILLER  PIC X(14) VALUE "Mississippi".
       03 FILLER  PIC X(14) VALUE "Missouri".
       03 FILLER  PIC X(14) VALUE "Montana".
       03 FILLER  PIC X(14) VALUE "Nebraska".
       03 FILLER  PIC X(14) VALUE "Nevada".
       03 FILLER  PIC X(14) VALUE "New Hampshire".
       03 FILLER  PIC X(14) VALUE "New Jersey".
       03 FILLER  PIC X(14) VALUE "New Mexico".
       03 FILLER  PIC X(14) VALUE "New York".
       03 FILLER  PIC X(14) VALUE "North Carolina".
       03 FILLER  PIC X(14) VALUE "North Dakota".
       03 FILLER  PIC X(14) VALUE "Ohio".
       03 FILLER  PIC X(14) VALUE "Oklahoma".
       03 FILLER  PIC X(14) VALUE "Oregon".
       03 FILLER  PIC X(14) VALUE "Pennsylvania".
       03 FILLER  PIC X(14) VALUE "Rhode Island".
       03 FILLER  PIC X(14) VALUE "South Carolina".
       03 FILLER  PIC X(14) VALUE "South Dakota".
       03 FILLER  PIC X(14) VALUE "Tennessee".
       03 FILLER  PIC X(14) VALUE "Texas".
       03 FILLER  PIC X(14) VALUE "Utah".
       03 FILLER  PIC X(14) VALUE "Vermont".
       03 FILLER  PIC X(14) VALUE "Virginia".
       03 FILLER  PIC X(14) VALUE "Washington".
       03 FILLER  PIC X(14) VALUE "West Virginia".
       03 FILLER  PIC X(14) VALUE "Wisconsin".
       03 FILLER  PIC X(14) VALUE "Wyoming".      
02 FILLER REDEFINES StateNameValues.
       03 State OCCURS 50 TIMES.
          04 StateName   PIC X(14).
          

REPORT SECTION.
RD  SolaceSalesReport
    CONTROLS ARE StateNum
                 SalesAgentNum 
    PAGE LIMIT IS 54
    FIRST DETAIL 3
    LAST DETAIL 46
    FOOTING 48.

01  TYPE IS REPORT HEADING NEXT GROUP PlUS 1.
    02 LINE 1.
       03 COLUMN 20     PIC X(32)
                        VALUE "Solace Solar Solutions".

    02 LINE 2.
       03 COLUMN 6      PIC X(52)
          VALUE "Sales Agent - Sales and Salary Report Monthly Report".

      
01  TYPE IS PAGE HEADING.
    02 LINE IS PLUS 1.
       03 COLUMN 2      PIC X(5)  VALUE "State".
       03 COLUMN 16     PIC X(5)  VALUE "Agent".
       03 COLUMN 32     PIC X(8)  VALUE "Value".

    02 LINE IS PLUS 1.
       03 COLUMN 2      PIC X(4)  VALUE "Name".
       03 COLUMN 16     PIC X(6)  VALUE "Number".
       03 COLUMN 31     PIC X(8)  VALUE "Of Sales".


01  DetailLine TYPE IS DETAIL.
    02 LINE IS PLUS 1.
       03 COLUMN 1      PIC X(14)
                        SOURCE StateName(StateNum).
       03 COLUMN 17     PIC ZZ9
                        SOURCE SalesAgentNum.
       03 COLUMN 30     PIC $$$,$$$.99 SOURCE ValueOfSale.
		

01  SalesAgentGrp
    TYPE IS CONTROL FOOTING SalesAgentNum  NEXT GROUP PLUS 2.
    02 LINE IS PLUS 1.
       03 COLUMN 15     PIC X(21) VALUE "Sales for sales agent".
       03 COLUMN 37     PIC ZZ9 SOURCE SalesAgentNum.
       03 COLUMN 43     PIC X VALUE "=".
       03 TotalAgentSales COLUMN 45 PIC $$$$$,$$$.99 SUM ValueOfSale.

01  StateGrp TYPE IS CONTROL FOOTING StateNum NEXT GROUP PLUS 2.     
    02 LINE IS PLUS 1.
       03 COLUMN 1      PIC X(58) VALUE ALL "-".       

01  TYPE IS PAGE FOOTING.
    02 LINE IS 49.
       03 COLUMN 1      PIC X(29) VALUE "Programmer - Michael Coughlan".
       03 COLUMN 55     PIC X(6) VALUE "Page :".
       03 COLUMN 62     PIC ZZ9 SOURCE PAGE-COUNTER.


PROCEDURE DIVISION.
Begin.
    OPEN INPUT SalesFile.
    OPEN OUTPUT PrintFile.
    READ SalesFile
         AT END SET EndOfFile TO TRUE
    END-READ.
    INITIATE SolaceSalesReport.
    PERFORM PrintSalaryReport
            UNTIL EndOfFile.
    TERMINATE SolaceSalesReport.
    CLOSE SalesFile, PrintFile.
    STOP RUN.


PrintSalaryReport.
    GENERATE DetailLine.
    READ SalesFile
          AT END SET EndOfFile TO TRUE
    END-READ.
