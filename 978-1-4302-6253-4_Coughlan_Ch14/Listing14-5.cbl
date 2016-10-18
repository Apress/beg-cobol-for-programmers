IDENTIFICATION DIVISION.
PROGRAM-ID. Listing14-5.
AUTHOR. Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT WorkFile ASSIGN TO "WORK.TMP".
    
    SELECT BillableServicesFile  ASSIGN TO "Listing14-5.dat"
           ORGANIZATION LINE SEQUENTIAL.
    
    SELECT SortedSummaryFile   ASSIGN TO "Listing14-5.Srt"
               ORGANIZATION LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  BillableServicesFile.
01  SubscriberRec-BSF     PIC X(17).

SD  WorkFile.
01  WorkRec.
    88 EndOfWorkFile      VALUE HIGH-VALUES.
    02 SubscriberId-WF    PIC 9(10).
    02 FILLER             PIC 9.
       88 TextCall        VALUE 1.
       88 VoiceCall       VALUE 2.
    02 ServiceCost-WF     PIC 9(4)V99.

FD  SortedSummaryFile.
01  SummaryRec.
    02 SubscriberId       PIC 9(10).
    02 CostOfTexts        PIC 9(4)V99.
    02 CostOfCalls        PIC 9(6)V99.
    
PROCEDURE DIVISION.
Begin.
    SORT WorkFile ON ASCENDING KEY SubscriberId-WF 
           USING BillableServicesFile 
           OUTPUT PROCEDURE IS CreateSummaryFile
    STOP RUN.

CreateSummaryFile.
    OPEN OUTPUT SortedSummaryFile
    RETURN WorkFile
      AT END SET EndOfWorkFile TO TRUE
    END-RETURN
    PERFORM UNTIL EndOfWorkFile
       MOVE ZEROS TO CostOfTexts, CostOfCalls
       MOVE SubscriberId-WF TO SubscriberId
       PERFORM UNTIL SubscriberId-WF NOT EQUAL TO SubscriberId
          IF VoiceCall 
             ADD ServiceCost-WF TO CostOfCalls
           ELSE
             ADD ServiceCost-WF TO CostOfTexts
          END-IF          
          RETURN WorkFile
             AT END SET EndOfWorkFile TO TRUE
          END-RETURN
       END-PERFORM
       WRITE SummaryRec
    END-PERFORM
    CLOSE SortedSummaryFile.
          