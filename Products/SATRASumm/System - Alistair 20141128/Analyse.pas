unit Analyse;

interface
                                                                                                                       
uses
  Classes, Controls, Forms, StdCtrls, Types, Grids, DBGridPlus, ComCtrls, Db, 
   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
   FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
   FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus,
   FDTablePlus, Spin, ExtCtrls, Buttons, XStringGrid, XStringGridPlus, ToolWin,
  PBNumEdit, PBSuperSpin, frxClass, frxDBSet, Vcl.DBGrids, frxReportPlus;

type
  UnitsRec = record
               Code:string;
               Conversion:real
             end;
type
  TfmAnalyse = class(TForm)
    dsqTicketTickets: TDataSource;
    qAnalyseTickets: TFDQueryPlus;
    qCutterLocations: TFDQueryPlus;
    qCutterLocationsCutterLocation: TStringField;
    qMaterialTypes: TFDQueryPlus;
    qMaterialTypesMaterialType: TStringField;
    qAnalyseTicketsCutter: TStringField;
    qAnalyseTicketsMaterialCode: TStringField;
    qAnalyseTicketsPartCode: TStringField;
    qAnalyseTicketsCutWeek: TSmallintField;
    qAnalyseTicketsTicketNumber: TStringField;
    qAnalyseTicketsAllowanceToUse: TFloatField;
    qAnalyseTicketssqUnits: TStringField;
    qAnalyseTicketsActualUsage: TFloatField;
    qAnalyseTicketsActualVar: TFloatField;
    qAnalyseTicketsPercVar: TFloatField;
    qAnalyseTicketsLossGain: TFloatField;
    qAnalyseTicketsUsedMoney: TFloatField;
    qAnalyseTicketsSMVs: TFloatField;
    qAnalyseTicketsTotalAllowance: TFloatField;
    qAnalyseTicketsTotalActualVar: TFloatField;
    qAnalyseTicketsTotalActualUsage: TFloatField;
    qAnalyseTicketsTotalLossGain: TFloatField;
    qAnalyseTicketsTotalCost: TFloatField;
    qAnalyseTicketsTotalTime: TFloatField;
    qAnalyseTicketsTotalPercVariance: TFloatField;
    qAnalyseTicketsTotalTotalPairs: TIntegerField;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlPrintButtons: TPanel;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    pcSetupResult: TPageControl;
    tsSetUp: TTabSheet;
    tsResult: TTabSheet;
    Panel1: TPanel;
    pcAnalysis: TPageControl;
    pcTabCutters: TTabSheet;
    dbgCutters: TDBGridPlus;
    pcTabMaterials: TTabSheet;
    dbgMaterials: TDBGridPlus;
    pcTabParts: TTabSheet;
    dbgParts: TDBGridPlus;
    Panel2: TPanel;
    sgResults: TXStringGridPlus;
    cbMaterialUnits: TComboBox;
    qAnalyseTicketsCutterName: TStringField;
    qAnalyseTicketsMaterialUnitsToFeet: TFloatField;
    qCategoryTotals: TFDQueryPlus;
    qCategoryTotalsCutter: TStringField;
    qCategoryTotalsCutterName: TStringField;
    qCategoryTotalsMaterialCode: TStringField;
    qCategoryTotalsPartCode: TStringField;
    qCategoryTotalsTotalAllowance: TFloatField;
    qCategoryTotalsTotalActualVar: TFloatField;
    qCategoryTotalsTotalActualUsage: TFloatField;
    qCategoryTotalsTotalLossGain: TFloatField;
    qCategoryTotalsTotalCost: TFloatField;
    qCategoryTotalsTotalTime: TFloatField;
    qCategoryTotalsTotalPercVariance: TFloatField;
    qAnalyseTicketsTotalPairs: TIntegerField;
    qCategoryTotalsTotalPairs: TIntegerField;
    qMaterialDescs: TFDQueryPlus;
    qMaterialDescsMaterialCode: TStringField;
    qMaterialDescsMaterialDescription: TStringField;
    qAnalyseTicketsMaterialDescription: TStringField;
    qCategoryTotalsMaterialDescription: TStringField;
    qPartDescs: TFDQueryPlus;
    qPartDescsPartCode: TStringField;
    qPartDescsPartDescription: TStringField;
    qAnalyseTicketsPartDescription: TStringField;
    qCategoryTotalsPartDescription: TStringField;
    qCategoryTotalsTotalActualVarInTheseUnits: TFloatField;
    qCategoryTotalsTotalActualUsageInTheseUnits: TFloatField;
    qCategoryTotalsTotalAllowanceInTheseUnits: TFloatField;
    qCategoryTotalsTotalAllowanceInUnits: TFloatField;
    frAnalysis: TfrxReportPlus;
    frdbTicketTickets: TfrxDBDataset;
    frdbCategoryTotals: TfrxDBDataset;
    SpeedButton1: TSpeedButton;
    pnlSetupOther: TPanel;
    pnlDetails: TPanel;
    pnlDetailsHeader: TPanel;
    lblWeek: TLabel;
    lblReport: TLabel;
    lblAllowance: TLabel;
    cbCutterMonetaryValue: TCheckBox;
    lblWeeks: TLabel;
    lblLosses: TLabel;
    lblSavings: TLabel;
    seSavings: TPBSuperSpin;
    seLosses: TPBSuperSpin;
    seFrom: TPBSuperSpin;
    lblDash: TLabel;
    seTo: TPBSuperSpin;
    lblLossesPercent: TLabel;
    lblSavingsPercent: TLabel;
    rgReports: TRadioGroup;
    rgAllowance: TRadioGroup;
    rgWeek: TRadioGroup;
    pnlSetupOtherTop: TPanel;
    pnlSearches: TPanel;
    pnlSearchesHeader: TPanel;
    pnlLocations: TPanel;
    pnlLocationsHeader: TPanel;
    pnlMaterialTypes: TPanel;
    pnlMaterialTypesHeader: TPanel;
    lbLocations: TListBox;
    lbMaterialTypes: TListBox;
    edtPartsSearch: TEdit;
    cbPartsSearchExact: TCheckBox;
    cbMaterialsSearchExact: TCheckBox;
    edtMaterialsSearch: TEdit;
    lblcPartsSearch: TLabel;
    lblcMaterialsSearch: TLabel;
    cbCuttersSearchExact: TCheckBox;
    edtCuttersSearch: TEdit;
    lblCuttersSearch: TLabel;
    pnlLocationsFooter: TPanel;
    pnlMaterialTypesFooter: TPanel;
    cbAllLocations: TCheckBox;
    cbAllMatTypes: TCheckBox;
    btnSize: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadLocationListBox;
    procedure LoadMaterialTypeListBox;
    procedure LoadMaterialUnitsComboBox;
    procedure btnPrintClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure cbMaterialUnitsChange(Sender: TObject);
    procedure HeaderControl1SectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure sgResultsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure cbMaterialUnitsExit(Sender: TObject);
    procedure cbAllLocationsClick(Sender: TObject);
    procedure cbAllMatTypesClick(Sender: TObject);
    procedure GoTotals;
    procedure qCutterLocationsAfterOpen(DataSet: TDataSet);
    procedure qMaterialTypesAfterOpen(DataSet: TDataSet);
    procedure PassFormName(AnalyseForm : TfmAnalyse);
    procedure FinishSecondProcess(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure seFromInvalidEntry(Sender: TObject);
    procedure seToInvalidEntry(Sender: TObject);
    procedure seLossesInvalidEntry(Sender: TObject);
    procedure seSavingsInvalidEntry(Sender: TObject);
    procedure dbgCuttersDblClick(Sender: TObject);
    procedure SelectPart;
    procedure SelectMaterial;
    procedure SelectTicket;
    procedure dbgMaterialsDblClick(Sender: TObject);
    procedure dbgPartsDblClick(Sender: TObject);
    procedure pcAnalysisChange(Sender: TObject);
    procedure MakeDescriptionQuerys(WhereClauseStr: string);
    procedure qCategoryTotalsCalcFields(DataSet: TDataSet);
    procedure pcSetupResultDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure pcAnalysisDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure frAnalysisGetValue(const VarName: string; var Value: Variant);
    procedure frAnalysisBeforePrint(Sender: TfrxReportComponent);
    procedure SpeedButton1Click(Sender: TObject);
    procedure qCategoryTotalsAfterScroll(DataSet: TDataSet);
    procedure btnSizeClick(Sender: TObject);
    procedure pcSetupResultChanging(Sender: TObject; var AllowChange: Boolean);
  private
    { Private declarations }
    fmAnalyse: TfmAnalyse;
    TotalAllowance, TotalActualUsage, TotalActualVariance: real;
  public
    { Public declarations }
    MaterialUnits: array of UnitsRec;
    SecondProcessInUse: Boolean;
  end;

implementation

uses
  Windows, SysUtils, Dialogs, Graphics, SummsVars, General, Summs, OutOfMemory,
  SummsThreads, TicketsBreakdown, PartDetails, MaterialDetails;

{$R *.DFM}

procedure TfmAnalyse.LoadLocationListBox;
//var
//  i: integer;

begin
  //CJY:Begin removing dependence on RecordCount
  qCutterLocations.RecNo := 1; //CJY changed from qCutterLocations.First
  qCutterLocations.Prior; //CJY changed from qCutterLocations.First
//  for i := 1 to qCutterLocations.RecordCount do
  while not qCutterLocations.eof do
  begin
    lbLocations.Items.Add(qCutterLocationsCutterLocation.Value);
    qCutterLocations.Next;
  end;
  //CJY:End
  lbLocations.ItemIndex := 0;
end;

procedure TfmAnalyse.LoadMaterialTypeListBox;
//var
//  i: integer;

begin
  //CJY:Begin removing dependence on RecordCount
  qMaterialTypes.RecNo := 1; //CJY changed from qMaterialTypes.First
  qMaterialTypes.Prior; //CJY changed from qMaterialTypes.First
//  for i := 1 to qMaterialTypes.RecordCount do
  while not qMaterialTypes.eof do
  begin
    lbMaterialTypes.Items.Add(qMaterialTypesMaterialType.Value);
    qMaterialTypes.Next;
  end;
  //CJY:End
  lbMaterialTypes.ItemIndex := 0;
end;

procedure TfmAnalyse.LoadMaterialUnitsComboBox;

var
  i, ThisIndex: integer;

begin
  fmSumms.qMaterialUnits.RecNo := 1; //CJY changed from qMaterialUnits.First
  fmSumms.qMaterialUnits.Prior; //CJY changed from qMaterialUnits.First
  //CJY: Fetching all records to correct RecordCount (overhead partially offset
  //by iteration of now cached records)
  fmSumms.qMaterialUnits.FetchAll;

  //CJY: fmSumms.qMaterialUnits.FetchOptions.RecordCountMode set to cmTotal
  SetLength(MaterialUnits, fmSumms.qMaterialUnits.RecordCount);

  //CJY: fmSumms.qMaterialUnits.FetchOptions.RecordCountMode set to cmTotal
  for i := 1 to fmSumms.qMaterialUnits.RecordCount do
  begin
    cbMaterialUnits.Items.Add('sq ' + fmSumms.qMaterialUnitsUnitAbbreviation.Value);
    MaterialUnits[i-1].Code := fmSumms.qMaterialUnitsCode.value;
    MaterialUnits[i-1].Conversion := fmSumms.qMaterialUnitsToFeet.value;
    if fmSumms.qMaterialUnitsCode.value = DefaultMaterialUnits then
      ThisIndex := i - 1;
    fmSumms.qMaterialUnits.Next;
  end;
  cbMaterialUnits.ItemIndex := ThisIndex;
end;


procedure TfmAnalyse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfmAnalyse.btnPrintClick(Sender: TObject);
var
  AString : string;
  i : short;
  MyBookMark: TBookmark;
  Failed:boolean;
  mMemo: TfrxMemoView;
  dData: TfrxDetailData;
  mData: TfrxMasterData;
  ghGap: TfrxGroupHeader;

begin
  frAnalysis.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  screen.cursor := crHourGlass;

  MyBookmark := qAnalyseTickets.GetBookmark;
  qAnalyseTickets.DisableControls;

  //Decide whether to show cutting times on report.
  mMemo := frAnalysis.FindObject('mSmsTitle') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frAnalysis.FindObject('mTotalTime') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frAnalysis.FindObject('mSms') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;
  mMemo := frAnalysis.FindObject('mTotalTimeTotal') as TfrxMemoView;
  mMemo.Visible := Option_CuttingTimes;

  //Decide whether to show monetary costs on report.
  mMemo := frAnalysis.FindObject('mLossGainTitle') as TfrxMemoView;
  mMemo.Visible := cbCutterMonetaryValue.checked;
  mMemo := frAnalysis.FindObject('mTotalLossGain') as TfrxMemoView;
  mMemo.Visible := cbCutterMonetaryValue.checked;
  mMemo := frAnalysis.FindObject('mLossGain') as TfrxMemoView;
  mMemo.Visible := cbCutterMonetaryValue.checked;
  mMemo := frAnalysis.FindObject('mTotalLossGainTotal') as TfrxMemoView;
  mMemo.Visible := cbCutterMonetaryValue.checked;

  mMemo := frAnalysis.FindObject('mCostTitle') as TfrxMemoView;
  mMemo.Visible := cbCutterMonetaryValue.checked;
  mMemo := frAnalysis.FindObject('mTotalCost') as TfrxMemoView;
  mMemo.Visible := cbCutterMonetaryValue.checked;
  mMemo := frAnalysis.FindObject('mCost') as TfrxMemoView;
  mMemo.Visible := cbCutterMonetaryValue.checked;
  mMemo := frAnalysis.FindObject('mTotalCostTotal') as TfrxMemoView;
  mMemo.Visible := cbCutterMonetaryValue.checked;

  ghGap := frAnalysis.FindObject('ghGap') as TfrxGroupHeader;
  mData := frAnalysis.FindObject('mdTotals') as TfrxMasterData;
  if pcAnalysis.activePage = pcTabCutters then
  begin
    mMemo := frAnalysis.FindObject('mThing') as TfrxMemoView;
    mMemo.DataField := 'CUTTER';
    mMemo := frAnalysis.FindObject('mDescription') as TfrxMemoView;
    mMemo.DataField := 'CutterName';
    mMemo := frAnalysis.FindObject('mField1') as TfrxMemoView;
    mMemo.DataField := 'PARTCODE';
    mMemo := frAnalysis.FindObject('mField2') as TfrxMemoView;
    mMemo.DataField := 'MATERIALCODE';
    ghGap.StartNewPage := CutterPageThrow;
  end
  else if pcAnalysis.activePage = pcTabMaterials then
  begin
    mMemo := frAnalysis.FindObject('mThing') as TfrxMemoView;
    mMemo.DataField := 'MATERIALCODE';
    mMemo := frAnalysis.FindObject('mDescription') as TfrxMemoView;
    mMemo.DataField := 'MaterialDescription';
    mMemo := frAnalysis.FindObject('mField1') as TfrxMemoView;
    mMemo.DataField := 'CUTTER';
    mMemo := frAnalysis.FindObject('mField2') as TfrxMemoView;
    mMemo.DataField := 'PARTCODE';
    ghGap.StartNewPage := False;
  end
  else if pcAnalysis.activePage = pcTabParts then
  begin
    mMemo := frAnalysis.FindObject('mThing') as TfrxMemoView;
    mMemo.DataField := 'PARTCODE';
    mMemo := frAnalysis.FindObject('mDescription') as TfrxMemoView;
    mMemo.DataField := 'PartDescription';
    mMemo := frAnalysis.FindObject('mField1') as TfrxMemoView;
    mMemo.DataField := 'CUTTER';
    mMemo := frAnalysis.FindObject('mField2') as TfrxMemoView;
    mMemo.DataField := 'MATERIALCODE';
    ghGap.StartNewPage := False;
  end;

  dData := frAnalysis.FindObject('ddDetailed') as TfrxDetailData;
  //Summarised report only
  if rgReports.ItemIndex = 0 then
  begin
    mMemo := frAnalysis.FindObject('mCutWeekTitle') as TfrxMemoView;
    mMemo.Visible := false;
    mMemo := frAnalysis.FindObject('mTicketNumberTitle') as TfrxMemoView;
    mMemo.Visible := false;
    mMemo := frAnalysis.FindObject('mTitle1') as TfrxMemoView;
    mMemo.Visible := false;
    mMemo := frAnalysis.FindObject('mTitle2') as TfrxMemoView;
    mMemo.Visible := false;
    ghGap.Visible := False;
    mData.StartNewPage := False;
    mData.Font.Style := [];
    dData.Visible := false;
  end
  else
  begin
    ghGap.Visible := True;
    mData.Font.Style := [fsBold];
    dData.Visible := true;
  end;

  if pcAnalysis.activePage = pcTabCutters then
  begin
    qCategoryTotals.filter := 'MaterialCode = ''CT0**0''';
    //CJY Double quotes required for this definitions
    ghGap.Condition := 'frdbTicketTickets."Cutter"';
  end
  else if pcAnalysis.activePage = pcTabMaterials then
  begin
    qCategoryTotals.filter := 'Cutter = ''MT0**0''';
    //CJY Double quotes required for this definitions
    ghGap.Condition := 'frdbTicketTickets."MaterialCode"';
  end
  else if pcAnalysis.activePage = pcTabParts then
  begin
    qCategoryTotals.filter := 'Cutter = ''PT0**0''';
    ghGap.Condition := 'frdbTicketTickets."PartCode"';
  end;

  qCategoryTotals.filtered := True;

  //CJY skipping first / last row and Filtered
//  if qCategoryTotals.Active then
//    qCategoryTotals.Refresh;

  frAnalysis.PrintOptions.PrintMode := pmScale;
  frAnalysis.PrintOptions.PrintOnSheet := GetPaperSize;
  frAnalysis.PrepareReport;

  qAnalyseTickets.EnableControls;

  qAnalyseTickets.Filter := 'NOT(Cutter = ''0**0'' and MaterialCode = ''0**0'')';

  qAnalyseTickets.GotoBookmark(MyBookmark);
  qAnalyseTickets.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frAnalysis.ShowPreparedReport
  else
    frAnalysis.Print;

  screen.cursor := crDefault;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmAnalyse.btnRefreshClick(Sender: TObject);
begin
  screen.Cursor := crHourGlass;
  qAnalyseTickets.Close;
  qAnalyseTickets.Open;
  GoTotals;
  screen.Cursor := crDefault;
end;

procedure TfmAnalyse.btnSizeClick(Sender: TObject);
begin
  showmessage(inttostr(fmAnalyse.height) + ' - ' + inttostr(fmAnalyse.Width));
end;

procedure TfmAnalyse.cbMaterialUnitsChange(Sender: TObject);
var
  CurrentUnitConversion, Divider: real;
  Temp: string;

begin
  CurrentUnitConversion := MaterialUnits[cbMaterialUnits.ItemIndex].Conversion;
  Divider := CurrentUnitConversion * CurrentUnitConversion;

  str(TotalAllowance / Divider : 8: 2, Temp);
  sgResults.Cells[1,1] := Trim(Temp);
  str(TotalActualUsage / Divider : 8: 2, Temp);
  sgResults.Cells[3,1]:= Trim(Temp);
  str(TotalActualVariance / Divider : 8: 2, Temp);
  sgResults.Cells[4,1] := Trim(Temp);

  cbMaterialUnits.Visible := FALSE;

  sgResults.Cells[2,1] := cbMaterialUnits.Text;
end;

procedure TfmAnalyse.MakeDescriptionQuerys(WhereClauseStr: string);
var
  CodeStr, DescStr, SQLString: string;
  Looping: integer;

begin
  Looping := 0;

  repeat
    if Looping = 0 then
    begin
      CodeStr := 'MaterialCode';
      DescStr := 'MaterialDescription';
    end
    else
    begin
      CodeStr := 'PartCode';
      DescStr := 'PartDescription';
    end;

    SQLString := 'SELECT ' + CodeStr + ', ''***VARIOUS***'' as ' + DescStr +
                 ' FROM TicketTickets ' +
                 'WHERE ' + WhereClauseStr +
                 ' GROUP BY ' + CodeStr +
                 ' HAVING COUNT(DISTINCT ' + DescStr + ') > 1 ' +
                 'UNION SELECT DISTINCT ' + CodeStr + ', ' + DescStr +
                 ' FROM TicketTickets ' +
                 'WHERE ' + CodeStr + ' NOT IN ' +
                 '(SELECT ' + CodeStr +
                 ' FROM TicketTickets WHERE ' +
                 WhereClauseStr + ' GROUP BY ' + CodeStr +
                 ' HAVING COUNT(DISTINCT ' + DescStr + ') > 1) AND ' +
                 WhereClauseStr +
                 ' Order By 1, 1 ';

    if Looping = 0 then
      qMaterialDescs.SQL.Text := SQLString
    else
      qPartDescs.SQL.Text := SQLString;
    inc(Looping);
  until Looping > 1;
end;

procedure TfmAnalyse.pcSetupResultChanging(Sender: TObject;
  var AllowChange: Boolean);
var
  UpdatedStr, SelectStr, TicketStr, FakeTotalsStr, FromStr, WeekStr, FullWeekStr, LossGainStr, LocationStr,
  MaterialTypesStr, CuttersStr, MaterialsStr, PartsStr, TotalsStr, OrderStr, CutTotalsStr, MatTotalsStr,
  PartTotalsStr, CutGroupByStr, MatGroupByStr, PartGroupByStr, NonZeroStr, WhereClauseStr, SQLString, LowWeek,
  HighWeek, Loss, Gain: string;
  i, LossInt: integer;
  First: boolean;

begin
  screen.cursor := crHourGlass;
  application.ProcessMessages;

  if pcSetUpResult.ActivePage = tsSetUp then
  begin
    btnRefresh.Enabled := TRUE;
    btnPrintPreview.Enabled := TRUE;
    btnPrint.Enabled := TRUE;

    SelectStr := 'SELECT Cutter, C.Name as CutterName, MaterialCode, PartCode, ' +
                 'CutWeek, WeekNo, SequenceNo, TicketNo, CONCAT(CONCAT(CONCAT(CONCAT(RTRIM(CONVERT(WeekNo, SQL_CHAR)), ''/''), ' +
                 'RTRIM(CONVERT(SequenceNo, SQL_CHAR))), ''/''), CONVERT(TicketNo, SQL_CHAR)) as TicketNumber, ' +
                 'MaterialUnitsToFeet, TotalPairs, CONCAT('' sq '', MaterialUnitAbbreviation) as sqUnits, ' +
                 'ROUND(ActualUsage, 2) as ActualUsage, SMVs, ';

    FakeTotalsStr := '0 as TotalTotalPairs, 0 as TotalAllowance, 0 as TotalActualVar, 0 as TotalActualUsage, 0 as ' +
                     'TotalLossGain, 0 as TotalCost, 0 as TotalTime, 0 as TotalPercVariance ';

    if seLosses.Value > 0 then
      LossInt := round(-seLosses.Value)
    else
      LossInt := 0;
    str(LossInt, Loss);

    if seSavings.Value > 0 then
      str(seSavings.Value, Gain)
    else
      Gain := '0';

    if rgAllowance.Items[rgAllowance.ItemIndex] = 'Ticket' then
    begin
      TicketStr := 'ROUND(IssuedAllowance, 2) as AllowanceToUse, ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2) as ActualVar, ' +
                   '((ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) / ROUND(IssuedAllowance, 2)) * 100 as PercVar, ' +
                   'IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * ' +
                   '(MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2))) as LossGain, ' +
                   'IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, MatPrice * ROUND(ActualUsage, 2) * ' +
                   '(MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * ROUND(ActualUsage, 2)) as UsedMoney, ';

      TotalsStr := ' UNION SELECT ''0**0'' as Cutter, ''0**0'' as CutterName, ''0**0'' as MaterialCode, ' +
                   '''0**0'' as PartCode, ' +
                   '0 as CutWeek, 0 as WeekNo, 0 as SequenceNo, 0 as TicketNo, ''0**0'' as TicketNumber, ' +
                   '0 as MaterialUnitsToFeet, 0 as TotalPairs, ''0**0'' as sqUnits, ' +
                   '0 as ActualUsage, 0 as SMVs, 0 as AllowanceToUse, 0 as ActualVar, 0 as PercVar, 0 as LossGain, ' +
                   '0 as UsedMoney, CONVERT(SUM(TotalPairs), SQL_INTEGER) as TotalTotalPairs, SUM(ROUND(IssuedAllowance, 2) * MaterialUnitsToFeet * ' +
                   'MaterialUnitsToFeet) as TotalAllowance, SUM((ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * ' +
                   'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualVar, SUM(ROUND(ActualUsage, 2) * ' +
                   'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualUsage, ' +
                   'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                   'MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * (MaterialSubUnitsPerUnit / MaterialWidth), ' +
 	                 'MatPrice * (ROUND (IssuedAllowance, 2) - ROUND(ActualUsage, 2)))) as TotalLossGain, ' +
                   'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                   'MatPrice * ROUND(ActualUsage, 2) * (MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * ROUND(ActualUsage, 2))) as TotalCost, ' +
                   'SUM(SMVs) as TotalTime, SUM((ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * ' +
                   'MaterialUnitsToFeet * MaterialUnitsToFeet) / SUM(ROUND(IssuedAllowance, 2) * MaterialUnitsToFeet * ' +
                   'MaterialUnitsToFeet) * 100 as TotalPercVariance ';

      CutTotalsStr := 'SELECT Cutter, C.Name as CutterName, ''CT0**0'' as MaterialCode, ' +
                      '''0**0'' as PartCode, ' +
                      'CONVERT(SUM(TotalPairs), SQL_INTEGER) as TotalPairs, SUM(ROUND(IssuedAllowance, 2) * MaterialUnitsToFeet * ' +
                      'MaterialUnitsToFeet) as TotalAllowance, SUM((ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualVar, SUM(ROUND(ActualUsage, 2) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualUsage, ' +
                      'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                      'MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * (MaterialSubUnitsPerUnit / MaterialWidth), ' +
 	                    'MatPrice * (ROUND (IssuedAllowance, 2) - ROUND(ActualUsage, 2)))) as TotalLossGain, ' +
                      'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                      'MatPrice * ROUND(ActualUsage, 2) * (MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * ROUND(ActualUsage, 2))) as TotalCost, ' +
                      'SUM(SMVs) as TotalTime, SUM((ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) / SUM(ROUND(IssuedAllowance, 2) * MaterialUnitsToFeet * ' +
                      'MaterialUnitsToFeet) * 100 as TotalPercVariance ';

      MatTotalsStr := ' UNION SELECT ''MT0**0'' as Cutter, ''0**0'' as CutterName, MaterialCode, ' +
                      '''0**0'' as PartCode, ' +
                      'CONVERT(SUM(TotalPairs), SQL_INTEGER) as TotalPairs, SUM(ROUND(IssuedAllowance, 2) * MaterialUnitsToFeet * ' +
                      'MaterialUnitsToFeet) as TotalAllowance, SUM((ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualVar, SUM(ROUND(ActualUsage, 2) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualUsage, ' +
                      'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                      'MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * (MaterialSubUnitsPerUnit / MaterialWidth), ' +
 	                    'MatPrice * (ROUND (IssuedAllowance, 2) - ROUND(ActualUsage, 2)))) as TotalLossGain, ' +
                      'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                      'MatPrice * ROUND(ActualUsage, 2) * (MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * ROUND(ActualUsage, 2))) as TotalCost, ' +
                      'SUM(SMVs) as TotalTime, SUM((ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) / SUM(ROUND(IssuedAllowance, 2) * MaterialUnitsToFeet * ' +
                      'MaterialUnitsToFeet) * 100 as TotalPercVariance ';

      PartTotalsStr := ' UNION SELECT ''PT0**0'' as Cutter, ''0**0'' as CutterName, ''0**0'' as MaterialCode, ' +
                       'PartCode, ' +
                       'CONVERT(SUM(TotalPairs), SQL_INTEGER) as TotalPairs, SUM(ROUND(IssuedAllowance, 2) * MaterialUnitsToFeet * ' +
                       'MaterialUnitsToFeet) as TotalAllowance, SUM((ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * ' +
                       'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualVar, SUM(ROUND(ActualUsage, 2) * ' +
                       'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualUsage, ' +
                       'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                       'MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * (MaterialSubUnitsPerUnit / MaterialWidth), ' +
 	                     'MatPrice * (ROUND (IssuedAllowance, 2) - ROUND(ActualUsage, 2)))) as TotalLossGain, ' +
                       'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                       'MatPrice * ROUND(ActualUsage, 2) * (MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * ROUND(ActualUsage, 2))) as TotalCost, ' +
                       'SUM(SMVs) as TotalTime, SUM((ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * ' +
                       'MaterialUnitsToFeet * MaterialUnitsToFeet) / SUM(ROUND(IssuedAllowance, 2) * MaterialUnitsToFeet * ' +
                       'MaterialUnitsToFeet) * 100 as TotalPercVariance ';

      if (seLosses.Value > 0) or (seSavings.Value > 0) then
        LossGainStr := ' and (((ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) / ROUND(IssuedAllowance, 2)) * 100 <= ' + Loss + ' or ' +
                       '((ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) / ROUND(IssuedAllowance, 2)) * 100 >= ' + Gain + ')'
      else LossGainStr := '';

      NonZeroStr := ' AND NOT(ROUND(IssuedAllowance, 2) = 0) AND IssuedAllowance IS NOT NULL ';
    end
    else
    begin
      TicketStr := 'CostedAllowance * TotalPairs as AllowanceToUse, CostedAllowance * TotalPairs - ROUND(ActualUsage, 2) as ' +
                   'ActualVar, (CostedAllowance * TotalPairs - ROUND(ActualUsage, 2)) / (CostedAllowance * TotalPairs) * 100 ' +
                   'as PercVar, IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * ' +
                   '(MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2))) as LossGain, ' +
                   'IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, MatPrice * ROUND(ActualUsage, 2) * ' +
                   '(MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * ROUND(ActualUsage, 2)) as UsedMoney, ';

      TotalsStr := ' UNION SELECT ''0**0'' as Cutter, ''0**0'' as CutterName, ''0**0'' as MaterialCode, ' +
                   '''0**0'' as PartCode, ' +
                   '0 as CutWeek, 0 as WeekNo, 0 as SequenceNo, 0 as TicketNo, ''0**0'' as TicketNumber, ' +
                   '0 as MaterialUnitsToFeet, 0 as TotalPairs, ''0**0'' as sqUnits, 0 as ActualUsage, ' +
                   '0 as SMVs, 0 as AllowanceToUse, 0 as ActualVar, 0 as PercVar, 0 as LossGain, 0 as UsedMoney, ' +
                   'CONVERT(SUM(TotalPairs), SQL_INTEGER) as TotalTotalPairs, SUM(CostedAllowance * TotalPairs * MaterialUnitsToFeet * ' +
                   'MaterialUnitsToFeet) as TotalAllowance, SUM((CostedAllowance * TotalPairs - ROUND(ActualUsage, 2)) * ' +
                   'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualVar, SUM(ROUND(ActualUsage, 2) * ' +
                   'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualUsage, ' +
                   'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                   'MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * (MaterialSubUnitsPerUnit / MaterialWidth), ' +
 	                 'MatPrice * (ROUND (IssuedAllowance, 2) - ROUND(ActualUsage, 2)))) as TotalLossGain, ' +
                   'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                   'MatPrice * ROUND(ActualUsage, 2) * (MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * ROUND(ActualUsage, 2))) as TotalCost, ' +
                   'SUM(SMVs) as TotalTime, SUM((CostedAllowance * TotalPairs - ROUND(ActualUsage, 2)) * ' +
                   'MaterialUnitsToFeet * MaterialUnitsToFeet) / SUM(CostedAllowance * TotalPairs * MaterialUnitsToFeet * ' +
                   'MaterialUnitsToFeet) * 100 as TotalPercVariance ';

      CutTotalsStr := 'SELECT Cutter, C.Name as CutterName, ''CT0**0'' as MaterialCode, ' +
                      '''0**0'' as PartCode, ' +
                      'CONVERT(SUM(TotalPairs), SQL_INTEGER) as TotalPairs, SUM(CostedAllowance * TotalPairs * MaterialUnitsToFeet * ' +
                      'MaterialUnitsToFeet) as TotalAllowance, SUM((CostedAllowance * TotalPairs - ROUND(ActualUsage, 2)) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualVar, SUM(ROUND(ActualUsage, 2) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualUsage, ' +
                      'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                      'MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * (MaterialSubUnitsPerUnit / MaterialWidth), ' +
 	                    'MatPrice * (ROUND (IssuedAllowance, 2) - ROUND(ActualUsage, 2)))) as TotalLossGain, ' +
                      'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                      'MatPrice * ROUND(ActualUsage, 2) * (MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * ROUND(ActualUsage, 2))) as TotalCost, ' +
                      'SUM(SMVs) as TotalTime, SUM((CostedAllowance * TotalPairs - ROUND(ActualUsage, 2)) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) / SUM(CostedAllowance * TotalPairs * MaterialUnitsToFeet * ' +
                      'MaterialUnitsToFeet) * 100 as TotalPercVariance ';

      MatTotalsStr := ' UNION SELECT ''MT0**0'' as Cutter, ''0**0'' as CutterName, MaterialCode, ' +
                      '''0**0'' as PartCode, ' +
                      'CONVERT(SUM(TotalPairs), SQL_INTEGER) as TotalPairs, SUM(CostedAllowance * TotalPairs * MaterialUnitsToFeet * ' +
                      'MaterialUnitsToFeet) as TotalAllowance, SUM((CostedAllowance * TotalPairs - ROUND(ActualUsage, 2)) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualVar, SUM(ROUND(ActualUsage, 2) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualUsage, ' +
                      'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                      'MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * (MaterialSubUnitsPerUnit / MaterialWidth), ' +
 	                    'MatPrice * (ROUND (IssuedAllowance, 2) - ROUND(ActualUsage, 2)))) as TotalLossGain, ' +
                      'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                      'MatPrice * ROUND(ActualUsage, 2) * (MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * ROUND(ActualUsage, 2))) as TotalCost, ' +
                      'SUM(SMVs) as TotalTime, SUM((CostedAllowance * TotalPairs - ROUND(ActualUsage, 2)) * ' +
                      'MaterialUnitsToFeet * MaterialUnitsToFeet) / SUM(CostedAllowance * TotalPairs * MaterialUnitsToFeet * ' +
                      'MaterialUnitsToFeet) * 100 as TotalPercVariance ';

      PartTotalsStr := ' UNION SELECT ''PT0**0'' as Cutter, ''0**0'' as CutterName, ''0**0'' as MaterialCode, ' +
                       'PartCode, ' +
                       'CONVERT(SUM(TotalPairs), SQL_INTEGER) as TotalPairs, SUM(CostedAllowance * TotalPairs * MaterialUnitsToFeet * ' +
                       'MaterialUnitsToFeet) as TotalAllowance, SUM((CostedAllowance * TotalPairs - ROUND(ActualUsage, 2)) * ' +
                       'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualVar, SUM(ROUND(ActualUsage, 2) * ' +
                       'MaterialUnitsToFeet * MaterialUnitsToFeet) as TotalActualUsage, ' +
                       'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                       'MatPrice * (ROUND(IssuedAllowance, 2) - ROUND(ActualUsage, 2)) * (MaterialSubUnitsPerUnit / MaterialWidth), ' +
 	                     'MatPrice * (ROUND (IssuedAllowance, 2) - ROUND(ActualUsage, 2)))) as TotalLossGain, ' +
                       'SUM(IIF(((MaterialType = ''R'') or (MaterialType = ''S'')) and MaterialLinearPrice = TRUE, ' +
                       'MatPrice * ROUND(ActualUsage, 2) * (MaterialSubUnitsPerUnit / MaterialWidth), MatPrice * ROUND(ActualUsage, 2))) as TotalCost, ' +
                       'SUM(SMVs) as TotalTime, SUM((CostedAllowance * TotalPairs - ROUND(ActualUsage, 2)) * ' +
                       'MaterialUnitsToFeet * MaterialUnitsToFeet) / SUM(CostedAllowance * TotalPairs * MaterialUnitsToFeet * ' +
                       'MaterialUnitsToFeet) * 100 as TotalPercVariance ';

      if (seLosses.Value > 0) or (seSavings.Value > 0) then
        LossGainStr := ' and ((CostedAllowance * TotalPairs - ROUND(ActualUsage, 2)) / (CostedAllowance * TotalPairs) * 100 <= ' +
                       Loss + ' or (CostedAllowance * TotalPairs - ROUND(ActualUsage, 2)) / (CostedAllowance * TotalPairs) * 100 >= '
                       + Gain + ')'
      else LossGainStr := '';

      NonZeroStr := ' AND NOT(CostedAllowance = 0) AND CostedAllowance IS NOT NULL';
    end;

    FromStr := 'FROM TicketTickets, Cutters C WHERE Cutter = C.Code and ';

    CutGroupByStr := ' GROUP BY Cutter, C.Name';
    MatGroupByStr := ' GROUP BY MaterialCode';
    PartGroupByStr := ' GROUP BY PartCode';

    UpdatedStr := 'ActualUsage IS NOT NULL and ';

    if rgWeek.Items[rgWeek.ItemIndex] = 'Issued' then
      WeekStr := 'WeekNo '
    else
      WeekStr := 'CutWeek ';

    str(seFrom.Value, LowWeek);
    str(seTo.Value, HighWeek);

    if seFrom.Value = seTo.Value then
      FullWeekStr := WeekStr + ' = ' + LowWeek + ' and CutWeek IS NOT NULL'
    else
      if seFrom.Value < seTo.Value then
        FullWeekStr := WeekStr + 'BETWEEN ' + LowWeek + ' and ' + HighWeek + ' and CutWeek IS NOT NULL'
      else
        FullWeekStr := '(' + WeekStr + 'BETWEEN ' + LowWeek + ' and 53 or ' + WeekStr + ' BETWEEN 1 and ' + HighWeek + ') and CutWeek IS NOT NULL';

    if cbAllLocations.Checked then
      LocationStr := ' and CutterLocation IS NOT NULL '
    else
    begin
      if LbLocations.SelCount = 0 then
        LocationStr := ' and CutterLocation = '''''
      else if LbLocations.SelCount = 1 then
        LocationStr := ' and CutterLocation = ''' + QS(lbLocations.Items[lbLocations.ItemIndex]) + ''''
      else if LbLocations.SelCount > 1 then
      begin
        First := TRUE;
        i := 0;

        while i < lbLocations.Items.Count do
        begin
          if lbLocations.Selected[i] then
          begin
            if First then
            begin
              LocationStr := ' and CutterLocation IS NOT NULL and (CutterLocation = ''' + QS(lbLocations.Items[i]) + '''';
              First := FALSE;
            end
            else
              LocationStr := LocationStr + ' or CutterLocation = ''' + QS(lbLocations.Items[i]) + '''';
          end;

          inc(i);
        end;
        LocationStr := LocationStr + ')';
      end;
    end;

    if cbAllMatTypes.Checked then
      MaterialTypesStr := ' and MaterialType IS NOT NULL '
    else
    begin
      if lbMaterialTypes.SelCount = 0 then
        MaterialTypesStr := ' and MaterialType = '''''
      else if lbMaterialTypes.SelCount = 1 then
        MaterialTypesStr := ' and MaterialType = ''' + QS(lbMaterialTypes.Items[lbMaterialTypes.ItemIndex]) + ''''
      else if lbMaterialTypes.SelCount > 1 then
      begin
        First := TRUE;
        i := 0;

        while i < lbMaterialTypes.Items.Count do
        begin
          if lbMaterialTypes.Selected[i] then
          begin
            if First then
            begin
              MaterialTypesStr := ' and MaterialType IS NOT NULL and (MaterialType = ''' + QS(lbMaterialTypes.Items[i]) + '''';
              First := FALSE;
            end
            else
              MaterialTypesStr := MaterialTypesStr + ' or MaterialType = ''' + QS(lbMaterialTypes.Items[i]) + '''';
          end;

          inc(i);
        end;
        MaterialTypesStr := MaterialTypesStr + ')';
      end;
    end;

    if cbCuttersSearchExact.checked then
      CuttersStr := ' and Cutter LIKE ''' + QS(edtCuttersSearch.text) + ''''
    else
      CuttersStr := ' and Cutter LIKE ''' + QS(edtCuttersSearch.text) + '%''';

    if cbMaterialsSearchExact.checked then
      MaterialsStr := ' and MaterialCode LIKE ''' + QS(edtMaterialsSearch.text) + ''''
    else
      MaterialsStr := ' and MaterialCode LIKE ''' + QS(edtMaterialsSearch.text) + '%''';

    if cbPartsSearchExact.checked then
      PartsStr := ' and PartCode LIKE ''' + QS(edtPartsSearch.text) + ''''
    else
      PartsStr := ' and PartCode LIKE ''' + QS(edtPartsSearch.text) + '%''';

    OrderStr := ' Order By 6, 6, 7, 8, 9';

    WhereClauseStr := UpdatedStr + FullWeekStr + NonZeroStr + LossGainStr + LocationStr + MaterialTypesStr +
                      CuttersStr + MaterialsStr + PartsStr;

    MakeDescriptionQuerys(WhereClauseStr);

    SQLString := SelectStr + TicketStr + FakeTotalsStr + FromStr + WhereClauseStr + TotalsStr + FromStr +
                 WhereClauseStr + OrderStr;

    qAnalyseTickets.SQL.Text := SQLString;
    qAnalyseTickets.Open;

    SQLString := CutTotalsStr + FromStr + WhereClauseStr + CutGroupByStr + MatTotalsStr + FromStr + UpdatedStr +
                 FullWeekStr + NonZeroStr + LossGainStr + LocationStr + MaterialTypesStr + CuttersStr +
                 MaterialsStr + PartsStr + MatGroupByStr + PartTotalsStr + FromStr + WhereClauseStr + PartGroupByStr;
    qCategoryTotals.SQL.Text := SQLString;
    qCategoryTotals.Open;

    GoTotals;
  end
  else
  begin
    btnRefresh.Enabled := FALSE;
    btnPrintPreview.Enabled := FALSE;
    btnPrint.Enabled := FALSE;
  end;

  screen.cursor := crDefault;
