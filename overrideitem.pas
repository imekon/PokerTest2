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

unit overrideitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, abilityitem, carditem;

type

  { TOverride }

  TOverride = class
  private
    m_addition: integer;
    m_multiplier: single;
    m_allCardsScore: boolean;
    procedure Reset;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Process(cards: TCardList);
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
end;

constructor TOverride.Create;
begin
  Reset;
end;

destructor TOverride.Destroy;
begin
  inherited Destroy;
end;

procedure TOverride.Process(cards: TCardList);
begin
  Reset;
end;

end.

