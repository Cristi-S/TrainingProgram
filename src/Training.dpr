program Training;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {Form1},
  UList in 'Classes\UList.pas',
  UListItem in 'Classes\UListItem.pas',
  UnitNewItem in 'UnitNewItem.pas' {Form2},
  Control1 in 'Control1.pas',
  Logger in 'Logger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
