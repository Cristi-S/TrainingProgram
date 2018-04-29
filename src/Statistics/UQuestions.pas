unit UQuestions;

// ������ ��� �������� ��� ��������� ��������� �������
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

  _hashAdd.Add(1, '���������� ����� ');
  _hashAdd.Add(2, '�������� ������ �� �������');
  _hashAdd.Add(3, '��������� ������ ��� ������ ��������');
  _hashAdd.Add(4, '���������� ��������������� ����: ');
  _hashAdd.Add(5, '����� �������� � ������ ');
  _hashAdd.Add(6, '���������� ��������������� ����:');
  _hashAdd.Add(7, '���������� ���� ������ �� ������� ������');
  _hashAdd.Add(8, '���������� ���� ������ �� ������ ������');
  _hashAdd.Add(9, '��������� ����� ������ � ������� ������');
  _hashAdd.Add(10, '��������� ������ ������ � ������ ������');
end;

end.
