unit Control1;

interface

uses
  Winapi.Windows, System.SysUtils, System.Types, System.Classes, Vcl.Controls,
  Vcl.Graphics,
  Vcl.StdCtrls, Math;

type
  TControl1 = class(TGraphicControl)
  const
    FirstWidth = 80; // ширина элемента First
    FirstHeight = 40; // высота элемента First
    ArrowWidth = 50; // стандартная длина стрелочки
    ItemHeigth = 60; // высота элемента
    ItemWidth = 100; // ширина элемента
  private
    { Private declarations }
    ItemTop, ItemLeft: integer;
    _IsFirst: boolean;
    _IsLast: boolean;
    _IsAddBefore: boolean;
    _IsAddAfter: boolean;

    procedure SetPaddings;
    procedure SetIsFirst(const Value: boolean);
    procedure SetIsLast(const Value: boolean);
    procedure SetIsAddBefore(const Value: boolean);
    procedure SetIsAddAfter(const Value: boolean);
  protected
    procedure Paint; override;
  public
    x, y: integer;
    TitleMain: String;
    TitleNext, TitlePrev: string;

    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property IsFirst: boolean read _IsFirst write SetIsFirst;
    property IsLast: boolean read _IsLast write SetIsLast;
    property IsAddBefore: boolean read _IsAddBefore write SetIsAddBefore;
    property IsAddAfter: boolean read _IsAddAfter write SetIsAddAfter;
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

  ItemTop := 50;
  ItemLeft := 0;

  Height := ItemTop + ItemHeigth;
  Width := ItemLeft + ItemWidth;
  TitleMain := 'Null';
  TitleNext := 'Null';
  TitlePrev := 'Null';
  IsLast := false;
  Color := clWhite;

  Parent := TWinControl(AOwner);
end;

procedure TControl1.SetPaddings;
begin
  if _IsFirst and _IsAddBefore then
  begin
    ItemLeft := ItemWidth + ArrowWidth;
    exit;
  end;

  if _IsAddBefore then
  begin
    ItemLeft := ItemWidth + ArrowWidth;
  end;

  if _IsFirst then
  begin
    ItemLeft := FirstWidth + 20;
  end;
end;

{$REGION 'Set- методы'}

procedure TControl1.SetIsFirst(const Value: boolean);
begin
  if Value <> _IsFirst then
  begin
    _IsFirst := Value;
    self.Refresh;
    SetPaddings();
  end;
end;

procedure TControl1.SetIsLast(const Value: boolean);
begin
  if Value <> _IsLast then
  begin
    _IsLast := Value;
    self.Refresh;
    SetPaddings();
  end;
end;

procedure TControl1.SetIsAddBefore(const Value: boolean);
begin
  if Value <> _IsAddBefore then
  begin
    _IsAddBefore := Value;
    self.Refresh;
    SetPaddings();
  end;
end;

procedure TControl1.SetIsAddAfter(const Value: boolean);
begin
  if Value <> _IsAddAfter then
  begin
    _IsAddAfter := Value;
    self.Refresh;
    SetPaddings();
  end;
end;

{$ENDREGION}
{$REGION 'рисование стрелок'}

// взято на просторах интеренета, говорят что это рисует стрелочку
procedure DrawArrowHead(Canvas: TCanvas; x, y: integer; Angle, LW: Extended);
var
  A1, A2: Extended;
  Arrow: array [0 .. 3] of TPoint;
  OldWidth: integer;
  OldBrush: TBrush;
const
  Beta = 0.322;
  LineLen = 4.74;
  CentLen = 3;
begin
  Angle := Pi + Angle;
  Arrow[0] := Point(x, y);
  A1 := Angle - Beta;
  A2 := Angle + Beta;
  Arrow[1] := Point(x + Round(LineLen * LW * Cos(A1)),
    y - Round(LineLen * LW * Sin(A1)));
  Arrow[2] := Point(x + Round(CentLen * LW * Cos(Angle)),
    y - Round(CentLen * LW * Sin(Angle)));
  Arrow[3] := Point(x + Round(LineLen * LW * Cos(A2)),
    y - Round(LineLen * LW * Sin(A2)));

  OldWidth := Canvas.Pen.Width;
  // OldBrush := Canvas.Brush;

  Canvas.Pen.Width := 1;
  Canvas.Brush.Color := clBlack;
  Canvas.Polygon(Arrow);

  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Width := OldWidth;
  // Canvas.Brush := OldBrush;
