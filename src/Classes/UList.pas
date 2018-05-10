unit UList;

{ ��������� ��������� ������.
  � ��������� �� ������ ������ Mode ���������
  �������� ��������� �������� ���������� � �������� ��������� �� ������,
  � ������� ������������������ ����� � Memo
}
interface

Uses
  UListItem, SyncObjs, System.Classes, Windows, dialogs, SysUtils, UQuestions,
  UEnum;

Type
  TList = class
  Private
    Count: Integer;
    First: TMyListItem;
    // ThreadId: Integer;
    // FState: TListState;
    FTempItem: TMyListItem;
    FNewItem: TMyListItem;
    // ���� ����������� �� ���������� ������� MyEvent.
    // ��� TNotifyEvent ������ � ������ Clases ���: TNotifyEvent = procedure(Sender: TObject) of object;
    // �����  "of object" ��������, ��� � �������� ����������� ����� ��������� ������ ����� ������-����
    // ������, � �� ������������ ���������.
    FOnThreadSuspended: TNotifyEvent;
    FDeleteItem: TMyListItem;
    FSearchItem: TMyListItem;
    procedure _AddAfter();
    procedure _AddBefore();
    Function _Delete(): boolean;
    procedure Pause();
  Public
    QuestionKey: Integer;
    ThreadId: Integer;
    State: TListState;
    Mode: TOperatingMode;
    Constructor Create;
    Function Getcount: Integer;
    Function GetFirst: TMyListItem;
    Function AddAfter(SearchItem: string; NewItem: TMyListItem): boolean;
    Function AddBefore(SearchItem: string; NewItem: TMyListItem): boolean;
    Function Delete(SearchItem: string): boolean;
    Function Search(SearchItem: string): TMyListItem;
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
    property NewItem: TMyListItem read FNewItem;
    property TempItem: TMyListItem read FTempItem;
    property DeleteItem: TMyListItem read FDeleteItem;
    property SearchItem: TMyListItem read FSearchItem;
  End;

implementation

uses Logger;

var
  CritSec: TCriticalSection; // ������ ����������� ������
  // ���������� ��� �������� ������� ���������� � ������� ����������
  _NewItem: TMyListItem;
  _SearchItem: string;

Constructor TList.Create;
begin
  Count := 0;
  First := nil;
  Mode := omDemo;
  State := lsNormal;
  CritSec := TCriticalSection.Create;
end;

{$REGION 'Public functions'}

Function TList.Getcount: Integer;
begin
  result := Count;
end;

Function TList.GetFirst: TMyListItem;
begin
  result := First;
end;

function TList.AddAfter(SearchItem: string; NewItem: TMyListItem): boolean;
var
  id: longword;
begin
  _NewItem := NewItem;
  _SearchItem := SearchItem;
  State := lsAddAfter;
  ThreadId := BeginThread(nil, 0, @TList._AddAfter, Self, 0, id);
end;

function TList.AddBefore(SearchItem: string; NewItem: TMyListItem): boolean;
var
  id: longword;
begin
  _NewItem := NewItem;
  _SearchItem := SearchItem;
  State := lsAddbefore;
  ThreadId := BeginThread(nil, 0, @TList._AddBefore, Self, 0, id);
end;

Function TList.Delete(SearchItem: string): boolean;
var
  id: longword;
begin
  State := lsDelete;
  _SearchItem := SearchItem;
  ThreadId := BeginThread(nil, 0, @TList._Delete, Self, 0, id);
end;

{$ENDREGION}
{$REGION 'Thread functions'}

procedure TList._AddAfter();
var
  NewItem: TMyListItem;
  SearchItem: string;
{$REGION '��������� ������� ��� ����������'}
  procedure CLeanListItemsStates;
  var
    temp, last: TMyListItem;
  begin
    temp := First;
    while temp <> nil do
    begin
      temp.IsAddBefore := false;
      temp.IsAddAfter := false;
      temp.IsFirst := false;
      temp.IsLast := false;
      last := temp;
      temp := temp.GetNext;
    end;

    First.IsFirst := true;
    last.IsLast := true;

    FTempItem := nil;
    FNewItem := nil;
  end;

  procedure FuncEnd();
  begin
    State := lsNormal;
    CLeanListItemsStates;
    TLogger.DisableCouner;
    TLogger.Log('');
    if Mode <> omNormal then
      GenericMyEvent;
    CritSec.Leave;
    EndThread(0);
    exit;
  end;
{$ENDREGION}

