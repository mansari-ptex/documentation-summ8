unit fr_Ticket;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frxClass, frxDBSet, Grids, DBGridPlus,  DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,
  FireDac.Stan.ExprFuncs, frxCross, CmnTypes, CmnVars, SummsVars, General,
  BasicAlw, ExtCtrls, jpeg, frxBarcode, frxReportPlus, RegularExpressions;

type
  TfmfrTicket = class(TForm)
    qShoeSizes: TFDQueryPlus;
    frdbShoeSizes: TfrxDBDataset;
    qNominalSizes: TFDQueryPlus;
    frdbNominalSizes: TfrxDBDataset;
    qMakeGrid: TFDQueryPlus;
    qLeatherGrid: TFDQueryPlus;
    qLeatherGridArea: TIntegerField;
    qLeatherGridQual: TIntegerField;
    qLeatherGridAllowance: TFloatField;
    dsLeatherGrid: TDataSource;
    frLeatherGrid: TfrxDBDataset;
    frTicket: TfrxReportPlus;
    qSynthGrid: TFDQueryPlus;
    qSynthGridWidth: TIntegerField;
    frdbSynthGrid: TfrxDBDataset;
    qSynthGridRF: TStringField;
    frMyArray: TfrxUserDataSet;
    qTickets: TFDQueryPlus;
    qTicketsWeekNo: TSmallintField;
    qTicketsSequenceNo: TSmallintField;
    qTicketsTicketNo: TSmallintField;
    qTicketsID: TIntegerField;
    qTicketsPartCode: TStringField;
    qTicketsPartDescription: TStringField;
    qTicketsMaterialCode: TStringField;
    qTicketsMaterialDescription: TStringField;
    qTicketsMaterialType: TStringField;
    qTicketsMaterialCutType: TStringField;
    qTicketsMaterialLength: TFloatField;
    qTicketsMaterialWidth: TFloatField;
    qTicketsMaterialSkinSize: TFloatField;
    qTicketsMaterialSkinTrimmed: TBooleanField;
    qTicketsMaterialUnits: TStringField;
    qTicketsMaterialLayers: TSmallintField;
    qTicketsAdjFactorResult: TSmallintField;
    qTicketsCutWeek: TSmallintField;
    qTicketsCutter: TStringField;
    qTicketsCutterLocation: TStringField;
    qTicketsQuality: TSmallintField;
    qTicketsArea: TSmallintField;
    qTicketsIssuedAllowance: TFloatField;
    qTicketsCostedAllowance: TFloatField;
    qTicketsActualUsage: TFloatField;
    qTicketsSMVs: TFloatField;
    qTicketsBulked: TBooleanField;
    qTicketsCostedResult: TFloatField;
    qTicketsTotalPairs: TSmallintField;
    qTicketsMatSupplier: TStringField;
    qTicketsMatPrice: TCurrencyField;
    qTicketsSpecialInstructions: TMemoField;
    qTicketsMaterialQualCoeff: TIntegerField;
    qTicketsMaterialAreaCoeff: TIntegerField;
    qTicketsSkinSize: TFloatField;
    qTicketsMaterialSkinTrimmedYN: TStringField;
    qTicketsTicketNumber: TStringField;
    qTicketsStyle: TStringField;
    qTicketsConstruction: TStringField;
    qTicketsCustomer: TStringField;
    qTicketsPicture: TBlobField;
    qTicketsMaterialUnitDescription: TStringField;
    qTicketsMaterialUnitAbbreviation: TStringField;
    qTicketsMaterialSubUnitDesc: TStringField;
    qTicketsMaterialSubUnitAbbreviation: TStringField;
    qTicketsMaterialSubUnitsPerUnit: TSmallintField;
    qTicketsMaterialUnitsToFeet: TFloatField;
    qTicketsPrint: TBooleanField;
    qTicketsPrinted: TBooleanField;
    qTicketsBasicAllowance: TFloatField;
    qTicketsBasicAllowanceXpairs: TFloatField;
    qTicketsRowsInLeatherGrid: TSmallintField;
    qTicketsLinesInLeatherGrid: TSmallintField;
    qTicketsSLMAllowance: TBooleanField;
    dsTickets: TDataSource;
    frdbTickets: TfrxDBDataset;
    qTicketTimes: TFDQueryPlus;
    qTicketTimesWeekNo: TSmallintField;
    qTicketTimesSequenceNo: TSmallintField;
    qTicketTimesTicketNo: TSmallintField;
    qTicketTimesQuality: TSmallintField;
    qTicketTimesTime: TFloatField;
    qTicketsNumberOfSheets: TFloatField;
    frdbTicketTimes: TfrxDBDataset;
    qPrinted: TFDQueryPlus;
    mSplitTicketNumber: TMemo;
    qTicketsTagNo: TStringField;
    qDropTemp: TFDQueryPlus;
    qSynthGridAllowance: TFloatField;
    qNominalSizes2: TFDQueryPlus;
    qTicketsStyleDescription: TStringField;
    procedure Setup;
    procedure qLeatherGridCalcFields(DataSet: TDataSet);
    procedure DropTemp;
    procedure frTicketGetValue(const VarName: string; var Value: Variant);
    procedure qTicketsCalcFields(DataSet: TDataSet);
    procedure qTicketsAfterScroll(DataSet: TDataSet);
    procedure frTicketEndDoc(Sender: TObject);
    procedure PrintedFlagsAndAudit(TicketNumber: string);
    procedure frTicketAfterPrintReport(Sender: TObject);
    procedure frTicketPrintPage(Page: TfrxReportPage; CopyNo: Integer);
    procedure frTicketBeforePrint(Sender: TfrxReportComponent);
    procedure DecodeTicketNumber(TicketNumber: string;
                                 var WeekNo, SeqNo, TicketNo: string);
    procedure FormDestroy(Sender: TObject);
    procedure qNominalSizes2AfterClose(DataSet: TDataSet);
    procedure qBeforeOpen(DataSet: TDataSet);
    procedure qBeforeExecute(DataSet: TFDDataSet);
  private
    { Private declarations }
    LinesInLeatherGridForTicket, RowsInLeatherGridForTicket: integer;
    TempTable: string;
  public
    { Public declarations }
    GroupPrint: boolean;
    constructor Create(AOwner: TComponent); override;
    procedure RandomTempName();
  end;

