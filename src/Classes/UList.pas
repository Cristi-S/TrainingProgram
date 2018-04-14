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
    FTempItem: TListItem;
    FNewItem: TListItem;
    // ���� ����������� �� ���������� ������� MyEvent.
    // ��� TNotifyEvent ������ � ������ Clases ���: TNotifyEvent = procedure(Sender: TObject) of object;
    // �����  "of object" ��������, ��� � �������� ����������� ����� ��������� ������ ����� ������-����
    // ������, � �� ������������ ���������.
    FOnThreadSuspended: TNotifyEvent;
    procedure _Add();
    Function _Delete(SearchItem: string): boolean;
  Public
    State: TListState;
    Constructor Create;
    Function Getcount: Integer;
    Function GetFirst: TListItem;
    Function Add(msg: string; NewItem: TListItem): boolean;
    Function Delete(SearchItem: string): boolean;
    Function Search(SearchItem: string): TListItem;
    procedure NextStep();
    // ��� ��������� ��������� ����� �� ���������� �������. �, ���� �����, ��������� ���.
    procedure DoMyEvent; dynamic;
    // ��� �������� ��������� ��������� ���������� ��� ��������� ������� MyEvent.
    property OnThreadSyspended: TNotifyEvent read FOnThreadSuspended
      write FOnThreadSuspended;
    // ���������, ������� ��������� ������� - ��������� ������� MyEvent ��� ���.
    // ����� �������� ����� ���� ��������� - ����� ��� ����� ���������� ������� MyEvent.
    // ���� ������� MyEvent ���������, �� ��������� ��������� DoMyEvent().
    procedure GenericMyEvent;
  protected
    // property State: TListState read FState write FState;
    property TempItem: TListItem read FTempItem;
    property NewItem: TListItem read FNewItem;
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
  NewItem: TListItem;
  SearchItem: string;

  procedure FuncEnd();
  begin
    State := lsNormal;
    GenericMyEvent;
    TLogger.Log('=====��������� ���������� ������ �������� � ������=====');
    CritSec.Leave;
    EndThread(0);
    exit;
  end;

  procedure Pause();
  begin
    GenericMyEvent;
    SuspendThread(ThreadId);
  end;

Begin
  CritSec.Enter;

  NewItem := _NewItem;
  SearchItem := _SearchItem;

  TLogger.Log('=====���������� ������ �������� � ������=====');
  If First = nil then
  begin
    TLogger.Log('������ ����. ��������� ������ �������');
    TLogger.Log('��������� First �������� � ����� �������');
    First := NewItem;
    NewItem.IsFirst := true;
    NewItem.IsLast := true;
    Pause();
    TLogger.Log('����������� ������� ����� ���������');
    inc(Count);
    // result := true;
    FuncEnd();
  End;
  TLogger.Log('=====����� ��������� ��������=====');
  FTempItem := Search(SearchItem);
  If TempItem = nil then
  begin
    TLogger.Log('������� ������� �� ������');
    // result := false;
    FuncEnd();
  end;
  If TempItem.GetNext = nil then
  begin
    TempItem.IsAddAfter := true;
    TLogger.Log('�������� ���� next � ���������� = null. ��������� � �����.');
    NewItem.SetNext(nil);
    Pause();
    TLogger.Log
      ('� �������� ���� "Prev" ��� ������ �������� ���������� ������ �� ����������');
    NewItem.SetPrev(TempItem);
    Pause();
    TLogger.Log
      ('� �������� ���� "Next" ��� ���������� �������� ���������� ������ �� ����� ������� "New" ');
    TempItem.SetNext(NewItem);
    Pause();
    TLogger.Log('����������� ������� ����� ���������');
    inc(Count);
    TempItem.IsAddAfter := false;
    TempItem.IsLast := false;
    NewItem.IsLast := true;
    // result := true
  End
  Else
  Begin
    TLogger.Log('��������� ���� ������ ��������, � ���������:');
    TLogger.Log
      ('� ���� next ��������� ����� ���������� �������� (������� �� ���� next ���������� ��������)');
    NewItem.SetNext(TempItem.GetNext);
    Pause();
    TLogger.Log
      ('� ���� prev ��������� ����� ��������������� ��������, ������� �������� ��������� �������');
    NewItem.SetPrev(TempItem);
    Pause();
    TLogger.Log
      ('�������� �������� ���� prev � ��������, ������� ������ ��������� �� �����, �� ����� ������ ��������');
    NewItem.GetNext.SetPrev(NewItem);
    Pause();
    TLogger.Log
      ('�������� �������� ���� next � ���������� �������� �� ����� ������ ��������');
    TempItem.SetNext(NewItem);
    inc(Count)
  End;
  FuncEnd();
end;

Function TList._Delete(SearchItem: string): boolean;
var
  Temp: TListItem;
  procedure Pause();
  begin
    GenericMyEvent;
    SuspendThread(ThreadId);
  end;

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
  procedure Pause();
  begin
    GenericMyEvent;
    SuspendThread(ThreadId);
  end;

begin
  result := nil;
  TLogger.Log('������������� ��������� temp � ����� ������� �������� � ������');
  FTempItem := First;
  Pause();
  TLogger.Log('���������� ������� ������� � �������:');
  while (FTempItem <> nil) do
    if (FTempItem.GetInfo = SearchItem) then
    begin
      TLogger.Log(FTempItem.GetInfo + ' = ' + SearchItem);
      result := FTempItem;
      break;
    end
    else
    begin
      TLogger.Log(FTempItem.GetInfo + ' <> ' + SearchItem);
      FTempItem := FTempItem.GetNext;
      Pause();
      TLogger.Log('��������� � ����������');
    end;
end;

Procedure TList.NextStep();
begin
  ResumeThread(ThreadId);
end;
{$ENDREGION}
{$REGION 'Event'}

procedure TList.DoMyEvent;
begin
  // ���� ���������� ��������, �� ��������� ���.
  if Assigned(FOnThreadSuspended) then
    FOnThreadSuspended(Self);
end;

procedure TList.GenericMyEvent;
var
  MyEventIsOccurred: boolean;
begin
  MyEventIsOccurred := true;
  // ���� ����� ��������� �������, ������� ������������, ��� ������� MyEvent
  // ���������, �� ������ ������� ��������� ��������� ����������.
  if MyEventIsOccurred then
  begin
    DoMyEvent;
  end;
end;

{$ENDREGION}

end.
