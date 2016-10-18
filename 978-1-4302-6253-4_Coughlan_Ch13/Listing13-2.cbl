IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing13-2.
AUTHOR.  Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 StatesTable.
   02 StateValues.
      03 FILLER PIC X(60)
         VALUE "ALAlabama       Montgomery    AKAlaska        Juneau".
      03 FILLER PIC X(60)
         VALUE "AZArizona       Phoenix       ARArkansas      Little Rock".
      03 FILLER PIC X(60)
         VALUE "CACalifornia    Sacramento    COColorado      Denver".
      03 FILLER PIC X(60)
         VALUE "CTConnecticut   Hartford      DEDelaware      Dover".
      03 FILLER PIC X(60)
         VALUE "FLFlorida       Tallahassee   GAGeorgia       Atlanta".
      03 FILLER PIC X(60)
         VALUE "HIHawaii        Honolulu      IDIdaho         Boise".
      03 FILLER PIC X(60)
         VALUE "ILIllinois      Springfield   INIndiana       Indianapolis".
      03 FILLER PIC X(60)
         VALUE "IAIowa          Des Moines    KSKansas        Topeka".
      03 FILLER PIC X(60)
         VALUE "KYKentucky      Frankfort     LALouisiana     Baton Rouge".
      03 FILLER PIC X(60)
         VALUE "MEMaine	        Augusta       MDMaryland      Annapolis".
      03 FILLER PIC X(60)
         VALUE "MAMassachusetts Boston        MIMichigan      Lansing".
      03 FILLER PIC X(60)
         VALUE "MNMinnesota     Saint Paul    MSMississippi   Jackson".
      03 FILLER PIC X(60)
         VALUE "MOMissouri      Jefferson CityMTMontana       Helena".
      03 FILLER PIC X(60)
         VALUE "NENebraska      Lincoln       NVNevada        Carson City".
      03 FILLER PIC X(60)
         VALUE "NHNew Hampshire Concord       NJNew Jersey    Trenton".
      03 FILLER PIC X(60)
         VALUE "NMNew Mexico    Santa Fe      NYNew York      Albany".
      03 FILLER PIC X(60)
         VALUE "NCNorth CarolinaRaleigh       NDNorth Dakota  Bismarck".
      03 FILLER PIC X(60)
         VALUE "OHOhio          Columbus      OKOklahoma      Oklahoma City".
      03 FILLER PIC X(60)
         VALUE "OROregon        Salem         PAPennsylvania  Harrisburg".
      03 FILLER PIC X(60)
         VALUE "RIRhode Island  Providence    SCSouth CarolinaColumbia".
      03 FILLER PIC X(60)
         VALUE "SDSouth Dakota  Pierre        TNTennessee     Nashville".
      03 FILLER PIC X(60)
         VALUE "TXTexas         Austin        UTUtah          Salt Lake City".
      03 FILLER PIC X(60)
         VALUE "VTVermont       Montpelier    VAVirginia      Richmond".
      03 FILLER PIC X(60)
         VALUE "WAWashington    Olympia       WVWest Virginia Charleston".
      03 FILLER PIC X(60)
         VALUE "WIWisconsin     Madison       WYWyoming       Cheyenne".
   02 FILLER REDEFINES StateValues.
      03 State OCCURS 50 TIMES
               INDEXED BY StateIdx.
         04 StateCode    PIC XX.
         04 StateName    PIC X(14).
         04 StateCapital PIC X(14).

01 StateNameIn           PIC X(14).

01 StateCapitalIn        PIC X(14).

01 StateCodeIn           PIC XX.

01 SearchChoice          PIC 9 VALUE ZERO.
   88 ValidSearchChoice  VALUES 1, 2, 3, 4.
   88 EndOfInput         VALUE 4.

PROCEDURE DIVISION.
Begin.
   PERFORM WITH TEST AFTER UNTIL EndOfInput
      PERFORM WITH TEST AFTER UNTIL ValidSearchChoice
         DISPLAY SPACES
         DISPLAY "Search by StateCode (1), StateName (2), StateCaptial (3), STOP (4) - " 
                 WITH NO ADVANCING
         ACCEPT SearchChoice
      END-PERFORM
      SET StateIdx TO 1
      EVALUATE SearchChoice
         WHEN 1 PERFORM GetNameAndCapital
         WHEN 2 PERFORM GetCodeAndCapital
         WHEN 3 PERFORM GetCodeAndName
      END-EVALUATE
   END-PERFORM
   STOP RUN.

GetNameAndCapital.
   DISPLAY "Enter the two letter State Code - " WITH NO ADVANCING
   ACCEPT StateCodeIn
   MOVE FUNCTION UPPER-CASE(StateCodeIn) TO StateCodeIn
   SEARCH State 
       AT END DISPLAY "State code " StateCodeIn " does not exist"
       WHEN StateCode(StateIdx) = StateCodeIn
            DISPLAY "State Name    = " StateName(StateIdx)
            DISPLAY "State Capital = " StateCapital(StateIdx)
   END-SEARCH.

GetCodeAndCapital.
   DISPLAY "Enter the State Name - " WITH NO ADVANCING
   ACCEPT StateNameIn
   SEARCH State 
       AT END DISPLAY "State Name " StateNameIn " does not exist"
       WHEN FUNCTION UPPER-CASE(StateName(StateIdx)) = FUNCTION UPPER-CASE(StateNameIn)
            DISPLAY "State Code    = " StateCode(StateIdx)
            DISPLAY "State Capital = " StateCapital(StateIdx)
   END-SEARCH.
                         
GetCodeAndName.
   DISPLAY "Enter the State Capital - " WITH NO ADVANCING
   ACCEPT StateCapitalIn
   SEARCH State 
       AT END DISPLAY "State capital " StateCapitalIn " does not exist"
       WHEN FUNCTION UPPER-CASE(StateCapital(StateIdx)) = FUNCTION UPPER-CASE(StateCapitalIn)
            DISPLAY "State Code = " StateCode(StateIdx)
            DISPLAY "State Name = " StateName(StateIdx)
   END-SEARCH.
