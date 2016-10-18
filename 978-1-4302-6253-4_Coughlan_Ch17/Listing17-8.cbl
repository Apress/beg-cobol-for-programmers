IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing17-8.
AUTHOR.  MICHAEL COUGHLAN.
*Applies Insertions and Deletions in TransFile to the VehicleFile.  
*For Insertions - If a vehicle already exists in either the Stock or 
*Vehicle file, the transaction record is written to the Error File otherwise inserted
*For Deletions - If the vehicle does not exit in the  Vehicle File the transaction 
*record is written to the Error File otherwise the Vehicle record is deleted
*If the vehicle record is deleted all the Stock records with the same VehicleNumber
*as the deleted record are written to the Redundant Stock Report and the VehicleNumber
*field in each of these Stock records is overwritten with zeros.  



ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT StockFile ASSIGN TO "Listing17-8-SMF.DAT"
        ORGANIZATION IS INDEXED
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS PartNumSF
        ALTERNATE RECORD KEY IS VehicleNumSF
                    WITH DUPLICATES
        FILE STATUS IS StockErrStatus.

    SELECT VehicleFile ASSIGN TO "Listing17-8-VMF.DAT"
        ORGANIZATION IS RELATIVE
        ACCESS MODE IS DYNAMIC
        RELATIVE KEY IS VehicleNumKey
        FILE STATUS IS VehicleErrStatus.

    SELECT TransFile ASSIGN TO "Listing17-8-TRANS.DAT"
        ORGANIZATION IS LINE SEQUENTIAL.

    SELECT ErrorFile ASSIGN TO "Listing17-8-ERR.DAT"
        ORGANIZATION IS LINE SEQUENTIAL.

    SELECT RedundantStockRpt ASSIGN TO "Listing17-8-STK.RPT".


DATA DIVISION.
FILE SECTION.
FD  StockFile.
01  StockRecSF.
    02  PartNumSF               PIC 9(7).
    02  VehicleNumSF            PIC 9(4).
    02  PartDescSF              PIC X(25).

FD  VehicleFile.
01  VehicleRecVF.
    02  VehicleNumVF            PIC 9(4).
    02  VehicleDescVF           PIC X(25).
    02  ManfNameVF              PIC X(20).

FD  TransFile.
01  TransRecTF.
    02  TransTypeTF             PIC X.
        88  InsertionRec        VALUE "I".
        88  DeletionRec         VALUE "D".
    02  DateTF                  PIC X(8).
    02  VehicleNumTF            PIC 9(4).
    02  VehicleDescTF           PIC X(25).
    02  ManfNameTF              PIC X(20).



FD  RedundantStockRpt REPORT IS StockReport.


FD  ErrorFile.
01  ErrorRec                    PIC X(56).


WORKING-STORAGE SECTION.
01  ErrorStatusCodes.
    02  StockErrStatus          PIC X(2).
        88  StockFileOpOK       VALUE "00", "02".
        88  StockRecExistis     VALUE "22".
        88  NoStockRec          VALUE "23".
    02  VehicleErrStatus        PIC X(2).
        88  VehicleFileOpOK     VALUE "00".
        88  VehicleRecExists    VALUE "22".
        88  NoVehicleRec        VALUE "23".

01  FileVariables.
    02  VehicleNumKey           PIC 9(4).
    02  PrevVehicleNum          PIC 9(4).

01  ConditionNames.
    02  FILLER                  PIC X.
        88  EndOfStockFile      VALUE HIGH-VALUES.
        88  NotEndOfStockFile   VALUE LOW-VALUES.
    02  FILLER                  PIC X.
        88  EndOfTransFile      VALUE HIGH-VALUES.

REPORT SECTION.
RD  StockReport
    PAGE LIMIT IS 66
    HEADING 1
    FIRST DETAIL 6
    LAST DETAIL 50
    FOOTING 55.

01  TYPE IS PAGE HEADING.
    02  LINE 2.
        03  COLUMN 31           PIC X(24) VALUE
                "REDUNDANT  STOCK  REPORT".
    02  LINE 3.
        03  COLUMN 30           PIC X(26) VALUE ALL "-".

    02  LINE 6.
        03  COLUMN 2            PIC X(36) VALUE
            "PART NUMBER        PART DESCRIPTION".
        03  COLUMN 45           PIC X(35) VALUE
            "VEHICLE NO.     MANUFACTURER  NAME".


