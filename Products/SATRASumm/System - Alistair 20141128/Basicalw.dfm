object dmBasAll: TdmBasAll
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 485
  Width = 741
  object tblSizeRelnSizes: TFDTablePlus
    IndexName = 'PRIMARY'
    Connection = fmSumms.ConnectionSumms
    UpdateOptions.UpdateTableName = 'SIZERELATIONSHIPSIZES'
    TableName = 'SIZERELATIONSHIPSIZES'
    Left = 94
    Top = 24
  end
  object tblSizeScaleSizes: TFDTablePlus
    IndexName = 'PRIMARY'
    Connection = fmSumms.ConnectionSumms
    UpdateOptions.UpdateTableName = 'SIZESCALESIZES'
    TableName = 'SIZESCALESIZES'
    Left = 92
    Top = 79
  end
  object qAverageSizes: TFDQueryPlus
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    Left = 20
    Top = 150
  end
  object qBAForParts: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    Left = 28
    Top = 22
    object qBAForPartsSeq: TFloatField
      FieldName = 'Seq'
    end
    object qBAForPartsKnife: TStringField
      FieldName = 'Knife'
    end
    object qBAForPartsTableLength: TFloatField
      FieldName = 'TableLength'
    end
    object qBAForPartsBAQuadraticA: TFloatField
      FieldName = 'BAQuadraticA'
    end
    object qBAForPartsBAQuadraticB: TFloatField
      FieldName = 'BAQuadraticB'
    end
    object qBAForPartsBAQuadraticC: TFloatField
      FieldName = 'BAQuadraticC'
    end
    object qBAForPartsFrequency: TSmallintField
      FieldName = 'Frequency'
    end
    object qBAForPartsMatType: TStringField
      FieldName = 'MatType'
      Size = 1
    end
    object qBAForPartsLinearAllowance: TBooleanField
      FieldName = 'LinearAllowance'
    end
    object qBAForPartsSLMAllowance: TBooleanField
      FieldName = 'SLMAllowance'
    end
    object qBAForPartsSkinSize: TFloatField
      FieldName = 'SkinSize'
    end
    object qBAForPartsMatCode: TStringField
      FieldName = 'MatCode'
    end
    object qBAForPartsMatLength: TFloatField
      FieldName = 'MatLength'
    end
    object qBAForPartsMatWidth: TFloatField
      FieldName = 'MatWidth'
    end
    object qBAForPartsCutType: TStringField
      FieldName = 'CutType'
      Size = 1
    end
    object qBAForPartsTrimmed: TBooleanField
      FieldName = 'Trimmed'
    end
    object qBAForPartsAreaCoeff: TSmallintField
      FieldName = 'AreaCoeff'
    end
    object qBAForPartsQualCoeff: TSmallintField
      FieldName = 'QualCoeff'
    end
    object qBAForPartsToFeet: TFloatField
      FieldName = 'ToFeet'
    end
    object qBAForPartsSubUnitsPerUnit: TSmallintField
      FieldName = 'SubUnitsPerUnit'
    end
    object qBAForPartsKnifeType: TStringField
      FieldName = 'KnifeType'
      Size = 1
    end
    object qBAForPartsKnifeCutGap: TSmallintField
      FieldName = 'KnifeCutGap'
    end
    object qBAForPartsInterlockAreaPrimeSynthetic: TFloatField
      FieldName = 'InterlockAreaPrimeSynthetic'
    end
    object qBAForPartsInterlockAreaNonPrime: TFloatField
      FieldName = 'InterlockAreaNonPrime'
    end
    object qBAForPartsGrossArea: TFloatField
      FieldName = 'GrossArea'
    end
    object qBAForPartsNettArea: TFloatField
      FieldName = 'NettArea'
    end
    object qBAForPartsPieces: TSmallintField
      FieldName = 'Pieces'
    end
    object qBAForPartsSampleSize: TStringField
      FieldName = 'SampleSize'
      Size = 10
    end
    object qBAForPartsMadeInPairs: TBooleanField
      FieldName = 'MadeInPairs'
    end
    object qBAForPartsSampleSizeMm: TSmallintField
      FieldName = 'SampleSizeMm'
    end
    object qBAForPartsScale: TStringField
      FieldName = 'Scale'
    end
    object qBAForPartsSizeRelationship: TStringField
      FieldName = 'SizeRelationship'
    end
    object qBAForPartsShoeSize: TStringField
      FieldName = 'ShoeSize'
      Size = 10
    end
    object qBAForPartsAdjustedKnifeSize: TStringField
      FieldName = 'AdjustedKnifeSize'
      Size = 10
    end
    object qBAForPartsAdjustedKnifeLength: TIntegerField
      FieldKind = fkLookup
      FieldName = 'AdjustedKnifeLength'
      LookupDataSet = tblSizeScaleSizes
      LookupKeyFields = 'Scale;Size'
      LookupResultField = 'Length'
      KeyFields = 'Scale;AdjustedKnifeSize'
      Lookup = True
    end
    object qBAForPartsSqFtPerPiece: TFloatField
      FieldName = 'SqFtPerPiece'
    end
    object qBAForPartsNumberOfKnives: TIntegerField
      FieldName = 'NumberOfKnives'
    end
    object qBAForPartsUnitAbbreviation: TStringField
      FieldName = 'UnitAbbreviation'
      Size = 4
    end
    object qBAForPartsSubUnitAbbreviation: TStringField
      FieldName = 'SubUnitAbbreviation'
      Size = 4
    end
  end
  object qKnifeSetExists: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'SELECT COUNT(KS.Code) as ACount, P.SLMAllowance'
      'FROM KnifeSets KS, PtWidKnf PWK, Parts P'
      'WHERE PWK.Part = :PartCode AND PWK.WidthNo = :WidthNo AND'
      '      KS.Code = PWK.Knife AND P.Code = PWK.Part'
      'GROUP BY P.SLMAllowance')
    Left = 96
    Top = 147
    ParamData = <
      item
        Name = 'PartCode'
        ParamType = ptInput
      end
      item
        Name = 'WidthNo'
        ParamType = ptInput
      end>
    object qKnifeSetExistsACount: TIntegerField
      FieldName = 'ACount'
    end
    object qKnifeSetExistsSLMAllowance: TBooleanField
      FieldName = 'SLMAllowance'
    end
  end
  object qDropTemp: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'DROP TABLE #Temp')
    Left = 18
    Top = 81
  end
end
