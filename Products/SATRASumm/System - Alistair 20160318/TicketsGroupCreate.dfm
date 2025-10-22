object fmTicketsGroupCreate: TfmTicketsGroupCreate
  Left = 308
  Top = 274
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Creating Tickets'
  ClientHeight = 146
  ClientWidth = 547
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgScreen: TImage
    Left = 0
    Top = 0
    Width = 954
    Height = 1421
    AutoSize = True
    Center = True
    Proportional = True
  end
  object pnlProgressBar: TPanel
    Left = 0
    Top = 0
    Width = 280
    Height = 41
    ParentColor = True
    TabOrder = 0
    DesignSize = (
      280
      41)
    object lblTicketCode: TLabel
      Left = 12
      Top = 13
      Width = 42
      Height = 13
      Caption = 'Creating '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object pbTicketsCreated: TGauge
      Left = 105
      Top = 10
      Width = 162
      Height = 21
      Anchors = []
      ForeColor = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Progress = 0
    end
  end
end
