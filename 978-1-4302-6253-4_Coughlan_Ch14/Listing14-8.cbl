IDENTIFICATION DIVISION.
PROGRAM-ID. Listing14-8.
*> ISO 2002 Applying the SORT to a table
DATA DIVISION.
WORKING-STORAGE SECTION.
01 CountyTable.
   02 TableValues.
      03 FILLER  PIC X(16)  VALUE "kilkenny 0080421".
      03 FILLER  PIC X(16)  VALUE "laois    0058732".
      03 FILLER  PIC X(16)  VALUE "leitrim  0025815".
      03 FILLER  PIC X(16)  VALUE "tipperary0140281".
      03 FILLER  PIC X(16)  VALUE "waterford0101518".
      03 FILLER  PIC X(16)  VALUE "westmeath0072027".
      03 FILLER  PIC X(16)  VALUE "carlow   0045845".
      03 FILLER  PIC X(16)  VALUE "wicklow  0114719".
      03 FILLER  PIC X(16)  VALUE "cavan    0056416".
      03 FILLER  PIC X(16)  VALUE "clare    0103333".
      03 FILLER  PIC X(16)  VALUE "meath    0133936".
      03 FILLER  PIC X(16)  VALUE "monaghan 0052772".
      03 FILLER  PIC X(16)  VALUE "offaly   0063702".
      03 FILLER  PIC X(16)  VALUE "roscommon0053803".
      03 FILLER  PIC X(16)  VALUE "sligo    0058178".
      03 FILLER  PIC X(16)  VALUE "cork     0448181".
      03 FILLER  PIC X(16)  VALUE "donegal  0137383".
      03 FILLER  PIC X(16)  VALUE "dublin   1122600".
      03 FILLER  PIC X(16)  VALUE "galway   0208826".
      03 FILLER  PIC X(16)  VALUE "wexford  0116543".
      03 FILLER  PIC X(16)  VALUE "kerry    0132424".
      03 FILLER  PIC X(16)  VALUE "kildare  0163995".
      03 FILLER  PIC X(16)  VALUE "limerick 0175529".
      03 FILLER  PIC X(16)  VALUE "longford 0031127".
      03 FILLER  PIC X(16)  VALUE "louth    0101802".
      03 FILLER  PIC X(16)  VALUE "mayo     0117428".
   02 FILLER REDEFINES TableValues.
      03   CountyDetails OCCURS 26 TIMES
           INDEXED BY Cidx.
           04 CountyName   PIC X(9).
           04 CountyPop    PIC 9(7).

01 PrnCountyPop            PIC Z,ZZZ,ZZ9.

PROCEDURE DIVISION.
Begin.
   DISPLAY "County name order"
   SORT CountyDetails ON ASCENDING KEY CountyName
   PERFORM DisplayCountyTotals
           VARYING Cidx FROM 1 BY 1 UNTIL Cidx GREATER THAN 26.
           
   DISPLAY SPACES
   DISPLAY "County population order"
   SORT CountyDetails ON ASCENDING KEY CountyPop
   PERFORM DisplayCountyTotals
           VARYING Cidx FROM 1 BY 1 UNTIL Cidx GREATER THAN 26.

   STOP RUN.

DisplayCountyTotals.
   MOVE CountyPop(Cidx) TO PrnCountyPop
   DISPLAY CountyName(Cidx) " is " PrnCountyPop.