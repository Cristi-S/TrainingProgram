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
  _hashAdd.Add(11, '����������� ���������� ���������');
  _hashAdd.Add(12, '�������� ��������� First');

  _hashDelete.Add(1, '�������� ������� ��������� � ������');
  _hashDelete.Add(2, '����� ��������� ��������');
  _hashDelete.Add(3, '��������� First �������� � nil');
  _hashDelete.Add(4, '��������� ���������� ���������');
  _hashDelete.Add(5, '��������� ����� ������ � ������� ������');
  _hashDelete.Add(6,
    '��������� First �������� � ��������� �� ��������� ���������');
  _hashDelete.Add(7, '������������ ��������� �������');
  _hashDelete.Add(8, '��������� ������ ������ � ������ ������');
  _hashDelete.Add(9, '��������� ����� ������ � ������� ������');
end;

end.
