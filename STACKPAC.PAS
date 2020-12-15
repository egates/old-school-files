(* Adapted from umb$disk2:[math.cs210.calc]oldstp2.pas *)

TYPE
   StackEltType = TreeType;
   Snode = RECORD
             Item : StackEltType;
             Prev : ^Snode
           END;
   StackType = ^Snode;
(***********************************************************************)

PROCEDURE Make (VAR S : StackType );
  (* set up an empty stack *)

BEGIN (* make *)
   S := NIL
END   (* make *);
(***********************************************************************)

FUNCTION Push (X : StackEltType;
               VAR S : StackType ) : boolean;
  (* put x on the stack s -- it always returns true *)

VAR Tmp : StackType;

BEGIN (* push *)
  New(Tmp);
  Tmp^.Item := X;
  Tmp^.Prev := S;
  S := Tmp;
  Push := TRUE
END   (* push *);
(***********************************************************************)

FUNCTION Pop ( VAR X : StackEltType;
               VAR S : StackType ) : boolean;

   (* return in x the top element of stack s and remove the top
      element from s -- note error checking *)

VAR Tmp : StackType;

BEGIN (* pop *)
  IF (S=NIL)
  THEN Pop := FALSE
  ELSE
     BEGIN
       X := S^.Item;
       Tmp := S;
       S := S^.Prev;
       Dispose(Tmp);
       Pop := TRUE
     END
END   (* pop *);
(***********************************************************************)

FUNCTION PopCheck(var X: TreeType;
                  var S: StackType): boolean;
    {returns false if tos = ( else return true}

BEGIN  {PopCheck}
   IF NOT Pop(X,S)
   THEN Error('Error')
   ELSE IF (X^.Node = LPAREN)
        THEN BEGIN
                PopCheck := False;
                Push(X,S);
             END
        ELSE PopCheck := True;
END;  {PopCheck}
(***********************************************************************)
