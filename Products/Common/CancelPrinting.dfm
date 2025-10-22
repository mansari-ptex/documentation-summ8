object fmCancelPrinting: TfmCancelPrinting
  Left = 386
  Top = 343
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Group printing'
  ClientHeight = 80
  ClientWidth = 161
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblItem: TLabel
    Left = 8
    Top = 8
    Width = 30
    Height = 13
    Caption = '..........'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object btnCancel: TColButton
    Left = 48
    Top = 44
    Width = 75
    Height = 25
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnCancelClick
    Color = clAqua
    FrameSize = 1
    FrameColor = clBtnHighlight
    FrameShadowColor = clBtnShadow
  end
end
