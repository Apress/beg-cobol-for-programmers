IDENTIFICATION DIVISION.
PROGRAM-ID. Listing16-9.
AUTHOR.  Michael Coughlan.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT BirthsFile ASSIGN TO "Listing16-9MPDOB.DAT"
        ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD BirthsFile.
01 BirthsRec.
   88 EndOfFile  VALUE HIGH-VALUES.
   02 MaleDOB             PIC X(8).
   02 FemaleDOB           PIC X(8).

WORKING-STORAGE SECTION.
01 Counts.
   02 CompatiblePairs     PIC 9(7)  VALUE ZEROS.
   02 CompatiblePrn       PIC ZZZZ,ZZ9.
   02 CompatiblePercent   PIC ZZ9.
   02 IncompatiblePairs   PIC 9(7)  VALUE ZEROS.
   02 IncompatiblePrn     PIC ZZZZ,ZZ9.
   02 IncompatiblePercent PIC ZZ9.
   02 ValidRecs           PIC 9(8) VALUE ZEROS.
   02 ValidRecsPrn        PIC ZZ,ZZZ,ZZ9.
   02 TotalRecs           PIC 9(9) VALUE ZEROS.
   02 TotalRecsPrn        PIC ZZ,ZZZ,ZZ9.
   
01 MaleSignType           PIC 99.
   88 ValidMale           VALUE 1 THRU 12. 
   
01 FemaleSignType         PIC 99.
   88 ValidFemale         VALUE 1 THRU 12.

01 SumOfSigns             PIC 99.
       

PROCEDURE DIVISION.
Begin.
   OPEN INPUT BirthsFile.
   READ BirthsFile
      AT END SET  EndOfFile TO TRUE
   END-READ
   PERFORM ProcessBirthRecs UNTIL EndOfFile
   
   COMPUTE ValidRecs = CompatiblePairs + IncompatiblePairs
   COMPUTE CompatiblePercent ROUNDED   = CompatiblePairs / ValidRecs * 100
   COMPUTE InCompatiblePercent ROUNDED = InCompatiblePairs / ValidRecs * 100

   PERFORM DisplayResults

   CLOSE BirthsFile.
   STOP RUN.

DisplayResults.
   MOVE CompatiblePairs   TO CompatiblePrn
   MOVE IncompatiblePairs TO IncompatiblePrn
   MOVE TotalRecs TO TotalRecsPrn
   MOVE ValidRecs TO ValidRecsPrn

   DISPLAY "Total records = " TotalRecsPrn
   DISPLAY "Valid records = " ValidRecsPrn
   DISPLAY "Compatible pairs   = " CompatiblePrn
           " which is " CompatiblePercent "% of total".
   DISPLAY "Incompatible pairs = " IncompatiblePrn
           " which is " InCompatiblePercent "% of total".

ProcessBirthRecs.
*  Get the two sign types and add them together
*  If the result is even then they are compatible
   ADD 1 TO TotalRecs
   CALL "IdentifySign" USING BY CONTENT   MaleDOB
                             BY REFERENCE MaleSignType

   CALL "IdentifySign" USING BY CONTENT   FemaleDOB
                             BY REFERENCE FemaleSignType
   
   IF ValidMale AND ValidFemale
      COMPUTE SumOfSigns = MaleSignType + FemaleSignType
      IF FUNCTION REM(SumOfSigns 2)  = ZERO
         ADD 1 TO CompatiblePairs
        ELSE 
         ADD 1 TO IncompatiblePairs
      END-IF
   END-IF
   READ BirthsFile
      AT END SET  EndOfFile TO TRUE
   END-READ.


IDENTIFICATION DIVISION.
PROGRAM-ID. IdentifySign IS INITIAL.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 WorkDate.
   88 Aquarius    VALUE "0122" THRU "0218".
   88 Pisces      VALUE "0221" THRU "0319".
   88 Aries       VALUE "0322" THRU "0419".
   88 Taurus      VALUE "0422" THRU "0520".
   88 Gemini      VALUE "0523" THRU "0620".
   88 Cancer      VALUE "0623" THRU "0722".
   88 Leo         VALUE "0725" THRU "0822".
   88 Virgo       VALUE "0825" THRU "0922".
   88 Libra       VALUE "0925" THRU "1022".
   88 Scorpio     VALUE "1025" THRU "1121".
   88 Sagittarius VALUE "1124" THRU "1220".
   88 Capricorn   VALUE "1223" THRU "1231", "0101" THRU "0119". 
   02 WorkMonth     PIC XX.
   02 WorkDay       PIC XX.

LINKAGE SECTION.
01 DateOfBirth.
   02 BirthMonth    PIC XX.
   02 BirthDay      PIC XX.
   02 FILLER        PIC 9(4).

01 SignType         PIC 99.

PROCEDURE DIVISION USING DateOfBirth, SignType.
Begin.
   MOVE BirthDay   TO WorkDay.
   MOVE BirthMonth TO WorkMonth.
   EVALUATE TRUE
     WHEN Aquarius    MOVE  1 TO SignType
     WHEN Pisces      MOVE  2 TO SignType
     WHEN Aries       MOVE  3 TO SignType
     WHEN Taurus      MOVE  4 TO SignType
     WHEN Gemini      MOVE  5 TO SignType
     WHEN Cancer      MOVE  6 TO SignType
     WHEN Leo         MOVE  7 TO SignType
     WHEN Virgo       MOVE  8 TO SignType
     WHEN Libra       MOVE  9 TO SignType
     WHEN Scorpio     MOVE 10 TO SignType
     WHEN Sagittarius MOVE 11 TO SignType
     WHEN Capricorn   MOVE 12 TO SignType
     WHEN OTHER       MOVE 13 TO SignType
  END-EVALUATE.
  EXIT PROGRAM.
END PROGRAM IdentifySign.
END PROGRAM Listing16-9.