IDENTIFICATION DIVISION.
PROGRAM-ID. Listing13-5.
AUTHOR. Michael Coughlan.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
       SELECT CountryCodeFile ASSIGN TO "Listing13-5.dat"
                 ORGANIZATION IS LINE SEQUENTIAL.
                 
DATA DIVISION. 
FILE SECTION.
FD CountryCodeFile.
01 CountryCodeRec.
   88 EndOfCountryCodeFile VALUE HIGH-VALUES.
   02 CountryCodeCF    PIC XX.
   02 CountryNameCF    PIC X(25).

WORKING-STORAGE SECTION.
01 CountryCodeTable.
   02 Country OCCURS 300 TIMES
              ASCENDING KEY IS CountryCode
              INDEXED BY Cidx.
      03 CountryCode   PIC XX.
      03 CountryName   PIC X(25).
      
01 CountryCodeIn       PIC XX.
   88 EndOfInput       VALUE SPACES.
   
01 FILLER              PIC 9 VALUE ZERO.
   88 ValidCountryCode VALUE 1.

PROCEDURE DIVISION.
Begin.
    PERFORM LoadCountryCodeTable
    PERFORM WITH TEST AFTER UNTIL EndOfInput
       PERFORM WITH TEST AFTER UNTIL ValidCountryCode OR EndOfInput
           DISPLAY "Enter a country code (space to stop) :- " 
                   WITH NO ADVANCING
           ACCEPT CountryCodeIn 
           SEARCH ALL Country
               AT END IF NOT EndOfInput 
                         DISPLAY "Country code " CountryCodeIn " is not valid" 
                      END-IF
               WHEN CountryCode(Cidx) =  FUNCTION UPPER-CASE(CountryCodeIn)
               DISPLAY CountryCodeIn " is " CountryName(Cidx) 
           END-SEARCH
           DISPLAY SPACES
       END-PERFORM
    END-PERFORM     
    STOP RUN.

LoadCountryCodeTable.
* Loads table with HIGH-VALUES so the SEARCH ALL works when the table is partially loaded
    MOVE HIGH-VALUES TO CountryCodeTable
    OPEN INPUT CountryCodeFile
    READ CountryCodeFile
       AT END SET EndOfCountryCodeFile TO TRUE
    END-READ

    PERFORM VARYING Cidx FROM 1 BY 1 UNTIL EndOfCountryCodeFile
        MOVE CountryCodeRec TO Country(Cidx)
        READ CountryCodeFile
           AT END SET EndOfCountryCodeFile TO TRUE
        END-READ       
    END-PERFORM
    CLOSE CountryCodeFile.


