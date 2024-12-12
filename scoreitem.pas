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

implementation

{ TScoringLadder }

const
  ScoringDefault: array [ROYAL_FLUSH..NO_SCORE] of TScoringRung =
    (
      (Adder: 20; Multiplier: 20),
      (Adder: 17; Multiplier: 18),
      (Adder: 15; Multiplier: 16),
      (Adder: 12; Multiplier: 14),
      (Adder: 10; Multiplier: 12),
      (Adder: 9; Multiplier: 10),
      (Adder: 7; Multiplier: 8),
      (Adder: 5; Multiplier: 4),
      (Adder: 4; Multiplier: 2),
      (Adder: 2; Multiplier: 1),
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

end.

