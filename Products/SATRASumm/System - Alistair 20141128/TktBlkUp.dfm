object fmTicketBulkUpdate: TfmTicketBulkUpdate
  Left = 416
  Top = 256
  Caption = 'Tickets Update (Bulk)'
  ClientHeight = 315
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TLabel
    Left = 22
    Top = 290
    Width = 3
    Height = 13
  end
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 439
    Height = 29
    Align = alTop
    Color = clAqua
    ParentBackground = False
    TabOrder = 0
    object btnLoad: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Load'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnLoadClick
    end
    object btnUpdateTickets: TSpeedButton
      Left = 26
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Update'
      Flat = True
      Glyph.Data = {
        96090000424D9609000000000000360000002800000028000000140000000100
        18000000000060090000C40E0000C40E00000000000000000000C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000080808080808080808080
        8080808080808080808080808080808080808080808080808080808080808080
        808080808080808080808080808080808080000000FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF808080000000FFFFFF00000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000FFFFFF
        000000000000808080FFFFFF8080808080808080808080808080808080808080
        80808080808080808080808080808080808080808080808080FFFFFF80808080
        8080000000FFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFF
        FFFFFF00000000FFFFFFFFFF00FFFFFFFFFF00FFFF000000000000FFFF008080
        80FFFFFF808080FFFFFFFFFFFF808080FFFFFFFFFFFF808080FFFFFFFFFFFF80
        8080808080FFFFFF808080FFFFFF808080808080808080808080000000FFFFFF
        000000FFFFFFFFFFFF000000FF0040FFFFFF000000FFFFFFFFFFFF0000000000
        00000000FFFFFF00FFFFFFFFFF00FFFF000000FFFF00808080FFFFFF808080FF
        FFFFFFFFFF808080808080FFFFFF808080FFFFFFFFFFFF808080808080808080
        FFFFFF808080FFFFFF808080808080808080000000FFFFFF0000000000000000
        00000000000000FF0040FF0040FFFFFF000000FFFFFF00FFFFFFFFFF00FFFFFF
        FFFF00FFFFFFFFFF000000FFFF00808080FFFFFF808080808080808080808080
        808080808080808080FFFFFF808080FFFFFF808080FFFFFF808080FFFFFF8080
        80FFFFFF808080808080000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        0040FF0040FF0040000000000000000000000000FFFFFF00FFFFFFFFFF00FFFF
        000000FFFF00808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080808080
        80808080808080808080808080808080FFFFFF808080FFFFFF80808080808080
        8080000000FFFFFF000000000000FFFFFF000000FFFFFF000000FF0040000000
        00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF000000FFFF008080
        80FFFFFF808080808080FFFFFF808080FFFFFF808080808080808080808080FF
        FFFF808080FFFFFF808080FFFFFF808080FFFFFF808080808080000000FFFFFF
        000000000000000000000000000000000000000000FF0040FF0040FF00400000
        00000000000000000000FFFFFF00FFFF000000FFFF00808080FFFFFF80808080
        8080808080808080808080808080808080808080808080808080808080808080
        808080808080FFFFFF808080808080808080000000FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0040FF0040FF004000000000FFFFFF
        FFFF00FFFF000000000000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF808080808080808080808080808080FFFFFF8080
        80808080808080808080000000FFFFFF000000000000000000000000FFFFFFFF
        FFFF000000FFFFFFFFFFFFFF0040FF0040FF0040000000000000000000FFFFFF
        FFFFFF000000808080FFFFFF808080808080808080808080FFFFFFFFFFFF8080
        80FFFFFFFFFFFF808080808080808080808080808080808080FFFFFFFFFFFF80
        8080000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF0040FF0040FF0040FFFFFFFFFFFFFFFFFFFFFFFF0000008080
        80FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF808080808080808080FFFFFFFFFFFFFFFFFFFFFFFF808080000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00FF0040FF0040FF004000000000000000000000000080808080808080808080
        8080808080808080808080808080808080808080808080808080808080808080
        808080808080808080808080808080808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FF0040FF
        0040FF0040C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C08080808080808080
        80C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FF00400000FFFF0040
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0808080808080808080C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FF0040C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0808080C0C0C0C0C0C0C0C0C0}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnUpdateTicketsClick
    end
  end
  object pcTicketsAndErrors: TPageControl
    Left = 0
    Top = 29
    Width = 439
    Height = 286
    ActivePage = tsTickets
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    OwnerDraw = True
    ParentFont = False
    TabOrder = 1
    OnChange = pcTicketsAndErrorsChange
    OnDrawTab = pcTicketsAndErrorsDrawTab
    object tsTickets: TTabSheet
      Caption = 'Tickets'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlLeft: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 277
        Height = 252
        Align = alLeft
        BevelOuter = bvNone
        Color = clAqua
        ParentBackground = False
        TabOrder = 0
        object lblCutWeek: TLabel
          Left = 8
          Top = 7
          Width = 48
          Height = 13
          Caption = 'Cut Week'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblCutter: TLabel
          Left = 8
          Top = 39
          Width = 28
          Height = 13
          Caption = 'Cutter'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblCutterLocation: TLabel
          Left = 8
          Top = 71
          Width = 72
          Height = 13
          Caption = 'Cutter Location'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblMaterialSupplier: TLabel
          Left = 8
          Top = 104
          Width = 78
          Height = 13
          Caption = 'Material Supplier'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblMatPrice: TLabel
          Left = 8
          Top = 136
          Width = 64
          Height = 13
          Caption = 'Material Price'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblMaterialUsed: TLabel
          Left = 8
          Top = 168
          Width = 65
          Height = 13
          Caption = 'Material Used'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblSms: TLabel
          Left = 8
          Top = 232
          Width = 20
          Height = 13
          Caption = 'Sms'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblIssuedAllowance: TLabel
          Left = 8
          Top = 200
          Width = 83
          Height = 13
          Caption = 'Issued Allowance'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbeCutWeek: TDBEdit
          Left = 110
          Top = 2
          Width = 40
          Height = 21
          DataField = 'CutWeek'
          DataSource = dsTktBlkUpdate
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object dbeCutter: TDBEdit
          Left = 110
          Top = 34
          Width = 121
          Height = 21
          CharCase = ecUpperCase
          DataField = 'Cutter'
          DataSource = dsTktBlkUpdate
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object dbeCutterLocation: TDBEdit
          Left = 110
          Top = 66
          Width = 121
          Height = 21
          CharCase = ecUpperCase
          DataField = 'CutterLocation'
          DataSource = dsTktBlkUpdate
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object dbeMatSupplier: TDBEdit
          Left = 110
          Top = 99
          Width = 121
          Height = 21
          CharCase = ecUpperCase
          DataField = 'MatSupplier'
          DataSource = dsTktBlkUpdate
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object dbeMatPrice: TDBEdit
          Left = 110
          Top = 131
          Width = 60
          Height = 21
          DataField = 'MatPrice'
          DataSource = dsTktBlkUpdate
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object dbeMatUsed: TDBEdit
          Left = 110
          Top = 163
          Width = 60
          Height = 21
          DataField = 'ActualUsage'
          DataSource = dsTktBlkUpdate
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object dbeSms: TDBEdit
          Left = 110
          Top = 227
          Width = 60
          Height = 21
          DataField = 'SMVs'
          DataSource = dsTktBlkUpdate
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
        object dbeIssuedAllowanced: TDBEdit
          Left = 110
          Top = 195
          Width = 60
          Height = 21
          DataField = 'IssuedAllowance'
          DataSource = dsTktBlkUpdate
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object cbUseDefault: TCheckBox
          Left = 180
          Top = 198
          Width = 79
          Height = 17
          Caption = 'Use Default'
          Checked = True
          State = cbChecked
          TabOrder = 8
          OnClick = cbUseDefaultClick
        end
        object cbUseExisting: TCheckBox
          Left = 180
          Top = 134
          Width = 79
          Height = 17
          Caption = 'Use Existing'
          Checked = True
          State = cbChecked
          TabOrder = 5
          OnClick = cbUseExistingClick
        end
        object cbUseTicketSms: TCheckBox
          Left = 180
          Top = 230
          Width = 79
          Height = 17
          Caption = 'Leave Sms '
          Checked = True
          State = cbChecked
          TabOrder = 10
          OnClick = cbUseTicketSmsClick
        end
      end
      object dbgTktBlkUpdate: TDBGridPlus
        AlignWithMargins = True
        Left = 286
        Top = 3
        Width = 142
        Height = 252
        Align = alClient
        BorderStyle = bsNone
        DataSource = dsBulkUpdate
        DrawingStyle = gdsClassic
        FixedColor = clLime
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
        ParentFont = False
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clFuchsia
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'WeekNo'
            Title.Caption = 'Week'
            Width = 41
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SequenceNo'
            Title.Caption = 'Seq'
            Width = 41
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TicketNo'
            Title.Caption = 'Ticket'
            Width = 41
            Visible = True
          end>
      end
    end
    object tsWarnings: TTabSheet
      Caption = 'Warnings'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgTicketUpdateAudit: TDBGridPlus
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 425
        Height = 252
        Align = alClient
        BorderStyle = bsNone
        Color = clAqua
        DataSource = dsTicketUpdateAudit
        DrawingStyle = gdsClassic
        FixedColor = clLime
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clFuchsia
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'WeekNo'
            Title.Caption = 'Week'
            Width = 41
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SequenceNo'
            Title.Caption = 'Seq'
            Width = 41
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TicketNo'
            Title.Caption = 'Ticket'
            Width = 41
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ActualErrorLevel'
            Title.Caption = ' '
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Message'
            Title.Caption = ' '
            Width = 570
            Visible = True
          end>
      end
    end
  end
  object tblTicketUpdate: TFDTablePlus
    BeforeOpen = tblTicketUpdateBeforeOpen
    AfterInsert = tblTicketUpdateAfterInsert
    Filtered = True
    Filter = 'BulkUpdate = True'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'TicketUpdate'
    TableName = 'TicketUpdate'
    OptionsPlus = [ftpPrefillDefaults, ftpNullEmptyIndexStrings, ftpInsertPreTest]
    Left = 325
    Top = 3
    object tblTicketUpdateIdentifier: TStringField
      FieldName = 'Identifier'
      Size = 25
    end
    object tblTicketUpdateBulkUpdate: TBooleanField
      FieldName = 'BulkUpdate'
    end
    object tblTicketUpdateCutWeek: TSmallintField
      DisplayWidth = 7
      FieldName = 'CutWeek'
    end
    object tblTicketUpdateCutter: TStringField
      DisplayWidth = 10
      FieldName = 'Cutter'
    end
    object tblTicketUpdateCutterLocation: TStringField
      DisplayWidth = 11
      FieldName = 'CutterLocation'
    end
    object tblTicketUpdateMatSupplier: TStringField
      DisplayWidth = 13
      FieldName = 'MatSupplier'
    end
    object tblTicketUpdateMatPrice: TCurrencyField
      DisplayWidth = 10
      FieldName = 'MatPrice'
    end
    object tblTicketUpdateQuality: TSmallintField
      DisplayWidth = 6
      FieldName = 'Quality'
    end
    object tblTicketUpdateArea: TSmallintField
      FieldName = 'Area'
    end
    object tblTicketUpdateActualUsage: TFloatField
      DisplayWidth = 10
      FieldName = 'ActualUsage'
      DisplayFormat = '0.00'
      EditFormat = '0.00'
    end
    object tblTicketUpdateIssuedAllowance: TFloatField
      DisplayWidth = 10
      FieldName = 'IssuedAllowance'
      DisplayFormat = '0.000'
      EditFormat = '0.000'
    end
    object tblTicketUpdateSMVs: TFloatField
      DisplayWidth = 8
      FieldName = 'SMVs'
      DisplayFormat = '0.000'
      EditFormat = '0.000'
    end
  end
  object dsTktBlkUpdate: TDataSource
    DataSet = tblTicketUpdate
    Left = 335
    Top = 13
  end
  object tblTicketBulkUpdate: TFDTablePlus
    BeforeOpen = tblTicketBulkUpdateBeforeOpen
    AfterInsert = tblTicketBulkUpdateAfterInsert
    Filtered = True
    Filter = 'BulkUpdate = False'
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'TICKETUPDATE'
    TableName = 'TICKETUPDATE'
    Left = 370
    Top = 6
    object tblTicketBulkUpdateIdentifier: TStringField
      FieldName = 'Identifier'
      Size = 25
    end
    object tblTicketBulkUpdateWeekNo: TIntegerField
      FieldName = 'WeekNo'
    end
    object tblTicketBulkUpdateSequenceNo: TIntegerField
      FieldName = 'SequenceNo'
    end
    object tblTicketBulkUpdateTicketNo: TIntegerField
      FieldName = 'TicketNo'
    end
    object tblTicketBulkUpdateMaterial: TStringField
      FieldKind = fkLookup
      FieldName = 'Material'
      LookupDataSet = tblTicketTickets
      LookupKeyFields = 'WeekNo;SequenceNo;TicketNo'
      LookupResultField = 'MaterialCode'
      KeyFields = 'WeekNo;SequenceNo;TicketNo'
      Lookup = True
    end
    object tblTicketBulkUpdateMatPrice: TCurrencyField
      FieldName = 'MatPrice'
    end
    object tblTicketBulkUpdateIssuedAllowance: TFloatField
      FieldName = 'IssuedAllowance'
    end
    object tblTicketBulkUpdateSMVs: TFloatField
      FieldName = 'SMVs'
    end
    object tblTicketBulkUpdateBulkUpdate: TBooleanField
      FieldName = 'BulkUpdate'
      Origin = 'BulkUpdate'
    end
  end
  object dsBulkUpdate: TDataSource
    DataSet = tblTicketBulkUpdate
    Left = 383
    Top = 12
  end
  object dlgOpenTicketFile: TOpenDialog
    DefaultExt = 'UP'
    FileName = 'Update Tickets'
    Filter = 'Bulk Update Tickets|*.BUP|All Files|*.*'
    Left = 284
    Top = 6
  end
  object LocalConnectionSumms: TFDConnection
    LoginPrompt = False
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 149
    Top = 5
  end
  object qReadTicketFile: TFDQueryPlus
    Connection = LocalConnectionSumms
    Left = 183
    Top = 5
  end
  object qUpdateTicketsPreUpdate: TFDQueryPlus
    Connection = LocalConnectionSumms
    Left = 216
    Top = 5
  end
  object qTotals: TFDQueryPlus
    Connection = LocalConnectionSumms
    Left = 249
    Top = 5
  end
  object dsTicketUpdateAudit: TDataSource
    DataSet = tblTicketUpdateAudit
    Left = 424
    Top = 18
  end
  object tblTicketUpdateAudit: TFDTablePlus
    AutoCalcFields = False
    BeforeOpen = tblTicketUpdateAuditBeforeOpen
    OnCalcFields = tblTicketUpdateAuditCalcFields
    Filtered = True
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'TICKETUPDATEAUDIT'
    TableName = 'TICKETUPDATEAUDIT'
    Left = 418
    Top = 8
    object tblTicketUpdateAuditIdentifier: TStringField
      FieldName = 'Identifier'
      Size = 25
    end
    object tblTicketUpdateAuditWeekNo: TIntegerField
      FieldName = 'WeekNo'
    end
    object tblTicketUpdateAuditSequenceNo: TIntegerField
      FieldName = 'SequenceNo'
    end
    object tblTicketUpdateAuditTicketNo: TIntegerField
      FieldName = 'TicketNo'
    end
    object tblTicketUpdateAuditErrorLevel: TSmallintField
      FieldName = 'ErrorLevel'
    end
    object tblTicketUpdateAuditMessage: TStringField
      FieldName = 'Message'
      Size = 100
    end
    object tblTicketUpdateAuditActualErrorLevel: TStringField
      FieldKind = fkCalculated
      FieldName = 'ActualErrorLevel'
      Calculated = True
    end
    object tblTicketUpdateAuditSeq: TIntegerField
      FieldName = 'Seq'
      Origin = 'Seq'
    end
  end
  object tblTicketTickets: TFDTablePlus
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'TICKETTICKETS'
    TableName = 'TICKETTICKETS'
    Left = 483
    Top = 6
  end
  object dsTicketTickets: TDataSource
    DataSet = tblTicketTickets
    Left = 496
    Top = 17
  end
end
