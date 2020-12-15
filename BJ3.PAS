edit blackjack3.pas
c
PROGRAM BlackJack3 (input,output);
    {plays a game of blackjack and keeps track of cards dealt}

TYPE Dlt=Array[1..13,1..3] OF Boolean;
     Cd=Array[1..2] OF integer;

VAR Card: Cd;
    CardsDealt: Dlt;
    PlayerTotal,DealerTotal: integer;
    Play,HitOrStand: char;

%INCLUDE 'Frands.Pas'

(**************************************************************************)

   PROCEDURE ShuffleDeck(var Card: Cd;
                         var CardsDealt: Dlt);
       {initializes and shuffles the deck of cards}

   VAR Counter1,Counter2: integer;

   BEGIN  {Shuffle}
      FOR Counter1 := 1 TO 13 DO
          FOR Counter2 := Counter1 TO 4 DO
              CardsDealt[Counter1,Counter2] := False;
      FOR Counter1 := 1 to 2 DO
          Card[Counter1] := 0;
   END;  {Shuffle}
(**************************************************************************)

   PROCEDURE AskToPlay(var Play: char);
        {asks user if he wants to play}

   BEGIN  {AskToPlay}
      Writeln('Psssst !! HEY BUD, want to play a game ?');
      Readln(Play);
   END;  {AskToPlay}
(**************************************************************************)

   PROCEDURE Deal(var Card: Cd);
        {Deals a card using random functions}

   BEGIN  {Deal}
      Card[1] := Rand1(1,13);
      Card[2] := Rand1(1,4);
   END;  {Deal}
(**************************************************************************)

   FUNCTION Dealt(Card: Cd;CardsDealt: Dlt): Boolean;
        {Checks to see if a card has already been dealt or not}

   VAR CardNum,CardSuite: integer;

   BEGIN  {Dealt}
      CardNum := Card[1];
      CardSuite := Card[2];
      IF CardsDealt[CardNum,CardSuite]  = True
      THEN Dealt := True
   END;  {Dealt}
(***************************************************************************)

   PROCEDURE Post (Card: Cd;
                   var CardsDealt: Dlt);
       {Updates the CardsDealt table with the current card}

   VAR CardNum,CardSuite: integer;

   BEGIN  {Post}
      CardNum := Card[1];
      CardSuite := Card[2];
      CardsDealt[CardNum,CardSuite] := True;
   END  {Post}
(**************************************************************************)

   PROCEDURE Show (Card: Cd);
        {Shows user actual card dealt}

   BEGIN  {Show}
      CASE Card[1] OF
          1: Write('Ace');
          2: Write('2');
          3: Write('3');
          4: Write('4');
          5: Write('5');
          6: Write('6');
          7: Write('7');
          8: Write('8');
          9: Write('9');
         10: Write('10');
         11: Write('Jack');
         12: Write('Queen');
         13: Write('King')
     END;  {CASE}
     Write(' OF ');
     CASE Card[2] OF
         1: Writeln ('Spades');
         2: Writeln ('Hearts');
         3: Writeln ('Clubs');
         4: Writeln ('Diamonds')
     END;  {CASE}
   END;  {Show}
(**************************************************************************)

   PROCEDURE CheckHand(var PlayerTotal: integer;
                       var HitOrStand: char;
                           Card: Cd);
          {Totals hand and checks to see if it is over 21}

   BEGIN  {CheckHand}
      PlayerTotal := PlayerTotal + Card[1];
      IF PlayerTotal > 21
      THEN BEGIN  {IF-THEN}
              Writeln('You Busted - You Lose');
              HitOrStand := 'Y';
           END  {IF-THEN}
      ELSE BEGIN  {ELSE}
              Writeln('Hit Or Stand');
              Readln(HitOrStand);
           END;  {ELSE}
   END;  {CheckHand}
(**************************************************************************)

   PROCEDURE DecideWinner(PlayerTotal,DealerTotal: integer);
       {Determines who won}

   BEGIN  {DecideWinner}
      IF DealerTotal > 21
      THEN Writeln('I Busted - You Win')
      ELSE IF DealerTotal < PlayerTotal
           THEN Writeln('You Win !!!!!!!!!!!!!!!!!!')
           ELSE Writeln('I Win !!!!!!!!!!!!');
   END;  {DecideWinner}

(********************************  MAIN  ************************************)

BEGIN  {BlackJack3}
   Play := 'Y'
   PlayerTotal := 0;
   DealerTotal := 0;
   ShuffleDeck(Card,CardsDealt);
   WHILE (Play = 'Y') DO
      BEGIN   {WHILE}
         AskToPlay(Play);
         IF (Play = 'Y')
         THEN  BEGIN  {IF-THEN}
                  REPEAT
                      Deal(Card);
                      WHILE Dealt(Card,CardsDealt) DO
                         Deal(Card);
                      Post(Card,CardsDealt);
                      Show(Card);
                      CheckHand(PlayerTotal,HitOrStand,Card);
                  UNTIL  (HitOrStand = 'Y');
                  IF PlayerTotal <= 21
                  THEN BEGIN  {Nested IF-THEN}
                          Writeln('Now its my turn SNICKER SNICKER');
                          REPEAT
                             Deal(Card);
                             WHILE Dealt(Card,CardsDealt) DO
                                Deal(Card);
                             Post(Card,CardsDealt);
                             Show(Card);
                             DealerTotal := DealerTotal + Card[1];
                          UNTIL (DealerTotal >= 14);
                       END;  {Nested IF-THEN}
               END;  {IF-THEN}
      END;  {WHILE}
END.  {BlackJack3}
