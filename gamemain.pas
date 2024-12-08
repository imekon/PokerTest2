unit gamemain;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib, carditem, handitem, deckitem;

type

  { TGame }

  TGame = class
  private
    m_deck: TDeck;
    function GetHand: THand;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update;
    procedure Draw;
    function Button(const text: string; x, y, w, h: integer): boolean;
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
end;

destructor TGame.Destroy;
begin
  m_deck.Free;
  inherited;
end;

procedure TGame.Update;
var
  index: integer;
  position: TVector2;

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

  if Button('Play Hand', LEFT_MARGIN, TOP_MARGIN + CARD_HEIGHT + OFFSET, 160, 35) then
    m_deck.PlayHand
  else if Button('Discard', LEFT_MARGIN + 200, TOP_MARGIN + CARD_HEIGHT + OFFSET, 160, 35) then
    m_deck.DiscardHand;
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
end;

function TGame.Button(const text: string; x, y, w, h: integer): boolean;
var
  point: TVector2;
  bounds: TRectangle;
  over: boolean;

begin
  result := false;

  bounds.x := x;
  bounds.y := y;
  bounds.width := w;
  bounds.height := h;
  point := GetMousePosition;
  over := CheckCollisionPointRec(point, bounds);

  if over then
  begin
    DrawRectangle(x, y, w, h, LIGHTGRAY);
    DrawText(PChar(text), x + 3, y + 3, 30, BLACK);
  end
  else
  begin
    DrawRectangle(x, y, w, h, DARKGRAY);
    DrawText(PChar(text), x + 3, y + 3, 30, WHITE);
  end;


  if IsMouseButtonPressed(MOUSE_LEFT_BUTTON) and over then
    result := true;
end;

end.

