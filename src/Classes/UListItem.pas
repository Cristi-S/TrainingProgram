unit UListItem;

interface

Type
  TListItem = class
  Private
    Info: string;
    Next: TListItem;
    Prev: TListItem;
    FIsFirst: boolean;
    FIsLast: boolean;
    FIsAddBefore: boolean;
    FIsAddAfter: boolean;
    FIsDelete: boolean;
  Public
    Constructor Create(sInfo: string);
    Function GetInfo: string;
    Function GetPrevInfo: string;
    Function GetNextInfo: string;
    Function GetNext: TListItem;
    Function GetPrev: TListItem;
    Procedure SetInfo(sInfo: string);
    Procedure SetNext(aNext: TListItem);
    Procedure SetPrev(aPrev: TListItem);
    function ToString(): string; override;
    property IsFirst: boolean read FIsFirst write FIsFirst;
    property IsLast: boolean read FIsLast write FIsLast;
    property IsAddBefore: boolean read FIsAddBefore write FIsAddBefore;
    property IsAddAfter: boolean read FIsAddAfter write FIsAddAfter;
    property IsDelete: boolean read FIsDelete write FIsDelete;
  End;

implementation

Constructor TListItem.Create(sInfo: string);
begin
  Info := sInfo;
  Next := nil;
  Prev := nil;
  FIsFirst := false;
  FIsLast := true;
  FIsAddBefore := false;
  FIsAddAfter := false;
end;

Function TListItem.GetInfo: string;
begin
  result := Info;
end;

Function TListItem.GetNextInfo: string;
begin
  if Assigned(Next) then
    result := Next.ToString()
  else
    result := 'nul';
end;

Function TListItem.GetPrevInfo: string;
begin
  if Assigned(Prev) then
    result := Prev.ToString
  else
    result := 'nul';
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

function TListItem.ToString(): string;
begin
  result := 'ÀÄÐ[' + Info+']';
end;

end.
