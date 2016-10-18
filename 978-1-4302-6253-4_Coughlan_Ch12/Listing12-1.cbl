IDENTIFICATION DIVISION.
PROGRAM-ID. Listing12-1.
AUTHOR.  Michael Coughlan.
* This program produces a summary report showing the sales of base oils
* to Aromamora customers by processing the OilSalesFile.  The OilSalesFile is a
* sequential file ordered on ascending CustomerId.  The report is required to be
* printed in ascending CustomerId order.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
       SELECT BaseOilsSalesFile ASSIGN TO "Listing12-1.Dat"
                 ORGANIZATION IS LINE SEQUENTIAL.

       SELECT SummaryReport ASSIGN TO "Listing12-1.Rpt"
                 ORGANIZATION IS LINE SEQUENTIAL.
                 
DATA DIVISION.
FILE SECTION.
FD  BaseOilsSalesFile.
01  SalesRec.
    88  EndOfSalesFile         VALUE HIGH-VALUES.
    02  CustomerId             PIC X(5).
    02  CustomerName           PIC X(20).
    02  OilId.
        03 FILLER              PIC X.
        03 OilNum              PIC 99.
    02  UnitSize               PIC 9.
    02  UnitsSold              PIC 999.

FD SummaryReport.
01 PrintLine                   PIC X(45).

WORKING-STORAGE SECTION.
01  OilsTable.
    02  OilTableValues.
        03 FILLER  PIC X(28) VALUE "Almond          020003500650".
        03 FILLER  PIC X(28) VALUE "Aloe vera       047508501625".
        03 FILLER  PIC X(28) VALUE "Apricot kernel  025004250775".
        03 FILLER  PIC X(28) VALUE "Avocado         027504750875".
        03 FILLER  PIC X(28) VALUE "Coconut         027504750895".
        03 FILLER  PIC X(28) VALUE "Evening primrose037506551225".
        03 FILLER  PIC X(28) VALUE "Grape seed      018503250600".
        03 FILLER  PIC X(28) VALUE "Peanut          027504250795".
        03 FILLER  PIC X(28) VALUE "Jojoba          072513252500".
        03 FILLER  PIC X(28) VALUE "Macadamia       032505751095".
        03 FILLER  PIC X(28) VALUE "Rosehip         052509951850".
        03 FILLER  PIC X(28) VALUE "Sesame          029504250750".
        03 FILLER  PIC X(28) VALUE "Walnut          027504550825".
        03 FILLER  PIC X(28) VALUE "Wheatgerm       045007751425".
    02  FILLER REDEFINES OilTableValues.
        03 BaseOil OCCURS 14 TIMES.
           04 OilName    PIC X(16).
           04 UnitCost   PIC 99V99 OCCURS 3 TIMES.

01  ReportHeadingLine      PIC X(41)
            VALUE " Aromamora Base Oils Summary Sales Report".

01  TopicHeadingLine.
    02  FILLER             PIC X(9)  VALUE "Cust Id".
    02  FILLER             PIC X(15) VALUE "Customer Name".
    02  FILLER             PIC X(7)  VALUE SPACES.
    02  FILLER             PIC X(12) VALUE "ValueOfSales".
    
01  ReportFooterLine       PIC X(43) 
            VALUE "************** End of Report **************".         

01  CustSalesLine.
    02  PrnCustId          PIC B9(5).
    02  PrnCustName        PIC BBBX(20).
    02  PrnCustTotalSales  PIC BBB$$$$,$$9.99.                 


01  CustTotalSales         PIC 9(6)V99. 
01  PrevCustId             PIC X(5).
01  ValueOfSale            PIC 9(5)V99.


PROCEDURE DIVISION.
Print-Summary-Report.    
    OPEN OUTPUT SummaryReport
    OPEN INPUT BaseOilsSalesFile
    
    WRITE PrintLine FROM ReportHeadingLine AFTER ADVANCING 1 LINE
    WRITE PrintLine FROM TopicHeadingLine  AFTER ADVANCING 2 LINES

    READ BaseOilsSalesFile
        AT END SET EndOfSalesFile TO TRUE
    END-Read

    PERFORM PrintCustomerLines UNTIL EndOfSalesFile
    
    WRITE PrintLine FROM ReportFooterLine AFTER ADVANCING 3 LINES

    CLOSE SummaryReport, BaseOilsSalesFile
    STOP RUN.

PrintCustomerLines.
    MOVE ZEROS TO CustTotalSales  
    MOVE CustomerId TO PrnCustId, PrevCustId
    MOVE CustomerName TO PrnCustName

    PERFORM UNTIL CustomerId NOT = PrevCustId
        COMPUTE ValueOfSale = UnitsSold * UnitCost(OilNum, UnitSize)
        ADD ValueOfSale TO CustTotalSales
        READ BaseOilsSalesFile
           AT END SET EndOfSalesFile TO TRUE
        END-Read
    END-PERFORM

    MOVE CustTotalSales TO PrnCustTotalSales 
    WRITE PrintLine FROM CustSalesLine AFTER ADVANCING 2 LINES.
