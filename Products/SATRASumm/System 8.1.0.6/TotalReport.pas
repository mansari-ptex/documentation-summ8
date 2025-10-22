unit TotalReport;

interface

uses
  SysUtils, Classes, Windows, Forms, Controls, Times, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Dialogs, frxClass,
  frxDBSet, frxReportPlus, CmnVars;

type
  TdmTotalReport = class(TDataModule)
    qMaterials: TFDQueryPlus;
    qMaterialsCode: TStringField;
    qMaterialsDescription: TStringField;
    qMaterialsType: TStringField;
    qMaterialsCutType: TStringField;
    qMaterialsCutGap: TSmallintField;
    qMaterialsStandardPrice: TCurrencyField;
    qMaterialsLinearMatPrice: TBooleanField;
    qMaterialsDegDiff: TSmallintField;
    qMaterialsQualCoeff: TSmallintField;
    qMaterialsAreaCoeff: TSmallintField;
    qMaterialsLength: TFloatField;
    qMaterialsWidth: TFloatField;
    qMaterialsSkinSize: TFloatField;
    qMaterialsTrimmed: TBooleanField;
    qMaterialsUnits: TStringField;
    qMaterialsLayers: TSmallintField;
    qMaterialsStrokeDepth: TFloatField;
    qMaterialsCalcSkinSize: TStringField;
    qMaterialsCalcLength: TStringField;
    qMaterialsCalcWidth: TStringField;
    qMaterialsCalcCutGap: TStringField;
    qMaterialsCalcTrimmed: TStringField;
    qMaterialsCalcStrokeDepth: TStringField;
    qMaterialsCalcQualCoeff: TStringField;
    qMaterialsCalcAreaCoeff: TStringField;
    qMaterialsCalcDegDiff: TStringField;
    qMaterialsCalcLinearPrice: TStringField;
    qMaterialsSelected: TBooleanField;
    frdbMaterials: TfrxDBDataset;
    dsqMaterials: TDataSource;
    spKnivesForStyle: TFDStoredProc;
    spKnivesForStyleKnifeCode: TStringField;
    spKnivesForStyleDescription: TStringField;
    spKnivesForStyleType: TStringField;
    spKnivesForStyleManual: TStringField;
    spKnivesForStyleCutGap: TSmallintField;
    spKnivesForStyleDblSided: TStringField;
    spKnivesForStyleThinKniife: TStringField;
    spKnivesForStylePieces: TSmallintField;
    spKnivesForStylePunches: TSmallintField;
    spKnivesForStyleClears: TSmallintField;
    spKnivesForStyleBands: TFloatField;
    spKnivesForStyleMarks: TFloatField;
    DataSource3: TDataSource;
    frdbKnivesForStyle: TfrxDBDataset;
    frWholeStyle: TfrxReportPlus;
    frdbKnifeSizeDetails: TfrxDBDataset;
    DataSource4: TDataSource;
    tblKnifeSizeDetails: TFDTablePlus;
    tblKnifeSizeDetailsCode: TStringField;
    tblKnifeSizeDetailsMeasuredSize: TStringField;
    tblKnifeSizeDetailsGrossArea: TFloatField;
    tblKnifeSizeDetailsNettArea: TFloatField;
    tblKnifeSizeDetailsInterlockArea: TFloatField;
    tblKnifeSizeDetailsAngle: TFloatField;
    qCommonWidths: TFDQueryPlus;
    qCommonWidthsNo: TSmallintField;
    qCommonWidthsWidth: TStringField;
    qCommonWidthsSampleSize: TStringField;
    qCommonWidthsCostedSize: TStringField;
    qCommonWidthsCommonIn: TIntegerField;
    DataSource8: TDataSource;
    frdbCommonWidths: TfrxDBDataset;
    qConParts: TFDQueryPlus;
    qConPartsConstruction: TStringField;
    qConPartsID: TIntegerField;
    qConPartsPart: TStringField;
    qConPartsAltMaterial: TStringField;
    qConPartsSampleSize: TStringField;
    qConPartsCostedSize: TStringField;
    qConPartsSLMAllowance: TBooleanField;
    qConPartsMadeInPairs: TBooleanField;
    qConPartsStyle: TStringField;
    qConPartsSizeScale: TStringField;
    qConPartsSizeRange: TStringField;
    qConPartsWidthRange: TStringField;
    qConPartsStdBatchSize: TSmallintField;
    qConPartsMaterial: TStringField;
    qConPartsMiP: TStringField;
    qConPartsRest: TFloatField;
    qConPartsContingency: TFloatField;
    qConPartsFeed: TStringField;
    qConPartsPicture: TGraphicField;
    DataSource5: TDataSource;
    frdbConParts: TfrxDBDataset;
    qGetData: TFDQueryPlus;
    qCuttingTimes: TFDQueryPlus;
    qCuttingTimesCoeff: TIntegerField;
    qCuttingTimesTime: TFloatField;
    tblTempSample: TFDTablePlus;
    tblTempSamplePart: TStringField;
    tblTempSampleSize: TStringField;
    tblTempSampleWidth: TStringField;
    tblTempSampleMaterial: TStringField;
    tblTempSampleBasAlw: TFloatField;
    tblTempSamplePrAlw: TFloatField;
    tblTempSampleBPrAlw: TFloatField;
    tblTempSamplePrMatCost: TFloatField;
    tblTempSampleBPrMatCost: TFloatField;
    tblTempSampleSms: TFloatField;
    DataSource1: TDataSource;
    qMainIndex: TFDQueryPlus;
    tblTempSampleTotals: TFDTablePlus;
    tblTempSampleTotalsSize: TStringField;
    tblTempSampleTotalsWidth: TStringField;
    tblTempSampleTotalsPrMatCostTotal: TFloatField;
    tblTempSampleTotalsBPrMatCostTotal: TFloatField;
    tblTempSampleTotalsSmsTotal: TFloatField;
    DataSource2: TDataSource;
    tblTempCosted: TFDTablePlus;
    tblTempCostedPart: TStringField;
    tblTempCostedSize: TStringField;
    tblTempCostedWidth: TStringField;
    tblTempCostedMaterial: TStringField;
    tblTempCostedBasAlw: TFloatField;
    tblTempCostedPrAlw: TFloatField;
    tblTempCostedBPrAlw: TFloatField;
    tblTempCostedPrMatCost: TFloatField;
    tblTempCostedBPrMatCost: TFloatField;
    tblTempCostedSms: TFloatField;
    DataSource9: TDataSource;
    tblTempCostedTotals: TFDTablePlus;
    tblTempCostedTotalsSize: TStringField;
    tblTempCostedTotalsWidth: TStringField;
    tblTempCostedTotalsPrMatCostTotal: TFloatField;
    tblTempCostedTotalsBPrMatCostTotal: TFloatField;
    tblTempCostedTotalsSmsTotal: TFloatField;
    DataSource10: TDataSource;
    frdbTempCosted: TfrxDBDataset;
    frdbTempSampleTotals: TfrxDBDataset;
    frdbTempCostedTotals: TfrxDBDataset;
    tblPtWidAF: TFDTablePlus;
    tblPtWidAFPart: TStringField;
    tblPtWidAFWidthNo: TSmallintField;
    tblPtWidAFAdjFactor: TSmallintField;
    tblPtWidAFWidthName: TStringField;
    DataSource6: TDataSource;
    frdbPtWidAF: TfrxDBDataset;
    tblPtWidKnf: TFDTablePlus;
    tblPtWidKnfPart: TStringField;
    tblPtWidKnfWidthNo: TSmallintField;
    tblPtWidKnfKnife: TStringField;
    tblPtWidKnfSeq: TFloatField;
    tblPtWidKnfFrequency: TSmallintField;
    tblPtWidKnfNoIncludedKnives: TSmallintField;
    tblPtWidKnfSizeScale: TStringField;
    tblPtWidKnfSizeRange: TStringField;
    tblPtWidKnfSizeRelationship: TStringField;
    tblPtWidKnfSizeAdjustment: TSmallintField;
    tblPtWidKnfGovernor: TBooleanField;
    tblPtWidKnfRealSampleSize: TStringField;
    tblPtWidKnfRealCostedSize: TStringField;
    DataSource7: TDataSource;
    frdbPtWidKnf: TfrxDBDataset;
    qAdjustedSize: TFDQueryPlus;
    qAdjustedSizeAdjSize: TStringField;
    qDrops: TFDQueryPlus;
    frdbTempSample: TfrxDBDataset;
    tblTempSampleUnit: TStringField;
    tblTempCostedUnit: TStringField;
    qMaterialsCalcLayers: TStringField;
    tblPtWidAFActualAdjFactor: TIntegerField;
    qConPartsManualAdjFactor: TBooleanField;
    qConPartsPressTypeLeather: TStringField;
    qConPartsPressTypeSynthetic: TStringField;
    qConPartsPressTypeLeatherDesc: TStringField;
    qConPartsPressTypeSyntheticDesc: TStringField;
    qTempTable: TFDQueryPlus;
    qConPartsMAF: TStringField;
    qConPartsAltMaterialType: TStringField;
    qConPartsMaterialType: TStringField;
    qConPartsDescription: TStringField;
    procedure frWholeStyleGetValue(const VarName: string; var Value: Variant);
    procedure PrintTotalReport(Style: string; HasPicture, Preview: boolean);
    procedure qMaterialsCalcFields(DataSet: TDataSet);
    procedure tblPtWidKnfCalcFields(DataSet: TDataSet);
    procedure DropTables;
    procedure tblPtWidAFCalcFields(DataSet: TDataSet);
    procedure qConPartsCalcFields(DataSet: TDataSet);
    procedure frWholeStyleBeforePrint(Sender: TfrxReportComponent);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmTotalReport: TdmTotalReport;

