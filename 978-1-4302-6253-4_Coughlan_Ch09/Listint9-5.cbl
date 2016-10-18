IDENTIFICATION DIVISION.
PROGRAM-ID. Listing9-5.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 SmallScaledNumber  PIC VP(5)999   VALUE .00000423.
01 LargeScaledNumber  PIC 999P(5)V   VALUE 45600000.00. 
01 ScaledBillions     PIC 999P(9)    VALUE ZEROS.

01 SmallNumber        PIC 9V9(8)     VALUE 1.11111111.
01 LargeNumber        PIC 9(8)V9     VALUE 11111111.

01 PrnSmall           PIC 99.9(8).
01 PrnLarge           PIC ZZ,ZZZ,ZZ9.99.
01 PrnBillions        PIC ZZZ,ZZZ,ZZZ,ZZ9.

PROCEDURE DIVISION.
Begin.
    MOVE SmallScaledNumber TO PrnSmall
    MOVE LargeScaledNumber TO PrnLarge
    DISPLAY "Small scaled = " PrnSmall
    DISPLAY "Large scaled = " PrnLarge

    ADD SmallScaledNumber TO SmallNumber
    ADD LargeScaledNumber TO LargeNumber
    MOVE SmallNumber TO PrnSmall
    MOVE LargeNumber TO PrnLarge
    DISPLAY "Small  = " PrnSmall
    DISPLAY "Large  = " PrnLarge
    
    MOVE 123456789012  TO ScaledBillions 
    MOVE ScaledBillions  TO PrnBillions
    DISPLAY "Billions = " PrnBillions    
    STOP RUN.
