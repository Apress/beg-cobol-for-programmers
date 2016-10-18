IDENTIFICATION DIVISION.
PROGRAM-ID. Listing18-4.
AUTHOR.  MICHAEL COUGHLAN.
*The Campus Bookshop Purchase Requirements Report (DP291-91-EXAM)
*Originally written for VAX COBOL 1991
*Converted to Microfocus COBOL 2002
*Modified for COBOL book 2014


ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT PurchaseReqFile  ASSIGN TO "Listing18-4-PRF.DAT"
        ORGANIZATION IS INDEXED
        FILE STATUS IS FileStatus-PRF
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS PRNumber-PRF
        ALTERNATE RECORD KEY IS LecturerName-PRF
                WITH DUPLICATES
        ALTERNATE RECORD KEY IS BookNum-PRF
                WITH DUPLICATES.

    SELECT BookFile ASSIGN TO "Listing18-4-BF.DAT"
        ORGANIZATION IS INDEXED
        FILE STATUS IS FileStatus-BF
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS BookNum-BF
        ALTERNATE RECORD KEY IS PublisherNum-BF
                WITH DUPLICATES.

    SELECT PublisherFile ASSIGN TO "Listing18-4-PF.DAT"
        ORGANIZATION IS INDEXED
        FILE STATUS IS FileStatus-PF
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS PublisherNum-PF
        ALTERNATE RECORD KEY IS PublisherName-PF.

    SELECT ReportFile ASSIGN TO "Listing18-4.RPT".

DATA DIVISION.
FILE SECTION.
FD  PurchaseReqFile.
01  PurchaseRec-PRF.
    88 EndOfPRequirements     VALUE HIGH-VALUES.
    88 NotEndOfPRequirements  VALUE LOW-VALUES.
    02  PRNumber-PRF          PIC 9(4).
    02  LecturerName-PRF      PIC X(20).
    02  BookNum-PRF           PIC 9(4).
    02  ModuleCode-PRF        PIC X(5).
    02  CopiesRequired-PRF    PIC 9(3).
    02  Semester-PRF          PIC 9.
    
FD  BookFile.
01  BookRec-BF.
    88 EndOfBooks             VALUE HIGH-VALUES.
    88 NotEndOfBooks          VALUE LOW-VALUES.
    02  BookNum-BF            PIC 9(4).
    02  PublisherNum-BF       PIC 9(4).
    02  BookTitle-BF          PIC X(30).    


FD  PublisherFile.
01  PublisherRec-PF.
    88  EndOfPublishers       VALUE HIGH-VALUES.
    02  PublisherNum-PF       PIC 9(4).
    02  PublisherName-PF      PIC X(20).
    02  PublisherAddress-PF   PIC X(40).

FD  ReportFile
    REPORT IS PurchaseRequirementsReport.

WORKING-STORAGE SECTION.
01  File-Stati.
    02  FileStatus-PRF        PIC X(2).
        88 PurchaseRec-PRF-Not-Found   VALUE "23".
    02  FileStatus-BF         PIC X(2).
        88 BookRec-Not-Found   VALUE "23".
    02  FileStatus-PF         PIC X(2).
        

01  Current-Semester          PIC 9.



REPORT SECTION.
RD  PurchaseRequirementsReport
    CONTROLS ARE     FINAL 
                     PublisherName-PF
    PAGE LIMIT IS 66
    HEADING 2
    FIRST DETAIL 8
    LAST DETAIL 50
    FOOTING 55.


01  TYPE IS REPORT FOOTING.
    02  LINE 56.
        03  COLUMN 29         PIC X(23)
                    VALUE "*** END  OF  REPORT ***".