implementation

uses
  Summs, SummsVars, Adjfact, BasicAlw, CmnTypes, General, Cututils;

{$R *.dfm}

procedure TdmTotalReport.frWholeStyleBeforePrint(Sender: TfrxReportComponent);
begin
  frWholeStyle.PreviewOptions.AllowEdit := False;
  frWholeStyle.PreviewOptions.Buttons := frWholeStyle.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frWholeStyle.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frWholeStyle.PreviewOptions.ZoomMode := zmDefault
  else
    frWholeStyle.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TdmTotalReport.frWholeStyleGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
    Value := 'Full Report for Style : ' + qConPartsStyle.Value + #13 + 'Construction : ' + qConPartsConstruction.Value
  else if (VarName = 'ReportTitle2') then
    Value := qConPartsDescription.Value;

  if qConPartsMadeInPairs.Value then
  begin
  if (VarName = '1PrAlwTitle') then
    Value := '1 Pair' + #13 + 'Allowance'
  else if (VarName = 'xPrAlwTitle') then
    Value := IntToStr(BatchSize) + ' Pairs' + #13 + 'Allowance'
  else if (VarName = '1PrMatCostTitle') then
    Value := '1 Pair' + #13 + 'Material Cost'
  else if (VarName = 'xPrMatCostTitle') then
    Value := IntToStr(BatchSize) + ' Pairs' + #13 + 'Material Cost';
  end
  else
  begin
    if (VarName = '1PrAlwTitle') then
      Value := '1 Item' + #13 + 'Allowance'
    else if (VarName = 'xPrAlwTitle') then
      Value := IntToStr(BatchSize) + ' Items' + #13 + 'Allowance'
    else if (VarName = '1PrMatCostTitle') then
      Value := '1 Item' + #13 + 'Material Cost'
    else if (VarName = 'xPrMatCostTitle') then
      Value := IntToStr(BatchSize) + ' Items' + #13 + 'Material Cost';
  end;
