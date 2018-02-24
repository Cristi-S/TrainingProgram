object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 396
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Button1: TButton
    Left = 360
    Top = 187
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object FlowPanel1: TFlowPanel
    Left = 0
    Top = 0
    Width = 559
    Height = 105
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 112
    Top = 187
    Width = 121
    Height = 24
    TabOrder = 2
  end
  object Button2: TButton
    Left = 120
    Top = 344
    Width = 75
    Height = 25
    Caption = 'NextStep()'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 344
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 4
  end
end
