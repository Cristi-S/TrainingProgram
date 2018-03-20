unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Control1, Vcl.ExtCtrls,
  UList, UListItem, Unit2;

type
  TForm1 = class(TForm)
    FlowPanel1: TFlowPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    Panel3: TPanel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Button1: TButton;
    Memo1: TMemo;
    Button7: TButton;
    Button8: TButton;
    Label1: TLabel;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  //массив контролов
  ControlList: array [1 .. 6] of TControl1;
  //контейнер списка
  List: TList;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  ListItem: TControl1;
  i, j, k: Integer;
  s1, s2: string;

begin
  j := StrToInt(Edit1.Text);
  if j > 6 then
  begin
    ShowMessage('Введите число от 1 до 7');
    exit;
  end;
  if RadioButton1.Checked = True then

    for i := 1 to j do
    begin
      k := StrToInt(InputBox('Новый элемент',
        'Введите номер элемента,ПОСЛЕ которого хотите добавить новый элемент:',
        '1'));
      Unit2.Form2.Edit2.Text := IntToStr(k);

      s2 := Form2.Edit2.Text;
      Form2.ShowModal;
      s1 := Form2.Edit1.Text;
      if (not Assigned(ControlList[i])) then
      begin
        ListItem := TControl1.Create(FlowPanel1);
        ListItem.TitleMain := s1;
        ListItem.TitleNext := s2;
        ListItem.IsLast := False;
        //ListItem.Refresh;
        ControlList[i] := ListItem;
      end;
    end;
  if RadioButton2.Checked = True then
    if (not Assigned(ControlList[i])) then
    begin
      ListItem := TControl1.Create(FlowPanel1);
      ListItem.IsLast := False;
      //ListItem.Refresh;

      ControlList[i] := ListItem;
    end;
  ListItem.IsLast := True;
  if (not Assigned(ControlList[i])) then
    Button8.Enabled := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  List.NextStep();
end;

procedure TForm1.Button3Click(Sender: TObject);
var
 ListItem: TControl1;
  i, k: Integer;
  s1, s2: string;
begin
  Form2.ShowModal;
  s1 := Form2.Edit1.Text;
  ListItem := TControl1.Create(FlowPanel1);
  ListItem.TitleMain := s1;
  ListItem.IsLast := False;
 // ListItem.Refresh;
  //ControlList[i] := ListItem;

  ListItem.IsLast := True;

  Button8.Enabled := True;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  ListItem: TControl1;
  i, k: Integer;
  s1, s2: string;
begin
  k := StrToInt(InputBox('Новый элемент',
    'Введите номер элемента,ПОСЛЕ которого хотите добавить новый элемент:', '1')
    );
  Unit2.Form2.Edit2.Text := IntToStr(k);
  s2 := Form2.Edit2.Text;
  Form2.ShowModal;
  s1 := Form2.Edit1.Text;

  ListItem := TControl1.Create(FlowPanel1);
  ListItem.TitleMain := s1;
  ListItem.TitleNext := s2;
  ListItem.IsLast := False;
  //ListItem.Refresh;
  ControlList[i] := ListItem;

  ListItem.IsLast := True;

  Button8.Enabled := True;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  i, count: Integer;
begin
  count := 0;
  for i := 1 to Length(ControlList) do
    if Assigned(ControlList[i]) then
      inc(count);

  for i := 1 to count do
  begin

    FlowPanel1.Controls[0].DisposeOf;
    ControlList[i] := nil;
  end;

end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  If not(Key in ['0' .. '9', #8]) then
    Key := #0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  List := TList.Create;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  if RadioButton1.Checked = True then
  begin
    Edit1.ReadOnly := False;
    Button1.Enabled := True;
  end;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  if RadioButton2.Checked = True then
  begin
    Button3.Enabled := True;
    Edit1.ReadOnly := False;
    Button1.Enabled := True;
  end
end;

end.
