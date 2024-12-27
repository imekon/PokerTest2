unit coord;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TCoord = record
    x, y: integer;
  end;

  TCoordF = record
    x, y: double;
  end;

  TCoordDynArray = array of TCoord;

const
  InvalidCoord: TCoord = (x: -1; y: -1);

  function CreateCoord(x, y: double): TCoordF;

implementation

function CreateCoord(x, y: double): TCoordF;
begin
  result.x := x;
  result.y := y;
end;

end.

