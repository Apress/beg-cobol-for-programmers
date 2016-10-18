IDENTIFICATION DIVISION. 
PROGRAM-ID. Debug4.  
AUTHOR.  Michael Coughlan.     
 
DATA DIVISION.       
WORKING-STORAGE SECTION.       
01 Counter1        PIC 99. 
01 InNumber        PIC 9.  
01 Result          PIC 999.         
 
 
PROCEDURE DIVISION.  
Begin.  
    DISPLAY "DEBUG4.  Sometimes I just don't stop"         
    DISPLAY "Enter number 0-9 :--> " WITH NO ADVANCING      
    ACCEPT InNumber        
    PERFORM EternalLooping 
       VARYING Counter1 FROM 1 BY 1     
       UNTIL Counter1 GREATER THAN 10
       
    DISPLAY "Back in main paragraph now"          
    STOP RUN.        
 
EternalLooping.  
    COMPUTE Result = InNumber * Counter1       
    IF Result > 60   
        MOVE 99 TO Counter1   
    END-IF          
    DISPLAY "Counter1 = " Counter1 "  Result = " Result.
