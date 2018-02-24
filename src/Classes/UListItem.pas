unit UListItem;

interface

Type
  TListItem = class
  Private
    Info: string;
    Next: TListItem;
    Prev: TListItem;
  Public
    Constructor Create(sInfo: string);
    Function GetInfo: string;
    Function GetNext: TListItem;
    Function GetPrev: TListItem;
    Procedure SetInfo(sInfo: string);
    Procedure SetNext(aNext: TListItem);
    Procedure SetPrev(aPrev: TListItem);
  End;

implementation

Constructor TListItem.Create(sInfo: string);
begin
  Info := sInfo;
  Next := nil;
  Prev := nil;
end;

Function TListItem.GetInfo: string;
begin
  result := Info;
end;

Function TListItem.GetNext: TListItem;
begin
  result := Next;
end;

Function TListItem.GetPrev: TListItem;
begin
  result := Prev;
end;

Procedure TListItem.SetInfo(sInfo: string);
begin
  Info := sInfo;
end;

Procedure TListItem.SetNext(aNext: TListItem);
begin
  Next := aNext;
end;

Procedure TListItem.SetPrev(aPrev: TListItem);
begin
  Prev := aPrev;
end;

end.
