IDENTIFICATION DIVISION.
PROGRAM-ID. Listing17-1.
AUTHOR.  MICHAEL COUGHLAN.
* Reads a Relative file directly or in sequence

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT VehicleFile ASSIGN TO "Listing17-1.DAT"
        ORGANIZATION IS RELATIVE
        ACCESS MODE IS DYNAMIC
        RELATIVE KEY IS VehicleKey
        FILE STATUS  IS VehicleStatus.

DATA DIVISION.
FILE SECTION.
FD  VehicleFile.
01  VehicleRec.
    88  EndOfVehiclefile        VALUE HIGH-VALUES.
    02  VehicleNum              PIC 9(4).
    02  VehicleDesc             PIC X(25).
    02  ManfName                PIC X(20).

WORKING-STORAGE SECTION.
01  VehicleStatus               PIC X(2).
    88  RecordFound             VALUE "00".

01  VehicleKey                  PIC 9(4).

01  ReadType                    PIC 9.
    88 DirectRead               VALUE 1.
    88 SequentialRead           VALUE 2.
    
01  PrnVehicleRecord.
    02    PrnVehicleNum         PIC 9(4).
    02    PrnVehicleDesc        PIC BBX(25).
    02    PrnManfName           PIC BBX(20).

PROCEDURE DIVISION.
BEGIN.
    OPEN INPUT VehicleFile
    DISPLAY "Read type : Direct read = 1, Sequential read = 2 --> "
                    WITH NO ADVANCING.
    ACCEPT ReadType
    IF DirectRead        
       DISPLAY "Enter vehicle key (4 digits) --> " WITH NO ADVANCING
       ACCEPT VehicleKey
       READ VehicleFile
         INVALID KEY DISPLAY "Vehicle file status = " VehicleStatus 
       END-READ
       PERFORM DisplayRecord
    END-IF
    
    IF SequentialRead
        READ VehicleFile NEXT RECORD
            AT END SET EndOfVehiclefile TO TRUE
        END-READ
        PERFORM UNTIL EndOfVehiclefile 
            PERFORM DisplayRecord
            READ VehicleFile NEXT RECORD
                AT END SET EndOfVehiclefile TO TRUE
            END-READ
        END-PERFORM
    END-IF
    CLOSE VehicleFile
    STOP RUN.

DisplayRecord.
    IF RecordFound
       MOVE VehicleNum  TO PrnVehicleNum
       MOVE VehicleDesc TO PrnVehicleDesc
       MOVE ManfName    TO PrnManfName
       DISPLAY PrnVehicleRecord
    END-IF.
 