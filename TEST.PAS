procedure myprogram;
const hi_sentinel = 100;
      lo_sentinel = 1;

type key_type = Integer;
     valueType = packed array [1..20] of char;

%include 'table1.pas'

VAR Key1: Key_Type;
    Val1: Value_type;
    Table1: Table_Type;
    a,b,c: boolean;

begin
  create(Table1);
  printkeys(Table1);
  writeln('should be eot');
  a := insert(10,'eric',table1);
  a := insert(20,'todd',table1);
  a := insert(30,'gates',table1);
  printkeys(table1);
  b := delete(20,table1);
  printkeys(table1);
  b := insert(20,'and',table1);
  b := insert(30,'melissa',table1);
  printkeys(table1);
  retrive(30,val1,table1);
  writeln(val1);
end;
