unit UList;

interface

Uses
  UListItem, SyncObjs, System.Classes, Windows, dialogs;

Type
  TListState = (lsNormal, lsAddbefore, lsAddafter, lsDelete);

  TList = class
  Private
    Count: Integer;
    First: TListItem;
    ThreadId: Integer;
    FState: TListState;

    procedure _Add();
    Function _Delete(SearchItem: string): boolean;
  Public
    Constructor Create;
    Function Getcount: Integer;
    Function GetFirst: TListItem;
    Function Add(msg: string; NewItem: TListItem): boolean;
    Function Delete(SearchItem: string): boolean;
    Function Search(SearchItem: string): TListItem;
    procedure NextStep();
  protected
    property State: TListState read FState write FState;
  End;

implementation

uses Logger;

var
  CritSec: TCriticalSection; // ������ ����������� ������
  // ���������� ��� �������� ������� ���������� � ������� ����������
  _NewItem: TListItem;
  _SearchItem: string;

Constructor TList.Create;
begin
  Count := 0;
  First := nil;
  State := lsNormal;
  CritSec := TCriticalSection.Create;
end;

{$REGION 'Public functions'}

Function TList.Getcount: Integer;
begin
  result := Count;
end;

Function TList.GetFirst: TListItem;
begin
  result := First;
end;

function TList.Add(msg: string; NewItem: TListItem): boolean;
var
  id: longword;
begin
  _NewItem := NewItem;
  _SearchItem := msg;
  State := lsAddafter;
  ThreadId := BeginThread(nil, 0, @TList._Add, Self, 0, id);
end;

Function TList.Delete(SearchItem: string): boolean;
begin
  State := lsDelete;
  _Delete(SearchItem);
end;

{$ENDREGION}
{$REGION 'Thread functions'}

procedure TList._Add();
var
  Temp: TListItem;
  NewItem: TListItem;
  SearchItem: string;
Begin
  CritSec.Enter;

  NewItem := _NewItem;
  SearchItem := _SearchItem;

  TLogger.Log('=====���������� ������ �������� � ������=====');
  If First = nil then
  begin
    TLogger.Log('���������� ������� �������� � ������');
    TLogger.Log('��������� First �������� � ����� �������');
    First := NewItem;
    SuspendThread(ThreadId);
    TLogger.Log('����������� ������� ����� ���������');
    inc(Count);
    // result := true;
    TLogger.Log('=====��������� ���������� ������ �������� � ������=====');
    CritSec.Leave;
    EndThread(0);
    exit;
  End;
  TLogger.Log('=====����� ��������� ��������=====');
  Temp := Search(SearchItem);
  If Temp = nil then
  begin
    TLogger.Log('������� ������� �� ������');
    // result := false;
    TLogger.Log('=====��������� ���������� ������ �������� � ������=====');
    CritSec.Leave;
    EndThread(0);
    exit;
  end;
  If Temp.GetNext = nil then
  begin
    TLogger.Log('�������� ���� next � ���������� = null. ��������� � �����.');
    NewItem.SetNext(nil);
    SuspendThread(ThreadId);
    NewItem.SetPrev(Temp);
    SuspendThread(ThreadId);
    TLogger.Log
      ('� �������� ���� "Next" ��� ���������� �������� ���������� ������ �� ����� ������� "New" ');
    Temp.SetNext(NewItem);
    SuspendThread(ThreadId);
    TLogger.Log('����������� ������� ����� ���������');
    inc(Count)
    // result := true
  End
  Else
  Begin
    TLogger.Log('��������� ���� ������ ��������, � ���������:');
    TLogger.Log
      ('� ���� next ��������� ����� ���������� �������� (������� �� ���� next ���������� ��������)');
    NewItem.SetNext(Temp.GetNext);
    SuspendThread(ThreadId);
    TLogger.Log
      ('� ���� prev ��������� ����� ��������������� ��������, ������� �������� ��������� �������');
    NewItem.SetPrev(Temp);
    SuspendThread(ThreadId);
    TLogger.Log
      ('�������� �������� ���� prev � ��������, ������� ������ ��������� �� �����, �� ����� ������ ��������');
    NewItem.GetNext.SetPrev(NewItem);
    SuspendThread(ThreadId);
    TLogger.Log
      ('�������� �������� ���� next � ���������� �������� �� ����� ������ ��������');
    Temp.SetNext(NewItem);
    inc(Count)
  End;
  TLogger.Log('=====��������� ���������� ������ �������� � ������=====');
  CritSec.Leave;
  EndThread(0);
end;

Function TList._Delete(SearchItem: string): boolean;
var
  Temp: TListItem;
begin
  result := false;
  if Count = 0 then
    exit;
  Temp := Search(SearchItem);
  If Temp = First then
  begin
    // �������� ������������� ��.
    If First.GetNext = nil then
    begin
      result := true;
      First := nil;
      Count := 0;
      exit;
    End;
    // �������� ������� ��.
    First := Temp.GetNext;
    First.SetPrev(nil);
    Count := Count - 1;
    result := true;
    Temp := nil;
    exit;
  End;
  // �������� �� �������� ������
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
  TLogger.Log('������������� ��������� temp � ����� ������� �������� � ������');
  Temp := First;
  SuspendThread(ThreadId);
  TLogger.Log('���������� ������� ������� � �������:');
  while (Temp <> nil) do
    if (Temp.GetInfo = SearchItem) then
    begin
      TLogger.Log(Temp.GetInfo + ' = ' + SearchItem);
      result := Temp;
      break;
    end
    else
    begin
      TLogger.Log(Temp.GetInfo + ' <> ' + SearchItem);
      Temp := Temp.GetNext;
      SuspendThread(ThreadId);
      TLogger.Log('��������� � ����������');
    end;
end;

Procedure TList.NextStep();
begin
  ResumeThread(ThreadId);
end;
{$ENDREGION}

end.
