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
    function Scoring(hand: TPokerScore; score: integer): integer;
  end;

implementation

{ TScoringLadder }

const
  ScoringDefault: array [ROYAL_FLUSH..NO_SCORE] of TScoringRung =
    (
      (Adder: 50; Multiplier: 20),
      (Adder: 45; Multiplier: 18),
      (Adder: 40; Multiplier: 16),
      (Adder: 35; Multiplier: 14),
      (Adder: 30; Multiplier: 12),
      (Adder: 25; Multiplier: 10),
      (Adder: 20; Multiplier: 8),
      (Adder: 15; Multiplier: 6),
      (Adder: 10; Multiplier: 4),
      (Adder: 5; Multiplier: 2),
      (Adder: 0; Multiplier: 0)
    );

constructor TScoringLadder.Create;
var
  i: TPokerScore;

begin
  for i := Low(ScoringDefault) to High(ScoringDefault) do
    m_scoring[i] := ScoringDefault[i];
end;

function TScoringLadder.Scoring(hand: TPokerScore; score: integer): integer;
begin
  result := (m_scoring[hand].Adder + score) * m_scoring[hand].Multiplier;
end;

end.

