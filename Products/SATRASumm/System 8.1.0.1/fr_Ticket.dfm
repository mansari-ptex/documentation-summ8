object fmfrTicket: TfmfrTicket
  Left = 0
  Top = 0
  Caption = 'fmfrTicket'
  ClientHeight = 579
  ClientWidth = 874
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object mSplitTicketNumber: TMemo
    Left = 675
    Top = 14
    Width = 185
    Height = 89
    Lines.Strings = (
      'mSplitTicketNumber')
    TabOrder = 0
  end
  object qShoeSizes: TFDQueryPlus
    Filtered = True
    Filter = 'Pairs <> 0'
    IndexFieldNames = 'WEEKNO;SEQUENCENO;TICKETNO;WIDTHNO;SIZESEQ'
    MasterSource = dsTickets
    MasterFields = 'WeekNo;SequenceNo;TicketNo'
    Connection = fmSumms.ConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      '//Template'
      
        'SELECT TI.WeekNo, TI.SequenceNo, TTW.TicketNo, TI.Width, TI.Size' +
        ', TI.Pairs, TI.WidthNo, TI.SizeSeq'
      'FROM TicketsInput TI, TicketTicketsWidths TTW'
      
        'WHERE TI.WeekNo = 2 AND TI.SequenceNo = 7 AND TTW.WeekNo = TI.We' +
        'ekNo AND'
      'TTW.SequenceNo = TI.SequenceNo'
      'Order By 1, 1, 2, 3, 7, 8')
    Left = 10
    Top = 481
  end
  object frdbShoeSizes: TfrxDBDataset
    UserName = 'frdbShoeSizes'
    CloseDataSource = False
    DataSet = qShoeSizes
    BCDToCurrency = False
    Left = 63
    Top = 74
  end
  object qNominalSizes: TFDQueryPlus
    BeforeOpen = qBeforeOpen
    BeforeExecute = qBeforeExecute
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'DECLARE Pairage Integer;'
      'DECLARE @WeekNo Short, @SequenceNo Short;'
      ''
      '/*'
      'DECLARE TicketCur CURSOR AS '
      '  SELECT DISTINCT TicketNo'
      '  FROM TicketPairage'
      '  WHERE WeekNo = @WeekNo AND SequenceNo = @SequenceNo;'
      '  '
      'DECLARE SizeCur CURSOR AS'
      '  SELECT DISTINCT Size, SizeIndex'
      '  FROM TicketPairage'
      
        '  WHERE WeekNo = @WeekNo AND SequenceNo = @SequenceNo AND Ticket' +
        'No = TicketCur.TicketNo;'
      '  '
      'DECLARE KnifeCur CURSOR AS'
      '  SELECT DISTINCT KnifeCode, KnifeIndex'
      '  FROM TicketPairage'
      
        '  WHERE WeekNo = @WeekNo AND SequenceNo = @SequenceNo AND Ticket' +
        'No = TicketCur.TicketNo;'
      '*/'
      ''
      'SELECT (:WeekNo * 1), (:SequenceNo * 1) FROM System.iota;'
      ''
      '@WeekNo = CAST(:WeekNo AS SQL_INTEGER);'
      '@SequenceNo = CAST(:SequenceNo AS SQL_INTEGER);'
      ''
      
        'CREATE TABLE #TPTemp(WeekNo Short, SequenceNo Short, TicketNo Sh' +
        'ort, Seq Double, SizeIndex Double,'
      '  KnifeCode Char(20), Size Char(20), Pairs integer);'
      ''
      
        'INSERT INTO #TPTemp(WeekNo, SequenceNo, TicketNo, Seq, SizeIndex' +
        ', KnifeCode, Size, Pairs)'
      '  VALUES(0, 0, 0, 0, 0, '#39'0'#39', '#39'0'#39', 0);'
      ''
      
        '//This INSERT will forces the Order By to, to create index by en' +
        'suring there is more than one record returned.'
      
        '//With only one line the Order By clause, clause is not used so ' +
        'no index is created - find a better way when more time.'
      ''
      '/*'
      'OPEN TicketCur;'
      'WHILE FETCH TicketCur DO'
      '  OPEN SizeCur;'
      '  WHILE FETCH SizeCur DO'
      '    OPEN KnifeCur;'
      '    WHILE FETCH KnifeCur DO'
      '      Pairage = (SELECT Pairs'
      #9'             FROM TicketPairage'
      
        #9#9#9#9' WHERE WeekNo = @WeekNo AND SequenceNo = @SequenceNo AND Tic' +
        'ketNo = TicketCur.TicketNo AND'
      
        #9#9#9#9'   KnifeIndex = KnifeCur.KnifeIndex AND SizeIndex = SizeCur.' +
        'SizeIndex);'
      #9'  IF Pairage IS NULL THEN'
      #9'    Pairage = 0;'
      #9'  END IF;'
      
        #9'  INSERT INTO #TPTemp(WeekNo, SequenceNo, TicketNo, Seq, SizeIn' +
        'dex, KnifeCode, Size, Pairs)'
      
        #9'    VALUES(@WeekNo, @SequenceNo, TicketCur.TicketNo, KnifeCur.K' +
        'nifeIndex, SizeCur.SizeIndex, KnifeCur.KnifeCode, SizeCur.Size, ' +
        'Pairage);'
      #9'END WHILE;'
      #9'CLOSE KnifeCur;'
      '  END WHILE;'#9
      '  CLOSE SizeCur;'
      'END WHILE;'
      'CLOSE TicketCur;'
      '*/'
      ''
      
        '//This does not create the 0 pairage values like the previous ve' +
        'rsion'
      ''
      
        'INSERT INTO #TPTemp(WeekNo, SequenceNo, TicketNo, Seq, SizeIndex' +
        ', KnifeCode, Size, Pairs) SELECT WeekNo, SequenceNo, TicketNo, K' +
        'nifeIndex, SizeIndex, KnifeCode, Size, IIF(Pairs IS NULL, 0, Pai' +
        'rs) AS Pairage'
      '  FROM TicketPairage   '
      '  WHERE WeekNo = @WeekNo AND SequenceNo = @SequenceNo;'
      ''
      '//SELECT *'
      '//FROM #TPTemp'
      '//Order By WeekNo, WeekNo, SequenceNo, TicketNo, Seq, SizeIndex')
    Left = 140
    Top = 497
    ParamData = <
      item
        Name = 'WeekNo'
        DataType = ftSmallint
        ParamType = ptInput
      end
      item
        Name = 'SequenceNo'
        DataType = ftSmallint
        ParamType = ptInput
      end>
  end
  object frdbNominalSizes: TfrxDBDataset
    UserName = 'frdbNominalSizes'
    CloseDataSource = False
    DataSet = qNominalSizes2
    BCDToCurrency = False
    Left = 98
    Top = 230
  end
  object qMakeGrid: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    Left = 66
    Top = 142
  end
  object qLeatherGrid: TFDQueryPlus
    BeforeOpen = qBeforeOpen
    OnCalcFields = qLeatherGridCalcFields
    BeforeExecute = qBeforeExecute
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'SELECT *'
      'FROM #Temp')
    Left = 184
    Top = 138
    object qLeatherGridArea: TIntegerField
      FieldName = 'Area'
    end
    object qLeatherGridQual: TIntegerField
      FieldName = 'Qual'
    end
    object qLeatherGridAllowance: TFloatField
      FieldKind = fkCalculated
      FieldName = 'Allowance'
      Calculated = True
    end
  end
  object dsLeatherGrid: TDataSource
    DataSet = qLeatherGrid
    Left = 52
    Top = 237
  end
  object frLeatherGrid: TfrxDBDataset
    UserName = 'frLeatherGrid'
    CloseDataSource = False
    DataSet = qLeatherGrid
    BCDToCurrency = False
    Left = 18
    Top = 210
  end
  object frTicket: TfrxReportPlus
    Version = '4.15'
    DataSet = frdbTickets
    DataSetName = 'frdbTickets'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbNoFullScreen]
    PreviewOptions.MDIChild = True
    PreviewOptions.Modal = False
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 40584.515990879600000000
    ReportOptions.LastChange = 43255.584186979170000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      
        'procedure DBCross3OnPrintRowHeader(Memo: TfrxMemoView; HeaderInd' +
        'exes, HeaderValues, Value: Variant);'
      'begin'
      '  if Value = 0 then'
      '  begin'
      
        '    Memo.UseDefaultCharSet := True;                             ' +
        '                                                        '
      '    Memo.Font.Charset := 2;'
      '    Memo.Font.Size := 12;'
      '    if Get('#39'CuttingTimes'#39') then'
      '      Memo.Text := '#39#185#39' //Clock'
      '    else'
      
        '      Memo.Text := '#39#39';                                          ' +
        '                   '
      '    Memo.Frame.TopLine.Width := 2;'
      '    Memo.Frame.RightLine.Width := 1;'
      ''
      '    if (not Get('#39'GridLines'#39')) or (not Get('#39'CuttingTimes'#39')) then'
      '      Memo.Frame.Typ := 0;'
      '  end'
      '  else'
      '  begin              '
      '    Memo.Font := cbLeatherGrid.Font;    '
      '      '
      
        '    if not(Get('#39'GridLines'#39')) then                               ' +
        '                         '
      '      Memo.Frame.Typ := 0;'
      '  end;                          '
      'end;'
      ''
      
        'procedure DBCross3OnPrintColumnHeader(Memo: TfrxMemoView; Header' +
        'Indexes, HeaderValues, Value: Variant);'
      'begin'
      '  Memo.Font := cbLeatherGrid.Font;'
      '    '
      '  if not(Get('#39'GridLines'#39')) then  '
      '    Memo.Frame.Typ := 0;        '
      'end;'
      '  '
      
        'procedure DBCross3OnPrintCell(Memo: TfrxMemoView; RowIndex, Colu' +
        'mnIndex, CellIndex: Integer; RowValues, ColumnValues, Value: Var' +
        'iant);'
      'begin'
      '  Memo.Font := cbLeatherGrid.Font;'
      '  if (RowIndex = Get('#39'NumberOfRows'#39')) then'
      '  begin              '
      '    Memo.Frame.TopLine.Width := 2;'
      '    Memo.Font.Style := fsItalic;'
      ''
      '    if (Value = 0.00) then'
      
        '      Memo.Text := '#39'x.xx'#39';                                      ' +
        '         '
      '  end;'
      ''
      
        '  if (not Get('#39'CuttingTimes'#39')) and (RowIndex = Get('#39'NumberOfRows' +
        #39')) then'
      
        '    Memo.Text := '#39#39';                                            ' +
        '                                        '
      '    '
      '  if (not Get('#39'GridLines'#39')) or'
      
        '     ((not Get('#39'CuttingTimes'#39')) and (RowIndex = Get('#39'NumberOfRow' +
        's'#39'))) then'
      '    Memo.Frame.Typ := 0;        '
      'end;'
      ''
      'procedure cbLeatherGridOnBeforePrint(Sender: TfrxComponent);'
      'begin'
      
        '  if cbLeatherGrid.Visible then                                 ' +
        '                      '
      
        '    mVerticalArea.Top := Engine.CurY + 40                     //' +
        'Aligning '#39'Area'#39' label'
      '  else'
      '    mVerticalArea.Visible := false;        '
      'end;'
      ''
      'procedure cbLeatherGridOnAfterPrint(Sender: TfrxComponent);'
      'begin'
      '  if cbLeatherGrid.Visible then    '
      
        '    mVerticalArea.Height := Engine.CurY - mVerticalArea.Top - 20' +
        ';      //Aligning '#39'Area'#39' label                                  ' +
        '                                                        '
      'end;'
      ''
      
        'procedure DBCross4OnPrintColumnHeader(Memo: TfrxMemoView; Header' +
        'Indexes, HeaderValues, Value: Variant);'
      'begin'
      '  if Value = '#39'9999'#39' then'
      '  begin'
      '    Memo.UseDefaultCharSet := True;      '
      '    Memo.Font.Charset := 2;'
      '    Memo.Font.Size := 12;'
      '    if Get('#39'CuttingTimes'#39') then'
      '      Memo.Text := '#39#185#39' //Clock'
      '    else'
      
        '      Memo.Text := '#39#39';                                          ' +
        '                   '
      '    Memo.Frame.LeftLine.Width := 2;'
      ''
      '    if (not Get('#39'GridLines'#39')) or (not Get('#39'CuttingTimes'#39')) then'
      '      Memo.Frame.Typ := 0;'
      '  end'
      '  else'
      '  begin              '
      '    Memo.Font := cbSyntheticGrid.Font;    '
      '      '
      '    if not(Get('#39'GridLines'#39')) then'
      '      Memo.Frame.Typ := 0;'
      '  end;                          '
      'end;'
      ''
      
        'procedure DBCross4OnPrintCell(Memo: TfrxMemoView; RowIndex, Colu' +
        'mnIndex, CellIndex: Integer; RowValues, ColumnValues, Value: Var' +
        'iant);'
      'begin'
      '  Memo.Font := cbSyntheticGrid.Font;    '
      
        '  if ColumnIndex = 11 then                                      ' +
        '                       '
      '    Memo.Frame.LeftLine.Width := 2;'
      ''
      '  if (not Get('#39'CuttingTimes'#39')) and (ColumnIndex = 11) then'
      
        '    Memo.Text := '#39#39';                                            ' +
        '                                        '
      '      '
      '  if (not Get('#39'GridLines'#39')) or'
      '     (not Get('#39'CuttingTimes'#39')) and (ColumnIndex = 11) then'
      '    Memo.Frame.Typ := 0;        '
      'end;'
      ''
      'procedure Page1OnBeforePrint(Sender: TfrxComponent);'
      'begin'
      '  DBCross1Corner3.Text := Get('#39'ShoeSizes'#39');'
      '  DBCross1Corner3.Font := cbShoeSizes.Font;      '
      '  DBCross2Corner3.Text := Get('#39'KnifeCode'#39');'
      '  DBCross2Corner3.Font := cbKnifeSizes.Font;      '
      '  if not(Get('#39'GridLines'#39')) then'
      '  begin              '
      '    DBCross1Corner3.Frame.Typ := 0;'
      '    DBCross2Corner3.Frame.Typ := 0;'
      '  end;              '
      '  DBCross3Corner1.Text := Get('#39'Quality'#39');'
      '  DBCross3Corner1.Font := cbLeatherGrid.Font;      '
      '  DBCross4Corner1.Text := Get('#39'WidthIn'#39');'
      '  DBCross4Corner1.Font := cbSyntheticGrid.Font;      '
      'end;'
      ''
      
        'procedure DBCross1OnPrintColumnHeader(Memo: TfrxMemoView; Header' +
        'Indexes, HeaderValues, Value: Variant);'
      'begin'
      '  Memo.Font := cbShoeSizes.Font;    '
      '  if not(Get('#39'GridLines'#39')) then  '
      
        '    Memo.Frame.Typ := 0;                                        ' +
        '                                    '
      'end;'
      ''
      
        'procedure DBCross2OnPrintColumnHeader(Memo: TfrxMemoView; Header' +
        'Indexes, HeaderValues, Value: Variant);'
      'begin'
      '  if Memo.Name = '#39'DBCross2Column1'#39' then                   '
      '    Memo.Font := cbKnifeSizes.Font;    '
      '  if not(Get('#39'GridLines'#39')) then  '
      '    Memo.Frame.Typ := 0;        '
      'end;'
      ''
      
        'procedure DBCross2OnPrintCell(Memo: TfrxMemoView; RowIndex, Colu' +
        'mnIndex, CellIndex: Integer; RowValues, ColumnValues, Value: Var' +
        'iant);'
      'begin'
      '  Memo.Font := cbKnifeSizes.Font;    '
      '  if not(Get('#39'GridLines'#39')) then  '
      '    Memo.Frame.Typ := 0;        '
      'end;'
      ''
      
        'procedure DBCross1OnPrintCell(Memo: TfrxMemoView; RowIndex, Colu' +
        'mnIndex, CellIndex: Integer; RowValues, ColumnValues, Value: Var' +
        'iant);'
      'begin'
      '  Memo.Font := cbShoeSizes.Font;    '
      '  if not(Get('#39'GridLines'#39')) then  '
      '    Memo.Frame.Typ := 0;        '
      'end;'
      ''
      'procedure Page1OnAfterPrint(Sender: TfrxComponent);'
      'begin'
      '  set('#39'PageNumber'#39', 8);  '
      'end;'
      ''
      'begin'
      ''
      'end.'
      ''
      
        '//It was very tricky to align the '#39'Area'#39' vertical label. DBCross' +
        'Tabs do not align to bands (they are sort of at the same level).' +
        ' If a DBCrossTab'
      
        '//is on a band the band does not grow. However, the band does al' +
        'ways end up aligned to the bottom of the DBCrossTab. DBCrossTabs' +
        ' on their own '
      
        '//do not make Engine.CurY return a correct value - Engine.CurY o' +
        'nly works with bands. Therefore, by combining bands with DBCross' +
        'Tabs it is possible'
      
        '//to get a correct value of CurY and this can be used (as above ' +
        'code shows) to align the label as required.'
      
        '//NB - ensure '#39'Area'#39' label is NOT on a band, just directly on th' +
        'e report.                                                       ' +
        '                                                                ' +
        '                          ')
    OnBeforePrint = frTicketBeforePrint
    OnEndDoc = frTicketEndDoc
    OnGetValue = frTicketGetValue
    OnPrintPage = frTicketPrintPage
    OnAfterPrintReport = frTicketAfterPrintReport
    ReportSettings = fmSumms.frxReportSettings
    Left = 60
    Top = 37
    Datasets = <
      item
        DataSet = frdbNominalSizes
        DataSetName = 'frdbNominalSizes'
      end
      item
        DataSet = frdbShoeSizes
        DataSetName = 'frdbShoeSizes'
      end
      item
        DataSet = frdbSynthGrid
        DataSetName = 'frdbSynthGrid'
      end
      item
        DataSet = frdbTickets
        DataSetName = 'frdbTickets'
      end
      item
        DataSet = frdbTicketTimes
        DataSetName = 'frdbTicketTimes'
      end
      item
        DataSet = frLeatherGrid
        DataSetName = 'frLeatherGrid'
      end
      item
        DataSet = frMyArray
        DataSetName = 'frMyArray'
      end>
    Variables = <
      item
        Name = ' Input'
        Value = Null
      end
      item
        Name = 'PageNumber'
        Value = Null
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      Orientation = poLandscape
      PaperWidth = 297.000000000000000000
      PaperHeight = 210.000000000000000000
      PaperSize = 9
      LeftMargin = 10.001250000000000000
      RightMargin = 10.001250000000000000
      TopMargin = 10.001250000000000000
      BottomMargin = 10.001250000000000000
      LargeDesignHeight = True
      OnAfterPrint = 'Page1OnAfterPrint'
      OnBeforePrint = 'Page1OnBeforePrint'
      object ReportTitle1: TfrxReportTitle
        Height = 35.000000000000000000
        Top = 18.897650000000000000
        Width = 1046.920361175000000000
        Child = frTicket.cbMainDetails
        object mSATRASummCuttingTicket: TfrxMemoView
          Width = 227.000000000000000000
          Height = 25.000000000000000000
          ShowHint = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Memo.UTF8W = (
            '[1]')
          ParentFont = False
        end
        object mTicketNumber: TfrxMemoView
          Left = 350.000000000000000000
          Top = 3.000000000000000000
          Width = 91.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Memo.UTF8W = (
            '[2]')
          ParentFont = False
        end
        object mCutWeek: TfrxMemoView
          Left = 864.000000000000000000
          Top = 3.000000000000000000
          Width = 104.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            '[4] __________')
          ParentFont = False
        end
        object mCutterNumber: TfrxMemoView
          Left = 620.000000000000000000
          Top = 3.000000000000000000
          Width = 101.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Memo.UTF8W = (
            '[3] __________')
          ParentFont = False
        end
        object mTicketNum: TfrxMemoView
          Left = 450.000000000000000000
          Top = 3.000000000000000000
          Width = 81.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'TicketNumber'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Memo.UTF8W = (
            '[frdbTickets."TicketNumber"]')
          ParentFont = False
        end
        object Date: TfrxMemoView
          Left = 250.000000000000000000
          Width = 80.000000000000000000
          Height = 20.000000000000000000
          ShowHint = False
          AutoWidth = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Memo.UTF8W = (
            '[Date]')
          ParentFont = False
        end
      end
      object cbShoeSizes: TfrxChild
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Height = 92.598425196850390000
        ParentFont = False
        Top = 347.716760000000000000
        Width = 1046.920361175000000000
        Child = frTicket.cbKnifeSizes
        object DBCross1: TfrxDBCrossView
          ShiftMode = smDontShift
          Top = 12.472440944881900000
          Width = 154.015748031496100000
          Height = 70.000000000000000000
          ShowHint = False
          AutoSize = False
          Border = False
          DownThenAcross = False
          GapY = 1
          MaxWidth = 968
          ShowColumnTotal = False
          ShowRowTotal = False
          ShowTitle = False
          OnPrintCell = 'DBCross1OnPrintCell'
          OnPrintColumnHeader = 'DBCross1OnPrintColumnHeader'
          OnPrintRowHeader = 'DBCross1OnPrintColumnHeader'
          CellFields.Strings = (
            'Pairs')
          ColumnFields.Strings = (
            'Size')
          DataSet = frdbShoeSizes
          DataSetName = 'frdbShoeSizes'
          RowFields.Strings = (
            'Width')
          Memos = {
            3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D227574
            662D3822207374616E64616C6F6E653D226E6F223F3E3C63726F73733E3C6365
            6C6C6D656D6F733E3C546672784D656D6F56696577204C6566743D2231303022
            20546F703D223339352E313839323030393434383832222057696474683D2233
            342E3031353734383033313439363122204865696768743D2231352220526573
            7472696374696F6E733D223234222053686F7748696E743D2246616C73652220
            416C6C6F7745787072657373696F6E733D2246616C73652220466F6E742E4368
            61727365743D22302220466F6E742E436F6C6F723D22302220466F6E742E4865
            696768743D222D31312220466F6E742E4E616D653D22436F7572696572204E65
            772220466F6E742E5374796C653D223022204672616D652E4C6566744C696E65
            2E57696474683D223022204672616D652E52696768744C696E652E5769647468
            3D22302220476170583D2233222048416C69676E3D2268615269676874222050
            6172656E74466F6E743D2246616C7365222056416C69676E3D22766143656E74
            65722220546578743D2230222F3E3C546672784D656D6F56696577204C656674
            3D223131332220546F703D223434222057696474683D22333922204865696768
            743D22323222205265737472696374696F6E733D223234222053686F7748696E
            743D2246616C73652220416C6C6F7745787072657373696F6E733D2246616C73
            6522204672616D652E5479703D2231352220476170583D2233222048416C6967
            6E3D2268615269676874222056416C69676E3D22766143656E74657222205465
            78743D2230222F3E3C546672784D656D6F56696577204C6566743D2231343622
            20546F703D223434222057696474683D22383122204865696768743D22323222
            205265737472696374696F6E733D223234222053686F7748696E743D2246616C
            73652220416C6C6F7745787072657373696F6E733D2246616C73652220467261
            6D652E5479703D2231352220476170583D2233222048416C69676E3D22686152
            69676874222056416C69676E3D22766143656E7465722220546578743D223022
            2F3E3C546672784D656D6F56696577204C6566743D223134362220546F703D22
            3636222057696474683D22383122204865696768743D22323222205265737472
            696374696F6E733D223234222053686F7748696E743D2246616C73652220416C
            6C6F7745787072657373696F6E733D2246616C736522204672616D652E547970
            3D2231352220476170583D2233222048416C69676E3D22686152696768742220
            56416C69676E3D22766143656E7465722220546578743D2230222F3E3C2F6365
            6C6C6D656D6F733E3C63656C6C6865616465726D656D6F733E3C546672784D65
            6D6F56696577204C6566743D22302220546F703D2230222057696474683D2232
            303022204865696768743D223022205265737472696374696F6E733D22382220
            53686F7748696E743D2246616C73652220416C6C6F7745787072657373696F6E
            733D2246616C736522204672616D652E5479703D2231352220476170583D2233
            222056416C69676E3D22766143656E7465722220546578743D22506169727322
            2F3E3C546672784D656D6F56696577204C6566743D22302220546F703D223022
            2057696474683D2232303022204865696768743D223022205265737472696374
            696F6E733D2238222053686F7748696E743D2246616C73652220416C6C6F7745
            787072657373696F6E733D2246616C736522204672616D652E5479703D223135
            2220476170583D2233222056416C69676E3D22766143656E7465722220546578
            743D225061697273222F3E3C2F63656C6C6865616465726D656D6F733E3C636F
            6C756D6E6D656D6F733E3C546672784D656D6F56696577204C6566743D223130
            302220546F703D223338302E313839323030393434383832222057696474683D
            2233342E3031353734383033313439363122204865696768743D223135222052
            65737472696374696F6E733D223234222053686F7748696E743D2246616C7365
            2220416C6C6F7745787072657373696F6E733D2246616C73652220466F6E742E
            436861727365743D22302220466F6E742E436F6C6F723D22302220466F6E742E
            4865696768743D222D31312220466F6E742E4E616D653D22436F757269657220
            4E65772220466F6E742E5374796C653D223022204672616D652E5479703D2238
            22204672616D652E4C6566744C696E652E57696474683D223022204672616D65
            2E52696768744C696E652E57696474683D22302220476170583D223322204841
            6C69676E3D22686152696768742220506172656E74466F6E743D2246616C7365
            2220576F7264577261703D2246616C7365222056416C69676E3D22766143656E
            7465722220546578743D22222F3E3C2F636F6C756D6E6D656D6F733E3C636F6C
            756D6E746F74616C6D656D6F733E3C546672784D656D6F56696577204C656674
            3D223134362220546F703D223232222057696474683D22383122204865696768
            743D22323222205265737472696374696F6E733D2238222056697369626C653D
            2246616C7365222053686F7748696E743D2246616C73652220416C6C6F774578
            7072657373696F6E733D2246616C73652220466F6E742E436861727365743D22
            312220466F6E742E436F6C6F723D22302220466F6E742E4865696768743D222D
            31332220466F6E742E4E616D653D22417269616C2220466F6E742E5374796C65
            3D223122204672616D652E5479703D2231352220476170583D2233222048416C
            69676E3D22686143656E7465722220506172656E74466F6E743D2246616C7365
            222056416C69676E3D22766143656E7465722220546578743D224772616E6420
            546F74616C222F3E3C2F636F6C756D6E746F74616C6D656D6F733E3C636F726E
            65726D656D6F733E3C546672784D656D6F56696577204C6566743D2232302220
            546F703D223338302E313839323030393434383832222057696474683D223830
            22204865696768743D223022205265737472696374696F6E733D223822205669
            7369626C653D2246616C7365222053686F7748696E743D2246616C7365222041
            6C6C6F7745787072657373696F6E733D2246616C736522204672616D652E5479
            703D2231352220476170583D2233222048416C69676E3D22686143656E746572
            222056416C69676E3D22766143656E7465722220546578743D22506169727322
            2F3E3C546672784D656D6F56696577204C6566743D223130302220546F703D22
            3338302E313839323030393434383832222057696474683D2233342E30313537
            34383033313439363122204865696768743D223022205265737472696374696F
            6E733D2238222056697369626C653D2246616C7365222053686F7748696E743D
            2246616C73652220416C6C6F7745787072657373696F6E733D2246616C736522
            204672616D652E5479703D2231352220476170583D2233222048416C69676E3D
            22686143656E746572222056416C69676E3D22766143656E7465722220546578
            743D2253697A65222F3E3C546672784D656D6F56696577204C6566743D223022
            20546F703D2230222057696474683D2232303022204865696768743D22302220
            5265737472696374696F6E733D2238222056697369626C653D2246616C736522
            2053686F7748696E743D2246616C73652220416C6C6F7745787072657373696F
            6E733D2246616C736522204672616D652E5479703D2231352220476170583D22
            33222048416C69676E3D22686143656E746572222056416C69676E3D22766143
            656E7465722220546578743D22222F3E3C546672784D656D6F56696577204C65
            66743D2232302220546F703D223338302E313839323030393434383832222057
            696474683D22383022204865696768743D22313522205265737472696374696F
            6E733D2238222053686F7748696E743D2246616C73652220416C6C6F77457870
            72657373696F6E733D2246616C73652220466F6E742E436861727365743D2230
            2220466F6E742E436F6C6F723D22302220466F6E742E4865696768743D222D31
            312220466F6E742E4E616D653D22436F7572696572204E65772220466F6E742E
            5374796C653D223022204672616D652E5479703D22382220476170583D223322
            20506172656E74466F6E743D2246616C7365222056416C69676E3D2276614365
            6E7465722220546578743D2253686F652053697A6573222F3E3C2F636F726E65
            726D656D6F733E3C726F776D656D6F733E3C546672784D656D6F56696577204C
            6566743D2232302220546F703D223339352E3138393230303934343838322220
            57696474683D22383022204865696768743D2231352220526573747269637469
            6F6E733D223234222053686F7748696E743D2246616C73652220416C6C6F7745
            787072657373696F6E733D2246616C73652220466F6E742E436861727365743D
            22302220466F6E742E436F6C6F723D22302220466F6E742E4865696768743D22
            2D31312220466F6E742E4E616D653D22436F7572696572204E65772220466F6E
            742E5374796C653D22302220476170583D22332220506172656E74466F6E743D
            2246616C7365222056416C69676E3D22766143656E7465722220546578743D22
            222F3E3C2F726F776D656D6F733E3C726F77746F74616C6D656D6F733E3C5466
            72784D656D6F56696577204C6566743D22302220546F703D2236362220576964
            74683D22383122204865696768743D22323222205265737472696374696F6E73
            3D2238222056697369626C653D2246616C7365222053686F7748696E743D2246
            616C73652220416C6C6F7745787072657373696F6E733D2246616C7365222046
            6F6E742E436861727365743D22312220466F6E742E436F6C6F723D2230222046
            6F6E742E4865696768743D222D31332220466F6E742E4E616D653D2241726961
            6C2220466F6E742E5374796C653D223122204672616D652E5479703D22313522
            20476170583D2233222048416C69676E3D22686143656E746572222050617265
            6E74466F6E743D2246616C7365222056416C69676E3D22766143656E74657222
            20546578743D224772616E6420546F74616C222F3E3C2F726F77746F74616C6D
            656D6F733E3C63656C6C66756E6374696F6E733E3C6974656D20312F3E3C2F63
            656C6C66756E6374696F6E733E3C636F6C756D6E736F72743E3C6974656D2032
            2F3E3C2F636F6C756D6E736F72743E3C726F77736F72743E3C6974656D20322F
            3E3C2F726F77736F72743E3C2F63726F73733E}
        end
      end
      object cbKnifeSizes: TfrxChild
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        Height = 85.000000000000000000
        ParentFont = False
        Top = 464.882190000000000000
        Width = 1046.920361175000000000
        Child = frTicket.cbSheet
        object DBCross2: TfrxDBCrossView
          ShiftMode = smDontShift
          Width = 257.795275590551200000
          Height = 72.000000000000000000
          ShowHint = False
          AutoSize = False
          Border = False
          ColumnLevels = 2
          DownThenAcross = False
          GapY = 1
          MaxWidth = 968
          ShowColumnTotal = False
          ShowRowTotal = False
          ShowTitle = False
          OnPrintCell = 'DBCross2OnPrintCell'
          OnPrintColumnHeader = 'DBCross2OnPrintColumnHeader'
          CellFields.Strings = (
            'Pairs')
          ColumnFields.Strings = (
            'SizeIndex'
            'Size')
          DataSet = frdbNominalSizes
          DataSetName = 'frdbNominalSizes'
          RowFields.Strings = (
            'KnifeCode')
          Memos = {
            3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D227574
            662D3822207374616E64616C6F6E653D226E6F223F3E3C63726F73733E3C6365
            6C6C6D656D6F733E3C546672784D656D6F56696577204C6566743D2232303022
            20546F703D223530302E3838323139222057696474683D2233372E3739353237
            353539303535313222204865696768743D22313622205265737472696374696F
            6E733D223234222053686F7748696E743D2246616C73652220416C6C6F774578
            7072657373696F6E733D2246616C73652220466F6E742E436861727365743D22
            302220466F6E742E436F6C6F723D22302220466F6E742E4865696768743D222D
            31322220466F6E742E4E616D653D22436F7572696572204E65772220466F6E74
            2E5374796C653D22312220476170583D2233222048416C69676E3D2268615269
            6768742220486964655A65726F733D22547275652220506172656E74466F6E74
            3D2246616C73652220576F7264577261703D2246616C7365222056416C69676E
            3D22766143656E7465722220546578743D2230222F3E3C546672784D656D6F56
            696577204C6566743D223233382220546F703D223436222057696474683D2234
            3922204865696768743D22323222205265737472696374696F6E733D22323422
            2053686F7748696E743D2246616C73652220416C6C6F7745787072657373696F
            6E733D2246616C736522204672616D652E5479703D2231352220476170583D22
            33222048416C69676E3D2268615269676874222056416C69676E3D2276614365
            6E7465722220546578743D22222F3E3C546672784D656D6F56696577204C6566
            743D223233372220546F703D223436222057696474683D223338222048656967
            68743D22323222205265737472696374696F6E733D223234222053686F774869
            6E743D2246616C73652220416C6C6F7745787072657373696F6E733D2246616C
            736522204672616D652E5479703D2231352220476170583D2233222048416C69
            676E3D2268615269676874222056416C69676E3D22766143656E746572222054
            6578743D22222F3E3C546672784D656D6F56696577204C6566743D2231343622
            20546F703D223636222057696474683D22383122204865696768743D22323222
            205265737472696374696F6E733D223234222053686F7748696E743D2246616C
            73652220416C6C6F7745787072657373696F6E733D2246616C73652220467261
            6D652E5479703D2231352220476170583D2233222048416C69676E3D22686152
            69676874222056416C69676E3D22766143656E7465722220546578743D223022
            2F3E3C546672784D656D6F56696577204C6566743D22302220546F703D223022
            2057696474683D223022204865696768743D223022205265737472696374696F
            6E733D2238222053686F7748696E743D2246616C73652220416C6C6F77457870
            72657373696F6E733D2246616C736522204672616D652E5479703D2231352220
            476170583D2233222048416C69676E3D2268615269676874222056416C69676E
            3D22766143656E7465722220546578743D22222F3E3C546672784D656D6F5669
            6577204C6566743D22302220546F703D2230222057696474683D223022204865
            696768743D223022205265737472696374696F6E733D2238222053686F774869
            6E743D2246616C73652220416C6C6F7745787072657373696F6E733D2246616C
            736522204672616D652E5479703D2231352220476170583D2233222048416C69
            676E3D2268615269676874222056416C69676E3D22766143656E746572222054
            6578743D22222F3E3C2F63656C6C6D656D6F733E3C63656C6C6865616465726D
            656D6F733E3C546672784D656D6F56696577204C6566743D22302220546F703D
            2230222057696474683D2232303022204865696768743D223022205265737472
            696374696F6E733D2238222053686F7748696E743D2246616C73652220416C6C
            6F7745787072657373696F6E733D2246616C736522204672616D652E5479703D
            2231352220476170583D2233222056416C69676E3D22766143656E7465722220
            546578743D225061697273222F3E3C546672784D656D6F56696577204C656674
            3D22302220546F703D2230222057696474683D2232303022204865696768743D
            223022205265737472696374696F6E733D2238222053686F7748696E743D2246
            616C73652220416C6C6F7745787072657373696F6E733D2246616C7365222046
            72616D652E5479703D2231352220476170583D2233222056416C69676E3D2276
            6143656E7465722220546578743D225061697273222F3E3C546672784D656D6F
            56696577204C6566743D22302220546F703D2230222057696474683D22302220
            4865696768743D223022205265737472696374696F6E733D2238222053686F77
            48696E743D2246616C73652220416C6C6F7745787072657373696F6E733D2246
            616C736522204672616D652E5479703D2231352220476170583D223322205641
            6C69676E3D22766143656E7465722220546578743D225061697273222F3E3C2F
            63656C6C6865616465726D656D6F733E3C636F6C756D6E6D656D6F733E3C5466
            72784D656D6F56696577204C6566743D223230302220546F703D223438342E38
            38323139222057696474683D2233372E37393532373535393035353132222048
            65696768743D223122205265737472696374696F6E733D223234222053686F77
            48696E743D2246616C73652220416C6C6F7745787072657373696F6E733D2246
            616C73652220466F6E742E436861727365743D22312220466F6E742E436F6C6F
            723D2231363737373231352220466F6E742E4865696768743D222D3135222046
            6F6E742E4E616D653D22417269616C2220466F6E742E5374796C653D22312220
            476170583D2233222048416C69676E3D22686152696768742220506172656E74
            466F6E743D2246616C7365222056416C69676E3D22766143656E746572222054
            6578743D22222F3E3C546672784D656D6F56696577204C6566743D2232303022
            20546F703D223438352E3838323139222057696474683D2233372E3739353237
            353539303535313222204865696768743D22313522205265737472696374696F
            6E733D223234222053686F7748696E743D2246616C73652220416C6C6F774578
            7072657373696F6E733D2246616C73652220466F6E742E436861727365743D22
            302220466F6E742E436F6C6F723D22302220466F6E742E4865696768743D222D
            31312220466F6E742E4E616D653D22436F7572696572204E65772220466F6E74
            2E5374796C653D223122204672616D652E5479703D22382220476170583D2233
            222048416C69676E3D22686152696768742220506172656E74466F6E743D2246
            616C73652220576F7264577261703D2246616C7365222056416C69676E3D2276
            6143656E7465722220546578743D22222F3E3C2F636F6C756D6E6D656D6F733E
            3C636F6C756D6E746F74616C6D656D6F733E3C546672784D656D6F5669657720
            4C6566743D223134362220546F703D223232222057696474683D223831222048
            65696768743D22323222205265737472696374696F6E733D2238222056697369
            626C653D2246616C7365222053686F7748696E743D2246616C73652220416C6C
            6F7745787072657373696F6E733D2246616C73652220466F6E742E4368617273
            65743D22312220466F6E742E436F6C6F723D22302220466F6E742E4865696768
            743D222D31332220466F6E742E4E616D653D22417269616C2220466F6E742E53
            74796C653D223122204672616D652E5479703D2231352220476170583D223322
            2048416C69676E3D22686143656E7465722220506172656E74466F6E743D2246
            616C7365222056416C69676E3D22766143656E7465722220546578743D224772
            616E6420546F74616C222F3E3C546672784D656D6F56696577204C6566743D22
            3233372220546F703D223234222057696474683D22333822204865696768743D
            22323222205265737472696374696F6E733D2238222056697369626C653D2246
            616C7365222053686F7748696E743D2246616C73652220416C6C6F7745787072
            657373696F6E733D2246616C73652220466F6E742E436861727365743D223122
            20466F6E742E436F6C6F723D22302220466F6E742E4865696768743D222D3133
            2220466F6E742E4E616D653D22417269616C2220466F6E742E5374796C653D22
            3122204672616D652E5479703D2231352220476170583D2233222048416C6967
            6E3D22686143656E7465722220506172656E74466F6E743D2246616C73652220
            56416C69676E3D22766143656E7465722220546578743D22546F74616C222F3E
            3C2F636F6C756D6E746F74616C6D656D6F733E3C636F726E65726D656D6F733E
            3C546672784D656D6F56696577204C6566743D2232302220546F703D22343834
            2E3838323139222057696474683D2231383022204865696768743D2230222052
            65737472696374696F6E733D2238222056697369626C653D2246616C73652220
            53686F7748696E743D2246616C73652220416C6C6F7745787072657373696F6E
            733D2246616C73652220476170583D2233222048416C69676E3D22686143656E
            746572222056416C69676E3D22766143656E7465722220546578743D22222F3E
            3C546672784D656D6F56696577204C6566743D223230302220546F703D223438
            342E3838323139222057696474683D2233372E37393532373535393035353132
            22204865696768743D223022205265737472696374696F6E733D223822205669
            7369626C653D2246616C7365222053686F7748696E743D2246616C7365222041
            6C6C6F7745787072657373696F6E733D2246616C73652220476170583D223322
            2048416C69676E3D22686143656E746572222056416C69676E3D22766143656E
            7465722220546578743D22222F3E3C546672784D656D6F56696577204C656674
            3D22302220546F703D2230222057696474683D2232303022204865696768743D
            223022205265737472696374696F6E733D2238222056697369626C653D224661
            6C7365222053686F7748696E743D2246616C73652220416C6C6F774578707265
            7373696F6E733D2246616C736522204672616D652E5479703D22313522204761
            70583D2233222048416C69676E3D22686143656E746572222056416C69676E3D
            22766143656E7465722220546578743D22222F3E3C546672784D656D6F566965
            77204C6566743D2232302220546F703D223438342E3838323139222057696474
            683D2231383022204865696768743D22313622205265737472696374696F6E73
            3D2238222053686F7748696E743D2246616C73652220416C6C6F774578707265
            7373696F6E733D2246616C73652220466F6E742E436861727365743D22302220
            466F6E742E436F6C6F723D22302220466F6E742E4865696768743D222D313222
            20466F6E742E4E616D653D22436F7572696572204E65772220466F6E742E5374
            796C653D223122204672616D652E5479703D22382220476170583D2233222050
            6172656E74466F6E743D2246616C7365222056416C69676E3D22766143656E74
            65722220546578743D224B6E696665436F6465222F3E3C2F636F726E65726D65
            6D6F733E3C726F776D656D6F733E3C546672784D656D6F56696577204C656674
            3D2232302220546F703D223530302E3838323139222057696474683D22313830
            22204865696768743D22313622205265737472696374696F6E733D2232342220
            53686F7748696E743D2246616C73652220416C6C6F7745787072657373696F6E
            733D2246616C73652220466F6E742E436861727365743D22302220466F6E742E
            436F6C6F723D22302220466F6E742E4865696768743D222D31322220466F6E74
            2E4E616D653D22436F7572696572204E65772220466F6E742E5374796C653D22
            312220476170583D22332220506172656E74466F6E743D2246616C7365222057
            6F7264577261703D2246616C7365222056416C69676E3D22766143656E746572
            2220546578743D22222F3E3C2F726F776D656D6F733E3C726F77746F74616C6D
            656D6F733E3C546672784D656D6F56696577204C6566743D22302220546F703D
            223636222057696474683D22383122204865696768743D223232222052657374
            72696374696F6E733D2238222056697369626C653D2246616C7365222053686F
            7748696E743D2246616C73652220416C6C6F7745787072657373696F6E733D22
            46616C73652220466F6E742E436861727365743D22312220466F6E742E436F6C
            6F723D22302220466F6E742E4865696768743D222D31332220466F6E742E4E61
            6D653D22417269616C2220466F6E742E5374796C653D223122204672616D652E
            5479703D2231352220476170583D2233222048416C69676E3D22686143656E74
            65722220506172656E74466F6E743D2246616C7365222056416C69676E3D2276
            6143656E7465722220546578743D224772616E6420546F74616C222F3E3C2F72
            6F77746F74616C6D656D6F733E3C63656C6C66756E6374696F6E733E3C697465
            6D20302F3E3C2F63656C6C66756E6374696F6E733E3C636F6C756D6E736F7274
            3E3C6974656D20302F3E3C6974656D20322F3E3C2F636F6C756D6E736F72743E
            3C726F77736F72743E3C6974656D20322F3E3C2F726F77736F72743E3C2F6372
            6F73733E}
        end
      end
      object cbLeatherGrid: TfrxChild
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Height = 100.000000000000000000
        ParentFont = False
        Top = 619.842920000000000000
        Width = 1046.920361175000000000
        OnAfterPrint = 'cbLeatherGridOnAfterPrint'
        OnBeforePrint = 'cbLeatherGridOnBeforePrint'
        Child = frTicket.cbSyntheticGrid
        PrintChildIfInvisible = True
        object DBCross3: TfrxDBCrossView
          ShiftMode = smDontShift
          Left = 15.000000000000000000
          Width = 137.000000000000000000
          Height = 95.000000000000000000
          ShowHint = False
          AutoSize = False
          Border = False
          DownThenAcross = False
          GapY = 1
          MaxWidth = 953
          ShowColumnTotal = False
          ShowCorner = False
          ShowRowTotal = False
          OnPrintCell = 'DBCross3OnPrintCell'
          OnPrintColumnHeader = 'DBCross3OnPrintColumnHeader'
          OnPrintRowHeader = 'DBCross3OnPrintRowHeader'
          CellFields.Strings = (
            'Allowance')
          ColumnFields.Strings = (
            'Qual')
          DataSet = frLeatherGrid
          DataSetName = 'frLeatherGrid'
          RowFields.Strings = (
            'Area')
          Memos = {
            3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D227574
            662D3822207374616E64616C6F6E653D226E6F223F3E3C63726F73733E3C6365
            6C6C6D656D6F733E3C546672784D656D6F56696577204C6566743D2237372220
            546F703D223637362E3834323932222057696474683D22353522204865696768
            743D22313822205265737472696374696F6E733D223234222053686F7748696E
            743D2246616C73652220416C6C6F7745787072657373696F6E733D2246616C73
            652220446973706C6179466F726D61742E466F726D61745374723D2225322E32
            662220446973706C6179466F726D61742E4B696E643D22666B4E756D65726963
            2220466F6E742E436861727365743D22302220466F6E742E436F6C6F723D2230
            2220466F6E742E4865696768743D222D31312220466F6E742E4E616D653D2243
            6F7572696572204E65772220466F6E742E5374796C653D223022204672616D65
            2E5479703D2231342220476170583D2233222048416C69676E3D226861526967
            68742220506172656E74466F6E743D2246616C7365222056416C69676E3D2276
            6143656E7465722220546578743D22302E3030222F3E3C546672784D656D6F56
            696577204C6566743D223131332220546F703D223434222057696474683D2233
            3922204865696768743D22323222205265737472696374696F6E733D22323422
            2053686F7748696E743D2246616C73652220416C6C6F7745787072657373696F
            6E733D2246616C736522204672616D652E5479703D2231352220476170583D22
            33222048416C69676E3D2268615269676874222056416C69676E3D2276614365
            6E7465722220546578743D2230222F3E3C546672784D656D6F56696577204C65
            66743D223134362220546F703D223434222057696474683D2238312220486569
            6768743D22323222205265737472696374696F6E733D223234222053686F7748
            696E743D2246616C73652220416C6C6F7745787072657373696F6E733D224661
            6C736522204672616D652E5479703D2231352220476170583D2233222048416C
            69676E3D2268615269676874222056416C69676E3D22766143656E7465722220
            546578743D2230222F3E3C546672784D656D6F56696577204C6566743D223134
            362220546F703D223636222057696474683D22383122204865696768743D2232
            3222205265737472696374696F6E733D223234222053686F7748696E743D2246
            616C73652220416C6C6F7745787072657373696F6E733D2246616C7365222046
            72616D652E5479703D2231352220476170583D2233222048416C69676E3D2268
            615269676874222056416C69676E3D22766143656E7465722220546578743D22
            30222F3E3C2F63656C6C6D656D6F733E3C63656C6C6865616465726D656D6F73
            3E3C546672784D656D6F56696577204C6566743D22302220546F703D22302220
            57696474683D2232303022204865696768743D22302220526573747269637469
            6F6E733D2238222053686F7748696E743D2246616C73652220416C6C6F774578
            7072657373696F6E733D2246616C736522204672616D652E5479703D22313522
            20476170583D2233222056416C69676E3D22766143656E746572222054657874
            3D22416C6C6F77616E6365222F3E3C546672784D656D6F56696577204C656674
            3D22302220546F703D2230222057696474683D2232303022204865696768743D
            223022205265737472696374696F6E733D2238222053686F7748696E743D2246
            616C73652220416C6C6F7745787072657373696F6E733D2246616C7365222046
            72616D652E5479703D2231352220476170583D2233222056416C69676E3D2276
            6143656E7465722220546578743D22416C6C6F77616E6365222F3E3C2F63656C
            6C6865616465726D656D6F733E3C636F6C756D6E6D656D6F733E3C546672784D
            656D6F56696577204C6566743D2237372220546F703D223635382E3834323932
            222057696474683D22353522204865696768743D223138222052657374726963
            74696F6E733D223234222053686F7748696E743D2246616C73652220416C6C6F
            7745787072657373696F6E733D2246616C73652220466F6E742E436861727365
            743D22302220466F6E742E436F6C6F723D22302220466F6E742E486569676874
            3D222D31312220466F6E742E4E616D653D22436F7572696572204E6577222046
            6F6E742E5374796C653D223022204672616D652E5479703D2231352220467261
            6D652E426F74746F6D4C696E652E57696474683D22322220476170583D223322
            2048416C69676E3D22686143656E74657222204C696E6553706163696E673D22
            302220506172656E74466F6E743D2246616C7365222056416C69676E3D227661
            43656E7465722220546578743D22222F3E3C2F636F6C756D6E6D656D6F733E3C
            636F6C756D6E746F74616C6D656D6F733E3C546672784D656D6F56696577204C
            6566743D223134362220546F703D223232222057696474683D22383122204865
            696768743D22323222205265737472696374696F6E733D223822205669736962
            6C653D2246616C7365222053686F7748696E743D2246616C73652220416C6C6F
            7745787072657373696F6E733D2246616C73652220466F6E742E436861727365
            743D22312220466F6E742E436F6C6F723D22302220466F6E742E486569676874
            3D222D31332220466F6E742E4E616D653D22417269616C2220466F6E742E5374
            796C653D223122204672616D652E5479703D2231352220476170583D22332220
            48416C69676E3D22686143656E7465722220506172656E74466F6E743D224661
            6C7365222056416C69676E3D22766143656E7465722220546578743D22477261
            6E6420546F74616C222F3E3C2F636F6C756D6E746F74616C6D656D6F733E3C63
            6F726E65726D656D6F733E3C546672784D656D6F56696577204C6566743D2230
            2220546F703D2230222057696474683D22343222204865696768743D22313922
            205265737472696374696F6E733D2238222056697369626C653D2246616C7365
            222053686F7748696E743D2246616C73652220416C6C6F774578707265737369
            6F6E733D2246616C73652220476170583D2233222048416C69676E3D22686143
            656E746572222056416C69676E3D22766143656E7465722220546578743D2222
            2F3E3C546672784D656D6F56696577204C6566743D2237372220546F703D2236
            33392E3834323932222057696474683D22353522204865696768743D22313922
            205265737472696374696F6E733D2238222053686F7748696E743D2246616C73
            652220416C6C6F7745787072657373696F6E733D2246616C73652220466F6E74
            2E436861727365743D22302220466F6E742E436F6C6F723D22302220466F6E74
            2E4865696768743D222D31312220466F6E742E4E616D653D22436F7572696572
            204E65772220466F6E742E5374796C653D223022204672616D652E4C6566744C
            696E652E57696474683D223222204672616D652E546F704C696E652E57696474
            683D223222204672616D652E52696768744C696E652E57696474683D22322220
            476170583D2233222048416C69676E3D22686143656E7465722220506172656E
            74466F6E743D2246616C7365222056416C69676E3D22766143656E7465722220
            546578743D225175616C697479222F3E3C546672784D656D6F56696577204C65
            66743D22302220546F703D2230222057696474683D2232303022204865696768
            743D223022205265737472696374696F6E733D2238222056697369626C653D22
            46616C7365222053686F7748696E743D2246616C73652220416C6C6F77457870
            72657373696F6E733D2246616C736522204672616D652E5479703D2231352220
            476170583D2233222048416C69676E3D22686143656E746572222056416C6967
            6E3D22766143656E7465722220546578743D22222F3E3C546672784D656D6F56
            696577204C6566743D22302220546F703D223139222057696474683D22343222
            204865696768743D22313822205265737472696374696F6E733D223822205368
            6F7748696E743D2246616C73652220416C6C6F7745787072657373696F6E733D
            2246616C736522204672616D652E5479703D22313522204672616D652E526967
            68744C696E652E57696474683D22322220476170583D2233222048416C69676E
            3D226861526967687422204C696E6553706163696E673D2230222056416C6967
            6E3D22766143656E7465722220546578743D2241726561222F3E3C2F636F726E
            65726D656D6F733E3C726F776D656D6F733E3C546672784D656D6F5669657720
            4C6566743D2233352220546F703D223637362E3834323932222057696474683D
            22343222204865696768743D22313822205265737472696374696F6E733D2232
            34222053686F7748696E743D2246616C73652220416C6C6F7745787072657373
            696F6E733D2246616C73652220466F6E742E436861727365743D22302220466F
            6E742E436F6C6F723D22302220466F6E742E4865696768743D222D3131222046
            6F6E742E4E616D653D22436F7572696572204E65772220466F6E742E5374796C
            653D223022204672616D652E5479703D22313522204672616D652E5269676874
            4C696E652E57696474683D22322220476170583D2233222048416C69676E3D22
            6861526967687422204C696E6553706163696E673D22302220506172656E7446
            6F6E743D2246616C7365222056416C69676E3D22766143656E74657222205465
            78743D22222F3E3C2F726F776D656D6F733E3C726F77746F74616C6D656D6F73
            3E3C546672784D656D6F56696577204C6566743D22302220546F703D22363622
            2057696474683D22383122204865696768743D22323222205265737472696374
            696F6E733D2238222056697369626C653D2246616C7365222053686F7748696E
            743D2246616C73652220416C6C6F7745787072657373696F6E733D2246616C73
            652220466F6E742E436861727365743D22312220466F6E742E436F6C6F723D22
            302220466F6E742E4865696768743D222D31332220466F6E742E4E616D653D22
            417269616C2220466F6E742E5374796C653D223122204672616D652E5479703D
            2231352220476170583D2233222048416C69676E3D22686143656E7465722220
            506172656E74466F6E743D2246616C7365222056416C69676E3D22766143656E
            7465722220546578743D224772616E6420546F74616C222F3E3C2F726F77746F
            74616C6D656D6F733E3C63656C6C66756E6374696F6E733E3C6974656D20302F
            3E3C2F63656C6C66756E6374696F6E733E3C636F6C756D6E736F72743E3C6974
            656D20312F3E3C2F636F6C756D6E736F72743E3C726F77736F72743E3C697465
            6D20312F3E3C2F726F77736F72743E3C2F63726F73733E}
        end
      end
      object cbSyntheticGrid: TfrxChild
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Height = 100.000000000000000000
        ParentFont = False
        Top = 744.567410000000000000
        Width = 1046.920361175000000000
        PrintChildIfInvisible = True
        object DBCross4: TfrxDBCrossView
          Width = 235.000000000000000000
          Height = 95.000000000000000000
          ShowHint = False
          AutoSize = False
          Border = False
          DownThenAcross = False
          GapY = 1
          MaxWidth = 968
          RepeatHeaders = False
          ShowColumnTotal = False
          ShowCorner = False
          ShowRowTotal = False
          OnPrintCell = 'DBCross4OnPrintCell'
          OnPrintColumnHeader = 'DBCross4OnPrintColumnHeader'
          CellFields.Strings = (
            'Allowance')
          ColumnFields.Strings = (
            'Width')
          DataSet = frdbSynthGrid
          DataSetName = 'frdbSynthGrid'
          RowFields.Strings = (
            'RF')
          Memos = {
            3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D227574
            662D3822207374616E64616C6F6E653D226E6F223F3E3C63726F73733E3C6365
            6C6C6D656D6F733E3C546672784D656D6F56696577204C6566743D2231363022
            20546F703D223830312E3536373431222057696474683D223535222048656967
            68743D22313822205265737472696374696F6E733D223234222053686F774869
            6E743D2246616C73652220416C6C6F7745787072657373696F6E733D2246616C
            73652220446973706C6179466F726D61742E466F726D61745374723D2225322E
            32662220446973706C6179466F726D61742E4B696E643D22666B4E756D657269
            632220466F6E742E436861727365743D22302220466F6E742E436F6C6F723D22
            302220466F6E742E4865696768743D222D31312220466F6E742E4E616D653D22
            436F7572696572204E65772220466F6E742E5374796C653D223022204672616D
            652E5479703D2231352220476170583D2233222048416C69676E3D2268615269
            6768742220506172656E74466F6E743D2246616C7365222056416C69676E3D22
            766143656E7465722220546578743D22302E3030222F3E3C546672784D656D6F
            56696577204C6566743D22302220546F703D223636222057696474683D223438
            22204865696768743D22323222205265737472696374696F6E733D2232342220
            53686F7748696E743D2246616C73652220416C6C6F7745787072657373696F6E
            733D2246616C736522204672616D652E5479703D2231352220476170583D2233
            222048416C69676E3D2268615269676874222056416C69676E3D22766143656E
            7465722220546578743D2230222F3E3C546672784D656D6F56696577204C6566
            743D2234382220546F703D223434222057696474683D22383122204865696768
            743D22323222205265737472696374696F6E733D223234222053686F7748696E
            743D2246616C73652220416C6C6F7745787072657373696F6E733D2246616C73
            6522204672616D652E5479703D2231352220476170583D2233222048416C6967
            6E3D2268615269676874222056416C69676E3D22766143656E74657222205465
            78743D2230222F3E3C546672784D656D6F56696577204C6566743D2234382220
            546F703D223636222057696474683D22383122204865696768743D2232322220
            5265737472696374696F6E733D223234222053686F7748696E743D2246616C73
            652220416C6C6F7745787072657373696F6E733D2246616C736522204672616D
            652E5479703D2231352220476170583D2233222048416C69676E3D2268615269
            676874222056416C69676E3D22766143656E7465722220546578743D2230222F
            3E3C2F63656C6C6D656D6F733E3C63656C6C6865616465726D656D6F733E3C54
            6672784D656D6F56696577204C6566743D22302220546F703D22302220576964
            74683D223022204865696768743D223022205265737472696374696F6E733D22
            38222053686F7748696E743D2246616C73652220416C6C6F7745787072657373
            696F6E733D2246616C736522204672616D652E5479703D223135222047617058
            3D2233222056416C69676E3D22766143656E7465722220546578743D22416C6C
            6F77616E6365222F3E3C546672784D656D6F56696577204C6566743D22302220
            546F703D2230222057696474683D223022204865696768743D22302220526573
            7472696374696F6E733D2238222053686F7748696E743D2246616C7365222041
            6C6C6F7745787072657373696F6E733D2246616C736522204672616D652E5479
            703D2231352220476170583D2233222056416C69676E3D22766143656E746572
            2220546578743D22416C6C6F77616E6365222F3E3C2F63656C6C686561646572
            6D656D6F733E3C636F6C756D6E6D656D6F733E3C546672784D656D6F56696577
            204C6566743D223136302220546F703D223738332E3536373431222057696474
            683D22353522204865696768743D22313822205265737472696374696F6E733D
            223234222053686F7748696E743D2246616C73652220416C6C6F774578707265
            7373696F6E733D2246616C73652220466F6E742E436861727365743D22302220
            466F6E742E436F6C6F723D22302220466F6E742E4865696768743D222D313122
            20466F6E742E4E616D653D22436F7572696572204E65772220466F6E742E5374
            796C653D223022204672616D652E5479703D2231352220476170583D22332220
            48416C69676E3D22686143656E7465722220506172656E74466F6E743D224661
            6C7365222056416C69676E3D22766143656E7465722220546578743D22222F3E
            3C2F636F6C756D6E6D656D6F733E3C636F6C756D6E746F74616C6D656D6F733E
            3C546672784D656D6F56696577204C6566743D2234382220546F703D22323222
            2057696474683D22383122204865696768743D22323222205265737472696374
            696F6E733D2238222056697369626C653D2246616C7365222053686F7748696E
            743D2246616C73652220416C6C6F7745787072657373696F6E733D2246616C73
            652220466F6E742E436861727365743D22312220466F6E742E436F6C6F723D22
            302220466F6E742E4865696768743D222D31332220466F6E742E4E616D653D22
            417269616C2220466F6E742E5374796C653D223122204672616D652E5479703D
            2231352220476170583D2233222048416C69676E3D22686143656E7465722220
            506172656E74466F6E743D2246616C7365222056416C69676E3D22766143656E
            7465722220546578743D224772616E6420546F74616C222F3E3C2F636F6C756D
            6E746F74616C6D656D6F733E3C636F726E65726D656D6F733E3C546672784D65
            6D6F56696577204C6566743D22302220546F703D2230222057696474683D2231
            343022204865696768743D22313922205265737472696374696F6E733D223822
            2056697369626C653D2246616C7365222053686F7748696E743D2246616C7365
            2220416C6C6F7745787072657373696F6E733D2246616C736522204672616D65
            2E5479703D2231352220476170583D2233222048416C69676E3D22686143656E
            746572222056416C69676E3D22766143656E7465722220546578743D22416C6C
            6F77616E6365222F3E3C546672784D656D6F56696577204C6566743D22313630
            2220546F703D223736342E3536373431222057696474683D2235352220486569
            6768743D22313922205265737472696374696F6E733D2238222053686F774869
            6E743D2246616C73652220416C6C6F7745787072657373696F6E733D2246616C
            73652220466F6E742E436861727365743D22302220466F6E742E436F6C6F723D
            22302220466F6E742E4865696768743D222D31312220466F6E742E4E616D653D
            22436F7572696572204E65772220466F6E742E5374796C653D22302220476170
            583D2233222048416C69676E3D22686143656E7465722220506172656E74466F
            6E743D2246616C7365222056416C69676E3D22766143656E7465722220546578
            743D225769647468222F3E3C546672784D656D6F56696577204C6566743D2230
            2220546F703D2230222057696474683D223022204865696768743D2230222052
            65737472696374696F6E733D2238222056697369626C653D2246616C73652220
            53686F7748696E743D2246616C73652220416C6C6F7745787072657373696F6E
            733D2246616C736522204672616D652E5479703D2231352220476170583D2233
            222048416C69676E3D22686143656E746572222056416C69676E3D2276614365
            6E7465722220546578743D22222F3E3C546672784D656D6F56696577204C6566
            743D22302220546F703D223139222057696474683D2231343022204865696768
            743D22313822205265737472696374696F6E733D2238222053686F7748696E74
            3D2246616C73652220416C6C6F7745787072657373696F6E733D2246616C7365
            22204672616D652E5479703D2231352220476170583D2233222048416C69676E
            3D22686143656E746572222056416C69676E3D22766143656E74657222205465
            78743D225246222F3E3C2F636F726E65726D656D6F733E3C726F776D656D6F73
            3E3C546672784D656D6F56696577204C6566743D2232302220546F703D223830
            312E3536373431222057696474683D2231343022204865696768743D22313822
            205265737472696374696F6E733D223234222053686F7748696E743D2246616C
            73652220416C6C6F7745787072657373696F6E733D2246616C73652220466F6E
            742E436861727365743D22302220466F6E742E436F6C6F723D22302220466F6E
            742E4865696768743D222D31312220466F6E742E4E616D653D22436F75726965
            72204E65772220466F6E742E5374796C653D22302220476170583D2233222050
            6172656E74466F6E743D2246616C7365222056416C69676E3D22766143656E74
            65722220546578743D22222F3E3C2F726F776D656D6F733E3C726F77746F7461
            6C6D656D6F733E3C546672784D656D6F56696577204C6566743D22302220546F
            703D223636222057696474683D2232303022204865696768743D223232222052
            65737472696374696F6E733D2238222056697369626C653D2246616C73652220
            53686F7748696E743D2246616C73652220416C6C6F7745787072657373696F6E
            733D2246616C73652220466F6E742E436861727365743D22312220466F6E742E
            436F6C6F723D22302220466F6E742E4865696768743D222D31332220466F6E74
            2E4E616D653D22417269616C2220466F6E742E5374796C653D22312220467261
            6D652E5479703D2231352220476170583D2233222048416C69676E3D22686143
            656E7465722220506172656E74466F6E743D2246616C7365222056416C69676E
            3D22766143656E7465722220546578743D224772616E6420546F74616C222F3E
            3C2F726F77746F74616C6D656D6F733E3C63656C6C66756E6374696F6E733E3C
            6974656D20312F3E3C2F63656C6C66756E6374696F6E733E3C636F6C756D6E73
            6F72743E3C6974656D20302F3E3C2F636F6C756D6E736F72743E3C726F77736F
            72743E3C6974656D20302F3E3C2F726F77736F72743E3C2F63726F73733E}
        end
      end
      object cbMainDetails: TfrxChild
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Height = 120.944881890000000000
        ParentFont = False
        Top = 75.590600000000000000
        Width = 1046.920361175000000000
        Child = frTicket.cbBarcodePicture
        object mConstruction: TfrxMemoView
          Top = 37.795275590000000000
          Width = 139.842519685039400000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[6]')
        end
        object Memo8: TfrxMemoView
          Left = 139.086614173228300000
          Top = 37.795275590000000000
          Width = 213.543307090000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'Construction'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."Construction"]')
        end
        object mMaterial: TfrxMemoView
          Left = 358.000000000000000000
          Top = 18.897637800000000000
          Width = 140.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[11]')
        end
        object Memo10: TfrxMemoView
          Left = 503.000000000000000000
          Top = 18.897637795275590000
          Width = 220.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'MaterialCode'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."MaterialCode"]')
        end
        object Memo11: TfrxMemoView
          Left = 358.000000000000000000
          Top = 56.692913390000000000
          Width = 140.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[SkinSizeORWidth]')
        end
        object mTagNumberTitle: TfrxMemoView
          Top = 94.488188980000000000
          Width = 139.842519685039400000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[8]')
        end
        object Memo13: TfrxMemoView
          Top = 75.590551180000000000
          Width = 139.842519685039400000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[TotalItems]')
        end
        object mTagNumber: TfrxMemoView
          Left = 139.086614170000000000
          Top = 94.488188980000000000
          Width = 734.362204720000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'TagNo'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."TagNo"]')
        end
        object Memo15: TfrxMemoView
          Left = 139.086614173228300000
          Top = 75.590551180000000000
          Width = 213.543307090000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'TotalPairs'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."TotalPairs"]')
        end
        object mPart: TfrxMemoView
          Top = 56.692913390000000000
          Width = 139.842519685039400000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[7]')
        end
        object Memo17: TfrxMemoView
          Left = 139.086614173228300000
          Top = 56.692913390000000000
          Width = 213.543307090000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'PartCode'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."PartCode"]')
        end
        object mMaterialDescription: TfrxMemoView
          Left = 358.000000000000000000
          Top = 37.795275590551180000
          Width = 140.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[12]')
        end
        object Memo19: TfrxMemoView
          Left = 503.000000000000000000
          Top = 37.795275590000000000
          Width = 220.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'MaterialDescription'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."MaterialDescription"]')
        end
        object mCuttingType: TfrxMemoView
          Left = 728.000000000000000000
          Top = 18.897637795275590000
          Width = 145.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[17]')
        end
        object Memo21: TfrxMemoView
          Left = 878.000000000000000000
          Top = 18.897637795275590000
          Width = 90.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'MaterialCutType'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."MaterialCutType"]')
        end
        object mSTLenTitle: TfrxMemoView
          Left = 358.000000000000000000
          Top = 75.590551181102360000
          Width = 140.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[SkinTrimmedORLength]')
        end
        object mCustomerTitle: TfrxMemoView
          Left = 728.000000000000000000
          Top = 75.590551181102360000
          Width = 145.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[18]')
        end
        object mCustomer: TfrxMemoView
          Left = 878.000000000000000000
          Top = 75.590551181102360000
          Width = 169.370130000000000000
          Height = 35.897650000000000000
          ShowHint = False
          DataField = 'Customer'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."Customer"]')
        end
        object mAdjustmentFactorTitle: TfrxMemoView
          Left = 728.000000000000000000
          Top = 37.795275590551180000
          Width = 145.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[23]')
        end
        object mLayers: TfrxMemoView
          Left = 878.000000000000000000
          Top = 56.692913385826770000
          Width = 90.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'MaterialLayers'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."MaterialLayers"]')
        end
        object mLayersTitle: TfrxMemoView
          Left = 728.000000000000000000
          Top = 56.692913385826770000
          Width = 145.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[24]')
        end
        object mAdjustmentFactor: TfrxMemoView
          Left = 878.000000000000000000
          Top = 37.795275590551180000
          Width = 90.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'AdjFactorResult'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."AdjFactorResult"]')
        end
        object Memo29: TfrxMemoView
          Left = 503.000000000000000000
          Top = 56.692913385826770000
          Width = 45.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          HAlign = haRight
          Memo.UTF8W = (
            '[SSWid]')
        end
        object mSTLen: TfrxMemoView
          Left = 503.000000000000000000
          Top = 75.590551181102360000
          Width = 45.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          HAlign = haRight
          Memo.UTF8W = (
            '[STLen]')
        end
        object mStyle: TfrxMemoView
          Top = 18.897637800000000000
          Width = 139.842519690000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[5]')
        end
        object Memo32: TfrxMemoView
          Left = 139.086614170000000000
          Top = 18.897637800000000000
          Width = 213.543307090000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'Style'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."Style"]')
        end
        object Memo12: TfrxMemoView
          Left = 550.000000000000000000
          Top = 56.692913385826770000
          Width = 75.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[SSWidUnit]')
        end
        object Memo16: TfrxMemoView
          Left = 550.000000000000000000
          Top = 75.590551181102360000
          Width = 75.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[STLenUnit]')
        end
        object Memo1: TfrxMemoView
          Left = 138.921259840000000000
          Width = 907.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Memo.UTF8W = (
            '[frdbTickets."StyleDescription"]')
        end
        object Memo2: TfrxMemoView
          Width = 139.842519690000000000
          Height = 17.000000000000000000
          ShowHint = False
          Memo.UTF8W = (
            '[37]')
        end
      end
      object cbBarcodePicture: TfrxChild
        Height = 60.000000000000000000
        Top = 219.212740000000000000
        Visible = False
        Width = 1046.920361175000000000
        Child = frTicket.cbSpecialInstructions
        PrintChildIfInvisible = True
        object Picture2: TfrxPictureView
          Align = baRight
          Left = 873.195871175000000000
          Width = 173.724490000000000000
          Height = 84.015770000000000000
          ShowHint = False
          DataField = 'Picture'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          HightQuality = False
          Transparent = False
          TransparentColor = clWhite
        end
        object bcTicketNumber: TfrxBarCodeView
          Left = 1.000000000000000000
          Top = 1.000000000000000000
          Width = 123.000000000000000000
          Height = 50.000000000000000000
          ShowHint = False
          BarType = bcCode128A
          DataField = 'TicketNumber'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Rotation = 0
          ShowText = False
          Text = '12345678'
          WideBarRatio = 2.000000000000000000
          Zoom = 1.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
        end
      end
      object cbSpecialInstructions: TfrxChild
        Height = 24.000000000000000000
        Top = 302.362400000000000000
        Width = 1046.920361175000000000
        Child = frTicket.cbShoeSizes
        PrintChildIfInvisible = True
        Stretched = True
        object mSpecialInstructions: TfrxMemoView
          Align = baLeft
          Width = 869.282451170000000000
          Height = 24.000000000000000000
          ShowHint = False
          StretchMode = smActualHeight
          DataField = 'SpecialInstructions'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Memo.UTF8W = (
            '[frdbTickets."SpecialInstructions"]')
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Height = 40.000000000000000000
        ParentFont = False
        Top = 1628.977430000000000000
        Width = 1046.920361175000000000
        object mSupplier: TfrxMemoView
          Left = 3.000000000000000000
          Top = 4.000000000000000000
          Width = 109.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          Memo.UTF8W = (
            '[29] __________')
        end
        object mAmountIssued: TfrxMemoView
          Left = 229.000000000000000000
          Top = 5.000000000000000000
          Width = 112.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          Memo.UTF8W = (
            '[31] __________')
        end
        object Memo216: TfrxMemoView
          Left = 461.000000000000000000
          Top = 5.000000000000000000
          Width = 106.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          Memo.UTF8W = (
            '[32] __________')
        end
        object mReturned: TfrxMemoView
          Left = 640.000000000000000000
          Top = 5.000000000000000000
          Width = 112.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          Memo.UTF8W = (
            '[33] __________')
        end
        object mUsed: TfrxMemoView
          Left = 863.000000000000000000
          Top = 4.000000000000000000
          Width = 105.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          HAlign = haRight
          Memo.UTF8W = (
            '[34] __________')
        end
      end
      object cbSheet: TfrxChild
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Height = 21.000000000000000000
        ParentFont = False
        Top = 574.488560000000000000
        Width = 1046.920361175000000000
        Child = frTicket.cbLeatherGrid
        PrintChildIfInvisible = True
        object mAllowanceTitle: TfrxMemoView
          Width = 79.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          Memo.UTF8W = (
            '[25]')
        end
        object mAllowance: TfrxMemoView
          Left = 144.000000000000000000
          Width = 121.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'BasicAllowanceXpairs'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[frdbTickets."BasicAllowanceXpairs"]')
        end
        object mSheetsTitle: TfrxMemoView
          Left = 390.000000000000000000
          Width = 25.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          Memo.UTF8W = (
            '[26]')
        end
        object mSheets: TfrxMemoView
          Left = 578.000000000000000000
          Width = 115.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          DataField = 'NumberOfSheets'
          DataSet = frdbTickets
          DataSetName = 'frdbTickets'
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[frdbTickets."NumberOfSheets"]')
        end
        object mStandardMinutesTitle: TfrxMemoView
          Left = 794.000000000000000000
          Width = 103.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          Memo.UTF8W = (
            '[27]')
        end
        object mStandardMinutes: TfrxMemoView
          Left = 943.000000000000000000
          Width = 25.000000000000000000
          Height = 17.000000000000000000
          ShowHint = False
          AutoWidth = True
          DataField = 'Time'
          DataSet = frdbTicketTimes
          DataSetName = 'frdbTicketTimes'
          DisplayFormat.FormatStr = '%2.2f'
          DisplayFormat.Kind = fkNumeric
          HAlign = haRight
          Memo.UTF8W = (
            '[frdbTicketTimes."Time"]')
        end
      end
      object obInvalidTicket: TfrxOverlay
        Height = 661.000000000000000000
        Top = 907.087200000000000000
        Width = 1046.920361175000000000
        object mInvalidTicket: TfrxMemoView
          Align = baClient
          Width = 1046.920361175000000000
          Height = 661.000000000000000000
          Visible = False
          ShowHint = False
          AutoWidth = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -64
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[35]')
          ParentFont = False
          VAlign = vaCenter
        end
        object mVerticalArea: TfrxMemoView
          Top = 625.928570000000100000
          Width = 20.929810000000000000
          Height = 100.000000000000000000
          ShowHint = False
          StretchMode = smMaxHeight
          AutoWidth = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[22]')
          ParentFont = False
          Rotation = 90
        end
      end
    end
  end
  object qSynthGrid: TFDQueryPlus
    BeforeOpen = qBeforeOpen
    OnCalcFields = qLeatherGridCalcFields
    BeforeExecute = qBeforeExecute
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'SELECT *'
      'FROM #Temp')
    Left = 120
    Top = 141
    object qSynthGridWidth: TIntegerField
      FieldName = 'Width'
    end
    object qSynthGridRF: TStringField
      FieldName = 'RF'
    end
    object qSynthGridAllowance: TFloatField
      FieldName = 'Allowance'
    end
  end
  object frdbSynthGrid: TfrxDBDataset
    UserName = 'frdbSynthGrid'
    CloseDataSource = False
    FieldAliases.Strings = (
      'Width=Width'
      'RF=RF'
      'Allowance=Allowance')
    DataSet = qSynthGrid
    BCDToCurrency = False
    Left = 42
    Top = 313
  end
  object frMyArray: TfrxUserDataSet
    UserName = 'frMyArray'
    Left = 11
    Top = 76
  end
  object qTickets: TFDQueryPlus
    AfterScroll = qTicketsAfterScroll
    OnCalcFields = qTicketsCalcFields
    Connection = fmSumms.ConnectionSumms
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      
        'SELECT TT.*, TS.Style, TS.StyleDescription, TS.Construction, TS.' +
        'TagNo, TS.Customer, TS.Picture, TS.RowsInLeatherGrid, TS.LinesIn' +
        'LeatherGrid'
      'FROM TicketTickets TT, TicketSequences TS'
      
        'WHERE TT.WeekNo = TS.WeekNo AND TT.SequenceNo = TS.SequenceNo AN' +
        'D TT.Print = TRUE'
      
        'Order By TT.MaterialCode, TT.MaterialCode, TT.WeekNo, TT.Sequenc' +
        'eNo, TT.TicketNo')
    Left = 44
    Top = 448
    object qTicketsWeekNo: TSmallintField
      FieldName = 'WeekNo'
    end
    object qTicketsSequenceNo: TSmallintField
      FieldName = 'SequenceNo'
    end
    object qTicketsTicketNo: TSmallintField
      FieldName = 'TicketNo'
    end
    object qTicketsID: TIntegerField
      FieldName = 'ID'
    end
    object qTicketsPartCode: TStringField
      FieldName = 'PartCode'
    end
    object qTicketsPartDescription: TStringField
      FieldName = 'PartDescription'
      Size = 30
    end
    object qTicketsMaterialCode: TStringField
      FieldName = 'MaterialCode'
    end
    object qTicketsMaterialDescription: TStringField
      FieldName = 'MaterialDescription'
      Size = 30
    end
    object qTicketsMaterialType: TStringField
      FieldName = 'MaterialType'
      Size = 1
    end
    object qTicketsMaterialCutType: TStringField
      FieldName = 'MaterialCutType'
      Size = 1
    end
    object qTicketsMaterialLength: TFloatField
      FieldName = 'MaterialLength'
    end
    object qTicketsMaterialWidth: TFloatField
      FieldName = 'MaterialWidth'
    end
    object qTicketsMaterialSkinSize: TFloatField
      FieldName = 'MaterialSkinSize'
    end
    object qTicketsMaterialSkinTrimmed: TBooleanField
      FieldName = 'MaterialSkinTrimmed'
    end
    object qTicketsMaterialUnits: TStringField
      FieldName = 'MaterialUnits'
    end
    object qTicketsMaterialLayers: TSmallintField
      FieldName = 'MaterialLayers'
    end
    object qTicketsAdjFactorResult: TSmallintField
      FieldName = 'AdjFactorResult'
    end
    object qTicketsCutWeek: TSmallintField
      FieldName = 'CutWeek'
    end
    object qTicketsCutter: TStringField
      FieldName = 'Cutter'
    end
    object qTicketsCutterLocation: TStringField
      FieldName = 'CutterLocation'
    end
    object qTicketsQuality: TSmallintField
      FieldName = 'Quality'
    end
    object qTicketsArea: TSmallintField
      FieldName = 'Area'
    end
    object qTicketsIssuedAllowance: TFloatField
      FieldName = 'IssuedAllowance'
    end
    object qTicketsCostedAllowance: TFloatField
      FieldName = 'CostedAllowance'
    end
    object qTicketsActualUsage: TFloatField
      FieldName = 'ActualUsage'
    end
    object qTicketsSMVs: TFloatField
      FieldName = 'SMVs'
    end
    object qTicketsBulked: TBooleanField
      FieldName = 'Bulked'
    end
    object qTicketsCostedResult: TFloatField
      FieldName = 'CostedResult'
    end
    object qTicketsTotalPairs: TSmallintField
      FieldName = 'TotalPairs'
    end
    object qTicketsMatSupplier: TStringField
      FieldName = 'MatSupplier'
    end
    object qTicketsMatPrice: TCurrencyField
      FieldName = 'MatPrice'
    end
    object qTicketsSpecialInstructions: TMemoField
      FieldName = 'SpecialInstructions'
      BlobType = ftMemo
      Size = 1
    end
    object qTicketsMaterialQualCoeff: TIntegerField
      FieldName = 'MaterialQualCoeff'
    end
    object qTicketsMaterialAreaCoeff: TIntegerField
      FieldName = 'MaterialAreaCoeff'
    end
    object qTicketsSkinSize: TFloatField
      FieldKind = fkCalculated
      FieldName = 'SkinSize'
      Calculated = True
    end
    object qTicketsMaterialSkinTrimmedYN: TStringField
      FieldKind = fkCalculated
      FieldName = 'MaterialSkinTrimmedYN'
      Size = 3
      Calculated = True
    end
    object qTicketsTicketNumber: TStringField
      FieldKind = fkCalculated
      FieldName = 'TicketNumber'
      Calculated = True
    end
    object qTicketsStyle: TStringField
      FieldName = 'Style'
    end
    object qTicketsStyleDescription: TStringField
      FieldName = 'StyleDescription'
      Size = 80
    end
    object qTicketsTagNo: TStringField
      FieldName = 'TagNo'
      Size = 55
    end
    object qTicketsConstruction: TStringField
      FieldName = 'Construction'
    end
    object qTicketsCustomer: TStringField
      FieldName = 'Customer'
    end
    object qTicketsPicture: TBlobField
      FieldName = 'Picture'
      Size = 1
    end
    object qTicketsMaterialUnitDescription: TStringField
      FieldName = 'MaterialUnitDescription'
      Size = 30
    end
    object qTicketsMaterialUnitAbbreviation: TStringField
      FieldName = 'MaterialUnitAbbreviation'
      Size = 4
    end
    object qTicketsMaterialSubUnitDesc: TStringField
      FieldName = 'MaterialSubUnitDesc'
      Size = 30
    end
    object qTicketsMaterialSubUnitAbbreviation: TStringField
      FieldName = 'MaterialSubUnitAbbreviation'
      Size = 4
    end
    object qTicketsMaterialSubUnitsPerUnit: TSmallintField
      FieldName = 'MaterialSubUnitsPerUnit'
    end
    object qTicketsMaterialUnitsToFeet: TFloatField
      FieldName = 'MaterialUnitsToFeet'
    end
    object qTicketsPrint: TBooleanField
      FieldName = 'Print'
    end
    object qTicketsPrinted: TBooleanField
      FieldName = 'Printed'
    end
    object qTicketsBasicAllowance: TFloatField
      FieldName = 'BasicAllowance'
    end
    object qTicketsBasicAllowanceXpairs: TFloatField
      FieldKind = fkCalculated
      FieldName = 'BasicAllowanceXpairs'
      Calculated = True
    end
    object qTicketsRowsInLeatherGrid: TSmallintField
      FieldName = 'RowsInLeatherGrid'
    end
    object qTicketsLinesInLeatherGrid: TSmallintField
      FieldName = 'LinesInLeatherGrid'
    end
    object qTicketsSLMAllowance: TBooleanField
      FieldName = 'SLMAllowance'
    end
    object qTicketsNumberOfSheets: TFloatField
      FieldKind = fkCalculated
      FieldName = 'NumberOfSheets'
      Calculated = True
    end
  end
  object dsTickets: TDataSource
    DataSet = qTickets
    Left = 19
    Top = 380
  end
  object frdbTickets: TfrxDBDataset
    UserName = 'frdbTickets'
    CloseDataSource = False
    FieldAliases.Strings = (
      'WeekNo=WeekNo'
      'SequenceNo=SequenceNo'
      'TicketNo=TicketNo'
      'ID=ID'
      'PartCode=PartCode'
      'PartDescription=PartDescription'
      'MaterialCode=MaterialCode'
      'MaterialDescription=MaterialDescription'
      'MaterialType=MaterialType'
      'MaterialCutType=MaterialCutType'
      'MaterialLength=MaterialLength'
      'MaterialWidth=MaterialWidth'
      'MaterialSkinSize=MaterialSkinSize'
      'MaterialSkinTrimmed=MaterialSkinTrimmed'
      'MaterialUnits=MaterialUnits'
      'MaterialLayers=MaterialLayers'
      'AdjFactorResult=AdjFactorResult'
      'CutWeek=CutWeek'
      'Cutter=Cutter'
      'CutterLocation=CutterLocation'
      'Quality=Quality'
      'Area=Area'
      'IssuedAllowance=IssuedAllowance'
      'CostedAllowance=CostedAllowance'
      'ActualUsage=ActualUsage'
      'SMVs=SMVs'
      'Bulked=Bulked'
      'CostedResult=CostedResult'
      'TotalPairs=TotalPairs'
      'MatSupplier=MatSupplier'
      'MatPrice=MatPrice'
      'SpecialInstructions=SpecialInstructions'
      'MaterialQualCoeff=MaterialQualCoeff'
      'MaterialAreaCoeff=MaterialAreaCoeff'
      'SkinSize=SkinSize'
      'MaterialSkinTrimmedYN=MaterialSkinTrimmedYN'
      'TicketNumber=TicketNumber'
      'Style=Style'
      'StyleDescription=StyleDescription'
      'TagNo=TagNo'
      'Construction=Construction'
      'Customer=Customer'
      'Picture=Picture'
      'MaterialUnitDescription=MaterialUnitDescription'
      'MaterialUnitAbbreviation=MaterialUnitAbbreviation'
      'MaterialSubUnitDesc=MaterialSubUnitDesc'
      'MaterialSubUnitAbbreviation=MaterialSubUnitAbbreviation'
      'MaterialSubUnitsPerUnit=MaterialSubUnitsPerUnit'
      'MaterialUnitsToFeet=MaterialUnitsToFeet'
      'Print=Print'
      'Printed=Printed'
      'BasicAllowance=BasicAllowance'
      'BasicAllowanceXpairs=BasicAllowanceXpairs'
      'RowsInLeatherGrid=RowsInLeatherGrid'
      'LinesInLeatherGrid=LinesInLeatherGrid'
      'SLMAllowance=SLMAllowance'
      'NumberOfSheets=NumberOfSheets')
    DataSet = qTickets
    BCDToCurrency = False
    Left = 13
    Top = 404
  end
  object qTicketTimes: TFDQueryPlus
    IndexFieldNames = 'WEEKNO;SEQUENCENO;TICKETNO;QUALITY'
    MasterSource = dsTickets
    MasterFields = 'WeekNo;SequenceNo;TicketNo'
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      '//Template'
      'SELECT WeekNo, SequenceNo, TicketNo, Quality, Time'
      'FROM TicketTicketsTimes'
      'WHERE WeekNo = 1 AND SequenceNo = 1'
      'Order By WeekNo, WeekNo, SequenceNo, TicketNo, Quality')
    Left = 75
    Top = 473
    object qTicketTimesWeekNo: TSmallintField
      FieldName = 'WeekNo'
    end
    object qTicketTimesSequenceNo: TSmallintField
      FieldName = 'SequenceNo'
    end
    object qTicketTimesTicketNo: TSmallintField
      FieldName = 'TicketNo'
    end
    object qTicketTimesQuality: TSmallintField
      FieldName = 'Quality'
    end
    object qTicketTimesTime: TFloatField
      FieldName = 'Time'
    end
  end
  object frdbTicketTimes: TfrxDBDataset
    UserName = 'frdbTicketTimes'
    CloseDataSource = False
    FieldAliases.Strings = (
      'WeekNo=WeekNo'
      'SequenceNo=SequenceNo'
      'TicketNo=TicketNo'
      'Quality=Quality'
      'Time=Time')
    DataSet = qTicketTimes
    BCDToCurrency = False
    Left = 64
    Top = 404
  end
  object qPrinted: TFDQueryPlus
    Connection = fmSumms.ConnectionSumms
    Left = 12
    Top = 530
  end
  object qDropTemp: TFDQueryPlus
    BeforeOpen = qBeforeOpen
    BeforeExecute = qBeforeExecute
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'DROP TABLE #TPTemp')
    Left = 60
    Top = 530
  end
  object qNominalSizes2: TFDQueryPlus
    BeforeOpen = qBeforeOpen
    AfterClose = qNominalSizes2AfterClose
    IndexFieldNames = 'WEEKNO;SEQUENCENO;TICKETNO;SEQ;SIZEINDEX'
    MasterSource = dsTickets
    MasterFields = 'WeekNo;SequenceNo;TicketNo'
    BeforeExecute = qBeforeExecute
    Connection = fmSumms.ConnectionSumms
    SQL.Strings = (
      'SELECT *'
      'FROM #TPTemp'
      'Order By WeekNo, WeekNo, SequenceNo, TicketNo, Seq, SizeIndex')
    Left = 212
    Top = 489
  end
end