end;

procedure TfmAnalyse.GoTotals;
var
  Temp: string;
  CurrentUnitConversion, Divider: real;

begin
  qAnalyseTickets.Filter := 'Cutter = ''0**0'' and MaterialCode = ''0**0''';

  CurrentUnitConversion := MaterialUnits[cbMaterialUnits.ItemIndex].Conversion;
  Divider := CurrentUnitConversion * CurrentUnitConversion;

  TotalAllowance := qAnalyseTicketsTotalAllowance.Value;
  TotalActualUsage := qAnalyseTicketsTotalActualUsage.Value;
  TotalActualVariance := qAnalyseTicketsTotalActualVar.Value;

  sgResults.Cells[0,1] := IntToStr(qAnalyseTicketsTotalTotalPairs.Value);
  str(TotalAllowance / Divider : 8: 2, Temp);
  sgResults.Cells[1,1] := Trim(Temp);
  str(TotalActualUsage / Divider : 8: 2, Temp);
  sgResults.Cells[3,1] := Trim(Temp);
  str(TotalActualVariance / Divider : 8: 2, Temp);
  sgResults.Cells[4,1] := Trim(Temp);
  str(qAnalyseTicketsTotalPercVariance.Value : 8: 2, Temp);
  sgResults.Cells[5,1] := Trim(Temp);
  str(qAnalyseTicketsTotalLossGain.Value : 8: 2, Temp);
  sgResults.Cells[6,1] := Trim(Temp);
  str(qAnalyseTicketsTotalCost.Value : 10: 2, Temp);
  sgResults.Cells[7,1] := Trim(Temp);
  str(qAnalyseTicketsTotalTime.Value : 8: 2, Temp);
  sgResults.Cells[8,1] := Trim(Temp);

  qAnalyseTickets.Filter := 'NOT(Cutter = ''0**0'' and MaterialCode = ''0**0'')';

  sgResults.Cells[2,1] := cbMaterialUnits.Text;
