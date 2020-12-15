edit censor.pas
c
PROCEDURE MyProgram;
    (* Reads from STDIN writes to STDOUT *)
    (* Changes a four letter word to ****  *)
    (* Takes entire line from input then checks each word to see if it is four
       letters long or contains only four letters.  It then converts the word
       in the line to **** and writes the entire line when all are censored.
       It does not change the Word string.  Some seemingly strange formulas
       were used for array subscripts to accomplish this.  But, they get they
       job done. *)

VAR Line,Word: String;
    Pos: integer;
(*****************************************************************************)

   FUNCTION ItIsFour(var Wd: String): boolean;
      (* Checks to see if it is actually a four letter word *)
      (* Will ignore punctuation, hypens, etc *)

   VAR Counter,Letters: integer;

   BEGIN  {ItIsFour}
      Letters := 0;
      FOR Counter := 1 TO Length(Wd) DO
        IF Wd[Counter] IN [UCLETA..LETZ]
        THEN Letters := Letters + 1;
      IF Letters = 4
      THEN ItIsFour := True
      ELSE ItIsFour := False;
   END;  {ItIsFour}
(******************************************************************************)

   PROCEDURE Censor(var Wd,Line: string;
                        Pos: integer);
       (* Changes alpha characters to * for four letter words *)

   VAR Counter: integer;

   BEGIN {Censor}
      FOR Counter := (Pos - Length(Wd)) TO Pos DO
          IF Wd[(Counter - Pos + Length(Wd) + 1)] IN [UCLETA..LETZ]
          THEN Line[Counter] := STAR;
   END;  {Censor}
(****************************  MAIN  ******************************************)

BEGIN    {MyProgram}
   Message('Eric Gates: EMPTY   Homework #1 Part 1');
   Message('This program changes four letter words from STDIN to ****');
   Message('Enter your text - press CTRL-Z when done');
   WHILE GetLine(Line,STDIN,MAXSTR) DO
     BEGIN  {WHILE}
        Pos := 1;
        REPEAT
          Pos := GetWord(Line,Pos,Word);
          IF ItIsFour(Word)
          THEN Censor(Word,Line,Pos)
        UNTIL (Pos = 0);
        Putstr(Line,STDOUT);
     END;  {WHILE}
END;   {MyProgram}

