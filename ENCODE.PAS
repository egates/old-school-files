PROCEDURE MyProgram;
    {This program encodes text as specified in the homework}
    {Created by: Eric Gates  6/6/89}
    {HW #1, Part 2}

VAR S,Word,PrevWord: String;
    Pos,PrevPos: integer;
(*************************************************************************)

   FUNCTION CountLetters(Wd: String): integer;
       {Counts only the letters in a word leaves out punctuation}

   VAR LetterCount,Counter: integer;

   BEGIN  {CountLetter}
      CountLetters := 0;
      FOR Counter := 1 TO Length(Wd) DO
          IF IsLetter(Wd[Counter])
          THEN LetterCount := LetterCount + 1;
      CountLetters := LetterCount;
   END;  {CounterLetters}
(*************************************************************************)

   PROCEDURE UpperToLower(var Word: String);
       {This converts uppercase letters to lower case}

   VAR Counter: integer;

   BEGIN  {UpperToLower}
      FOR Counter := 1 TO Length(Word) DO
          IF IsLetter(Word[Counter])
          THEN IF IsUpper(Word[Counter])
               THEN Word[Counter] := ToUpper(Word[Counter]);
   END;  {UpperToLower}
(*************************************************************************)

   PROCEDURE ReplaceLetter(var Letter: character;
                               SN: integer);
           {Replaces the current letter with the letter defines by the
            Shift Number}

   BEGIN  {ReplaceLetter}
      IF Letter + SN <= LETZ
      THEN Letter := Letter + SN
      ELSE Letter := (SN - (LETZ - Letter) + LETA - 1);
   END;  {ReplaceLetter}
(*************************************************************************)

   PROCEDURE ShiftLetters(var PrevWord,Word: String);
       {Determines Shift Number and calls ReplaceLetter to replace each
        letter}

   VAR ShiftNumber,Counter: integer;

   BEGIN  {ShiftLetter}
      ShiftNumber := (CountLetters(PrevWord) + CountLetters(Word)) MOD 26;
      FOR Counter := 1 TO Length(Word) DO
         IF IsLetter(Word[Counter])
         THEN ReplaceLetter(Word[Counter],ShiftNumber);
   END;  {ShiftLetter}
(*************************************************************************)

   PROCEDURE ReplaceWord(var Word,Str: String;
                             Pos,PrevPos: integer);
           {Replaces the word in the string with its encoded word}

   VAR Counter: integer;

   BEGIN  {ReplaceWord}
      FOR Counter := PrevPos TO Pos DO
         IF Word[Counter - PrevPos + 1] <> ENDSTR
         THEN Str[Counter] := Word[Counter - PrevPos + 1]
         ELSE Str[Counter] := BLANK;
   END;  {ReplaceWord}
(*************************************************************************)

BEGIN  {MyProgram}
   Message('Text Encoder -- Eric Gates - ALDER    6/6/89');
   Init(Word);
   Init(PrevWord);
   Init(S);
   WHILE GetLine(S,STDIN,MAXSTR) DO
      BEGIN  {WHILE}
         Pos := 1;
         PrevPos := 1;
         REPEAT
            Pos := GetWord(S,Pos,Word);
            UpperToLower(Word);
            ShiftLetters(PrevWord,Word);
            ReplaceWord(Word,S,Pos,PrevPos);
            PrevPos := Pos;
            For Counter := 1 TO MAXSTR DO
                PrevWord[Counter] := Word[Counter];
         UNTIL (Pos = 0);
   PutStr(S,STDOUT);
END;  {MyProgram}







