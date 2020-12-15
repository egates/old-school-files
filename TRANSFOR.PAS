PROGRAM Transform(input,output);

{$M 16384,0,250360}

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
    NewYear : Boolean;

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
                    Month,Wday: Word): word;
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
   JDate := JD;
END;   {jdate}

(**************************************************************************)
PROCEDURE BuildDate(var MonthDays: Months;
                    var Wday,Year,Month,Day,DayOfWeek: Word;
                    var NewYear: Boolean);
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
   IF ((Year - 1988) MOD 4) = 0
   THEN MonthDays[2] := 29;

   NewYear := False;
   (* set work date, adjust for weekend if necessary *)
   CASE DayOfWeek OF
      0: IF Day = 1
         THEN BEGIN
                 IF Month = 1
                 THEN BEGIN  {then}
                         Month := 13;
                         NewYear := True;
                      END;  {then}
                 WDay := MonthDays[Month-1] - 1;
                 Month := Month - 1;
              END
         ELSE IF Day = 2
              THEN BEGIN
                      IF Month = 1
                      THEN BEGIN  {then}
                              Month := 13;
                              NewYear := True;
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
                         NewYear := True;
                      END;  {then}
                 WDay := MonthDays[Month-1] - 2;
                 Month := Month - 1;
              END
         ELSE IF Day = 2
              THEN BEGIN
                      IF Month = 1
                      THEN BEGIN  {then}
                              Month := 13;
                              NewYear := True;
                           END;  {then}
                      WDay := MonthDays[Month-1] - 1;
                      Month := Month - 1;
                   END
              ELSE IF Day = 3
                   THEN BEGIN
                           IF Month = 1
                           THEN BEGIN  {then}
                                   Month := 13;
                                   NewYear := True;
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
                           NewYear := True;
                        END;  {then}
                   WDay := MonthDays[Month-1];
                   Month := Month - 1;
                END
           ELSE WDay := Day - 1;
   END;  {case}
END;  {Builddate}

(**************************************************************************)
PROCEDURE CheckForHoliday(MonthDays: Months;
                          var WDay: word);
   (* adjust workdate for holidays *)


VAR NewYears,Presidents, Memorial,Independence : word;
    Labor, Turkey, Christmas : word;
    DOWCnt, I : Integer;
    Yr, Mth, Dy, DOW: Word;
    CYr, CMth, CDy, CDOW: Word;
    LeapYear : Boolean;

BEGIN  {cfh}
   GetDate(CYr,CMth,CDy,CDOW);

   (* Adjust for Leap year *)
   (* Set holidays with standard dates *)
   LeapYear := (((CYr - 1988) MOD 4) = 0);
   IF LeapYear
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
   Presidents := JDate(MonthDays,Mth,Dy);

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
   IF LeapYear
   THEN Memorial := JDate(MonthDays,Mth,Dy) + 1
   ELSE Memorial := JDate(MonthDays,Mth,Dy);

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
   IF LeapYear
   THEN Labor := JDate(MonthDays,Mth,Dy) + 1
   ELSE Labor := JDate(MonthDays,Mth,Dy);

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
   IF LeapYear
   THEN Turkey := JDate(MonthDays,Mth,Dy) + 1
   ELSE Turkey := JDate(MonthDays,Mth,Dy);

   (* reset date *)
   SetDate(CYr,CMth,CDy);
   Writeln('Presidents: ',Presidents);
   Writeln('Memorial  : ',Memorial);
   Writeln('Labor     : ',Labor);
   Writeln('Turkey    : ',Turkey);

   (* Adjust workday if it equals a holiday *)
   CASE WDay OF
     NewYears    : ;
     Presidents  : WDay := WDay - 2;
     Memorial    : WDay := WDay - 2;
     Independence: ;
     Labor       : WDay := WDay - 2;
     Turkey      : WDay := WDay - 1;
     Christmas   : ;








END;  {cfh}
(**************************************************************************)
PROCEDURE BuildFile(    MonthDays: Months;
                        Year, Month, Wday: Word;
                        NewYear: Boolean;
                    var CExt, PExt: string);
   (* Build file extension for Central Library Files *)
   (* Adjust for work date of previous year *)

VAR TYear,TDate: String;
    Len : integer;

BEGIN {buildfile}
   IF NewYear
   THEN Year := Year - 1;
   TYear := IToStr(Year);
   Delete(TYear,1,2);
   TDate := IToStr(JDate(MonthDays,Month,Wday));
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
   BuildDate(MonthDays,WDay,Year,Month,Day,DayOfWeek,NewYear);
   CheckForHoliday(MonthDays,WDay);
   BuildFile(MonthDays,Year,Month,Wday,NewYear,CentralExt,PCExt);
   MakeQueue(Queue);
   BuildQ(Queue,CentralExt,PCExt);
   PrintQ(Queue);
(*   Dequeue(TranFiles,Queue);
   IF NOT LwCall(TranFiles)
   THEN Writeln
   ELSE Writeln; *)
END.  {main}
