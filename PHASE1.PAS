PROGRAM Phase1 (Infile,Outfile,input,output);
    {Reads a text file of the users choice and writes it to a print file
     with all lines within the user set line length - no split words, no
     hyphens)

TYPE Line = Packed Array[1..80] of char;
     Filename = Packed Array[1..12] of char;

VAR OutBuffer,Word: Line;
    WordLength,LineLength,OutLength: integer;
    Ch,Spacing: char;
    File1,File2: Filename;
    InFile,OutFile: text;

%INCLUDE 'GetPut.Pas'
(*************************************************************************(

   PROCEDURE Init(var InFile,OutFile: text;
                      File1,File2: Filename);
        {Opens the Files requested by user as InFile and OutFile and puts
         them in the proper mode}

   BEGIN  {Init}
      OPEN(InFile,File1,History:=Old);
      RESET(InFile);
      OPEN(OutFile,File2,History:=Old);
      REWRITE(OutFile);
   END;  {Init}
(*************************************************************************)

   PROCEDURE GetInfo(var File1,File2: Filename;
                     var LineLength,Spacing: integer);
          {Asks user to enter the input and output files, line lenght (60
           or 70) and spacing (1 for single, 2 for double)}

   BEGIN   {GetInfo}
      Writeln('Input file ? ');
      Readln(File1);
      Writeln('Output File ?);
      Readln(File2);
      Writeln('Maximum Line Length - 60 or 70 ?');
      Readln(LineLength);
      Writeln('Spacing - 1 for Single, 2 for Double');
      Readln(Spacing);
   END;  {GetInfo}
(*************************************************************************)

   PROCEDURE GetLine(var InFile: Text;
                     var OutBuffer: Line;
                     var Ch; char;
                         LineLength: integer);
            {Reads from the file and builds the line until is reaches line
             Length)

   VAR WordLength,Counter: integer;
       Word: Line;

   BEGIN  {GetLine}
      Clear(OutBuffer);
      Clear(Word);
      Word[1] := Ch;
      OutBuffer[1] := Ch;
      LineSize := 0;
      WHILE (LineSize <= LineLength) AND (Ch <> ENDFILE) DO
         BEGIN  {While}
            WordLength := 0;
            Clear(Word);
            REPEAT
               WordLength := WordLength + 1;
               Getcf(InFile,Ch);
               Word[WordLength] := Ch;
            UNTIL (Ch = Blank) OR (Ch = ENDFILE);
            IF (WordLength + LineSize) < LineLength
            THEN FOR Counter := (LineSize + 2) TO (LineSize + WordLength) DO
                    BEGIN  {FOR}
                       OutBuffer[Counter] := Word[Counter];
                       LineSize := Counter;
                    END;  {FOR}
         END;  {WHILE
      Writeln(OutBuffer);

END;  {GetLine}
(*************************************************************************)
 BEGIN  {Phase1}

 Initio;
 GetInfo(File1,File2,LineLength,Spacing);
 Init(InFile,OutFile,File1,File2);
 GetLine(InFile,OutBuffer,Ch,LineLength);
 END.  {Phase1}







