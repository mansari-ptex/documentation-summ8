object fmChangePassword: TfmChangePassword
  Left = 401
  Top = 171
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Change Password'
  ClientHeight = 116
  ClientWidth = 190
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tbMain: TPanel
    Left = 0
    Top = 0
    Width = 190
    Height = 29
    Align = alTop
    Color = clAqua
    TabOrder = 0
    object btnSave: TSpeedButton
      Left = 3
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Save'
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
      OnClick = btnSaveClick
    end
    object btnCancel: TSpeedButton
      Left = 26
      Top = 0
      Width = 23
      Height = 23
      Hint = 'Cancel'
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
      ParentShowHint = False
      ShowHint = True
      OnClick = btnCancelClick
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 29
    Width = 190
    Height = 87
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object lblOld: TLabel
      Left = 5
      Top = 10
      Width = 16
      Height = 13
      Caption = 'Old'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblNew: TLabel
      Left = 5
      Top = 35
      Width = 22
      Height = 13
      Caption = 'New'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblVerify: TLabel
      Left = 5
      Top = 60
      Width = 26
      Height = 13
      Caption = 'Verify'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object edtVerify: TMaskEdit
      Left = 50
      Top = 57
      Width = 130
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 2
      Text = ''
      OnKeyDown = eAnyKeyDown
    end
    object edtNew: TMaskEdit
      Left = 50
      Top = 32
      Width = 130
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
      Text = ''
      OnKeyDown = eAnyKeyDown
    end
    object edtOld: TMaskEdit
      Left = 50
      Top = 7
      Width = 130
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 0
      Text = ''
      OnKeyDown = eAnyKeyDown
    end
  end
  object qPassword: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      
        'EXECUTE PROCEDURE sp_ChangeCurrentUserPassword(:OldPassword, :Ne' +
        'wPassword)')
    Left = 30
    Top = 48
    ParamData = <
      item
        Name = 'OldPassword'
        ParamType = ptInput
      end
      item
        Name = 'NewPassword'
        ParamType = ptInput
      end>
  end
  object qVersion: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'EXECUTE PROCEDURE sp_mgGetInstallInfo()')
    Left = 88
    Top = 47
  end
  object qPassword10: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      
        'EXECUTE PROCEDURE sp_ModifyUserProperty(:UserName, '#39'USER_PASSWOR' +
        'D'#39', :NewPassword)'
      '')
    Left = 139
    Top = 47
    ParamData = <
      item
        Name = 'USERNAME'
        ParamType = ptInput
      end
      item
        Name = 'NewPassword'
        ParamType = ptInput
      end>
  end
end