end;

procedure TdmTotalReport.PrintTotalReport(Style: string;
                                          HasPicture, Preview: boolean);
var
  AltMaterial, Caption, Construction, MatWidthStr, UnitsStr: string;
  i, j: integer;
  SampleBasicAllowance, SampleAdjustedAllowance, SampleMaterialCostPerPair: real;
  CostedBasicAllowance, CostedAdjustedAllowance, CostedMaterialCostPerPair: real;
  CostedSyntheticBasicAllowance, SampleSyntheticBasicAllowance: Real;
  SampleTime, CostedTime, LinearMultiplierAllowance, LinearMultiplierPrice: real;
  SampleTotalMaterialCostPerPair, SampleTotalMaterialCostPerBatchPairs, SampleTotalTime: real;
  CostedTotalMaterialCostPerPair, CostedTotalMaterialCostPerBatchPairs, CostedTotalTime: real;
  SampleCaption, CostedCaption: real;
  ToFeet, SqFtToUnits: real;
  Part: string;
  AdjFactor: real;
  PartWidthNo: short;
  PartError, NotAvailable, SampleSameAsCosted: Boolean;
  NotAvailableSample, NotAvailableCosted: Boolean;
  NotAvailableSampleMC1, NotAvailableSampleMC10: boolean;
  NotAvailableCostedMC1, NotAvailableCostedMC10: boolean;
  Allowance: AllowanceResult;
  Dummy: TTicketInts;
  mMemo: TfrxMemoView;

