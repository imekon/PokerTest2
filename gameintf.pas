unit gameintf;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  IGame = interface
    procedure AddAdditive(amount: integer);
    procedure AddMultiplier(amount: integer);
    procedure MultMultiplier(amount: single);
  end;

implementation

end.

