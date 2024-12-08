unit carditem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, raylib;

type
  TSuit = (SUIT_CLUBS, SUIT_DIAMONDS, SUIT_HEARTS, SUIT_SPADES, SUIT_OTHER);
  TCardIndex = 0..12;
  TPokerScore = (ROYAL_FLUSH, STRAIGHT_FLUSH, FOUR_OF_A_KIND, FULL_HOUSE,
    FLUSH, STRAIGHT, THREE_OF_A_KIND, TWO_PAIR, PAIR, HIGH_CARD);

  { TCard }

  TCard = class
  private
    m_texture: TTexture2D;
    m_suit: TSuit;
    m_card: TCardIndex;
    m_selected: boolean;
    function GetCardOrder: integer;
  public
    constructor Create(asuit: TSuit; acard: TCardIndex; atexture: TTexture2D);
    destructor Destroy; override;
    property Suit: TSuit read m_suit;
    property CardIndex: TCardIndex read m_card;
    property CardOrder: integer read GetCardOrder;
    property Selected: boolean read m_selected write m_selected;
    property Texture: TTexture2D read m_texture;
  end;

  TCardList = specialize TFPGList<TCard>;

  { TCards }

  TCards = class
  private
    m_cards: TCardList;
    function CreateCard(asuit: TSuit; acard: TCardIndex; const filename: string): TCard;
    procedure LoadCards;
    procedure SwapCards(a, b: integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Shuffle;
    function Remove: TCard;
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

procedure TCards.LoadCards;
begin
  // CLUBS
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 0, 'assets/clubs/a_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 1, 'assets/clubs/2_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 2, 'assets/clubs/3_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 3, 'assets/clubs/4_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 4, 'assets/clubs/5_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 5, 'assets/clubs/6_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 6, 'assets/clubs/7_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 7, 'assets/clubs/8_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 8, 'assets/clubs/9_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 9, 'assets/clubs/10_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 10, 'assets/clubs/j_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 11, 'assets/clubs/q_clubs.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_CLUBS, 12, 'assets/clubs/k_clubs.png'));

  // DIAMONDS
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 0, 'assets/diamonds/a_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 1, 'assets/diamonds/2_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 2, 'assets/diamonds/3_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 3, 'assets/diamonds/4_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 4, 'assets/diamonds/5_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 5, 'assets/diamonds/6_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 6, 'assets/diamonds/7_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 7, 'assets/diamonds/8_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 8, 'assets/diamonds/9_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 9, 'assets/diamonds/10_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 10, 'assets/diamonds/j_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 11, 'assets/diamonds/q_diamonds.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_DIAMONDS, 12, 'assets/diamonds/k_diamonds.png'));

  // HEARTS
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 0, 'assets/heart/a_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 1, 'assets/heart/2_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 2, 'assets/heart/3_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 3, 'assets/heart/4_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 4, 'assets/heart/5_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 5, 'assets/heart/6_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 6, 'assets/heart/7_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 7, 'assets/heart/8_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 8, 'assets/heart/9_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 9, 'assets/heart/10_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 10, 'assets/heart/j_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 11, 'assets/heart/q_heart.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_HEARTS, 12, 'assets/heart/k_heart.png'));

  // SPADES
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 0, 'assets/spades/a_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 1, 'assets/spades/2_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 2, 'assets/spades/3_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 3, 'assets/spades/4_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 4, 'assets/spades/5_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 5, 'assets/spades/6_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 6, 'assets/spades/7_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 7, 'assets/spades/8_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 8, 'assets/spades/9_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 9, 'assets/spades/10_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 10, 'assets/spades/j_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 11, 'assets/spades/q_spades.png'));
  m_cards.Add(CreateCard(TSuit.SUIT_SPADES, 12, 'assets/spades/k_spades.png'));
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
  i, other: integer;

begin
  for i := 0 to m_cards.Count - 1 do
  begin
    other := Random(52);
    while other = i do
      other := Random(52);

    SwapCards(i, other);
  end;
end;

function TCards.Remove: TCard;
var
  card: TCard;

begin
  card := m_cards[0];
  m_cards.Remove(card);
  result := card;
end;

end.

