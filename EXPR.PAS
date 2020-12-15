(***********************************************************************)

FUNCTION Precedence(Tok, Op: String): boolean;
    {returns true if p(tok) <= p(Op)}

BEGIN {Precedence}
   CASE Tok OF
     PLUS,MINUS: Precedence := True;
     STAR,SLASH: Precedence := Op IN [CARET,STAR,SLASH];
     CARET     : Precedence := Op = CARET;
   END;  {CASE}
END;  {Precedence}
(***********************************************************************)

PROCEDURE ProcessExpr(var S:StackType);
   {Process tokens into a tree on a stack}

VAR Tree,Tree1,T,T0,T1,T2,T3,T4,T5: TreeType;
    Tok: String;

BEGIN  {ProcessExpr}
   NEW(Tree);
   Tree^.Node := LPAREN;
   Push(Tree,S);
   REPEAT
      GetTok(Tok);
      IF IsComment(Tok)
      THEN  {NOTHING}
      ELSE IF IsReal(Tok) OR IsVar(Tok)
           THEN BEGIN
                   New(Tree);
                   Tree^.Node := Tok;
                   Push(Tree,S);
                END
           ELSE IF Tok IN [PLUS,MINUS,STAR,SLASH,CARET]
                THEN IF NOT PopCheck(Tree,S)
                     THEN Error('Error')
                     ELSE BEGIN
                            New(T1);
                            T1 := Tree;
                            IF NOT PopCheck(Tree,S)
                            THEN BEGIN
                                   New(Tree1);
                                   Tree1^.Node := Tok;
                                   Tree1^.Left := T1;
                                   Push(Tree1,S);
                                 END
                            ELSE BEGIN
                                   New(T2);
                                   T2 := Tree;
                                   IF Precedence(Tok,T2^.Node)
                                    {p(tok) <= p(t2)}
                                   THEN BEGIN
                                          New(T3);
                                          T2^.Right := T1;
                                          T3 := T2;
                                          New(T4);
                                          T4^.Node := Tok;
                                          T4^.Left := T3;
                                          Push(T4,S);
                                        END
                                   ELSE BEGIN
                                          Push(T2);
                                          New(T5);
                                          T5^.Node := Tok;
                                          T5^.Left := T1;
                                          Push(T5);
                                        END;
                                 END;
                          END
                ELSE IF (Tok = LPRAREN)
                     THEN BEGIN
                            New(Tree);
                            Tree^.Node := Tok;
                            Push(Tree,S);
                          END
                     ELSE IF Tok IN [RPAREN,DOLLAR,ENDFILE]
                          THEN BEGIN
                                 IF NOT PopCheck(Tree,S)
                                 THEN Error
                                 ELSE BEGIN
                                        New(T0);
                                        T0 := Tree;
                                        WHILE PopCheck(Tree,S) DO
                                          BEGIN
                                            T1 := Tree;
                                            New(T);
                                            T1^.Right := T0;
                                            T : T1;
                                            T0 := T;
                                          END;
                                        Junk := Pop(Tree,S);
                                        IF (Tree^.Node = LPAREN)
                                        THEN Junk := Push(T0,S)
                                        ELSE Error
                                      END;
                               END;
   UNTIL Tok IN [ENDFILE,DOLLAR];
END; {ProcessExpr}
(***********************************************************************)
