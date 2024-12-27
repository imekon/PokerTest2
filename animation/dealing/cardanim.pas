unit cardanim;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib, animator;

type

  { TCardAnimate }

  TCardAnimate = class(TAnimateData)
  private
    m_texture: TTexture2D;
  public
    constructor Create(texture: TTexture2D);
    procedure Draw(anim: TAnimate); override;
  end;

implementation

{ TCardAnimate }

constructor TCardAnimate.Create(texture: TTexture2D);
begin
  inherited Create(0);
  m_texture := texture;
end;

procedure TCardAnimate.Draw(anim: TAnimate);
var
  animCoord: TAnimateCoord;

begin
  animCoord := anim as TAnimateCoord;
  DrawTexture(m_texture, round(animCoord.Where.x), round(animCoord.Where.y), WHITE);
end;

end.

