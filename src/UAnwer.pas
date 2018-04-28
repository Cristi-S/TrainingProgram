unit UAnwer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, UQuestions,
  UList;

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
    rIndex: integer;
  end;

var
  FormAnswer: TFormAnswer;

implementation

uses UMain;

{$R *.dfm}

procedure TFormAnswer.Load();
var
  I, index, j: integer;
begin
  Randomize;

  case UMain.List.State of
    lsAddbefore:
      begin
        //
      end;
    lsAddAfter:
      begin
        rIndex := Random(3) + 1; // слуйчайное число от 1 до 4
        TRadioButton(FindComponent('RadioButton' + IntToStr(rIndex))).Caption :=
          _hashAddBefore.Items[List.QuestionKey];
        for I := 1 to 4 do
          if I <> rIndex then
          begin
            repeat
              index := Random(UQuestions._hashAddBefore.Count) + 1;
            until index <> rIndex;

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
