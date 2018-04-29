unit UQuestions;

// модуль для хранения все возможных вариантов ответов
interface

uses
  System.Generics.Collections;

var
  _hashAdd: TDictionary<integer, string>;
  _hashDelete: TDictionary<integer, string>;

procedure QuestionsInitialize();

implementation

procedure QuestionsInitialize();
begin
  _hashAdd := TDictionary<integer, string>.Create();
  _hashDelete := TDictionary<integer, string>.Create();

  _hashAdd.Add(1, 'Добавление ключа ');
  _hashAdd.Add(2, 'Проверка списка на пустоту');
  _hashAdd.Add(3, 'Выделение памяти для нового элемента');
  _hashAdd.Add(4, 'Заполнение информационного поля: ');
  _hashAdd.Add(5, 'Поиск элемента с ключом ');
  _hashAdd.Add(6, 'Заполнение информационного поля:');
  _hashAdd.Add(7, 'Заполнение поля ссылки на правого соседа');
  _hashAdd.Add(8, 'Заполнение поля ссылки на левого соседа');
  _hashAdd.Add(9, 'Изменение левой ссылки у правого соседа');
  _hashAdd.Add(10, 'Изменение правой ссылки у левого соседа');
end;

end.
