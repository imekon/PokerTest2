unit rulestest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, raylib, carditem, rulesitem;

type

  { PokerRulesTest }

  PokerRulesTest= class(TTestCase)
  published
    procedure EmptyList;
    procedure RoyalFlushScore;
  end;

implementation

procedure PokerRulesTest.EmptyList;
var
  list: TCardList;
  rules: TRules;
  score: TPokerScore;

begin
  list := TCardList.Create;
  rules := TRules.Create(list);
  score := rules.Apply;
  AssertTrue(score = NO_SCORE);
  list.Free;
end;

procedure PokerRulesTest.RoyalFlushScore;
var
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  texture: TTexture2D;

begin
  list := TCardList.Create;
  texture := GetShapesTexture;

  list.Add(TCard.Create(SUIT_SPADES, 0, texture));
  list.Add(TCard.Create(SUIT_SPADES, 12, texture));
  list.Add(TCard.Create(SUIT_SPADES, 11, texture));
  list.Add(TCard.Create(SUIT_SPADES, 10, texture));
  list.Add(TCard.Create(SUIT_SPADES, 9, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Royal Flush Spades', score = ROYAL_FLUSH);

  list.Clear;
  list.Add(TCard.Create(SUIT_CLUBS, 0, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 12, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 11, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 10, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 9, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Royal Flush Clubs', score = ROYAL_FLUSH);

  list.Free;
end;



initialization

  RegisterTest(PokerRulesTest);
end.

