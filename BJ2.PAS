type bj2.pas
PROGRAM BlackJack2 (input,output);
    {Plays a game of blackjack using random functions}

VAR Card,Play,Hit: char;
    PlayerTotal,DealerTotal: integer;

%INCLUDE 'Frands.pas'

(******************************************************************************)

   PROCEDURE Deal (var Card: char);
        {Deals cards using random functions in Frands.pas}

   VAR CardNumber: integer;

   BEGIN  {Deal}
      CardNumber := Rand1(1,13);
      CASE CardNumber OF 
         1: Card := 'A';
         2: Card := '2';
         3: Card := '3';
         4: Card := '4';
         5: Card := '5';
         6: Card := '6';
         7: Card := '7';
         8: Card := '8';
         9: Card := '9';
        10: Card := '1';
        11: Card := 'J';
        12: Card := 'Q';
        13: Card := 'K'
      END;  {case}
   END;  {Deal}
(**************************************************************************)

   FUNCTION Value(Card: char): integer;
       {Returns value of card dealt}

   CONST Zero = '0';

   BEGIN  {Value}
      CASE Card OF
         'A': Value:=11;
         '2','3','4','5','6','7','8','9': Value:=(ORD(Card) - (ORD(Zero)));
         '1','Q','K','J': Value:=10
      END;  {CASE}
   END;  {Value}
(**************************************************************************)

   PROCEDURE AskToPlay(var Play: char);
       {Asks user if he wants to play}

   BEGIN  {Ask}
      Writeln('Do you wish to play blackjack');
      Readln(Play);
   END;  {Ask}
(************************************************************************)

   PROCEDURE HitOrStand(var PlayerTotal: integer;
                        var Hit: char);
         {Asks user to stand or hit then keeps track of total}

   BEGIN  {HitOrStand}
      Writeln('Hit ? ');
      Readln(Hit);
      IF (Hit <> 'Y') 
      THEN BEGIN  {IF-THEN}
              Deal(Card);
              PlayerTotal := PlayerTotal + Value(Card)   
           END;  {IF-THEN}
   END;  {HitOrStand}
(****************************************************************************)

   PROCEDURE Show(Card: char);
       {Displays card to player}

   BEGIN  {Show}
     Writeln(Card);
   END;  {Show}
(****************************************************************************)

   PROCEDURE DealToDealer(var DealerTotal: integer);
       {deals cards to the dealer}

   VAR Card: char;

   BEGIN  {DealToDealer}
      Deal(Card);
      Write('Dealers Hand: ',Card:2);
      DealerTotal:=Value(Card);
      REPEAT
        Card:=' ';
        Deal(Card);
        Write(Card:2);
        DealerTotal:=DealerTotal + Value(Card);
      UNTIL (DealerTotal >= 14);
      Writeln;
   END;  {DealToDealer}
(*****************************************************************************)

   PROCEDURE DecideWinner(PlayerTotal,DealerTotal: integer);
       {Decides who the winner is}

   BEGIN {DecideWinner}
      IF ((DealerTotal > PlayerTotal) AND (DealerTotal <= 21) OR 
          (PlayerTotal > 21))
      THEN Writeln('Dealer Wins');
      IF ((PlayerTotal > DealerTotal) AND (PlayerTotal <= 21) OR
          (DealerTotal > 21))
      THEN Writeln('Player Wins');
      IF (PlayerTotal = DealerTotal)
      THEN Writeln('PUSH');
    END;  {DecideWinner}
(*********************************** MAIN  **********************************)


BEGIN  {BlackJack2}
   Play := 'Y';
   PlayerTotal := 0;
   DealerTotal := 0;
   Card:= ' ';
   WHILE (Play = 'Y') DO
     BEGIN  {While}
        AskToPlay(Play);
        IF  (Play = 'Y') 
        THEN BEGIN  {THEN}
                Deal(Card);
                Show(Card);
                PlayerTotal := Value(Card);
                HitOrStand(PlayerTotal,Hit);
                While (Hit <> 'N') DO
                   BEGIN  {While}
                      Deal(Card);
                      Show(Card);
                      HitOrStand(PlayerTotal,Hit)
                   END;  {While}
                DealToDealer(DealerTotal);
                DecideWinner(PlayerTotal,DealerTotal);
             END;  {IF-THEN}
     END;  {While}
END.  {BlackJack2}
  
$ 