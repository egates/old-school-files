PROGRAM Sortmeas(input,output);
    {Measures effeciency of various sorting routines}

CONST  sortlim = 1001; (* to accomodate up to 1000 records for sorting *)

TYPE
     ET = integer;
     RecordType = RECORD
                    key : ET;
                    position: 0..sortlim
                  END;
     SortArray = ARRAY [0..sortlim] OF RecordType;

VAR
     A,B,C,D,E,F,G,H,I   : SortArray;
     First,Last          : integer;
     CmpCnt,SwtCnt,AsgCnt: integer;

(********************************************************************)

   FUNCTION Init(var A: SortArray): integer;
        {fills the array from STDIN and returns the numbers of items
         as it's value}

   VAR Count: integer;

   BEGIN  {Init}
      Count := 0;
      WHILE NOT EOF DO
        BEGIN  {while}
           WHILE NOT EOLN DO
              BEGIN  {while}
                 Count := Count + 1;
                 Read(A[Count].Key);
                 A[Count].Position := Count;
               END;  {while}
            READLN;
        END;  {while}
      Init := Count;
      A[0].Position := 0;
      A[Sortlim].Position := 1001;
   END; {Init}
(********************************************************************)

PROCEDURE Print(A: Sortarray;
                First,Last: integer);
    {prints the array}

VAR I: Integer;

BEGIN  {Print}
   FOR I := First TO Last DO
     BEGIN  {For}
        Write(A[I].Key);
        Writeln(A[I].Position);
     END;  {FOR}
END;  {PRINT}
(*****************************************************************************)
   FUNCTION GT(Parm1,Parm2: ET): Boolean;
      {returns true if parm1>parm2}

   BEGIN  {GT}
      GT := (Parm1 > Parm2);
      CmpCnt := CmpCnt + 2;
   END;  {GT}

(*****************************************************************************)
   FUNCTION LT(Parm1,Parm2: ET): Boolean;
      {returns true if parm1<parm2}

   BEGIN  {LT}
      LT := (Parm1 < Parm2);
      CmpCnt := CmpCnt + 1;
   END;  {LT}

(*****************************************************************************)
   FUNCTION EQ(Parm1,Parm2: ET): Boolean;
      {returns true if parm1=PArm2}

   BEGIN  {EQ}
      EQ := (Parm1 = Parm2);
      CmpCnt := CmpCnt + 1;
   END;  {EQ}

(*****************************************************************************)
   FUNCTION GE(Parm1,Parm2: ET): Boolean;
      {returns true if parm1>=parm2}

   BEGIN  {GE}
      GE := (Parm1 >= Parm2);
      CmpCnt := CmpCnt + 1;
   END;  {GE}

(*****************************************************************************)
   FUNCTION LE(Parm1,Parm2: ET): Boolean;
      {returns true if parm1<=parm2}

   BEGIN  {LE}
      LE := (Parm1 <= Parm2);
      CmpCnt := CmpCnt + 1;
   END;  {LE}
(**************************************************************************)

   FUNCTION Stable(A: SortArray;
                   Last: Integer): char;

   VAR I,IBack: Integer;
       Found: Boolean;

   BEGIN  {Stable}
      IBack := 0;
      I := 1;
      Found := False;
      WHILE NOT Found AND (I <> Last) DO
        BEGIN  {while}
            IF A[I].Key = A[IBack].Key
            THEN IF A[I].Position < A[IBack].Position
                 THEN BEGIN
                         Found := True;
                         Stable := 'N';
                      END;

            I := I + 1;
            IBack := IBack + 1;
        END;
      IF NOT Found
      THEN Stable := 'Y'
   END;  {stable}
(*****************************************************************************)

   PROCEDURE Report(Srt,Len: integer);
       {prints a reports giving details of test}


  BEGIN  {Report}
   IF Srt = 1 THEN BEGIN
     Writeln;
     Writeln('Method',' ','List Length',' ','Switches',' ','Assignments',
             ' ','Compares',' ','Assign+Compare',' ','Stable');
     Write('-------------------------------------------------------');
     Writeln('------------------------');
   END;  {if}
     CASE Srt OF
       1 : Writeln('Bubble','   ',Len,'   ',SwtCnt,'  ',AsgCnt,'  ',
                   CmpCnt,'   ',AsgCnt+CmpCnt,Stable(A,Last));
       2 : Writeln('Insert','   ',Len,'   ',SwtCnt,'  ',AsgCnt,'  ',
                   CmpCnt,'   ',AsgCnt+CmpCnt,Stable(A,Last));
       3 : Writeln('Select','   ',Len,'   ',SwtCnt,'  ',AsgCnt,'  ',
                   CmpCnt,'   ',AsgCnt+CmpCnt,Stable(A,Last));
       4 : Writeln('Heap  ','   ',Len,'   ',SwtCnt,'  ',AsgCnt,'  ',
                   CmpCnt,'   ',AsgCnt+CmpCnt,Stable(A,Last));
       5 : Writeln('Quick-R ','   ',Len,'   ',SwtCnt,'  ',AsgCnt,'  ',
                   CmpCnt,'   ',AsgCnt+CmpCnt,Stable(A,Last));
       6 : Writeln('Quick -NR','   ',Len,'   ',SwtCnt,'  ',AsgCnt,'  ',
                   CmpCnt,'   ',AsgCnt+CmpCnt,Stable(A,Last));
       7 : Writeln('AQuick - R','   ',Len,'   ',SwtCnt,'  ',AsgCnt,'  ',
                   CmpCnt,'   ',AsgCnt+CmpCnt,Stable(A,Last));
       8 : Writeln('AQuick -NR','   ',Len,'   ',SwtCnt,'  ',AsgCnt,'  ',
                   CmpCnt,'   ',AsgCnt+CmpCnt,Stable(A,Last));
       9 : Writeln('Shell','   ',Len,'   ',SwtCnt,'  ',AsgCnt,'  ',
                   CmpCnt,'   ',AsgCnt+CmpCnt,Stable(A,Last));
     END;  {case}
  END;  {report}

(* ------------------------------------------------------------------------- *)
(* Utility for almost all the sorts given below *)

PROCEDURE Switch ( VAR item1, item2 : RecordType );
   (* interchanges the values stored in item1 and item2 *)
VAR temp : RecordType;
BEGIN (* Switch *)
  temp := item1; item1 := item2; item2 := temp;
  AsgCnt := AsgCnt + 3;
  SwtCnt := SwtCnt + 1;
END   (* Switch *);

(* ------------------------------------------------------------------------- *)
(* BubbleSort *)

PROCEDURE BubbleSort(VAR A : SortArray; first, last: integer);
  (* exchanges consecutive pairs of elements of A systematically  and  switches
     those that are not yet in order; it stops when  no switches  are done in a
     given pass or the last pass has been done *)
VAR pass, pos, sw : integer;

BEGIN (* BubbleSort *)
  pass := first;
  AsgCnt := AsgCnt + 1;
  REPEAT
    sw := 0;
    AsgCnt := AsgCnt + 1;
    Pos := First;
    AsgCnt := AsgCnt + 1;
    WHILE LE(Pos,Last+First-1) DO
      BEGIN  {while}
         IF GT(A[pos].key,A[Pos+1].key) THEN BEGIN
             Switch( A[pos],A[pos+1] );
             sw := sw+1;
             AsgCnt := AsgCnt + 1;
         END;
         Pos := Pos + 1;
         AsgCnt := AsgCnt + 1;
      END; {while}
    pass := pass+1;
    AsgCnt := AsgCnt + 1;
  UNTIL EQ(SW,0) OR GE(Pass,Last);
END   (* BubbleSort *);


(* ------------------------------------------------------------------------- *)
(* InsertSort *)

PROCEDURE InsertSort(VAR A : SortArray; first, last: integer);

  (* with A[first] to A[pass-1] in place,  it finds the right place for A[pass]
     relative to A[first]..A[pass-1];  it starts  its search  at the spot whose
     index is pass and goes down to the spot  whose index  is first;  it slides
     the A[j]'s  to the right  as it goes  so as to make room for the one to be
     inserted at the right spot *)

VAR
     pass, pos : integer; temp : RecordType;

BEGIN (* InsertSort *)
  A[0] := A[first-1];(* temporary storage so as not to lose A[first-1] *);
  AsgCnt := AsgCnt + 1;
  Pass := First + 1;
  AsgCnt := AsgCnt + 1;
  WHILE LE(Pass,Last) DO BEGIN
      temp := A[pass];
      AsgCnt := AsgCnt + 1;
      A[first-1] := temp;
      AsgCnt := AsgCnt + 1;
      pos := pass-1;
      AsgCnt := AsgCnt + 1;
      WHILE LT(Temp.Key,A[Pos].Key) DO BEGIN
         (* find the right spot *)
         A[pos+1] := A[pos]; (* slide down while searching *)
         pos := pos-1;
         AsgCnt := AsgCnt + 2;
      END (* WHILE *);
      A[pos+1] := temp;(* put value in right spot *);
      A[first-1] := A[0];(* restore the value *)
      AsgCnt := AsgCnt + 2;
      Pass := Pass + 1;
      AsgCnt := AsgCnt + 1;
  END (* FOR pass *)
END   (* InsertSort *);

(* ------------------------------------------------------------------------- *)
(* SelectSort *)

PROCEDURE SelectSort( VAR A : SortArray; first, last: integer);

   (* For each value of pass (going from first to last-1) this sort  assigns to
      minplc the index of the item with the smallest key in the set of elements
      A[pos]..A[last] and then exchanges A[pass] with A[pos] *)

VAR
   pass, minplc, pos  : integer;

BEGIN (* SelectSort *)
  Pass := First;
  AsgCnt := AsgCnt + 1;
  WHILE LE(Pass,Last-1) DO BEGIN
      minplc := pass+1; (* minplc is position of the current
      AsgCnt := AsgCnt + 1;
                           smallest key during the search *)
      Pos := Pass + 2;
      AsgCnt := AsgCnt + 1;
      WHILE LE(Pos,Last) DO BEGIN
          IF LT(A[Pos].Key,A[Minplc].Key) THEN BEGIN
             minplc := Pos;
             AsgCnt := AsgCnt + 1;
          END;  {if}
          Pos := Pos + 1;
          AsgCnt := AsgCnt + 1;
        END;  {While}
      IF LT(A[Minplc].Key,A[Pass].Key) THEN
            Switch( A[minplc], A[pass] );
      Pass := Pass + 1;
      AsgCnt := AsgCnt + 1;
  END (* FOR pass *)
END   (* SelectSort *);

(* ------------------------------------------------------------------------- *)
(* Heap Sort *)

PROCEDURE PushDown ( VAR A                        : SortArray;
                   sortstart, tmpstart, tmpfinish : integer );
  (* This is the work horse in HeapSort : it essentially pushes A[tmpstart] down
     the tree consisting of all items from A[sortstart]..A[tmpfinish] until the
     partially ordered tree property is restored in A[tmpstart]..A[tmpfinish] *)
VAR
    r : integer;  (* holds coded current position of item *)
BEGIN (* PushDown *)
   r := tmpstart-sortstart+1;
   AsgCnt := AsgCnt + 1;
   WHILE LE(R,((TmpFinish-SortStart+1) DIV 2)) DO BEGIN  {while}
      IF EQ(R,((Tmpfinish-SortStart+1) DIV 2)) AND
         EQ(((Tmpfinish-SortStart+1) MOD 2),0) THEN
         (* A[sortstart-1 + r] has one child at place sortstart-1 + 2*r *)
         BEGIN
           IF LT(A[Sortstart-1+R].Key,A[SortStart-1+2*R].Key) THEN
                Switch( A[sortstart-1+r], A[sortstart-1+2*r] );
           r := tmpfinish-sortstart+1 (* stop loop *);
           AsgCnt := AsgCnt + 1;
         END
      ELSE (* every parent has two children *)
         IF LT(A[sortstart-1 + r].key,A[sortstart-1 + 2*r].key) THEN
             IF LT(A[sortstart-1 + 2*r].key,A[sortstart-1 + 2*r+1].key) THEN
                (* exchange value of parent and right child *)
                BEGIN
                    Switch( A[sortstart-1 + r], A[sortstart-1 + 2*r+1] );
                    r := 2*r+1;  (* move on down *);
                    AsgCnt := AsgCnt + 1;
                END
             ELSE (* exchange value of parent with leftchild *)
                BEGIN
                  Switch( A[sortstart-1 + r], A[sortstart-1 + 2*r] );
                  r := 2*r;  (* move on down *)
                  AsgCnt := AsgCnt + 1;
                END
         ELSE IF LT(A[sortstart-1 + r].key,A[sortstart-1 + 2*r+1].key) THEN
             (* exchange value of parent and right child *)
                BEGIN
                  Switch( A[sortstart-1 + r], A[sortstart-1 + 2*r+1] );
                  r := 2*r+1;
                  AsgCnt := AsgCnt + 1;
                END
         ELSE (* A[sortstart-1 + r] doesn't violate the partially order tree prop *)
            BEGIN {else}
                r := tmpfinish-sortstart+1;
                AsgCnt := AsgCnt + 1;
           END;  {else}
   END (* WHILE *)
END   (* PushDown *);

PROCEDURE HeapSort( VAR A : SortArray; first, last: integer );
   (* sorts A[first]..A[last] into non-decreasing order by pushing down the
      items not in the partial ordering of the tree in a systematic way.*)
VAR
   pos : integer; (* a cursor into A *)
BEGIN (* HeapSort *)
   Pos := (First-1) + ((Last-First+1) DIV 2);
   AsgCnt := AsgCnt + 1;
   WHILE GE(Pos,First) DO BEGIN {While}
       PushDown (A, first, pos, last);
       Pos := Pos - 1;
       AsgCnt := AsgCnt + 1;
     END; {while}
   Pos := Last;
   AsgCnt := AsgCnt + 1;
   WHILE GE(Pos,First+1) DO BEGIN
       Switch (A[first], A[pos]) (* removes minimum from the heap *);
       PushDown (A, first, first, pos-1);
       Pos := Pos - 1;
       AsgCnt := AsgCnt + 1;
   END (* FOR pos *)
END  (* HeapSort *);

(* ------------------------------------------------------------------------- *)
(* Recursive and Non Recursive QuickSort *)

PROCEDURE partition( VAR A : sortarray; lo, hi : integer; VAR pivloc : integer);

  (* returns in A the items from A[lo] to A[hi] rearranged as follows:
     if lo<=i< pivloc, then A[i].key<A[pivloc].key; and if pivloc<=i<=hi, then
     A[pivloc].key>=A[i].key; thus the list from position lo to position hi is
     divided into two parts all in left part (coming before the pivloc spot)
     are smaller than all in right part. The place designated pivloc is
     a dividing value *)

VAR  piv : integer; (* key value *)
     i, lastsmall : integer; (* index values *)

BEGIN (* partition *)
(* pick middle as pivot and put in lo spot *)
  switch(A[lo], A[(lo+hi) DIV 2]);
  piv := A[lo].key;
  AsgCnt := AsgCnt + 1;
  (* keep track of last item in left half as things are rearranged *)
  lastsmall := lo;
  AsgCnt := AsgCnt + 1;
  I := Lo + 1;
  AsgCnt := AsgCnt + 1;
  WHILE LE (I,Hi) DO BEGIN {while}
      IF LT(A[i].key,piv) THEN
         BEGIN
           lastsmall := lastsmall+1;
           AsgCnt := AsgCnt + 1;
           switch(A[lastsmall], A[i])
         END;
      I := I + 1;
      AsgCnt := AsgCnt + 1;
   END;  {While}
  (* put pivot in lastsmall position *)
  switch(A[lo], A[lastsmall]);
  pivloc := lastsmall;
  AsgCnt := AsgCnt + 1;
END   (* partition *);

(* recursive version *)
PROCEDURE quicksort( VAR A : sortarray; first, last : integer );
  (* partition the list into two halves and then call quicksort
     one each half to get job done *)
VAR pivloc : integer;
BEGIN (* quicksort *)
  IF LT(first,last) THEN
     BEGIN
       partition(A, first, last, pivloc);
       quicksort(A, first, pivloc-1);
       quicksort(A, pivloc+1, last)
     END
END   (* quicksort *);

(*------------------------------------------------------------------------*)
(* nonrecursive version of quicksort *)

PROCEDURE nrquicksort ( VAR A : sortarray ; first, last : integer );
  (* implements a non recursive version of quicksort with a pair
     of stacks that keep track of the boundaries for the partitioned sets *)
CONST
      maxstack   = round(ln(sortlim)/ln(2))+1; (* log(n) choice *)
TYPE
      stacktype  = ARRAY [1..maxstack] OF 0..sortlim;
VAR
    pivloc           : integer;
    lostack, histack : stacktype;
    nstack           : integer;
    (* error            : boolean; *)
BEGIN
  nstack := 0; (* error := false; *)
  AsgCnt := AsgCnt + 1;
  REPEAT
    IF GT(nstack,0) THEN (* pop off the next two boundaries for partitioning *)
        BEGIN
          first := lostack[nstack]; last  := histack[nstack];
          nstack := nstack-1;
          AsgCnt := AsgCnt + 3;
        END;
    WHILE LT(first,last) (* AND (NOT error) *) DO BEGIN
       partition (A, first, last, pivloc);
       (* overflow check has been omitted since the two stacks are big
          enough even in worst cases
          IF GE(nstack,maxstack) THEN
             BEGIN
               error := true; writeln('sort terminated, stack overflow');
               AsgCnt := AsgCnt + 1;
             END
          ELSE *)
       IF LT((pivloc-first),(last-pivloc)) THEN
       (* push larger sublist boundaries onto stack and do smaller list *)
          BEGIN
            nstack := nstack+1; lostack[nstack] := pivloc+1;
            histack[nstack] := last; last := pivloc-1;
            AsgCnt := AsgCnt + 4;
          END
       ELSE
          BEGIN
            nstack := nstack+1; lostack[nstack] := first;
            histack[nstack] := pivloc-1; first := pivloc+1;
            AsgCnt := AsgCnt + 4;
          END
    END (* WHILE *)
  UNTIL EQ(nstack,0) (* OR error *)
END (* nrquicksort *);

(*--------------------------------------------------------------------------*)
(* alternate recursive quicksort *)

FUNCTION Pivot ( VAR A : SortArray; i, j : integer ) : integer;

  (* returns the subscript of an array element in A[i]..A[j] whose key is the
     larger of the  two leftmost different keys, unless all the keys of these
     elements are the same, in which case it returns the value of 0 *)

VAR  k : integer;

BEGIN (* Pivot *)
  k := i+1;
  AsgCnt := AsgCnt + 1;
  WHILE LE(k,j) AND EQ(A[k].key,A[i].key) DO BEGIN
        k := k+1;
        AsgCnt := AsgCnt + 1;
     END;  {while}
  IF EQ(k,j+1) THEN
     Pivot := 0   (* all keys were the same in this range *)
  ELSE IF GT(A[k].key,A[i].key) THEN
     Pivot := k
  ELSE (* A[k].key<A[i].key *)
     Pivot := i;
  AsgCnt := AsgCnt + 1  {for the nested if's}
END   (* Pivot *);

FUNCTION PartitionBoundary( VAR A : SortArray; i, j, piv : integer ) : integer;

   (* let divider = A[piv].key at start; rearranges A[i]..A[j] so that all  the
      A[t]'s with A[t].key<divider are on the left  and  all  the  A[t]'s  with
      A[t].key>=divider are on the right &  then returns the index of the array
      element that is at the boundary of the two halves of the array. *)

VAR
    left, right : integer;

BEGIN (* PartitionBoundary *)
   left := i; right := j; A[0] := A[piv];
   AsgCnt := AsgCnt + 3;
   REPEAT
     Switch( A[left], A[right] );
     WHILE LT(A[left].key,A[0].key) DO BEGIN
          left := left+1;
          AsgCnt := AsgCnt + 1;
       END;  {while}
     WHILE GE(A[right].key,A[0].key) DO BEGIN
          right := right-1;
          AsgCnt := AsgCnt + 1;
       END;  {while}
   UNTIL GT(left,right);
   PartitionBoundary := left;
   AsgCnt := AsgCnt + 1;
END   (* PartitionBoundary *);

PROCEDURE AltQuickSort( VAR A : SortArray; first, last: integer);

   (* Sorts A from A[first] to A[last] by the partition method; calls itself
      recursively on each part of the partition that results.               *)

VAR  pivindex, k : integer;

BEGIN (* AltQuickSort *)
  pivindex := Pivot( A, first, last );
  AsgCnt := AsgCnt + 1;
  IF NOT EQ(pivindex,0) THEN (* there are still parts of the partition to sort *)
     BEGIN
       k := PartitionBoundary( A, first, last, pivindex );
       AsgCnt := AsgCnt + 1;
       AltQuickSort( A, first, k-1  ); (* do the left  part of the partition *)
       AltQuickSort( A, k,     last ); (* do the right part of the partition *)
     END
END   (* AltQuickSort *);

(* ------------------------------------------------------------------------ *)
(* Non recursive version of AltQuickSort *)

PROCEDURE NrAltQuickSort( VAR A : sortarray; first, last: integer);

   (* Sorts A from A[first] to A[last] by the partition method;
      uses two stacks to keep track of ends of partitioned sets *)

CONST
    maxstack = round(ln(sortlim)/ln(2))+1; (* tight but adequate estimate *)
TYPE
    stacktype = array [1..maxstack] OF integer;
VAR
    pivindex, k      : integer;
    nstack           : 0..maxstack;
    lostack, histack : stacktype;

BEGIN (* NrAltQuickSort *)
  nstack := 0;
  AsgCnt := AsgCnt + 1;
  REPEAT
    IF GT(nstack,0) THEN (* pop both stacks *)
       BEGIN
         first := lostack[nstack];
         last := histack[nstack];
         nstack := nstack-1;
         AsgCnt := AsgCnt + 3;
       END;
    pivindex := Pivot( A, first, last );
    AsgCnt := AsgCnt + 1;
    WHILE NOT EQ(pivindex,0) DO BEGIN
       k := PartitionBoundary( A, first, last, pivindex );
       AsgCnt := AsgCnt + 1;
       IF LT((k-1-first),(last-k)) THEN
          BEGIN
            nstack := nstack+1;
            lostack[nstack] := k; histack[nstack] := last;
            last := k-1;
            AsgCnt := AsgCnt + 4;
          END
       ELSE
          BEGIN
            nstack := nstack+1;
            lostack[nstack] := first; histack[nstack] := k-1;
            first := k;
            AsgCnt := AsgCnt + 4;
          END;
       pivindex := Pivot( A, first, last );
       AsgCnt := AsgCnt + 1;
     END (* WHILE *)
   UNTIL EQ(nstack,0)
END   (* NrAltQuickSort *);

(*---------------------------------------------------------------------------*)
(* Shell Sort *)

PROCEDURE ShellSort( VAR A : SortArray; first, last: integer);

   (* In each pass this sort switches successive pairs of items in A that are
      out of order, whose subscripts are incr apart and then cuts incr in half;
      it continues this process until incr reaches 0 *)

VAR i, j, incr : integer;

BEGIN (* ShellSort *)
  incr := (last-first+1) DIV 2;
  AsgCnt := AsgCnt + 1;
  WHILE GT(incr,0) DO BEGIN
    I := Incr + First;
    WHILE LE(I,Last) DO BEGIN
        j := i-incr;
        AsgCnt := AsgCnt + 1;
        WHILE GT(j,first-1) DO
          IF GT(A[j].key,A[j+incr].key) THEN
             BEGIN
               Switch( A[j], A[j+incr] );
               j := j-incr;
               AsgCnt := AsgCnt + 1;
             END (* if two items are out of order *)
          ELSE BEGIN
                  j := first-1; (* forces end of inner WHILE loop: no more to
                               do *)
                  AsgCnt := AsgCnt + 1;
               END;
        I := I + 1;
    END (* FOR i *);
    incr := ( incr DIV 2 );
    AsgCnt := AsgCnt + 1;
  END   (* WHILE *)
END   (* ShellSort *);

(*--------------------------- MAIN ---------------------------------------*)

BEGIN  {SortMeas}
   AsgCnt := 0; SwtCnt := 0; CmpCnt := 0;
   Last := Init(A);
   B := A;
   C := A;
   D := A;
   E := A;
   F := A;
   G := A;
   H := A;
   I := A;
   First := 1;
   BubbleSort(A,First,Last);
   Report(1,Last);
   First := 1;
   asgcnt := 0;swtcnt:=0;cmpcnt:=0;
   InsertSort(B,First,Last);
   Report(2,Last);
   First := 1;
   asgcnt:=0;swtcnt:=0;cmpcnt:=0;
   SelectSort(C,First,Last);
   Report(3,Last);
   First := 1;
   asgcnt:=0;swtcnt:=0;cmpcnt:=0;
   HeapSort(D,First,Last);
   Report(4,Last);
   First := 1;
   asgcnt:=0;swtcnt:=0;cmpcnt:=0;
   QuickSort(E,First,Last);
   Report(5,Last);
   First := 1;
   asgcnt:=0;swtcnt:=0;cmpcnt:=0;
   NRQuickSort(F,First,Last);
   Report(6,Last);
   First := 1;
   asgcnt:=0;swtcnt:=0;cmpcnt:=0;
   AltQuickSort(G,First,Last);
   Report(7,Last);
   First := 1;
   asgcnt:=0;swtcnt:=0;cmpcnt:=0;
   NRAltQuickSort(H,First,Last);
   Report(8,Last);
   First := 1;
   asgcnt:=0;swtcnt:=0;cmpcnt:=0;
   ShellSort(I,First,Last);
   report(9,last);
END.

