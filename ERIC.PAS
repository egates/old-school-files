PROGRAM TEST (INPUT,OUTPUT);
    {THIS IS A TEST}

CONST ZERO='0';

VAR  CHARJUNK: CHAR;

procedure getnum (var charjunk: char);

BEGIN
   WRITELN('ENTER THE NUMBER');
   READLN(CHARJUNK);
end;

procedure printans(charjunk: char);
var junk: integer;

begin
   JUNK:=(ORD(CHARJUNK)-(ORD(ZERO))) * 100;
   WRITELN ('THIS IS THE NUMBER TIMES 100',JUNK:6);
end;
begin
getnum(charjunk);
printans(charjunk);

END.

