program TestApp;

uses
  Vcl.Forms,
  UnitMain in 'C:\Users\Тимур\Documents\Embarcadero\Studio\Projects\Threads\UnitMain.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
