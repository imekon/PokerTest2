unit loading;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TLoading }

  TLoading = class(TThread)
  private
    m_progress: single;
  protected
    procedure Execute; override;
  public
    constructor Create;
    procedure Load;
    property Progress: single read m_progress;
  end;

implementation

{ TLoading }

constructor TLoading.Create;
begin
  inherited Create(true);
  m_progress := 0;
end;

procedure TLoading.Load;
var
  i: integer;

begin
  for i := 1 to 54 do
  begin
    m_progress := i / 54.0;
    Sleep(500);
  end;
end;

procedure TLoading.Execute;
begin
  Load;
end;

end.

