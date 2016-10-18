IDENTIFICATION DIVISION.
PROGRAM-ID. Listing14-1.
AUTHOR. Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT WorkFile ASSIGN TO "WORK.TMP".
    
    SELECT BillableServicesFile  ASSIGN TO "Listing14-1.dat"
           ORGANIZATION LINE SEQUENTIAL.
    
    SELECT SortedBillablesFile   ASSIGN TO "Listing14-1.Srt"
               ORGANIZATION LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.

FD  BillableServicesFile.
01  SalesRec              PIC X(17).

SD  WorkFile.
01  WorkRec.
    02 SubscriberId-WF    PIC 9(10).
    02 FILLER             PIC X(7).

FD  SortedBillablesFile.
01  SubscriberRec.
    88 EndOfBillablesFile   VALUE HIGH-VALUES.
    02 SubscriberId       PIC 9(10).
    02 ServiceType        PIC 9.
    02 ServiceCost        PIC 9(4)V99.
    
WORKING-STORAGE SECTION.
01 SubscriberTotal        PIC 9(5)V99.

01 ReportHeader           PIC X(33) VALUE "Universal Telecoms Monthly Report".

01 SubjectHeader          PIC X(31) VALUE "SubscriberId      BillableValue".

01 SubscriberLine.
   02 PrnSubscriberId     PIC 9(10).
   02 FILLER              PIC X(8) VALUE SPACES.
   02 PrnSubscriberTotal  PIC $$$,$$9.99.
   
01 PrevSubscriberId       PIC 9(10).
   


PROCEDURE DIVISION.
Begin.
    SORT WorkFile ON ASCENDING KEY SubscriberId-WF 
           USING BillableServicesFile 
           GIVING SortedBillablesFile
    DISPLAY ReportHeader
    DISPLAY SubjectHeader
    OPEN INPUT SortedBillablesFile
    READ SortedBillablesFile
      AT END SET EndOfBillablesFile TO TRUE
    END-READ
    PERFORM UNTIL EndOfBillablesFile
       MOVE SubscriberId TO PrevSubscriberId, PrnSubscriberId
       MOVE ZEROS TO SubscriberTotal
       PERFORM UNTIL SubscriberId NOT EQUAL TO PrevSubscriberId
          ADD ServiceCost TO SubscriberTotal
          READ SortedBillablesFile
               AT END SET EndOfBillablesFile TO TRUE
          END-READ
       END-PERFORM
       MOVE SubscriberTotal TO PrnSubscriberTotal
       DISPLAY SubscriberLine
    END-PERFORM
    CLOSE SortedBillablesFile
    STOP RUN.

