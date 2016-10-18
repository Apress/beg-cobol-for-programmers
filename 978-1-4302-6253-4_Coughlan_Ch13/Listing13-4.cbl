IDENTIFICATION DIVISION.
PROGRAM-ID. Listing13-4.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 JeansSalesTable.
   02 Shop OCCURS 150 TIMES INDEXED BY ShopIdx.
      03 ShopName	    PIC X(15) VALUE SPACES.
      03 JeansColor OCCURS 3 TIMES.
         04 TotalSold	PIC 9(5)  VALUE ZEROS.  

            
01 ShopQuery            PIC X(15).

01 PrnWhiteJeans.
   02 PrnWhiteTotal     PIC ZZ,ZZ9.
   02 FILLER            PIC X(12) VALUE " white jeans".
   
01 PrnBlueJeans.   
   02 PrnBlueTotal      PIC ZZ,ZZ9.
   02 FILLER            PIC X(12) VALUE " blue  jeans".
   
01 PrnBlackJeans.   
   02 PrnBlackTotal     PIC ZZ,ZZ9.
   02 FILLER            PIC X(12) VALUE " black jeans".     

   
         
PROCEDURE DIVISION.
Begin.
    MOVE "Jean Therapy" TO ShopName(3), ShopQuery
    MOVE 00734 TO TotalSold(3, 1)
    MOVE 04075 TO TotalSold(3, 2)
    MOVE 01187 TO TotalSold(3, 3)
   
    SET ShopIdx TO 1
    SEARCH Shop
       AT END Display "Shop not found"  
       WHEN ShopName(ShopIdx) = ShopQuery
           MOVE TotalSold(ShopIdx, 1) TO PrnWhiteTotal
           MOVE TotalSold(ShopIdx, 2) TO PrnBlueTotal
           MOVE TotalSold(ShopIdx, 3) TO PrnBlackTotal
           DISPLAY "Sold by " ShopQuery 
           DISPLAY PrnWhiteJeans
           DISPLAY PrnBlueJeans
           DISPLAY PrnBlackJeans           
    END-SEARCH
    STOP RUN.