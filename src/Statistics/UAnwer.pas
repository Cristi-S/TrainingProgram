unit UAnwer;

// модуль генерирующий вопросы, с проверкой ответов на них.
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Generics.Collections, UQuestions,
  UList, UEnum;

type
  TFormAnswer = class(TForm)
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    ButtonOk: TButton;
    procedure Load();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAnswer: TFormAnswer;
  rIndex: integer; // номер RadioButton с правильным ответом
  QuestionsCount, CorrectQuestionsCount: integer;
  // количество вопросов и верных ответов
  FirstName, LastName, MiddleName, Group: string;

implementation

uses UMain, UResult, UListItem;

{$R *.dfm}

// загружает на форму вопросы в зависимости от типа операции: добавление/удаление
procedure TFormAnswer.Load();
var
  i, hashKey: integer;
  exclusiveKey: integer; // кобч - исключение  не попадет в перечень вопросов
  // вспомогательный список для хранения уникальных индекссов ответов
  UniqueAnswer: TList<integer>;
  QuestionsString: string;
  // функия для сборки строки вопроса, принимает 2 параметра:
  // hashKey - ключ из хэша с вопросам
  // возвращает вариант ответа со случайным номером вершины
  function StringBuild(ihashKey: integer): string;
  var
    RandomListItem: integer;
    temp: TMyListItem;
  begin
    RandomListItem := -1;
    if i = rIndex then
    begin
      // в зависимости от текущей операции брать нужно правильный ключ!!!
      if Assigned(List.NewItem) then
        RandomListItem := List.NewItem.GetInfo.ToInteger;
    end
    else
    begin
      temp := List.GetItem(Random(List.Getcount) + 1);
      if temp <> nil then
        RandomListItem := temp.GetInfo.ToInteger;
    end;

    // заменяем в строке символы подстаовки на значения ключей
    if _hashAdd.Items[ihashKey].Contains(':x') then
      result := StringReplace(_hashAdd.Items[ihashKey], ':x',
        RandomListItem.ToString, [rfReplaceAll, rfIgnoreCase])
    else
      result := _hashAdd.Items[ihashKey];
  end;

begin
  Randomize;
  UniqueAnswer := TList<integer>.Create;
  UniqueAnswer.Add(List.QuestionKey);

  exclusiveKey := 0;
  if List.QuestionKey = 7 then
    exclusiveKey := 8;
  if List.QuestionKey = 8 then
    exclusiveKey := 7;

  case List.State of
    lsAddAfter, lsAddbefore:
      begin
        rIndex := Random(3) + 1; // слуйчайное число от 1 до 4
        // записываем в RadioButton один из вариантов ответа
        // TRadioButton(FindComponent('RadioButton' + IntToStr(rIndex))).Caption :=
        // _hashAdd.Items[List.QuestionKey];
        for i := 1 to 4 do
        begin
          if i <> rIndex then
          begin
            // генерируем случайные ключ ответа, пока не найдем уникальный
            repeat
              hashKey := Random(UQuestions._hashAdd.Count) + 1;
            until not UniqueAnswer.Contains(hashKey) and
              (exclusiveKey <> hashKey);
            UniqueAnswer.Add(hashKey);
          end
          else
            hashKey := List.QuestionKey;

          QuestionsString := StringBuild(hashKey);
          TRadioButton(FindComponent('RadioButton' + IntToStr(i))).Caption :=
            QuestionsString;
          // _hashAdd.Items[hashKey];
        end;
      end;
    lsDelete:
      begin
        begin
          rIndex := Random(3) + 1; // слуйчайное число от 1 до 4
          // записываем в RadioButton один из вариантов ответа
          TRadioButton(FindComponent('RadioButton' + IntToStr(rIndex))).Caption
            := _hashDelete.Items[List.QuestionKey];
          for i := 1 to 4 do
            if i <> rIndex then
            begin
              // генерируем случайные ключ ответа, пока не найдем уникальный
              repeat
                hashKey := Random(UQuestions._hashDelete.Count) + 1;
              until not UniqueAnswer.Contains(hashKey);
              UniqueAnswer.Add(hashKey);

              TRadioButton(FindComponent('RadioButton' + IntToStr(i))).Caption
                := _hashDelete.Items[hashKey];
            end;
        end;
      end;
  end;
end;

// проверка ответа пользователя
procedure TFormAnswer.ButtonOkClick(Sender: TObject);
var
  i, cheked: integer;
  correct: boolean;
  sCorrect: string;
begin
  Inc(QuestionsCount);
  case List.State of
    lsAddbefore, lsAddAfter, lsDelete:
      // if List.QuestionKey > 1 then // пропускаем первый шаг
      begin
        for i := 1 to 4 do
          if (TRadioButton(FindComponent('RadioButton' + IntToStr(i))).Checked)
          then
          begin
            if rIndex = i then
            begin
              Inc(CorrectQuestionsCount);
              correct := true;
            end;
            cheked := i;
          end;
        if not correct then
          FormMain.Memo1.Lines.Add('ОШИБКА! Правильный ответ: ');
      end;
  end;

  FormResult.Memo2.Lines.Add('Вопрос: ' + QuestionsCount.ToString);
  FormResult.Memo2.Lines.Add('Какой следующий шаг алгоритма?');

  for i := 1 to 4 do
    FormResult.Memo2.Lines.Add('-' + i.ToString + '-' +
      TRadioButton(FindComponent('RadioButton' + IntToStr(i))).Caption);

  if correct then
    sCorrect := 'ВЕРНО'
  else
    sCorrect := 'НЕВЕРНО';

  FormResult.Memo2.Lines.Add('Тестируемый ответил ' + cheked.ToString + ' - ' +
    sCorrect);
  FormResult.Memo2.Lines.Add('====================================');
  Close;
end;

// закрытие окна
procedure TFormAnswer.FormClose(Sender: TObject; var Action: TCloseAction);
var
  isChecked: boolean;
  i: integer;
begin
  // если не выбран ни один чекбокс, то окно не закрываем
  for i := 1 to 4 do
    if (TRadioButton(FindComponent('RadioButton' + IntToStr(i))).Checked) then
    begin
      isChecked := true;
      Break;
    end;
  if not isChecked then
    Action := caNone
  else
  begin
    // очистка формы
    for i := 1 to 4 do
    begin
      TRadioButton(FindComponent('RadioButton' + IntToStr(i))).Checked := False;
      TRadioButton(FindComponent('RadioButton' + IntToStr(i))).Caption := '';
    end;
  end;
end;

end.
