unit ParamGeneral;

interface

uses
  Classes, Controls, Forms, Dialogs, StdCtrls, DBCtrls,  
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DBGridPlus, ExtCtrls, Buttons, ComCtrls,  Mask, Db,
  Grids, ToolWin, IniFiles, Types, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, DBGrids, FDConnectionPlus;

type
  TfmParametersGeneral = class(TForm)
    tblParameters: TFDTablePlus;
    dsParameters: TDataSource;
    tblParametersBatchSize: TSmallintField;
    tblParametersTableLength: TFloatField;
    tblTktLabels: TFDTablePlus;
    dsTktlabels: TDataSource;
    tblParametersLinesInLeatherGrid: TSmallintField;
    tblParametersDifficultLeatherFacilty: TBooleanField;
    tblParametersIssuedCutWeek: TStringField;
    tblParametersTicketCostedAlw: TStringField;
    tblParametersSummarisedDetailed: TStringField;
    tblParametersAlwUseErrorCheck: TSmallintField;
    tblParametersPrintCutterValue: TBooleanField;
    tblParametersPrintTagNumbers: TBooleanField;
    tblParametersPrintCustomer: TBooleanField;
    tblMatUnits: TFDTablePlus;
    dsMaterialUnits: TDataSource;
    tblMatUnitsCode: TStringField;
    tblMatUnitsSubUnitDesc: TStringField;
    tblMatUnitsSubUnitsPerUnit: TSmallintField;
    tblMatUnitsUnitDescription: TStringField;
    tblMatUnitsUnitAbbreviation: TStringField;
    tblMatUnitsToFeet: TFloatField;
    tblMatUnitsSubUnitAbbreviation: TStringField;
    tblParametersFeedSystem: TStringField;
    tblParametersRowsInLeatherGrid: TSmallintField;
    tblParametersPrintTimes: TBooleanField;
    tblParametersShowBarcodeNPic: TBooleanField;
    tblParametersStylePicDirectory: TStringField;
    tblParametersOldAudit: TBooleanField;
    tblParametersSaveOutBasic: TStringField;
    tblParametersCompany: TStringField;
    tblParametersTicketsDirectory: TStringField;
    tblParametersCutterPageThrow: TBooleanField;
    tblParametersAutoCreateConstruction: TBooleanField;
    tblParametersAutoDeleteConstruction: TBooleanField;
    fdTitle: TFontDialog;
    fdStandard: TFontDialog;
    tblParametersTitleFontName: TStringField;
    tblParametersTitleFontSize: TIntegerField;
    tblParametersStandardFontName: TStringField;
    tblParametersStandardFontSize: TIntegerField;
    tblParametersTitleFontCharset: TIntegerField;
    tblParametersStandardFontCharset: TIntegerField;
    fdFixed: TFontDialog;
    tblParametersFixedFontName: TStringField;
    tblParametersFixedFontSize: TIntegerField;
    tblParametersFixedFontCharset: TIntegerField;
    LocalConnectionSumms: TFDConnectionPlus;
    tblTktLabelsSeq: TSmallintField;
    tblTktLabelsEnglish: TStringField;
    tblTktLabelsTranslation: TStringField;
    tblParametersAuditPathName: TStringField;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnRefresh: TSpeedButton;
    btnBrowse: TSpeedButton;
    pcParameters: TPageControl;
    tsDirectories: TTabSheet;
    tsCutting: TTabSheet;
    tsAnalysis: TTabSheet;
    tsMatUnits: TTabSheet;
    tsTicketLayout: TTabSheet;
    tsMisc: TTabSheet;
    dbcbNormalAuditFormat: TDBCheckBox;
    tsTicketOptions: TTabSheet;
    dbrgAllowanceType: TDBRadioGroup;
    dbcbSplitTickets: TDBCheckBox;
    lblSplittingScheme: TLabel;
    dbcbCustOnTkt: TDBCheckBox;
    dbcbTagNumbers: TDBCheckBox;
    lblAlwUseCheck: TLabel;
    dbeAlwUseCheck: TDBEdit;
    tsTicketText: TTabSheet;
    dbgTktLabels: TDBGridPlus;
    tblParametersPrintTimesYesNo: TStringField;
    tblParametersMaterialSummaryYesNo: TStringField;
    tblParametersPrintBarCodesYesNo: TStringField;
    lblAllowanceType: TLabel;
    dbrgSplittingScheme: TDBRadioGroup;
    pnlView3: TPanel;
    dbtAlwUseCheck: TDBText;
    tblParametersShowCustomerYesNo: TStringField;
    dbtShowCustomerYesNo: TDBText;
    tblParametersShowtagNumbersYesNo: TStringField;
    tblParametersSplitTicketsYesNo: TStringField;
    dbtSplittingSchemeType: TDBText;
    tblParametersSplittingSchemeType: TStringField;
    dbtTagNumbers: TDBText;
    dbtSplitTickets: TDBText;
    dbtAllowanceType: TDBText;
    tblParametersAllowanceType: TStringField;
    tblParametersDiffLeatherYesNo: TStringField;
    tblParametersAutoCreateConYesNo: TStringField;
    tblParametersAutoDeleteConYesNo: TStringField;
    lblCompanyName: TLabel;
    dbeCompany: TDBEdit;
    tblParametersFeedSystemClipsGantry: TStringField;
    tblParametersPrintMonetaryValueYesNo: TStringField;
    tblParametersCutterPageThrowYesNo: TStringField;
    tblParametersWeekIssuedCut: TStringField;
    tblParametersAllowanceTicketCosted: TStringField;
    tblParametersReportSummarisedDetailed: TStringField;
    tblParametersNormalAuditFormatYesNo: TStringField;
    tsMatTypes: TTabSheet;
    dsMatTypes: TDataSource;
    tblMatTypes: TFDTablePlus;
    tblMatTypesCode: TStringField;
    tblMatTypesDescription: TStringField;
    tblMatTypesAvePairsPerJob: TSmallintField;
    tblMatTypesAveSizes: TSmallintField;
    tblMatTypesRest: TFloatField;
    tblMatTypesContingency: TFloatField;
    dbgMatUnits: TDBGridPlus;
    dbcbDiffLeather: TDBCheckBox;
    dbcbAutoCreateConstruction: TDBCheckBox;
    dbcbAutoDeleteConstruction: TDBCheckBox;
    pnlView10: TPanel;
    dbtCompanyName: TDBText;
    dbtNormalAuditFormat: TDBText;
    dbtDiffLeather: TDBText;
    dbtAutoCreateCon: TDBText;
    dbtAutoDeleteCon: TDBText;
    tsCuttingElements: TTabSheet;
    tblElementTimes: TFDTablePlus;
    dsElements: TDataSource;
    dbgElements: TDBGridPlus;
    tblParametersCADDirectory: TStringField;
    tblParametersSplitTickets: TBooleanField;
    tblParametersSplittingScheme: TSmallintField;
    btnTimeLine: TSpeedButton;
    dbcbSaveAndClearAudit: TDBCheckBox;
    dbtSaveAndClearAudit: TDBText;
    tblParametersClearAuditAfterSave: TBooleanField;
    tblParametersClearAuditAfterSaveYesNo: TStringField;
    tblParametersShowWaste: TBooleanField;
    dbtShowWaste: TDBText;
    tblParametersShowWasteYesNo: TStringField;
    dbcbShowWaste: TDBCheckBox;
    dbcbGroupPrintSyntheticTickets: TDBCheckBox;
    dbcbAutoSyntheticTicketsList: TDBCheckBox;
    tblParametersGroupPrintSyntheticTickets: TBooleanField;
    tblParametersCreateSyntheticTicketsList: TBooleanField;
    tblParametersGroupPrintSyntheticTicketsYesNo: TStringField;
    tblParametersCreateSyntheticTicketsListYesNo: TStringField;
    dbtGroupPrintSyntheticTicketsYesNo: TDBText;
    dbtAutoSyntheticTicketsListYesNo: TDBText;
    tblParametersBAQuadraticA: TFloatField;
    tblParametersBAQuadraticB: TFloatField;
    tblParametersBAQuadraticC: TFloatField;
    tblParametersUpdatedInitialisation: TBooleanField;
    tblParametersInterlockingToleranceInterlock: TSmallintField;
    tblParametersInterlockingToleranceLayplans: TSmallintField;
    lblBatchSize: TLabel;
    dbeBatchSize: TDBEdit;
    dbtBatchSize: TDBText;
    tblParametersMadeInPairsDefault: TBooleanField;
    tblParametersMadeInPairsDefaultYesNo: TStringField;
    dbcbMadeInPairs: TDBCheckBox;
    dbtMadeInPairsYesNo: TDBText;
    tblParametersPatternEfficiency100: TBooleanField;
    tblParametersFixedCutFontName: TStringField;
    tblParametersFixedCutFontSize: TIntegerField;
    tblParametersFixedCutFontCharset: TIntegerField;
    fdFixedCut: TFontDialog;
    tblParametersTitleFontStyle: TStringField;
    tblParametersStandardFontStyle: TStringField;
    tblParametersFixedFontStyle: TStringField;
    tblParametersFixedCutFontStyle: TStringField;
    dbcbShortTagNoOutput: TDBCheckBox;
    dbtShortTagNo: TDBText;
    tblParametersShortTagNoYesNo: TStringField;
    tblParametersShortTagNo: TBooleanField;
    pnlDirectories: TPanel;
    lblTicketsDirectory: TLabel;
    lblCADDirectory: TLabel;
    lblStylePicDirectory: TLabel;
    lblAuditPath: TLabel;
    dbeAuditPath: TDBEdit;
    dbeStylePicDirectory: TDBEdit;
    dbeCADDirectory: TDBEdit;
    dbeTicketsDirectory: TDBEdit;
    pnlView1: TPanel;
    dbtTicketsDirectory: TDBText;
    dbtCADDirectory: TDBText;
    dbtStylePicDirectory: TDBText;
    dbtAuditPath: TDBText;
    pnlTicketLayout: TPanel;
    lblLinesinGrid: TLabel;
    lblRowsinGrid: TLabel;
    dbcbShowTimes: TDBCheckBox;
    dbcbShowBarcodeNPic: TDBCheckBox;
    lblTitleFont: TLabel;
    lblStandardFont: TLabel;
    lblFixedFont: TLabel;
    lblFixedCutFont: TLabel;
    btnFixedCutFont: TSpeedButton;
    btnFixedFont: TSpeedButton;
    btnStandardFont: TSpeedButton;
    btnTitleFont: TSpeedButton;
    pnlView2: TPanel;
    dbtLinesinGrid: TDBText;
    dbtRowsinGrid: TDBText;
    dbtPrintTimesYesNo: TDBText;
    dbPrintBarCodes: TDBText;
    dbtTitleName: TDBText;
    dbtTitleSize: TDBText;
    lblActualTitleScript: TLabel;
    lblActualStandardScript: TLabel;
    dbtStandardSize: TDBText;
    dbtStandardName: TDBText;
    lblFixedScript: TLabel;
    dbtFixedSize: TDBText;
    dbtFixedName: TDBText;
    lblFixedCutScript: TLabel;
    dbtFixedCutSize: TDBText;
    dbtFixedCutName: TDBText;
    dbeColsInLeatherGrid: TDBEdit;
    dbeRowsInLeatherGrid: TDBEdit;
    pnlTicketOptions: TPanel;
    pnlAnalysis: TPanel;
    dbcbCutterPageThrow: TDBCheckBox;
    dbcbPrintCutValue: TDBCheckBox;
    dbrgIssuedCutWeek: TDBRadioGroup;
    dbrgReports: TDBRadioGroup;
    dbrgTicketCostedAlw: TDBRadioGroup;
    lblAllowance: TLabel;
    lblReport: TLabel;
    lblWeek: TLabel;
    pnlView5: TPanel;
    dbtPrintMonetaryValueYesNo: TDBText;
    dbtCutterPageThrowYesNo: TDBText;
    dbtWeekIssuedCut: TDBText;
    dbtAllowanceTicketCosted: TDBText;
    dbtReportSummarisedDetailed: TDBText;
    pnlCutting: TPanel;
    lblTableLength: TLabel;
    lblFeedSystem: TLabel;
    pnlView7: TPanel;
    dbtTableLength: TDBText;
    dbtFeedSystemCG: TDBText;
    dbrgFeedSystem: TDBRadioGroup;
    dbeTableLength: TDBEdit;
    pnlMisc: TPanel;
    tblElements: TFDTablePlus;
    tblElementsCode: TStringField;
    tblElementsDescription: TStringField;
    tblElementsCuttingCategory: TStringField;
    tblElementTimesCode: TStringField;
    tblElementTimesTime: TFloatField;
    tblElementTimesDescription: TStringField;
    tblParametersPressTypeLeather: TStringField;
    tblParametersPressTypeSynthetic: TStringField;
    Panel1: TPanel;
    dbgMatTypes: TDBGridPlus;
    pnlPressesLeather: TPanel;
    pnlView6: TPanel;
    dbtCuttingTypeLeather: TDBText;
    dbtCuttingTypeSynthetic: TDBText;
    dbrgPressTypeLeather: TDBRadioGroup;
    dbrgPressTypeSynthetic: TDBRadioGroup;
    lblPressTypeSynthetic: TLabel;
    lblPressTypeLeather: TLabel;
    tblParametersPressTypeLeatherDesc: TStringField;
    tblParametersPressTypeSyntheticDesc: TStringField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tblTktLabelsBeforeInsert(DataSet: TDataSet);
    procedure tblTktLabelsBeforeDelete(DataSet: TDataSet);
    procedure tblMatUnitsBeforeDelete(DataSet: TDataSet);
    procedure tblMatUnitsBeforeEdit(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure tblParametersBeforePost(DataSet: TDataSet);
    procedure btnTitleFontClick(Sender: TObject);
    function CharsetName(Charset:integer):string;
    procedure btnStandardFontClick(Sender: TObject);
    procedure btnFixedFontClick(Sender: TObject);
    procedure dbcbSplitTicketsClick(Sender: TObject);
    procedure tblParametersCalcFields(DataSet: TDataSet);
    procedure eAnyEnter(Sender: TObject);
    procedure eAnyExit(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure UpdateScreen(Editing : boolean);
    procedure tblMatTypesBeforeInsert(DataSet: TDataSet);
    procedure tblMatTypesBeforeDelete(DataSet: TDataSet);
    procedure pcParametersChange(Sender: TObject);
    procedure tblElementTimesBeforeInsert(DataSet: TDataSet);
    procedure tblElementTimesBeforeDelete(DataSet: TDataSet);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure Pass;
    procedure SetTabStops(Editing: Boolean);
    procedure dbgMatUnitsKeyPress(Sender: TObject; var Key: Char);
    procedure btnTimeLineClick(Sender: TObject);
    procedure tblMatTypesBeforeOpen(DataSet: TDataSet);
    procedure pcParametersDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure btnFixedCutFontClick(Sender: TObject);
  private
    { Private declarations }
    BrowseNum : shortint;
    TimeLineAliasExists: Boolean;
  public
    { Public declarations }
  end;

var
  fmParametersGeneral: TfmParametersGeneral;

implementation

uses
  SysUtils, Graphics, Summs, DirBrowse, General, CmnVars, SummsVars,
  ImportTimeLineElements, OutOfMemory;

{$R *.DFM}

procedure TfmParametersGeneral.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if tblParameters.state in [dsEdit, dsInsert] then
  begin
    if MessageDlgPos('Save Changes to Parameters?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
      btnSave.click
    else
      btnCancel.click;
  end;

  action := caFree;
end;

procedure TfmParametersGeneral.tblTktLabelsBeforeInsert(DataSet: TDataSet);
begin
  abort;
end;

procedure TfmParametersGeneral.tblTktLabelsBeforeDelete(DataSet: TDataSet);
begin
  abort;
end;

procedure TfmParametersGeneral.tblMatUnitsBeforeDelete(DataSet: TDataSet);
begin
  if (tblMatUnitsCode.value = 'FT') or (tblMatUnitsCode.value = 'M') then
  begin
    MessageDlgPos('Cannot delete system units', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    abort;
  end;
end;

procedure TfmParametersGeneral.tblMatUnitsBeforeEdit(DataSet: TDataSet);
begin
  if (tblMatUnitsCode.value = 'FT') or (tblMatUnitsCode.value = 'M') then
  begin
    MessageDlgPos('Cannot change system units', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    abort;
  end;
end;

procedure TfmParametersGeneral.FormCreate(Sender: TObject);
var
  AdsINI: TINIFile;

begin
  AutoColor(Self);

  AdsINI := TIniFile.Create('ADS.INI');
  TimeLineAliasExists := (AdsINI.ReadString('Databases', 'TIMELINE2', 'INVALID') <> 'INVALID');
  AdsINI.Free;

  if (not Option_ProductionSystem) or (not Option_Synthetics) then
  begin
    dbcbGroupPrintSyntheticTickets.Enabled := false;
    dbtGroupPrintSyntheticTicketsYesNo.Enabled := false;

    dbcbAutoSyntheticTicketsList.Enabled := false;
    dbtAutoSyntheticTicketsListYesNo.Enabled := false;
  end;

  if not Option_ProductionSystem then
  begin
    lblTicketsDirectory.enabled := False;
    dbtTicketsDirectory.enabled := False;
    dbeTicketsDirectory.enabled := False;

    tsTicketLayout.enabled := False;
    lblLinesInGrid.enabled := False;
    dbtLinesInGrid.enabled := False;
    dbeColsInLeatherGrid.enabled := False;
    lblRowsInGrid.enabled := False;
    dbtRowsInGrid.enabled := False;
    dbeRowsInLeatherGrid.enabled := False;
    dbcbShowTimes.enabled := False;
    dbtPrintTimesYesNo.enabled := False;
    dbcbShowBarcodeNPic.enabled := False;
    dbPrintBarCodes.enabled := False;
    lblTitleFont.enabled := False;
    btnTitleFont.enabled := False;
    dbtTitleName.enabled := False;
    dbtTitleSize.enabled := False;
    lblActualTitleScript.enabled := False;
    lblStandardFont.enabled := False;
    btnStandardFont.enabled := False;
    dbtStandardName.enabled := False;
    dbtStandardSize.enabled := False;
    lblActualStandardScript.enabled := False;
    lblFixedFont.enabled := False;
    btnFixedFont.enabled := False;
    dbtFixedName.enabled := False;
    dbtFixedSize.enabled := False;
    lblFixedScript.enabled := False;
    lblFixedCutFont.enabled := False;
    btnFixedCutFont.enabled := False;
    dbtFixedCutName.enabled := False;
    dbtFixedCutSize.enabled := False;
    lblFixedCutScript.enabled := False;

    dbcbCustOnTkt.enabled := False;
    dbtShowCustomerYesNo.enabled := False;
    dbcbTagNumbers.enabled := False;
    dbtTagNumbers.enabled := False;
    dbcbSplitTickets.enabled := False;
    dbtSplitTickets.enabled := False;
    lblSplittingScheme.enabled := False;
    dbtSplittingSchemeType.enabled := False;
    dbrgSplittingScheme.enabled := False;
    lblAlwUseCheck.enabled := False;
    dbtAlwUseCheck.enabled := False;
    dbeAlwUseCheck.enabled := False;
    lblAllowanceType.enabled := False;
    dbtAllowanceType.enabled := False;
    dbrgAllowanceType.enabled := False;

    dbgTKtlabels.enabled := False;

    lblWeek.enabled := False;
    dbtWeekIssuedCut.enabled := False;
    dbrgIssuedCutWeek.enabled := False;
    lblAllowance.enabled := False;
    dbtAllowanceTicketCosted.enabled := False;
    dbrgTicketCostedAlw.enabled := False;
    lblReport.enabled := False;
    dbtReportSummarisedDetailed.enabled := False;
    dbrgReports.enabled := False;
    dbcbPrintCutValue.enabled := False;
    dbtPrintMonetaryValueYesNo.enabled := False;
    dbcbCutterPageThrow.enabled := False;
    dbtCutterPageThrowYesNo.enabled := False;
  end;

  if not Option_CuttingTimes then
  begin
    lblFeedSystem.Enabled := false;
    dbrgFeedSystem.Enabled := false;
    dbtFeedSystemCG.Enabled := false;

    lblTableLength.enabled := false;
    dbeTableLength.enabled := false;
    dbtTableLength.enabled := false;

    dbcbShowTimes.enabled := false;
    dbtPrintTimesYesNo.enabled := false;

    dbgElements.enabled := false;

    dbgMatTypes.Columns[3].ReadOnly := True;
    dbgMatTypes.Columns[4].ReadOnly := True;
  end;

  if Option_ProductionSystem then
  begin
    lblSplittingScheme.enabled := dbcbSplitTickets.checked;
    dbrgSplittingScheme.enabled := dbcbSplitTickets.checked;
    dbtSplittingSchemeType.enabled := dbcbSplitTickets.checked;
  end;

  if not Option_SinglesAllowed then
  begin
    dbcbMadeInPairs.visible := False;
    dbtMadeInPairsYesNo.visible := False;
  end;

  if Option_CuttingTimes and TimeLineAliasExists then
    btnTimeLine.enabled := True
  else
    btnTimeLine.enabled := False;

  dbgMatTypes.columns[1].Title.Caption := PairsWord;

  SetTabStops(False);
end;

procedure TfmParametersGeneral.tblParametersBeforePost(DataSet: TDataSet);
begin
  if (tblParametersRowsInLeatherGrid.value mod 2 = 0) and
     (tblParametersRowsInLeatherGrid.value > 2) then
    tblParametersRowsInLeatherGrid.value := tblParametersRowsInLeatherGrid.value - 1;
end;

procedure TfmParametersGeneral.btnTitleFontClick(Sender: TObject);
begin
  fdTitle.Font.Name := tblParametersTitleFontName.value;
  fdTitle.Font.Size := tblParametersTitleFontSize.value;
  fdTitle.Font.Charset := tblParametersTitleFontCharset.value;
  fdTitle.Font.Style := FontStyle(tblParametersTitleFontStyle.value);
  lblActualTitleScript.caption := CharsetName(fdTitle.Font.Charset) + ' ' + tblParametersTitleFontStyle.Value;

  if fdTitle.Execute then
  begin
    tblParametersTitleFontName.value := fdTitle.Font.Name;
    tblParametersTitleFontSize.value := fdTitle.Font.Size;
    tblParametersTitleFontCharset.value := fdTitle.Font.Charset;
    tblParametersTitleFontStyle.value := FontStyleString(fdTitle.Font.Style);
    lblActualTitleScript.caption := charsetName(fdTitle.Font.Charset) + ' ' + tblParametersTitleFontStyle.Value;
  end;
end;

procedure TfmParametersGeneral.btnStandardFontClick(Sender: TObject);
begin
  fdStandard.Font.Name := tblParametersStandardFontName.value;
  fdStandard.Font.Size := tblParametersStandardFontSize.value;
  fdStandard.Font.Charset := tblParametersStandardFontCharset.value;
  fdStandard.Font.Style := FontStyle(tblParametersStandardFontStyle.value);
  lblActualStandardScript.caption := CharsetName(fdStandard.Font.Charset) + ' ' + tblParametersStandardFontStyle.Value;

  if fdStandard.Execute then
  begin
    tblParametersStandardFontName.value := fdStandard.Font.Name;
    tblParametersStandardFontSize.value := fdStandard.Font.Size;
    tblParametersStandardFontCharset.value := fdStandard.Font.Charset;
    tblParametersStandardFontStyle.value := FontStyleString(fdStandard.Font.Style);
    lblActualStandardScript.caption := charsetName(fdStandard.Font.Charset) + ' ' + tblParametersStandardFontStyle.Value;
  end;
end;

procedure TfmParametersGeneral.btnFixedFontClick(Sender: TObject);
begin
  fdFixed.Font.Name := tblParametersFixedFontName.value;
  fdFixed.Font.Size := tblParametersFixedFontSize.value;
  fdFixed.Font.Charset := tblParametersFixedFontCharset.value;
  fdFixed.Font.Style := FontStyle(tblParametersFixedFontStyle.value);
  lblFixedScript.caption := CharsetName(fdFixed.Font.Charset) + ' ' + tblParametersFixedFontStyle.Value;

  if fdFixed.Execute then
  begin
    tblParametersFixedFontName.value := fdFixed.Font.Name;
    tblParametersFixedFontSize.value := fdFixed.Font.Size;
    tblParametersFixedFontCharset.value := fdFixed.Font.Charset;
    tblParametersFixedFontStyle.value := FontStyleString(fdFixed.Font.Style);
    lblFixedScript.caption := charsetName(fdFixed.Font.Charset) + ' ' + tblParametersFixedFontStyle.Value;
  end;
end;

procedure TfmParametersGeneral.btnFixedCutFontClick(Sender: TObject);
begin
  fdFixedCut.Font.Name := tblParametersFixedCutFontName.value;
  fdFixedCut.Font.Size := tblParametersFixedCutFontSize.value;
  fdFixedCut.Font.Charset := tblParametersFixedCutFontCharset.value;
  fdFixedCut.Font.Style := FontStyle(tblParametersFixedCutFontStyle.value);
  lblFixedCutScript.caption := CharsetName(fdFixedCut.Font.Charset) + ' ' + tblParametersFixedCutFontStyle.Value;

  if fdFixedCut.Execute then
  begin
    tblParametersFixedCutFontName.value := fdFixedCut.Font.Name;
    tblParametersFixedCutFontSize.value := fdFixedCut.Font.Size;
    tblParametersFixedCutFontCharset.value := fdFixedCut.Font.Charset;
    tblParametersFixedCutFontStyle.value := FontStyleString(fdFixedCut.Font.Style);
    lblFixedCutScript.caption := charsetName(fdFixedCut.Font.Charset) + ' ' + tblParametersFixedCutFontStyle.Value;
  end;
end;

function TfmParametersGeneral.CharsetName(Charset: integer): string;
begin
  case Charset of
      0 : Result := 'Western';
      1 : Result := 'Default';
      2 : Result := 'Symbol';
     77 : Result := 'Mac';
    128 : Result := 'Japanese';
    129 : Result := 'Korean (Wansung)';
    130 : Result := 'Korean (Johab)';
    134 : Result := 'Simplified Chinese';
    136 : Result := 'Taiwanese';
    161 : Result := 'Greek';
    162 : Result := 'Turkish';
    163 : Result := 'Vietnamese';
    177 : Result := 'Hebrew';
    178 : Result := 'Arabic';
    186 : Result := 'Baltic';
    204 : Result := 'Cyrillic';
    222 : Result := 'Thai';
    238 : Result := 'Central European';
    255 : Result := 'OEM/DOS';
  end;
end;

procedure TfmParametersGeneral.dbcbSplitTicketsClick(Sender: TObject);
begin
  if Option_ProductionSystem then
  begin
    lblSplittingScheme.enabled := dbcbSplitTickets.checked;
    dbrgSplittingScheme.enabled := dbcbSplitTickets.checked;
    dbtSplittingSchemeType.enabled := dbcbSplitTickets.checked;
  end;
end;

procedure TfmParametersGeneral.tblParametersCalcFields(DataSet: TDataSet);
begin
  if tblParametersPrintTimes.value then
    tblParametersPrintTimesYesNo.value := 'Yes'
  else
    tblParametersPrintTimesYesNo.value := 'No';

  if tblParametersShowBarCodeNPic.value then
    tblParametersPrintBarCodesYesNo.value := 'Yes'
  else
    tblParametersPrintBarCodesYesNo.value := 'No';

  if tblParametersPrintCustomer.value then
    tblParametersShowCustomerYesNo.value := 'Yes'
  else
    tblParametersShowCustomerYesNo.value := 'No';

  if tblParametersPrintTagNumbers.value then
    tblParametersShowTagNumbersYesNo.value := 'Yes'
  else
    tblParametersShowTagNumbersYesNo.value := 'No';

  if tblParametersSplitTickets.value then
    tblParametersSplitTicketsYesNo.value := 'Yes'
  else
    tblParametersSplitTicketsYesNo.value := 'No';

  if tblParametersSplittingScheme.value = 0 then
    tblParametersSplittingSchemeType.value := 'Consecutive Sizes'
  else if tblParametersSplittingScheme.value = 1 then
    tblParametersSplittingSchemeType.value := 'Consecutive Sizes with Size Relationship split';

  if tblParametersSaveOutBasic.value = '0' then
    tblParametersAllowanceType.value := 'Basic'
  else if tblParametersSaveOutBasic.value = '1' then
    tblParametersAllowanceType.value := 'Grid @ Material Area/Quality Coefficient';

  if tblParametersDifficultLeatherFacilty.value then
    tblParametersDiffLeatherYesNo.value := 'Yes'
  else
    tblParametersDiffLeatherYesNo.value := 'No';

  if tblParametersAutoCreateConstruction.value then
    tblParametersAutoCreateConYesNo.value := 'Yes'
  else
    tblParametersAutoCreateConYesNo.value := 'No';

  if tblParametersAutoDeleteConstruction.value then
    tblParametersAutoDeleteConYesNo.value := 'Yes'
  else
    tblParametersAutoDeleteConYesNo.value := 'No';

  if tblParametersFeedSystem.value = 'C' then
    tblParametersFeedSystemClipsGantry.value := 'Clips'
  else if tblParametersFeedSystem.value = 'G' then
    tblParametersFeedSystemClipsGantry.value := 'Gantry';

  if tblParametersPrintCutterValue.value then
    tblParametersPrintMonetaryValueYesNo.value := 'Yes'
  else
    tblParametersPrintMonetaryValueYesNo.value := 'No';

  if tblParametersCutterPageThrow.value then
    tblParametersCutterPageThrowYesNo.value := 'Yes'
  else
    tblParametersCutterPageThrowYesNo.value := 'No';

  if tblParametersIssuedCutWeek.value = '0' then
    tblParametersWeekIssuedCut.value := 'Issued'
  else if tblParametersIssuedCutWeek.value = '1' then
    tblParametersWeekIssuedCut.value := 'Cut';

  if tblParametersTicketCostedAlw.value = '0' then
    tblParametersAllowanceTicketCosted.value := 'Ticket'
  else if tblParametersTicketCostedAlw.value = '1' then
    tblParametersAllowanceTicketCosted.value := 'Costed';

  if tblParametersSummarisedDetailed.value = '0' then
    tblParametersReportSummarisedDetailed.value := 'Summarised'
  else if tblParametersSummarisedDetailed.value = '1' then
    tblParametersReportSummarisedDetailed.value := 'Detailed';

  if tblParametersOldAudit.value then
    tblParametersNormalAuditFormatYesNo.value := 'Yes'
  else
    tblParametersNormalAuditFormatYesNo.value := 'No';

  if tblParametersShortTagNo.value then
    tblParametersShortTagNoYesNo.value := 'Yes'
  else
    tblParametersShortTagNoYesNo.value := 'No';

  if tblParametersClearAuditAfterSave.value then
    tblParametersClearAuditAfterSaveYesNo.value := 'Yes'
  else
    tblParametersClearAuditAfterSaveYesNo.value := 'No';

  if tblParametersShowWaste.value then
    tblParametersShowWasteYesNo.value := 'Yes'
  else
    tblParametersShowWasteYesNo.value := 'No';

  if tblParametersGroupPrintSyntheticTickets.value then
    tblParametersGroupPrintSyntheticTicketsYesNo.value := 'Yes'
  else
    tblParametersGroupPrintSyntheticTicketsYesNo.value := 'No';

  if tblParametersCreateSyntheticTicketsList.value then
    tblParametersCreateSyntheticTicketsListYesNo.value := 'Yes'
  else
    tblParametersCreateSyntheticTicketsListYesNo.value := 'No';

  if tblParametersMadeInPairsDefault.value then
    tblParametersMadeInPairsDefaultYesNo.value := 'Yes'
  else
    tblParametersMadeInPairsDefaultYesNo.value := 'No';

  if tblParametersPressTypeLeather.value = 'S' then
    tblParametersPressTypeLeatherDesc.value := dbrgPressTypeLeather.Items[0]
  else if tblParametersPressTypeLeather.value = 'P' then
    tblParametersPressTypeLeatherDesc.value := dbrgPressTypeLeather.Items[1]
  else if tblParametersPressTypeLeather.value = 'T' then
    tblParametersPressTypeLeatherDesc.value := dbrgPressTypeLeather.Items[2];

  if tblParametersPressTypeSynthetic.value = 'P' then
    tblParametersPressTypeSyntheticDesc.value := dbrgPressTypeSynthetic.Items[0]
  else if tblParametersPressTypeSynthetic.value = 'T' then
    tblParametersPressTypeSyntheticDesc.value := dbrgPressTypeSynthetic.Items[1];
end;

procedure TfmParametersGeneral.eAnyEnter(Sender: TObject);
begin
  btnBrowse.enabled := True;

  if (Sender as TControl).Name = dbeTicketsDirectory.Name then
  begin
    BrowseNum := 1;
    btnBrowse.Hint := 'Browse Tickets Directory';
  end
  else if (Sender as TControl).Name = dbeCADDirectory.Name then
  begin
    BrowseNum := 2;
    btnBrowse.Hint := 'Browse Pattern File Directory';
  end
  else if (Sender as TControl).Name = dbeStylePicDirectory.Name then
  begin
    BrowseNum := 3;
    btnBrowse.Hint := 'Browse Style Pictures Directory';
  end
  else if (Sender as TControl).Name = dbeAuditPath.Name then
  begin
    BrowseNum := 4;
    btnBrowse.Hint := 'Browse Audit Path Directory';
  end;
end;

procedure TfmParametersGeneral.eAnyExit(Sender: TObject);
begin
  btnBrowse.enabled := False;
end;

procedure TfmParametersGeneral.btnBrowseClick(Sender: TObject);
var
  Dir: string;

begin
  case BrowseNum of
    1 : Dir := tblParametersTicketsDirectory.Value;
    2 : Dir := tblParametersCADDirectory.Value;
    3 : Dir := tblParametersStylePicDirectory.Value;
    4 : Dir := tblParametersAuditPathName.Value;
  end;

  fmBrowseDirectories.BrowseInfo(Dir);
  if (fmBrowseDirectories.ShowModal = mrOK) then
  begin
    case BrowseNum of
      1 : tblParametersTicketsDirectory.Value := fmBrowseDirectories.dlbBrowse.Directory;
      2 : tblParametersCADDirectory.Value := fmBrowseDirectories.dlbBrowse.Directory;
      3 : tblParametersStylePicDirectory.Value := fmBrowseDirectories.dlbBrowse.Directory;
      4 : tblParametersAuditPathName.Value := fmBrowseDirectories.dlbBrowse.Directory;
    end;
  end;
end;

procedure TfmParametersGeneral.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmParametersGeneral.btnEditClick(Sender: TObject);
var
  LockSuccess : boolean;

begin
  LocalConnectionSumms.StartTransaction;

  //Attempt Lock
  LockSuccess := LockSingleOption(oParameters, tblParameters);

  if LockSuccess then
    UpdateScreen(True)
  else
    LocalConnectionSumms.Rollback;
end;

procedure TfmParametersGeneral.btnSaveClick(Sender: TObject);
begin
  if tblTktLabels.active and (tblTktLabels.state in [dsEdit, dsInsert]) then
    tblTktLabels.post;
  if tblMatUnits.active and (tblMatUnits.state in [dsEdit, dsInsert]) then
    tblMatUnits.post;
  if tblMatTypes.active and (tblMatTypes.state in [dsEdit, dsInsert]) then
    tblMatTypes.post;
  if tblElementTimes.active and (tblElementTimes.state in [dsEdit, dsInsert]) then
    tblElementTimes.post;
  tblParameters.post;

  LocalConnectionSumms.commit;
  UpdateScreen(False);

  //Opening sets all Parameters
  try
    fmSumms.qParameters.open;
    fmSumms.qParameters.close;
  except
  end;

  //Need an 'if changed ' here...
  fmSumms.qTicketLabels.open;
  fmSumms.qTicketLabels.close;

  //& Reopen Material Defaults (Need 'if changed' here too...)
  fmSumms.qMaterialUnits.close;
  fmSumms.qMaterialUnits.open;
end;

procedure TfmParametersGeneral.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblTktLabels.cancel;
  tblMatUnits.cancel;
  tblMatTypes.cancel;
  tblElementTimes.cancel;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock (& Non saved edits)
  tblParameters.cancel;

  //Refresh Grids
  if tblTktLabels.active then
  begin
    tblTktLabels.refresh;
    dbgTktLabels.refresh;
  end;
  if tblMatUnits.active then
  begin
    tblMatUnits.refresh;
    dbgMatUnits.refresh;
  end;
  if tblMatTypes.active then
  begin
    tblMatTypes.refresh;
    dbgMatTypes.refresh;
  end;
  if tblElementTimes.active then
  begin
    tblElementTimes.refresh;
    dbgElements.refresh;
  end;

  UpdateScreen(False);
end;

procedure TfmParametersGeneral.btnRefreshClick(Sender: TObject);
begin
  tblParameters.refresh;

  if tblTktLabels.active then
    tblTktLabels.refresh;
  if tblMatUnits.active then
    tblMatUnits.refresh;
  if tblMatTypes.active then
    tblMatTypes.refresh;
  if tblElementTimes.active then
    tblElementTimes.refresh;
end;

procedure TfmParametersGeneral.UpdateScreen(Editing : boolean);
begin
  if Option_CuttingTimes then
    dbgElements.Columns[2].ReadOnly := not Editing;

  if Editing then
  begin
    if Option_ProductionSystem then
    begin
      dbgTktLabels.Options := dbgTktLabels.Options + [dgEditing];
      dbgTktLabels.Color := clEditing;
      dbgTktLabels.Columns.Items[1].Color := clEditing;
    end;

    dbcbCustOnTkt.ReadOnly := False;
    dbcbTagNumbers.ReadOnly := False;
    dbcbSplitTickets.ReadOnly := False;
    dbcbShowTimes.ReadOnly := False;
    dbcbShowBarcodeNPic.ReadOnly := False;
    dbcbPrintCutValue.ReadOnly := False;
    dbcbCutterPageThrow.ReadOnly := False;
    dbcbNormalAuditFormat.ReadOnly := False;
    dbcbShortTagNoOutput.ReadOnly := False;
    dbcbSaveAndClearAudit.ReadOnly := False;
    dbcbDiffLeather.ReadOnly := False;
    dbcbAutoCreateConstruction.ReadOnly := False;
    dbcbAutoDeleteConstruction.ReadOnly := False;
    dbcbShowWaste.ReadOnly := False;
    dbcbGroupPrintSyntheticTickets.ReadOnly := False;
    dbcbAutoSyntheticTicketsList.ReadOnly := False;
    dbcbMadeInPairs.ReadOnly := False;

    dbgMatUnits.Options := dbgMatUnits.Options + [dgEditing];
    dbgMatUnits.color := clEditing;
    dbgMatUnits.Columns[0].color := clEditing;
    dbgMatUnits.Columns[1].color := clEditing;
    dbgMatUnits.Columns[2].color := clEditing;
    dbgMatUnits.Columns[3].color := clEditing;
    dbgMatUnits.Columns[4].color := clEditing;
    dbgMatUnits.Columns[5].color := clEditing;
    dbgMatUnits.Columns[6].color := clEditing;

    dbgMatTypes.Options := dbgMatTypes.Options + [dgEditing];
    dbgMatTypes.color := clEditing;
    dbgMatTypes.Columns[1].color := clEditing;
    dbgMatTypes.Columns[2].color := clEditing;
    dbgMatTypes.Columns[3].color := clEditing;
    dbgMatTypes.Columns[4].color := clEditing;

    if Option_CuttingTimes then
    begin
      dbgElements.Options := dbgElements.Options + [dgEditing];
      dbgElements.color := clEditing;
      dbgElements.Columns[2].color := clEditing;
    end;

    tbMain.color := clEditing;
  end
  else
  begin
    if Option_ProductionSystem then
    begin
      dbgTktLabels.Options := dbgTktLabels.Options - [dgEditing];
      dbgTktLabels.Color := clBack;
      dbgTktLabels.Columns.Items[1].Color := clBack;
    end;

    dbcbCustOnTkt.ReadOnly := True;
    dbcbTagNumbers.ReadOnly := True;
    dbcbSplitTickets.ReadOnly := True;
    dbcbShowTimes.ReadOnly := True;
    dbcbShowBarcodeNPic.ReadOnly := True;
    dbcbPrintCutValue.ReadOnly := True;
    dbcbCutterPageThrow.ReadOnly := True;
    dbcbNormalAuditFormat.ReadOnly := True;
    dbcbShortTagNoOutput.ReadOnly := True;
    dbcbSaveAndClearAudit.ReadOnly := True;
    dbcbDiffLeather.ReadOnly := True;
    dbcbAutoCreateConstruction.ReadOnly := True;
    dbcbAutoDeleteConstruction.ReadOnly := True;
    dbcbShowWaste.ReadOnly := True;
    dbcbGroupPrintSyntheticTickets.ReadOnly := True;
    dbcbAutoSyntheticTicketsList.ReadOnly := True;
    dbcbMadeInPairs.ReadOnly := True;

    dbgMatUnits.Options := dbgMatUnits.Options - [dgEditing];
    dbgMatUnits.color := clBack;
    dbgMatUnits.Columns[0].color := clBack;
    dbgMatUnits.Columns[1].color := clBack;
    dbgMatUnits.Columns[2].color := clBack;
    dbgMatUnits.Columns[3].color := clBack;
    dbgMatUnits.Columns[4].color := clBack;
    dbgMatUnits.Columns[5].color := clBack;
    dbgMatUnits.Columns[6].color := clBack;

    dbgMatTypes.Options := dbgMatTypes.Options - [dgEditing];
    dbgMatTypes.color := clBack;
    dbgMatTypes.Columns[1].color := clBack;
    dbgMatTypes.Columns[2].color := clBack;
    dbgMatTypes.Columns[3].color := clBack;
    dbgMatTypes.Columns[4].color := clBack;

    if Option_CuttingTimes then
    begin
      dbgElements.Options := dbgElements.Options - [dgEditing];
      dbgElements.color := clBack;
      dbgElements.Columns[2].color := clBack;
    end;

    tbMain.color := clBack;
  end;

  //Stops Odd colouring (& failure of above to stop
  //editing until current record exited) if in
  //Editing - not posted - then save
  if Option_ProductionSystem then
  begin
    dbgTktLabels.enabled := false;
    dbgTktLabels.enabled := true;
  end;
  dbgMatUnits.enabled := false;
  dbgMatUnits.enabled := true;
  dbgMatTypes.enabled := false;
  dbgMatTypes.enabled := true;
  if Option_CuttingTimes then
  begin
    dbgElements.enabled := false;
    dbgElements.enabled := true;
  end;

  btnEdit.enabled := not Editing;
  btnSave.enabled := Editing;
  btnCancel.enabled := Editing;
  btnRefresh.enabled := not Editing;
  if Option_CuttingTimes and TimeLineAliasExists then
    btnTimeLine.enabled := not Editing
  else
    btnTimeLine.enabled := False;

  pnlView1.visible := not Editing;
  pnlView2.visible := not Editing;
  pnlView3.visible := not Editing;
  pnlView5.visible := not Editing;
  pnlView6.visible := not Editing;
  pnlView7.visible := not Editing;
  pnlView10.visible := not Editing;

  SetTabStops(Editing);

  if not Editing then
    btnBrowse.enabled := false;
  btnTitleFont.visible := Editing;
  btnStandardFont.visible := Editing;
  btnFixedFont.visible := Editing;
  btnFixedCutFont.visible := Editing;

  if (dbeAuditPath.Focused or dbeCADDirectory.Focused or
      dbeStylePicDirectory.Focused or dbeTicketsDirectory.Focused) and Editing then
    eAnyEnter(ActiveControl)
  else
    btnBrowse.enabled := False;

  if not Editing then
    tbMain.setFocus;
end;

procedure TfmParametersGeneral.tblMatTypesBeforeInsert(DataSet: TDataSet);
begin
  abort;
end;

procedure TfmParametersGeneral.tblMatTypesBeforeDelete(DataSet: TDataSet);
begin
  abort;
end;

procedure TfmParametersGeneral.pcParametersChange(Sender: TObject);
begin
  if (pcParameters.ActivePage = tsTicketText) then
  begin
    if not tblTktLabels.active then
      tblTktLabels.open;
  end
  else if (pcParameters.ActivePage = tsMatTypes) then
  begin
    if not tblMatTypes.active then
      tblMatTypes.open;
  end
  else if (pcParameters.ActivePage = tsMatUnits) then
  begin
    if not tblMatUnits.active then
      tblMatUnits.open;
  end
  else if (pcParameters.ActivePage = tsCuttingElements) then
  begin
    if not tblElementTimes.active then
      tblElementTimes.open;
  end
  else if (pcParameters.ActivePage = tsTicketLayout) then
  begin
    lblActualTitleScript.caption := CharsetName(tblParametersTitleFontCharset.Value) + ' ' + tblParametersTitleFontStyle.Value;
    lblActualStandardScript.caption := CharsetName(tblParametersStandardFontCharset.Value) + ' ' + tblParametersStandardFontStyle.Value;
    lblFixedScript.caption := CharsetName(tblParametersFixedFontCharset.Value) + ' ' + tblParametersFixedFontStyle.Value;
    lblFixedCutScript.caption := CharsetName(tblParametersFixedCutFontCharset.Value) + ' ' + tblParametersFixedCutFontStyle.Value;
  end;
end;

procedure TfmParametersGeneral.tblElementTimesBeforeInsert(DataSet: TDataSet);
begin
  abort;
end;

procedure TfmParametersGeneral.tblElementTimesBeforeDelete(DataSet: TDataSet);
begin
  abort;
end;

procedure TfmParametersGeneral.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmParametersGeneral.Pass;
begin
  tblParameters.open;
end;

procedure TfmParametersGeneral.SetTabStops(Editing: Boolean);
begin
  dbeTicketsDirectory.TabStop := Editing;
  dbeCADDirectory.TabStop := Editing;
  dbeStylePicDirectory.TabStop := Editing;
  dbeAuditPath.TabStop := Editing;
  dbeColsInLeatherGrid.TabStop := Editing;
  dbeRowsInLeatherGrid.TabStop := Editing;
  dbcbShowTimes.TabStop := Editing;
  dbcbShowBarcodeNPic.TabStop := Editing;
  dbcbCustOnTkt.TabStop := Editing;
  dbcbTagNumbers.TabStop := Editing;
  dbcbSplitTickets.TabStop := Editing;
  dbrgSplittingScheme.TabStop := Editing;
  dbrgSplittingScheme.visible := Editing; //Radio Group TabStop status doesn't work
  dbeAlwUseCheck.TabStop := Editing;
  dbrgAllowanceType.TabStop := Editing;
  dbrgAllowanceType.visible := Editing;   //Radio Group TabStop status doesn't work
  dbrgIssuedCutWeek.TabStop := Editing;
  dbrgIssuedCutWeek.visible := Editing;   //Radio Group TabStop status doesn't work
  dbrgTicketCostedAlw.TabStop := Editing;
  dbrgTicketCostedAlw.visible := Editing; //Radio Group TabStop status doesn't work
  dbrgReports.TabStop := Editing;
  dbrgReports.visible := Editing;         //Radio Group TabStop status doesn't work
  dbcbPrintCutValue.TabStop := Editing;
  dbcbCutterPageThrow.TabStop := Editing;
  dbrgFeedSystem.TabStop := Editing;
  dbrgFeedSystem.visible := Editing;      //Radio Group TabStop status doesn't work
  dbeBatchSize.TabStop := Editing;
  dbeTableLength.TabStop := Editing;
  dbeCompany.TabStop := Editing;
  dbcbNormalAuditFormat.TabStop := Editing;
  dbcbShortTagNoOutput.TabStop := Editing;
  dbcbSaveAndClearAudit.TabStop := Editing;
  dbcbDiffLeather.TabStop := Editing;
  dbcbAutoCreateConstruction.TabStop := Editing;
  dbcbAutoDeleteConstruction.TabStop := Editing;
  dbcbShowWaste.TabStop := Editing;
  dbcbGroupPrintSyntheticTickets.TabStop := Editing;
  dbcbAutoSyntheticTicketsList.TabStop := Editing;
end;

procedure TfmParametersGeneral.dbgMatUnitsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (dbgMatUnits.SelectedField.Fieldname = 'Code') then
    Key := upcase(Key);
end;

procedure TfmParametersGeneral.btnTimeLineClick(Sender: TObject);
var
  LockSuccess : boolean;

begin
  LocalConnectionSumms.StartTransaction;

  //Attempt Lock
  LockSuccess := LockSingleOption(oParameters, tblParameters);

  if LockSuccess then
    fmImportTimeLineElements.showModal;

  LocalConnectionSumms.Rollback;
end;

procedure TfmParametersGeneral.tblMatTypesBeforeOpen(DataSet: TDataSet);
begin
  if (not Option_Leather) then
  begin
    tblMatTypes.Filter := '(Code <> ''L'') and (Code <> ''W'') and (Code <> ''K'')';
    tblMatTypes.Filtered := True;
  end;
  if (not Option_Synthetics) then
  begin
    tblMatTypes.Filter := '(Code <> ''R'') and (Code <> ''S'')';
    tblMatTypes.Filtered := True;
  end;
end;

procedure TfmParametersGeneral.pcParametersDrawTab(
  Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

end.