var
  fmfrTicket: TfmfrTicket;

implementation

uses
  Summs, CancelPrinting;

{$R *.dfm}

procedure TfmfrTicket.SetUp;
var
  ChildBand: TfrxChild;
  PageFooter: TfrxPageFooter;
  MyMemo: TfrxMemoView;

begin
  DropTemp;

  try
    RowsInLeatherGridForTicket := qTickets.FieldValues['ROWSINLEATHERGRID'];
    LinesInLeatherGridForTicket := qTickets.FieldValues['LINESINLEATHERGRID'];
  except
    RowsInLeatherGridForTicket := 0;
    LinesInLeatherGridForTicket := 0;
  end;

  frMyArray.RangeEnd := reCount;
  frMyArray.RangeEndCount := Length(TicketTranslation);

{
  frTicket.Variables['NumberOfRows'] := RowsInLeatherGridForTicket;
  frTicket.Variables['CuttingTimes'] := Option_CuttingTimes;
  frTicket.Variables['ShoeSizes'] := '''' + TicketTranslation[19] + '''';
  frTicket.Variables['KnifeCode'] := '''' + TicketTranslation[20] + '''';
  frTicket.Variables['Quality'] := '''' + TicketTranslation[21] + '''';
  frTicket.Variables['WidthIn'] := '''' + TicketTranslation[28] + ' ' + qTicketsMaterialSubUnitDesc.value + '''';
  frTicket.Variables['GridLines'] := fmSumms.mmGridLines.Checked;
  //You need this weird syntax or FR string variables do not work. Note - had to put these lines here and NOT
  //OnBeforePrint of the report. Only integers worked there if I tried to receive them with the OnBeforePrint
  //of the ReportPage within the report.
}

  ChildBand := frTicket.FindObject('cbBarcodePicture') as TfrxChild;
  ChildBand.Visible := ShowBarCodeNPic;

  //Fonts
  MyMemo := frTicket.FindObject('mSATRASummCuttingTicket') as TfrxMemoView;
  MyMemo.Font.Name := TitleFontName;
  MyMemo.Font.Size := TitleFontSize;
  MyMemo.Font.Style := TitleFontStyle;
  MyMemo := frTicket.FindObject('Date') as TfrxMemoView;
  MyMemo.Font.Name := TitleFontName;
  MyMemo.Font.Size := TitleFontSize;
  MyMemo.Font.Style := TitleFontStyle;
  MyMemo := frTicket.FindObject('mTicketNumber') as TfrxMemoView;
  MyMemo.Font.Name := StandardFontName;
  MyMemo.Font.Size := StandardFontSize;
  MyMemo.Font.Style := StandardFontStyle;
  MyMemo := frTicket.FindObject('mTicketNum') as TfrxMemoView;
  MyMemo.Font.Name := StandardFontName;
  MyMemo.Font.Size := StandardFontSize;
  MyMemo.Font.Style := StandardFontStyle;
  MyMemo := frTicket.FindObject('mCutterNumber') as TfrxMemoView;
  MyMemo.Font.Name := StandardFontName;
  MyMemo.Font.Size := StandardFontSize;
  MyMemo.Font.Style := StandardFontStyle;
  MyMemo := frTicket.FindObject('mCutWeek') as TfrxMemoView;
  MyMemo.Font.Name := StandardFontName;
  MyMemo.Font.Size := StandardFontSize;
  MyMemo.Font.Style := StandardFontStyle;
  MyMemo := frTicket.FindObject('mSpecialInstructions') as TfrxMemoView;
  MyMemo.Font.Name := StandardFontName;
  MyMemo.Font.Size := StandardFontSize;
  MyMemo.Font.Style := StandardFontStyle;
  ChildBand := frTicket.FindObject('cbMainDetails') as TfrxChild;
  ChildBand.Font.Name := StandardFontName;
  ChildBand.Font.Size := StandardFontSize;
  ChildBand.Font.Style := StandardFontStyle;
  ChildBand := frTicket.FindObject('cbShoeSizes') as TfrxChild;
  ChildBand.Font.Name := FixedFontName;
  ChildBand.Font.Size := FixedFontSize;
  ChildBand.Font.Style := StandardFontStyle;
  ChildBand := frTicket.FindObject('cbKnifeSizes') as TfrxChild;
  ChildBand.Font.Name := FixedCutFontName;
  ChildBand.Font.Size := FixedCutFontSize;
  ChildBand.Font.Style := FixedCutFontStyle;
  ChildBand := frTicket.FindObject('cbSheet') as TfrxChild;
  ChildBand.Font.Name := FixedFontName;
  ChildBand.Font.Size := FixedFontSize;
  ChildBand.Font.Style := StandardFontStyle;
  ChildBand := frTicket.FindObject('cbLeatherGrid') as TfrxChild;
  ChildBand.Font.Name := FixedFontName;
  ChildBand.Font.Size := FixedFontSize;
  ChildBand.Font.Style := StandardFontStyle;
  ChildBand := frTicket.FindObject('cbSyntheticGrid') as TfrxChild;
  ChildBand.Font.Name := FixedFontName;
  ChildBand.Font.Size := FixedFontSize;
  ChildBand.Font.Style := FixedFontStyle;
  //Left code below in (but commented out) because we should try to find a solution
  //if we change to a new way of selecting font styles. The problem currently is that
  //if you change the font style of the vertical label for Area, the label refuses to
  //be vertical anymore - only works vertically with fonts that have the 'O' like symbol.
{  MyMemo := frTicket.FindObject('mVerticalArea') as TfrxMemoView;
  MyMemo.Font.Name := FixedFontName;
  MyMemo.Font.Size := FixedFontSize;
  MyMemo.Font.Style := StandardFontStyle;}

  PageFooter := frTicket.FindObject('PageFooter1') as TfrxPageFooter;
  PageFooter.Font.Name := StandardFontName;
  PageFooter.Font.Size := StandardFontSize;
  PageFooter.Font.Style := StandardFontStyle;

  MyMemo := frTicket.FindObject('mTagNumberTitle') as TfrxMemoView;
  MyMemo.Visible := PrintTagNumbers;
  MyMemo := frTicket.FindObject('mTagNumber') as TfrxMemoView;
  MyMemo.Visible := PrintTagNumbers;
  MyMemo := frTicket.FindObject('mCustomerTitle') as TfrxMemoView;
  MyMemo.Visible := PrintCustomer;
  MyMemo := frTicket.FindObject('mCustomer') as TfrxMemoView;
  MyMemo.Visible := PrintCustomer;
