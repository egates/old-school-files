(* PART A.

  This file contains sorting routines each of which expects to sort an array of
  A[0..SORTLIM] of RecordType from position first to positon last, according to
  a field of the record RecordType called key,  which is  of type ET.  In other
  words, each of these  subprograms sorts  the elements of A  by looking at the
  order of the A[i].key's. Note that the  index  first  will always be >= 1  in
  value and the index last will always be < SORTLIM in value, so that positions
  0 and SORTLIM are available for "dummy" storage bins,  if needed.  (Note that
  some of the sorts given take advantage of that fact.) These sorts are "in lo-
  cation" sorts, i.e., they do not create an auxiliary array  in  which  to put
  the sorted list but do everything within the same list.

            written by John A. Lutts (from various places) 11/86
            revised by JAL on 7/9/89 and 3/31/90

  HERE IS THE DECLARATION PART TO BE USED: *)

     CONST  sortlim = 1001; (* to accomodate up to 1000 records for sorting *)
     TYPE
       ET = integer;
       RecordType = RECORD
           key : ET;
           position: 0..sortlim
       END;
       SortArray = ARRAY [0..sortlim] OF RecordType;

(* ------------------------------------------------------------------------- *)
(* Utility for almost all the sorts given below *)

PROCEDURE Switch ( VAR item1, item2 : RecordType );
   (* interchanges the values stored in item1 and item2 *)
