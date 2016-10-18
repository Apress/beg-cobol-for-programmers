IDENTIFICATION DIVISION.
PROGRAM-ID. Listing13-8.
AUTHOR. Michael Coughlan.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 NumberArray.
   02 Num PIC 99 OCCURS 10 TIMES
                 INDEXED BY Nidx.        
  
01 FirstZeroPos            PIC 99 VALUE ZERO.
   88 NoZeros              VALUE 0.
  
01 SecondZeroPos           PIC 99 VALUE ZERO.
   88 OneZero              VALUE 0.
  
01 ValuesBetweenZeros      PIC 9 VALUE ZERO.
   88 NoneBetweenZeros     VALUE 0.

PROCEDURE DIVISION.
Begin.
  DISPLAY "Enter 10 two digit numbers "
  PERFORM VARYING Nidx FROM 1 BY 1 UNTIL Nidx > 10
     DISPLAY "Enter number - "  SPACE WITH NO ADVANCING
     ACCEPT Num(Nidx)
  END-PERFORM

  SET Nidx TO 1
  SEARCH Num
    AT END SET NoZeros TO TRUE
    WHEN Num(Nidx) = ZERO
     SET FirstZeroPos TO Nidx
     SET Nidx UP BY 1
     SEARCH Num
       AT END SET OneZero TO TRUE
       WHEN Num(Nidx) = ZERO
        SET SecondZeroPos TO Nidx
        COMPUTE ValuesBetweenZeros = (SecondZeroPos - 1) - FirstZeroPos
     END-SEARCH
  END-SEARCH
  
  EVALUATE TRUE
    WHEN NoZeros    DISPLAY "No zeros found"
    WHEN OneZero    DISPLAY "Only one zero found"
    WHEN NoneBetweenZeros DISPLAY "No numbers between the two zeros"
    WHEN FUNCTION REM(ValuesBetweenZeros, 2)= ZERO
                    DISPLAY "Even number of non-zeros between zeros"
    WHEN OTHER      DISPLAY "Odd number of non-zeros between zeros"
  END-EVALUATE
  STOP RUN.
