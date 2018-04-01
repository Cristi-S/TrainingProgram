unit Control1;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Graphics,
  Vcl.StdCtrls;

type
  TControl1 = class(TGraphicControl)
  private
    { Private declarations }
    ItemTop, ItemLeft: integer;
    _IsFirst: boolean;
    procedure SetIsFirst(const Value: boolean);
  protected
    procedure Paint; override;
  public
    MinHeigth, x, y: integer;
    MinWidth: integer;
    TitleMain: String;
    TitleNext, TitlePrev: string;

    IsLast: boolean;
    IsAddBefore: boolean;
    IsAddAfter: boolean;

    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property IsFirst: boolean read _IsFirst write SetIsFirst;
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

  Height := ItemTop + 60;
  Width := ItemLeft + 120;
  TitleMain := 'Null';
  TitleNext := 'Null';
  TitlePrev := 'Null';
  IsLast := false;
  Color := clWhite;

  MinHeigth := 60;
  MinWidth := 100;

  Parent := TWinControl(AOwner);

end;

procedure TControl1.SetIsFirst(const Value: boolean);
begin
  if Value <> _IsFirst then
  begin
    _IsFirst := Value;

    if _IsFirst then
    begin
      ItemTop := 50;
      ItemLeft := 120;
    end;
  end;
end;

procedure TControl1.Paint();
begin
  Canvas.Font.Size := 8;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsClear;
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Color := clWhite;
  Canvas.Rectangle(ItemLeft, ItemTop, ItemLeft + Width, ItemTop + Height);
  Canvas.Pen.Color := clBlack;
  Canvas.Rectangle(ItemLeft, ItemTop, ItemLeft + MinWidth, ItemTop + MinHeigth);
  Canvas.Rectangle(ItemLeft, ItemTop + round(MinHeigth * 1 / 3),
    ItemLeft + MinWidth, ItemTop + round(MinHeigth * 1 / 3 + 1));
  Canvas.Rectangle(ItemLeft, ItemTop + round(MinHeigth * 2 / 3),
    ItemLeft + MinWidth, ItemTop + round(MinHeigth * 2 / 3 + 1));

  // возвращает ширину текста в пикселях с учетом гарнитуры шрифта
  x := Canvas.TextWidth(TitleMain);
  y := Canvas.TextHeight(TitleMain);

  // рисуем заголовок компонента
  Canvas.TextOut(ItemLeft + round((MinWidth - x) / 2),
    ItemTop + round((MinHeigth * 1 / 3 - y) / 2), TitleMain);

  x := Canvas.TextWidth(TitleNext);
  y := Canvas.TextHeight(TitleNext);
  // рисуем поле ссылку на след элемент
  Canvas.TextOut(ItemLeft + round((MinWidth - x) / 2),
    ItemTop + round(MinHeigth * 1 / 3 + ((MinHeigth * 2 / 3 - MinHeigth * 1 / 3
    - y) / 2)), TitleNext);

  x := Canvas.TextWidth(TitlePrev);
  y := Canvas.TextHeight(TitlePrev);
  // рисуем поле ссылку на след элемент
  Canvas.TextOut(ItemLeft + round((MinWidth - x) / 2),
    ItemTop + round(MinHeigth * 2 / 3 + ((MinHeigth * 3 / 3 - MinHeigth * 2 / 3
    - y) / 2)), TitlePrev);

  // рисуем стрелочки влево/вправо
  if (not IsLast) then
  begin
    Canvas.Font.Size := 14;

    x := Canvas.TextWidth('<──');
    y := Canvas.TextHeight('<──');

    Canvas.TextOut(ItemLeft + MinWidth + 1,
      ItemTop + round(MinHeigth * 2 / 3 + ((MinHeigth * 3 / 3 - MinHeigth * 2 /
      3 - y) / 2) - 5), '<──');

    x := Canvas.TextWidth('──>');
    y := Canvas.TextHeight('──>');

    Width := ItemLeft + MinWidth + x;
    Canvas.TextOut(ItemLeft + MinWidth + 2,
      ItemTop + round(MinHeigth * 1 / 3 + ((MinHeigth * 2 / 3 - MinHeigth * 1 /
      3 - y) / 2) - 5), '──>');
  end;

  if IsFirst then
  begin
    Canvas.Font.Size := 8;
    Canvas.Rectangle(0, 0, 80, 40);

    // возвращает ширину текста в пикселях с учетом гарнитуры шрифта
    x := Canvas.TextWidth('First');
    y := Canvas.TextHeight('First');

    // рисуем First
    Canvas.TextOut(0 + round((80 - x) / 2), 0 + round((40 - y) / 2), 'First');

    Canvas.MoveTo(0 + 40, 40);
    Canvas.LineTo(0 + 40, ItemTop + round(MinHeigth * 1 / 3 +
      ((MinHeigth * 2 / 3 - MinHeigth * 1 / 3 - y) / 2) - 5));

    //ToDo:дорисовать стрелочку до элемента
  end;
end;

end.
