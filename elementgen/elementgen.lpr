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

procedure ProcessElements;
var
  elements: TElements;

begin
  elements := TElements.Create;
  elements.LoadFromFile('../assets/elements.db');

  //CopyFile('../assets/elements.db', '../assets/elements.bak');

  elements.SaveToFile('../assets/elements.db');

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
  elements.LoadFromFile('../assets/elements.db');

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

begin
  StatsElements;
  WriteLn('Press RETURN...');
  ReadLn;
end.

