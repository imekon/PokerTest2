// MIT License
//
// Copyright (c) 2024 Pete Goodwin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

unit rulesitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, carditem, bucketitem;

type

  { TRules }

  TRules = class
  private
    m_cards: TCardList;

    procedure ClearScoring;

    function AllSameSuit: boolean;
    function IsRoyal: boolean;
    function IsInline: boolean;

    function IsRoyalFlush: boolean;
    function IsStraightFlush: boolean;
    function IsFourKind: boolean;
    function IsFullHouse: boolean;
    function IsFlush: boolean;
    function IsStraight: boolean;
    function IsThreeKind: boolean;
    function IsTwoPair: boolean;
    function IsPair: boolean;
    function IsHighCard: boolean;
  public
    constructor Create(list: TCardList);
    function Apply: TPokerScore;
    function Score: integer;
    function ScoreDescription(ascore: TPokerScore): string;
  end;

implementation

{ TRules }

const
  CardScoring: array [TCardIndex] of integer =
    (20, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10);

constructor TRules.Create(list: TCardList);
begin
  m_cards := list;
end;

procedure TRules.ClearScoring;
var
  card: TCard;

begin
  for card in m_cards do
    card.Scoring := false;
end;

function TRules.AllSameSuit: boolean;
var
  card: TCard;
  suit: TSuit;

begin
  suit := SUIT_OTHER;
  for card in m_cards do
  begin
    if suit = SUIT_OTHER then
    begin
      suit := card.Suit;
      continue;
    end;

    if suit <> card.Suit then
    begin
      result := false;
      exit
    end;
  end;

  result := true;
end;

function TRules.IsRoyal: boolean;
begin
  result := false;

  if m_cards.Count <> 5 then
    exit;

  if m_cards[0].CardIndex <> 0 then exit;  // ACE
  if m_cards[1].CardIndex <> 12 then exit; // KING
  if m_cards[2].CardIndex <> 11 then exit; // QUEEN
  if m_cards[3].CardIndex <> 10 then exit; // JACK
  if m_cards[4].CardIndex <> 9 then exit;  // TEN

  result := true;
end;

function TRules.IsInline: boolean;
var
  card: TCard;
  index: TCardIndex;
  first: boolean;

begin
  result := false;

  index := 0;
  first := true;

  for card in m_cards do
  begin
    if first then
    begin
      index := card.CardIndex;
      first := false;
    end
    else
      if index <> card.CardIndex then exit;

    if index = 0 then
      index := 12
    else
      dec(index);
  end;

  result := true;
end;

function TRules.IsRoyalFlush: boolean;
var
  ok: boolean;
  card: TCard;

begin
  result := false;

  ok := AllSameSuit;
  if not ok then exit;

  ok := IsRoyal;
  if not ok then exit;

  for card in m_cards do
    card.Scoring := true;

  result := true;
end;

function TRules.IsStraightFlush: boolean;
var
  ok: boolean;
  card: TCard;

begin
  result := false;

  ok := AllSameSuit;
  if not ok then exit;

  ok := m_cards.Count = 5;
  if not ok then exit;

  ok := IsInline;
  if not ok then exit;

  for card in m_cards do
    card.Scoring := true;

  result := true;
end;

function TRules.IsFourKind: boolean;
var
  ok: boolean;
  cardBuckets: TCardBucketResult;
  card: TCard;

begin
  result := false;

  ok := m_cards.Count >= 4;
  if not ok then exit;

  cardBuckets := TCardBucketResult.Create;
  cardBuckets.ProcessCards(m_cards);

  if not cardBuckets.Passed then exit;

  if (cardBuckets.buckets[1].Cards.Count = 4) then
  begin
    for card in cardBuckets.buckets[1].Cards do
      card.Scoring := true;

    result := true;
  end;

  if (CardBuckets.buckets[2].Cards.Count = 4) then
  begin
    for card in cardBuckets.buckets[2].Cards do
      card.Scoring := true;

    result := true;
  end;

  cardBuckets.Free;
