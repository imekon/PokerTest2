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

unit abilityitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, carditem;

type
  TAbilityType = (ABILITY_ALLCARDSCORE,
                  ABILITY_ADDITION,
                  ABILITY_MULTIPLIER_ADD,
                  ABILITY_MULTIPLIER_MULTIPLY,
                  ABILITY_CREDITS);

  TConditionType = (CONDITION_CLUBS,
                    CONDITION_DIAMONDS,
                    CONDITION_HEARTS,
                    CONDITION_SPADES);

  TValueIndex = (VALUE_ADDITION,
                 VALUE_MULTIPLIER,
                 VALUE_CREDITS);

  TAbilityMask = set of TAbilityType;
  TConditionMask = set of TConditionType;

  { TAbility }

  TAbility = class
  protected
    m_cost: integer;
  public
    constructor Create(acost: integer);
    property Cost: integer read m_cost;
  end;

  { TCardAbility }

  TCardAbility = class(TAbility)
  private
    m_card: TCardIndex;
    m_suit: TSuit;
  public
    constructor Create(acard: TCardIndex; asuit: TSuit);
  end;

  { TConditionAbility }

  TConditionAbility = class(TAbility)
  private
    m_actions: TAbilityMask;
    m_conditions: TConditionMask; // Maybe make condition a separate class, aggregate?
    m_values: array [VALUE_ADDITION..VALUE_CREDITS] of single;
    function GetValue(index: TValueIndex): single;
  public
    constructor Create(aconditions: TConditionMask; aactions: TAbilityMask); virtual;
    property Conditions: TConditionMask read m_conditions;
    property Actions: TAbilityMask read m_actions;
    property Values[index: TValueIndex]: single read GetValue;
  end;

  TAbilityList = specialize TFPGList<TAbility>;

implementation

{ TAbility }

constructor TAbility.Create(acost: integer);
begin
  m_cost := acost;
end;

{ TCardAbility }

constructor TCardAbility.Create(acard: TCardIndex; asuit: TSuit);
begin
  inherited Create(10);

  m_card := acard;
  m_suit := asuit;
end;

{ TConditionAbility }

function TConditionAbility.GetValue(index: TValueIndex): single;
begin
  result := m_values[index];
end;

constructor TConditionAbility.Create(aconditions: TConditionMask; aactions: TAbilityMask);
begin
  inherited Create(20);

  m_conditions := aconditions;
  m_actions := aactions;
  m_values[VALUE_ADDITION] := 0.0;
  m_values[VALUE_MULTIPLIER] := 1.0;
  m_values[VALUE_CREDITS] := 0.0;
end;

end.

