IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing10-5.
AUTHOR. Michael Coughlan
* File Update program based on the algorithm described by Barry Dwyer in
* "One more time - How to update a Master File"
* Applies the transactions ordered on ascending GadgetId-TF to the 
* MasterStockFile ordered on ascending GadgetId-MF. 
* Within each key value records are ordered on the sequence in which
* events occurred in the outside world. 
* All valid, real world, transaction sequences are accommodated
* This version includes additions and subtractions from QtyInStock

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
   SELECT MasterStockFile ASSIGN TO "Listing10-5Master.dat"
          ORGANIZATION IS LINE SEQUENTIAL.

   SELECT NewStockFile ASSIGN TO "Listing10-5NewMast.dat"
          ORGANIZATION IS LINE SEQUENTIAL.


   SELECT TransactionFile ASSIGN TO "Listing10-5Trans.dat"
          ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD MasterStockFile.
01 MasterStockRec.
   88 EndOfMasterFile       VALUE HIGH-VALUES.
   02 GadgetID-MF           PIC 9(6).
   02 GadgetName-MF         PIC X(30).
   02 QtyInStock-MF         PIC 9(4).
   02 Price-MF              PIC 9(4)V99.

FD NewStockFile.
01 NewStockRec.
   02 GadgetID-NSF          PIC 9(6).
   02 GadgetName-NSF        PIC X(30).
   02 QtyInStock-NSF        PIC 9(4).
   02 Price-NSF             PIC 9(4)V99.

FD TransactionFile.
01 InsertionRec.
   88 EndOfTransFile        VALUE HIGH-VALUES.
   02 TypeCode-TF           PIC 9.
       88 Insertion         VALUE 1.
       88 Deletion          VALUE 2.
       88 UpdatePrice       VALUE 3.
       88 StockAddition     VALUE 4.
       88 StockSubtraction  VALUE 5.
   02 RecordBody-IR.
      03 GadgetID-TF        PIC 9(6).
      03 GadgetName-IR      PIC X(30).
      03 QtyInStock-IR      PIC 9(4).
      03 Price-IR           PIC 9(4)V99.

01 DeletionRec.
   02 FILLER                PIC 9(7).

01 PriceChangeRec.
   02 FILLER                PIC 9(7).   
   02 Price-PCR             PIC 9(4)V99.
   
01 AddToStock.
   02 FILLER                PIC 9(7).   
   02 QtyToAdd              PIC 9(4). 

01 SubtractFromStock.      
   02 FILLER                PIC 9(7).   
   02 QtyToSubtract         PIC 9(4). 
   
   
WORKING-STORAGE SECTION.
01 ErrorMessage.
   02 PrnGadgetId          PIC 9(6).
   02 FILLER               PIC XXX VALUE " - ".
   02 FILLER               PIC X(46).
      88 InsertError       VALUE "Insert Error - Record already exists".
      88 DeleteError       VALUE "Delete Error - No such record in Master".
      88 PriceUpdateError  VALUE "Price Update Error - No such record in Master".
      88 QtyAddError       VALUE "Stock Add Error - No such record in Master".
      88 QtySubtractError  VALUE "Stock Subract Error - No such record in Master".
      88 InsufficientStock VALUE "Stock Subract Error - Not enough stock".
         
   
01 FILLER                  PIC X VALUE "n".
   88 RecordInMaster       VALUE "y".
   88 RecordNotInMaster    VALUE "n".  
   
01 CurrentKey              PIC 9(6).

PROCEDURE DIVISION.
Begin.
   OPEN INPUT  MasterStockFile
   OPEN INPUT  TransactionFile
   OPEN OUTPUT NewStockFile
   PERFORM ReadMasterFile
   PERFORM ReadTransFile
   PERFORM ChooseNextKey
   PERFORM UNTIL EndOfMasterFile AND EndOfTransFile
      PERFORM SetInitialStatus
      PERFORM ProcessOneTransaction 
              UNTIL GadgetID-TF NOT = CurrentKey               
*     CheckFinalStatus
      IF RecordInMaster 
         WRITE NewStockRec
      END-IF
      PERFORM ChooseNextKey
    END-PERFORM

   CLOSE MasterStockFile, TransactionFile, NewStockFile
   STOP RUN.    

ChooseNextKey.
   IF GadgetID-TF < GadgetID-MF
      MOVE GadgetID-TF TO CurrentKey
    ELSE 
      MOVE GadgetID-MF TO CurrentKey
   END-IF.

SetInitialStatus.
   IF GadgetID-MF =  CurrentKey
      MOVE MasterStockRec TO NewStockRec
      SET RecordInMaster TO TRUE
      PERFORM ReadMasterFile
    ELSE SET RecordNotInMaster TO TRUE
   END-IF.
    
ProcessOneTransaction.
*  ApplyTransToMaster
   EVALUATE TRUE
       WHEN Insertion         PERFORM ApplyInsertion
       WHEN UpdatePrice       PERFORM ApplyPriceChange 
       WHEN Deletion          PERFORM ApplyDeletion
       WHEN StockAddition     PERFORM ApplyAddToStock
       WHEN StockSubtraction  PERFORM ApplySubtractFromStock
    END-EVALUATE.
    PERFORM ReadTransFile.
    
ApplyInsertion.
   IF RecordInMaster 
      SET InsertError TO TRUE
      DISPLAY ErrorMessage
    ELSE
      SET RecordInMaster TO TRUE
      MOVE RecordBody-IR TO NewStockRec
   END-IF.
       
ApplyDeletion.
   IF RecordNotInMaster
      SET DeleteError TO TRUE
      DISPLAY ErrorMessage
    ELSE SET RecordNotInMaster TO TRUE
   END-IF.
   
ApplyPriceChange.
   IF RecordNotInMaster
      SET PriceUpdateError TO TRUE
      DISPLAY ErrorMessage
    ELSE
      MOVE Price-PCR TO Price-NSF
   END-IF.

ApplyAddToStock.
   IF RecordNotInMaster
      SET QtyAddError TO TRUE
      DISPLAY ErrorMessage
    ELSE
      ADD QtyToAdd TO QtyInStock-NSF
   END-IF.

ApplySubtractFromStock.
   IF RecordNotInMaster
      SET QtySubtractError TO TRUE
      DISPLAY ErrorMessage
    ELSE
      IF QtyInStock-NSF < QtyToSubtract
          SET InsufficientStock TO TRUE
          DISPLAY ErrorMessage
        ELSE 
          SUBTRACT QtyToSubtract FROM QtyInStock-NSF
      END-IF
   END-IF.

  
ReadTransFile.
    READ TransactionFile
         AT END SET EndOfTransFile TO TRUE
    END-READ
    MOVE GadgetID-TF TO PrnGadgetId.

ReadMasterFile.
    READ MasterStockFile
         AT END SET EndOfMasterFile TO TRUE
    END-READ.
      
     
   
 
  