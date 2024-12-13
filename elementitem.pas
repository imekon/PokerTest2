unit elementitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, csvdocument;

type

  TElementType = (ELEMENT_METAL, ELEMENT_NONMETAL, ELEMENT_GAS);

  { TElement }

  TElement = class
  private
    m_number: integer;
    m_ev: single;
    m_symbol: string;
    m_name: string;
    m_type: TElementType;
  public
    constructor Create(anumber: integer; anev: single; asymbol: string; aname: string; atype: TElementType);
    property Number: integer read m_number;
    property EV: single read m_ev;
    property Symbol: string read m_symbol;
    property Name: string read m_name;
    property ElementType: TElementType read m_type;
  end;

  TElementList = specialize TFPGList<TElement>;

  { TElements }

  TElements = class
  private
    m_elements: TElementList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(const filename: string);
    property Elements: TElementList read m_elements;
  end;

implementation

constructor TElement.Create(anumber: integer; anev: single; asymbol: string;
  aname: string; atype: TElementType);
begin
  m_number := anumber;
  m_ev := anev;
  m_symbol := asymbol;
  m_name := aname;
  m_type := atype;
end;

{ TElements }

constructor TElements.Create;
begin
  m_elements := TElementList.Create;
end;

destructor TElements.Destroy;
var
  element: TElement;

begin
  for element in m_elements do
    element.Free;

  inherited Destroy;
end;

procedure TElements.LoadFromFile(const filename: string);
var
  row: integer;
  csv: TCsvDocument;
  number: integer;
  ev: single;
  symbol: string;
  name: string;
  elementTypeName: string;
  elementType: TElementType;
  element: TElement;

begin
  csv := TCSVDocument.Create;
  try
    csv.Delimiter := ',';
    csv.LoadFromFile(filename);
    for row := 0 to csv.RowCount - 1 do
    begin
      number := StrToInt(csv.Cells[0, row]);
      ev := StrToFloat(csv.Cells[1, row]);
      symbol := csv.Cells[2, row];
      name := csv.Cells[3, row];
      elementTypeName := csv.Cells[4, row];
      case elementTypeName of
        'metal': elementType := ELEMENT_METAL;
        'nonmetal': elementType := ELEMENT_NONMETAL;
        'gas': elementType := ELEMENT_GAS;
      end;
      element := TElement.Create(number, ev, symbol, name, elementType);
      m_elements.Add(element);
    end;
  finally
    csv.Free;
  end;
end;

end.

