object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 699
  ClientWidth = 973
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFireDac: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 699
    Align = alLeft
    TabOrder = 0
    object lbFireDac: TListBox
      Left = 1
      Top = 623
      Width = 498
      Height = 75
      Align = alBottom
      ItemHeight = 13
      TabOrder = 0
    end
    object pnlFireDacButtons: TPanel
      Left = 1
      Top = 1
      Width = 185
      Height = 622
      Align = alLeft
      TabOrder = 1
      object btnRefreshConstructions: TButton
        Left = 1
        Top = 201
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Refresh Constructions'
        TabOrder = 0
        OnClick = btnRefreshConstructionsClick
      end
      object btnParts: TButton
        Left = 1
        Top = 26
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Parts Table'
        TabOrder = 1
        OnClick = btnPartsClick
      end
      object btnConnect: TButton
        Left = 1
        Top = 1
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Connect'
        TabOrder = 2
        OnClick = btnConnectClick
      end
      object btnConstructions: TButton
        Left = 1
        Top = 76
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Constructions'
        TabOrder = 3
        OnClick = btnConstructionsClick
      end
      object btnConPartsTable: TButton
        Left = 1
        Top = 101
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'ConParts with Table'
        TabOrder = 4
        OnClick = btnConPartsTableClick
      end
      object btnRefreshConPartsQuery: TButton
        Left = 1
        Top = 251
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Refresh ConParts with Query'
        TabOrder = 5
        OnClick = btnRefreshConPartsQueryClick
      end
      object btnPartsQ: TButton
        Left = 1
        Top = 51
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Parts Query'
        TabOrder = 6
        OnClick = btnPartsQClick
      end
      object btnConPartsNone: TButton
        Left = 1
        Top = 151
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'ConParts with None'
        TabOrder = 7
        OnClick = btnConPartsNoneClick
      end
      object btnConPartsQuery: TButton
        Left = 1
        Top = 126
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'ConParts with Query'
        TabOrder = 8
        OnClick = btnConPartsQueryClick
      end
      object btnRefreshConPartsTable: TButton
        Left = 1
        Top = 226
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Refresh ConParts with Table'
        TabOrder = 9
        OnClick = btnRefreshConPartsTableClick
      end
      object btnRefreshConPartsNone: TButton
        Left = 1
        Top = 276
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Refresh ConParts with None'
        TabOrder = 10
        OnClick = btnRefreshConPartsNoneClick
      end
      object DBGrid10: TDBGrid
        Left = 1
        Top = 521
        Width = 183
        Height = 100
        Align = alBottom
        DataSource = dsConPartsNoneCalc
        TabOrder = 11
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object btnConPartsNoneCalc: TButton
        Left = 1
        Top = 176
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'ConParts with None Calc'
        TabOrder = 12
        OnClick = btnConPartsNoneCalcClick
      end
      object btnRefreshConPartsNoneCalc: TButton
        Left = 1
        Top = 301
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Refresh ConParts with None Calc'
        TabOrder = 13
        OnClick = btnRefreshConPartsNoneCalcClick
      end
    end
    object pnlFireDacGrids: TPanel
      Left = 186
      Top = 1
      Width = 313
      Height = 622
      Align = alClient
      TabOrder = 2
      object DBGrid1: TDBGrid
        AlignWithMargins = True
        Left = 1
        Top = 211
        Width = 311
        Height = 100
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 10
        Align = alTop
        DataSource = dsConstructions
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object DBGrid2: TDBGrid
        Left = 1
        Top = 521
        Width = 311
        Height = 100
        Align = alClient
        DataSource = dsConPartsNone
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object DBGrid3: TDBGrid
        Left = 1
        Top = 101
        Width = 311
        Height = 100
        Align = alTop
        DataSource = dsPartsQ
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object DBGrid7: TDBGrid
        Left = 1
        Top = 1
        Width = 311
        Height = 100
        Align = alTop
        DataSource = dsParts
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object DBGrid8: TDBGrid
        Left = 1
        Top = 421
        Width = 311
        Height = 100
        Align = alTop
        DataSource = dsConPartsQuery
        TabOrder = 4
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object DBGrid9: TDBGrid
        Left = 1
        Top = 321
        Width = 311
        Height = 100
        Align = alTop
        DataSource = dsConPartsTable
        TabOrder = 5
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
  end
  object pnlAds: TPanel
    Left = 500
    Top = 0
    Width = 473
    Height = 699
    Align = alClient
    TabOrder = 1
    object lbAds: TListBox
      Left = 1
      Top = 623
      Width = 471
      Height = 75
      Align = alBottom
      ItemHeight = 13
      TabOrder = 0
    end
    object pnlAdButtons: TPanel
      Left = 1
      Top = 1
      Width = 185
      Height = 622
      Align = alLeft
      TabOrder = 1
      object btnAdsConnect: TButton
        Left = 1
        Top = 1
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Connect'
        TabOrder = 0
        OnClick = btnAdsConnectClick
      end
      object tbnAdsDisconnect: TButton
        Left = 1
        Top = 26
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Disconnect'
        TabOrder = 1
        OnClick = tbnAdsDisconnectClick
      end
      object btnAdsParts: TButton
        Left = 1
        Top = 51
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Parts'
        TabOrder = 2
        OnClick = btnAdsPartsClick
      end
      object btnAdsConstructions: TButton
        Left = 1
        Top = 76
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Constructions'
        TabOrder = 3
        OnClick = btnAdsConstructionsClick
      end
      object btnAdsConParts: TButton
        Left = 1
        Top = 101
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'ConParts'
        TabOrder = 4
        OnClick = btnAdsConPartsClick
      end
      object btnRefreshAdsConParts: TButton
        Left = 1
        Top = 151
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Refresh ConParts'
        TabOrder = 5
        OnClick = btnRefreshAdsConPartsClick
      end
      object btnRefreshAdsConstructions: TButton
        Left = 1
        Top = 126
        Width = 183
        Height = 25
        Align = alTop
        Caption = 'Refresh Constructions'
        TabOrder = 6
        OnClick = btnRefreshAdsConstructionsClick
      end
    end
    object pnlAdGrids: TPanel
      Left = 186
      Top = 1
      Width = 286
      Height = 622
      Align = alClient
      TabOrder = 2
      object DBGrid4: TDBGrid
        Left = 1
        Top = 1
        Width = 284
        Height = 200
        Align = alTop
        DataSource = dsAdsParts
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object DBGrid5: TDBGrid
        AlignWithMargins = True
        Left = 1
        Top = 211
        Width = 284
        Height = 100
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 10
        Align = alTop
        DataSource = dsAdsConstructions
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object DBGrid6: TDBGrid
        Left = 1
        Top = 321
        Width = 284
        Height = 100
        Align = alTop
        DataSource = dsAdsConParts
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
  end
  object dsConPartsTable: TDataSource
    DataSet = tblConPartsTable
    Left = 343
    Top = 356
  end
  object dsConstructions: TDataSource
    DataSet = tblConstructions
    Left = 352
    Top = 237
  end
  object tblConstructions: TFDTablePlus
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'Construc'
    TableName = 'Construc'
    Left = 290
    Top = 191
    object tblConstructionsConstruction: TStringField
      FieldName = 'Construction'
      Required = True
    end
    object tblConstructionsSizeScale: TStringField
      FieldName = 'SizeScale'
    end
    object tblConstructionsSizeRange: TStringField
      FieldName = 'SizeRange'
    end
    object tblConstructionsSampleSize: TStringField
      FieldName = 'SampleSize'
      Size = 10
    end
    object tblConstructionsCostedSize: TStringField
      FieldName = 'CostedSize'
      Size = 10
    end
    object tblConstructionsDescription: TStringField
      FieldName = 'Description'
      Size = 30
    end
    object tblConstructionsMadeInPairs: TBooleanField
      FieldName = 'MadeInPairs'
    end
    object tblConstructionsMadeInPairsYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'MadeInPairsYesNo'
      Size = 3
      Calculated = True
    end
  end
  object LocalConnectionSumms: TFDConnectionPlus
    Params.Strings = (
      'Alias=SATRASUMM8'
      'User_Name=supervisor'
      'Password=SATRA'
      'DriverID=ADS')
    FetchOptions.AssignedValues = [evItems, evRowsetSize]
    Connected = True
    LoginPrompt = False
    Left = 47
    Top = 390
  end
  object tblParts: TFDTablePlus
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRowsetSize]
    UpdateOptions.UpdateTableName = 'PARTS'
    TableName = 'PARTS'
    Left = 285
    Top = 24
    object tblPartsCode: TStringField
      FieldName = 'Code'
      Origin = 'Code'
      FixedChar = True
    end
    object tblPartsDescription: TStringField
      FieldName = 'Description'
      Origin = 'Description'
      FixedChar = True
      Size = 30
    end
    object tblPartsSizeScale: TStringField
      FieldName = 'SizeScale'
      Origin = 'SizeScale'
      FixedChar = True
    end
    object tblPartsSizeRange: TStringField
      FieldName = 'SizeRange'
      Origin = 'SizeRange'
      FixedChar = True
    end
    object tblPartsCostedSize: TStringField
      FieldName = 'CostedSize'
      Origin = 'CostedSize'
      FixedChar = True
      Size = 10
    end
    object tblPartsSampleSize: TStringField
      FieldName = 'SampleSize'
      Origin = 'SampleSize'
      FixedChar = True
      Size = 10
    end
    object tblPartsMadeInPairs: TBooleanField
      FieldName = 'MadeInPairs'
      Origin = 'MadeInPairs'
    end
  end
  object dsParts: TDataSource
    DataSet = tblParts
    Left = 336
    Top = 56
  end
  object FDPhysADSDriverLink1: TFDPhysADSDriverLink
    Left = 48
    Top = 264
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrNone
    Left = 48
    Top = 329
  end
  object tblAdsParts: TAdsTable
    IndexName = 'PRIMARY'
    AdsConnection = LocalAdsConnectionSumms
    AdsTableOptions.AdsIndexPageSize = 512
    TableName = 'PARTS'
    Left = 781
    Top = 40
  end
  object LocalAdsConnectionSumms: TAdsConnection
    AliasName = 'SATRASUMM8'
    AdsServerTypes = [stADS_REMOTE, stADS_LOCAL, stADS_AIS]
    LoginPrompt = False
    Username = 'supervisor'
    Password = 'SATRA'
    StoreConnected = False
    Left = 565
    Top = 344
  end
  object dsAdsParts: TDataSource
    DataSet = tblAdsParts
    Left = 830
    Top = 88
  end
  object dsAdsConstructions: TDataSource
    DataSet = tblAdsConstructions
    Left = 830
    Top = 256
  end
  object tblAdsConstructions: TAdsTable
    IndexName = 'PRIMARY'
    AdsConnection = LocalAdsConnectionSumms
    AdsTableOptions.AdsIndexPageSize = 512
    TableName = 'CONSTRUC'
    Left = 781
    Top = 200
    object tblAdsConstructionsConstruction: TAdsStringField
      FieldName = 'Construction'
    end
    object tblAdsConstructionsDescription: TAdsStringField
      FieldName = 'Description'
      Size = 30
    end
    object tblAdsConstructionsSizeScale: TAdsStringField
      FieldName = 'SizeScale'
    end
    object tblAdsConstructionsSizeRange: TAdsStringField
      FieldName = 'SizeRange'
    end
    object tblAdsConstructionsSampleSize: TAdsStringField
      FieldName = 'SampleSize'
      Size = 10
    end
    object tblAdsConstructionsCostedSize: TAdsStringField
      FieldName = 'CostedSize'
      Size = 10
    end
    object tblAdsConstructionsMadeInPairs: TBooleanField
      FieldName = 'MadeInPairs'
    end
  end
  object dsAdsConParts: TDataSource
    DataSet = tblAdsConParts
    Left = 830
    Top = 408
  end
  object tblAdsConParts: TAdsTable
    IndexName = 'PRIMARY'
    MasterFields = 'Construction'
    MasterSource = dsAdsConstructions
    AdsConnection = LocalAdsConnectionSumms
    AdsTableOptions.AdsIndexPageSize = 512
    TableName = 'CONPARTS'
    Left = 781
    Top = 360
    object tblAdsConPartsConstruction: TAdsStringField
      FieldName = 'Construction'
    end
    object tblAdsConPartsPart: TAdsStringField
      FieldName = 'Part'
    end
    object tblAdsConPartsID: TIntegerField
      FieldName = 'ID'
    end
    object tblAdsConPartsAltMaterial: TAdsStringField
      FieldName = 'AltMaterial'
    end
    object tblAdsConPartsUse: TBooleanField
      FieldName = 'Use'
    end
    object tblAdsConPartsPartDescription: TAdsStringField
      FieldKind = fkLookup
      FieldName = 'PartDescription'
      LookupDataSet = tblAdsParts
      LookupKeyFields = 'Code'
      LookupResultField = 'Description'
      KeyFields = 'Part'
      Lookup = True
    end
    object tblAdsConPartsPartSizeScale: TStringField
      FieldKind = fkLookup
      FieldName = 'PartSizeScale'
      LookupDataSet = tblAdsParts
      LookupKeyFields = 'Code'
      LookupResultField = 'SizeScale'
      KeyFields = 'Part'
      Lookup = True
    end
    object tblAdsConPartsPartSizeRange: TStringField
      FieldKind = fkLookup
      FieldName = 'PartSizeRange'
      LookupDataSet = tblAdsParts
      LookupKeyFields = 'Code'
      LookupResultField = 'SizeRange'
      KeyFields = 'Part'
      Lookup = True
    end
    object tblAdsConPartsPartSampleSize: TStringField
      FieldKind = fkLookup
      FieldName = 'PartSampleSize'
      LookupDataSet = tblAdsParts
      LookupKeyFields = 'Code'
      LookupResultField = 'SampleSize'
      KeyFields = 'Part'
      Lookup = True
    end
    object tblAdsConPartsPartCostedSize: TStringField
      FieldKind = fkLookup
      FieldName = 'PartCostedSize'
      LookupDataSet = tblAdsParts
      LookupKeyFields = 'Code'
      LookupResultField = 'CostedSize'
      KeyFields = 'Part'
      Lookup = True
    end
    object tblAdsConPartsPartMadeInPairs: TStringField
      FieldKind = fkLookup
      FieldName = 'PartMadeInPairs'
      LookupDataSet = tblAdsParts
      LookupKeyFields = 'Code'
      LookupResultField = 'MadeInPairs'
      KeyFields = 'Part'
      Lookup = True
    end
  end
  object qParts: TFDQuery
    IndexFieldNames = 'Code'
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRowsetSize]
    FetchOptions.RowsetSize = 3000
    SQL.Strings = (
      
        'SELECT Code, Description, SizeScale, SizeRange, CostedSize, Samp' +
        'leSize, MadeInPairs '
      'FROM Parts'
      'ORDER By Code')
    Left = 290
    Top = 121
    object qPartsCode: TStringField
      FieldName = 'Code'
      Origin = 'Code'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      FixedChar = True
    end
    object qPartsDescription: TStringField
      FieldName = 'Description'
      Origin = 'Description'
      FixedChar = True
      Size = 30
    end
    object qPartsSizeScale: TStringField
      FieldName = 'SizeScale'
      Origin = 'SizeScale'
      FixedChar = True
    end
    object qPartsSizeRange: TStringField
      FieldName = 'SizeRange'
      Origin = 'SizeRange'
      FixedChar = True
    end
    object qPartsCostedSize: TStringField
      FieldName = 'CostedSize'
      Origin = 'CostedSize'
      FixedChar = True
      Size = 10
    end
    object qPartsSampleSize: TStringField
      FieldName = 'SampleSize'
      Origin = 'SampleSize'
      FixedChar = True
      Size = 10
    end
    object qPartsMadeInPairs: TBooleanField
      FieldName = 'MadeInPairs'
      Origin = 'MadeInPairs'
    end
  end
  object tblConPartsTable: TFDTablePlus
    IndexName = 'PRIMARY'
    MasterSource = dsConstructions
    MasterFields = 'Construction'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'ConPARTS'
    TableName = 'ConPARTS'
    Left = 277
    Top = 336
    object tblConPartsTableConstruction: TStringField
      FieldName = 'Construction'
      Required = True
    end
    object tblConPartsTablePart: TStringField
      FieldName = 'Part'
      Required = True
    end
    object tblConPartsTableID: TIntegerField
      FieldName = 'ID'
    end
    object tblConPartsTableAltMaterial: TStringField
      FieldName = 'AltMaterial'
    end
    object tblConPartsTableUse: TBooleanField
      FieldName = 'Use'
    end
    object tblConPartsTablePartDescription: TStringField
      DisplayWidth = 30
      FieldKind = fkLookup
      FieldName = 'PartDescription'
      LookupDataSet = tblParts
      LookupKeyFields = 'Code'
      LookupResultField = 'Description'
      KeyFields = 'Part'
      Size = 30
      Lookup = True
    end
    object tblConPartsTablePartSizeScale: TStringField
      FieldKind = fkLookup
      FieldName = 'PartSizeScale'
      LookupDataSet = tblParts
      LookupKeyFields = 'Code'
      LookupResultField = 'SizeScale'
      KeyFields = 'Part'
      Lookup = True
    end
    object tblConPartsTablePartSizeRange: TStringField
      FieldKind = fkLookup
      FieldName = 'PartSizeRange'
      LookupDataSet = tblParts
      LookupKeyFields = 'Code'
      LookupResultField = 'SizeRange'
      KeyFields = 'Part'
      Lookup = True
    end
    object tblConPartsTablePartSampleSize: TStringField
      FieldKind = fkLookup
      FieldName = 'PartSampleSize'
      LookupDataSet = tblParts
      LookupKeyFields = 'Code'
      LookupResultField = 'SampleSize'
      KeyFields = 'Part'
      Lookup = True
    end
    object tblConPartsTablePartCostedSize: TStringField
      FieldKind = fkLookup
      FieldName = 'PartCostedSize'
      LookupDataSet = tblParts
      LookupKeyFields = 'Code'
      LookupResultField = 'CostedSize'
      KeyFields = 'Part'
      Lookup = True
    end
    object tblConPartsTablePartMadeInPairs: TBooleanField
      FieldKind = fkLookup
      FieldName = 'PartMadeInPairs'
      LookupDataSet = tblParts
      LookupKeyFields = 'Code'
      LookupResultField = 'MadeInPairs'
      KeyFields = 'Part'
      Lookup = True
    end
  end
  object dsPartsQ: TDataSource
    DataSet = qParts
    Left = 336
    Top = 144
  end
  object dsConPartsQuery: TDataSource
    DataSet = tblConPartsQuery
    Left = 343
    Top = 444
  end
  object tblConPartsQuery: TFDTablePlus
    IndexName = 'PRIMARY'
    MasterSource = dsConstructions
    MasterFields = 'Construction'
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRowsetSize]
    UpdateOptions.UpdateTableName = 'ConPARTS'
    TableName = 'ConPARTS'
    Left = 277
    Top = 424
    object StringField1: TStringField
      FieldName = 'Construction'
      Required = True
    end
    object StringField2: TStringField
      FieldName = 'Part'
      Required = True
    end
    object IntegerField1: TIntegerField
      FieldName = 'ID'
    end
    object StringField3: TStringField
      FieldName = 'AltMaterial'
    end
    object BooleanField1: TBooleanField
      FieldName = 'Use'
    end
    object StringField9: TStringField
      FieldKind = fkLookup
      FieldName = 'PartDescription2'
      LookupDataSet = qParts
      LookupKeyFields = 'Code'
      LookupResultField = 'Description'
      KeyFields = 'Part'
      Lookup = True
    end
    object StringField10: TStringField
      FieldKind = fkLookup
      FieldName = 'PartSizeScale2'
      LookupDataSet = qParts
      LookupKeyFields = 'Code'
      LookupResultField = 'SizeScale'
      KeyFields = 'Part'
      Lookup = True
    end
    object StringField11: TStringField
      FieldKind = fkLookup
      FieldName = 'PartSizeRange2'
      LookupDataSet = qParts
      LookupKeyFields = 'Code'
      LookupResultField = 'SizeRange'
      KeyFields = 'Part'
      Lookup = True
    end
    object StringField12: TStringField
      FieldKind = fkLookup
      FieldName = 'PartSampleSize2'
      LookupDataSet = qParts
      LookupKeyFields = 'Code'
      LookupResultField = 'SampleSize'
      KeyFields = 'Part'
      Lookup = True
    end
    object StringField13: TStringField
      FieldKind = fkLookup
      FieldName = 'PartCostedSize2'
      LookupDataSet = qParts
      LookupKeyFields = 'Code'
      LookupResultField = 'CostedSize'
      KeyFields = 'Part'
      Lookup = True
    end
    object StringField14: TStringField
      FieldKind = fkLookup
      FieldName = 'PartMadeInPairs2'
      LookupDataSet = qParts
      LookupKeyFields = 'Code'
      LookupResultField = 'MadeInPairs'
      KeyFields = 'Part'
      Lookup = True
    end
  end
  object dsConPartsNone: TDataSource
    DataSet = tblConPartsNone
    Left = 343
    Top = 540
  end
  object tblConPartsNone: TFDTablePlus
    IndexName = 'PRIMARY'
    MasterSource = dsConstructions
    MasterFields = 'Construction'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'ConPARTS'
    TableName = 'ConPARTS'
    Left = 277
    Top = 520
    object StringField15: TStringField
      FieldName = 'Construction'
      Required = True
    end
    object StringField16: TStringField
      FieldName = 'Part'
      Required = True
    end
    object IntegerField2: TIntegerField
      FieldName = 'ID'
    end
    object StringField17: TStringField
      FieldName = 'AltMaterial'
    end
    object BooleanField3: TBooleanField
      FieldName = 'Use'
    end
    object tblConPartsNonePartDescription3: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartDescription3'
      Calculated = True
    end
    object tblConPartsNonePartSizeScale3: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartSizeScale3'
      Calculated = True
    end
    object tblConPartsNonePartSizeRange3: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartSizeRange3'
      Calculated = True
    end
    object tblConPartsNonePartSampleSize3: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartSampleSize3'
      Calculated = True
    end
    object tblConPartsNonePartCostedSize3: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartCostedSize3'
      Calculated = True
    end
    object tblConPartsNonePartMadeInPairs3: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartMadeInPairs3'
      Calculated = True
    end
  end
  object dsConPartsNoneCalc: TDataSource
    DataSet = tblConPartsNoneCalc
    Left = 103
    Top = 532
  end
  object tblConPartsNoneCalc: TFDTablePlus
    OnCalcFields = tblConPartsNoneCalcCalcFields
    IndexName = 'PRIMARY'
    MasterSource = dsConstructions
    MasterFields = 'Construction'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'ConPARTS'
    TableName = 'ConPARTS'
    Left = 37
    Top = 512
    object StringField4: TStringField
      FieldName = 'Construction'
      Required = True
    end
    object StringField5: TStringField
      FieldName = 'Part'
      Required = True
    end
    object IntegerField3: TIntegerField
      FieldName = 'ID'
    end
    object StringField6: TStringField
      FieldName = 'AltMaterial'
    end
    object BooleanField2: TBooleanField
      FieldName = 'Use'
    end
    object StringField7: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartDescription3'
      Calculated = True
    end
    object StringField8: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartSizeScale3'
      Calculated = True
    end
    object StringField18: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartSizeRange3'
      Calculated = True
    end
    object StringField19: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartSampleSize3'
      Calculated = True
    end
    object StringField20: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartCostedSize3'
      Calculated = True
    end
    object StringField21: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartMadeInPairs3'
      Calculated = True
    end
  end
end