end;

procedure DrawArrow(Canvas: TCanvas; X1, Y1, X2, Y2: integer; LW: Extended = 3);
var
  Angle: Extended;
  OldWidth: integer;
begin
  OldWidth := Canvas.Pen.Width;
  Canvas.Pen.Width := 2;
  Canvas.Pen.Style := psDot;
  Angle := ArcTan2(Y1 - Y2, X2 - X1);
  Canvas.MoveTo(X1, Y1);
  Canvas.LineTo(X2 - Round(2 * LW * Cos(Angle)),
    Y2 + Round(2 * LW * Sin(Angle)));
  Canvas.Pen.Width := OldWidth;
  Canvas.Pen.Style := psSolid;
  DrawArrowHead(Canvas, X2, Y2, Angle, LW);
end;

Procedure DrawListItem(Canvas: TCanvas; p: TPoint; Width, Height: integer;
  TitleMain, TitleNext, TitlePrev: string; var points: Array Of TPoint);
var
  x, y: integer;
begin
  Canvas.Rectangle(p.x, p.y, p.x + Width, p.y + Height);
  Canvas.Pen.Color := clBlack;
  Canvas.Rectangle(p.x, p.y, p.x + Width, p.y + Height);
  Canvas.Rectangle(p.x, p.y + Round(Height * 1 / 3), p.x + Width,
    p.y + Round(Height * 1 / 3 + 1));
  Canvas.Rectangle(p.x, p.y + Round(Height * 2 / 3), p.x + Width,
    p.y + Round(Height * 2 / 3 + 1));

  // возвращает ширину текста в пикселях с учетом гарнитуры шрифта
  x := Canvas.TextWidth(TitleMain);
  y := Canvas.TextHeight(TitleMain);

  // рисуем заголовок компонента
  Canvas.TextOut(p.x + Round((Width - x) / 2),
    p.y + Round((Height * 1 / 3 - y) / 2), TitleMain);

  x := Canvas.TextWidth(TitleNext);
  y := Canvas.TextHeight(TitleNext);
  // рисуем поле ссылку на след элемент
  Canvas.TextOut(p.x + Round((Width - x) / 2),
    p.y + Round(Height * 1 / 3 + ((Height * 2 / 3 - Height * 1 / 3 - y) / 2)),
    TitleNext);

  x := Canvas.TextWidth(TitlePrev);
  y := Canvas.TextHeight(TitlePrev);
  // рисуем поле ссылку на след элемент
  Canvas.TextOut(p.x + Round((Width - x) / 2),
    p.y + Round(Height * 2 / 3 + ((Height * 3 / 3 - Height * 2 / 3 - y) / 2)),
    TitlePrev);

  // вычислим координты откуда нужно будет присовать срелочки
  points[0] := Point(p.x,
    p.y + Round(Height * 1 / 3 + ((Height * 3 / 3 - Height * 2 / 3 - y)
    / 2)) + 7);
  points[1] := Point(p.x,
    p.y + Round(Height * 2 / 3 + ((Height * 2 / 3 - Height * 1 / 3 - y)
    / 2)) + 7);
  points[2] := Point(p.x + Width,
    p.y + Round(Height * 1 / 3 + ((Height * 3 / 3 - Height * 2 / 3 - y)
    / 2)) + 7);
  points[3] := Point(p.x + Width,
    p.y + Round(Height * 2 / 3 + ((Height * 2 / 3 - Height * 1 / 3 - y)
    / 2)) + 7);
end;
{$ENDREGION}

procedure TControl1.Paint();
var
  // координаты для стрелочек, откуда они будут рисоваться
  //для каждого элемента - 4 координаты
  MainItemPoints: array [1 .. 4] of TPoint;
  LeftItemPoints: array [1 .. 4] of TPoint;
  RightItemPoints: array [1 .. 4] of TPoint;
  aHeight, aWidth: integer;
  p: TPoint; // произвольная коодината для облегчения жизни

