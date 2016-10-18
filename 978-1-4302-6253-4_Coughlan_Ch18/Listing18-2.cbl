IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing18-2.
AUTHOR.  Michael Coughlan.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT SalesFile ASSIGN TO "Listing18-2-Sales.DAT"
           ORGANIZATION IS LINE SEQUENTIAL.
           
    SELECT PrintFile ASSIGN TO "Listing18-2.Rpt".


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
       03 FILLER  PIC X(18) VALUE "1149Alabama".
       03 FILLER  PIC X(18) VALUE "1536Alaska".
       03 FILLER  PIC X(18) VALUE "1284Arizona".
       03 FILLER  PIC X(18) VALUE "1064Arkansas".
       03 FILLER  PIC X(18) VALUE "1459California".
       03 FILLER  PIC X(18) VALUE "1508Colorado".
       03 FILLER  PIC X(18) VALUE "1742Connecticut".
       03 FILLER  PIC X(18) VALUE "1450Delaware".
       03 FILLER  PIC X(18) VALUE "1328Florida".
       03 FILLER  PIC X(18) VALUE "1257Georgia".
       03 FILLER  PIC X(18) VALUE "1444Hawaii".
       03 FILLER  PIC X(18) VALUE "1126Idaho".
       03 FILLER  PIC X(18) VALUE "1439Illinois".
       03 FILLER  PIC X(18) VALUE "1203Indiana".
       03 FILLER  PIC X(18) VALUE "1267Iowa".
       03 FILLER  PIC X(18) VALUE "1295Kansas".
       03 FILLER  PIC X(18) VALUE "1126Kentucky".
       03 FILLER  PIC X(18) VALUE "1155Louisiana".
       03 FILLER  PIC X(18) VALUE "1269Maine".
       03 FILLER  PIC X(18) VALUE "1839Maryland".
       03 FILLER  PIC X(18) VALUE "1698Massachusetts".
       03 FILLER  PIC X(18) VALUE "1257Michigan".
       03 FILLER  PIC X(18) VALUE "1479Minnesota".
       03 FILLER  PIC X(18) VALUE "0999Mississippi".
       03 FILLER  PIC X(18) VALUE "1236Missouri".
       03 FILLER  PIC X(18) VALUE "1192Montana".
       03 FILLER  PIC X(18) VALUE "1261Nebraska".
       03 FILLER  PIC X(18) VALUE "1379Nevada".
       03 FILLER  PIC X(18) VALUE "1571New Hampshire".
       03 FILLER  PIC X(18) VALUE "1743New Jersey".
       03 FILLER  PIC X(18) VALUE "1148New Mexico".
       03 FILLER  PIC X(18) VALUE "1547New York".
       03 FILLER  PIC X(18) VALUE "1237North Carolina".
       03 FILLER  PIC X(18) VALUE "1290North Dakota".
       03 FILLER  PIC X(18) VALUE "1256Ohio".
       03 FILLER  PIC X(18) VALUE "1155Oklahoma".
       03 FILLER  PIC X(18) VALUE "1309Oregon".
       03 FILLER  PIC X(18) VALUE "1352Pennsylvania".
       03 FILLER  PIC X(18) VALUE "1435Rhode Island".
       03 FILLER  PIC X(18) VALUE "1172South Carolina".
       03 FILLER  PIC X(18) VALUE "1206South Dakota".
       03 FILLER  PIC X(18) VALUE "1186Tennessee".
       03 FILLER  PIC X(18) VALUE "1244Texas".
       03 FILLER  PIC X(18) VALUE "1157Utah".
       03 FILLER  PIC X(18) VALUE "1374Vermont".
       03 FILLER  PIC X(18) VALUE "1607Virginia".
       03 FILLER  PIC X(18) VALUE "1487Washington".
       03 FILLER  PIC X(18) VALUE "1062West Virginia".
       03 FILLER  PIC X(18) VALUE "1393Wisconsin".
       03 FILLER  PIC X(18) VALUE "1393Wyoming".      
02 FILLER REDEFINES StateNameValues.
       03 State OCCURS 50 TIMES.
          04 BaseSalary  PIC 9(4).
          04 StateName   PIC X(14).
          

REPORT SECTION.
RD  SolaceSalesReport
    CONTROLS ARE FINAL
                 StateNum
                 SalesAgentNum 
    PAGE LIMIT IS 54
    FIRST DETAIL 3
    LAST DETAIL 42
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
                        SOURCE StateName(StateNum) GROUP INDICATE.
       03 COLUMN 17     PIC ZZ9
                        SOURCE SalesAgentNum  GROUP INDICATE.
       03 COLUMN 30     PIC $$$,$$$.99 SOURCE ValueOfSale.
		

01  SalesAgentGrp
    TYPE IS CONTROL FOOTING SalesAgentNum  NEXT GROUP PLUS 2.
    02 LINE IS PLUS 1.
       03 COLUMN 15     PIC X(21) VALUE "Sales for sales agent".
       03 COLUMN 37     PIC ZZ9 SOURCE SalesAgentNum.
       03 COLUMN 43     PIC X VALUE "=".
       03 TotalAgentSales COLUMN 45 PIC $$$$$,$$$.99 SUM ValueOfSale.

01  StateGrp TYPE IS CONTROL FOOTING StateNum NEXT GROUP PLUS 2.
    02 LINE IS PLUS 2.
       03 COLUMN 15     PIC X(15) VALUE "Total sales for".
       03 COLUMN 31     PIC X(14) SOURCE StateName(StateNum).
       03 TotalStateSales COLUMN 45  PIC $$$$$,$$$.99 SUM TotalAgentSales.
       
    02 LINE IS PLUS 1.
       03 COLUMN 15     PIC X(15) VALUE "Base salary for".
       03 COLUMN 31     PIC X(14) SOURCE StateName(StateNum).       
       03 COLUMN 48     PIC $$,$$$.99 SOURCE BaseSalary(StateNum).
       
    02 LINE IS PLUS 1.
       03 COLUMN 1      PIC X(58) VALUE ALL "-".       


01  TotalSalesGrp TYPE IS CONTROL FOOTING FINAL.
    02 LINE IS PLUS 2.
       03 COLUMN 15     PIC X(11)
                        VALUE "Total sales".
       03 COLUMN 46     PIC X VALUE "=".
       03 COLUMN 48     PIC $$,$$$,$$$.99 SUM TotalStateSales.


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