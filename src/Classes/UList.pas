unit UList;

interface

Uses
  UListItem, SyncObjs, System.Classes, Windows, dialogs, SysUtils;

Type
  TListState = (lsNormal, lsAddbefore, lsAddAfter, lsDelete);
  TListMode = (lmControl, lmNormal, lmDemo);

  TList = class
  Private
    Count: Integer;
    First: TListItem;
    // ThreadId: Integer;
    // FState: TListState;
    FTempItem: TListItem;
    FNewItem: TListItem;
    // Поле ссылающееся на обработчик события MyEvent.
    // Тип TNotifyEvent описан в модуле Clases так: TNotifyEvent = procedure(Sender: TObject) of object;
    // Фраза  "of object" означает, что в качестве обработчика можно назначить только метод какого-либо
    // класса, а не произвольную процедуру.
    FOnThreadSuspended: TNotifyEvent;
    FDeleteItem: TListItem;
    procedure _AddAfter();
    procedure _AddBefore();
    Function _Delete(): boolean;
    procedure Pause();
  Public
    ThreadId: Integer;
    State: TListState;
    Mode: TListMode;
    Constructor Create;
    Function Getcount: Integer;
    Function GetFirst: TListItem;
    Function AddAfter(SearchItem: string; NewItem: TListItem): boolean;
    Function AddBefore(SearchItem: string; NewItem: TListItem): boolean;
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
    property NewItem: TListItem read FNewItem;
    property TempItem: TListItem read FTempItem;
    property DeleteItem: TListItem read FDeleteItem;
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
  Mode := lmControl;
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

function TList.AddAfter(SearchItem: string; NewItem: TListItem): boolean;
var
  id: longword;
begin
  _NewItem := NewItem;
  _SearchItem := SearchItem;
  State := lsAddAfter;
  ThreadId := BeginThread(nil, 0, @TList._AddAfter, Self, 0, id);
end;

function TList.AddBefore(SearchItem: string; NewItem: TListItem): boolean;
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
  // _Delete(SearchItem);
end;

{$ENDREGION}
{$REGION 'Thread functions'}

procedure TList._AddAfter();
var
  NewItem: TListItem;
  SearchItem: string;
{$REGION 'вложенные функции для добавления'}
  procedure CLeanListItemsStates;
  var
    temp, last: TListItem;
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
    TLogger.Log('=====Закончили добавление нового элемента в список=====');
    if Mode <> lmNormal then
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
  FNewItem := NewItem;
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

    TempItem.IsAddAfter := false;
    TempItem.IsLast := false;
    NewItem.IsLast := true;
    Pause();
    TLogger.Log('Увеличиваем счетчик числа элементов');
    inc(Count);
    // result := true
  End
  Else
  Begin
    TempItem.IsAddAfter := true;
    TLogger.Log('Формируем поля нового элемента');
    Pause();
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

procedure TList._AddBefore();
var
  NewItem: TListItem;
  SearchItem: string;
{$REGION 'вложенные функции для добавления'}
  procedure CLeanListItemsStates;
  var
    temp, last: TListItem;
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
    TLogger.Log('=====Закончили добавление нового элемента в список=====');
    if Mode <> lmNormal then
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

  TLogger.Log('=====Добавление нового элемента в список=====');
  TLogger.Log('1.	Поиск заданного элемента ');
  FNewItem := NewItem;
  FTempItem := Search(SearchItem);
  If TempItem = nil then
  begin
    TLogger.Log('•	Искомый элемент не найден');
    // result := false;
    FuncEnd();
  end;
  If TempItem.GetPrev = nil then
  begin
    TempItem.IsAddBefore := true;
    TLogger.Log
      ('Адресное поле prev у найденного = null. Добавляем перед первым.');
    NewItem.SetPrev(nil);
    Pause();
    TLogger.Log
      ('В адресное поле "Prev" для найденного элемента записываем ссылку нового');
    TempItem.SetPrev(NewItem);
    Pause();
    TLogger.Log
      ('В адресное поле "Next" для нового элемента записываем ссылку найденнлшл элемента "Temp" ');
    NewItem.SetNext(TempItem);
    TLogger.Log('Изменяем указатель "First"');
    First := NewItem;

    // TempItem.IsAddBefore := false;
    // TempItem.IsLast := false;
    Pause();
    TLogger.Log('Увеличиваем счетчик числа элементов');
    inc(Count);
    // result := true
  End
  Else
  Begin
    TempItem.IsAddBefore := true;
    TLogger.Log('2.	Формируем поля нового элемента, в частности: ');
    Pause();
    TLogger.Log('•	в поле next заносится адрес заданного элемента');
    NewItem.SetNext(TempItem);
    Pause();
    TLogger.Log
      ('•	в поле prev заносится адрес предшествующего элемента (берется из поля prev найденного элемента)');
    NewItem.SetPrev(TempItem.GetPrev);
    Pause();
    TLogger.Log
      ('3.	Изменяем адресное поле prev у заданного элемента на адрес нового элемента');
    TempItem.SetPrev(NewItem);
    Pause();
    TLogger.Log
      ('4.	Изменяем адресное поле next у предшествующего элемента на адрес нового элемента');
    NewItem.GetPrev.SetNext(NewItem);
    TLogger.Log('5.	Увеличиваем количество элементов');
    inc(Count)
  End;
  FuncEnd();
