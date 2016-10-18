IDENTIFICATION DIVISION.
PROGRAM-ID. Listing5-5.
AUTHOR.  Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 CountryCode       PIC 999 VALUE ZEROS.
   88 BritishCountry VALUES 3, 7, 10, 15.

01 CurrencyCode        PIC 99 VALUE ZEROS.
   88 CurrencyIsPound  VALUE 14.
   88 CurrencyIsEuro   VALUE 03.
   88 CurrencyIsDollar VALUE 28.

PROCEDURE DIVISION.
Begin.
   DISPLAY "Enter the country code :- " WITH NO ADVANCING
   ACCEPT CountryCode

   IF BritishCountry THEN 
      SET CurrencyIsPound TO TRUE
   END-IF
   IF CurrencyIsPound THEN
      DISPLAY "Pound sterling used in this country"
    ELSE
      DISPLAY "Country does not use sterling"
   END-IF
   STOP RUN.
