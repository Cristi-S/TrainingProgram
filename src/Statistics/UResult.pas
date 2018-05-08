unit UResult;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormResult = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditQuestionsCount: TEdit;
    EditCorrectAnswerCount: TEdit;
    Label3: TLabel;
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormResult: TFormResult;

implementation

{$R *.dfm}

uses UMain;

procedure TFormResult.Button1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    FormMain.Memo1.Lines.SaveToFile(SaveDialog1.FileName);

  Close;
end;

procedure TFormResult.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.
