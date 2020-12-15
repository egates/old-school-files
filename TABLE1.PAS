TYPE  Node = RECORD
                 Key: Key_Type;
                 Val: Value_Type;
                 Next: ^Node;
             END;   {Record}
      Table_type = ^Node;

(********************************************************************)
FUNCTION InRange(KeyVal: Key_Type): Boolean;
    {Checks to see if key is in range of Lo to Hi}

BEGIN
   InRange := (KeyVal < Hi_Sentinel) AND (KeyVal > Lo_Sentinel)
END;  {InRange}

(********************************************************************)

PROCEDURE create (VAR table : table_type);
  {initialize table to empty}
BEGIN
  writeln('Hello from create');
  Table := Nil;
END;
(********************************************************************)

FUNCTION insert (keyval : key_type;
                 val    : value_type;
                 VAR T  : table_type): boolean;
  {Cause table T to associate val to keyval in T,  either  by  creating  a  new
   entry in T if there is  nothing there associated with  keyval  or  by  over-
   writing any previous association  with  keyval.  Return FALSE and do nothing
   if the key is out of range or if there is no room; return TRUE if the inser-
   tion was successful.  NOTE: It is assumed that there  is  an  order  to  the
   storing so that the keys in some way go from low to high. }

VAR NewNode: Table_Type;
    Ptr    : Table_Type;
    PlaceFound: Boolean;

BEGIN {Insert}
  writeln('Hello from insert');
  IF InRange(KeyVal)
  THEN BEGIN  {If InRange}
         New(NewNode);
         NewNode^.Val := Val;
         NewNode^.Key := KeyVal;
         NewNode^.Next := Nil;
         IF T = Nil
         THEN BEGIN  {NewTable}
                T := NewNode;
                Insert := True;
              END  {NewTable}
         ELSE BEGIN {Not Empty(T)}
                IF (KeyVal <= T^.Key)
                THEN IF KeyVal = T^.Key
                     THEN BEGIN  {replace val}
                            T^.Val := Val;
                            Insert := True;
                            Dispose(NewNode);
                          END  {Replace}
                      ELSE  BEGIN  {INSERT}
                              NewNode^.Next := T;
                              T := NewNode;
                              Insert := True;
                            END {insert}
                ELSE  BEGIN {Insert in mid of end}
                        Ptr := T;
                        PlaceFound := False;
                        WHILE (Ptr^.Next <> NIL) AND NOT PlaceFound DO
                           IF KeyVal >= Ptr^.Next^.Key
                           THEN Ptr := Ptr^.Next
                           ELSE PlaceFound := True;
                        IF KeyVal = Ptr^.Key
                        THEN BEGIN  {REPLACE}
                               Insert := True;
                               Ptr^.Val := Val;
                               Dispose(NewNode);
                             END  {Replace}
                        ELSE BEGIN {INSERT}
                               NewNode^.Next := Ptr^.Next;
                               Ptr^.Next := NewNode;
                               Insert := True;
                             END;  {insert}
                      END; {ELSE}
              END;{ELSE}
       END {InRange}
  ELSE Insert := False;
END; {Insert}
(********************************************************************)

FUNCTION delete (keyval : key_type; VAR T : table_type): boolean;
  {Search table T to see whether keyval is present (including a check to see
   if keyval is in range). If it is present then remove it and all information
   associated with it and return TRUE, else return FALSE }

VAR Current : Table_Type;
    Backup  : Table_Type;

BEGIN
  writeln('Hello from delete');
  IF InRange(Key)
  THEN BEGIN  {InRange}
         Current := T;
         Backup  := Nil;
         WHILE (Current^.Key <> KeyVal) AND (Current <> Nil) DO
           BEGIN  {WHILE}
             Backup := Current;
             Current := Current^.Next;
           END;  {WHILE}
         IF (Current = Nil)
         THEN Delete := False
         ELSE BEGIN  {In Table}
                IF (Backup = Nil)
                THEN T := T^.Next
                ELSE Backup^.Next := Current^.Next;
                Dispose(Current);
                Delete := True;
              END; {In Table}
       END  {InRange}
  ELSE Delete := False;
END;  {Delete}
(********************************************************************)

FUNCTION retrieve (keyval  : key_type; VAR val : value_type;
                   VAR T   : table_type): boolean;
 {Search table T to see whether keyval is present (including whether it is in
  range). If it is present , set val to the associated value and return TRUE,
  else return FALSE; in any event, leave T unchanged; NOTE: T is passed as a
  VAR parameter merely to avoid possibly expensive copying}

VAR Current : Table_Type;

BEGIN
  writeln('Hello from retrieve');
  IF InRange(Key)
  THEN BEGIN  {InRange}
         Current := T;
         WHILE (Current^.Key <> KeyVal) AND (Current <> Nil) DO
             Current := Current^.Next;
         IF (Current = Nil)
         THEN Retrieve := False
         ELSE BEGIN  {In Table}
                Val := Current^.Val;
                Retrieve := True;
              END; {In Table}
       END  {InRange}
  ELSE Retrieve := False;
END;
(********************************************************************)

PROCEDURE printkeys (VAR T: table_type);
 {Send to output, the keys in t, one to a line, each with its system default
  field widthand then send the string <eot> on its own line, 'as is'; if T is
  empty, print only the string  <eot>  on its own line, 'as is'. Again, T here
  is passed as a VAR parameter merely to avoid possibly expensive copying}

VAR Ptr: Table_Type;

BEGIN
  writeln('Hello from printkeys');
  Ptr := T;
  IF Ptr <> Nil
  THEN BEGIN
          REPEAT
             Writeln(Ptr^.Key);
             Ptr := Ptr^.Next;
          UNTIL (Ptr^.Next = Nil);
          Writeln(Ptr^.Key);
       END;  {if-then}
  Writeln('<eot>');
END;
