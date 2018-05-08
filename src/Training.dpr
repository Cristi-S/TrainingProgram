program Training;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FormMain},
  UList in 'Classes\UList.pas',
  UListItem in 'Classes\UListItem.pas',
  ListItemControl in 'Controls\ListItemControl.pas',
  Logger in 'Utilites\Logger.pas',
  UQuestions in 'Statistics\UQuestions.pas',
  UAnwer in 'Statistics\UAnwer.pas' {FormAnswer},
  UEnum in 'Enum\UEnum.pas',
  UDriver in 'UDriver.pas',
  UnitStart in 'Statistics\UnitStart.pas' {FormStart},
  UResult in 'Statistics\UResult.pas' {FormResult};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormStart, FormStart);
  Application.CreateForm(TFormResult, FormResult);
  Application.Run;

end.
