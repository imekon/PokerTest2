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

unit handitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, carditem;

type

  { THand }

  THand = class
  private
    m_cards: TCardList;
    function GetAnySelected: boolean;
    function GetSelectedCount: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(acard: TCard);
    procedure Sort;
    procedure Remove(acard: TCard);
    property Cards: TCardList read m_cards;
    property SelectedCount: integer read GetSelectedCount;
    property AnySelected: boolean read GetAnySelected;
  end;



implementation

{ THand }

function THand.GetSelectedCount: integer;
var
  total: integer;
  card: TCard;

begin
  total := 0;

  for card in m_cards do
    if card.Selected then inc(total);

  result := total;
end;

function THand.GetAnySelected: boolean;
var
  card: TCard;

begin
  result := false;

  for card in m_cards do
    if card.Selected then
    begin
      result := true;
      exit;
    end;
end;

constructor THand.Create;
begin
  m_cards := TCardList.Create;
end;

destructor THand.Destroy;
begin
  m_cards.Free;
  inherited Destroy;
end;

procedure THand.Clear;
begin
  m_cards.Clear;
end;

procedure THand.Add(acard: TCard);
begin
  m_cards.Add(acard);
end;

function CompareCards(const first, second: TCard): integer;
begin
  result := 0;
  if first.CardOrder = second.CardOrder then
  begin
    if first.Suit > second.Suit then
      result := -1
    else if first.Suit < second.Suit then
      result := 1;
  end
  else
  begin
    if first.CardOrder > second.CardOrder then
      result := -1
    else if first.CardOrder < second.CardOrder then
      result := 1;
  end;
end;

procedure THand.Sort;
begin
  m_cards.Sort(@CompareCards);
end;

procedure THand.Remove(acard: TCard);
begin
  m_cards.Remove(acard);
end;



end.

