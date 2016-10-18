IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing10-3.
AUTHOR. Michael Coughlan
* Applies the transactions ordered on ascending GadgetId-TF to the 
* MasterStockFile ordered on ascending GadgetId-MF.  
* Assumption: Insert not followed by updates to inserted record
*             Multiple updates per master record permitted

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   SELECT MasterStockFile ASSIGN TO "Listing10-3Master.dat"
          ORGANIZATION IS LINE SEQUENTIAL.

   SELECT NewStockFile ASSIGN TO "Listing10-3NewMast.dat"
          ORGANIZATION IS LINE SEQUENTIAL.


   SELECT TransactionFile ASSIGN TO "Listing10-3Trans.dat"
          ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD MasterStockFile.
01 MasterStockRec.
   88 EndOfMasterFile      VALUE HIGH-VALUES.
   02 GadgetId-MF          PIC 9(6).
   02 GadgetName-MF        PIC X(30).
   02 QtyInStock-MF        PIC 9(4).
   02 Price-MF             PIC 9(4)V99.

FD NewStockFile.
01 NewStockRec.
   02 GadgetId-NSF        PIC 9(6).
   02 GadgetName-NSF      PIC X(30).
   02 QtyInStock-NSF      PIC 9(4).
   02 Price-NSF           PIC 9(4)V99.

FD TransactionFile.
01 InsertionRec.
   88 EndOfTransFile      VALUE HIGH-VALUES.
   02 TypeCode-TF         PIC 9.
       88 Insertion       VALUE 1.
       88 Deletion        VALUE 2.
       88 UpdatePrice     VALUE 3.
   02 GadgetId-TF         PIC 9(6).
   02 GadgetName-IR       PIC X(30).
   02 QtyInStock-IR       PIC 9(4).
   02 Price-IR            PIC 9(4)V99.

01 DeletionRec.
   02 FILLER              PIC 9(7).

01 PriceChangeRec.
   02 FILLER              PIC 9(7).   
   02 Price-PCR           PIC 9(4)V99.

   
WORKING-STORAGE SECTION.
01  ErrorMessage.
    02 PrnGadgetId        PIC 9(6).
    02 FILLER             PIC XXX VALUE " - ".
    02 FILLER             PIC X(45).
       88 InsertError      VALUE "Insert Error - Record already exists".
       88 DeleteError      VALUE "Delete Error - No such record in Master".
       88 PriceUpdateError VALUE "Price Update Error - No such record in Master".

PROCEDURE DIVISION.
Begin.
   OPEN INPUT  MasterStockFile
   OPEN INPUT  TransactionFile
   OPEN OUTPUT NewStockFile
   PERFORM ReadMasterFile
   PERFORM ReadTransFile
   PERFORM UNTIL EndOfMasterFile AND EndOfTransFile
      EVALUATE TRUE
        WHEN GadgetId-TF > GadgetId-MF  PERFORM CopyToNewMaster
        WHEN GadgetId-TF = GadgetId-MF  PERFORM TryToApplyToMaster
        WHEN GadgetId-TF < GadgetId-MF  PERFORM TryToInsert
      END-EVALUATE
   END-PERFORM

   CLOSE MasterStockFile, TransactionFile, NewStockFile
   STOP RUN.

CopyToNewMaster.
   WRITE NewStockRec FROM MasterStockRec
   PERFORM ReadMasterFile.

TryToApplyToMaster.
   EVALUATE TRUE
      WHEN UpdatePrice MOVE Price-PCR TO Price-MF                           
      WHEN Deletion    PERFORM ReadMasterFile
      WHEN Insertion   SET InsertError TO TRUE
                       DISPLAY ErrorMessage
   END-EVALUATE
   PERFORM ReadTransFile.
        
TryToInsert.
   IF Insertion    MOVE GadgetId-TF TO GadgetId-NSF
                   MOVE GadgetName-IR TO GadgetName-NSF
                   MOVE QtyInStock-IR TO QtyInStock-NSF
                   MOVE Price-Ir TO Price-NSF
                   WRITE NewStockRec
      ELSE
        IF UpdatePrice  
           SET PriceUpdateError TO TRUE
        END-IF
        IF Deletion     
           SET DeleteError TO TRUE
        END-IF 
        DISPLAY ErrorMessage           
   END-IF        
   PERFORM ReadTransFile.
    
ReadTransFile.
   READ TransactionFile
        AT END SET EndOfTransFile TO TRUE
   END-READ
   MOVE GadgetId-TF TO PrnGadgetId.

ReadMasterFile.
   READ MasterStockFile
        AT END SET EndOfMasterFile TO TRUE
   END-READ.    

  
 
