program LANDPRT;
uses
   Printer,Crt;

var
   C : string[1];

Procedure Frame(x1,y1,x2,y2: byte);
Var
   I: Integer;
begin
     GoToXY(x1,y1);
     Write(chr(218));
     For I := x1+1 to x2-1 do
         Write(chr(196));
     Write(chr(191));
     For I := y1+1 to y2-1 do
         begin
              GoToXY(x1,I);
              Write(chr(179));
              GoToXY(x2,I);
              Write(chr(179));
         end;
     GoToXY(x1,y2);
     Write(chr(192));
     For I := x1+1 to x2-1 do
         Write(chr(196));
     Write(chr(217));
     end;



Procedure MenuOp;
  begin
    ClrScr;
    Frame(2,1,77,3);
    Frame(8,23,72,25);
    Frame(13,6,69,20);
    Window(3,2,76,2);
    TextBackground(1);
    TextColor(4);
    ClrScr;
    Write('HP LaserJet Printer Utility, Version 3.1, (C) Copyright 1988, James Moran');
    Window(9,24,71,24);
    TextBackground(1);
    TextColor(4);
    ClrScr;
    Write('PLEASE NOTE:  Some print formats may require a font cartridge.');
    Window(14,7,68,19);
    TextBackground(4);
    TextColor(1);
    ClrScr;
    GoToXY(1,1);
    Write(' Choose the desired print format by pressing a number: ');
    GoToXY(1,3);
    Write(' 1) Landscape/Compressed Print, 45 lines per page');
    GoToXY(1,4);
    Write(' 2) Landscape/Compressed Print, 66 lines per page');
    GoToXY(1,5);
    Write(' 3) Landscape/Normal Print, 45 lines per page');
    GoToXY(1,6);
    Write(' 4) Landscape/Normal Print, 66 lines per page');
    GoToXY(1,7);
    Write(' 5) Portrait/Compressed Print, 60 lines per page');
    GoToXY(1,8);
    Write(' 6) Portrait/Compressed Print, 89 lines per page');
    GoToXY(1,9);
    Write(' 7) Portrait/Normal Print, 66 lines per page');
    GoToXY(1,10);
    Write(' 8) Portrait/Normal Print, 60 lines per page (normal)');
    GoToXY(1,11);
    Write(' 9) Portrait/Normal Print, 4  lines per inch (screen) ');
    GoToXY(1,12);
    Write(' 0) Portrait/Compressed Print, 66 lines per page');
    GoToXY(55,1);
    C:=ReadKey;
   end;

Procedure MessageWin;
begin
    Window(14,4,68,4);
    TextBackground(Cyan);
    TextColor(LightBlue);
    ClrScr;
end;

Procedure ProcessChoice;
begin
 case C[1] of
      '1'      : begin
                 ClrScr;
                 Write ('Printer set to Landscape/Compressed, 45 lines per page');
                 Writeln (Lst, Chr(27),'E',Chr(27),'&l1O',Chr(27),'&k2S');
                 end;

      '2'      : begin
                 ClrScr;
                 Write ('Printer set to Landscape/Compressed, 66 lines per page');
                 Writeln (Lst, Chr(27),'E',Chr(27),'&l1o2e5.647c66F',Chr(27),'&k2S');
                 end;

      '3'      : begin
                 ClrScr;
                 Write ('  Printer set to Landscape/Normal, 45 lines per page');
                 Writeln (Lst, Chr(27),'E',Chr(27),'&l1O');
                 end;

      '4'      : begin
                 ClrScr;
                 Write ('  Printer set to Landscape/Normal, 66 lines per page');
                 Writeln (Lst, Chr(27),'E',Chr(27),'&l1o2e5.647c66F');
                 end;

      '5'      : begin
                 ClrScr;
                 Write (' Printer set to Portrait/Compressed, 60 lines per page');
                 Writeln (Lst, Chr(27),'E',Chr(27),'&k2S');
                 end;

      '6'      : begin
                 ClrScr;
                 Write (' Printer set to Portrait/Compressed, 89 lines per page');
                 Writeln (Lst, Chr(27),'E',Chr(27),'&l2e5.647c89F',Chr(27),'&k2S');
                 end;

      '7'      : begin
                 ClrScr;
                 Write ('   Printer set to Portrait/Normal, 66 lines per page');
                 Writeln (Lst, Chr(27),'E',Chr(27),'&l14c1e7.64c66F');
                 end;

      '8'      : begin
                 ClrScr;
                 Write ('  Printer set to Portrait/Normal, 60 lines per page');
                 Writeln (Lst, Chr(27),'E');
                 end;
      '9'      : begin
                 ClrScr;
                 Write ('  Printer set to Portrait/Normal, 4  lines per INCH');
                 Writeln (Lst, Chr(27),'E',Chr(27),'&l4D');
                 end;
      '0'      : begin
                 ClrScr;
                 Write (' Printer set to Portrait/Compressed, 66 lines per page');
                 Writeln (Lst, Chr(27),'E',Chr(27),'&l14c1e7.64c66F',Chr(27),'&k2S');
                 end;
    else
        Write ('        Printer settings have not been changed      ');
    end;
  Window(1,5,80,25);
  TextBackground(Black);
  TextColor(LightGray);
  ClrScr
end;

begin {Main Program Body}
If ParamCount > 0 then
 C := ParamStr(1)
  else
    MenuOp;
MessageWin;
ProcessChoice;

end.
