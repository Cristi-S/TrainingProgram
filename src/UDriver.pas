unit UDriver;
// модуль связующий логическую структуру с отображаемыми данными

interface

uses UMain, UEnum, ListItemControl, UListItem, Graphics, UAnwer, SysUtils;

procedure UpdateButtonState(Sender: TObject = nil);
procedure RedrawPanel();
procedure ClearPanel(Sender: TObject = nil);

implementation

// обновляем состояние кнопок

procedure UpdateButtonState(Sender: TObject = nil);
begin
  with FormMain do
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

    // statusbar
    StatusBar1.Visible := (List.Mode = omControl);
    StatusBar1.Panels[2].Text := QuestionsCount.ToString;
    StatusBar1.Panels[4].Text := CorrectQuestionsCount.ToString;

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

// процедура для поддержки RedrawPanel()
procedure TemplateControlCreate(var item: TListControl; temp: TMyListItem;
  State: TItemState = normal; iColor: integer = clBlack);
begin
  with FormMain do
  begin
    item := TListControl.Create(FlowPanel1);
    item.ItemMain.TitleMain := temp.GetInfo;
    item.ItemMain.TitleNext := temp.GetNextInfo;
    item.ItemMain.TitlePrev := temp.GetPrevInfo;
    item.IsLast := temp.IsLast;
    item.IsFirst := temp.IsFirst;
    item.IsAddBefore := temp.IsAddBefore;
    item.IsAddAfter := temp.IsAddAfter;
    item.ItemMain.ArrowHeader.Visible := temp.IsFirst;
    item.State := State;
    item.ItemMain.color := iColor;
  end;
end;

// перерисовывает панель с компонентами  взависимсти от состояния элементов, предварительно ее очищая
procedure RedrawPanel();
var
  temp, NextItem: TMyListItem;
  ListControlItem, NewListControlItem: TListControl;