end;

procedure TfmfrTicket.DropTemp;
begin
  qLeatherGrid.Close;
  qLeatherGrid.Disconnect;  //AdsCloseSQLStatement replaced by Disconnect when converted to FireDac
  qSynthGrid.Close;
  qSynthGrid.Disconnect;  //AdsCloseSQLStatement replaced by Disconnect when converted to FireDac

  qMakeGrid.SQL.Clear;
  qMakeGrid.SQL.Text := 'TRY DROP TABLE #TEMP' + TempTable + '; CATCH ALL END;';
  try
    qMakeGrid.ExecSQL;
  except
    beep;
  end;
end;

procedure TfmfrTicket.FormDestroy(Sender: TObject);
begin
  DropTemp;
end;

procedure TfmfrTicket.frTicketAfterPrintReport(Sender: TObject);
begin
  qPrinted.ExecSQL;
end;

procedure TfmfrTicket.frTicketBeforePrint(Sender: TfrxReportComponent);
begin
  qPrinted.SQL.Clear;

  frTicket.PreviewOptions.AllowEdit := False;
  frTicket.PreviewOptions.Buttons := frTicket.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frTicket.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frTicket.PreviewOptions.ZoomMode := zmDefault
  else
    frTicket.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmfrTicket.frTicketEndDoc(Sender: TObject);
begin
  DropTemp;
end;

procedure TfmfrTicket.frTicketGetValue(const VarName: string; var Value: Variant);
var
  s: string;
  i: integer;