Begin
  CritSec.Enter;

  NewItem := _NewItem;
  SearchItem := _SearchItem;

  QuestionKey := 1;

  if Count = 0 then
    TLogger.Log('���������� ����� ' + NewItem.GetInfo)
  else
    TLogger.Log('���������� ����� ' + NewItem.GetInfo + ' ����� ����� ' +
      SearchItem);
  TLogger.EnableCouner;
  // ���������� ������� ��������
  If First = nil then
  begin
    QuestionKey := 2;
    Pause();
    TLogger.Log('�������� ������ �� �������: ������ ����');

    QuestionKey := 3;
    Pause();
    TLogger.Log('��������� ������ ��� ������ ��������');

    QuestionKey := 4;
    Pause();
    TLogger.Log('���������� ��������������� ����: ' + NewItem.GetInfo);

    QuestionKey := 12;
    Pause();
    TLogger.Log('�������� ��������� First');

    First := NewItem;
    NewItem.IsFirst := true;
    NewItem.IsLast := true;

    QuestionKey := 11;
    Pause();
    TLogger.Log('����������� ���������� ���������');

    inc(Count);
    FuncEnd();
  End
  else
  // ���������� � �������� ������
  begin
    QuestionKey := 2;
    Pause();
    TLogger.Log('�������� ������ �� �������: ������ �������� ��������');

    QuestionKey := 5;
    Pause();
    TLogger.Log('����� �������� � ������ ' + SearchItem);

    FNewItem := NewItem;
    FTempItem := Search(SearchItem);
    If TempItem = nil then
    begin
      TLogger.Append(' - ������� ������� �� ������');
      FuncEnd();
    end;
    QuestionKey := 3;
    Pause();
    TLogger.Log('��������� ������ ��� ������ ��������');
    // ����������� � �����
    If TempItem.GetNext = nil then
    begin
      TempItem.IsAddAfter := true;

      QuestionKey := 4;
      Pause();
      TLogger.Log('���������� ��������������� ����:' + NewItem.GetInfo);

      NewItem.SetNext(nil);

      QuestionKey := 8;
      Pause();
      TLogger.Log('���������� ���� ������ �� ������ ������');

      NewItem.SetPrev(TempItem);

      QuestionKey := 10;
      Pause();
      TLogger.Log('��������� ������ ������ � ������ ������');

      TempItem.SetNext(NewItem);
      TempItem.IsAddAfter := false;
      TempItem.IsLast := false;
      NewItem.IsLast := true;

      QuestionKey := 11;
      Pause();
      TLogger.Log('����������� ���������� ���������');

      inc(Count);
    End
    Else
    Begin
      TempItem.IsAddAfter := true;
      QuestionKey := 7;
      Pause();
      TLogger.Log('���������� ���� ������ �� ������� ������');

      NewItem.SetNext(TempItem.GetNext);

      QuestionKey := 8;
      Pause();
      TLogger.Log('���������� ���� ������ �� ������ ������');
      NewItem.SetPrev(TempItem);

      QuestionKey := 9;
      Pause();
      TLogger.Log('��������� ����� ������ � ������� ������');
      NewItem.GetNext.SetPrev(NewItem);

      QuestionKey := 10;
      Pause();
      TLogger.Log('��������� ������ ������ � ������ ������');
      TempItem.SetNext(NewItem);

      QuestionKey := 11;
      Pause();
      TLogger.Log('����������� ���������� ���������');

      inc(Count)
    End;
  End;
  FuncEnd();
end;

