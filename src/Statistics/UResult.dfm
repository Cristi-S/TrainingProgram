object FormResult: TFormResult
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103
  ClientHeight = 420
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 454
    Top = 72
    Width = 131
    Height = 41
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1088#1086#1090#1086#1082#1086#1083
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 56
    Top = 40
    Width = 369
    Height = 113
    ReadOnly = True
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 56
    Top = 192
    Width = 545
    Height = 201
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    FileName = #1055#1088#1086#1090#1086#1082#1086#1083' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103
    Filter = 'txt-files|*.txt|All Files|*.*'
    Left = 552
    Top = 24
  end
end
