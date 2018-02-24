unit UList;

interface

Uses
  UListItem;

Type
  TList = class
  Private
    Count: Integer;
    First: TListItem;
    IsContinue: boolean;
  Public
    Constructor Create;
    Function Getcount: Integer;
    Function GetFirst: TListItem;
    Function Add(SearchItem: string; NewItem: TListItem): boolean;
    Function Delete(SearchItem: string): boolean;
    Function Search(SearchItem: string): TListItem;
    procedure NextStep();
  End;

implementation

Constructor TList.Create;
begin
  Count := 0;
  First := nil;
end;

Function TList.Getcount: Integer;
begin
  result := Count;
end;

Function TList.GetFirst: TListItem;
begin
  result := First;
end;

function TList.Add(SearchItem: string; NewItem: TListItem): boolean;
var
  Temp: TListItem;
Begin
  while true do
  if IsContinue then
  begin
    result := false;
    IsContinue:=false;
    break;
  end;

  If First = nil then
  begin
    First := NewItem;
    Count := Count + 1;
    result := true;
    exit;
  End;
  Temp := Search(SearchItem);
  If Temp = nil then
  begin
    result := false;
    exit;
  end;
  If Temp.GetNext = nil then
  begin
    NewItem.SetNext(nil);
    NewItem.SetPrev(Temp);
    Temp.SetNext(NewItem);
    Count := Count + 1;
    result := true
  End
  Else
  Begin
    NewItem.SetNext(Temp.GetNext);
    NewItem.SetPrev(Temp);
    NewItem.GetNext.SetPrev(NewItem);
    Temp.SetNext(NewItem);
    Count := Count + 1;
  End;
end;

Function TList.Delete(SearchItem: string): boolean;
var
  Temp: TListItem;
begin
  result := false;
  if Count = 0 then
    exit;
  Temp := Search(SearchItem);
  If Temp = First then
  begin
    // удаление единственного эл.
    If First.GetNext = nil then
    begin
      result := true;
      First := nil;
      Count := 0;
      exit;
    End;
    // удаление первого эл.
    First := Temp.GetNext;
    First.SetPrev(nil);
    Count := Count - 1;
    result := true;
    Temp := nil;
    exit;
  End;
  // удаление из середины списка
  Temp.GetPrev.SetNext(Temp.GetNext);
  if Temp.GetNext <> nil then
    Temp.GetNext.SetPrev(Temp.GetPrev);
  Temp := nil;
  Count := Count - 1;
  result := true;
end;

Function TList.Search(SearchItem: string): TListItem;
var
  Temp: TListItem;
begin
  result := nil;
  Temp := First;
  while (Temp <> nil) do
    if (Temp.GetInfo = SearchItem) then
    begin
      result := Temp;
      break;
    end
    else
      Temp := Temp.GetNext;
end;

Procedure TList.NextStep();
begin
  IsContinue:=true;
end;

end.
