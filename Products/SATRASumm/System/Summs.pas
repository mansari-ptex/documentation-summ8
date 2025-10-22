unit Summs;

interface

uses
  Messages, Windows, SysUtils, Classes, Controls, Forms, Dialogs, Menus, DB, StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,
  ExtCtrls, Buttons, Grids, Math, ToolWin, ComCtrls, iniFiles, Graphics,
  ShellApi, ImgList, Vcl.Imaging.jpeg, ThdTimer, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Phys.ADS, FireDAC.Comp.UI, frxReportPlus, FDConnectionPlus;
type
  TfmSumms = class(TForm)
    dlgOpenPatternFile: TOpenDialog;
    lblError: TLabel;
    dlgOpenExternalFile: TOpenDialog;
    qParameters: TFDQueryPlus;
    qParametersCompany: TStringField;
    qParametersAutoCreateConstruction: TBooleanField;
    ConnectionSumms: TFDConnectionPlus;
    tblLocks: TFDTablePlus;
    tblLocksOption: TStringField;
    tblSizeRelationships: TFDTablePlus;
    tblSizeRelationshipsRelationship: TStringField;
    tblSizeRelationshipsRange: TStringField;
    qParametersCADDirectory: TStringField;
    qParametersTicketsDirectory: TStringField;
    qParametersDifficultLeatherFacilty: TBooleanField;
    qMaterialUnits: TFDQueryPlus;
    qMaterialUnitsCode: TStringField;
    qMaterialUnitsUnitDescription: TStringField;
    qMaterialUnitsUnitAbbreviation: TStringField;
    qMaterialUnitsToFeet: TFloatField;
    qMaterialUnitsSubUnitDesc: TStringField;
    qMaterialUnitsSubUnitAbbreviation: TStringField;
    qMaterialUnitsSubUnitsPerUnit: TSmallintField;
    tblParts: TFDTablePlus;
    qParametersAutoDeleteConstruction: TBooleanField;
    qParametersStylePicDirectory: TStringField;
    tblConstructions: TFDTablePlus;
    qParametersLinesInLeatherGrid: TSmallintField;
    qParametersRowsInLeatherGrid: TSmallintField;
    qParametersTitleFontName: TStringField;
    qParametersTitleFontSize: TIntegerField;
    qParametersTitleFontCharset: TIntegerField;
    qParametersStandardFontName: TStringField;
    qParametersStandardFontSize: TIntegerField;
    qParametersStandardFontCharset: TIntegerField;
    qParametersFixedFontName: TStringField;
    qParametersFixedFontSize: TIntegerField;
    qParametersFixedFontCharset: TIntegerField;
    qParametersPrintTagNumbers: TBooleanField;
    qParametersPrintCustomer: TBooleanField;
    qParametersPrintTimes: TBooleanField;
    qParametersShowBarcodeNPic: TBooleanField;
    qTicketLabels: TFDQueryPlus;
    qTicketLabelsEnglish: TStringField;
    qTicketLabelsTranslation: TStringField;
    qParametersAuditPathName: TStringField;
    qParametersOldAudit: TBooleanField;
    qParametersTableLength: TFloatField;
    qParametersBatchSize: TSmallintField;
    qParametersIssuedCutWeek: TStringField;
    qParametersTicketCostedAlw: TStringField;
    qParametersSummarisedDetailed: TStringField;
    qParametersPrintCutterValue: TBooleanField;
    qParametersCutterPageThrow: TBooleanField;
    qParametersSplitTickets: TBooleanField;
    qParametersSplittingScheme: TSmallintField;
    qParametersSaveOutBasic: TStringField;
    qParametersMaterialDefaultUnits: TStringField;
    lblTemp: TLabel;
    sbMain: TStatusBar;
    tmrClock: TTimer;
    imgNoTick: TImage;
    imgTick: TImage;
    mmSumms: TMainMenu;
    mmKnives: TMenuItem;
    mmKnivesNew: TMenuItem;
    mmKnivesOpen: TMenuItem;
    mmKnivesAll: TMenuItem;
    mmKnivesSeparator1: TMenuItem;
    mmKnivesSeparator2: TMenuItem;
    mmKnivesSwap: TMenuItem;
    mmKnivesSeparator3: TMenuItem;
    mmKnivesDefaults: TMenuItem;
    mmKnivesSeparator4: TMenuItem;
    mmExit: TMenuItem;
    mmBuild: TMenuItem;
    mmBuildMaterials: TMenuItem;
    mmBuildMaterialsNew: TMenuItem;
    mmBuildMaterialsOpen: TMenuItem;
    mmBuildMaterialsAll: TMenuItem;
    mmBuildMaterialsSeparator2: TMenuItem;
    mmBuildMaterialsDefaults: TMenuItem;
    mmBuildMaterialsSeparator3: TMenuItem;
    mmBuildMaterialsSuppliers: TMenuItem;
    mmBuildMaterialsSuppliersNew: TMenuItem;
    mmBuildMaterialsSuppliersOpen: TMenuItem;
    mmBuildMaterialsSuppliersAll: TMenuItem;
    mmBuildParts: TMenuItem;
    mmBuildPartsNew: TMenuItem;
    mmBuildPartsOpen: TMenuItem;
    mmBuildPartsAll: TMenuItem;
    mmBuildConstructions: TMenuItem;
    mmBuildConstructionsNew: TMenuItem;
    mmBuildConstructionsOpen: TMenuItem;
    mmBuildConstructionsAll: TMenuItem;
    mmBuildStyles: TMenuItem;
    mmBuildStylesNew: TMenuItem;
    mmBuildStylesOpen: TMenuItem;
    mmBuildStylesAll: TMenuItem;
    mmTickets: TMenuItem;
    mmTicketsNew: TMenuItem;
    mmTicketsOpen: TMenuItem;
    mmTicketsAll: TMenuItem;
    mmTicketsSeparater: TMenuItem;
    mmTicketsAnalysis: TMenuItem;
    mmTicketsUpdate: TMenuItem;
    mmTicketsUpdateGroup: TMenuItem;
    mmTicketsUpdateBulk: TMenuItem;
    mmNotUpdated: TMenuItem;
    N1: TMenuItem;
    mmTicketsExternalin: TMenuItem;
    mmTicketsAudit: TMenuItem;
    N2: TMenuItem;
    mmTicketsCutters: TMenuItem;
    mmTicketsCuttersNames: TMenuItem;
    mmTicketsCuttersLocations: TMenuItem;
    mmSizes: TMenuItem;
    mmSizeRelationships: TMenuItem;
    mmSizeRelationshipsNew: TMenuItem;
    mmSizeRelationshipsOpen: TMenuItem;
    mmSizeRelationshipsAll: TMenuItem;
    mmSizeRanges: TMenuItem;
    mmSizeRangesNew: TMenuItem;
    mmSizeRangesOpen: TMenuItem;
    mmSizeRangesAll: TMenuItem;
    mmSizeScales: TMenuItem;
    mmSizeScalesNew: TMenuItem;
    mmSizeScalesOpen: TMenuItem;
    mmSizeScalesAll: TMenuItem;
    mmWidths: TMenuItem;
    mmWidthRanges: TMenuItem;
    mmWidthRangesNew: TMenuItem;
    mmWidthRangesOpen: TMenuItem;
    mmWidthRangesAll: TMenuItem;
    mmWidthNames: TMenuItem;
    mmParameters: TMenuItem;
    mmParametersGeneral: TMenuItem;
    mmSystemStatus: TMenuItem;
    mmParametersSeparater: TMenuItem;
    mmSaveScreenPosition: TMenuItem;
    mmToolbar: TMenuItem;
    mmStatusbar: TMenuItem;
    mmMinimiseAllonOpen: TMenuItem;
    mmPrintPreview: TMenuItem;
    mmPrintPreview100: TMenuItem;
    mmPrintPreviewMax: TMenuItem;
    mmOpenTicketsinCentre: TMenuItem;
    mmTicketsUpdateOption: TMenuItem;
    mmTicketsUpdateQualityArea: TMenuItem;
    mmTicketsUpdateIssuedAllowanceSms: TMenuItem;
    mmTicketsUpdateBoth: TMenuItem;
    N5: TMenuItem;
    mmTicketsUpdateCutWeek: TMenuItem;
    mmTicketsUpdateCutter: TMenuItem;
    mmTicketsUpdateCutterLocation: TMenuItem;
    mmTicketsUpdateMaterialSupplier: TMenuItem;
    mmTicketsUpdateMaterialPrice: TMenuItem;
    mmTicketsUpdateMaterialUsed: TMenuItem;
    mmDeleteExternalInAfterRead: TMenuItem;
    mmExpandedTicketSearch: TMenuItem;
    mmGroupPrintByMaterial: TMenuItem;
    mmTagNoOnMaterialSummary: TMenuItem;
    mmWindows: TMenuItem;
    mmTile: TMenuItem;
    mmCascade: TMenuItem;
    mmArrangeIcons: TMenuItem;
    mmWindowsSeparater: TMenuItem;
    mmUtilitiesCloseAll: TMenuItem;
    mmUtilities: TMenuItem;
    mmUtilitiesSMRateTable: TMenuItem;
    mmPassword: TMenuItem;
    mmDongle: TMenuItem;
    mmDongleInfo: TMenuItem;
    N4: TMenuItem;
    mmDongleChange: TMenuItem;
    qParametersClearAuditAfterSave: TBooleanField;
    mmLayplans: TMenuItem;
    mmLayplansOpen: TMenuItem;
    qParametersShowWaste: TBooleanField;
    mmLogo: TMenuItem;
    qParametersGroupPrintSyntheticTickets: TBooleanField;
    qParametersCreateSyntheticTicketsList: TBooleanField;
    mmKnivesNewSingle: TMenuItem;
    mmKnivesNewSet: TMenuItem;
    mmNewKnivesManual: TMenuItem;
    tblMaterialDefaults: TFDTablePlus;
    tblMaterialDefaultsType: TStringField;
    tblMaterialDefaultsCutType: TStringField;
    qParametersUpdatedInitialisation: TBooleanField;
    qUpdateDefaults: TFDQueryPlus;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    FloatField1: TFloatField;
    StringField4: TStringField;
    StringField5: TStringField;
    SmallintField1: TSmallintField;
    mmKnivesNewSeparator1: TMenuItem;
    mmAssessKnives: TMenuItem;
    qParametersInterlockingToleranceInterlock: TSmallintField;
    qParametersInterlockingToleranceLayplans: TSmallintField;
    mmLegacyCheck: TMenuItem;
    mmManualKnives: TMenuItem;
    mmUseExtendedUpdatedOUT: TMenuItem;
    mmAutoEdit: TMenuItem;
    mmKnivesNewAuto: TMenuItem;
    mmCADOrder: TMenuItem;
    mmSmallToLarge: TMenuItem;
    mmLargeToSmall: TMenuItem;
    qParametersMadeInPairsDefault: TBooleanField;
    tblConstructionsConstruction: TStringField;
    tblConstructionsDescription: TStringField;
    tblConstructionsSizeScale: TStringField;
    tblConstructionsSizeRange: TStringField;
    tblConstructionsSampleSize: TStringField;
    tblConstructionsCostedSize: TStringField;
    tblConstructionsMadeInPairs: TBooleanField;
    mmLayplansBulk: TMenuItem;
    qParametersFixedCutFontName: TStringField;
    qParametersFixedCutFontSize: TIntegerField;
    qParametersFixedCutFontCharset: TIntegerField;
    qParametersTitleFontStyle: TStringField;
    qParametersStandardFontStyle: TStringField;
    qParametersFixedFontStyle: TStringField;
    qParametersFixedCutFontStyle: TStringField;
    mmGridLines: TMenuItem;
    tmrDongle: TTimer;
    qParametersShortTagNo: TBooleanField;
    qCountFullSyntheticParts: TFDQueryPlus;
    qCountLegacySyntheticParts: TFDQueryPlus;
    qCountFullSyntheticPartsTotal: TIntegerField;
    qCountLegacySyntheticPartsTotal: TIntegerField;
    SpeedButton1: TSpeedButton;
    cbRight: TCoolBar;
    cbLeft: TCoolBar;
    SpeedButton2: TToolButton;
    cbTop: TCoolBar;
    N3: TMenuItem;
    N6: TMenuItem;
    mmToolBarTop: TMenuItem;
    mmToolBarLeft: TMenuItem;
    mmToolBarRight: TMenuItem;
    mmToolBarFloating: TMenuItem;
    mmToolBarOff: TMenuItem;
    mmToolBarStandard: TMenuItem;
    mmToolBarAlternative: TMenuItem;
    mmToolBarLocked: TMenuItem;
    ilButtons: TImageList;
    tbMain: TToolBar;
    btnNewKnifeSingle: TToolButton;
    btnNewKnifeSet: TToolButton;
    btnOpenKnife: TToolButton;
    btnAllKnives: TToolButton;
    btnAssessKnives: TToolButton;
    btnSpacer1: TToolButton;
    btnNewMaterial: TToolButton;
    btnOpenMaterial: TToolButton;
    btnAllMaterials: TToolButton;
    btnSpacer2: TToolButton;
    btnNewPart: TToolButton;
    btnOpenPart: TToolButton;
    btnAllParts: TToolButton;
    btnSpacer3: TToolButton;
    btnNewConstruction: TToolButton;
    btnOpenConstruction: TToolButton;
    btnAllConstructions: TToolButton;
    btnSpacer4: TToolButton;
    btnNewStyle: TToolButton;
    btnOpenStyle: TToolButton;
    btnAllStyles: TToolButton;
    btnSpacer5: TToolButton;
    btnNewTicket: TToolButton;
    btnOpenTicket: TToolButton;
    btnAllTickets: TToolButton;
    btnSpacer6: TToolButton;
    btnOpenLayplanning: TToolButton;
    btnBulkLayplanning: TToolButton;
    btnSpacer7: TToolButton;
    btnStatus: TToolButton;
    MoreSATRAProductionEfficiencySystems1: TMenuItem;
    N7: TMenuItem;
    Timeline1: TMenuItem;
    VisionStitch1: TMenuItem;
    SATRA1: TMenuItem;
    System1: TMenuItem;
    Features1: TMenuItem;
    mmAbout: TMenuItem;
    tmrAlive: TThreadedTimer;
    qParametersWebAddress1: TStringField;
    qParametersWebAddress2: TStringField;
    qParametersWebAddress3: TStringField;
    qParametersWebAddress4: TStringField;
    qParametersWebAddress5: TStringField;
    dlgOpenMaterials: TOpenDialog;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysADSDriverLink1: TFDPhysADSDriverLink;
    frxReportSettings: TfrxReportSettings;
    N8: TMenuItem;
    mmNormaliseOnClose: TMenuItem;
    pnlBackground: TPanel;
    imgSystem: TImage;
    procedure mmTileClick(Sender: TObject);
    procedure mmCascadeClick(Sender: TObject);
    procedure mmArrangeIconsClick(Sender: TObject);
    procedure mmExitClick(Sender: TObject);
    procedure HandleExceptions(Sender: TObject; E: Exception);
    procedure mmBuildMaterialsAllClick(Sender: TObject);
    procedure mmBuildMaterialsNewClick(Sender: TObject);
    procedure mmBuildMaterialsOpenClick(Sender: TObject);
    procedure mmBuildPartsAllClick(Sender: TObject);
    procedure mmBuildPartsNewClick(Sender: TObject);
    procedure mmBuildPartsOpenClick(Sender: TObject);
    procedure mmBuildConstructionsAllClick(Sender: TObject);
    procedure mmBuildConstructionsNewClick(Sender: TObject);
    procedure mmBuildConstructionsOpenClick(Sender: TObject);
    procedure mmKnivesAllClick(Sender: TObject);
    procedure mmKnivesOpenClick(Sender: TObject);
    procedure mmKnivesDefaultsClick(Sender: TObject);
    procedure mmSizeRelationshipsNewClick(Sender: TObject);
    procedure mmSizeRelationshipsOpenClick(Sender: TObject);
    procedure mmSizeRangesNewClick(Sender: TObject);
    procedure mmSizeRangesOpenClick(Sender: TObject);
    procedure mmSizeScalesNewClick(Sender: TObject);
    procedure mmSizeScalesOpenClick(Sender: TObject);
    procedure mmTicketsAllClick(Sender: TObject);
    procedure mmTicketsNewClick(Sender: TObject);
    procedure mmTicketsOpenClick(Sender: TObject);
    procedure mmWidthRangesNewClick(Sender: TObject);
    procedure mmWidthRangesOpenClick(Sender: TObject);
    procedure mmSizeRelationshipsAllClick(Sender: TObject);
    procedure mmSizeRangesAllClick(Sender: TObject);
    procedure mmSizeScalesAllClick(Sender: TObject);
    procedure mmWidthRangesAllClick(Sender: TObject);
    procedure mmTicketsCuttersNamesClick(Sender: TObject);
    procedure mmTicketsCuttersLocationsClick(Sender: TObject);
    procedure mmWidthNamesClick(Sender: TObject);
    procedure mmParametersGeneralClick(Sender: TObject);
    procedure mmMinimiseAllonOpenClick(Sender: TObject);
    procedure mmBuildMaterialsSuppliersNewClick(Sender: TObject);
    procedure mmBuildMaterialsSuppliersOpenClick(Sender: TObject);
    procedure mmBuildMaterialsSuppliersAllClick(Sender: TObject);
    procedure mmBuildMaterialsDefaultsClick(Sender: TObject);
    procedure ReadSummsIni;
    procedure WriteSummsIni;
    procedure mmTicketsAnalysisClick(Sender: TObject);
    procedure mmTicketsExternalinClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mmUtilitiesSMRateTableClick(Sender: TObject);
    procedure mmTicketsAuditClick(Sender: TObject);
    procedure mmOpenTicketsinCentreClick(Sender: TObject);
    procedure mmUtilitiesCloseAllClick(Sender: TObject);
    procedure mmSaveScreenPositionClick(Sender: TObject);
    procedure mmNotUpdatedClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mmKnivesSwapClick(Sender: TObject);
    procedure mmBuildStylesNewClick(Sender: TObject);
    procedure mmBuildStylesOpenClick(Sender: TObject);
    procedure mmBuildStylesAllClick(Sender: TObject);
    procedure mmSystemStatusClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure qParametersAfterOpen(DataSet: TDataSet);
    procedure SetFeatures;
    procedure FormResize(Sender: TObject);
    procedure mmPrintPreview100Click(Sender: TObject);
    procedure mmPrintPreviewMaxClick(Sender: TObject);
    procedure qTicketLabelsAfterOpen(DataSet: TDataSet);
    procedure mmToolbarClick(Sender: TObject);
    procedure mmTicketsUpdateGroupClick(Sender: TObject);
    procedure mmTicketsUpdateBulkClick(Sender: TObject);
    procedure mmPasswordClick(Sender: TObject);
    procedure mmStatusbarClick(Sender: TObject);
    procedure mmDongleChangeClick(Sender: TObject);
    procedure mmDongleInfoClick(Sender: TObject);
    procedure CallCheckDongle(Sender: TObject);
    procedure mmTicketsUpdateQualityAreaClick(Sender: TObject);
    procedure mmTicketsUpdateIssuedAllowanceSmsClick(Sender: TObject);
    procedure mmTicketsUpdateBothClick(Sender: TObject);
    procedure mmTicketsUpdateCutWeekClick(Sender: TObject);
    procedure mmTicketsUpdateCutterClick(Sender: TObject);
    procedure mmTicketsUpdateCutterLocationClick(Sender: TObject);
    procedure mmTicketsUpdateMaterialSupplierClick(Sender: TObject);
    procedure mmTicketsUpdateMaterialPriceClick(Sender: TObject);
    procedure mmTicketsUpdateMaterialUsedClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrClockTimer(Sender: TObject);
    procedure mmTagNoOnMaterialSummaryClick(Sender: TObject);
    procedure mmDeleteExternalInAfterReadClick(Sender: TObject);
    procedure mmExpandedTicketSearchClick(Sender: TObject);
    procedure mmGroupPrintByMaterialClick(Sender: TObject);
    procedure mmLayplansOpenClick(Sender: TObject);
    function LayplanningInterfaceOUT(CallingForm: TForm;
                                     Knife, Scale, Size, SubUnitDesc, SubUnitAbbrev: string;
                                     Length, Width: Real;
                                     Units: string;
                                     CutGap: integer;
                                     RestrictiveMaterialCode: string): Boolean;
    procedure mmLogoClick(Sender: TObject);
    procedure mmKnivesNewSingleClick(Sender: TObject);
    procedure mmKnivesNewSetClick(Sender: TObject);
    procedure mmNewKnivesManualClick(Sender: TObject);
    procedure btnNewKnifeSetClick(Sender: TObject);
    procedure btnNewKnifeSingleClick(Sender: TObject);
    procedure mmAssessKnivesClick(Sender: TObject);
    procedure mmLegacyCheckClick(Sender: TObject);
    procedure mmManualKnivesClick(Sender: TObject);
    procedure mmUseExtendedUpdatedOUTClick(Sender: TObject);
    procedure mmAutoEditClick(Sender: TObject);
    procedure mmKnivesNewAutoClick(Sender: TObject);
    procedure mmLargeToSmallClick(Sender: TObject);
    procedure mmSmallToLargeClick(Sender: TObject);
    procedure mmLayplansBulkClick(Sender: TObject);
    procedure mmGridLinesClick(Sender: TObject);
    procedure tmrDongleTimer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure mmSystemClick(Sender: TObject);
    procedure mmFeaturesClick(Sender: TObject);
    procedure tbMainEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure mmToolBarTopClick(Sender: TObject);
    procedure mmToolBarLeftClick(Sender: TObject);
    procedure mmToolBarRightClick(Sender: TObject);
    procedure mmToolBarFloatingClick(Sender: TObject);
    procedure mmToolBarOffClick(Sender: TObject);
    procedure mmToolBarStandardClick(Sender: TObject);
    procedure StandardToolbar;
    procedure AlternativeToolbar;
    procedure tbMainStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure UpdateToolBarMenu;
    procedure mmToolBarAlternativeClick(Sender: TObject);
    procedure mmToolBarLockedClick(Sender: TObject);
    procedure btnNewMaterialClick(Sender: TObject);
    procedure btnNewPartClick(Sender: TObject);
    procedure btnNewStyleClick(Sender: TObject);
    procedure btnOpenKnifeClick(Sender: TObject);
    procedure btnAllKnivesClick(Sender: TObject);
    procedure btnAssessKnivesClick(Sender: TObject);
    procedure btnOpenMaterialClick(Sender: TObject);
    procedure btnAllMaterialsClick(Sender: TObject);
    procedure btnOpenPartClick(Sender: TObject);
    procedure btnAllPartsClick(Sender: TObject);
    procedure btnNewConstructionClick(Sender: TObject);
    procedure btnOpenConstructionClick(Sender: TObject);
    procedure btnAllConstructionsClick(Sender: TObject);
    procedure btnOpenStyleClick(Sender: TObject);
    procedure btnAllStylesClick(Sender: TObject);
    procedure btnNewTicketClick(Sender: TObject);
    procedure btnOpenTicketClick(Sender: TObject);
    procedure btnAllTicketsClick(Sender: TObject);
    procedure btnOpenLayplanningClick(Sender: TObject);
    procedure btnBulkLayplanningClick(Sender: TObject);
    procedure btnStatusClick(Sender: TObject);
    procedure cbTopDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cbRightDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cbLeftDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Timeline1Click(Sender: TObject);
    procedure VisionStitch1Click(Sender: TObject);
    procedure SATRA1Click(Sender: TObject);
    procedure System1Click(Sender: TObject);
    procedure Features1Click(Sender: TObject);
    procedure MoreSATRAProductionEfficiencySystems1Click(Sender: TObject);
    procedure tmrAliveTimer(Sender: TObject);
    function GetMasterPassword: string;
    procedure StartUp;
    procedure mmNormaliseOnCloseClick(Sender: TObject);
    procedure dlgOpenPatternFileShow(Sender: TObject);
    procedure dlgOpenExternalFileShow(Sender: TObject);
    procedure dlgOpenMaterialsShow(Sender: TObject);
  private
    { Private declarations }
    FirstTime, MaxIt: Boolean;
    NagAgain: Boolean;
    ToolBarPosStatus, ToolBarTypeStatus: integer;
    JustScrolled: boolean;
    FClientInstance : TFarProc;
    FPrevClientProc : TFarProc;
    procedure ClientWndProc(var Message: TMessage);

  public
    { Public declarations }
    ClosingSystem: Boolean;
    SystemIni: TIniFile;
    function CheckDongle(ProtType: integer): Boolean;
  end;