begin
  i := StrToIntDef(VarName, -1);

  if i >= 0 then
  begin
    Value := TicketTranslation[i];
  end
  else
  begin
    if VarName = 'NumberOfRows' then
      Value := RowsInLeatherGridForTicket
    else if VarName = 'ShoeSizes' then
      Value := TicketTranslation[19]
    else if VarName = 'KnifeCode' then
      Value := TicketTranslation[20]
    else if VarName = 'Quality' then
      Value := TicketTranslation[21]
    else if VarName = 'CuttingTimes' then
      Value := Option_CuttingTimes
    else if VarName = 'GridLines' then
      Value := fmSumms.mmGridLines.Checked
    else if VarName = 'TotalItems' then
    begin
      if ThisTicketMadeInPairs then
        Value := TicketTranslation[9]
      else
        Value := TicketTranslation[10];
    end
    else if VarName = 'SkinSizeORWidth' then
    begin
      if (qTicketsMaterialType.value[1] in Leathers) then
        Value := TicketTranslation[13]
      else
        Value := TicketTranslation[14];
    end
    else if VarName = 'SkinTrimmedORLength' then
    begin
      if (qTicketsMaterialType.value[1] in Leathers) then
        Value := TicketTranslation[15]
      else
        Value := TicketTranslation[16];
    end
    else if VarName = 'SSWid' then
    begin
      if (qTicketsMaterialType.value[1] in Leathers) then
        Value := qTicketsSkinSize.value
      else
        Value := qTicketsMaterialWidth.value;
    end
    else if VarName = 'STLen' then
    begin
      //Field Might be a string or a real so formated here
      if (qTicketsMaterialType.value[1] in Leathers) then
        Value := qTicketsMaterialSkinTrimmedYN.value
      else
      begin
        str(qTicketsMaterialLength.value : 8 : 2, s);
        Value := s;
      end;
    end
    else if VarName = 'SSWidUnit' then
    begin
      if (qTicketsMaterialType.value[1] in Leathers) then
        Value := 'sq ' +  qTicketsMaterialUnitAbbreviation.value
      else
        Value := qTicketsMaterialSubUnitAbbreviation.value;
    end
    else if VarName = 'STLenUnit' then
    begin
      if (qTicketsMaterialType.value[1] in Leathers) or (qTicketsMaterialType.value[1] = 'R') then
        Value := ''
      else
        Value := qTicketsMaterialSubUnitAbbreviation.value;
    end
    else if VarName = 'WidthIn' then
      Value := TicketTranslation[28] + ' ' + qTicketsMaterialSubUnitDesc.value;
  end;

{
  try
    Value := TicketTranslation[StrToInt(VarName)];
  except
    if VarName = 'NumberOfRows' then
      Value := RowsInLeatherGridForTicket
    else if VarName = 'ShoeSizes' then
      Value := TicketTranslation[19]
    else if VarName = 'KnifeCode' then
      Value := TicketTranslation[20]
    else if VarName = 'Quality' then
      Value := TicketTranslation[21]
    else if VarName = 'CuttingTimes' then
      Value := Option_CuttingTimes
    else if VarName = 'GridLines' then
      Value := fmSumms.mmGridLines.Checked
    else if VarName = 'TotalItems' then
    begin
      if ThisTicketMadeInPairs then
        Value := TicketTranslation[9]
      else
        Value := TicketTranslation[10];
    end
    else if VarName = 'SkinSizeORWidth' then
    begin
      if (qTicketsMaterialType.value[1] in Leathers) then
        Value := TicketTranslation[13]
      else
        Value := TicketTranslation[14];
    end
    else if VarName = 'SkinTrimmedORLength' then
    begin
      if (qTicketsMaterialType.value[1] in Leathers) then
        Value := TicketTranslation[15]
      else
        Value := TicketTranslation[16];
    end
    else if VarName = 'SSWid' then
    begin
      if (qTicketsMaterialType.value[1] in Leathers) then
        Value := qTicketsSkinSize.value
      else
        Value := qTicketsMaterialWidth.value;
    end
    else if VarName = 'STLen' then
    begin
      //Field Might be a string or a real so formated here
      if (qTicketsMaterialType.value[1] in Leathers) then
        Value := qTicketsMaterialSkinTrimmedYN.value
      else
      begin
        str(qTicketsMaterialLength.value : 8 : 2, s);
        Value := s;
      end;
    end
    else if VarName = 'SSWidUnit' then
    begin
      if (qTicketsMaterialType.value[1] in Leathers) then
        Value := 'sq ' +  qTicketsMaterialUnitAbbreviation.value
      else
        Value := qTicketsMaterialSubUnitAbbreviation.value;
    end
    else if VarName = 'STLenUnit' then
    begin
      if (qTicketsMaterialType.value[1] in Leathers) or (qTicketsMaterialType.value[1] = 'R') then
        Value := ''
      else
        Value := qTicketsMaterialSubUnitAbbreviation.value;
    end
    else if VarName = 'WidthIn' then
      Value := TicketTranslation[28] + ' ' + qTicketsMaterialSubUnitDesc.value;
  end;
}
end;

