program Training;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FormMain},
  UList in 'Classes\UList.pas',
  UListItem in 'Classes\UListItem.pas',
  UnitNewItem in 'UnitNewItem.pas' {Form2},
  Control1 in 'Controls\Control1.pas',
  Logger in 'Utilites\Logger.pas',
  UQuestions in 'Statistics\UQuestions.pas',
  UAnwer in 'Statistics\UAnwer.pas' {FormAnswer},
  UEnum in 'Enum\UEnum.pas',
  UDriver in 'UDriver.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TFormAnswer, FormAnswer);
  Application.Run;
end.
