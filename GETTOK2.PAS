%include 'umb$disk2:[math.cs210]gbfpbf.pas'

(*************************************************************************)

   FUNCTION IsReal(C: character): boolean;
     {Returns true if the number is a int or contains a period}

   BEGIN   {IsReal}
      IsReal := IsDigit(C) OR (C = PERIOD);
   END;   {IsReal}
(*************************************************************************)

   FUNCTION IsOperator(C: character): boolean;
       {Checks to see if character is an operator}

   BEGIN  {IsOperator}
      IsOperator := C in [ENDFILE,STAR..SLASH,
                          CARET,RPAREN,LPAREN,PLUS,RBRACE,LBRACE]
   END;  {IsOperator}
(***********************************************************************)

   FUNCTION IsVar(C:character): boolean;
      {Checks to see if token is a legal pascal variable}

   BEGIN {IsVar}
      IsVar := IsAlphanum(C) OR C = UNDERLINE;
   END;  {IsVar}
(***********************************************************************)

   FUNCTION IsComment(C: Character): boolean;
       {Checks for LBRACE OR LPAREN+STAR}

   VAR C1: Character;

   BEGIN  {IsComment}
      IsComment := (C = LBRACE) OR (C = LPAREN AND
                                   Getpbcf(C1,STDIN) = STAR);
      PutBackf(C1,STDIN);
   END;  {IsComment
(***********************************************************************)

   FUNCTION EndComment(C: Character): Boolean;
      {Checks for RBRACE or STAR+RPAREN}

   VAR C1: Character;

   BEGIN   {EndComment}
      EndComment := (C = RBRACE) OR (C = STAR AND
                                   Getpbcf(C1,STDIN) = RPAREN);
      PutBackf(C1,STDIN);
   END;  {EndComment
(*************************************************************************)
   FUNCTION GetTok(var Token: string): character;
      {This function returns as it's value the first character of the
       Token string and return the complete string as Token}

   VAR Counter: integer;
       C: character;
       TokenCollected: boolean;

   BEGIN   {GetTok}
      Counter := 1;
      TokenCollected := False;
      Token[Counter] := Getpbcf(C,STDIN);
      REPEAT
         IF NOT IsReal(Token[Counter]) THEN
            IF NOT IsOperator(Token[Counter]) AND NOT IsVar(Token[Counter])
            THEN
               Token[Counter] := Getpbcf(C,STDIN)
            ELSE
               IF IsVar(Token[Counter])
               THEN BEGIN
                       WHILE IsVar(Getpbcf(C,STDIN)) DO
                         BEGIN
                           Counter := Counter + 1;
                           Token[Counter] := C;
                         END;
                         TokenCollected := True;
                         PutBackf(C,STDIN);
                    END
               ELSE IF IsComment(Token[Counter])
                    THEN BEGIN
                           WHILE NOT EndComment(Getpbcf(C,STDIN) DO
                             BEGIN
                               Counter := Counter + 1;
                               Token[Counter] := C;
                             END;
                             TokenCollected := True;
                         END
                    ELSE TokenCollected := True
         ELSE BEGIN  {SECOND IF-THEN-ELSE}
                 WHILE IsReal(Getpbcf(C,STDIN)) DO
                   BEGIN  {WHILE}
                      Counter := Counter + 1;
                      Token[Counter] := C;
                   END;  {WHILE}
                 TokenCollected := True;
                 Putbackf(C,STDIN);
              END;   {else}
      UNTIL TokenCollected;
      Token[Counter + 1] := ENDSTR;
      GetTok := Token[1];
   END;   {GetTok}