end;

function TRules.IsFullHouse: boolean;
var
  ok: boolean;
  cardBuckets: TCardBucketResult;
  card: TCard;

begin
  result := false;
  ok := m_cards.Count = 5;
  if not ok then exit;

  cardBuckets := TCardBucketResult.Create;
  cardBuckets.ProcessCards(m_cards);

  if not cardBuckets.Passed then exit;

  if ((cardBuckets.buckets[1].Cards.Count = 3) and
     (cardBuckets.buckets[2].Cards.Count = 2)) or
     ((cardBuckets.buckets[1].Cards.Count = 2) and
     (cardBuckets.buckets[2].Cards.Count = 3)) then
  begin
    for card in m_cards do
      card.Scoring := true;

    result := true;
  end;

  cardBuckets.Free;
end;

function TRules.IsFlush: boolean;
var
  ok: boolean;
  card: TCard;

begin
  result := false;

  ok := AllSameSuit;
  if not ok then exit;

  ok := m_cards.Count = 5;
  if not ok then exit;

  for card in m_cards do
    card.Scoring := true;

  result := true;
end;

function TRules.IsStraight: boolean;
var
  ok: boolean;
  card: TCard;

begin
  result := false;

  ok := m_cards.Count = 5;
  if not ok then exit;

  ok := IsInline;
  if not ok then exit;

  for card in m_cards do
    card.Scoring := true;

  result := true;
end;

function TRules.IsThreeKind: boolean;
var
  ok: boolean;
  cardBuckets: TCardBucketResult;
  card: TCard;

begin
  result := false;

  ok := m_cards.Count >= 3;
  if not ok then exit;

  cardBuckets := TCardBucketResult.Create;
  cardBuckets.ProcessCards(m_cards);
  if not cardBuckets.Passed then exit;

  if (cardBuckets.buckets[1].Cards.Count = 3) then
  begin
    for card in cardBuckets.buckets[1].Cards do
      card.Scoring := true;

    result := true;
  end;

  if (cardBuckets.buckets[2].Cards.Count = 3) then
  begin
    for card in cardBuckets.buckets[2].Cards do
      card.Scoring := true;

    result := true;
  end;

  if (cardBuckets.buckets[3].Cards.Count = 3) then
  begin
    for card in cardBuckets.buckets[3].Cards do
      card.Scoring := true;

    result := true;
  end;
  cardBuckets.Free;
end;

function TRules.IsTwoPair: boolean;
var
  ok: boolean;
  cardBuckets: TCardBucketResult;
  card: TCard;

begin
  result := false;

  ok := m_cards.Count >= 4;
  if not ok then exit;

  cardBuckets := TCardBucketResult.Create;
  cardBuckets.ProcessCards(m_cards);
  if not cardBuckets.Passed then exit;

  if ((cardBuckets.buckets[1].Cards.Count = 2) and
     (cardBuckets.buckets[2].Cards.Count = 2)) then
  begin
    for card in cardBuckets.buckets[1].Cards do
      card.Scoring := true;

    for card in cardBuckets.buckets[2].Cards do
      card.Scoring := true;

    result := true;
  end;

  if ((cardBuckets.buckets[1].Cards.Count = 2) and
     (cardBuckets.buckets[3].Cards.Count = 2)) then
  begin
    for card in cardBuckets.buckets[1].Cards do
      card.Scoring := true;

    for card in cardBuckets.buckets[3].Cards do
      card.Scoring := true;

    result := true;
  end;

  if ((cardBuckets.buckets[2].Cards.Count = 2) and
     (cardBuckets.buckets[3].Cards.Count = 2)) then
  begin
    for card in cardBuckets.buckets[2].Cards do
      card.Scoring := true;

    for card in cardBuckets.buckets[3].Cards do
      card.Scoring := true;

    result := true;
  end;
  cardBuckets.Free;
