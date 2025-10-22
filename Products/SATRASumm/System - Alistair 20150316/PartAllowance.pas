unit PartAllowance;

interface

uses
  Windows, Classes, Controls, Forms, StdCtrls, ExtCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus,
  ComCtrls, CmnTypes, Times, Buttons, XStringGrid, XStringGridPlus,
  ToolWin, PartDetails, ActnList, frxClass, frxDBSet, Vcl.DBCtrls, Clipbrd,
  Vcl.DBGrids, frxReportPlus;

type
  TfmPartAllowance = class(TForm)
    pcAllowances: TPageControl;
    tsPartAllowance: TTabSheet;
    tsTimesBreakdown: TTabSheet;
    qGetData: TFDQueryPlus;
    qGetDataCode: TStringField;
    qGetDataStdBatchSize: TSmallintField;
    qGetDataMaterial: TStringField;
    qGetDataSampleSize: TStringField;
    qGetDataCostedSize: TStringField;
    qGetDataCostedAllowance: TFloatField;
    qGetDataRest: TFloatField;
    qGetDataContingency: TFloatField;
    qGetDataWidth: TStringField;
    qGetDataMatWidth: TFloatField;
    qGetDataMatLength: TFloatField;
    qGetDataStandardPrice: TCurrencyField;
    qGetDataToFeet: TFloatField;
    qGetDataSubUnitsPerUnit: TSmallintField;
    qGetDataUnitDescription: TStringField;
    qGetDataNo: TSmallintField;
    qUpdateCosted: TFDQueryPlus;
    tbMain: TPanel;
    qGetDataQualCoeff: TSmallintField;
    qGetDataAreaCoeff: TSmallintField;
    qGetDataUnits: TStringField;
    qGetDataArea: TFloatField;
    qGetDataLayers: TSmallintField;
    qGetDataWidthInches: TFloatField;
    qGetDataLengthInches: TFloatField;
    qGetDataCuttingMethodLeather: TStringField;
    qGetDataCoefficient: TIntegerField;
    qGetDataCuttingMethodSynthetic: TStringField;
    qGetDataFeedSystem: TStringField;
    qGetDataDepth: TFloatField;
    qGetDataMaxTableLength: TFloatField;
    qGetDataAASample: TFloatField;
    qGetDataAACosted: TFloatField;
    dbgCuttingTimes: TDBGridPlus;
    dsCuttingTimes: TDataSource;
    qGetDataUnitsPerJob: TSmallintField;
    qGetDataSizes: TSmallintField;
    qGetDataCuttingType: TStringField;
    qGetDataMaterialType: TStringField;
    qCuttingTimesSample: TFDQueryPlus;
    qCuttingTimesSampleSeq: TIntegerField;
    qCuttingTimesSampleCategory: TStringField;
    qCuttingTimesSampleElement: TStringField;
    qCuttingTimesSampleDescription: TStringField;
    qCuttingTimesSampleMinutes: TFloatField;
    qCuttingTimesCosted: TFDQueryPlus;
    IntegerField1: TIntegerField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    btnRefresh: TSpeedButton;
    btnAllCosts: TSpeedButton;
    qGetDataDegreeDifficulty: TSmallintField;
    qGetDataTrimmed: TBooleanField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    qTotalNettArea: TFDQueryPlus;
    qTotalNettAreaTotalNettArea: TFloatField;
    btnSetCostedAllowance: TSpeedButton;
    qGetDataAACostedSynth: TFloatField;
    qGetDataSLMAllowance: TBooleanField;
    tsSyntheticBreakdown: TTabSheet;
    sgAllowances: TXStringGridPlus;
    btnCopy: TSpeedButton;
    qGetDataMadeInPairs: TBooleanField;
    qGetDataLinearMatPrice: TBooleanField;
    qGetDataLinearAllowance: TBooleanField;
    qGetDataSubUnitAbbreviation: TStringField;
    frPartAllowance: TfrxReportPlus;
    frTimesBreakdown: TfrxReportPlus;
    frudsPartAllowance: TfrxUserDataSet;
    frdbTimes: TfrxDBDataset;
    qCuttingTimesCostedMinutes: TFloatField;
    qCuttingTimesSampleFreq: TFMTBCDField;
    qCuttingTimesCostedFreq: TFMTBCDField;
    qCuttingTimesSamplePer: TFMTBCDField;
    qCuttingTimesSampleBatchFreq: TFMTBCDField;
    qCuttingTimesSampleTime: TFloatField;
    qCuttingTimesCostedPer: TFMTBCDField;
    qCuttingTimesCostedBatchFreq: TFMTBCDField;
    qCuttingTimesCostedTime: TFloatField;
    qCuttingTimesSamplePerWhat: TStringField;
    qCuttingTimesCostedPerWhat: TStringField;
    pnlTimesSummary: TPanel;
    pnlBms: TPanel;
    lblSetupBms: TLabel;
    lblMaterialHandlingBms: TLabel;
    lblCuttingBms: TLabel;
    lblCutPartHandlingBms: TLabel;
    lblTotalBms: TLabel;
    lblTotalActualBms: TLabel;
    lblCutPartHandlingActualBms: TLabel;
    lblCuttingActualBms: TLabel;
    lblMaterialHandlingActualBms: TLabel;
    lblSetupActualBms: TLabel;
    pnlBmsHeader: TPanel;
    pnlTimesSummaryLeft: TPanel;
    pnlSizes: TPanel;
    rgSampleCosted: TRadioGroup;
    pnlSizesTitle: TPanel;
    pnlAms: TPanel;
    lblSetupAms: TLabel;
    lblMaterialHandlingAms: TLabel;
    lblCuttingAms: TLabel;
    lblCutPartHandlingAms: TLabel;
    lblTotalAms: TLabel;
    lblTotalActualAms: TLabel;
    lblCutPartHandlingActualAms: TLabel;
    lblCuttingActualAms: TLabel;
    lblMaterialHandlingActualAms: TLabel;
    lblSetupActualAms: TLabel;
    pnlAmsTitle: TPanel;
    btnSize: TButton;
    pnlSample: TPanel;
    pnlSampleTitle: TPanel;
    sgSample: TXStringGridPlus;
    pnlSampleHeaders: TPanel;
    pnlCosted: TPanel;
    pnlCostedTitle: TPanel;
    pnlCostedHeaders: TPanel;
    sgCosted: TXStringGridPlus;
    redtClipboard: TRichEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function PassPartNameWidth(PartAllowForm: TfmPartAllowance;
                               PartDetailForm: TfmPartDetails;
                               var Code: string;
                               WidthNo: short;
                               SampleSz, CostedSz: string;
                               SLMAllw, SuppressMessage: boolean): Boolean;
    procedure btnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAllCostsClick(Sender: TObject);
    function FourDPs(RealNum: Real): string;
    function OneDP(RealNum: Real): string;
    function TotalCuttingTimes(qCuttingTimes: TFDQueryPlus): real;
    procedure pcAllowancesChange(Sender: TObject);
    procedure rgSampleCostedClick(Sender: TObject);
    procedure GetTimes;
    procedure CuttingQueries;
    function Allowances(SuppressMessage: Boolean): Boolean;
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FinishSecondProcess(Sender: TObject);
    procedure EnableButtons;
    procedure btnSetCostedAllowanceClick(Sender: TObject);
    procedure sgAllowancesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure pcAllowancesDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure btnCopyClick(Sender: TObject);
    procedure frudsPartAllowanceGetValue(const VarName: string;
      var Value: Variant);
    procedure frPartAllowanceBeforePrint(Sender: TfrxReportComponent);
    procedure frPartAllowanceGetValue(const VarName: string;
      var Value: Variant);
    procedure frTimesBreakdownBeforePrint(Sender: TfrxReportComponent);
    procedure frTimesBreakdownGetValue(const VarName: string;
      var Value: Variant);
    procedure qCuttingTimesSampleCalcFields(DataSet: TDataSet);
    procedure qCuttingTimesCostedCalcFields(DataSet: TDataSet);
    procedure btnSizeClick(Sender: TObject);
  private
    { Private declarations }
    fmPartAllowance: TfmPartAllowance;
    fmPartDetails: TfmPartDetails;
    dmTimes: TdmTimes;
    PartCode, SampleSize, CostedSize: string;
    PartWidthNo: short;
    SampleAdjInterlocks, CostedAdjInterlocks: RealArray;
    SLMAllowance: boolean;
  public
    { Public declarations }
    SecondProcessInUse: Boolean;
  end;

