unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Control1, Vcl.ExtCtrls,
  UList, UListItem, UnitNewItem, Math, UAnwer, UQuestions, UEnum, Vcl.ComCtrls;

type
  TFormMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    Panel3: TPanel;
    ButtonAddBefore: TButton;
    ButtonDelete: TButton;
    ButtonAddAfter: TButton;
    ButtonAdd: TButton;
    ButtonNext: TButton;
    Button1: TButton;
    Panel4: TPanel;
    ButtonCreate: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    ScrollBox1: TScrollBox;
    FlowPanel1: TPanel;
    StatusBar1: TStatusBar;
    procedure ButtonCreateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ButtonAddAfterClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonAddBeforeClick(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    // ���������� ������� MyEvent ��� ��������, ������������� ���� TMyClass.
    procedure OnThreadSyspended(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  ListControl: TList<TListControl>;
  // ��������� ������
  List: TList;

implementation

{$R *.dfm}

uses Logger, UDriver;

// ���������� ������� ThreadSyspended  - ����� ���������� �����
procedure TFormMain.OnThreadSyspended(Sender: TObject);
begin
  if not(Sender is TList) then
    Exit;
  RedrawPanel;
end;

procedure TFormMain.RadioButton1Click(Sender: TObject);
begin
  UpdateButtonState(Sender);
end;

// ��������� ������������ ������
procedure TFormMain.ButtonCreateClick(Sender: TObject);
var
  ListItem: TMyListItem;
  i, Count: integer;
  new, last: integer;
  oldMode: TOperatingMode;
begin
  // ��������� ����� ��������� � ������� - ��� ���������� �������
  oldMode := List.Mode;
  List.Mode := omNormal;
  // ��������� ������������
  Logger.Enabled := false;

  Randomize;

  Count := Min(3, StrToInt(Edit1.Text) - 1);

  for i := 0 to Count do
  begin
    if i = 0 then
    begin
      new := Random(80) + 20;
      ListItem := TMyListItem.Create(new.ToString);
      List.addAfter('item', ListItem);
      last := new;
      // ���� ��������� ������
      WaitForSingleObject(List.ThreadId, INFINITE);
    end
    else
    begin
      new := Random(80) + 20;
      ListItem := TMyListItem.Create(new.ToString);
      List.addAfter(last.ToString, ListItem);
      last := new;
      // ���� ��������� ������
      WaitForSingleObject(List.ThreadId, INFINITE);
    end;
  end;

  // ���������� ��������� � ����� ����������
  Logger.Enabled := true;
  List.Mode := oldMode;
  // �������������� ������
  RedrawPanel();
end;

// ��������
procedure TFormMain.ButtonDeleteClick(Sender: TObject);
var
  SearchItem: string;
begin
  SearchItem := InputBox('��������',
    '������� �������, ������� ����� ������� :', 'item1');
  List.Delete(SearchItem);
end;

// ���������� ������� �������� � ������
procedure TFormMain.ButtonAddClick(Sender: TObject);
var
  ListItem: TMyListItem;
  info: string;
begin
  Form2.ShowModal;
  info := Form2.Edit1.Text;
  ListItem := TMyListItem.Create(info);
  List.addAfter('', ListItem);
end;

// ������������� ������
procedure TFormMain.ButtonNextClick(Sender: TObject);
begin
  case List.Mode of
    omControl:
      begin
        FormAnswer.Load;
        FormAnswer.ShowModal;
      end;
  end;
  List.NextStep;
end;

// ���������� �����
procedure TFormMain.ButtonAddAfterClick(Sender: TObject);
var
  ListItem: TMyListItem;
  SearchItem: string;
  info: string;
begin
  if List.Getcount <> 0 then
    Form2.ShowModal;
  info := Form2.Edit1.Text;
  ListItem := TMyListItem.Create(info);
  SearchItem := InputBox('���������� ����� ���������',
    '������� �������, ����� �������� �������� ����� :', 'item1');
  List.addAfter(SearchItem, ListItem);
end;

// ���������� �����
procedure TFormMain.ButtonAddBeforeClick(Sender: TObject);
var
  ListItem: TMyListItem;
  SearchItem: string;
  info: string;
begin
  if List.Getcount <> 0 then
    Form2.ShowModal;
  info := Form2.Edit1.Text;
  ListItem := TMyListItem.Create(info);
  SearchItem := InputBox('���������� ����� ��������',
    '������� �������, ����� ������� �������� ����� :', 'item1');
  List.AddBefore(SearchItem, ListItem);
end;

// ����� ��� ����� �����
procedure TFormMain.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  If not CharInSet(Key, ['0' .. '9', #8]) then
    Key := #0;
end;

// ���������� �������� �����
procedure TFormMain.FormCreate(Sender: TObject);
begin
  List := TList.Create;
  // ������������� �� ������� ThreadSyspended
  List.OnThreadSyspended := OnThreadSyspended;
  ListControl := TList<TListControl>.Create;
  QuestionsInitialize();
  UpdateButtonState;

  List.Mode := omControl;
  // List.Mode := omDemo;
end;

end.
