unit UList;

{ контейнер элементов списка.
  в завимости от режима работы Mode позволяет
  пошагово выполнять операции добавления и удаления элементов из списка,
  с выводом последовательности шагов в Memo
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
    // Поле ссылающееся на обработчик события MyEvent.
    // Тип TNotifyEvent описан в модуле Clases так: TNotifyEvent = procedure(Sender: TObject) of object;
    // Фраза  "of object" означает, что в качестве обработчика можно назначить только метод какого-либо
    // класса, а не произвольную процедуру.
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
    // Эта процедура проверяет задан ли обработчик события. И, если задан, запускает его.
    procedure DoMyEvent; dynamic;
    // Это свойство позволяет назначить обработчик для обработки события MyEvent.
    property OnThreadSyspended: TNotifyEvent read FOnThreadSuspended
      write FOnThreadSuspended;
    // Процедура, которая принимает решение - произошло событие MyEvent или нет.
    // Таких процедур может быть несколько - везде где может возникнуть событие MyEvent.
    // Если событие MyEvent произошло, то вызвается процедура DoMyEvent().
    procedure GenericMyEvent;
    property NewItem: TMyListItem read FNewItem;
    property TempItem: TMyListItem read FTempItem;
    property DeleteItem: TMyListItem read FDeleteItem;
    property SearchItem: TMyListItem read FSearchItem;
  End;

implementation

uses Logger;

var
  CritSec: TCriticalSection; // объект критической секции
  // переменные для хранения входных парамтеров в функцию добавления
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
{$REGION 'вложенные функции для добавления'}
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
    TLogger.Log('Добавление ключа ' + NewItem.GetInfo)
  else
    TLogger.Log('Добавление ключа ' + NewItem.GetInfo + ' после ключа ' +
      SearchItem);
  TLogger.EnableCouner;
  // добавление первого элемента
  If First = nil then
  begin
    QuestionKey := 2;
    Pause();
    TLogger.Log('Проверка списка на пустоту: список пуст');

    QuestionKey := 3;
    Pause();
    TLogger.Log('Выделение памяти для нового элемента');

    QuestionKey := 4;
    Pause();
    TLogger.Log('Заполнение информационного поля: ' + NewItem.GetInfo);

    QuestionKey := 12;
    Pause();
    TLogger.Log('Изменяем указатель First');

    First := NewItem;
    NewItem.IsFirst := true;
    NewItem.IsLast := true;

    QuestionKey := 11;
    Pause();
    TLogger.Log('Увеличиваем количество элементов');

    inc(Count);
    FuncEnd();
  End
  else
  // добавление в непустой список
  begin
    QuestionKey := 2;
    Pause();
    TLogger.Log('Проверка списка на пустоту: список содержит элементы');

    QuestionKey := 5;
    Pause();
    TLogger.Log('Поиск элемента с ключом ' + SearchItem);

    FNewItem := NewItem;
    FTempItem := Search(SearchItem);
    If TempItem = nil then
    begin
      TLogger.Append(' - искомый элемент не найден');
      FuncEnd();
    end;
    QuestionKey := 3;
    Pause();
    TLogger.Log('Выделение памяти для нового элемента');
    // добавлление в конец
    If TempItem.GetNext = nil then
    begin
      TempItem.IsAddAfter := true;

      QuestionKey := 4;
      Pause();
      TLogger.Log('Заполнение информационного поля:' + NewItem.GetInfo);

      NewItem.SetNext(nil);

      QuestionKey := 8;
      Pause();
      TLogger.Log('Заполнение поля ссылки на левого соседа');

      NewItem.SetPrev(TempItem);

      QuestionKey := 10;
      Pause();
      TLogger.Log('Изменение правой ссылки у левого соседа');

      TempItem.SetNext(NewItem);
      TempItem.IsAddAfter := false;
      TempItem.IsLast := false;
      NewItem.IsLast := true;

      QuestionKey := 11;
      Pause();
      TLogger.Log('Увеличиваем количество элементов');

      inc(Count);
    End
    Else
    Begin
      TempItem.IsAddAfter := true;
      QuestionKey := 7;
      Pause();
      TLogger.Log('Заполнение поля ссылки на правого соседа');

      NewItem.SetNext(TempItem.GetNext);

      QuestionKey := 8;
      Pause();
      TLogger.Log('Заполнение поля ссылки на левого соседа');
      NewItem.SetPrev(TempItem);

      QuestionKey := 9;
      Pause();
      TLogger.Log('Изменение левой ссылки у правого соседа');
      NewItem.GetNext.SetPrev(NewItem);

      QuestionKey := 10;
      Pause();
      TLogger.Log('Изменение правой ссылки у левого соседа');
      TempItem.SetNext(NewItem);

      QuestionKey := 11;
      Pause();
      TLogger.Log('Увеличиваем количество элементов');

      inc(Count)
    End;
  End;
  FuncEnd();
end;

procedure TList._AddBefore();
var
  NewItem: TMyListItem;
  SearchItem: string;
{$REGION 'вложенные функции для добавления'}
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

  TLogger.Log('Добавление ключа ' + NewItem.GetInfo + ' перед ключом ' +
    SearchItem);

  QuestionKey := 2;
  Pause();
  TLogger.EnableCouner;
  TLogger.Log('Проверка списка на пустоту: список содержит элементы');

  QuestionKey := 5;
  Pause();
  TLogger.Log('Поиск элемента с ключом ' + SearchItem);

  FNewItem := NewItem;
  FTempItem := Search(SearchItem);
  If TempItem = nil then
  begin
    TLogger.Append(' - искомый элемент не найден');
    FuncEnd();
  end;

  QuestionKey := 3;
  Pause();
  TLogger.Log('Выделение памяти для нового элемента');

  FSearchItem := FTempItem;
  If TempItem.GetPrev = nil then
  begin
    TempItem.IsAddBefore := true;

    QuestionKey := 4;
    Pause();
    TLogger.Log('Заполнение информационного поля:' + NewItem.GetInfo);

    NewItem.SetPrev(nil);

    QuestionKey := 9;
    Pause();
    TLogger.Log('Изменение левой ссылки у правого соседа');

    TempItem.SetPrev(NewItem);

    QuestionKey := 7;
    Pause();
    TLogger.Log('Заполнение поля ссылки на правого соседа');

    NewItem.SetNext(TempItem);

    QuestionKey := 11;
    Pause();
    TLogger.Log('Увеличиваем количество элементов');

    inc(Count);

    QuestionKey := 12;
    Pause();
    TLogger.Log('Изменяем указатель First');
    First := NewItem;
    FuncEnd();
  End
  Else
  Begin
    TempItem.IsAddBefore := true;

    QuestionKey := 7;
    Pause();
    TLogger.Log('Заполнение поля ссылки на правого соседа');

    NewItem.SetNext(TempItem);

    QuestionKey := 8;
    Pause();
    TLogger.Log('Заполнение поля ссылки на левого соседа');
    NewItem.SetPrev(TempItem.GetPrev);

    QuestionKey := 9;
    Pause();
    TLogger.Log('Изменение левой ссылки у правого соседа');
    TempItem.SetPrev(NewItem);

    QuestionKey := 10;
    Pause();
    TLogger.Log('Изменение правой ссылки у левого соседа');
    NewItem.GetPrev.SetNext(NewItem);

    QuestionKey := 11;
    Pause();
    TLogger.Log('Увеличиваем количество элементов');

    inc(Count)
  End;
  FuncEnd();
end;

Function TList._Delete(): boolean;
{$REGION 'вложенные функции для удаления'}
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

  TLogger.Log('Удаление элемента из списка');
  TLogger.EnableCouner;

  QuestionKey := 1;
  Pause();
  TLogger.Log('Проверка наличия элементов в списке: count= ' + IntToStr(Count));
  result := false;
  if Count = 0 then
    FuncEnd;

  QuestionKey := 2;
  Pause();
  TLogger.Log('Поиск заданного элемента');

  FTempItem := Search(_SearchItem);

  If TempItem = nil then
  begin
    TLogger.Log('Искомый элемент не найден');
    FuncEnd();
  end;

  FTempItem.IsDelete := true;
  FDeleteItem := FTempItem;

  If FTempItem = First then
  begin
    // удаление единственного эл.
    If First.GetNext = nil then
    begin
      result := true;
      QuestionKey := 2;
      Pause();
      TLogger.Log('Указатель First адресуем в nil');
      First := nil;

      QuestionKey := 4;
      Pause();
      TLogger.Log('Уменьшаем количество элементов');
      Count := 0;
      FuncEnd;
    End
    else
    begin
      QuestionKey := 5;
      Pause();
      TLogger.Log('Изменение левой ссылки у правого соседа');
      First.GetNext.SetPrev(nil);

      QuestionKey := 6;
      Pause();
      TLogger.Log
        ('Указатель First адресуем в следующий за удаляемым элементом');
      First := FTempItem.GetNext;
      CLeanListItemsStates;

      QuestionKey := 4;
      Pause();
      TLogger.Log('Уменьшаем количество элементов');
      Count := Count - 1;
      result := true;

      QuestionKey := 7;
      Pause();
      TLogger.Log('Обрабатываем удаляемый элемент');
      FTempItem := nil;
      FuncEnd;
    end;
  End;

  QuestionKey := 8;
  Pause();
  TLogger.Log('Изменение правой ссылки у левого соседа');
  TempItem.GetPrev.SetNext(FTempItem.GetNext);

  if FTempItem.GetNext <> nil then
  begin
    QuestionKey := 9;
    Pause();
    TLogger.Log('Изменение левой ссылки у правого соседа');
    FTempItem.GetNext.SetPrev(FTempItem.GetPrev);
  end;

  QuestionKey := 7;
  Pause();
  TLogger.Log('Обрабатываем удаляемый элемент');
  FTempItem := nil;

  QuestionKey := 4;
  Pause();
  TLogger.Log('Уменьшаем количество элементов');
  result := true;
  FuncEnd;
end;

Function TList.Search(SearchItem: string): TMyListItem;
var
  oldLogerState: boolean;
begin
  result := nil;
  FTempItem := First;
  // сохраняем старое состояние логгера
  oldLogerState := Logger.Enabled;
  // в режиме контрол - отключаем логгер
  if Mode = omControl then
    Logger.Enabled := false;
  while (FTempItem <> nil) do
  begin
    // в управляющем режиме вылючаем приостановку потока
    if Mode <> omControl then
      Pause();
    if (FTempItem.GetInfo = SearchItem) then
    begin
      TLogger.Log('Сравнение ключей ' + FTempItem.GetInfo + ' и ' + SearchItem +
        ' равны - нашли');
      result := FTempItem;
      break;
    end
    else
    begin
      TLogger.Log('Сравнение ключей ' + FTempItem.GetInfo + ' и ' + SearchItem +
        ' не равны - переход к следующему элементу');
      FTempItem := FTempItem.GetNext;
    end;
  end;
  Logger.Enabled := oldLogerState;
  if Mode = omControl then
    if Assigned(result) then
      if State in [lsAddbefore, lsAddAfter] then
        TLogger.Append(' - найдено место для вставки');
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