implementation

uses
  SysUtils, Graphics, Dialogs, Summs, AllCosts, OutOfMemory, SummsThreads,
  SummsVars, AdjFact, BasicAlw, General, AdvErrorHandler;

{$R *.DFM}

var
  CostedAdjustedAllowance, SampleAdjustedAllowance: real;
  FullSynthetic: Boolean;

procedure TfmPartAllowance.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

function TfmPartAllowance.PassPartNameWidth(PartAllowForm: TfmPartAllowance;
                                            PartDetailForm: TfmPartDetails;
                                            var Code: string;
                                            WidthNo: short;
                                            SampleSz, CostedSz: string;
                                            SLMAllw, SuppressMessage: boolean): Boolean;
var
  Success: Boolean;

begin
  screen.cursor := crHourGlass;

  fmPartAllowance := PartAllowForm;
  fmPartDetails := PartDetailForm;
  PartCode := Code;
  PartWidthNo := WidthNo;
  SampleSize := SampleSz;
  CostedSize := CostedSz;

  //if leather then SLMAllw is ALWAYS true
  if (Option_LegacySynthetics) or (fmPartDetails.lblMaterialType.Caption = 'LEATHER') then
    SLMAllowance := SLMAllw
  else
    SLMAllowance := False;

  Success := Allowances(SuppressMessage);

  Application.ProcessMessages;
  screen.cursor := crDefault;

  if Success then
  begin
    if (not tsSyntheticBreakdown.TabVisible) and (not tsTimesbreakdown.TabVisible) then
    begin
      fmPartAllowance.ClientHeight := 243;
      fmPartAllowance.ClientWidth := 417;
    end;
  end;

  Result := Success;
end;

function TfmPartAllowance.FourDPs(RealNum: Real): String;
var
  s: string;

begin
  str(RealNum : 10 : 4, s);
  Result := s;
end;

function TfmPartAllowance.OneDP(RealNum: Real): String;
var
  s: string;

begin
  str(RealNum : 10 : 1, s);
  Result := s;
end;

