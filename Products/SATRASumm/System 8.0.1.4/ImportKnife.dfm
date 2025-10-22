object fmKnifeImport: TfmKnifeImport
  Left = 339
  Top = 128
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pattern File'
  ClientHeight = 428
  ClientWidth = 542
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object lblOk: TLabel
    Left = 152
    Top = 248
    Width = 4
    Height = 16
    Visible = False
  end
  object pnlMain: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 536
    Height = 422
    Align = alClient
    BevelOuter = bvNone
    Color = clAqua
    ParentBackground = False
    TabOrder = 0
    object Image: TImage
      Left = 39
      Top = 118
      Width = 33
      Height = 34
      Visible = False
    end
    object pbxGrid: TPaintBox
      Left = 10
      Top = 11
      Width = 501
      Height = 401
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnDblClick = pbxGridDblClick
      OnMouseDown = pbxGridMouseDown
      OnMouseEnter = pbxGridMouseEnter
      OnMouseMove = pbxGridMouseMove
    end
    object ggLoadProgress: TGauge
      Left = 129
      Top = 196
      Width = 272
      Height = 25
      Color = clBtnFace
      ForeColor = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Progress = 0
      Visible = False
    end
    object sbUpDown: TScrollBar
      Left = 510
      Top = 11
      Width = 16
      Height = 400
      Enabled = False
      Kind = sbVertical
      LargeChange = 100
      Max = 0
      PageSize = 0
      SmallChange = 5
      TabOrder = 0
      OnChange = sbUpDownChange
    end
  end
  object tmrShowHint: TThreadedTimer
    OnTimer = tmrShowHintTimer
    Left = 347
    Top = 28
  end
  object tmrHideHint: TThreadedTimer
    Interval = 3000
    OnTimer = tmrHideHintTimer
    Left = 388
    Top = 27
  end
end
