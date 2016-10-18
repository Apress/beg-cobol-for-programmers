IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing17-4.
AUTHOR.  Michael Coughlan.
*Reads the file sequentially and then directly on any key

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
    SELECT FilmFile ASSIGN TO "Listing17-4Film.DAT"
        ORGANIZATION IS INDEXED
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS FilmId
        ALTERNATE RECORD KEY IS FilmTitle
                     WITH DUPLICATES
        ALTERNATE RECORD KEY IS DirectorId
                     WITH DUPLICATES
        FILE STATUS IS FilmStatus.

DATA DIVISION.
FILE SECTION.
FD FilmFile.
01 FilmRec.
   88 EndOfFilms            VALUE HIGH-VALUES.
   02 FilmId                PIC 9(7).
   02 FilmTitle             PIC X(40).
   02 DirectorId            PIC 999.


WORKING-STORAGE SECTION.
01 FilmStatus               PIC XX.
   88 FilmOK VALUE ZEROS.

01 RequiredSequence         PIC 9.
   88 FilmIdSequence        VALUE 1.
   88 FilmTitleSequence     VALUE 2.
   88 DirectorIdSequence    VALUE 3.

01 PrevDirectorId           PIC 999.

PROCEDURE DIVISION.
Begin.
    OPEN INPUT FilmFile
    DISPLAY "*** Get Records Sequentially ***"
    DISPLAY "Enter key : 1 = FilmId, 2 = FilmTitle, 3 = DirectorId - "
            WITH NO ADVANCING.
    ACCEPT RequiredSequence.
    
    EVALUATE TRUE
       WHEN FilmIdSequence       PERFORM DisplayFilmData
       WHEN FilmTitleSequence    MOVE SPACES TO FilmTitle
                                 START FilmFile KEY IS GREATER THAN FilmTitle
                                      INVALID KEY DISPLAY "FilmStatus = " FilmStatus
                                 END-START
                                 PERFORM DisplayFilmData
       WHEN DirectorIdSequence   MOVE ZEROS TO DirectorId
                                 START FilmFile KEY IS GREATER THAN DirectorId
                                      INVALID KEY DISPLAY "FilmStatus = " FilmStatus
                                 END-START
                                 PERFORM DisplayFilmData
    END-EVALUATE
    
    DISPLAY SPACES
    DISPLAY "*** Get Records Directly ***"
    DISPLAY "Enter key : 1 = FilmId, 2 = FilmTitle, 3 = DirectorId - "
            WITH NO ADVANCING.
    ACCEPT RequiredSequence.
    EVALUATE TRUE
       WHEN FilmIdSequence       PERFORM GetFilmByFilmId
       WHEN FilmTitleSequence    PERFORM GetFilmByFilmTitle
       WHEN DirectorIdSequence   PERFORM GetFilmByDirectorId
    END-EVALUATE

    CLOSE FilmFile
    STOP RUN.
    
DisplayFilmData.
   READ FilmFile NEXT RECORD 
      AT END SET EndOfFilms TO TRUE
   END-READ
   PERFORM UNTIL EndOfFilms
      DISPLAY FilmId SPACE FilmTitle SPACE DirectorId
      READ FilmFile NEXT RECORD 
         AT END SET EndOfFilms TO TRUE
      END-READ
   END-PERFORM.
   
GetFilmByFilmId.
   DISPLAY "Enter the FilmId - " WITH NO ADVANCING
   ACCEPT FilmId
   READ FilmFile
      KEY IS FilmId
      INVALID KEY DISPLAY "Film not found - " FilmStatus
      NOT INVALID KEY DISPLAY FilmId SPACE FilmTitle SPACE DirectorId
   END-READ.


GetFilmByFilmTitle.
   DISPLAY "Enter the FilmTitle - " WITH NO ADVANCING
   ACCEPT FilmTitle
   READ FilmFile
      KEY IS FilmTitle
      INVALID KEY DISPLAY "Film not found - " FilmStatus
      NOT INVALID KEY DISPLAY FilmId SPACE FilmTitle SPACE DirectorId
   END-READ.


GetFilmByDirectorId.
   DISPLAY "Enter the Director Id - " WITH NO ADVANCING
   ACCEPT DirectorId
   READ FilmFile
      KEY IS DirectorId
      INVALID KEY DISPLAY "Film not found - " FilmStatus
      NOT INVALID KEY DISPLAY FilmId SPACE FilmTitle SPACE DirectorId
   END-READ.

