unit overrideitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, abilityitem, carditem;

type

  { TOverride }

  TOverride = class
  private
    m_abilities: TAbilityList;
    m_addition: integer;
    m_multiplier: single;
    m_allCardsScore: boolean;
    procedure Reset;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Process(cards: TCardList; abilities: TAbilityList);
    property Addition: integer read m_addition;
    property Multiplier: single read m_multiplier;
    property AllCardsScore: boolean read m_allCardsScore;
  end;

implementation

{ TOverride }

procedure TOverride.Reset;
begin
  m_addition := 0;
  m_multiplier := 1.0;
  m_allCardsScore := false;

  m_abilities := TAbilityList.Create;
end;

constructor TOverride.Create;
begin
  Reset;
end;

destructor TOverride.Destroy;
var
  ability: TAbility;

begin
  for ability in m_abilities do
    ability.Free;

  m_abilities.Free;

  inherited Destroy;
end;

procedure TOverride.Process(cards: TCardList; abilities: TAbilityList);
var
  ability: TAbility;

begin
  Reset;

  for ability in m_abilities do
  begin
    // NEED LIST OF CHOSEN CARDS TO CONSIDER!
    // NEED TO CONSIDER CONDITIONS!
    if ABILITY_ALLCARDSCORE in ability.Actions then
      m_allCardsScore := true;
    if ABILITY_ADDITION in ability.Actions then
      m_addition := m_addition + round(ability.Values[VALUE_ADDITION]);
    if ABILITY_MULTIPLIER in ability.Actions then
      m_multiplier := m_multiplier * ability.Values[VALUE_MULTIPLIER];

  end;
end;

end.

