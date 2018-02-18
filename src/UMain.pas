unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Control1, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    FlowPanel1: TFlowPanel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  List:array[1..5] of TControl1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  ListItem:TControl1;
  i: Integer;
begin
  for i := 1 to 5 do
    begin
      if (not Assigned(List[i])) then
      begin
        ListItem:= TControl1.Create(FlowPanel1);
        ListItem.IsLast:=False;
        ListItem.Refresh;

        List[i]:=ListItem;
      end;
    end;

    ListItem.IsLast:=true;
    FlowPanel1.Height:=ListItem.MinHeigth+5;
end;

end.
