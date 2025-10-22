object fmKnifeDefaults: TfmKnifeDefaults
  Left = 366
  Top = 265
  BorderStyle = bsSingle
  Caption = 'Knife Defaults'
  ClientHeight = 199
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 386
    Height = 29
    Align = alTop
    Color = clAqua
    Enabled = False
    TabOrder = 0
    ExplicitWidth = 367
    object btnEdit: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Edit'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        330333333333333333F333333333333330F03333333333333F8F333333333300
        0F033333333333FFF8F330000000000FF0003FFFFFFFFFF88FFF30FFFFFFFF0F
        F0F03F88888888F88F8F30F77FF7770F0FF03F88888888F8F88F30F7C00CCC00
        FFF03F88888888FF888F30F700C0CCC7FFF03F8888888888888F30F7FF77FF77
        FFF03F8888888888888F30F777FF7777FFF03F8888888888888F30F777777777
        FFF03F8888888888888F30FFFFFFFFFFFFF03F8888888888888F300000000000
        00003FFFFFFFFFFFFFFF30704444444070703F8F8888888F8F8F300000000000
        00003FFFFFFFFFFFFFFF33333333333333333333333333333333}
      NumGlyphs = 2
      OnClick = btnEditClick
    end
    object btnSave: TSpeedButton
      Left = 26
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Save'
      Enabled = False
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
      OnClick = btnSaveClick
    end
    object btnCancel: TSpeedButton
      Left = 49
      Top = 0
      Width = 23
      Height = 25
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
      OnClick = btnCancelClick
    end
    object btnRefresh: TSpeedButton
      Left = 72
      Top = 0
      Width = 23
      Height = 25
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
      OnClick = btnRefreshClick
    end
  end
  object pnlTop: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 32
    Width = 380
    Height = 164
    Align = alClient
    BevelOuter = bvNone
    Color = clAqua
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    ExplicitTop = 8
    object lblPieces: TLabel
      Left = 8
      Top = 35
      Width = 32
      Height = 13
      Caption = 'Pieces'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblMatCats: TLabel
      Left = 8
      Top = 10
      Width = 56
      Height = 13
      Caption = 'Material Cat'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblCutGap: TLabel
      Left = 8
      Top = 60
      Width = 39
      Height = 13
      Caption = 'Cut Gap'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dbePieces: TDBEdit
      Left = 110
      Top = 32
      Width = 45
      Height = 21
      DataField = 'Pieces'
      DataSource = dsKnifeDefaults
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object dbcbCutGap: TDBComboBox
      Left = 110
      Top = 57
      Width = 45
      Height = 21
      Style = csDropDownList
      DataField = 'CutGap'
      DataSource = dsKnifeDefaults
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Items.Strings = (
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '10')
      ParentFont = False
      TabOrder = 2
    end
    object cbMatCat: TDBComboBox
      Left = 110
      Top = 7
      Width = 45
      Height = 22
      Style = csOwnerDrawFixed
      DataField = 'Type'
      DataSource = dsKnifeDefaults
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnDropDown = cbMatCatDropDown
    end
    object pnlView1: TPanel
      Left = 110
      Top = 0
      Width = 110
      Height = 100
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 4
      object dbtMaterialCat: TDBText
        Left = 0
        Top = 10
        Width = 95
        Height = 17
        DataField = 'MaterialType'
        DataSource = dsKnifeDefaults
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object dbtCutGap: TDBText
        Left = 0
        Top = 60
        Width = 45
        Height = 17
        Alignment = taRightJustify
        DataField = 'CutGap'
        DataSource = dsKnifeDefaults
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object dbtPieces: TDBText
        Left = 0
        Top = 35
        Width = 45
        Height = 17
        Alignment = taRightJustify
        DataField = 'Pieces'
        DataSource = dsKnifeDefaults
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnlCuttingTimes: TPanel
      Left = 221
      Top = 0
      Width = 142
      Height = 191
      BevelOuter = bvNone
      ParentBackground = False
      ParentColor = True
      TabOrder = 3
      object lblPunches: TLabel
        Left = 3
        Top = 60
        Width = 42
        Height = 13
        Caption = 'Punches'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblBands: TLabel
        Left = 3
        Top = 85
        Width = 30
        Height = 13
        Caption = 'Bands'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblMarks: TLabel
        Left = 3
        Top = 110
        Width = 29
        Height = 13
        Caption = 'Marks'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblClears: TLabel
        Left = 3
        Top = 135
        Width = 29
        Height = 13
        Caption = 'Clears'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object dbcbDoubleSidedQ: TDBCheckBox
        Left = 1
        Top = 10
        Width = 100
        Height = 17
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'Cuts L && R'
        DataField = 'DoubleSided'
        DataSource = dsKnifeDefaults
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object dbcbThinQ: TDBCheckBox
        Left = 1
        Top = 35
        Width = 100
        Height = 17
        TabStop = False
        Alignment = taLeftJustify
        Caption = 'Tool'
        DataField = 'Thin'
        DataSource = dsKnifeDefaults
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object dbePunches: TDBEdit
        Left = 87
        Top = 57
        Width = 45
        Height = 21
        DataField = 'Punches'
        DataSource = dsKnifeDefaults
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object dbeBands: TDBEdit
        Left = 87
        Top = 82
        Width = 45
        Height = 21
        DataField = 'Bands'
        DataSource = dsKnifeDefaults
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object dbeMarks: TDBEdit
        Left = 87
        Top = 107
        Width = 45
        Height = 21
        DataField = 'Marks'
        DataSource = dsKnifeDefaults
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object dbeClears: TDBEdit
        Left = 87
        Top = 132
        Width = 45
        Height = 21
        DataField = 'Clears'
        DataSource = dsKnifeDefaults
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
      object pnlView3: TPanel
        Left = 87
        Top = 0
        Width = 50
        Height = 162
        BevelOuter = bvNone
        Color = clAqua
        ParentBackground = False
        TabOrder = 2
        object dbtBands: TDBText
          Left = 1
          Top = 85
          Width = 45
          Height = 17
          Alignment = taRightJustify
          DataField = 'Bands'
          DataSource = dsKnifeDefaults
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtMarks: TDBText
          Left = 1
          Top = 110
          Width = 45
          Height = 17
          Alignment = taRightJustify
          DataField = 'Marks'
          DataSource = dsKnifeDefaults
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtClears: TDBText
          Left = 1
          Top = 135
          Width = 45
          Height = 17
          Alignment = taRightJustify
          DataField = 'Clears'
          DataSource = dsKnifeDefaults
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtCutsLRYesNo: TDBText
          Left = 0
          Top = 10
          Width = 45
          Height = 17
          Alignment = taRightJustify
          DataField = 'CutsLRYesNo'
          DataSource = dsKnifeDefaults
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtThinYesNo: TDBText
          Left = 0
          Top = 35
          Width = 45
          Height = 17
          Alignment = taRightJustify
          DataField = 'ThinsYesNo'
          DataSource = dsKnifeDefaults
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtPunches: TDBText
          Left = 1
          Top = 60
          Width = 45
          Height = 17
          Alignment = taRightJustify
          DataField = 'Punches'
          DataSource = dsKnifeDefaults
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
      end
    end
  end
  object LocalConnectionSumms: TFDConnectionPlus
    LoginPrompt = False
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 25
    Top = 136
  end
  object dsKnifeDefaults: TDataSource
    AutoEdit = False
    DataSet = tblKnifeDefaults
    Left = 79
    Top = 146
  end
  object tblKnifeDefaults: TFDTablePlus
    AfterOpen = tblKnifeDefaultsAfterOpen
    OnCalcFields = tblKnifeDefaultsCalcFields
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'KNFDFLTS'
    TableName = 'KNFDFLTS'
    Left = 62
    Top = 143
    object tblKnifeDefaultsType: TStringField
      FieldName = 'Type'
      Size = 1
    end
    object tblKnifeDefaultsCutGap: TSmallintField
      FieldName = 'CutGap'
    end
    object tblKnifeDefaultsPieces: TSmallintField
      FieldName = 'Pieces'
    end
    object tblKnifeDefaultsDoubleSided: TBooleanField
      FieldName = 'DoubleSided'
    end
    object tblKnifeDefaultsThin: TBooleanField
      FieldName = 'Thin'
    end
    object tblKnifeDefaultsPunches: TSmallintField
      FieldName = 'Punches'
    end
    object tblKnifeDefaultsBands: TFloatField
      FieldName = 'Bands'
      DisplayFormat = '0.00'
      EditFormat = '0.00'
    end
    object tblKnifeDefaultsMarks: TFloatField
      FieldName = 'Marks'
      DisplayFormat = '0.00'
      EditFormat = '0.00'
    end
    object tblKnifeDefaultsClears: TSmallintField
      FieldName = 'Clears'
    end
    object tblKnifeDefaultsMaterialType: TStringField
      FieldKind = fkCalculated
      FieldName = 'MaterialType'
      Size = 10
      Calculated = True
    end
    object tblKnifeDefaultsCutsLRYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'CutsLRYesNo'
      Size = 3
      Calculated = True
    end
    object tblKnifeDefaultsThinsYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'ThinsYesNo'
      Size = 3
      Calculated = True
    end
  end
  object qMatCats: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'SELECT * FROM MatCats')
    Left = 165
    Top = 117
    object qMatCatsCode: TStringField
      FieldName = 'Code'
      Size = 1
    end
  end
  object dsMatCats: TDataSource
    DataSet = qMatCats
    Left = 184
    Top = 150
  end
end
