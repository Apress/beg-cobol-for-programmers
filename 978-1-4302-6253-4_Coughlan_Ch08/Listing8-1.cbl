IDENTIFICATION DIVISION.
PROGRAM-ID. Listing8-1.
AUTHOR.  Michael Coughlan. 
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    Select ShopReceiptsFile  ASSIGN TO "Listing8-1-ShopSales.Dat"
            ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD ShopReceiptsFile. 
01 ShopDetails.
   88 EndOfShopReceiptsFile   VALUE HIGH-VALUES.
   02 RecTypeCode        PIC X.
      88 ShopHeader      VALUE "H".
      88 ShopSale        VALUE "S".
   02 ShopId             PIC X(5).
   02 ShopLocation       PIC X(30).

01 SaleReceipt.
   02 RecTypeCode        PIC X.
   02 ItemId             PIC X(8).
   02 QtySold            PIC 9(3).
   02 ItemCost           PIC 999V99.

WORKING-STORAGE SECTION.
01 PrnShopSalesTotal.
   02 FILLER             PIC X(21) VALUE "Total sales for shop ".
   02 PrnShopId          PIC X(5).
   02 PrnShopTotal       PIC $$$$,$$9.99. 

01 ShopTotal             PIC 9(5)V99.

PROCEDURE DIVISION.
ShopSalesSummary.
    OPEN INPUT ShopReceiptsFile
    READ ShopReceiptsFile
        AT END SET EndOfShopReceiptsFile TO TRUE
    END-READ
    PERFORM SummarizeCountrySales 
        UNTIL EndOfShopReceiptsFile
    CLOSE ShopReceiptsFile
    STOP RUN.

SummarizeCountrySales.
    MOVE ShopId  TO PrnShopId
    MOVE ZEROS TO ShopTotal 
    READ ShopReceiptsFile
        AT END SET EndOfShopReceiptsFile TO TRUE
    END-READ
    PERFORM SummarizeShopSales
            UNTIL ShopHeader OR EndOFShopReceiptsFile
    MOVE ShopTotal TO PrnShopTotal
    DISPLAY PrnShopSalesTotal.
    
SummarizeShopSales.
    COMPUTE  ShopTotal = ShopTotal + (QtySold * ItemCost)
    READ ShopReceiptsFile
        AT END SET EndOfShopReceiptsFile TO TRUE
    END-READ. 