end;

procedure TfmAnalyse.HeaderControl1SectionResize(
  HeaderControl: THeaderControl; Section: THeaderSection);
begin
  if Section.Index = 0 then
    sgResults.Columns[0].Width := Section.Width - 2
  else
    sgResults.Columns[Section.Index].Width := Section.Width;
end;

procedure TfmAnalyse.sgResultsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ACol = 2) and (ARow = 1) then
  begin
    cbMaterialUnits.Left := sgResults.Columns[0].Width + sgResults.Columns[1].Width + 3;
    cbMaterialUnits.Width := sgResults.Columns[2].Width + 1;
    cbMaterialUnits.Visible := TRUE;
    cbMaterialUnits.SetFocus;
  end;

  if ARow = 0 then
    CanSelect := False;
end;

procedure TfmAnalyse.SpeedButton1Click(Sender: TObject);
begin
  qCategoryTotals.filter := 'MaterialCode = ''CT0**0''';
  qCategoryTotals.filtered := True;

  //CJY skipping first / last row and Filtered
//  if qCategoryTotals.Active then
//    qCategoryTotals.Refresh;
end;

procedure TfmAnalyse.cbMaterialUnitsExit(Sender: TObject);
begin
  cbMaterialUnits.Visible := FALSE;
  sgResults.Cells[2,1] := cbMaterialUnits.Text;
