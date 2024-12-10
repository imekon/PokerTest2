program unittests;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, rulestest, rulesitem, bucketitem;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

