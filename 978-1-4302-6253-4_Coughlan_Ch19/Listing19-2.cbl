IDENTIFICATION DIVISION.
PROGRAM-ID. Listing19-2.
* AUTHOR.  Michael Coughlan. 
* Demonstrates the difference between Factory methods & data 
* and instance methods & data. 
* It is also used to demonstrate the scope of
* data items declared in different parts of the program. 
 
REPOSITORY.
    CLASS Tester-cls AS "tester".

DATA DIVISION.
WORKING-STORAGE SECTION.
01 Test1-obj  OBJECT REFERENCE Tester-cls.
01 Test2-obj  OBJECT REFERENCE Tester-cls.
01 Test3-obj  OBJECT REFERENCE Tester-cls.
  
PROCEDURE DIVISION.
Begin. 
   INVOKE Tester-cls "new" RETURNING Test1-obj  
   INVOKE Tester-cls "new" RETURNING Test2-obj
   INVOKE Tester-cls "new" RETURNING Test3-obj

   DISPLAY SPACES
   DISPLAY "--------- Test3-obj ViewData -----------" 
   INVOKE Test3-obj "ViewData" 
 
   DISPLAY SPACES 
   DISPLAY "--------- Test1-obj ViewData -----------" 
   INVOKE Test1-obj "ViewData" 

   DISPLAY SPACES
   DISPLAY "--------- Test3-obj ViewData again -----" 
   INVOKE Test3-obj "ViewData" 

   DISPLAY SPACES
   DISPLAY "--------- Test2-obj ViewData -----------"
   INVOKE Test2-obj "ViewData" USING BY CONTENT 5

   INVOKE Test1-obj "finalize" RETURNING Test1-obj
   INVOKE Test2-obj "finalize" RETURNING Test2-obj
   INVOKE Test3-obj "finalize" RETURNING Test3-obj
   STOP RUN.