constructor TfmfrTicket.Create(AOwner: TComponent);
begin
  inherited;
  RandomTempName;
end;

procedure TfmfrTicket.DecodeTicketNumber(TicketNumber: string;
                                         var WeekNo, SeqNo, TicketNo: string);
begin
  mSplitTicketNumber.Lines.Clear;
  ExtractStrings(['/'], [' '], PChar(TicketNumber), mSplitTicketNumber.Lines);
  WeekNo := mSplitTicketNumber.Lines[0];
  SeqNo := mSplitTicketNumber.Lines[1];
  TicketNo := mSplitTicketNumber.Lines[2];
end;

procedure TfmfrTicket.frTicketPrintPage(Page: TfrxReportPage; CopyNo: Integer);
var
  i: integer;
  StopNow: boolean;
  c: TObject;
begin
  i := 0;
  StopNow := False;
  if CopyNo = 1 then
    while not((i = Page.AllObjects.Count) or StopNow) do
    begin
      c := Page.AllObjects.Items[i];
      if c is TfrxMemoView then
        if TfrxMemoView(c).Name = 'mTicketNum' then
        begin
          PrintedFlagsAndAudit(TfrxMemoView(c).Text);
          StopNow := True;
        end;
      inc(i);
    end;
end;

procedure TfmfrTicket.qLeatherGridCalcFields(DataSet: TDataSet);
var
  Allowance: real;

begin
  if (qTicketsMaterialType.value[1] in Leathers) then
  begin
    if qLeatherGridArea.Value = 0 then    //times!!
    begin
      //CJY Refresh not required as only updating filter value
      qTicketTimes.Filtered := False;
      qTicketTimes.Filter := 'Quality = ' + IntToStr(qLeatherGridQual.Value);
      qTicketTimes.Filtered := True;
      //CJY skipping first / last row and Filtered
//      if qTicketTimes.Active then
//        qTicketTimes.Refresh;
        //TAH The Open/Close added to replace Refresh was
        //not needed at all and caused massive slow down
//      if qTicketTimes.Active then
//      begin
//        qTicketTimes.Close;
//        qTicketTimes.Open;
//      end;

      qLeatherGridAllowance.Value := qTicketTimesTime.Value;
    end
    else
    begin
      Allowance := dmBasAll.CalcAdjAlw(qLeatherGridArea.Value, qLeatherGridQual.Value, qTicketsAdjFactorResult.value, qTicketsBasicAllowance.value);
      qLeatherGridAllowance.Value := (Allowance * qTicketsTotalPairs.value) / (qTicketsMaterialUnitsToFeet.Value * qTicketsMaterialUnitsToFeet.Value);
    end;
  end;
end;

procedure TfmfrTicket.qNominalSizes2AfterClose(DataSet: TDataSet);
begin
  qNominalSizes2.Disconnect;  //AdsCloseSQLStatement replaced by Disconnect when converted to FireDac (& was qNominalSizes)
  try
    qDropTemp.ExecSQL;
  except
  end;
end;

procedure TfmfrTicket.qBeforeExecute(DataSet: TFDDataSet);
begin
  qBeforeOpen(DataSet);
end;

procedure TfmfrTicket.qBeforeOpen(DataSet: TDataSet);
var
  sSql: string;
begin
  sSql := TFDQuery(DataSet).SQL.Text;
  if (DataSet.Name = 'qNominalSizes') then
  begin
    sSql := TRegEx.Replace(sSql, '\@WeekNo = CAST\([\:0-9A-Z]+ AS SQL_INTEGER\);', '@WeekNo = CAST(' + IntToStr(TFDQuery(DataSet).Params.ParamByName('WeekNo').AsInteger) + ' AS SQL_INTEGER);', [roIgnoreCase]);
    sSql := TRegEx.Replace(sSql, '\@SequenceNo = CAST\([\:0-9A-Z]+ AS SQL_INTEGER\);', '@SequenceNo = CAST(' + IntToStr(TFDQuery(DataSet).Params.ParamByName('SequenceNo').AsInteger) + ' AS SQL_INTEGER);', [roIgnoreCase]);
  end;
  sSql := TRegEx.Replace(sSql, '#TEMP[A-Z]*', '#TEMP' + Self.TempTable, [roIgnoreCase]);
  sSql := TRegEx.Replace(sSql, '#TPTEMP[A-Z]*', '#TPTEMP' + Self.TempTable, [roIgnoreCase]);
  TFDQuery(DataSet).SQL.Text := sSQL;
end;

procedure TfmfrTicket.qTicketsAfterScroll(DataSet: TDataSet);
var
  i, j, AdjQualCoeff, MidRow, MidCol, Max, MaxPlus, Min: integer;
  qStr, AlwStr, TimeStr: string;
  MyMemo: TfrxMemoView;
  ChildBand: TfrxChild;
  OverlayBand: TfrxOverlay;
  bcPic: TfrxPictureView;
  TempTableNamed: boolean;
  TempTableTries: integer;