begin
  aWidth := Width;
  aHeight := Height;
  Canvas.Font.Size := 8;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsClear;
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Color := clWhite;
  DrawListItem(Canvas, Point(ItemLeft, ItemTop), ItemWidth, ItemHeigth,
    TitleMain, TitleNext, TitlePrev, MainItemPoints);

  // рисуем стрелочки влево/вправо
  if (not IsLast) and (not IsAddAfter) then
  begin
    DrawArrow(Canvas, MainItemPoints[3].x, MainItemPoints[3].y,
      MainItemPoints[3].x + ArrowWidth, MainItemPoints[3].y);
    //
    DrawArrow(Canvas, MainItemPoints[4].x + ArrowWidth, MainItemPoints[4].y,
      MainItemPoints[4].x, MainItemPoints[4].y);

    aWidth := ItemLeft + ItemWidth + ArrowWidth;
  end;

  if IsFirst then
  begin
    aHeight := ItemTop + ItemHeigth * 2;

    Canvas.Font.Size := 8;
    Canvas.Brush.Color := clWhite;
    Canvas.Rectangle(0, 0, FirstWidth, FirstHeight);

    // возвращает ширину текста в пикселях с учетом гарнитуры шрифта
    x := Canvas.TextWidth('First');
    y := Canvas.TextHeight('First');

    // рисуем First
    Canvas.TextOut(0 + Round((FirstWidth - x) / 2),
      0 + Round((FirstHeight - y) / 2), 'First');
    Canvas.Pen.Width := 2;

    Canvas.MoveTo(0 + Round(FirstWidth / 2), FirstHeight);

    p := Point(0 + Round(FirstWidth / 2),
      ItemTop + Round(ItemHeigth * 1 / 3 + ((ItemHeigth * 2 / 3 - ItemHeigth * 1
      / 3 - y) / 2)));

    Canvas.LineTo(p.x, p.y);
    Canvas.Pen.Width := 1;
    DrawArrow(Canvas, p.x, p.y, ItemLeft, p.y);
  end;

  if IsAddBefore then
  begin
    DrawListItem(Canvas, Point(0, ItemTop + ItemHeigth), ItemWidth, ItemHeigth,
      TitleMain, TitleNext, TitlePrev, LeftItemPoints);

    // рисуем стрелочки по диогонали для левого элемента
    DrawArrow(Canvas, LeftItemPoints[3].x, LeftItemPoints[3].y,
      MainItemPoints[1].x, MainItemPoints[1].y);
    DrawArrow(Canvas, MainItemPoints[2].x, MainItemPoints[2].y,
      LeftItemPoints[4].x, LeftItemPoints[4].y);

    aWidth := ItemLeft + ItemWidth * 2 + ArrowWidth * 2;
    aHeight := ItemTop + ItemHeigth * 2;
  end;

  // ToDO: ввести понятие этап, для постедовательной отрисовки нужных стрелочек
  if IsAddAfter then
  begin
    // рисуем длинные стрелочки

    DrawArrow(Canvas, MainItemPoints[3].x, MainItemPoints[3].y,
      MainItemPoints[3].x + ItemWidth + ArrowWidth * 2, MainItemPoints[3].y);

    DrawArrow(Canvas, MainItemPoints[4].x + ItemWidth + ArrowWidth * 2,
      MainItemPoints[4].y, MainItemPoints[4].x, MainItemPoints[4].y);

    // рисуем сам контрол
    DrawListItem(Canvas, Point(ItemLeft + ItemWidth + ArrowWidth,
      ItemTop + ItemHeigth), ItemWidth, ItemHeigth, TitleMain, TitleNext,
      TitlePrev, RightItemPoints);

    // рисуем стрелочки по диогонали для правого элемента
    DrawArrow(Canvas, RightItemPoints[3].x, RightItemPoints[3].y,
      MainItemPoints[3].x + ArrowWidth + ItemWidth + ArrowWidth,
      MainItemPoints[3].y);

    DrawArrow(Canvas, MainItemPoints[4].x + ArrowWidth + ItemWidth + ArrowWidth,
      MainItemPoints[4].y, RightItemPoints[4].x, RightItemPoints[4].y);

    // рисуем стрелочки по диогонали для правого элемента
    DrawArrow(Canvas, MainItemPoints[3].x, MainItemPoints[3].y,
      RightItemPoints[1].x, RightItemPoints[1].y);

    DrawArrow(Canvas, RightItemPoints[2].x, RightItemPoints[2].y,
      MainItemPoints[4].x, MainItemPoints[4].y);

    aWidth := ItemLeft + ItemWidth * 2 + ArrowWidth * 2;
    aHeight := ItemTop + ItemHeigth * 2;
  end;

  Width := aWidth;
  Height := aHeight;
end;

end.
