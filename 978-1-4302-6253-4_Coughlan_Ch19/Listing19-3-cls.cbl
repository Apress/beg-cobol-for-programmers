      $SET ISO2002 
      $SET DIALECT"ISO2002"  
      $SET SOURCEFORMAT"FREE"
CLASS-ID. Zodiac AS "zodiac" INHERITS FROM Base.
* AUTHOR. Michael Coughlan.  

REPOSITORY.
    CLASS BASE AS "base"  
    CLASS Zodiac AS "zodiac".

* No FACTORY in this program       

OBJECT.
WORKING-STORAGE SECTION.
01 ZodiacTable.
   02 ZodiacTableData.             
      03 FILLER   PIC X(20) VALUE "Aries      103210419".
      03 FILLER   PIC X(20) VALUE "Taurus     204200520".
      03 FILLER   PIC X(20) VALUE "Gemini     305210620".
      03 FILLER   PIC X(20) VALUE "Cancer     406210722".
      03 FILLER   PIC X(20) VALUE "Leo        107230822".
      03 FILLER   PIC X(20) VALUE "Virgo      208230922".
      03 FILLER   PIC X(20) VALUE "Libra      309231022".
      03 FILLER   PIC X(20) VALUE "Scorpio    410231121".
      03 FILLER   PIC X(20) VALUE "Sagittarius111221221".
      03 FILLER   PIC X(20) VALUE "Capricorn  212221231".
      03 FILLER   PIC X(20) VALUE "Aquarius   301200218".
      03 FILLER   PIC X(20) VALUE "Pisces     402190320".
   02 ZodiacSign REDEFINES ZodiacTableData 
                 OCCURS 12 TIMES 
                 INDEXED BY Zidx.
      03 SignName        PIC X(11).
      03 SignElement     PIC 9.
      03 StartDate       PIC X(4).
      03 EndDate         PIC X(4).

01 ElementTable VALUE "Fire EarthAir  Water".
   02 Element OCCURS 4 TIMES PIC X(5).


METHOD-ID. getSignHouse.
LOCAL-STORAGE SECTION.
01 WorkDate.
   88 SignIsCusp  VALUE "0120", "0121", "0219", "0220",
                        "0320", "0321", "0420", "0421",
                        "0521", "0522", "0621", "0622",
                        "0723", "0724", "0823", "0824",
                        "0923", "0924", "1023", "1024",
                        "1122", "1123", "1221", "1222".
   02 WorkMonth          PIC XX.
   02 WorkDay            PIC XX.

LINKAGE SECTION.
01 InDate.
   02 InDay              PIC XX.
   02 InMonth            PIC XX.

01 House                 PIC 99.
01 OpStatus              PIC 9.
   88 CuspSign           VALUE 1.
   88 InvalidDate        VALUE 2.

PROCEDURE DIVISION USING InDate, House RETURNING OpStatus.
  MOVE InDay   TO WorkDay
  MOVE InMonth TO WorkMonth
  MOVE 0 TO OpStatus
  SET Zidx TO 1
  SEARCH ZodiacSign
     AT END IF WorkDate >= "0101" AND <= "0119"
                         MOVE 11 TO House
            END-IF
     WHEN WorkDate >= StartDate(Zidx) AND <= EndDate(Zidx)
          SET House TO Zidx
  END-SEARCH
  IF SignIsCusp SET CuspSign TO TRUE
  END-IF

  EXIT METHOD.
END METHOD getSignHouse.


METHOD-ID. getSignName.
LINKAGE SECTION.
01 House                 PIC 99.
   88 ValidSignHouse     VALUE 01 THRU 12.
01 OutSignName           PIC X(11).

01 OpStatus              PIC 9.
   88 InvalidSignHouse   VALUE 1.
   88 OperationOk        VALUE 0.

PROCEDURE DIVISION USING House, OutSignName RETURNING OpStatus.
  IF NOT ValidSignHouse
     SET InvalidSignHouse TO TRUE
   ELSE
     MOVE SignName(House) TO OutSignName
     SET OperationOk TO TRUE
  END-IF
  EXIT METHOD.
END METHOD getSignName.


METHOD-ID. getSignElement.
LINKAGE SECTION.
01 House    PIC 99.
   88 ValidSignHouse     VALUE 01 THRU 12.
   
01 OutSignElement        PIC X(5).

01 OpStatus              PIC 9.
   88 InvalidSignHouse   VALUE 1.
   88 OperationOk        VALUE 0.

PROCEDURE DIVISION USING House, OutSignElement RETURNING OpStatus.
  IF NOT ValidSignHouse
     SET InvalidSignHouse TO TRUE
   ELSE
     MOVE Element(SignElement(House)) TO OutSignElement
     SET OperationOk TO TRUE
  END-IF
  EXIT METHOD.
END METHOD getSignElement.
END OBJECT.
END CLASS Zodiac.


