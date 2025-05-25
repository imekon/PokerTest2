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
  Classes, SysUtils, raylib, raygui, carditem, elementitem, handitem, deckitem, scoreitem;

type

  { TGame }
  TGamePage = (PAGE_WELCOME, PAGE_GAME, {* PAGE_SHOP, *} PAGE_RULES, PAGE_ABOUT);
  TGameState = (STATE_NONE, STATE_PLAYING, STATE_SHOPPING);

  TGame = class
  private
    m_progress: single;
    m_font: TFont;
    m_page: TGamePage;
    m_state: TGameState;
    m_backPage: TGamePage;
    m_deck: TDeck;
    function GetHand: THand;
    procedure DrawWelcome;
    procedure DrawGame;
    //procedure DrawShop;
    procedure DrawRules;
    procedure DrawAbout;
    procedure UpdateWelcome;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update(delta: single);
    procedure Draw;
    procedure DrawPeriodicCard(x, y: integer; const symbol, name, action: string;
      number, cost: integer);
    procedure DrawTooltipCard(x, y: integer; card: TCard);
    procedure DrawTooltipElement(x, y: integer; element: TElement);
    property Hand: THand read GetHand;
  end;

implementation

uses
  utilities;

{ TGame }

const
  BUTTON_MARGIN = 20;
  BUTTON_WIDTH = 140;
  BUTTON_HEIGHT = 40;
  BUTTON_SPACING = 170;

  LEFT_MARGIN = 30;
  TOP_MARGIN = 500;
  SELECTED_OFFSET = 20;
  CARD_WIDTH = 120;
  CARD_HEIGHT = 160;
  OFFSET = 40;

function TGame.GetHand: THand;
begin
  result := m_deck.Hand;
end;

procedure TGame.DrawWelcome;
const
  TEXT_LEFT = 200;
  TEXT_TOP = 320;

begin
  ClearBackground(DARKGREEN);

  DrawTextEx(m_font, 'Welcome to Poker Crafter!', Vec2(TEXT_LEFT, TEXT_TOP), 64, 1.0, WHITE);

  GuiProgressBar(RectangleCreate(TEXT_LEFT + 90, TEXT_TOP + 70, 400, 20), nil, nil, @m_progress, 0.0, 1.0);

  if m_deck.Loaded then
    GuiEnable
  else
    GuiDisable;

  if GuiButton(RectangleCreate(TEXT_LEFT + 250, TEXT_TOP + 110, 100, BUTTON_HEIGHT), 'Start') = 1 then
  begin
    m_deck.DealHand;

    m_page := PAGE_GAME;
    m_backPage := PAGE_GAME;
  end;

  GuiEnable;
end;

procedure TGame.DrawGame;
var
  i, x, y: integer;
  card: TCard;
  element: TElement;

