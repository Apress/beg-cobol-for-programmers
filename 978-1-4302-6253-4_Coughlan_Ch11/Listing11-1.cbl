IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing11-1.
AUTHOR. Michael Coughlan
* Program to sum the CandySales for each branch of YoreCandyShoppe 
* and display the results in StateNum order
* Using as input the Sequential BranchSalesFile ordered on ascending BranchId

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   SELECT BranchSalesFile ASSIGN TO "Listing11-1BranchSales.dat"
          ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD BranchSalesFile.
01 BranchSalesRec.
   88 EndOfSalesFile  VALUE HIGH-VALUES.
   02 BranchId         PIC 9(7).
   02 StateNum         PIC 99.
   02 CandySales       PIC 9(7)V99.

WORKING-STORAGE SECTION.
01 StateSalesTable.
   02 StateSalesTotal  PIC 9(8)V99  OCCURS 50 TIMES.

01 StateIdx            PIC 99.    
01 PrnStateSales       PIC $$$,$$$,$$9.99.

PROCEDURE DIVISION.
Begin.
   MOVE ZEROS TO StateSalesTable
   OPEN INPUT BranchSalesFile
   READ BranchSalesFile
      AT END SET EndOfSalesFile TO TRUE
   END-READ
   PERFORM UNTIL EndOfSalesFile
      ADD CandySales TO StateSalesTotal(StateNum)
      READ BranchSalesFile
        AT END SET EndOfSalesFile TO TRUE
     END-READ
   END-PERFORM
   DISPLAY "   YoreCandyShoppe Sales by State"
   DISPLAY "   ------------------------------"
   PERFORM VARYING StateIdx FROM 1 BY 1 
           UNTIL StateIdx GREATER THAN 50
      MOVE StateSalesTotal(StateIdx) TO PrnStateSales
      DISPLAY "State ", StateIdx
              " sales total is " PrnStateSales
   END-PERFORM
   CLOSE BranchSalesFile
   STOP RUN.
