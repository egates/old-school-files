PROGRAM Transform(input,output);

{$M 16384,0,280360}

uses Dos;

{$I Queuepac.pas}

TYPE TranType = QEltType;
     Months = array[0..12] of integer;

VAR TranFiles: TranType;
    Queue    : QType;
    Year,Month,Day,DayOfWeek,Wday: word;
    STime,CentralExt,PCExt: string;
    Junk: Integer;
    MonthDays : Months;
    JDay : word;

(**************************************************************************)
FUNCTION LeapYear(Yr: word): boolean;
    {checks to see if the year is a leap year}

BEGIN  {leapyear}
   LeapYear :=  (((Yr - 1988) MOD 4) = 0);
END;  {leapYear}

(**************************************************************************)
FUNCTION itostr (n : word) : string;
    { itostr - convert integer n to string in s... }

VAR S: String;

begin (* itoc *)
   Str(N,S);
   IToStr := S;
end (* itoc *);

(**************************************************************************)
FUNCTION  JDate(var MonthDays: Months;
                    Year,Month,Wday: Word): word;
   (* create julian date *)

VAR JD : Word;
    I : Integer;

BEGIN  {Jdate}
   IF (Month <> 1)
   THEN  BEGIN  {then}
            JD := WDay;
            FOR I := 1 TO (Month - 1) DO
                 JD := JD + MonthDays[I];
         END  {then}
   ELSE JD := WDay;
   IF LeapYear(Year)
   THEN JDate := JD + 1
   ELSE JDate := JD;
END;   {jdate}

(**************************************************************************)
PROCEDURE BuildDate(var MonthDays: Months;
                    var Wday,Year,Month,Day,DayOfWeek: Word);
    {returns the file extension for the current day files}

VAR   I : integer;

BEGIN  {builddate}

   (* initialize array with days in months *)
   MonthDays[0] := 31;  {dec prev year}
   MonthDays[1] := 31;  {jan}
   MonthDays[2] := 28;  {feb}
   MonthDays[3] := 31;  {mar}
   MonthDays[4] := 30;  {apr}
   MonthDays[5] := 31;  {may}
   MonthDays[6] := 30;  {jun}
   MonthDays[7] := 31;  {jul}
   MonthDays[8] := 31;  {aug}
   MonthDays[9] := 30;  {sep}
   MonthDays[10] := 31; {oct}
   MonthDays[11] := 30; {nov}
   MonthDays[12] := 31; {dec}

   (* get current date *)
   GetDate(Year,Month,Day,DayOfWeek);

   (* adjust days in february for leap years *)
   IF LeapYear(Year)
   THEN MonthDays[2] := 29;

   (* set work date, adjust for weekend if necessary *)
   CASE DayOfWeek OF
      0: IF Day = 1
         THEN BEGIN
                 IF Month = 1
                 THEN BEGIN  {then}
                         Month := 13;
                         Year := Year - 1;
                      END;  {then}
                 WDay := MonthDays[Month-1] - 1;
                 Month := Month - 1;
              END
         ELSE IF Day = 2
              THEN BEGIN
                      IF Month = 1
                      THEN BEGIN  {then}
                              Month := 13;
                              Year := Year - 1;
                           END;  {then}
                      WDay := MonthDays[Month-1];
                      Month := Month - 1;
                   END
              ELSE WDay := Day - 2;

      1: IF Day = 1
         THEN BEGIN
                 IF Month = 1
                 THEN BEGIN  {then}
                         Month := 13;
                         Year := Year - 1;
                      END;  {then}
                 WDay := MonthDays[Month-1] - 2;
                 Month := Month - 1;
              END
         ELSE IF Day = 2
              THEN BEGIN
                      IF Month = 1
                      THEN BEGIN  {then}
                              Month := 13;
                              Year := Year - 1;
                           END;  {then}
                      WDay := MonthDays[Month-1] - 1;
                      Month := Month - 1;
                   END
              ELSE IF Day = 3
                   THEN BEGIN
                           IF Month = 1
                           THEN BEGIN  {then}
                                   Month := 13;
                                   Year := Year - 1;
                                END;  {then}
                           WDay := MonthDays[Month-1];
                           Month := Month - 1;
                        END
                   ELSE WDay := Day - 3

      ELSE IF Day = 1
           THEN BEGIN
                   IF Month = 1
                   THEN BEGIN  {then}
                           Month := 13;
                           Year := Year - 1;
                        END;  {then}
                   WDay := MonthDays[Month-1];
                   Month := Month - 1;
                END
           ELSE WDay := Day - 1;
   END;  {case}
