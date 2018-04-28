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

  _hashAddBefore.Add(1, '���������� ����� ');
  _hashAddBefore.Add(2, '�������� ������ �� �������');
  _hashAddBefore.Add(3, '��������� ������ ��� ������ ��������');
  _hashAddBefore.Add(4, '���������� ��������������� ����: ');
  _hashAddBefore.Add(5, '����� �������� � ������ ');
  _hashAddBefore.Add(6, '���������� ��������������� ����:');
  _hashAddBefore.Add(7, '���������� ���� ������ �� ������� ������');
  _hashAddBefore.Add(8, '���������� ���� ������ �� ������ ������');
  _hashAddBefore.Add(9, '��������� ����� ������ � ������� ������');
  _hashAddBefore.Add(10, '��������� ������ ������ � ������ ������');
end;

end.
