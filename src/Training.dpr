program Training;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {Form1},
  UList in 'Classes\UList.pas',
  UListItem in 'Classes\UListItem.pas',
  Unit2 in 'Unit2.pas' {Form2},
  Control1 in 'Control1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
