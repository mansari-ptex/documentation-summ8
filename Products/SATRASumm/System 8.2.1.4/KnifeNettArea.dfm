object dmKnifeNettArea: TdmKnifeNettArea
  OldCreateOrder = False
  Height = 281
  Width = 374
  object qNettArea: TFDQueryPlus
    SQL.Strings = (
      'UPDATE Knives'
      'SET NettArea = :NettArea,'
      '    GrossArea = :GrossArea'
      'WHERE (Code = :KnifeCode) AND (SizeScale = :SizeScale) AND '
      '  (MeasuredSize = :KnifeSize)')
    Left = 188
    Top = 42
    ParamData = <
      item
        Name = 'NETTAREA'
        ParamType = ptInput
      end
      item
        Name = 'GROSSAREA'
        ParamType = ptInput
      end
      item
        Name = 'KNIFECODE'
        ParamType = ptInput
      end
      item
        Name = 'SIZESCALE'
        ParamType = ptInput
      end
      item
        Name = 'KNIFESIZE'
        ParamType = ptInput
      end>
  end
  object qSizes: TFDQueryPlus
    SQL.Strings = (
      'SELECT SizeScale, MeasuredSize'
      'FROM Knives'
      'WHERE (Code = :KnifeCode);')
    Left = 39
    Top = 36
    ParamData = <
      item
        Name = 'KNIFECODE'
        ParamType = ptInput
      end>
  end
  object qKnifePoints: TFDQueryPlus
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    SQL.Strings = (
      'SELECT * FROM PATTERNS'
      
        'WHERE (Knife = :KnifeCode) AND (SizeScale = :SizeScale) AND (Mea' +
        'suredSize = :KnifeSize)'
      'ORDER BY (Seq + 0)')
    Left = 133
    Top = 42
    ParamData = <
      item
        Name = 'KNIFECODE'
        ParamType = ptInput
      end
      item
        Name = 'SIZESCALE'
        ParamType = ptInput
      end
      item
        Name = 'KNIFESIZE'
        ParamType = ptInput
      end>
  end
end
