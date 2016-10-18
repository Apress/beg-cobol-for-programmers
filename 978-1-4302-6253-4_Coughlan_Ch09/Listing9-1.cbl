IDENTIFICATION DIVISION.
PROGRAM-ID. Listing9-1.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 NumericValue   PIC 9(8)V99  VALUE 00014584.95.
01 Edit1     PIC  99,999,999.99.
01 Edit2     PIC  ZZ,ZZZ,ZZ9.99.
01 Edit3     PIC  $*,***,**9.99.
01 Edit4     PIC  ++,+++,++9.99.
01 Edit5     PIC  $$,$$$,$$9.99.
01 Edit6     PIC  $$,$$$,$$9.00.
01 Edit7     PIC  99/999/999.99.
01 Edit8     PIC  99999000999.99.
01 Edit9     PIC  99999BBB999.99.

PROCEDURE DIVISION.
Begin.
MOVE NumericValue TO Edit1
DISPLAY "Edit1 = " Edit1

MOVE NumericValue TO Edit2
DISPLAY "Edit2 = " Edit2

MOVE NumericValue TO Edit3
DISPLAY "Edit3 = " Edit3

MOVE NumericValue TO Edit4
DISPLAY "Edit4 = " Edit4

MOVE NumericValue TO Edit5
DISPLAY "Edit5 = " Edit5

MOVE NumericValue TO Edit6
DISPLAY "Edit6 = " Edit6

MOVE NumericValue TO Edit7
DISPLAY "Edit7 = " Edit7

MOVE NumericValue TO Edit8
DISPLAY "Edit8 = " Edit8

MOVE NumericValue TO Edit9
DISPLAY "Edit9 = " Edit9

STOP RUN.


