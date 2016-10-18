IDENTIFICATION DIVISION.
PROGRAM-ID. Listing6-1.
AUTHOR. Michael Coughlan.
PROCEDURE DIVISION.
LevelOne. 
   DISPLAY "> Starting to run program" 
   PERFORM LevelTwo
   DISPLAY "> Back in LevelOne"
   STOP RUN.

LevelFour.
   DISPLAY "> > > > Now in LevelFour".

LevelThree.
   DISPLAY "> > > Now in LevelThree"
   PERFORM LevelFour
   DISPLAY "> > > Back in LevelThree".

LevelTwo.
   DISPLAY "> > Now in LevelTwo"
   PERFORM LevelThree 
   DISPLAY "> > Back in LevelTwo".
