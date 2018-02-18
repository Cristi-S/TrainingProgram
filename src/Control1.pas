unit Control1;

interface

uses
  Winapi.Windows,System.SysUtils, System.Classes, Vcl.Controls, Vcl.Graphics, Vcl.StdCtrls;

type
  TControl1 = class(TGraphicControl)
  private
    { Private declarations }

  protected
    procedure Paint; override;
  public
    MinHeigth, x, y: integer;
    MinWidth: integer;
    TitleMain : String;
    TitleNext, TitlePrev : string;
    lable1,lable2,lable3  :TLabel;
    IsLast: boolean;
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TControl1]);
end;

constructor TControl1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
    Height:= 60;
    Width := 100;
    TitleNext:='Null';
    TitlePrev:='Null';
    IsLast:=false;
    Color:=clWhite;



    MinHeigth := 60;
    MinWidth:= 100;

    Parent:=  TWinControl(AOwner);

end;

procedure TControl1.Paint();
begin
  Canvas.Font.Size:=8;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsClear;
  Canvas.Brush.Color:=clWhite;
  Canvas.Pen.Color := clWhite;
  Canvas.Rectangle(0, 0, Width, Height);
  Canvas.Pen.Color := clBlack;
  Canvas.Rectangle(0, 0, MinWidth, MinHeigth);
  Canvas.Rectangle(0, round(MinHeigth*1/3), MinWidth, round(MinHeigth*1/3+1));
  Canvas.Rectangle(0, round(MinHeigth*2/3), MinWidth, round(MinHeigth*2/3+1));

  //возвращает ширину текста в пикселях с учетом гарнитуры шрифта
  x:=Canvas.TextWidth(TitleMain);
  y:=Canvas.TextHeight(TitleMain);

  //рисуем заголовок компонента
  Canvas.TextOut(Round((MinWidth-x)/2), Round((MinHeigth*1/3-y)/2), TitleMain);

  x:=Canvas.TextWidth(TitleNext);
  y:=Canvas.TextHeight(TitleNext);
  //рисуем поле ссылку на след элемент
  Canvas.TextOut(Round((MinWidth-x)/2), Round(MinHeigth*1/3+((MinHeigth*2/3-MinHeigth*1/3-y)/2)), TitleNext);

  x:=Canvas.TextWidth(TitlePrev);
  y:=Canvas.TextHeight(TitlePrev);
  //рисуем поле ссылку на след элемент
  Canvas.TextOut(Round((MinWidth-x)/2), Round(MinHeigth*2/3+((MinHeigth*3/3-MinHeigth*2/3-y)/2)), TitlePrev);


  if (not IsLast) then
  begin
    Canvas.Font.Size:=14;

    x:=Canvas.TextWidth('→');
    y:=Canvas.TextHeight('→');

    Width:=MinWidth+x;
    Canvas.TextOut(MinWidth+1, Round(MinHeigth*1/3+((MinHeigth*2/3-MinHeigth*1/3-y)/2)-5), '→');

    x:=Canvas.TextWidth('←');
    y:=Canvas.TextHeight('←');

    Canvas.TextOut(MinWidth+1, Round(MinHeigth*2/3+((MinHeigth*3/3-MinHeigth*2/3-y)/2)-5), '←');
  end;
end;
end.

