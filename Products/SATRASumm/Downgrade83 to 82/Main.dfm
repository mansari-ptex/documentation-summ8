object fmDowngrade: TfmDowngrade
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'SATRASumm Database downgrade from 8.3 to 8.2'
  ClientHeight = 89
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnDowngrade: TButton
    Left = 129
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Downgrade'
    TabOrder = 0
    OnClick = btnDowngradeClick
  end
  object FDPhysADSDriverLink1: TFDPhysADSDriverLink
    Left = 16
    Top = 16
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 80
    Top = 40
  end
end
