unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Control1, Vcl.ExtCtrls, UList, UListItem;

type
  TForm1 = class(TForm)
    Button1: TButton;
    FlowPanel1: TFlowPanel;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ControlList:array[1..5] of TControl1;
  List:TList;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  ListItem:TControl1;
  i: Integer;
begin
  for i := 1 to 5 do
    begin
      if (not Assigned(ControlList[i])) then
      begin
        ListItem:= TControl1.Create(FlowPanel1);
        ListItem.IsLast:=False;
        ListItem.Refresh;

        ControlList[i]:=ListItem;
      end;
    end;

    ListItem.IsLast:=true;
    FlowPanel1.Height:=ListItem.MinHeigth+5;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  List.NextStep();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  List:=TList.Create;
end;

end.
