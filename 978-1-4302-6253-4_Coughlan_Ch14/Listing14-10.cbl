IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing14-10.
AUTHOR.  Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   SELECT GuestBookFile 
          ASSIGN TO "Listing14-10.Dat"
          ORGANIZATION IS LINE SEQUENTIAL.

   SELECT WorkFile 
          ASSIGN TO "Work.Tmp".

   SELECT ForeignGuestReport 
          ASSIGN TO "Listing14-10.rpt"
          ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD GuestBookFile.
01 GuestRec.
   88  EndOfFile  VALUE HIGH-VALUES.
   02  GuestNameGF         PIC X(20).
   02  CountryNameGF       PIC X(20).
       88 CountryIsIreland VALUE "IRELAND". 
   02  GuestCommentGF      PIC X(40).

SD WorkFile.
01 WorkRec.
   88 EndOfWorkFile        VALUE HIGH-VALUES.
   02 CountryNameWF        PIC X(20).

FD ForeignGuestReport.
01 PrintLine               PIC X(38).


WORKING-STORAGE SECTION.
01 Heading1                PIC X(25) 
         VALUE "    Foreign Guests Report".
         
01 Heading2. 
   02 FILLER               PIC X(22) VALUE "Country".
   02 FILLER               PIC X(8)  VALUE "Visitors".

01 CountryLine.
   02 PrnCountryName       PIC X(20).
   02 PrnVisitorCount      PIC BBBZZ,ZZ9.

01 ReportFooting           PIC X(27)
         VALUE "  ***** End of report *****".

01 VisitorCount            PIC 9(5).

PROCEDURE DIVISION.
Begin.
   SORT WorkFile ON ASCENDING CountryNameWF
        INPUT PROCEDURE IS SelectForeignGuests
        OUTPUT PROCEDURE IS PrintGuestsReport.


   STOP RUN.

PrintGuestsReport.
   OPEN OUTPUT ForeignGuestReport
   WRITE PrintLine FROM Heading1
         AFTER ADVANCING PAGE
   WRITE PrintLine FROM Heading2
         AFTER ADVANCING 1 LINES
   
   RETURN WorkFile
        AT END SET EndOfWorkfile TO TRUE
   END-RETURN
   PERFORM PrintReportBody UNTIL EndOfWorkfile

   WRITE PrintLine FROM ReportFooting 
         AFTER ADVANCING 2 LINES
   CLOSE ForeignGuestReport.
   
PrintReportBody.
   MOVE CountryNameWF TO PrnCountryName
   MOVE ZEROS TO VisitorCount
   PERFORM UNTIL CountryNameWF NOT EQUAL TO PrnCountryName
      ADD 1 TO VisitorCount
      RETURN WorkFile
         AT END SET EndOfWorkfile TO TRUE
      END-RETURN
   END-PERFORM
   MOVE VisitorCount TO PrnVisitorCount
   WRITE PrintLine FROM CountryLine 
         AFTER ADVANCING 1 LINE.

SelectForeignGuests.
   OPEN INPUT GuestBookFile.
   READ GuestBookFile
      AT END SET EndOfFile TO TRUE
   END-READ
   PERFORM UNTIL EndOfFile
      IF NOT CountryIsIreland
         MOVE CountryNameGF TO CountryNameWF
         RELEASE WorkRec
      END-IF
      READ GuestBookFile
        AT END SET EndOfFile TO TRUE
      END-READ
   END-PERFORM
   CLOSE GuestBookFile.
