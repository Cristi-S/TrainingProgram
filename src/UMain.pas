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
    ButtonAppend: TButton;
    ButtonNext: TButton;
    ButtonRefresh: TButton;
    ButtonInsert: TButton;
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
    procedure ButtonAppendClick(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    // Обработчик события MyEvent для объектов, принадлежащих типу TMyClass.
    procedure OnThreadSyspended(Sender: TObject);
    procedure ButtonInsertClick(Sender: TObject);
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

procedure PlaceControlItems();
var
  i: integer;
  width: integer;
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

procedure TForm1.RedrawPanel();
var
  temp: TListItem;
  ListControlItem, NewListControlItem: TListControl;

begin
  ButtonClearClick(Self);
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
    lsAddAfter:
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
          ListControlItem.IsAddAfter := temp.IsAddAfter;
          ListControl.Add(ListControlItem);
          if temp.IsAddAfter then
          begin
            NewListControlItem := TListControl.Create(FlowPanel1);
            NewListControlItem.ItemMain.TitleMain := List.NewItem.GetInfo;
            NewListControlItem.ItemMain.TitleNext := List.NewItem.GetNextInfo;
            NewListControlItem.ItemMain.TitlePrev := List.NewItem.GetPrevInfo;
            NewListControlItem.State := new;
            NewListControlItem.IsLast := List.NewItem.IsLast;
            NewListControlItem.IsFirst := List.NewItem.IsFirst;
            NewListControlItem.ItemMain.color := clGreen;

            // стрелочки
            ListControlItem.ItemMain.ArrowRight.visible :=
              (temp.GetNext = List.NewItem) and (temp.IsLast);

            // стрелочки при добавлении в середину для нового элемента
            if temp.GetNext <> nil then
            begin
              NewListControlItem.ItemMain.ArrowUpRight.visible :=
                (temp.GetNext = List.NewItem.GetNext);
              NewListControlItem.ItemMain.ArrowDownRight.visible :=
                (List.NewItem = temp.GetNext.GetPrev);

              ListControlItem.ItemMain.ArrowDownLeft.visible :=
                (temp.GetNext = List.NewItem);
              ListControlItem.ItemMain.ArrowUpLeft.visible :=
                (temp = List.NewItem.GetPrev);

              // длинные
              ListControlItem.ItemMain.ArrowLongLeft.visible :=
                (temp.GetNext <> List.NewItem) and
                (temp.GetNext.GetPrev = temp);
              ListControlItem.ItemMain.ArrowLongRight.visible :=
                (temp.GetNext <> List.NewItem) and (temp.GetNext <> nil);

            end;

            if temp.IsLast then
            begin
              NewListControlItem.State := normal;
              NewListControlItem.IsLast := true;
            end
            else
            begin
              NewListControlItem.State := new;
              ListControlItem.State := addAfter;
            end;

            ListControl.Add(NewListControlItem);
          end;

          // закрашивание temp
          if temp = List.TempItem then
          begin
            ListControlItem.ItemMain.color := clBlue;
          end;

          temp := temp.GetNext;
        end;
      end;
    lsDelete:
      begin

      end;

  end;
  PlaceControlItems;
end;

// Обработчик события ThreadSyspended для объектов, принадлежащих типу TList.
procedure TForm1.OnThreadSyspended(Sender: TObject);
begin
  if not(Sender is TList) then
    Exit;
  RedrawPanel;
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
    ShowMessage('Введите число от 1 до 7');
    Exit;
  end;
  if RadioButton1.Checked = true then

    for i := 1 to j do
    begin
      k := StrToInt(InputBox('Новый элемент',
        'Введите номер элемента,ПОСЛЕ которого хотите добавить новый элемент:',
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
        ListItem.IsFirst := true;
      end;
      ListItem.IsLast := false;
      ListControl.Add(ListItem);
      RedrawPanel();
    end;
  if RadioButton2.Checked = true then
  begin
    ListItem := TListControl.Create(FlowPanel1);
    ListItem.IsLast := false;
    ListControl.Add(ListItem);
  end;
  ListItem.IsLast := true;
  ButtonAddAfter.Enabled := true;
  ButtonAddBefore.Enabled := true;
  ButtonClear.Enabled := true;
end;

procedure TForm1.ButtonAppendClick(Sender: TObject);
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

  ButtonAddAfter.Enabled := true;
  ButtonAddBefore.Enabled := true;

  RedrawPanel;
end;

procedure TForm1.ButtonNextClick(Sender: TObject);
begin
  List.NextStep;
end;

procedure TForm1.ButtonRefreshClick(Sender: TObject);
begin
  ButtonClearClick(Sender);
  // FlowPanel1.Components.DestroyComponents;
  { TODO пересмоттреть очистку списка, т.к. панель не очищается }
  PlaceControlItems();
end;

procedure TForm1.ButtonInsertClick(Sender: TObject);
var
  temp: TListItem;
  searchItem: string;
begin
  if List.Getcount = 0 then
  begin
    temp := TListItem.Create('item' + IntToStr(List.Getcount));
    List.Add('', temp);
  end
  else
  begin
    searchItem := InputBox('Новый элемент',
      'Введите элемент, после которого добавить новый :', 'item1');
    temp := TListItem.Create('itemNew');
    List.Add(searchItem, temp);
  end;
end;

procedure TForm1.ButtonAddAfterClick(Sender: TObject);
var
  ListItem: TListControl;
  i, k: integer;
  s1, s2: string;
begin
  k := StrToInt(InputBox('Новый элемент',
    'Введите номер элемента,ПОСЛЕ которого хотите добавить новый элемент:',
    '1')) - 1;

  ListItem := TListControl.Create(FlowPanel1);
  ListItem.ItemMain.TitleMain := 'new';
  ListItem.ItemMain.TitleNext := 'nul';
  ListItem.ItemMain.TitlePrev := 'nul';

  if ListControl[k].IsLast then
  begin
    ListItem.State := normal;
    ListItem.IsLast := true;
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
  k := StrToInt(InputBox('Новый элемент',
    'Введите номер элемента,ПОСЛЕ которого хотите добавить новый элемент:',
    '1')) - 1;

  ListItem := TListControl.Create(FlowPanel1);
  ListItem.ItemMain.TitleMain := 'new';
  ListItem.ItemMain.TitleNext := 'nul';
  ListItem.ItemMain.TitlePrev := 'nul';

  if ListControl[k].IsLast then
  begin
    ListItem.State := normal;
    ListItem.IsLast := true;
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
  for i := 1 to FlowPanel1.ComponentCount do
    FlowPanel1.Controls[0].DisposeOf;

  for i := 1 to ListControl.Count do
  begin
    ListControl.Delete(0);
  end;

end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  ListControl.Last.ItemMain.color := clRed;

  ListControl.Items[0].ItemMain.ArrowRight.cross.visible := true;
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
  // Для MyObj1 и MyObj2 назначаем обработчики события MyEvent.
  List.OnThreadSyspended := OnThreadSyspended;
  ListControl := TList<TListControl>.Create;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  if RadioButton1.Checked = true then
  begin
    Edit1.ReadOnly := false;
    ButtonCreate.Enabled := true;
  end;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  if RadioButton2.Checked = true then

  begin
    Button3.Enabled := true;
    Edit1.ReadOnly := false;
  end
end;

end.
