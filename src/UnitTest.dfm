object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 80
    Top = 8
    Width = 185
    Height = 162
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object ButtonCreate: TButton
    Left = 80
    Top = 176
    Width = 185
    Height = 25
    Caption = 'Create'
    TabOrder = 1
    OnClick = ButtonCreateClick
  end
  object ButtonResume: TButton
    Left = 304
    Top = 176
    Width = 75
    Height = 25
    Caption = 'resume'
    TabOrder = 2
    OnClick = ButtonResumeClick
  end
  object Button1: TButton
    Left = 80
    Top = 207
    Width = 185
    Height = 25
    Caption = 'Create'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 304
    Top = 207
    Width = 75
    Height = 25
    Caption = 'resume'
    TabOrder = 4
    OnClick = Button2Click
  end
end