end;

procedure TfmAnalyse.cbAllLocationsClick(Sender: TObject);
var
  i: integer;

begin
  lbLocations.Enabled := not cbAllLocations.Checked;
  for i := 0 to lbLocations.Items.Count - 1 do
    lbLocations.Selected[i] := FALSE;
end;

procedure TfmAnalyse.cbAllMatTypesClick(Sender: TObject);
var
  i: integer;

begin
  lbMaterialTypes.Enabled := not cbAllMatTypes.Checked;
  for i := 0 to lbMaterialTypes.Items.Count - 1 do
    lbMaterialTypes.Selected[i] := FALSE;
end;

procedure TfmAnalyse.qCutterLocationsAfterOpen(DataSet: TDataSet);
begin
  LoadLocationListBox;
end;

procedure TfmAnalyse.qMaterialTypesAfterOpen(DataSet: TDataSet);
begin
  LoadMaterialTypeListBox;
end;

procedure TfmAnalyse.PassFormName(AnalyseForm : TfmAnalyse);
var
  i: SmallInt;
  ItemIndex, Code: integer;
  SecondProcess : AnalysisThread;

begin
  fmAnalyse := AnalyseForm;

  rgWeek.ItemIndex := IssuedCutWeek;
  rgAllowance.ItemIndex := TicketCostedAlw;
  rgReports.ItemIndex := SummarisedDetailed;

  cbCutterMonetaryValue.checked := PrintCutterValue;

  pcAnalysis.ActivePage := pcTabCutters;

  //Start Thread to Load List Boxes
  if not SecondProcessInUse then
  begin
    SecondProcessInUse := True;
    SecondProcess := AnalysisThread.Create(true);
    SecondProcess.FreeOnTerminate := True;
    SecondProcess.OnTerminate := FinishSecondProcess;
    SecondProcess.PassDetails(fmAnalyse);
    SecondProcess.resume;
  end;

  LoadMaterialUnitsComboBox;

  if Option_CuttingTimes then
  begin
    dbgCutters.Columns.add;
    dbgCutters.Columns[13].Fieldname := 'Smvs';
    dbgCutters.Columns[13].Width := 60;
    dbgCutters.Columns[13].Alignment := taRightJustify;
    dbgCutters.Columns[13].Title.Alignment := taCenter;
    dbgMaterials.Columns.add;
    dbgMaterials.Columns[13].Fieldname := 'Smvs';
    dbgMaterials.Columns[13].Width := 60;
    dbgMaterials.Columns[13].Alignment := taRightJustify;
    dbgMaterials.Columns[13].Title.Alignment := taCenter;
    dbgParts.Columns.add;
    dbgParts.Columns[13].Fieldname := 'Smvs';
    dbgParts.Columns[13].Width := 60;
    dbgParts.Columns[13].Alignment := taRightJustify;
    dbgParts.Columns[13].Title.Alignment := taCenter;

    sgResults.Columns[8].Width := 66;
  end;

  Screen.cursor := crDefault