VAR temp : RecordType;
BEGIN (* Switch *)
  temp := item1; item1 := item2; item2 := temp
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
  REPEAT
    sw := 0;
    FOR pos := first TO (last+first-1) - pass DO
        IF ( A[pos].key>A[pos+1].key ) THEN BEGIN
           Switch( A[pos],A[pos+1] );
           sw := sw+1
        END;
    pass := pass+1
  UNTIL (sw=0) OR (pass>=last)
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
  A[0] := A[first-1] (* temporary storage so as not to lose A[first-1] *);
  FOR pass := first+1 TO last DO BEGIN
      temp := A[pass];
      A[first-1] := temp;
      pos := pass-1;
      WHILE ( temp.key<A[pos].key ) DO BEGIN
         (* find the right spot *)
         A[pos+1] := A[pos]; (* slide down while searching *)
         pos := pos-1
      END (* WHILE *);
      A[pos+1] := temp (* put value in right spot *);
      A[first-1] := A[0] (* restore the value *)
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
  FOR pass := first TO last-1 DO BEGIN
      minplc := pass+1; (* minplc is position of the current
                           smallest key during the search *)
      FOR pos := pass+2 TO last DO
          IF ( A[pos].key<A[minplc].key ) THEN minplc := pos;
      IF ( A[minplc].key<A[pass].key ) THEN
         Switch( A[minplc], A[pass] )
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
   WHILE ( r <= (tmpfinish-sortstart+1) DIV 2 ) DO BEGIN
      IF ( r = (tmpfinish-sortstart+1) DIV 2 ) AND
         ( (tmpfinish-sortstart+1) MOD 2 = 0 ) THEN
         (* A[sortstart-1 + r] has one child at place sortstart-1 + 2*r *)
         BEGIN
           IF ( A[sortstart-1 + r].key < A[sortstart-1 + 2*r].key ) THEN
                Switch( A[sortstart-1+r], A[sortstart-1+2*r] );
           r := tmpfinish-sortstart+1 (* stop loop *);
         END
      ELSE (* every parent has two children *)
         IF ( A[sortstart-1 + r].key < A[sortstart-1 + 2*r].key ) THEN
             IF ( A[sortstart-1 + 2*r].key < A[sortstart-1 + 2*r+1].key ) THEN
                (* exchange value of parent and right child *)
                BEGIN
                    Switch( A[sortstart-1 + r], A[sortstart-1 + 2*r+1] );
                    r := 2*r+1  (* move on down *);
                END
             ELSE (* exchange value of parent with leftchild *)
                BEGIN
                  Switch( A[sortstart-1 + r], A[sortstart-1 + 2*r] );
                  r := 2*r  (* move on down *)
                END
         ELSE IF ( A[sortstart-1 + r].key < A[sortstart-1 + 2*r+1].key ) THEN
             (* exchange value of parent and right child *)
                BEGIN
                  Switch( A[sortstart-1 + r], A[sortstart-1 + 2*r+1] );
                  r := 2*r+1
                END
         ELSE (* A[sortstart-1 + r] doesn't violate the partially order tree prop *)
                r := tmpfinish-sortstart+1;
   END (* WHILE *)
END   (* PushDown *);

PROCEDURE HeapSort( VAR A : SortArray; first, last: integer );
   (* sorts A[first]..A[last] into non-decreasing order by pushing down the
      items not in the partial ordering of the tree in a systematic way.*)
VAR
   pos : integer; (* a cursor into A *)
BEGIN (* HeapSort *)
   FOR pos := (first-1) + ((last-first+1) DIV 2) DOWNTO first DO
       PushDown (A, first, pos, last);
   FOR pos := last DOWNTO first+1 DO BEGIN
       Switch (A[first], A[pos]) (* removes minimum from the heap *);
       PushDown (A, first, first, pos-1)
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
  (* keep track of last item in left half as things are rearranged *)
  lastsmall := lo;
  FOR i := lo+1 TO hi DO
      IF (A[i].key<piv) THEN
	 BEGIN
	   lastsmall := lastsmall+1;
           switch(A[lastsmall], A[i])
         END;
  (* put pivot in lastsmall position *)
  switch(A[lo], A[lastsmall]);
  pivloc := lastsmall
END   (* partition *);

(* recursive version *)
PROCEDURE quicksort( VAR A : sortarray; first, last : integer );
  (* partition the list into two halves and then call quicksort
     one each half to get job done *)
VAR pivloc : integer;
BEGIN (* quicksort *)
  IF (first<last) THEN
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
  REPEAT
    IF (nstack>0) THEN (* pop off the next two boundaries for partitioning *)
        BEGIN
          first := lostack[nstack]; last  := histack[nstack];
          nstack := nstack-1
        END;
    WHILE (first<last) (* AND (NOT error) *) DO BEGIN
       partition (A, first, last, pivloc);
       (* overflow check has been omitted since the two stacks are big
          enough even in worst cases
          IF (nstack>=maxstack) THEN
             BEGIN
               error := true; writeln('sort terminated, stack overflow')
             END
          ELSE *)
       IF (pivloc-first) < (last-pivloc) THEN
       (* push larger sublist boundaries onto stack and do smaller list *)
          BEGIN
	    nstack := nstack+1;      lostack[nstack] := pivloc+1;
            histack[nstack] := last; last := pivloc-1
          END
       ELSE
          BEGIN
            nstack := nstack+1;          lostack[nstack] := first;
            histack[nstack] := pivloc-1; first := pivloc+1
          END
    END (* WHILE *)
  UNTIL (nstack=0) (* OR error *)
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
  WHILE ( k<=j ) AND ( A[k].key=A[i].key ) DO k := k+1;
  IF ( k=j+1 ) THEN
     Pivot := 0   (* all keys were the same in this range *)
  ELSE IF ( A[k].key>A[i].key ) THEN
     Pivot := k
  ELSE (* A[k].key<A[i].key *)
     Pivot := i
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
   REPEAT
     Switch( A[left], A[right] );
     WHILE ( A[left].key<A[0].key ) DO left := left+1;
     WHILE ( A[right].key>=A[0].key ) DO right := right-1
   UNTIL ( left>right );
   PartitionBoundary := left
END   (* PartitionBoundary *);

PROCEDURE AltQuickSort( VAR A : SortArray; first, last: integer);

   (* Sorts A from A[first] to A[last] by the partition method; calls itself
      recursively on each part of the partition that results.               *)

VAR  pivindex, k : integer;

BEGIN (* AltQuickSort *)
  pivindex := Pivot( A, first, last );
  IF ( pivindex<>0 ) THEN (* there are still parts of the partition to sort *)
     BEGIN
       k := PartitionBoundary( A, first, last, pivindex );
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
  REPEAT
    IF (nstack>0) THEN (* pop both stacks *)
       BEGIN
         first := lostack[nstack];
         last := histack[nstack];
         nstack := nstack-1;
       END;
    pivindex := Pivot( A, first, last );
    WHILE (pivindex<>0) DO BEGIN
       k := PartitionBoundary( A, first, last, pivindex );
       IF (k-1-first)< (last-k ) THEN
          BEGIN
            nstack := nstack+1;
            lostack[nstack] := k; histack[nstack] := last;
            last := k-1;
          END
       ELSE
          BEGIN
            nstack := nstack+1;
            lostack[nstack] := first; histack[nstack] := k-1;
            first := k;
          END;
       pivindex := Pivot( A, first, last );
     END (* WHILE *)
   UNTIL (nstack=0)
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
  WHILE ( incr>0 ) DO BEGIN
    FOR i := (incr+first) TO last DO BEGIN
        j := i-incr;
        WHILE ( j >first-1) DO
          IF ( A[j].key>A[j+incr].key ) THEN
             BEGIN
               Switch( A[j], A[j+incr] );
               j := j-incr
             END (* if two items are out of order *)
          ELSE
             j := first-1 (* forces end of inner WHILE loop: no more to do *)
    END (* FOR i *);
    incr := ( incr DIV 2 )
  END   (* WHILE *)
END   (* ShellSort *);






































(*---------------------------------------------------------------------------*)
(* PART B: Using indices for sorting:

Comment : If the  records  involved  are very large data  structures, it is not
	  really a good idea to switch whole records often. Rather  one  should
keep an array of the type:

                  IndexType = array[0..sortlim] of 0..sortlim

which at the start of the sort is initialized so  that  its  index  is also its
value.  And one can use this array  to  keep  track  of the switches. Here is a
sample of what is meant:

PROCEDURE SwitchInd ( VAR ind1, ind2 : integer );
VAR temp : integer;
BEGIN
   temp := ind1; ind1 := ind2; ind2 := temp
END;

PROCEDURE InitInd( VAR ind : IndexType; first, last : integer );
VAR j : integer;
BEGIN
   FOR j := first TO last DO ind[j] := j
END;

PROCEDURE BubbleSortInd( A:SortArray; VAR ind:IndexType; first,last:integer );
VAR pass, pos, swcnt : integer;
BEGIN
  InitInd ( ind, first, last );
  pass := first;
  REPEAT
    swcnt := 0;
    FOR pos := first TO (last+first-1) - pass DO
        IF ( A[ind[pos]].key>A[ind[pos+1]].key ) THEN BEGIN
           SwitchInd( ind[pos], ind[pos+1] );
           swcnt := swcnt+1
        END;
    pass := pass+1
  UNTIL (swcnt=0) or (pass>=last)
END;

   Note how the comparison is written: A[ind[pos]].key > A[ind[pos+1]].key
   This notation can be very confusing unless it is thought out. Note, too,
   that the indices are switched, not the records.

   This method of sorting will result in:

	A[ind[first]].key <= A[ind[first+1]].key <= ... <= A[ind[last]].key

   and the corresponding records can then be sent to some file or other proce-
   dure and processed accordingly, e.g., sent to a file of recordtype in the
   appropriate order.

Questions:

1. Rewrite the other sorts in part A using index switching instead of record
   switching.

2. Write the appropriate procedure for sending to output the list of all
   elements from first to last in their sorted order.  *)






(* ------------------------------------------------------------------------- *)