procedure TfmPartAllowance.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  if (pcAllowances.ActivePage = tsPartAllowance) then
  begin
    frPartAllowance.ReportOptions.Name := 'Preview ' + Caption;
    ClosePreviewForm(Caption);

    frudsPartAllowance.RangeEnd := reCount;
    frudsPartAllowance.RangeEndCount := sgAllowances.RowCount;

    frPartAllowance.PrintOptions.PrintMode := pmScale;
    frPartAllowance.PrintOptions.PrintOnSheet := GetPaperSize;
    frPartAllowance.PrepareReport;

    if ((Sender as TSpeedButton) = btnPrintPreview) then
      frPartAllowance.ShowPreparedReport
    else
      frPartAllowance.Print;
  end
  else if (pcAllowances.ActivePage = tsTimesBreakdown) then
  begin
    frTimesBreakdown.ReportOptions.Name := 'Preview ' + Caption;
    ClosePreviewForm(Caption);

    if rgSampleCosted.ItemIndex = 0 then
      frdbTimes.DataSet := qCuttingTimesSample
    else
      frdbTimes.DataSet := qCuttingTimesCosted;

    MyBookmark := frdbTimes.DataSet.GetBookmark;
    frdbTimes.DataSet.DisableControls;

    frTimesBreakdown.PrintOptions.PrintMode := pmScale;
    frTimesBreakdown.PrintOptions.PrintOnSheet := GetPaperSize;
    frTimesBreakdown.PrepareReport;

    try
      frdbTimes.DataSet.GotoBookmark(MyBookmark);
    except
    end;
    frdbTimes.DataSet.EnableControls;
    frdbTimes.DataSet.FreeBookmark(MyBookmark);

    if ((Sender as TSpeedButton) = btnPrintPreview) then
      frTimesBreakdown.ShowPreparedReport
    else
      frTimesBreakdown.Print;
  end;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmPartAllowance.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  SecondProcessInUse := False;

  tsTimesBreakdown.TabVisible := false;
  Screen.cursor := crHourGlass;

  //Form is Invisible & Normal as a default so it can be
  //called invisibly. Overide here for normal instance.
  if Owner = fmSumms then
  begin
    FormStyle := fsMDIChild;
    Visible := True;
  end;

  //Main panel created as invisible to stop 'flashing'
  pcAllowances.Visible := True;
end;

procedure TfmPartAllowance.btnAllCostsClick(Sender: TObject);
var
  Failed: boolean;

begin
  application.ProcessMessages;
  Screen.cursor := crHourGlass;
  Failed := false;
  try
    fmAllCosts := TfmAllCosts.create(fmSumms);
    fmAllCosts.pnlTop.Visible := FullSynthetic;
  except
    fmMemoryError.TidyUp(self);
    Failed := true;
  end;

  if not Failed then
    fmAllCosts.PassPartCodeWidthNo(qGetDataCode.Value, qGetDataWidth.value, qGetDataSampleSize.Value, qGetDataNo.value, qGetDataToFeet.value);
end;

function TfmPartAllowance.TotalCuttingTimes(qCuttingTimes: TFDQueryPlus): real;
var
  i: integer;
  tBms, tAms: real;
  c, sBms, sAms: string;

begin
  qCuttingTimes.filtered := false;
  //CJY skipping first / last row and Filtered
  if qCuttingTimes.Active then
    qCuttingTimes.Refresh;
  qCuttingTimes.RecNo := 1; //CJY changed from qCuttingTimes.First
  qCuttingTimes.Prior; //CJY changed from qCuttingTimes.First
  for i := 1 to 5 do
  begin
    c := qCuttingTimes.FieldByname('Category').asString;
    tBms := qCuttingTimes.FieldByname('Time').value;
    str(tBms : 10 : 2, sBms);
    tAms := tBms  * ((100 + qGetDataRest.value) / 100) * ((100 + qGetDataContingency.value) / 100);
    str(tAms : 10 : 2, sAms);

    if c = 'S' then
    begin
      lblSetupActualBms.caption := sBms;
      lblSetupActualAms.caption := sAms;
    end
    else if c = 'M' then
    begin
      lblMaterialHandlingActualBms.caption := sBms;
      lblMaterialHandlingActualAms.caption := sAms;
    end
    else if c = 'C' then
    begin
      lblCuttingActualBms.caption := sBms;
      lblCuttingActualAms.caption := sAms;
    end
    else if c = 'P' then
    begin
      lblCutPartHandlingActualBms.caption := sBms;
      lblCutPartHandlingActualAms.caption := sAms;
    end
    else if c = 'T' then
    begin
      lblTotalActualBms.caption := sBms;
      lblTotalActualAms.caption := sAms;

      Result := tAms;
    end;

    qCuttingTimes.next;
  end;

  qCuttingTimes.filtered := true;
  //CJY skipping first / last row and Filtered
  if qCuttingTimes.Active then
    qCuttingTimes.Refresh;
end;

procedure TfmPartAllowance.pcAllowancesChange(Sender: TObject);
begin
  if pcAllowances.ActivePageIndex = 1 then
  begin
    //If we are here at least one of Sample/Costed times
    //must have been calculated but not necesarily both
    if (sgAllowances.Cells[1, 1] = 'Unavailable') then
    begin
      rgSampleCosted.ItemIndex := 1;
      rgSampleCosted.Enabled := False;
    end
    else if (sgAllowances.Cells[2, 1] = 'Unavailable') then
    begin
      rgSampleCosted.ItemIndex := 0;
      rgSampleCosted.Enabled := False;
    end
    else
      rgSampleCosted.Enabled := True;

    GetTimes;
  end;

  if pcAllowances.ActivePageIndex = 0 then
    btnCopy.Enabled := True
  else
    btnCopy.Enabled := False;

  if pcAllowances.ActivePageIndex = 2 then
  begin
    btnPrintPreview.Enabled := False;
    btnPrint.Enabled := False;
  end
  else
  begin
    btnPrintPreview.Enabled := True;
    btnPrint.Enabled := True;
  end;
end;

procedure TfmPartAllowance.rgSampleCostedClick(Sender: TObject);
begin
  GetTimes;
end;

procedure TfmPartAllowance.GetTimes;
begin
  if rgSampleCosted.ItemIndex = 0 then
    dsCuttingTimes.dataSet := qCuttingTimesSample
  else
    dsCuttingTimes.dataSet := qCuttingTimesCosted;
  TotalCuttingTimes(dsCuttingTimes.dataSet as TFDQueryPlus);
end;

procedure TfmPartAllowance.CuttingQueries;
var
  CuttingTimesAvailable: Boolean;

