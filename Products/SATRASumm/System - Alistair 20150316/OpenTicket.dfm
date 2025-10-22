object fmOpenTicket: TfmOpenTicket
  Left = 338
  Top = 365
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Open Ticket'
  ClientHeight = 66
  ClientWidth = 175
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblSlash: TLabel
    Left = 98
    Top = 40
    Width = 5
    Height = 13
    Caption = '/'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblNumber: TLabel
    Left = 3
    Top = 40
    Width = 37
    Height = 13
    Caption = 'Number'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 175
    Height = 29
    Align = alTop
    Color = clAqua
    TabOrder = 0
    object btnOpen: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Open'
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
      ParentShowHint = False
      ShowHint = True
      OnClick = btnOpenClick
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
  end
  object seWeekNo: TPBSuperSpin
    Left = 53
    Top = 37
    Width = 40
    Height = 22
    Cursor = crDefault
    Alignment = taLeftJustify
    Decimals = -1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 2
    MaxValue = 53.000000000000000000
    MinValue = 1.000000000000000000
    NumberFormat = Standard
    OnKeyDown = seAnyKeyDown
    ParentFont = False
    TabOrder = 1
    Value = 1.000000000000000000
    Increment = 1.000000000000000000
    RoundValues = False
    Wrap = True
  end
  object seSequenceNo: TPBSuperSpin
    Left = 110
    Top = 37
    Width = 60
    Height = 22
    Cursor = crDefault
    Alignment = taLeftJustify
    Decimals = -1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 5
    MaxValue = 32000.000000000000000000
    MinValue = 1.000000000000000000
    NumberFormat = Standard
    OnKeyDown = seAnyKeyDown
    ParentFont = False
    TabOrder = 2
    Value = 1.000000000000000000
    Increment = 1.000000000000000000
    RoundValues = False
    Wrap = True
  end
end
