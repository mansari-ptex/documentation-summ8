object fmTicketUpdate: TfmTicketUpdate
  Left = 265
  Top = 278
  Caption = 'Tickets Update (Group)'
  ClientHeight = 317
  ClientWidth = 1077
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
    Width = 1077
    Height = 29
    Align = alTop
    Color = clAqua
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
      OnClick = btnUpdateClick
    end
  end
  object pcTicketsUpdate: TPageControl
    Left = 0
    Top = 29
    Width = 1077
    Height = 288
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
    OnDrawTab = pcTicketsUpdateDrawTab
    object tsTickets: TTabSheet
      Caption = 'Tickets'
      object dbgTktUpdate: TDBGridPlus
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1063
        Height = 254
        Align = alClient
        BorderStyle = bsNone
        DataSource = dsTicketUpdate
        DrawingStyle = gdsClassic
        FixedColor = clLime
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clFuchsia
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnKeyPress = dbgTktUpdateKeyPress
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
            FieldName = 'CutWeek'
            Title.Caption = 'Cut Wk'
            Width = 41
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Cutter'
            Width = 180
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CutterLocation'
            Title.Caption = 'Cutter Location'
            Width = 180
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MatSupplier'
            Title.Caption = 'Material Supplier'
            Width = 180
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MatPrice'
            Title.Caption = 'Mat Price'
            Width = 66
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Quality'
            Title.Caption = 'Qual'
            Width = 33
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Area'
            Width = 33
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ActualUsage'
            Title.Caption = 'Mat Used'
            Width = 66
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'IssuedAllowance'
            Title.Caption = 'Issued Alw'
            Width = 66
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SMVs'
            Title.Caption = 'Ams'
            Width = 66
            Visible = True
          end>
      end
    end
    object tsWarningsErrors: TTabSheet
      Caption = 'Warnings/Errors'
      ImageIndex = 1
      object dbgTicketUpdateAudit: TDBGridPlus
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 1063
        Height = 254
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
  object dsTicketUpdateAudit: TDataSource
    DataSet = tblTicketUpdateAudit
    Left = 403
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
    Left = 390
    Top = 6
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
  object dsTicketUpdate: TDataSource
    DataSet = tblTicketUpdate
    Left = 357
    Top = 20
  end
  object dlgOpenTicketFile: TOpenDialog
    OnShow = dlgOpenTicketFileShow
    DefaultExt = 'UP'
    FileName = 'Update Tickets'
    Filter = 'Update Tickets|*.UP|All Files|*.*'
    Left = 181
    Top = 3
  end
  object LocalConnectionSumms: TFDConnectionPlus
    LoginPrompt = False
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 146
    Top = 3
  end
  object qReadTicketFile: TFDQueryPlus
    Connection = LocalConnectionSumms
    Left = 235
    Top = 4
  end
  object tblTicketUpdate: TFDTablePlus
    BeforeOpen = tblTicketUpdateBeforeOpen
    AfterInsert = tblTicketUpdateAfterInsert
    AfterPost = tblTicketUpdateAfterPost
    BeforeScroll = tblTicketUpdateBeforeScroll
    OnNewRecord = tblTicketUpdateNewRecord
    Filtered = True
    Filter = 'BulkUpdate = False'
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'TicketUpdate'
    TableName = 'TicketUpdate'
    OptionsPlus = [ftpNullEmptyIndexStrings, ftpInsertPreTest, ftpApplyLastEdit]
    Left = 343
    Top = 7
    object tblTicketUpdateIdentifier: TStringField
      FieldName = 'Identifier'
      Size = 25
    end
    object tblTicketUpdateBulkUpdate: TBooleanField
      FieldName = 'BulkUpdate'
    end
    object tblTicketUpdateWeekNo: TIntegerField
      FieldName = 'WeekNo'
    end
    object tblTicketUpdateSequenceNo: TIntegerField
      FieldName = 'SequenceNo'
    end
    object tblTicketUpdateTicketNo: TIntegerField
      FieldName = 'TicketNo'
    end
    object tblTicketUpdateCutWeek: TSmallintField
      FieldName = 'CutWeek'
    end
    object tblTicketUpdateCutter: TStringField
      FieldName = 'Cutter'
    end
    object tblTicketUpdateCutterLocation: TStringField
      FieldName = 'CutterLocation'
    end
    object tblTicketUpdateMatSupplier: TStringField
      FieldName = 'MatSupplier'
    end
    object tblTicketUpdateMatPrice: TCurrencyField
      FieldName = 'MatPrice'
      DisplayFormat = '0.00'
    end
    object tblTicketUpdateQuality: TSmallintField
      FieldName = 'Quality'
    end
    object tblTicketUpdateArea: TSmallintField
      FieldName = 'Area'
    end
    object tblTicketUpdateActualUsage: TFloatField
      FieldName = 'ActualUsage'
      DisplayFormat = '0.00'
    end
    object tblTicketUpdateIssuedAllowance: TFloatField
      FieldName = 'IssuedAllowance'
      DisplayFormat = '0.00'
    end
    object tblTicketUpdateSMVs: TFloatField
      FieldName = 'SMVs'
      DisplayFormat = '0.00'
    end
    object tblTicketUpdateAutoCutterLocation: TStringField
      FieldName = 'AutoCutterLocation'
    end
    object tblTicketUpdateAutoMatPrice: TCurrencyField
      FieldName = 'AutoMatPrice'
    end
    object tblTicketUpdateAutoIssuedAllowance: TFloatField
      FieldName = 'AutoIssuedAllowance'
    end
    object tblTicketUpdateAutoSMVs: TFloatField
      FieldName = 'AutoSMVs'
    end
    object tblTicketUpdatePreviousActualUsage: TFloatField
      FieldName = 'PreviousActualUsage'
    end
  end
end
