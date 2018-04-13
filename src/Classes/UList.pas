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

  // класс для работы с потоком
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
    TLogger.Log('=====Добавление нового эдемента в список=====');
    // добавление первого элемента в список
    If list.First = nil then
    begin
      TLogger.Log('добавление первого элемента в список');
      TLogger.Log('Указатель First адресуем с новый элемент');
      list.First := NewItem;
      Suspend;
      TLogger.Log('Увеличиваем счетчик числа элементов');
      inc(list.Count);
      result := True;
      exit;
    End;
    TLogger.Log('Поиск заданного элемента');
    // ищем элемент после которого добавлять
    Temp := list.Search(SearchItem);
    If Temp = nil then
    begin
      TLogger.Log('Искомый элемент не найден');
      result := False;
      exit;
    end;
    // добавление в конец
    If Temp.GetNext = nil then
    begin
      TLogger.Log('Адресное поле next у найденного = null. Добавляем в конец.');
      NewItem.SetNext(nil);
      Suspend;
      TLogger.Log
        ('В адресной поле "Prev" для нового элемента записываем ссылку на найденный элемент "Temp" ');
      NewItem.SetPrev(Temp);
      Suspend;
      TLogger.Log
        ('В адресной поле "Next" для найденного элемента записываем ссылку на новый элемент "New" ');
      Temp.SetNext(NewItem);
      Suspend;
      TLogger.Log('Увеличиваем счетчик числа элементов');
      inc(list.Count);
      result := True
    End
    Else
    // добавление в середину
    Begin
      TLogger.Log('Формируем поля нового элемента, в частности:');
      TLogger.Log
        ('в поле next заносится адрес следующего элемента (берется из поля next найденного элемента)');
      NewItem.SetNext(Temp.GetNext);
      Suspend;
      TLogger.Log
        ('в поле prev заносится адрес предшествующего элемента, которым является найденный элемент');
      NewItem.SetPrev(Temp);
      Suspend;
      TLogger.Log
        ('Изменяем адресное поле prev у элемента, который должен следовать за новым, на адрес нового элемента');
      NewItem.GetNext.SetPrev(NewItem);
      Suspend;
      TLogger.Log
        ('Изменяем адресное поле next у найденного элемента на адрес нового элемента');
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
  TLogger.Log('=====Добавление нового эдемента в список=====');
  // добавление первого элемента в список
  If list.First = nil then
  begin
    TLogger.Log('добавление первого элемента в список');
    TLogger.Log('Указатель First адресуем с новый элемент');
    list.First := NewItem;
    Suspend;
    TLogger.Log('Увеличиваем счетчик числа элементов');
    inc(list.Count);
    result := True;
    exit;
  End;
  TLogger.Log('Поиск заданного элемента');
  // ищем элемент после которого добавлять
  Temp := list.Search(SearchItem);
  If Temp = nil then
  begin
    TLogger.Log('Искомый элемент не найден');
    result := False;
    exit;
  end;
  // добавление в конец
  If Temp.GetNext = nil then
  begin
    TLogger.Log('Адресное поле next у найденного = null. Добавляем в конец.');
    NewItem.SetNext(nil);
    Suspend;
    TLogger.Log
      ('В адресной поле "Prev" для нового элемента записываем ссылку на найденный элемент "Temp" ');
    NewItem.SetPrev(Temp);
    Suspend;
    TLogger.Log
      ('В адресной поле "Next" для найденного элемента записываем ссылку на новый элемент "New" ');
    Temp.SetNext(NewItem);
    Suspend;
    TLogger.Log('Увеличиваем счетчик числа элементов');
    inc(list.Count);
    result := True
  End
  Else
  // добавление в середину
  Begin
    TLogger.Log('Формируем поля нового элемента, в частности:');
    TLogger.Log
      ('в поле next заносится адрес следующего элемента (берется из поля next найденного элемента)');
    NewItem.SetNext(Temp.GetNext);
    Suspend;
    TLogger.Log
      ('в поле prev заносится адрес предшествующего элемента, которым является найденный элемент');
    NewItem.SetPrev(Temp);
    Suspend;
    TLogger.Log
      ('Изменяем адресное поле prev у элемента, который должен следовать за новым, на адрес нового элемента');
    NewItem.GetNext.SetPrev(NewItem);
    Suspend;
    TLogger.Log
      ('Изменяем адресное поле next у найденного элемента на адрес нового элемента');
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
  TLogger.Log('=====астарожна, запускаю поток=====');
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
    // удаление единственного эл.
    If First.GetNext = nil then
    begin
      result := True;
      First := nil;
      Count := 0;
      exit;
    End;
    // удаление первого эл.
    First := Temp.GetNext;
    First.SetPrev(nil);
    Count := Count - 1;
    result := True;
    Temp := nil;
    exit;
  End;
  // удаление из середины списка
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
  TLogger.Log('Устанавливаем указатель temp в адрес первого элемента в списке');
  Temp := First;
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
      TLogger.Log('Переходим к следующему');
    end;
end;

end.
