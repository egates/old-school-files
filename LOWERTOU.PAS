PROGRAM LowerToUpperCase(Infile,Outfile,output);
    {takes text from Infile.dat in lower case and writes it to
     Outfile.Dat in uppercase}

VAR InFile,OutFile: Text;
    LineCounter: integer;
(**************************************************************************)

   PROCEDURE TurnToUpperCase(var Ch: char);
       {Changes small case letters to upper case}

   BEGIN  {TurnToUpperCase}
      IF (ORD(Ch) >= ORD('a')) AND (ORD(Ch) <= ORD('z'))
      THEN  Ch := CHR(ORD(Ch) - 11)
   END;  {TurnToUpperCase}
(**************************************************************************)

   PROCEDURE ProcessFile(var InFile,Outfile: text;
                         var LineCounter: integer);
       {Reads thru InFile.Dat, pass characters to TurnToUpperCase,
        then writes to Outfile.Dat}

   VAR Ch: char;

   BEGIN  {ProcessFile}
      LineCounter := 0;
      Reset(InFile);
      Rewrite(OutFile);
      WHILE NOT Eof(InFile) DO
         BEGIN  {While}
            WHILE NOT Eoln(InFile) DO
               BEGIN  {Nested While}
                  Ch := InFile^;
                  TurnToUpperCase(Ch);
                  Write(OutFile,Ch);
                  GET(InFile);
               END;  {Nested While}
            Writeln(OutFile);
            Readln(InFile);
            LineCounter := LineCounter + 1;
         END;  {While}
   END;  {ProcessFile}
(**************************************************************************)

   PROCEDURE ReportLineCount(LineCounter);
       {Reports number of lines in file}

   BEGIN  {Report}
      Writeln;
      Writeln('Total number of lines written: ':LineCounter:1);
   END;   {Report}
(******************************  MAIN  ************************************)

BEGIN  {LowerToUpperCase}
   ProcessFile(Infile,OutFile,LineCounter);
   ReportLineCount(LineCounter);
END.  {LowerToUpperCase}







