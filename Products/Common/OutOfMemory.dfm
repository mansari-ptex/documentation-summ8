object fmMemoryError: TfmMemoryError
  Left = 266
  Top = 220
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'System Problem'
  ClientHeight = 163
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 163
    Align = alClient
    BevelOuter = bvNone
    Color = clBlue
    TabOrder = 0
    object lblError: TLabel
      Left = 10
      Top = 15
      Width = 203
      Height = 13
      Caption = 'The action could not be completed.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblIntro: TLabel
      Left = 10
      Top = 37
      Width = 300
      Height = 26
      Caption = 
        'An unexpected problem was encountered during the creation of a w' +
        'indow or report. '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object lblNote1: TLabel
      Left = 10
      Top = 85
      Width = 154
      Height = 13
      Caption = '1) Database Rights Issues.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblNote3: TLabel
      Left = 10
      Top = 133
      Width = 294
      Height = 26
      Caption = 
        '3) Your PC may be out of memory. Close some             windows ' +
        'immediately to release some resources. '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object lblIntro2: TLabel
      Left = 10
      Top = 64
      Width = 149
      Height = 13
      Caption = 'Common causes include -:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblNote2: TLabel
      Left = 10
      Top = 103
      Width = 300
      Height = 26
      Caption = 
        '2) Windows Rights Issues with file or device access.     E.g. no' +
        ' access to the selected printer.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
  end
end