var
  fmSumms: TfmSumms;
  BatchSize: short;
  WebAddress1, WebAddress2, WebAddress3, WebAddress4, WebAddress5: string;

const
  {$IFDEF DEBUG}
  ProtectionOn = FALSE;
  {$ELSE}
  ProtectionOn = TRUE;
  {$ENDIF}

implementation

{$R *.DFM}

//{$DEFINE DEBUGFULL}

uses
  Analyse, AllParts, AllConstructions, AllKnifeSets, Audit, OpenKnife,
  KnifeDefaults, NewConstruction, NewMaterial, OpenMaterial, NewPart, OpenPart,
  OpenConstruction, NewTicket, OpenTicket, NewSizeReln, OpenSizeReln,
  NewSizeRange, OpenSizeRange, NewSizeScale, OpenSizeScale, AllTickets,
  AllSizeRelationships, AllSizeRanges, AllSizeScales, AllWidthRanges, About,
  CutterNames, CutterLocations, WidthNames, ParamGeneral, NewSupplier,
  OpenSupplier, AllSuppliers, NewWidthRange, OpenWidthRange,
  ImportKnife, MatDflts, ExternalIn, SMRate, TktUpdate, TktBlkUp,
  TicketsNotUpdated, KnivesToSwap, NewStyle, OpenStyle, AllStyles, SystemStatus,
  BasicAlw, AdjFact, CutUtils, CutUtils2, Times, Times2,
  AccessDenied, ChangePassword, OutOfMemory, General, AllMaterials,
  SummsVars, CmnVars, CmnTypes, AdvErrorHandler, FileCtrl,
  Dongle_Green, DongleChange_Green, Features,
  DongleInfo_Green, PartDetails, SHFolder,
  //Layplanning below
  Layplanning, LayMain, AllPatterns, NewKnifeSet,
  AllLayplans, AllLayplansWithoutSelection, AllSyntheticMaterials,
  SyntheticTicketsList, BulkAssessKnives, LegacyCheck, ManualKnifeCheck,
  BulkLayplan, KnifeSpinner
  {$IFDEF DEBUGFULL}
  , Debugger
  {$DEFINE DEBUG}
  {$ENDIF}
  ;


