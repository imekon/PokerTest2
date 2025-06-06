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

unit deckitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, carditem, handitem, rulesitem, scoreitem, overrideitem;

type

{ TDeck }

  TDeck = class
  private
    m_additive: integer;
    m_multiplier: single;
    m_handSize: integer;
    m_cards: TCards;
    m_hand: THand;
    m_games: integer;
    m_total: integer;
    m_rounds: integer;
    m_discards: integer;
    m_points: integer;
    m_description: string;
    m_override: TOverride;
    m_scoring: TScoringLadder;
    m_roundsLadder: TRoundsLadder;
    function GetCanDiscard: boolean;
    function GetCanPlay: boolean;
    function GetLoaded: boolean;
    function GetProgress: single;
    function GetRemainingCards: integer;
    function GetTarget: integer;
    procedure RefillHand;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadTextures;
    procedure DealHand;
    procedure ToggleSelect(index: integer);
    procedure ResetSelection;
    procedure PlayHand;
    procedure DiscardHand;
    procedure NewDeal;
    procedure AddAdditive(amount: integer);
    procedure AddMultiplier(amount: integer);
    procedure MultMultiplier(amount: single);
    property Progress: single read GetProgress;
    property Hand: THand read m_hand;
    property Remaining: integer read GetRemainingCards;
    property Games: integer read m_games;
    property Total: integer read m_total;
    property Points: integer read m_points;
    property Description: string read m_description;
    property Rounds: integer read m_rounds;
    property RoundsLadder: TRoundsLadder read m_roundsLadder;
    property ScoringLadder: TScoringLadder read m_scoring;
    property Discards: integer read m_discards;
    property Target: integer read GetTarget;
    property Loaded: boolean read GetLoaded;
    property CanPlay: boolean read GetCanPlay;
    property CanDiscard: boolean read GetCanDiscard;
  end;

implementation

{ TDeck }

procedure TDeck.RefillHand;
var
  card: TCard;

begin
  while m_hand.Cards.Count < m_handSize do
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

function TDeck.GetTarget: integer;
begin
  result := m_roundsLadder.GetScore(m_games + 1);
end;

function TDeck.GetCanDiscard: boolean;
begin
  result := m_discards > 0;
end;

function TDeck.GetCanPlay: boolean;
begin
  result := m_rounds > 0;
end;

function TDeck.GetLoaded: boolean;
begin
  result := m_cards.ImagesLoaded and m_cards.TexturesLoaded;
end;

function TDeck.GetProgress: single;
begin
  if Assigned(m_cards) then
    result := m_cards.Progress
  else
    result := 0.0;
end;

constructor TDeck.Create;
begin
  m_additive := 0;
  m_multiplier := 1.0;

  m_handSize := 8;
  m_rounds := 4;
  m_discards := 3;

  m_cards := TCards.Create;
  m_hand := THand.Create;
  m_scoring := TScoringLadder.Create;
  m_roundsLadder := TRoundsLadder.Create;
  m_override := TOverride.Create;
  m_games := 0;
end;

destructor TDeck.Destroy;
begin
  m_hand.Free;
  m_cards.Free;
  m_scoring.Free;
  m_roundsLadder.Free;
  m_override.Free;
  inherited Destroy;
end;

procedure TDeck.LoadTextures;
begin
  if m_cards.ImagesLoaded and not m_cards.TexturesLoaded then
  begin
    m_cards.LoadTexturesFromImages;
    m_cards.Shuffle;
  end;
end;

procedure TDeck.DealHand;
var
  i: integer;
  card: TCard;

begin
  for i := 1 to m_handSize do
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
      m_description := GetScoreDescription(score);
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
  m_points := m_scoring.Scoring(score, rules.Score(m_override),
    m_override.Addition + m_additive, m_override.Multiplier * m_multiplier);
  m_total := m_total + m_points;
  m_description := GetScoreDescription(score);
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
  inc(m_games);
  m_points := 0;
  m_rounds := 3;
  m_discards := 3;

  for card in m_hand.Cards do
  begin
    m_cards.Add(card);
    card.Selected := false;
  end;

  m_hand.Clear;

  m_cards.Shuffle;

  DealHand;
end;

procedure TDeck.AddAdditive(amount: integer);
begin
  inc(m_additive, amount);
end;

procedure TDeck.AddMultiplier(amount: integer);
begin
  m_multiplier := m_multiplier + amount;
end;

procedure TDeck.MultMultiplier(amount: single);
begin
  m_multiplier := m_multiplier * amount;
end;

end.