procedure TList._AddBefore();
var
  NewItem: TMyListItem;
  SearchItem: string;
{$REGION '��������� ������� ��� ����������'}
  procedure CLeanListItemsStates;
  var
    temp, last: TMyListItem;
  begin
    temp := First;
    while temp <> nil do
    begin
      temp.IsAddBefore := false;
      temp.IsAddAfter := false;
      temp.IsFirst := false;
      temp.IsLast := false;
      last := temp;
      temp := temp.GetNext;
    end;

    First.IsFirst := true;
    last.IsLast := true;

    FTempItem := nil;
    FNewItem := nil;
  end;

  procedure FuncEnd();
  begin
    State := lsNormal;
    CLeanListItemsStates;
    TLogger.DisableCouner;
    TLogger.Log('');
    if Mode <> omNormal then
      GenericMyEvent;
    CritSec.Leave;
    EndThread(0);
    exit;
  end;
{$ENDREGION}

Begin
  CritSec.Enter;

  NewItem := _NewItem;
  SearchItem := _SearchItem;

  QuestionKey := 1;

  TLogger.Log('���������� ����� ' + NewItem.GetInfo + ' ����� ������ ' +
    SearchItem);

  QuestionKey := 2;
  Pause();
  TLogger.EnableCouner;
  TLogger.Log('�������� ������ �� �������: ������ �������� ��������');

  QuestionKey := 5;
  Pause();
  TLogger.Log('����� �������� � ������ ' + SearchItem);

  FNewItem := NewItem;
  FTempItem := Search(SearchItem);
  If TempItem = nil then
  begin
    TLogger.Append(' - ������� ������� �� ������');
    FuncEnd();
  end;

  QuestionKey := 3;
  Pause();
  TLogger.Log('��������� ������ ��� ������ ��������');

  FSearchItem := FTempItem;
  If TempItem.GetPrev = nil then
  begin
    TempItem.IsAddBefore := true;

    QuestionKey := 4;
    Pause();
    TLogger.Log('���������� ��������������� ����:' + NewItem.GetInfo);

    NewItem.SetPrev(nil);

    QuestionKey := 9;
    Pause();
    TLogger.Log('��������� ����� ������ � ������� ������');

    TempItem.SetPrev(NewItem);

    QuestionKey := 7;
    Pause();
    TLogger.Log('���������� ���� ������ �� ������� ������');

    NewItem.SetNext(TempItem);

    QuestionKey := 11;
    Pause();
    TLogger.Log('����������� ���������� ���������');

    inc(Count);

    QuestionKey := 12;
    Pause();
    TLogger.Log('�������� ��������� First');
    First := NewItem;
    FuncEnd();
  End
  Else
  Begin
    TempItem.IsAddBefore := true;

    QuestionKey := 7;
    Pause();
    TLogger.Log('���������� ���� ������ �� ������� ������');

    NewItem.SetNext(TempItem);

    QuestionKey := 8;
    Pause();
    TLogger.Log('���������� ���� ������ �� ������ ������');
    NewItem.SetPrev(TempItem.GetPrev);

    QuestionKey := 9;
    Pause();
    TLogger.Log('��������� ����� ������ � ������� ������');
    TempItem.SetPrev(NewItem);

    QuestionKey := 10;
    Pause();
    TLogger.Log('��������� ������ ������ � ������ ������');
    NewItem.GetPrev.SetNext(NewItem);

    QuestionKey := 11;
    Pause();
    TLogger.Log('����������� ���������� ���������');

    inc(Count)
  End;
  FuncEnd();
end;

Function TList._Delete(): boolean;
{$REGION '��������� ������� ��� ��������'}
  procedure CLeanListItemsStates;
  var
    temp, last: TMyListItem;
  begin
    temp := First;
    while temp <> nil do
    begin
      temp.IsAddBefore := false;
      temp.IsAddAfter := false;
      temp.IsFirst := false;
      temp.IsLast := false;
      temp.IsDelete := false;
      last := temp;
      temp := temp.GetNext;
    end;

    First.IsFirst := true;
    last.IsLast := true;

    FDeleteItem := nil;
    FTempItem := nil;
    FNewItem := nil;
  end;

  procedure FuncEnd();
  begin
    State := lsNormal;
    CLeanListItemsStates;
    GenericMyEvent;
    TLogger.DisableCouner;
    TLogger.Log('');
    CritSec.Leave;
    EndThread(0);
    exit;
  end;
{$ENDREGION}

