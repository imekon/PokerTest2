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

program elementgen;

uses
  fileutil, elementitem;

const
  DBFile = '../assets/elements.db';
  BackupFile = '../assets/elements.bak';

procedure ProcessElements;
var
  elements: TElements;

begin
  elements := TElements.Create;
  elements.LoadFromFile(DBFile);

  //CopyFile(DBFile, BackupFile);

  elements.SaveToFile(DBFile);

  elements.Free;
end;

procedure StatsElements;
var
  none: integer;
  reserved: integer;
  special: integer;

  elements: TElements;
  element: TElement;

begin
  elements := TElements.Create;
  elements.LoadFromFile(DBFile);

  none := 0;
  reserved := 0;
  special := 0;

  for element in elements.Elements do
  begin
    case element.AbilityName of
      'none': inc(none);
      'reserved': inc(reserved);
      'special': inc(special);
    end;
  end;

  WriteLn('None: ', none);
  WriteLn('Reserved: ', reserved);
  WriteLn('Special: ', special);

  elements.Free;
end;

procedure CardElements;
var
  elements: TElements;
  element: TElement;
  card: integer;
  suit: integer;
  name: string;

  function CardName(card: integer): string;
  begin
    case card of
      1: result := 'A';
      2: result := '2';
      3: result := '3';
      4: result := '4';
      5: result := '5';
      6: result := '6';
      7: result := '7';
      8: result := '8';
      9: result := '9';
      10: result := '10';
      11: result := 'J';
      12: result := 'Q';
      13: result := 'K';
    end;
  end;

  function SuitName(suit: integer): string;
  begin
    case suit of
      1: result := 'Clubs';
      2: result := 'Diamonds';
      3: result := 'Hearts';
      4: result := 'Spades';
    end;
  end;

begin
  elements := TElements.Create;
  elements.LoadFromFile(DBFile);

  card := 1;
  suit := 1;

  for element in elements.Elements do
  begin
    if element.AbilityName = 'none' then
    begin
      name := 'Card:' + CardName(card) + ':' + SuitName(suit);
      inc(card);
      element.AbilityName := name;
      WriteLn('Card name: ', name);

      if card > 13 then
      begin
        inc(suit);
        if suit > 4 then break;
        card := 1;
      end;
    end;
  end;

  elements.SaveToFile(DBFile);

  elements.Free;
end;

begin
  CardElements;
  WriteLn('Press RETURN...');
  ReadLn;
end.

