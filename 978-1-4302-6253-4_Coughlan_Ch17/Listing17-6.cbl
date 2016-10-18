IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing17-6.
AUTHOR. Michael Coughlan.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
    SELECT FilmFile ASSIGN TO "Listing17-6Film.DAT"
        ORGANIZATION IS INDEXED
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS FilmId-FF
        ALTERNATE RECORD KEY IS FilmTitle-FF
                     WITH DUPLICATES
        ALTERNATE RECORD KEY IS DirectorId-FF
                     WITH DUPLICATES
        FILE STATUS IS FilmStatus.

   SELECT DirectorFile ASSIGN TO "Listing17-6Dir.DAT"
        ORGANIZATION IS INDEXED
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS DirectorId-DF
        ALTERNATE RECORD KEY IS DirectorSurname-DF
        FILE STATUS IS DirectorStatus.

DATA DIVISION.
FILE SECTION.
FD FilmFile.
01 FilmRec-FF.
   88 EndOfFilms     VALUE HIGH-VALUES.
   02 FilmId-FF            PIC 9(7).
   02 FilmTitle-FF         PIC X(40).
   02 DirectorId-FF        PIC 999.

FD DirectorFile.
01 DirectorRec-DF.
   88 EndOfDirectors  VALUE HIGH-VALUES.
   02 DirectorId-DF         PIC 999.
   02 DirectorSurname-DF    PIC X(20).


WORKING-STORAGE SECTION.
01 AllStatusFlags  VALUE ZEROS.
   02 FilmStatus            PIC XX.
      88 FilmOk    VALUE "02", "00".
      
   02 DirectorStatus        PIC XX.

01 DirectorName             PIC X(20).


PROCEDURE DIVISION.
Begin.
    OPEN INPUT FilmFile
    OPEN INPUT DirectorFile
    DISPLAY "Please enter the director surname :- "
            WITH NO ADVANCING
    ACCEPT DirectorSurname-DF
    READ DirectorFile
        KEY IS DirectorSurname-DF
        INVALID KEY DISPLAY "-DF ERROR Status = " DirectorStatus
        NOT INVALID KEY PERFORM GetFilmsForDirector
    END-READ

    CLOSE FilmFile
    CLOSE DirectorFile
    STOP RUN.

GetFilmsForDirector.
    MOVE DirectorId-DF TO DirectorId-FF
    READ FilmFile
        KEY IS DirectorId-FF
        INVALID KEY DISPLAY "-FF ERROR Status = " FilmStatus
    END-READ
    IF FilmOk
       PERFORM UNTIL DirectorId-DF NOT Equal TO DirectorId-FF OR EndOfFilms
          DISPLAY DirectorId-DF SPACE DirectorSurname-DF SPACE FilmId-FF SPACE FilmTitle-FF
          READ FilmFile NEXT RECORD
             AT END SET EndOfFilms TO TRUE
          END-READ
       END-PERFORM
    END-IF.

       