01  DetailLine TYPE IS DETAIL.
    02  LINE IS PLUS 2.
        03  COLUMN 3            PIC 9(7) SOURCE PartNumSF .
        03  COLUMN 17           PIC X(25) SOURCE PartDescSF.
        03  COLUMN 48           PIC 9(4) SOURCE VehicleNumSF.
        03  COLUMN 60           PIC X(20) SOURCE ManfNameVF.



PROCEDURE DIVISION.
Begin.
    OPEN INPUT  TransFile.
    OPEN I-O    StockFile
                VehicleFile.
    OPEN OUTPUT ErrorFile
                RedundantStockRpt.

    INITIATE StockReport

    READ TransFile
        AT END SET EndOfTransFile TO TRUE
    END-READ
    PERFORM UNTIL EndOfTransFile
        MOVE VehicleNumTF TO VehicleNumKey
                             VehicleNumSF
        EVALUATE   TRUE
           WHEN InsertionRec  PERFORM CheckStockFile
           WHEN DeletionRec   PERFORM DeleteVehicleRec
           WHEN OTHER         DISPLAY "NOT INSERT OR DELETE"
        END-EVALUATE
        READ TransFile
            AT END SET EndOfTransFile TO TRUE
        END-READ
    END-PERFORM

    TERMINATE StockReport

    CLOSE   ErrorFile
            RedundantStockRpt
            TransFile
            StockFile
            VehicleFile

    STOP RUN.

CheckStockFile.
    READ StockFile KEY IS VehicleNumSF
        INVALID KEY CONTINUE
    END-READ
    IF StockFileOpOK
        PERFORM WriteErrorLine
     ELSE IF NoStockRec
             PERFORM InsertVehicleRec
           ELSE
             DISPLAY "Unexpected Read Error on Stockfile"
             DISPLAY "Stockfile status = " StockErrStatus
           END-IF
    END-IF.

InsertVehicleRec.
    MOVE ManfNameTF TO ManfNameVF
    MOVE VehicleDescTF TO VehicleDescVF
    MOVE VehicleNumTF TO VehicleNumVF
    WRITE VehicleRecVF
        INVALID KEY CONTINUE
    END-WRITE
    IF VehicleRecExists PERFORM WriteErrorLine
    ELSE IF NOT VehicleFileOpOK
            DISPLAY "Unexpected Write Error on VehicleFile."
            DISPLAY "Vehicle file status = " VehicleErrStatus
         END-IF
    END-IF.

DeleteVehicleRec.
    READ VehicleFile
        INVALID KEY CONTINUE
    END-READ
    IF NoVehicleRec PERFORM WriteErrorLine
    ELSE IF VehicleFileOpOK
            DELETE VehicleFile RECORD
                 INVALID KEY
                 DISPLAY "Unexpected Delete Error on VehicleFile"
                 DISPLAY "Vehicle file status = " VehicleErrStatus
            END-DELETE
            PERFORM UpdateStockFile
         ELSE
            DISPLAY "DeleteProblem = " VehicleErrStatus
         END-IF
    END-IF.

WriteErrorLine.
    MOVE TransRecTF TO ErrorRec
    WRITE ErrorRec.


UpdateStockFile.
    MOVE VehicleNumSF TO PrevVehicleNum
    READ StockFile KEY IS VehicleNumSF
        INVALID KEY CONTINUE
    END-READ
    IF StockFileOpOK
       SET NotEndOfStockFile TO TRUE
       PERFORM PrintStockRpt
             UNTIL VehicleNumSF NOT EQUAL TO PrevVehicleNum
                OR EndOfStockFile
    END-IF.


PrintStockRpt.
    GENERATE DetailLine
    MOVE ZEROS TO VehicleNumSF
    REWRITE StockRecSF
        INVALID KEY DISPLAY "ERROR ON REWRITE"
    END-REWRITE
    READ StockFile NEXT RECORD
        AT END SET EndOfStockFile TO TRUE
    END-READ.
