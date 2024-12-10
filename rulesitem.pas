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

begin
  result := false;

  index := 0; // ACE, which isn't legal for this (legal for Royal)

  for card in m_cards do
  begin
    if index = 0 then
      index := card.CardIndex
    else
      if index <> card.CardIndex then exit;

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
     (cardBuckets.buckets[2].Cards.Count = 1) and
     (cardBuckets.buckets[3].Cards.Count = 1) and
     (cardBuckets.buckets[4].Cards.Count = 1)) then
  begin
    for card in cardBuckets.buckets[1].Cards do
      card.Scoring := true;

    result := true;
  end;

  if ((cardBuckets.buckets[1].Cards.Count = 1) and
     (cardBuckets.buckets[2].Cards.Count = 2) and
     (cardBuckets.buckets[3].Cards.Count = 1) and
     (cardBuckets.buckets[4].Cards.Count = 1)) then
  begin
    for card in cardBuckets.buckets[2].Cards do
      card.Scoring := true;

    result := true;
  end;

  if ((cardBuckets.buckets[1].Cards.Count = 1) and
     (cardBuckets.buckets[2].Cards.Count = 1) and
     (cardBuckets.buckets[3].Cards.Count = 2) and
     (cardBuckets.buckets[4].Cards.Count = 1)) then
  begin
    for card in cardBuckets.buckets[3].Cards do
      card.Scoring := true;

    result := true;
  end;

  if ((cardBuckets.buckets[1].Cards.Count = 1) and
     (cardBuckets.buckets[2].Cards.Count = 1) and
     (cardBuckets.buckets[3].Cards.Count = 1) and
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

end.