begin
  DropTemp;
  Application.ProcessMessages;

  qTicketTimes.Filtered := False;
  //CJY skipping first / last row and Filtered
//  if qTicketTimes.Active then
//    qTicketTimes.Refresh;
    //TAH The Open/Close added to replace Refresh was
    //not needed at all and caused massive slow down
//  if qTicketTimes.Active then
//  begin
//    qTicketTimes.Close;
//    qTicketTimes.Open;
//  end;

  if (qTicketsMaterialType.value[1] in Leathers) then
  begin
    MidCol := trunc(LinesInLeatherGridForTicket / 2);
    MidRow := trunc(RowsInLeatherGridForTicket / 2) + 1;
    AdjQualCoeff := qTicketsMaterialQualCoeff.value;
    if (AdjQualCoeff > (100 - MidCol)) then
      AdjQualCoeff := 100 - MidCol;

//    qStr := 'CREATE TABLE #TEMP(Area integer, Qual integer, Allowance double); ';

    TempTableTries := 10;
    TempTableNamed := false;
    while (not TempTableNamed) and (TempTableTries > 0) do
    begin
      Dec(TempTableTries);
      try
        qStr := 'CREATE TABLE #TEMP' + TempTable + '(Area integer, Qual integer, Allowance double); ';
        qMakeGrid.SQL.Text := qStr;
        qMakeGrid.ExecSQL;
        TempTableNamed := true;
      except
        RandomTempName;
      end;
    end;
    qStr := '';

    for i := 0 to RowsInLeatherGridForTicket do
      for j := 0 to LinesInLeatherGridForTicket - 1 do
      begin
        if i = 0 then
          qStr := qStr + 'INSERT INTO #TEMP' + TempTable + '(Area, Qual) VALUES (0,' + IntToStr(AdjQualCoeff + MidCol - j) + '); '
        else
          qStr := qStr + 'INSERT INTO #TEMP' + TempTable + '(Area, Qual) VALUES (' +  IntToStr(qTicketsMaterialAreaCoeff.value + MidRow - i) + ', ' + IntToStr(AdjQualCoeff + MidCol - j) + '); ';
      end;
    qMakeGrid.SQL.Text := qStr;
    if (Length(qStr) > 0) then
      qMakeGrid.ExecSQL;
    qLeatherGrid.Open;
    ChildBand := frTicket.FindObject('cbLeatherGrid') as TfrxChild;
    ChildBand.Visible := True;
    ChildBand := frTicket.FindObject('cbSheet') as TfrxChild;
    ChildBand.Visible := False;
    ChildBand := frTicket.FindObject('cbSyntheticGrid') as TfrxChild;
    ChildBand.Visible := False;
    MyMemo := frTicket.FindObject('mSTLenTitle') as TfrxMemoView;
    MyMemo.Visible := True;
    MyMemo := frTicket.FindObject('mSTLen') as TfrxMemoView;
    MyMemo.Visible := True;
    MyMemo.HAlign := haLeft;
    MyMemo := frTicket.FindObject('mAdjustmentFactorTitle') as TfrxMemoView;
    MyMemo.Visible := True;
    MyMemo := frTicket.FindObject('mAdjustmentFactor') as TfrxMemoView;
    MyMemo.Visible := True;
    MyMemo := frTicket.FindObject('mLayersTitle') as TfrxMemoView;
    MyMemo.Visible := False;
    MyMemo := frTicket.FindObject('mLayers') as TfrxMemoView;
    MyMemo.Visible := False;
  end
  else
  begin
    ChildBand := frTicket.FindObject('cbLeatherGrid') as TfrxChild;
    ChildBand.Visible := False;
    MyMemo := frTicket.FindObject('mAdjustmentFactorTitle') as TfrxMemoView;
    MyMemo.Visible := False;
    MyMemo := frTicket.FindObject('mAdjustmentFactor') as TfrxMemoView;
    MyMemo.Visible := False;
    MyMemo := frTicket.FindObject('mLayersTitle') as TfrxMemoView;
    MyMemo.Visible := True;
    MyMemo := frTicket.FindObject('mLayers') as TfrxMemoView;
    MyMemo.Visible := True;

    if (qTicketsMaterialType.value = 'R') then
    begin
      str(qTicketTimesTime.Value : 10 : 4, TimeStr);
      Min := round(qTicketsMaterialWidth.value) - 5;
      if (Min <= 0) then
      begin
        MaxPlus := 5 - Min + 1;
        Min := 1;
      end
      else
        MaxPlus := 5;