procedure TfmSumms.mmBuildMaterialsAllClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Materials', '') then
    begin
      Screen.cursor := crHourGlass;
      try
        fmAllMaterials := TfmAllMaterials.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
      end;
      Screen.cursor := crDefault;
    end;
  end;
end;

procedure TfmSumms.mmBuildPartsAllClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Parts', '') then
    begin
      Screen.cursor := crHourGlass;
      try
        fmAllParts := TfmAllParts.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
      end;
      Screen.cursor := crDefault;
    end;
  end;
end;

procedure TfmSumms.mmBuildConstructionsAllClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Constructions', '') then
    begin
      Screen.cursor := crHourGlass;
      try
        fmAllConstructions := TfmAllConstructions.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
      end;
      Screen.cursor := crDefault;
    end;
  end;
end;

procedure TfmSumms.mmKnivesAllClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Knives', '') then
    begin
      Screen.cursor := crHourGlass;
      try
        fmAllKnifeSets := TfmAllKnifeSets.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
      end;
      Screen.cursor := crDefault;
    end;
  end;
end;

procedure TfmSumms.mmTicketsAllClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Tickets', '') then
    begin
      Screen.cursor := crHourGlass;
      try
        fmAllTickets := TfmAllTickets.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
      end;

      Screen.cursor := crDefault;
    end;
  end;
end;

