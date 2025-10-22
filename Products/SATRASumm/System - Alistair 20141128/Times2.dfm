object dmTimes2: TdmTimes2
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 448
  Width = 772
  object qKnivesForValue: TFDQueryPlus
    OnCalcFields = qKnivesForValueCalcFields
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'SELECT '#39'FROM_SUMMS'#39' as Value,'
      '       PWK.Knife,'
      '       (PWK.NoIncludedKnives * 100) + PWK.Frequency as Freq,'
      '       KS.Pieces,'
      '       KS.Punches as Peels,'
      '       CASE KS.DoubleSided'
      '       WHEN True THEN '#39'N'#39
      '       WHEN False THEN '#39'Y'#39
      '       END As CutsLR,'
      '       CASE KS.Thin'
      '       WHEN True THEN '#39'Y'#39
      '       WHEN False THEN '#39'N'#39
      '       END as Thin,'
      '       KS.Bands,'
      '       KS.Marks,'
      '       KS.Clears'
      'FROM PtWidKnf PWK, KnifeSets KS'
      
        'WHERE PWK.Part = :Code AND PWK.WidthNo = :WidthNo AND KS.Code = ' +
        'PWK.Knife'
      'Order By PWK.Seq, PWK.Seq')
    Left = 30
    Top = 14
    ParamData = <
      item
        Name = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'WidthNo'
        ParamType = ptInput
      end>
    object qKnivesForValueValue: TStringField
      FieldName = 'Value'
      Size = 10
    end
    object qKnivesForValueKnife: TStringField
      FieldName = 'Knife'
    end
    object qKnivesForValueFreq: TIntegerField
      FieldName = 'Freq'
    end
    object qKnivesForValuePieces: TSmallintField
      FieldName = 'Pieces'
    end
    object qKnivesForValuePeels: TSmallintField
      FieldName = 'Peels'
    end
    object qKnivesForValueCutsLR: TStringField
      FieldName = 'CutsLR'
      Size = 1
    end
    object qKnivesForValueThin: TStringField
      FieldName = 'Thin'
      Size = 1
    end
    object qKnivesForValueBands: TFloatField
      FieldName = 'Bands'
    end
    object qKnivesForValueMarks: TFloatField
      FieldName = 'Marks'
    end
    object qKnivesForValueClears: TSmallintField
      FieldName = 'Clears'
    end
    object qKnivesForValueNettArea: TFloatField
      FieldKind = fkCalculated
      FieldName = 'NettArea'
      Calculated = True
    end
  end
  object qPatternsForValue: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'SELECT '#39'FROM_SUMMS'#39' as Value,'
      '       PWK.Knife as Pattern,'
      '       PWK.Frequency as Freq,'
      '       CASE K.Type'
      '       WHEN '#39'P'#39' THEN K.InterlockAreaPrimeSynthetic / 1.1'
      '       WHEN '#39'S'#39' THEN K.InterlockAreaPrimeSynthetic / 1.1'
      '       ELSE K.InterlockAreaNonPrime / 1.1'
      '       END As NettArea,'
      '       K.Perimeter,'
      '       K.Corners,'
      '       K.Prickers'
      'FROM PtWidKnf PWK, Knives K'
      
        'WHERE PWK.Part = :Code AND PWK.WidthNo = :WidthNo AND K.Code = P' +
        'WK.Knife'
      'Order By PWK.Seq, PWK.Seq'
      ' '
      ' '
      ' ')
    Left = 31
    Top = 65
    ParamData = <
      item
        Name = 'Code'
        ParamType = ptInput
      end
      item
        Name = 'WidthNo'
        ParamType = ptInput
      end>
  end
end
