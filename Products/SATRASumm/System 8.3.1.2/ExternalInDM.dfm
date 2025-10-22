object ExternalInDM1: TExternalInDM1
  OldCreateOrder = False
  Height = 386
  Width = 619
  object tblStyles: TFDTable
    IndexName = 'PRIMARY'
    Connection = FDDataConn
    UpdateOptions.UpdateTableName = 'STYLES'
    TableName = 'STYLES'
    Left = 173
    Top = 224
    object tblStylesStyle: TStringField
      FieldName = 'Style'
    end
    object tblStylesCurrentCon: TStringField
      FieldName = 'CurrentCon'
    end
    object tblStylesPicture: TBlobField
      FieldName = 'Picture'
      Size = 1
    end
    object tblStylesDescription: TStringField
      FieldName = 'Description'
      Origin = 'Description'
      FixedChar = True
      Size = 80
    end
  end
  object tblConParts: TFDTable
    IndexName = 'PRIMARY'
    MasterSource = dsStyles
    MasterFields = 'CurrentCon'
    Connection = FDDataConn
    UpdateOptions.UpdateTableName = 'CONPARTS'
    TableName = 'CONPARTS'
    Left = 364
    Top = 224
    object tblConPartsConstruction: TStringField
      FieldName = 'Construction'
    end
    object tblConPartsPart: TStringField
      FieldName = 'Part'
      Origin = 'Part'
      FixedChar = True
    end
    object tblConPartsID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
    end
  end
  object tblParts: TFDTable
    IndexName = 'PRIMARY'
    MasterSource = dsConParts
    MasterFields = 'Part'
    Connection = FDDataConn
    UpdateOptions.UpdateTableName = 'PARTS'
    TableName = 'PARTS'
    Left = 556
    Top = 222
    object tblPartsCode: TStringField
      FieldName = 'Code'
    end
    object tblPartsWidthRange: TStringField
      FieldName = 'WidthRange'
    end
  end
  object tblWidths: TFDTable
    IndexName = 'OWIDTH'
    Connection = FDDataConn
    UpdateOptions.UpdateTableName = 'WIDTHS'
    TableName = 'WIDTHS'
    Left = 117
    Top = 293
    object tblWidthsNo: TSmallintField
      FieldName = 'No'
    end
    object tblWidthsWidth: TStringField
      FieldName = 'Width'
      Size = 10
    end
  end
  object tblWidthRangeWidths: TFDTable
    IndexName = 'PRIMARY'
    Connection = FDDataConn
    UpdateOptions.UpdateTableName = 'WRNGWS'
    TableName = 'WRNGWS'
    Left = 212
    Top = 292
    object tblWidthRangeWidthsRange: TStringField
      FieldName = 'Range'
    end
    object tblWidthRangeWidthsWidthNo: TSmallintField
      FieldName = 'WidthNo'
    end
  end
  object tblPtWidKnf: TFDTable
    IndexName = 'PRIMARY'
    Connection = FDDataConn
    UpdateOptions.UpdateTableName = 'PTWIDKNF'
    TableName = 'PTWIDKNF'
    Left = 469
    Top = 228
    object tblPtWidKnfPart: TStringField
      FieldName = 'Part'
      Origin = 'Part'
      FixedChar = True
    end
    object tblPtWidKnfWidthNo: TSmallintField
      FieldName = 'WidthNo'
      Origin = 'WidthNo'
    end
  end
  object tblSizeRangeSizes: TFDTable
    IndexName = 'PRIMARY'
    Connection = FDDataConn
    UpdateOptions.UpdateTableName = 'SIZERANGESIZES'
    TableName = 'SIZERANGESIZES'
    Left = 45
    Top = 300
    object tblSizeRangeSizesScale: TStringField
      FieldName = 'Scale'
    end
    object tblSizeRangeSizesRange: TStringField
      FieldName = 'Range'
    end
    object tblSizeRangeSizesSize: TStringField
      FieldName = 'Size'
      Size = 10
    end
    object tblSizeRangeSizesSeq: TFloatField
      FieldName = 'Seq'
    end
  end
  object tblConstructions: TFDTable
    IndexName = 'PRIMARY'
    MasterSource = dsStyles
    MasterFields = 'CurrentCon'
    Connection = FDDataConn
    UpdateOptions.UpdateTableName = 'CONSTRUC'
    TableName = 'CONSTRUC'
    Left = 267
    Top = 225
    object tblConstructionsConstruction: TStringField
      FieldName = 'Construction'
    end
    object tblConstructionsSizeRange: TStringField
      FieldName = 'SizeRange'
    end
    object tblConstructionsSizeScale: TStringField
      FieldName = 'SizeScale'
    end
  end
  object qGet: TFDQueryPlus
    Connection = FDDataConn
    SQL.Strings = (
      'SELECT MAX(SequenceNo) + 1 as SequenceNo'
      'FROM TicketSequences'
      'WHERE (WeekNo = :WeekNo) OR (WeekNo = 0)')
    Left = 293
    Top = 291
    ParamData = <
      item
        Name = 'WeekNo'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qGetSequenceNo: TIntegerField
      FieldName = 'SequenceNo'
    end
  end
  object qCommonWidths: TFDQueryPlus
    Connection = FDDataConn
    SQL.Strings = (
      '/*'
      'SELECT DISTINCT W.Width, W.No'
      'FROM ConParts CP, Parts P, WRngWs WRW, Widths W'
      'WHERE CP.Construction = :Construction AND P.Code = CP.Part AND '
      '      P.WidthRange = WRW."Range" AND W.No = WRW.WidthNo'
      '*/'
      ''
      '/*'
      'The above version gathers all widths used in the construction'
      
        'The below version uses the above to get a list that it will only' +
        ' '
      '  show the widths that are used the for the same number of parts'
      '  that exist in the construction... The common ones!'
      '*/'
      ''
      'SELECT TotalWidths.Width, TotalWidths.No '
      'FROM (SELECT COUNT(*) AS TotalPartsCount'
      #9'  FROM ConParts CP, Parts P '
      
        #9'   WHERE CP.Construction = :Construction AND P.Code = CP.Part) ' +
        'TotalParts,'
      #9' (SELECT W.Width, W.No, COUNT(*) AS TotalWidthCount'
      #9'  FROM ConParts CP, Parts P, WRngWs WRW, Widths W'
      
        #9'   WHERE CP.Construction = :Construction AND P.Code = CP.Part A' +
        'ND '
      #9'          P.WidthRange = WRW."Range" AND W.No = WRW.WidthNo'
      #9#9#9'   GROUP BY W.Width, W.No) TotalWidths'
      'WHERE TotalWidths.TotalWidthCount = TotalParts.TotalPartsCount')
    Left = 361
    Top = 289
    ParamData = <
      item
        Name = 'Construction'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
    object qCommonWidthsNo: TSmallintField
      FieldName = 'No'
    end
    object qCommonWidthsWidth: TStringField
      FieldName = 'Width'
      Origin = 'Width'
      FixedChar = True
      Size = 10
    end
  end
  object FDDataConn: TFDConnectionPlus
    Params.Strings = (
      'FDSAdvanced=StoredProcedureConnection=TRUE'
      'User_Name=adssys'
      'Password=monster'
      'Alias=SATRASUMM8'
      'DriverID=ADS')
    AfterConnect = FDDataConnAfterConnect
    BeforeConnect = FDDataConnBeforeConnect
    Left = 240
    Top = 16
  end
  object FDDataConnQ: TFDQueryPlus
    Connection = FDDataConn
    Left = 240
    Top = 72
  end
  object dsStyles: TDataSource
    DataSet = tblStyles
    Left = 208
    Top = 152
  end
  object dsConParts: TDataSource
    DataSet = tblConParts
    Left = 388
    Top = 160
  end
  object mtblOutput: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 360
    Top = 16
    object mtblOutputStyle: TStringField
      FieldName = 'Style'
    end
    object mtblOutputWidth: TStringField
      FieldName = 'Width'
      Size = 10
    end
    object mtblOutputErrorStr: TStringField
      FieldName = 'ErrorStr'
      Size = 60
    end
  end
  object qTicketsInput: TFDQueryPlus
    Connection = FDDataConn
    Left = 520
    Top = 24
  end
end
