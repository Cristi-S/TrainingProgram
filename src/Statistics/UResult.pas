unit UResult;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormResult = class(TForm)
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    Memo2: TMemo;
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
var
  str: string;
begin
  if SaveDialog1.Execute then
  begin
    str := Memo2.Lines.Text;
    Memo2.Lines.Text := Memo1.Lines.Text + str;
    Memo2.Lines.SaveToFile(SaveDialog1.FileName);
  end;

  Close;
end;

procedure TFormResult.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.