end;

function TRules.IsPair: boolean;
var
  ok: boolean;
  cardBuckets: TCardBucketResult;
  card: TCard;

begin
  result := false;

  ok := m_cards.Count >= 2;
  if not ok then exit;

  cardBuckets := TCardBucketResult.Create;
  cardBuckets.ProcessCards(m_cards);
  if not cardBuckets.Passed then exit;

  if ((cardBuckets.buckets[1].Cards.Count = 2) and
     (cardBuckets.buckets[2].Cards.Count <= 1) and
     (cardBuckets.buckets[3].Cards.Count <= 1) and
     (cardBuckets.buckets[4].Cards.Count <= 1)) then
  begin
    for card in cardBuckets.buckets[1].Cards do
      card.Scoring := true;

    result := true;
  end;

  if ((cardBuckets.buckets[1].Cards.Count <= 1) and
     (cardBuckets.buckets[2].Cards.Count = 2) and
     (cardBuckets.buckets[3].Cards.Count <= 1) and
     (cardBuckets.buckets[4].Cards.Count <= 1)) then
  begin
    for card in cardBuckets.buckets[2].Cards do
      card.Scoring := true;

    result := true;
  end;

  if ((cardBuckets.buckets[1].Cards.Count <= 1) and
     (cardBuckets.buckets[2].Cards.Count <= 1) and
     (cardBuckets.buckets[3].Cards.Count = 2) and
     (cardBuckets.buckets[4].Cards.Count <= 1)) then
  begin
    for card in cardBuckets.buckets[3].Cards do
      card.Scoring := true;

    result := true;
  end;

  if ((cardBuckets.buckets[1].Cards.Count <= 1) and
     (cardBuckets.buckets[2].Cards.Count <= 1) and
     (cardBuckets.buckets[3].Cards.Count <= 1) and
     (cardBuckets.buckets[4].Cards.Count = 2)) then
  begin
    for card in cardBuckets.buckets[4].Cards do
      card.Scoring := true;

    result := true;
  end;
  cardBuckets.Free;
end;

function TRules.IsHighCard: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := m_cards.Count >= 1;
  if not ok then exit;

  m_cards[0].Scoring := true;

  result := true;
end;

function TRules.Apply: TPokerScore;
begin
  ClearScoring;

  if IsRoyalFlush then
    result := ROYAL_FLUSH
  else if IsStraightFlush then
    result := STRAIGHT_FLUSH
  else if IsFourKind then
    result := FOUR_OF_A_KIND
  else if IsFullHouse then
    result := FULL_HOUSE
  else if IsFlush then
    result := FLUSH
  else if IsStraight then
    result := STRAIGHT
  else if IsThreeKind then
    result := THREE_OF_A_KIND
  else if IsTwoPair then
    result := TWO_PAIRS
  else if IsPair then
    result := PAIR
  else if IsHighCard then
    result := HIGH_CARD
  else
    result := NO_SCORE;
end;

function TRules.Score: integer;
var
  card: TCard;
  total: integer;

begin
  total := 0;
  for card in m_cards do
  begin
    if card.Scoring then
    begin
      total := total + CardScoring[card.CardIndex];
    end;
  end;

  result := total;
end;

function TRules.ScoreDescription(ascore: TPokerScore): string;
begin
  case ascore of
    ROYAL_FLUSH: result := 'Royal Flush';
    STRAIGHT_FLUSH: result := 'Straight Flush';
    FOUR_OF_A_KIND: result := 'Four of a Kind';
    FULL_HOUSE: result := 'Full House';
    FLUSH: result := 'Flush';
    STRAIGHT: result := 'Straight';
    THREE_OF_A_KIND: result := 'Three of a Kind';
    TWO_PAIRS: result := 'Two Pairs';
    PAIR: result := 'Pair';
    HIGH_CARD: result := 'High Card';
  end;
end;

end.

