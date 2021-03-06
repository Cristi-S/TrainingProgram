﻿unit Control1;

interface

uses
  Winapi.Windows, System.SysUtils, System.Types, System.Classes, Vcl.Controls,
  Vcl.Graphics,
  Vcl.StdCtrls, Math;

type
  TCross = record
    visible: boolean;
  end;

  TArrow = Record
    visible: boolean;
    color: TColor;
    cross: TCross;
    style: TPenStyle;
  end;

  TItem = Record
    visible: boolean;
    color: TColor;
    TitleMain: string;
    TitleNext: string;
    TitlePrev: string;

    ArrowLeft: TArrow;
    ArrowRight: TArrow;
    ArrowUpLeft: TArrow;
    ArrowUpRight: TArrow;
    ArrowDownLeft: TArrow;
    ArrowLongLeft: TArrow;
    ArrowDownRight: TArrow;
    ArrowLongRight: TArrow;
    ArrowRightPolygon: TArrow;
    ArrowLeftPolygon: TArrow;
    ArrowHeader: TArrow;
  End;

  TItemState = (normal, addAfter, addBefore, new);

  TListControl = class(TGraphicControl)
  const
    FirstWidth = 80; // ширина элемента First
    FirstHeight = 40; // высота элемента First
    ArrowWidth = 50; // стандартная длина стрелочки
    ArrowHeadWidth = 14; // ширина треугольника у стрелочки
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
    ItemMain: TItem;
    State: TItemState;
    constructor Create(AOwner: TComponent); override;
  published
    property IsFirst: boolean read _IsFirst write SetIsFirst;
    property IsLast: boolean read _IsLast write SetIsLast;
    property IsAddBefore: boolean read _IsAddBefore write SetIsAddBefore;
    property IsAddAfter: boolean read _IsAddAfter write SetIsAddAfter;
    property PaddingLeft: integer read ItemLeft write ItemLeft;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TListControl]);
end;

constructor TListControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ItemTop := 50;
  ItemLeft := 0;

  Height := ItemTop + ItemHeigth;
  Width := ItemLeft + ItemWidth;
  ItemMain.TitleMain := 'Null';
  ItemMain.TitleNext := 'Null';
  ItemMain.TitlePrev := 'Null';
  ItemMain.visible := true;
  IsFirst := false;
  IsLast := false;

  ItemMain.ArrowLeft.visible := true;
  ItemMain.ArrowRight.visible := true;
  ItemMain.ArrowLongLeft.style := psDash;
  ItemMain.ArrowLongRight.style := psDash;

  ItemMain.ArrowRightPolygon.visible := false;
  ItemMain.ArrowLeftPolygon.visible := false;

  Parent := TWinControl(AOwner);
end;

procedure TListControl.SetPaddings;
begin
  if IsFirst then
  begin
    ItemLeft := FirstWidth + 20;
  end;
end;

{$REGION 'Set- методы'}

procedure TListControl.SetIsFirst(const Value: boolean);
begin
  if Value <> _IsFirst then
  begin
    _IsFirst := Value;
    self.Refresh;
    SetPaddings();
  end;
end;

procedure TListControl.SetIsLast(const Value: boolean);
begin
  if Value <> _IsLast then
  begin
    _IsLast := Value;
    self.Refresh;
    SetPaddings();
  end;
end;

procedure TListControl.SetIsAddBefore(const Value: boolean);
begin
  if Value <> _IsAddBefore then
  begin
    _IsAddBefore := Value;
    self.Refresh;
    SetPaddings();
  end;
end;

procedure TListControl.SetIsAddAfter(const Value: boolean);
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
procedure DrawArrowHead(Canvas: TCanvas; x, y: integer; Angle, LW: Extended;
  color: TColor);
var
  A1, A2: Extended;
  Arrow: array [0 .. 3] of TPoint;
  OldWidth: integer;
  OldBrushColor: TColor;
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
  OldBrushColor := Canvas.Brush.color;

  Canvas.Pen.Width := 1;
  Canvas.Brush.color := color;
  Canvas.Polygon(Arrow);

  Canvas.Brush.color := OldBrushColor;
  Canvas.Pen.Width := OldWidth;
end;

procedure DrawArrow(Canvas: TCanvas; X1, Y1, X2, Y2: integer; Arrow: TArrow;
  LW: Extended = 3);
