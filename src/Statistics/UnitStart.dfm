object FormStart: TFormStart
  Left = 0
  Top = 0
  Caption = #1054#1073#1091#1095#1072#1102#1097#1072#1103' '#1090#1088#1077#1085#1072#1078#1077#1088#1085#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072
  ClientHeight = 303
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 88
    Top = 56
    Width = 44
    Height = 13
    Caption = #1060#1072#1084#1080#1083#1080#1103
  end
  object Label2: TLabel
    Left = 88
    Top = 92
    Width = 19
    Height = 13
    Caption = #1048#1084#1103
  end
  object Label3: TLabel
    Left = 88
    Top = 128
    Width = 49
    Height = 13
    Caption = #1054#1090#1095#1077#1089#1090#1074#1086
  end
  object Label4: TLabel
    Left = 88
    Top = 164
    Width = 36
    Height = 13
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object Label5: TLabel
    Left = 88
    Top = 200
    Width = 32
    Height = 13
    Caption = #1056#1077#1078#1080#1084
  end
  object EditLastName: TEdit
    Left = 152
    Top = 48
    Width = 145
    Height = 21
    TabOrder = 0
    Text = #1057#1099#1095#1077#1074#1072
  end
  object EditFirstName: TEdit
    Left = 152
    Top = 83
    Width = 145
    Height = 21
    TabOrder = 1
    Text = #1050#1088#1080#1089#1090#1080#1085#1072
  end
  object EditMiddleName: TEdit
    Left = 152
    Top = 118
    Width = 145
    Height = 21
    TabOrder = 2
    Text = #1040#1083#1077#1082#1089#1072#1085#1076#1088#1086#1074#1085#1072
  end
  object EditGroup: TEdit
    Left = 152
    Top = 156
    Width = 145
    Height = 21
    TabOrder = 3
    Text = #1048#1042#1058'-411'
  end
  object ComboBox1: TComboBox
    Left = 152
    Top = 192
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 4
    Text = #1044#1077#1084#1086
    Items.Strings = (
      #1044#1077#1084#1086
      #1059#1087#1088#1072#1074#1083#1103#1102#1097#1080#1081)
  end
  object ButtonStart: TButton
    Left = 232
    Top = 254
    Width = 145
    Height = 25
    Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100
    TabOrder = 5
    OnClick = ButtonStartClick
  end
end
