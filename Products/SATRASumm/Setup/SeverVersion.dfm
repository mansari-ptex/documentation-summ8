object fmServerVersion: TfmServerVersion
  Left = 371
  Top = 299
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Advantage Database Server Version'
  ClientHeight = 208
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object rgServerVersion: TRadioGroup
    Left = 0
    Top = 0
    Width = 317
    Height = 159
    Align = alTop
    Caption = 'Version'
    ItemIndex = 0
    Items.Strings = (
      'Advantage 11.1 (32 Bit)'
      'Advantage 11.1 (64 Bit)'
      'Advantage 10.1 (32 Bit)'
      'Advantage 10.1 (64 Bit)'
      'Advantage 9.1 (32 Bit)'
      'Advantage 9.1 (64 Bit)'
      'Advantage 8.1 ')
    TabOrder = 0
  end
  object btnBack: TButton
    Left = 160
    Top = 172
    Width = 75
    Height = 25
    Caption = '< Back'
    TabOrder = 1
    OnClick = btnBackClick
  end
  object btnNext: TButton
    Left = 242
    Top = 172
    Width = 75
    Height = 25
    Caption = 'Next >'
    TabOrder = 2
    OnClick = btnNextClick
  end
end
