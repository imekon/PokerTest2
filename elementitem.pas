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

unit elementitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, csvdocument, raylib, abilityitem;

type

  TElementType = (ELEMENT_METAL, ELEMENT_NONMETAL, ELEMENT_GAS);

  { TElement }

  TElement = class
  private
    m_number: integer;
    m_ev: single;
    m_symbol: string;
    m_name: string;
    m_abilityName: string;
    m_abilityDescription: string;
    m_ability: TAbility;
    m_cost: integer;
    m_type: TElementType;
  public
    constructor Create(anumber: integer; anev: single; asymbol: string;
      aname: string; anability, anabilityDesc: string; acost: integer;
      atype: TElementType);
    property Number: integer read m_number;
    property EV: single read m_ev;
    property Symbol: string read m_symbol;
    property Name: string read m_name;
    property ElementType: TElementType read m_type;
    property AbilityName: string read m_abilityName;
  end;

  TElementList = specialize TFPGList<TElement>;

  { TElements }

  TElements = class
  private
    m_elements: TElementList;
    procedure SwapElements(a, b: integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(const filename: string);
    procedure SaveToFile(const filename: string);
    procedure Shuffle;
    property Elements: TElementList read m_elements;
  end;

implementation

constructor TElement.Create(anumber: integer; anev: single; asymbol: string;
  aname: string; anability, anabilityDesc: string; acost: integer;
  atype: TElementType);
begin
  m_number := anumber;
  m_ev := anev;
  m_symbol := asymbol;
  m_name := aname;
  m_type := atype;
  m_abilityName := anability;
  m_abilityDescription := anabilityDesc;
  m_ability := nil;
  m_cost := acost;
end;

{ TElements }

procedure TElements.SwapElements(a, b: integer);
var
  element: TElement;

begin
  element := m_elements[a];
  m_elements[a] := m_elements[b];
  m_elements[b] := element;
end;

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
  abilityName: string;
  abilityDesc: string;
  elementTypeName: string;
  elementType: TElementType;
  cost: integer;
  element: TElement;

begin
  TraceLog(LOG_INFO, 'ELEMENTS: Loading periodic elements');
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
      abilityName := csv.Cells[5, row];
      abilityDesc := csv.Cells[6, row];
      cost := StrToInt(csv.Cells[7, row]);

      case elementTypeName of
        'metal': elementType := ELEMENT_METAL;
        'nonmetal': elementType := ELEMENT_NONMETAL;
        'gas': elementType := ELEMENT_GAS;
      end;
      element := TElement.Create(number, ev, symbol, name, abilityName,
        abilityDesc, cost, elementType);
      m_elements.Add(element);
    end;
  finally
    csv.Free;
  end;
  TraceLog(LOG_INFO, PChar('ELEMENTS: total count ' + IntToStr(m_elements.Count)));
end;

procedure TElements.SaveToFile(const filename: string);
var
  row: integer;
  csv: TCsvDocument;
  element: TElement;

  function ElementTypeToStr: string;
  begin
    case element.ElementType of
      ELEMENT_METAL: result := 'metal';
      ELEMENT_NONMETAL: result := 'nonmetal';
      ELEMENT_GAS: result := 'gas';
    end;
  end;

begin
  csv := TCSVDocument.Create;
  try
    csv.Delimiter := ',';
    row := 0;
    for element in m_elements do
    begin
      csv.AddRow(IntToStr(element.Number));
      csv.AddCell(row, FloatToStr(element.EV));
      csv.AddCell(row, element.Symbol);
      csv.AddCell(row, element.Name);
      csv.AddCell(row, ElementTypeToStr);
      csv.AddCell(row, element.m_abilityName);
      csv.AddCell(row, element.m_abilityDescription);
      csv.AddCell(row, IntToStr(element.m_cost));
      inc(row);
    end;
    csv.SaveToFile(filename);
  finally
    csv.Free;
  end;
end;

procedure TElements.Shuffle;
var
  i, n, other: integer;

begin
  n := m_elements.Count;

  for i := 0 to n - 1 do
  begin
    other := Random(n);
    while other = i do
      other := Random(n);

    SwapElements(i, other);
  end;
end;

end.

