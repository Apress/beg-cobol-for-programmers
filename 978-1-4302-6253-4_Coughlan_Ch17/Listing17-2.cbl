IDENTIFICATION DIVISION.
PROGRAM-ID. Listing17-2.
AUTHOR.  MICHAEL COUGHLAN.
* Reads a Relative file directly or in sequence

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT VehicleFile ASSIGN TO "Listing17-2.DAT"
        ORGANIZATION IS RELATIVE
        ACCESS MODE IS RANDOM
        RELATIVE KEY IS VehicleKey
        FILE STATUS  IS VehicleStatus.
        
    SELECT Seqfile ASSIGN TO "Listing17-2.SEQ"
               ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  VehicleFile.
01  VehicleRec.
    02  VehicleNum              PIC 9(4).
    02  VehicleDesc             PIC X(25).
    02  ManfName                PIC X(20).
    
FD  SeqFile.
01  VehicleRec-SF.
    88  EndOfSeqfile            VALUE HIGH-VALUES.
    02  VehicleNum-SF           PIC 9(4).
    02  VehicleDesc-SF          PIC X(25).
    02  ManfName-SF             PIC X(20).

WORKING-STORAGE SECTION.
01  VehicleStatus               PIC X(2).
    88  RecordFound             VALUE "00".

01  VehicleKey                  PIC 9(4).

PROCEDURE DIVISION.
BEGIN.
    OPEN INPUT SeqFile
    OPEN OUTPUT VehicleFile
    READ SeqFile
       AT END SET EndOfSeqFile TO TRUE
    END-READ
    PERFORM UNTIL EndOfSeqFile
       MOVE VehicleNum-SF TO VehicleKey
       WRITE VehicleRec FROM VehicleRec-SF
             INVALID KEY DISPLAY "Vehicle file status = " VehicleStatus 
       END-WRITE
       READ SeqFile
          AT END SET EndOfSeqFile TO TRUE
       END-READ
    END-PERFORM

    CLOSE SeqFile, VehicleFile
    STOP RUN.
