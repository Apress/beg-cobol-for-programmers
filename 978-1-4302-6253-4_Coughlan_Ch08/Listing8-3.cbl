IDENTIFICATION DIVISION.
PROGRAM-ID. Listing8-3.
AUTHOR. Michael Coughlan.
ENVIRONMENT DIVISION. 
INPUT-OUTPUT SECTION. 
FILE-CONTROL. 
    SELECT MembershipReport 
           ASSIGN TO "Listing8-3-Members.rpt"
           ORGANIZATION IS SEQUENTIAL. 
           
    SELECT MemberFile  ASSIGN TO "Listing8-3-Members.dat"
           ORGANIZATION IS LINE SEQUENTIAL.
           
DATA DIVISION. 
FILE SECTION.
FD  MembershipReport. 
01  PrintLine        PIC X(44).

FD  MemberFile.
01  MemberRec.
    88 EndOfMemberFile   VALUE HIGH-VALUES.
    02 MemberId      PIC X(5).
    02 MemberName    PIC X(20).
    02 MemberType    PIC 9.
    02 Gender        PIC X.


WORKING-STORAGE SECTION.
01  PageHeading.
    02 FILLER        PIC X(44)
       VALUE "Rolling Greens Golf Club - Membership Report".
 
01  PageFooting.
    02 FILLER        PIC X(15) VALUE SPACES.
    02 FILLER        PIC X(7)  VALUE "Page : ".
    02 PrnPageNum    PIC Z9.

01  ColumnHeadings   PIC X(41) 
                     VALUE "MemberID  Member Name         Type Gender".

01  MemberDetailLine.
    02 FILLER        PIC X  VALUE SPACES.
    02 PrnMemberId   PIC 9(5).
    02 FILLER        PIC X(4) VALUE SPACES.
    02 PrnMemberName PIC X(20).
    02 FILLER        PIC XX VALUE SPACES.
    02 PrnMemberType PIC X.
    02 FILLER        PIC X(4) VALUE SPACES.
    02 PrnGender     PIC X.

01  ReportFooting    PIC X(38)
       VALUE "**** End of Membership Report ****".

01  LineCount        PIC 99 VALUE ZEROS.
    88 NewPageRequired  VALUE 40 THRU 99.

01  PageCount        PIC 99 VALUE ZEROS.
       
PROCEDURE DIVISION.
PrintMembershipReport.
   OPEN INPUT MemberFile
   OPEN OUTPUT MembershipReport
   PERFORM PrintPageHeadings
   READ MemberFile
        AT END SET EndOfMemberFile TO TRUE
   END-READ
   PERFORM PrintReportBody UNTIL EndOfMemberFile
   WRITE PrintLine FROM ReportFooting AFTER ADVANCING 5 LINES
   CLOSE MemberFile, MembershipReport
   STOP RUN.

PrintPageHeadings.
   WRITE PrintLine FROM PageHeading AFTER ADVANCING PAGE
   WRITE PrintLine FROM ColumnHeadings AFTER ADVANCING 2 LINES
   MOVE 3 TO LineCount
   ADD 1 TO PageCount.


PrintReportBody.
   IF NewPageRequired
      MOVE PageCount TO PrnPageNum
      WRITE PrintLine FROM PageFooting AFTER ADVANCING 5 LINES
      PERFORM PrintPageHeadings
   END-IF.
   MOVE MemberId   TO PrnMemberId
   MOVE MemberName TO PrnMemberName
   MOVE MemberType TO PrnMemberType
   MOVE Gender     TO PrnGender
   WRITE PrintLine FROM MemberDetailLine AFTER ADVANCING 1 LINE
   ADD 1 TO LineCount
   READ MemberFile
        AT END SET EndOfMemberFile TO TRUE
   END-READ.