//      qStr := 'CREATE TABLE #TEMP(Width integer, RF char(20), Allowance double); ';

      TempTableTries := 10;
      TempTableNamed := false;
      while (not TempTableNamed) and (TempTableTries > 0) do
      begin
        try
          qStr := 'CREATE TABLE #TEMP' + TempTable + '(Width integer, RF char(20), Allowance double); ';
          qMakeGrid.SQL.Text := qStr;
          qMakeGrid.ExecSQL;
          TempTableNamed := true;
        except
          RandomTempName;
        end;
      end;
      qStr := '';

      Max := round(qTicketsMaterialWidth.value) + MaxPlus;
      for i := Min to Max do
      begin
        str(qTicketsIssuedAllowance.Value * qTicketsMaterialSubUnitsPerUnit.Value / i : 10 : 4, AlwStr);
        qStr := qStr + 'INSERT INTO #TEMP' + TempTable + '(Width, RF, Allowance) VALUES (' + IntToStr(i) + ', ''' + TicketTranslation[30] + ' ' + qTicketsMaterialUnitDescription.value + ''',' + AlwStr + '); ';
      end;
      qStr := qStr + 'INSERT INTO #TEMP' + TempTable + '(Width, RF, Allowance) VALUES (9999, ''' + ticketTranslation[30] + ' ' + qTicketsMaterialUnitDescription.value + ''', ' + TimeStr + '); ';
      qMakeGrid.SQL.Text := qStr;
      if (Length(qStr) > 0) then
        qMakeGrid.ExecSQL;
      qSynthGrid.Open;

      ChildBand := frTicket.FindObject('cbSheet') as TfrxChild;
      ChildBand.Visible := True;
      MyMemo := frTicket.FindObject('mSheetsTitle') as TfrxMemoView;
      MyMemo.Visible := False;
      MyMemo := frTicket.FindObject('mSheets') as TfrxMemoView;
      MyMemo.Visible := False;

      MyMemo := frTicket.FindObject('mStandardMinutesTitle') as TfrxMemoView;
      MyMemo.Visible := False;
      MyMemo := frTicket.FindObject('mStandardMinutes') as TfrxMemoView;
      MyMemo.Visible := False;

      ChildBand := frTicket.FindObject('cbSyntheticGrid') as TfrxChild;
      ChildBand.Visible := True;
      MyMemo := frTicket.FindObject('mSTLenTitle') as TfrxMemoView;
      MyMemo.Visible := False;
      MyMemo := frTicket.FindObject('mSTLen') as TfrxMemoView;
      MyMemo.Visible := False;
    end
    else
    begin
      ChildBand := frTicket.FindObject('cbSheet') as TfrxChild;
      ChildBand.Visible := True;

      MyMemo := frTicket.FindObject('mStandardMinutesTitle') as TfrxMemoView;
      MyMemo.Visible := Option_CuttingTimes;
      MyMemo := frTicket.FindObject('mStandardMinutes') as TfrxMemoView;
      MyMemo.Visible := Option_CuttingTimes;

      ChildBand := frTicket.FindObject('cbSyntheticGrid') as TfrxChild;
      ChildBand.Visible := False;
      MyMemo := frTicket.FindObject('mSTLenTitle') as TfrxMemoView;
      MyMemo.Visible := True;
      MyMemo := frTicket.FindObject('mSTLen') as TfrxMemoView;
      MyMemo.Visible := True;
      MyMemo.HAlign := haRight;
    end;
  end;
  if qShoeSizes.Active then
  begin
    //CJY Refresh not required as only updating filter value
    qShoeSizes.Filtered := False;
    qShoeSizes.Filter := 'LEFT(Size, 2) = ''? ''';
    qShoeSizes.Filtered := True;
    //CJY: Filter changes need to be refreshed to update RecordCount
//    qShoeSizes.Refresh;
    //CJY: qShoeSizes.FetchOptions.RecordCountMode set to cmTotal

    //TAH Check RecordCount > 0 but that requires (SLOW) Refresh (Removed above)
    //  Left filtering in (above) as isnt slow and unsure ATM whether
    //  it requires filtering later on
    if qShoeSizes.locate('Size', '? ', [loPartialKey]) then
//    if (qShoeSizes.RecordCount > 0) then
    begin
      OverlayBand := frTicket.FindObject('obInvalidTicket') as TfrxOverlay;
      OverlayBand.Visible := True;
      ChildBand := frTicket.FindObject('cbShoeSizes') as TfrxChild;
      ChildBand.Visible := False;
    end
    else
    begin
      OverlayBand := frTicket.FindObject('obInvalidTicket') as TfrxOverlay;
      OverlayBand.Visible := False;
      ChildBand := frTicket.FindObject('cbShoeSizes') as TfrxChild;
      ChildBand.Visible := True;
      //CJY Refresh not required as only updating filter value
      qShoeSizes.Filtered := False;
      qShoeSizes.Filter := 'Pairs <> 0';
      qShoeSizes.Filtered := True;
      //CJY skipping first / last row and Filtered