begin
  ClearBackground(DARKGREEN);

  // SCORING
  DrawTextEx(m_font, PChar('Target: ' + IntToStr(m_deck.Target)), Vec2(20, 20), 32, 1.0, RAYWHITE);
  DrawTextEx(m_font, PChar('Credits: '), Vec2(20, 50), 32, 1.0, WHITE);
  DrawTextEx(m_font, PChar('Games: ' + IntToStr(m_deck.Games)), Vec2(20, 80), 32, 1.0, WHITE);
  DrawTextEx(m_font, PChar('Total: ' + IntToStr(m_deck.Total)), Vec2(20, 110), 32, 1.0, WHITE);
  DrawTextEx(m_font, PChar('Points: ' + IntToStr(m_deck.Points)), Vec2(20, 140), 32, 1.0, WHITE);
  DrawTextEx(m_font, PChar('Deck: ' + IntToStr(m_deck.Remaining)), Vec2(20, 170), 32, 1.0, WHITE);
  DrawTextEx(m_font, PChar(m_deck.Description), Vec2(20, 200), 32, 1.0, WHITE);
  DrawTextEx(m_font, PChar('Rounds: ' + IntToStr(m_deck.Rounds) + ' : Discards: ' +
    IntToStr(m_deck.Discards)), Vec2(20, 230), 32, 1.0, WHITE);

  // POKER CARDS
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

  // BUTTONS
  if m_deck.CanPlay then
    GuiEnable
  else
    GuiDisable;

  if GuiButton(RectangleCreate(BUTTON_MARGIN, TOP_MARGIN + CARD_HEIGHT + OFFSET, BUTTON_WIDTH, BUTTON_HEIGHT), 'Play Hand') = 1 then
    m_deck.PlayHand;

  if m_deck.CanDiscard and m_deck.Hand.AnySelected then
    GuiEnable
  else
    GuiDisable;

  if GuiButton(RectangleCreate(BUTTON_MARGIN + BUTTON_SPACING, TOP_MARGIN + CARD_HEIGHT + OFFSET, BUTTON_WIDTH, BUTTON_HEIGHT), 'Discard') = 1 then
    m_deck.DiscardHand;

  if m_deck.CanPlay then
    GuiDisable
  else
    GuiEnable;

  if GuiButton(RectangleCreate(BUTTON_MARGIN + BUTTON_SPACING * 2, TOP_MARGIN + CARD_HEIGHT + OFFSET, BUTTON_WIDTH, BUTTON_HEIGHT), 'New Deal') = 1 then
    m_deck.NewDeal;

  {*if GuiButton(RectangleCreate(BUTTON_MARGIN + BUTTON_SPACING * 3, TOP_MARGIN + CARD_HEIGHT + OFFSET, 160, 40), 'Shop') = 1 then
  begin
    m_page := PAGE_SHOP;
    m_backPage := PAGE_GAME;
  end;
  *}

  GuiEnable;

  if GuiButton(RectangleCreate(BUTTON_MARGIN + BUTTON_SPACING * 4, TOP_MARGIN + CARD_HEIGHT + OFFSET, BUTTON_WIDTH, BUTTON_HEIGHT), 'Rules') = 1 then
  begin
    m_page := PAGE_RULES;
    m_backPage := PAGE_GAME;
  end;

  if GuiButton(RectangleCreate(BUTTON_MARGIN + BUTTON_SPACING * 5, TOP_MARGIN + CARD_HEIGHT + OFFSET, 40, BUTTON_HEIGHT), '?') = 1 then
  begin
    m_page := PAGE_ABOUT;
    m_backPage := PAGE_GAME;
  end;
end;

{*
procedure TGame.DrawShop;
begin
  ClearBackground(DARKGREEN);
  DrawTextEx(m_font, 'Shop', Vec2(100, 200), 48, 1.0, RAYWHITE);
  if GuiButton(RectangleCreate(100, 300, 100, 30), 'Back') = 1 then
  begin
    m_page := PAGE_GAME;
    m_backPage := PAGE_GAME;
  end;
end;
*}

procedure TGame.DrawRules;
const
  NAME_X = 100;
  ADDER_X = 400;
  MULT_X = 480;
  LEVEL_X = 600;

var
  rung: TScoringRung;
  score: TPokerScore;
  y: integer;

