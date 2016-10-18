IDENTIFICATION DIVISION.
PROGRAM-ID. Listing13-3.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 MyTimeTable.
   02 DayOfApp OCCURS 5 TIMES INDEXED BY DayIdx.      
      03 HourOfApp OCCURS 9 TIMES INDEXED BY HourIdx.         
         04 Appointment      PIC X(15).         
         04 Location         PIC X(20).
            
01 AppointmentType           PIC X(15).

01 DaySub                    PIC 9.
01 HourSub                   PIC 9.

01 FILLER                    PIC 9 VALUE ZERO.
   88 AppointmentNotFound    VALUE ZERO.
   88 AppointmentFound       VALUE 1.

01 DayTable VALUE "MonTueWedThuFri".
   02 DayName   PIC XXX OCCURS 5 TIMES.

01 TimeValues  VALUE " 9:0010:0011:0012:0013:0014:0015:0016:0017:00".
   02 TimeValue   PIC X(5) OCCURS 9 TIMES.         
         
PROCEDURE DIVISION.
Begin.
   MOVE "Peter's Wedding" TO AppointmentType, Appointment(2, 3)
   MOVE "Saint John's Church" TO Location(2, 3)
   SET DayIdx TO 1.
   PERFORM UNTIL AppointmentFound OR DayIdx > 5   
      SET HourIdx TO 1  
      SEARCH HourOfApp
         AT END SET DayIdx UP BY 1    
         WHEN AppointmentType = Appointment(DayIdx, HourIdx)
              SET AppointmentFound TO TRUE 
              SET HourSub TO HourIdx   
              SET DaySub TO DayIdx
              DISPLAY AppointmentType " is on " DayName(DaySub) 
              DISPLAY "at " TimeValue(HourSub) " in " Location(DayIdx, HourIdx) 
     END-SEARCH
   END-PERFORM
   IF AppointmentNotFound
      DISPLAY "Appointment " AppointmentType " was not in the timetable"
   END-IF
   STOP RUN.