begin
  CuttingTimesAvailable := False;

  if not(sgAllowances.Cells[1, 1] = 'Unavailable') then
  begin
    dmTimes.CalculateTime(TRUE, qGetData, qCuttingTimesSample, SampleAdjInterlocks);
    sgAllowances.Cells[1, sgAllowances.RowCount - 1] := FourDps(TotalCuttingTimes(qCuttingTimesSample));
    CuttingTimesAvailable := True;
  end;

  if not(sgAllowances.Cells[2, 1] = 'Unavailable') then
  begin
    dmTimes.CalculateTime(FALSE, qGetData, qCuttingTimesCosted, CostedAdjInterlocks);
    sgAllowances.Cells[2, sgAllowances.RowCount - 1] := FourDps(TotalCuttingTimes(qCuttingTimesCosted));
    CuttingTimesAvailable := True;
  end;

  if CuttingTimesAvailable then
  begin
    tsTimesBreakdown.TabVisible := true;
    fmPartAllowance.ClientHeight := 391;
    fmPartAllowance.ClientWidth := 813;
  end;
end;

function TfmPartAllowance.Allowances(SuppressMessage: Boolean): Boolean;
var
  i, AdjFactor, DefaultBatchSize, PairMultiplier, RowAdd: integer;
  CostedBasicAllowance, SampleBasicAllowance, SubUnitsToFeet, SqftToUnits, WidthInFeet, SheetAreaInSqft,
  LinearMultiplierPrice, LinearMultiplierAllowance: real;
  Allowance: AllowanceResult;
  Error, ItemPair, MatWidthStr, UnitsStr, UnitsStr2: string;
  SecondProcess: PartAllowanceThread;
  TotalNettArea: Real;
  SampleNormalInterlockWaste, SampleNormalOtherWaste: Real;
  SampleSyntheticInterlockWaste, SampleSyntheticOtherWaste: Real;
  CostedNormalInterlockWaste, CostedNormalOtherWaste: Real;
  CostedSyntheticInterlockWaste, CostedSyntheticOtherWaste: Real;
  CostedSyntheticBasicAllowance, SampleSyntheticBasicAllowance: Real;
  SampleAllowance, CostedAllowance: Real;
  SampleInterlockWaste, SampleOtherWaste: Real;
  CostedInterlockWaste, CostedOtherWaste: Real;
  Quit: Boolean;

