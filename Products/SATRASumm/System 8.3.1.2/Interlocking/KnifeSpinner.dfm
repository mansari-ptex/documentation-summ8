object fmKnifeSpinner: TfmKnifeSpinner
  Left = 550
  Top = 323
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Knife Orientation'
  ClientHeight = 566
  ClientWidth = 295
  Color = clBtnFace
  Constraints.MinHeight = 591
  Constraints.MinWidth = 301
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001000800680500001600000028000000100000002000
    00000100080000000000000000000000000000000000000000000000000000FF
    FF00080800001818000000000000636300008484000029290000525200009CA5
    000039390000101000008C940000636B0000737B00007B7B0000737300005A5A
    00008C8C00002121000094940000313100006B6B00004A4A00007B8400009494
    0000949C00009CA5000000D6D60000DED60008E7D60018F7D60000FFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
    00000000000000000000000000000008081702010E0808080808080808080015
    080903030608080C1308080D0508000A150903030608040A1108081606110003
    0A01030301120A03050908160302000A03030303030303040203091601030015
    0303030303030103030303091203000512030303030303030303030303030008
    0703030303030303030303030303000811060303031414030303030303010008
    081312031410010303030303030E00080808060208100A120303011201050008
    080E02010F0F0F080A03090810110008080903030608080C0103020D08080007
    080903030608040A03030302090B000102010303010201040505050506020000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlLayplans: TPanel
    Left = 0
    Top = 29
    Width = 295
    Height = 537
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object pnlPatternTop: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 289
      Height = 106
      Align = alTop
      BevelOuter = bvNone
      Color = clAqua
      ParentBackground = False
      TabOrder = 0
      object lblNettArea2: TLabel
        Left = 50
        Top = 85
        Width = 40
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblNettArea1: TLabel
        Left = 50
        Top = 60
        Width = 40
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblNettAreaUnits1: TLabel
        Left = 100
        Top = 60
        Width = 9
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblNettAreaUnits2: TLabel
        Left = 100
        Top = 85
        Width = 9
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblKnifeAreaText: TLabel
        Left = 8
        Top = 60
        Width = 22
        Height = 13
        Caption = 'Area'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblKnifeSizeText: TLabel
        Left = 8
        Top = 35
        Width = 20
        Height = 13
        Caption = 'Size'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblKnifeCodeText: TLabel
        Left = 8
        Top = 10
        Width = 24
        Height = 13
        Caption = 'Knife'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblKnifeSize: TLabel
        Left = 50
        Top = 35
        Width = 3
        Height = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblKnifeCode: TLabel
        Left = 50
        Top = 10
        Width = 3
        Height = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblUnitsText: TLabel
        Left = 200
        Top = 10
        Width = 24
        Height = 13
        Caption = 'Units'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object cbUnitsKnife: TComboBox
        Left = 233
        Top = 7
        Width = 48
        Height = 21
        Style = csDropDownList
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = cbUnitsKnifeChange
      end
      object cbGrid: TCheckBox
        Left = 198
        Top = 35
        Width = 82
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Grid'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = cbGridClick
      end
    end
    object pnlPatternControls: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 410
      Width = 289
      Height = 122
      Align = alTop
      BevelOuter = bvNone
      Color = clAqua
      ParentBackground = False
      TabOrder = 1
      object shpWheel: TShape
        Left = 110
        Top = 45
        Width = 70
        Height = 70
        Brush.Color = clLime
        Shape = stCircle
        OnMouseDown = shpWheelMouseDown
        OnMouseMove = shpWheelMouseMove
        OnMouseUp = shpWheelMouseUp
      end
      object shpWheelHandle: TShape
        Left = 161
        Top = 66
        Width = 10
        Height = 10
        Brush.Color = clYellow
        Shape = stCircle
      end
      object imgRotatedKnife: TImage
        Left = 15
        Top = 78
        Width = 43
        Height = 44
        Center = True
        Proportional = True
        Visible = False
      end
      object shpActualAngle0: TShape
        Left = 147
        Top = 100
        Width = 4
        Height = 4
        Brush.Color = clYellow
        Shape = stCircle
      end
      object shpActualAngle10: TShape
        Left = 160
        Top = 100
        Width = 4
        Height = 4
        Brush.Color = clYellow
        Shape = stCircle
      end
      object shpActualAngle15: TShape
        Left = 157
        Top = 100
        Width = 4
        Height = 4
        Brush.Color = clYellow
        Shape = stCircle
      end
      object shpActualAngle20: TShape
        Left = 168
        Top = 100
        Width = 4
        Height = 4
        Brush.Color = clYellow
        Shape = stCircle
      end
      object shpActualAngle25: TShape
        Left = 165
        Top = 100
        Width = 4
        Height = 4
        Brush.Color = clYellow
        Shape = stCircle
      end
      object shpActualAngle5: TShape
        Left = 152
        Top = 100
        Width = 4
        Height = 4
        Brush.Color = clYellow
        Shape = stCircle
      end
      object lblWheelHelp1: TLabel
        Left = 39
        Top = 31
        Width = 15
        Height = 13
        Caption = 'Ctrl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
      end
      object lblWheelHelp2: TLabel
        Left = 140
        Top = 31
        Width = 12
        Height = 13
        Caption = 'Alt'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
      end
      object lblWheelHelp3: TLabel
        Left = 234
        Top = 31
        Width = 15
        Height = 13
        Caption = 'Ctrl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
      end
      object lblAdjustmentAngle: TLabel
        Left = 229
        Top = 66
        Width = 33
        Height = 27
        Alignment = taRightJustify
        Caption = '0.0'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object imgDegrees: TImage
        Left = 264
        Top = 66
        Width = 12
        Height = 12
        Picture.Data = {
          07544269746D61700A020000424D0A0200000000000036000000280000000C00
          00000D0000000100180000000000D40100000000000000000000000000000000
          0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0AFAFAF75757500000000000075
          7575AFAFAFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0AFAFAF3B3B3B000000000000
          0000000000003B3B3BAFAFAFC0C0C0C0C0C0C0C0C0C0C0C07575750000007E7E
          7EC0C0C0C0C0C07E7E7E000000757575C0C0C0C0C0C0C0C0C0C0C0C03B3B3B00
          0000B5B5B5C0C0C0C0C0C0B5B5B50000003B3B3BC0C0C0C0C0C0C0C0C0C0C0C0
          000000000000C0C0C0C0C0C0C0C0C0C0C0C0000000000000C0C0C0C0C0C0C0C0
          C0C0C0C03B3B3B000000B5B5B5C0C0C0C0C0C0B5B5B50000003B3B3BC0C0C0C0
          C0C0C0C0C0C0C0C07575750000007E7E7EC0C0C0C0C0C07E7E7E000000757575
          C0C0C0C0C0C0C0C0C0C0C0C0AFAFAF3B3B3B0000000000000000000000003B3B
          3BAFAFAFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0AFAFAF75757500000000000075
          7575AFAFAFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
        Transparent = True
      end
      object pnlInitialAngle: TPanel
        Left = 0
        Top = 0
        Width = 290
        Height = 25
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object btnNudgeLeft10: TColButton
          Left = 1
          Top = 0
          Width = 48
          Height = 25
          Caption = '< < <'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = btnNudgeLeft10Click
          Color = clLime
          FrameSize = 1
          FrameColor = clBtnHighlight
          FrameShadowColor = clBtnShadow
        end
        object btnNudgeLeft1: TColButton
          Left = 49
          Top = 0
          Width = 48
          Height = 25
          Caption = '< <'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btnNudgeLeft1Click
          Color = clLime
          FrameSize = 1
          FrameColor = clBtnHighlight
          FrameShadowColor = clBtnShadow
        end
        object btnNudgeLeftPoint1: TColButton
          Left = 97
          Top = 0
          Width = 48
          Height = 25
          Caption = '<'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = btnNudgeLeftPoint1Click
          Color = clLime
          FrameSize = 1
          FrameColor = clBtnHighlight
          FrameShadowColor = clBtnShadow
        end
        object btnNudgeRight10: TColButton
          Left = 241
          Top = 0
          Width = 48
          Height = 25
          Caption = '> > >'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          OnClick = btnNudgeRight10Click
          Color = clLime
          FrameSize = 1
          FrameColor = clBtnHighlight
          FrameShadowColor = clBtnShadow
        end
        object btnNudgeRight1: TColButton
          Left = 193
          Top = 0
          Width = 48
          Height = 25
          Caption = '> >'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          OnClick = btnNudgeRight1Click
          Color = clLime
          FrameSize = 1
          FrameColor = clBtnHighlight
          FrameShadowColor = clBtnShadow
        end
        object btnNudgeRightPoint1: TColButton
          Left = 145
          Top = 0
          Width = 48
          Height = 25
          Caption = '>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btnNudgeRightPoint1Click
          Color = clLime
          FrameSize = 1
          FrameColor = clBtnHighlight
          FrameShadowColor = clBtnShadow
        end
      end
    end
    object pnlPatternKnife: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 115
      Width = 289
      Height = 289
      Align = alTop
      BevelOuter = bvNone
      Color = clAqua
      ParentBackground = False
      TabOrder = 2
      object pnlKnifeIncRulers: TPanel
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 277
        Height = 277
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object pnlKnifeRulerRight: TPanel
          Left = 0
          Top = 0
          Width = 30
          Height = 277
          Align = alLeft
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object rulerKnifeLeft: TRuler
            Tag = -1
            Left = 0
            Top = 0
            Width = 30
            Height = 247
            Align = alClient
            Caption = ''
            CaptionAlign = caBottomRight
            CaptionIndent1 = 0
            CaptionIndent2 = 0
            Color = clYellow
            EnableRepaint = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Tahoma'
            Font.Style = []
            FontRotation = fr0
            NumberAlign = naCenter
            NumberIndent = 0
            Orientation = orVert
            RollEnabled = False
            RollLimits.MinValid = False
            RollLimits.MaxValid = False
            RollLimits.Max = 100.000000000000000000
            TickAlign = taBottomRight
            TickColor = clBlack
            TickSizeBig = 45
            TickSizeMiddle = 35
            TickSizeSmall = 15
            UnitSize = 50.000000000000000000
            UnitPrice = 10.000000000000000000
            UnitPrecision = 0
          end
          object pnlKnifeRulerCorner: TPanel
            Left = 0
            Top = 247
            Width = 30
            Height = 30
            Align = alBottom
            BevelOuter = bvNone
            Caption = 'cms'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clFuchsia
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentBackground = False
            ParentColor = True
            ParentFont = False
            TabOrder = 1
          end
        end
        object pnlKnifeAndRuler: TPanel
          Left = 30
          Top = 0
          Width = 247
          Height = 277
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object pnlKnife: TPanel
            Left = 0
            Top = 0
            Width = 247
            Height = 247
            Align = alClient
            BevelOuter = bvNone
            Color = clAqua
            ParentBackground = False
            TabOrder = 0
            object imgKnife: TImage
              Left = 0
              Top = 0
              Width = 247
              Height = 247
              Align = alClient
              Center = True
              Proportional = True
              ExplicitWidth = 254
              ExplicitHeight = 254
            end
          end
          object pnlKnifeRulerBottom: TPanel
            Left = 0
            Top = 247
            Width = 247
            Height = 30
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            object rulerKnifeBottom: TRuler
              Tag = -1
              Left = 0
              Top = 0
              Width = 247
              Height = 30
              Align = alClient
              Caption = ''
              CaptionAlign = caTopLeft
              CaptionIndent1 = 0
              CaptionIndent2 = 0
              Color = clYellow
              EnableRepaint = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -9
              Font.Name = 'Tahoma'
              Font.Style = []
              FontRotation = fr0
              NumberAlign = naCenter
              NumberIndent = 15
              Orientation = orHoriz
              RollEnabled = False
              RollLimits.MinValid = False
              RollLimits.MaxValid = False
              RollLimits.Max = 100.000000000000000000
              TickAlign = taTopLeft
              TickColor = clBlack
              TickSizeBig = 45
              TickSizeMiddle = 35
              TickSizeSmall = 15
              UnitSize = 50.000000000000000000
              UnitPrice = 10.000000000000000000
              UnitPrecision = 0
            end
          end
        end
      end
    end
  end
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 295
    Height = 29
    Align = alTop
    Color = clAqua
    TabOrder = 0
    object btnSave: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Set Angle for this Size'
      Flat = True
      Glyph.Data = {
        E6040000424DE604000000000000360000002800000014000000140000000100
        180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF000000E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        000000E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1
        DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DE
        D5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5E1DED5
        000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5E1DED5E1DED5000000FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF000000E1DED5E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
        0000E1DED5E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DE
        D5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFF00000000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DED5E1DED5
        E1DED5E1DED5000000FFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED50000
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5E1
        DED5000000FFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5E1DED5000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5E1DED5E1DE
        D5000000000000000000E1DED5E1DED5E1DED5E1DED5E1DED5000000FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5
        E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1
        DED5E1DED5E1DED5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DE
        D5E1DED5E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF000000E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5E1DED5
        E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF000000000000000000000000000000000000000000000000FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSaveClick
    end
    object btnSaveAll: TSpeedButton
      Left = 26
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Set Angle for ALL Sizes'
      Flat = True
      Glyph.Data = {
        76030000424D7603000000000000360000002800000011000000100000000100
        1800000000004003000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFF
        FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
        000000E1DED5E1DED5000000FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF000000000000000000E1DED5000000E1DED5E1DED5000000
        FFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000E1
        DED5000000000000E1DED5E1DED5000000FFFFFFFFFFFFFFFFFFFFFFFF00FFFF
        FFFFFFFF000000000000000000E1DED5000000000000E1DED5000000E1DED5E1
        DED5000000FFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF000000E1DED50000
        00000000E1DED5000000000000E1DED5E1DED5000000FFFFFFFFFFFF00000000
        0000FFFFFF00FFFFFFFFFFFF000000000000E1DED5000000000000E1DED50000
        00E1DED5E1DED5000000FFFFFF000000E1DED5000000FFFFFF00FFFFFF000000
        E1DED5000000000000E1DED5000000E1DED5000000E1DED5E1DED5E1DED50000
        00E1DED5E1DED5000000FFFFFF00FFFFFF000000000000E1DED5000000E1DED5
        000000E1DED5E1DED5000000E1DED5E1DED5E1DED5E1DED5E1DED5000000FFFF
        FF00000000E1DED5000000E1DED5000000E1DED5E1DED5000000E1DED5E1DED5
        000000000000E1DED5E1DED5000000FFFFFFFFFFFF00000000E1DED5000000E1
        DED5E1DED5000000E1DED5E1DED5000000000000E1DED5E1DED5000000000000
        FFFFFFFFFFFFFFFFFF00000000E1DED5E1DED5000000E1DED5E1DED500000000
        0000E1DED5E1DED5000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFF
        FF000000E1DED5E1DED5000000000000E1DED5E1DED5000000000000FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF000000000000E1DE
        D5E1DED5000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSaveAllClick
    end
    object btnCancel: TSpeedButton
      Left = 49
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Cancel'
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
  end
  object LocalConnectionSumms: TFDConnectionPlus
    LoginPrompt = False
    AfterConnect = LocalConnectionSummsAfterConnect
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 146
    Top = 285
  end
  object tblKnives: TFDTablePlus
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'KNIVES'
    TableName = 'KNIVES'
    Left = 182
    Top = 297
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
    object tblKnivesToBeAssessed: TBooleanField
      FieldName = 'ToBeAssessed'
    end
  end
  object qPatterns: TFDQueryPlus
    Connection = LocalConnectionSumms
    SQL.Strings = (
      'SELECT *'
      'FROM Patterns'
      'WHERE (Knife = :KnifeCode) AND'
      '      (SizeScale = :KnifeScale) AND'
      '      (MeasuredSize = :KnifeSize)'
      'Order By Seq, Seq')
    Left = 163
    Top = 290
    ParamData = <
      item
        Name = 'KnifeCode'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'KnifeScale'
        ParamType = ptInput
      end
      item
        Name = 'KnifeSize'
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
    object qPatternsSizeScale: TStringField
      FieldName = 'SizeScale'
    end
    object qPatternsMeasuredSize: TStringField
      FieldName = 'MeasuredSize'
      Size = 10
    end
  end
  object qMaterialUnits: TFDQueryPlus
    IndexFieldNames = 'CODE'
    Connection = LocalConnectionSumms
    SQL.Strings = (
      'SELECT *'
      'FROM MatUnits'
      'Order By Code, Code')
    Left = 102
    Top = 273
    object qMaterialUnitsCode: TStringField
      FieldName = 'Code'
    end
    object qMaterialUnitsUnitDescription: TStringField
      FieldName = 'UnitDescription'
      Size = 30
    end
    object qMaterialUnitsUnitAbbreviation: TStringField
      FieldName = 'UnitAbbreviation'
      Size = 4
    end
    object qMaterialUnitsToFeet: TFloatField
      FieldName = 'ToFeet'
    end
    object qMaterialUnitsSubUnitDesc: TStringField
      FieldName = 'SubUnitDesc'
      Size = 30
    end
    object qMaterialUnitsSubUnitAbbreviation: TStringField
      FieldName = 'SubUnitAbbreviation'
      Size = 4
    end
    object qMaterialUnitsSubUnitsPerUnit: TSmallintField
      FieldName = 'SubUnitsPerUnit'
    end
  end
  object dsMaterialUnits: TDataSource
    DataSet = qMaterialUnits
    Left = 110
    Top = 283
  end
end
