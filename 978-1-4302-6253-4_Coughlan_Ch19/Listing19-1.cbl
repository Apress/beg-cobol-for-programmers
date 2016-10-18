IDENTIFICATION DIVISION.
PROGRAM-ID. Listing19-1.
AUTHOR.  Michael Coughlan.
*UseDictionary program 

REPOSITORY.
    CLASS DictionaryCls AS "dictionary".
 
DATA DIVISION.
WORKING-STORAGE SECTION.
01 AcronymDictionary  USAGE OBJECT REFERENCE DictionaryCls.
01 NetworkDictionary  USAGE OBJECT REFERENCE DictionaryCls.
01 SlangDictionary    USAGE OBJECT REFERENCE DictionaryCls.
01 CurrentDictionary  USAGE OBJECT REFERENCE.

01 WordToAdd          PIC X(20).
   88 EndOfInput      VALUE SPACES.
   
01 WordDefinition     PIC X(1000).

PROCEDURE DIVISION.
Begin.   
   INVOKE DictionaryCls "new" USING BY CONTENT "Acronym Dictionary"  RETURNING AcronymDictionary
   INVOKE DictionaryCls "new" USING BY CONTENT "Network Dictionary"  RETURNING NetworkDictionary
   INVOKE DictionaryCls "new" USING BY CONTENT "Slang Dictionary"    RETURNING SlangDictionary
   
   SET CurrentDictionary TO AcronymDictionary
   DISPLAY "Fill the Acronym dictionary"
   PERFORM FillTheDictionary WITH TEST AFTER UNTIL EndOfInput   

   SET CurrentDictionary TO NetworkDictionary
   DISPLAY "Fill the Network dictionary"
   PERFORM FillTheDictionary WITH TEST AFTER UNTIL EndOfInput  
   
   SET CurrentDictionary TO SlangDictionary
   DISPLAY "Fill the Slang dictionary"
   PERFORM FillTheDictionary WITH TEST AFTER UNTIL EndOfInput   
 
   DISPLAY SPACES  
   INVOKE AcronymDictionary "PrintDictionaryContents" 

   DISPLAY SPACES
   INVOKE NetworkDictionary "PrintDictionaryContents" 

   DISPLAY SPACES
   INVOKE SlangDictionary "PrintDictionaryContents" 

   INVOKE AcronymDictionary  "finalize" RETURNING AcronymDictionary
   INVOKE NetworkDictionary  "finalize" RETURNING NetworkDictionary
   INVOKE SlangDictionary    "finalize" RETURNING SlangDictionary 
   STOP RUN.
   

FillTheDictionary.
   DISPLAY "Enter a word to add (press return to end) - " WITH NO ADVANCING
   ACCEPT WordToAdd
   
   DISPLAY "Enter the word definition - " WITH NO ADVANCING
   ACCEPT WordDefinition 
    
   INVOKE CurrentDictionary "AddWordToDictionary" 
          USING BY CONTENT WordToAdd, WordDefinition.

