IDENTIFICATION DIVISION.
PROGRAM-ID. Listing19-3.
* Zodiac Compatibility program
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT BirthsFile ASSIGN TO "Listing19-3-MPDOB.DAT"
        ORGANIZATION IS LINE SEQUENTIAL.

CLASS-CONTROL.
    ZodiacFactory IS CLASS "zodiac".

DATA DIVISION.
FILE SECTION.
FD BirthsFile.
01 BirthsRec.
   88 EndOfFile  VALUE HIGH-VALUES.
   02 MaleDOB.
      03 MaleDate         PIC X(4).
      03 FILLER           PIC X(4).
   02 FemaleDOB.
      03 FemaleDate       PIC X(4).
      03 FILLER           PIC X(4).
 

WORKING-STORAGE SECTION.
01 MyZodiac   USAGE OBJECT REFERENCE. 

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
   
01 MaleSign           PIC 99.   
01 FemaleSign         PIC 99.
01 SumOfSigns         PIC 99.
       
01 OpStatusM          PIC 9.
   88 ValidMale       VALUE ZEROS.

01 OpStatusF           PIC 9.
   88 ValidFemale     VALUE ZEROS.


PROCEDURE DIVISION.
Begin.
   INVOKE ZodiacFactory "new" RETURNING MyZodiac
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
   INVOKE MyZodiac "getSignHouse" USING BY CONTENT MaleDate
                                        BY REFERENCE MaleSign
                                        RETURNING OpStatusM

   INVOKE MyZodiac "getSignHouse" USING BY CONTENT FemaleDate
                                        BY REFERENCE FemaleSign
                                        RETURNING OpStatusF
 
   IF ValidMale AND ValidFemale
      COMPUTE SumOfSigns = MaleSign + FemaleSign
      IF FUNCTION REM(SumOfSigns 2)  = ZERO
         ADD 1 TO CompatiblePairs
        ELSE 
         ADD 1 TO IncompatiblePairs
      END-IF
   END-IF
   READ BirthsFile
      AT END SET  EndOfFile TO TRUE
   END-READ.

                    

