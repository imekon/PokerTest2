unit abilityitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type
  TAbilityType = (ABILITY_ALLCARDSCORE, ABILITY_ADDITION, ABILITY_MULTIPLIER);
  TConditionType = (CONDITION_CLUBS, CONDITION_DIAMONDS, CONDITION_HEARTS,
    CONDITION_SPADES);
  TAbilityMask = set of TAbilityType;
  TConditionMask = set of TConditionType;

  { TAbility }

  TAbility = class
  private
    m_actions: TAbilityMask;
    m_conditions: TConditionMask;
    m_value: single; // TODO; more than one?
  public
    constructor Create(aconditions: TConditionMask; aactions: TAbilityMask); virtual;
    property Conditions: TConditionMask read m_conditions;
    property Actions: TAbilityMask read m_actions;
  end;

  TAbilityList = specialize TFPGList<TAbility>;

implementation

{ TAbility }

constructor TAbility.Create(aconditions: TConditionMask; aactions: TAbilityMask);
begin
  m_conditions := aconditions;
  m_actions := aactions;
  m_value := 0.0;
end;

end.