begin
  Quit := False;

  screen.cursor := crHourGlass;
  btnRefresh.enabled := FALSE;
  btnPrintPreview.enabled := FALSE;
  btnPrint.enabled := FALSE;
  btnAllCosts.enabled := FALSE;
  btnSetCostedAllowance.Enabled := FALSE;

  tsSyntheticBreakdown.Tabvisible := FALSE;
  tsTimesBreakdown.TabVisible := FALSE;

  if qTotalNettArea.active then
    qTotalNettArea.close;
  qTotalNettArea.ParamByName('PartCode').AsString := PartCode;
  qTotalNettArea.ParamByName('WidthNo').AsInteger := PartWidthNo;
  qTotalNettArea.Open;
  TotalNettArea := qTotalNettAreaTotalNettArea.value;

  //Sample
  Allowance := dmBasAll.AllowanceSingle(PartCode, '', SampleSize, CostedSize, PartWidthNo, TRUE, SLMAllowance);
  Error := Allowance.Error;
  if Error <> '' then
  begin
    screen.cursor := crDefault;
    Error := 'Cannot calculate allowance - ' + #13 + #13 + Error;
    if not SuppressMessage then
      messageDlg(Error, mtInformation, [mbOk], 0);
    close;
    Quit := True;
  end;

  if not Quit then
  begin
    SampleAdjInterlocks := Allowance.AdjInterlocks;
    SampleBasicAllowance := Allowance.BasicAllowance;
    SampleAdjustedAllowance := Allowance.AdjustedAllowance;
    SampleSyntheticBasicAllowance := Allowance.SampleSyntheticBasicAllowance;
    PairMultiplier := Allowance.PairMultiplier;
    if SampleSyntheticBasicAllowance > 0 then
    begin
  //    SampleNormalInterlockWaste := (((Allowance.TotalInterlockArea * 2) - (Allowance.TotalNettArea * 2)) / SampleAdjustedAllowance) * 100;
  //    SampleNormalOtherWaste := ((SampleAdjustedAllowance - (Allowance.TotalInterlockArea * 2)) / SampleAdjustedAllowance) * 100;
      SampleNormalInterlockWaste := 0;
      SampleNormalOtherWaste := 0;
      SampleSyntheticInterlockWaste := (((Allowance.TotalInterlockArea * PairMultiplier) - (Allowance.TotalNettArea * PairMultiplier)) / SampleSyntheticBasicAllowance) * 100;
      SampleSyntheticOtherWaste := ((SampleSyntheticBasicAllowance - (Allowance.TotalInterlockArea * PairMultiplier)) / SampleSyntheticBasicAllowance) * 100;
    end
    else if SampleAdjustedAllowance > 0 then
    begin
  //    SampleNormalInterlockWaste := 0;
  //    SampleNormalOtherWaste := 0;
      SampleNormalInterlockWaste := (((Allowance.TotalInterlockArea * PairMultiplier) - (Allowance.TotalNettArea * PairMultiplier)) / SampleAdjustedAllowance) * 100;
      SampleNormalOtherWaste := ((SampleAdjustedAllowance - (Allowance.TotalInterlockArea * PairMultiplier)) / SampleAdjustedAllowance) * 100;
      SampleSyntheticInterlockWaste := 0;
      SampleSyntheticOtherWaste := 0;
    end
    else
    begin
      SampleNormalInterlockWaste := -1;
      SampleNormalOtherWaste := -1;
      SampleSyntheticInterlockWaste := -1;
      SampleSyntheticOtherWaste := -1;
    end;

    //Costed
    Allowance := dmBasAll.AllowanceSingle(PartCode, '', SampleSize, CostedSize, PartWidthNo, FALSE, SLMAllowance);
    Error := Allowance.Error;
    if Error <> '' then
    begin
      screen.cursor := crDefault;
      Error := 'Cannot calculate allowance - ' + #13 + Error;
      if not SuppressMessage then
        messageDlg(Error, mtInformation, [mbOk], 0);
      close;
      Quit := True;
    end;

    if not Quit then
    begin
      CostedAdjInterlocks := Allowance.AdjInterlocks;
      CostedBasicAllowance := Allowance.BasicAllowance;
      CostedAdjustedAllowance := Allowance.AdjustedAllowance;
      CostedSyntheticBasicAllowance := Allowance.CostedSyntheticBasicAllowance;
      CostedNormalInterlockWaste := SampleNormalInterlockWaste;
      CostedNormalOtherWaste := SampleNormalOtherWaste;
      CostedSyntheticInterlockWaste := SampleSyntheticInterlockWaste;
      CostedSyntheticOtherWaste := SampleSyntheticOtherWaste;
      PairMultiplier := Allowance.PairMultiplier;

      if Option_CuttingTimes then
        AdjFactor := dmAdjFact.PartAdjFactor(PartCode, PartWidthNo)
      else
        Adjfactor := 0;

      if qGetData.active then
        qGetData.close;

      qGetData.ParamByName('PartCode').AsString := PartCode;
      qGetData.ParamByName('WidthNo').AsInteger := PartWidthNo;
      //Following Parameters are for Cutting Times
      qGetData.ParamByName('AdjFactor').AsInteger := AdjFactor;
      qGetData.ParamByName('SampleAdjustedAllowance').AsFloat := SampleAdjustedAllowance;
      qGetData.ParamByName('CostedAdjustedAllowance').AsFloat := CostedAdjustedAllowance;
      qGetData.ParamByName('SampleSyntheticBasicAllowance').AsFloat := SampleSyntheticBasicAllowance;
      qGetData.ParamByName('CostedSyntheticBasicAllowance').AsFloat := CostedSyntheticBasicAllowance;
      qGetData.Open;

      //Type of Allowance
      if Option_LegacySynthetics then
        FullSynthetic := not ((qGetDataMaterialType.value[1] in Leathers) or
                              ((qGetDataMaterialType.value[1] in Synthetics) and
                              qGetDataSLMAllowance.value))
      else
        FullSynthetic := (qGetDataMaterialType.value[1] in Synthetics);

      tsSyntheticBreakdown.Tabvisible := FullSynthetic;

      //Choose allowance to use
      if not FullSynthetic then
      begin
        SampleAllowance := SampleAdjustedAllowance;
        CostedAllowance := CostedAdjustedAllowance;

        SampleInterlockWaste := SampleNormalInterlockWaste;
        SampleOtherWaste := SampleNormalOtherWaste;
        CostedInterlockWaste := SampleNormalInterlockWaste;
        CostedOtherWaste := SampleNormalOtherWaste;
      end
      else
      begin
        SampleAllowance := SampleSyntheticBasicAllowance;
        CostedAllowance := CostedSyntheticBasicAllowance;

        SampleInterlockWaste := SampleSyntheticInterlockWaste;
        SampleOtherWaste := SampleSyntheticOtherWaste;
        CostedInterlockWaste := SampleSyntheticInterlockWaste;
        CostedOtherWaste := SampleSyntheticOtherWaste;
      end;

      sgAllowances.RowCount := 4;
      if (not((qGetDataMaterialType.value[1] = 'S') or (qGetDataMaterialType.value[1] = 'R'))) or (not Option_FullSynthetics) then
        sgAllowances.ColCount := 3;

      DefaultBatchSize := qGetDataStdBatchSize.value;
      Caption := 'Allowance for Part : ' + PartCode + ' (' + qGetDataWidth.value + ')';

      if SLMAllowance and (qGetDataMaterialType.value[1] in Synthetics) then
        Caption := Caption + '  [Legacy]';

      SubUnitsToFeet := qGetDataToFeet.value / qGetDataSubUnitsPerUnit.value;
      SqftToUnits := 1 / (qGetDataToFeet.value * qGetDataToFeet.value);

      if PairMultiplier = 2 then
        ItemPair := 'Pair'
      else
        ItemPair := 'Item';

      UnitsStr := 'Square ' + qGetDataUnitDescription.value;
      LinearMultiplierPrice := 1;
      LinearMultiplierAllowance := 1;
      if ((qGetDataMaterialType.value[1] = 'S') or (qGetDataMaterialType.value[1] = 'R')) then
      begin
        if qGetDataLinearMatPrice.Value and not qGetDataLinearAllowance.Value then
        begin
          LinearMultiplierPrice := qGetDataSubUnitsPerUnit.value / qGetDataMatWidth.value;
          LinearMultiplierAllowance := 1;
        end
        else if not qGetDataLinearMatPrice.Value and qGetDataLinearAllowance.Value then
        begin
          LinearMultiplierPrice := 1;
          LinearMultiplierAllowance := qGetDataSubUnitsPerUnit.value / qGetDataMatWidth.value;
        end
        else if qGetDataLinearMatPrice.Value and qGetDataLinearAllowance.Value then
        begin
          LinearMultiplierPrice := qGetDataSubUnitsPerUnit.value / qGetDataMatWidth.value;
          LinearMultiplierAllowance := qGetDataSubUnitsPerUnit.value / qGetDataMatWidth.value;
        end
        else
        begin
          LinearMultiplierPrice := 1;
          LinearMultiplierAllowance := 1;
        end;

        if qGetDataLinearAllowance.Value then
        begin
           Str(qGetData.FieldByName('MatWidth').Value: 6: 2, MatWidthStr);
           UnitsStr2 := '''' + qGetDataUnitDescription.value + ' x ' + MatWidthStr + ' ' + qGetData.FieldByName('SubUnitAbbreviation').Value + '''';
           sgAllowances.RowCount := 5;
           RowAdd := 1;
           sgAllowances.Cells[0, 3] := UnitsStr2 + ' per ' + ItemPair + ' ';
        end
        else
           RowAdd := 0;
      end;

      //Synthetic Breakdown
      if FullSynthetic then
      begin
        sgSample.RowCount := Length(Allowance.SampleSynths) + 1;
        pnlSample.Visible := (SampleAllowance <> 0);
        for i := 0 to Length(Allowance.SampleSynths) - 1 do
        begin
          sgSample.Cells[0, i + 1] := Allowance.SampleKnives[i];
          sgSample.Cells[1, i + 1] := FourDPs(Allowance.SampleSynths[i] * fmPartDetails.MaterialUnitConversion);
          sgSample.Cells[2, i + 1] := FourDPs(Allowance.SampleSynths[i] * fmPartDetails.MaterialUnitConversion * qGetDataStdBatchSize.value);
        end;

        sgCosted.RowCount := Length(Allowance.CostedSynths) + 1;
        pnlCosted.Visible := (CostedAllowance <> 0);
        for i := 0 to Length(Allowance.CostedSynths) - 1 do
        begin
          sgCosted.Cells[0, i + 1] := Allowance.CostedKnives[i];
          sgCosted.Cells[1, i + 1] := FourDPs(Allowance.CostedSynths[i] * fmPartDetails.MaterialUnitConversion);
          sgCosted.Cells[2, i + 1] := FourDPs(Allowance.CostedSynths[i] * fmPartDetails.MaterialUnitConversion * qGetDataStdBatchSize.value);
        end;
      end;

      sgAllowances.Cells[1, 0] := 'Sample (Size ' + qGetDataSampleSize.value + ')';
      sgAllowances.Cells[2, 0] := 'Costed (Size ' + qGetDataCostedSize.value + ')';
      rgSampleCosted.Items[0] := 'Sample (Size ' + qGetDataSampleSize.value + ')';
      rgSampleCosted.Items[1] := 'Costed (Size ' + qGetDataCostedSize.value + ')';

      sgAllowances.Cells[0, 1] := UnitsStr + ' per ' + ItemPair + ' ';
      sgAllowances.Cells[0, 2] := UnitsStr + ' per ' + inttostr(DefaultBatchSize) + ' ' + ItemPair + 's';
      pnlSampleHeaders.Caption := 'Sample (' + UnitsStr + ')';
      sgSample.Cells[1, 0] := 'Per ' + ItemPair;
      sgSample.Cells[2, 0] := 'Per ' + inttostr(DefaultBatchSize) +  ' ' +ItemPair + 's';
      pnlCostedHeaders.Caption := 'Costed (' + UnitsStr + ')';
      sgCosted.Cells[1, 0] := 'Per ' + ItemPair;
      sgCosted.Cells[2, 0] := 'Per ' + inttostr(DefaultBatchSize) + ' ' + ItemPair + 's';

      if SampleAllowance > 0 then
      begin
        sgAllowances.Cells[1, 1] := FourDPs(SampleAllowance * SqftToUnits);
        sgAllowances.Cells[1, 2] := FourDPs(DefaultBatchSize * SampleAllowance * SqftToUnits);
        if qGetDataLinearAllowance.Value then
          sgAllowances.Cells[1, 3] := FourDPs(SampleAllowance * SqftToUnits * LinearMultiplierAllowance);
      end
      else
        sgAllowances.Cells[1, 1] := 'Unavailable';

      if CostedAllowance > 0 then
      begin
        sgAllowances.Cells[2, 1] := FourDPs(CostedAllowance * SqftToUnits);
        sgAllowances.Cells[2, 2] := FourDPs(DefaultBatchSize * CostedAllowance * SqftToUnits);
        if qGetDataLinearAllowance.Value then
          sgAllowances.Cells[2, 3] := FourDPs(CostedAllowance * SqftToUnits * LinearMultiplierAllowance);
      end
      else
        sgAllowances.Cells[2, 1] := 'Unavailable';

      if (qGetDataMaterialType.value[1] in Leathers) then
      begin
        sgAllowances.Cells[0, 3] := 'Basic Allowance (' + UnitsStr + ')';
        sgAllowances.Cells[1, 3] := FourDPs(SampleBasicAllowance * SqftToUnits);
        sgAllowances.Cells[2, 3] := FourDPs(CostedBasicAllowance * SqftToUnits)
      end
      else if (qGetDataMaterialType.value[1] = 'S') then
      begin
        sgAllowances.Cells[0, 3 + RowAdd] := 'Sheets per ' + inttostr(DefaultBatchSize) + ' ' + ItemPair + 's' ;
        SheetAreaInSqft := (qGetDataMatLength.value * SubUnitsToFeet) * (qGetDataMatWidth.value * SubUnitsToFeet);

        if SampleAllowance > 0 then
          sgAllowances.Cells[1, 3 + RowAdd] := FourDPs((SampleAllowance * DefaultBatchSize) / SheetAreaInSqft);
        if CostedAllowance > 0 then
          sgAllowances.Cells[2, 3 + RowAdd] := FourDPs((CostedAllowance * DefaultBatchSize) / SheetAreaInSqft);

        sgAllowances.RowCount := sgAllowances.RowCount + 1;
        sgAllowances.Cells[0, sgAllowances.RowCount - 1] := ItemPair + 's per Sheet';

        if SampleAllowance > 0 then
          sgAllowances.Cells[1, sgAllowances.RowCount - 1] := FourDPs(SheetAreaInSqft / SampleAllowance);
        if CostedAllowance > 0 then
          sgAllowances.Cells[2, sgAllowances.RowCount - 1] := FourDPs(SheetAreaInSqft / CostedAllowance);
      end;

      if (qGetDataMaterialType.value[1] = 'R') then
        sgAllowances.RowCount := sgAllowances.RowCount - 1;

      if ShowWaste and not FullSynthetic then     //Don't show waste if layplanned allowance - might use parallelogram stuff
      begin                                       //to allow this.
        sgAllowances.RowCount := sgAllowances.RowCount + 3;
        sgAllowances.Cells[0, sgAllowances.RowCount - 3] := 'Waste (Efficiency) - Interlock (%)';
        sgAllowances.Cells[0, sgAllowances.RowCount - 2] := 'Waste (Efficiency) - Other (%)';
        sgAllowances.Cells[0, sgAllowances.RowCount - 1] := 'Waste (Efficiency) - Total (%)';

        if SampleAllowance > 0 then
        begin
          sgAllowances.Cells[1, sgAllowances.RowCount - 3] := OneDP(SampleInterlockWaste) + ' (' + Trim(OneDP(100 - SampleInterlockWaste)) + ')';
          sgAllowances.Cells[1, sgAllowances.RowCount - 2] := OneDP(SampleOtherWaste) + ' (' + Trim(OneDP(100 - SampleOtherWaste)) + ')';
          sgAllowances.Cells[1, sgAllowances.RowCount - 1] := OneDP(SampleInterlockWaste + SampleOtherWaste) + ' (' + Trim(OneDP(100 - (SampleInterlockWaste + SampleOtherWaste))) + ')';
        end;

        if (SampleSize = CostedSize) then
        begin
          if CostedAllowance > 0 then
          begin
            sgAllowances.Cells[2, sgAllowances.RowCount - 3] := OneDP(CostedInterlockWaste) + ' (' + Trim(OneDP(100 - CostedInterlockWaste)) + ')';
            sgAllowances.Cells[2, sgAllowances.RowCount - 2] := OneDP(CostedOtherWaste) + ' (' + Trim(OneDP(100 - CostedOtherWaste)) + ')';
            sgAllowances.Cells[2, sgAllowances.RowCount - 1] := OneDP(CostedInterlockWaste + CostedOtherWaste) + ' (' + Trim(OneDP(100 - (CostedInterlockWaste + CostedOtherWaste))) + ')';
          end;
        end
        else
        begin
          sgAllowances.Cells[2, sgAllowances.RowCount - 3] := '-';
          sgAllowances.Cells[2, sgAllowances.RowCount - 2] := '-';
          sgAllowances.Cells[2, sgAllowances.RowCount - 1] := '-';
        end;
      end;

      sgAllowances.RowCount := sgAllowances.RowCount + 1;
      sgAllowances.Cells[0, sgAllowances.RowCount - 1] := 'Material Cost per ' + inttostr(DefaultBatchSize) + ' ' + ItemPair + 's';

      if SampleAllowance > 0 then
        sgAllowances.Cells[1, sgAllowances.RowCount - 1] := FourDPs(DefaultBatchSize * SampleAllowance * SqftToUnits * qGetDataStandardPrice.value * LinearMultiplierPrice);
      if CostedAllowance > 0 then
        sgAllowances.Cells[2, sgAllowances.RowCount - 1] := FourDPs(DefaultBatchSize * CostedAllowance * SqftToUnits * qGetDataStandardPrice.value * LinearMultiplierPrice);

      if Option_CuttingTimes then
      begin
        sgAllowances.RowCount := sgAllowances.RowCount + 1;
        sgAllowances.Cells[0, sgAllowances.RowCount - 1] := 'Cutting Time per ' + inttostr(DefaultBatchSize) + ' ' + ItemPair + 's';

        //Start Thread to calculate Cutting Times
        if not SecondProcessInUse then
        begin
          SecondProcessInUse := True;
          SecondProcess := PartAllowanceThread.Create(true);
          SecondProcess.FreeOnTerminate := True;
          SecondProcess.OnTerminate := FinishSecondProcess;
          SecondProcess.PassDetails(fmPartAllowance);
          SecondProcess.resume;
        end;
      end;

      pcAllowances.ActivePageIndex := 0;
      btnCopy.Enabled := True;

      if not SecondProcessInUse then
        EnableButtons;
    end;
  end;

  Result := not Quit;
