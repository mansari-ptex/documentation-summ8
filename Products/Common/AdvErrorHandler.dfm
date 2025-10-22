object fmErrorHandler: TfmErrorHandler
  Left = 516
  Top = 167
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Error'
  ClientHeight = 423
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 429
    Height = 382
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object lblDetails: TLabel
      Left = 8
      Top = 8
      Width = 21
      Height = 13
      Alignment = taCenter
      Caption = '... ...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object lblDatabasePasswordError: TLabel
      Left = 8
      Top = 27
      Width = 120
      Height = 13
      Caption = 'Database Password Error'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblDatabaseServerError: TLabel
      Left = 8
      Top = 44
      Width = 105
      Height = 13
      Caption = 'Database Server Error'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblUnexpectedError: TLabel
      Left = 8
      Top = 58
      Width = 83
      Height = 13
      Caption = 'Unexpected Error'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblValidityCheck: TLabel
      Left = 7
      Top = 72
      Width = 67
      Height = 13
      Caption = 'Validity Check'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblDatabaseServerLimit: TLabel
      Left = 7
      Top = 88
      Width = 104
      Height = 13
      Caption = 'Database Server Limit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblConversion: TLabel
      Left = 7
      Top = 104
      Width = 53
      Height = 13
      Caption = 'Conversion'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblPermissionDenied: TLabel
      Left = 182
      Top = 9
      Width = 87
      Height = 13
      Caption = 'Permission Denied'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblLockedbyanotheruser: TLabel
      Left = 180
      Top = 27
      Width = 112
      Height = 13
      Caption = 'Locked by another user'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblUserpasswordchangedbyanotheruser: TLabel
      Left = 180
      Top = 43
      Width = 191
      Height = 13
      Caption = 'User password changed by another user'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblErrordiscoveringserver: TLabel
      Left = 181
      Top = 59
      Width = 111
      Height = 13
      Caption = 'Error discovering server'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblMaximumnumberofdatabaseconnectionsexceeded: TLabel
      Left = 177
      Top = 94
      Width = 253
      Height = 13
      Caption = 'Maximum number of database Connections exceeded'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblMaximumnumberofdatabaseWorkAreasexceeded: TLabel
      Left = 178
      Top = 111
      Width = 250
      Height = 13
      Caption = 'Maximum number of database Work Areas exceeded'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblMaximumnumberofdatabaseTablesexceeded: TLabel
      Left = 177
      Top = 126
      Width = 226
      Height = 13
      Caption = 'Maximum number of database Tables exceeded'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblMaximumnumberofdatabaseIndexFilesexceeded: TLabel
      Left = 176
      Top = 145
      Width = 244
      Height = 13
      Caption = 'Maximum number of database Index Files exceeded'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblMaximumnumberofdatabaseDataLocksexceeded: TLabel
      Left = 176
      Top = 163
      Width = 249
      Height = 13
      Caption = 'Maximum number of database Data Locks exceeded'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblThisisinuseandcannotbechanged: TLabel
      Left = 177
      Top = 179
      Width = 178
      Height = 13
      Caption = 'This is in use and cannot be changed'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblThiscannotbeblank: TLabel
      Left = 178
      Top = 198
      Width = 100
      Height = 13
      Caption = 'This cannot be blank'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblThisistoosmall: TLabel
      Left = 177
      Top = 217
      Width = 74
      Height = 13
      Caption = 'This is too small'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblThisistoobig: TLabel
      Left = 177
      Top = 237
      Width = 65
      Height = 13
      Caption = 'This is too big'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblThisalreadyexists: TLabel
      Left = 178
      Top = 253
      Width = 86
      Height = 13
      Caption = 'This already exists'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblThisdoesnotexist: TLabel
      Left = 178
      Top = 268
      Width = 88
      Height = 13
      Caption = 'This does not exist'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblSQLError: TLabel
      Left = 179
      Top = 284
      Width = 46
      Height = 13
      Caption = 'SQL Error'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblCLOSESYSTEMandrestart: TLabel
      Left = 19
      Top = 227
      Width = 135
      Height = 13
      Caption = 'CLOSE SYSTEM and restart'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblOperationABORTEDWindowClosed: TLabel
      Left = 14
      Top = 251
      Width = 178
      Height = 13
      Caption = 'Operation ABORTED Window Closed'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblThisisinvalid: TLabel
      Left = 16
      Top = 277
      Width = 63
      Height = 13
      Caption = 'This is invalid'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblThismusthaveavalue: TLabel
      Left = 17
      Top = 299
      Width = 110
      Height = 13
      Caption = 'This must have a value'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblNothingToDo: TLabel
      Left = 182
      Top = 299
      Width = 64
      Height = 13
      Caption = 'Nothing to do'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblCommunicationsError: TLabel
      Left = 179
      Top = 75
      Width = 149
      Height = 13
      Caption = 'Database communications error'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblThisisbeingeditedelsewhere: TLabel
      Left = 14
      Top = 344
      Width = 271
      Height = 13
      Caption = 'Something you are trying to add is being edited elsewhere'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 382
    Width = 429
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object btnOk: TColButton
      Left = 127
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnOkClick
      OnKeyDown = btnOkKeyDown
      OnKeyUp = btnOkKeyUp
      Color = clAqua
      FrameSize = 1
      FrameColor = clBtnHighlight
      FrameShadowColor = clBtnShadow
    end
  end
  object qAllFields: TFDQuery
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT * FROM Fields')
    Left = 351
    Top = 13
    object qAllFieldsFieldName: TStringField
      FieldName = 'FieldName'
      Size = 31
    end
    object qAllFieldsOurName: TStringField
      FieldName = 'OurName'
      Size = 50
    end
  end
end
