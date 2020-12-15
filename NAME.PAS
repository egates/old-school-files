PROGRAM ReverseName (input,output);
    {Takes a name and reverses it   i.e.  John H. Doe --> Doe, J. H.}

CONST Blank = ' ';

TYPE Name = PACKED ARRAY[1..20] OF char;

VAR WholeName: Name;
(**************************************************************************)

   FUNCTION FirstNonBlank(WholeName: Name;
                        Position: integer): integer;
        {Look though name backwards to find first non blank character}

   BEGIN  {1stNonBlank}
      REPEAT
         Position := Position - 1;
         FirstNonBlank := Position;
      UNTIL (WholeName[Position] <> Blank);
    END;  {1stNonBlank}
 (************************************************************************)

   FUNCTION FirstBlank(WholeName: Name;
                     Position: integer): integer;
        {Look through name backwards to find first blank character}

   BEGIN  {1stBlank}
      REPEAT
         Position := Position - 1;
         FirstBlank := Position;
         {Position := Position - 1;}
      UNTIL (WholeName[Position] = Blank);
   END;  {1stBlank}
(**************************************************************************)

   PROCEDURE Initialize(var WholeName: Name);
         {Initializes name to blanks}

   VAR Counter: integer;

   BEGIN  {Init}
      FOR Counter := 1 TO 20 DO
          WholeName[Counter] := Blank;
   END;  {Init}
(**************************************************************************)

   PROCEDURE ReadName(var WholeName: Name);
       {Reads in name}

   VAR Counter: integer;

   BEGIN  {ReadName}
      Counter := 0;
      Writeln('Enter name i.e. ERIC T GATES  ');
      WHILE (NOT EOLN) DO
         BEGIN  {While}
            Counter := Counter + 1;
            Read(WholeName[Counter]);
         END;  {Counter}
   END;  {ReadName}
(**************************************************************************)

   PROCEDURE WriteName(WholeName: Name);
       {Writes out the name in the correct format}

   VAR FirstBlankPosition,FirstNonBlankPosition,SecondBlankPosition: integer;
       Counter: integer;

   BEGIN  {WriteName}
      FirstNonBlankPosition := FirstNonBlank(WholeName,21);
      FirstBlankPosition := FirstBlank(WholeName,FirstNonBlankPosition);
      FOR Counter := (FirstBlankPosition + 1) TO FirstNonBlankPosition  DO
          Write(WholeName[Counter]);
      Write(', ');
      SecondBlankPosition := FirstBlank(WholeName,FirstBlankPosition);
      Write(WholeName[1],'. ');
      Writeln(WholeName[SecondBlankPosition + 1],'.');
   END;  {WriteName}
(*********************************  MAIN  ***********************************)

BEGIN  {ReverseName}
   Initialize(WholeName);
   ReadName(WholeName);
   WriteName(WholeName);
END.  {ReverseNames}






