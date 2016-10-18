      $SET ISO2002 
      $SET DIALECT"ISO2002"  
      $SET SOURCEFORMAT"FREE"
CLASS-ID. Tester-cls AS "tester" 
          INHERITS FROM Base.
* AUTHOR. Michael Coughlan.                                             
* Demonstrates the difference between Factory methods and data and Instance methods
* and data.  Also demonstrates persistence of data items declared in different areas. 

REPOSITORY.
    CLASS BASE AS "base"  
    CLASS Tester-cls AS "tester".

FACTORY.
WORKING-STORAGE SECTION.
*Items declared here are visible only to factory methods and have state memory
01 InstCounter-fws   PIC 9 VALUE ZEROS.
01 FactoryData-fws   PIC 9 VALUE ZEROS.
 
METHOD-ID. New.
LOCAL-STORAGE SECTION.
*Items declared here are visible only to this method but do not have state memory. 
01 LocalData-mls   PIC 9 VALUE ZEROS.
                                                                         
LINKAGE SECTION.
01 TestObject-lnk  OBJECT REFERENCE.
 
PROCEDURE DIVISION RETURNING TestObject-lnk.
Begin.
    ADD 2 TO FactoryData-fws LocalData-mls
    DISPLAY "Factory Working-Storage data has state memory  - "  
              FactoryData-fws
    DISPLAY "but Factory Method Local-Storage data does not - " 
              LocalData-mls
    DISPLAY SPACES
    INVOKE SUPER "new" RETURNING TestObject-lnk
    ADD 1 TO InstCounter-fws 
    INVOKE TestObject-lnk "InitialiseData" 
           USING BY CONTENT InstCounter-fws 
    EXIT METHOD. 
END METHOD New.

METHOD-ID. GetTotalInstCount.
LINKAGE SECTION.
01  TotalInstCount-lnk    PIC 9.
PROCEDURE DIVISION RETURNING TotalInstCount-lnk.
Begin.
   MOVE InstCounter-fws TO TotalInstCount-lnk. 
END METHOD GetTotalInstCount. 
END FACTORY.


OBJECT.
WORKING-STORAGE SECTION.
*Items declared here are visible only to methods of this 
*instance.  They are persist for the life of the object instance.
01  ThisInstanceNum-ows          PIC 9 VALUE ZEROS.
01  InstObjectData-ows           PIC 99 VALUE ZEROS.
  
METHOD-ID. InitialiseData.
LINKAGE SECTION.
01 InstNumIn-lnk                 PIC 9.
PROCEDURE DIVISION USING InstNumIn-lnk.
Begin.
    MOVE InstNumIn-lnk TO ThisInstanceNum-ows
    EXIT METHOD.
END METHOD InitialiseData. 


METHOD-ID. ViewData.
LOCAL-STORAGE SECTION.
*Items declared here only exist for the life of the method.
*They do not retain their values between invocations.
01  InstMethodData-mls           PIC 99 VALUE ZEROS.
01  TotalInstCount-mls           PIC 9  VALUE ZEROS.
01  Increment-mls                PIC 99 VALUE ZEROS.

PROCEDURE DIVISION.
Begin.
    COMPUTE Increment-mls = 10 * ThisInstanceNum-ows
    ADD Increment-mls TO InstObjectData-ows, InstMethodData-mls
    INVOKE Tester-cls "GetTotalInstCount" 
                        RETURNING TotalInstCount-mls
    DISPLAY "This is instance " ThisInstanceNum-ows
              " of " TotalInstCount-mls
    DISPLAY "Instance Object Data = " InstObjectData-ows
    DISPLAY "Instance Method Data = " InstMethodData-mls
    EXIT METHOD.
END METHOD ViewData. 
END OBJECT.
END CLASS Tester-cls.