end;

procedure TfmAnalyse.FinishSecondProcess(Sender: TObject);
begin
  SecondProcessInUse := False;
end;

procedure TfmAnalyse.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);

  dbgCutters.Columns[5].Title.Caption := PairsWord;
  dbgMaterials.Columns[5].Title.Caption := PairsWord;
  dbgParts.Columns[5].Title.Caption := PairsWord;
  sgResults.Columns[0].Caption := PairsWord;

  SecondProcessInUse := False;
end;

procedure TfmAnalyse.frAnalysisBeforePrint(Sender: TfrxReportComponent);
begin
  frAnalysis.PreviewOptions.AllowEdit := False;
  frAnalysis.PreviewOptions.Buttons := frAnalysis.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAnalysis.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAnalysis.PreviewOptions.ZoomMode := zmDefault
  else
    frAnalysis.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAnalyse.frAnalysisGetValue(const VarName: string;
  var Value: Variant);
var
  i: integer;
  AString: string;

begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
  begin
    if pcAnalysis.activePage = pcTabCutters then
      Value := 'Analysis by Cutter'
    else if pcAnalysis.activePage = pcTabMaterials then
      Value := 'Analysis by Material'
    else
      Value := 'Analysis by Part'
  end
  else if (VarName = 'TotalPairs') then
    Value := sgResults.Cells[0, 1]
  else if (VarName = 'TotalAllowanceInTheseUnits') then
    Value := sgResults.Cells[1, 1]
  else if (VarName = 'Units') then
    Value := sgResults.Cells[2, 1]
  else if (VarName = 'TotalActualUsageInTheseUnits') then
    Value := sgResults.Cells[3, 1]
  else if (VarName = 'TotalActualVarInTheseUnits') then
    Value := sgResults.Cells[4, 1]
  else if (VarName = 'TotalPercVariance') then
    Value := sgResults.Cells[5, 1]
  else if (VarName = 'TotalLossGain') then
    Value := sgResults.Cells[6, 1]
  else if (VarName = 'TotalCost') then
    Value := sgResults.Cells[7, 1]
  else if (VarName = 'TotalTime') then
    Value := sgResults.Cells[8, 1]
  else if (VarName = 'Week') then
    Value := rgWeek.Items[rgWeek.ItemIndex]
  else if (VarName = 'Allowance') then
    Value := rgAllowance.Items[rgAllowance.ItemIndex]
  else if (VarName = 'Location') then
  begin
    if cbAllLocations.Checked then
      Value := 'ALL'
    else
    begin
      Value := '';
      for i :=  1 to lbLocations.Items.Count do
      begin
        if (lbLocations.Selected[i - 1]) then
        begin
          if Value <> '' then
            Value := Value + ', ';
          Value := Value + lbLocations.Items[i - 1];
        end;
      end;
    end;
  end
  else if (VarName = 'MaterialType') then
  begin
      if cbAllMatTypes.Checked then
        Value := 'ALL'
      else
      begin
        Value := '';
        for i := 1 to lbMaterialTypes.Items.Count do
        begin
          if (lbMaterialTypes.Selected[i - 1]) then
          begin
            if Value <> '' then
              Value := Value + ', ';
            Value := Value + lbMaterialTypes.Items[i - 1];
          end;
        end;
      end;
  end
  else if (VarName = 'Losses') then
  begin
    str(seLosses.value : 2 : 0, AString);
    Value := AString;
  end
  else if (VarName = 'Savings') then
  begin
    str(seSavings.value : 2 : 0, AString);
    Value := AString;
  end
  else if (VarName = 'From') then
  begin
    str(seFrom.value : 2 : 0, AString);
    Value := AString;
  end
  else if (VarName = 'To') then
  begin
    str(seTo.value : 2 : 0, AString);
    Value := AString;
  end
  else if (VarName = 'Cutters') then
    Value := edtCuttersSearch.text
  else if (VarName = 'Materials') then
    Value := edtMaterialsSearch.text
  else if (VarName = 'Parts') then
    Value := edtPartsSearch.text
  else if (VarName = 'LossGain') then
    Value := 'Loss/  ' + #13 + 'Gain (' + FormatSettings.CurrencyString + ')'
  else if (VarName = 'Cost') then
    Value := 'Cost (' + FormatSettings.CurrencyString + ')'
  else if (VarName = 'Title1') then
  begin
    if pcAnalysis.activePage = pcTabCutters then
      Value := 'Part' + #13 + 'Code'
    else if pcAnalysis.activePage = pcTabMaterials then
      Value := 'Cutter' + #13 + 'Code'
    else if pcAnalysis.activePage = pcTabParts then
      Value := 'Material' + #13 + 'Code';
  end
  else if (VarName = 'Title2') then
  begin
    if pcAnalysis.activePage = pcTabCutters then
      Value := 'Material' + #13 + 'Code'
    else if pcAnalysis.activePage = pcTabMaterials then
      Value := 'Part' + #13 + 'Code'
    else if pcAnalysis.activePage = pcTabParts then
      Value := 'Cutter' + #13 + 'Code';
  end;
