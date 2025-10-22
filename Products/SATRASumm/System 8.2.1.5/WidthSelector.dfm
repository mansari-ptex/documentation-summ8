object fmWidthSelector: TfmWidthSelector
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Select Width'
  ClientHeight = 98
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblWidth: TLabel
    Left = 29
    Top = 23
    Width = 28
    Height = 13
    Caption = 'Width'
  end
  object cbWidth: TComboBox
    Left = 75
    Top = 20
    Width = 145
    Height = 21
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 92
    Top = 59
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
end
