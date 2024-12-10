unit deckitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, carditem, handitem, rulesitem;

type

{ TDeck }

  TDeck = class
  private
    m_cards: TCards;
    m_hand: THand;
    m_total: integer;
    m_credits: integer;
    procedure RefillHand;
  public
    constructor Create;
    destructor Destroy; override;
    procedure DealHand;
    procedure ToggleSelect(index: integer);
    procedure ResetSelection;
    procedure PlayHand;
    procedure DiscardHand;
    property Hand: THand read m_hand;
    property Total: integer read m_total;
    property Credits: integer read m_credits;
  end;

implementation

{ TDeck }

procedure TDeck.RefillHand;
var
  card: TCard;

begin
  while m_hand.Cards.Count < 7 do
  begin
    card := m_cards.Remove;
    m_hand.Add(card);
  end;

  m_hand.Sort;
end;

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
    if ((card.Selected = false) and (m_hand.SelectedCount < 5)) or (card.Selected = true) then
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
var
  card: TCard;
  playList: TCardList;
  rules: TRules;
  score: TPokerScore;

begin
  playList := TCardList.Create;

  for card in m_hand.Cards do
  begin
    if card.Selected then
    begin
      playList.Add(card);
      m_cards.Add(card);
    end;
  end;

  for card in playList do
    m_hand.Remove(card);

  rules := TRules.Create(playList);
  score := rules.Apply;
  m_credits := rules.Score;
  m_total := m_total + m_credits;
  rules.Free;

  RefillHand;

  playList.Free;
end;

procedure TDeck.DiscardHand;
var
  card: TCard;
  toRemove: TCardList;

begin
  toRemove := TCardList.Create;
  for card in m_hand.Cards do
  begin
    if card.Selected then
    begin
      toRemove.Add(card);
      m_cards.Add(card);
    end;
  end;

  for card in toRemove do
    m_hand.Remove(card);

  RefillHand;

  toRemove.Free;
end;

end.

