(* Adapted from umb$disk2:[math.cs210.queue]queuepack1.pas *)

TYPE
 QEltType = String;
 QPtrType = ^Qnode;
 Qnode = RECORD
           Item : QEltType;
           Next : QPtrType;
         END;
 Qtype = RECORD
           Front, Back : QPtrType;
         END;
(***********************************************************************)

PROCEDURE MakeQueue (VAR Q : Qtype);
   (* sets up empty que *)

BEGIN (* makequeue *)
  WITH Q DO
    BEGIN
      Front := NIL;
      Back := Front
    END
END   (* makequeue *);
(***********************************************************************)

FUNCTION EmptyQueue ( Q : Qtype ) : boolean;
 (* returns true if and only if the queue is empty *)

BEGIN
  EmptyQueue := Q.Front = NIL
END;
(***********************************************************************)

FUNCTION FullQueue ( Q : Qtype ) : boolean;
  (* always returns false because of pointer implementation *)

BEGIN
  FullQueue := FALSE
END;
(***********************************************************************)

PROCEDURE EnQueue ( Elmt : QEltType;
                    VAR Q : Qtype );
   (* puts item at back of q *)

VAR  Temp : QPtrType;

BEGIN (* enque *)
   WITH Q DO BEGIN
                  (* put info in temp *)
     New( Temp );
     Temp^.Item := Elmt;
     Temp^.Next := NIL;
                  (* attach temp to q *)
     IF (Back=NIL)
     THEN Front := Temp
     ELSE Back^.Next := Temp;
           (* in either event make back point to latest entry *)
     Back := Temp
   END (* WITH *)
END   (* enqueue *);
(***********************************************************************)

PROCEDURE DeQueue( VAR Elmt : QEltType;
                   VAR Q : Qtype );
   (* returns front of q in item *)

VAR Temp : QptrType;

BEGIN (* dequeue *)
   WITH Q DO BEGIN
                 (* set up for disposal of front *)
     Temp := Front;
                 (* put data from front in item *)
     Elmt := Front^.Item;
     Front := Front^.Next;
     IF (Front=NIL)
     THEN Back := NIL;  (* queue is empty again *)
             (* return old front, now in temp, to free space *)
     Dispose(Temp)
   END
END (* dequeue *);
(***********************************************************************)

PROCEDURE PrintQ( Q: Qtype);
     (* prints the queue *)

VAR Tmp: QPtrType;

BEGIN  (* printq *)
  Tmp := Q.Front;
  WHILE Tmp.Front <> Nil DO
    BEGIN
       PutStr(Tmp.Front^.Item,STDOUT,80);
       Tmp := Tmp.Front^.Next;
    END
    PutStr(Tmp.Front^.Item,STDOUT);
    Putc(LESS);Putc(lete);Putc(leto);Putc(letq);Putc(Greater);
    Putc(Newline);
END;  (* printq *)
