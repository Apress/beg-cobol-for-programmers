IDENTIFICATION DIVISION.
PROGRAM-ID. Listing5-2.
AUTHOR.  Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01  CityCode PIC 9 VALUE ZERO.
    88 CityIsDublin         VALUE 1.
    88 CityIsLimerick       VALUE 2.
    88 CityIsCork           VALUE 3.
    88 CityIsGalway         VALUE 4.
    88 CityIsSligo          VALUE 5.
    88 CityIsWaterford      VALUE 6.
    88 UniversityCity       VALUE 1 THRU 4.
    88 CityCodeNotValid     VALUE 0, 7, 8, 9.  
     
PROCEDURE DIVISION.
Begin.
   DISPLAY "Enter a city code (1-6) - " WITH NO ADVANCING
   ACCEPT CityCode 
   IF CityCodeNotValid
      DISPLAY "Invalid city code entered"
     ELSE
       IF CityIsLimerick 
          DISPLAY "Hey, we're home."
       END-IF
       IF CityIsDublin
          DISPLAY "Hey, we're in the capital." 
       END-IF
       IF UniversityCity 
          DISPLAY "Apply the rent surcharge!"
       END-IF
   END-IF
   STOP RUN.
