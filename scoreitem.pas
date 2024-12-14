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

unit scoreitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, carditem;

type
  TScoringRung = record
    Adder: integer;
    Multiplier: integer;
  end;

  { TScoringLadder }

  TScoringLadder = class
  private
    m_scoring: array [ROYAL_FLUSH..NO_SCORE] of TScoringRung;
  public
    constructor Create;
    function Scoring(hand: TPokerScore; score, adder, multiplier: integer): integer;
  end;

  { TRoundsLadder }

  TRoundsLadder = class
  private
    m_score: array [1..12] of integer;
  public
    constructor Create;
    function GetScore(level: integer): integer;
  end;

implementation

{ TScoringLadder }

const
  ScoringDefault: array [ROYAL_FLUSH..NO_SCORE] of TScoringRung =
    (
      (Adder: 10; Multiplier: 16),
      (Adder: 9; Multiplier: 16),
      (Adder: 8; Multiplier: 8),
      (Adder: 7; Multiplier: 8),
      (Adder: 6; Multiplier: 4),
      (Adder: 5; Multiplier: 4),
      (Adder: 4; Multiplier: 2),
      (Adder: 3; Multiplier: 2),
      (Adder: 2; Multiplier: 1),
      (Adder: 1; Multiplier: 1),
      (Adder: 0; Multiplier: 0)
    );

constructor TScoringLadder.Create;
var
  i: TPokerScore;

begin
  for i := Low(ScoringDefault) to High(ScoringDefault) do
    m_scoring[i] := ScoringDefault[i];
end;

function TScoringLadder.Scoring(hand: TPokerScore; score, adder,
  multiplier: integer): integer;
begin
  result := (m_scoring[hand].Adder + score + adder) * m_scoring[hand].Multiplier * multiplier;
end;

{ TRoundsLadder }

const
  scores: array [1..12] of integer =
    (500, 1000, 1500, 2000, 3000, 5000,
    10000, 12000, 15000, 20000, 22000, 25000);

constructor TRoundsLadder.Create;
var
  i: integer;

begin
  for i := Low(scores) to High(scores) do
    m_score[i] := scores[i];
end;

function TRoundsLadder.GetScore(level: integer): integer;
begin
  result := m_score[level];
end;

end.