end;

procedure TfmAnalyse.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not SecondProcessInUse;

  if SecondProcessInUse then
    messagedlg('Cannot close whilst loading', mtInformation, [mbOk], 0);
end;

procedure TfmAnalyse.seFromInvalidEntry(Sender: TObject);
begin
  seFrom.Value := 1;
  seFrom.SetFocus;
end;

procedure TfmAnalyse.seToInvalidEntry(Sender: TObject);
begin
  seTo.Value := 1;
  seTo.SetFocus;
end;

procedure TfmAnalyse.seLossesInvalidEntry(Sender: TObject);
begin
  seLosses.Value := 0;
  seLosses.SetFocus;
end;

procedure TfmAnalyse.seSavingsInvalidEntry(Sender: TObject);
begin
  seSavings.Value := 0;
  seSavings.SetFocus;
end;

procedure TfmAnalyse.dbgCuttersDblClick(Sender: TObject);
var
  Whichfield: string;

begin
  WhichField := dbgCutters.Columns.Grid.SelectedField.FieldName;

  if WhichField = 'TicketNumber' then
    SelectTicket
  else if WhichField = 'PartCode' then
    SelectPart
  else if WhichField = 'MaterialCode' then
    SelectMaterial;
end;

procedure TfmAnalyse.dbgMaterialsDblClick(Sender: TObject);
var
  Whichfield: string;

