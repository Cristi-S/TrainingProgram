unit UAnwer;

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
  rIndex: integer; // ����� RadioButton � ���������� �������

implementation

uses UMain;

{$R *.dfm}

procedure TFormAnswer.Load();
var
  i, index: integer;
  UniqueAnswer: TList<integer>;
  // ��������������� ������ ��� �������� ���������� ��������� �������
begin
  Randomize;
  UniqueAnswer := TList<integer>.Create;
  UniqueAnswer.Add(List.QuestionKey);
  case List.State of
    lsAddAfter, lsAddbefore:
      begin
        rIndex := Random(3) + 1; // ���������� ����� �� 1 �� 4
        // ���������� � RadioButton ���� �� ��������� ������
        TRadioButton(FindComponent('RadioButton' + IntToStr(rIndex))).Caption :=
          _hashAdd.Items[List.QuestionKey];
        for i := 1 to 4 do
          if i <> rIndex then
          begin
            // ���������� ��������� ���� ������, ���� �� ������ ����������
            repeat
              index := Random(UQuestions._hashAdd.Count) + 1;
            until not UniqueAnswer.Contains(index);
            UniqueAnswer.Add(index);

            TRadioButton(FindComponent('RadioButton' + IntToStr(i))).Caption :=
              _hashAdd.Items[index];
          end;
      end;
    lsDelete:
      begin

      end;
  end;
end;

// �������� ������
procedure TFormAnswer.ButtonOkClick(Sender: TObject);
var
  i: integer;
begin
  case List.State of
    lsAddbefore, lsAddAfter:
      if List.QuestionKey > 1 then // ���������� ������ ���
      begin
        for i := 1 to 4 do
          if (TRadioButton(FindComponent('RadioButton' + IntToStr(i))).Checked)
          then
            if rIndex = i then
              ShowMessage('������ �����!')
            else
              ShowMessage
                ('�������� �����. ���������� ����� ������ � ���� ������')
      end;
  end;
  Close;
end;

// �������� ����
procedure TFormAnswer.FormClose(Sender: TObject; var Action: TCloseAction);
var
  isChecked: Boolean;
  i: integer;
begin
  // ���� �� ������ �� ���� �������, �� ���� �� ���������
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
    // ToDo: ���������� ������� �����
    for i := 1 to 4 do
    begin
      TRadioButton(FindComponent('RadioButton' + IntToStr(i))).Checked := False;
      TRadioButton(FindComponent('RadioButton' + IntToStr(i))).Caption := '';
    end;
  end;
end;

end.
