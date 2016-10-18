IDENTIFICATION DIVISION.
PROGRAM-ID. Listing13-7.
AUTHOR. Michael Coughlan.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
       SELECT DocWordsFile ASSIGN TO "Listing13-7.DAT"
                 ORGANIZATION IS LINE SEQUENTIAL.
                 
DATA DIVISION. 
FILE SECTION.
FD DocWordsFile.
01 WordIn               PIC X(20).
   88 EndOfDocWordsFile VALUE HIGH-VALUES.

WORKING-STORAGE SECTION.
01 WordFreqTable.
   02 Word OCCURS 0 TO 2000 TIMES 
              DEPENDING ON NumberOfWords
              INDEXED BY Widx.
      03 WordFound    PIC X(20).
      03 WordFreq     PIC 9(3).
      
01 TopTenTable.
   02 WordTT  OCCURS 11 TIMES 
               INDEXED BY TTidx.
      03 WordFoundTT  PIC X(20) VALUE SPACES.
      03 WordFreqTT   PIC 9(3)  VALUE ZEROS. 

01 NumberOfWords       PIC 9(4) VALUE ZERO.

01 ReportHeader        PIC X(27) VALUE "  Top Ten Words In Document".

01 SubjectHeader       PIC X(29) VALUE "Pos   Occurs    Document Word".

01 DetailLine.
   02 PrnPos           PIC Z9.
   02 FILLER           PIC X VALUE ".".
   02 PrnFreq          PIC BBBBBZZ9.
   02 PrnWord          PIC BBBBBX(20).

01 Pos                 PIC 99.

PROCEDURE DIVISION.
Begin.
    OPEN INPUT DocWordsFile
    READ DocWordsFile
       AT END SET EndOfDocWordsFile TO TRUE
    END-READ
    PERFORM LoadWordFreqTable UNTIL EndOfDocWordsFile
    PERFORM FindTopTenWords 
            VARYING Widx FROM 1 BY 1 UNTIL Widx > NumberOfWords
    PERFORM DisplayTopTenWords
    CLOSE DocWordsFile
    STOP RUN.
    
LoadWordFreqTable.
* The AT END triggers when Widx is one greater than the current size of the 
* table so all we have to do is extend the table and write into the new table
* element
    SET Widx TO 1
    SEARCH Word
       AT END ADD 1 TO NumberOfWords
              MOVE 1 TO WordFreq(Widx)
              MOVE FUNCTION LOWER-CASE(WordIn) TO WordFound(Widx)
       WHEN   FUNCTION LOWER-CASE(WordIn) = WordFound(Widx)
              ADD 1 TO WordFreq(Widx)
    END-SEARCH
    READ DocWordsFile
       AT END SET EndOfDocWordsFile TO TRUE
    END-READ.             
    
FindTopTenWords.
   PERFORM VARYING TTidx FROM 10 BY -1 UNTIL TTidx < 1
      IF WordFreq(Widx) > WordFreqTT(TTidx)
         MOVE WordTT(TTidx) TO WordTT(TTidx + 1)
         MOVE Word(Widx) TO WordTT(TTidx)
      END-IF
   END-PERFORM.

DisplayTopTenWords.
   DISPLAY ReportHeader
   DISPLAY SubjectHeader
   PERFORM  VARYING TTidx FROM 1 BY 1 UNTIL TTIdx > 10
      SET Pos TO TTidx
      MOVE Pos TO PrnPos
      MOVE WordFoundTT(TTidx) TO PrnWord
      MOVE WordFreqTT(TTidx) TO PrnFreq
      DISPLAY DetailLine      
   END-PERFORM

