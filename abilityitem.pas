unit abilityitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type
  TAbilityType = (ABILITY_ALLCARDSCORE, ABILITY_ADDITION, ABILITY_MULTIPLIER, ABILITY_CREDITS);
  TConditionType = (CONDITION_CLUBS, CONDITION_DIAMONDS, CONDITION_HEARTS,
    CONDITION_SPADES);
  TValueIndex = (VALUE_ADDITION, VALUE_MULTIPLIER, VALUE_CREDITS);
  TAbilityMask = set of TAbilityType;
  TConditionMask = set of TConditionType;

  { TAbility }

  TAbility = class
  private
    m_actions: TAbilityMask;
    m_conditions: TConditionMask;
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

function TAbility.GetValue(index: TValueIndex): single;
begin
  result := m_values[index];
end;

constructor TAbility.Create(aconditions: TConditionMask; aactions: TAbilityMask);
begin
  m_conditions := aconditions;
  m_actions := aactions;
  m_values[VALUE_ADDITION] := 0.0;
  m_values[VALUE_MULTIPLIER] := 1.0;
  m_values[VALUE_CREDITS] := 0.0;
end;

end.

