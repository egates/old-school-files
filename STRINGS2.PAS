copy stringpack.pas stringpack.old
del stringpack.pas;*
edit stringpack.pas
c
TYPE StopperType = SET OF Character;

FUNCTION GetString(VAR S:        String;
                       Stoppers: Stoppertype;
                       F:        Filedesc): boolean;

    {Gets a string from file F until a stopper is reached. Returns
     True if a string/stopper combination is encountered. Returns
     False if no stopper is encountered before maxstr 256 or ENDFILE}

VAR I,I2: Integer;
    C: Character;
    Junk: String;

BEGIN  {GetString}
   I:=1;
   S[I] := Getcf(C,F);
   IF (S[I] IN Stoppers) OR (S[I] = ENDFILE)
   THEN BEGIN  {IF}
           S[1] := ENDSTR;
           GetString := False;
        END  {if}
   ELSE BEGIN   {ELSE}
           REPEAT
              I := I + 1;
              S[I] := Getcf(c,f)
           UNTIL (S[I] IN Stoppers) OR (I = MAXSTR) OR (S[I] = ENDFILE);
           IF I = MAXSTR
           THEN BEGIN   {IF}
                   I2 := 1;
                   REPEAT
                      Junk[I2] := Getcf(c,f);
                      I2 := I2+1;
                   UNTIL (Junk[I2] IN Stoppers) OR (I2 = MAXSTR)
                         OR (Junk[I2] = ENDFILE);
                END;  {IF}
            S[I] := ENDSTR;
            GetString := True;
            IF S[I] = ENDFILE
            THEN BEGIN
                    S[1] := ENDSTR;
                    GetString := False;
                 END;  {if}
        END;  {IF-ELSE}
END;  {Getstring}
(*********************************************************************)

PROCEDURE Print (VAR S: String;
                     F: Filedesc);
    {Puts contents of S out to file F}

VAR Counter: integer;

BEGIN  {PRINT}
   Counter := 1;
   WHILE S[Counter] <> ENDSTR DO
     BEGIN   {WHILE}
        Putcf(S[Counter],F);
        Counter := Counter + 1;
     END;   {WHILE}
END;  {PRINT}
(********************************************************************)

(*FUNCTION Length (VAR S: String): integer;*)
   {returns number of significant characters in S (not ENDSTR)}
   {code is in IOMOD.PAS}
(********************************************************************)

FUNCTION Concat(var S,T:String): Boolean;
   {puts T on the end of S if it fits}

VAR SCounter,TCounter: Integer;

BEGIN {Concat}
   IF Length(S)+Lenght(T) <= MAXSTR - 1
   THEN BEGIN {IF}
           TCounter := 1;
           SCounter := Length(S) + 1;
           WHILE T[Counter] <> ENDSTR DO
              BEGIN  {WHILE}
                 S[SCounter] := T[TCounter]
                 TCounter := TCounter + 1;
                 SCounter := Scounter + 1;
              END;  {WHILE}
           S[SCounter] := ENDSTR;
           Concat := True;
        END  {IF}
   ELSE Concat := False;
END;  {Concat}
(*********************************************************************)
function insert(var s,t:string; spos: integer): boolean;
begin
   insert := false;
end;
function delete(var s: string;spos,num: integer):boolean;
begin
   delete := false;
end;
function substring(var s,sub:string;spos,num:integer):boolean;
begin
    substring := false;
end;
function search(var s,pat:string;spos: integer):integer;
begin
   search := 1;
end;
 function append(c:character;var s: string) : boolean;
begin
   append := false;
end;
function compare(var s,t: string) : character;
begin
   compare := EQUALs;
end;


$

$
