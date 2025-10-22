object fmNewPart: TfmNewPart
  Left = 626
  Top = 420
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'New Part'
  ClientHeight = 139
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblCode: TLabel
    Left = 3
    Top = 40
    Width = 25
    Height = 13
    Caption = 'Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblMaterial: TLabel
    Left = 3
    Top = 65
    Width = 37
    Height = 13
    Caption = 'Material'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblSizeRange: TLabel
    Left = 3
    Top = 90
    Width = 55
    Height = 13
    Caption = 'Size Range'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblWidthRange: TLabel
    Left = 3
    Top = 115
    Width = 63
    Height = 13
    Caption = 'Width Range'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object eNewPartCode: TEdit
    Left = 75
    Top = 37
    Width = 173
    Height = 21
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 20
    ParentFont = False
    TabOrder = 1
    OnKeyDown = eAnyKeyDown
  end
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 248
    Height = 29
    Align = alTop
    Color = clAqua
    TabOrder = 0
    object btnSave: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Save'
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
      OnClick = btnSaveClick
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
    object btnBrowse: TSpeedButton
      Left = 72
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Browse'
      AllowAllUp = True
      Enabled = False
      Flat = True
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        1800000000000006000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800080800080800080800080
        80BD665BA06409610C0000808000808000808000808000808000808000808000
        8080008080008080008080008080008080808080808080FFFFFF008080008080
        008080008080008080008080008080008080008080008080008080008080D575
        5EE87906FA96009A190900808000808000808000808000808000808000808000
        8080008080008080008080008080808080808080808080FFFFFF008080008080
        008080008080008080008080008080008080008080008080008080D37460E97C
        0CFF9400D22F06A25C5B00808000808000808000808000808000808000808000
        8080008080008080008080808080808080808080808080FFFFFF008080008080
        008080008080008080008080008080008080008080008080D87D63E7790CF786
        00D33D0CAB615E00808000808000808000808000808000808000808000808000
        8080008080008080808080808080808080808080FFFFFF008080008080008080
        008080008080008080008080008080008080008080D47260E77807FF9000CF3C
        0CA8606000808000808000808000808000808000808000808000808000808000
        8080008080808080808080808080808080FFFFFF008080008080008080008080
        008080008080008080008080008080008080C89289E97B13F98E00CF3607B268
        6300808000808000808000808000808000808000808000808000808000808000
        8080808080808080808080808080FFFFFF008080008080008080008080008080
        BCBCBCA9A9A99C9C9C9C9C9CAAAAAAB7B7B7D4C6BCDFA651D0380FAA625F0080
        8000808000808000808000808000808080808080808080808080808080808080
        8080808080808080808080FFFFFF008080008080008080008080008080C1C1C1
        58584560601C61611061611052521C40403ABCBCBB8879718D5C5B0080800080
        8000808000808000808000808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080DDDDDCA9A997
        B6B67ED1D161E2E255DBDB68D1D1369898073B3B1E7575750080800080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080FFFFFF008080008080008080008080008080008080BCBC9DD5D57C
        D3D384DEDE5FDFDF5FDEDE5FDFDF5FD1D1367373108F8F87C4C4C40080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080CBCB70EAEA99
        D1D187DFDF5EDCDC65E0E05ADEDE5FDBDB68B3B32362623BD3D3D30080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080CDCD95EDEDA6
        D4D480DEDE60E1E158DCDC65DFDF5EE2E255AEAE4D5B5B30D1D1D10080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080CACA84EAEAD3
        D2D294DFDF65DEDE60DFDF5EDEDE5FDEDE61B1B13C676743D5D5D50080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080BFBF97E2E2A6
        DADAB5E3E371DCDC65E0E05ADEDE5FDBDB6889893A8D8D83C8C8C80080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080E1E1DCC0C091
        DCDC91EFEF75E5E55CDDDD67D2D25B9F9F45737360D4D4D40080800080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080FFFFFF008080008080008080008080008080008080008080E1E1DC
        BEBE95CACA78CBCB8CBFBF62575735505047B7B7B60080800080800080800080
        80008080008080008080008080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF008080008080008080008080008080008080008080}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnBrowseClick
    end
  end
  object eMaterial: TEdit
    Left = 75
    Top = 62
    Width = 173
    Height = 21
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 20
    ParentFont = False
    TabOrder = 2
    OnEnter = eAnyEnter
    OnExit = eAnyExit
    OnKeyDown = eAnyKeyDown
  end
  object eSizeRange: TEdit
    Left = 75
    Top = 87
    Width = 173
    Height = 21
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 20
    ParentFont = False
    TabOrder = 3
    OnEnter = eAnyEnter
    OnExit = eAnyExit
    OnKeyDown = eAnyKeyDown
  end
  object eWidthRange: TEdit
    Left = 75
    Top = 112
    Width = 173
    Height = 21
    CharCase = ecUpperCase
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 20
    ParentFont = False
    TabOrder = 4
    OnEnter = eAnyEnter
    OnExit = eAnyExit
    OnKeyDown = eAnyKeyDown
  end
  object qParts: TFDQueryPlus
    Connection = LocalConnectionSumms
    SQL.Strings = (
      
        'INSERT INTO Parts (Code, SizeScale, SizeRange, WidthRange, Mater' +
        'ial, MadeInPairs, CostedSize,'
      
        '                   SampleSize, StdBatchSize, FeedSystem, Rest, C' +
        'ontingency, PressTypeLeather, PressTypeSynthetic, SLMAllowance)'
      'SELECT'
      '  :Code,'
      '  SRD.Scale,'
      '  :SizeRange,'
      '  :WidthRange,'
      '  :Material,'
      '  :MadeInPairs,'
      '  SRD.CostedSize,'
      '  SRD.SampleSize,'
      '  P.BatchSize,'
      '  P.FeedSystem,'
      '  MT.Rest,'
      '  MT.Contingency,'
      '  P.PressTypeLeather,'
      '  P.PressTypeSynthetic,'
      
        '  IIF(:SLMAllowance = TRUE AND (MT.Code = '#39'S'#39' OR MT.Code = '#39'R'#39'),' +
        ' FALSE, TRUE)'
      'FROM'
      '  Params P,'
      '  SizeRanges SRD,'
      '  MatTypes MT'
      'WHERE'
      '  SRD.Range = :SizeRange AND'
      '  MT.Code = (SELECT Type FROM Material WHERE Code = :Material)')
    Left = 128
    Top = 33
    ParamData = <
      item
        Name = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'SizeRange'
        ParamType = ptInput
      end
      item
        Name = 'WidthRange'
        ParamType = ptInput
      end
      item
        Name = 'Material'
        ParamType = ptInput
      end
      item
        Name = 'MadeInPairs'
        ParamType = ptInput
      end
      item
        Name = 'SLMAllowance'
        ParamType = ptInput
      end>
  end
  object qPartsGetError: TFDQueryPlus
    Connection = LocalConnectionSumms
    SQL.Strings = (
      'SELECT COUNT(*)'
      'FROM SizeRanges'
      'WHERE Range = :SizeRange'
      ''
      ''
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    Left = 156
    Top = 33
    ParamData = <
      item
        Name = 'SizeRange'
        ParamType = ptInput
      end>
    object qPartsGetErrorEXPR: TIntegerField
      FieldName = 'EXPR'
    end
  end
  object LocalConnectionSumms: TFDConnection
    LoginPrompt = False
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 101
    Top = 33
  end
end