procedure TfmSumms.mmSizeRelationshipsAllClick(Sender: TObject);
begin
  if not ExistingToFront('Size Relationships', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmAllSizeRelationships := TfmAllSizeRelationships.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmSizeRangesAllClick(Sender: TObject);
begin
  if not ExistingToFront('Size Ranges', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmAllSizeRanges := TfmAllSizeRanges.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmSizeScalesAllClick(Sender: TObject);
begin
  if not ExistingToFront('Size Scales', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmAllSizeScales := TfmAllSizeScales.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmWidthRangesAllClick(Sender: TObject);
begin
  if not ExistingToFront('Width Ranges', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmAllWidthRanges := TfmAllWidthRanges.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmBuildMaterialsSuppliersAllClick(Sender: TObject);
begin
  if not ExistingToFront('Suppliers', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmAllSuppliers := TfmAllSuppliers.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmTicketsCuttersLocationsClick(Sender: TObject);
var
  Failed: Boolean;

begin
  if not ExistingToFront('Cutter Locations', '') then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmCutterLocations := TfmCutterLocations.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := True;
    end;

    if not Failed then
      fmCutterLocations.Pass;

    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmTicketsCuttersNamesClick(Sender: TObject);
var
  Failed: Boolean;

begin
  if not ExistingToFront('Cutter Names', '') then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmCutterNames := TfmCutterNames.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := True;
    end;

    if not Failed then
      fmCutterNames.Pass;

    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmWidthNamesClick(Sender: TObject);
var
  Failed: Boolean;

begin
  if not ExistingToFront('Width Names', '') then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmWidthNames := TfmWidthNames.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := True;
    end;

    if not Failed then
      fmWidthNames.Pass;

    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmKnivesDefaultsClick(Sender: TObject);
var
  Failed: Boolean;

begin
  if not ExistingToFront('Knife Defaults', '') then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmKnifeDefaults := TfmKnifeDefaults.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := True;
    end;

    if not Failed then
      fmKnifeDefaults.Pass;

    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmTileClick(Sender: TObject);
begin
  Tile;
end;

procedure TfmSumms.mmCascadeClick(Sender: TObject);
begin
  Cascade;
end;

procedure TfmSumms.mmArrangeIconsClick(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TfmSumms.mmExitClick(Sender: TObject);
begin
  close
end;

procedure TfmSumms.HandleExceptions(Sender: TObject; E: Exception);
begin
  Screen.Cursor := crDefault;
  if E is EFDDBEngineException then
  begin
    if (E as EFDDBEngineException).ErrorCode = 5054 then
      ADMessage('Rights not granted for User - ' + SystemUserName)
    else
      fmErrorHandler.FDDbErrMsg(E)
  end
  else if E is EDatabaseError then
  begin
    if pos('Cannot modify', (E as EDataBaseError).Message) > 0 then
      ADMessage('Rights not granted for User - ' + SystemUserName)
    else
      fmErrorHandler.DbErrMsg(E);
  end
  else if E is EConvertError then
    fmErrorHandler.ConvErrMsg(E)
  else
    fmErrorHandler.OtherErrMsg(E);
end;

procedure TfmSumms.Timeline1Click(Sender: TObject);
begin
	ShowWebpage(Sender, WebAddress5);
end;

procedure TfmSumms.mmKnivesNewSingleClick(Sender: TObject);
var
  Failed: boolean;

begin
  Failed := false;

  if DirectoryExists(CADDirectory) then
    dlgOpenPatternFile.InitialDir := CADDirectory
  else
  begin
    MessageDlgPos('Parameters | Pattern File directory does not exist', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    dlgOpenPatternFile.InitialDir := ExtractFileDrive(Application.EXEName);
  end;

  dlgOpenPatternFile.FileName := '';
  if (dlgOpenPatternFile.Execute) then
  begin
    try
      fmKnifeImport := TfmKnifeImport.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;
    if not Failed then
      fmKnifeImport.PassKnifeInfo(dlgOpenPatternFile.FileName, '', '', nil, 'Single');
  end;
end;

procedure TfmSumms.mmKnivesNewAutoClick(Sender: TObject);
var
  Failed: boolean;

begin
  Failed := false;

  if DirectoryExists(CADDirectory) then
    dlgOpenPatternFile.InitialDir := CADDirectory
  else
  begin
    MessageDlgPos('Parameters | Pattern File directory does not exist', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    dlgOpenPatternFile.InitialDir := ExtractFileDrive(Application.EXEName);
  end;

  dlgOpenPatternFile.FileName := '';
  if (dlgOpenPatternFile.Execute) then
  begin
    try
      fmKnifeImport := TfmKnifeImport.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;
    if not Failed then
      fmKnifeImport.PassKnifeInfo(dlgOpenPatternFile.FileName, '', '', nil, ' Auto');
  end;
end;

procedure TfmSumms.mmKnivesNewSetClick(Sender: TObject);
begin
  ToBeAssessed := True;
  //CJY eSizeScale.OnChange requires fmNewKnifeSet.Auto
  fmNewKnifeSet.Auto := False;
  fmNewKnifeSet.Single := False;
  fmNewKnifeSet.Manual := False;
  fmNewKnifeSet.eSizeScale.Text := KnifeSizeScale;
  fmNewKnifeSet.eNewKnifeCode.text := '';
  fmNewKnifeSet.Height := fmNewKnifeSet.CreatedFormHeight - 27;
  fmNewKnifeSet.ShowModal;
end;

procedure TfmSumms.mmNewKnivesManualClick(Sender: TObject);
begin
  ToBeAssessed := False;
  //CJY eSizeScale.OnChange requires fmNewKnifeSet.Auto
  fmNewKnifeSet.Auto := False;
  fmNewKnifeSet.Single := False;
  fmNewKnifeSet.Manual := True;
  fmNewKnifeSet.eSizeScale.Text := KnifeSizeScale;
  fmNewKnifeSet.eNewKnifeCode.text := '';
  fmNewKnifeSet.Height := fmNewKnifeSet.CreatedFormHeight;
  fmNewKnifeSet.ShowModal;
end;

procedure TfmSumms.mmKnivesOpenClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
    fmOpenKnife.showmodal;
end;

procedure TfmSumms.mmBuildMaterialsNewClick(Sender: TObject);
begin
  fmNewMaterial.ShowModal
end;

procedure TfmSumms.mmBuildMaterialsOpenClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
    fmOpenMaterial.ShowModal;
end;

procedure TfmSumms.mmBuildPartsNewClick(Sender: TObject);
begin
  fmNewPart.ShowModal
end;

procedure TfmSumms.mmBuildPartsOpenClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
    fmOpenPart.ShowModal
end;

procedure TfmSumms.mmBuildConstructionsNewClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
    fmNewConstruction.ShowModal
end;

procedure TfmSumms.mmBuildConstructionsOpenClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
    fmOpenConstruction.ShowModal
end;

procedure TfmSumms.mmTicketsNewClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
    fmNewTicket.ShowModal
end;

procedure TfmSumms.mmTicketsOpenClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
    fmOpenTicket.ShowModal
end;

procedure TfmSumms.mmSizeRelationshipsNewClick(Sender: TObject);
begin
  fmNewSizeRelationship.ShowModal
end;

procedure TfmSumms.mmSizeRelationshipsOpenClick(Sender: TObject);
begin
  fmOpenSizeRelationship.ShowModal
end;

procedure TfmSumms.mmSizeRangesNewClick(Sender: TObject);
begin
  fmNewSizeRange.ShowModal
end;

procedure TfmSumms.mmSizeRangesOpenClick(Sender: TObject);
begin
  fmOpenSizeRange.ShowModal
end;

procedure TfmSumms.mmSizeScalesNewClick(Sender: TObject);
begin
//This option is now defunct because we do not allow them to make their own Size Scales.  This is to do with the
//changes which prevent them seeing or needing to enter mm lengths due to all the confusion it caused.
  fmNewSizeScale.ShowModal
end;

procedure TfmSumms.mmSizeScalesOpenClick(Sender: TObject);
begin
  fmOpenSizeScale.ShowModal
end;

procedure TfmSumms.mmSmallToLargeClick(Sender: TObject);
begin
  mmLargeToSmall.Checked := False;
  mmSmallToLarge.Checked := True;
end;

procedure TfmSumms.mmWidthRangesNewClick(Sender: TObject);
begin
  fmNewWidthRange.ShowModal
end;

procedure TfmSumms.mmWidthRangesOpenClick(Sender: TObject);
begin
  fmOpenWidthRange.ShowModal
end;

procedure TfmSumms.MoreSATRAProductionEfficiencySystems1Click(Sender: TObject);
begin
	Timeline1.Caption :=     'TimeLine         ' + WebAddress5;
  VisionStitch1.Caption := 'VisionStitch     ' + WebAddress4;
  Satra1.Caption :=        'SATRA            ' + WebAddress1;
end;

procedure TfmSumms.mmParametersGeneralClick(Sender: TObject);
var
  Failed: Boolean;
begin
  if not ExistingToFront('Parameters General', '') then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmParametersGeneral := TfmParametersGeneral.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := True;
    end;

    if not Failed then
      fmParametersGeneral.Pass;

    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmSystemClick(Sender: TObject);
begin
	if not CheckDongle(PROTECTION_CHECK) then
		fmAboutBox.ShowModal;
end;

procedure TfmSumms.mmSystemStatusClick(Sender: TObject);
begin
  if not ExistingToFront('System Status', '') then
  begin
    try
      fmSystemStatus := TfmSystemStatus.create(fmSumms)
    except
      fmMemoryError.TidyUp(self);
    end;
  end;
end;

procedure TfmSumms.mmMinimiseAllonOpenClick(Sender: TObject);
begin
  mmMinimiseAllonOpen.Checked := not mmMinimiseAllonOpen.Checked;
end;

procedure TfmSumms.mmBuildMaterialsSuppliersNewClick(Sender: TObject);
begin
  fmNewSupplier.ShowModal
end;

procedure TfmSumms.mmBuildMaterialsSuppliersOpenClick(Sender: TObject);
begin
  fmOpenSupplier.ShowModal
end;

procedure TfmSumms.mmBuildStylesNewClick(Sender: TObject);
begin
  fmNewStyle.ShowModal
end;

procedure TfmSumms.mmBuildStylesOpenClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
    fmOpenStyle.ShowModal
end;

procedure TfmSumms.mmBuildStylesAllClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Styles', '') then
    begin
      Screen.cursor := crHourGlass;
      try
        fmAllStyles := TfmAllStyles.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
      end;
      Screen.cursor := crDefault;
    end;
  end;    
end;

procedure TfmSumms.mmBuildMaterialsDefaultsClick(Sender: TObject);
var
  Failed: Boolean;

begin
  if not ExistingToFront('Material Defaults', '') then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmMaterialDefaults := TfmMaterialDefaults.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := True;
    end;

    if not Failed then
      fmMaterialDefaults.Pass;

    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.SATRA1Click(Sender: TObject);
begin
	ShowWebpage(Sender, WebAddress1);
end;

procedure TfmSumms.SetFeatures;
begin
  {$IFDEF DEBUG}
  Feature := 2047;
  {$ENDIF}

  if (Feature < 65535) then
  begin
    Option_Leather := ((Feature and 1) = 1);
    Option_FullSynthetics := Force_FullSynthetics or ((Feature and 2) = 2);
    Option_LegacySynthetics := Force_LegacySynthetics or ((Feature and 4) = 4);
    Option_Synthetics := Option_LegacySynthetics or Option_FullSynthetics;
    Option_ProductionSystem := ((Feature and 8) = 8);
    Option_CuttingTimes := ((Feature and 16) = 16);
    Option_CadFiles := ((Feature and 32) = 32);
    Option_TicketsIn := ((Feature and 64) = 64);
    Option_TicketsOut := ((Feature and 128) = 128);
    Option_TicketAudit := ((Feature and 256) = 256);
    Option_TicketUpdating := ((Feature and 512) = 512);
    Option_SinglesAllowed := ((Feature and 1024) = 1024);
    Option_OverrideReleasedVersion := ((Feature and 2048) = 2048);  //to override ReleasedVersion flag (in LayMain)

    mmAssessKnives.Enabled := Option_Leather or Option_LegacySynthetics;
    mmLegacyCheck.Visible := Option_LegacySynthetics and Option_FullSynthetics;
    mmManualKnives.Visible := Option_LegacySynthetics and Option_FullSynthetics;
    mmTicketsExternalIn.Enabled := Option_TicketsIn;
    mmTicketsAudit.Enabled := Option_TicketAudit;
    mmTickets.Enabled := Option_ProductionSystem;
    mmOpenTicketsinCentre.Enabled := Option_ProductionSystem;
    mmTicketsUpdateOption.Enabled := Option_ProductionSystem;
    mmDeleteExternalInAfterRead.Enabled := Option_ProductionSystem;
    mmExpandedTicketSearch.Enabled := Option_ProductionSystem;
    mmGroupPrintByMaterial.Enabled := Option_ProductionSystem;
    mmTagNoOnMaterialSummary.Enabled := Option_ProductionSystem;
    mmUseExtendedUpdatedOUT.Enabled := Option_ProductionSystem;
    mmGridLines.Enabled := Option_ProductionSystem;
    mmUtilitiesSMRateTable.Enabled := Option_ProductionSystem;
    mmLayplans.Enabled := Option_FullSynthetics;
    btnAssessKnives.Enabled := Option_Leather or Option_LegacySynthetics;
    btnNewTicket.Enabled := Option_ProductionSystem;
    btnOpenTicket.Enabled := Option_ProductionSystem;
    btnAllTickets.Enabled := Option_ProductionSystem;
    btnOpenLayplanning.Enabled := Option_FullSynthetics;
    btnBulkLayplanning.Enabled := Option_FullSynthetics;
  end;

  //If Singles are allowed we need a generic word for both Pairs and
  //Singles, namely 'Quantity'. If it is standard SATRASumm i.e. Pairs
  //only then we may as well use 'Pairs' all the time.
  if not Option_SinglesAllowed then
    PairsWord := 'Pairs'
  else
    PairsWord := 'Quantity';
end;

procedure TfmSumms.SpeedButton1Click(Sender: TObject);
begin
  {$IFDEF DEBUGFULL}
  if Assigned(fmDebugger) then fmDebugger.Show;
  {$ENDIF}
end;

procedure TfmSumms.StandardToolbar;
var
  CurrentPos: integer;

begin
  if cbTop.DockClientCount > 0 then
  begin
    if cbTop.DockClients[0] = tbMain then
      CurrentPos := 1
  end
  else if cbLeft.DockClientCount > 0 then
  begin
    if cbLeft.DockClients[0] = tbMain then
      CurrentPos := 2
  end
  else if cbRight.DockClientCount > 0 then
  begin
    if cbRight.DockClients[0] = tbMain then
      CurrentPos := 3
  end
  else
    CurrentPos := 4;

  tbMain.ManualDock(cbTop);

  btnSpacer5.visible := true;
  btnSpacer6.visible := true;
  btnSpacer7.visible := true;

  btnNewKnifeSingle.Left := 0;
  btnNewKnifeSet.Left := 27;
  btnOpenKnife.Left := 54;
  btnAllKnives.Left := 81;
  btnAssessKnives.Left := 108;
  btnSpacer1.Left := 135;

  btnNewMaterial.Left := 145;
  btnOpenMaterial.Left := 172;
  btnAllMaterials.Left := 199;
  btnSpacer2.Left := 226;

  btnNewPart.Left := 236;
  btnOpenPart.Left := 290;
  btnAllParts.Left := 317;
  btnSpacer3.Left := 344;

  btnNewConstruction.Left := 354;
  btnOpenConstruction.Left := 381;
  btnAllConstructions.Left := 408;
  btnSpacer4.Left := 435;

  btnNewStyle.Left := 445;
  btnOpenStyle.Left := 472;
  btnAllStyles.Left := 499;
  btnSpacer5.Left := 526;

  btnNewTicket.Left := 536;
  btnOpenTicket.Left := 563;
  btnAllTickets.Left := 590;
  btnSpacer6.Left := 617;

  btnOpenLayplanning.Left := 654;
  btnBulkLayplanning.Left := 681;
  btnSpacer7.Left := 708;

  btnStatus.Left := 718;

  case CurrentPos of
    1: begin
         tbMain.ManualDock(NullDockSite);
         tbMain.ManualDock(cbTop);
       end;
    2: begin
         tbMain.ManualDock(NullDockSite);
         tbMain.ManualDock(cbLeft);
       end;
    3: begin
         tbMain.ManualDock(NullDockSite);
         tbMain.ManualDock(cbRight);
       end;
    4: begin
         tbMain.ManualDock(cbTop);
         tbMain.ManualDock(NullDockSite);
       end;
  end;

  ToolBarTypeStatus := 1;
end;

procedure TfmSumms.System1Click(Sender: TObject);
begin
//	if not CheckDongle(PROTECTION_CHECK) then
		fmAboutBox.ShowModal;
end;

procedure TfmSumms.AlternativeToolbar;
var
  CurrentPos: integer;

begin
  if cbTop.DockClientCount > 0 then
  begin
    if cbTop.DockClients[0] = tbMain then
      CurrentPos := 1
  end
  else if cbLeft.DockClientCount > 0 then
  begin
    if cbLeft.DockClients[0] = tbMain then
      CurrentPos := 2
  end
  else if cbRight.DockClientCount > 0 then
  begin
    if cbRight.DockClients[0] = tbMain then
      CurrentPos := 3
  end
  else
    CurrentPos := 4;

  tbMain.ManualDock(cbTop);

  btnSpacer5.visible := false;
  btnSpacer6.visible := false;
  btnSpacer7.visible := false;

  btnNewKnifeSingle.Left := 0;
  btnNewKnifeSet.Left := 27;
  btnNewMaterial.Left := 54;
  btnNewPart.Left := 81;
  btnNewConstruction.Left := 108;
  btnNewStyle.Left := 135;
  btnNewTicket.Left := 162;
  btnSpacer1.Left := 189;

  btnOpenKnife.Left := 199;
  btnOpenMaterial.Left := 226;
  btnOpenPart.Left := 253;
  btnOpenConstruction.Left := 280;
  btnOpenStyle.Left := 307;
  btnOpenTicket.Left := 334;
  btnSpacer2.Left := 361;

  btnAllKnives.Left := 371;
  btnAllMaterials.Left := 398;
  btnAllParts.Left := 425;
  btnAllConstructions.Left := 452;
  btnAllStyles.Left := 479;
  btnAllTickets.Left := 506;
  btnSpacer3.Left := 533;

  btnAssessKnives.Left := 543;
  btnOpenLayplanning.Left := 597;
  btnBulkLayplanning.Left := 624;

  btnSpacer4.Left := 651;
  btnStatus.Left := 661;


  case CurrentPos of
    1: begin
         tbMain.ManualDock(NullDockSite);
         tbMain.ManualDock(cbTop);
       end;
    2: begin
         tbMain.ManualDock(NullDockSite);
         tbMain.ManualDock(cbLeft);
       end;
    3: begin
         tbMain.ManualDock(NullDockSite);
         tbMain.ManualDock(cbRight);
       end;
    4: begin
         tbMain.ManualDock(cbTop);
         tbMain.ManualDock(NullDockSite);
       end;
  end;

  ToolBarTypeStatus := 2;
end;

procedure TfmSumms.ReadSummsIni;
var
  S: string;

begin
  Identifier := SystemIni.ReadString('Client', 'IDENTIFIER', '');
  MultipleCopies := SystemIni.ReadBool('Client', 'MULTIPLECOPIES', False);

  LastPartSizeRange := SystemIni.ReadString('Application Options', 'LASTPARTSIZERANGE', '');
  LastPartWidthRange := SystemIni.ReadString('Application Options', 'LASTPARTWIDTHRANGE', '');
  KnifeSizeScale := SystemIni.ReadString('Application Options', 'LASTKNIFESIZESCALE', '');
  KnifeMeasuredSize := SystemIni.ReadString('Application Options', 'LASTKNIFEMEASUREDSIZE', '');
  mmSaveScreenPosition.checked := SystemIni.ReadBool('Application Options', 'SAVESCREENPOSITION', False);
  if mmSaveScreenPosition.checked = True then
  begin
    MaxIt := SystemIni.ReadBool('Application Options', 'APPLICATIONMAXIMISED', False);

    if not MaxIt then
    begin
      fmSumms.height := SystemIni.ReadInteger('Application Options', 'APPLICATIONHEIGHT', fmSumms.height);
      fmSumms.width := SystemIni.ReadInteger('Application Options', 'APPLICATIONWIDTH', fmSumms.width);
      fmSumms.left := SystemIni.ReadInteger('Application Options', 'APPLICATIONLEFT', fmSumms.left);
      fmSumms.top := SystemIni.ReadInteger('Application Options', 'APPLICATIONTOP', fmSumms.top);
    end;
  end;

  mmMinimiseAllOnOpen.checked := SystemIni.ReadBool('Menu Options', 'MINIMISEALLONOPEN', False);
  mmPrintPreview100.checked := SystemIni.ReadBool('Menu Options', 'PRINTPREVIEW100', False);
  mmPrintPreviewMax.checked := SystemIni.ReadBool('Menu Options', 'PRINTPREVIEWMAX', False);
  mmNormaliseOnClose.checked := SystemIni.ReadBool('Menu Options', 'NORMALISEONCLOSE', True);
  mmOpenTicketsInCentre.checked := SystemIni.ReadBool('Menu Options', 'OPENTICKETSINCENTRE', False);
  mmStatusBar.checked := SystemIni.ReadBool('Menu Options', 'STATUSBAR', True);
  ToolBarPosStatus := SystemIni.ReadInteger('Menu Options', 'TOOLBARPOS', 1);
  ToolBarTypeStatus := SystemIni.ReadInteger('Menu Options', 'TOOLBARTYPE', 1);
  mmToolBarLocked.Checked := SystemIni.ReadBool('Menu Options', 'TOOLBARLOCKED', False);
  mmLogo.checked := SystemIni.ReadBool('Menu Options', 'LOGO', True);
  mmTicketsUpdateQualityArea.Checked := SystemIni.ReadBool('Menu Options', 'TICKETSUPDATEQUALITYAREA', False);
  mmTicketsUpdateIssuedAllowanceSms.Checked := SystemIni.ReadBool('Menu Options', 'TICKETSUPDATEISSUEDALLOWANCESMS', False);
  mmTicketsUpdateBoth.Checked := SystemIni.ReadBool('Menu Options', 'TICKETSUPDATEBOTH', True);
  mmTicketsUpdateCutWeek.Checked := SystemIni.ReadBool('Menu Options', 'TICKETSUPDATECUTWEEK', True);
  mmTicketsUpdateCutter.Checked := SystemIni.ReadBool('Menu Options', 'TICKETSUPDATECUTTER', True);
  mmTicketsUpdateCutterLocation.Checked := SystemIni.ReadBool('Menu Options', 'TICKETSUPDATECUTTERLOCATION', True);
  mmTicketsUpdateMaterialSupplier.Checked := SystemIni.ReadBool('Menu Options', 'TICKETSUPDATEMATERIALSUPPLIER', True);
  mmTicketsUpdateMaterialPrice.Checked := SystemIni.ReadBool('Menu Options', 'TICKETSUPDATEMATERIALPRICE', True);
  mmTicketsUpdateMaterialUsed.Checked := SystemIni.ReadBool('Menu Options', 'TICKETSUPDATEMATERIALUSED', True);
  mmDeleteExternalInAfterRead.Checked := SystemIni.ReadBool('Menu Options', 'DELETEEXTERNALINAFTERREAD', False);
  mmExpandedTicketSearch.Checked := SystemIni.ReadBool('Menu Options', 'EXPANDEDTICKETSEARCH', False);
  mmGroupPrintByMaterial.Checked := SystemIni.ReadBool('Menu Options', 'GROUPPRINTBYMATERIAL', False);
  mmTagNoOnMaterialSummary.Checked := SystemIni.ReadBool('Menu Options', 'TAGNOONMATERIALSUMMARY', False);
  mmUseExtendedUpdatedOUT.Checked := SystemIni.ReadBool('Menu Options', 'EXTENDEDUPDATEDOUT', False);
  mmAutoEdit.Checked := SystemIni.ReadBool('Menu Options', 'AUTOEDIT', False);
  mmLargeToSmall.Checked := SystemIni.ReadBool('Menu Options', 'CADDESCENDING', True);
  mmGridLines.Checked := SystemIni.ReadBool('Menu Options', 'GRIDLINESONTICKET', True);
  mmSmallToLarge.Checked := not mmLargeToSmall.Checked;
  AllowGroupDeleteTickets := SystemIni.ReadBool('Client Options', 'ALLOWGROUPDELETETICKETS', True);

  ExtendedUpdatedOUT := mmUseExtendedUpdatedOUT.Checked;
  sbMain.visible := mmStatusBar.checked;
  imgSystem.Visible := mmLogo.Checked;
  frxReportSettings.NormaliseOnClose := mmNormaliseOnClose.Checked;

  if (Identifier = '') or (Identifier = '          ') then
  begin
    Randomize;
    str(random(2147483647) : 10, s);
    while Pos(' ', s) > 0 do
      s[Pos(' ', s)] := '0';
    Identifier := s;
  end
  else if length(Identifier) > 10 then
    //Manually changed to more than 10 characters
    Identifier := Copy(Identifier, 1, 10);

  //Secondary Identifier too...
  if MultipleCopies then
  begin
    Randomize;
    str(random(2147483647) : 10, s);
    while Pos(' ', s) > 0 do
      s[Pos(' ', s)] := '0';
    Identifier := Identifier + '/' + s;
  end;

  sbMain.Panels[3].text := 'Client : ' + Identifier;
end;

procedure TfmSumms.WriteSummsIni;
var
  Identifier10: string;

begin
  //Ensure if Identifier changed Manually it is
  //at least 10 characters long, and, if it has
  //a sub number due to 2 work stations on same PC,
  //then it is ignored in .INI file.

  Identifier10 := Identifier;
  while length(Identifier10) < 10 do
    Identifier10 := Identifier10 + ' ';
  Identifier10 := Copy(Identifier10, 1, 10);

  try
    UpdateToolBarMenu;

    SystemIni.WriteString('Client', 'IDENTIFIER', Identifier10);
    SystemIni.WriteBool('Client', 'MULTIPLECOPIES', MultipleCopies);
    SystemIni.WriteString('Application Options', 'LASTPARTSIZERANGE', LastPartSizeRange);
    SystemIni.WriteString('Application Options', 'LASTPARTWIDTHRANGE', LastPartWidthRange);
    SystemIni.WriteString('Application Options', 'LASTKNIFESIZESCALE', KnifeSizeScale);
    SystemIni.WriteString('Application Options', 'LASTKNIFEMEASUREDSIZE', KnifeMeasuredSize);
    SystemIni.WriteBool('Application Options', 'SAVESCREENPOSITION', mmSaveScreenPosition.checked);

    if mmSaveScreenPosition.checked = true then
    begin
      SystemIni.WriteBool('Application Options', 'APPLICATIONMAXIMISED', (fmSumms.WindowState = wsMaximized));
      if fmSumms.WindowState = wsNormal then
      begin
        SystemIni.WriteInteger('Application Options', 'APPLICATIONHEIGHT', fmSumms.height);
        SystemIni.WriteInteger('Application Options', 'APPLICATIONWIDTH', fmSumms.width);
        SystemIni.WriteInteger('Application Options', 'APPLICATIONLEFT', fmSumms.left);
        SystemIni.WriteInteger('Application Options', 'APPLICATIONTOP', fmSumms.top);
      end;
    end;

    SystemIni.WriteBool('Menu Options', 'MINIMISEALLONOPEN', mmMinimiseAllOnOpen.checked);
    SystemIni.WriteBool('Menu Options', 'PRINTPREVIEW100', mmPrintPreview100.checked);
    SystemIni.WriteBool('Menu Options', 'PRINTPREVIEWMAX', mmPrintPreviewMax.checked);
    SystemIni.WriteBool('Menu Options', 'NORMALISEONCLOSE', mmNormaliseOnClose.checked);
    SystemIni.WriteInteger('Menu Options', 'TOOLBARPOS', ToolBarPosStatus);
    SystemIni.WriteInteger('Menu Options', 'TOOLBARTYPE', ToolBarTypeStatus);
    SystemIni.WriteBool('Menu Options', 'OPENTICKETSINCENTRE', mmOpenTicketsInCentre.checked);
    SystemIni.WriteBool('Menu Options', 'STATUSBAR', mmStatusBar.checked);
    SystemIni.WriteBool('Menu Options', 'LOGO', mmLogo.checked);
    SystemIni.WriteBool('Menu Options', 'TICKETSUPDATEQUALITYAREA', mmTicketsUpdateQualityArea.Checked);
    SystemIni.WriteBool('Menu Options', 'TICKETSUPDATEISSUEDALLOWANCESMS', mmTicketsUpdateIssuedAllowanceSms.Checked);
    SystemIni.WriteBool('Menu Options', 'TICKETSUPDATEBOTH', mmTicketsUpdateBoth.Checked);
    SystemIni.WriteBool('Menu Options', 'TICKETSUPDATECUTWEEK', mmTicketsUpdateCutWeek.Checked);
    SystemIni.WriteBool('Menu Options', 'TICKETSUPDATECUTTER', mmTicketsUpdateCutter.Checked);
    SystemIni.WriteBool('Menu Options', 'TICKETSUPDATECUTTERLOCATION', mmTicketsUpdateCutterLocation.Checked);
    SystemIni.WriteBool('Menu Options', 'TICKETSUPDATEMATERIALSUPPLIER', mmTicketsUpdateMaterialSupplier.Checked);
    SystemIni.WriteBool('Menu Options', 'TICKETSUPDATEMATERIALPRICE', mmTicketsUpdateMaterialPrice.Checked);
    SystemIni.WriteBool('Menu Options', 'TICKETSUPDATEMATERIALUSED', mmTicketsUpdateMaterialUsed.Checked);
    SystemIni.WriteBool('Menu Options', 'DELETEEXTERNALINAFTERREAD', mmDeleteExternalInAfterRead.Checked);
    SystemIni.WriteBool('Menu Options', 'EXPANDEDTICKETSEARCH', mmExpandedTicketSearch.Checked);
    SystemIni.WriteBool('Menu Options', 'GROUPPRINTBYMATERIAL', mmGroupPrintByMaterial.Checked);
    SystemIni.WriteBool('Menu Options', 'TAGNOONMATERIALSUMMARY', mmTagNoOnMaterialSummary.Checked);
    SystemIni.WriteBool('Menu Options', 'EXTENDEDUPDATEDOUT', mmUseExtendedUpdatedOUT.Checked);
    SystemIni.WriteBool('Menu Options', 'AUTOEDIT', mmAutoEdit.Checked);
    SystemIni.WriteBool('Menu Options', 'CADDESCENDING', mmLargeToSmall.Checked);
    SystemIni.WriteBool('Menu Options', 'GRIDLINESONTICKET', mmGridLines.Checked);
    SystemIni.WriteBool('Client Options', 'ALLOWGROUPDELETETICKETS', AllowGroupDeleteTickets);
    SystemIni.WriteBool('Menu Options', 'TOOLBARLOCKED', mmToolBarLocked.Checked);
  except
    on E: Exception do
      MessageDlgPos(SystemAlias + ' NOT saved', mtWarning, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end;
end;

procedure TfmSumms.mmTicketsAnalysisClick(Sender: TObject);
var
  fmAnalyse: TfmAnalyse;

begin
  if not ExistingToFront('Analysis', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmAnalyse := TfmAnalyse.create(fmSumms);
      fmAnalyse.PassFormName(fmAnalyse);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmTicketsExternalinClick(Sender: TObject);
var
  Failed: boolean;

begin
  Failed := false;

  if DirectoryExists(TicketsDirectory) then
    dlgOpenExternalFile.InitialDir := TicketsDirectory
  else
  begin
    MessageDlgPos('Parameters | Tickets directory does not exist', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    dlgOpenExternalFile.InitialDir := ExtractFileDrive(ExpandFileName(Application.EXEName));
  end;

  dlgOpenExternalFile.FileName := '';
  if (dlgOpenExternalFile.Execute) then
  begin
    try
      fmExternalIn := TfmExternalIn.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;
    if not Failed then
      fmExternalIn.ImportExternal(dlgOpenExternalFile.FileName);
  end;
end;

procedure TfmSumms.FormShow(Sender: TObject);
var
  s: string;

begin
  if ConnectionSumms.Connected then
  begin
    CheckDongle(PROTECTION_CHECK);
    screen.OnActiveFormChange := CallCheckDongle;
    Application.OnException := HandleExceptions;

    if Option_FullSynthetics and (not Option_LegacySynthetics) then
    begin
      qCountLegacySyntheticParts.open;
      if qCountLegacySyntheticPartsTotal.value > 0 then
      begin
        s := 'You must have ''Legacy Synthetics'' ';
        Force_LegacySynthetics := True;
      end;
      qCountLegacySyntheticParts.close;
    end;

    if (not Option_FullSynthetics) and Option_LegacySynthetics then
    begin
      qCountFullSyntheticParts.open;
      if qCountFullSyntheticPartsTotal.value > 0 then
      begin
        s := 'You must have ''Full Synthetics'' ';
        Force_FullSynthetics := True;
      end;
      qCountFullSyntheticParts.close;
    end;
    if Force_LegacySynthetics or Force_FullSynthetics then
    begin
      s := s + #13 +
           'when Parts are set to use it.' + #13#13 +
           'Please contact SATRA.';
      MessageDlgPos(s, mtWarning, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      SetFeatures;
    end;
  end;

  s := 'Version : ' + ProgramVersion;
  {$IFDEF WIN32}
  s := s + ' (32 bit)';
  {$ENDIF}
  {$IFDEF WIN64}
  s := s + ' (64 bit)';
  {$ENDIF}
  sbMain.Panels[0].text := s;
  sbMain.Panels[2].text := 'User : ' + SystemUserName;

  //Check Defaults are valid for this version
  //IF they haven't been checked before.
  if (not UpdatedInitialisation) then
  begin
    if (not Option_Leather) then
    begin
      s := 'UPDATE KNFDFLTS SET Type = ''S'';';
      qUpdateDefaults.SQL.Add(s);
      s := 'UPDATE MATDFLTS SET Type = ''S'', CutType = ''E'';';
      qUpdateDefaults.SQL.Add(s);
    end;
    s := 'UPDATE PARAMS SET UpdatedInitialisation = True;';
    qUpdateDefaults.SQL.Add(s);

    qUpdateDefaults.ExecSQL;

    //Redo Parameters Query
    qParameters.open;
    qParameters.close;
  end;

  Screen.cursor := crDefault;
end;

procedure TfmSumms.CallCheckDongle(Sender: TObject);
begin
  CheckDongle(FAST_PRESENCE_CHECK);
end;

procedure TfmSumms.cbLeftDockOver(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source.Control is TToolbar;
end;

procedure TfmSumms.cbRightDockOver(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
	Accept := Source.Control is TToolbar;
end;

procedure TfmSumms.cbTopDockOver(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
	Accept := Source.Control is TToolbar;
end;

procedure TfmSumms.FormCreate(Sender: TObject);
var
  AppDirPath: string;
  OSVer: string;

begin
  MasterPassword := GetMasterPassword;

  FirstTime := True;
  ClosingSystem := False;
  NagAgain := True;
  CreatingFullReport := False;

  clMain := $00F6F6F6;
  clBack := $00EAEAEA;
  clBackDark := $00DDDDDD;
  clBackVeryDark := $00A0A0A0; //$00D0D0D0;
  clText := $00707070;
  clData := clBlack;
  clData2 := clBlue;
  clEditing := clWindow;
  clWarningRed := clRed;
  clWarningAmber := $000080FF;

  Force_FullSynthetics := False;
  Force_LegacySynthetics := False;

  SystemName := 'SATRASumm';
  SystemAlias := 'SATRASUMM8';
  AppDirPath := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA) + '\SATRA\SATRASumm';
  ForceDirectories(AppDirPath);
  SystemIniName := AppDirPath + '\SATRASumm8.ini';
  LayplanIniName := AppDirPath + '\SummsLayplanIni.ini';

  SystemIni := TIniFile.Create(SystemIniName);

  //Because Eastern Europeans have numbers in the format 1,34
  //rather than 1.34 which doesn't go down too well in SQL...
  FormatSettings.DecimalSeparator := '.';
  //From Google groups - the exact problem Garry had at Sievin Jalkine
  //Question...
  //"Decimalseparator" changes in runtime.

  //We now observe that while the application is running, that the decimalseparator in the application
  //is changed to the Windows value of  the decimalseparator.

  //Answer...
  //If Windows sends a WM_WININICHANGE message to your application (change
  //any system settings or set the time) or if a user login to Windows
  //(RM_TaskBarCreated) the appliciation call GetFormatSettings to reset the
  //variables.

  //You must set Application.UpdateFormatSettings to False to prevent this.
  Application.UpdateFormatSettings := False;

  Application.HintHidePause := 5000; //5 Sec

  //Required to ensure locale settings correct in Windows 7
  SetThreadLocale(LOCALE_USER_DEFAULT);
  GetFormatSettings;

  Caption := SystemName;
  tbMain.Caption := SystemName + ' Toolbar';
  WindowMenu := mmSumms.Items.Find('Windows');

  ReadSummsIni;
  HasClosed := False;

  OSVer := GetOSVersionText;

  if (pos('Microsoft Windows Vista', OSVer) > 0) then
    ForceRedraw := True
  else
    ForceRedraw := False;

   AutoColor(Self);

   pnlBackground.Visible := false;
   pnlBackground.Align := alClient;

   FClientInstance := MakeObjectInstance(ClientWndProc);
   FPrevClientProc := Pointer(GetWindowLong(ClientHandle, GWL_WNDPROC));
   SetWindowLong(ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));
end;

procedure TfmSumms.mmUtilitiesSMRateTableClick(Sender: TObject);
begin
  if not ExistingToFront('SM Rate Table', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmSMRateTable := TfmSMRateTable.Create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmTicketsAuditClick(Sender: TObject);
begin
  if not ExistingToFront('Audit', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmAudit:= TfmAudit.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmOpenTicketsinCentreClick(Sender: TObject);
begin
  mmOpenTicketsInCentre.Checked := not mmOpenTicketsInCentre.Checked;
end;

procedure TfmSumms.mmUseExtendedUpdatedOUTClick(Sender: TObject);
begin
  mmUseExtendedUpdatedOUT.Checked := not mmUseExtendedUpdatedOUT.Checked;
  ExtendedUpdatedOUT := mmUseExtendedUpdatedOUT.Checked;
end;

procedure TfmSumms.mmUtilitiesCloseAllClick(Sender: TObject);
var
  SkipCount, MDIChildCountOriginal: integer;

begin
  if (fmBulkLayplan <> nil) and (fmBulkLayplan.BulkLayplanning or fmBulkLayplan.LoadingLayplans) then
    MessageDlgPos('Not available while Bulk Layplanning.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else
  begin
    Application.ProcessMessages;

    SkipCount := 0;

    while (fmSumms.MDIChildCount > SkipCount) do
    begin
      with MDIChildren[fmSumms.MDIChildCount - 1 - SkipCount] do
      begin
        if (Pos('Loading...', Caption) <= 0) then
        begin
          MDIChildCountOriginal := fmSumms.MDIChildCount;
          if Visible then
            Close;

          application.ProcessMessages;

          if (MDIChildCountOriginal = fmSumms.MDIChildCount) then
            Inc(SkipCount);
        end
        else
          Inc(SkipCount);
      end;
    end;
  end;
end;

procedure TfmSumms.mmSaveScreenPositionClick(Sender: TObject);
begin
  mmSaveScreenPosition.Checked := not mmSaveScreenPosition.Checked;
end;

procedure TfmSumms.mmNormaliseOnCloseClick(Sender: TObject);
begin
  mmNormaliseOnClose.checked := not mmNormaliseOnClose.checked;
  frxReportSettings.NormaliseOnClose := mmNormaliseOnClose.Checked;
end;

procedure TfmSumms.mmNotUpdatedClick(Sender: TObject);
begin
  if not ExistingToFront('Tickets Not Updated', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmTicketsNotUpdated := TfmTicketsNotUpdated.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  CloseMe: boolean;
  i: integer;
  Forms: array of TForm;

begin
  //screen.OnActiveFormChange := nil;

  if ConnectionSumms.Connected then
  begin
    ClosingSystem := True;

    CloseMe := True;
    if MessageDlgPos('Exit ' + SystemName + '?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
    begin
      setLength(Forms, 0);

      i := 0;
      while CanClose and (i <= ComponentCount - 1) do
      begin
        if (Components[I] is TForm) then
        begin
          if (Components[I] as TForm).visible then
          begin
            setLength(Forms, Length(Forms) + 1);
            Forms[Length(Forms) - 1] := (Components[I] as TForm);
          end;
        end;
        inc(i);
      end;

      for i := 0 to Length(Forms) - 1 do
      begin
        try
          Forms[i].close;
        except
          //At least one window open - That window
          //should have raised a user friendly exception
          CloseMe := False;
        end;
      end;

      CanClose := CloseMe
    end
    else
    begin
      CanClose := false;
      screen.OnActiveFormChange := CallCheckDongle;
    end;

    if CanClose then
    begin
      WriteSummsIni;
      SystemIni.Free;
    end
    else
      ClosingSystem := False;
  end;
end;

procedure TfmSumms.mmKnivesSwapClick(Sender: TObject);
begin
  fmKnivesToSwap.ShowModal
end;

procedure TfmSumms.Features1Click(Sender: TObject);
var
  Failed: Boolean;

begin
  if not ExistingToFront('Features', '') then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmFeatures := TfmFeatures.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := True;
    end;

    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.FormActivate(Sender: TObject);
begin
  //These Windows must be opened at least once before they are
  //required or else their buttons fail to work. Initially they
  //are off screen at -1000 (see FormShow for the 2 forms) so
  //we can't see them. Setting visible property didn't solve
  //that problem. It seemed that if they are not visible, no
  //memory is 'reserved'.

  //The Deactivate procs do not want to be turned on until this
  //'initialisation' has taken place

  if FirstTime then
  begin
    case ToolBarPosStatus of
      1: begin
           //Already at top (default) so must be moved away
           //and back again or else not picked up as docked
           //which the procedure UpdateToolBarMenu needs
           tbMain.ManualDock(cbLeft);
           tbMain.ManualDock(cbTop);
         end;
      2: tbMain.ManualDock(cbLeft);
      3: tbMain.ManualDock(cbRight);
      4: tbMain.Visible := False;
    end;

    if ToolBarTypeStatus = 2 then
      AlternativeToolbar;

    if MaxIt then
      WindowState := wsMaximized;
    FirstTime := False;

  end;

  fmMemoryError.close;
  fmMemoryError.OnDeactivate := fmMemoryError.FormDeactivate;
end;

procedure TfmSumms.qParametersAfterOpen(DataSet: TDataSet);
begin
  Company := qParametersCompany.value;
  BatchSize := qParametersBatchSize.value;
  AutoCreateConstruction := qParametersAutoCreateConstruction.value;
  AutoDeleteConstruction := qParametersAutoDeleteConstruction.value;
  SplitTickets := qParametersSplitTickets.value;
  SplittingScheme := qParametersSplittingScheme.value;
  CADDirectory := qParametersCADDirectory.value;
  TicketsDirectory := qParametersTicketsDirectory.value;
  StylePicDirectory := qParametersStylePicDirectory.value;
  DifficultLeatherFacility := qParametersDifficultLeatherFacilty.value;
  LinesInLeatherGrid := qParametersLinesInLeatherGrid.value;
  RowsInLeatherGrid := qParametersRowsInLeatherGrid.value;
  TableLength := qParametersTableLength.value;
  TitleFontName := qParametersTitleFontName.value;
  TitleFontSize := qParametersTitleFontSize.value;
  TitleFontCharset := qParametersTitleFontCharset.value;
  TitleFontStyle := FontStyle(qParametersTitleFontStyle.value);
  StandardFontName := qParametersStandardFontName.value;
  StandardFontSize := qParametersStandardFontSize.value;
  StandardFontCharset := qParametersStandardFontCharset.value;
  StandardFontStyle := FontStyle(qParametersStandardFontStyle.value);
  FixedFontName := qParametersFixedFontName.value;
  FixedFontSize := qParametersFixedFontSize.value;
  FixedFontCharset := qParametersFixedFontCharset.value;
  FixedFontStyle := FontStyle(qParametersFixedFontStyle.value);
  FixedCutFontName := qParametersFixedCutFontName.value;
  FixedCutFontSize := qParametersFixedCutFontSize.value;
  FixedCutFontCharset := qParametersFixedCutFontCharset.value;
  FixedCutFontStyle := FontStyle(qParametersFixedCutFontStyle.value);
  PrintTagNumbers := qParametersPrintTagNumbers.value;
  PrintCustomer := qParametersPrintCustomer.value;
  PrintTimes := qParametersPrintTimes.value;
  ShowBarCodeNPic := qParametersShowBarCodeNPic.value;
  AuditPathName := qParametersAuditPathName.value;
  OldAudit := qParametersOldAudit.value;
  ShortTagNo := qParametersShortTagNo.value;
  ClearAuditAfterSave := qParametersClearAuditAfterSave.value;
  IssuedCutWeek := StrToInt(qParametersIssuedCutWeek.value);
  TicketCostedAlw := StrToInt(qParametersTicketCostedAlw.value);
  SummarisedDetailed := strToInt(qParametersSummarisedDetailed.value);
  PrintCutterValue := qParametersPrintCutterValue.value;
  CutterPageThrow := qParametersCutterPageThrow.value;
  SaveOutBasic := qParametersSaveOutBasic.value;
  DefaultMaterialUnits := qParametersMaterialDefaultUnits.value;
  SaveOutBasic := qParametersSaveOutBasic.value;
  ShowWaste := qParametersShowWaste.value;
  GroupPrintSyntheticTickets := qParametersGroupPrintSyntheticTickets.value;
  CreateSyntheticTicketsList := qParametersCreateSyntheticTicketsList.value;
  UpdatedInitialisation := qParametersUpdatedInitialisation.value;
  InterlockingToleranceInterlock := qParametersInterlockingToleranceInterlock.value;
  InterlockingToleranceLayplans := qParametersInterlockingToleranceLayplans.value;
  MadeInPairsDefault := qParametersMadeInPairsDefault.Value;
  WebAddress1 := qParametersWebAddress1.value;
  WebAddress2 := qParametersWebAddress2.value;
  WebAddress3 := qParametersWebAddress3.value;
  WebAddress4 := qParametersWebAddress4.value;
  WebAddress5 := qParametersWebAddress5.value;

  //Force made in Pairs flag if Singles not Allowed
  if not Option_SinglesAllowed then
    MadeInPairsDefault := True;

//  MDIChild autocomplete titlename changes caption everytime it is set. The following
//    Results in double autocompleted titles
//  fmSumms.caption := SystemName;
//  if not (Company = '') then
//    fmSumms.caption := fmSumms.caption + '          Company : ' + Company;

  if not (Company = '') then
    fmSumms.caption := SystemName + '          Company : ' + Company
  else
    fmSumms.caption := SystemName;

  sbMain.Panels[1].text := 'Connection : ' + ConnectionSumms.Params.Values['ServerTypes'];
end;

procedure TfmSumms.FormResize(Sender: TObject);
var
  RemainingWidth: Integer;
  imgLeft, imgTop, imgWidth, imgHeight: integer;

begin
  //Ensure Time visible
  sbMain.Panels[4].Text := DateTimeToStr(Now);

  lblTemp.caption := sbMain.Panels[0].text;
  sbMain.Panels[0].width := lblTemp.Width + 20;
  lblTemp.caption := sbMain.Panels[1].text;
  sbMain.Panels[1].width := lblTemp.Width + 20;
  lblTemp.caption := sbMain.Panels[2].text;
  sbMain.Panels[2].width := lblTemp.Width + 20;
  lblTemp.caption := sbMain.Panels[3].text;
  sbMain.Panels[3].width := lblTemp.Width + 20;
  lblTemp.caption := sbMain.Panels[4].text;
  sbMain.Panels[4].width := lblTemp.Width + 20;

  RemainingWidth := width - sbMain.Panels[0].width
                          - sbMain.Panels[1].width
                          - sbMain.Panels[2].width
                          - sbMain.Panels[3].width
                          - sbMain.Panels[4].width;

  sbMain.Panels[0].width := sbMain.Panels[0].width + (RemainingWidth div 5);
  sbMain.Panels[1].width := sbMain.Panels[1].width + (RemainingWidth div 5);
  sbMain.Panels[2].width := sbMain.Panels[2].width + (RemainingWidth div 5);
  sbMain.Panels[3].width := sbMain.Panels[3].width + (RemainingWidth div 5);

  imgSystem.Height := min(fmSumms.ClientHeight - lblError.Height - sbMain.Height, fmSumms.ClientWidth);
  imgSystem.Width := imgSystem.Height;
  imgSystem.Left := (fmSumms.ClientWidth - imgSystem.Width) div 2;
  imgSystem.Top := sbMain.Height + lblError.Height - sbMain.Height + ((fmSumms.ClientHeight - imgSystem.Height) div 2);
end;

procedure TfmSumms.mmPrintPreview100Click(Sender: TObject);
begin
  mmPrintPreview100.checked := not mmPrintPreview100.checked;
end;

procedure TfmSumms.mmPrintPreviewMaxClick(Sender: TObject);
begin
  mmPrintPreviewMax.checked := not mmPrintPreviewMax.checked;
end;

procedure TfmSumms.qTicketLabelsAfterOpen(DataSet: TDataSet);
var
  i: integer;

begin
  i := 0;

  //CJY: qTicketLabels.FetchOptions.RecordCountMode set to cmTotal
  SetLength(TicketTranslation, qTicketLabels.RecordCount + 1);

  qTicketLabels.RecNo := 1; //CJY changed from qTicketLabels.First
  qTicketLabels.Prior; //CJY changed from qTicketLabels.First
  while not qTicketLabels.eof do
  begin
    inc(i);
    TicketTranslation[i] := qTicketLabelsTranslation.value;
    qTicketLabels.next;
  end;
end;

procedure TfmSumms.mmToolBarAlternativeClick(Sender: TObject);
begin
	AlternativeToolbar;
end;

procedure TfmSumms.mmToolbarClick(Sender: TObject);
begin
  UpdateToolBarMenu;
end;

procedure TfmSumms.mmToolBarFloatingClick(Sender: TObject);
begin
  tbMain.ManualDock(NullDockSite);
end;

procedure TfmSumms.mmToolBarLeftClick(Sender: TObject);
begin
  tbMain.ManualDock(cbLeft);
end;

procedure TfmSumms.mmToolBarLockedClick(Sender: TObject);
begin
	mmToolBarLocked.Checked := not mmToolBarLocked.Checked;
end;

procedure TfmSumms.mmToolBarOffClick(Sender: TObject);
begin
	tbMain.visible := False;
end;

procedure TfmSumms.mmToolBarRightClick(Sender: TObject);
begin
  tbMain.ManualDock(cbRight);
end;

procedure TfmSumms.mmToolBarStandardClick(Sender: TObject);
begin
  StandardToolbar;
end;

procedure TfmSumms.mmToolBarTopClick(Sender: TObject);
begin
  //MAYBE Already at top (default) so must be moved away
  //and back again or else not picked up as docked
  //which the procedure UpdateToolBarMenu needs
  //(This can happen if we open program with it set Off
  //and then try and turn it on at the top)
  tbMain.ManualDock(cbLeft);
  tbMain.ManualDock(cbTop);
end;

procedure TfmSumms.mmTicketsUpdateGroupClick(Sender: TObject);
var
  Failed: Boolean;
  qClearUpdates: TFDQueryPlus;

begin
  if not ExistingToFront('Tickets Update (Group)', '') then
  begin
    if ExistingToFront('Tickets Update (Bulk)', '') then
      MessageDlgPos('Tickets Update (Bulk) already open', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
    begin
      Screen.cursor := crHourGlass;
      Failed := False;
      try
        qClearUpdates := TFDQueryPlus.Create(Self);
        qClearUpdates.Connection := ConnectionSumms;
        qClearUpdates.SQL.Text  := 'DELETE FROM TicketUpdate ' +
                                      'WHERE Identifier = ''' + Identifier + ''';';
        qClearUpdates.ExecSQL;
        FreeAndNil(qClearUpdates);

        fmTicketUpdate := TfmTicketUpdate.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := True;
      end;
      Screen.cursor := crDefault;

      if not Failed then
        fmTicketUpdate.Pass;
    end;
  end;
end;

procedure TfmSumms.mmTicketsUpdateBulkClick(Sender: TObject);
var
  Failed: Boolean;

begin
  if not ExistingToFront('Tickets Update (Bulk)', '') then
  begin
    if ExistingToFront('Tickets Update (Group)', '') then
      MessageDlgPos('Tickets Update (Group) already open', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
    begin
      Screen.cursor := crHourGlass;
      Failed := False;
      try
        fmTicketBulkUpdate := TfmTicketBulkUpdate.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := True;
      end;

      if not Failed then
        fmTicketBulkUpdate.Pass;

      Screen.cursor := crDefault;
    end;
  end;
end;

procedure TfmSumms.mmPasswordClick(Sender: TObject);
begin
  fmChangePassword.showModal;
end;

procedure TfmSumms.mmStatusbarClick(Sender: TObject);
begin
  mmStatusBar.Checked := not mmStatusBar.Checked;
  sbMain.visible := mmStatusBar.checked;
end;

procedure TfmSumms.mmDongleInfoClick(Sender: TObject);
begin
	fmDongleInformationGreen.ShowModal;
  CheckDongle(PROTECTION_CHECK);
end;

function TfmSumms.CheckDongle(ProtType: integer): Boolean;
var
  Dongle: TDongle;
  DongleError: Boolean;

begin
  if ProtectionOn then
  begin
  	Dongle := CheckGreenDongle(fmSumms, lblError, ProtType);
    DongleError := Dongle.Error;
  end
  else
    DongleError := False;

  if not DongleError then SetFeatures;
  tmrDongle.Enabled := DongleError;

  Result := DongleError;
end;

procedure TfmSumms.ClientWndProc(var Message: TMessage);
var
  Dc : hDC;
  Row : Integer;
  Col : Integer;
  Pos: real;

begin
  with Message do
    case Msg of
      WM_PAINT:
      begin
        inherited;
        if JustScrolled then
        begin
          pnlBackground.Visible := true;
          pnlBackground.Visible := false;
          JustScrolled := false;
        end;
      end;
      WM_HSCROLL, WM_VSCROLL:
      begin
        inherited;
        JustScrolled := true;
      end;
      else
        Result := CallWindowProc(FPrevClientProc,
                                 ClientHandle,
                                 Msg,
                                 wParam,
                                 lParam);
  end;
end;

procedure TfmSumms.dlgOpenExternalFileShow(Sender: TObject);
var
  dlgRect: TRect;

begin
  //Believed to work the first time but windows overrides the location after this
  //  to the last location of the OpenDialog.
  with dlgOpenExternalFile do
  begin
    GetWindowRect(GetParent(handle), dlgRect);
    SetWindowPos(GetParent(handle), 0, Application.MainForm.Left + (Application.MainForm.Width div 3), Application.MainForm.Top + (Application.MainForm.Height div 3), 0, 0, SWP_NOSIZE);
    Abort;
  end;
end;

procedure TfmSumms.dlgOpenMaterialsShow(Sender: TObject);
var
  dlgRect: TRect;

begin
  //Believed to work the first time but windows overrides the location after this
  //  to the last location of the OpenDialog.
  with dlgOpenMaterials do
  begin
    GetWindowRect(GetParent(handle), dlgRect);
    SetWindowPos(GetParent(handle), 0, Application.MainForm.Left + (Application.MainForm.Width div 3), Application.MainForm.Top + (Application.MainForm.Height div 3), 0, 0, SWP_NOSIZE);
    Abort;
  end;
end;

procedure TfmSumms.dlgOpenPatternFileShow(Sender: TObject);
var
  dlgRect: TRect;

begin
  //Believed to work the first time but windows overrides the location after this
  //  to the last location of the OpenDialog.
  with dlgOpenPatternFile do
  begin
    GetWindowRect(GetParent(handle), dlgRect);
    SetWindowPos(GetParent(handle), 0, Application.MainForm.Left + (Application.MainForm.Width div 3), Application.MainForm.Top + (Application.MainForm.Height div 3), 0, 0, SWP_NOSIZE);
    Abort;
  end;
end;

procedure TfmSumms.mmDongleChangeClick(Sender: TObject);
var
  ExpiryDate: TDateTime;

begin
  fmDongleChangeGreen := TfmDongleChangeGreen.Create(fmSumms);
  fmDongleChangeGreen.ShowModal;
  fmDongleChangeGreen.Release;

  CheckDongle(PROTECTION_CHECK);
end;

procedure TfmSumms.mmTicketsUpdateQualityAreaClick(Sender: TObject);
begin
  mmTicketsUpdateQualityArea.Checked := True;
  mmTicketsUpdateIssuedAllowanceSms.Checked := False;
  mmTicketsUpdateBoth.Checked := False;
end;

procedure TfmSumms.mmTicketsUpdateIssuedAllowanceSmsClick(Sender: TObject);
begin
  mmTicketsUpdateQualityArea.Checked := False;
  mmTicketsUpdateIssuedAllowanceSms.Checked := True;
  mmTicketsUpdateBoth.Checked := False;
end;

procedure TfmSumms.mmTicketsUpdateBothClick(Sender: TObject);
begin
  mmTicketsUpdateQualityArea.Checked := False;
  mmTicketsUpdateIssuedAllowanceSms.Checked := False;
  mmTicketsUpdateBoth.Checked := True;
end;

procedure TfmSumms.mmTicketsUpdateCutWeekClick(Sender: TObject);
begin
  mmTicketsUpdateCutWeek.Checked := not mmTicketsUpdateCutWeek.Checked;
end;

procedure TfmSumms.mmTicketsUpdateCutterClick(Sender: TObject);
begin
  mmTicketsUpdateCutter.Checked := not mmTicketsUpdateCutter.Checked;
end;

procedure TfmSumms.mmTicketsUpdateCutterLocationClick(Sender: TObject);
begin
  mmTicketsUpdateCutterLocation.Checked := not mmTicketsUpdateCutterLocation.Checked;
end;

procedure TfmSumms.mmTicketsUpdateMaterialSupplierClick(Sender: TObject);
begin
  mmTicketsUpdateMaterialSupplier.Checked := not mmTicketsUpdateMaterialSupplier.Checked;
end;

procedure TfmSumms.mmTicketsUpdateMaterialPriceClick(Sender: TObject);
begin
  mmTicketsUpdateMaterialPrice.Checked := not mmTicketsUpdateMaterialPrice.Checked;
end;

procedure TfmSumms.mmDeleteExternalInAfterReadClick(Sender: TObject);
begin
  mmDeleteExternalInAfterRead.Checked := not mmDeleteExternalInAfterRead.Checked;
end;

procedure TfmSumms.mmExpandedTicketSearchClick(Sender: TObject);
begin
  mmExpandedTicketSearch.Checked := not mmExpandedTicketSearch.Checked;
end;

procedure TfmSumms.mmFeaturesClick(Sender: TObject);
var
  Failed: Boolean;

begin
  if not ExistingToFront('Features', '') then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmFeatures := TfmFeatures.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := True;
    end;

    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmGridLinesClick(Sender: TObject);
begin
  mmGridLines.Checked := not mmGridLines.Checked;
end;

procedure TfmSumms.mmGroupPrintByMaterialClick(Sender: TObject);
begin
  mmGroupPrintByMaterial.Checked := not mmGroupPrintByMaterial.Checked;
end;

procedure TfmSumms.mmTicketsUpdateMaterialUsedClick(Sender: TObject);
begin
  mmTicketsUpdateMaterialUsed.Checked := not mmTicketsUpdateMaterialUsed.Checked;
end;

procedure TfmSumms.mmTagNoOnMaterialSummaryClick(Sender: TObject);
begin
  mmTagNoOnMaterialSummary.Checked := not mmTagNoOnMaterialSummary.Checked;
end;

procedure TfmSumms.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ErrorCode: longint;

begin
  screen.OnActiveFormChange := nil;
end;

procedure TfmSumms.tbMainEndDock(Sender, Target: TObject; X, Y: Integer);
begin
	if (Target is TCoolBar) then
  begin
    cbTop.AutoSize := False;
    cbLeft.AutoSize := False;
    cbRight.AutoSize := False;

    if tbMain.width < tbMain.height then
      tbMain.width := 27
    else
      tbMain.height := 26;

    cbTop.AutoSize := True;
    cbLeft.AutoSize := True;
    cbRight.AutoSize := True;

    if (Target as TCoolBar).Name = 'cbTop' then
      mmToolBarTop.Checked := True;
    if (Target as TCoolBar).Name = 'cbLeft' then
      mmToolBarLeft.Checked := True;
    if (Target as TCoolBar).Name = 'cbRight' then
      mmToolBarRight.Checked := True;
  end
  else
    mmToolBarOff.Checked := True;
end;

procedure TfmSumms.tbMainStartDock(Sender: TObject;
  var DragObject: TDragDockObject);
begin
  if mmToolBarLocked.Checked  then
    abort;
  mmToolBarTop.Checked := False;
  mmToolBarLeft.Checked := False;
  mmToolBarRight.Checked := False;
  mmToolBarOff.Checked := False;
end;

procedure TfmSumms.tmrAliveTimer(Sender: TObject);
begin
  try
    qParameters.Open;
    qParameters.Close;
  except;
  end;
end;

procedure TfmSumms.tmrClockTimer(Sender: TObject);
begin
  sbMain.Panels[4].Text := DateTimeToStr(Now);
end;

procedure TfmSumms.tmrDongleTimer(Sender: TObject);
begin
  if NagAgain and (not ClosingSystem) and
                  (not fmDongleChangeGreen.visible) and
                  (not fmDongleInformationGreen.visible) then
  begin
    NagAgain := False;
    MessageDlgPos('Please insert ' + SystemName + ' dongle', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    NagAgain := True;
  end;
end;

procedure TfmSumms.UpdateToolBarMenu;
begin
	if not tbMain.Visible then
    mmToolBarOff.Checked := True
  else if cbTop.DockClientCount > 0 then
  begin
    if cbTop.DockClients[0] = tbMain then
      mmToolBarTop.Checked := True
  end
  else if cbLeft.DockClientCount > 0 then
  begin
    if cbLeft.DockClients[0] = tbMain then
      mmToolBarLeft.Checked := True
  end
  else if cbRight.DockClientCount > 0 then
  begin
    if cbRight.DockClients[0] = tbMain then
      mmToolBarRight.Checked := True
  end
  else
    mmToolBarFloating.Checked := True;

  if mmToolBarTop.Checked or mmToolBarFloating.Checked then
    ToolBarPosStatus := 1
  else if mmToolBarLeft.Checked then
    ToolBarPosStatus := 2
  else if mmToolBarRight.Checked then
    ToolBarPosStatus := 3
  else if mmToolBarOff.Checked then
    ToolBarPosStatus := 4;

  if ToolBarTypeStatus = 1 then
    mmToolBarStandard.Checked := True
  else if ToolBarTypeStatus = 2 then
    mmToolBarAlternative.Checked := True;
end;

procedure TfmSumms.VisionStitch1Click(Sender: TObject);
begin
	ShowWebpage(Sender, WebAddress4);
end;

procedure TfmSumms.mmLargeToSmallClick(Sender: TObject);
begin
  mmLargeToSmall.Checked := True;
  mmSmallToLarge.Checked := False;
end;

procedure TfmSumms.mmLayplansOpenClick(Sender: TObject);
begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Pattern Assessment', '') then
    begin
      if not ExistingToFront('Synthetic Layplanning', '') then
      begin
        Screen.cursor := crHourGlass;
        try
          fmLayplan := TfmLayplanAsChild.create(fmSumms);
          fmAllPatterns := TfmAllPatterns.create(fmSumms);
          fmAllSyntheticMaterials := TfmAllSyntheticMaterials.create(fmSumms);
          fmAllLayplans := TfmAllLayplans.create(fmSumms);
          fmAllLayplansWithoutSelection := TfmAllLayplansWithoutSelection.create(fmSumms);
          {$IFDEF DEBUGFULL}
          fmDebugger := TfmDebugger.create(fmSumms);
          {$ENDIF}
          fmLayplan.LoadingLayplanning := false;
        except
          fmMemoryError.TidyUp(self);
        end;
        Screen.cursor := crDefault;
      end;
    end
    else
      MessageDlgPos('Close Pattern Assessment first', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end;
end;

function TfmSumms.LayplanningInterfaceOUT(CallingForm: TForm;
                                          Knife, Scale, Size, SubUnitDesc, SubUnitAbbrev: string;
                                          Length, Width: Real;
                                          Units: string;
                                          CutGap: integer;
                                          RestrictiveMaterialCode: string): Boolean;
var
  LayplanningOpened: Boolean;

begin
  LayplanningOpened := False;

  if not ExistingToFront('Pattern Assessment', '') then
  begin
    if ExistingToFront('Synthetic Layplanning', '') then
      MessageDlgPos('Synthetic Layplanning already in use.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
    begin
      Screen.cursor := crHourGlass;
      try
        if CallingForm = fmBulklayplan then
          fmLayplan := TfmLayplanAsBulkLayplanner.create(fmSumms)
        else
          fmLayplan := TfmLayplanAsChild.create(fmSumms);
        fmAllPatterns := TfmAllPatterns.create(fmSumms);
        fmAllSyntheticMaterials := TfmAllSyntheticMaterials.create(fmSumms);
        fmAllLayplans := TfmAllLayplans.create(fmSumms);
        fmAllLayplansWithoutSelection := TfmAllLayplansWithoutSelection.create(fmSumms);
        {$IFDEF DEBUGFULL}
        fmDebugger := TfmDebugger.create(fmSumms);
        {$ENDIF}

        fmLayplan.SATRASummInterface(CallingForm, Knife, Scale, Size, SubUnitDesc, SubUnitAbbrev, Length, Width, Units, CutGap, RestrictiveMaterialCode);
        fmLayplan.LoadingLayplanning := false;
      except
        fmMemoryError.TidyUp(self);
      end;

      LayplanningOpened := True;
      Screen.cursor := crDefault;
    end;
  end
  else
    MessageDlgPos('Close Pattern Assessment first', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

  Result := LayplanningOpened;
end;

procedure TfmSumms.mmLogoClick(Sender: TObject);
begin
  mmLogo.Checked := not mmLogo.Checked;
  imgSystem.Visible := mmLogo.Checked;
end;

procedure TfmSumms.btnAllConstructionsClick(Sender: TObject);
begin
	mmBuildConstructionsAll.Click;
end;

procedure TfmSumms.btnAllKnivesClick(Sender: TObject);
begin
	mmKnivesAll.Click;
end;

procedure TfmSumms.btnAllMaterialsClick(Sender: TObject);
begin
	mmBuildMaterialsAll.Click;
end;

procedure TfmSumms.btnAllPartsClick(Sender: TObject);
begin
	mmBuildPartsAll.Click;
end;

procedure TfmSumms.btnAllStylesClick(Sender: TObject);
begin
	mmBuildStylesAll.Click;
end;

procedure TfmSumms.btnAllTicketsClick(Sender: TObject);
begin
	mmTicketsAll.Click;
end;

procedure TfmSumms.btnAssessKnivesClick(Sender: TObject);
begin
	mmAssessKnives.Click;
end;

procedure TfmSumms.btnBulkLayplanningClick(Sender: TObject);
begin
	mmLayplansBulk.Click;
end;

procedure TfmSumms.btnNewConstructionClick(Sender: TObject);
begin
	mmBuildConstructionsNew.Click;
end;

procedure TfmSumms.btnNewKnifeSetClick(Sender: TObject);
begin
  mmKnivesNewSet.Click;
end;

procedure TfmSumms.btnNewKnifeSingleClick(Sender: TObject);
begin
  mmKnivesNewSingle.Click;
end;

procedure TfmSumms.btnNewMaterialClick(Sender: TObject);
begin
  mmBuildMaterialsNew.Click
end;

procedure TfmSumms.btnNewPartClick(Sender: TObject);
begin
  mmBuildPartsNew.Click;
end;

procedure TfmSumms.btnNewStyleClick(Sender: TObject);
begin
  mmBuildStylesNew.Click;
end;

procedure TfmSumms.btnNewTicketClick(Sender: TObject);
begin
	mmTicketsNew.Click;
end;

procedure TfmSumms.btnOpenConstructionClick(Sender: TObject);
begin
	mmBuildConstructionsOpen.Click;
end;

procedure TfmSumms.btnOpenKnifeClick(Sender: TObject);
begin
	mmKnivesOpen.Click;
end;

procedure TfmSumms.btnOpenLayplanningClick(Sender: TObject);
begin
	mmLayplansOpen.Click;
end;

procedure TfmSumms.btnOpenMaterialClick(Sender: TObject);
begin
	mmBuildMaterialsOpen.Click;
end;

procedure TfmSumms.btnOpenPartClick(Sender: TObject);
begin
	mmBuildPartsOpen.Click;
end;

procedure TfmSumms.btnOpenStyleClick(Sender: TObject);
begin
	mmBuildStylesOpen.Click;
end;

procedure TfmSumms.btnOpenTicketClick(Sender: TObject);
begin
	mmTicketsOpen.Click;
end;

procedure TfmSumms.btnStatusClick(Sender: TObject);
begin
	mmSystemStatus.Click;
end;

procedure TfmSumms.mmLayplansBulkClick(Sender: TObject);
begin
  if not ExistingToFront('Bulk Layplanning', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmBulkLayplan := TfmBulkLayplan.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmAssessKnivesClick(Sender: TObject);
var
  Failed: Boolean;

begin
  if not CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Synthetic Layplanning', '') then
    begin
      if not ExistingToFront('Pattern Assessment', '') then
      begin
        Screen.cursor := crHourGlass;
        Failed := False;
        try
          fmAssessKnives := TfmAssessKnives.create(fmSumms);
          {$IFDEF DEBUGFULL}
            fmDebugger := TfmDebugger.create(fmSumms);
          {$ENDIF}
        except
          fmMemoryError.TidyUp(self);
          Failed := True;
        end;

        Screen.cursor := crDefault;
      end;
    end
    else
      MessageDlgPos('Close Synthetic Layplanning first', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end;
end;

procedure TfmSumms.mmAutoEditClick(Sender: TObject);
begin
  mmAutoEdit.Checked := not mmAutoEdit.Checked;
end;

procedure TfmSumms.mmLegacyCheckClick(Sender: TObject);
begin
  if not ExistingToFront('Legacy Check', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmLegacyCheck := TfmLegacyCheck.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

procedure TfmSumms.mmManualKnivesClick(Sender: TObject);
begin
  if not ExistingToFront('Manual Knives Check', '') then
  begin
    Screen.cursor := crHourGlass;
    try
      fmManualKnifeCheck := TfmManualKnifeCheck.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
    end;
    Screen.cursor := crDefault;
  end;
end;

function TfmSumms.GetMasterPassword: string;
var
  CodedPassword: array[0..6] of Char;

begin
  //Encode just enough to hide if read by hex editor

  //monster
  CodedPassword := 'jnnzsdt';

  CodedPassword[0] := chr(Ord(CodedPassword[0]) + 3);
  CodedPassword[1] := chr(Ord(CodedPassword[1]) + 1);
  CodedPassword[2] := chr(Ord(CodedPassword[2]) + 0);
  CodedPassword[3] := chr(Ord(CodedPassword[3]) - 7);
  CodedPassword[4] := chr(Ord(CodedPassword[4]) + 1);
  CodedPassword[5] := chr(Ord(CodedPassword[5]) + 1);
  CodedPassword[6] := chr(Ord(CodedPassword[6]) - 2);

  Result := CodedPassword;
end;

procedure TfmSumms.StartUp;
begin
  //Open all tables
  tblLocks.open;
  tblSizeRelationships.open;
  tblParts.open;
  tblConstructions.open;

  //Opening sets all Parameters
  qParameters.open;
  qParameters.close;
  qTicketLabels.open;
  qTicketLabels.close;
  qMaterialUnits.open;

  fmErrorHandler := TfmErrorHandler.create(fmSumms);
  fmErrorHandler.qAllFields.Connection := fmSumms.ConnectionSumms;
  fmErrorHandler.Initialise;

  dmAdjFact := TdmAdjFact.create(fmSumms);
  dmBasAll := TdmBasAll.create(fmSumms);
  dmCutUtils := TdmCutUtils.create(fmSumms);
  dmCutUtils2 := TdmCutUtils2.create(fmSumms);
  dmTimes := TdmTimes.create(fmSumms);
  dmTimes2 := TdmTimes2.create(fmSumms);
  dmCutUtils2.qAddCuttingElement.Connection := fmSumms.ConnectionSumms;

  tmrAlive.Enabled := True;
end;

begin
 {Tell Delphi to hide it's hidden application window for now to avoid}
 {a "flash" on the taskbar if we halt due to another instance}
  ShowWindow(Application.Handle, SW_HIDE);

end.