end;

procedure TfmPartAllowance.btnRefreshClick(Sender: TObject);
begin
  btnSetCostedAllowance.Enabled := False;
  Allowances(False);
end;

procedure TfmPartAllowance.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not SecondProcessInUse;

  if SecondProcessInUse then
    messagedlg('Cannot close whilst loading', mtInformation, [mbOk], 0);
end;

procedure TfmPartAllowance.FinishSecondProcess(Sender: TObject);
begin
  SecondProcessInUse := False;
  EnableButtons;
end;

procedure TfmPartAllowance.EnableButtons;
begin
  btnRefresh.enabled := TRUE;
  btnPrintPreview.enabled := TRUE;
  btnPrint.enabled := TRUE;
  btnAllCosts.enabled := TRUE;
  btnSetCostedAllowance.Enabled := True;
  screen.cursor := crDefault;
end;

procedure TfmPartAllowance.btnSetCostedAllowanceClick(Sender: TObject);
var
  CA: Double;
  errList: TStringList;
  EMessage: string;
  SQLCode, NativeCode: integer;

begin
  if sgAllowances.Cells[2, 1] = 'Unavailable' then
    messagedlg('Costed allowance is unavailable', mtInformation, [mbOk], 0)
  else
  begin
    qUpdateCosted.ParamByName('PartCode').AsString := PartCode;
    CA := StrToFloat(sgAllowances.Cells[2, 1]);
    qUpdateCosted.ParamByName('CostedAlw').AsFloat := CA;
    qUpdateCosted.ParamByName('CostedWid').AsFloat := PartWidthNo;
    screen.Cursor := crHourGlass;

    try
    begin
      qUpdateCosted.ExecSQL;
      try
        fmPartDetails.tblParts.refresh;
      except
      end;
    end;
    except
      on E: EFDDBEngineException do
      begin
        screen.Cursor := crDefault;

        errList := TStringList.Create();
        errList := fmErrorHandler.ErrRegMatch((E as EFDDBEngineException).Message);

        EMessage := errList.Values['Message'];
        SQLCode := strToInt(errList.Values['SQLErrorCode']);
        NativeCode := strToInt(errList.Values['NativeErrorCode']);
        errList.Free;

        if (SQLCode = 7200) and (NativeCode = 5035) then
          fmErrorHandler.DebugMessageDlg('Part locked - Cannot set Costed Allowance', E.Message, qUpdateCosted.Text);
      end
      else
        Raise;
    end;

    screen.Cursor := crDefault;
  end;