END;  {Builddate}

(**************************************************************************)
PROCEDURE CheckForHoliday(MonthDays: Months;
                          var Year,Month,WDay,JDay: word);
   (* adjust workdate for holidays *)


VAR NewYears,Presidents, Memorial,Independence : word;
    Labor, Turkey, Christmas : word;
    DOWCnt, I : Integer;
    Yr, Mth, Dy, DOW: Word;
    CYr, CMth, CDy, CDOW: Word;

BEGIN  {cfh}
   GetDate(CYr,CMth,CDy,CDOW);

   (* Adjust for Leap year *)
   (* Set holidays with standard dates *)
   IF LeapYear(Year)
   THEN BEGIN
           NewYears := 1;
           Independence := 186;
           Christmas := 360;
        END
   ELSE BEGIN
           NewYears := 1;
           Independence := 185;
           Christmas := 359;
        END;

   (* find 3rd Mon of Feb - Presidents day *)
   I := 1;
   DowCnt := 0;
   REPEAT
      SetDate(CYr,2,I);
      GetDate(Yr,Mth,Dy,DOW);
      IF DOW = 1
      THEN DowCnt := DowCnt + 1;
      I := I + 1;
   UNTIL DowCnt = 3;
   Presidents := JDate(MonthDays,Yr,Mth,Dy);

   (* find 4th Mon of May - Memorial day *)
   I := 1;
   DowCnt := 0;
   REPEAT
      SetDate(CYr,5,I);
      GetDate(Yr,Mth,Dy,DOW);
      IF DOW = 1
      THEN DowCnt := DowCnt + 1;
      I := I + 1;
   UNTIL DowCnt = 4;
   IF LeapYear(Year)
   THEN Memorial := JDate(MonthDays,Yr,Mth,Dy) + 1
   ELSE Memorial := JDate(MonthDays,Yr,Mth,Dy);

   (* find 1st Mon of Sept - Labor Day *)
   I := 1;
   DowCnt := 0;
   REPEAT
      SetDate(CYr,9,I);
      GetDate(Yr,Mth,Dy,DOW);
      IF DOW = 1
      THEN DowCnt := DowCnt + 1;
      I := I + 1;
   UNTIL DowCnt = 1;
   IF LeapYear(Year)
   THEN Labor := JDate(MonthDays,Yr,Mth,Dy) + 1
   ELSE Labor := JDate(MonthDays,Yr,Mth,Dy);

   (* find 4th Thur of Nov - Turkey Day *)
   I := 1;
   DowCnt := 0;
   REPEAT
      SetDate(CYr,11,I);
      GetDate(Yr,Mth,Dy,DOW);
      IF DOW = 4
      THEN DowCnt := DowCnt + 1;
      I := I + 1;
   UNTIL DowCnt = 4;
   IF LeapYear(Year)
   THEN Turkey := JDate(MonthDays,Yr,Mth,Dy) + 1
   ELSE Turkey := JDate(MonthDays,Yr,Mth,Dy);

   (* reset date *)
   SetDate(CYr,CMth,CDy);

Writeln('Presidents: ',Presidents);
Writeln('Memorial  : ',Memorial);
Writeln('Labor     : ',Labor);
Writeln('Turkey    : ',Turkey);

   (* set julian day *)
   JDay := (JDate(MonthDays,Year,Month,WDay));

   (* Adjust workday if it equals a holiday *)
   IF JDay = NewYears
   THEN BEGIN  {case NY}
           SetDate(Year,1,1);
           GetDate(Yr,Mth,Day,DOW);
           IF DOW = 1
           THEN IF LeapYear(Year - 1)
                THEN JDay := 364
                ELSE JDay := 363
           ELSE IF LeapYear(Year - 1)
                THEN JDay := 366
                ELSE JDay := 365;
           Month := 12;
           Year := Year - 1;
        END  {case NY}
   ELSE IF JDay = Presidents
        THEN JDay := JDay - 3
        ELSE IF JDay = Memorial
             THEN JDay := JDay - 3
             ELSE IF JDay = Independence
                  THEN BEGIN {case 7/4}
                         SetDate(Year,7,4);
                         GetDate(Yr,Mth,Day,DOW);
                         IF DOW = 1
                         THEN JDay := JDay - 3
                         ELSE JDay := JDay - 1;
                       END  {case 7/4}
                  ELSE IF JDay = Labor
                       THEN JDay := JDay - 3
                       ELSE IF JDay = Turkey
                            THEN JDay := JDay - 1
                            ELSE IF JDay = Christmas
                                 THEN BEGIN {case xmas}
                                        SetDate(Year,12,25);
                                        GetDate(Yr,Mth,Day,DOW);
                                        IF DOW = 1
                                        THEN JDay := JDay - 3
                                        ELSE JDay := JDay - 1;
                                      END;  {case xmas}
   SetDate(CYr,CMth,CDy);
