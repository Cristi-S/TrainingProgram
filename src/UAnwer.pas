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
    Button1: TButton;
    procedure Load();
  private
    { Private declarations }
  public
    { Public declarations }
    rIndex: integer; // номер RadioButton с правильным ответом
  end;

var
  FormAnswer: TFormAnswer;

implementation

uses UMain;

{$R *.dfm}

procedure TFormAnswer.Load();
var
  I, index, j: integer;
  UniqueAnswer: TList<integer>;
  // вспомогательный список для хранения уникальных индекссов ответов
begin
  Randomize;
  UniqueAnswer := TList<integer>.Create;
  UniqueAnswer.Add(List.QuestionKey);
  case List.State of
    lsAddbefore:
      begin
        //
      end;
    lsAddAfter:
      begin
        rIndex := Random(3) + 1; // слуйчайное число от 1 до 4
        // записываем в RadioButton один из вариантов ответа
        TRadioButton(FindComponent('RadioButton' + IntToStr(rIndex))).Caption :=
          _hashAddBefore.Items[List.QuestionKey];
        for I := 1 to 4 do
          if I <> rIndex then
          begin
            // генерируем случайные ключ ответа, пока не найдем уникальный
            repeat
              index := Random(UQuestions._hashAddBefore.Count) + 1;
            until not UniqueAnswer.Contains(index);
            UniqueAnswer.Add(index);

            TRadioButton(FindComponent('RadioButton' + IntToStr(I))).Caption :=
              _hashAddBefore.Items[index];
          end;
      end;
    lsDelete:
      begin

      end;
  end;
end;

end.
