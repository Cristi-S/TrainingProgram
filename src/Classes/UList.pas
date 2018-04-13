unit UList;

interface

Uses
  UListItem, System.Classes;

Type
  TList = class
  Private
    Count: Integer;
    First: TListItem;
  Public
    Constructor Create;
    Function Getcount: Integer;
    Function GetFirst: TListItem;
    Function Add(SearchItem: string; NewItem: TListItem): boolean;
    procedure Resume();
    Function Delete(SearchItem: string): boolean;
    Function Search(SearchItem: string): TListItem;
  End;

  // ����� ��� ������ � �������
  TAddThread = class(TThread)
  private
    list: TList;
    SearchItem: String;
    NewItem: TListItem;
    result: boolean;
    procedure Add();
  public
    constructor Create(alist: TList; aparam1: String; aparam2: TListItem);
  protected
    procedure Execute; override;
  end;

implementation

uses Logger;

var
  thread: TAddThread;

procedure TList.Resume;
begin
  if (not thread.Finished) then
    if thread.Suspended then
      thread.Resume;
end;

procedure TAddThread.Execute;
var
  Temp: TListItem;
Begin
  if not Suspended then
  begin
    TLogger.Log('=====���������� ������ �������� � ������=====');
    // ���������� ������� �������� � ������
    If list.First = nil then
    begin
      TLogger.Log('���������� ������� �������� � ������');
      TLogger.Log('��������� First �������� � ����� �������');
      list.First := NewItem;
      Suspend;
      TLogger.Log('����������� ������� ����� ���������');
      inc(list.Count);
      result := True;
      exit;
    End;
    TLogger.Log('����� ��������� ��������');
    // ���� ������� ����� �������� ���������
    Temp := list.Search(SearchItem);
    If Temp = nil then
    begin
      TLogger.Log('������� ������� �� ������');
      result := False;
      exit;
    end;
    // ���������� � �����
    If Temp.GetNext = nil then
    begin
      TLogger.Log('�������� ���� next � ���������� = null. ��������� � �����.');
      NewItem.SetNext(nil);
      Suspend;
      TLogger.Log
        ('� �������� ���� "Prev" ��� ������ �������� ���������� ������ �� ��������� ������� "Temp" ');
      NewItem.SetPrev(Temp);
      Suspend;
      TLogger.Log
        ('� �������� ���� "Next" ��� ���������� �������� ���������� ������ �� ����� ������� "New" ');
      Temp.SetNext(NewItem);
      Suspend;
      TLogger.Log('����������� ������� ����� ���������');
      inc(list.Count);
      result := True
    End
    Else
    // ���������� � ��������
    Begin
      TLogger.Log('��������� ���� ������ ��������, � ���������:');
      TLogger.Log
        ('� ���� next ��������� ����� ���������� �������� (������� �� ���� next ���������� ��������)');
      NewItem.SetNext(Temp.GetNext);
      Suspend;
      TLogger.Log
        ('� ���� prev ��������� ����� ��������������� ��������, ������� �������� ��������� �������');
      NewItem.SetPrev(Temp);
      Suspend;
      TLogger.Log
        ('�������� �������� ���� prev � ��������, ������� ������ ��������� �� �����, �� ����� ������ ��������');
      NewItem.GetNext.SetPrev(NewItem);
      Suspend;
      TLogger.Log
        ('�������� �������� ���� next � ���������� �������� �� ����� ������ ��������');
      Temp.SetNext(NewItem);
      inc(list.Count);
    End;
  end;
end;

constructor TAddThread.Create(alist: TList; aparam1: String;
  aparam2: TListItem);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  SearchItem := aparam1;
  NewItem := aparam2;
  list := alist;

  Resume;

  // Synchronize(Add);
end;

procedure TAddThread.Add();
var
  Temp: TListItem;
Begin
  TLogger.Log('=====���������� ������ �������� � ������=====');
  // ���������� ������� �������� � ������
  If list.First = nil then
  begin
    TLogger.Log('���������� ������� �������� � ������');
    TLogger.Log('��������� First �������� � ����� �������');
    list.First := NewItem;
    Suspend;
    TLogger.Log('����������� ������� ����� ���������');
    inc(list.Count);
    result := True;
    exit;
  End;
  TLogger.Log('����� ��������� ��������');
  // ���� ������� ����� �������� ���������
  Temp := list.Search(SearchItem);
  If Temp = nil then
  begin
    TLogger.Log('������� ������� �� ������');
    result := False;
    exit;
  end;
  // ���������� � �����
  If Temp.GetNext = nil then
  begin
    TLogger.Log('�������� ���� next � ���������� = null. ��������� � �����.');
    NewItem.SetNext(nil);
    Suspend;
    TLogger.Log
      ('� �������� ���� "Prev" ��� ������ �������� ���������� ������ �� ��������� ������� "Temp" ');
    NewItem.SetPrev(Temp);
    Suspend;
    TLogger.Log
      ('� �������� ���� "Next" ��� ���������� �������� ���������� ������ �� ����� ������� "New" ');
    Temp.SetNext(NewItem);
    Suspend;
    TLogger.Log('����������� ������� ����� ���������');
    inc(list.Count);
    result := True
  End
  Else
  // ���������� � ��������
  Begin
    TLogger.Log('��������� ���� ������ ��������, � ���������:');
    TLogger.Log
      ('� ���� next ��������� ����� ���������� �������� (������� �� ���� next ���������� ��������)');
    NewItem.SetNext(Temp.GetNext);
    Suspend;
    TLogger.Log
      ('� ���� prev ��������� ����� ��������������� ��������, ������� �������� ��������� �������');
    NewItem.SetPrev(Temp);
    Suspend;
    TLogger.Log
      ('�������� �������� ���� prev � ��������, ������� ������ ��������� �� �����, �� ����� ������ ��������');
    NewItem.GetNext.SetPrev(NewItem);
    Suspend;
    TLogger.Log
      ('�������� �������� ���� next � ���������� �������� �� ����� ������ ��������');
    Temp.SetNext(NewItem);
    inc(list.Count);
  End;
end;

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
  TLogger.Log('=====���������, �������� �����=====');
  thread := TAddThread.Create(Self, SearchItem, NewItem);

end;

Function TList.Delete(SearchItem: string): boolean;
var
  Temp: TListItem;
begin
  result := False;
  if Count = 0 then
    exit;
  Temp := Search(SearchItem);
  If Temp = First then
  begin
    // �������� ������������� ��.
    If First.GetNext = nil then
    begin
      result := True;
      First := nil;
      Count := 0;
      exit;
    End;
    // �������� ������� ��.
    First := Temp.GetNext;
    First.SetPrev(nil);
    Count := Count - 1;
    result := True;
    Temp := nil;
    exit;
  End;
  // �������� �� �������� ������
  Temp.GetPrev.SetNext(Temp.GetNext);
  if Temp.GetNext <> nil then
    Temp.GetNext.SetPrev(Temp.GetPrev);
  Temp := nil;
  Count := Count - 1;
  result := True;
end;

Function TList.Search(SearchItem: string): TListItem;
var
  Temp: TListItem;
begin
  result := nil;
  TLogger.Log('������������� ��������� temp � ����� ������� �������� � ������');
  Temp := First;
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
      TLogger.Log('��������� � ����������');
    end;
end;

end.
