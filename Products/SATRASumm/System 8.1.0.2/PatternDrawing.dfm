object dmPatternDrawing: TdmPatternDrawing
  OldCreateOrder = False
  Height = 150
  Width = 215
  object qPatterns: TFDQueryPlus
    SQL.Strings = (
      'SELECT * FROM Patterns'
      
        'WHERE Knife = :KnifeCode AND SizeScale = :KnifeSizeScale AND Mea' +
        'suredSize = :MeasuredSize'
      'Order By Seq, Seq')
    Left = 21
    Top = 14
    ParamData = <
      item
        Name = 'KnifeCode'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'KnifeSizeScale'
        ParamType = ptInput
      end
      item
        Name = 'MeasuredSize'
        ParamType = ptInput
      end>
    object qPatternsKnife: TStringField
      FieldName = 'Knife'
    end
    object qPatternsSeq: TSmallintField
      FieldName = 'Seq'
    end
    object qPatternsX: TSmallintField
      FieldName = 'X'
    end
    object qPatternsY: TSmallintField
      FieldName = 'Y'
    end
    object qPatternsSizeScale: TStringField
      FieldName = 'SizeScale'
    end
    object qPatternsMeasuredSize: TStringField
      FieldName = 'MeasuredSize'
      Size = 10
    end
  end
  object qPattInts: TFDQueryPlus
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT * FROM PattInts'
      
        'WHERE Knife = :KnifeCode AND SizeScale = :KnifeSizeScale AND Mea' +
        'suredSize = :MeasuredSize'
      'Order By Knife, Knife, InterlockNo')
    Left = 86
    Top = 14
    ParamData = <
      item
        Name = 'KnifeCode'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'KnifeSizeScale'
        ParamType = ptInput
      end
      item
        Name = 'MeasuredSize'
        ParamType = ptInput
      end>
    object qPattIntsKnife: TStringField
      FieldName = 'Knife'
    end
    object qPattIntsInterlockNo: TSmallintField
      FieldName = 'InterlockNo'
    end
    object qPattIntsTrxx: TSmallintField
      FieldName = 'Trxx'
    end
    object qPattIntsTryy: TSmallintField
      FieldName = 'Tryy'
    end
    object qPattIntsRev: TBooleanField
      FieldName = 'Rev'
    end
    object qPattIntsW2: TBooleanField
      FieldName = 'W2'
    end
  end
end
