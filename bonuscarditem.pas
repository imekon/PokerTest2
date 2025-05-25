unit bonuscarditem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type

  { TBonusCardItem }

  TBonusCard = class
  private
    m_name: string;
  protected
    function GetAdditive: integer; virtual;
    function GetMultiplier: integer; virtual;
  public
    constructor Create(const aname: string); virtual;

    property Name: string read m_name;
    property Additive: integer read GetAdditive;
    property Multiplier: integer read GetMultiplier;
  end;

  { TAddititiveBonusCard }

  TAdditiveBonusCard = class(TBonusCard)
  private
    m_additive: integer;
  protected
    function GetAdditive: integer; override;
  public
    constructor Create(const aname: string; addition: integer);
  end;

  TBonusCardList = specialize TFPGList<TBonusCard>;

  { TBonusCardManager }

  TBonusCardManager = class
  private
    m_cards: TBonusCardList;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TBonusCard }

function TBonusCard.GetAdditive: integer;
begin
  result := 0;
end;

function TBonusCard.GetMultiplier: integer;
begin
  result := 1;
end;

constructor TBonusCard.Create(const aname: string);
begin
  m_name := 'untitled';
end;

{ TAdditiveBonusCard }

function TAdditiveBonusCard.GetAdditive: integer;
begin
  Result := m_additive;
end;

constructor TAdditiveBonusCard.Create(const aname: string; addition: integer);
begin
  m_additive := addition;
  TBonusCard.Create(aname);
end;

{ TBonusCardManager }

constructor TBonusCardManager.Create;
var
  card: TBonusCard;

begin
  m_cards := TBonusCardList.Create;
  card := TAdditiveBonusCard.Create('Add50', 50);
end;

destructor TBonusCardManager.Destroy;
begin
  m_cards.Free;
  inherited Destroy;
end;

end.

