object fmLayplan: TfmLayplan
  Left = 204
  Top = 119
  Caption = 'Interlocking Visualiser'
  ClientHeight = 899
  ClientWidth = 1016
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object imgInterlock: TImage
    Left = 480
    Top = 28
    Width = 536
    Height = 844
    Proportional = True
  end
  object tbMain: TToolBar
    Left = 0
    Top = 0
    Width = 1016
    Height = 29
    ButtonHeight = 23
    Color = clBtnFace
    EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
    EdgeOuter = esNone
    ParentColor = False
    TabOrder = 0
    object pnlSpacer1: TPanel
      Left = 0
      Top = 0
      Width = 3
      Height = 23
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
    end
    object btnAllKnives: TSpeedButton
      Left = 3
      Top = 0
      Width = 21
      Height = 23
      Hint = 'All Knives'
      AllowAllUp = True
      Flat = True
      Glyph.Data = {
        E6040000424DE604000000000000360000002800000014000000140000000100
        180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF000000E1DED5000000E1DED5E1DED5E1DED5E1DED50000
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
        0000000000000000E1DED5000000E1DED5E1DED5E1DED5E1DED5000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DE
        D5000000000000E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DED5000000
        000000E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000E1DED5E1
        DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000E1DED5E1DED5E1DE
        D5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF000000000000000000E1DED5E1DED5E1DED5E1DED5E1DED5
        000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF000000000000000000E1DED5E1DED5E1DED5E1DED5000000FFFFFFFF
        FFFFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000
        000000C1BBA8000000E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFF
        FF000000E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFF000000000000C1
        BBA8000000E1DED5E1DED5E1DED5E1DED5000000FFFFFF000000000000000000
        E1DED5E1DED5E1DED5E1DED5000000FFFFFF000000A79E85000000C1BBA80000
        00E1DED5E1DED5E1DED5E1DED5E1DED5000000000000000000E1DED5E1DED5E1
        DED5E1DED5E1DED5000000FFFFFF000000A79E85000000C1BBA8000000E1DED5
        E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DE
        D5E1DED5000000FFFFFF000000A79E85000000C1BBA8C1BBA8000000E1DED5E1
        DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5
        000000FFFFFF000000A79E85000000C1BBA8C1BBA8C1BBA8000000E1DED5E1DE
        D5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5000000FFFFFFFF
        FFFF000000A79E85A79E85000000C1BBA8C1BBA8C1BBA8000000E1DED5E1DED5
        E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFF0000
        00A79E85A79E85A79E85000000C1BBA8C1BBA8C1BBA800000000000000000000
        0000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000
        A79E85A79E85A79E85000000C1BBA8C1BBA8C1BBA8C1BBA8C1BBA8C1BBA8C1BB
        A8C1BBA8000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000A7
        9E85A79E85A79E85000000000000000000000000000000000000000000000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000A79E
        85A79E85A79E85A79E85A79E85A79E85A79E85A79E85000000FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
        000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnAllKnivesClick
    end
    object btnAllKnives2: TSpeedButton
      Left = 24
      Top = 0
      Width = 23
      Height = 23
      Hint = 'All Knives'
      AllowAllUp = True
      Flat = True
      Glyph.Data = {
        E6040000424DE604000000000000360000002800000014000000140000000100
        180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF000000E1DED5000000E1DED5E1DED5E1DED5E1DED50000
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
        0000000000000000E1DED5000000E1DED5E1DED5E1DED5E1DED5000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DE
        D5000000000000E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DED5000000
        000000E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000E1DED5E1
        DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000E1DED5E1DED5E1DE
        D5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF000000000000000000E1DED5E1DED5E1DED5E1DED5E1DED5
        000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF000000000000000000E1DED5E1DED5E1DED5E1DED5000000FFFFFFFF
        FFFFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000
        000000C1BBA8000000E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFF
        FF000000E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFF000000000000C1
        BBA8000000E1DED5E1DED5E1DED5E1DED5000000FFFFFF000000000000000000
        E1DED5E1DED5E1DED5E1DED5000000FFFFFF000000A79E85000000C1BBA80000
        00E1DED5E1DED5E1DED5E1DED5E1DED5000000000000000000E1DED5E1DED5E1
        DED5E1DED5E1DED5000000FFFFFF000000A79E85000000C1BBA8000000E1DED5
        E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DE
        D5E1DED5000000FFFFFF000000A79E85000000C1BBA8C1BBA8000000E1DED5E1
        DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5
        000000FFFFFF000000A79E85000000C1BBA8C1BBA8C1BBA8000000E1DED5E1DE
        D5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5000000FFFFFFFF
        FFFF000000A79E85A79E85000000C1BBA8C1BBA8C1BBA8000000E1DED5E1DED5
        E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFF0000
        00A79E85A79E85A79E85000000C1BBA8C1BBA8C1BBA800000000000000000000
        0000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000
        A79E85A79E85A79E85000000C1BBA8C1BBA8C1BBA8C1BBA8C1BBA8C1BBA8C1BB
        A8C1BBA8000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000A7
        9E85A79E85A79E85000000000000000000000000000000000000000000000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000A79E
        85A79E85A79E85A79E85A79E85A79E85A79E85A79E85000000FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
        000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnAllKnives2Click
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 29
    Width = 479
    Height = 870
    Align = alLeft
    TabOrder = 1
    object rgAutoTransfer: TRadioGroup
      Left = 391
      Top = 6
      Width = 82
      Height = 106
      Caption = 'Auto Transfer'
      ItemIndex = 2
      Items.Strings = (
        'None'
        'Main'
        'All')
      TabOrder = 1
      TabStop = True
    end
    object gbKnife: TGroupBox
      Left = 3
      Top = 118
      Width = 154
      Height = 167
      Caption = 'Knife'
      TabOrder = 2
      object imgKnife: TImage
        Left = 2
        Top = 15
        Width = 150
        Height = 150
        Align = alClient
        Proportional = True
        ExplicitLeft = 3
        ExplicitTop = 17
      end
    end
    object gbKnifeW1: TGroupBox
      Left = 161
      Top = 118
      Width = 154
      Height = 167
      Caption = 'Knife 1'
      TabOrder = 3
      object imgKnifeW1: TImage
        Left = 2
        Top = 15
        Width = 150
        Height = 150
        Align = alClient
        Proportional = True
        ExplicitLeft = 4
        ExplicitTop = 17
      end
    end
    object gbKnifeW2: TGroupBox
      Left = 319
      Top = 118
      Width = 154
      Height = 167
      Caption = 'Knife 2'
      TabOrder = 4
      object imgKnifeW2: TImage
        Left = 2
        Top = 15
        Width = 150
        Height = 150
        Align = alClient
        Proportional = True
        ExplicitLeft = 4
        ExplicitTop = 17
      end
    end
    object gbPresets: TGroupBox
      Left = 3
      Top = 6
      Width = 382
      Height = 106
      Caption = 'Set before loading knives'
      TabOrder = 0
      TabStop = True
      object Label1: TLabel
        Left = 150
        Top = 81
        Width = 219
        Height = 13
        Caption = '1/1000 ths of an inch (div by 2 && => Kerf (mm))'
      end
      object lblExpandBy: TLabel
        Left = 8
        Top = 79
        Width = 50
        Height = 13
        Caption = 'Expand by'
      end
      object btnCopyAngle: TButton
        Left = 73
        Top = 23
        Width = 75
        Height = 35
        Caption = '=>'
        TabOrder = 1
        OnClick = btnCopyAngleClick
      end
      object gbAngle1: TGroupBox
        Left = 5
        Top = 16
        Width = 53
        Height = 42
        Caption = 'Ang K1'
        TabOrder = 0
        object sedtAngle: TPBNumEdit
          Left = 8
          Top = 15
          Width = 38
          Height = 21
          Alignment = taRightJustify
          Decimals = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxLength = 5
          MaxValue = 360.000000000000000000
          MinValue = -360.000000000000000000
          NumberFormat = Standard
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbAngle2: TGroupBox
        Left = 161
        Top = 16
        Width = 53
        Height = 42
        Caption = 'Ang K2'
        TabOrder = 2
        object sedtAngle2: TPBNumEdit
          Left = 7
          Top = 15
          Width = 38
          Height = 21
          Alignment = taRightJustify
          Decimals = 1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxLength = 5
          MaxValue = 360.000000000000000000
          MinValue = -360.000000000000000000
          NumberFormat = Standard
          ParentFont = False
          TabOrder = 0
        end
      end
      object sedtExpand: TPBSpinEdit
        Left = 73
        Top = 76
        Width = 58
        Height = 22
        Cursor = crDefault
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxLength = 4
        MaxValue = 2000
        MinValue = 0
        ParentFont = False
        TabOrder = 3
        Value = 0
        Alignment = taLeftJustify
      end
      object gbMaterialSize: TGroupBox
        Left = 270
        Top = 16
        Width = 104
        Height = 42
        Caption = 'Material Size (m)'
        TabOrder = 4
        object Label5: TLabel
          Left = 57
          Top = 22
          Width = 8
          Height = 13
          Caption = 'w'
        end
        object Label4: TLabel
          Left = 7
          Top = 21
          Width = 6
          Height = 13
          Caption = 'h'
        end
        object eWidth: TEdit
          Left = 70
          Top = 16
          Width = 28
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          Text = '2'
        end
        object eHeight: TEdit
          Left = 16
          Top = 16
          Width = 28
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          Text = '2'
        end
      end
    end
    object gbAreas: TGroupBox
      Left = 3
      Top = 289
      Width = 284
      Height = 55
      Caption = 'Areas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      object lblGrossArea: TLabel
        Left = 40
        Top = 18
        Width = 60
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblGross: TLabel
        Left = 8
        Top = 18
        Width = 27
        Height = 13
        Caption = 'Gross'
      end
      object lblNett: TLabel
        Left = 8
        Top = 35
        Width = 20
        Height = 13
        Caption = 'Nett'
      end
      object lblNettArea: TLabel
        Left = 40
        Top = 35
        Width = 60
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblPrime: TLabel
        Left = 130
        Top = 18
        Width = 26
        Height = 13
        Caption = 'Prime'
      end
      object lblPrimeInterlockArea: TLabel
        Left = 212
        Top = 18
        Width = 60
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblNonPrime: TLabel
        Left = 130
        Top = 35
        Width = 49
        Height = 13
        Caption = 'Non Prime'
      end
      object lblNonPrimeInterlockArea: TLabel
        Left = 212
        Top = 35
        Width = 60
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object gbDrawingSettings: TGroupBox
      Left = 301
      Top = 620
      Width = 173
      Height = 157
      Caption = 'Drawing'
      TabOrder = 9
      object cbShowHulls: TCheckBox
        Left = 8
        Top = 59
        Width = 150
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show Hulls'
        TabOrder = 3
      end
      object cbShowExpansions: TCheckBox
        Left = 8
        Top = 44
        Width = 150
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show Expansions'
        TabOrder = 2
      end
      object cbShowBoundingRects: TCheckBox
        Left = 8
        Top = 14
        Width = 150
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show Bounding Rects'
        TabOrder = 0
      end
      object cbShowNumbers: TCheckBox
        Left = 8
        Top = 29
        Width = 150
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show Numbers'
        TabOrder = 1
      end
      object cbShowHullOverlaps: TCheckBox
        Left = 8
        Top = 74
        Width = 150
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show Hull Overlaps'
        TabOrder = 4
      end
      object cbShowMerges: TCheckBox
        Left = 8
        Top = 89
        Width = 150
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Show Merges'
        TabOrder = 5
      end
      object btnDraw: TButton
        Left = 48
        Top = 124
        Width = 75
        Height = 25
        Caption = 'Redraw'
        TabOrder = 7
        OnClick = btnDrawClick
      end
      object cbSimpleDraw: TCheckBox
        Left = 8
        Top = 104
        Width = 150
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Simple Draw'
        TabOrder = 6
      end
    end
    object gbSyntheticLayplanning: TGroupBox
      Left = 5
      Top = 347
      Width = 468
      Height = 273
      Caption = 'Synthetic Layplanning'
      TabOrder = 7
      object lblConcavityNumber: TLabel
        Left = 275
        Top = 55
        Width = 87
        Height = 13
        Caption = 'Concavity Number'
        Enabled = False
      end
      object rgRecipe: TRadioGroup
        Left = 8
        Top = 16
        Width = 262
        Height = 249
        Caption = 'Layplan Type'
        ItemIndex = 7
        Items.Strings = (
          'SQUARE HORIZONTAL'
          'SQUARE HORIZONTAL P2 INVERTED'
          'SQUARE VERTICAL'
          'SQUARE VERTICAL P2 INVERTED'
          'OFFSET HORIZONTAL TOP'
          'OFFSET HORIZONTAL BOTTOM'
          'OFFSET HORIZONTAL P2 INVERTED'
          'OFFSET VERTICAL LEFT'
          'OFFSET VERTICAL RIGHT'
          'OFFSET VERTICAL P2 INVERTED'
          'DIAGONAL HORIZONTAL'
          'DIAGONAL HORIZONTAL P2 INVERTED'
          'DIAGONAL VERTICAL'
          'DIAGONAL VERTICAL P2 INVERTED'
          'DIAGONAL FREE')
        TabOrder = 0
        TabStop = True
      end
      object btnSynthetics: TButton
        Left = 379
        Top = 240
        Width = 75
        Height = 25
        Caption = 'Do Layplan'
        TabOrder = 7
        OnClick = btnSyntheticsClick
      end
      object cbW2: TCheckBox
        Left = 275
        Top = 28
        Width = 175
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Line Inverted'
        TabOrder = 1
      end
      object eConcavityNumber: TEdit
        Left = 436
        Top = 52
        Width = 19
        Height = 21
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        Text = '0'
      end
      object rgStartingSide: TRadioGroup
        Left = 275
        Top = 115
        Width = 185
        Height = 40
        Caption = 'Starting side'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Left'
          'Right')
        TabOrder = 4
        TabStop = True
      end
      object rgCornerAnchoring: TRadioGroup
        Left = 275
        Top = 155
        Width = 185
        Height = 40
        Caption = 'Force corner anchoring'
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          'Yes'
          'No')
        TabOrder = 5
        TabStop = True
      end
      object rgStartingCriteria: TRadioGroup
        Left = 275
        Top = 195
        Width = 185
        Height = 40
        Caption = 'Starting criteria'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Preferred'
          'Fixed')
        TabOrder = 6
        TabStop = True
      end
      object gbGangStart: TGroupBox
        Left = 275
        Top = 75
        Width = 185
        Height = 40
        Caption = 'Gang Start'
        TabOrder = 3
        TabStop = True
        object rbNone: TRadioButton
          Left = 9
          Top = 17
          Width = 84
          Height = 17
          Caption = '1 (No Gangs)'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbNoneClick
        end
        object rbGangs2: TRadioButton
          Left = 95
          Top = 17
          Width = 30
          Height = 17
          Caption = '2'
          TabOrder = 1
          OnClick = rbGangsClick
        end
        object rbGangs3: TRadioButton
          Left = 140
          Top = 17
          Width = 30
          Height = 17
          Caption = '3'
          TabOrder = 2
          OnClick = rbGangsClick
        end
      end
    end
    object gbStepByStep: TGroupBox
      Left = 5
      Top = 620
      Width = 290
      Height = 132
      Caption = 'Step By Step'
      TabOrder = 8
      object btnW1: TButton
        Left = 11
        Top = 101
        Width = 75
        Height = 25
        Caption = 'W1'
        TabOrder = 2
        OnClick = btnW1Click
      end
      object btnW2: TButton
        Left = 92
        Top = 101
        Width = 75
        Height = 25
        Caption = 'W2'
        TabOrder = 3
        OnClick = btnW2Click
      end
      object btnW1W2: TButton
        Left = 173
        Top = 101
        Width = 107
        Height = 25
        Caption = 'Best of W1 + W2'
        TabOrder = 4
        OnClick = btnW1W2Click
      end
      object gbStops: TGroupBox
        Left = 192
        Top = 15
        Width = 87
        Height = 80
        Caption = 'Stops'
        TabOrder = 1
        TabStop = True
        object cbLeft: TCheckBox
          Left = 8
          Top = 15
          Width = 70
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Left'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbRight: TCheckBox
          Left = 8
          Top = 30
          Width = 70
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Right'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object cbTop: TCheckBox
          Left = 8
          Top = 45
          Width = 70
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Top'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object cbBottom: TCheckBox
          Left = 8
          Top = 61
          Width = 70
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Bottom'
          TabOrder = 3
        end
      end
      object gbInterlockSettings: TGroupBox
        Left = 11
        Top = 15
        Width = 175
        Height = 80
        Caption = 'Interlock Settings'
        TabOrder = 0
        TabStop = True
        object cbOriginalHullTakeOut: TCheckBox
          Left = 8
          Top = 15
          Width = 157
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Original Hull Take out ONLY'
          TabOrder = 0
          OnClick = cbOriginalHullTakeOutClick
        end
        object cbButt: TCheckBox
          Left = 8
          Top = 45
          Width = 157
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Butt'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object cbLeather: TCheckBox
          Left = 8
          Top = 30
          Width = 157
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Leather'
          TabOrder = 1
        end
        object cbSpeedRotate: TCheckBox
          Left = 8
          Top = 60
          Width = 157
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Speed Rotate'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = cbSpeedRotateClick
        end
      end
    end
    object gbNumberOfPatterns: TGroupBox
      Left = 295
      Top = 289
      Width = 175
      Height = 55
      Caption = 'Number of Patterns Layplanned'
      TabOrder = 6
      object lblNumPats: TLabel
        Left = 2
        Top = 26
        Width = 171
        Height = 27
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object dbDebugger: TGroupBox
      Left = 5
      Top = 803
      Width = 372
      Height = 60
      Caption = 'Debugger'
      TabOrder = 10
      object Zoom: TLabel
        Left = 281
        Top = 35
        Width = 27
        Height = 13
        Caption = 'Zoom'
      end
      object seDebuggerZoom: TPBSpinEdit
        Left = 316
        Top = 32
        Width = 43
        Height = 22
        Cursor = crDefault
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        MaxValue = 15
        MinValue = 1
        ParentFont = False
        TabOrder = 0
        Value = 1
        OnChange = seDebuggerZoomChange
        Alignment = taLeftJustify
      end
      object btnDebug: TButton
        Left = 186
        Top = 16
        Width = 80
        Height = 25
        Caption = 'Debug'
        TabOrder = 1
        OnClick = btnDebugClick
      end
      object cbTrueSize: TCheckBox
        Left = 277
        Top = 12
        Width = 82
        Height = 17
        Alignment = taLeftJustify
        Caption = 'True Size'
        TabOrder = 2
        OnClick = cbTrueSizeClick
      end
      object btnDrawInterlock: TButton
        Left = 88
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Draw Interlock'
        TabOrder = 3
        OnClick = btnDrawInterlockClick
      end
      object btnDescribe: TButton
        Left = 7
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Describe'
        TabOrder = 4
        OnClick = btnDescribeClick
      end
    end
    object gbLeatherInterlocking: TGroupBox
      Left = 5
      Top = 755
      Width = 290
      Height = 47
      Caption = 'Leather Interlocking'
      TabOrder = 11
      object btnSATRASummLeather: TButton
        Left = 8
        Top = 17
        Width = 60
        Height = 25
        Caption = 'Start'
        Enabled = False
        TabOrder = 0
        OnClick = btnSATRASummLeatherClick
      end
      object btnStep: TButton
        Left = 74
        Top = 17
        Width = 60
        Height = 25
        Caption = 'Step'
        Enabled = False
        TabOrder = 1
        OnClick = btnStepClick
      end
      object btnFinish: TButton
        Left = 140
        Top = 17
        Width = 60
        Height = 25
        Caption = 'Finish'
        Enabled = False
        TabOrder = 2
        OnClick = btnFinishClick
      end
      object btnCancel: TButton
        Left = 206
        Top = 17
        Width = 60
        Height = 25
        Caption = 'Cancel'
        Enabled = False
        TabOrder = 3
        OnClick = btnCancelClick
      end
    end
    object gbDiagFreeAngle: TGroupBox
      Left = 381
      Top = 803
      Width = 92
      Height = 60
      Caption = 'Diag Free Angle'
      TabOrder = 12
      object lblGetDiagonalFreeAngle: TLabel
        Left = 38
        Top = 44
        Width = 19
        Height = 13
        Alignment = taRightJustify
        Caption = '0.0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object btnDiagonalFreeAngle: TButton
        Left = 6
        Top = 16
        Width = 80
        Height = 25
        Caption = 'Find'
        TabOrder = 0
        OnClick = btnDiagonalFreeAngleClick
      end
    end
    object btnGang: TButton
      Left = 286
      Top = 587
      Width = 75
      Height = 25
      Caption = 'Gang'
      TabOrder = 13
      OnClick = btnGangClick
    end
  end
  object odBitmap: TOpenDialog
    DefaultExt = 'bmp'
    Left = 255
    Top = 4
  end
  object LocalConnectionSumms: TFDConnection
    Params.Strings = (
      'Alias=SATRASUMM8'
      'ServerTypes=Remote'
      'Protocol=TCPIP'
      'DriverID=ADS'
      'User_name=AdsSys'
      'Password=monster')
    LoginPrompt = False
    Left = 76
    Top = 1
  end
  object tblKnives: TFDTablePlus
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'KNIVES'
    TableName = 'KNIVES'
    Left = 139
    Top = 2
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
    object tblKnivesInterlockAreaPrimeSynthetic: TFloatField
      FieldName = 'InterlockAreaPrimeSynthetic'
    end
    object tblKnivesInterlockAreaNonPrime: TFloatField
      FieldName = 'InterlockAreaNonPrime'
    end
    object tblKnivesOldInterlockArea: TFloatField
      FieldKind = fkCalculated
      FieldName = 'OldInterlockArea'
      DisplayFormat = '0.000'
      EditFormat = '0.000'
      Calculated = True
    end
    object tblKnivesNewInterlockArea: TFloatField
      FieldKind = fkCalculated
      FieldName = 'NewInterlockArea'
      DisplayFormat = '0.000'
      EditFormat = '0.000'
      Calculated = True
    end
  end
  object qPatterns: TFDQuery
    Connection = LocalConnectionSumms
    SQL.Strings = (
      'SELECT * '
      'FROM Patterns '
      'WHERE Knife = :KnifeCode AND MeasuredSize = :Size'
      'Order By Seq, Seq')
    Left = 107
    Top = 1
    ParamData = <
      item
        Name = 'KnifeCode'
        DataType = ftString
        Value = ''
      end
      item
        Name = 'Size'
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
  object tblKnifeSets: TFDTablePlus
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'KNIFESETS'
    TableName = 'KNIFESETS'
    Left = 185
    Top = 3
    object tblKnifeSetsCode: TStringField
      FieldName = 'Code'
    end
    object tblKnifeSetsDescription: TStringField
      FieldName = 'Description'
      Size = 30
    end
    object tblKnifeSetsSizeScale: TStringField
      FieldName = 'SizeScale'
    end
    object tblKnifeSetsType: TStringField
      FieldName = 'Type'
      Size = 1
    end
    object tblKnifeSetsManualEntry: TBooleanField
      FieldName = 'ManualEntry'
    end
    object tblKnifeSetsCutGap: TSmallintField
      FieldName = 'CutGap'
    end
    object tblKnifeSetsDoubleSided: TBooleanField
      FieldName = 'DoubleSided'
    end
    object tblKnifeSetsThin: TBooleanField
      FieldName = 'Thin'
    end
    object tblKnifeSetsPieces: TSmallintField
      FieldName = 'Pieces'
    end
    object tblKnifeSetsPunches: TSmallintField
      FieldName = 'Punches'
    end
    object tblKnifeSetsClears: TSmallintField
      FieldName = 'Clears'
    end
    object tblKnifeSetsBands: TFloatField
      FieldName = 'Bands'
    end
    object tblKnifeSetsMarks: TFloatField
      FieldName = 'Marks'
    end
  end
  object dsKnives: TDataSource
    DataSet = tblKnives
    Left = 151
    Top = 9
  end
  object qParameters: TFDQuery
    AfterOpen = qParametersAfterOpen
    Connection = LocalConnectionSumms
    SQL.Strings = (
      
        'SELECT AutoCreateConstruction, AutoDeleteConstruction, BatchSize' +
        ', Company,'
      '  SplitTickets, SplittingScheme, CADDirectory, TicketsDirectory,'
      
        '  StylePicDirectory, DifficultLeatherFacilty, LinesinLeatherGrid' +
        ','
      '  RowsinLeatherGrid, TableLength, TitleFontName,'
      
        '  TitleFontSize, TitleFontCharset, StandardFontName, StandardFon' +
        'tSize,'
      
        '  StandardFontCharset, FixedFontName, FixedFontSize, FixedFontCh' +
        'arset,'
      
        '  PrintTagNumbers, PrintCustomer, PrintTimes, ShowBarCodeNPic, A' +
        'uditPathName,'
      
        '  OldAudit, ClearAuditAfterSave, IssuedCutWeek, TicketCostedAlw,' +
        ' SummarisedDetailed,'
      '  PrintCutterValue, CutterPageThrow, SaveOutBasic, ShowWaste,'
      
        '  GroupPrintSyntheticTickets, CreateSyntheticTicketsList, Update' +
        'dInitialisation,'
      
        '  InterlockingToleranceInterlock, InterlockingToleranceLayplans,' +
        ' MadeInPairsDefault,'
      '  MD.Units as MaterialDefaultUnits'
      'FROM Params, MatDflts MD'
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    Left = 219
    Top = 4
    object qParametersAutoCreateConstruction: TBooleanField
      FieldName = 'AutoCreateConstruction'
    end
    object qParametersAutoDeleteConstruction: TBooleanField
      FieldName = 'AutoDeleteConstruction'
    end
    object qParametersBatchSize: TSmallintField
      FieldName = 'BatchSize'
    end
    object qParametersCompany: TStringField
      FieldName = 'Company'
      Size = 30
    end
    object qParametersCADDirectory: TStringField
      FieldName = 'CADDirectory'
      Size = 50
    end
    object qParametersTicketsDirectory: TStringField
      FieldName = 'TicketsDirectory'
      Size = 50
    end
    object qParametersStylePicDirectory: TStringField
      FieldName = 'StylePicDirectory'
      Size = 50
    end
    object qParametersDifficultLeatherFacilty: TBooleanField
      FieldName = 'DifficultLeatherFacilty'
    end
    object qParametersLinesInLeatherGrid: TSmallintField
      FieldName = 'LinesInLeatherGrid'
    end
    object qParametersRowsInLeatherGrid: TSmallintField
      FieldName = 'RowsInLeatherGrid'
    end
    object qParametersTableLength: TFloatField
      FieldName = 'TableLength'
    end
    object qParametersTitleFontName: TStringField
      FieldName = 'TitleFontName'
      Size = 50
    end
    object qParametersTitleFontSize: TIntegerField
      FieldName = 'TitleFontSize'
    end
    object qParametersTitleFontCharset: TIntegerField
      FieldName = 'TitleFontCharset'
    end
    object qParametersStandardFontName: TStringField
      FieldName = 'StandardFontName'
      Size = 50
    end
    object qParametersStandardFontSize: TIntegerField
      FieldName = 'StandardFontSize'
    end
    object qParametersStandardFontCharset: TIntegerField
      FieldName = 'StandardFontCharset'
    end
    object qParametersFixedFontName: TStringField
      FieldName = 'FixedFontName'
      Size = 50
    end
    object qParametersFixedFontSize: TIntegerField
      FieldName = 'FixedFontSize'
    end
    object qParametersFixedFontCharset: TIntegerField
      FieldName = 'FixedFontCharset'
    end
    object qParametersPrintTagNumbers: TBooleanField
      FieldName = 'PrintTagNumbers'
    end
    object qParametersPrintCustomer: TBooleanField
      FieldName = 'PrintCustomer'
    end
    object qParametersPrintTimes: TBooleanField
      FieldName = 'PrintTimes'
    end
    object qParametersShowBarcodeNPic: TBooleanField
      FieldName = 'ShowBarcodeNPic'
    end
    object qParametersAuditPathName: TStringField
      FieldName = 'AuditPathName'
      Size = 60
    end
    object qParametersOldAudit: TBooleanField
      FieldName = 'OldAudit'
    end
    object qParametersIssuedCutWeek: TStringField
      FieldName = 'IssuedCutWeek'
      Size = 1
    end
    object qParametersTicketCostedAlw: TStringField
      FieldName = 'TicketCostedAlw'
      Size = 1
    end
    object qParametersSummarisedDetailed: TStringField
      FieldName = 'SummarisedDetailed'
      Size = 1
    end
    object qParametersPrintCutterValue: TBooleanField
      FieldName = 'PrintCutterValue'
    end
    object qParametersCutterPageThrow: TBooleanField
      FieldName = 'CutterPageThrow'
    end
    object qParametersSplitTickets: TBooleanField
      FieldName = 'SplitTickets'
    end
    object qParametersSplittingScheme: TSmallintField
      FieldName = 'SplittingScheme'
    end
    object qParametersSaveOutBasic: TStringField
      FieldName = 'SaveOutBasic'
      Size = 1
    end
    object qParametersMaterialDefaultUnits: TStringField
      FieldName = 'MaterialDefaultUnits'
    end
    object qParametersClearAuditAfterSave: TBooleanField
      FieldName = 'ClearAuditAfterSave'
    end
    object qParametersShowWaste: TBooleanField
      FieldName = 'ShowWaste'
    end
    object qParametersGroupPrintSyntheticTickets: TBooleanField
      FieldName = 'GroupPrintSyntheticTickets'
    end
    object qParametersCreateSyntheticTicketsList: TBooleanField
      FieldName = 'CreateSyntheticTicketsList'
    end
    object qParametersUpdatedInitialisation: TBooleanField
      FieldName = 'UpdatedInitialisation'
    end
    object qParametersInterlockingToleranceInterlock: TSmallintField
      FieldName = 'InterlockingToleranceInterlock'
    end
    object qParametersInterlockingToleranceLayplans: TSmallintField
      FieldName = 'InterlockingToleranceLayplans'
    end
    object qParametersMadeInPairsDefault: TBooleanField
      FieldName = 'MadeInPairsDefault'
    end
  end
  object odFullInterlockFile: TOpenDialog
    DefaultExt = 'txt'
    FileName = 'Full'
    Filter = 'Output File|*.TXT|All Files|*.*'
    Left = 101
    Top = 851
  end
  object odDescribe: TOpenDialog
    DefaultExt = 'txt'
    FileName = 'Patt'
    Filter = 'Output File|*.TXT|All Files|*.*'
    Title = 'Describe Pattern'
    Left = 37
    Top = 849
  end
  object FDPhysADSDriverLink1: TFDPhysADSDriverLink
    Left = 343
    Top = 195
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrDefault
    Left = 399
    Top = 211
  end
end
