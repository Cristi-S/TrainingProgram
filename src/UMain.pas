unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Control1, Vcl.ExtCtrls,
  UList, UListItem, UnitNewItem, Math;

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
    ButtonCreate: TButton;
    ButtonNext: TButton;
    Label1: TLabel;
    ButtonAdd: TButton;
    ScrollBox1: TScrollBox;
    FlowPanel1: TPanel;
    Memo1: TMemo;
    procedure ButtonCreateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ButtonAddAfterClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure RedrawPanel();
    procedure ButtonAddBeforeClick(Sender: TObject);
    procedure ButtonAppendClick(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    // Обработчик события MyEvent для объектов, принадлежащих типу TMyClass.
    procedure OnThreadSyspended(Sender: TObject);
    procedure ButtonInsertClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
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

uses Logger;

// обновляем состояние кнопок
procedure UpdateButtonState;
begin
  with Form1 do
  begin
    case List.State of
      lsNormal:
        begin
          if List.Getcount > 0 then
          begin
            ButtonAdd.Enabled := false;
            ButtonAddAfter.Enabled := true;
            ButtonAddBefore.Enabled := true;
            RadioButton1.Enabled := false;
            ButtonCreate.Enabled := false;
            RadioButton2.Enabled := false;
            Edit1.Enabled := false;
            // удалять первый элемент пока нельзя
            if List.Getcount > 1 then
              ButtonDelete.Enabled := true
            else
              ButtonDelete.Enabled := false;
          end
          else
          begin
            ButtonAdd.Enabled := RadioButton2.Checked;
            ButtonAddAfter.Enabled := false;
            ButtonAddBefore.Enabled := false;
            ButtonDelete.Enabled := false;
            RadioButton1.Enabled := true;
            RadioButton2.Enabled := true;

            if RadioButton1.Checked then
            begin
              ButtonCreate.Enabled := true;
              Edit1.Enabled := true;
            end
            else
            begin
              ButtonCreate.Enabled := false;
              Edit1.Enabled := false;
            end;
          end;
          ButtonNext.Enabled := false;
        end;
      lsAddbefore, lsAddAfter, lsDelete:
        begin
          ButtonAdd.Enabled := false;
          ButtonAddAfter.Enabled := false;
          ButtonAddBefore.Enabled := false;
          ButtonDelete.Enabled := false;
          ButtonNext.Enabled := true;
        end;
    end;
  end;
end;

// перемещает все контролы в ряд по порядку
procedure ReplaceControlItems();
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
    else
      case ListControl.Items[i].State of
        addAfter:
          width := width + ListControl.Items[i].width -
            (ListControl.Items[i].ItemWidth + ListControl.Items[i].ArrowWidth);
        normal:
          width := width + ListControl.Items[i].width -
            (ListControl.Items[i].ItemWidth + ListControl.Items[i].ArrowWidth +
            Round(1 / 5 * ListControl.Items[i].ItemWidth) +
            Round(ListControl.Items[i].ArrowHeadWidth / 2));
        new:
          width := width + ListControl.Items[i].width;
      end;
  end;
end;

// перерисовывает панель с компонентами  взависимсти от состояния элементов, предварительно ее очищая
procedure TForm1.RedrawPanel();
var
  temp, next: TListItem;
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
          ListControlItem.ItemMain.ArrowHeader.visible := temp.IsFirst;

          ListControl.Add(ListControlItem);
          temp := temp.GetNext;
        end;
      end;
    lsAddbefore:
      begin
        // если добавление перед первым
        if List.SearchItem = List.GetFirst then
        begin
          NewListControlItem := TListControl.Create(FlowPanel1);
          NewListControlItem.ItemMain.TitleMain := List.NewItem.GetInfo;
          NewListControlItem.ItemMain.TitleNext := List.NewItem.GetNextInfo;
          NewListControlItem.ItemMain.TitlePrev := List.NewItem.GetPrevInfo;
          NewListControlItem.State := new;
          NewListControlItem.ItemMain.color := clGreen;

          NewListControlItem.ItemMain.ArrowUpRight.visible :=
            List.NewItem.GetNext <> nil;
          NewListControlItem.ItemMain.ArrowDownRight.visible :=
            List.SearchItem.GetPrev = List.NewItem;

          ListControl.Add(NewListControlItem);
        end;

        temp := List.GetFirst;
        while temp <> nil do
        begin
          ListControlItem := TListControl.Create(FlowPanel1);
          ListControlItem.ItemMain.TitleMain := temp.GetInfo;
          ListControlItem.ItemMain.TitleNext := temp.GetNextInfo;
          ListControlItem.ItemMain.TitlePrev := temp.GetPrevInfo;
          ListControlItem.ItemMain.ArrowHeader.visible := temp.IsFirst;

          ListControlItem.IsLast := temp.IsLast;
          ListControlItem.IsFirst := temp.IsFirst;
          ListControlItem.IsAddBefore := temp.IsAddBefore;
          ListControl.Add(ListControlItem);

          // елси добавление перд первым, то первый элемент нужне немного подвинуть
          if (List.SearchItem = List.GetFirst) and (temp = List.GetFirst) then
            ListControlItem.PaddingLeft := ListControlItem.PaddingLeft +
              +ListControlItem.ArrowWidth;

          // добавление в середину перед заданным
          next := temp.GetNext;
          if Assigned(next) then
            if temp.GetNext.IsAddBefore then
            begin
              NewListControlItem := TListControl.Create(FlowPanel1);
              NewListControlItem.ItemMain.TitleMain := List.NewItem.GetInfo;
              NewListControlItem.ItemMain.TitleNext := List.NewItem.GetNextInfo;
              NewListControlItem.ItemMain.TitlePrev := List.NewItem.GetPrevInfo;
              NewListControlItem.State := new;
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

              NewListControlItem.State := new;
              ListControlItem.State := addAfter;
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
    lsAddAfter:
      begin
        temp := List.GetFirst;
        while temp <> nil do
        begin
          ListControlItem := TListControl.Create(FlowPanel1);
          ListControlItem.ItemMain.TitleMain := temp.GetInfo;
          ListControlItem.ItemMain.TitleNext := temp.GetNextInfo;
          ListControlItem.ItemMain.TitlePrev := temp.GetPrevInfo;
          ListControlItem.ItemMain.ArrowHeader.visible := temp.IsFirst;

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
              ListControlItem.IsLast := false;
              NewListControlItem.State := normal;
              ListControlItem.ItemMain.ArrowRight.visible :=
                (temp.GetNext <> nil);

              ListControlItem.ItemMain.ArrowLeft.visible :=
                (List.NewItem.GetPrev <> nil);
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
        temp := List.GetFirst;
        while temp <> nil do
        begin
          ListControlItem := TListControl.Create(FlowPanel1);
          ListControlItem.ItemMain.TitleMain := temp.GetInfo;
          ListControlItem.ItemMain.TitleNext := temp.GetNextInfo;
          ListControlItem.ItemMain.TitlePrev := temp.GetPrevInfo;
          ListControlItem.ItemMain.ArrowHeader.visible := temp.IsFirst;
          ListControlItem.IsLast := temp.IsLast;
          ListControlItem.IsFirst := temp.IsFirst;

          ListControl.Add(ListControlItem);

          // закрашивание удяляемого
          if temp.IsDelete then
          begin
            ListControlItem.ItemMain.color := clRed;
          end;
          // закрашивание temp
          if temp = List.TempItem then
          begin
            ListControlItem.ItemMain.color := clBlue;
          end;

          // непосредственно визуализация удаления элемента
          if Assigned(List.DeleteItem) then
          begin
            // если удаляем с начала списка (первый элемент)
            if List.DeleteItem = List.GetFirst then
            begin
              if temp = List.DeleteItem then
                if temp.GetNext.GetPrev <> temp then
                  ListControlItem.ItemMain.ArrowLeft.cross.visible := true;
            end;
            // если удаляем с конца (последний элеменет)
            if List.DeleteItem.GetNext = nil then
            begin
              // крестик вправо
              if (List.DeleteItem.GetPrev = temp) and
                (temp.GetNext <> List.DeleteItem) then
              begin
                ListControlItem.ItemMain.ArrowRight.cross.visible := true;
              end;
            end
            else
            // удаление из середины
            begin
              // длинная стрелочка вперед + крестик
              if (List.DeleteItem.GetPrev = temp) and
                (temp.GetNext <> List.DeleteItem) then
              begin
                ListControlItem.ItemMain.ArrowRightPolygon.visible := true;
                ListControlItem.ItemMain.ArrowRight.cross.visible := true;
              end;
              // длинная стрелочка назад
              if (List.DeleteItem.GetNext = temp.GetNext) and
                (temp.GetNext <> List.DeleteItem) and (temp <> List.DeleteItem)
                and (temp.GetNext.GetPrev = temp) then
              begin
                ListControlItem.ItemMain.ArrowLeftPolygon.visible := true;
              end;
              // крестик
              if (temp = List.DeleteItem) and
                (List.DeleteItem.GetNext.GetPrev = List.DeleteItem.GetPrev) then
              begin
                ListControlItem.ItemMain.ArrowLeft.cross.visible := true;
              end;
            end;
          end;

          // обработка прохода по списку с учетом удаляемного элемента
          if Assigned(List.DeleteItem) then
          begin
            if List.DeleteItem.GetPrev = temp then
              temp := List.DeleteItem
            else
              temp := temp.GetNext;
          end
          else
            temp := temp.GetNext;
        end;
      end;
  end;
  ReplaceControlItems;
  UpdateButtonState;
end;

// Обработчик события ThreadSyspended для объектов, принадлежащих типу TList.
procedure TForm1.OnThreadSyspended(Sender: TObject);
begin
  if not(Sender is TList) then
    Exit;
  RedrawPanel;
end;

procedure TForm1.ButtonCreateClick(Sender: TObject);
var
  ListItem: TListItem;
  i, Count: integer;
  new, last: integer;
begin
  // переводим режим программы в обычный - без управления потоком
  List.Mode := lmNormal;
  // выключаем логгирование
  Logger.Enabled := false;

  Randomize;

  Count := Min(3, StrToInt(Edit1.Text) - 1);

  if RadioButton1.Checked = true then
    for i := 0 to Count do
    begin
      if i = 0 then
      begin
        new:= Random(80)+20;
        ListItem := TListItem.Create(new.ToString);
        List.addAfter('item', ListItem);
        last:= new;
        WaitForSingleObject(List.ThreadId, INFINITE);
      end
      else
      begin
        new:= Random(80)+20;
        ListItem := TListItem.Create(new.ToString);
        List.addAfter(last.ToString, ListItem);
        last:= new;
        WaitForSingleObject(List.ThreadId, INFINITE);
      end;
    end;
  // перерисовываем панель
  RedrawPanel();
  // возвращаем программу в режим управления
  Logger.Enabled := true;
  List.Mode := lmControl;
end;

// удаление
procedure TForm1.ButtonDeleteClick(Sender: TObject);
var
  SearchItem: string;
begin
  SearchItem := InputBox('Удаление',
    'Введите элемент, который нужно удалить :', 'item1');
  List.Delete(SearchItem);
end;

procedure TForm1.ButtonAppendClick(Sender: TObject);
var
  temp: TListItem;
begin
  if List.Getcount = 0 then
  begin
    temp := TListItem.Create('item' + IntToStr(List.Getcount));
    List.addAfter('', temp);
  end
  else
  begin
    temp := TListItem.Create('item' + IntToStr(List.Getcount));
    List.addAfter('item' + IntToStr(List.Getcount - 1), temp);
  end;
end;

// добавление первого элемента в список
procedure TForm1.ButtonAddClick(Sender: TObject);
var
  ListItem: TListItem;
  info: string;
begin
  Form2.ShowModal;
  info := Form2.Edit1.Text;
  ListItem := TListItem.Create(info);
  List.addAfter('', ListItem);
end;

// возобновление работы
procedure TForm1.ButtonNextClick(Sender: TObject);
begin
  List.NextStep;
end;

procedure TForm1.ButtonRefreshClick(Sender: TObject);
begin
  ButtonClearClick(Sender);
  // FlowPanel1.Components.DestroyComponents;
  { TODO пересмоттреть очистку списка, т.к. панель не очищается }
  ReplaceControlItems();
end;

procedure TForm1.ButtonInsertClick(Sender: TObject);
var
  temp: TListItem;
  SearchItem: string;
begin
  if List.Getcount = 0 then
  begin
    temp := TListItem.Create('item' + IntToStr(List.Getcount));
    List.addAfter('', temp);
  end
  else
  begin
    SearchItem := InputBox('Новый элемент',
      'Введите элемент, после которого добавить новый :', 'item1');
    temp := TListItem.Create('itemNew');
    List.addAfter(SearchItem, temp);
  end;
end;

// добавление после
procedure TForm1.ButtonAddAfterClick(Sender: TObject);
var
  ListItem: TListItem;
  SearchItem: string;
  info: string;
begin
  if List.Getcount <> 0 then
    Form2.ShowModal;
  info := Form2.Edit1.Text;
  ListItem := TListItem.Create(info);
  SearchItem := InputBox('Добавление после заданного',
    'Введите элемент, после которого добавить новый :', 'item1');
  List.addAfter(SearchItem, ListItem);
end;

// добавление перед
procedure TForm1.ButtonAddBeforeClick(Sender: TObject);
var
  ListItem: TListItem;
  SearchItem: string;
  info: string;
begin
  if List.Getcount <> 0 then
    Form2.ShowModal;
  info := Form2.Edit1.Text;
  ListItem := TListItem.Create(info);
  SearchItem := InputBox('Добавление перед заданным',
    'Введите элемент, перед которым добавить новый :', 'item1');
  List.AddBefore(SearchItem, ListItem);
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

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  If not CharInSet(Key, ['0' .. '9', #8]) then
    Key := #0;
end;

// обработчик создания формы
procedure TForm1.FormCreate(Sender: TObject);
begin
  List := TList.Create;
  // Для OnThreadSyspended назначаем обработчики события ThreadSyspended.
  List.OnThreadSyspended := OnThreadSyspended;
  ListControl := TList<TListControl>.Create;
  UpdateButtonState;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  UpdateButtonState;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  UpdateButtonState;
end;

end.
