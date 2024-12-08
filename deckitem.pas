unit deckitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, carditem, handitem;

type

{ TDeck }

  TDeck = class
  private
    m_cards: TCards;
    m_hand: THand;
  public
    constructor Create;
    destructor Destroy; override;
    procedure DealHand;
    procedure ToggleSelect(index: integer);
    procedure ResetSelection;
    procedure PlayHand;
    procedure DiscardHand;
    property Hand: THand read m_hand;
  end;

implementation

{ TDeck }

constructor TDeck.Create;
begin
  m_cards := TCards.Create;
  m_hand := THand.Create;
end;

destructor TDeck.Destroy;
begin
  m_hand.Free;
  m_cards.Free;
  inherited Destroy;
end;

procedure TDeck.DealHand;
var
  i: integer;
  card: TCard;

begin
  for i := 1 to 7 do
  begin
    card := m_cards.Remove;
    m_hand.Add(card);
  end;

  m_hand.Sort;
end;

procedure TDeck.ToggleSelect(index: integer);
var
  card: TCard;

begin
  if (index >= 0) and (index < m_hand.Cards.Count) then
  begin
    card := m_hand.Cards[index];
    card.Selected := not card.Selected;
  end;
end;

procedure TDeck.ResetSelection;
var
  card: TCard;

begin
  for card in m_hand.Cards do
    card.Selected := false;
end;

procedure TDeck.PlayHand;
begin

end;

procedure TDeck.DiscardHand;
begin

end;

end.

