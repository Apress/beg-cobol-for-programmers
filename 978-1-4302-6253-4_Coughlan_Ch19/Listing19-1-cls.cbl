CLASS-ID.  DictionaryCls AS "dictionary" 
           INHERITS FROM Base.                                                   
AUTHOR. Michael Coughlan.                                             

REPOSITORY.                                                            
   CLASS Base AS "base"                                               
   CLASS DictionaryCls AS "dictionary".
   

FACTORY.                                                                         
METHOD-ID. New.                        
LINKAGE SECTION.                                                       
01 TestObject-lnk  OBJECT REFERENCE. 
01 DictionaryName  PIC X(20).
                                                                         
PROCEDURE DIVISION USING DictionaryName RETURNING TestObject-lnk.
Begin. 
*Create a new dictionary object by invoke "new" in the base class
      INVOKE SUPER "new" RETURNING TestObject-lnk. 

*Set the dictionary name in the dictionary object
      INVOKE TestObject-lnk "SetDictionaryName"
              USING BY CONTENT DictionaryName
      EXIT METHOD.
END METHOD New.
END FACTORY.



                                            
OBJECT. 
DATA DIVISION.                                                               
WORKING-STORAGE SECTION.                                               
*Items declared here are visible only to methods of this                
*instance.  They have state memory.                                     
01 DictionaryTable.
   02 DictionaryEntry  OCCURS 0 TO 1000 TIMES
      DEPENDING ON NumberOfWords
      INDEXED BY WordIdx.
      03 DictionaryWord   PIC X(20).
      03 WordDefinition   PIC X(1000).
      
01 NumberOfWords     PIC 9(4) VALUE ZERO.   

01 DictionaryName    PIC X(20).



METHOD-ID. SetDictionaryName.
LINKAGE SECTION.                                                       
01 DictionaryNameIn     PIC X(20). 
PROCEDURE DIVISION USING DictionaryNameIn.                                
Begin.
    MOVE DictionaryNameIn TO DictionaryName
END METHOD SetDictionaryName.  

          
  
METHOD-ID. AddWordToDictionary.                                             
LINKAGE SECTION.                                                       
01 WordIn               PIC X(20). 
01 DefinitionIn         PIC X(1000).                               
PROCEDURE DIVISION USING WordIn, DefinitionIn.                                
Begin.
    MOVE FUNCTION UPPER-CASE(WordIn) TO WordIn
    SET WordIdx TO 1
    SEARCH DictionaryEntry 
        AT END ADD 1 TO NumberOfWords
             MOVE WordIn TO DictionaryWord(NumberOfWords)
             MOVE DefinitionIn TO WordDefinition(NumberOfWords)
        WHEN WordIn = DictionaryWord(WordIdx)
             DISPLAY WordIn " is already in the dictionary"
     END-SEARCH
     EXIT METHOD.
END METHOD AddWordToDictionary.                                            
                                                                         
                                                                         
METHOD-ID.  PrintDictionaryContents.                                                   
LOCAL-STORAGE SECTION.                                                             
PROCEDURE DIVISION.                                                    
Begin. 
    DISPLAY "Words in  - " DictionaryName
    PERFORM VARYING WordIdx FROM 1 BY 1 UNTIL WordIdx = NumberOfWords
       DISPLAY "Word = " DictionaryWord(WordIdx)
    END-PERFORM    
    DISPLAY "------ End of dictionary words  --------"                                                                         
    EXIT METHOD.                                                       
END METHOD PrintDictionaryContents.                                                   
END OBJECT.                                                            
END CLASS DictionaryCls.
       
       