END;  {cfh}

(**************************************************************************)
PROCEDURE BuildFile(    MonthDays: Months;
                        Year, Jday: Word;
                    var CExt, PExt: string);
   (* Build file extension for Central Library Files *)
   (* Adjust for work date of previous year *)

VAR TYear,TDate: String;
    Len : integer;

BEGIN {buildfile}
   TYear := IToStr(Year);
   Delete(TYear,1,2);
   TDate := IToStr(JDay);
   Len := Length(TDate);
   IF Len = 1
   THEN TDate := '00'+TDate
   ELSE IF Len = 2
        THEN TDate := '0'+TDate;
   Cext := '000'+TYear+TDate;

   (* Build file extension for PC Files *)
   PExt := TDate+'.DAT';
END;  {Builddate}

(**************************************************************************)
PROCEDURE BuildQ(var Q: Qtype;
                     CExt,PExt: string);
   {creates the Q according to historical file creation order}


VAR NewFile  : QEltType;
    FileNames: text;

BEGIN  {buildQ}
      (* prepare file containing filenames for reading *)
   Assign(FileNames,'FILES.DAT');
   Reset(FileNames);
   WHILE NOT EOF(FileNames) DO
      BEGIN  {while}
          (* read from the file and insert the file extension for
             current day files *)
        Readln(FileNames,NewFile.Cmd);
        Insert(PExt,NewFile.Cmd,35);
        Insert(CExt,NewFile.Cmd,27);
        NewFile.Time := 1:00;
        EnQueue(Newfile,Q);
      END;
   Close(Filenames);
END;  {buildQ}

(**************************************************************************)
FUNCTION LwCall(TFiles: TranType): boolean;
    {calls lw transform on the files FILE returns true if sucessful}

VAR CmdLine : String;

BEGIN  {lwcall}
   CmdLine := 'Call transform '+TFiles.Cmd;
   SwapVectors;
   Exec('C:\LW\LWF.EXE',CmdLine);
   SwapVectors;
   Writeln(doserror);
   IF DosError <> 0
   THEN BEGIN  {IF}
          LwCall := False;
          Writeln('LWF.EXE file not found')
        END   {if}
   ELSE BEGIN  {else}
           CASE DosExitCode OF
              0:   BEGIN  { case 0 }
                      LwCall := True;
                      Writeln('File ',Tfiles.Cmd,' successfully transformed');
                   END;  { case 0 }
              3:   BEGIN { case 3 }
                      LwCall := False;
                      Writeln('Not Logged On to VM or Bad Connection');
                      Writeln('Please make sure you are logged on');
                   END;  { case 3 }
              57:  BEGIN { case 57 }
                      LwCall := False;
                      Writeln('Transform of ',Tfiles.Cmd,
                              ' unsucessful - cancelled by user');
                   END;  { case 57 }
              59:  BEGIN { case 59 }
                      LwCall := False;
                      Writeln('File ',Tfiles.Cmd,' does not exist');
                      Writeln('Will try again later.');
                   END;
              255: BEGIN  { case 255 }
                      LwCall := False;
                      Write('Central Library File is restricted for');
                      Writeln(Tfiles.Cmd);
                   END
              ELSE BEGIN  { otherwise }
                           LwCall := False;
                           Writeln('Unidentified error transforming ',Tfiles.Cmd);
                           Writeln('Error code was ',DosExitCode:3);
                        END;  { otherwise }
          END;  {case}
      END;
END;  {lwcall}

(**************************************************************************)
BEGIN {Main}
   BuildDate(MonthDays,WDay,Year,Month,Day,DayOfWeek);
   CheckForHoliday(MonthDays,Year,Month,WDay,JDay);
   BuildFile(MonthDays,Year,Jday,CentralExt,PCExt);
   MakeQueue(Queue);
   BuildQ(Queue,CentralExt,PCExt);
   PrintQ(Queue);
   GetTime(Hr,Min,Sec,Msec);
   WHILE NOT Empty(Queue) OR (Hr < 3) DO
     BEGIN  {while}
       Dequeue(TranFiles,Queue);
       IF LwCall(TranFiles)
       THEN Writeln
       ELSE Writeln; *)
END.  {main}
