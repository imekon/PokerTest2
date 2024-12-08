unit handitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, carditem;

type

  { THand }

  THand = class
  private
    m_cards: TCardList;
    function AllSameSuit: boolean;
    function SelectedCount: integer;
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
    constructor Create;
    destructor Destroy; override;
    procedure Add(acard: TCard);
    procedure Sort;
    function ApplyPokerRules: TPokerScore;
    property Cards: TCardList read m_cards;
  end;



implementation

{ THand }

function THand.AllSameSuit: boolean;
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

function THand.SelectedCount: integer;
var
  total: integer;
  card: TCard;

begin
  total := 0;

  for card in m_cards do
    if card.Selected then inc(total);

  result := total;
end;

function THand.IsRoyalFlush: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := AllSameSuit;
  if not ok then exit;

  ok := SelectedCount = 5;
  if not ok then exit;

  // ...

  result := true;
end;

function THand.IsStraightFlush: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := AllSameSuit;
  if not ok then exit;

  ok := SelectedCount = 5;
  if not ok then exit;

  // ...

  result := true;
end;

function THand.IsFourKind: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := SelectedCount = 4;
  if not ok then exit;

  // ...

  result := true;
end;

function THand.IsFullHouse: boolean;
var
  ok: boolean;

begin
  ok := SelectedCount = 5;
  if not ok then exit;

  // ...

  result := true;

end;

function THand.IsFlush: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := AllSameSuit;
  if not ok then exit;

  ok := SelectedCount = 5;
  if not ok then exit;

  // ...

  result := true;
end;

function THand.IsStraight: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := SelectedCount = 5;
  if not ok then exit;

  // ...

  result := true;
end;

function THand.IsThreeKind: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := SelectedCount = 3;
  if not ok then exit;

  // ...

  result := true;

end;

function THand.IsTwoPair: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := SelectedCount = 4;
  if not ok then exit;

  // ...

  result := true;

end;

function THand.IsPair: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := SelectedCount = 2;
  if not ok then exit;

  // ...

  result := true;

end;

function THand.IsHighCard: boolean;
var
  ok: boolean;

begin
  result := false;

  ok := SelectedCount = 1;
  if not ok then exit;

  // ...

  result := true;

end;

constructor THand.Create;
begin
  m_cards := TCardList.Create;
end;

destructor THand.Destroy;
begin
  m_cards.Free;
  inherited Destroy;
end;

procedure THand.Add(acard: TCard);
begin
  m_cards.Add(acard);
end;

function CompareCards(const first, second: TCard): integer;
begin
  result := 0;
  if first.CardOrder = second.CardOrder then
  begin
    if first.Suit > second.Suit then
      result := -1
    else if first.Suit < second.Suit then
      result := 1;
  end
  else
  begin
    if first.CardOrder > second.CardOrder then
      result := -1
    else if first.CardOrder < second.CardOrder then
      result := 1;
  end;
end;

procedure THand.Sort;
begin
  m_cards.Sort(@CompareCards);
end;

function THand.ApplyPokerRules: TPokerScore;
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

