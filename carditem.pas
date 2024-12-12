unit carditem;

{$mode ObjFPC}{$H+}

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
    m_texture: TTexture2D;
    m_suit: TSuit;
    m_card: TCardIndex;
    m_selected: boolean;
    m_scoring: boolean;
    function GetCardOrder: integer;
  public
    constructor Create(asuit: TSuit; acard: TCardIndex; atexture: TTexture2D);
    destructor Destroy; override;
    property Suit: TSuit read m_suit;
    property CardIndex: TCardIndex read m_card;
    property CardOrder: integer read GetCardOrder;
    property Selected: boolean read m_selected write m_selected;
    property Scoring: boolean read m_scoring write m_scoring;
    property Texture: TTexture2D read m_texture;
  end;

  TCardList = specialize TFPGList<TCard>;

  { TCards }

  TCards = class
  private
    m_cards: TCardList;
    function CreateCard(asuit: TSuit; acard: TCardIndex; const filename: string): TCard;
    function GetCardCount: integer;
    procedure LoadCards;
    procedure SwapCards(a, b: integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Shuffle;
    procedure Add(acard: TCard);
    function Remove: TCard;
    property Count: integer read GetCardCount;
  end;

implementation

{ TCard }

function TCard.GetCardOrder: integer;
begin
  if m_card = 0 then
    result := 50
  else
    result := ord(m_card) + 1;
end;

constructor TCard.Create(asuit: TSuit; acard: TCardIndex; atexture: TTexture2D);
begin
  m_texture := atexture;
  m_suit := asuit;
  m_card := acard;
  m_selected := false;
  m_scoring := false;
end;

destructor TCard.Destroy;
begin
  inherited Destroy;
end;

{ TCards }

function TCards.CreateCard(asuit: TSuit; acard: TCardIndex;
  const filename: string): TCard;
var
  card: TCard;
  texture: TTexture2D;

begin
  texture := LoadTexture(PChar(filename));
  card := TCard.Create(asuit, acard, texture);
  result := card;
end;

function TCards.GetCardCount: integer;
begin
  result := m_cards.Count;
end;

procedure TCards.LoadCards;
begin
  // CLUBS
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 0, 'assets/clubs/A_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 1, 'assets/clubs/2_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 2, 'assets/clubs/3_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 3, 'assets/clubs/4_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 4, 'assets/clubs/5_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 5, 'assets/clubs/6_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 6, 'assets/clubs/7_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 7, 'assets/clubs/8_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 8, 'assets/clubs/9_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 9, 'assets/clubs/10_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 10, 'assets/clubs/J_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 11, 'assets/clubs/Q_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 12, 'assets/clubs/K_clubs.png'));

  // DIAMONDS
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 0, 'assets/diamonds/A_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 1, 'assets/diamonds/2_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 2, 'assets/diamonds/3_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 3, 'assets/diamonds/4_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 4, 'assets/diamonds/5_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 5, 'assets/diamonds/6_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 6, 'assets/diamonds/7_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 7, 'assets/diamonds/8_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 8, 'assets/diamonds/9_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 9, 'assets/diamonds/10_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 10, 'assets/diamonds/J_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 11, 'assets/diamonds/Q_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 12, 'assets/diamonds/K_diamonds.png'));

  // HEARTS
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 0, 'assets/hearts/A_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 1, 'assets/hearts/2_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 2, 'assets/hearts/3_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 3, 'assets/hearts/4_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 4, 'assets/hearts/5_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 5, 'assets/hearts/6_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 6, 'assets/hearts/7_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 7, 'assets/hearts/8_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 8, 'assets/hearts/9_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 9, 'assets/hearts/10_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 10, 'assets/hearts/J_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 11, 'assets/hearts/Q_hearts.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 12, 'assets/hearts/K_hearts.png'));

  // SPADES
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 0, 'assets/spades/A_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 1, 'assets/spades/2_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 2, 'assets/spades/3_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 3, 'assets/spades/4_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 4, 'assets/spades/5_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 5, 'assets/spades/6_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 6, 'assets/spades/7_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 7, 'assets/spades/8_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 8, 'assets/spades/9_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 9, 'assets/spades/10_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 10, 'assets/spades/J_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 11, 'assets/spades/Q_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 12, 'assets/spades/K_spades.png'));
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
  LoadCards;
  Shuffle;
end;

destructor TCards.Destroy;
begin
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

end.