end;

procedure TfmPartAllowance.btnSizeClick(Sender: TObject);
begin
  showmessage(inttostr(fmPartAllowance.ClientHeight) + ' - ' + inttostr(fmPartAllowance.ClientWidth));
end;

procedure TfmPartAllowance.sgAllowancesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow = 0 then
    CanSelect := False;
end;

procedure TfmPartAllowance.pcAllowancesDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

procedure TfmPartAllowance.qCuttingTimesCostedCalcFields(DataSet: TDataSet);
begin
  (DataSet as TFDQueryPlus).FieldByName('PerWhat').Value := 'Shoe(s)';
end;

procedure TfmPartAllowance.qCuttingTimesSampleCalcFields(DataSet: TDataSet);
begin
  (DataSet as TFDQueryPlus).FieldByName('PerWhat').Value := 'Shoe(s)';
end;

procedure TfmPartAllowance.btnCopyClick(Sender: TObject);
const
  TAB = #9;
  LF = #10;
var
  r, c: integer;
  s: string;

begin
  if pcAllowances.ActivePage = tsPartAllowance then
  begin
    s := '';
    for r := 1 to sgAllowances.RowCount - 1 do
    begin
      for c := 1 to sgAllowances.ColCount - 1 do
      begin
        s := s + sgAllowances.Cells[c, r];
        if c < sgAllowances.ColCount - 1 then
          s := s + TAB;
      end;
      s := s + LF;
    end;

    //Copying s straight to clipboard loses
    //formatting so copy to TRichEdit first.
    //Also TRichEdit must be visible.
    redtClipboard.Visible := True;
    redtClipboard.Text := s;
    redtClipboard.Visible := False;
    Clipboard.AsText := redtClipboard.Text;
  end;
