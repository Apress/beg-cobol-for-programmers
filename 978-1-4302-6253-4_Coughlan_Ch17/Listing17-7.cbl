IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing17-7.
AUTHOR.  Michael Coughlan.
*Applies transactions to the Indexed FilmFile and enforces referential integrity
*with the Indexed Directors File


ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
    SELECT FilmFile ASSIGN TO "Listing17-7Films.DAT"
        ORGANIZATION IS INDEXED
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS FilmId-FF
        ALTERNATE RECORD KEY IS FilmTitle-FF
                     WITH DUPLICATES
        ALTERNATE RECORD KEY IS DirectorId-FF
                     WITH DUPLICATES
        FILE STATUS IS FilmStatus.

    SELECT DirectorsFile ASSIGN TO "Listing17-7Dir.DAT"
        ORGANIZATION IS INDEXED
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS DirectorId-DF
        ALTERNATE RECORD KEY IS DirectorSurname-DF
        FILE STATUS IS DirectorStatus.

    SELECT TransFile ASSIGN TO "Listing17-7Trans.dat"
        ORGANIZATION IS LINE SEQUENTIAL.
        
DATA DIVISION.
FILE SECTION.
FD FilmFile.
01 FilmRec-FF.
   88 EndOfFilms     VALUE HIGH-VALUES.
   02 FilmId-FF              PIC 9(7).
   02 FilmTitle-FF           PIC X(40).
   02 DirectorId-FF          PIC 9(3).

FD DirectorsFile.
01 DirectorsRec-DF.
   88 EndOfDirectors  VALUE HIGH-VALUES.
   02 DirectorId-DF          PIC 9(3).
   02 DirectorSurname-DF     PIC X(20).

FD TransFile.
01 DeletionRec-TF.
   88 EndOfTrans     VALUE HIGH-VALUES.
   02 TypeId-TF              PIC X.
      88 DoDeletion          VALUE "D".
      88 DoInsertion         VALUE "I".
      88 DoUpdate            VALUE "U".
   02 FilmId-TF              PIC 9(7).

01 InsertionRec-TF.
   02 FILLER                 PIC 9.
   02 InsertionBody-TF.
      03 FILLER              PIC X(47).
      03 DirectorId-TF       PIC 9(3).
   
01 UpdateRec-TF.
   02 FILLER                 PIC X(8).
   02 FilmTitle-TF           PIC X(40).

WORKING-STORAGE SECTION.
01 AllStatusFlags  VALUE ZEROS.
   02 FilmStatus            PIC XX.
      88 FilmOK VALUE ZEROS.
   02 DirectorStatus        PIC XX.
      88 MatchingDirectorFound  VALUE ZEROS.


PROCEDURE DIVISION.
Begin.
    OPEN I-O FilmFile
    OPEN INPUT DirectorsFile
    OPEN INPUT TransFile
    DISPLAY "*** Film file before updates ***"
    PERFORM DisplayFilmFileContents
    DISPLAY SPACES
    READ TransFile
      AT END SET EndOfTrans TO TRUE
    END-READ
    PERFORM UpdateFilmFile UNTIL EndofTrans
    DISPLAY SPACES
    DISPLAY "*** Film file after updates ***"
    PERFORM DisplayFilmFileContents
    CLOSE FilmFile, DirectorsFile, TransFile
    STOP RUN.

DisplayFilmFileContents.
    MOVE ZEROS TO FilmId-FF
    START FilmFile KEY IS GREATER THAN FilmId-FF
        INVALID KEY DISPLAY "Error1 - FilmStatus = " FilmStatus
    END-START
    READ FilmFile NEXT RECORD
       AT END SET EndOfFilms TO TRUE
    END-READ
    PERFORM UNTIL EndOfFilms
       DISPLAY FilmId-FF SPACE DirectorId-FF SPACE FilmTitle-FF
       READ FilmFile NEXT RECORD
          AT END SET EndOfFilms TO TRUE
       END-READ
    END-PERFORM.     

UpdateFilmFile.
    EVALUATE TRUE
       WHEN DoDeletion  PERFORM DeleteFilmRec
       WHEN DoInsertion PERFORM InsertFilmRec
       WHEN DoUpdate    PERFORM UpdateFilmRec
    END-EVALUATE
    READ TransFile
         AT END SET EndOfTrans TO TRUE
    END-READ.
    
DeleteFilmRec.
    MOVE FilmId-TF TO FilmId-FF
    DELETE FilmFile RECORD
         INVALID KEY DISPLAY FilmId-FF " - Delete Error. No such record" 
    END-DELETE.
    
InsertFilmRec.
*To preserve Referential Integrity check director exists for this Film  
    MOVE DirectorId-TF   TO DirectorId-DF
    START DirectorsFile
          KEY IS EQUAL TO DirectorId-DF
          INVALID KEY DISPLAY FilmId-FF " - Insert Error. No matching entry for director - " DirectorId-TF
    END-START
          
    IF MatchingDirectorFound
       MOVE InsertionBody-TF TO FilmRec-FF
       WRITE FilmRec-FF
            INVALID KEY DISPLAY FilmId-FF " - Insert Error. That FilmId already exists."
       END-WRITE
    END-IF.
    

UpdateFilmRec.       
    MOVE FilmId-TF TO FilmId-FF
    READ FilmFile RECORD
         KEY IS FilmId-FF
         INVALID KEY DISPLAY FilmId-FF " - Update error. No such record exists"
    END-READ
    IF FilmOk
       MOVE FilmTitle-TF TO FilmTitle-FF
       REWRITE FilmRec-FF
          INVALID KEY DISPLAY "Unexpected Error1. FilmStatus - " FilmStatus
       END-REWRITE
    END-IF.
    
