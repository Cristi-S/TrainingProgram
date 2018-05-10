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

  _hashDelete.Add(1, 'Проверка наличия элементов в списке');
  _hashDelete.Add(2, 'Поиск заданного элемента');
  _hashDelete.Add(3, 'Указатель First адресуем в nil');
  _hashDelete.Add(4, 'Уменьшаем количество элементов');
  _hashDelete.Add(5,
    'Изменяем адресное поле Prev у элемента следующего после удаляемого');
  _hashDelete.Add(6,
    'Указатель First адресуем в следующий за удаляемым элементом');
  _hashDelete.Add(7, 'Обрабатываем удаляемый элемент');
  _hashDelete.Add(8,
    'Изменяем адресное поле next у элемента, предшествующего удаляемому на адрес элемента, следующего за удаляемым');
  _hashDelete.Add(9,
    'Изменяем адресное поле prev у следующего за удаляемым элемента на адрес элемента, предшествующего удаляемому');
end;

end.
