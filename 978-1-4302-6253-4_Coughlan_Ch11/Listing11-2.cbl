IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing11-2.
AUTHOR. Michael Coughlan
* Program that for each state and for the whole US  
* sums the CandySales for each branch of YoreCandyShoppe 
* counts the number of branches
* calculates the average sales per state and displays the results in StateNum order
* Uses as input the Sequential BranchSalesFile ordered on ascending BranchId

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   SELECT BranchSalesFile ASSIGN TO "Listing11-2BranchSales.dat"
          ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD BranchSalesFile.
01 BranchSalesRec.
   88 EndOfSalesFile  VALUE HIGH-VALUES.
   02 BranchId              PIC 9(7).
   02 StateNum              PIC 99.
   02 CandySales            PIC 9(7)V99.

WORKING-STORAGE SECTION.
01 StateSalesTable.
   02 StateTotals OCCURS 50 TIMES.
      03 StateSalesTotal    PIC 9(8)V99.
      03 StateBranchCount   PIC 9(5).  

01 StateIdx                 PIC 99.    

01 ReportHeading1           PIC X(35) 
                            VALUE "     YoreCandyShoppe Sales by State".
01 ReportHeading2           PIC X(35) 
                            VALUE "     ------------------------------".
01 ReportHeading3           PIC X(47) 
                            VALUE "State  Branches      StateSales    AverageSales".
                                          
01 DetailLine.
   02 PrnStateNum           PIC BZ9.
   02 PrnBranchCount        PIC B(3)ZZ,ZZ9.
   02 PrnStateSales         PIC B(5)$$$,$$$,$$9.99.
   02 PrnAveageSales        PIC BB$$$,$$$,$$9.99.
   
01 US-Totals.
   02 US-TotalSales        PIC 9(9)V99.
   02 US-BranchCount       PIC 9(6).
   02 PrnUS-TotalSales     PIC $,$$$,$$$,$$9.99.
   02 PrnUS-BranchCount    PIC B(9)ZZZ,ZZ9.
   02 PrnUS-AverageSales   PIC BBBB$$$,$$$,$$9.99.
   
   
PROCEDURE DIVISION.
Begin.
   MOVE ZEROS TO StateSalesTable
   OPEN INPUT BranchSalesFile
   READ BranchSalesFile
      AT END SET EndOfSalesFile TO TRUE
   END-READ
   PERFORM UNTIL EndOfSalesFile
      ADD CandySales TO StateSalesTotal(StateNum), US-TotalSales
      ADD 1 TO StateBranchCount(StateNum), US-BranchCount
      READ BranchSalesFile
        AT END SET EndOfSalesFile TO TRUE
     END-READ
   END-PERFORM
   PERFORM PrintResults

   CLOSE BranchSalesFile
   STOP RUN.
   
PrintResults.
   DISPLAY ReportHeading1
   DISPLAY ReportHeading2
   DISPLAY ReportHeading3 
   PERFORM VARYING StateIdx FROM 1 BY 1 
           UNTIL StateIdx GREATER THAN 50  
      MOVE StateIdx TO PrnStateNum    
      MOVE StateSalesTotal(StateIdx) TO PrnStateSales
      MOVE StateBranchCount(StateIdx) TO PrnBranchCount
      COMPUTE PrnAveageSales = StateSalesTotal(StateIdx) / StateBranchCount(StateIdx)       
      DISPLAY DetailLine
   END-PERFORM
   MOVE US-TotalSales TO PrnUS-TotalSales
   MOVE US-BranchCount TO PrnUS-BranchCount 
   COMPUTE PrnUS-AverageSales = US-TotalSales / US-BranchCount
   DISPLAY "YoreCandyShop branches in the US = " PrnUS-BranchCount                                                           
   DISPLAY "YoreCandyShop sales in the US    = " PrnUS-TotalSales                                                 
   DISPLAY "YoreCandyShop average US sales   = " PrnAveageSales.