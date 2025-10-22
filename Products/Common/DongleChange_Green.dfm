object fmDongleChangeGreen: TfmDongleChangeGreen
  Left = 239
  Top = 183
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Change Dongle'
  ClientHeight = 175
  ClientWidth = 533
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblError: TLabel
    Left = 0
    Top = 47
    Width = 22
    Height = 13
    Caption = 'Error'
    Visible = False
  end
  object lblExtendedError: TLabel
    Left = 0
    Top = 64
    Width = 70
    Height = 13
    Caption = 'Extended Error'
    Visible = False
  end
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 533
    Height = 29
    Align = alTop
    Color = clAqua
    ParentBackground = False
    TabOrder = 0
    object btnUpdateDongle: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Change'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
        00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
        00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
        00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
        0003737FFFFFFFFF7F7330099999999900333777777777777733}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnUpdateDongleClick
    end
    object btnCancel: TSpeedButton
      Left = 26
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Cancel'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
        3333333777333777FF3333993333339993333377FF3333377FF3399993333339
        993337777FF3333377F3393999333333993337F777FF333337FF993399933333
        399377F3777FF333377F993339993333399377F33777FF33377F993333999333
        399377F333777FF3377F993333399933399377F3333777FF377F993333339993
        399377FF3333777FF7733993333339993933373FF3333777F7F3399933333399
        99333773FF3333777733339993333339933333773FFFFFF77333333999999999
        3333333777333777333333333999993333333333377777333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnCancelClick
    end
    object btnInformation: TSpeedButton
      Left = 72
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Information'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333FFFFF3333333333F797F3333333333F737373FF333333BFB999BFB
        33333337737773773F3333BFBF797FBFB33333733337333373F33BFBFBFBFBFB
        FB3337F33333F33337F33FBFBFB9BFBFBF3337333337F333373FFBFBFBF97BFB
        FBF37F333337FF33337FBFBFBFB99FBFBFB37F3333377FF3337FFBFBFBFB99FB
        FBF37F33333377FF337FBFBF77BF799FBFB37F333FF3377F337FFBFB99FB799B
        FBF373F377F3377F33733FBF997F799FBF3337F377FFF77337F33BFBF99999FB
        FB33373F37777733373333BFBF999FBFB3333373FF77733F7333333BFBFBFBFB
        3333333773FFFF77333333333FBFBF3333333333377777333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnInformationClick
    end
    object btnRead: TSpeedButton
      Left = 118
      Top = 0
      Width = 23
      Height = 23
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      OnClick = btnReadClick
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 59
    Width = 533
    Height = 116
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object lblMessage1: TLabel
      Left = 179
      Top = 8
      Width = 175
      Height = 13
      Caption = 'Contact SATRA for an Update Code.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object lblMessage2: TLabel
      Left = 117
      Top = 35
      Width = 298
      Height = 13
      Caption = 'Enter Code and press Save or press Cancel to enter code later.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label1: TLabel
      Left = 241
      Top = 68
      Width = 74
      Height = 13
      Caption = 'Dongle Number'
      Visible = False
    end
    object Label2: TLabel
      Left = 315
      Top = 67
      Width = 75
      Height = 13
      Caption = 'Update Number'
      Visible = False
    end
    object Label3: TLabel
      Left = 252
      Top = 85
      Width = 70
      Height = 13
      Caption = 'Extended Error'
      Visible = False
    end
    object Label4: TLabel
      Left = 155
      Top = 84
      Width = 22
      Height = 13
      Caption = 'Error'
      Visible = False
    end
    object Label5: TLabel
      Left = 167
      Top = 68
      Width = 65
      Height = 13
      Caption = 'Product Code'
      Visible = False
    end
    object gbUpdateCode: TGroupBox
      Left = 63
      Top = 62
      Width = 407
      Height = 38
      Caption = 'Update Code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object eUpdateCode: TEdit
        Left = 2
        Top = 15
        Width = 403
        Height = 21
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnKeyDown = eUpdateCodeKeyDown
      end
    end
  end
  object pnlError: TPanel
    Left = 0
    Top = 29
    Width = 533
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Error'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = True
    ParentFont = False
    TabOrder = 2
  end
  object odReadCode: TOpenDialog
    OnShow = odReadCodeShow
    Filter = 'Text Files|*.txt'
    Left = 195
    Top = 43
  end
end
