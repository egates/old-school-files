PROGRAM GetLine (input,output,File2);
    {Returns the requested line from the file File2.Dat}

VAR File2: file;
    filename: text;
    Line: integer;
(**************************************************************************)

   PROCEDURE GetTheLine(var File2: file;Line: integer);
       {Writes out requested line of file}

   VAR Counter: integer;
       Ch: char;

   BEGIN  {Get}
      Counter := 1;
      WHILE (ch <> '#') DO
         BEGIN  {While}
            IF (Counter = Line)
            THEN BEGIN  {IF-THEN}
                    WHILE NOT Eoln(filename) DO
                        BEGIN  {Nested While}
                           Read(Filename,Ch);
                           Write(Ch);
                        END;  {Nested While}
                    Writeln;
                 END;  {IF-THEN}
            Counter := Counter + 1;
            Readln(Filename);
         END;  {While}
   END;  {Get}
(*****************************  MAIN  ***********************************)

BEGIN  {GetLine}
   assign(file2,'file2.dat');
   assign(filename,'file2.dat');
   reset(filename);
   Reset(File2);
   Writeln('Enter Line Number Desired');
   Readln(Line);
   GetTheLine(File2,Line);
END.  {GetLine}
