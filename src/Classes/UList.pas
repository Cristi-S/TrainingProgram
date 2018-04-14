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
  CritSec: TCriticalSection; // объект критической секции
  // переменные для хранения входных парамтеров в функцию добавления
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

  TLogger.Log('=====Добавление нового элемента в список=====');
  If First = nil then
  begin
    TLogger.Log('добавление первого элемента в список');
    TLogger.Log('Указатель First адресуем с новый элемент');
    First := NewItem;
    SuspendThread(ThreadId);
    TLogger.Log('Увеличиваем счетчик числа элементов');
    inc(Count);
    // result := true;
    TLogger.Log('=====Закончили добавление нового элемента в список=====');
    CritSec.Leave;
    EndThread(0);
    exit;
  End;
  TLogger.Log('=====Поиск заданного элемента=====');
  Temp := Search(SearchItem);
  If Temp = nil then
  begin
    TLogger.Log('Искомый элемент не найден');
    // result := false;
    TLogger.Log('=====Закончили добавление нового элемента в список=====');
    CritSec.Leave;
    EndThread(0);
    exit;
  end;
  If Temp.GetNext = nil then
  begin
    TLogger.Log('Адресное поле next у найденного = null. Добавляем в конец.');
    NewItem.SetNext(nil);
    SuspendThread(ThreadId);
    NewItem.SetPrev(Temp);
    SuspendThread(ThreadId);
    TLogger.Log
      ('В адресной поле "Next" для найденного элемента записываем ссылку на новый элемент "New" ');
    Temp.SetNext(NewItem);
    SuspendThread(ThreadId);
    TLogger.Log('Увеличиваем счетчик числа элементов');
    inc(Count)
    // result := true
  End
  Else
  Begin
    TLogger.Log('Формируем поля нового элемента, в частности:');
    TLogger.Log
      ('в поле next заносится адрес следующего элемента (берется из поля next найденного элемента)');
    NewItem.SetNext(Temp.GetNext);
    SuspendThread(ThreadId);
    TLogger.Log
      ('в поле prev заносится адрес предшествующего элемента, которым является найденный элемент');
    NewItem.SetPrev(Temp);
    SuspendThread(ThreadId);
    TLogger.Log
      ('Изменяем адресное поле prev у элемента, который должен следовать за новым, на адрес нового элемента');
    NewItem.GetNext.SetPrev(NewItem);
    SuspendThread(ThreadId);
    TLogger.Log
      ('Изменяем адресное поле next у найденного элемента на адрес нового элемента');
    Temp.SetNext(NewItem);
    inc(Count)
  End;
  TLogger.Log('=====Закончили добавление нового элемента в список=====');
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
  TLogger.Log('Устанавливаем указатель temp в адрес первого элемента в списке');
  Temp := First;
  SuspendThread(ThreadId);
  TLogger.Log('Сравниваем искомый элемент с текущим:');
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
      TLogger.Log('Переходим к следующему');
    end;
end;

Procedure TList.NextStep();
begin
  ResumeThread(ThreadId);
end;
{$ENDREGION}

end.