end;

procedure TfmPartAllowance.frPartAllowanceBeforePrint(Sender: TfrxReportComponent);
begin
  frPartAllowance.PreviewOptions.AllowEdit := False;
  frPartAllowance.PreviewOptions.Buttons := frPartAllowance.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frPartAllowance.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frPartAllowance.PreviewOptions.ZoomMode := zmDefault
  else
    frPartAllowance.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmPartAllowance.frPartAllowanceGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
    Value := 'Allowance for Part : ' + qGetDataCode.Value
  else if (VarName = 'Width') then
    Value := qGetDataWidth.Value
  else if (VarName = 'Sample') then
    Value := sgAllowances.Cells[1,0]
  else if (VarName = 'Costed') then
    Value := sgAllowances.Cells[2,0];
end;

procedure TfmPartAllowance.frudsPartAllowanceGetValue(const VarName: string;
  var Value: Variant);
begin
  if (frudsPartAllowance.RecNo = 0) then
    frudsPartAllowance.Next;
  if VarName = 'RowTitle' then
    Value := sgAllowances.Cells[0, frudsPartAllowance.RecNo]
  else if VarName = 'Sample' then
    Value := sgAllowances.Cells[1, frudsPartAllowance.RecNo]
  else if VarName = 'Costed' then
    Value := sgAllowances.Cells[2, frudsPartAllowance.RecNo];
end;

procedure TfmPartAllowance.frTimesBreakdownBeforePrint(Sender: TfrxReportComponent);
begin
  frTimesBreakdown.PreviewOptions.AllowEdit := False;
  frTimesBreakdown.PreviewOptions.Buttons := frTimesBreakdown.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frTimesBreakdown.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frTimesBreakdown.PreviewOptions.ZoomMode := zmDefault
  else
    frTimesBreakdown.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmPartAllowance.frTimesBreakdownGetValue(const VarName: string;
  var Value: Variant);
var
  EndTitle: string;

begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
  begin
    if rgSampleCosted.ItemIndex = 0 then
      EndTitle := ' (Sample Size ' + qGetDataSampleSize.value + ')'
    else
      EndTitle := ' (Costed Size ' + qGetDataCostedSize.value + ')';

    Value := 'Times Breakdown for Part : ' + qGetDataCode.value + EndTitle;
  end
  else if (VarName = 'Width') then
    Value := qGetDataWidth.Value
  else if (VarName = 'BmsSetup') then
    Value := lblSetupActualBms.Caption
  else if (VarName = 'BmsMatHand') then
    Value := lblMaterialHandlingActualBms.Caption
  else if (VarName = 'BmsCutting') then
    Value := lblCuttingActualBms.Caption
  else if (VarName = 'BmsCPH') then
    Value := lblCutPartHandlingActualBms.Caption
  else if (VarName = 'Bms') then
    Value := lblTotalActualBms.Caption
  else if (VarName = 'AmsSetup') then
    Value := lblSetupActualAms.Caption
  else if (VarName = 'AmsMatHand') then
    Value := lblMaterialHandlingActualAms.Caption
  else if (VarName = 'AmsCutting') then
    Value := lblCuttingActualAms.Caption
  else if (VarName = 'AmsCPH') then
    Value := lblCutPartHandlingActualAms.Caption
  else if (VarName = 'Ams') then
    Value := lblTotalActualAms.Caption;
end;

end.



