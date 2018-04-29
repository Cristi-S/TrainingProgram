unit URedrawing;

interface

uses UMain, UEnum, Control1, UListItem, Vcl.Graphics;

procedure UpdateButtonState(Sender: TObject = nil);
procedure RedrawPanel();
procedure ClearPanel(Sender: TObject = nil);

implementation

{$REGION '���������'}
// uses UMain;

// ��������� ��������� ������
procedure UpdateButtonState(Sender: TObject = nil);
begin
  with Form1 do
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
            // ������� ������ ������� ���� ������
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

// ���������� ��� �������� � ��� �� �������
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

// �������������� ������ � ������������  ����������� �� ��������� ���������, �������������� �� ������
procedure RedrawPanel();
var
  temp, NextItem: TListItem;
  ListControlItem, NewListControlItem: TListControl;
begin
  with Form1 do
  begin
    ClearPanel();
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
          // ���� ���������� ����� ������
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

            // ���� ���������� ���� ������, �� ������ ������� ����� ������� ���������
            if (List.SearchItem = List.GetFirst) and (temp = List.GetFirst) then
              ListControlItem.PaddingLeft := ListControlItem.PaddingLeft +
                +ListControlItem.ArrowWidth;

            // ���������� � �������� ����� ��������
            NextItem := temp.GetNext;
            if Assigned(NextItem) then
              if temp.GetNext.IsAddBefore then
              begin
                NewListControlItem := TListControl.Create(FlowPanel1);
                NewListControlItem.ItemMain.TitleMain := List.NewItem.GetInfo;
                NewListControlItem.ItemMain.TitleNext :=
                  List.NewItem.GetNextInfo;
                NewListControlItem.ItemMain.TitlePrev :=
                  List.NewItem.GetPrevInfo;
                NewListControlItem.State := new;
                NewListControlItem.ItemMain.color := clGreen;

                // ���������
                ListControlItem.ItemMain.ArrowRight.visible :=
                  (temp.GetNext = List.NewItem) and (temp.IsLast);

                // ��������� ��� ���������� � �������� ��� ������ ��������
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

                  // �������
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

            // ������������ temp
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

              // ���������
              ListControlItem.ItemMain.ArrowRight.visible :=
                (temp.GetNext = List.NewItem) and (temp.IsLast);

              // ��������� ��� ���������� � �������� ��� ������ ��������
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

                // �������
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

            // ������������ temp
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

            // ������������ ����������
            if temp.IsDelete then
            begin
              ListControlItem.ItemMain.color := clRed;
            end;
            // ������������ temp
            if temp = List.TempItem then
            begin
              ListControlItem.ItemMain.color := clBlue;
            end;

            // ��������������� ������������ �������� ��������
            if Assigned(List.DeleteItem) then
            begin
              // ���� ������� � ������ ������ (������ �������)
              if List.DeleteItem = List.GetFirst then
              begin
                if temp = List.DeleteItem then
                  if temp.GetNext.GetPrev <> temp then
                    ListControlItem.ItemMain.ArrowLeft.cross.visible := true;
              end;
              // ���� ������� � ����� (��������� ��������)
              if List.DeleteItem.GetNext = nil then
              begin
                // ������� ������
                if (List.DeleteItem.GetPrev = temp) and
                  (temp.GetNext <> List.DeleteItem) then
                begin
                  ListControlItem.ItemMain.ArrowRight.cross.visible := true;
                end;
              end
              else
              // �������� �� ��������
              begin
                // ������� ��������� ������ + �������
                if (List.DeleteItem.GetPrev = temp) and
                  (temp.GetNext <> List.DeleteItem) then
                begin
                  ListControlItem.ItemMain.ArrowRightPolygon.visible := true;
                  ListControlItem.ItemMain.ArrowRight.cross.visible := true;
                end;
                // ������� ��������� �����
                if (List.DeleteItem.GetNext = temp.GetNext) and
                  (temp.GetNext <> List.DeleteItem) and
                  (temp <> List.DeleteItem) and (temp.GetNext.GetPrev = temp)
                then
                begin
                  ListControlItem.ItemMain.ArrowLeftPolygon.visible := true;
                end;
                // �������
                if (temp = List.DeleteItem) and
                  (List.DeleteItem.GetNext.GetPrev = List.DeleteItem.GetPrev)
                then
                begin
                  ListControlItem.ItemMain.ArrowLeft.cross.visible := true;
                end;
              end;
            end;

            // ��������� ������� �� ������ � ������ ����������� ��������
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

// ������� ��� ���������� � Panel
procedure ClearPanel(Sender: TObject = nil);
var
  i: integer;
begin
  with Form1 do
  begin
    for i := 1 to FlowPanel1.ComponentCount do
      FlowPanel1.Controls[0].DisposeOf;

    for i := 1 to ListControl.Count do
    begin
      ListControl.Delete(0);
    end;

  end;
end;
{$ENDREGION}

end.