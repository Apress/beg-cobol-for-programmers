IDENTIFICATION DIVISION.
PROGRAM-ID. Listing11-4.
AUTHOR. Michael Coughlan.
* A three level Control Break program to process the Electronics2Go 
* Sales file and produce a report that shows the value of sales for 
* each Salesperson, each Branch, each State, and for the Country.
* The SalesFile is sorted on ascending SalespersonId within BranchId
* within StateNum. 
* The report must be printed in SalespersonId within BranchId
* within StateName.  There is a correspondence between StateNum order 
* and StateName order such that the order of records in 
* the file is the same if the file is ordered on ascending StateNum 
* as it is when the file is ordered on ascending StateName


ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
SELECT SalesFile ASSIGN TO "Listing11-4TestData.Dat"
                 ORGANIZATION IS LINE SEQUENTIAL.
                      
SELECT SalesReport ASSIGN TO "Listing11-4.RPT"
                   ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  SalesFile.
01  SalesRecord.
    88 EndOfSalesFile VALUE HIGH-VALUES.
    02 StateNum          PIC 99.
    02 BranchId          PIC X(5).
    02 SalesPersonId     PIC X(6).
    02 ValueOfSale       PIC 9(4)V99.
    
FD SalesReport.
01 PrintLine             PIC X(55).

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
   03 StateName PIC X(14) OCCURS 50 TIMES.

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

01  PrevStateNum            PIC 99.
01  PrevBranchId            PIC X(5).
01  PrevSalespersonId       PIC X(6).  

         

PROCEDURE DIVISION.
Begin.
   OPEN INPUT SalesFile
   OPEN OUTPUT SalesReport
   WRITE PrintLine FROM ReportHeading  AFTER ADVANCING 1 LINE
   WRITE PrintLine FROM SubjectHeading AFTER ADVANCING 1 LINE
   
   READ SalesFile
      AT END SET EndOfSalesFile TO TRUE
   END-READ
   PERFORM UNTIL EndOfSalesFile
      MOVE StateNum TO PrevStateNum, 
      MOVE StateName(StateNum) TO PrnStateName   
      MOVE ZEROS TO StateTotal
      PERFORM SumSalesForState 
              UNTIL StateNum NOT = PrevStateNum
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
                  OR StateNum NOT = PrevStateNum
                  OR EndOfSalesFile                       
      MOVE BranchTotal TO PrnBranchTotal                      
      WRITE PrintLine FROM BranchTotalLine AFTER ADVANCING 1 LINE.   
      
SumSalesForBranch.
    MOVE SalespersonId TO PrevSalespersonId, PrnSalespersonId
    MOVE ZEROS TO SalespersonTotal
    PERFORM SumSalespersonSales
            UNTIL SalespersonId NOT = PrevSalespersonId
                  OR BranchId   NOT = PrevBranchId
                  OR StateNum  NOT = PrevStateNum
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
