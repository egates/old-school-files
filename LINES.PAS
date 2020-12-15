PROGRAM Lines (input,output);
      {reads line of input from keyboard and determines number of words
       and number of sentances}

VAR Numword,Sentances: integer;
    Ch,CurrCh: char;
(***************************************************************************)

   PROCEDURE Init(var Ch,CurrCh: char;
                  var NumWord,Sentances: integer);
        {reads first character and initializes variables}

   BEGIN  {Init}
      Numword:=0;
      Sentances:=0;
      READ(Ch);
      Currch:=Ch;
   END;  {Init}
(***************************************************************************)

   PROCEDURE CountWordsAndLines(var Sentances,NumWords:integer;
                                    Ch,CurrCh: char);
         {Counts the words and sentances}
   CONST Blank = ' ';
         Period = '.';

   VAR PrevCh: char;

   BEGIN  {Count}
     WHILE NOT EOF DO
        BEGIN
            WHILE NOT EOLN DO
              BEGIN
                 PrevCh:=CurrCh;
                 READ(Ch);
                 CurrCh:=Ch;

                 IF ((PrevCh <> Blank) AND (CurrCh = Blank))
                 THEN NumWord:=NumWord+1;

                 IF (Currch = Period) AND (PrevCh <> Blank)
                 THEN Sentances:=Sentances+1;

                 IF (PrevCh = Period) AND (CurrCh <> Blank)
                 THEN BEGIN {IF}
                       WRITELN ('ERROR ON LINE #',SENTANCES:1);
                       WRITE ('PERIOD NOT CONSIDERED END OF SENTANCE ');
                       WRITELN ('OR END OF WORD, IN THIS CASE.  ');
                       WRITELN ('YOU WOULD HAVE TO PUT A SPACE AFTER PERIOD');
                       SENTANCES:=SENTANCES-1;
                      END; {IF}
              END; {INNER WHILE}
        READLN;
        END; {OUTER WHILE}
   END; {Count}
(****************************************************************************)

   PROCEDURE Report(Sentances,Numwords: integer);
       {Reports numbers of sentances and number of words}

   BEGIN  {Report}
      WRITELN('SENTANCES: ',Sentances);
      WRITELN('WORDS: ',NumWord);
   END; {Report}
(*********************************  MAIN  ***********************************)

BEGIN  {LINES}
   Init(Ch,CurrCh,NumWord,Sentances);
   CountWordsAndLines(Sentances,NumWord,Ch,CurrCh);
   Report(Sentances,NumWord);
END.  {LINES}
