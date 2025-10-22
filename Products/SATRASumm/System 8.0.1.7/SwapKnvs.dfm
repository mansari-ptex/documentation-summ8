object fmSwapKnives: TfmSwapKnives
  Left = 457
  Top = 331
  Caption = 'Swap Knife Set'
  ClientHeight = 252
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 336
    Height = 29
    Align = alTop
    Color = clAqua
    TabOrder = 0
    object btnSwap: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Swap'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        39993333333333333FFF333333333333339933333333333333FF333333333333
        39393333333333333F3F3333333333339333333333333333F333330000000000
        933333FFFFFFFFFFF33333077FF77779033333F88888888FF3333399900CCC97
        033333FFF88888F8F333330990C0CCC7033333FFF8888888F33339979777FF77
        03333FF8F8888888F333930777FF77770333F3F888888888F333930000000000
        0333F3FFFFFFFFFFF3339307044444070333F3F8F88888F8F333930000000000
        0333F3FFFFFFFFFFF3339333333333333333F333333333333333933333333333
        3333F3333333333333339333333333333333F333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSwapClick
    end
    object btnRefresh: TSpeedButton
      Left = 26
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Refresh'
      AllowAllUp = True
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333339999933
        3333333333888883333393399999999933333833888333888333999993333399
        9333F88888F333F388339993333333399933F888F33333FF3883999933333333
        9933F8888333333FF3839999933333333993F88888333333FF88333333333333
        3993FFFFF33333333F8833333333333339933333333333333F88993333333333
        333388F3333333333333993333333333333388F33333333FFFFF993333333399
        999388FF33333388888F3993333333399993383FF3333338888F399933333333
        99933883FF33333F888F339993333399999333883F333F88888F333999999999
        3393333888333888338333333999993333333333388888333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnRefreshClick
    end
    object btnSelectAll: TSpeedButton
      Left = 72
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Select All'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333330000000
        000033333FFFFFFFFFFF3333303333333330333388888888888F333000333033
        3330333F8F333F33338F333030330003333033888F338FF3338F300030300000
        33303F8F8F3888FF338F3030303003000330888F8F88888FF38F303030303330
        00308F8F8F883888FF8F30303033333300308F8F8F8333888F8F303030333333
        30308F8F8F3333388F8F30303033333333308F8F8F333333838F303030000000
        00008F8F8FFFFFFFFF8F30303333333330338F8F888888888883303000000000
        00338F8FFFFFFFFF8F3330333333333033338F88888888888333300000000000
        33338FFFFFFFFF8F333333333333333333338888888888833333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSelectAllClick
    end
    object btnDeselectAll: TSpeedButton
      Left = 95
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Deselect All'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333330000000
        000033333FFFFFFFFFFF3333303333333330333388888888888F333000333333
        3330333F8F333333338F333030333333333033888F333333338F300030333333
        33303F8F8F333333338F3030303333333330888F8F333333338F303030333333
        33308F8F8F333333338F30303033333333308F8F8F333333338F303030333333
        33308F8F8F333333338F30303033333333308F8F8F333333338F303030000000
        00008F8F8FFFFFFFFF8F30303333333330338F8F888888888883303000000000
        00338F8FFFFFFFFF8F3330333333333033338F88888888888333300000000000
        33338FFFFFFFFF8F333333333333333333338888888888833333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnDeselectAllClick
    end
  end
  object dbgSwapKnives: TDBGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 32
    Width = 330
    Height = 198
    Align = alClient
    BorderStyle = bsNone
    Color = clAqua
    DataSource = dsListKnives
    DrawingStyle = gdsClassic
    FixedColor = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgAlwaysShowEditor, dgTitles, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
    ParentFont = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clFuchsia
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnCellClick = dbgSwapKnivesCellClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Part'
        ReadOnly = True
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Width'
        ReadOnly = True
        Width = 85
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Selected'
        Visible = True
      end>
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 233
    Width = 336
    Height = 19
    Color = clYellow
    Panels = <
      item
        Text = 'WARNING - This has locked:'
        Width = 150
      end
      item
        Bevel = pbNone
        Width = 0
      end
      item
        Bevel = pbNone
        Width = 0
      end
      item
        Bevel = pbNone
        Width = 0
      end
      item
        Bevel = pbNone
        Width = 0
      end
      item
        Bevel = pbNone
        Width = 0
      end
      item
        Bevel = pbNone
        Width = 0
      end
      item
        Bevel = pbNone
        Width = 0
      end
      item
        Bevel = pbNone
        Width = 0
      end
      item
        Bevel = pbNone
        Width = 0
      end
      item
        Bevel = pbNone
        Width = 0
      end
      item
        Bevel = pbNone
        Width = 0
      end>
    SizeGrip = False
    Visible = False
  end
  object LocalConnectionSumms: TFDConnectionPlus
    LoginPrompt = False
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 7
    Top = 27
  end
  object dsListKnives: TDataSource
    DataSet = qListKnives
    Left = 31
    Top = 114
  end
  object qSwapKnives: TFDQueryPlus
    Connection = LocalConnectionSumms
    SQL.Strings = (
      'UPDATE PtWidKnf'
      'SET Knife = '#39'TEST2'#39
      'WHERE PtWidKnf.Part = '#39'TEST'#39' AND'
      '      PtWidKnf.WidthNo = 1 AND'
      '      PtWidKnf.Knife = '#39'TEST'#39
      ''
      '/*AND'
      '      :NewKnife NOT IN'
      '               (SELECT Knife'
      '                FROM PtWidKnf'
      '                WHERE Part = SK.Part AND'
      '                      WidthNo = SK.WidthNo AND'
      '                      SK.Selected = True); */'
      ''
      ' '
      ' ')
    Left = 71
    Top = 23
  end
  object qListKnives: TFDQueryPlus
    BeforeOpen = qListKnivesBeforeOpen
    AfterOpen = qListKnivesAfterOpen
    AfterScroll = qListKnivesAfterScroll
    OnCalcFields = qListKnivesCalcFields
    Connection = fmSumms.ConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      '//Template'
      'SELECT PWK.Part, W.Width, PWK.WidthNo'
      'FROM PtWidKnf PWK, Widths W'
      'WHERE W.No = PWK.WidthNo AND PWK.Knife = '#39'TEST'#39
      'Order By PWK.Part, PWK.Part, PWK.WidthNo')
    Left = 137
    Top = 139
    object qListKnivesPart: TStringField
      FieldName = 'Part'
    end
    object qListKnivesWidth: TStringField
      FieldName = 'Width'
      Size = 10
    end
    object qListKnivesWidthNo: TSmallintField
      FieldName = 'WidthNo'
    end
    object qListKnivesSelected: TBooleanField
      FieldKind = fkCalculated
      FieldName = 'Selected'
      Calculated = True
    end
    object qListKnivesRecNo: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'RecNo'
      Calculated = True
    end
  end
  object qToKnife: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'SELECT COUNT(*) as HowMany'
      'FROM KnifeSets'
      'WHERE Code = :NewCode')
    Left = 98
    Top = 62
    ParamData = <
      item
        Name = 'NewCode'
        ParamType = ptInput
      end>
    object qToKnifeHowMany: TIntegerField
      FieldName = 'HowMany'
    end
  end
end
