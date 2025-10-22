object fmConstructionAllowanceFull: TfmConstructionAllowanceFull
  Left = 143
  Top = 218
  BorderIcons = [biSystemMenu]
  Caption = 'All allowances for Construction'
  ClientHeight = 361
  ClientWidth = 891
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCalculating: TPanel
    Left = 0
    Top = 0
    Width = 891
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object pnlTitles: TPanel
      Left = 0
      Top = 0
      Width = 89
      Height = 49
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblProgressWidths: TLabel
        Left = 5
        Top = 5
        Width = 28
        Height = 13
        Caption = 'Width'
      end
      object lblProgressConstruction: TLabel
        Left = 5
        Top = 30
        Width = 59
        Height = 13
        Caption = 'Construction'
      end
    end
    object pnlProgressBars: TPanel
      Left = 89
      Top = 0
      Width = 802
      Height = 49
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object pbWidth: TProgressBar
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 796
        Height = 17
        Align = alTop
        TabOrder = 0
      end
      object pbConstruction: TProgressBar
        AlignWithMargins = True
        Left = 3
        Top = 29
        Width = 796
        Height = 17
        Align = alBottom
        TabOrder = 1
      end
    end
  end
  object sgSampleResults: TXStringGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 52
    Width = 885
    Height = 306
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clAqua
    ColCount = 4
    DefaultRowHeight = 17
    DrawingStyle = gdsClassic
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentFont = False
    TabOrder = 1
    FixedLineColor = clSilver
    SelectedColor = clAqua
    SelectedTextColor = clWindowText
    Columns = <
      item
        HeaderColor = clLime
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clFuchsia
        HeaderFont.Height = -11
        HeaderFont.Name = 'MS Sans Serif'
        HeaderFont.Style = []
        HeaderAlignment = taCenter
        Color = clAqua
        Width = 60
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
        HeaderAlignment = taCenter
        Color = clAqua
        Width = 200
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
        HeaderAlignment = taCenter
        Color = clAqua
        Width = 200
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
        HeaderAlignment = taCenter
        Color = clAqua
        Width = 100
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
      60
      200
      200
      100)
  end
  object qWidths: TFDQueryPlus
    AfterOpen = qWidthsAfterOpen
    Connection = fmSumms.ConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT W.No, W.Width, C.SampleSize, COUNT(W.No) AS CommonIn'
      'FROM ConParts CP, Parts P, WRngWs WRW, Widths W, Construc C'
      
        'WHERE C.Construction = :Code AND CP.Construction = C.Constructio' +
        'n AND P.Code = CP.Part AND WRW.Range = P.WidthRange AND'
      '      W.No = WRW.WidthNo'
      'GROUP BY W.No, W.Width, C.SampleSize'
      'HAVING COUNT(W.NO) = (SELECT COUNT(Part)'
      '                      FROM ConParts'
      '                      WHERE Construction = :Code)'
      'Order By W.No, W.No'
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    Left = 760
    Top = 225
    ParamData = <
      item
        Name = 'Code'
        ParamType = ptInput
      end>
    object qWidthsNo: TSmallintField
      FieldName = 'No'
    end
    object qWidthsWidth: TStringField
      FieldName = 'Width'
      Size = 10
    end
    object qWidthsSampleSize: TStringField
      FieldName = 'SampleSize'
      Size = 10
    end
    object qWidthsCommonIn: TIntegerField
      FieldName = 'CommonIn'
    end
  end
  object qParts: TFDQueryPlus
    AfterOpen = qPartsAfterOpen
    Connection = fmSumms.ConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      
        'SELECT C.Construction, CP.ID, CP.Part, CP.AltMaterial, C.SampleS' +
        'ize,'
      '       C.CostedSize, P.SLMAllowance, C.MadeInPairs'
      'FROM Construc C, ConParts CP, Parts P'
      
        'WHERE C.Construction = :Code AND CP.Construction = C.Constructio' +
        'n AND'
      '      P.Code = CP.Part'
      ''
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    Left = 763
    Top = 161
    ParamData = <
      item
        Name = 'Code'
        ParamType = ptInput
      end>
  end
  object qSizes: TFDQueryPlus
    AfterOpen = qSizesAfterOpen
    Connection = fmSumms.ConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT SRS.Seq, SRS.Size'
      'FROM SizeRangeSizes SRS, Construc C'
      'WHERE (C.Construction = :Code) AND'
      '      (SRS.Scale = C.SizeScale) AND'
      '      (SRS.Range = C.SizeRange)'
      'ORDER BY Seq'
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    Left = 760
    Top = 289
    ParamData = <
      item
        Name = 'CODE'
        DataType = ftString
        ParamType = ptInput
        Value = 'WK706BK2/PROD3'
      end>
    object qSizesSeq: TFloatField
      FieldName = 'Seq'
      Origin = 'Seq'
    end
    object qSizesSize: TStringField
      FieldName = 'Size'
      Origin = 'Size'
      FixedChar = True
      Size = 10
    end
    object qSizesNo: TSmallintField
      FieldKind = fkInternalCalc
      FieldName = 'No'
    end
  end
  object sdFileOut: TSaveDialog
    DefaultExt = 'SAA'
    Filter = 'Text files (*.txt)|*.TXT'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 658
    Top = 162
  end
end
