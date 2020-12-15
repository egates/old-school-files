EDIT GETTOKTEST.PAS
C
PROCEDURE MyProgram;
    {This procedure is to test GetTok.  It will get the tokens and
     write them to STDOUT}

VAR Token: String;

%INCLUDE 'umb$disk2:[math.cs210]gbfpbf.pas'
(*************************************************************************)

   FUNCTION GetTok(var Token: String): Character;
      {This function returns as it's value the first character of the
       token string and returns the complete string as Token.}

   VAR Counter: integer;
       C: Character;
       TokenCollected: Boolean;

   BEGIN  {GetTok}
      Counter := 1;
      TokenCollected := False;
      REPEAT
         Token[Counter] := GetPbcf(C,STDIN);
         CASE Token[Counter] OF
            BLANK: Token[Counter] := Getpbcf(C,STDIN);
            1,2,3,4,5,6,7,8,9: BEGIN  {CASE CONDITION}
                                  WHILE getpbcf(C,STDIN) <> BLANK DO
                                     BEGIN   {WHILE}
                                        Counter := Counter + 1;
                                        Token[Counter] := C;
                                     END;  {WHILE}
                                  TokenCollected := True;
                               END;  {CASE CONDTION}
            '!': BEGIN  {CASE CONDTION}
                    WHILE getpbcf(C,STDIN) <> NEWLINE DO
                       BEGIN  {WHILE}
                          Counter := Counter + 1;
                          Token[Counter] := C;
                       END;  {While}
                    TokenCollected := True;
                 END;  {CASE CONDITION}
           '~','#','+','-','*','/','^','=','R','A','Q':
                             TokenCollected := True;
         END;  {CASE}
      UNTIL TokenCollected;
      Token[Counter + 1] := ENDSTR;
      GetTok := Token[1];
   END;  {GetTok}
(*************************  MAIN  ****************************************)

BEGIN  {MAIN}
   Initio;
   Message('GetTok TEST  --  ERIC GATES  --  6/15/89');
   Initpbf(STDIN)
   WHILE GetTok(Token) <> 'Q' DO
      BEGIN  {WHILE}
         Write('->');
         PutStr(Token,STDOUT);
         Writeln('<-');
      END;  {WHILE}
END;  {MAIN}