var
  Angle: Extended;
  OldWidth: integer;
  oldColor: TColor;
  oldFontSize: integer;
  oldFontColor: TColor;
  p1, p2, center: TPoint;
begin
  if not Arrow.visible then
    exit;

  p1 := Point(X1, Y1);
  p2 := Point(X2, Y2);
  oldColor := Canvas.Pen.color;
  Canvas.Pen.color := Arrow.color;
  OldWidth := Canvas.Pen.Width;
  oldFontSize := Canvas.Font.Size;
  oldFontColor := Canvas.Font.color;

  if Arrow.style = psDash then
    Canvas.Pen.Width := 1
  else
    Canvas.Pen.Width := 2;

  Canvas.Pen.style := Arrow.style;

  Angle := ArcTan2(Y1 - Y2, X2 - X1);
  Canvas.MoveTo(X1, Y1);
  Canvas.LineTo(X2 - Round(2 * LW * Cos(Angle)),
    Y2 + Round(2 * LW * Sin(Angle)));

  // рисуем крестик
  if Arrow.cross.visible then
  begin
    Canvas.Font.Size := 12;
    Canvas.Font.color := clRed;
    center.x := Round((p1.x + p2.x) / 2);
    center.y := Round((p1.y + p2.y) / 2);

    Canvas.TextOut(center.x - Round(Canvas.TextWidth('x') / 2),
      center.y - Round((Canvas.TextHeight('x') / 2) + 0.6), 'x');
    Canvas.Font.Size := oldFontSize;
    Canvas.Font.color := oldFontColor;
  end;

  Canvas.Pen.style := psSolid;
  DrawArrowHead(Canvas, X2, Y2, Angle, LW, Arrow.color);

  Canvas.Pen.Width := OldWidth;
  Canvas.Pen.color := oldColor;

end;

procedure DrawArrowPolygon(Canvas: TCanvas; points: Array Of TPoint;
  Arrow: TArrow);
var
  I, last: integer;
begin
  if not Arrow.visible then
    exit;

  // рисуем линии
  Canvas.MoveTo(points[0].x, points[0].y);
  for I := 0 to Length(points) - 1 do
  begin
    Canvas.LineTo(points[I].x, points[I].y);
  end;
  last := High(points);
  DrawArrow(Canvas, points[last - 1].x, points[last - 1].y, points[last].x,
    points[last].y, Arrow);
end;
{$ENDREGION}
{$REGION 'рисование самого элемента'}

// вычисляет координаты откуда нужно будет рисовать стрелочки
procedure CalcPointsForArrows(p: TPoint; Width, Height: integer;
  var points: Array Of TPoint);
begin
  points[0] := Point(p.x,
    p.y + Round(Height * 1 / 3 + ((Height * 3 / 3 - Height * 2 / 3) / 2)));
  points[1] := Point(p.x,
    p.y + Round(Height * 2 / 3 + ((Height * 2 / 3 - Height * 1 / 3) / 2)));
  points[2] := Point(p.x + Width,
    p.y + Round(Height * 1 / 3 + ((Height * 3 / 3 - Height * 2 / 3) / 2)));
  points[3] := Point(p.x + Width,
    p.y + Round(Height * 2 / 3 + ((Height * 2 / 3 - Height * 1 / 3) / 2)));
end;

Procedure DrawListItem(Canvas: TCanvas; p: TPoint; Width, Height: integer;
  item: TItem; var points: Array Of TPoint);
var
  x, y: integer;
  oldPenColor: TColor;
  oldPenWidth: integer;
