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

unit carditem;

{$mode ObjFPC}{$H+}
{$define ENABLE_THREADING}

interface

uses
  Classes, SysUtils, fgl, raylib;

type
  TSuit = (SUIT_CLUBS, SUIT_DIAMONDS, SUIT_HEARTS, SUIT_SPADES, SUIT_OTHER);
  TCardIndex = 0..12;
  TPokerScore = (ROYAL_FLUSH, STRAIGHT_FLUSH, FOUR_OF_A_KIND, FULL_HOUSE,
    FLUSH, STRAIGHT, THREE_OF_A_KIND, TWO_PAIRS, PAIR, HIGH_CARD, NO_SCORE);

  { TCard }

  TCard = class
  private
    m_image: TImage;
    m_texture: TTexture2D;
    m_suit: TSuit;
    m_card: TCardIndex;
    m_selected: boolean;
    m_scoring: boolean;
    function GetCardOrder: integer;
  public
    constructor Create(asuit: TSuit; acard: TCardIndex; anImage: TImage);
    destructor Destroy; override;
    property Suit: TSuit read m_suit;
    property CardIndex: TCardIndex read m_card;
    property CardOrder: integer read GetCardOrder;
    property Selected: boolean read m_selected write m_selected;
    property Scoring: boolean read m_scoring write m_scoring;
    property Texture: TTexture2D read m_texture;
  end;

  TCardList = specialize TFPGList<TCard>;

  TCardLoader = class;

  { TCards }

  TCards = class
  private
    m_cards: TCardList;
    m_progress: single;
    m_imagesLoaded: boolean;
    m_texturesLoaded: boolean;
    m_cardLoader: TCardLoader;
    procedure CreateCardImage(asuit: TSuit; acard: TCardIndex; const filename: string);
    function GetCardCount: integer;
    procedure LoadImages;
    procedure LoadTextures;
    procedure SwapCards(a, b: integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Shuffle;
    procedure Add(acard: TCard);
    function Remove: TCard;
    procedure LoadTexturesFromImages;
    property ImagesLoaded: boolean read m_imagesLoaded;
    property TexturesLoaded: boolean read m_texturesLoaded;
    property Progress: single read m_progress;
    property Count: integer read GetCardCount;
  end;

  { TCardLoader }

  TCardLoader = class(TThread)
  private
    m_cards: TCards;
  protected
    procedure Execute; override;
  public
    constructor Create(cards: TCards);
  end;

  function GetScoreDescription(ascore: TPokerScore): string;

implementation

{ TCard }

function TCard.GetCardOrder: integer;
begin
  if m_card = 0 then
    result := 50
  else
    result := ord(m_card) + 1;
end;

constructor TCard.Create(asuit: TSuit; acard: TCardIndex; anImage: TImage);
begin
  m_image := anImage;
  m_suit := asuit;
  m_card := acard;
  m_selected := false;
  m_scoring := false;
end;

destructor TCard.Destroy;
begin
  UnloadTexture(m_texture);
  UnloadImage(m_image);
  inherited Destroy;
end;

{ TCards }

const
  PROGRESS_INC = 1.0 / 53.0;

procedure TCards.CreateCardImage(asuit: TSuit; acard: TCardIndex;
  const filename: string);
var
  card: TCard;
  image: TImage;

begin
  image := LoadImage(PChar(filename));
  card := TCard.Create(asuit, acard, image);
  m_cards.Add(card);

  m_progress := m_progress + PROGRESS_INC;
end;

function TCards.GetCardCount: integer;
begin
  result := m_cards.Count;
end;

procedure TCards.LoadImages;
begin
  m_progress := 0.0;

  // CLUBS
  CreateCardImage(TSuit.SUIT_CLUBS, 0, 'assets/clubs/a_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 1, 'assets/clubs/2_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 2, 'assets/clubs/3_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 3, 'assets/clubs/4_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 4, 'assets/clubs/5_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 5, 'assets/clubs/6_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 6, 'assets/clubs/7_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 7, 'assets/clubs/8_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 8, 'assets/clubs/9_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 9, 'assets/clubs/10_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 10, 'assets/clubs/j_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 11, 'assets/clubs/q_clubs.png');
  CreateCardImage(TSuit.SUIT_CLUBS, 12, 'assets/clubs/k_clubs.png');

  // DIAMONDS
  CreateCardImage(TSuit.SUIT_DIAMONDS, 0, 'assets/diamonds/a_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 1, 'assets/diamonds/2_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 2, 'assets/diamonds/3_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 3, 'assets/diamonds/4_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 4, 'assets/diamonds/5_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 5, 'assets/diamonds/6_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 6, 'assets/diamonds/7_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 7, 'assets/diamonds/8_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 8, 'assets/diamonds/9_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 9, 'assets/diamonds/10_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 10, 'assets/diamonds/j_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 11, 'assets/diamonds/q_diamonds.png');
  CreateCardImage(TSuit.SUIT_DIAMONDS, 12, 'assets/diamonds/k_diamonds.png');

  // HEARTS
  CreateCardImage(TSuit.SUIT_HEARTS, 0, 'assets/hearts/A_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 1, 'assets/hearts/2_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 2, 'assets/hearts/3_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 3, 'assets/hearts/4_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 4, 'assets/hearts/5_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 5, 'assets/hearts/6_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 6, 'assets/hearts/7_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 7, 'assets/hearts/8_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 8, 'assets/hearts/9_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 9, 'assets/hearts/10_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 10, 'assets/hearts/J_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 11, 'assets/hearts/Q_hearts.png');
  CreateCardImage(TSuit.SUIT_HEARTS, 12, 'assets/hearts/K_hearts.png');

  // SPADES
  CreateCardImage(TSuit.SUIT_SPADES, 0, 'assets/spades/a_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 1, 'assets/spades/2_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 2, 'assets/spades/3_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 3, 'assets/spades/4_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 4, 'assets/spades/5_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 5, 'assets/spades/6_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 6, 'assets/spades/7_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 7, 'assets/spades/8_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 8, 'assets/spades/9_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 9, 'assets/spades/10_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 10, 'assets/spades/j_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 11, 'assets/spades/q_spades.png');
  CreateCardImage(TSuit.SUIT_SPADES, 12, 'assets/spades/k_spades.png');

  m_imagesLoaded := true;
end;

procedure TCards.LoadTextures;
var
  card: TCard;
  texture: TTexture2D;

begin
  for card in m_cards do
  begin
    texture := LoadTextureFromImage(card.m_image);
    card.m_texture := texture;
  end;

  m_texturesLoaded := true;
end;

procedure TCards.SwapCards(a, b: integer);
var
  card: TCard;

begin
  card := m_cards[a];
  m_cards[a] := m_cards[b];
  m_cards[b] := card;
end;

constructor TCards.Create;
begin
  m_cards := TCardList.Create;
  m_imagesLoaded := false;
  m_texturesLoaded := false;

{$IFDEF ENABLE_THREADING}
  m_cardLoader := TCardLoader.Create(self);
  m_cardLoader.Start;
{$ELSE}
  LoadImages;
  LoadTextures;
  Shuffle;
{$ENDIF}
end;

destructor TCards.Destroy;
var
  card: TCard;

begin
  for card in m_cards do
    card.Free;

  m_cards.Free;
  inherited Destroy;
end;

procedure TCards.Shuffle;
var
  i, n, other: integer;

begin
  n := m_cards.Count;

  for i := 0 to n - 1 do
  begin
    other := Random(n);
    while other = i do
      other := Random(n);

    SwapCards(i, other);
  end;
end;

procedure TCards.Add(acard: TCard);
begin
  m_cards.Add(acard);
end;

function TCards.Remove: TCard;
var
  card: TCard;

begin
  if m_cards.Count = 0 then
  begin
    result := nil;
    exit;
  end;

  card := m_cards[0];
  m_cards.Remove(card);
  result := card;
end;

procedure TCards.LoadTexturesFromImages;
begin
  LoadTextures;
  m_texturesLoaded := true;
end;

{ TCardLoader }

procedure TCardLoader.Execute;
begin
  m_cards.LoadImages;
end;

constructor TCardLoader.Create(cards: TCards);
begin
  m_cards := cards;
  inherited Create(true);
end;

function GetScoreDescription(ascore: TPokerScore): string;
begin
  case ascore of
    ROYAL_FLUSH: result := 'Royal Flush';
    STRAIGHT_FLUSH: result := 'Straight Flush';
    FOUR_OF_A_KIND: result := 'Four of a Kind';
    FULL_HOUSE: result := 'Full House';
    FLUSH: result := 'Flush';
    STRAIGHT: result := 'Straight';
    THREE_OF_A_KIND: result := 'Three of a Kind';
    TWO_PAIRS: result := 'Two Pairs';
    PAIR: result := 'Pair';
    HIGH_CARD: result := 'High Card';
  end;
end;



end.

