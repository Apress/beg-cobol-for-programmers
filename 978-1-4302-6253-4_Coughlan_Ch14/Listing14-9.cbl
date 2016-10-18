IDENTIFICATION DIVISION.
PROGRAM-ID. Listing14-9.
AUTHOR. Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT UlsterSales    ASSIGN TO "Listing14-9ulster.dat"
           ORGANIZATION IS LINE SEQUENTIAL.
           
    SELECT ConnachtSales  ASSIGN TO "Listing14-9connacht.dat"
           ORGANIZATION IS LINE SEQUENTIAL.
           
    SELECT MunsterSales   ASSIGN TO "Listing14-9munster.dat"
           ORGANIZATION IS LINE SEQUENTIAL.
           
    SELECT LeinsterSales  ASSIGN TO "Listing14-9leinster.dat"
           ORGANIZATION IS LINE SEQUENTIAL.

    SELECT SummaryFile    ASSIGN TO "Listing14-9.sum"
               ORGANIZATION IS LINE SEQUENTIAL.
               
    SELECT WorkFile       ASSIGN TO "WORK.TMP".

DATA DIVISION.
FILE SECTION.
FD  UlsterSales.
01  FILLER                 PIC X(12).

FD  ConnachtSales.
01  FILLER                 PIC X(12).

FD  MunsterSales.
01  FILLER                 PIC X(12).

FD  LeinsterSales.
01  FILLER                 PIC X(12).

FD  SummaryFile.
01  SummaryRec.
    02 ProductCode-SF      PIC X(6).
    02 TotalSalesValue     PIC 9(6)V99.
    
SD  WorkFile.
01  WorkRec.
    88 EndOfWorkfile       VALUE HIGH-VALUES.
    02 ProductCode-WF      PIC X(6).
    02 ValueOfSale-WF      PIC 9999V99.


PROCEDURE DIVISION.
Begin.
    MERGE WorkFile ON ASCENDING KEY ProductCode-WF
       USING UlsterSales, ConnachtSales, MunsterSales, LeinsterSales
       OUTPUT PROCEDURE IS SummarizeProductSales
       
    STOP RUN.

SummarizeProductSales.
    OPEN OUTPUT SummaryFile
    RETURN WorkFile
       AT END SET EndOfWorkfile TO TRUE
    END-RETURN
    
    PERFORM UNTIL EndOfWorkFile
       MOVE ZEROS TO TotalSalesValue
       MOVE ProductCode-WF TO ProductCode-SF
       PERFORM UNTIL ProductCode-WF NOT EQUAL TO ProductCode-SF
          ADD ValueOfSale-WF TO TotalSalesValue
          RETURN WorkFile
             AT END SET EndOfWorkfile TO TRUE
          END-RETURN    
       END-PERFORM
       WRITE SummaryRec
    END-PERFORM
    CLOSE SummaryFile.
    
         
       