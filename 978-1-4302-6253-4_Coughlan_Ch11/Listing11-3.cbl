IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing11-3.
AUTHOR. Michael Coughlan
* Program that for each state and for the whole US  
* sums the Monthly Sales for each branch of YoreCandyShoppe, counts the number of 
* branches and displays the State Sales per month in StateNum order
* Calculates the US sales, the number of branches in the US and the average US sales 
* Uses as input the Sequential BranchSalesFile ordered on ascending BranchId

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   SELECT BranchSalesFile ASSIGN TO "Listing11-3BranchSales.dat"
          ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD BranchSalesFile.
01 BranchSalesRec.
   88 EndOfSalesFile  VALUE HIGH-VALUES.
   02 BranchId              PIC 9(7).
   02 StateNum              PIC 99.
   02 SalesForMonth         PIC 9(5)V99 OCCURS 12 TIMES.

WORKING-STORAGE SECTION.
01 StateSalesTable.
   02 State OCCURS 50 TIMES.
      03 StateBranchCount   PIC 9(5). 
      03 StateMonthSales    PIC 9(5)V99 OCCURS 12 TIMES. 

01 ReportHeading.
   02  FILLER               PIC X(20)  VALUE SPACES.
   02  FILLER               PIC X(38) VALUE "YoreCandyShoppe Monthly Sales by State".
   
01 ReportUnderline.
   02  FILLER               PIC X(20)  VALUE SPACES.
   02  FILLER               PIC X(38) VALUE ALL "-".   

01 ReportSubjectHeadings1.
   02 FILLER                PIC X(12)  VALUE "State   NOBs".
   02 FILLER                PIC X(63) VALUE  "     Jan        Feb        Mar        Apr        May        Jun".
    
01 ReportSubjectHeadings2.
   02 FILLER                PIC X(12) VALUE SPACES.
   02 FILLER                PIC X(63) VALUE  "     Jul        Aug        Sep        Oct        Nov        Dec".
                                          
01 DetailLine1.
   02 PrnStateNum           PIC BZ9.
   02 PrnBranchCount        PIC BBZZ,ZZ9.
   02 PrnMonthSales1        PIC B$$$,$$9.99 OCCURS 6 TIMES.   
      
01 DetailLine2.      
   02 FILLER                PIC X(11) VALUE SPACES.
   02 PrnMonthSales2        PIC B$$$,$$9.99 OCCURS 6 TIMES.   
        
01 US-Totals.
   02 US-TotalSales        PIC 9(9)V99.
   02 US-BranchCount       PIC 9(6).
   02 PrnUS-TotalSales     PIC $,$$$,$$$,$$9.99.
   02 PrnUS-BranchCount    PIC B(9)ZZZ,ZZ9.
   02 PrnUS-AverageSales   PIC BB$$$,$$$,$$9.99.

01 StateIdx                PIC 99.     
01 MonthIdx                PIC 99.   
   
PROCEDURE DIVISION.
Begin.
   MOVE ZEROS TO StateSalesTable
   OPEN INPUT BranchSalesFile
   READ BranchSalesFile
      AT END SET EndOfSalesFile TO TRUE
   END-READ
   PERFORM UNTIL EndOfSalesFile
      ADD 1 TO StateBranchCount(StateNum), US-BranchCount
      PERFORM VARYING MonthIdx FROM 1 BY 1 UNTIL MonthIdx > 12
         ADD SalesForMonth(MonthIdx) TO 
             StateMonthSales(StateNum, MonthIdx), US-TotalSales
      END-PERFORM
      READ BranchSalesFile
         AT END SET EndOfSalesFile TO TRUE
      END-READ
   END-PERFORM
   PERFORM DisplayResults
   CLOSE BranchSalesFile
   STOP RUN.
   
DisplayResults.
   DISPLAY ReportHeading
   DISPLAY ReportUnderline
   DISPLAY ReportSubjectHeadings1
   DISPLAY ReportSubjectHeadings2  
   PERFORM VARYING StateIdx FROM 1 BY 1 
           UNTIL StateIdx GREATER THAN 50  
      MOVE StateIdx TO PrnStateNum    
      MOVE StateBranchCount(StateIdx) TO PrnBranchCount
      PERFORM VARYING MonthIdx FROM 1 BY 1 UNTIL MonthIdx > 6
         MOVE StateMonthSales(StateIdx, MonthIdx) TO PrnMonthSales1(MonthIdx)
      END-PERFORM
      PERFORM VARYING MonthIdx FROM 7 BY 1 UNTIL MonthIdx > 12
         MOVE StateMonthSales(StateIdx, MonthIdx) TO PrnMonthSales2(MonthIdx - 6)
      END-PERFORM   
      DISPLAY DetailLine1
      DISPLAY DetailLine2
      DISPLAY SPACES  
   END-PERFORM
   MOVE US-TotalSales TO PrnUS-TotalSales
   MOVE US-BranchCount TO PrnUS-BranchCount 
   COMPUTE PrnUS-AverageSales = US-TotalSales / US-BranchCount
   DISPLAY "YoreCandyShoppe branches in the US = " PrnUS-BranchCount                                                           
   DISPLAY "YoreCandyShoppe sales in the US    = " PrnUS-TotalSales                                                 
   DISPLAY "YoreCandyShoppe average US sales   = " PrnUS-AverageSales.
