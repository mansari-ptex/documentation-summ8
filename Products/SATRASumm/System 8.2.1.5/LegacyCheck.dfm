object fmLegacyCheck: TfmLegacyCheck
  Left = 437
  Top = 172
  Caption = 'Legacy Check'
  ClientHeight = 562
  ClientWidth = 466
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
  object Splitter1: TSplitter
    Left = 0
    Top = 294
    Width = 466
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 288
  end
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 466
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
  object dbgLegacySynthetics: TDBGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 93
    Width = 460
    Height = 198
    Align = alTop
    BorderStyle = bsNone
    Color = clAqua
    DataSource = dsLegacySynthetics
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
    OnDblClick = dbgLegacySyntheticsDblClick
    OnKeyPress = dbgLegacySyntheticsKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'Code'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Description'
        Width = 262
        Visible = True
      end>
  end
  object pnlHeader: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 32
    Width = 460
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    Color = clAqua
    ParentBackground = False
    TabOrder = 1
    object lblNote: TLabel
      Left = 0
      Top = 0
      Width = 290
      Height = 55
      Align = alClient
      Caption = 
        'The following Parts are using Legacy Synthetics. It is recommend' +
        'ed that you change these to use the Full Synthetic system and th' +
        'en contact SATRA to turn off Legacy Synthetics. This will optimi' +
        'se your SATRASumm system.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 288
      ExplicitHeight = 52
    end
    object gbTotals: TGroupBox
      Left = 400
      Top = 0
      Width = 60
      Height = 55
      Align = alRight
      Caption = 'Parts'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object lblCount: TLabel
        Left = 2
        Top = 15
        Width = 56
        Height = 38
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
    object rgDoubleClick: TRadioGroup
      Left = 290
      Top = 0
      Width = 110
      Height = 55
      Align = alRight
      Caption = 'Double Click'
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Open'
        'Remove Legacy')
      ParentBackground = False
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
  end
  object pnlHeader2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 300
    Width = 460
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    Color = clAqua
    ParentBackground = False
    TabOrder = 3
    ExplicitTop = 297
    object lblNote2: TLabel
      Left = 0
      Top = 0
      Width = 400
      Height = 55
      Align = alClient
      Caption = 
        'The following Knives have non-zero Cut Gaps. It is recommended t' +
        'hat you set Cut Gaps on Materials, where necessary, and zero all' +
        ' Cut Gaps on Knives. It is not possible to generate Allowances f' +
        'or Leather Parts which have Knives with non-zero Cut Gaps. Leath' +
        'er Knives with Cut Gaps should be zeroed urgently.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 395
      ExplicitHeight = 52
    end
    object gbTotals2: TGroupBox
      Left = 400
      Top = 0
      Width = 60
      Height = 55
      Align = alRight
      Caption = 'Knives '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object lblCount2: TLabel
        Left = 2
        Top = 15
        Width = 56
        Height = 38
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
  object dbgKnivesWithCutGap: TDBGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 361
    Width = 460
    Height = 198
    Align = alClient
    BorderStyle = bsNone
    Color = clAqua
    DataSource = dsKnivesWithCutGap
    DrawingStyle = gdsClassic
    FixedColor = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clFuchsia
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgKnivesWithCutGapDblClick
    OnKeyPress = dbgKnivesWithCutGapKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'Code'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Description'
        Width = 210
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Leather'
        Title.Caption = ' '
        Width = 50
        Visible = True
      end>
  end
  object qLegacySynthetics: TFDQueryPlus
    AfterOpen = qLegacySyntheticsAfterOpen
    Connection = fmSumms.ConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT P.Code, P.Description'
      'FROM PARTS P, MATERIAL M'
      'WHERE (P.SLMAllowance = True) AND '
      '      (M.Code = P.Material) AND '
      #9'  ((M.Type = '#39'R'#39') OR (M.Type = '#39'S'#39'))'
      'Order By P.Code, P.Code')
    Left = 30
    Top = 56
    object qLegacySyntheticsCode: TStringField
      FieldName = 'Code'
    end
    object qLegacySyntheticsDescription: TStringField
      FieldName = 'Description'
      Size = 30
    end
  end
  object dsLegacySynthetics: TDataSource
    DataSet = qLegacySynthetics
    Left = 42
    Top = 73
  end
  object qKnivesWithCutGap: TFDQueryPlus
    AfterOpen = qKnivesWithCutGapAfterOpen
    Connection = fmSumms.ConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      
        'SELECT DISTINCT KS.Code, KS.Description, IIF((M.Type = '#39'L'#39') OR (' +
        'M.Type = '#39'K'#39') OR (M.Type = '#39'W'#39'), '#39'Leather'#39', '#39#39') as Leather'
      'FROM Parts P, PtWidKnf PWK, KnifeSets KS, Material M'
      
        'WHERE P.Material = M.Code AND PWK.Part = P.Code AND KS.Code = PW' +
        'K.Knife AND KS.Cutgap > 0 '
      'Order By Leather, Leather DESC, KS.Code ASC')
    Left = 6
    Top = 480
    object qKnivesWithCutGapCode: TStringField
      FieldName = 'Code'
    end
    object qKnivesWithCutGapDescription: TStringField
      FieldName = 'Description'
      Size = 30
    end
    object qKnivesWithCutGapLeather: TStringField
      FieldName = 'Leather'
      Size = 3
    end
  end
  object dsKnivesWithCutGap: TDataSource
    DataSet = qKnivesWithCutGap
    Left = 26
    Top = 489
  end
end
