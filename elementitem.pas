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

