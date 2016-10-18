IDENTIFICATION DIVISION.
PROGRAM-ID. Listing9-3.
AUTHOR. Michael Coughlan.
ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CURRENCY SIGN IS "£"
    CURRENCY SIGN IS "$"
    CURRENCY SIGN IS "¥".
    
DATA DIVISION.
WORKING-STORAGE SECTION.
01  DollarValue      PIC 9999V99.

01  PrnDollarValue   PIC $$$,$$9.99.
01  PrnYenValue      PIC ¥¥¥,¥¥9.99.
01  PrnPoundValue    PIC £££,££9.99.

01  Dollar2PoundRate PIC 99V9(6) VALUE 0.640138.
01  Dollar2YenRate   PIC 99V9(6) VALUE 98.6600.

PROCEDURE DIVISION.
Begin.
   DISPLAY "Enter a dollar value to convert :- " WITH NO ADVANCING
   ACCEPT DollarValue
   MOVE DollarValue TO PrnDollarValue
   
   COMPUTE PrnYenValue ROUNDED = DollarValue * Dollar2YenRate  

   COMPUTE PrnPoundValue ROUNDED = DollarValue * Dollar2PoundRate
    
   DISPLAY "Dollar value    = " PrnDollarValue
   DISPLAY "Yen value       = " PrnYenValue   
   DISPLAY "Pound value     = " PrnPoundValue

   STOP RUN.

