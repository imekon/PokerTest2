unit bonuscarditem;

{$mode ObjFPC}{$H+}

interface

uses
  Types, Classes, SysUtils, StrUtils, fgl, raylib;

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

  { TPlanetBonusCard }

  TPlanetBonusCard = class(TBonusCard)
  private
    m_level: integer;
    m_additive, m_multiplier: integer;
    m_deltaAdd, m_deltaMult: integer;
  protected
    function GetAdditive: integer; override;
    function GetMultiplier: integer; override;
  public
    constructor Create(const aname: string; anadditive, amultiplier,
      deltaadd, deltamult: integer);
  end;

  TBonusCardList = specialize TFPGList<TBonusCard>;

  { TBonusCardManager }

  TBonusCardManager = class
  private
    m_cards: TBonusCardList;
    procedure LoadPlanetCards;
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

{ TPlanetBonusCard }

function TPlanetBonusCard.GetAdditive: integer;
begin
  Result := m_additive;
end;

function TPlanetBonusCard.GetMultiplier: integer;
begin
  Result := m_multiplier;
end;

constructor TPlanetBonusCard.Create(const aname: string; anadditive,
  amultiplier, deltaadd, deltamult: integer);
begin
  m_level := 1;
  m_additive := anadditive;
  m_multiplier := amultiplier;
  m_deltaAdd := deltaadd;
  m_deltaMult := deltaMult;
  TBonusCard.Create(aname);
end;

{ TBonusCardManager }

procedure TBonusCardManager.LoadPlanetCards;
var
  source: TextFile;
  line, aname: string;
  level, amult, anadd, dmult, dadd: integer;
  items: TStringDynArray;
  card: TPlanetBonusCard;

begin
  AssignFile(source, 'planetary/planets.db');
  Reset(source);
  while not eof(source) do
  begin
    readln(source, line);
    items := SplitString(line, ',');
    aname := items[0];
    amult := StrToInt(items[1]);
    anadd := StrToInt(items[2]);
    dmult := StrToInt(items[3]);
    dadd := StrToInt(items[4]);
    if amult = 0 then continue;
    card := TPlanetBonusCard.Create(aname, anadd, amult, dmult, dadd);
    TraceLog(LOG_INFO, PChar('PLANET: Load planet card ' + aname));
    m_cards.Add(card);
  end;
  CloseFile(source);
end;

constructor TBonusCardManager.Create;
var
  card: TBonusCard;

begin
  m_cards := TBonusCardList.Create;
  card := TAdditiveBonusCard.Create('Add50', 50);
  m_cards.Add(card);

  LoadPlanetCards;

  TraceLog(LOG_INFO, PChar('BONUS CARDS: ' + IntToStr(m_cards.Count) + ' loaded'));
end;

destructor TBonusCardManager.Destroy;
begin
  m_cards.Free;
  inherited Destroy;
end;

end.

