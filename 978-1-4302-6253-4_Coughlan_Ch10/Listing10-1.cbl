IDENTIFICATION DIVISION.
PROGRAM-ID. Listing10-1.
AUTHOR. Michael Coughlan.
* A three level Control Break program to process the Electronics2Go 
* Sales file and produce a report that shows the value of sales for 
* each Salesperson, each branch, each state, and for the country.
* The SalesFile is sorted on ascending SalespersonId within BranchId
* within Statename.
* The report must be printed in the same order

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
SELECT SalesFile ASSIGN TO "Listing10-1TestData.Dat"
                 ORGANIZATION IS LINE SEQUENTIAL.
                      
SELECT SalesReport ASSIGN TO "Listing10-1.RPT"
                   ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  SalesFile.
01  SalesRecord.
    88 EndOfSalesFile VALUE HIGH-VALUES.
    02 StateName         PIC X(14).
    02 BranchId          PIC X(5).
    02 SalesPersonId     PIC X(6).
    02 ValueOfSale       PIC 9(4)V99.
    
FD SalesReport.
01 PrintLine             PIC X(55).

WORKING-STORAGE SECTION.
01  ReportHeading.
    02 FILLER               PIC X(35)
       VALUE "        Electronics2Go Sales Report".
       
01  SubjectHeading.
    02 FILLER               PIC X(43)
       VALUE "State Name      Branch  SalesId  SalesTotal".
       
01  DetailLine.
    02 PrnStateName         PIC X(14).
       88 SuppressStateName VALUE SPACES.
    02 PrnBranchId          PIC BBX(5).
       88 SuppressBranchId  VALUE SPACES.
    02 PrnSalespersonId     PIC BBBBX(6).
    02 PrnSalespersonTotal  PIC BB$$,$$9.99.
    
01  BranchTotalLine.
    02 FILLER               PIC X(43)
       VALUE "                         Branch Total:    ".
    02 PrnBranchTotal       PIC $$$,$$9.99.
       
01  StateTotalLine.
    02 FILLER               PIC X(40)
       VALUE "                         State Total :  ".
    02 PrnStateTotal        PIC $$,$$$,$$9.99. 
    
01  FinalTotalLine.
    02 FILLER               PIC X(39)
       VALUE "                         Final Total :".
    02 PrnFinalTotal        PIC $$$,$$$,$$9.99. 

01  SalespersonTotal        PIC 9(4)V99.
01  BranchTotal             PIC 9(6)V99.
01  StateTotal              PIC 9(7)V99.
01  FinalTotal              PIC 9(9)V99. 

01  PrevStateName           PIC X(14).
01  PrevBranchId            PIC X(5).
01  PrevSalespersonId       PIC X(6).           

PROCEDURE DIVISION.
Begin.
   OPEN INPUT SalesFile
   OPEN OUTPUT SalesReport
   WRITE PrintLine FROM ReportHeading  AFTER ADVANCING 1 LINE
   WRITE PrintLine FROM SubjectHeading AFTER ADVANCING 2 LINE
   
   READ SalesFile
      AT END SET EndOfSalesFile TO TRUE
   END-READ
   PERFORM UNTIL EndOfSalesFile
      MOVE StateName TO PrevStateName, PrnStateName   
      MOVE ZEROS TO StateTotal
      PERFORM SumSalesForState 
              UNTIL StateName NOT = PrevStateName
                    OR EndOfSalesFile 
      MOVE StateTotal TO PrnStateTotal                      
      WRITE PrintLine FROM StateTotalLine AFTER ADVANCING 1 LINE
   END-PERFORM
   
   MOVE FinalTotal TO PrnFinalTotal                      
   WRITE PrintLine FROM FinalTotalLine AFTER ADVANCING 1 LINE

   CLOSE SalesFile, SalesReport
   STOP RUN.
  
SumSalesForState.
    WRITE PrintLine FROM SPACES AFTER ADVANCING 1 LINE
    MOVE BranchId TO PrevBranchId, PrnBranchId
    MOVE ZEROS TO BranchTotal 
    PERFORM SumSalesForBranch
            UNTIL BranchId NOT = PrevBranchId
                  OR StateName NOT = PrevStateName
                  OR EndOfSalesFile                       
      MOVE BranchTotal TO PrnBranchTotal                      
      WRITE PrintLine FROM BranchTotalLine AFTER ADVANCING 1 LINE.   
      
SumSalesForBranch.
    MOVE SalespersonId TO PrevSalespersonId, PrnSalespersonId
    MOVE ZEROS TO SalespersonTotal
    PERFORM SumSalespersonSales
            UNTIL SalespersonId NOT = PrevSalespersonId
                  OR BranchId   NOT = PrevBranchId
                  OR StateName  NOT = PrevStateName
                  OR EndOfSalesFile   
    MOVE SalespersonTotal TO PrnSalespersonTotal
    WRITE PrintLine FROM DetailLine AFTER ADVANCING 1 LINE
    SET SuppressBranchId TO TRUE
    SET SuppressStateName TO TRUE.
    
SumSalespersonSales.
    ADD ValueOfSale TO SalespersonTotal, BranchTotal, StateTotal, FinalTotal
    READ SalesFile
      AT END SET EndOfSalesFile TO TRUE
    END-READ.