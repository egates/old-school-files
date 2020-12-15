PROCEDURE MyProgram;
     {This program will count paragraphs}
     {Created by: Eric Gates 6/6/89}
     {HW #1, Part 1}

VAR CurrLine,PrevLine: String;
    ParCount: integer;
(*************************************************************************)

   FUNCTION IsItBlank(S: String): boolean;
       {Checks to see if a line is blank}

   VAR Counter: integer;
       Stop: character;

   BEGIN  {IsItBlank}
      Counter := 1;
      REPEAT
         IF S[Counter] NOT IN [BLANK,TAB,BELL,BACKSPACE]
         THEN BEGIN  {IF-THEN}
                 Stop := 'Y';
                 IsItBlank := False;
              END  {IF-THEN]
         ELSE IsItBlank := True;
         Counter := Counter + 1;
      UNTIL  (Stop = 'Y') OR (Counter >= Length(S))
   END;  {IsItBlank}
(*************************************************************************)

   PROCEDURE Init(var S: String);
       {Initializes strings to blanks}

   VAR Counter: integer;

   BEGIN  {Init}
      FOR Counter := 1 TO MAXSTR DO
          S[Counter] := BLANK;
   END;  {Init}
(*************************************************************************)

   PROCEDURE CountParagraphs(var PrevLine,Currline: string;
                             var ParCount: integer);
          {Counts the paragraphs}

   VAR Counter: integer;

   BEGIN  {CountParagraphs}
      ParCount := 0;
      WHILE GetLine(CurrentLine,STDIN,MAXSTR) DO
         BEGIN  {WHILE}
            IF IsItBlank(CurrLine) AND (NOT IsItBlank(PrevLine))
            THEN ParCount := ParCount + 1;
            Init(PrevLine);
            FOR Counter := 1 TO Length(CurrLine) DO
                PrevLine[Counter] := CurrLine[Counter]
            Init(CurrLine);
         END;  {WHILE}
      IF NOT IsItBlank(PrevLine)
      THEN ParCount := ParCount + 1;
   END;  {CountParagraphs}
(*************************************************************************)

BEGIN  {MyProgram}
   Message('Paragraph Counter by Eric Gates -- ALDER.  6/6/89');
   ParCount := 0;
   Init(CurrLine);
   Init(PrevLine);
   CountParagraphs(PrevLine,CurrLine,ParCount);
   Putcf(ParCount,STDOUT);
END;  {MyProgram}