begin
  with FormMain do
  begin
    ClearPanel();
    case List.State of
      lsNormal:
        begin
          temp := List.GetFirst;
          while temp <> nil do
          begin
            TemplateControlCreate(ListControlItem, temp);
            ListControl.Add(ListControlItem);
            temp := temp.GetNext;
          end;
        end;
      lsAddbefore:
        begin
          // если добавление перед первым
          if List.SearchItem = List.GetFirst then
          begin
            TemplateControlCreate(NewListControlItem, List.NewItem,
              TItemState.new, clGreen);

            NewListControlItem.ItemMain.ArrowUpRight.Visible :=
              List.NewItem.GetNext <> nil;
            NewListControlItem.ItemMain.ArrowDownRight.Visible :=
              List.SearchItem.GetPrev = List.NewItem;

            ListControl.Add(NewListControlItem);
          end;

          temp := List.GetFirst;
          while temp <> nil do
          begin
            TemplateControlCreate(ListControlItem, temp);
            ListControl.Add(ListControlItem);

            // елси добавление перд первым, то первый элемент нужне немного подвинуть
            if (List.SearchItem = List.GetFirst) and (temp = List.GetFirst) then
              ListControlItem.PaddingLeft := ListControlItem.PaddingLeft +
                +ListControlItem.ArrowWidth;

            // добавление в середину перед заданным
            NextItem := temp.GetNext;
            if Assigned(NextItem) then
              if temp.GetNext.IsAddBefore then
              begin
                TemplateControlCreate(NewListControlItem, List.NewItem,
                  TItemState.new, clGreen);

                // стрелочки
                ListControlItem.ItemMain.ArrowRight.Visible :=
                  (temp.GetNext = List.NewItem) and (temp.IsLast);

                // стрелочки при добавлении в середину для нового элемента
                if temp.GetNext <> nil then
                begin
                  NewListControlItem.ItemMain.ArrowUpRight.Visible :=
                    (temp.GetNext = List.NewItem.GetNext);
                  NewListControlItem.ItemMain.ArrowDownRight.Visible :=
                    (List.NewItem = temp.GetNext.GetPrev);

                  ListControlItem.ItemMain.ArrowDownLeft.Visible :=
                    (temp.GetNext = List.NewItem);
                  ListControlItem.ItemMain.ArrowUpLeft.Visible :=
                    (temp = List.NewItem.GetPrev);

                  // длинные
                  ListControlItem.ItemMain.ArrowLongLeft.Visible :=
                    (temp.GetNext <> List.NewItem) and
                    (temp.GetNext.GetPrev = temp);
                  ListControlItem.ItemMain.ArrowLongRight.Visible :=
                    (temp.GetNext <> List.NewItem) and (temp.GetNext <> nil);
                end;

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
            TemplateControlCreate(ListControlItem, temp);
            ListControl.Add(ListControlItem);
            if temp.IsAddAfter then
            begin
              TemplateControlCreate(NewListControlItem, List.NewItem,
                TItemState.new, clGreen);

              // стрелочки
              ListControlItem.ItemMain.ArrowRight.Visible :=
                (temp.GetNext = List.NewItem) and (temp.IsLast);

              // стрелочки при добавлении в середину для нового элемента
              if temp.GetNext <> nil then
              begin
                NewListControlItem.ItemMain.ArrowUpRight.Visible :=
                  (temp.GetNext = List.NewItem.GetNext);
                NewListControlItem.ItemMain.ArrowDownRight.Visible :=
                  (List.NewItem = temp.GetNext.GetPrev);

                ListControlItem.ItemMain.ArrowDownLeft.Visible :=
                  (temp.GetNext = List.NewItem);
                ListControlItem.ItemMain.ArrowUpLeft.Visible :=
                  (temp = List.NewItem.GetPrev);

                // длинные
                ListControlItem.ItemMain.ArrowLongLeft.Visible :=
                  (temp.GetNext <> List.NewItem) and
                  (temp.GetNext.GetPrev = temp);
                ListControlItem.ItemMain.ArrowLongRight.Visible :=
                  (temp.GetNext <> List.NewItem) and (temp.GetNext <> nil);
              end;

              if temp.IsLast then
              begin
                ListControlItem.IsLast := false;
                NewListControlItem.State := normal;
                ListControlItem.ItemMain.ArrowRight.Visible :=
                  (temp.GetNext <> nil);

                ListControlItem.ItemMain.ArrowLeft.Visible :=
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
            TemplateControlCreate(ListControlItem, temp);
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
                    ListControlItem.ItemMain.ArrowLeft.cross.Visible := true;
              end;
              // если удаляем с конца (последний элеменет)
              if List.DeleteItem.GetNext = nil then
              begin
                // крестик вправо
                if (List.DeleteItem.GetPrev = temp) and
                  (temp.GetNext <> List.DeleteItem) then
                begin
                  ListControlItem.ItemMain.ArrowRight.cross.Visible := true;
                end;
              end
              else
              // удаление из середины
              begin
                // длинная стрелочка вперед + крестик
                if (List.DeleteItem.GetPrev = temp) and
                  (temp.GetNext <> List.DeleteItem) then
                begin
                  ListControlItem.ItemMain.ArrowRightPolygon.Visible := true;
                  ListControlItem.ItemMain.ArrowRight.cross.Visible := true;
                end;
                // длинная стрелочка назад
                if (List.DeleteItem.GetNext = temp.GetNext) and
                  (temp.GetNext <> List.DeleteItem) and
                  (temp <> List.DeleteItem) and (temp.GetNext.GetPrev = temp)
                then
                begin
                  ListControlItem.ItemMain.ArrowLeftPolygon.Visible := true;
                end;
                // крестик
                if (temp = List.DeleteItem) and
                  (List.DeleteItem.GetNext.GetPrev = List.DeleteItem.GetPrev)
                then
                begin
                  ListControlItem.ItemMain.ArrowLeft.cross.Visible := true;
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
end;

// удаляет все компоненты в Panel
procedure ClearPanel(Sender: TObject = nil);
var
  i: integer;
begin
  with FormMain do
  begin
    for i := 1 to FlowPanel1.ComponentCount do
      FlowPanel1.Controls[0].DisposeOf;

    for i := 1 to ListControl.Count do
    begin
      ListControl.Delete(0);
    end;

  end;
end;

end.