begin
  NotAvailableSampleMC1 := False;
  NotAvailableCostedMC1 := False;
  NotAvailableSampleMC10 := False;
  NotAvailableCostedMC10 := False;

  NotAvailableSample := false;
  NotAvailableCosted := false;

  CreatingFullReport := True;

  TfrxChild(frWholeStyle.FindObject('Picture1')).Visible := HasPicture;

  mMemo := frWholeStyle.FindObject('Memo10') as TfrxMemoView;
  mMemo.Visible := Option_LegacySynthetics;
  mMemo := frWholeStyle.FindObject('frdbKnivesForStyleCutGap') as TfrxMemoView;
  mMemo.Visible := Option_LegacySynthetics;

  mMemo := frWholeStyle.FindObject('Memo11') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('frdbKnivesForStyleDoubleSided') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('Memo12') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('frdbKnivesForStyleThin') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('Memo14') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('frdbKnivesForStylePunches') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('Memo15') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('frdbKnivesForStyleClears') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('Memo16') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('frdbKnivesForStyleBands') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('Memo17') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('frdbKnivesForStyleMarks') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('mStrTitle') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('mStr') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;

  mMemo := frWholeStyle.FindObject('Memo35') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('frdbConPartsRest') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('Memo36') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('frdbConPartsContingency') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('Memo37') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('frdbConPartsFeedSystem') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('Memo59') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('Memo50') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('Memo38') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frWholeStyle.FindObject('frdbConPartsPressType') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;

  mMemo := frWholeStyle.FindObject('Memo81') as TfrxMemoView;
  mMemo.Visible := Option_SinglesAllowed;
  mMemo := frWholeStyle.FindObject('frdbConPartsMiP') as TfrxMemoView;
  mMemo.Visible := Option_SinglesAllowed;

  mMemo := frWholeStyle.FindObject('Memo48') as TfrxMemoView;
  mMemo.Visible := Option_ProductionSystem;
  mMemo := frWholeStyle.FindObject('frdbPtWidKnfSizeAdjustment') as TfrxMemoView;
  mMemo.Visible := Option_ProductionSystem;
  mMemo := frWholeStyle.FindObject('Memo49') as TfrxMemoView;
  mMemo.Visible := Option_ProductionSystem;
  mMemo := frWholeStyle.FindObject('frdbPtWidKnfNoIncludedKnives') as TfrxMemoView;
  mMemo.Visible := Option_ProductionSystem;

  qConParts.ParamByName('Code').AsString := Style;
  qConParts.Open;
  SampleSameAsCosted := (qConPartsSampleSize.Value = qConPartsCostedSize.Value);
  if SampleSameAsCosted then
  begin
    TfrxMemoView(frWholeStyle.FindObject('mSampleCostedSize')).Memo.Clear;
    TfrxMemoView(frWholeStyle.FindObject('mSampleCostedSize')).Memo.Add('Sample/Costed Size:')
  end
  else
  begin
    TfrxMemoView(frWholeStyle.FindObject('mSampleCostedSize')).Memo.Clear;
    TfrxMemoView(frWholeStyle.FindObject('mSampleCostedSize')).Memo.Add('Sample Size:')
  end;

  qTempTable.SQL.Text := 'CREATE TABLE #Temp(Part char(20), Size char(10), ' +
                         'Width char(10), Material char(20), Unit char(20), ' +
                         'BasAlw Double, PrAlw Double, BPrAlw Double, ' +
                         'PrMatCost Double, BPrMatCost Double, Sms Double);';
  qTempTable.ExecSQL;

  qTempTable.Disconnect;  //AdsCloseSQLStatement replaced by Disconnect when converted to FireDac
  tblTempSample.Tablename := '#Temp';

  qTempTable.SQL.Text := 'CREATE TABLE #TempTotals(Size char(10), Width char(10), ' +
                         'PrMatCostTotal Double, BPrMatCostTotal Double, SmsTotal Double);';
  qTempTable.ExecSQL;

  qTempTable.Disconnect;  //AdsCloseSQLStatement replaced by Disconnect when converted to FireDac
  tblTempSampleTotals.Tablename := '#TempTotals';

  qMainIndex.ExecSQL;
  qMainIndex.Disconnect;  //AdsCloseSQLStatement replaced by Disconnect when converted to FireDac

  tblTempSample.Open;
  tblTempSampleTotals.Open;
  tblTempCostedTotals.Open;

  //CJY: qConParts.FetchOptions.RecordCountMode set to cmTotal
  if qConParts.recordcount > 0 then
  begin
    PartError := false;
    Construction := qConPartsConstruction.Value;

    qCommonWidths.ParamByName('Code').AsString := Construction;
    qCommonWidths.Open;

    qCommonWidths.RecNo := 1; //CJY changed from qCommonWidths.First
    qCommonWidths.Prior; //CJY changed from qCommonWidths.First
    while not(qCommonWidths.eof or PartError) do
    begin
      NotAvailable := False;

      SampleTotalMaterialCostPerPair := 0;
      SampleTotalMaterialCostPerBatchPairs := 0;
      SampleTotalTime := 0;
      CostedTotalMaterialCostPerPair := 0;
      CostedTotalMaterialCostPerBatchPairs := 0;
      CostedTotalTime := 0;

      qConParts.RecNo := 1; //CJY changed from qConParts.First
      qConParts.Prior; //CJY changed from qConParts.First
      while not(qConParts.eof or PartError) do
      begin
        Part := qConPartsPart.Value;
        AltMaterial := qConPartsAltMaterial.Value;
        PartWidthNo := qCommonWidthsNo.value;

        Allowance := dmBasAll.AllowanceSingle(Part, AltMaterial, qConPartsSampleSize.Value,
                                              qConPartsCostedSize.Value, PartWidthNo, TRUE,
                                              qConPartsSLMAllowance.Value);
        PartError := not(Allowance.Error = '');

        if PartError then
          MessageDlgPos('Report cannot be generated due to error' + #13 + 'calculating allowance for Part: ' +
            Part + '  Width: ' + qCommonWidthsWidth.value + #13 + #13 + Allowance.Error, mtError, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
        else
        begin
          SampleBasicAllowance := Allowance.BasicAllowance;
          SampleAdjustedAllowance := Allowance.AdjustedAllowance;
          SampleSyntheticBasicAllowance := Allowance.SampleSyntheticBasicAllowance;

          if not SampleSameAsCosted then
          begin
            Allowance := dmBasAll.AllowanceSingle(Part, AltMaterial, qConPartsSampleSize.Value,
                                                  qConPartsCostedSize.Value, PartWidthNo, FALSE,
                                                  qConPartsSLMAllowance.Value);

            PartError := not(Allowance.Error = '');

            if PartError then
              MessageDlgPos('Report cannot be generated due to error' + #13 + 'calculating allowance for Part: ' +
                Part + #13 + #13 + Allowance.Error, mtError, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))

            else
            begin
              CostedBasicAllowance := Allowance.BasicAllowance;
              CostedAdjustedAllowance := Allowance.AdjustedAllowance;
              CostedSyntheticBasicAllowance := Allowance.CostedSyntheticBasicAllowance;
            end;
          end
          else
          begin
            CostedBasicAllowance := SampleBasicAllowance;
            CostedAdjustedAllowance := SampleAdjustedAllowance;
            CostedSyntheticBasicAllowance := SampleSyntheticBasicAllowance;
          end;

          if not PartError then
          begin
            if Option_CuttingTimes and not PartError then
              AdjFactor := dmAdjFact.PartAdjFactor(Part, PartWidthNo)
            else
              Adjfactor := 0;

            qGetData.ParamByName('PartCode').AsString := Part;
            qGetData.ParamByName('WidthNo').value := PartWidthNo;
            qGetData.ParamByName('AdjFactor').value := AdjFactor;
            qGetData.ParamByName('SampleAdjustedAllowance').value := SampleAdjustedAllowance;
            qGetData.ParamByName('CostedAdjustedAllowance').value := CostedAdjustedAllowance;
            qGetData.ParamByName('SampleSyntheticBasicAllowance').AsFloat := SampleSyntheticBasicAllowance;
            qGetData.ParamByName('CostedSyntheticBasicAllowance').AsFloat := CostedSyntheticBasicAllowance;
            qGetData.paramByName('Construction').value := Construction;
            qGetData.Open;

            if Option_CuttingTimes then
            begin
              //CJY: If CalculateAllTimes finds a min/max error note set Time = 0 and mark as not available;
              dmTimes.CalculateAllTimes(TRUE, qGetData.FieldByName('StdBatchSize').value, qGetData, qCuttingTimes, 0, Allowance.AdjInterlocks, Dummy, TRUE);
              if not dmCutUtils.MessageShown then
              begin
                qCuttingTimes.Open;
                SampleTime := qCuttingTimes.FieldByName('Time').value;
                qCuttingTimes.Close;
              end
              else
              begin
                SampleTime := 0;
                NotAvailableSample := True;
              end;
            end
            else
              SampleTime := 0;

            if not SampleSameAsCosted then
            begin
              if Option_CuttingTimes then
              begin
                //CJY: If CalculateAllTimes finds a min/max error note set Time = 0 and mark as not available;
                dmTimes.CalculateAllTimes(FALSE, qGetData.FieldByName('StdBatchSize').value, qGetData, qCuttingTimes, 0, Allowance.AdjInterlocks, Dummy, TRUE);
                if not dmCutUtils.MessageShown then
                begin
                  qCuttingTimes.Open;
                  CostedTime := qCuttingTimes.FieldByName('Time').value;
                  qCuttingTimes.Close;
                end
                else
                begin
                  CostedTime := 0;
                  NotAvailableCosted := True;
                end;
              end
              else
                CostedTime := 0;
            end;

            UnitsStr := 'Sq ' + qGetData.FieldByName('UnitAbbreviation').value;
            LinearMultiplierPrice := 1;
            LinearMultiplierAllowance := 1;

            if (qGetData.FieldByName('MaterialType').value = 'S') or (qGetData.FieldByName('MaterialType').value = 'R') then
            begin
              if qGetData.FieldByName('LinearMatPrice').Value and not qGetData.FieldByName('LinearAllowance').Value then
              begin
                LinearMultiplierPrice := qGetData.FieldByName('SubUnitsPerUnit').value / qGetData.FieldByName('MatWidth').value;
                LinearMultiplierAllowance := 1;
              end
              else if not qGetData.FieldByName('LinearMatPrice').Value and qGetData.FieldByName('LinearAllowance').Value then
              begin
                LinearMultiplierPrice := 1;
                LinearMultiplierAllowance := qGetData.FieldByName('SubUnitsPerUnit').value / qGetData.FieldByName('MatWidth').value;
              end
              else if qGetData.FieldByName('LinearMatPrice').Value and qGetData.FieldByName('LinearAllowance').Value then
              begin
                LinearMultiplierPrice := qGetData.FieldByName('SubUnitsPerUnit').value / qGetData.FieldByName('MatWidth').value;
                LinearMultiplierAllowance := qGetData.FieldByName('SubUnitsPerUnit').value / qGetData.FieldByName('MatWidth').value;
              end;
            end;

            if qGetData.FieldByName('SLMAllowance').value then
            begin
              SampleSyntheticBasicAllowance := SampleBasicAllowance;
              CostedSyntheticBasicAllowance := CostedBasicAllowance;
            end;

            ToFeet := qGetData.FieldByName('ToFeet').value;
            SqftToUnits := 1 / (ToFeet * ToFeet);

            if (qGetData.FieldByName('MaterialType').value = 'S') or (qGetData.FieldByName('MaterialType').value = 'R') then
            begin
              SampleBasicAllowance := SampleSyntheticBasicAllowance;
              CostedBasicAllowance := CostedSyntheticBasicAllowance;
              SampleAdjustedAllowance := SampleSyntheticBasicAllowance;
              CostedAdjustedAllowance := CostedSyntheticBasicAllowance; 
            end;

            SampleMaterialCostPerPair := (SampleAdjustedAllowance / LinearMultiplierAllowance) * SqftToUnits * qGetData.FieldByName('StandardPrice').value * LinearMultiplierPrice;
            //CJY: If any individual MaterialCost failed show total = 0
            if not NotAvailableSampleMC1 then
              NotAvailableSampleMC1 := (SampleMaterialCostPerPair = 0);

            CostedMaterialCostPerPair := (CostedAdjustedAllowance / LinearMultiplierAllowance) * SqftToUnits * qGetData.FieldByName('StandardPrice').value * LinearMultiplierPrice;
            //CJY: If any individual MaterialCost failed show total = 0
            if not NotAvailableCostedMC1 then
              NotAvailableCostedMC1 := (CostedMaterialCostPerPair = 0);

            tblTempSample.Append;
            tblTempSample.FieldByName('Part').value := Part;
            tblTempSample.FieldByName('Size').value := qConPartsSampleSize.Value;
            tblTempSample.FieldByName('Width').value := PartWidthNo;
            tblTempSample.FieldByName('Material').value := qGetData.FieldByName('Material').value;
            tblTempSample.FieldByName('Unit').value := UnitsStr;
            tblTempSample.FieldByName('BasAlw').value := SampleBasicAllowance * SqftToUnits;
            tblTempSample.FieldByName('PrAlw').value := SampleAdjustedAllowance * SqftToUnits;
            tblTempSample.FieldByName('BPrAlw').value := SampleAdjustedAllowance * SqftToUnits * BatchSize;
            tblTempSample.FieldByName('PrMatCost').value := SampleMaterialCostPerPair;
            tblTempSample.FieldByName('BPrMatCost').value := SampleMaterialCostPerPair * BatchSize;
            tblTempSample.FieldByName('SMs').value := SampleTime;
            SampleTotalMaterialCostPerPair := round(SampleTotalMaterialCostPerPair + (SampleMaterialCostPerPair * 10000));
            SampleTotalMaterialCostPerBatchPairs := round(SampleTotalMaterialCostPerBatchPairs + (SampleMaterialCostPerPair * 10000 * BatchSize));
            SampleTotalTime := round(SampleTotalTime + (SampleTime * 10000));
            tblTempSample.Post;

            if qGetData.FieldByName('LinearAllowance').Value then
            begin
              tblTempSample.Append;
              tblTempSample.FieldByName('Size').value := qConPartsSampleSize.Value;
              Str(qGetData.FieldByName('MatWidth').Value: 6: 2, MatWidthStr);
              UnitsStr := '''' + qGetData.FieldByName('UnitAbbreviation').Value + ' x ' + MatWidthStr + ' ' + qGetData.FieldByName('SubUnitAbbreviation').Value + '''';
              tblTempSample.FieldByName('Unit').value := UnitsStr;
              tblTempSample.FieldByName('PrAlw').value := SampleAdjustedAllowance  * LinearMultiplierAllowance * SqftToUnits;
              tblTempSample.Post;
            end;

            if not SampleSameAsCosted then
            begin
              UnitsStr := 'Sq ' + qGetData.FieldByName('UnitAbbreviation').value;            
              tblTempSample.Append;
              tblTempSample.FieldByName('Part').value := Part;
              tblTempSample.FieldByName('Size').value := qConPartsCostedSize.Value;
              tblTempSample.FieldByName('Width').value := PartWidthNo;
              tblTempSample.FieldByName('Material').value := qGetData.FieldByName('Material').value;
              tblTempSample.FieldByName('Unit').value := UnitsStr;
              tblTempSample.FieldByName('BasAlw').value := CostedBasicAllowance * SqftToUnits;
              tblTempSample.FieldByName('PrAlw').value := CostedAdjustedAllowance * SqftToUnits;
              tblTempSample.FieldByName('BPrAlw').value := CostedAdjustedAllowance * SqftToUnits * BatchSize;
              tblTempSample.FieldByName('PrMatCost').value := CostedMaterialCostPerPair;
              tblTempSample.FieldByName('BPrMatCost').value := CostedMaterialCostPerPair * BatchSize;
              tblTempSample.FieldByName('SMs').value := CostedTime;
              CostedTotalMaterialCostPerPair := round(CostedTotalMaterialCostPerPair + (CostedMaterialCostPerPair * 10000));
              CostedTotalMaterialCostPerBatchPairs := round(CostedTotalMaterialCostPerBatchPairs + (CostedMaterialCostPerPair * 10000 * BatchSize));
              CostedTotalTime := round(CostedTotalTime + (CostedTime * 10000));
              tblTempSample.Post;

              if qGetData.FieldByName('LinearAllowance').Value then
              begin
                tblTempSample.Append;
                tblTempSample.FieldByName('Size').value := qConPartsCostedSize.Value;
                Str(qGetData.FieldByName('MatWidth').Value: 6: 2, MatWidthStr);
                UnitsStr := '''' + qGetData.FieldByName('UnitAbbreviation').Value + ' x ' + MatWidthStr + ' ' + qGetData.FieldByName('SubUnitAbbreviation').Value + '''';
                tblTempSample.FieldByName('Unit').value := UnitsStr;
                tblTempSample.FieldByName('PrAlw').value := CostedAdjustedAllowance  * LinearMultiplierAllowance * SqftToUnits;
                tblTempSample.Post;
              end;
            end;
            qGetData.close;
            qConParts.next;
          end;  //this is now the end of the latest if parterror then
        end;   //this is end of Sample Part Allowance error
      end;   //this is end of qConParts loop

      if not PartError then
      begin
        tblTempSampleTotals.Append;
        tblTempSampleTotals.FieldByName('Size').value := qConPartsSampleSize.Value;
        tblTempSampleTotals.FieldByName('Width').value := PartWidthNo;

        //CJY: If any individual MaterialCost failed show total = 0
        if not NotAvailableSampleMC1 then
          tblTempSampleTotals.FieldByName('PrMatCostTotal').value := SampleTotalMaterialCostPerPair / 10000
        else
          tblTempSampleTotals.FieldByName('PrMatCostTotal').value := 0;

        //CJY: If any individual MaterialCost failed show total = 0
        if not NotAvailableSampleMC1 then
          tblTempSampleTotals.FieldByName('BPrMatCostTotal').value := SampleTotalMaterialCostPerBatchPairs / 10000
        else
          tblTempSampleTotals.FieldByName('BPrMatCostTotal').value := 0;

        //CJY: If any individual time failed show time = 0
        if not NotAvailableSample then
          tblTempSampleTotals.FieldByName('SMsTotal').value := SampleTotalTime / 10000
        else
          tblTempSampleTotals.FieldByName('SMsTotal').value := 0;

        tblTempSampleTotals.Post;
        if not SampleSameAsCosted then
        begin
          tblTempCostedTotals.Append;
          tblTempCostedTotals.FieldByName('Size').value := qConPartsCostedSize.Value;
          tblTempCostedTotals.FieldByName('Width').value := PartWidthNo;

          //CJY: If any individual MaterialCost failed show total = 0
          if not NotAvailableCostedMC1 then
            tblTempCostedTotals.FieldByName('PrMatCostTotal').value := CostedTotalMaterialCostPerPair / 10000//;
          else
            tblTempCostedTotals.FieldByName('PrMatCostTotal').value := 0;

          //CJY: If any individual MaterialCost failed show total = 0
          if not NotAvailableCostedMC1 then
            tblTempCostedTotals.FieldByName('BPrMatCostTotal').value := CostedTotalMaterialCostPerBatchPairs / 10000//;
          else
            tblTempCostedTotals.FieldByName('BPrMatCostTotal').value := 0;

          //CJY: If any individual time failed show time = 0
          if not NotAvailableCosted then
            tblTempCostedTotals.FieldByName('SMsTotal').value := CostedTotalTime / 10000
          else
            tblTempCostedTotals.FieldByName('SMsTotal').value := 0;

          tblTempCostedTotals.Post;
        end;
      end;

      qCommonWidths.Next;
    end;  //this is the end to the qcommonwidths while

    if not PartError then
    begin
      tblTempSample.Open;
      tblTempCosted.Open;
      tblTempSampleTotals.Open;
      tblTempCostedTotals.Open;

      spKnivesForStyle.FetchOptions.Items := spKnivesForStyle.FetchOptions.Items - [fiMeta];
      spKnivesForStyle.Command.FillParams(spKnivesForStyle.Params);
      spKnivesForStyle.Prepare;
      spKnivesForStyle.ParamByName('Style').Value := Style;
      spKnivesForStyle.Open;
      tblKnifeSizeDetails.Tablename := '#TempKnifeSizes';
      tblKnifeSizeDetails.Open;
      tblPtWidAF.Open;
      tblPtWidKnf.Open;
      qMaterials.ParamByName('Style').Value := Style;
      qMaterials.Open;

      frWholeStyle.PrintOptions.PrintMode := pmScale;
      frWholeStyle.PrintOptions.PrintOnSheet := GetPaperSize;
      frWholeStyle.PrepareReport;
      frWholeStyle.PrintOptions.ShowDialog := True;//not GroupPrinting;

      if Preview then
      begin
        with frWholeStyle do
        begin
          ShowPreparedReport;
          if (((PreviewForm.Left + (PreviewForm.Width div 2)) > Application.MainForm.Width) or 
              (((PreviewForm.Left + (PreviewForm.Width div 2)) < 0))) then
            PreviewForm.Left := ((Application.MainForm.Width - PreviewForm.Width) div 2);
          if (((PreviewForm.Top + (PreviewForm.Height div 2)) > Application.MainForm.Height) or 
              (((PreviewForm.Top + (PreviewForm.Height div 2)) < 0))) then
            PreviewForm.Top := ((Application.MainForm.Height - PreviewForm.Height) div 2);
        end;
      end
      else
        frWholeStyle.Print;
    end;
  end
  else
  begin
    qConParts.Close;
    MessageDlgPos('No Parts for Style', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  end;

  DropTables;

  CreatingFullReport := False;
end;

procedure TdmTotalReport.qConPartsCalcFields(DataSet: TDataSet);
begin
  if qConPartsPressTypeLeather.value = 'S' then
    qConPartsPressTypeLeatherDesc.value := 'Swing Beam'
  else if qConPartsPressTypeLeather.value = 'P' then
    qConPartsPressTypeLeatherDesc.value := 'Push / Pull'
  else if qConPartsPressTypeLeather.value = 'T' then
    qConPartsPressTypeLeatherDesc.value := 'Travelling Head';

  if qConPartsPressTypeSynthetic.value = 'P' then
    qConPartsPressTypeSyntheticDesc.value := 'Push / Pull'
  else if qConPartsPressTypeSynthetic.value = 'T' then
    qConPartsPressTypeSyntheticDesc.value := 'Travelling Head';
end;

procedure TdmTotalReport.qMaterialsCalcFields(DataSet: TDataSet);
var
  temp: string;

begin
  if (qMaterialsType.value='L') or (qMaterialsType.value='K') or (qMaterialsType.value='W') then
  begin
    str(qMaterialsSkinSize.value : 7 : 3,temp);
    qMaterialsCalcSkinSize.value := temp;
    qMaterialsCalcQualCoeff.value := IntToStr(qMaterialsQualCoeff.value);
    qMaterialsCalcAreaCoeff.value := IntToStr(qMaterialsAreaCoeff.value);
    qMaterialsCalcDegDiff.value := IntToStr(qMaterialsDegDiff.value);
    qMaterialsCalcCutGap.value := '-';
    qMaterialsCalcLength.value := '-';
    qMaterialsCalcWidth.value := '-';
    qMaterialsCalcStrokeDepth.value := '-';
    qMaterialsCalcLinearPrice.value := '-';
    qMaterialsCalcLayers.value := '-';
    if (qMaterialsTrimmed.value) then
      qMaterialsCalcTrimmed.value := 'Yes'
    else
      qMaterialsCalcTrimmed.value := 'No';
  end
  else
  begin
    qMaterialsCalcSkinSize.value := '-';
    qMaterialsCalcQualCoeff.value := '-';
    qMaterialsCalcAreaCoeff.value := '-';
    qMaterialsCalcDegDiff.value := '-';
    qMaterialsCalcTrimmed.value := '-';
    qMaterialsCalcCutGap.value := IntToStr(qMaterialsCutGap.value);
    str(qMaterialsWidth.value : 7 : 3, temp);
    qMaterialsCalcWidth.value := temp;
    str(qMaterialsStrokeDepth.value : 7 : 3, temp);
    qMaterialsCalcStrokeDepth.value := temp;
    if (qMaterialsLinearMatPrice.value) then
      qMaterialsCalcLinearPrice.value := 'Lin'
    else
      qMaterialsCalcLinearPrice.value := 'Sq';
    qMaterialsCalcLayers.value := IntToStr(qMaterialsLayers.value);
    if (qMaterialsType.value = 'R') then
      qMaterialsCalcLength.value := '-'
    else
    begin
      str(qMaterialsLength.value : 7 : 3, temp);
      qMaterialsCalcLength.value := temp;
    end;
  end;
end;

procedure TdmTotalReport.tblPtWidAFCalcFields(DataSet: TDataSet);
var
  AdjFactor: real;

begin
  AdjFactor := dmAdjFact.PartAdjFactor(qConPartsPart.value, tblPtWidAFWidthNo.value);

  if qConPartsManualAdjFactor.value then
    tblPtWidAFActualAdjFactor.value := tblPtWidAFAdjFactor.value
  else
    tblPtWidAFActualAdjFactor.value := round(AdjFactor);
end;

procedure TdmTotalReport.tblPtWidKnfCalcFields(DataSet: TDataSet);
begin
  qAdjustedSize.ParamByName('PartCode').Value := tblPtWidKnfPart.Value;
  qAdjustedSize.ParamByName('WidthNo').Value := tblPtWidKnfWidthNo.Value;
  qAdjustedSize.ParamByName('KnifeCode').Value := tblPtWidKnfKnife.Value;
  qAdjustedSize.ParamByName('Size').Value := qConPartsSampleSize.Value;
  qAdjustedSize.Open;
  tblPtWidKnfRealSampleSize.Value := qAdjustedSizeAdjSize.Value;
  qAdjustedSize.Close;
  qAdjustedSize.ParamByName('Size').Value := qConPartsCostedSize.Value;
  qAdjustedSize.Open;
  tblPtWidKnfRealCostedSize.Value := qAdjustedSizeAdjSize.Value;
  qAdjustedSize.Close;
end;

procedure TdmTotalReport.DropTables;
begin
  tblTempSample.Close;
  tblTempCosted.Close;
  tblTempSampleTotals.Close;
  tblTempCostedTotals.Close;
  spKnivesForStyle.Close;
  tblKnifeSizeDetails.Close;
  tblPtWidAF.Close;
  tblPtWidKnf.Close;
  qMaterials.Close;
  qConParts.Close;
  qCommonWidths.Close;
  qGetData.Close;
  qCuttingTimes.Close;

  tblTempSample.Disconnect;
  tblTempCosted.Disconnect;
  tblTempSampleTotals.Disconnect;
  tblTempCostedTotals.Disconnect;
  tblKnifeSizeDetails.Disconnect;

  qDrops.ExecSQL;
end;

end.
