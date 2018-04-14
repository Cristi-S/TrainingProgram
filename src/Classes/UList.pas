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
    // Поле ссылающееся на обработчик события MyEvent.
    // Тип TNotifyEvent описан в модуле Clases так: TNotifyEvent = procedure(Sender: TObject) of object;
    // Фраза  "of object" означает, что в качестве обработчика можно назначить только метод какого-либо
    // класса, а не произвольную процедуру.
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
    // Эта процедура проверяет задан ли обработчик события. И, если задан, запускает его.
    procedure DoMyEvent; dynamic;
    // Это свойство позволяет назначить обработчик для обработки события MyEvent.
    property OnThreadSyspended: TNotifyEvent read FOnThreadSuspended
      write FOnThreadSuspended;
    // Процедура, которая принимает решение - произошло событие MyEvent или нет.
    // Таких процедур может быть несколько - везде где может возникнуть событие MyEvent.
    // Если событие MyEvent произошло, то вызвается процедура DoMyEvent().
    procedure GenericMyEvent;
  protected
    // property State: TListState read FState write FState;
    property TempItem: TListItem read FTempItem;
    property NewItem: TListItem read FNewItem;
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
  NewItem: TListItem;
  SearchItem: string;

  procedure FuncEnd();
  begin
    State := lsNormal;
    GenericMyEvent;
    TLogger.Log('=====Закончили добавление нового элемента в список=====');
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

  TLogger.Log('=====Добавление нового элемента в список=====');
  If First = nil then
  begin
    TLogger.Log('Список пуст. Добавляем первый элемент');
    TLogger.Log('Указатель First адресуем с новый элемент');
    First := NewItem;
    NewItem.IsFirst := true;
    NewItem.IsLast := true;
    Pause();
    TLogger.Log('Увеличиваем счетчик числа элементов');
    inc(Count);
    // result := true;
    FuncEnd();
  End;
  TLogger.Log('=====Поиск заданного элемента=====');
  FTempItem := Search(SearchItem);
  If TempItem = nil then
  begin
    TLogger.Log('Искомый элемент не найден');
    // result := false;
    FuncEnd();
  end;
  If TempItem.GetNext = nil then
  begin
    TempItem.IsAddAfter := true;
    TLogger.Log('Адресное поле next у найденного = null. Добавляем в конец.');
    NewItem.SetNext(nil);
    Pause();
    TLogger.Log
      ('В адресной поле "Prev" для нового элемента записываем ссылку на найденного');
    NewItem.SetPrev(TempItem);
    Pause();
    TLogger.Log
      ('В адресной поле "Next" для найденного элемента записываем ссылку на новый элемент "New" ');
    TempItem.SetNext(NewItem);
    Pause();
    TLogger.Log('Увеличиваем счетчик числа элементов');
    inc(Count);
    TempItem.IsAddAfter := false;
    TempItem.IsLast := false;
    NewItem.IsLast := true;
    // result := true
  End
  Else
  Begin
    TLogger.Log('Формируем поля нового элемента, в частности:');
    TLogger.Log
      ('в поле next заносится адрес следующего элемента (берется из поля next найденного элемента)');
    NewItem.SetNext(TempItem.GetNext);
    Pause();
    TLogger.Log
      ('в поле prev заносится адрес предшествующего элемента, которым является найденный элемент');
    NewItem.SetPrev(TempItem);
    Pause();
    TLogger.Log
      ('Изменяем адресное поле prev у элемента, который должен следовать за новым, на адрес нового элемента');
    NewItem.GetNext.SetPrev(NewItem);
    Pause();
    TLogger.Log
      ('Изменяем адресное поле next у найденного элемента на адрес нового элемента');
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
  procedure Pause();
  begin
    GenericMyEvent;
    SuspendThread(ThreadId);
  end;

begin
  result := nil;
  TLogger.Log('Устанавливаем указатель temp в адрес первого элемента в списке');
  FTempItem := First;
  Pause();
  TLogger.Log('Сравниваем искомый элемент с текущим:');
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
      TLogger.Log('Переходим к следующему');
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
  // Если обработчик назначен, то запускаем его.
  if Assigned(FOnThreadSuspended) then
    FOnThreadSuspended(Self);
end;

procedure TList.GenericMyEvent;
var
  MyEventIsOccurred: boolean;
begin
  MyEventIsOccurred := true;
  // Если верно некоторое условие, которое подтверждает, что событие MyEvent
  // произошло, то делаем попытку запустить связанный обработчик.
  if MyEventIsOccurred then
  begin
    DoMyEvent;
  end;
end;

{$ENDREGION}

end.
