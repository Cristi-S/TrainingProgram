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
    ButtonAddAfter: TButton;
    ButtonAddBefore: TButton;
    ButtonDelete: TButton;
    Edit1: TEdit;
    Button2: TButton;
    ButtonCreate: TButton;
    ButtonStop: TButton;
    ButtonClear: TButton;
    Label1: TLabel;
    Button3: TButton;
    ScrollBox1: TScrollBox;
    FlowPanel1: TPanel;
    Memo1: TMemo;
    Button9: TButton;
    Button10: TButton;
    Button1: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure ButtonCreateClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ButtonAddAfterClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RedrawPanel();
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure ButtonAddBeforeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ListControl: TList<TListControl>;
  // ��������� ������
  List: TList;

implementation

{$R *.dfm}

procedure TForm1.RedrawPanel();
var
  width: integer;
  temp: TListItem;
  ListControlItem: TListControl;

  procedure PlaceControlItems();
  var
    i: integer;
  begin
    width := 0;
    for i := 0 to ListControl.Count - 1 do
    begin
      ListControl.Items[i].Left := width;
      ListControl[i].Refresh;
      if (i = 0) and (ListControl.Items[i].State = new) then
        width := 0
      else if ListControl.Items[i].State = addAfter then
        width := width + ListControl.Items[i].width -
          (ListControl.Items[i].ItemWidth + ListControl.Items[i].ArrowWidth)
      else
        width := width + ListControl.Items[i].width;

    end;

  end;

begin
  ListControl.Clear;
  case List.State of
    lsNormal:
      begin
        temp := List.GetFirst;
        while temp <> nil do
        begin
          ListControlItem := TListControl.Create(FlowPanel1);
          ListControlItem.ItemMain.TitleMain := temp.GetInfo;
          ListControlItem.ItemMain.TitleNext := temp.GetNextInfo;
          ListControlItem.ItemMain.TitlePrev := temp.GetPrevInfo;
          ListControlItem.IsLast := temp.IsLast;
          ListControlItem.IsFirst := temp.IsFirst;

          ListControl.Add(ListControlItem);
          temp := temp.GetNext;
        end;
      end;
    lsAddbefore:
      begin

      end;
    lsAddafter:
      begin

      end;
    lsDelete:
      begin

      end;

  end;
  PlaceControlItems;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  // ListControl.Items[1].ItemMain.color := clLime;
  RedrawPanel();
  // ListControl.Items[1-1].Refresh;

end;

procedure TForm1.ButtonCreateClick(Sender: TObject);
var
  ListItem: TListControl;
  i, j, k: integer;
  s1, s2: string;

begin
  j := StrToInt(Edit1.Text);
  if j > 6 then
  begin
    ShowMessage('������� ����� �� 1 �� 7');
    exit;
  end;
  if RadioButton1.Checked = True then

    for i := 1 to j do
    begin
      k := StrToInt(InputBox('����� �������',
        '������� ����� ��������,����� �������� ������ �������� ����� �������:',
        '1'));
      Unit2.Form2.Edit2.Text := IntToStr(k);

      s2 := Form2.Edit2.Text;
      Form2.ShowModal;
      s1 := Form2.Edit1.Text;
      ListItem := TListControl.Create(FlowPanel1);
      if i = 1 then
      begin

        ListItem.Top := 0;
        ListItem.Left := 0;
      end;

      ListItem.ItemMain.TitleMain := s1;
      ListItem.ItemMain.TitleNext := s2;
      if i = 1 then
      begin
        ListItem.IsFirst := True;
      end;
      ListItem.IsLast := false;
      ListControl.Add(ListItem);
      RedrawPanel();
    end;
  if RadioButton2.Checked = True then
  begin
    ListItem := TListControl.Create(FlowPanel1);
    ListItem.IsLast := false;
    ListControl.Add(ListItem);
  end;
  ListItem.IsLast := True;
  ButtonAddAfter.Enabled := True;
  ButtonAddBefore.Enabled := True;
  ButtonClear.Enabled := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  temp: TListItem;
begin
  if List.Getcount = 0 then
  begin
    temp := TListItem.Create('item' + IntToStr(List.Getcount));
    List.Add('', temp);
  end
  else
  begin
    temp := TListItem.Create('item' + IntToStr(List.Getcount));
    List.Add('item' + IntToStr(List.Getcount - 1), temp);
  end;
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
  ListItem: TListItem;
  i, k: integer;
  info: string;
begin
  Form2.ShowModal;
  info := Form2.Edit1.Text;
  ListItem := TListItem.Create(info);
  List.Add('', ListItem);

  ButtonAddAfter.Enabled := True;
  ButtonAddBefore.Enabled := True;

  RedrawPanel;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  List.NextStep;
  RedrawPanel;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  RedrawPanel;
end;

procedure TForm1.ButtonAddAfterClick(Sender: TObject);
var
  ListItem: TListControl;
  i, k: integer;
  s1, s2: string;
begin
  k := StrToInt(InputBox('����� �������',
    '������� ����� ��������,����� �������� ������ �������� ����� �������:',
    '1')) - 1;

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
    ListControl[k].State := addAfter;
  end;

  ListControl.Insert(k + 1, ListItem);

  RedrawPanel();
end;

procedure TForm1.ButtonAddBeforeClick(Sender: TObject);
var
  ListItem: TListControl;
  i, k: integer;
  s1, s2: string;
begin
  k := StrToInt(InputBox('����� �������',
    '������� ����� ��������,����� �������� ������ �������� ����� �������:',
    '1')) - 1;

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
    ListControl[k].State := addBefore;
  end;

  if k > 0 then
  begin
    ListControl[k - 1].State := addAfter;
  end
  else
  begin
    ListControl.Items[k].PaddingLeft := ListControl.Items[k].PaddingLeft +
      ListControl.Items[k].ArrowWidth;
  end;

  ListControl.Insert(k, ListItem);
  RedrawPanel();
end;

procedure TForm1.ButtonClearClick(Sender: TObject);
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
    ListControl.Delete(0);
  end;

end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  ListControl.Last.ItemMain.color := clRed;

  ListControl.Items[0].ItemMain.ArrowRight.cross.visible := True;
  RedrawPanel();
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
    ButtonCreate.Enabled := True;
  end;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  if RadioButton2.Checked = True then

  begin
    Button3.Enabled := True;
    Edit1.ReadOnly := false;
  end
end;

end.
