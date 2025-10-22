object fmExternalIn: TfmExternalIn
  Left = 399
  Top = 312
  BorderIcons = [biSystemMenu]
  Caption = 'External Tickets Errors'
  ClientHeight = 274
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dbgErrors: TDBGridPlus
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 469
    Height = 268
    Align = alClient
    BorderStyle = bsNone
    Color = clAqua
    DataSource = dsOutput
    DrawingStyle = gdsClassic
    FixedColor = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clFuchsia
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Style'
        Width = 180
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Width'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ErrorStr'
        Title.Caption = 'Error'
        Width = 205
        Visible = True
      end>
  end
  object dsspExternalIn: TDataSource
    DataSet = spExternalIn
    Left = 56
    Top = 208
  end
  object LocalConnectionSumms: TFDConnection
    LoginPrompt = False
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 43
    Top = 154
  end
  object spExternalIn: TFDStoredProc
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    StoredProcName = 'ExternalIn'
    Left = 107
    Top = 164
    ParamData = <
      item
        Name = 'InFile'
        DataType = ftMemo
        ParamType = ptInput
      end
      item
        Name = 'Style'
        DataType = ftString
        ParamType = ptOutput
      end
      item
        Name = 'Width'
        DataType = ftString
        ParamType = ptOutput
      end
      item
        Name = 'ErrorStr'
        DataType = ftString
        ParamType = ptOutput
      end
      item
        Name = 'InFile'
        DataType = ftMemo
        ParamType = ptInput
      end>
  end
  object mtblOutput: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 368
    Top = 192
  end
  object dsOutput: TDataSource
    Left = 232
    Top = 144
  end
end
