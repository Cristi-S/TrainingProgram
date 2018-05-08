object FormResult: TFormResult
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103
  ClientHeight = 299
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
  object Label1: TLabel
    Left = 136
    Top = 112
    Width = 78
    Height = 13
    Caption = #1042#1089#1077#1075#1086' '#1074#1086#1087#1088#1086#1089#1086#1074
  end
  object Label2: TLabel
    Left = 136
    Top = 144
    Width = 108
    Height = 13
    Caption = #1055#1088#1072#1074#1080#1083#1100#1085#1099#1093' '#1086#1090#1074#1077#1090#1086#1074
  end
  object Label3: TLabel
    Left = 136
    Top = 184
    Width = 206
    Height = 13
    Caption = #1042#1089#1103' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1073#1091#1076#1077#1090' '#1089#1086#1093#1088#1072#1085#1077#1085#1072' '#1074' '#1092#1072#1081#1083
  end
  object EditQuestionsCount: TEdit
    Left = 256
    Top = 104
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 0
    Text = 'EditQuestionsCount'
  end
  object EditCorrectAnswerCount: TEdit
    Left = 256
    Top = 136
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 302
    Top = 224
    Width = 75
    Height = 25
    Caption = #1047#1072#1074#1077#1088#1080#1096#1080#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    FileName = #1055#1088#1086#1090#1086#1082#1086#1083' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103
    Filter = 'txt-files|*.txt|All Files|*.*'
    Left = 512
    Top = 192
  end
end