begin
  if not item.visible then
    exit;
  oldPenColor := Canvas.Pen.color;
  Canvas.Pen.color := item.color;
  oldPenWidth := Canvas.Pen.Width;

  Canvas.Pen.Width := 2;

  Canvas.Rectangle(p.x, p.y, p.x + Width, p.y + Height);
  Canvas.Rectangle(p.x, p.y, p.x + Width, p.y + Height);
  Canvas.Rectangle(p.x, p.y + Round(Height * 1 / 3), p.x + Width,
    p.y + Round(Height * 1 / 3 + 1));
  Canvas.Rectangle(p.x, p.y + Round(Height * 2 / 3), p.x + Width,
    p.y + Round(Height * 2 / 3 + 1));

  Canvas.Pen.Width := oldPenWidth;
  // возвращает ширину текста в пикселях с учетом гарнитуры шрифта
  x := Canvas.TextWidth(item.TitleMain);
  y := Canvas.TextHeight(item.TitleMain);

  Canvas.Pen.color := oldPenColor;

  // рисуем заголовок компонента
  Canvas.TextOut(p.x + Round((Width - x) / 2),
    p.y + Round((Height * 1 / 3 - y) / 2), item.TitleMain);

  x := Canvas.TextWidth(item.TitleNext);
  y := Canvas.TextHeight(item.TitleNext);
  // рисуем поле ссылку на след элемент
  Canvas.TextOut(p.x + Round((Width - x) / 2),
    p.y + Round(Height * 1 / 3 + ((Height * 2 / 3 - Height * 1 / 3 - y) / 2)),
    item.TitleNext);

  x := Canvas.TextWidth(item.TitlePrev);
  y := Canvas.TextHeight(item.TitlePrev);
  // рисуем поле ссылку на след элемент
  Canvas.TextOut(p.x + Round((Width - x) / 2),
    p.y + Round(Height * 2 / 3 + ((Height * 3 / 3 - Height * 2 / 3 - y) / 2)),
    item.TitlePrev);

  // вычислим координты откуда нужно будет присовать срелочки
  CalcPointsForArrows(p, Width, Height, points);
end;

{$ENDREGION}

procedure TListControl.Paint();
var
  // координаты для стрелочек, откуда они будут рисоваться
  // для каждого элемента - 4 координаты
  MainItemPoints: array [1 .. 4] of TPoint;
  LeftItemPoints: array [1 .. 4] of TPoint;
  RightItemPoints: array [1 .. 4] of TPoint;
  aHeight, aWidth: integer;
  p: TPoint; // произвольная коодината для облегчения жизни
  x, y, PolygonArrowHeight: integer;
  Arrow: TArrow;
