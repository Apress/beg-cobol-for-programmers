IDENTIFICATION DIVISION.
PROGRAM-ID. Listing14-2.
AUTHOR. Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT WorkFile ASSIGN TO "WORK.TMP".
    
    SELECT BillableServicesFile  ASSIGN TO "Listing14-2.dat"
           ORGANIZATION LINE SEQUENTIAL.
    
    SELECT SortedCallsFile   ASSIGN TO "Listing14-2.Srt"
               ORGANIZATION LINE SEQUENTIAL.
               
    SELECT PrintFile  ASSIGN TO "Listing14-2.prn"
               ORGANIZATION LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  BillableServicesFile.
01  SubscriberRec-BSF.
    88 EndOfBillableServicesFile VALUE HIGH-VALUES.
    02 FILLER           PIC X(10).
    02 FILLER           PIC 9.
       88 VoiceCall     VALUE 2.
    02 FILLER           PIC X(6).     

SD  WorkFile.
01  WorkRec.
    02 SubscriberId-WF    PIC 9(10).
    02 FILLER             PIC X(7).

FD  SortedCallsFile.
01  SubscriberRec.
    88 EndOfCallsFile   VALUE HIGH-VALUES.
    02 SubscriberId       PIC 9(10).
    02 ServiceType        PIC 9.
    02 ServiceCost        PIC 9(4)V99.    

FD PrintFile.
01 PrintRec               PIC X(40).
    
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
           INPUT PROCEDURE IS SelectVoiceCalls
           GIVING SortedCallsFile
    OPEN OUTPUT PrintFile
    OPEN INPUT SortedCallsFile
    WRITE PrintRec FROM ReportHeader AFTER ADVANCING PAGE
    WRITE PrintRec FROM SubjectHeader AFTER ADVANCING 1 LINE

    READ SortedCallsFile
      AT END SET EndOfCallsFile TO TRUE
    END-READ
    PERFORM UNTIL EndOfCallsFile
       MOVE SubscriberId TO PrevSubscriberId, PrnSubscriberId
       MOVE ZEROS TO SubscriberTotal
       PERFORM UNTIL SubscriberId NOT EQUAL TO PrevSubscriberId
          ADD ServiceCost TO SubscriberTotal
          READ SortedCallsFile
               AT END SET EndOfCallsFile TO TRUE
          END-READ
       END-PERFORM
       MOVE SubscriberTotal TO PrnSubscriberTotal
       WRITE PrintRec FROM SubscriberLine AFTER ADVANCING 1 LINE
    END-PERFORM
    CLOSE SortedCallsFile, PrintFile
    STOP RUN.

SelectVoiceCalls.
    OPEN INPUT BillableServicesFile
    READ BillableServicesFile
         AT END SET EndOfBillableServicesFile TO TRUE
    END-READ
    PERFORM UNTIL EndOfBillableServicesFile
       IF VoiceCall 
          RELEASE WorkRec FROM SubscriberRec-BSF
       END-IF
       READ BillableServicesFile
            AT END SET EndOfBillableServicesFile TO TRUE
       END-READ
    END-PERFORM
    CLOSE BillableServicesFile.