end;

Function TList._Delete(): boolean;
// var
// temp: TListItem;
{$REGION 'вложенные функции для удаления'}
  procedure CLeanListItemsStates;
  var
    temp, last: TListItem;
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
    TLogger.Log('=====Элемент удален из списка=====');
    CritSec.Leave;
    EndThread(0);
    exit;
  end;
{$ENDREGION}

begin
  CritSec.Enter;
  TLogger.Log('=====Удаление элемента из списка=====');
  TLogger.Log('1. Проверка наличия элементов в списке');
  TLogger.Log('   count= ' + IntToStr(Count));
  result := false;
  if Count = 0 then
    FuncEnd;

  TLogger.Log('2. Поиск заданного элемента');
  FTempItem := Search(_SearchItem);
  If TempItem = nil then
  begin
    TLogger.Log('Искомый элемент не найден');
    // result := false;
    FuncEnd();
  end;
  TLogger.Log('Искомый элемент найден, адресуем его указателем pTemp');

  FTempItem.IsDelete := true;
  FDeleteItem := FTempItem;

  If FTempItem = First then
  begin
    // удаление единственного эл.
    If First.GetNext = nil then
    begin
      TLogger.Log('=====Удаление единственного элемента из списка=====');
      result := true;
      TLogger.Log('Указатель First адресуем в nil');
      First := nil;
      Pause();
      TLogger.Log('Уменьшаем количество элементов');
      Count := 0;
      FuncEnd;
    End
    else
    begin
      // удаление первого эл.
      TLogger.Log('=====Удаление первого элемента из списка=====');
      TLogger.Log
        ('3. Изменяем адресное поле Prev у элемента следующего после удаляемого');
      First.GetNext.SetPrev(nil);
      Pause();
      TLogger.Log
        ('4. Указатель First адресуем в следующий за удаляемым элементом');
      First := FTempItem.GetNext;
      CLeanListItemsStates;
      Pause();
      TLogger.Log('5. Уменьшаем количество элементов');
      Count := Count - 1;
      result := true;
      TLogger.Log('6. Обрабатываем удаляемый элемент');
      FTempItem := nil;
      FuncEnd;
    end;
  End;
  // удаление из середины списка
  if FTempItem.GetNext <> nil then
    TLogger.Log('=====Удаление элемента из середины списка=====')
  else
    TLogger.Log('=====Удаление элемента из конца списка=====');

  TLogger.Log
    ('3. Изменяем адресное поле next у элемента, предшествующего удаляемому на адрес элемента, следующего за удаляемым');
  TempItem.GetPrev.SetNext(FTempItem.GetNext);
  Pause();
  if FTempItem.GetNext <> nil then
  begin
    TLogger.Log
      ('4. Изменяем адресное поле prev у следующего за удаляемым элемента на адрес элемента, предшествующего удаляемому');
    FTempItem.GetNext.SetPrev(FTempItem.GetPrev);
  end;
  Pause();
  TLogger.Log('5. Обрабатываем удаляемый элемент');
  FTempItem := nil;
  Pause();
  Count := Count - 1;
  result := true;
  FuncEnd;
end;

Function TList.Search(SearchItem: string): TListItem;
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
      TLogger.Log('Переходим к следующему');
      Pause();
    end;
end;

procedure TList.Pause();
begin
  case Mode of
    lmControl:
      begin
        GenericMyEvent;
        SuspendThread(ThreadId);
      end;
    lmNormal:
      ;
    lmDemo:
      ;
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
