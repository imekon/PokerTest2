unit rulesitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, carditem;

type

  { TRules }

  TRules = class
  private
    m_cards: TCardList;

    function AllSameSuit: boolean;
    function IsRoyal: boolean;
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
  end;

implementation

{ TRules }

constructor TRules.Create(list: TCardList);
begin
  m_cards := list;
end;

function TRules.AllSameSuit: boolean;
var
  card: TCard;
  suit: TSuit;

begin
  suit := SUIT_OTHER;
  for card in m_cards do
  begin
    if not card.Selected then continue;

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

function TRules.IsRoyalFlush: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := AllSameSuit;
  if not ok then exit;

  ok := IsRoyal;
  if not ok then exit;

  result := true;
end;

function TRules.IsStraightFlush: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := AllSameSuit;
  if not ok then exit;

  ok := m_cards.Count = 5;
  if not ok then exit;

  // ...

  result := true;
end;

function TRules.IsFourKind: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := m_cards.Count = 4;
  if not ok then exit;

  // ...

  result := true;
end;

function TRules.IsFullHouse: boolean;
var
  ok: boolean;

begin
  ok := m_cards.Count = 5;
  if not ok then exit;

  // ...

  result := true;

end;

function TRules.IsFlush: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := AllSameSuit;
  if not ok then exit;

  ok := m_cards.Count = 5;
  if not ok then exit;

  // ...

  result := true;
end;

function TRules.IsStraight: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := m_cards.Count = 5;
  if not ok then exit;

  // ...

  result := true;
end;

function TRules.IsThreeKind: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := m_cards.Count = 3;
  if not ok then exit;

  // ...

  result := true;

end;

function TRules.IsTwoPair: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := m_cards.Count = 4;
  if not ok then exit;

  // ...

  result := true;

end;

function TRules.IsPair: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := m_cards.Count = 2;
  if not ok then exit;

  // ...

  result := true;

end;

function TRules.IsHighCard: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := m_cards.Count = 1;
  if not ok then exit;

  // ...

  result := true;

end;

function TRules.Apply: TPokerScore;
begin
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
    result := TWO_PAIR
  else if IsPair then
    result := PAIR
  else
    result := HIGH_CARD;
end;

end.