begin
  CritSec.Enter;

  TLogger.Log('�������� �������� �� ������');
  TLogger.EnableCouner;

  QuestionKey := 1;
  Pause();
  TLogger.Log('�������� ������� ��������� � ������: count= ' + IntToStr(Count));
  result := false;
  if Count = 0 then
    FuncEnd;

  QuestionKey := 2;
  Pause();
  TLogger.Log('����� ��������� ��������');

  FTempItem := Search(_SearchItem);

  If TempItem = nil then
  begin
    TLogger.Log('������� ������� �� ������');
    FuncEnd();
  end;

  FTempItem.IsDelete := true;
  FDeleteItem := FTempItem;

  If FTempItem = First then
  begin
    // �������� ������������� ��.
    If First.GetNext = nil then
    begin
      result := true;
      QuestionKey := 2;
      Pause();
      TLogger.Log('��������� First �������� � nil');
      First := nil;

      QuestionKey := 4;
      Pause();
      TLogger.Log('��������� ���������� ���������');
      Count := 0;
      FuncEnd;
    End
    else
    begin
      QuestionKey := 5;
      Pause();
      TLogger.Log('��������� ����� ������ � ������� ������');
      First.GetNext.SetPrev(nil);

      QuestionKey := 6;
      Pause();
      TLogger.Log
        ('��������� First �������� � ��������� �� ��������� ���������');
      First := FTempItem.GetNext;
      CLeanListItemsStates;

      QuestionKey := 4;
      Pause();
      TLogger.Log('��������� ���������� ���������');
      Count := Count - 1;
      result := true;

      QuestionKey := 7;
      Pause();
      TLogger.Log('������������ ��������� �������');
      FTempItem := nil;
      FuncEnd;
    end;
  End;

  QuestionKey := 8;
  Pause();
  TLogger.Log('��������� ������ ������ � ������ ������');
  TempItem.GetPrev.SetNext(FTempItem.GetNext);

  if FTempItem.GetNext <> nil then
  begin
    QuestionKey := 9;
    Pause();
    TLogger.Log('��������� ����� ������ � ������� ������');
    FTempItem.GetNext.SetPrev(FTempItem.GetPrev);
  end;

  QuestionKey := 7;
  Pause();
  TLogger.Log('������������ ��������� �������');
  FTempItem := nil;

  QuestionKey := 4;
  Pause();
  TLogger.Log('��������� ���������� ���������');
  result := true;
  FuncEnd;
end;

Function TList.Search(SearchItem: string): TMyListItem;
var
  oldLogerState: boolean;
begin
  result := nil;
  FTempItem := First;
  // ��������� ������ ��������� �������
  oldLogerState := Logger.Enabled;
  // � ������ ������� - ��������� ������
  if Mode = omControl then
    Logger.Enabled := false;
  while (FTempItem <> nil) do
  begin
    // � ����������� ������ �������� ������������ ������
    if Mode <> omControl then
      Pause();
    if (FTempItem.GetInfo = SearchItem) then
    begin
      TLogger.Log('��������� ������ ' + FTempItem.GetInfo + ' � ' + SearchItem +
        ' ����� - �����');
      result := FTempItem;
      break;
    end
    else
    begin
      TLogger.Log('��������� ������ ' + FTempItem.GetInfo + ' � ' + SearchItem +
        ' �� ����� - ������� � ���������� ��������');
      FTempItem := FTempItem.GetNext;
    end;
  end;
  Logger.Enabled := oldLogerState;
  if Mode = omControl then
    if Assigned(result) then
      if State in [lsAddbefore, lsAddAfter] then
        TLogger.Append(' - ������� ����� ��� �������');
end;

procedure TList.Pause();
begin
  case Mode of
    omControl:
      begin
        GenericMyEvent;
        SuspendThread(ThreadId);
      end;
    omNormal:
      ;
    omDemo:
      begin
        GenericMyEvent;
        SuspendThread(ThreadId);
      end;
  end;

end;

procedure TList.NextStep();
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
