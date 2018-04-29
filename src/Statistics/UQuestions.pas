unit UQuestions;

interface

uses
  System.Generics.Collections;

var
  _hashAddBefore: TDictionary<integer, string>;
  _hashAddAfter: TDictionary<integer, string>;
  _hashDelete: TDictionary<integer, string>;

procedure QuestionsInitialize();

implementation

procedure QuestionsInitialize();
begin
  _hashAddBefore := TDictionary<integer, string>.Create();
  _hashAddAfter := TDictionary<integer, string>.Create();
  _hashDelete := TDictionary<integer, string>.Create();

  _hashAddBefore.Add(1, 'Добавление ключа ');
  _hashAddBefore.Add(2, 'Проверка списка на пустоту');
  _hashAddBefore.Add(3, 'Выделение памяти для нового элемента');
  _hashAddBefore.Add(4, 'Заполнение информационного поля: ');
  _hashAddBefore.Add(5, 'Поиск элемента с ключом ');
  _hashAddBefore.Add(6, 'Заполнение информационного поля:');
  _hashAddBefore.Add(7, 'Заполнение поля ссылки на правого соседа');
  _hashAddBefore.Add(8, 'Заполнение поля ссылки на левого соседа');
  _hashAddBefore.Add(9, 'Изменение левой ссылки у правого соседа');
  _hashAddBefore.Add(10, 'Изменение правой ссылки у левого соседа');
end;

end.
