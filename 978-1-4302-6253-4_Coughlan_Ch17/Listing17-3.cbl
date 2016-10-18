IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing17-3.
AUTHOR.  MICHAEL COUGHLAN.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT VehicleMasterFile ASSIGN TO "Listing17-3.DAT"
        ORGANIZATION IS RELATIVE
        ACCESS MODE IS DYNAMIC
        RELATIVE KEY IS VehicleKey
        FILE STATUS  IS VehicleFileStatus.

    SELECT TransFile ASSIGN TO "Listing17-3Trans.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  VehicleMasterFile.
01  VehicleRec-VMF.
    88  EndOfVehiclefile  VALUE HIGH-VALUES. 
    02  VehicleNum-VMF          PIC 9(4).
    02  VehicleDesc-VMF         PIC X(25).
    02  ManfName-VMF            PIC X(20).
    
FD TransFile.
01  InsertionRec.
    88  EndOfTransFile          VALUE HIGH-VALUES.
    02  TransType               PIC X.
        88  InsertRecord        VALUE "I".
        88  DeleteRecord        VALUE "D".
        88  UpdateRecord        VALUE "U".
    02  VehicleNum-IR           PIC 9(4).
    02  VehicleDesc-IR          PIC X(25).
    02  ManfName-IR             PIC X(20).
    
01  DeletionRec                 PIC X(5).

01  UpdateRec.
    02  FILLER                  PIC X(5).
    02  VehicleDesc-UR          PIC X(25).
    
WORKING-STORAGE SECTION.
01  VehicleFileStatus           PIC X(2).
    88  OperationSuccessful     VALUE "00".
    88  VehicleRecExists        VALUE "22".
    88  NoVehicleRec            VALUE "23".

01  VehicleKey                  PIC 9(4).

01  ReadType                    PIC 9.

PROCEDURE DIVISION.
Begin.
    OPEN INPUT TransFile
    OPEN I-O   VehicleMasterFile
    DISPLAY "Vehicle Master File records before transactions"
    PERFORM DisplayVehicleRecords
    DISPLAY SPACES

    READ TransFile
         AT END SET EndOfTransFile TO TRUE
    END-READ
    PERFORM UNTIL EndOfTransFile
       MOVE VehicleNum-IR TO VehicleKey
       EVALUATE   TRUE
          WHEN InsertRecord  PERFORM InsertVehicleRec
          WHEN DeleteRecord  PERFORM DeleteVehicleRec
          WHEN UpdateRecord  PERFORM UpdateVehicleRec
          WHEN OTHER         DISPLAY "Error - Invalid Transaction Code"
       END-EVALUATE
       READ TransFile
            AT END SET EndOfTransFile TO TRUE
       END-READ
    END-PERFORM
    
    DISPLAY SPACES
    DISPLAY "Vehicle Master File records after transactions"
    PERFORM DisplayVehicleRecords
    
    CLOSE TransFile, VehicleMasterFile
    STOP RUN.

InsertVehicleRec.
    MOVE ManfName-IR    TO ManfName-VMF
    MOVE VehicleDesc-IR TO VehicleDesc-VMF
    MOVE VehicleNum-IR  TO VehicleNum-VMF
    WRITE VehicleRec-VMF
          INVALID KEY 
             IF VehicleRecExists 
                DISPLAY "InsertError - Record at - " VehicleNum-IR " - already exists"
              ELSE  
                 DISPLAY "Unexpected error. File Status is - " VehicleFileStatus
             END-IF
    END-WRITE.


DeleteVehicleRec.
    DELETE VehicleMasterFile RECORD
         INVALID KEY 
            IF NoVehicleRec 
               DISPLAY "DeleteError - No record at - " VehicleNum-IR 
            ELSE
               DISPLAY "Unexpected error1. File Status is - " VehicleFileStatus
            END-IF
    END-DELETE.
    
UpdateVehicleRec.
    READ VehicleMasterFile 
         INVALID KEY 
            IF NoVehicleRec 
               DISPLAY "UpdateError - No record at - " VehicleNum-IR 
            ELSE
               DISPLAY "Unexpected error2. File Status is - " VehicleFileStatus
            END-IF
    END-READ
    IF OperationSuccessful
       MOVE VehicleDesc-UR TO VehicleDesc-VMF
       REWRITE VehicleRec-VMF
           INVALID KEY DISPLAY "Unexpected error3. File Status is - " VehicleFileStatus
       END-REWRITE
    END-IF.
    
DisplayVehicleRecords.
*  Position the Next Record Pointer to the start of the file
   MOVE ZEROS TO VehicleKey
   START VehicleMasterFile KEY IS GREATER THAN VehicleKey
        INVALID KEY DISPLAY "Unexpected error on START"
   END-START
   READ VehicleMasterFile NEXT RECORD
        AT END SET EndOfVehiclefile TO TRUE
   END-READ  

   PERFORM UNTIL EndOfVehiclefile 
      DISPLAY VehicleNum-VMF SPACE VehicleDesc-VMF  SPACE ManfName-VMF 
      READ VehicleMasterFile NEXT RECORD
           AT END SET EndOfVehiclefile TO TRUE
      END-READ
   END-PERFORM.
   

    