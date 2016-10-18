IDENTIFICATION DIVISION.
PROGRAM-ID. Listing16-8
AUTHOR.  Michael Coughlan.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 CopyData.

COPY Copybook1 
     REPLACING S BY 15.
* Changes the size of a data item


COPY Copybook2 REPLACING ==V99== BY ====.
* Changes the type of a data item to an integer

COPY Copybook3 REPLACING "CustKey" BY "MyValue".
COPY Copybook3 REPLACING CustKey BY NewKey.
* demonstrates the difference between a literal and a COBOL-Word

COPY Copybook3 REPLACING CustKey BY 
==CustAddress.
     03 Adr1         PIC X(10).
     03 Adr2         PIC X(10).
     03 Adr3         PIC X(10).
  02 CustId==.
*Changes the CustKey declaration to add some new data items.
*After REPLACEMENT the included text will be - 
*   02 CustAddress.
*     03 Adr1         PIC X(10).
*     03 Adr2         PIC X(10).
*     03 Adr3         PIC X(10).
*   02 CustId         PIC X(7) VALUE "CustKey".

PROCEDURE DIVISION.
BeginProg.
  MOVE "123456789012345678901234567890" TO CustomerName
  DISPLAY "CustomerName - " CustomerName
  
  MOVE 1234.56 TO CustomerOrder
  DISPLAY "CustomerOrder - " CustomerOrder
  
  DISPLAY "CustKey value changed to - " CustKey
  
  DISPLAY "NewKey value - " NewKey
 
  MOVE "Dublin"  TO Adr3
  
  DISPLAY "CustId value - "CustId
  
STOP RUN.
