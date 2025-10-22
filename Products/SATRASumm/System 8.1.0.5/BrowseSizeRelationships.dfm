object fmBrowseSizeRelationships: TfmBrowseSizeRelationships
  Left = 253
  Top = 193
  BorderStyle = bsDialog
  Caption = 'Browse Size Relationships'
  ClientHeight = 366
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000088
    8888888888888888888888888000008800000888000000000888888880000088
    8888888888888888888888888000008888888888888888888888888880000088
    0000888800000000888888888000008888888888888888888888888880000088
    8888888888888888888888888000008800008888000000888888888880000088
    8888888888888888888888888000008888888888888888888888888880000088
    0000888800000000888888888000008888888888888888888888888880000088
    8888888888888888888888888000008800008888000000000000888880000088
    8888888888888888888888888000008888888888888888888888888880000088
    0000888800000000888888888000008888888888888888888888888880000088
    8888888888888888888888888000008800008888000000000008888880000088
    8888888888888888888888888000008888888888888888888888888880000088
    0000888800000000008888888000008888888888888888888888888880000088
    8888888888888888888888888000008800008888000000000000888880000099
    9999999999999999999999999000009999999999999999999999999990000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFF800000038000000380000003800000038000000380000003800000038000
    0003800000038000000380000003800000038000000380000003800000038000
    0003800000038000000380000003800000038000000380000003800000038000
    0003800000038000000380000003800000038000000380000003FFFFFFFF}
  OldCreateOrder = True
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dbgSizeRelationships: TDBGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 73
    Width = 629
    Height = 290
    Align = alClient
    BorderStyle = bsNone
    Color = clAqua
    DataSource = dsSizeRelationships
    DrawingStyle = gdsClassic
    FixedColor = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick]
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clFuchsia
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnCellClick = dbgSizeRelationshipsCellClick
    OnDblClick = dbgSizeRelationshipsDblClick
    OnKeyPress = dbgSizeRelationshipsKeyPress
    OnTitleClick = dbgSizeRelationshipsTitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'Relationship'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Range'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Description'
        Width = 250
        Visible = True
      end>
  end
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 635
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
  object pnlSearch: TPanel
    Left = 0
    Top = 29
    Width = 635
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object lblRelationship: TLabel
      Left = 250
      Top = 14
      Width = 68
      Height = 13
      Caption = 'lblRelationship'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
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
  end
  object dsSizeRelationships: TDataSource
    DataSet = qSizeRelationships
    Left = 172
    Top = 121
  end
  object qSizeRelationships: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      
        'SELECT Relationship,Range,Description FROM SizeRelationships WHE' +
        'RE Relationship LIKE :Search Order By Relationship, Relationship'
      ' ')
    Left = 247
    Top = 119
    ParamData = <
      item
        Name = 'Search'
        ParamType = ptInput
      end>
    object qSizeRelationshipsRelationship: TStringField
      FieldName = 'Relationship'
    end
    object qSizeRelationshipsRange: TStringField
      FieldName = 'Range'
    end
    object qSizeRelationshipsDescription: TStringField
      FieldName = 'Description'
      Size = 30
    end
  end
end
