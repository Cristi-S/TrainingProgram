unit UListItem;

interface

Type
  TMyListItem = class
  Private
    Info: string;
    Next: TMyListItem;
    Prev: TMyListItem;
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
    Function GetNext: TMyListItem;
    Function GetPrev: TMyListItem;
    Procedure SetInfo(sInfo: string);
    Procedure SetNext(aNext: TMyListItem);
    Procedure SetPrev(aPrev: TMyListItem);
    function ToString(): string; override;
    property IsFirst: boolean read FIsFirst write FIsFirst;
    property IsLast: boolean read FIsLast write FIsLast;
    property IsAddBefore: boolean read FIsAddBefore write FIsAddBefore;
    property IsAddAfter: boolean read FIsAddAfter write FIsAddAfter;
    property IsDelete: boolean read FIsDelete write FIsDelete;
  End;

implementation

Constructor TMyListItem.Create(sInfo: string);
begin
  Info := sInfo;
  Next := nil;
  Prev := nil;
  FIsFirst := false;
  FIsLast := true;
  FIsAddBefore := false;
  FIsAddAfter := false;
end;

Function TMyListItem.GetInfo: string;
begin
  result := Info;
end;

Function TMyListItem.GetNextInfo: string;
begin
  if Assigned(Next) then
    result := Next.ToString()
  else
    result := 'nul';
end;

Function TMyListItem.GetPrevInfo: string;
begin
  if Assigned(Prev) then
    result := Prev.ToString
  else
    result := 'nul';
end;

Function TMyListItem.GetNext: TMyListItem;
begin
  result := Next;
end;

Function TMyListItem.GetPrev: TMyListItem;
begin
  result := Prev;
end;

Procedure TMyListItem.SetInfo(sInfo: string);
begin
  Info := sInfo;
end;

Procedure TMyListItem.SetNext(aNext: TMyListItem);
begin
  Next := aNext;
end;

Procedure TMyListItem.SetPrev(aPrev: TMyListItem);
begin
  Prev := aPrev;
end;

function TMyListItem.ToString(): string;
begin
  result := 'ÀÄÐ[' + Info+']';
end;

end.
