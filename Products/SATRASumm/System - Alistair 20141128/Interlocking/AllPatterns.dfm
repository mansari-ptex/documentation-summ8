object fmAllPatterns: TfmAllPatterns
  Left = 310
  Top = 320
  Caption = 'Patterns'
  ClientHeight = 365
  ClientWidth = 810
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
  object pnlSearch: TPanel
    Left = 0
    Top = 29
    Width = 810
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object lblSearch: TLabel
      Left = 3
      Top = 14
      Width = 34
      Height = 13
      Caption = 'Search'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object edSearch: TEdit
      Left = 50
      Top = 10
      Width = 180
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      TabOrder = 0
      OnChange = edSearchChange
      OnKeyPress = edSearchKeyPress
    end
    object cbExact: TCheckBox
      Left = 241
      Top = 13
      Width = 50
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Exact'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = cbExactClick
    end
  end
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 810
    Height = 29
    Align = alTop
    Color = clAqua
    TabOrder = 0
    object btnRefresh: TSpeedButton
      Left = 3
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
  end
  object pnlPicture: TPanel
    AlignWithMargins = True
    Left = 518
    Top = 73
    Width = 289
    Height = 289
    Align = alRight
    BevelOuter = bvNone
    Color = clAqua
    ParentBackground = False
    TabOrder = 3
    object imgPattern: TImage
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 283
      Height = 283
    end
    object dbeKnifeCode: TDBEdit
      Left = 20
      Top = 265
      Width = 121
      Height = 21
      DataField = 'Code'
      DataSource = dsqKnives
      TabOrder = 0
      Visible = False
      OnChange = dbeKnifeCodeChange
    end
    object dbeKnifeSize: TDBEdit
      Left = 148
      Top = 264
      Width = 121
      Height = 21
      DataField = 'MeasuredSize'
      DataSource = dsqKnives
      TabOrder = 1
      Visible = False
      OnChange = dbeKnifeCodeChange
    end
  end
  object dbgKnives: TDBGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 73
    Width = 509
    Height = 289
    Align = alClient
    BorderStyle = bsNone
    Color = clAqua
    DataSource = dsqKnives
    DrawingStyle = gdsClassic
    FixedColor = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clFuchsia
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnCellClick = dbgKnivesCellClick
    OnDblClick = dbgKnivesDblClick
    OnKeyPress = dbgKnivesKeyPress
    OnTitleClick = dbgKnivesTitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Code'
        Title.Caption = 'Knife'
        Width = 177
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'MeasuredSize'
        Title.Caption = 'Size'
        Width = 47
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Description'
        Title.Caption = 'Set Description'
        Width = 230
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Done'
        Width = 35
        Visible = True
      end>
  end
  object dsqKnives: TDataSource
    DataSet = qKnives
    Left = 155
    Top = 183
  end
  object qKnives: TFDQueryPlus
    BeforeOpen = qKnivesBeforeOpen
    Connection = fmLayplan.LocalConnectionSumms
    SQL.Strings = (
      
        'SELECT K.Code, K.SizeScale, K.MeasuredSize, K.Angle, KS.Descript' +
        'ion, KS.CutGap as KnifeCutGap,'
      '      (IIF(0 < (SELECT COUNT(L.KnifeCode)'
      ' '#9'              FROM Layplans L'
      
        '                WHERE (L.KnifeCode = K.Code) AND (L.KnifeSizeSca' +
        'le = K.SizeScale) AND (L.KnifeSize = K.MeasuredSize) AND'
      
        #9#9#9'                (L.MaterialLength = :MatLength) AND (L.Materi' +
        'alWidth = :MatWidth) AND (L.MaterialCutGap = :Cutgap) AND'
      
        #9#9#9#9'              (L.MaterialEdge = :MatEdge) AND (L.MaterialCod' +
        'eRestrictive = :MatRestrictive)), TRUE, FALSE)) as Done'
      'FROM Knives K, KnifeSets KS'
      
        'WHERE (ManualEntry = False) AND (K.Code LIKE :Search) AND (KS.Co' +
        'de = K.Code)'
      'Order By K.Code, K.Code, K.Seq'
      '')
    Left = 102
    Top = 176
    ParamData = <
      item
        Name = 'MatLength'
        ParamType = ptInput
      end
      item
        Name = 'MatWidth'
        ParamType = ptInput
      end
      item
        Name = 'Cutgap'
        ParamType = ptInput
      end
      item
        Name = 'MatEdge'
        ParamType = ptInput
      end
      item
        Name = 'MatRestrictive'
        ParamType = ptInput
      end
      item
        Name = 'Search'
        ParamType = ptInput
      end>
    object qKnivesCode: TStringField
      FieldName = 'Code'
    end
    object qKnivesSizeScale: TStringField
      FieldName = 'SizeScale'
    end
    object qKnivesMeasuredSize: TStringField
      FieldName = 'MeasuredSize'
      Size = 10
    end
    object qKnivesAngle: TFloatField
      FieldName = 'Angle'
    end
    object qKnivesDescription: TStringField
      FieldName = 'Description'
      Size = 30
    end
    object qKnivesKnifeCutGap: TSmallintField
      FieldName = 'KnifeCutGap'
    end
    object qKnivesDone: TBooleanField
      FieldName = 'Done'
    end
  end
end
