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
    procedure StraightFlushScore;
    procedure FourKindScore;
    procedure FullHouseScore;
    procedure FlushScore;
    procedure StraightScore;
    procedure StraightScore2;
    procedure ThreeOfAKindScore;
    procedure TwoPairsScore;
    procedure PairScore;
    procedure HighScore;
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
  card: TCard;
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  total: integer;
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
  total := rules.Score;
  rules.Free;
  AssertTrue('Royal Flush Spades', score = ROYAL_FLUSH);
  AssertTrue('Royal Flush score', total = 20 + 10 + 10 + 10 + 10);
  for card in list do
    AssertTrue('Scoring', card.Scoring);

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
  for card in list do
    AssertTrue('Scoring', card.Scoring);

  list.Clear;
  list.Add(TCard.Create(SUIT_HEARTS, 0, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 12, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 11, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 10, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 9, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Royal Flush Hearts', score = ROYAL_FLUSH);
  for card in list do
    AssertTrue('Scoring', card.Scoring);

  list.Clear;
  list.Add(TCard.Create(SUIT_DIAMONDS, 0, texture));
  list.Add(TCard.Create(SUIT_DIAMONDS, 12, texture));
  list.Add(TCard.Create(SUIT_DIAMONDS, 11, texture));
  list.Add(TCard.Create(SUIT_DIAMONDS, 10, texture));
  list.Add(TCard.Create(SUIT_DIAMONDS, 9, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Royal Flush Clubs', score = ROYAL_FLUSH);
  for card in list do
    AssertTrue('Scoring', card.Scoring);

  list.Clear;
  list.Add(TCard.Create(SUIT_CLUBS, 0, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 12, texture));
  list.Add(TCard.Create(SUIT_SPADES, 11, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 10, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 9, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Royal Flush mismatching suit', score <> ROYAL_FLUSH);

  list.Clear;
  list.Add(TCard.Create(SUIT_CLUBS, 0, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 12, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 11, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 10, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 8, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Royal Flush mismatching sequence', score <> ROYAL_FLUSH);

  list.Free;
end;

procedure PokerRulesTest.StraightFlushScore;
var
  card: TCard;
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  texture: TTexture2D;

begin
  list := TCardList.Create;
  texture := GetShapesTexture;

  list.Add(TCard.Create(SUIT_SPADES, 12, texture));
  list.Add(TCard.Create(SUIT_SPADES, 11, texture));
  list.Add(TCard.Create(SUIT_SPADES, 10, texture));
  list.Add(TCard.Create(SUIT_SPADES, 9, texture));
  list.Add(TCard.Create(SUIT_SPADES, 8, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Straight Flush Spades', score = STRAIGHT_FLUSH);
  for card in list do
    AssertTrue('Scoring', card.Scoring);

  list.Free;
end;

procedure PokerRulesTest.FourKindScore;
var
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  texture: TTexture2D;

begin
  list := TCardList.Create;
  texture := GetShapesTexture;

  list.Add(TCard.Create(SUIT_SPADES, 9, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 9, texture));
  list.Add(TCard.Create(SUIT_DIAMONDS, 9, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 9, texture));
  list.Add(TCard.Create(SUIT_SPADES, 7, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Four of a kind', score = FOUR_OF_A_KIND);

  list.Free;
end;

procedure PokerRulesTest.FullHouseScore;
var
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  texture: TTexture2D;

begin
  list := TCardList.Create;
  texture := GetShapesTexture;

  list.Add(TCard.Create(SUIT_SPADES, 9, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 9, texture));
  list.Add(TCard.Create(SUIT_DIAMONDS, 8, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 8, texture));
  list.Add(TCard.Create(SUIT_SPADES, 8, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Full House', score = FULL_HOUSE);

  list.Free;
end;

procedure PokerRulesTest.FlushScore;
var
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  texture: TTexture2D;

begin
  list := TCardList.Create;
  texture := GetShapesTexture;

  list.Add(TCard.Create(SUIT_HEARTS, 9, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 7, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 6, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 4, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 2, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Flush', score = FLUSH);

  list.Free;
end;

procedure PokerRulesTest.StraightScore;
var
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  texture: TTexture2D;

begin
  list := TCardList.Create;
  texture := GetShapesTexture;

  list.Add(TCard.Create(SUIT_HEARTS, 9, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 8, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 7, texture));
  list.Add(TCard.Create(SUIT_SPADES, 6, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 5, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Straight', score = STRAIGHT);

  list.Free;
end;

procedure PokerRulesTest.StraightScore2;
var
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  texture: TTexture2D;

begin
  list := TCardList.Create;
  texture := GetShapesTexture;

  list.Add(TCard.Create(SUIT_HEARTS, 0, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 12, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 11, texture));
  list.Add(TCard.Create(SUIT_SPADES, 10, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 9, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Straight', score = STRAIGHT);

  list.Free;
end;

procedure PokerRulesTest.ThreeOfAKindScore;
var
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  texture: TTexture2D;

begin
  list := TCardList.Create;
  texture := GetShapesTexture;

  list.Add(TCard.Create(SUIT_HEARTS, 9, texture));
  list.Add(TCard.Create(SUIT_CLUBS, 9, texture));
  list.Add(TCard.Create(SUIT_SPADES, 9, texture));
  list.Add(TCard.Create(SUIT_SPADES, 6, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 5, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Three of a Kind', score = THREE_OF_A_KIND);

  list.Free;
end;

procedure PokerRulesTest.TwoPairsScore;
var
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  texture: TTexture2D;

begin
  list := TCardList.Create;
  texture := GetShapesTexture;

  list.Add(TCard.Create(SUIT_HEARTS, 9, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 9, texture));
  list.Add(TCard.Create(SUIT_SPADES, 8, texture));
  list.Add(TCard.Create(SUIT_SPADES, 8, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 5, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Two pairs', score = TWO_PAIRS);

  list.Free;
end;

procedure PokerRulesTest.PairScore;
var
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  texture: TTexture2D;

begin
  list := TCardList.Create;
  texture := GetShapesTexture;

  list.Add(TCard.Create(SUIT_HEARTS, 9, texture));
  list.Add(TCard.Create(SUIT_SPADES, 9, texture));
  list.Add(TCard.Create(SUIT_SPADES, 8, texture));
  list.Add(TCard.Create(SUIT_SPADES, 7, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 5, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Pair', score = PAIR);

  list.Clear;
  list.Add(TCard.Create(SUIT_SPADES, 8, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 8, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('Pair', score = PAIR);

  list.Free;
end;

procedure PokerRulesTest.HighScore;
var
  list: TCardList;
  rules: TRules;
  score: TPokerScore;
  texture: TTexture2D;

begin
  list := TCardList.Create;
  texture := GetShapesTexture;

  list.Add(TCard.Create(SUIT_HEARTS, 11, texture));
  list.Add(TCard.Create(SUIT_SPADES, 9, texture));
  list.Add(TCard.Create(SUIT_SPADES, 8, texture));
  list.Add(TCard.Create(SUIT_SPADES, 7, texture));
  list.Add(TCard.Create(SUIT_HEARTS, 5, texture));
  rules := TRules.Create(list);
  score := rules.Apply;
  rules.Free;
  AssertTrue('High', score = HIGH_CARD);
  AssertTrue('Scoring', list[0].Scoring);
  list.Free;
end;

initialization

  RegisterTest(PokerRulesTest);
end.

