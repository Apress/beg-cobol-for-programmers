IDENTIFICATION DIVISION.
PROGRAM-ID.  Listing15-9.
AUTHOR.  Michael Coughlan.
*> Intrinsic Function examples

DATA DIVISION.
WORKING-STORAGE SECTION.
01 OrdPos        PIC 99.

01 TableValues   VALUE "123411457429130938637306851419883522700467".
    02 Num       PIC 99 OCCURS 21 TIMES.
    
01 idx           PIC 9.
    
01 xString       PIC X(45) 
                 VALUE "This string is 33 characters long". 
              
01 xWord         PIC X(10).
    
01 CharCount     PIC 99.

01 TextLength    PIC 99.  
       
PROCEDURE DIVISION.                                               
Begin. 
*> eg1. In the ASCII collating sequence W has a code of 87 but an ordinal 
*> position of 88.
   DISPLAY "eg1. The character in position 88 is = " FUNCTION CHAR(88) 
  
*> eg2. Using ordinal positions to spell out my name
   DISPLAY SPACES
   DISPLAY "eg2. My name is " FUNCTION CHAR(78)  FUNCTION CHAR(106) 
                              FUNCTION CHAR(108) FUNCTION CHAR(102)                    

*> eg3. Finding the ordinal position of a particular character 
   DISPLAY SPACES       
   MOVE FUNCTION ORD("A") TO OrdPos
   DISPLAY "eg3. The ordinal position of A is = " OrdPos 

*> eg4. Using CHAR and ORD in combination to display the sixth letter of the alphabet
   DISPLAY SPACES
   DISPLAY "eg4. The sixth letter of the alphabet is "  
           FUNCTION CHAR(FUNCTION ORD("A") + 5)
           
*> eg5. Finding the position of the highest value in a list of parameters
   DISPLAY SPACES      
   MOVE FUNCTION ORD-MAX("t" "b" "x" "B" "4" "s" "b") TO OrdPos
   DISPLAY "eg5. Highest character in the list is at pos " OrdPos
  
*> eg6. Finding the position of the lowest value in a list of parameters 
   DISPLAY SPACES                                                                 
   MOVE FUNCTION ORD-MIN("t" "b" "x" "B" "4" "s" "b") TO OrdPos
   DISPLAY "eg6. Lowest character in the list is at pos " OrdPos
   
*> eg7.Finding the position of the highest value in a table
   DISPLAY SPACES
   MOVE FUNCTION ORD-MAX(Num(ALL)) TO OrdPos
   DISPLAY "eg7. Highest value in the table is at pos " OrdPos   
   
*> eg8. Finding the highest value in a table  
   DISPLAY SPACES  
   DISPLAY "eg8. Highest value in the table = " Num(FUNCTION ORD-MAX(Num(ALL)))
   
*> eg9. Finds the top three values in a table by finding the top 
*> overwrites it with zeros to remove it from consideration 
*> then finds the next top and so on
   DISPLAY SPACES
   DISPLAY "eg9."
   PERFORM VARYING idx FROM 1 BY 1 UNTIL idx > 3
      DISPLAY "TopPos " idx " = " Num(FUNCTION ORD-MAX(Num(ALL)))
      MOVE ZEROS TO Num(FUNCTION ORD-MAX(Num(ALL)))
   END-PERFORM
   
*> eg10. Finding the length of a string
   DISPLAY SPACES
   DISPLAY "eg10. The length of xString is " FUNCTION LENGTH(xString) " characters"
   
*> eg11. Finding the length of the text in a string
   DISPLAY SPACES
   INSPECT FUNCTION REVERSE(xString) TALLYING CharCount
          FOR LEADING SPACES
   COMPUTE TextLength = FUNCTION LENGTH(xString) - CharCount
   DISPLAY "eg11. The length of text in xString is " TextLength " characters"

*> eg12. Discover if a word is a palindrome
   DISPLAY SPACES
   DISPLAY "eg12."
   MOVE ZEROS TO CharCount
   DISPLAY "Enter a word - " WITH NO ADVANCING
   ACCEPT xWord
   INSPECT FUNCTION REVERSE(xWord) TALLYING CharCount
          FOR LEADING SPACES  
   IF FUNCTION UPPER-CASE(xWord(1:FUNCTION LENGTH(xWord) - CharCount)) EQUAL TO 
      FUNCTION UPPER-CASE(FUNCTION REVERSE(xWord(1:FUNCTION LENGTH(xWord)- CharCount)))
      DISPLAY xWord " is a palindrome"
     ELSE 
      DISPLAY xWord " is not a palindrome"
   END-IF          
   STOP RUN.                     