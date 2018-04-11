object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #1058#1088#1077#1085#1072#1078#1077#1088#1085#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072
  ClientHeight = 608
  ClientWidth = 1236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PrintScale = poNone
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 280
    Top = 304
    Width = 40
    Height = 16
    Caption = #1050#1086#1083'-'#1074#1086
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 608
    Align = alLeft
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 239
      Height = 104
      Align = alTop
      TabOrder = 0
      object RadioButton2: TRadioButton
        Left = 77
        Top = 60
        Width = 125
        Height = 17
        Alignment = taLeftJustify
        Caption = #1055#1091#1089#1090#1086#1081' '#1089#1087#1080#1089#1086#1082
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = RadioButton2Click
      end
      object RadioButton1: TRadioButton
        Left = 32
        Top = 21
        Width = 170
        Height = 17
        Alignment = taLeftJustify
        Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1085#1099#1081' '#1089#1087#1080#1089#1086#1082
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = RadioButton1Click
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 105
      Width = 239
      Height = 240
      Align = alTop
      TabOrder = 1
      object ButtonAddBefore: TButton
        Left = 1
        Top = 119
        Width = 239
        Height = 59
        Align = alCustom
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1055#1045#1056#1045#1044' '#1074#1099#1073#1088#1072#1085#1085#1099#1084
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = ButtonAddBeforeClick
      end
      object ButtonDelete: TButton
        Left = 1
        Top = 184
        Width = 239
        Height = 49
        Align = alCustom
        Caption = #1059#1044#1040#1051#1048#1058#1068' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1101#1083#1077#1084#1077#1085#1090
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object ButtonAddAfter: TButton
        Left = 1
        Top = 69
        Width = 239
        Height = 57
        Align = alCustom
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1055#1054#1057#1051#1045' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = ButtonAddAfterClick
      end
      object Button3: TButton
        Left = 0
        Top = 6
        Width = 239
        Height = 57
        Align = alCustom
        Caption = #1053#1086#1074#1099#1081' '#1101#1083#1077#1084#1077#1085#1090
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = Button3Click
      end
    end
    object ButtonStop: TButton
      Left = 1
      Top = 344
      Width = 239
      Height = 48
      Caption = #1057#1058#1054#1055
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object Edit1: TEdit
    Left = 326
    Top = 300
    Width = 96
    Height = 24
    ReadOnly = True
    TabOrder = 1
    OnKeyPress = Edit1KeyPress
  end
  object Button2: TButton
    Left = 428
    Top = 300
    Width = 85
    Height = 25
    Caption = 'NextStep()'
    TabOrder = 2
    OnClick = Button2Click
  end
  object ButtonCreate: TButton
    Left = 684
    Top = 300
    Width = 137
    Height = 25
    Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
    Enabled = False
    TabOrder = 3
    OnClick = ButtonCreateClick
  end
  object ButtonClear: TButton
    Left = 603
    Top = 300
    Width = 75
    Height = 25
    Caption = 'Clear'
    Enabled = False
    TabOrder = 4
    OnClick = ButtonClearClick
  end
  object ScrollBox1: TScrollBox
    Left = 260
    Top = 25
    Width = 813
    Height = 258
    HorzScrollBar.Increment = 1
    TabOrder = 5
    object FlowPanel1: TPanel
      Left = 0
      Top = 0
      Width = 809
      Height = 254
      Align = alClient
      Color = clWindow
      ParentBackground = False
      TabOrder = 0
      ExplicitHeight = 201
    end
  end
  object Memo1: TMemo
    Left = 262
    Top = 357
    Width = 811
    Height = 212
    TabOrder = 6
  end
  object Button9: TButton
    Left = 950
    Top = 298
    Width = 121
    Height = 25
    Caption = 'SetLastItemColor'
    TabOrder = 7
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 952
    Top = 326
    Width = 121
    Height = 25
    Caption = 'SetNewItemColor'
    TabOrder = 8
    OnClick = Button10Click
  end
end