begin
  WhichField := dbgMaterials.Columns.Grid.SelectedField.FieldName;

  if WhichField = 'TicketNumber' then
    SelectTicket
  else if WhichField = 'PartCode' then
    SelectPart
  else if WhichField = 'MaterialCode' then
    SelectMaterial;
end;

procedure TfmAnalyse.dbgPartsDblClick(Sender: TObject);
var
  Whichfield: string;

begin
  WhichField := dbgParts.Columns.Grid.SelectedField.FieldName;

  if WhichField = 'TicketNumber' then
    SelectTicket
  else if WhichField = 'PartCode' then
    SelectPart
  else if WhichField = 'MaterialCode' then
    SelectMaterial;
end;

procedure TfmAnalyse.SelectPart;
var
  fmPartDetails: TfmPartDetails;
  Code: string;
  Failed: boolean;

begin
  Code := qAnalyseTicketsPartCode.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Part', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmPartDetails := TfmPartDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;
      if not Failed then
        fmPartDetails.PassPartName(fmPartDetails, Code);
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmAnalyse.SelectMaterial;
var
  Code: string;
  Failed: boolean;
  fmMaterialDetails: TfmMaterialDetails;

begin
  Code := qAnalyseTicketsMaterialCode.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Material', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed:=False;
      try
        fmMaterialDetails := TfmMaterialDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(Self);
        Failed := True;
      end;

      if not Failed then
        fmMaterialDetails.PassMaterialName(fmMaterialDetails, Code)
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmAnalyse.SelectTicket;
var
  TicketCaption, sSequenceNo, sWeekNo, SequenceStr, SplitStr: string;
  SequenceNo, WeekNo, SlashPos: integer;
  Failed: boolean;
  fmTicketsBreakdown: TfmTicketsBreakdown;

