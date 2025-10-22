object fmTicketBulkUpdateErrors: TfmTicketBulkUpdateErrors
  Left = 236
  Top = 354
  BorderIcons = [biSystemMenu]
  Caption = 'Tickets Update (Bulk) Warnings/Errors'
  ClientHeight = 255
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dbgTicketUpdateAudit: TDBGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 794
    Height = 249
    Align = alClient
    BorderStyle = bsNone
    Color = clAqua
    DataSource = fmTicketBulkUpdate.dsTicketUpdateAudit
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
