object fmAssessKnives: TfmAssessKnives
  Left = 272
  Top = 128
  Caption = 'Pattern Assessment'
  ClientHeight = 539
  ClientWidth = 718
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlKnives: TPanel
    Left = 0
    Top = 29
    Width = 208
    Height = 510
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object dbgKnives: TDBGridPlus
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 202
      Height = 504
      Align = alClient
      BorderStyle = bsNone
      Color = clAqua
      DataSource = dsKnives
      DrawingStyle = gdsClassic
      FixedColor = clLime
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clFuchsia
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Code'
          Title.Caption = 'Knife'
          Width = 154
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'MeasuredSize'
          Title.Alignment = taCenter
          Title.Caption = 'Size'
          Width = 30
          Visible = True
        end>
    end
  end
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 718
    Height = 29
    Align = alTop
    Color = clAqua
    TabOrder = 0
    object btnStart: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Go'
      Flat = True
      Glyph.Data = {
        E6040000424DE604000000000000360000002800000014000000140000000100
        180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
        0000E1DED5E1DED5E1DED5000000FFFFFFFFFFFF000000000000000000000000
        000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DE
        D5E1DED5E1DED5000000FFFFFF000000E1DED5E1DED5E1DED5E1DED5E1DED5E1
        DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DED5E1DED5
        E1DED5000000000000E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DE
        D5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED500
        0000E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5
        000000FFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5000000000000E1DE
        D5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED500
        0000FFFFFFFFFFFF000000E1DED5E1DED5E1DED5000000000000E1DED5E1DED5
        E1DED5E1DED5000000000000000000E1DED5E1DED5E1DED5E1DED5000000FFFF
        FF000000E1DED5E1DED5E1DED5E1DED5000000000000E1DED5E1DED5E1DED500
        0000FFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5000000FFFFFF000000
        E1DED5E1DED5E1DED5E1DED5000000FFFFFF000000E1DED5E1DED5000000FFFF
        FFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5000000000000E1DED5E1DED5E1
        DED5E1DED5000000FFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFF
        FFFFFF000000E1DED5E1DED5E1DED5000000000000E1DED5E1DED5E1DED50000
        00FFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFF000000E1
        DED5E1DED5E1DED5E1DED5000000000000E1DED5E1DED5E1DED5000000FFFFFF
        FFFFFFFFFFFF000000E1DED5E1DED5000000FFFFFF000000E1DED5E1DED5E1DE
        D5E1DED5000000FFFFFF000000E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFF
        FFFF000000E1DED5E1DED5E1DED5000000000000E1DED5E1DED5E1DED5E1DED5
        000000FFFFFF000000E1DED5E1DED5E1DED5E1DED5000000000000000000E1DE
        D5E1DED5E1DED5E1DED5000000000000E1DED5E1DED5E1DED5000000FFFFFFFF
        FFFF000000E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5
        E1DED5E1DED5000000000000E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFF
        FF000000E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1
        DED5000000E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        000000E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED50000000000
        00E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
        0000E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5000000FFFFFF000000E1DED5
        E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
        00000000000000000000000000000000FFFFFFFFFFFF000000E1DED5E1DED5E1
        DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000
        00FFFFFFFFFFFFFFFFFF}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnStartClick
    end
    object btnCancel: TSpeedButton
      Left = 26
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Cancel'
      Enabled = False
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
    object btnRefresh: TSpeedButton
      Left = 49
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
  object pnlImage: TPanel
    AlignWithMargins = True
    Left = 211
    Top = 32
    Width = 504
    Height = 504
    Align = alClient
    BevelOuter = bvNone
    Color = clAqua
    ParentBackground = False
    TabOrder = 2
    object imgInterlock: TImage
      Left = 0
      Top = 0
      Width = 504
      Height = 504
      Align = alClient
      Proportional = True
      ExplicitWidth = 490
      ExplicitHeight = 490
    end
  end
  object LocalConnectionSumms: TFDConnectionPlus
    LoginPrompt = False
    AfterConnect = LocalConnectionSummsAfterConnect
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 186
    Top = 5
  end
  object qPatterns: TFDQueryPlus
    Connection = LocalConnectionSumms
    SQL.Strings = (
      'SELECT * '
      'FROM Patterns '
      'WHERE Knife = :KnifeCode AND MeasuredSize = :Size'
      'Order By Seq, Seq')
    Left = 227
    Top = 1
    ParamData = <
      item
        Name = 'KnifeCode'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'Size'
        ParamType = ptInput
      end>
    object qPatternsKnife: TStringField
      FieldName = 'Knife'
    end
    object qPatternsSeq: TSmallintField
      FieldName = 'Seq'
    end
    object qPatternsX: TSmallintField
      FieldName = 'X'
    end
    object qPatternsY: TSmallintField
      FieldName = 'Y'
    end
  end
  object dsKnives: TDataSource
    DataSet = qKnives
    Left = 223
    Top = 71
  end
  object qSaveInterlocks: TFDQueryPlus
    Connection = LocalConnectionSumms
    Left = 332
    Top = 9
    object StringField1: TStringField
      FieldName = 'Knife'
    end
    object SmallintField1: TSmallintField
      FieldName = 'Seq'
    end
    object SmallintField2: TSmallintField
      FieldName = 'X'
    end
    object SmallintField3: TSmallintField
      FieldName = 'Y'
    end
  end
  object tblKnifeSets: TFDTablePlus
    Filtered = True
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'KNIFESETS'
    TableName = 'KNIFESETS'
    Left = 303
    Top = 62
    object tblKnifeSetsCode: TStringField
      FieldName = 'Code'
    end
    object tblKnifeSetsDescription: TStringField
      FieldName = 'Description'
      Size = 30
    end
    object tblKnifeSetsCutGap: TSmallintField
      FieldName = 'CutGap'
    end
    object tblKnifeSetsType: TStringField
      FieldName = 'Type'
      Size = 1
    end
  end
  object tblKnives: TFDTablePlus
    Filtered = True
    Filter = '(ToBeAssessed = True)'
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'KNIVES'
    TableName = 'KNIVES'
    Left = 264
    Top = 62
    object tblKnivesCode: TStringField
      FieldName = 'Code'
    end
    object tblKnivesSizeScale: TStringField
      FieldName = 'SizeScale'
    end
    object tblKnivesMeasuredSize: TStringField
      FieldName = 'MeasuredSize'
      Size = 10
    end
    object tblKnivesGrossArea: TFloatField
      FieldName = 'GrossArea'
    end
    object tblKnivesNettArea: TFloatField
      FieldName = 'NettArea'
    end
    object tblKnivesInterlockAreaPrimeSynthetic: TFloatField
      FieldName = 'InterlockAreaPrimeSynthetic'
    end
    object tblKnivesInterlockAreaNonPrime: TFloatField
      FieldName = 'InterlockAreaNonPrime'
    end
    object tblKnivesToBeAssessed: TBooleanField
      FieldName = 'ToBeAssessed'
    end
    object tblKnivesImportFilename: TStringField
      FieldName = 'ImportFilename'
      Size = 100
    end
    object tblKnivesPiecename: TStringField
      FieldName = 'Piecename'
    end
    object tblKnivesAssessedVersion: TSmallintField
      FieldName = 'AssessedVersion'
    end
    object tblKnivesToleranceUsed: TIntegerField
      FieldName = 'ToleranceUsed'
    end
    object tblKnivesSeq: TFloatField
      FieldName = 'Seq'
    end
    object tblKnivesKnifeSetType: TStringField
      FieldKind = fkCalculated
      FieldName = 'KnifeSetType'
      Size = 1
      Calculated = True
    end
  end
  object qKnives: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      '')
    Left = 274
    Top = 7
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
    object qKnivesGrossArea: TFloatField
      FieldName = 'GrossArea'
    end
    object qKnivesNettArea: TFloatField
      FieldName = 'NettArea'
    end
    object qKnivesInterlockAreaPrimeSynthetic: TFloatField
      FieldName = 'InterlockAreaPrimeSynthetic'
    end
    object qKnivesInterlockAreaNonPrime: TFloatField
      FieldName = 'InterlockAreaNonPrime'
    end
    object qKnivesToBeAssessed: TBooleanField
      FieldName = 'ToBeAssessed'
    end
    object qKnivesImportFilename: TStringField
      FieldName = 'ImportFilename'
      Size = 100
    end
    object qKnivesPiecename: TStringField
      FieldName = 'Piecename'
    end
    object qKnivesAssessedVersion: TSmallintField
      FieldName = 'AssessedVersion'
    end
    object qKnivesToleranceUsed: TIntegerField
      FieldName = 'ToleranceUsed'
    end
    object qKnivesSeq: TFloatField
      FieldName = 'Seq'
    end
  end
end
