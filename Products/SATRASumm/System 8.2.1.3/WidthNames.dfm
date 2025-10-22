object fmWidthNames: TfmWidthNames
  Left = 211
  Top = 121
  Caption = 'Width Names'
  ClientHeight = 287
  ClientWidth = 242
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dbgWidthNames: TDBGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 32
    Width = 236
    Height = 252
    Align = alClient
    BorderStyle = bsNone
    DataSource = dsWidths
    DrawingStyle = gdsClassic
    FixedColor = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clFuchsia
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'No'
        Width = 44
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Width'
        Width = 85
        Visible = True
      end>
  end
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 242
    Height = 29
    Align = alTop
    Color = clAqua
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object btnEdit: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 23
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
      Height = 23
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
      OnClick = btnCancelClick
    end
    object btnRefresh: TSpeedButton
      Left = 72
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
      OnClick = btnRefreshClick
    end
  end
  object pnlView1: TPanel
    Left = 0
    Top = 29
    Width = 242
    Height = 258
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object sgWidthNames: TXStringGridPlus
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 236
      Height = 252
      TabStop = False
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clAqua
      ColCount = 2
      DefaultRowHeight = 17
      DrawingStyle = gdsClassic
      FixedCols = 0
      RowCount = 14
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect]
      ParentFont = False
      TabOrder = 0
      OnSelectCell = sgWidthNamesSelectCell
      FixedLineColor = clBlack
      Columns = <
        item
          HeaderColor = clLime
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clFuchsia
          HeaderFont.Height = -11
          HeaderFont.Name = 'MS Sans Serif'
          HeaderFont.Style = []
          Caption = 'No'
          Color = clAqua
          Width = 44
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          EditorInheritsCellProps = False
        end
        item
          HeaderColor = clLime
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clFuchsia
          HeaderFont.Height = -11
          HeaderFont.Name = 'MS Sans Serif'
          HeaderFont.Style = []
          Caption = 'Width'
          Color = clAqua
          Width = 85
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          EditorInheritsCellProps = False
        end>
      MultiLine = False
      ImmediateEditMode = False
      ColWidths = (
        44
        85)
    end
  end
  object tblWidthNames: TFDTablePlus
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'WIDTHS'
    TableName = 'WIDTHS'
    Left = 291
    Top = 96
    object tblWidthNamesNo: TSmallintField
      FieldName = 'No'
    end
    object tblWidthNamesWidth: TStringField
      FieldName = 'Width'
      Size = 10
    end
  end
  object dsWidths: TDataSource
    DataSet = tblWidthNames
    Left = 304
    Top = 108
  end
  object LocalConnectionSumms: TFDConnectionPlus
    LoginPrompt = False
    AfterConnect = LocalConnectionSummsAfterConnect
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 290
    Top = 59
  end
end