begin
  ClearBackground(DARKGREEN);

  DrawTextEx(m_font, 'Name', Vec2(NAME_X, 60), 20, 1.0, WHITE);
  DrawTextEx(m_font, 'Adder', Vec2(ADDER_X, 60), 20, 1.0, WHITE);
  DrawTextEx(m_font, 'Multiplier', Vec2(MULT_X, 60), 20, 1.0, WHITE);
  DrawTextEx(m_font, 'Level', Vec2(LEVEL_X, 60), 20, 1.0, WHITE);

  y := 100;
  for score := ROYAL_FLUSH to HIGH_CARD do
  begin
    rung := m_deck.ScoringLadder.GetRung(score);
    DrawTextEx(m_font, PChar(GetScoreDescription(score)), Vec2(NAME_X, y), 32, 1.0, RAYWHITE);
    DrawTextEx(m_font, PChar(IntToStr(rung.Adder)),       Vec2(ADDER_X, y), 32, 1.0, RAYWHITE);
    DrawTextEx(m_font, PChar(IntToStr(rung.Multiplier)),  Vec2(MULT_X, y), 32, 1.0, RAYWHITE);
    DrawTextEx(m_font, PChar(IntToStr(rung.Level)),       Vec2(LEVEL_X, y), 32, 1.0, RAYWHITE);
    inc(y, 40);
  end;

  if GuiButton(RectangleCreate(100, 550, 100, 40), 'Back') = 1 then
  begin
    m_page := PAGE_GAME;
    m_backPage := PAGE_GAME;
  end;
end;

procedure TGame.DrawAbout;
begin
  ClearBackground(RAYWHITE);
  GuiSetStyle(DEFAULT, TEXT_SIZE, 22);
  GuiSetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_WORD);
  GuiTextBox(RectangleCreate(100, 100, 700, 400),
    'A simple poker game based on rules seen in Balatro. I was curious, could I create' +
    ' a game similar to Balatro but in my own way, using the rules of Poker',
    22, false);
  GuiSetStyle(DEFAULT, TEXT_SIZE, 32);
  if GuiButton(RectangleCreate(100, 650, 100, 40), 'Back') = 1 then
  begin
    m_page := PAGE_GAME;
    m_backPage := PAGE_GAME;
  end;
end;

procedure TGame.UpdateWelcome;
begin
  m_progress := m_deck.Progress;

  m_deck.LoadTextures;
end;

constructor TGame.Create;
begin
  m_progress := 0;
  m_page := PAGE_WELCOME;
  m_backPage := PAGE_WELCOME;
  m_state := STATE_NONE;
  m_deck := TDeck.Create;

  m_font := LoadFont('assets/fonts/SF Atarian System.ttf');

  GuiSetFont(m_font);
  GuiSetStyle(DEFAULT, TEXT_SIZE, 32);
end;

destructor TGame.Destroy;
begin
  m_deck.Free;
  UnloadFont(m_font);
  inherited;
end;

procedure TGame.Update(delta: single);
var
  index: integer;
  position: TVector2;

begin
  m_state := STATE_NONE;

  case m_page of
    PAGE_WELCOME: UpdateWelcome;
    PAGE_GAME:
      begin
        if m_deck.CanPlay then
          m_state := STATE_PLAYING
        else
          m_state := STATE_SHOPPING;

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
      end;
  end;
end;

procedure TGame.Draw;
begin
  case m_page of
    PAGE_WELCOME: DrawWelcome;
    PAGE_GAME:    DrawGame;
    PAGE_RULES:   DrawRules;
    //PAGE_SHOP:    DrawShop;
    PAGE_ABOUT:   DrawAbout;
  end;
end;

procedure TGame.DrawPeriodicCard(x, y: integer; const symbol, name,
  action: string; number, cost: integer);
begin
  DrawRectangle(x, y, CARD_WIDTH - 8, CARD_HEIGHT, LIGHTGRAY);
  DrawTextEx(m_font, PChar(IntToStr(number)), Vec2(x + 5, y + 5), 22, 1.0, BLACK);
  DrawTextEx(m_font, PChar(symbol), Vec2(x + 25, y + 50), 64, 1.0, BLACK);
  DrawTextEx(m_font, PChar(name), Vec2(x + 5, y + 118), 22, 1.0, BLACK);
  DrawTextEx(m_font, PChar(action + ': ' + IntToStr(cost)), Vec2(x + 5, y + 138), 22, 1.0, RED);
end;

procedure TGame.DrawTooltipCard(x, y: integer; card: TCard);
begin
  //
end;

procedure TGame.DrawTooltipElement(x, y: integer; element: TElement);
begin
  //
end;

end.

