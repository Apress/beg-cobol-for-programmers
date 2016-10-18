IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing16-5.
AUTHOR.  Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 Parameters.
   02 StateNum      PIC 99.
   02 StateCode     PIC XX.   
   02 StateName     PIC X(14).
   02 StateCapital  PIC X(14).
   02 StatePop      PIC 9(8).
   02 ErrorFlag     PIC 9.
       
01 idx  PIC 99.

* Receiving item for TIME: Format is HHMMSSss   s = S/100 
01 CurrentTime.
   02 FILLER        PIC 9(4).
   02 Seed          PIC 9(4).
01 RandState        PIC 99. 
01 RandChoice       PIC 9.
 
01 Answer           PIC X(14). 
01 PopAnswer        PIC 9(8).
01 MinPop           PIC 9(8).
01 MaxPop           PIC 9(8).
01 PrnStatePop      PIC ZZ,ZZZ,ZZ9.
01 StrLength        PIC 99.

   
PROCEDURE DIVISION.
Begin.
   ACCEPT CurrentTime FROM TIME
   COMPUTE RandState = FUNCTION RANDOM(Seed)
   PERFORM 8 TIMES
      COMPUTE RandState  = (FUNCTION RANDOM * 50) + 1
      COMPUTE RandChoice = (FUNCTION RANDOM * 4) + 1  
      CALL "GetStateInfo" 
           USING BY REFERENCE  RandState, StateCode, StateName, 
                               StateCapital, StatePop, ErrorFlag                   
      EVALUATE RandChoice
        WHEN      1   PERFORM TestCapitalFromState
        WHEN      2   PERFORM TestCodeFromState
        WHEN      3   PERFORM TestPopFromState
        WHEN      4   PERFORM TestStateFromCapital
      END-EVALUATE
      DISPLAY SPACES
   END-PERFORM   
   STOP RUN.


TestCapitalFromState.
   CALL "GetStringLength" USING BY CONTENT StateName
                                BY REFERENCE StrLength  
   DISPLAY "What is the capital of " StateName(1:StrLength) "? "
           WITH NO ADVANCING
   ACCEPT Answer
   IF FUNCTION UPPER-CASE(Answer) = FUNCTION UPPER-CASE(StateCapital)
      DISPLAY "That is correct"
    ELSE
      DISPLAY "That is incorrect.  The capital of " StateName(1:StrLength)
              " is " StateCapital
   END-IF.
  
 
TestCodeFromState.
   CALL "GetStringLength" USING BY CONTENT StateName
                                BY REFERENCE StrLength  
   DISPLAY "What is the state code for " StateName(1:StrLength) "? " 
           WITH NO ADVANCING
   ACCEPT Answer
   IF FUNCTION UPPER-CASE(Answer) = FUNCTION UPPER-CASE(StateCode)
      DISPLAY "That is correct"
    ELSE
      DISPLAY "That is incorrect.  The code for " StateName(1:StrLength)  
              " is " StateCode
   END-IF.


TestPopFromState.
   CALL "GetStringLength" USING BY CONTENT StateName
                                BY REFERENCE StrLength  
   DISPLAY "What is the population of " StateName(1:StrLength) "? "
           WITH NO ADVANCING
   ACCEPT PopAnswer
   COMPUTE MinPop = PopAnswer - (PopAnswer * 0.25)
   COMPUTE MaxPop = PopAnswer + (PopAnswer * 0.25)
   MOVE StatePop TO PrnStatePop
   IF StatePop > MinPop AND < MaxPop
      DISPLAY "That answer is close enough.  The actual population is "  PrnStatePop
    ELSE
      DISPLAY "That is incorrect.  The population of " StateName(1:StrLength)
              " is " PrnStatePop
   END-IF.


TestStateFromCapital.
   CALL "GetStringLength" USING BY CONTENT StateCapital
                                BY REFERENCE StrLength  
   DISPLAY "Of what state is " StateCapital(1:StrLength) " the capital? "
           WITH NO ADVANCING
   ACCEPT Answer
   IF FUNCTION UPPER-CASE(Answer) = FUNCTION UPPER-CASE(StateName)
      DISPLAY "That is correct"
    ELSE
      DISPLAY "That is incorrect.  The state for " StateCapital(1:StrLength)
              " is " StateName
   END-IF.



IDENTIFICATION DIVISION.
PROGRAM-ID.  GetStringLength IS INITIAL.
AUTHOR.  Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 CharCount       PIC 99 VALUE ZEROS.

LINKAGE SECTION.
01 StringParam     PIC X(14).
01 StringLength    PIC 99.

PROCEDURE DIVISION USING StringParam, StringLength.
Begin.
   INSPECT FUNCTION REVERSE(StringParam) TALLYING CharCount
          FOR LEADING SPACES  
   COMPUTE StringLength = 14 - CharCount
   EXIT PROGRAM.
END PROGRAM GetStringLength.
END PROGRAM Listing16-5.



