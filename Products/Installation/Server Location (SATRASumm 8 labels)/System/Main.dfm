object fmMain: TfmMain
  Left = 343
  Top = 339
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Advantage Database Location'
  ClientHeight = 173
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblExamples: TLabel
    Left = 5
    Top = 40
    Width = 45
    Height = 13
    Caption = 'Examples'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object btnNext: TButton
    Left = 404
    Top = 139
    Width = 85
    Height = 22
    Caption = '&Next >'
    TabOrder = 2
    OnClick = btnNextClick
  end
  object edtDatabaseLocation: TEdit
    Left = 4
    Top = 15
    Width = 485
    Height = 21
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 5
    Top = 60
    Width = 385
    Height = 101
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      '\\192.168.20.145:13866\SATRA-ADS\SATRASumm8\SATRASumm8Database'
      ''
      '\\MainServer\SATRA-ADS\SATRASumm8\SATRASumm8Database'
      ''
      'C:\Program Files\SATRA-ADS\SATRASumm8\SATRASumm8Database'
      ''
      'C:\Program Files (x86)\SATRA-ADS\SATRASumm8\SATRASumm8Database'
      '')
    ReadOnly = True
    TabOrder = 1
  end
end