//      if qShoeSizes.Active then
//        qShoeSizes.Refresh;
      //TAH The Open/Close added to replace Refresh was
      //not needed at all and caused massive slow down
//      if qShoeSizes.Active then
//      begin
//        qShoeSizes.Close;
//        qShoeSizes.Open;
//      end;
    end;
  end;
  if GroupPrint then
  begin
    if fmCancelPrinting.Visible then
      fmCancelPrinting.lblItem.caption := qTicketsTicketNumber.Value
    else
      frTicket.Terminated := True;
  end;
end;

procedure TfmfrTicket.qTicketsCalcFields(DataSet: TDataSet);
var
  s, ss : string;

begin
  str(qTicketsWeekNo.value, s);
  ss := s + '/';
  str(qTicketsSequenceNo.value, s);
  ss := ss + s + '/';
  str(qTicketsTicketNo.value, s);
  ss := ss + s;
  qTicketsTicketNumber.value := ss;

  if (qTicketsMaterialType.Value = 'L') or (qTicketsMaterialType.Value = 'K') or (qTicketsMaterialType.Value = 'W') then
    qTicketsSkinSize.value := qTicketsMaterialSkinSize.value
  else
    qTicketsSkinSize.value := qTicketsMaterialLength.value * qTicketsMaterialWidth.value;

  if (qTicketsMaterialSkinTrimmed.value = true) then
    qTicketsMaterialSkinTrimmedYN.value := 'Yes'
  else
    qTicketsMaterialSkinTrimmedYN.value := 'No';

  qTicketsBasicAllowanceXPairs.value := (qTicketsBasicAllowance.value * qTicketsTotalPairs.value) /
                                        (qTicketsMaterialUnitsToFeet.Value * qTicketsMaterialUnitsToFeet.Value);

  qTicketsNumberOfSheets.value := qTicketsBasicAllowanceXPairs.value / ((qTicketsMaterialLength.value / qTicketsMaterialSubUnitsPerUnit.value) *
                                  (qTicketsMaterialWidth.value / qTicketsMaterialSubUnitsPerUnit.value));
end;

procedure TfmfrTicket.RandomTempName;
begin
  TempTable := '';
  while (TempTable.Length < 10) do
  begin
    TempTable := TempTable + Char(Random(26) + 65);
  end;
end;

procedure TfmfrTicket.PrintedFlagsAndAudit(TicketNumber: string);
var
  sWeekNo, sSequenceNo, sTicketNo, sIssuedAllowance, sTotalPairs, SQLString: string;

begin
  DecodeTicketNumber(TicketNumber, sWeekNo, sSequenceNo, sTicketNo);

  //CJY Refresh not required as only updating filter value
  qTickets.Filtered := False;
  qTickets.Filter := '(WeekNo = ' + sWeekNo + ') AND (SequenceNo = ' + sSequenceNo + ') AND (TicketNo = ' + sTicketNo + ')';
  qTickets.Filtered := True;
  //CJY skipping first / last row and Filtered
//  if qTickets.Active then
//    qTickets.Refresh;
  //TAH The Open/Close added to replace Refresh was
  //not needed at all and caused massive slow down
//  if qTickets.Active then
//  begin
//    qTickets.Close;
//    qTickets.Open;
//  end;

  str(qTicketsIssuedAllowance.value : 10 : 4, sIssuedAllowance);
  str(qTicketsTotalPairs.value : 5, sTotalPairs);

  //Add to audit trail if not already printed
  if Option_TicketAudit and (qTicketsPrinted.value = FALSE) then
  begin
    SQLString := 'INSERT INTO Audit ' +
                 '(Type, UserName, WeekNo, SequenceNo, TicketNo, TransactionDate, ' +
                 'MaterialCode, Allowance, Construction, Part, TotalPairs, ' +
                 'TagNo, CustNo) ' +
                 'VALUES (''P'', ''' + QS(SystemUserName) + ''', ' + sWeekNo + ', ' +
                 sSequenceNo + ', ' + sTicketNo + ', CurDate(), ''' +
                 QS(qTicketsMaterialCode.value) + ''', ' + sIssuedAllowance + ', ''' +
                 QS(qTicketsConstruction.value) + ''', ''' + QS(qTicketsPartCode.value) + ''', ' +
                 sTotalPairs + ', ''' + QS(qTicketsTagNo.value) + ''', ''' +
                 QS(qTicketsCustomer.value) + ''');';
    qPrinted.SQL.Text := qPrinted.SQL.Text + SQLString;
  end;

  //Set this ticket as printed
  SQLString := 'UPDATE TicketTickets ' +
               'SET Printed = TRUE ' +
               'WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' + sSequenceNo +
               ' AND TicketNo = ' + sTicketNo + ';';
  qPrinted.SQL.Text := qPrinted.SQL.Text + SQLString;
end;

end.
