object dmTicketsCreate: TdmTicketsCreate
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 480
  Width = 696
  object LocalConnectionSumms: TFDConnection
    LoginPrompt = False
    BeforeConnect = LocalConnectionSummsBeforeConnect
    Left = 61
    Top = 11
  end
  object qWidthKnives: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      
        'SELECT PWK.Part, CP.AltMaterial, PWK.WidthNo, W.Width, K.Code as' +
        ' Knife, KS.Type as PSN,'
      
        '       KS.CutGap as KnifeCutGap, K.InterlockAreaPrimeSynthetic, ' +
        'K.InterlockAreaNonPrime, '
      
        '       PWK.Seq as SeqNo, TI.Pairs, P.MaxPairs, P.SLMAllowance, M' +
        '.Type as MaterialType'
      
        'FROM PtWidKnf PWK, TicketsInput TI, Widths W, Parts P, WRngWs WR' +
        'W, ConParts CP,'
      '     Knives K, KnifeSets KS, Material M'
      'WHERE (PWK.Part IN'
      '        (SELECT Part'
      '         FROM ConParts'
      '         WHERE (Construction ='
      '          (SELECT Construction'
      '          FROM TicketSequences'
      
        '          WHERE (WeekNo = :WeekNo) AND (SequenceNo = :SequenceNo' +
        '))))) AND'
      
        '                (TI.WeekNo = :WeekNo) AND (TI.SequenceNo = :Sequ' +
        'enceNo) AND'
      
        '              (TI.WidthNo = PWK.WidthNo) AND (W.No = PWK.WidthNo' +
        ') AND'
      '              (TI.Size = '#39'AddWidth'#39') AND (P.Code = PWK.Part) AND'
      
        '              (WRW.Range = P.WidthRange) AND (WRW.WidthNo = PWK.' +
        'WidthNo) AND'
      '               (CP.Construction ='
      '                (SELECT Construction'
      '                 FROM TicketSequences'
      
        '                 WHERE (WeekNo = :WeekNo) AND (SequenceNo = :Seq' +
        'uenceNo))) AND'
      
        '               (CP.Part = PWK.Part) AND (CP.Use = TRUE) AND (K.C' +
        'ode = PWK.Knife) AND (KS.Code = PWK.Knife) AND'
      '              W.Width IN (SELECT DISTINCT Width'
      '                             FROM TicketsInput'
      
        '                             WHERE WeekNo = :WeekNo AND Sequence' +
        'No = :SequenceNo AND'
      
        '                                   NOT Size = '#39'AddWidth'#39' AND Pai' +
        'rs > 0) AND'
      
        '       M.Code = (IIF (CP.AltMaterial IS NOT NULL, CP.AltMaterial' +
        ', P.Material)) '
      'Order By PWK.Part, PWK.Part, PWK.WidthNo, PWK.Seq'
      '')
    Left = 39
    Top = 68
    ParamData = <
      item
        Name = 'WeekNo'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'SequenceNo'
        DataType = ftString
        ParamType = ptInput
      end>
    object qWidthKnivesPart: TStringField
      FieldName = 'Part'
    end
    object qWidthKnivesAltMaterial: TStringField
      FieldName = 'AltMaterial'
    end
    object qWidthKnivesWidthNo: TSmallintField
      FieldName = 'WidthNo'
    end
    object qWidthKnivesWidth: TStringField
      FieldName = 'Width'
      Size = 10
    end
    object qWidthKnivesKnife: TStringField
      FieldName = 'Knife'
    end
    object qWidthKnivesPairs: TIntegerField
      FieldName = 'Pairs'
    end
    object qWidthKnivesMaxPairs: TSmallintField
      FieldName = 'MaxPairs'
    end
    object qWidthKnivesSeqNo: TFloatField
      FieldName = 'SeqNo'
    end
    object qWidthKnivesInterlockAreaPrimeSynthetic: TFloatField
      FieldName = 'InterlockAreaPrimeSynthetic'
    end
    object qWidthKnivesInterlockAreaNonPrime: TFloatField
      FieldName = 'InterlockAreaNonPrime'
    end
    object qWidthKnivesPSN: TStringField
      FieldName = 'PSN'
      Size = 1
    end
    object qWidthKnivesKnifeCutGap: TSmallintField
      FieldName = 'KnifeCutGap'
    end
    object qWidthKnivesMaterialType: TStringField
      FieldName = 'MaterialType'
      Size = 1
    end
    object qWidthKnivesSLMAllowance: TBooleanField
      FieldName = 'SLMAllowance'
    end
  end
  object qTimesGridFullBatch: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    Left = 223
    Top = 143
  end
  object qNewTickets: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    Left = 113
    Top = 69
  end
  object qTicketTimes: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    Left = 112
    Top = 129
  end
  object qTimesGridSmallBatch: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    Left = 224
    Top = 197
  end
  object qGetData: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      
        'SELECT TT.WeekNo, TT.SequenceNo, TT.TicketNo, P.Code, P.StdBatch' +
        'Size, M.Code as Material, P.SampleSize, P.CostedSize,'
      
        '       P.MadeInPairs, P.CostedAllowance, P.Rest, P.Contingency, ' +
        'P.SLMAllowance, W.Width, W.No, M.Type as MaterialType,'
      
        '       M.Width AS MatWidth, M.QualCoeff, M.AreaCoeff, M.Length A' +
        'S MatLength,'
      '       M.StandardPrice, TT.BasicAllowance,'
      '       TT.TotalPairs as UnitsPerJob,'
      '       COUNT(DISTINCT(TP.Size)) as Sizes,   '
      '       MU.ToFeet, MU.SubUnitsPerUnit, MU.UnitDescription,'
      ''
      '       //Extra Bits for the Cutting Times'
      '       '#39'I'#39' as Units,'
      '       M.SkinSize * MU.ToFeet * MU.ToFeet as Area,'
      '       (M.QualCoeff * 100) + TT.AdjFactorResult as Coefficient,'
      '       M.Layers,'
      
        '       M.Width / MU.SubUnitsPerUnit * MU.ToFeet * 12 as WidthInc' +
        'hes,'
      
        '       M.Length / MU.SubUnitsPerUnit * MU.ToFeet * 12 as LengthI' +
        'nches,'
      '       M.CutType as CuttingType,'
      '       M.Trimmed,'
      '       P.PressTypeLeather as CuttingMethodLeather,'
      '       P.PressTypeSynthetic as CuttingMethodSynthetic,'
      '       P.FeedSystem,'
      '//     0 as AASample,'
      '//     0 as AASampleSynth,'
      '       M.DegDiff as DegreeDifficulty,'
      
        '       M.StrokeDepth / MU.SubUnitsPerUnit * MU.ToFeet * 12 as De' +
        'pth,'
      '       R.TableLength as MaxTableLength, TT.AdjFactorResult'
      
        'FROM Parts P, Widths W, Material M, MatTypes MT, MatUnits MU, Pa' +
        'rams R, TicketTickets TT, TicketTicketsWidths TTW,'
      '     TicketPairage TP'
      'WHERE TT.WeekNo = :WeekNo AND'
      '      TT.SequenceNo = :SequenceNo AND'
      '      TTW.WeekNo = TT.WeekNo AND'
      '      TTW.SequenceNo = TT.SequenceNo AND'
      '      TTW.TicketNo = TT.TicketNo AND'
      '      TP.WeekNo = TT.WeekNo AND'
      '      TP.SequenceNo = TT.SequenceNo AND'
      '      TP.TicketNo = TT.TicketNo AND'
      '//      TP.KnifeIndex = 1 AND'
      '      W.No IN'
      '        (SELECT MIN(W2.No)'
      '         FROM TicketTicketsWidths TTW2, Widths W2'
      '         WHERE WeekNo = TTW.WeekNo AND'
      '               SequenceNo = TTW.SequenceNo AND'
      '               TicketNo = TTW.TicketNo AND'
      '               W2.Width = TTW2.Width) AND'
      '      P.Code = TT.PartCode AND'
      '      M.Code = TT.MaterialCode AND'
      '      M.Units = MU.Code AND'
      '      M.Type = MT.Code AND'
      '      W.Width = TTW.Width'
      
        'GROUP BY TT.WeekNo, TT.SequenceNo, TT.TicketNo, P.Code, P.StdBat' +
        'chSize, M.Code, '
      
        '         P.SampleSize, P.CostedSize, P.MadeInPairs, P.CostedAllo' +
        'wance, P.Rest, P.Contingency, P.SLMAllowance,'
      
        #9#9'     W.Width, W.No, M.Type, M.Width, M.QualCoeff, M.AreaCoeff,' +
        ' M.Length,'
      
        '         M.StandardPrice, TT.BasicAllowance, TT.TotalPairs, MU.T' +
        'oFeet,'
      
        #9#9'     MU.SubUnitsPerUnit, MU.UnitDescription, M.SkinSize, TT.Ad' +
        'jFactorResult,'
      
        '         M.Layers, M.CutType, M.Trimmed, P.PressTypeLeather, P.P' +
        'ressTypeSynthetic, P.FeedSystem, M.DegDiff,'
      '         M.StrokeDepth, R.TableLength')
    Left = 40
    Top = 130
    ParamData = <
      item
        Name = 'WeekNo'
        ParamType = ptInput
      end
      item
        Name = 'SequenceNo'
        ParamType = ptInput
      end>
  end
  object qGetAverageSizes: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      
        'SELECT TT.PartCode, TT.MaterialCode, TT.MaterialType, TT.Materia' +
        'lAreaCoeff, TT.MaterialQualCoeff, TT.SLMAllowance,'
      '       TP.WeekNo, TP.SequenceNo, TP.TicketNo, TP.KnifeIndex,'
      
        '       CONVERT(SUM(SSS.Length * TP.Pairs), SQL_DOUBLE) / CONVERT' +
        '(SUM(TP.Pairs), SQL_DOUBLE) as Average,'
      '       MIN(W.No) as WidthNo'
      
        'FROM TicketTickets TT, TicketPairage TP, SizeScaleSizes SSS, Tic' +
        'ketTicketsWidths TTW,'
      '     Widths W'
      
        'WHERE TT.WeekNo = :WeekNo AND TT.SequenceNo = :SequenceNo AND TT' +
        '.TicketNo = :TicketNo AND'
      
        '      TP. WeekNo = TT.WeekNo AND TP.SequenceNo = TT.SequenceNo A' +
        'ND'
      
        '      TP.TicketNo = TT.TicketNo AND TTW.WeekNo = TT.WeekNo AND S' +
        'SS.Scale = TT.SizeScale AND'
      
        '      TTW.SequenceNo = TT.SequenceNo AND TTW.TicketNo = TT.Ticke' +
        'tNo AND'
      
        '      W.Width = TTW.Width AND NOT(TP.SizeIndex= -999) AND SSS.Si' +
        'ze = TP.Size'
      
        'GROUP BY TT.PartCode, TT.MaterialCode, TT.MaterialType, TT.Mater' +
        'ialAreaCoeff, TT.MaterialQualCoeff, TT.SLMAllowance,'
      '         TP.WeekNo, TP.SequenceNo, TP.TicketNo, TP.KnifeIndex')
    Left = 34
    Top = 195
    ParamData = <
      item
        Name = 'WeekNo'
        ParamType = ptInput
      end
      item
        Name = 'SequenceNo'
        ParamType = ptInput
      end
      item
        Name = 'TicketNo'
        ParamType = ptInput
      end>
    object qGetAverageSizesPartCode: TStringField
      FieldName = 'PartCode'
    end
    object qGetAverageSizesMaterialCode: TStringField
      FieldName = 'MaterialCode'
    end
    object qGetAverageSizesMaterialType: TStringField
      FieldName = 'MaterialType'
      Size = 1
    end
    object qGetAverageSizesMaterialAreaCoeff: TIntegerField
      FieldName = 'MaterialAreaCoeff'
    end
    object qGetAverageSizesMaterialQualCoeff: TIntegerField
      FieldName = 'MaterialQualCoeff'
    end
    object qGetAverageSizesWeekNo: TSmallintField
      FieldName = 'WeekNo'
    end
    object qGetAverageSizesSequenceNo: TSmallintField
      FieldName = 'SequenceNo'
    end
    object qGetAverageSizesTicketNo: TSmallintField
      FieldName = 'TicketNo'
    end
    object qGetAverageSizesKnifeIndex: TFloatField
      FieldName = 'KnifeIndex'
    end
    object qGetAverageSizesAverage: TFloatField
      FieldName = 'Average'
    end
    object qGetAverageSizesWidthNo: TSmallintField
      FieldName = 'WidthNo'
    end
    object qGetAverageSizesSLMAllowance: TBooleanField
      FieldName = 'SLMAllowance'
    end
  end
  object qWhatTickets: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT TicketNo, SLMAllowance '
      'FROM TicketTickets'
      'WHERE WeekNo = :WeekNo AND SequenceNo = :SequenceNo')
    Left = 38
    Top = 250
    ParamData = <
      item
        Name = 'WeekNo'
        ParamType = ptInput
      end
      item
        Name = 'SequenceNo'
        ParamType = ptInput
      end>
    object qWhatTicketsTicketNo: TSmallintField
      FieldName = 'TicketNo'
    end
    object qWhatTicketsSLMAllowance: TBooleanField
      FieldName = 'SLMAllowance'
    end
  end
  object qInvalidTickets: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    Left = 186
    Top = 69
  end
  object qBAForTickets: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      '//DUMMY STRING'
      ''
      
        'SELECT PWK.Seq, PWK.Knife, SUM(PWK.Frequency) as Frequency, COUN' +
        'T(PWK.WidthNo) as NumWidths, 1 AS NumberOfKnives, '#39'L'#39' AS MatType' +
        ', 99 AS AreaCoeff, 81 AS QualCoeff,'
      
        '       1 as SqFtPerPiece, P.SampleSize AS ShoeSize, KS.Type AS K' +
        'nifeType, K.InterlockAreaPrimeSynthetic,'
      
        '       K.InterlockAreaNonPrime, KS.Pieces, K.GrossArea, K.NettAr' +
        'ea, MU.ToFeet, MU.SubUnitsPerUnit, M.SkinSize,'
      
        '  '#9'   M.Length AS MatLength, M.Width AS MatWidth, M.CutType, M.T' +
        'rimmed, M.LinearAllowance, SSS.Length AS SampleSizeMm, True as S' +
        'LMAllowance,'
      
        '       PM.TableLength, PM.BAQuadraticA, PM.BAQuadraticB, PM.BAQu' +
        'adraticC'
      
        'FROM PtWidKnf PWK, Parts P, Knives K, KnifeSets KS, MatUnits MU,' +
        ' Material M, SizeScaleSizes SSS, Params PM'
      
        'WHERE P.Code = '#39'GUS'#39' AND M.Code = '#39'30082'#39' AND PWK.Part = P.Code ' +
        'AND'
      
        '      K.Code = PWK.Knife AND KS.Code = PWK.Knife AND MU.Code = M' +
        '.Units AND'
      '      SSS.Scale = P.SizeScale AND SSS.Size = P.SampleSize'
      
        'GROUP BY PWK.Seq, PWK.Knife, P.SampleSize, KS.Type, K.InterlockA' +
        'reaPrimeSynthetic,'
      
        '         K.InterlockAreaNonPrime, KS.Pieces, K.GrossArea, K.Nett' +
        'Area, MU.ToFeet, MU.SubUnitsPerUnit,'
      
        '    '#9#9' M.SkinSize, M.Length, M.Width, M.CutType, M.Trimmed, M.Li' +
        'nearAllowance, SSS.Length,'
      
        '         PM.TableLength, PM.BAQuadraticA, PM.BAQuadraticB, PM.BA' +
        'QuadraticC'
      'Order By PWK.Seq, PWK.Seq')
    Left = 303
    Top = 43
    object qBAForTicketsKnife: TStringField
      FieldName = 'Knife'
    end
    object qBAForTicketsSeq: TFloatField
      FieldName = 'Seq'
    end
    object qBAForTicketsFrequency: TSmallintField
      FieldName = 'Frequency'
    end
    object qBAForTicketsNumberOfKnives: TIntegerField
      FieldName = 'NumberOfKnives'
    end
    object qBAForTicketsMatType: TStringField
      FieldName = 'MatType'
      Size = 1
    end
    object qBAForTicketsAreaCoeff: TIntegerField
      FieldName = 'AreaCoeff'
    end
    object qBAForTicketsQualCoeff: TIntegerField
      FieldName = 'QualCoeff'
    end
    object qBAForTicketsShoeSize: TStringField
      FieldName = 'ShoeSize'
      Size = 10
    end
    object qBAForTicketsKnifeType: TStringField
      FieldName = 'KnifeType'
      Size = 1
    end
    object qBAForTicketsKnifeCutGap: TIntegerField
      FieldName = 'KnifeCutGap'
    end
    object qBAForTicketsInterlockAreaPrimeSynthetic: TFloatField
      FieldName = 'InterlockAreaPrimeSynthetic'
    end
    object qBAForTicketsInterlockAreaNonPrime: TFloatField
      FieldName = 'InterlockAreaNonPrime'
    end
    object qBAForTicketsPieces: TSmallintField
      FieldName = 'Pieces'
    end
    object qBAForTicketsGrossArea: TFloatField
      FieldName = 'GrossArea'
    end
    object qBAForTicketsNettArea: TFloatField
      FieldName = 'NettArea'
    end
    object qBAForTicketsToFeet: TFloatField
      FieldName = 'ToFeet'
    end
    object qBAForTicketsSubUnitsPerUnit: TSmallintField
      FieldName = 'SubUnitsPerUnit'
    end
    object qBAForTicketsSkinSize: TFloatField
      FieldName = 'SkinSize'
    end
    object qBAForTicketsMatLength: TFloatField
      FieldName = 'MatLength'
    end
    object qBAForTicketsMatWidth: TFloatField
      FieldName = 'MatWidth'
    end
    object qBAForTicketsCutType: TStringField
      FieldName = 'CutType'
      Size = 1
    end
    object qBAForTicketsTrimmed: TBooleanField
      FieldName = 'Trimmed'
    end
    object qBAForTicketsSampleSizeMm: TSmallintField
      FieldName = 'SampleSizeMm'
    end
    object qBAForTicketsTableLength: TFloatField
      FieldName = 'TableLength'
    end
    object qBAForTicketsBAQuadraticA: TFloatField
      FieldName = 'BAQuadraticA'
    end
    object qBAForTicketsBAQuadraticB: TFloatField
      FieldName = 'BAQuadraticB'
    end
    object qBAForTicketsBAQuadraticC: TFloatField
      FieldName = 'BAQuadraticC'
    end
    object qBAForTicketsNumWidths: TIntegerField
      FieldName = 'NumWidths'
    end
    object qBAForTicketsSqFtPerPiece: TFloatField
      FieldName = 'SqFtPerPiece'
    end
    object qBAForTicketsSLMAllowance: TBooleanField
      FieldName = 'SLMAllowance'
    end
    object qBAForTicketsMadeInParts: TBooleanField
      FieldName = 'MadeInPairs'
    end
    object qBAForTicketsLinearAllowance: TBooleanField
      FieldName = 'LinearAllowance'
    end
  end
  object qCheckFullSynthetics: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT KnifeCode, Size'
      'FROM TicketPairage')
    Left = 121
    Top = 187
    object qCheckFullSyntheticsPartCode: TStringField
      FieldName = 'PartCode'
    end
    object qCheckFullSyntheticsKnifeCode: TStringField
      FieldName = 'KnifeCode'
    end
    object qCheckFullSyntheticsSize: TStringField
      FieldName = 'Size'
    end
  end
  object qNoSampleKnife: TFDQueryPlus
    Connection = LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT DISTINCT PWK.Part, PWK.Knife, W.Width  '
      'FROM TicketTicketsWidths TTW, PtWidKnf PWK, Widths W'
      'WHERE TTW.WeekNo = :WeekNo AND TTW.SequenceNo = :SequenceNo AND'
      
        '  PWK.Part = TTW.Part AND PWK.WidthNo = W.No AND W.Width = TTW.W' +
        'idth AND '
      '  NOT EXISTS (SELECT K.Code '
      #9'          FROM Knives K, Parts P'
      
        #9'          WHERE P.Code = PWK.Part AND K.Code = PWK.Knife AND K.' +
        'SizeScale = P.SizeScale AND P.SampleSize = K.MeasuredSize)'
      '')
    Left = 147
    Top = 250
    ParamData = <
      item
        Name = 'WeekNo'
        ParamType = ptInput
      end
      item
        Name = 'SequenceNo'
        ParamType = ptInput
      end>
    object qNoSampleKnifePart: TStringField
      FieldName = 'Part'
    end
    object qNoSampleKnifeKnife: TStringField
      FieldName = 'Knife'
    end
    object qNoSampleKnifeWidth: TStringField
      FieldName = 'Width'
      Size = 10
    end
  end
end
