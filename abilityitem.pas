unit abilityitem;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type
  TAbilityType = (ABILITY_ALLCARDSCORE);

  { TAbility }

  TAbility = class
  private
    m_type: TAbilityType;
  public
    constructor Create(atype: TAbilityType); virtual;
    property AbilityType: TAbilityType read m_type;
  end;

  TAbilityList = specialize TFPGList<TAbility>;

implementation

{ TAbility }

constructor TAbility.Create(atype: TAbilityType);
begin
  m_type := atype;
end;

end.

