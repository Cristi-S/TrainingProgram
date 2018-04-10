unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Control1, Vcl.ExtCtrls,
  UList, UListItem, Unit2;

type
  TForm1 = class(TForm)
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
    Button7: TButton;
    Button8: TButton;
    Label1: TLabel;
    Button3: TButton;
    ScrollBox1: TScrollBox;
    FlowPanel1: TPanel;
    Memo1: TMemo;
    Button9: TButton;
    Button10: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RedrawPanel();
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ListControl: TList<TListControl>;
  // контейнер списка
  List: TList;

implementation

{$R *.dfm}

procedure TForm1.RedrawPanel();
var
  i: integer;
  width: integer;
begin
  width := 0;
  for i := 0 to ListControl.Count - 1 do
  begin
    ListControl.Items[i].Left := width;
    if ListControl.Items[i].State = add then
      width := width + ListControl.Items[i].width -
        (ListControl.Items[i].ItemWidth + ListControl.Items[i].ArrowWidth)
    else
      width := width + ListControl.Items[i].width;
    ListControl[i].Refresh;
  end;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  ListControl.Last.ItemMain.Visible := false;
  ListControl.Last.Refresh;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  ListItem: TListControl;
  i, j, k: integer;
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
      // if (not ControlList[i] = null) then
      // begin
      ListItem := TListControl.Create(FlowPanel1);
      if i = 1 then
      begin

        ListItem.Top := 0;
        ListItem.Left := 0;
      end
      else
      begin
        // ListItem.Left := ListControl.Items[0].Width;
      end;
      ListItem.ItemMain.TitleMain := s1;
      ListItem.ItemMain.TitleNext := s2;
      if i = 1 then
      begin
        ListItem.IsFirst := True;
        ListItem.IsAddBefore := True;
      end;
      ListItem.IsLast := false;
      // ListItem.Refresh;
      ListControl.add(ListItem);
      // end;
      RedrawPanel();
    end;
  if RadioButton2.Checked = True then
  begin
    // if (not ControlList[i] = null) then
    // begin
    ListItem := TListControl.Create(FlowPanel1);
    ListItem.IsLast := false;
    // ListItem.Refresh;

    ListControl.add(ListItem);
  end;
  ListItem.IsLast := True;
  // if (not ControlList[i] = null) then
  Button8.Enabled := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ListItem: TListControl;
begin
  // if ControlList[1].AddAfterStep > 4 then
  // begin
  // ListItem := TControl1.Create(FlowPanel1);
  // ListItem.IsLast := False;
  // // ListItem.Refresh;
  //
  // ControlList[i] := ListItem;
  // end
  // else
  // Inc(ListControl[1].AddAfterStep);

  ListControl[1].Refresh;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  ListItem: TListControl;
  i, k: integer;
  s1, s2: string;
begin
  Form2.ShowModal;
  s1 := Form2.Edit1.Text;
  ListItem := TListControl.Create(FlowPanel1);
  // ListItem.ItemMain.Arrow1.visible := True;
  ListItem.ItemMain.TitleMain := s1;
  ListItem.IsLast := false;
  // ListItem.Refresh;
  // ControlList[i] := ListItem;

  ListItem.IsLast := True;

  Button8.Enabled := True;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  ListItem: TListControl;
  i, k: integer;
  s1, s2: string;
begin
  k := StrToInt(InputBox('Новый элемент',
    'Введите номер элемента,ПОСЛЕ которого хотите добавить новый элемент:', '1')
    );

  ListItem := TListControl.Create(FlowPanel1);
  ListItem.ItemMain.TitleMain := 'new';
  ListItem.ItemMain.TitleNext := 'nul';
  ListItem.ItemMain.TitlePrev := 'nul';
  if ListControl[k].IsLast then
  begin
    ListItem.State := normal;
    ListItem.IsLast := True;
  end
  else
  begin
    ListItem.State := new;
    ListControl[k].State := add;
  end;

  ListControl.Insert(k + 1, ListItem);

  RedrawPanel();
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  i: integer;
begin
  // count := 0;
  // for i := 1 to Length(ControlList) do
  // if ControlList[i]= null then
  // Inc(count);

  for i := 1 to ListControl.Count do
  begin

    FlowPanel1.Controls[0].DisposeOf;
    // ListControl.Delete(0);
  end;

end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  ListControl.Last.ItemMain.color := clRed;
  ListControl.Last.Refresh;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  If not(Key in ['0' .. '9', #8]) then
    Key := #0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  List := TList.Create;
  ListControl := TList<TListControl>.Create;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  if RadioButton1.Checked = True then
  begin
    Edit1.ReadOnly := false;
    Button1.Enabled := True;
  end;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  if RadioButton2.Checked = True then

  begin
    Button3.Enabled := True;
    Edit1.ReadOnly := false;
    Button1.Enabled := True;
  end
end;

end.
