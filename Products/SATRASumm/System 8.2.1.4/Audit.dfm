object fmAudit: TfmAudit
  Left = 295
  Top = 172
  Caption = 'Audit'
  ClientHeight = 578
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 442
    Height = 29
    Align = alTop
    Color = clAqua
    TabOrder = 0
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
      ParentShowHint = False
      ShowHint = True
      OnClick = btnRefreshClick
    end
    object btnSaveAndClearAll: TSpeedButton
      Left = 95
      Top = 0
      Width = 23
      Height = 22
      Hint = 'Save ASC and Clear'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000220B0000220B00001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300003000333
        333337777F777FFFFFF300000000777000337777777777F7773F000000088088
        000377F3777FF737F37F000000000888000377FF377F7FF7F37F000000000088
        0003777FF77777FFF37F00000080110800037F77F777777FF37F000000099910
        00037FFF7F777777FF7F0000000999910003777F7F7777777FFF000F0FF09990
        3003777F73F77777777F0000F0FF090B03037F77373377737F7F000FFFFFF0B0
        B0307F7F3F3337377777000F0FFFFF0B0B337F7F733333737F7F000FFFFFFFF0
        BBB37F7FF33333377F7F0000FFFFFFFF0BBB7F773333333377FF000FFFFFFFFF
        00BB737FFFFFFFFF777F300999999999000B3777777777777773}
      NumGlyphs = 2
      OnClick = btnSaveAndClearAllClick
    end
    object pnlButtons: TPanel
      Left = 49
      Top = 0
      Width = 46
      Height = 22
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      Visible = False
      object btnClear: TSpeedButton
        Left = 23
        Top = 0
        Width = 23
        Height = 22
        Hint = 'Clear'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
          555557777F777555F55500000000555055557777777755F75555005500055055
          555577F5777F57555555005550055555555577FF577F5FF55555500550050055
          5555577FF77577FF555555005050110555555577F757777FF555555505099910
          555555FF75777777FF555005550999910555577F5F77777775F5500505509990
          3055577F75F77777575F55005055090B030555775755777575755555555550B0
          B03055555F555757575755550555550B0B335555755555757555555555555550
          BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
          50BB555555555555575F555555555555550B5555555555555575}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btnClearClick
      end
      object btnSaveASC: TSpeedButton
        Left = 0
        Top = 0
        Width = 23
        Height = 22
        Hint = 'Save ASC'
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
        ParentShowHint = False
        ShowHint = True
        OnClick = btnSaveASCClick
      end
    end
    object btnSize: TButton
      Left = 151
      Top = 2
      Width = 75
      Height = 25
      Caption = 'btnSize'
      TabOrder = 1
      Visible = False
      OnClick = btnSizeClick
    end
  end
  object pnlBottom: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 540
    Width = 436
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    Color = clAqua
    ParentBackground = False
    TabOrder = 2
    Visible = False
    DesignSize = (
      436
      35)
    object lblOlder: TLabel
      Left = 5
      Top = 10
      Width = 79
      Height = 13
      Caption = 'Clears older than'
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblDays: TLabel
      Left = 150
      Top = 10
      Width = 25
      Height = 13
      Caption = 'days.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object pnlSpin: TPanel
      Left = 90
      Top = 7
      Width = 55
      Height = 22
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      TabOrder = 0
      object seDays: TPBSuperSpin
        Left = 0
        Top = 0
        Width = 55
        Height = 22
        Cursor = crDefault
        Alignment = taLeftJustify
        Decimals = -1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 4
        MaxValue = 9999.000000000000000000
        NumberFormat = Standard
        OnInvalidEntry = seDaysInvalidEntry
        ParentFont = False
        TabOrder = 0
        Value = 365.000000000000000000
        Increment = 1.000000000000000000
        RoundValues = False
        Wrap = True
      end
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 29
    Width = 442
    Height = 508
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object pcAudit: TPageControl
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 436
      Height = 502
      ActivePage = tsAuditCleared
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      OwnerDraw = True
      ParentFont = False
      TabOrder = 0
      OnChange = pcAuditChange
      OnDrawTab = pcAuditDrawTab
      object tsAuditCleared: TTabSheet
        Caption = 'Cleared'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object dbgAudit: TDBGridPlus
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 422
          Height = 468
          Align = alClient
          BorderStyle = bsNone
          Color = clAqua
          DataSource = dsAudit
          DrawingStyle = gdsClassic
          FixedColor = clLime
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clFuchsia
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'UserName'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Title.Caption = 'User Name'
              Width = 150
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TicketNumber'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Title.Caption = 'Ticket Number'
              Width = 75
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TransactionDate'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Title.Caption = 'Date'
              Width = 75
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'PrintedYN'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Title.Alignment = taCenter
              Title.Caption = 'Printed'
              Width = 50
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'AmendedYN'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Title.Alignment = taCenter
              Title.Caption = 'Amended'
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MaterialCode'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Title.Caption = 'Material'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Allowance'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Width = 75
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Construction'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Part'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TotalPairs'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Title.Caption = '? ? ?'
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TagNo'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Title.Caption = 'Tag Number'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CustNo'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Title.Caption = 'Customer '
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Usage'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Width = 60
              Visible = True
            end>
        end
      end
      object tsAuditDeleted: TTabSheet
        Caption = 'Deleted'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
      end
      object tsAuditPrinted: TTabSheet
        Caption = 'Printed'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
      end
      object tsAuditUpdated: TTabSheet
        Caption = 'Updated'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
      end
    end
  end
  object dsAudit: TDataSource
    DataSet = qAudit
    Left = 89
    Top = 148
  end
  object qAudit: TFDQueryPlus
    OnCalcFields = qAuditCalcFields
    Connection = fmSumms.ConnectionSumms
    Left = 69
    Top = 121
    object qAuditType: TStringField
      FieldName = 'Type'
      Size = 1
    end
    object qAuditUserName: TStringField
      FieldName = 'UserName'
      Size = 40
    end
    object qAuditWeekNo: TSmallintField
      FieldName = 'WeekNo'
    end
    object qAuditSequenceNo: TSmallintField
      FieldName = 'SequenceNo'
    end
    object qAuditTicketNo: TSmallintField
      FieldName = 'TicketNo'
    end
    object qAuditTransactionDate: TDateField
      FieldName = 'TransactionDate'
    end
    object qAuditPrinted: TBooleanField
      FieldName = 'Printed'
    end
    object qAuditMaterialCode: TStringField
      FieldName = 'MaterialCode'
    end
    object qAuditAllowance: TFloatField
      FieldName = 'Allowance'
      DisplayFormat = '0.0000'
      EditFormat = '0.0000'
    end
    object qAuditConstruction: TStringField
      FieldName = 'Construction'
    end
    object qAuditPart: TStringField
      FieldName = 'Part'
    end
    object qAuditTotalPairs: TSmallintField
      FieldName = 'TotalPairs'
    end
    object qAuditUsage: TFloatField
      FieldName = 'Usage'
      DisplayFormat = '0.00'
      EditFormat = '0.00'
    end
    object qAuditAmended: TBooleanField
      FieldName = 'Amended'
    end
    object qAuditTagNo: TStringField
      FieldName = 'TagNo'
      Size = 55
    end
    object qAuditCustNo: TStringField
      FieldName = 'CustNo'
    end
    object qAuditPrintedYN: TStringField
      FieldKind = fkCalculated
      FieldName = 'PrintedYN'
      Size = 3
      Calculated = True
    end
    object qAuditAmendedYN: TStringField
      FieldKind = fkCalculated
      FieldName = 'AmendedYN'
      Size = 3
      Calculated = True
    end
    object qAuditTicketNumber: TStringField
      FieldKind = fkCalculated
      FieldName = 'TicketNumber'
      Size = 15
      Calculated = True
    end
  end
  object qAudit2: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    Left = 253
    Top = 126
  end
end
