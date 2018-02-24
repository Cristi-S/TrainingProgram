program Training;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {Form1},
  Control1 in 'Control1.pas',
  UList in 'Classes\UList.pas',
  UListItem in 'Classes\UListItem.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
