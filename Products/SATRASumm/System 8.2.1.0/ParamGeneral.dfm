object fmParametersGeneral: TfmParametersGeneral
  Left = 256
  Top = 196
  Caption = 'Parameters General'
  ClientHeight = 481
  ClientWidth = 553
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
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
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 553
    Height = 29
    Align = alTop
    Color = clAqua
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object btnEdit: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Edit'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        330333333333333333F333333333333330F03333333333333F8F333333333300
        0F033333333333FFF8F330000000000FF0003FFFFFFFFFF88FFF30FFFFFFFF0F
        F0F03F88888888F88F8F30F77FF7770F0FF03F88888888F8F88F30F7C00CCC00
        FFF03F88888888FF888F30F700C0CCC7FFF03F8888888888888F30F7FF77FF77
        FFF03F8888888888888F30F777FF7777FFF03F8888888888888F30F777777777
        FFF03F8888888888888F30FFFFFFFFFFFFF03F8888888888888F300000000000
        00003FFFFFFFFFFFFFFF30704444444070703F8F8888888F8F8F300000000000
        00003FFFFFFFFFFFFFFF33333333333333333333333333333333}
      NumGlyphs = 2
      OnClick = btnEditClick
    end
    object btnSave: TSpeedButton
      Left = 26
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Save'
      Enabled = False
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
      OnClick = btnSaveClick
    end
    object btnCancel: TSpeedButton
      Left = 49
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Cancel'
      Enabled = False
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
      OnClick = btnCancelClick
    end
    object btnRefresh: TSpeedButton
      Left = 72
      Top = 0
      Width = 23
      Height = 25
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
      OnClick = btnRefreshClick
    end
    object btnBrowse: TSpeedButton
      Left = 118
      Top = 0
      Width = 23
      Height = 25
      AllowAllUp = True
      Enabled = False
      Flat = True
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        1800000000000006000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800080800080800080800080
        80BD665BA06409610C0000808000808000808000808000808000808000808000
        8080008080008080008080008080008080808080808080FFFFFF008080008080
        008080008080008080008080008080008080008080008080008080008080D575
        5EE87906FA96009A190900808000808000808000808000808000808000808000
        8080008080008080008080008080808080808080808080FFFFFF008080008080
        008080008080008080008080008080008080008080008080008080D37460E97C
        0CFF9400D22F06A25C5B00808000808000808000808000808000808000808000
        8080008080008080008080808080808080808080808080FFFFFF008080008080
        008080008080008080008080008080008080008080008080D87D63E7790CF786
        00D33D0CAB615E00808000808000808000808000808000808000808000808000
        8080008080008080808080808080808080808080FFFFFF008080008080008080
        008080008080008080008080008080008080008080D47260E77807FF9000CF3C
        0CA8606000808000808000808000808000808000808000808000808000808000
        8080008080808080808080808080808080FFFFFF008080008080008080008080
        008080008080008080008080008080008080C89289E97B13F98E00CF3607B268
        6300808000808000808000808000808000808000808000808000808000808000
        8080808080808080808080808080FFFFFF008080008080008080008080008080
        BCBCBCA9A9A99C9C9C9C9C9CAAAAAAB7B7B7D4C6BCDFA651D0380FAA625F0080
        8000808000808000808000808000808080808080808080808080808080808080
        8080808080808080808080FFFFFF008080008080008080008080008080C1C1C1
        58584560601C61611061611052521C40403ABCBCBB8879718D5C5B0080800080
        8000808000808000808000808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080DDDDDCA9A997
        B6B67ED1D161E2E255DBDB68D1D1369898073B3B1E7575750080800080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080FFFFFF008080008080008080008080008080008080BCBC9DD5D57C
        D3D384DEDE5FDFDF5FDEDE5FDFDF5FD1D1367373108F8F87C4C4C40080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080CBCB70EAEA99
        D1D187DFDF5EDCDC65E0E05ADEDE5FDBDB68B3B32362623BD3D3D30080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080CDCD95EDEDA6
        D4D480DEDE60E1E158DCDC65DFDF5EE2E255AEAE4D5B5B30D1D1D10080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080CACA84EAEAD3
        D2D294DFDF65DEDE60DFDF5EDEDE5FDEDE61B1B13C676743D5D5D50080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080BFBF97E2E2A6
        DADAB5E3E371DCDC65E0E05ADEDE5FDBDB6889893A8D8D83C8C8C80080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080808080FFFFFF008080008080008080008080008080E1E1DCC0C091
        DCDC91EFEF75E5E55CDDDD67D2D25B9F9F45737360D4D4D40080800080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080808080FFFFFF008080008080008080008080008080008080008080E1E1DC
        BEBE95CACA78CBCB8CBFBF62575735505047B7B7B60080800080800080800080
        80008080008080008080008080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF008080008080008080008080008080008080008080}
      NumGlyphs = 2
      OnClick = btnBrowseClick
    end
    object btnTimeLine: TSpeedButton
      Left = 141
      Top = 0
      Width = 23
      Height = 25
      Hint = 'Import TimeLine Cutting Elements'
      AllowAllUp = True
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000C40E0000C40E00000000000000000000EEAE00EDAC00
        EFAE00EFAE00EDA900EDA800EEAA00EDAB0BEDAB08EEAA00EDA800EDAA00EFAE
        00EFAE00EDAC00EEAE00EDAC00EEAD00EEAD00EBA300F1BA26F6D364F9EA95FC
        F6D4FCF4D1FAE58CF4CD5BEFB200ECA500EEAE00EFAE00EEAD00EEAD00EEAC00
        EDA700F3C748FEFEF1FBF1BBF5CD5AFAEABEF8DE89F5D16FFDF7CEFDF7CEF0B8
        23ECA700EFAE00EFAE00F1BD00F0B600F6D24CFFFFFFF5D255EDA600ECA300EE
        AC0AEDA900EDA600EEAB05F9E285FEFFFEF0B823EDA500EFAE00F2BC00F5D04C
        FFFFFFF6D577F1BD21F5C839F0B608EDAB00EEAD00EFAE00EDAC00E89600FAE4
        89FDF7CEEFB300EEAA00F1BC00FAE59FFBEDC4F2BF1CF3C439F4C748F3C743EF
        AF00EDA800EFAE00EFAE00EEAD00EFAC07FDF9D5F5CB56ECA900F1BE10FDF7EA
        F5D25EF3BE19F4C53BF4C53FF3C74DF9E1A0EFB100EEAB00EFAE00EFAE00ECA6
        00F6D473F8E175EDAA00F2C116FEFFFFF8E093F3C123F4C53BF2BE29F5D781FF
        FFFFF7DA63ECA100EFAE00EFAC00EEAB01FAE3A3FCF1B7EDAB02F2C115FEFFFF
        F9E5A7F3C224F3C130F5CC5BFDF7E9FBEED1FFFFFFF2BF28EEA600EDAC00EEAF
        09FBEBC2FCF2C4EDAC07F1BE13FDFAF0F5D054F3BD15F3C947FBECC7F7DD95F3
        BE32FFFFFFFAE8B3EEAD01EEA900EDA600F5CF66FAE489EEA900F1BC00FAE8AD
        FAE9B5F1BB12F7D36EF7D988F2C546F3C037F9E2A8FFFFFFF7D677F0B300EDA9
        00FCF3BFF5CE60EDA900F1BC00F6D258FFFFFFF5CC54F2BD20F2C33AF2C649F5
        C84DF4C752FCF6E8FDFCF6F3C857F8DC78FDF7DDEFAF10ECA200F3BE00F0BB00
        F7DF8BFFFFFFF5CE5EF2C133F2C33DF4C74DF3C546F5CC64FDFAF1FEFBF6FFFF
        FFF9DEA4F7D67BF5D143F3BF00F3C100F2BF08F9E098FFFFFFFBEBBFF6D57BFA
        EABFF8E0A4F7DA8FFDF8EBFEFDFBFBEDCDF5CB64F7D27CF7D68BF2BF00F3C200
        F1C00AF1BB17F6D476FAE8B8FDF8EFFFFFFFFEFFFFFCF5E7F9E7B6F6D580F6D7
        8AF7CF72F7D37BF6D57CF2C100F2C200F1C10BF4C324F2C12CF2C336F3C646F5
        C74DF4C956F4C959F4C959F4CC5FF4CD6AF7D073F5D378F6D580}
      OnClick = btnTimeLineClick
    end
  end
  object pcParameters: TPageControl
    Left = 0
    Top = 29
    Width = 553
    Height = 452
    ActivePage = tsDirectories
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MultiLine = True
    OwnerDraw = True
    ParentFont = False
    TabOrder = 1
    OnChange = pcParametersChange
    OnDrawTab = pcParametersDrawTab
    object tsDirectories: TTabSheet
      Caption = 'Directories'
      object pnlDirectories: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 539
        Height = 400
        Align = alClient
        BevelOuter = bvNone
        Color = clAqua
        ParentBackground = False
        TabOrder = 0
        object lblTicketsDirectory: TLabel
          Left = 5
          Top = 10
          Width = 35
          Height = 13
          Caption = 'Tickets'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblCADDirectory: TLabel
          Left = 5
          Top = 35
          Width = 53
          Height = 13
          Caption = 'Pattern File'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblStylePicDirectory: TLabel
          Left = 5
          Top = 60
          Width = 64
          Height = 13
          Caption = 'Style Pictures'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblAuditPath: TLabel
          Left = 5
          Top = 85
          Width = 49
          Height = 13
          Caption = 'Audit Path'
        end
        object dbeAuditPath: TDBEdit
          Left = 110
          Top = 82
          Width = 430
          Height = 21
          DataField = 'AuditPathName'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnEnter = eAnyEnter
          OnExit = eAnyExit
        end
        object dbeStylePicDirectory: TDBEdit
          Left = 110
          Top = 57
          Width = 430
          Height = 21
          DataField = 'StylePicDirectory'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnEnter = eAnyEnter
          OnExit = eAnyExit
        end
        object dbeCADDirectory: TDBEdit
          Left = 110
          Top = 32
          Width = 430
          Height = 21
          DataField = 'CADDirectory'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnEnter = eAnyEnter
          OnExit = eAnyExit
        end
        object dbeTicketsDirectory: TDBEdit
          Left = 110
          Top = 7
          Width = 430
          Height = 21
          DataField = 'TicketsDirectory'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnEnter = eAnyEnter
          OnExit = eAnyExit
        end
        object pnlView1: TPanel
          Left = 110
          Top = 0
          Width = 431
          Height = 103
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 4
          object dbtTicketsDirectory: TDBText
            Left = 5
            Top = 10
            Width = 430
            Height = 17
            DataField = 'TicketsDirectory'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtCADDirectory: TDBText
            Left = 5
            Top = 35
            Width = 430
            Height = 17
            DataField = 'CADDirectory'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtStylePicDirectory: TDBText
            Left = 5
            Top = 60
            Width = 430
            Height = 17
            DataField = 'StylePicDirectory'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtAuditPath: TDBText
            Left = 5
            Top = 85
            Width = 430
            Height = 17
            DataField = 'AuditPathName'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
      end
    end
    object tsTicketLayout: TTabSheet
      Caption = 'Ticket Layout'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlTicketLayout: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 539
        Height = 400
        Align = alClient
        BevelOuter = bvNone
        Color = clAqua
        ParentBackground = False
        TabOrder = 0
        object lblLinesinGrid: TLabel
          Left = 5
          Top = 10
          Width = 98
          Height = 13
          Caption = 'Lines In Leather Grid'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblRowsinGrid: TLabel
          Left = 5
          Top = 35
          Width = 99
          Height = 13
          Caption = 'Rows in Leather Grid'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblTitleFont: TLabel
          Left = 4
          Top = 110
          Width = 44
          Height = 13
          Caption = 'Title Font'
        end
        object lblStandardFont: TLabel
          Left = 4
          Top = 185
          Width = 67
          Height = 13
          Caption = 'Standard Font'
        end
        object lblFixedFont: TLabel
          Left = 4
          Top = 260
          Width = 49
          Height = 13
          Caption = 'Fixed Font'
        end
        object lblFixedCutFont: TLabel
          Left = 4
          Top = 335
          Width = 97
          Height = 13
          Caption = 'Fixed Font (Cut Size)'
        end
        object btnFixedCutFont: TSpeedButton
          Left = 110
          Top = 335
          Width = 23
          Height = 25
          AllowAllUp = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333333333333333333333FFF33FFFFF33333300033000
            00333337773377777333333330333300033333337FF33777F333333330733300
            0333333377FFF777F33333333700000073333333777777773333333333033000
            3333333337FF777F333333333307300033333333377F777F3333333333703007
            33333333377F7773333333333330000333333333337777F33333333333300003
            33333333337777F3333333333337007333333333337777333333333333330033
            3333333333377333333333333333033333333333333733333333333333333333
            3333333333333333333333333333333333333333333333333333}
          NumGlyphs = 2
          Visible = False
          OnClick = btnFixedCutFontClick
        end
        object btnFixedFont: TSpeedButton
          Left = 110
          Top = 260
          Width = 23
          Height = 25
          AllowAllUp = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333333333333333333333FFF33FFFFF33333300033000
            00333337773377777333333330333300033333337FF33777F333333330733300
            0333333377FFF777F33333333700000073333333777777773333333333033000
            3333333337FF777F333333333307300033333333377F777F3333333333703007
            33333333377F7773333333333330000333333333337777F33333333333300003
            33333333337777F3333333333337007333333333337777333333333333330033
            3333333333377333333333333333033333333333333733333333333333333333
            3333333333333333333333333333333333333333333333333333}
          NumGlyphs = 2
          Visible = False
          OnClick = btnFixedFontClick
        end
        object btnStandardFont: TSpeedButton
          Left = 110
          Top = 185
          Width = 23
          Height = 25
          AllowAllUp = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333333333333333333333FFF33FFFFF33333300033000
            00333337773377777333333330333300033333337FF33777F333333330733300
            0333333377FFF777F33333333700000073333333777777773333333333033000
            3333333337FF777F333333333307300033333333377F777F3333333333703007
            33333333377F7773333333333330000333333333337777F33333333333300003
            33333333337777F3333333333337007333333333337777333333333333330033
            3333333333377333333333333333033333333333333733333333333333333333
            3333333333333333333333333333333333333333333333333333}
          NumGlyphs = 2
          Visible = False
          OnClick = btnStandardFontClick
        end
        object btnTitleFont: TSpeedButton
          Left = 110
          Top = 110
          Width = 23
          Height = 25
          AllowAllUp = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333333333333333333333FFF33FFFFF33333300033000
            00333337773377777333333330333300033333337FF33777F333333330733300
            0333333377FFF777F33333333700000073333333777777773333333333033000
            3333333337FF777F333333333307300033333333377F777F3333333333703007
            33333333377F7773333333333330000333333333337777F33333333333300003
            33333333337777F3333333333337007333333333337777333333333333330033
            3333333333377333333333333333033333333333333733333333333333333333
            3333333333333333333333333333333333333333333333333333}
          NumGlyphs = 2
          Visible = False
          OnClick = btnTitleFontClick
        end
        object dbtTitleName: TDBText
          Left = 145
          Top = 110
          Width = 63
          Height = 13
          AutoSize = True
          DataField = 'TitleFontName'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtTitleSize: TDBText
          Left = 145
          Top = 135
          Width = 30
          Height = 17
          DataField = 'TitleFontSize'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblActualTitleScript: TLabel
          Left = 145
          Top = 160
          Width = 40
          Height = 13
          Caption = 'Western'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblActualStandardScript: TLabel
          Left = 145
          Top = 235
          Width = 40
          Height = 13
          Caption = 'Western'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtStandardSize: TDBText
          Left = 145
          Top = 210
          Width = 30
          Height = 17
          DataField = 'StandardFontSize'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtStandardName: TDBText
          Left = 145
          Top = 185
          Width = 86
          Height = 13
          AutoSize = True
          DataField = 'StandardFontName'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblFixedScript: TLabel
          Left = 145
          Top = 310
          Width = 40
          Height = 13
          Caption = 'Western'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtFixedSize: TDBText
          Left = 145
          Top = 285
          Width = 30
          Height = 17
          DataField = 'FixedFontSize'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtFixedName: TDBText
          Left = 145
          Top = 260
          Width = 68
          Height = 13
          AutoSize = True
          DataField = 'FixedFontName'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblFixedCutScript: TLabel
          Left = 145
          Top = 385
          Width = 40
          Height = 13
          Caption = 'Western'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtFixedCutSize: TDBText
          Left = 145
          Top = 360
          Width = 30
          Height = 17
          DataField = 'FixedCutFontSize'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbtFixedCutName: TDBText
          Left = 145
          Top = 335
          Width = 84
          Height = 13
          AutoSize = True
          DataField = 'FixedCutFontName'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbcbShowTimes: TDBCheckBox
          Left = 4
          Top = 60
          Width = 186
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Print Times'
          DataField = 'PrintTimes'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 2
        end
        object dbcbShowBarcodeNPic: TDBCheckBox
          Left = 4
          Top = 85
          Width = 186
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Print Barcodes and Pictures'
          DataField = 'ShowBarcodeNPic'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 3
        end
        object dbeColsInLeatherGrid: TDBEdit
          Left = 145
          Top = 7
          Width = 45
          Height = 21
          DataField = 'LinesInLeatherGrid'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object dbeRowsInLeatherGrid: TDBEdit
          Left = 145
          Top = 32
          Width = 45
          Height = 21
          DataField = 'RowsInLeatherGrid'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object pnlView2: TPanel
          Left = 145
          Top = 0
          Width = 165
          Height = 102
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 4
          object dbtLinesinGrid: TDBText
            Left = 0
            Top = 10
            Width = 30
            Height = 17
            Alignment = taRightJustify
            DataField = 'LinesInLeatherGrid'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtRowsinGrid: TDBText
            Left = 0
            Top = 35
            Width = 30
            Height = 17
            Alignment = taRightJustify
            DataField = 'RowsInLeatherGrid'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtPrintTimesYesNo: TDBText
            Left = 0
            Top = 60
            Width = 30
            Height = 17
            DataField = 'PrintTimesYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbPrintBarCodes: TDBText
            Left = 0
            Top = 85
            Width = 30
            Height = 17
            DataField = 'PrintBarCodesYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
      end
    end
    object tsTicketOptions: TTabSheet
      Caption = 'Ticket Options'
      ImageIndex = 9
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlTicketOptions: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 539
        Height = 400
        Align = alClient
        BevelOuter = bvNone
        Color = clAqua
        ParentBackground = False
        TabOrder = 0
        object lblAllowanceType: TLabel
          Left = 5
          Top = 185
          Width = 139
          Height = 13
          Caption = 'Allowance Type on Save Out'
        end
        object lblAlwUseCheck: TLabel
          Left = 5
          Top = 160
          Width = 147
          Height = 13
          Caption = 'Allowance Use Error Check (%)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblSplittingScheme: TLabel
          Left = 5
          Top = 85
          Width = 79
          Height = 13
          Caption = 'Splitting Scheme'
        end
        object dbcbAutoSyntheticTicketsList: TDBCheckBox
          Left = 3
          Top = 285
          Width = 170
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Auto Synthetic Tickets List'
          DataField = 'CreateSyntheticTicketsList'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 7
          OnClick = dbcbSplitTicketsClick
        end
        object dbcbCustOnTkt: TDBCheckBox
          Left = 3
          Top = 10
          Width = 170
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Show Customer '
          DataField = 'PrintCustomer'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
        object dbcbGroupPrintSyntheticTickets: TDBCheckBox
          Left = 3
          Top = 260
          Width = 170
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Group Print Synthetic Tickets'
          DataField = 'GroupPrintSyntheticTickets'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
        end
        object dbcbSplitTickets: TDBCheckBox
          Left = 3
          Top = 60
          Width = 170
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Split Tickets'
          DataField = 'SplitTickets'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 2
          OnClick = dbcbSplitTicketsClick
        end
        object dbcbTagNumbers: TDBCheckBox
          Left = 3
          Top = 35
          Width = 170
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Show Tag Numbers'
          DataField = 'PrintTagNumbers'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
        end
        object dbeAlwUseCheck: TDBEdit
          Left = 160
          Top = 162
          Width = 40
          Height = 21
          DataField = 'AlwUseErrorCheck'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object dbrgAllowanceType: TDBRadioGroup
          Left = 160
          Top = 182
          Width = 219
          Height = 60
          DataField = 'SaveOutBasic'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Items.Strings = (
            'Basic'
            'Grid @ Material Area/Quality Coefficient')
          ParentFont = False
          TabOrder = 5
          Values.Strings = (
            '0'
            '1')
        end
        object dbrgSplittingScheme: TDBRadioGroup
          Left = 160
          Top = 82
          Width = 296
          Height = 60
          DataField = 'SplittingScheme'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Items.Strings = (
            'Consecutive Sizes'
            'Consecutive Sizes with governing Size Relationship split')
          ParentFont = False
          TabOrder = 3
          Values.Strings = (
            '0'
            '1')
        end
        object pnlView3: TPanel
          Left = 160
          Top = 0
          Width = 300
          Height = 330
          BevelOuter = bvNone
          Color = clAqua
          ParentBackground = False
          TabOrder = 8
          object dbtAlwUseCheck: TDBText
            Left = 0
            Top = 160
            Width = 30
            Height = 17
            Alignment = taRightJustify
            DataField = 'AlwUseErrorCheck'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtShowCustomerYesNo: TDBText
            Left = 0
            Top = 10
            Width = 65
            Height = 17
            DataField = 'ShowCustomerYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtSplittingSchemeType: TDBText
            Left = 0
            Top = 85
            Width = 300
            Height = 17
            DataField = 'SplittingSchemeType'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtTagNumbers: TDBText
            Left = 0
            Top = 35
            Width = 65
            Height = 17
            DataField = 'ShowtagNumbersYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtSplitTickets: TDBText
            Left = 0
            Top = 60
            Width = 65
            Height = 17
            DataField = 'SplitTicketsYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtAllowanceType: TDBText
            Left = 0
            Top = 185
            Width = 300
            Height = 17
            DataField = 'AllowanceType'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtGroupPrintSyntheticTicketsYesNo: TDBText
            Left = 0
            Top = 260
            Width = 65
            Height = 17
            DataField = 'GroupPrintSyntheticTicketsYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtAutoSyntheticTicketsListYesNo: TDBText
            Left = 0
            Top = 285
            Width = 65
            Height = 17
            DataField = 'CreateSyntheticTicketsListYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
      end
    end
    object tsTicketText: TTabSheet
      Caption = 'Ticket Text'
      ImageIndex = 10
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgTktLabels: TDBGridPlus
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 539
        Height = 400
        Align = alClient
        BorderStyle = bsNone
        Color = clAqua
        DataSource = dsTktlabels
        DrawingStyle = gdsClassic
        FixedColor = clLime
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
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
            FieldName = 'English'
            ReadOnly = True
            Width = 175
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Translation'
            Width = 175
            Visible = True
          end>
      end
    end
    object tsAnalysis: TTabSheet
      Caption = 'Analysis'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlAnalysis: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 539
        Height = 400
        Align = alClient
        BevelOuter = bvNone
        Color = clAqua
        ParentBackground = False
        TabOrder = 0
        object lblAllowance: TLabel
          Left = 5
          Top = 85
          Width = 49
          Height = 13
          Caption = 'Allowance'
        end
        object lblReport: TLabel
          Left = 5
          Top = 160
          Width = 32
          Height = 13
          Caption = 'Report'
        end
        object lblWeek: TLabel
          Left = 5
          Top = 10
          Width = 29
          Height = 13
          Caption = 'Week'
        end
        object dbcbCutterPageThrow: TDBCheckBox
          Left = 3
          Top = 260
          Width = 156
          Height = 17
          Alignment = taLeftJustify
          Caption = 'New page for each cutter'
          DataField = 'CutterPageThrow'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 4
        end
        object dbcbPrintCutValue: TDBCheckBox
          Left = 3
          Top = 235
          Width = 156
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Print monetary value'
          DataField = 'PrintCutterValue'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
        end
        object dbrgIssuedCutWeek: TDBRadioGroup
          Left = 145
          Top = 7
          Width = 180
          Height = 60
          DataField = 'IssuedCutWeek'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Items.Strings = (
            'Issued'
            'Cut')
          ParentFont = False
          TabOrder = 0
          Values.Strings = (
            '0'
            '1')
        end
        object dbrgReports: TDBRadioGroup
          Left = 145
          Top = 157
          Width = 180
          Height = 60
          DataField = 'SummarisedDetailed'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Items.Strings = (
            'Summarised'
            'Detailed')
          ParentFont = False
          TabOrder = 2
          Values.Strings = (
            '0'
            '1')
        end
        object dbrgTicketCostedAlw: TDBRadioGroup
          Left = 145
          Top = 82
          Width = 180
          Height = 60
          DataField = 'TicketCostedAlw'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Items.Strings = (
            'Ticket'
            'Costed')
          ParentFont = False
          TabOrder = 1
          Values.Strings = (
            '0'
            '1')
        end
        object pnlView5: TPanel
          Left = 145
          Top = 0
          Width = 180
          Height = 304
          BevelOuter = bvNone
          Color = clAqua
          ParentBackground = False
          TabOrder = 5
          object dbtPrintMonetaryValueYesNo: TDBText
            Left = 0
            Top = 235
            Width = 180
            Height = 17
            DataField = 'PrintMonetaryValueYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtCutterPageThrowYesNo: TDBText
            Left = 0
            Top = 260
            Width = 180
            Height = 17
            DataField = 'CutterPageThrowYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtWeekIssuedCut: TDBText
            Left = 0
            Top = 10
            Width = 180
            Height = 17
            DataField = 'WeekIssuedCut'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtAllowanceTicketCosted: TDBText
            Left = 0
            Top = 85
            Width = 180
            Height = 17
            DataField = 'AllowanceTicketCosted'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowFrame
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtReportSummarisedDetailed: TDBText
            Left = 0
            Top = 160
            Width = 180
            Height = 17
            DataField = 'ReportSummarisedDetailed'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
      end
    end
    object tsMatTypes: TTabSheet
      Caption = 'Material Types'
      ImageIndex = 11
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 545
        Height = 116
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel1'
        TabOrder = 0
        object dbgMatTypes: TDBGridPlus
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 539
          Height = 110
          Align = alClient
          BorderStyle = bsNone
          Color = clAqua
          DataSource = dsMatTypes
          DrawingStyle = gdsClassic
          FixedColor = clLime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
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
              FieldName = 'Description'
              ReadOnly = True
              Title.Caption = 'Material'
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'AvePairsPerJob'
              Title.Alignment = taCenter
              Title.Caption = '? ? ?'
              Width = 55
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'AveSizes'
              Title.Alignment = taCenter
              Title.Caption = 'Sizes'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Rest'
              Title.Alignment = taCenter
              Width = 40
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Contingency'
              Title.Alignment = taCenter
              Title.Caption = 'Cont.'
              Width = 40
              Visible = True
            end>
        end
      end
      object pnlPressesLeather: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 119
        Width = 539
        Height = 62
        Align = alTop
        BevelOuter = bvNone
        Color = clAqua
        ParentBackground = False
        TabOrder = 1
        object lblPressTypeSynthetic: TLabel
          Left = 7
          Top = 39
          Width = 142
          Height = 13
          Caption = 'Press when cutting Synthetics'
        end
        object lblPressTypeLeather: TLabel
          Left = 7
          Top = 14
          Width = 134
          Height = 13
          Caption = 'Press when cutting Leathers'
        end
        object dbrgPressTypeSynthetic: TDBRadioGroup
          Left = 160
          Top = 27
          Width = 227
          Height = 30
          Columns = 2
          DataField = 'PressTypeSynthetic'
          DataSource = dsParameters
          Items.Strings = (
            'Push / Pull'
            'Travelling Head')
          TabOrder = 2
          Values.Strings = (
            'P'
            'T')
        end
        object dbrgPressTypeLeather: TDBRadioGroup
          Left = 160
          Top = 2
          Width = 336
          Height = 30
          Columns = 3
          DataField = 'PressTypeLeather'
          DataSource = dsParameters
          Items.Strings = (
            'Swing Beam'
            'Push / Pull'
            'Travelling Head')
          TabOrder = 1
          Values.Strings = (
            'S'
            'P'
            'T')
        end
        object pnlView6: TPanel
          Left = 160
          Top = 6
          Width = 339
          Height = 51
          BevelOuter = bvNone
          Color = clAqua
          ParentBackground = False
          TabOrder = 0
          object dbtCuttingTypeLeather: TDBText
            Left = 0
            Top = 8
            Width = 108
            Height = 13
            AutoSize = True
            DataField = 'PressTypeLeatherDesc'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtCuttingTypeSynthetic: TDBText
            Left = 0
            Top = 33
            Width = 116
            Height = 13
            AutoSize = True
            DataField = 'PressTypeSyntheticDesc'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
      end
    end
    object tsCutting: TTabSheet
      Caption = 'Cutting'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlCutting: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 539
        Height = 400
        Align = alClient
        BevelOuter = bvNone
        Color = clAqua
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        object lblTableLength: TLabel
          Left = 5
          Top = 85
          Width = 80
          Height = 13
          Caption = 'Table Length (m)'
        end
        object lblFeedSystem: TLabel
          Left = 5
          Top = 10
          Width = 61
          Height = 13
          Caption = 'Feed System'
        end
        object lblNotRecommended: TLabel
          Left = 5
          Top = 187
          Width = 102
          Height = 13
          Caption = '(*Not Recommended)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dbrgFeedSystem: TDBRadioGroup
          Left = 145
          Top = 7
          Width = 160
          Height = 60
          DataField = 'FeedSystem'
          DataSource = dsParameters
          Items.Strings = (
            'Clips'
            'Gantry')
          TabOrder = 1
          Values.Strings = (
            'C'
            'G')
        end
        object dbeTableLength: TDBEdit
          Left = 145
          Top = 82
          Width = 40
          Height = 21
          AutoSize = False
          DataField = 'TableLength'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object cbLegacyCuttingTimes: TDBCheckBox
          Left = 4
          Top = 110
          Width = 154
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Legacy Cutting Times'
          DataField = 'LegacyCuttingTimes'
          DataSource = dsParameters
          TabOrder = 3
          OnClick = cbLegacyCuttingTimesClick
        end
        object cbLegacyCuttingTimesExact: TDBCheckBox
          Left = 4
          Top = 135
          Width = 154
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Exact Legacy Times*'
          DataField = 'LegacyCuttingTimesExact'
          DataSource = dsParameters
          TabOrder = 4
          Visible = False
        end
        object cbLegacyCuttingTimesBase: TDBCheckBox
          Left = 4
          Top = 160
          Width = 154
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Legacy Times @ Base'
          DataField = 'LegacyCuttingTimesBase'
          DataSource = dsParameters
          TabOrder = 5
          OnClick = cbLegacyCuttingTimesClick
        end
        object pnlView7: TPanel
          Left = 145
          Top = 0
          Width = 160
          Height = 220
          BevelOuter = bvNone
          Color = clAqua
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
          object dbtTableLength: TDBText
            Left = 0
            Top = 85
            Width = 40
            Height = 17
            Alignment = taRightJustify
            DataField = 'TableLength'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtFeedSystemCG: TDBText
            Left = 0
            Top = 10
            Width = 65
            Height = 17
            DataField = 'FeedSystemClipsGantry'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtLegacyCuttingTimes: TDBText
            Left = 0
            Top = 110
            Width = 40
            Height = 17
            DataField = 'LegacyCuttingTimesYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtLegacyCuttingTimesExact: TDBText
            Left = 0
            Top = 135
            Width = 40
            Height = 17
            DataField = 'LegacyCuttingTimesExactYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Visible = False
          end
          object dbtLegacyCuttingTimesBase: TDBText
            Left = 0
            Top = 160
            Width = 40
            Height = 17
            DataField = 'LegacyCuttingTimesBaseYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Visible = False
          end
        end
      end
    end
    object tsCuttingElements: TTabSheet
      Caption = 'Cutting Elements'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgElements_Summs8: TDBGridPlus
        AlignWithMargins = True
        Left = 3
        Top = 169
        Width = 539
        Height = 143
        BorderStyle = bsNone
        Color = clAqua
        DataSource = dsElements_Summs8
        DrawingStyle = gdsClassic
        FixedColor = clLime
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
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
            FieldName = 'Code'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ReadOnly = True
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Description'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ReadOnly = True
            Width = 392
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Time'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ReadOnly = True
            Title.Alignment = taCenter
            Title.Caption = 'Minutes'
            Visible = True
          end>
      end
      object dbgElements_Summs7: TDBGridPlus
        AlignWithMargins = True
        Left = 3
        Top = 12
        Width = 539
        Height = 143
        BorderStyle = bsNone
        Color = clAqua
        DataSource = dsElements_Summs7
        DrawingStyle = gdsClassic
        FixedColor = clLime
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgCancelOnExit]
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
            FieldName = 'Element'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ReadOnly = True
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Description'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ReadOnly = True
            Width = 340
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'PerBatchYesNo'
            Title.Caption = 'Per Batch'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Time'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ReadOnly = True
            Title.Alignment = taCenter
            Visible = True
          end>
      end
    end
    object tsMatUnits: TTabSheet
      Caption = 'Units'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgMatUnits: TDBGridPlus
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 539
        Height = 400
        Align = alClient
        BorderStyle = bsNone
        Color = clAqua
        DataSource = dsMaterialUnits
        DrawingStyle = gdsClassic
        FixedColor = clLime
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clFuchsia
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnKeyPress = dbgMatUnitsKeyPress
        Columns = <
          item
            Expanded = False
            FieldName = 'Code'
            Width = 41
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UnitDescription'
            Title.Caption = 'Description'
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UnitAbbreviation'
            Title.Caption = 'Abbreviation'
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ToFeet'
            Title.Caption = 'To Feet'
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SubUnitDesc'
            Title.Caption = 'Sub Unit Desc.'
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SubUnitAbbreviation'
            Title.Caption = 'Sub Unit Abbrev.'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SubUnitsPerUnit'
            Title.Caption = 'Sub Units/Unit'
            Width = 85
            Visible = True
          end>
      end
    end
    object tsMisc: TTabSheet
      Caption = 'Misc'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnlMisc: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 539
        Height = 400
        Align = alClient
        BevelOuter = bvNone
        Color = clAqua
        ParentBackground = False
        TabOrder = 0
        object lblBatchSize: TLabel
          Left = 5
          Top = 35
          Width = 51
          Height = 13
          Caption = 'Batch Size'
        end
        object lblCompanyName: TLabel
          Left = 5
          Top = 10
          Width = 75
          Height = 13
          Caption = 'Company Name'
        end
        object dbcbAutoCreateConstruction: TDBCheckBox
          Left = 3
          Top = 160
          Width = 155
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Auto Create Construction'
          DataField = 'AutoCreateConstruction'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clFuchsia
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
        end
        object dbcbAutoDeleteConstruction: TDBCheckBox
          Left = 3
          Top = 185
          Width = 155
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Auto Delete Construction'
          DataField = 'AutoDeleteConstruction'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 7
        end
        object dbcbDiffLeather: TDBCheckBox
          Left = 3
          Top = 135
          Width = 155
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Difficult Leather Facility'
          DataField = 'DifficultLeatherFacilty'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 5
        end
        object dbcbMadeInPairs: TDBCheckBox
          Left = 3
          Top = 260
          Width = 155
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Made In Pairs (Default)'
          DataField = 'MadeInPairsDefault'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 10
        end
        object dbcbNormalAuditFormat: TDBCheckBox
          Left = 3
          Top = 60
          Width = 155
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Normal Audit Format'
          DataField = 'OldAudit'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 2
        end
        object dbcbSaveAndClearAudit: TDBCheckBox
          Left = 3
          Top = 85
          Width = 155
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Save and Clear Audit'
          DataField = 'ClearAuditAfterSave'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 3
        end
        object dbcbShortTagNoOutput: TDBCheckBox
          Left = 3
          Top = 110
          Width = 155
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Short Tag No Output'
          DataField = 'ShortTagNo'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 4
        end
        object dbcbShowWaste: TDBCheckBox
          Left = 3
          Top = 210
          Width = 155
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Allowance - Show waste'
          DataField = 'ShowWaste'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 8
        end
        object dbeBatchSize: TDBEdit
          Left = 145
          Top = 32
          Width = 40
          Height = 21
          AutoSize = False
          DataField = 'BatchSize'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object dbeCompany: TDBEdit
          Left = 145
          Top = 7
          Width = 250
          Height = 21
          DataField = 'Company'
          DataSource = dsParameters
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object dbcbSearchStyleDescription: TDBCheckBox
          Left = 3
          Top = 235
          Width = 155
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Search Style Desc. (Default)'
          DataField = 'SearchStyleDescriptionDefault'
          DataSource = dsParameters
          ReadOnly = True
          TabOrder = 9
        end
        object pnlView10: TPanel
          Left = 145
          Top = 0
          Width = 250
          Height = 291
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 11
          object dbtCompanyName: TDBText
            Left = 0
            Top = 10
            Width = 250
            Height = 17
            DataField = 'Company'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtNormalAuditFormat: TDBText
            Left = 0
            Top = 60
            Width = 65
            Height = 17
            DataField = 'NormalAuditFormatYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtDiffLeather: TDBText
            Left = 0
            Top = 135
            Width = 30
            Height = 17
            DataField = 'DiffLeatherYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtAutoCreateCon: TDBText
            Left = 0
            Top = 160
            Width = 30
            Height = 17
            DataField = 'AutoCreateConYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtAutoDeleteCon: TDBText
            Left = 0
            Top = 185
            Width = 30
            Height = 17
            DataField = 'AutoDeleteConYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtSaveAndClearAudit: TDBText
            Left = 0
            Top = 85
            Width = 30
            Height = 17
            DataField = 'ClearAuditAfterSaveYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtShowWaste: TDBText
            Left = 0
            Top = 210
            Width = 30
            Height = 17
            DataField = 'ShowWasteYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtBatchSize: TDBText
            Left = 0
            Top = 35
            Width = 40
            Height = 17
            Alignment = taRightJustify
            DataField = 'BatchSize'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtMadeInPairsYesNo: TDBText
            Left = 0
            Top = 260
            Width = 65
            Height = 17
            DataField = 'MadeInPairsDefaultYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtShortTagNo: TDBText
            Left = 0
            Top = 110
            Width = 30
            Height = 17
            DataField = 'ShortTagNoYesNo'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object dbtSearchStyleDescriptionYesNo: TDBText
            Left = 0
            Top = 235
            Width = 65
            Height = 17
            DataField = 'SearchStyleDescriptionDefaultYN'
            DataSource = dsParameters
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
      end
    end
  end
  object tblParameters: TFDTablePlus
    BeforePost = tblParametersBeforePost
    OnCalcFields = tblParametersCalcFields
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'Params'
    TableName = 'Params'
    Left = 326
    Top = 223
    object tblParametersCADDirectory: TStringField
      FieldName = 'CADDirectory'
      Size = 50
    end
    object tblParametersStylePicDirectory: TStringField
      FieldName = 'StylePicDirectory'
      Required = True
      Size = 50
    end
    object tblParametersBatchSize: TSmallintField
      FieldName = 'BatchSize'
      Required = True
    end
    object tblParametersTableLength: TFloatField
      FieldName = 'TableLength'
      Required = True
      DisplayFormat = '0.00'
      EditFormat = '0.00'
    end
    object tblParametersFeedSystem: TStringField
      FieldName = 'FeedSystem'
      Size = 1
    end
    object tblParametersLinesInLeatherGrid: TSmallintField
      FieldName = 'LinesInLeatherGrid'
    end
    object tblParametersRowsInLeatherGrid: TSmallintField
      FieldName = 'RowsInLeatherGrid'
    end
    object tblParametersDifficultLeatherFacilty: TBooleanField
      FieldName = 'DifficultLeatherFacilty'
    end
    object tblParametersIssuedCutWeek: TStringField
      FieldName = 'IssuedCutWeek'
      Size = 1
    end
    object tblParametersTicketCostedAlw: TStringField
      FieldName = 'TicketCostedAlw'
      Size = 1
    end
    object tblParametersSummarisedDetailed: TStringField
      FieldName = 'SummarisedDetailed'
      Size = 1
    end
    object tblParametersAlwUseErrorCheck: TSmallintField
      FieldName = 'AlwUseErrorCheck'
    end
    object tblParametersPrintCutterValue: TBooleanField
      FieldName = 'PrintCutterValue'
    end
    object tblParametersPrintTagNumbers: TBooleanField
      FieldName = 'PrintTagNumbers'
    end
    object tblParametersPrintCustomer: TBooleanField
      FieldName = 'PrintCustomer'
    end
    object tblParametersPrintTimes: TBooleanField
      FieldName = 'PrintTimes'
    end
    object tblParametersShowBarcodeNPic: TBooleanField
      FieldName = 'ShowBarcodeNPic'
    end
    object tblParametersOldAudit: TBooleanField
      FieldName = 'OldAudit'
    end
    object tblParametersSaveOutBasic: TStringField
      FieldName = 'SaveOutBasic'
      Required = True
      Size = 1
    end
    object tblParametersCompany: TStringField
      FieldName = 'Company'
      Size = 30
    end
    object tblParametersTicketsDirectory: TStringField
      FieldName = 'TicketsDirectory'
      Size = 50
    end
    object tblParametersCutterPageThrow: TBooleanField
      FieldName = 'CutterPageThrow'
    end
    object tblParametersAutoCreateConstruction: TBooleanField
      FieldName = 'AutoCreateConstruction'
    end
    object tblParametersAutoDeleteConstruction: TBooleanField
      FieldName = 'AutoDeleteConstruction'
    end
    object tblParametersTitleFontName: TStringField
      FieldName = 'TitleFontName'
      Size = 50
    end
    object tblParametersTitleFontSize: TIntegerField
      FieldName = 'TitleFontSize'
    end
    object tblParametersTitleFontCharset: TIntegerField
      FieldName = 'TitleFontCharset'
    end
    object tblParametersTitleFontStyle: TStringField
      FieldName = 'TitleFontStyle'
      Size = 40
    end
    object tblParametersStandardFontName: TStringField
      FieldName = 'StandardFontName'
      Size = 50
    end
    object tblParametersStandardFontSize: TIntegerField
      FieldName = 'StandardFontSize'
    end
    object tblParametersStandardFontCharset: TIntegerField
      FieldName = 'StandardFontCharset'
    end
    object tblParametersStandardFontStyle: TStringField
      FieldName = 'StandardFontStyle'
      Size = 40
    end
    object tblParametersFixedFontName: TStringField
      FieldName = 'FixedFontName'
      Size = 50
    end
    object tblParametersFixedFontSize: TIntegerField
      FieldName = 'FixedFontSize'
    end
    object tblParametersFixedFontCharset: TIntegerField
      FieldName = 'FixedFontCharset'
    end
    object tblParametersFixedFontStyle: TStringField
      FieldName = 'FixedFontStyle'
      Size = 40
    end
    object tblParametersFixedCutFontName: TStringField
      FieldName = 'FixedCutFontName'
      Size = 50
    end
    object tblParametersFixedCutFontSize: TIntegerField
      FieldName = 'FixedCutFontSize'
    end
    object tblParametersFixedCutFontCharset: TIntegerField
      FieldName = 'FixedCutFontCharset'
    end
    object tblParametersFixedCutFontStyle: TStringField
      FieldName = 'FixedCutFontStyle'
      Size = 40
    end
    object tblParametersAuditPathName: TStringField
      FieldName = 'AuditPathName'
      Size = 60
    end
    object tblParametersPrintTimesYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'PrintTimesYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersPrintBarCodesYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'PrintBarCodesYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersMaterialSummaryYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'MaterialSummaryYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersShowCustomerYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'ShowCustomerYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersShowtagNumbersYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'ShowtagNumbersYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersSplitTicketsYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'SplitTicketsYesNo'
      Calculated = True
    end
    object tblParametersSplittingSchemeType: TStringField
      FieldKind = fkCalculated
      FieldName = 'SplittingSchemeType'
      Size = 100
      Calculated = True
    end
    object tblParametersAllowanceType: TStringField
      FieldKind = fkCalculated
      FieldName = 'AllowanceType'
      Size = 100
      Calculated = True
    end
    object tblParametersDiffLeatherYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'DiffLeatherYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersAutoCreateConYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'AutoCreateConYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersAutoDeleteConYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'AutoDeleteConYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersFeedSystemClipsGantry: TStringField
      FieldKind = fkCalculated
      FieldName = 'FeedSystemClipsGantry'
      Size = 6
      Calculated = True
    end
    object tblParametersPrintMonetaryValueYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'PrintMonetaryValueYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersCutterPageThrowYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'CutterPageThrowYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersWeekIssuedCut: TStringField
      FieldKind = fkCalculated
      FieldName = 'WeekIssuedCut'
      Size = 6
      Calculated = True
    end
    object tblParametersAllowanceTicketCosted: TStringField
      FieldKind = fkCalculated
      FieldName = 'AllowanceTicketCosted'
      Size = 6
      Calculated = True
    end
    object tblParametersReportSummarisedDetailed: TStringField
      FieldKind = fkCalculated
      FieldName = 'ReportSummarisedDetailed'
      Size = 10
      Calculated = True
    end
    object tblParametersNormalAuditFormatYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'NormalAuditFormatYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersSplitTickets: TBooleanField
      FieldName = 'SplitTickets'
    end
    object tblParametersSplittingScheme: TSmallintField
      FieldName = 'SplittingScheme'
    end
    object tblParametersClearAuditAfterSave: TBooleanField
      FieldName = 'ClearAuditAfterSave'
    end
    object tblParametersClearAuditAfterSaveYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'ClearAuditAfterSaveYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersShowWaste: TBooleanField
      FieldName = 'ShowWaste'
    end
    object tblParametersShowWasteYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'ShowWasteYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersGroupPrintSyntheticTickets: TBooleanField
      FieldName = 'GroupPrintSyntheticTickets'
    end
    object tblParametersCreateSyntheticTicketsList: TBooleanField
      FieldName = 'CreateSyntheticTicketsList'
    end
    object tblParametersGroupPrintSyntheticTicketsYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'GroupPrintSyntheticTicketsYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersCreateSyntheticTicketsListYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'CreateSyntheticTicketsListYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersBAQuadraticA: TFloatField
      FieldName = 'BAQuadraticA'
    end
    object tblParametersBAQuadraticB: TFloatField
      FieldName = 'BAQuadraticB'
    end
    object tblParametersBAQuadraticC: TFloatField
      FieldName = 'BAQuadraticC'
    end
    object tblParametersUpdatedInitialisation: TBooleanField
      FieldName = 'UpdatedInitialisation'
    end
    object tblParametersInterlockingToleranceInterlock: TSmallintField
      FieldName = 'InterlockingToleranceInterlock'
    end
    object tblParametersInterlockingToleranceLayplans: TSmallintField
      FieldName = 'InterlockingToleranceLayplans'
    end
    object tblParametersMadeInPairsDefault: TBooleanField
      FieldName = 'MadeInPairsDefault'
    end
    object tblParametersMadeInPairsDefaultYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'MadeInPairsDefaultYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersPatternEfficiency100: TBooleanField
      FieldName = 'PatternEfficiency100'
    end
    object tblParametersShortTagNoYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'ShortTagNoYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersShortTagNo: TBooleanField
      FieldName = 'ShortTagNo'
    end
    object tblParametersPressTypeLeather: TStringField
      FieldName = 'PressTypeLeather'
      Size = 1
    end
    object tblParametersPressTypeSynthetic: TStringField
      FieldName = 'PressTypeSynthetic'
      Size = 1
    end
    object tblParametersPressTypeLeatherDesc: TStringField
      FieldKind = fkCalculated
      FieldName = 'PressTypeLeatherDesc'
      Size = 40
      Calculated = True
    end
    object tblParametersPressTypeSyntheticDesc: TStringField
      FieldKind = fkCalculated
      FieldName = 'PressTypeSyntheticDesc'
      Size = 40
      Calculated = True
    end
    object tblParametersSearchStyleDescriptionDefault: TBooleanField
      FieldName = 'SearchStyleDescriptionDefault'
    end
    object tblParametersSearchStyleDescriptionDefaultYN: TStringField
      DisplayWidth = 3
      FieldKind = fkCalculated
      FieldName = 'SearchStyleDescriptionDefaultYN'
      Size = 3
      Calculated = True
    end
    object tblParametersLegacyCuttingTimes: TBooleanField
      FieldName = 'LegacyCuttingTimes'
    end
    object tblParametersLegacyCuttingTimesExact: TBooleanField
      FieldName = 'LegacyCuttingTimesExact'
    end
    object tblParametersLegacyCuttingTimesBase: TBooleanField
      FieldName = 'LegacyCuttingTimesBase'
    end
    object tblParametersLegacyCuttingTimesYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'LegacyCuttingTimesYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersLegacyCuttingTimesExactYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'LegacyCuttingTimesExactYesNo'
      Size = 3
      Calculated = True
    end
    object tblParametersLegacyCuttingTimesBaseYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'LegacyCuttingTimesBaseYesNo'
      Size = 3
      Calculated = True
    end
  end
  object dsParameters: TDataSource
    DataSet = tblParameters
    Left = 336
    Top = 234
  end
  object tblTktLabels: TFDTablePlus
    BeforeInsert = tblTktLabelsBeforeInsert
    BeforeDelete = tblTktLabelsBeforeDelete
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'TICKETLABELS'
    TableName = 'TICKETLABELS'
    Left = 362
    Top = 225
    object tblTktLabelsSeq: TSmallintField
      FieldName = 'Seq'
    end
    object tblTktLabelsEnglish: TStringField
      FieldName = 'English'
      Size = 30
    end
    object tblTktLabelsTranslation: TStringField
      FieldName = 'Translation'
      Size = 30
    end
  end
  object dsTktlabels: TDataSource
    DataSet = tblTktLabels
    Left = 367
    Top = 238
  end
  object tblMatUnits: TFDTablePlus
    BeforeEdit = tblMatUnitsBeforeEdit
    BeforeDelete = tblMatUnitsBeforeDelete
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'MATUNITS'
    TableName = 'MATUNITS'
    Left = 398
    Top = 224
    object tblMatUnitsCode: TStringField
      DisplayWidth = 17
      FieldName = 'Code'
      Required = True
    end
    object tblMatUnitsUnitDescription: TStringField
      FieldName = 'UnitDescription'
      Required = True
      Size = 30
    end
    object tblMatUnitsUnitAbbreviation: TStringField
      FieldName = 'UnitAbbreviation'
      Required = True
      Size = 4
    end
    object tblMatUnitsToFeet: TFloatField
      FieldName = 'ToFeet'
      DisplayFormat = '0.0000'
      EditFormat = '0.0000'
    end
    object tblMatUnitsSubUnitDesc: TStringField
      DisplayWidth = 20
      FieldName = 'SubUnitDesc'
      Required = True
      Size = 30
    end
    object tblMatUnitsSubUnitAbbreviation: TStringField
      FieldName = 'SubUnitAbbreviation'
      Required = True
      Size = 4
    end
    object tblMatUnitsSubUnitsPerUnit: TSmallintField
      DisplayWidth = 16
      FieldName = 'SubUnitsPerUnit'
      Required = True
    end
  end
  object dsMaterialUnits: TDataSource
    DataSet = tblMatUnits
    Left = 412
    Top = 235
  end
  object fdTitle: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 10
    MaxFontSize = 18
    Options = []
    Left = 325
    Top = 262
  end
  object fdStandard: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 10
    MaxFontSize = 18
    Options = []
    Left = 341
    Top = 265
  end
  object fdFixed: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 8
    MaxFontSize = 12
    Options = [fdFixedPitchOnly]
    Left = 361
    Top = 268
  end
  object LocalConnectionSumms: TFDConnectionPlus
    Params.Strings = (
      'Alias=TIMELINE2'
      'ServerTypes=Remote'
      'Protocol=TCPIP'
      'DriverID=ADS')
    LoginPrompt = False
    AfterConnect = LocalConnectionSummsAfterConnect
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 289
    Top = 237
  end
  object dsMatTypes: TDataSource
    DataSet = tblMatTypes
    Left = 454
    Top = 236
  end
  object tblMatTypes: TFDTablePlus
    BeforeOpen = tblMatTypesBeforeOpen
    BeforeInsert = tblMatTypesBeforeInsert
    BeforeDelete = tblMatTypesBeforeDelete
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'Mattypes'
    TableName = 'Mattypes'
    Left = 441
    Top = 225
    object tblMatTypesCode: TStringField
      FieldName = 'Code'
      Required = True
      Size = 1
    end
    object tblMatTypesDescription: TStringField
      DisplayWidth = 13
      FieldName = 'Description'
      Size = 30
    end
    object tblMatTypesAvePairsPerJob: TSmallintField
      FieldName = 'AvePairsPerJob'
    end
    object tblMatTypesAveSizes: TSmallintField
      DisplayWidth = 6
      FieldName = 'AveSizes'
    end
    object tblMatTypesRest: TFloatField
      FieldName = 'Rest'
    end
    object tblMatTypesContingency: TFloatField
      FieldName = 'Contingency'
    end
  end
  object tblElementTimes_Summs8: TFDTablePlus
    BeforeInsert = tblElementTimes_Summs8BeforeInsert
    BeforeDelete = tblElementTimes_Summs8BeforeDelete
    IndexName = 'CODE'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'ElementTimes'
    TableName = 'ElementTimes'
    Left = 274
    Top = 370
    object tblElementTimes_Summs8Code: TStringField
      FieldName = 'Code'
      Size = 10
    end
    object tblElementTimes_Summs8Time: TFloatField
      FieldName = 'Time'
      DisplayFormat = '0.0000'
      EditFormat = '0.0000'
    end
    object tblElementTimes_Summs8Description: TStringField
      FieldKind = fkLookup
      FieldName = 'Description'
      LookupDataSet = tblElements
      LookupKeyFields = 'Code'
      LookupResultField = 'Description'
      KeyFields = 'Code'
      Size = 60
      Lookup = True
    end
  end
  object dsElements_Summs8: TDataSource
    DataSet = tblElementTimes_Summs8
    Left = 284
    Top = 383
  end
  object fdFixedCut: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 8
    MaxFontSize = 12
    Options = [fdFixedPitchOnly]
    Left = 376
    Top = 279
  end
  object tblElements: TFDTablePlus
    BeforeInsert = tblElementTimes_Summs8BeforeInsert
    BeforeDelete = tblElementTimes_Summs8BeforeDelete
    IndexName = 'PRIMARY'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'Elements'
    TableName = 'Elements'
    Left = 331
    Top = 372
    object tblElementsCode: TStringField
      FieldName = 'Code'
      Size = 10
    end
    object tblElementsDescription: TStringField
      FieldName = 'Description'
      Size = 60
    end
    object tblElementsCuttingCategory: TStringField
      FieldName = 'CuttingCategory'
      Size = 1
    end
  end
  object tblElementTimes_Summs7: TFDTablePlus
    BeforeInsert = tblElementTimes_Summs7BeforeInsert
    BeforeDelete = tblElementTimes_Summs7BeforeDelete
    OnCalcFields = tblElementTimes_Summs7CalcFields
    IndexFieldNames = 'Element'
    Connection = LocalConnectionSumms
    UpdateOptions.UpdateTableName = 'Elements_Summs7'
    TableName = 'Elements_Summs7'
    Left = 277
    Top = 432
    object tblElementTimes_Summs7Element: TStringField
      FieldName = 'Element'
      Size = 5
    end
    object tblElementTimes_Summs7Description: TStringField
      FieldName = 'Description'
      Size = 40
    end
    object tblElementTimes_Summs7PerBatch: TBooleanField
      FieldName = 'PerBatch'
    end
    object tblElementTimes_Summs7Time: TFloatField
      FieldName = 'Time'
      DisplayFormat = '0.0000'
      EditFormat = '0.0000'
    end
    object tblElementTimes_Summs7PerBatchYesNo: TStringField
      FieldKind = fkCalculated
      FieldName = 'PerBatchYesNo'
      Size = 3
      Calculated = True
    end
  end
  object dsElements_Summs7: TDataSource
    DataSet = tblElementTimes_Summs7
    Left = 298
    Top = 438
  end
end