begin
  aWidth := Width;
  aHeight := Height;
  Canvas.Font.Size := 8;
  Canvas.Pen.Width := 2;
  Canvas.Pen.style := psSolid;
  Canvas.Pen.color := clBlack;

  Canvas.Brush.style := bsClear;
  Canvas.Brush.color := clWhite;

  case State of
    normal, addBefore:
      begin
        // рисуем сам элемент
        DrawListItem(Canvas, Point(ItemLeft, ItemTop), ItemWidth, ItemHeigth,
          ItemMain, MainItemPoints);
        if not IsLast then
        begin
          // рисуем стрелочки влево/вправо
          DrawArrow(Canvas, MainItemPoints[3].x, MainItemPoints[3].y,
            MainItemPoints[3].x + ArrowWidth, MainItemPoints[3].y,
            ItemMain.ArrowRight);
          DrawArrow(Canvas, MainItemPoints[4].x + ArrowWidth,
            MainItemPoints[4].y, MainItemPoints[4].x, MainItemPoints[4].y,
            ItemMain.ArrowLeft);

          PolygonArrowHeight := Round((1 / 5 * ItemWidth));
          // рисуем длинные стрелки отображаемые при удалении элемента
          DrawArrowPolygon(Canvas,
            [Point(ItemLeft + ItemWidth - PolygonArrowHeight, ItemTop),
            Point(ItemLeft + ItemWidth - PolygonArrowHeight,
            ItemTop - PolygonArrowHeight),
            Point(ItemLeft + 2 * ItemWidth + 2 * ArrowWidth +
            PolygonArrowHeight, ItemTop - PolygonArrowHeight),
            Point(ItemLeft + 2 * ItemWidth + 2 * ArrowWidth +
            PolygonArrowHeight, ItemTop)], ItemMain.ArrowRightPolygon);

          DrawArrowPolygon(Canvas,
            [Point(ItemLeft + 2 * ItemWidth + 2 * ArrowWidth +
            PolygonArrowHeight, ItemTop + ItemHeigth),
            Point(ItemLeft + 2 * ItemWidth + 2 * ArrowWidth +
            PolygonArrowHeight, ItemTop + ItemHeigth + PolygonArrowHeight),
            Point(ItemLeft + ItemWidth - PolygonArrowHeight,
            ItemTop + ItemHeigth + PolygonArrowHeight),
            Point(ItemLeft + ItemWidth - PolygonArrowHeight,
            ItemTop + ItemHeigth)], ItemMain.ArrowLeftPolygon);
        end;

        aWidth := ItemLeft + 2 * ItemWidth + 2 * ArrowWidth + PolygonArrowHeight
          + Round(ArrowHeadWidth / 2);
        aHeight := ItemTop + ItemHeigth + PolygonArrowHeight + 1;
      end;
    addAfter:
      begin
        // оснвной элемент - начало
        DrawListItem(Canvas, Point(ItemLeft, ItemTop), ItemWidth, ItemHeigth,
          ItemMain, MainItemPoints);
        aWidth := ItemLeft + ItemWidth + ArrowWidth;
        // оснвной элемент - конец

        CalcPointsForArrows(Point(ItemLeft + ItemWidth + ArrowWidth,
          ItemTop + ItemHeigth), ItemWidth, ItemHeigth, RightItemPoints);

        // рисуем длинные стрелочки

        DrawArrow(Canvas, MainItemPoints[3].x, MainItemPoints[3].y,
          MainItemPoints[3].x + ItemWidth + ArrowWidth * 2, MainItemPoints[3].y,
          ItemMain.ArrowLongRight);
        DrawArrow(Canvas, MainItemPoints[4].x + ItemWidth + ArrowWidth * 2,
          MainItemPoints[4].y, MainItemPoints[4].x, MainItemPoints[4].y,
          ItemMain.ArrowLongLeft);

        // рисуем стрелочки по диогонали от главного элемента всправо
        DrawArrow(Canvas, MainItemPoints[3].x, MainItemPoints[3].y,
          RightItemPoints[1].x, RightItemPoints[1].y, ItemMain.ArrowDownLeft);
        // рисуем стрелочки по диогонали от правого элемента к главному
        DrawArrow(Canvas, RightItemPoints[2].x, RightItemPoints[2].y,
          MainItemPoints[4].x, MainItemPoints[4].y, ItemMain.ArrowUpLeft);

        aWidth := ItemLeft + ItemWidth * 2 + ArrowWidth * 2;
        aHeight := ItemTop + ItemHeigth * 2;
      end;
    new:
      begin
        // рисуем сам контрол
        DrawListItem(Canvas, Point(ItemLeft, ItemTop + ItemHeigth), ItemWidth,
          ItemHeigth, ItemMain, MainItemPoints);

        // вычисляем координаты для правого элемента
        CalcPointsForArrows(Point(ItemLeft + ItemWidth + ArrowWidth, ItemTop),
          ItemWidth, ItemHeigth, RightItemPoints);

        // рисуем стрелочки по диогонали от нового элемента вправо
        DrawArrow(Canvas, MainItemPoints[3].x, MainItemPoints[3].y,
          RightItemPoints[1].x, RightItemPoints[1].y, ItemMain.ArrowUpRight);
        // рисуем стрелочки по диогонали от правого элемента к новому
        DrawArrow(Canvas, RightItemPoints[2].x, RightItemPoints[2].y,
          MainItemPoints[4].x, MainItemPoints[4].y, ItemMain.ArrowDownRight);

        aWidth := ItemLeft + ItemWidth + ArrowWidth;
        aHeight := ItemTop + ItemHeigth * 2;
      end;
  end;

  if IsFirst then
  begin
    aHeight := ItemTop + ItemHeigth * 2;

    Canvas.Rectangle(0, 0, FirstWidth, FirstHeight);

    // возвращает ширину текста в пикселях с учетом гарнитуры шрифта
    x := Canvas.TextWidth('First');
    y := Canvas.TextHeight('First');

    // рисуем First
    Canvas.TextOut(0 + Round((FirstWidth - x) / 2),
      0 + Round((FirstHeight - y) / 2), 'First');
    Canvas.Pen.Width := 2;

    // Canvas.MoveTo(0 + Round(FirstWidth / 2), FirstHeight);

    p := Point(0 + Round(FirstWidth / 2),
      ItemTop + Round(ItemHeigth * 1 / 3 + ((ItemHeigth * 2 / 3 - ItemHeigth * 1
      / 3 - y) / 2)));
    DrawArrowPolygon(Canvas, [Point(p.x, FirstHeight), p, Point(ItemLeft, p.y)],
      ItemMain.ArrowHeader);

    // Canvas.LineTo(p.x, p.y);
    // Canvas.Pen.Width := 1;
    // ItemMain.ArrowHeader.visible := true;
    // ItemMain.ArrowHeader.color := clBlack;
    // DrawArrow(Canvas, p.x, p.y, ItemLeft, p.y, Arrow);
  end;

  Width := aWidth;
  Height := aHeight;
end;

end.
