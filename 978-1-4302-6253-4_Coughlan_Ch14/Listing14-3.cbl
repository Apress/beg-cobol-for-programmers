IDENTIFICATION DIVISION.
PROGRAM-ID. Listing14-3.
AUTHOR. Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT WorkFile ASSIGN TO "WORK.TMP".
    
    SELECT BillableServicesFile  ASSIGN TO "Listing14-3.dat"
           ORGANIZATION LINE SEQUENTIAL.
    
    SELECT SortedSubscriberFile   ASSIGN TO "Listing14-3.Srt"
               ORGANIZATION LINE SEQUENTIAL.
               
    SELECT PrintFile  ASSIGN TO "Listing14-3.prn"
               ORGANIZATION LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  BillableServicesFile.
01  SubscriberRec-BSF.
    88 EndOfBillableServicesFile VALUE HIGH-VALUES.
    02 SubscriberId-BSF   PIC 9(10).
    02 ServiceType-BSF    PIC 9.
    02 FILLER             PIC X(6).

SD  WorkFile.
01  WorkRec.
    02 SubscriberId-WF    PIC 9(10).
    02 ServiceType-WF     PIC 9.

FD  SortedSubscriberFile.
01  SubscriberRec.
    88 EndOfCallsFile   VALUE HIGH-VALUES.
    02 SubscriberId       PIC 9(10).
    02 ServiceType        PIC 9.
       88 VoiceCall       VALUE 2.

FD PrintFile.
01 PrintRec               PIC X(40).
    
WORKING-STORAGE SECTION.
01 CallsTotal             PIC 9(4).

01 TextsTotal             PIC 9(5).

01 ReportHeader           PIC X(33) VALUE "Universal Telecoms Monthly Report".

01 SubjectHeader          PIC X(31) VALUE "SubscriberId    Calls     Texts".

01 SubscriberLine.
   02 PrnSubscriberId     PIC 9(10).
   02 FILLER              PIC X(6) VALUE SPACES.
   02 PrnCallsTotal       PIC Z,ZZ9.
   02 FILLER              PIC X(4) VALUE SPACES.
   02 PrnTextsTotal       PIC ZZ,ZZ9.  
    
01 PrevSubscriberId       PIC 9(10).
   


PROCEDURE DIVISION.
Begin.
    SORT WorkFile ON ASCENDING KEY SubscriberId-WF 
           INPUT PROCEDURE IS ModifySubscriberRecords
           GIVING SortedSubscriberFile
    OPEN OUTPUT PrintFile
    OPEN INPUT SortedSubscriberFile
    WRITE PrintRec FROM ReportHeader AFTER ADVANCING PAGE
    WRITE PrintRec FROM SubjectHeader AFTER ADVANCING 1 LINE

    READ SortedSubscriberFile
      AT END SET EndOfCallsFile TO TRUE
    END-READ
    PERFORM UNTIL EndOfCallsFile
       MOVE SubscriberId TO PrevSubscriberId, PrnSubscriberId
       MOVE ZEROS TO CallsTotal, TextsTotal
       PERFORM UNTIL SubscriberId NOT EQUAL TO PrevSubscriberId
          IF VoiceCall ADD 1 TO CallsTotal
             ELSE ADD 1 TO TextsTotal
          END-IF
          READ SortedSubscriberFile
               AT END SET EndOfCallsFile TO TRUE
          END-READ
       END-PERFORM
       MOVE CallsTotal TO PrnCallsTotal
       MOVE TextsTotal TO PrnTextsTotal
       WRITE PrintRec FROM SubscriberLine AFTER ADVANCING 1 LINE
    END-PERFORM
    CLOSE SortedSubscriberFile, PrintFile
    STOP RUN.

ModifySubscriberRecords.
    OPEN INPUT BillableServicesFile
    READ BillableServicesFile
         AT END SET EndOfBillableServicesFile TO TRUE
    END-READ
    PERFORM UNTIL EndOfBillableServicesFile   
       MOVE SubscriberId-BSF TO SubscriberId-WF 
       MOVE ServiceType-BSF  TO ServiceType-WF
       RELEASE WorkRec
       READ BillableServicesFile
            AT END SET EndOfBillableServicesFile TO TRUE
       END-READ
    END-PERFORM
    CLOSE BillableServicesFile.
