object dmAdjFact: TdmAdjFact
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 479
  Width = 741
  object qAFVars: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    FetchOptions.AssignedValues = [evRowsetSize, evRecordCountMode]
    FetchOptions.RowsetSize = 2
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      
        'SELECT PWAF.AdjFactor, KS.Type, K.InterlockAreaPrimeSynthetic, K' +
        '.InterlockAreaNonPrime, PWK.Frequency,'
      '       M.Type AS MaterialType, P.ManualAdjFactor'
      
        'FROM PtWidAF PWAF, PtWidKnf PWK, Knives K, KnifeSets KS, Parts P' +
        ', Material M'
      
        'WHERE P.Code = :PartCode AND PWK.Part = P.Code AND PWAF.Part = P' +
        'WK.Part AND PWK.WidthNo = :WidthNo AND'
      
        '      PWAF.WidthNo = PWK.WidthNo AND K.Code = PWK.Knife AND K.Me' +
        'asuredSize = P.SampleSize AND KS.Code = PWK.Knife AND'
      '      M.Code = P.Material')
    Left = 13
    Top = 17
    ParamData = <
      item
        Name = 'PartCode'
        ParamType = ptInput
      end
      item
        Name = 'WidthNo'
        ParamType = ptInput
      end>
    object qAFVarsAdjFactor: TSmallintField
      FieldName = 'AdjFactor'
    end
    object qAFVarsType: TStringField
      FieldName = 'Type'
      Size = 1
    end
    object qAFVarsInterlockAreaPrimeSynthetic: TFloatField
      FieldName = 'InterlockAreaPrimeSynthetic'
    end
    object qAFVarsInterlockAreaNonPrime: TFloatField
      FieldName = 'InterlockAreaNonPrime'
    end
    object qAFVarsFrequency: TSmallintField
      FieldName = 'Frequency'
    end
    object qAFVarsMaterialType: TStringField
      FieldName = 'MaterialType'
      Size = 1
    end
    object qAFVarsManualAdjFactor: TBooleanField
      FieldName = 'ManualAdjFactor'
    end
  end
end
