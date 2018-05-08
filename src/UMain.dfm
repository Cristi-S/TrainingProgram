object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #1058#1088#1077#1085#1072#1078#1077#1088#1085#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072
  ClientHeight = 608
  ClientWidth = 1127
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PrintScale = poNone
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 608
    Align = alLeft
    TabOrder = 0
    ExplicitHeight = 589
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
        OnClick = RadioButton1Click
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
        OnClick = ButtonDeleteClick
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
      object ButtonAdd: TButton
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
        OnClick = ButtonAddClick
      end
    end
    object ButtonNext: TButton
      Left = 1
      Top = 344
      Width = 239
      Height = 48
      Caption = 'Next'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = ButtonNextClick
    end
    object Button1: TButton
      Left = 33
      Top = 536
      Width = 184
      Height = 49
      Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1100
      TabOrder = 3
    end
  end
  object Panel4: TPanel
    Left = 241
    Top = 0
    Width = 886
    Height = 608
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 656
    ExplicitTop = 297
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Label1: TLabel
      Left = 56
      Top = 306
      Width = 40
      Height = 16
      Caption = #1050#1086#1083'-'#1074#1086
    end
    object ButtonCreate: TButton
      Left = 220
      Top = 302
      Width = 137
      Height = 25
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
      Enabled = False
      TabOrder = 0
      OnClick = ButtonCreateClick
    end
    object Edit1: TEdit
      Left = 102
      Top = 302
      Width = 96
      Height = 24
      TabOrder = 1
      OnKeyPress = Edit1KeyPress
    end
    object Memo1: TMemo
      Left = 40
      Top = 344
      Width = 811
      Height = 225
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object ScrollBox1: TScrollBox
      Left = 40
      Top = 25
      Width = 813
      Height = 258
      HorzScrollBar.Increment = 1
      TabOrder = 3
      object FlowPanel1: TPanel
        Left = 0
        Top = 0
        Width = 809
        Height = 254
        Align = alClient
        Color = clWindow
        ParentBackground = False
        TabOrder = 0
        ExplicitLeft = -3
        ExplicitTop = -2
      end
    end
    object StatusBar1: TStatusBar
      Left = 1
      Top = 588
      Width = 884
      Height = 19
      Panels = <
        item
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          Text = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074#1086#1087#1088#1086#1089#1086#1074':'
          Width = 140
        end
        item
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          Width = 50
        end
        item
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          Text = #1042#1077#1088#1085#1099#1093' '#1086#1090#1074#1077#1090#1086#1074':'
          Width = 100
        end
        item
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          Width = 50
        end
        item
          Width = 50
        end>
      ExplicitWidth = 866
    end
  end
end
