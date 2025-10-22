object fmManualKnifeCheck: TfmManualKnifeCheck
  Left = 356
  Top = 215
  Caption = 'Manual Knives Check'
  ClientHeight = 286
  ClientWidth = 456
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
    Width = 456
    Height = 29
    Align = alTop
    Color = clAqua
    TabOrder = 0
    object btnRefresh: TSpeedButton
      Left = 3
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
  object dbgManualKnives: TDBGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 86
    Width = 450
    Height = 197
    Align = alClient
    BorderStyle = bsNone
    Color = clAqua
    DataSource = dsManualKnives
    DrawingStyle = gdsClassic
    FixedColor = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clFuchsia
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgManualKnivesDblClick
    OnKeyPress = dbgManualKnivesKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'KnifeCode'
        Title.Caption = 'Knife'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PartCode'
        Title.Caption = 'Part'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MType'
        Title.Caption = ' '
        Width = 71
        Visible = True
      end>
  end
  object pnlHeader: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 32
    Width = 450
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    Color = clAqua
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object lblNote: TLabel
      Left = 0
      Top = 0
      Width = 376
      Height = 48
      Align = alClient
      Caption = 
        'The following Knives are manually entered. Those on synthetic Pa' +
        'rts are marked. Without the knife shapes you will not be able to' +
        ' assess these Knives for synthetics once the legacy feature is r' +
        'emoved.'
      WordWrap = True
      ExplicitWidth = 366
      ExplicitHeight = 39
    end
    object gbManualCount: TGroupBox
      Left = 376
      Top = 0
      Width = 74
      Height = 48
      Align = alRight
      Caption = 'Synthetics'
      TabOrder = 0
      object lblCount: TLabel
        Left = 2
        Top = 15
        Width = 70
        Height = 31
        Align = alClient
        Alignment = taCenter
        Caption = '999'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 30
        ExplicitHeight = 24
      end
    end
  end
  object qManualKnives: TFDQueryPlus
    AfterOpen = qManualKnivesAfterOpen
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      
        'SELECT DISTINCT KS.Code as KnifeCode, P.Code as PartCode, CAST(I' +
        'IF((M.Type = '#39'S'#39') OR (M.Type = '#39'R'#39'), '#39'Synthetic'#39', '#39#39') as SQL_CHA' +
        'R) as MType'
      'FROM KnifeSets KS, Parts P, Material M, PtWidKnf PWK'
      'WHERE P.Code = PWK.Part AND M.Code = P.Material AND'
      '      KS.Code = PWK.Knife AND KS.ManualEntry = True'
      'Order By KS.Code, KS.Code, P.Code')
    Left = 30
    Top = 56
    object qManualKnivesKnifeCode: TStringField
      FieldName = 'KnifeCode'
    end
    object qManualKnivesPartCode: TStringField
      FieldName = 'PartCode'
    end
    object qManualKnivesMType: TStringField
      FieldName = 'MType'
      Size = 9
    end
  end
  object dsManualKnives: TDataSource
    DataSet = qManualKnives
    Left = 42
    Top = 73
  end
  object qCount: TFDQueryPlus
    AfterOpen = qManualKnivesAfterOpen
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'SELECT COUNT(DISTINCT (KS.Code)) as KnifeCount'
      'FROM KnifeSets KS, Parts P, Material M, PtWidKnf PWK'
      
        'WHERE P.Code = PWK.Part AND M.Code = P.Material AND (M.Type = '#39'R' +
        #39' OR M.Type = '#39'S'#39') AND'
      '      KS.Code = PWK.Knife AND KS.ManualEntry = True')
    Left = 86
    Top = 56
    object qCountKnifeCount: TIntegerField
      FieldName = 'KnifeCount'
    end
  end
end
