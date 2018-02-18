unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Control1, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Control11: TControl1;
    FlowPanel1: TFlowPanel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin

  Control11.TitleMain:='Заголовок';
  Control11.TitleNext:='Null';
  Control11.TitlePrev:='Null';

  Control11.Refresh;
end;

end.
