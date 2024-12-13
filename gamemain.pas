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

unit gamemain;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib, raygui, carditem, handitem, deckitem;

type

  { TGame }

  TGame = class
  private
    m_deck: TDeck;
    function GetHand: THand;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update(delta: single);
    procedure Draw;
    procedure DrawMetalCard(x, y: integer; const symbol, name: string; number: integer);
    property Hand: THand read GetHand;
  end;

implementation

{ TGame }

const
  LEFT_MARGIN = 100;
  TOP_MARGIN = 500;
  SELECTED_OFFSET = 20;
  CARD_WIDTH = 120;
  CARD_HEIGHT = 160;
  OFFSET = 40;

function TGame.GetHand: THand;
begin
  result := m_deck.Hand;
end;

constructor TGame.Create;
begin
  m_deck := TDeck.Create;
  m_deck.DealHand;

  GuiSetStyle(DEFAULT, TEXT_SIZE, 30);
end;

destructor TGame.Destroy;
begin
  m_deck.Free;
  inherited;
end;

procedure TGame.Update(delta: single);
var
  index: integer;
  position: TVector2;
  bounds: TRectangle;

begin
  if IsMouseButtonPressed(MOUSE_LEFT_BUTTON) then
  begin
    position := GetMousePosition;
    if (position.x > LEFT_MARGIN) and
      (position.y > TOP_MARGIN) and
      (position.y < TOP_MARGIN + CARD_HEIGHT) then
    begin
      index := (round(position.x) - LEFT_MARGIN) div CARD_WIDTH;
      m_deck.ToggleSelect(index);
    end;
  end
  else if IsMouseButtonPressed(MOUSE_RIGHT_BUTTON) then
    m_deck.ResetSelection;

  if m_deck.CanPlay then
    GuiEnable
  else
    GuiDisable;

  bounds.x := LEFT_MARGIN;
  bounds.y := TOP_MARGIN + CARD_HEIGHT + OFFSET;
  bounds.width := 160;
  bounds.height := 40;
  if GuiButton(bounds, 'Play Hand') = 1 then
    m_deck.PlayHand;

  if m_deck.CanDiscard then
    GuiEnable
  else
    GuiDisable;

  bounds.x := LEFT_MARGIN + 200;
  bounds.y := TOP_MARGIN + CARD_HEIGHT + OFFSET;
  bounds.width := 160;
  bounds.height := 40;
  if GuiButton(bounds, 'Discard') = 1 then
    m_deck.DiscardHand;

  if m_deck.CanPlay then
    GuiDisable
  else
    GuiEnable;

  bounds.x := LEFT_MARGIN + 400;
  bounds.y := TOP_MARGIN + CARD_HEIGHT + OFFSET;
  bounds.width := 160;
  bounds.height := 40;
  if GuiButton(bounds, 'New Deal') = 1 then
    m_deck.NewDeal;

  GuiEnable;
end;

procedure TGame.Draw;
var
  x, y: integer;
  card: TCard;

begin
  x := LEFT_MARGIN;
  y := TOP_MARGIN;
  for card in m_deck.Hand.Cards do
  begin
    if card.Selected then
      DrawTexture(card.Texture, x, y - SELECTED_OFFSET, WHITE)
    else
      DrawTexture(card.Texture, x, y, WHITE);

    inc(x, CARD_WIDTH);
  end;

  // sample drawing of a periodic card
  DrawMetalCard(LEFT_MARGIN, 300, 'Pb', 'Lead', 100);

  DrawText(PChar('Games: ' + IntToStr(m_deck.Games)), 20, 20, 30, WHITE);
  DrawText(PChar('Total: ' + IntToStr(m_deck.Total)), 20, 50, 30, WHITE);
  DrawText(PChar('Credits: ' + IntToStr(m_deck.Credits)), 20, 80, 30, WHITE);
  DrawText(PChar('Deck: ' + IntToStr(m_deck.Remaining)), 20, 110, 30, WHITE);
  DrawText(PChar(m_deck.Description), 20, 140, 30, WHITE);
  DrawText(PChar('Rounds: ' + IntToStr(m_deck.Rounds) + ' : Discards: ' +
    IntToStr(m_deck.Discards)), 20, 170, 30, WHITE);
end;

procedure TGame.DrawMetalCard(x, y: integer; const symbol, name: string;
  number: integer);
begin
  DrawRectangle(x, y, CARD_WIDTH - 8, CARD_HEIGHT, LIGHTGRAY);
  DrawText(PChar(symbol), x + 5, y + 5, 20, BLACK);
  DrawText(PChar(IntToStr(number)), x + 40, y + 70, 30, BLACK);
  DrawText(PChar(name), x + 10, y + 140, 20, BLACK);
end;

end.

