IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing17-5.
AUTHOR.  Michael Coughlan.
*Creating an Indexed File from a Sequential File

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
    SELECT FilmFile ASSIGN TO "Listing17-5Film.DAT"
        ORGANIZATION IS INDEXED
        ACCESS MODE IS DYNAMIC
        RECORD KEY IS FilmId
        ALTERNATE RECORD KEY IS FilmTitle
                     WITH DUPLICATES
        ALTERNATE RECORD KEY IS DirectorId
                     WITH DUPLICATES
        FILE STATUS IS FilmStatus. 
        
    SELECT SeqFilmFile ASSIGN TO "Listing17-5Film.SEQ"
        ORGANIZATION IS LINE SEQUENTIAL.


DATA DIVISION.
FILE SECTION.
FD FilmFile.
01 FilmRec.
   02 FilmId                PIC 9(7).
   02 FilmTitle             PIC X(40).
   02 DirectorId            PIC 999.

FD SeqFilmFile.
01 SeqFilmRec               PIC X(50).
   88 EndOfFilmFile         VALUE HIGH-VALUES.

WORKING-STORAGE SECTION.
01 FilmStatus               PIC XX.
   88 FilmOK VALUE ZEROS.

PROCEDURE DIVISION.
Begin.
    OPEN INPUT  SeqFilmFile
    OPEN OUTPUT FilmFile

    READ SeqFilmFile
       AT END SET EndOfFilmFile TO TRUE
    END-READ
    PERFORM UNTIL EndOfFilmFile
       WRITE FilmRec FROM SeqFilmRec
            INVALID KEY DISPLAY "Error writing to film file"
       END-WRITE
       READ SeqFilmFile
          AT END SET EndOfFilmFile TO TRUE
       END-READ
    END-PERFORM
    CLOSE SeqFilmFile, FilmFile  
    STOP RUN.