IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing7-4.
AUTHOR. Michael Coughlan

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   SELECT GadgetStockFile ASSIGN TO "input.txt"
          ORGANIZATION IS LINE SEQUENTIAL.
          
DATA DIVISION.
FILE SECTION.
FD GadgetStockFile.
01 StockRec.
   88 EndOfStockFile      VALUE HIGH-VALUES.
   02 GadgetID         PIC 9(6).
   02 GadgetName       PIC X(30).
   02 QtyInStock       PIC 9(4).
   02 Price            PIC 9(4)V99.
   
WORKING-STORAGE SECTION.
01 PrnStockValue.
   02 PrnGadgetName      PIC X(30).
   02 FILLER             PIC XX VALUE SPACES.
   02 PrnValue           PIC $$$,$$9.99.

01 PrnFinalStockTotal.
   02 FILLER              PIC X(16) VALUE SPACES.
   02 FILLER              PIC X(16) VALUE "Stock Total:".
   02 PrnFinalTotal       PIC $$$,$$9.99.
   
01 FinalStockTotal        PIC 9(6)V99.
01 StockValue             PIC 9(6)V99.
     
?
PROCEDURE DIVISION.
Begin.
    OPEN INPUT GadgetStockFile
    READ GadgetStockFile
       AT END SET EndOfStockFile TO TRUE
    END-READ
    PERFORM DisplayGadgetValues UNTIL EndOfStockFile
    MOVE FinalStockTotal TO PrnFinalTotal
    DISPLAY PrnFinalStockTotal    
    CLOSE GadgetStockFile
    STOP RUN.

DisplayGadgetValues.
    COMPUTE StockValue = Price * QtyInStock
    ADD StockValue  TO FinalStockTotal  
    MOVE GadgetName TO PrnGadgetName 
    MOVE StockValue TO PrnValue     
    DISPLAY PrnStockValue
    READ GadgetStockFile
         AT END SET EndOfStockFile TO TRUE
    END-READ.




