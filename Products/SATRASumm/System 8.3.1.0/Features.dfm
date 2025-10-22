object fmFeatures: TfmFeatures
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Features'
  ClientHeight = 318
  ClientWidth = 245
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 239
    Height = 312
    Align = alClient
    BevelOuter = bvNone
    Color = clAqua
    ParentBackground = False
    TabOrder = 0
    object lblOption4: TLabel
      Left = 10
      Top = 85
      Width = 88
      Height = 13
      Caption = 'Production System'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption1: TLabel
      Left = 10
      Top = 10
      Width = 36
      Height = 13
      Caption = 'Leather'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption2: TLabel
      Left = 10
      Top = 35
      Width = 74
      Height = 13
      Caption = 'Synthetics (Full)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption3: TLabel
      Left = 10
      Top = 60
      Width = 93
      Height = 13
      Caption = 'Synthetics (Legacy)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption5: TLabel
      Left = 10
      Top = 110
      Width = 64
      Height = 13
      Caption = 'Cutting Times'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption6: TLabel
      Left = 10
      Top = 135
      Width = 46
      Height = 13
      Caption = 'CAD Files'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption7: TLabel
      Left = 10
      Top = 160
      Width = 47
      Height = 13
      Caption = 'Tickets In'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption8: TLabel
      Left = 10
      Top = 185
      Width = 55
      Height = 13
      Caption = 'Tickets Out'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption9: TLabel
      Left = 10
      Top = 210
      Width = 57
      Height = 13
      Caption = 'Ticket Audit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption1OnOff: TLabel
      Left = 200
      Top = 10
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption2OnOff: TLabel
      Left = 200
      Top = 35
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption3OnOff: TLabel
      Left = 200
      Top = 60
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption4OnOff: TLabel
      Left = 200
      Top = 85
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption5OnOff: TLabel
      Left = 200
      Top = 110
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption6OnOff: TLabel
      Left = 200
      Top = 135
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption7OnOff: TLabel
      Left = 200
      Top = 160
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption8OnOff: TLabel
      Left = 200
      Top = 185
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption9OnOff: TLabel
      Left = 200
      Top = 210
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption10OnOff: TLabel
      Left = 200
      Top = 235
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption11: TLabel
      Left = 10
      Top = 260
      Width = 74
      Height = 13
      Caption = 'Singles Allowed'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption10: TLabel
      Left = 10
      Top = 235
      Width = 76
      Height = 13
      Caption = 'Ticket Updating'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption11OnOff: TLabel
      Left = 200
      Top = 260
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption12: TLabel
      Left = 10
      Top = 285
      Width = 164
      Height = 13
      Caption = 'All allowances for Construction Out'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblOption12OnOff: TLabel
      Left = 200
      Top = 285
      Width = 20
      Height = 13
      Caption = 'OFF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
end
