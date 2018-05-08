unit UnitStart;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UEnum, UMain, UAnwer;

type
  TFormStart = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditLastName: TEdit;
    EditFirstName: TEdit;
    EditMiddleName: TEdit;
    EditGroup: TEdit;
    ComboBox1: TComboBox;
    ButtonStart: TButton;
    procedure ButtonStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormStart: TFormStart;

implementation

{$R *.dfm}

procedure TFormStart.ButtonStartClick(Sender: TObject);
begin
  if (EditFirstName.Text = '') or (EditLastName.Text = '') or
    (EditMiddleName.Text = '') then
  begin
    ShowMessage('Заполните все поля');
    exit;
  end;

  FirstName := EditFirstName.Text;
  LastName := EditLastName.Text;
  MiddleName := EditMiddleName.Text;
  Group := EditGroup.Text;

  if ComboBox1.ItemIndex = 0 then
    ApplicationMode := omDemo;
  if ComboBox1.ItemIndex = 1 then
    ApplicationMode := omControl;

  if not Assigned(FormMain) then
    FormMain := TFormMain.Create(Self);
  FormMain.Show;

  hide;
end;

end.
