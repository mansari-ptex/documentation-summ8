object dmTicketsSplit: TdmTicketsSplit
  OldCreateOrder = False
  Height = 480
  Width = 696
  object qGetSizePairs: TFDQueryPlus
    Connection = dmTicketsCreate.LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT TI.*, TTW.TicketNo, SRS.KnifeSize'
      
        'FROM TicketsInput TI, TicketTicketsWidths TTW, PtWidKnf PWK, Siz' +
        'eRelationshipSizes SRS, Widths W'
      'WHERE TTW.WeekNo = :WeekNo AND'
      '      TTW.SequenceNo = :SequenceNo AND'
      '      TTW.TicketNo = :TicketNo AND'
      '      TI.WeekNo = TTW.WeekNo AND'
      '      TI.SequenceNo = TTW.SequenceNo AND'
      '      TI.Width = TTW.Width AND'
      '      TI.Size <> '#39'AddWidth'#39' AND'
      
        '      PWK.Part = TTW.Part AND W.Width = TTW.Width AND PWK.WidthN' +
        'o = W.No AND'
      
        '      SRS.Scale = PWK.SizeScale AND SRS.Range = PWK.SizeRange AN' +
        'D SRS.Relationship = PWK.SizeRelationship AND'
      '      Governor = TRUE AND SRS.ShoeSize = TI.Size  '
      'Order By TI.SizeSeq, TI.SizeSeq, TI.Width')
    Left = 44
    Top = 17
    ParamData = <
      item
        Name = 'WeekNo'
        DataType = ftInteger
        ParamType = ptInput
        Value = 4
      end
      item
        Name = 'SequenceNo'
        DataType = ftSmallint
        ParamType = ptInput
        Value = 1
      end
      item
        Name = 'TicketNo'
        DataType = ftSmallint
        ParamType = ptInput
        Value = 254
      end>
    object qGetSizePairsWeekNo: TSmallintField
      FieldName = 'WeekNo'
    end
    object qGetSizePairsSequenceNo: TSmallintField
      FieldName = 'SequenceNo'
    end
    object qGetSizePairsTicketNo: TSmallintField
      FieldName = 'TicketNo'
    end
    object qGetSizePairsWidth: TStringField
      FieldName = 'Width'
      Size = 10
    end
    object qGetSizePairsSize: TStringField
      FieldName = 'Size'
      Size = 10
    end
    object qGetSizePairsKnifeSize: TStringField
      FieldName = 'KnifeSize'
      Size = 10
    end
    object qGetSizePairsPairs: TIntegerField
      FieldName = 'Pairs'
    end
    object qGetSizePairsWidthNo: TSmallintField
      FieldName = 'WidthNo'
    end
    object qGetSizePairsSizeSeq: TFloatField
      FieldName = 'SizeSeq'
    end
  end
  object qGovernor: TFDQueryPlus
    Connection = dmTicketsCreate.LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'SELECT DISTINCT(SRS.KnifeSize), SSS.Seq'
      
        'FROM PtWidKnf PWK, SizeRelationshipSizes SRS, SizeScaleSizes SSS' +
        ', Widths W'
      
        'WHERE PWK.Part = '#39'Part'#39' AND W.Width = '#39'A'#39' AND PWK.WidthNo = W.No' +
        ' AND'
      
        '      SRS.Scale = PWK.SizeScale AND SRS.Range = PWK.SizeRange AN' +
        'D SRS.Relationship = PWK.SizeRelationship AND'
      
        '      Governor = TRUE AND SSS.Scale = PWK.SizeScale AND SSS.Size' +
        ' = SRS.KnifeSize'
      'Order By SSS.Seq, SSS.Seq, SRS.KnifeSize'
      '')
    Left = 113
    Top = 18
    object qGovernorKnifeSize: TStringField
      FieldName = 'KnifeSize'
      Size = 10
    end
    object qGovernorSeq: TFloatField
      FieldName = 'Seq'
    end
  end
  object qTicketsSplitInput: TFDQueryPlus
    Connection = dmTicketsCreate.LocalConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    Left = 193
    Top = 17
  end
end
