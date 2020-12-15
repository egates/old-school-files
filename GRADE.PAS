EDIT COMPUTEGRADES.PAS
C
PROGRAM ComputeGrades(Scores,ClassList,Grades,Input,Output);
     {Takes information from the text file Scores.Dat, computes a final
      grade, puts the updated information into the record file ClassList.Dat,
      then creates a text file sorted by Student Name from ClassList.dat}

CONST NameLength  = 20;
      NumStudents = 20;

TYPE  String = PackedArray[1..NameLength] OF char;
      Marks  = RECORD
                 HW,MT,Final,Grd: integer;
               END;
      StuRec = RECORD
                 Name: String;
                 Mks:  Marks;
               END;
      Class  = FILE OF StuRec;
      HoldRecord = Array[1..NumStudents] of StuRec;

VAR   Scores,Grades: Text;
      ClassList: Class;
      Student: StuRec;
      StudentList: HoldRecord;
      Counter: Integer;
(*************************************************************************)

   FUNCTION Calculate(Student: StuRec): integer;
       {Calculates grade according to given weight}

   BEGIN  {Calculate}
      WITH Student.Mks DO
        Calculate = ((HW*0.2) + (MT*0.3) + (Final*0.5));
   END;  {Calculate}
(*************************************************************************)

   PROCEDURE GetScores(VAR Scores: text;
                       VAR Student: StuRec);
        {Reads contents of file Scores.Dat into the Record Student}

   BEGIN  {GetScores}
      Readln(Scores,Student.Name);
      WITH Student.Mks DO
         BEGIN  {WITH}
            Read(Scores,HW);
            Read(Scores,MT);
            Read(Scores,Final);
         END  {WITH}
      Readln(Scores);
   END;  {GetScores}
(*************************************************************************)

   PROCEDURE UpdateClassList(VAR ClassList: Class;
                             VAR StudentList: HoldRecord;
                             VAR Counter: integer;
                                 Student: StuRec);
        {Computes final grade with function Calculate, posts this info to
         Classlist.Dat, then updates the record array with the info}

   BEGIN  {UpdateClassList}
      Student.Mks.Grd = Calculate(Student);
      Write(ClassList,Student);
      Writeln(ClassList);
      StudentList[Counter] := Student;
      Counter := Counter + 1;
   END;  {UpdateClassList}
(*************************************************************************)

   PROCEDURE SortClassList(VAR ClassList: Class;
                               StudentList: HoldRecord);

   VAR Counter: integer;
       NextCounter: integer;
       TempRecord: HoldRecord;

   BEGIN  {SortClassList}
      FOR Counter := 1 TO NumStudents DO
         BEGIN  {For Counter}
            Smallest := Counter;
            FOR NextCounter := Counter TO NumStudents DO
               IF StudentList[NextCounter].Name < StudentList[Smallest].Name
               THEN Smallest := NextCounter;
            TempRecord := StudentList[Counter];
            StudentList[Counter] := StudentList[Smallest];
            StudentList[Smallest] := TempRecord;
         END;  {For Counter}
         REWRITE(ClassList);
         FOR Counter := 1 TO NumStudents DO
            Write(ClassList,StudentList);
         Writeln(ClassList);
   END;  {SortClassList}
(*************************************************************************)

   PROCEDURE CreateGrades(VAR ClassList: Class;
                          VAR Grades: Text);
        {Creates the text file Grades.Dat}

   VAR Student: StuRec;

   BEGIN  {CreateGrades}
      RESET(ClassList);
      REWRITE(Grades);
      WHILE NOT EOF(ClassList) DO
         BEGIN  {While}
            Read(ClassList,Student);
            Write(Grades,Student.Name);
            Writeln(Grades);
            WITH Student.Mks DO
               BEGIN   {WITH}
                  Write(Grades,HW,'  ');
                  Write(Grades,MT,'  ');
                  Write(Grades,Final,'  ');
                  Write(Grades,Grd,'  ');
               END; {WITH}
            Writeln(Grades);
         END;  {While}
   END;  {CreateGrades}
(*******************************  MAIN  **********************************)

BEGIN  {ComputeGrades}
   RESET(Scores);
   REWRITE(Grades);
   REWRITE(ClassList);
   Counter := 1;
   WHILE NOT EOF(Scores) DO
      BEGIN   {WHILE}
         GetScores(Scores,Student);
         UpdateClassList(ClassList,StudentList,Counter,Student);
      END;  {While}
   SortClassList(ClassList,StudentList);
   CreatesGrades(ClassList,Grades);
END.  {ComputeGrades}




