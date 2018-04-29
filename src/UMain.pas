unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Control1, Vcl.ExtCtrls,
  UList, UListItem, UnitNewItem, Math, UAnwer, UQuestions, UEnum;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    ButtonCreate: TButton;
    Label1: TLabel;
    ScrollBox1: TScrollBox;
    FlowPanel1: TPanel;
    Memo1: TMemo;
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
    procedure ButtonCreateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure ButtonClearClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ButtonAddAfterClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
//    procedure RedrawPanel();
//    procedure UpdateButtonState(Sender: TObject = nil);
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
  Form1: TForm1;
  ListControl: TList<TListControl>;
  // ��������� ������
  List: TList;

implementation

{$R *.dfm}

uses Logger, URedrawing;

// ���������� ������� ThreadSyspended ��� ��������, ������������� ���� TList.
procedure TForm1.OnThreadSyspended(Sender: TObject);
begin
  if not(Sender is TList) then
    Exit;
  RedrawPanel;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  UpdateButtonState(Sender);
end;

// ��������� ������������ ������
procedure TForm1.ButtonCreateClick(Sender: TObject);
var
  ListItem: TListItem;
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

  if RadioButton1.Checked = true then
    for i := 0 to Count do
    begin
      if i = 0 then
      begin
        new := Random(80) + 20;
        ListItem := TListItem.Create(new.ToString);
        List.addAfter('item', ListItem);
        last := new;
        WaitForSingleObject(List.ThreadId, INFINITE);
      end
      else
      begin
        new := Random(80) + 20;
        ListItem := TListItem.Create(new.ToString);
        List.addAfter(last.ToString, ListItem);
        last := new;
        WaitForSingleObject(List.ThreadId, INFINITE);
      end;
    end;
  // �������������� ������
  RedrawPanel();
  // ���������� ��������� � ����� ����������
  Logger.Enabled := true;
  List.Mode := oldMode;
end;

// ��������
procedure TForm1.ButtonDeleteClick(Sender: TObject);
var
  SearchItem: string;
begin
  SearchItem := InputBox('��������',
    '������� �������, ������� ����� ������� :', 'item1');
  List.Delete(SearchItem);
end;

// ���������� ������� �������� � ������
procedure TForm1.ButtonAddClick(Sender: TObject);
var
  ListItem: TListItem;
  info: string;
begin
  Form2.ShowModal;
  info := Form2.Edit1.Text;
  ListItem := TListItem.Create(info);
  List.addAfter('', ListItem);
end;

// ������������� ������
procedure TForm1.ButtonNextClick(Sender: TObject);
var
  i: integer;
begin
  case List.Mode of
    omControl:
      begin
        case List.State of
          lsAddbefore, lsAddAfter:
            if List.QuestionKey > 1 then // ���������� ������ ���
            begin
              FormAnswer.Load;
              FormAnswer.ShowModal;
              if FormAnswer.ModalResult = mrOk then
              begin
                for i := 1 to 4 do
                  if (TRadioButton(FormAnswer.FindComponent('RadioButton' +
                    IntToStr(i))).Checked) then
                    if FormAnswer.rIndex = i then
                      ShowMessage('������ �����!')
                    else
                      ShowMessage('�������� �����!')
              end;
            end;
        end;
      end;
    omNormal:
      begin

      end;
    omDemo:
      begin

      end;
  end;
  List.NextStep;
end;

// ���������� �����
procedure TForm1.ButtonAddAfterClick(Sender: TObject);
var
  ListItem: TListItem;
  SearchItem: string;
  info: string;
begin
  if List.Getcount <> 0 then
    Form2.ShowModal;
  info := Form2.Edit1.Text;
  ListItem := TListItem.Create(info);
  SearchItem := InputBox('���������� ����� ���������',
    '������� �������, ����� �������� �������� ����� :', 'item1');
  List.addAfter(SearchItem, ListItem);
end;

// ���������� �����
procedure TForm1.ButtonAddBeforeClick(Sender: TObject);
var
  ListItem: TListItem;
  SearchItem: string;
  info: string;
begin
  if List.Getcount <> 0 then
    Form2.ShowModal;
  info := Form2.Edit1.Text;
  ListItem := TListItem.Create(info);
  SearchItem := InputBox('���������� ����� ��������',
    '������� �������, ����� ������� �������� ����� :', 'item1');
  List.AddBefore(SearchItem, ListItem);
end;

// ����� ��� ����� �����
procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  If not CharInSet(Key, ['0' .. '9', #8]) then
    Key := #0;
end;

// ���������� �������� �����
procedure TForm1.FormCreate(Sender: TObject);
begin
  List := TList.Create;
  // ��� OnThreadSyspended ��������� ����������� ������� ThreadSyspended.
  List.OnThreadSyspended := OnThreadSyspended;
  ListControl := TList<TListControl>.Create;
  QuestionsInitialize();
  UpdateButtonState;

  List.Mode := omControl;
  // List.Mode := omDemo;
end;

end.
