IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing15-10.
AUTHOR.  Michael Coughlan.
*> Date Functions

DATA DIVISION.
WORKING-STORAGE SECTION.
01 DateAndTimeNow.
    02 DateNow.
       03 YearNow              PIC 9(4).
       03 MonthNow             PIC 99.
       03 DayNow               PIC 99.
    02 TimeC.
       03 HourNow              PIC 99.
       03 MinNow               PIC 99.
       03 SecNow               PIC 99.
       03 FILLER               PIC 99.
    02 GMT.
       03 GMTDiff              PIC X.
          88 GMTNotSupported  VALUE "0".
       03 GMTHours             PIC 99.
       03 GMTMins              PIC 99.

01  BillDate                   PIC 9(8).
01  DateNowInt                 PIC 9(8).
01  DaysOverdue                PIC S999.
01  NumOfDays                  PIC 999.

01  IntFutureDate              PIC 9(8).
01  FutureDate                 PIC 9(8).
01  DisplayDate REDEFINES FutureDate.
    02 YearD                   PIC 9999.
    02 MonthD                  PIC 99.
    02 DayD                    PIC 99.
    
01 DateCheck                   PIC 9(8) VALUE ZEROS.
   88 DateIsNotValid           VALUE ZEROS.
   88 DateIsValid              VALUE 1 THRU 99999999. 
   
PROCEDURE DIVISION.
Begin.
*> eg1 This example gets the current date and displays
*> the constituent parts.
   DISPLAY "eg1 - get the current date"
   MOVE FUNCTION CURRENT-DATE TO DateAndTimeNow
   DISPLAY "Current Date is "
           MonthNow "/" DayNow "/" YearNow
   DISPLAY "Current Time is "
            HourNow ":" MinNow ":" SecNow
   IF GMTNotSupported
       DISPLAY "This computer cannot supply the time"
       DISPLAY "difference between local and GMT."
     ELSE
       DISPLAY "The local time is - GMT "
                 GMTDiff GMTHours ":" GMTMins
   END-IF.

*> eg2. In this example bills fall due 30 days from
*> the billing date.
   DISPLAY SPACES
   DISPLAY "eg2 - find the difference between two dates"
   DISPLAY "Enter the date of the bill (yyyymmdd) - " WITH NO ADVANCING
   ACCEPT BillDate
   MOVE DateNow TO DateNowInt
   COMPUTE DaysOverDue =
           (FUNCTION INTEGER-OF-DATE(DateNowInt))
         - (FUNCTION INTEGER-OF-DATE(BillDate) + 30)

   EVALUATE TRUE
      WHEN DaysOverDue > ZERO
           DISPLAY "This bill is overdue."
      WHEN DaysOverDue = ZERO
           DISPLAY "This bill is due today."
      WHEN DaysOverDue < ZERO
           DISPLAY "This bill is not yet due."
   END-EVALUATE

*> eg3. This example displays the date NumOfDays days
*> from the current date
   DISPLAY SPACES
   DISPLAY "eg3 - find the date x days from now"
   DISPLAY "Enter the number of days - " WITH NO ADVANCING
   ACCEPT NumOfDays
   COMPUTE IntFutureDate = FUNCTION INTEGER-OF-DATE(DateNowInt) + NumOfDays + 1
   MOVE FUNCTION DATE-OF-INTEGER(IntFutureDate) TO FutureDate
   DISPLAY "The date in " NumOfDays " days time will be "
            MonthD "/" DayD "/" YearD
            
*> eg4. This takes advantage of the fact that DATE-OF-INTEGER 
*> requires a valid date to do some easy date validation 
   
   DISPLAY SPACES
   DISPLAY "eg4 - validate the date"
   PERFORM WITH TEST AFTER UNTIL DateIsValid   
      DISPLAY "Enter a valid date (yyyymmdd) - " WITH NO ADVANCING
      ACCEPT DateNowInt
      COMPUTE DateCheck = FUNCTION INTEGER-OF-DATE(DateNowInt)
      IF DateIsNotValid 
         DISPLAY DateNowInt " is not a valid date"
         DISPLAY SPACES
      END-IF
   END-PERFORM
   DISPLAY "Thank you! " DateNowInt " is a valid date."

   STOP RUN.