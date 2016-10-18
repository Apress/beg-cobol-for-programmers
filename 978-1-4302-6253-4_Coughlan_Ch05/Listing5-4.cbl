IDENTIFICATION DIVISION.
PROGRAM-ID. Listing5-4.
AUTHOR.  Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01  MakeOfCar        PIC X(10).
    88 VolksGroup  VALUE "skoda", "seat",
                         "audi", "volkswagen". 
    88 GermanMade  VALUE "volkswagen", "audi",
                         "mercedes", "bmw",
                         "porsche". 
PROCEDURE DIVISION.
Begin.
   DISPLAY "Enter the make of car - " WITH NO ADVANCING
   ACCEPT MakeOfCar
   IF VolksGroup AND GermanMade
      DISPLAY "Your car is made in Germany by the Volkswagen Group."
    ELSE 
      IF VolksGroup
         DISPLAY "Your car is made by the Volkswagen Group."
      END-IF
      IF GermanMade
         DISPLAY "Your car is made in Germany."
      END-IF
   END-IF
   STOP RUN.
