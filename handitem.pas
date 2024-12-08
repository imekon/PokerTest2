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
    function GetSelectedCount: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(acard: TCard);
    procedure Sort;
    procedure Remove(acard: TCard);
    property Cards: TCardList read m_cards;
    property SelectedCount: integer read GetSelectedCount;
  end;



implementation

{ THand }

function THand.GetSelectedCount: integer;
var
  total: integer;
  card: TCard;

begin
  total := 0;

  for card in m_cards do
    if card.Selected then inc(total);

  result := total;
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

procedure THand.Remove(acard: TCard);
begin
  m_cards.Remove(acard);
end;



end.

