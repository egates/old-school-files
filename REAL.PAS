PROGRAM MyProgram;
  {RPN CALCULATOR}

%include 'umb$disk2:[math.cs210]stackpack1.pas'

TYPE StackEltType = Character;

VAR Token: String;
    Stack: StackType;

(**************************************************************************)

   FUNCTION CToR(var Token: String): Real;
     {Converts character string to real number}

   VAR Counter,IntNum : Integer;
       Number,DecCount: Real;

   BEGIN  {CTOR}
      Counter := 1;
      IF (Token[1] = PERIOD)
      THEN Error('Invalid Real')
      ELSE BEGIN  {ELSE}
              IntNum := CTOI(Token[Counter]);
              Counter := Counter + 1;
              REPEAT
                 IntNum := CTOI(Token[Counter])+Number*10;
                 Counter := Counter + 1;
              UNTIL (Token[Counter] IN [ENDSTR,PERIOD]);
              IF (Token[Counter] = ENDSTR)
              THEN Number := IntNum * 1.0
              ELSE IF (Token[Counter+1] = ENDSTR)
                   THEN Error('Invalid Real')
                   ELSE BEGIN  {2nd ELSE}
                           Counter := Counter + 1;
                           Number := IntNum * 1.0;
                           DecCount := 0.1;
                           REPEAT
                              Number := CTOI(Token[Counter])*DecCount+Number;
                              Counter := Counter + 1;
                              DecCount := DecCount/10.0;
                           UNTIL (Token[Counter] = ENDSTR);
                        END; {2nd ELSE}
           END;  {ELSE}
      CTOR := Number;
   END;  {CTOR}
(*******************************************************************)






