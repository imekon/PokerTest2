unit deckitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, carditem, handitem, rulesitem, scoreitem, elementitem;

type

{ TDeck }

  TDeck = class
  private
    m_cards: TCards;
    m_elements: TElements;
    m_hand: THand;
    m_total: integer;
    m_rounds: integer;
    m_discards: integer;
    m_credits: integer;
    m_description: string;
    m_scoring: TScoringLadder;
    function GetCanDiscard: boolean;
    function GetCanPlay: boolean;
    function GetRemainingCards: integer;
    procedure RefillHand;
  public
    constructor Create;
    destructor Destroy; override;
    procedure DealHand;
    procedure ToggleSelect(index: integer);
    procedure ResetSelection;
    procedure PlayHand;
    procedure DiscardHand;
    procedure NewDeal;
    property Hand: THand read m_hand;
    property Remaining: integer read GetRemainingCards;
    property Total: integer read m_total;
    property Credits: integer read m_credits;
    property Description: string read m_description;
    property Rounds: integer read m_rounds;
    property Discards: integer read m_discards;
    property CanPlay: boolean read GetCanPlay;
    property CanDiscard: boolean read GetCanDiscard;
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
    if card = nil then break;
    m_hand.Add(card);
  end;

  m_hand.Sort;
end;

function TDeck.GetRemainingCards: integer;
begin
  result := m_cards.Count;
end;

function TDeck.GetCanDiscard: boolean;
begin
  result := m_discards > 0;
end;

function TDeck.GetCanPlay: boolean;
begin
  result := m_rounds > 0;
end;

constructor TDeck.Create;
begin
  m_cards := TCards.Create;
  m_hand := THand.Create;
  m_scoring := TScoringLadder.Create;
  m_elements := TElements.Create;
  m_elements.LoadFromFile('assets/elements.db');
  m_rounds := 3;
  m_discards := 3;
end;

destructor TDeck.Destroy;
begin
  m_hand.Free;
  m_cards.Free;
  m_scoring.Free;
  m_elements.Free;
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
  rules: TRules;
  playList: TCardList;
  score: TPokerScore;

begin
  if (index >= 0) and (index < m_hand.Cards.Count) then
  begin
    card := m_hand.Cards[index];
    if ((card.Selected = false) and (m_hand.SelectedCount < 5)) or (card.Selected = true) then
    begin
      card.Selected := not card.Selected;
      playList := TCardList.Create;

      for card in m_hand.Cards do
      begin
        if card.Selected then
          playList.Add(card);
      end;

      rules := TRules.Create(playList);
      score := rules.Apply;
      m_description := rules.ScoreDescription(score);
      rules.Free;
    end;
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
  if m_rounds = 0 then exit;

  dec(m_rounds);

  playList := TCardList.Create;

  for card in m_hand.Cards do
  begin
    if card.Selected then
      playList.Add(card);
  end;

  for card in playList do
  begin
    m_hand.Remove(card);
    m_cards.Add(card);
    card.Selected := false;
  end;

  rules := TRules.Create(playList);
  score := rules.Apply;
  m_credits := m_scoring.Scoring(score, rules.Score, 0, 1);
  m_total := m_total + m_credits;
  m_description := rules.ScoreDescription(score);
  rules.Free;

  RefillHand;

  playList.Free;
end;

procedure TDeck.DiscardHand;
var
  card: TCard;
  toRemove: TCardList;

begin
  if m_discards = 0 then exit;

  dec(m_discards);

  toRemove := TCardList.Create;
  for card in m_hand.Cards do
  begin
    if card.Selected then
      toRemove.Add(card);
  end;

  for card in toRemove do
  begin
    m_hand.Remove(card);
    m_cards.Add(card);
    card.Selected := false;
  end;

  RefillHand;

  m_description := '';

  toRemove.Free;
end;

procedure TDeck.NewDeal;
var
  card: TCard;

begin
  m_total := 0;
  m_credits := 0;
  m_rounds := 3;
  m_discards := 3;

  for card in m_hand.Cards do
    m_cards.Add(card);

  m_hand.Clear;

  m_cards.Shuffle;

  DealHand;
end;

end.