01  TYPE IS PAGE HEADING.
    02  LINE 2.
        03  COLUMN 27         PIC X(30)
                    VALUE "PURCHASE  REQUIREMENTS  REPORT".
        03  COLUMN 77         PIC X(6)
                    VALUE "PAGE :".
        03  COLUMN 84         PIC Z9 SOURCE PAGE-COUNTER.

    02  LINE 3.
        03  COLUMN 26         PIC X(32) VALUE ALL "-".

    02  LINE 6.
        03  COLUMN 2          PIC X(24) VALUE "PUBLISHER NAME".
        03  COLUMN 33         PIC X(11) VALUE "BOOK  TITLE".
        03  COLUMN 57         PIC X(3)  VALUE "QTY".
        03  COLUMN 65         PIC X(14) VALUE "LECTURER  NAME".


01  PReq-PrintLine TYPE IS DETAIL.
    02  LINE IS PLUS 2.
        03  COLUMN 1          PIC X(20) SOURCE PublisherName-PF
                              GROUP INDICATE.
        03  COLUMN 24         PIC X(30)  SOURCE BookTitle-BF.
        03  COLUMN 57         PIC ZZ9    SOURCE CopiesRequired-PRF.
        03  COLUMN 63         PIC X(20)  SOURCE LecturerName-PRF.

PROCEDURE DIVISION.
BEGIN.
   DISPLAY "Enter the semester number (1 or 2) - " WITH NO ADVANCING
   ACCEPT Current-Semester
   OPEN INPUT PurchaseReqFile
   OPEN INPUT BookFile
   OPEN INPUT PublisherFile
   OPEN OUTPUT ReportFile
   INITIATE PurchaseRequirementsReport

   MOVE SPACES TO PublisherName-PF
   START PublisherFile
         KEY IS GREATER THAN PublisherName-PF
         INVALID KEY DISPLAY "START Pub file status" FileStatus-PF
   END-START
   READ PublisherFile NEXT RECORD
         AT END SET EndOfPublishers TO TRUE
   END-READ
   PERFORM PrintRequirementsReport UNTIL EndOfPublishers

   TERMINATE PurchaseRequirementsReport
   CLOSE   PurchaseReqFile, BookFile,
           PublisherFile, ReportFile
   STOP RUN.

PrintRequirementsReport.
    SET NotEndOfBooks TO TRUE
    MOVE PublisherNum-PF TO PublisherNum-BF  
    READ BookFile
        KEY IS PublisherNum-BF
        INVALID KEY
            DISPLAY SPACES
            DISPLAY "Book File Error.  FileStatus = "  FileStatus-BF
            DISPLAY "Publisher Number - " PublisherNum-BF
            DISPLAY "Publisher Rec = " PublisherRec-PF
            MOVE ZEROS TO PublisherNum-BF
    END-READ

    PERFORM ProcessPublisher 
        UNTIL PublisherNum-PF NOT EQUAL TO PublisherNum-BF 
              OR EndOfBooks
    
    READ PublisherFile NEXT RECORD
        AT END SET EndOfPublishers TO TRUE
    END-READ.

ProcessPublisher.
    SET NotEndOfPRequirements TO TRUE
    MOVE BookNum-BF TO BookNum-PRF
    READ PurchaseReqFile
        KEY IS BookNum-PRF
        INVALID KEY
           DISPLAY SPACES
           DISPLAY "PurchReqFile Error. FileStatus = " FileStatus-PRF
           DISPLAY "Book Num PRF = " BookNum-PRF
           DISPLAY "Book Rec = " BookRec-BF
           MOVE ZEROS TO BookNum-PRF
    END-READ

    PERFORM UNTIL BookNum-BF NOT EQUAL TO BookNum-PRF
            OR EndOfPRequirements
                IF Current-Semester = Semester-PRF THEN
            Generate PReq-PrintLine
        END-IF
        READ PurchaseReqFile NEXT RECORD
            AT END SET EndOfPRequirements TO TRUE
        END-READ
    END-PERFORM
    
    READ BookFile NEXT RECORD
        AT END SET EndOfBooks TO TRUE
    END-READ.