begin
  SlashPos := Pos('/', qAnalyseTicketsTicketNumber.Value);
  SplitStr := Copy(qAnalyseTicketsTicketNumber.Value, 0, SlashPos - 1);
  WeekNo := StrToInt(SplitStr);
  SplitStr := qAnalyseTicketsTicketNumber.Value;
  Delete(SplitStr, 1, SlashPos);
  SlashPos := Pos('/', SplitStr);
  SequenceStr := Copy(SplitStr, 0, SlashPos - 1);
  SequenceNo := StrToInt(SequenceStr);

  if (WeekNo > 0) and (WeekNo < 54) then
  begin
    sWeekNo := intToStr(WeekNo);
    sSequenceNo := intToStr(SequenceNo);
    TicketCaption := 'Ticket(s) : ' + sWeekNo + '/' + sSequenceNo + '/xx    ';
    if not ExistingToFront(TicketCaption, '') then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmTicketsBreakdown := TfmTicketsBreakDown.Create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmTicketsBreakdown.PassTicketSequenceReference(fmTicketsBreakdown, WeekNo, SequenceNo);

    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmAnalyse.pcAnalysisChange(Sender: TObject);
begin
{
  if pcAnalysis.ActivePage = pcTabCutters then
    taoAnalyse.Control := dbgCutters
  else if pcAnalysis.ActivePage = pcTabMaterials then
    taoAnalyse.Control := dbgMaterials
  else if pcAnalysis.ActivePage = pcTabParts then
    taoAnalyse.Control := dbgParts;
    }
end;

procedure TfmAnalyse.qCategoryTotalsAfterScroll(DataSet: TDataSet);
begin
  //CJY Refresh not required as only updating filter value
  qAnalyseTickets.filtered := false;

  if pcAnalysis.activePage = pcTabCutters then
  begin
    if not qCategoryTotals.FieldByName('Cutter').isNull then
      qAnalyseTickets.filter := 'Cutter = ''' + qCategoryTotals.FieldByName('Cutter').value + ''''
    else
      qAnalyseTickets.filter := 'Cutter = ''' + '''';
  end
  else if pcAnalysis.activePage = pcTabMaterials then
  begin
    if not qCategoryTotals.FieldByName('MaterialCode').isNull then
      qAnalyseTickets.filter := 'MaterialCode = ''' + qCategoryTotals.FieldByName('MaterialCode').value + ''''
    else
      qAnalyseTickets.filter := 'MaterialCode = ''' + '''';
  end
  else if pcAnalysis.activePage = pcTabParts then
  begin
    if not qCategoryTotals.FieldByName('PartCode').isNull then
      qAnalyseTickets.filter := 'PartCode = ''' + qCategoryTotals.FieldByName('PartCode').value + ''''
    else
      qAnalyseTickets.filter := 'PartCode = ''' + '''';
  end;
  qAnalyseTickets.filtered := true;
end;

procedure TfmAnalyse.qCategoryTotalsCalcFields(DataSet: TDataSet);
var
  CurrentUnitConversion, Divider: real;

begin
  CurrentUnitConversion := MaterialUnits[cbMaterialUnits.ItemIndex].Conversion;
  Divider := CurrentUnitConversion * CurrentUnitConversion;

//These totals must be added up with everything converted to sq ft in case we are adding apples and oranges,
//this converts the total back into the units we want to display in.
  qCategoryTotalsTotalAllowanceInTheseUnits.Value := qCategoryTotalsTotalAllowance.Value / Divider;
  qCategoryTotalsTotalActualUsageInTheseUnits.Value := qCategoryTotalsTotalActualUsage.Value / Divider;
  qCategoryTotalsTotalActualVarInTheseUnits.Value := qCategoryTotalsTotalActualVar.Value / Divider;
end;

procedure TfmAnalyse.pcSetupResultDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

procedure TfmAnalyse.pcAnalysisDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

end.


