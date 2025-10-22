object fmSystemStatus: TfmSystemStatus
  Left = 380
  Top = 238
  BorderStyle = bsSingle
  Caption = 'System Status'
  ClientHeight = 230
  ClientWidth = 343
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
  PixelsPerInch = 96
  TextHeight = 13
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 343
    Height = 29
    Align = alTop
    Color = clAqua
    Enabled = False
    TabOrder = 0
    ExplicitWidth = 345
    object btnRefresh: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 22
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
  object pnlWhole: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 32
    Width = 337
    Height = 195
    Align = alClient
    BevelOuter = bvNone
    Color = clAqua
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 339
    ExplicitHeight = 185
    object lblConstructions: TLabel
      Left = 15
      Top = 10
      Width = 64
      Height = 13
      Caption = 'Constructions'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblCutters: TLabel
      Left = 15
      Top = 35
      Width = 33
      Height = 13
      Caption = 'Cutters'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblCutterLocations: TLabel
      Left = 15
      Top = 60
      Width = 77
      Height = 13
      Caption = 'Cutter Locations'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblKnives: TLabel
      Left = 15
      Top = 85
      Width = 32
      Height = 13
      Caption = 'Knives'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblMaterials: TLabel
      Left = 15
      Top = 110
      Width = 42
      Height = 13
      Caption = 'Materials'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblParts: TLabel
      Left = 15
      Top = 135
      Width = 24
      Height = 13
      Caption = 'Parts'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblSizeRanges: TLabel
      Left = 15
      Top = 160
      Width = 60
      Height = 13
      Caption = 'Size Ranges'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblSizeRelationships: TLabel
      Left = 170
      Top = 10
      Width = 86
      Height = 13
      Caption = 'Size Relationships'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblSizeScales: TLabel
      Left = 170
      Top = 35
      Width = 55
      Height = 13
      Caption = 'Size Scales'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblStyles: TLabel
      Left = 170
      Top = 60
      Width = 28
      Height = 13
      Caption = 'Styles'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblSuppliers: TLabel
      Left = 170
      Top = 85
      Width = 43
      Height = 13
      Caption = 'Suppliers'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblTickets: TLabel
      Left = 170
      Top = 110
      Width = 35
      Height = 13
      Caption = 'Tickets'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblWidths: TLabel
      Left = 170
      Top = 135
      Width = 33
      Height = 13
      Caption = 'Widths'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblWidthRanges: TLabel
      Left = 170
      Top = 160
      Width = 68
      Height = 13
      Caption = 'Width Ranges'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 110
      Top = 10
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 110
      Top = 35
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 110
      Top = 60
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 110
      Top = 85
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 110
      Top = 110
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label5'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 110
      Top = 135
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 110
      Top = 160
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label7'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 265
      Top = 10
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label8'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 265
      Top = 35
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label9'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 265
      Top = 60
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label10'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 265
      Top = 85
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label11'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 265
      Top = 110
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label12'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 265
      Top = 135
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label13'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 265
      Top = 160
      Width = 45
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Label14'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object qSum: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'SELECT 1 as Idx, COUNT(*) as Total FROM Construc'
      'UNION'
      'SELECT 2 as Idx, COUNT(*) as Total FROM Cutters'
      'UNION'
      'SELECT 3 as Idx, COUNT(*) as Total FROM CutLocs'
      'UNION'
      'SELECT 4 as Idx, COUNT(*) as Total FROM Knives'
      'UNION'
      'SELECT 5 as Idx, COUNT(*) as Total FROM Material'
      'UNION'
      'SELECT 6 as Idx, COUNT(*) as Total FROM Parts'
      'UNION'
      'SELECT 7 as Idx, COUNT(*) as Total FROM SizeRanges'
      'UNION'
      'SELECT 8 as Idx, COUNT(*) as Total FROM SizeRelationships'
      'UNION'
      'SELECT 9 as Idx, COUNT(*) as Total FROM SizeScales'
      'UNION'
      'SELECT 10 as Idx, COUNT(*) as Total FROM Styles'
      'UNION'
      'SELECT 11 as Idx, COUNT(*) as Total FROM Supplier'
      'UNION'
      'SELECT 12 as Idx, COUNT(*)  - 1 as Total FROM TicketSequences'
      'UNION'
      'SELECT 13 as Idx, COUNT(*) as Total FROM Widths'
      'UNION'
      'SELECT 14 as Idx, COUNT(*) as Total FROM WRngs'
      '')
    Left = 35
    Top = 6
    object qSumIdx: TIntegerField
      FieldName = 'Idx'
    end
    object qSumTotal: TIntegerField
      FieldName = 'Total'
    end
  end
end
