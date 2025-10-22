object dmTicketsGeneral: TdmTicketsGeneral
  OldCreateOrder = False
  Height = 480
  Width = 696
  object qCompareGrids: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    Left = 184
    Top = 10
    object qCompareGridsWidth: TStringField
      FieldName = 'Width'
      Size = 10
    end
    object qCompareGridsSize: TStringField
      FieldName = 'Size'
      Size = 10
    end
  end
  object LocalConnectionSumms: TFDConnection
    LoginPrompt = False
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 58
    Top = 7
  end
  object qFillCompareGrid: TFDQueryPlus
    Connection = LocalConnectionSumms
    Left = 184
    Top = 67
    object StringField1: TStringField
      FieldName = 'Width'
      Size = 10
    end
    object StringField2: TStringField
      FieldName = 'Size'
      Size = 10
    end
  end
  object qClearCompareGrid: TFDQueryPlus
    Connection = LocalConnectionSumms
    SQL.Strings = (
      'DELETE FROM TicketsCompareGrid'
      'WHERE Identifier = :Identifier AND'
      '              WeekNo = :WeekNo AND'
      '              SequenceNo = :SequenceNo')
    Left = 188
    Top = 132
    ParamData = <
      item
        Name = 'Identifier'
        ParamType = ptInput
      end
      item
        Name = 'WeekNo'
        ParamType = ptInput
      end
      item
        Name = 'SequenceNo'
        ParamType = ptInput
      end>
  end
  object qReadCompareGrid: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT * '
      'FROM TicketsCompareGrid'
      'WHERE Identifier = :Identifier AND'
      '              WeekNo = :WeekNo AND'
      '              SequenceNo = :SequenceNo')
    Left = 188
    Top = 199
    ParamData = <
      item
        Name = 'Identifier'
        ParamType = ptInput
      end
      item
        Name = 'WeekNo'
        ParamType = ptInput
      end
      item
        Name = 'SequenceNo'
        ParamType = ptInput
      end>
  end
end
