unit utilities;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib;

  function Vec2(x, y: single): TVector2;

implementation

function Vec2(x, y: single): TVector2;
begin
  result.x := x;
  result.y := y;
end;

end.

