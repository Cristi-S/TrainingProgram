unit UnitTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SyncObjs;

type
  TForm3 = class(TForm)
    Memo1: TMemo;
    ButtonCreate: TButton;
    ButtonResume: TButton;
    Button1: TButton;
    Button2: TButton;
    procedure ButtonResumeClick(Sender: TObject);
    procedure ButtonCreateClick(Sender: TObject);
    // procedure Cycle(Parameter: Pointer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  param = record
    i: Integer;
    s: string;
  end;

  // класс для работы с потоком
  TestThread = class(TThread)
  protected
    procedure Execute; override;
    procedure DoTerminate; override;
    procedure UpdateCaption;
  end;

var
  Form3: TForm3;
  test: TestThread; // переменная - ссылко на сам поток

  CritSec: TCriticalSection; // объект критической секции
  tid: Integer;

implementation

{$R *.dfm}
  ThreadVar // We must allow each thread its own instances
// of the passed record variable
  pa: ^param;
{$REGION 'Пример реализации с ипользованием стандартного класса TThread'}

// какая-то процедура которая будет вызываться в потоке
procedure TestThread.UpdateCaption;
begin
  Form3.Caption := 'Updated in a thread' + IntToStr(Random(10));
end;

// создаем поток
procedure TestThread.Execute;
begin
  // Synchronize нужен для корректной работы с графикой.
  Synchronize(UpdateCaption);
  // Suspend - приостанавливает поток. ждёмс..
  Suspend;
  // а когда возобновим работу то еще раз вызовем еще раз эту же функцию
  Synchronize(UpdateCaption);
end;

// процедура события OnTerminate
// вызовется когда поток закончит свою работу
procedure TestThread.DoTerminate;
begin
  ShowMessage('закончили');
end;

procedure TForm3.ButtonCreateClick(Sender: TObject);
begin
  test := TestThread.Create(false);
end;

// обработчик кнопки resume(возобновить)
procedure TForm3.ButtonResumeClick(Sender: TObject);
begin
  test.Resume;
end;
{$ENDREGION}
{$REGION 'пример реализации с использованием BeginThread'}

procedure Cycle(Parameter: Pointer);
var
  i: Integer;
  str: string;
  cnt: Integer;
begin
  CritSec.Enter;

  pa := Parameter;

  str := pa.s;
  cnt := pa.i;

  for i := 1 to 10 do
  begin
    // почему-то обазятально нужно указывать форму...
    Form3.Memo1.Lines.Add(IntToStr(i) + ' some message');
    SuspendThread(tid);
  end;
  CritSec.Leave;
  EndThread(0);
end;

// обработчик кнопки create
procedure TForm3.Button1Click(Sender: TObject);
var
  id: longword;
  pa: param;
begin
  pa.i := 10;
  pa.s := 'ttt';
  tid := BeginThread(nil, 0, @Cycle, @pa, 0, id);
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  ResumeThread(tid);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  CritSec := TCriticalSection.Create;
end;
{$ENDREGION}

end.
