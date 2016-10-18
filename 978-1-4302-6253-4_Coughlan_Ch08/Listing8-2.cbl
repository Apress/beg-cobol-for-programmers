IDENTIFICATION DIVISION.
PROGRAM-ID. Listing8-2.
AUTHOR.  Michael Coughlan. 
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    Select ShopReceiptsFile  ASSIGN TO "Listing8-2-ShopSales.dat"
            ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD ShopReceiptsFile.
01 ShopDetails.
   88 EndOfShopReceiptsFile   VALUE HIGH-VALUES.
   02 TypeCode           PIC X.
      88 ShopHeader      VALUE "H".
      88 ShopSale        VALUE "S".
      88 ShopFooter      VALUE "F".
   02 ShopId             PIC X(5).
   02 ShopLocation       PIC X(30).

01 SaleReceipt.
   02 TypeCode           PIC X.
   02 ItemId             PIC X(8).
   02 QtySold            PIC 9(3).
   02 ItemCost           PIC 999V99.

01 ShopSalesCount.
   02 TypeCode           PIC X.
   02 RecCount           PIC 9(5).

WORKING-STORAGE SECTION.
01 PrnShopSalesTotal.
   02 FILLER             PIC X(21) VALUE "Total sales for shop ".
   02 PrnShopId          PIC X(5).
   02 PrnShopTotal       PIC $$$$,$$9.99.
 
01 PrnErrorMessage.
   02 FILLER             PIC X(15) VALUE "Error on Shop: ".
   02 PrnErrorShopId     PIC X(5).
   02 FILLER             PIC X(10) VALUE " RCount = ".
   02 PrnRecCount        PIC 9(5).
   02 FILLER             PIC X(10) VALUE " ACount = ".
   02 PrnActualCount     PIC 9(5).

01 ShopTotal             PIC 9(5)V99.
01 ActualCount           PIC 9(5).
    	
PROCEDURE DIVISION.
ShopSalesSummary.
    OPEN INPUT ShopReceiptsFile
    PERFORM GetHeaderRec
    PERFORM SummarizeCountrySales 
        UNTIL EndOfShopReceiptsFile
    CLOSE ShopReceiptsFile
    STOP RUN.

SummarizeCountrySales.
    MOVE ShopId  TO PrnShopId, PrnErrorShopId
    MOVE ZEROS TO ShopTotal 

    READ ShopReceiptsFile
        AT END SET EndOfShopReceiptsFile TO TRUE
    END-READ
    PERFORM SummarizeShopSales
            VARYING ActualCount FROM 0 BY 1 UNTIL ShopFooter
    IF RecCount = ActualCount
       MOVE ShopTotal TO PrnShopTotal
       DISPLAY PrnShopSalesTotal
     ELSE
       MOVE RecCount TO PrnRecCount
       MOVE ActualCount TO PrnActualCount
       DISPLAY PrnErrorMessage
    END-IF 
    PERFORM GetHeaderRec.
    
SummarizeShopSales.
    COMPUTE  ShopTotal = ShopTotal + (QtySold * ItemCost)
    READ ShopReceiptsFile
        AT END SET EndOfShopReceiptsFile TO TRUE
    END-READ. 

GetHeaderRec.
    READ ShopReceiptsFile
        AT END SET EndOfShopReceiptsFile TO TRUE
    END-READ.
