object dmSatraConnect: TdmSatraConnect
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 361
  Top = 168
  Height = 480
  Width = 696
  object AdsConnectionSumms6_L: TFDConnectionPlus
    Connected = False
    LoginPrompt = False
    Left = 48
    Top = 79
  end
  object AdsConnectionSdata6: TFDConnectionPlus
    Connected = False
    LoginPrompt = False
    Left = 48
    Top = 149
  end
  object tblLocks: TFDTable
    IndexName = 'PRIMARY'
    Connection = AdsConnectionSumms6
    TableName = 'LOCKS'
    Left = 147
    Top = 16
    object tblLocksOption: TStringField
      FieldName = 'Option'
      Size = 25
    end
  end
  object AdsConnectionSumms6: TFDConnectionPlus
    Connected = False
    LoginPrompt = False
    Left = 47
    Top = 18
  end
end
