unit LayMainATTEMPT2FIX;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, CButton,  AllPatterns, ToolWin,
  ComCtrls, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus,
  FDTablePlus, Interlocking, Results, Const_Interlocking, General_Interlocking,
  Spin, PBSpinEdit, Merge, Math, PlanIt, Concavities, PBNumEdit, Menus, Ruler,
  Grids, jpeg, IniFiles, CmnVars, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, frxClass, frxReportPlus, PBEdit
{$IFNDEF STANDALONE}
  , Summs, SummsVars, OutOfMemory
{$ENDIF}
  , frxDBSet;

type
  TfmLayplan = class(TForm)
    odBitmap: TOpenDialog;
    LocalConnectionSumms: TFDConnection;
    tblKnives: TFDTablePlus;
    tblKnivesCode: TStringField;
    qPatterns: TFDQueryPlus;
    qPatternsKnife: TStringField;
    qPatternsSeq: TSmallintField;
    qPatternsX: TSmallintField;
    qPatternsY: TSmallintField;
    mnuLayplans: TMainMenu;
    mnuLayplanning: TMenuItem;
    mnuLayPlansClear: TMenuItem;
    N2: TMenuItem;
    mnuLayplansShowCutGaps: TMenuItem;
    mnuLayPlansCreate: TMenuItem;
    mnuLayPlansShowWholeLength: TMenuItem;
    mnuLayPlansPrint: TMenuItem;
    N4: TMenuItem;
    N1: TMenuItem;
    mnuLayPlansPreview: TMenuItem;
    mnuLayPlansShowRemainingEdges: TMenuItem;
    mnuLayPlansSort: TMenuItem;
    mnuLayPlansShowCount: TMenuItem;
    mnuLayPlansShowBorder: TMenuItem;
    pnlLayplans: TPanel;
    tbMain: TPanel;
    btnAllPatterns: TSpeedButton;
    btnCreateLayPlans: TSpeedButton;
    btnClearLayPlans: TSpeedButton;
    btnPrint: TSpeedButton;
    pnlZoomLbl: TPanel;
    lblZoom: TLabel;
    tbZoom: TTrackBar;
    pnlZoomNo: TPanel;
    lblZoomNo: TLabel;
    pnlLeft: TPanel;
    pcSelectionsResults: TPageControl;
    tsSelections: TTabSheet;
    pnlSelections: TPanel;
    pnlParameters1: TPanel;
    rgAdjustmentsAllowed: TRadioGroup;
    pnlParameters3: TPanel;
    rgCornerAnchoring: TRadioGroup;
    pnlParameters4: TPanel;
    rgStartingSide: TRadioGroup;
    rgStartingCriteria: TRadioGroup;
    rgNumberOfResults: TRadioGroup;
    tsResults: TTabSheet;
    tsDebug: TTabSheet;
    sgDebug: TStringGrid;
    pnlRight: TPanel;
    pnlLayPlanAndRulerBottom: TPanel;
    imgLayPlan: TImage;
    imgJaggyEdgeLeft: TImage;
    imgRotatedKnife: TImage;
    imgJaggyEdgeTop: TImage;
    imgJaggyEdgeRight: TImage;
    pnlLayPlanRulerBottom: TPanel;
    rulerLayPlanBottom: TRuler;
    pnlCalculating: TPanel;
    gbCalculating: TGroupBox;
    lblElapsedTime: TLabel;
    lblBestPieces: TLabel;
    lblElapsedTimeText: TLabel;
    lblBestPiecesText: TLabel;
    pbLayPlans: TProgressBar;
    btnAbort: TColButton;
    btnPreview: TColButton;
    pnlPrintPreviewOpen: TPanel;
    lblPrintPreviewOpen: TLabel;
    pnlLayPlanRulerRight: TPanel;
    rulerLayPlanRight: TRuler;
    pnlLayPlanRulerLeft: TPanel;
    rulerLayPlanLeft: TRuler;
    mnuLayplansOpenKnife: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    tsPattern: TTabSheet;
    tblKnivesMeasuredSize: TStringField;
    gbSuggestions: TGroupBox;
    lblAtLeast: TLabel;
    lblGuide: TLabel;
    lblProvided: TLabel;
    lblOrEasier: TLabel;
    sedtSelectionsNo: TPBSpinEdit;
    sedtSelectionsGrade: TPBSpinEdit;
    sedtSelectionsPerc: TPBSpinEdit;
    lblOfBest: TLabel;
    tsMaterial: TTabSheet;
    qMaterialUnits: TFDQueryPlus;
    qMaterialUnitsCode: TStringField;
    qMaterialUnitsUnitDescription: TStringField;
    qMaterialUnitsUnitAbbreviation: TStringField;
    qMaterialUnitsToFeet: TFloatField;
    qMaterialUnitsSubUnitDesc: TStringField;
    qMaterialUnitsSubUnitAbbreviation: TStringField;
    qMaterialUnitsSubUnitsPerUnit: TSmallintField;
    dsMaterialUnits: TDataSource;
    qSaveLayplan: TFDQueryPlus;
    qReadLayplanPacks: TFDQueryPlus;
    qReadLayplanKnives: TFDQueryPlus;
    qReadLayplans: TFDQueryPlus;
    mnuLayplansOpenLayplan: TMenuItem;
    btnAllLayplans: TSpeedButton;
    tblKnivesSizeScale: TStringField;
    btnSaveLayplans: TSpeedButton;
    mnuLayplansSave: TMenuItem;
    btnDeleteLayplans: TSpeedButton;
    mnuLayplansDelete: TMenuItem;
    qDeleteLayplan: TFDQueryPlus;
    btnPrintPreview: TSpeedButton;
    mnuLayplansPrintPreview: TMenuItem;
    mnuLayplansOpenMaterial: TMenuItem;
    btnAllMaterials: TSpeedButton;
    tblKnivesToBeAssessed: TBooleanField;
    qPatternsSizeScale: TStringField;
    qPatternsMeasuredSize: TStringField;
    mnuLayplansShowKnifePreview: TMenuItem;
    gbPacks: TGroupBox;
    cbPacksSquareExcluded: TCheckBox;
    cbPacksOffsetExcluded: TCheckBox;
    cbPacksDiagonalExcluded: TCheckBox;
    cbPacksDiagonalFreeExcluded: TCheckBox;
    rgShowGangs: TRadioGroup;
    gbCuttingGuide: TGroupBox;
    tbCuttingGuide: TTrackBar;
    lblCuttingGuide: TLabel;
    lblNoVisibleLayplan: TLabel;
    mnuLayplansSimpleDrawing: TMenuItem;
    mnuLayplansSimpleDrawingOff: TMenuItem;
    mnuLayplansSimpleDrawingPrintoutsOnly: TMenuItem;
    mnuLayplansSimpleDrawingOn: TMenuItem;
    qReadLayplanPacksKnifeCode: TStringField;
    qReadLayplanPacksKnifeSizeScale: TStringField;
    qReadLayplanPacksKnifeSize: TStringField;
    qReadLayplanPacksMaterialLength: TIntegerField;
    qReadLayplanPacksMaterialWidth: TIntegerField;
    qReadLayplanPacksMaterialCutGap: TIntegerField;
    qReadLayplanPacksMaterialCodeRestrictive: TStringField;
    qReadLayplanPacksLayplanCode: TStringField;
    qReadLayplanPacksSeq: TSmallintField;
    qReadLayplanPacksW2: TBooleanField;
    qReadLayplanPacksBR_Left: TIntegerField;
    qReadLayplanPacksBR_Top: TIntegerField;
    qReadLayplanPacksBR_Right: TIntegerField;
    qReadLayplanPacksBR_Bottom: TIntegerField;
    qReadNumberOfLayplanKnives: TFDQueryPlus;
    qReadLayplanKnivesKnifeCode: TStringField;
    qReadLayplanKnivesKnifeSizeScale: TStringField;
    qReadLayplanKnivesKnifeSize: TStringField;
    qReadLayplanKnivesMaterialLength: TIntegerField;
    qReadLayplanKnivesMaterialWidth: TIntegerField;
    qReadLayplanKnivesMaterialCutGap: TIntegerField;
    qReadLayplanKnivesMaterialCodeRestrictive: TStringField;
    qReadLayplanKnivesKnifeNo: TSmallintField;
    qReadLayplanKnivesRealNotExpanded: TBooleanField;
    qReadLayplanKnivesW2: TBooleanField;
    qReadLayplanKnivesSeq: TSmallintField;
    qReadLayplanKnivesX: TIntegerField;
    qReadLayplanKnivesY: TIntegerField;
    qReadNumberOfLayplanKnivesNoKnives: TSmallintField;
    qReadLayplansKnifeCode: TStringField;
    qReadLayplansKnifeSizeScale: TStringField;
    qReadLayplansKnifeSize: TStringField;
    qReadLayplansMaterialLength: TIntegerField;
    qReadLayplansMaterialWidth: TIntegerField;
    qReadLayplansMaterialCutGap: TIntegerField;
    qReadLayplansMaterialCodeRestrictive: TStringField;
    qReadLayplansLayplanCode: TStringField;
    qReadLayplansSeq: TSmallintField;
    qReadLayplansSqFtPerPiece: TFloatField;
    qReadLayplansStartLeft: TBooleanField;
    qReadLayplansRemHeight: TIntegerField;
    qReadLayplansRemWidth: TIntegerField;
    qReadLayplansDetails2: TStringField;
    qReadLayplansDetails3: TStringField;
    qReadLayplansDetails4: TStringField;
    qReadLayplansDetails5: TStringField;
    qReadLayplansDetails6: TStringField;
    qReadLayplansToleranceUsed: TIntegerField;
    qReadLayplansInput_UsableMaterialLength: TIntegerField;
    qReadLayplansInput_UsableMaterialWidth: TIntegerField;
    qReadLayplansInput_PatternHeight: TIntegerField;
    qReadLayplansInput_PatternWidth: TIntegerField;
    qReadLayplansInput_Square: TBooleanField;
    qReadLayplansInput_FixedStart: TBooleanField;
    qReadLayplansInput_StartLeft: TBooleanField;
    qReadLayplansInput_W2: TBooleanField;
    qReadLayplansInput_FirstCutInCorner: TBooleanField;
    qReadLayplansInput_ForceW1First: TBooleanField;
    qReadLayplansInput_ForceW2First: TBooleanField;
    qReadLayplansInput_LocalInterlock_Used: TBooleanField;
    qReadLayplansInput_LocalInterlock_Reversed: TBooleanField;
    qReadLayplansInput_LocalInterlock_PairedPatternHeight: TIntegerField;
    qReadLayplansInput_LocalInterlock_PairedPatternWidth: TIntegerField;
    qReadLayplansInput_LocalInterlock_SinglePatternHeight: TIntegerField;
    qReadLayplansInput_LocalInterlock_SinglePatternWidth: TIntegerField;
    qReadLayplansInput_LocalInterlock_Vec1x: TIntegerField;
    qReadLayplansInput_LocalInterlock_Vec1y: TIntegerField;
    qReadLayplansInput_LocalInterlock_W2: TBooleanField;
    qReadLayplansInput_LocalInterlock_Pat1_Left: TIntegerField;
    qReadLayplansInput_LocalInterlock_Pat1_Top: TIntegerField;
    qReadLayplansInput_LocalInterlock_Pat1_Right: TIntegerField;
    qReadLayplansInput_LocalInterlock_Pat1_Bottom: TIntegerField;
    qReadLayplansInput_LocalInterlock_Pat2_Left: TIntegerField;
    qReadLayplansInput_LocalInterlock_Pat2_Top: TIntegerField;
    qReadLayplansInput_LocalInterlock_Pat2_Right: TIntegerField;
    qReadLayplansInput_LocalInterlock_Pat2_Bottom: TIntegerField;
    qReadLayplansInput_LocalInterlock_LeftPat: TIntegerField;
    qReadLayplansInput_LocalInterlock_BottomPat: TIntegerField;
    qReadLayplansInput_PackAngle: TFloatField;
    qReadLayplansPropogationNo: TIntegerField;
    qReadLayplansKnifeNo: TSmallintField;
    qReadLayplanSets: TFDQueryPlus;
    qReadLayplanSetsKnifeCode: TStringField;
    qReadLayplanSetsKnifeSizeScale: TStringField;
    qReadLayplanSetsKnifeSize: TStringField;
    qReadLayplanSetsMaterialLength: TIntegerField;
    qReadLayplanSetsMaterialWidth: TIntegerField;
    qReadLayplanSetsMaterialCutGap: TIntegerField;
    qReadLayplanSetsMaterialCodeRestrictive: TStringField;
    qReadLayplanSetsMaterialEdge: TIntegerField;
    qReadLayplanSetsKnifeAngle: TFloatField;
    qReadLayplanSetsSelectedNo: TIntegerField;
    btnLayplansWithoutSelection: TSpeedButton;
    N6: TMenuItem;
    mnuLayplansWithoutSelection: TMenuItem;
    N7: TMenuItem;
    Bulk1: TMenuItem;
    tblKnivesAngle: TFloatField;
    pnlParameters5: TPanel;
    rgMaxGangs: TRadioGroup;
    frLayplan: TfrxReportPlus;
    pnlUnits2: TPanel;
    pnlUnits3: TPanel;
    pnlPatternControls: TPanel;
    shpWheel: TShape;
    lblWheelHelp3: TLabel;
    lblWheelHelp2: TLabel;
    lblWheelHelp1: TLabel;
    pnlInitialAngle: TPanel;
    btnNudgeLeft10: TColButton;
    btnNudgeLeft1: TColButton;
    btnNudgeLeftPoint1: TColButton;
    btnNudgeRight10: TColButton;
    btnNudgeRight1: TColButton;
    btnNudgeRightPoint1: TColButton;
    shpActualAngle0: TShape;
    shpActualAngle10: TShape;
    shpActualAngle15: TShape;
    shpActualAngle20: TShape;
    shpActualAngle25: TShape;
    shpActualAngle5: TShape;
    shpWheelHandle: TShape;
    pnlPatternKnife: TPanel;
    pnlKnifeIncRulers: TPanel;
    pnlKnifeRulerRight: TPanel;
    rulerKnifeLeft: TRuler;
    pnlUnits1: TPanel;
    pnlKnifeAndRuler: TPanel;
    pnlKnife: TPanel;
    imgKnife: TImage;
    pnlKnifeRulerBottom: TPanel;
    rulerKnifeBottom: TRuler;
    pnlPatternTop: TPanel;
    lblKnifeAreaText: TLabel;
    lblKnifeCode: TLabel;
    lblKnifeCodeText: TLabel;
    lblKnifeSize: TLabel;
    lblKnifeSizeText: TLabel;
    lblNettArea1: TLabel;
    lblNettArea2: TLabel;
    lblNettAreaUnits1: TLabel;
    lblNettAreaUnits2: TLabel;
    lblAdjustmentAngle: TLabel;
    imgDegrees: TImage;
    cbUnitsKnife: TComboBox;
    lblKnifeUnitsText: TLabel;
    cbGrid: TCheckBox;
    pnlParameters2: TPanel;
    rgRotationalIncrements: TRadioGroup;
    rgAllowInvertion: TRadioGroup;
    rgOptimisation: TRadioGroup;
    pnlExplanation: TPanel;
    pnlResultTitles: TPanel;
    lblSelectedLayplanText: TLabel;
    lblSelectedLayplan: TLabel;
    sgLayPlans: TStringGrid;
    pnlTitlesMain: TPanel;
    pnlTitles1: TPanel;
    pnlTitles2: TPanel;
    pnlTitles3: TPanel;
    pnlTitles6: TPanel;
    pnlTitles5: TPanel;
    pnlTitles4: TPanel;
    pnlRestrictive: TPanel;
    pnlRoll: TPanel;
    pnlMaterial: TPanel;
    lblNote2: TLabel;
    btnRoll: TColButton;
    btnView: TColButton;
    pedtMaterialLength: TPBNumEdit;
    pedtMaterialWidth: TPBNumEdit;
    sedtExpand: TPBSpinEdit;
    sedtEdge: TPBSpinEdit;
    lblEdge: TLabel;
    lblCutGap: TLabel;
    lblUnits5: TLabel;
    lblMaterialWidth: TLabel;
    lblUnits4: TLabel;
    lblMaterialLength: TLabel;
    lblNote: TLabel;
    pedtRestrictiveMaterial: TPBEdit;
    lblRestrictiveMaterial: TLabel;
    lblRoll: TLabel;
    cbUnitsMaterial: TComboBox;
    lblMaterialUnitsText: TLabel;
    Label1: TLabel;
    procedure PatternInitialise;
    procedure FindInitialise(ShowPretendKnife: Boolean);
    procedure LayPlanInitialise(Angle: real; UseLocalInterlock: Boolean);
    procedure MainKnifeInitialise(UpdateMaterial, Spinning: Boolean);
    procedure btnNudgeLeft10Click(Sender: TObject);
    procedure btnNudgeLeft1Click(Sender: TObject);
    procedure btnNudgeLeftPoint1Click(Sender: TObject);
    procedure btnNudgeRight10Click(Sender: TObject);
    procedure btnNudgeRight1Click(Sender: TObject);
    procedure btnNudgeRightPoint1Click(Sender: TObject);
    procedure MakeBitmap(Pattern: TPattern; ShowGrid: Boolean; No: integer; Spinning: Boolean);
    function ReadPattern(Code, Scale, Size: string): TPointArray;
    procedure FormCreate(Sender: TObject);
    procedure OpenKnife;
    procedure CreateLayplans;
    procedure DisplayResults(img: TImage);
    procedure DisplayMaterial(img: TImage; ShowPretendKnife: Boolean);
    function KerfWidth: integer;
    procedure DrawPretendKnife(Canvas: TCanvas);
    procedure MaterialSizeChange(Sender: TObject);
    procedure CheckMenuItem(Sender: TObject);
    procedure mnuLayPlansClearClick(Sender: TObject);
    procedure btnAllPatternsClick(Sender: TObject);
    procedure ClearLayPlans;
    procedure mnuLayPlansCreateClick(Sender: TObject);
    procedure btnCreateLayPlansClick(Sender: TObject);
    procedure sgLayPlansClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DrawLayPlanRulers;
    procedure UpdateScreen;
    procedure mnuLayplansShowCutGapsClick(Sender: TObject);
    procedure btnClearLayPlansClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
    procedure mnuLayPlansShowWholeLengthClick(Sender: TObject);
    procedure KnifeAtActualRotation(Angle: real; No: integer);
    function W2sUsed: Boolean;
    procedure PrintOutsTopJaggyEdge;
    procedure PrintOutsLeftJaggyEdge;
    procedure PrintOutsRightJaggyEdge;
    procedure SetZoom(Sender: TObject; Level: integer);
    procedure btnPreviewClick(Sender: TObject);
    procedure mnuLayPlansPreviewClick(Sender: TObject);
    procedure rgStartingSideClick(Sender: TObject);
    procedure mnuLayPlansShowRemainingEdgesClick(Sender: TObject);
    procedure AddToKnivesUsed(var CurrentKnife: integer);
    procedure mnuLayPlansSortClick(Sender: TObject);
    procedure SortResults;
    procedure ReadIni;
    procedure WriteIni;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpdateInitialisation(a, b: real; StartTime: TTime);
    procedure mnuLayPlansShowCountClick(Sender: TObject);
    procedure tbZoomChange(Sender: TObject);
    procedure mnuLayPlansShowBorderClick(Sender: TObject);
    procedure FilterResults(NoPlans, NoAnglesPerPlan: integer);
    procedure sgDebugClick(Sender: TObject);
    procedure pcSelectionsResultsChange(Sender: TObject);
    procedure mnuLayplansOpenKnifeClick(Sender: TObject);
    procedure UnminimizeLayMain;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    function ResultsCutOff(No, Grade, Perc: integer): integer;
    function SATRASummInterface(CallingForm: TForm; Code, Scale, Size, SubUnitDesc, SubUnitAbbrev: string;
      MatLength, MatWidth: Real; Units: string; MatCutGap: integer; RestrictiveMaterialCode: string): Boolean;
    procedure LoadUnitsDropDown;
    procedure cbUnitsMaterialChange(Sender: TObject);
    function FindUnitsIndex(UnitsCode: string): integer;
    procedure cbUnitsKnifeChange(Sender: TObject);
    procedure pcSelectionsResultsDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure SaveLayplanSet;
    procedure DeleteLayplanSet;
    procedure btnAllLayplansClick(Sender: TObject);
    procedure mnuLayplansOpenLayplanClick(Sender: TObject);
    procedure btnSaveLayplansClick(Sender: TObject);
    procedure mnuLayplansSaveClick(Sender: TObject);
    procedure btnDeleteLayplansClick(Sender: TObject);
    procedure mnuLayplansDeleteClick(Sender: TObject);
    procedure PrintLayplan(PreviewThis, ShowProgress: Boolean);
    procedure mnuLayplansPrintPreviewClick(Sender: TObject);
    procedure mnuLayplansPrintClick(Sender: TObject);
    procedure btnPrintPreviewClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure mnuLayplansOpenMaterialClick(Sender: TObject);
    procedure btnAllMaterialsClick(Sender: TObject);
    procedure btnRollClick(Sender: TObject);
    procedure SetAsRoll;
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure mnuLayplansShowKnifePreviewClick(Sender: TObject);
    procedure tbCuttingGuideChange(Sender: TObject);
    procedure SortStringGrid(var TheStringGrid: TStringGrid; SortCol: Integer; Ascending: Boolean);
    procedure sgLayPlansDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    function LayplanExists: Boolean;
    procedure RedrawBMPs;
    procedure mnuLayplansSimpleDrawingOffClick(Sender: TObject);
    procedure mnuLayplansSimpleDrawingOnClick(Sender: TObject);
    procedure mnuLayplansSimpleDrawingPrintoutsOnlyClick(Sender: TObject);
    procedure shpWheelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shpWheelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure shpWheelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AngleHandle(HandleAngle: real);
    procedure AngleHand;
    procedure sgLayPlansDblClick(Sender: TObject);
    procedure ReadLayplans;
    procedure UpdateSelectedLayplan;
    function CheckAndSaveLayplan: Boolean;
    procedure mnuLayplansWithoutSelectionClick(Sender: TObject);
    procedure btnLayplansWithoutSelectionClick(Sender: TObject);
    procedure LoadKnife(Code, Scale, Size: string; Angle: Real);
    procedure Bulk1Click(Sender: TObject);
    procedure SetPiecesCaps;
    function ElapsedTime(TheTime: TDateTime): string;
    procedure frLayplanBeforePrint(Sender: TfrxReportComponent);
    procedure frLayplanGetValue(const VarName: string; var Value: Variant);
    procedure AdjustRulersScale;
    procedure cbGridClick(Sender: TObject);
  private
    SummsLayplanINI: TIniFile;
    HasClosed: Boolean;
    LastWheelX, LastWheelY, HandleAngle: integer;
    HoldWheel: Boolean;
    SmallScale: Real;
  public
    { Public declarations }
    KnifeCode, KnifeScale, KnifeSize: string;
    KnifeArea: Real;
    AbortLayplanning: Boolean;
    SelectedLayplan: short;
    AutoOverwrite: short;
  end;

var
  fmLayplan: TfmLayplan;
  OldWindowProc: Pointer;
  MyMsg: DWord;
  TheCallingForm: TForm;
  {$IFDEF DEBUG}
  AllAngles, AllDiagonalFrees, DiagonalFreeTC, KeepArea, TotalAllAngles, WholeCreate: real;
  KeepHeight, KeepWidth, NoPointsInOriginal: integer;
  {$ENDIF}

const
  NegligableRemain = 0.25;   //SqM
{$IFDEF STANDALONE}
  Option_ProductionSystem = True;        //Allows all features when standalone
  InterlockingToleranceInterlock = 1000;
  InterlockingToleranceLayplans = 100;
{$ENDIF}
{$IFDEF DEBUG}
  ReleasedVersionConst = False;
{$ENDIF}
{$IFNDEF DEBUG}
  ReleasedVersionConst = True;
{$ENDIF}

implementation

uses AllLayplans, AllSyntheticMaterials, FILT,
  AdvErrorHandler, AllLayplansWithoutSelection, BulkLayplan, Dongle_Green
{$IFNDEF STANDALONE}
  , General
{$ENDIF}
{$IFDEF DEBUGFULL}
  , Debugger
{$ENDIF}
  ;

{$R *.dfm}

type
  TLayplan = record
    StartLeft: Boolean;
    RemHeight, RemWidth: real;

    Pack: TCutResult;
    PropogationInput: TPropogationInput;
    PropogationNo: integer;
  end;
  TSaveKnife = record
    Save: Boolean;
    NewNo: short;
  end;

var
  LayPlans: array of TLayplan;
  ActualPoints, OriginalPoints: TPointArray;
  AdjustmentAngle: Real;
  PictureSize: integer;
  KnifeLoaded, Calculating, Saving, LayPlansLoaded, PreviewThis, Errors: Boolean;
  MaterialLength, MaterialWidth, Edge, UsableMaterialLength, UsableMaterialWidth, Zoom: integer;
  VisibleMaterialLength: integer;
  clMaterial: TColor;
  LIKnifeW1, LIKnifeW2: TPattern;
  ResultsCaption: string;
  IsRoll: Boolean;
  SummsUnits, KnifeUnits: string;
  SummsToFtMultiplier, SummsToCmMultiplier, KnifeToFtMultiplier, KnifeToCmMultiplier: Real;
  CanSave, SelectedLayplanChanged, ReleasedVersion: Boolean;
  FromSATRASumm, FromSATRASummSized, FromBulkLayplanning: Boolean;
  CanChangeCutGapFromSATRASumm: Boolean;
  SelectedLayplanWhenLoaded: short;
  KnivesToSave: array of TSaveKnife;

function NewWindowProc(WindowHandle : hWnd;
                       TheMessage   : LongInt;
                       ParamW       : LongInt;
                       ParamL       : LongInt) : LongInt stdcall;

begin
  if TheMessage = MyMsg then
  begin
   {Tell the application to restore, let it restore the form}
    SendMessage(Application.handle, WM_SYSCOMMAND, SC_RESTORE, 0);
    SetForegroundWindow(Application.Handle);

    Result := 0;
    exit;
  end;
 {Call the original winproc}
  Result := CallWindowProc(OldWindowProc, WindowHandle, TheMessage, ParamW, ParamL);
end;

procedure TfmLayplan.PatternInitialise;
begin
  imgKnife.Picture.Bitmap := nil;

  SetLength(CutResults, 0);
  NewKnife := True;
  AdjustmentAngle := 0;

  AngleHand;

  FindInitialise(False);
end;

procedure TfmLayplan.MainKnifeInitialise(UpdateMaterial, Spinning: Boolean);
var
  s: string;
  ImageHeight10CM: real;
  OldKnifeToFtMultiplier: Real;

begin
  KnifeLoaded := True;
  LayPlansLoaded := False;

  if AdjustmentAngle > 180 then
    AdjustmentAngle := AdjustmentAngle - 360
  else if AdjustmentAngle <= -180 then
    AdjustmentAngle := AdjustmentAngle + 360;

  str(AdjustmentAngle : 4 : 1, s);
  lblAdjustmentAngle.Caption := s;

//  if Length(OriginalPoints) > 0 then
  Knife := CreatePattern(ActualPoints, AdjustmentAngle, KerfWidth, True, False);

  MakeBitmap(Knife, KnifeLoaded and cbGrid.Checked, 1, Spinning);
  AngleHand;

  qMaterialUnits.findkey(['M']);
  OldKnifeToFtMultiplier := qMaterialUnitsToFeet.Value / qMaterialUnitsSubUnitsPerUnit.value;
  ImageHeight10CM := (PictureSize / (1000 div PATTERNRES)) * 0.254;  //Units of 10cm
  rulerKnifeLeft.UnitSize := rulerKnifeLeft.Height / ImageHeight10CM / OldKnifeToFtMultiplier * KnifeToFtMultiplier;
  rulerKnifeLeft.UnitPrice := 10;
  rulerKnifeBottom.UnitSize := rulerKnifeBottom.Width / ImageHeight10CM / OldKnifeToFtMultiplier * KnifeToFtMultiplier;
  rulerKnifeBottom.UnitPrice := 10;

  AdjustRulersScale;

  if UpdateMaterial then
    DisplayMaterial(imgLayPlan, True);

  UpdateScreen;
end;

procedure TfmLayplan.FindInitialise(ShowPretendKnife: Boolean);
begin
  DisplayMaterial(imgLayPlan, ShowPretendKnife);

  setlength(LayPlans , 0);
  //Minimum of 1 row so blank it;
  sgLayPlans.RowCount := 1;
  sgLayPlans.Cells[0, 0] := '';
  sgLayPlans.Cells[1, 0] := '';
  sgLayPlans.Cells[2, 0] := '';
  sgLayPlans.Cells[3, 0] := '';
  sgLayPlans.Cells[4, 0] := '';
  sgLayPlans.Cells[5, 0] := '';
  sgLayPlans.Cells[6, 0] := '';
  sgLayPlans.Cells[7, 0] := '';
  sgLayPlans.Cells[8, 0] := '';
  sgLayPlans.Cells[9, 0] := '';

  SelectedLayplan := -1;
  lblSelectedLayplan.Caption := '';

  sgDebug.RowCount := 2;
  tsDebug.TabVisible := False;
  LayPlansLoaded := False;
  AbortLayplanning := False;
  PreviewThis := mnuLayplansPreview.Checked;
  Errors := False;

  if PreviewThis then
    btnPreview.Caption := 'Preview OFF'
  else
    btnPreview.Caption := 'Preview ON';

  UpdateScreen;
end;

procedure TfmLayplan.LayPlanInitialise(Angle: real; UseLocalInterlock: Boolean);
begin
  SetLength(CutResults, 0);
  ResultsRemHeight := 0;
  ResultsRemWidth := 0;

  SetLength(OriginalHullOverlaps, 0);

  if UseLocalInterlock then
  begin
    Knife.Height := LIKnifeW1.Height;
    Knife.Width := LIKnifeW1.Width;
    Knife.PatternPoints := Copy(LIKnifeW1.PatternPoints);
    Knife.ExpandedPoints := Copy(LIKnifeW1.ExpandedPoints);
    Knife.ConvexHull := Copy(LIKnifeW1.ConvexHull);
    Knife.ButtSquare := Copy(LIKnifeW1.ButtSquare);
    Knife.PatternNettArea := LIKnifeW1.PatternNettArea;
    Knife.ExpandedGrossArea := LIKnifeW1.ExpandedGrossArea;
    Knife.W2 := LIKnifeW1.W2;

    KnifeW1.Height := LIKnifeW1.Height;
    KnifeW1.Width := LIKnifeW1.Width;
    KnifeW1.PatternPoints := Copy(LIKnifeW1.PatternPoints);
    KnifeW1.ExpandedPoints := Copy(LIKnifeW1.ExpandedPoints);
    KnifeW1.ConvexHull := Copy(LIKnifeW1.ConvexHull);
    KnifeW1.ButtSquare := Copy(LIKnifeW1.ButtSquare);
    KnifeW1.PatternNettArea := LIKnifeW1.PatternNettArea;
    KnifeW1.ExpandedGrossArea := LIKnifeW1.ExpandedGrossArea;
    KnifeW1.W2 := LIKnifeW1.W2;

    KnifeW2.Height := LIKnifeW2.Height;
    KnifeW2.Width := LIKnifeW2.Width;
    KnifeW2.PatternPoints := Copy(LIKnifeW2.PatternPoints);
    KnifeW2.ExpandedPoints := Copy(LIKnifeW2.ExpandedPoints);
    KnifeW2.ConvexHull := Copy(LIKnifeW2.ConvexHull);
    KnifeW2.ButtSquare := Copy(LIKnifeW2.ButtSquare);
    KnifeW2.PatternNettArea := LIKnifeW2.PatternNettArea;
    KnifeW2.ExpandedGrossArea := LIKnifeW2.ExpandedGrossArea;
    KnifeW2.W2 := LIKnifeW2.W2;
  end
  else
  begin
    if Length(OriginalPoints) <> 0 then
    begin
      Knife := CreatePattern(OriginalPoints, Angle, KerfWidth, True, False);
      KnifeW1 := CreatePattern(OriginalPoints, Angle, KerfWidth, True, False);
      KnifeW2 := CreatePattern(OriginalPoints, Angle, KerfWidth, True, True);
    end;
  end;

  NewKnife := True;
  CanSave := False;
  SelectedLayplanChanged := False;
end;

procedure TfmLayplan.btnNudgeLeft10Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle - 10;
  MainKnifeInitialise(True, False);
end;

procedure TfmLayplan.btnNudgeLeft1Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle - 1;
  MainKnifeInitialise(True, False);
end;

procedure TfmLayplan.btnNudgeLeftPoint1Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle - 0.1;
  MainKnifeInitialise(True, False);
end;

procedure TfmLayplan.btnNudgeRight10Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle + 10;
  MainKnifeInitialise(True, False);
end;

procedure TfmLayplan.btnNudgeRight1Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle + 1;
  MainKnifeInitialise(True, False);
end;

procedure TfmLayplan.btnNudgeRightPoint1Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle + 0.1;
  MainKnifeInitialise(True, False);
end;

procedure TfmLayplan.MakeBitmap(Pattern: TPattern; ShowGrid: Boolean; No: integer; Spinning: Boolean);
var
  bmp: TBitmap;
  Points: TPointArray;
  i: integer;
  maxx, maxy, minx, miny: real;
  PenWidth: integer;
  clBackground: TColor;

begin
  //Disabling this panel stops user being able to hold down the
  //button and spin the knife which exentually leads to a 'lock'.
  pnlInitialAngle.Enabled := False;

  if PictureSize = -1 then
  begin
    PictureSize := max(Pattern.Height, Pattern.Width);
    PictureSize := round(sqrt(2 * PictureSize * PictureSize)) + 10;
  end;

  maxx := -999999;
  maxy := -999999;
  minx := 999999;
  miny := 999999;
  Points := copy(Pattern.PatternPoints);
  for i := 0 to Length(Points) - 1 do
  begin
    Points[i].x := Points[i].x + (PictureSize - Pattern.Width) div 2;
    Points[i].y := Points[i].y + (PictureSize - Pattern.Height) div 2;

    if maxx < Points[i].x then
      maxx := Points[i].x;
    if maxy < Points[i].y then
      maxy := Points[i].y;
    if minx > Points[i].x then
      minx := Points[i].x;
    if miny > Points[i].y then
      miny := Points[i].y;
  end;

  //Close shape just for drawing
  setLength(Points, Length(Points) + 1);
  Points[Length(Points) - 1] := Points[0];

  bmp := TBitmap.Create;
  bmp.PixelFormat := pf4Bit;

  bmp.Height := PictureSize;
  bmp.Width := PictureSize;

  if (not SimpleDrawing) and (not Spinning) then
  begin
    clBackground := clHide;
    pnlKnife.Color := clHide;
  end
  else
  begin
    clBackground := clEditing;
    pnlKnife.Color := clEditing;
  end;
  bmp.Canvas.pen.Color := clBackground;
  bmp.Canvas.brush.color := clBackground;
  bmp.Canvas.FloodFill(10, 10, clBackground, fsBorder);

  if not SimpleDrawing then
  begin
    bmp.Canvas.Pen.Width := 1;
    bmp.Canvas.pen.Color := clCut;
    bmp.Canvas.brush.color := clCut;
    bmp.Canvas.Polygon(Points);
  end
  else
  begin
    bmp.Canvas.Pen.Width := (PictureSize div 200) + 1;
    bmp.Canvas.pen.Color := clBlack;
    bmp.Canvas.brush.color := clBlack;
    bmp.Canvas.Polyline(Points);
  end;

  if ShowGrid then
  begin
    PenWidth := (PictureSize div 200) + 1;

    bmp.Canvas.Pen.Width := PenWidth;
    if not SimpleDrawing then
    begin
      bmp.Canvas.pen.Color := clEditing;
      bmp.Canvas.brush.color := clEditing;
    end
    else
    begin
      bmp.Canvas.pen.Color := clCut;
      bmp.Canvas.brush.color := clCut;
    end;
    bmp.Canvas.MoveTo(0, round(maxy));
    bmp.Canvas.LineTo(PictureSize, round(maxy));
    bmp.Canvas.MoveTo(0, round(miny));
    bmp.Canvas.LineTo(PictureSize, round(miny));
    bmp.Canvas.MoveTo(round(maxx), 0);
    bmp.Canvas.LineTo(round(maxx), PictureSize);
    bmp.Canvas.MoveTo(round(minx), 0);
    bmp.Canvas.LineTo(round(minx), PictureSize);
  end;

  //Result := bmp;
  if No = 1 then
    imgKnife.Picture.Bitmap := bmp
  else if No = 2 then
    imgRotatedKnife.Picture.Bitmap := bmp;

  bmp.Free;

  pnlInitialAngle.Enabled := True;
end;

function TfmLayplan.ReadPattern(Code, Scale, Size: string): TPointArray;
var
  Pattern: TPointArray;
  i: integer;

begin
  qPatterns.ParamByName('KnifeCode').value := Code;
  qPatterns.ParamByName('KnifeScale').value := Scale;
  qPatterns.ParamByName('KnifeSize').value := Size;
  qPatterns.open;

  i := 0;
  qPatterns.RecNo := 1; //CJY changed from qPatterns.First
  qPatterns.Prior; //CJY changed from qPatterns.First
  while not qPatterns.eof do
  begin
    inc(i);
    SetLength(Pattern, i);
    Pattern[i - 1].x := qPatternsX.Value;
    Pattern[i - 1].y := qPatternsY.Value;

    qPatterns.Next;
  end;

  qPatterns.close;

  Result := Pattern;
end;

procedure TfmLayplan.FormCreate(Sender: TObject);
var
  i, j: integer;

begin
  //Main panel created as invisible to stop 'wrong'
  //colours flashing before they are recoloured
  //Made Visible at end of create.
	AutoColor(Self);
  shpWheel.Brush.Color := OurColor(clLime);

  pbLayplans.BackgroundColor := OurColor(pbLayplans.BackgroundColor);

  ReleasedVersion := ReleasedVersionConst;
  FromSATRASumm := False;
  FromSATRASummSized := False;
  FromBulkLayplanning := False;
  AutoOverwrite := AUTO_OVERWRITE_OFF;

  KnifeCode := '';
  KnifeScale := '';
  KnifeSize := '';
  KnifeArea := 0;

  if Tag = 2 then
    FromBulkLayplanning := True;

  application.processmessages;
  for i := 0 to imgJaggyEdgeTop.Picture.Bitmap.Width - 1  do
    for j := 0 to imgJaggyEdgeTop.Picture.Bitmap.Height - 1 do
      if imgJaggyEdgeTop.Picture.Bitmap.Canvas.Pixels[i, j] <> clBlack then
        imgJaggyEdgeTop.Picture.Bitmap.Canvas.Pixels[i, j] := OurColor(clBtnFace);

  for i := 0 to imgJaggyEdgeLeft.Picture.Bitmap.Width - 1  do
    for j := 0 to imgJaggyEdgeLeft.Picture.Bitmap.Height - 1 do
      if imgJaggyEdgeLeft.Picture.Bitmap.Canvas.Pixels[i, j] <> clBlack then
        imgJaggyEdgeLeft.Picture.Bitmap.Canvas.Pixels[i, j] := OurColor(clBtnFace);

  for i := 0 to imgJaggyEdgeRight.Picture.Bitmap.Width - 1  do
    for j := 0 to imgJaggyEdgeRight.Picture.Bitmap.Height - 1 do
      if imgJaggyEdgeRight.Picture.Bitmap.Canvas.Pixels[i, j] <> clBlack then
        imgJaggyEdgeRight.Picture.Bitmap.Canvas.Pixels[i, j] := OurColor(clBtnFace);

  CanSave := False;
  SelectedLayplanChanged := False;
  SummsToFtMultiplier := 0;

{$IFNDEF STANDALONE}
  Height := Height - GetSystemMetrics(SM_CYMENU);
  if Option_OverrideReleasedVersion then
    ReleasedVersion := False;
{$ENDIF}

  SetLength(KnivesUsed, 0);
  SetLength(ActualPoints, 0);
  SetLength(OriginalPoints, 0);
  CurrentKnife := 0;
  NewKnife := False;
  KnifeLoaded := False;
  Calculating := False;
  Saving := False;
  LayPlansLoaded := False;
  Zoom := 1;

  sgLayPlans.ColWidths[6] := 0;   //Although -1 took away the thicker grey line which is visible before
  sgLayPlans.ColWidths[7] := 0;   //the scroll bar covers it using -1 caused selected cells to remain painted in
  sgLayPlans.ColWidths[8] := 0;   //blue when large fonts were set.  Do NOT use -1.
  sgLayPlans.ColWidths[9] := 0;
  pnlTitles1.width := sgLayPlans.ColWidths[0];
  pnlTitles2.width := sgLayplans.ColWidths[1];
  pnlTitles3.width := sgLayplans.ColWidths[2];
  pnlTitles4.width := sgLayplans.ColWidths[3];
  pnlTitles5.width := sgLayplans.ColWidths[4];
  pnlTitles6.width := sgLayplans.ColWidths[5];

  sgDebug.Cells[0, 0] := 'Layplan';
  sgDebug.Cells[1, 0] := 'Pieces';
  sgDebug.Cells[2, 0] := 'Drawn';
  sgDebug.ColWidths[0] := sgLayplans.ColWidths[0] + 25;
  sgDebug.ColWidths[1] := sgLayplans.ColWidths[3] + 5;
  sgDebug.ColWidths[2] := sgLayplans.ColWidths[4] + 10;
  sgDebug.ColWidths[3] := 0;
  sgDebug.ColWidths[4] := 0;

  LoadUnitsDropDown;

  SummsLayplanINI := TIniFile.Create(LayplanIniName);
  ReadINI;

  pedtMaterialLength.OnChange := MaterialSizeChange;
  pedtMaterialWidth.OnChange := MaterialSizeChange;
  sedtEdge.OnChange := MaterialSizeChange;

  MaterialSizeChange(Self);

  if not SimpleDrawing then
    pnlKnife.color := clHide
  else
    pnlKnife.color := clEditing;
  PatternInitialise;

  //Released Version
  mnuLayplansShowCount.Visible := not ReleasedVersion;
  N1.Visible := not ReleasedVersion;
  mnuLayplansPreview.Visible := not ReleasedVersion;
  mnuLayplansSort.Visible := not ReleasedVersion;
  btnPreview.Visible := not ReleasedVersion;
  gbPacks.Visible := not ReleasedVersion;
  rgShowGangs.Visible := not ReleasedVersion;
  pnlTitles2.visible := not ReleasedVersion;
  rgNumberOfResults.visible := not ReleasedVersion;
  gbSuggestions.visible := not ReleasedVersion;
  if ReleasedVersion then
  begin
    sgLayPlans.ColWidths[0] := sgLayPlans.ColWidths[0] + sgLayPlans.ColWidths[1];
    sgLayPlans.ColWidths[1] := -1;
    pnlTitles1.width := sgLayplans.ColWidths[0] + 1;
    pnlTitles2.width := sgLayplans.ColWidths[1] + 1;
    pnlTitles3.width := sgLayplans.ColWidths[2] + 1;
    pnlTitles4.width := sgLayplans.ColWidths[3] + 1;
    pnlTitles5.width := sgLayplans.ColWidths[4] + 1;
    pnlTitles6.width := sgLayplans.ColWidths[5] + 1;

    mnuLayplansShowCount.Checked := False;
    mnuLayplansPreview.Checked := False;
    mnuLayplansSort.Checked := True;
    cbPacksSquareExcluded.Checked := False;
    cbPacksOffsetExcluded.Checked := False;
    cbPacksDiagonalExcluded.Checked := False;
    cbPacksDiagonalFreeExcluded.Checked := False;
    rgShowGangs.ItemIndex := 1;
    rgNumberOfResults.ItemIndex := 3;
    sedtSelectionsNo.value := 2;
    sedtSelectionsGrade.value := 5;
    sedtSelectionsPerc.value := 100;
  end;

  //Bulk Layplanning
  btnAbort.Visible := not FromBulkLayplanning;

  //Forces Intermediate packs only for Costings Only System and switch off menu options for display.
  if not Option_ProductionSystem then
  begin
    tbCuttingGuide.Position := 5;
    sedtSelectionsNo.value := 1;
    mnuLayplansShowKnifePreview.Enabled := False;
  end;

  rgStartingSideClick(Sender);

  //Open Tables
  tblKnives.open;

{$IFDEF STANDALONE}
  {JustOne bit}
  {Register a custom windows message}
  MyMsg := RegisterWindowMessage('Layplanning');
  {Set fmSumms' windows proc to ours and remember the old window proc}
  OldWindowProc := Pointer(SetWindowLong(fmCaller.Handle, GWL_WNDPROC, LongInt(@NewWindowProc)));
  {End of JustOne bit}
{$ENDIF}

  HandleAngle := 0;
  AngleHandle(HandleAngle);

  //See comment at start of create
  pnlLayplans.Visible := True;
  FormResize(Sender);

  HasClosed := False;
end;

procedure TfmLayplan.mnuLayplansSimpleDrawingOffClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;
  SimpleDrawing := False;
  SimpleDrawingPrintoutsOnly := False;
  UpdateScreen;

  pnlKnife.color := clHide;
  RedrawBMPs;
end;

procedure TfmLayplan.mnuLayplansSimpleDrawingOnClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;
  SimpleDrawing := True;
  SimpleDrawingPrintoutsOnly := False;
  UpdateScreen;

  pnlKnife.color := clEditing;
  RedrawBMPs;
end;

procedure TfmLayplan.mnuLayplansSimpleDrawingPrintoutsOnlyClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;
  SimpleDrawing := False;
  SimpleDrawingPrintoutsOnly := True;
  UpdateScreen;

  pnlKnife.color := clHide;
  RedrawBMPs;
end;

procedure TfmLayplan.OpenKnife;
var
  DongleError: Boolean;

begin
  DongleError := False;
  {$IFNDEF STANDALONE}
  DongleError := fmSumms.CheckDongle(FAST_PRESENCE_CHECK);
  {$ENDIF}

  UnminimizeLayMain;

  if not DongleError then
  begin
    if CanSave or SelectedLayplanChanged then
      CheckAndSaveLayplan;

    fmAllPatterns.MatLength :=  MaterialLength; //UsableMaterialLength;
    fmAllPatterns.MatWidth := MaterialWidth;    //UsableMaterialWidth;
    fmAllPatterns.MatCutGap := sedtExpand.value;
    fmAllPatterns.MatEdge := sedtEdge.value;
    fmAllPatterns.MatRestrictive := pedtRestrictiveMaterial.Text;

    if fmAllPatterns.ShowModal = mrOk then
      LoadKnife(fmAllPatterns.KnifeCode, fmAllPatterns.KnifeScale, fmAllPatterns.KnifeSize, fmAllPatterns.KnifeAngle);
  end
  else
    close;
end;

function BoundingRectsAreSame(RectA, RectB: TRect): boolean;
begin
  if (RectA.Left = RectB.Left) and (RectA.Top = RectB.Top) and
     (RectA.Right = RectB.Right) and (RectA.Bottom = RectB.Bottom) then
    Result := True
  else
    Result := False;
end;

procedure TfmLayplan.CreateLayplans;
const
  LI_None = 1;
  LI_W2 = 2;
  LI_W1 = 3;  //Don't actually bother with these, either repeats or stupid

var
  PackCode: string;
  NumberOfPatterns, RemHeight, RemWidth: integer;
  BestNumberOfPatterns: integer;
  StartLeft: Boolean;
  RemArea: real;
  Angle, FirstAngle, LastAngle, AngleStep, PackAngle, ActualPackAngle: real;
  Pack, PlanNo, w: integer;
  s: string;
  NoPlans, NoAnglesPerPlan: integer;
  NoConcavities, NoValidConcavities: integer;
  a, b: real;
  Utilisation: real;
  MaterialAreaM2: real;
  StartTime: TTime;
  DoPack, DoSubPack, Success: Boolean;
  i: integer;
  PackType, Way, Pat2w, Line2w, Side: integer;
  Pat2W2, Line2W2: Boolean;
  MaxW: integer;
  NoPatternStarts, PatternStart: integer;
  Interlock: TInterlock;
  LocalSuccess: Boolean;
  Knife2: TPattern;
  LocalInterlock: TLocalInterlock;
  Concavity, ValidConcavity: integer;
  Concavities: TConcavityBoundsArray;
  HoldKnife1, HoldKnife2, MaskKnife1, MaskKnife2: TPointArray;
  ConcavitiesMatch, ConvexShape1, ConvexShape2: boolean;
  DiagonalFreePackResults: array of TCompleteCutResult;
  NoDiagonalFreePacks: integer;
  dmyLI, LIToUse: TLocalInterlock;
  SingleKnifeNo, SingleKnifeHeight, SingleKnifeWidth: integer;
  PatternHeight, PatternWidth: integer;
  Gangs: array of TInterlock;
  Merge: TMerge;
  Capability, BasicComplexity: integer;
  Vec1x, Vec1y: integer;
  SquarePacks, OffsetPacks, DiagonalPacks, DiagonalFreePacks: Boolean;
  SquareGangs, OffsetGangs, DiagonalGangs, DiagonalFreeGangs: Boolean;
  OffsetGangsInverted, DiagonalVerticalPacks, DiagonalGangsInverted: Boolean;
  sNoOfLayPlans, sAngle, sBasicComplexity: string;
  TrimRowCount: integer;
  LargePatternToMaterialRatio, TooBigPatternToMaterialRatio: Boolean;
  SingleKnifeNoAtThisAngle: short;
  AngleError: Boolean;
  OutFile: TextFile;
  ErrorFileExists: Boolean;
  UtilisationError: Boolean;

begin
  {$IFDEF DEBUG}
  WholeCreate := GetTickCount;
  {$ENDIF}

  screen.cursor := crHourGlass;

  LayPlanInitialise(0, False);

  {$IFDEF DEBUG}
  KeepArea := Knife.PatternNettArea;
  KeepHeight := Knife.Height;
  KeepWidth := Knife.Width;
  {$ENDIF}

  ShowGangs := (rgShowGangs.ItemIndex = 0);

  //Check if Knife/Material ratio large
  LargePatternToMaterialRatio := False;
  if max(Knife.Height, Knife.Width) >= (min(UsableMaterialLength, UsableMaterialWidth) / 4) then
    LargePatternToMaterialRatio := True;

  if Zoom <> 1 then
    tbZoom.Position := 1;

  //Focus on anything that is enabled so that the validations on
  //Material Size are checked as just clicking the 'Start' button
  //doesn't leave the Material Size edit boxes
  if tbMain.visible then
    tbMain.setfocus;

  //Set for drawing if calculating in zoomed state
  ResultsLeft := (rgStartingSide.ItemIndex = 0);

  Calculating := True;
  UpdateScreen;

  LayPlanInitialise(0, False);
  FindInitialise(False);

  MaterialAreaM2 := (MaterialLength / (1000 div PATTERNRES) * 0.0254) *
                    (MaterialWidth / (1000 div PATTERNRES) * 0.0254);

  GetConcavityBounds(Knife.ExpandedPoints, Knife.ConvexHull, True, 0, NoValidConcavities, Concavities);
  NoConcavities := Length(Concavities);

  if rgAllowInvertion.ItemIndex = 0 then
  begin
    MaxW := 2;
    NoPatternStarts := 2;
  end
  else
  begin
    MaxW := 1;
    NoPatternStarts := 1;
  end;

  AngleStep := 1.0;
  if rgAdjustmentsAllowed.ItemIndex = 0 then
  begin
    FirstAngle := 0;
    LastAngle := 0;
    AngleStep := 100;
    NoAnglesPerPlan := 0;
  end
  else if rgAdjustmentsAllowed.ItemIndex = 1 then
  begin
    FirstAngle := -2.0;
    LastAngle := 2.0;
    NoAnglesPerPlan := 4;
  end
  else if rgAdjustmentsAllowed.ItemIndex = 2 then
  begin
    FirstAngle := -5.0;
    LastAngle := 5.0;
    NoAnglesPerPlan := 10;
  end
  else
  begin
    FirstAngle := -10.0;
    LastAngle := 10.0;
    NoAnglesPerPlan := 20;
  end;

  if rgRotationalIncrements.ItemIndex = 0 then
  begin
    AngleStep := AngleStep / 2;
    NoAnglesPerPlan := NoAnglesPerPlan * 2;
  end;
  inc(NoAnglesPerPlan);

  pbLayPlans.Position := 0;
  lblElapsedTime.Caption := '0:00';
  lblBestPieces.Caption := '0';
  gbCalculating.Caption := '';
  pnlCalculating.Visible := True;
  application.processmessages;

  StartTime := Now;
  CurrentKnife := 0;

  //Find the interlock for each concavity at 0 degrees
  Knife2 := KnifeW2;

  HoldKnife1 := copy(Knife.ExpandedPoints);
  HoldKnife2 := copy(Knife2.ExpandedPoints);
  //Not yet doing a free interlock, just doing concavities 1..n open one at a time
  ValidConcavity := 0;
  for Concavity := 1 to NoValidConcavities do
  begin
    LayPlanInitialise(0, False);
    Knife2 := KnifeW2;

    SingleConcavityOpen(Concavity - 1, Concavities, MaskKnife1, MaskKnife2);

    Knife.ExpandedPoints := copy(MaskKnife1);
    Knife2.ExpandedPoints := copy(MaskKnife2);

    Interlock := FindInterlock(Knife, Knife2, Knife, True, False, OriginalKnifeNow, False, False, False, False, False, True, True, InterlockingToleranceLayplans);

    if (not Interlock.Error) and Interlock.Found then
    begin
      Knife.ExpandedPoints := copy(HoldKnife1);
      Knife2.ExpandedPoints := copy(HoldKnife2);

      Merge := MergePatterns(Knife, Knife2, Interlock, False);
    end
    else
      Merge.Success := False;

    if not Merge.Success then
    begin
      dec(NoValidConcavities);
      Concavities[Concavity - 1].TheArea := 0;
    end
    else
    begin
      inc(ValidConcavity);
      SetLength(Gangs, ValidConcavity);
      Gangs[ValidConcavity - 1] := Interlock;
    end;
  end;
  Selectionsort(Concavities);      //Sort in case any have been set to area = 0

  //Do a completely 'free' interlock, no masked concavities and add it to the
  //concavities to gang if it differs from all the interlocks we have already.
  Knife.ExpandedPoints := copy(HoldKnife1);
  Knife2.ExpandedPoints := copy(HoldKnife2);

  Interlock := FindInterlock(Knife, Knife2, Knife, True, False, OriginalKnifeNow, False, False, False, False, False, True, True, InterlockingToleranceLayplans);
  if (not Interlock.Error) then
  begin
    i := -1;
    ConcavitiesMatch := False;
    if (NoValidConcavities > 0) then
    begin
      while not(i = Length(Gangs) - 1) and not(ConcavitiesMatch) do
      begin
        inc(i);
        if BoundingRectsAreSame(Gangs[i].Knife1BoundingRect, Interlock.Knife1BoundingRect) and
           BoundingRectsAreSame(Gangs[i].Knife2BoundingRect, Interlock.Knife2BoundingRect) then
          ConcavitiesMatch := True
        else
          ConcavitiesMatch := False;
      end;
    end
    else
      ConcavitiesMatch := False;

    if not ConcavitiesMatch and Interlock.Found then
    begin
      inc(NoValidConcavities);
      inc(ValidConcavity);
      SetLength(Gangs, ValidConcavity);
      Gangs[ValidConcavity - 1] := Interlock;
    end;
  end;

  //Only use as many Concavities as Required
  if rgMaxGangs.ItemIndex <> 5 then
  begin
    if rgMaxGangs.ItemIndex < Length(Gangs) then
    begin
      NoValidConcavities := rgMaxGangs.ItemIndex;
      SetLength(Gangs, NoValidConcavities);
    end;
  end;

  //Can not start with 2nd part of gang if there are no concavities
  if NoValidConcavities = 0 then
    NoPatternStarts := 1;

  //Decides which packs we are capable of doing
  //Previously we decided...
  //Beginner Upto 2
  //Intermediate Upto 5
  //Experienced Upto 9
  //Expert Upto 11
  Capability := tbCuttingGuide.Position;

  SquarePacks := (Capability >= 1) and (not cbPacksSquareExcluded.Checked);
  OffsetPacks := (Capability >= 2) and (not cbPacksOffsetExcluded.Checked);
  DiagonalPacks := (Capability >= 4) and (not cbPacksDiagonalExcluded.Checked);
  DiagonalVerticalPacks := (Capability >= 7) and (not cbPacksDiagonalExcluded.Checked);
  DiagonalFreePacks := (Capability >= 10) and (not cbPacksDiagonalFreeExcluded.Checked);
  SquareGangs := (Capability >= 3) and SquarePacks and (NoValidConcavities > 0);
  OffsetGangs := (Capability >= 5) and OffsetPacks and (NoValidConcavities > 0);
  OffsetGangsInverted := (Capability >= 6) and OffsetPacks and (NoValidConcavities > 0);
  DiagonalGangs := (Capability >= 8) and DiagonalPacks and (NoValidConcavities > 0);
  DiagonalGangsInverted := (Capability >= 9) and DiagonalPacks and (NoValidConcavities > 0);
  DiagonalFreeGangs := (Capability >= 11) and DiagonalFreePacks and (NoValidConcavities > 0);

  NoPlans := 0;
  if SquarePacks then
  begin
    if MaxW = 2 then
    begin
      NoPlans := NoPlans + 6;
      //inc 2 local W2 starts
      if SquareGangs then
        NoPlans := NoPlans + (2 * NoValidConcavities);
    end
    else
      NoPlans := NoPlans + 2
  end;
  if OffsetPacks then
  begin
    if MaxW = 2 then
    begin
      NoPlans := NoPlans + 8;
      //inc 2 local W2 starts
      if OffsetGangs then
        NoPlans := NoPlans + NoValidConcavities;
      if OffsetGangsInverted then
        NoPlans := NoPlans + NoValidConcavities;
    end
    else
      NoPlans := NoPlans + 2
  end;
  if DiagonalPacks then
  begin
    if MaxW = 2 then
    begin
      NoPlans := NoPlans + 3;
      if DiagonalVerticalPacks then
        NoPlans := NoPlans + 3;
      //inc 2 local W2 starts
      if DiagonalGangs then
        NoPlans := NoPlans + NoValidConcavities;
      if DiagonalGangsInverted then
        NoPlans := NoPlans + NoValidConcavities;
    end
    else
    begin
      NoPlans := NoPlans + 1;        //Was .... + 2
      if DiagonalVerticalPacks then  //Bug Fix
        NoPlans := NoPlans + 1;      //20/08/08
    end;
  end;
  if DiagonalFreePacks then
  begin
    if MaxW = 2 then
    begin
      NoPlans := NoPlans + 2;
      //inc 2 local W2 starts
      if DiagonalFreeGangs then
        NoPlans := NoPlans + NoValidConcavities;
    end
    else
      NoPlans := NoPlans + 1
  end;

  //Pre process packs for Diagonal Free as the PACKS
  //will be the same at every angle that we might use
  NoDiagonalFreePacks := 0;
  setlength(DiagonalFreePackResults, 0);
  if DiagonalFreePacks then
  begin
    {$IFDEF DEBUG}
    DiagonalFreeTC := GetTickCount;
    {$ENDIF}
    NoDiagonalFreePacks := 2 + (NoValidConcavities);
    setlength(DiagonalFreePackResults, NoDiagonalFreePacks);

    LayPlanInitialise(0, False);
    AddToKnivesUsed(CurrentKnife);
    AngleError := GetFreeAngle(PackAngle);
    if AngleError then
      AbortLayplanning := True;

    if (not AbortLayplanning) then
    begin
      LayPlanInitialise(PackAngle, False);
      UpdateInitialisation(1, NoDiagonalFreePacks, StartTime);
      AddToKnivesUsed(CurrentKnife);
      InitialisePackResults;

      Line2W2 := False;

      {$IFDEF DEBUG}
      DiagonalFreeTC := GetTickCount - DiagonalFreeTC;
      AllDiagonalFrees := AllDiagonalFrees + DiagonalFreeTC;
      {$ENDIF}

      Success := Plan(UsableMaterialLength, UsableMaterialWidth, Knife.Height, Knife.Width, DIAGONAL_VERTICAL, False, Line2W2,
                      (rgCornerAnchoring.ItemIndex = 0), False, False, (rgStartingCriteria.ItemIndex = 1),
                      (rgStartingSide.ItemIndex = 0), LocalInterlock,
                      NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft, InterlockingToleranceLayplans);

      {$IFDEF DEBUG}
      DiagonalFreeTC := GetTickCount;
      {$ENDIF}

      ActualPackAngle := PackAngle - AdjustmentAngle;
      CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, ActualPackAngle, DiagonalFreePackResults[0]);
    end;

    if (not AbortLayplanning) then
    begin
      LayPlanInitialise(PackAngle, False);
      UpdateInitialisation(2, NoDiagonalFreePacks, StartTime);
      InitialisePackResults;
      if MaxW = 2 then
      begin
        Line2W2 := True;

        {$IFDEF DEBUG}
        DiagonalFreeTC := GetTickCount - DiagonalFreeTC;
        AllDiagonalFrees := AllDiagonalFrees + DiagonalFreeTC;
        {$ENDIF}

        Success := Plan(UsableMaterialLength, UsableMaterialWidth, Knife.Height, Knife.Width, DIAGONAL_VERTICAL, False, Line2W2,
                        (rgCornerAnchoring.ItemIndex = 0), False, False, (rgStartingCriteria.ItemIndex = 1),
                        (rgStartingSide.ItemIndex = 0), LocalInterlock,
                        NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft, InterlockingToleranceLayplans);

        {$IFDEF DEBUG}
        DiagonalFreeTC := GetTickCount;
        {$ENDIF}

        ActualPackAngle := PackAngle - AdjustmentAngle;
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, ActualPackAngle, DiagonalFreePackResults[1]);
      end;
    end;

    //Not yet doing a free interlock, just doing concavities 1..n open one at a time
    Concavity := 0;
    while (Concavity < NoValidConcavities) and (not AbortLayplanning) do
    begin
      inc(Concavity);

      LayPlanInitialise(0, False);
      UpdateInitialisation(2 + Concavity, NoDiagonalFreePacks, StartTime);
      Knife2 := KnifeW2;

      SingleKnifeHeight := Knife.Height;
      SingleKnifeWidth := Knife.Width;

      HoldKnife1 := Copy(Knife.ExpandedPoints);
      HoldKnife2 := Copy(Knife2.ExpandedPoints);

      Interlock := Gangs[Concavity - 1];

      UpdateSyntheticResults(Interlock, Knife2, False, False);
      AngleError := GetFreeAngle(PackAngle);
      if AngleError then
        AbortLayplanning := True;

      if not AbortLayplanning then
      begin
        //Rotate the interlock to the correct angle
        Knife.ExpandedPoints := copy(HoldKnife1);
        Knife2.ExpandedPoints := copy(HoldKnife2);
        Interlock := RotatedInterlock(Knife, Knife2, PackAngle, Interlock);

        LayPlanInitialise(PackAngle, False);
        Knife2 := KnifeW2;

        //Single knife at the correct angle
        AddToKnivesUsed(CurrentKnife);

        LocalSuccess := UpdateSyntheticResults(Interlock, Knife2, False, True);

        //Local Interlock Vectors
        LocalInterlock.Used := True;
        LocalInterlock.Reversed := False;
        LocalInterlock.PairedPatternHeight := Knife.Height;
        LocalInterlock.PairedPatternWidth := Knife.Width;
        LocalInterlock.SinglePatternHeight := SingleKnifeHeight;
        LocalInterlock.SinglePatternWidth := SingleKnifeWidth;
        LocalInterlock.Vec1x := CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left;
        LocalInterlock.Vec1y := CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top;
        LocalInterlock.W2 := True; //(PatternStart = LI_W2);
        LocalInterlock.SingleKnifeNo := CurrentKnife;
        RelativePositionLocalInterlockPatterns(LocalInterlock);

        //Gang knife at the correct angle
        AddToKnivesUsed(CurrentKnife);

        setlength(CutResults, 0);
        InitialisePackResults;
        Line2W2 := False;

        {$IFDEF DEBUG}
        DiagonalFreeTC := GetTickCount - DiagonalFreeTC;
        AllDiagonalFrees := AllDiagonalFrees + DiagonalFreeTC;
        {$ENDIF}

        Success := Plan(UsableMaterialLength, UsableMaterialWidth, Knife.Height, Knife.Width, DIAGONAL_VERTICAL, False, Line2W2,
                        (rgCornerAnchoring.ItemIndex = 0), False, False, (rgStartingCriteria.ItemIndex = 1),
                        (rgStartingSide.ItemIndex = 0), LocalInterlock,
                         NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft, InterlockingToleranceLayplans);

        {$IFDEF DEBUG}
        DiagonalFreeTC := GetTickCount;
        {$ENDIF}

        ActualPackAngle := PackAngle - AdjustmentAngle;
        CopyToPackResult(Knife, KnifeW1, KnifeW2, LocalInterlock, ActualPackAngle, DiagonalFreePackResults[Concavity + 1]);
      end;
    end;
    {$IFDEF DEBUG}
    DiagonalFreeTC := GetTickCount - DiagonalFreeTC;
    AllDiagonalFrees := AllDiagonalFrees + DiagonalFreeTC;
    {$ENDIF}
  end;

  gbCalculating.Caption := 'Calculating ...';
  application.processmessages;

  BestNumberOfPatterns := 0;
  pcSelectionsResults.TabIndex := 3;

  PlanNo := 0;
  Angle := AdjustmentAngle + FirstAngle;
  //Test Angles as integers as if there is an AdjustmentAngle set (e.g. 9.5) then
  //the real number'ness' of this equality check was missing the last angle.
  while (round(Angle * 10) <= round((AdjustmentAngle + LastAngle) * 10)) and (not AbortLayplanning) do
  begin
  {$IFDEF DEBUG}
    AllAngles := GetTickCount;
  {$ENDIF}

    SingleKnifeNoAtThisAngle := -1;

    for Concavity := 1 to max(1, NoValidConcavities) do
    begin
      for PatternStart := 1 to NoPatternStarts do
      begin
        LayPlanInitialise(Angle, False);

        //Keep the width of the actual pattern
        SingleKnifeWidth := KnifeW1.Width;

        //Do local interlock first
        LocalInterlock.Used := False;
        LocalSuccess := True;
        if PatternStart <> LI_NONE then
        begin
          //Get the single pattern dimensions before....
          LocalInterlock.SinglePatternHeight := KnifeW1.Height;
          LocalInterlock.SinglePatternWidth := KnifeW1.Width;

          //...reloading the knife at 0 degrees
          LayPlanInitialise(0, False);

          if PatternStart = LI_W1 then
            Knife2 := KnifeW1
          else if PatternStart = LI_W2 then
            Knife2 := KnifeW2;

          if (NoValidConcavities > 0) then
          begin
            Interlock := Gangs[Concavity - 1];
            Interlock := RotatedInterlock(Knife, Knife2, Angle, Interlock);
          end;

          LayPlanInitialise(Angle, False);
          Knife2 := KnifeW2;

          if SingleKnifeNoAtThisAngle = -1 then
          begin
            //Single knife at the correct angle
            AddToKnivesUsed(CurrentKnife);
            SingleKnifeNoAtThisAngle := CurrentKnife;
          end;

          LocalSuccess := UpdateSyntheticResults(Interlock, Knife2, False, (NoValidConcavities > 0));

          //Local Interlock Knives
          LIKnifeW1.Height := KnifeW1.Height;
          LIKnifeW1.Width := KnifeW1.Width;
          LIKnifeW1.PatternPoints := Copy(KnifeW1.PatternPoints);
          LIKnifeW1.ExpandedPoints := Copy(KnifeW1.ExpandedPoints);
          LIKnifeW1.ConvexHull := Copy(KnifeW1.ConvexHull);
          LIKnifeW1.ButtSquare := Copy(KnifeW1.ButtSquare);
          LIKnifeW1.PatternNettArea := KnifeW1.PatternNettArea;
          LIKnifeW1.ExpandedGrossArea := KnifeW1.ExpandedGrossArea;
          LIKnifeW1.W2 := KnifeW1.W2;

          LIKnifeW2.Height := KnifeW2.Height;
          LIKnifeW2.Width := KnifeW2.Width;
          LIKnifeW2.PatternPoints := Copy(KnifeW2.PatternPoints);
          LIKnifeW2.ExpandedPoints := Copy(KnifeW2.ExpandedPoints);
          LIKnifeW2.ConvexHull := Copy(KnifeW2.ConvexHull);
          LIKnifeW2.ButtSquare := Copy(KnifeW2.ButtSquare);
          LIKnifeW2.PatternNettArea := KnifeW2.PatternNettArea;
          LIKnifeW2.ExpandedNettArea := KnifeW2.ExpandedNettArea;
          LIKnifeW2.ExpandedGrossArea := KnifeW2.ExpandedGrossArea;
          LIKnifeW2.W2 := KnifeW2.W2;

          //Local Interlock Vectors
          LocalInterlock.Used := True;
          LocalInterlock.Reversed := False;
          LocalInterlock.PairedPatternHeight := Knife.Height;
          LocalInterlock.PairedPatternWidth := Knife.Width;
          LocalInterlock.Vec1x := CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left;
          LocalInterlock.Vec1y := CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top;
          LocalInterlock.W2 := (PatternStart = LI_W2);
          LocalInterlock.SingleKnifeNo := SingleKnifeNoAtThisAngle; //CurrentKnife;
          RelativePositionLocalInterlockPatterns(LocalInterlock);

          NewKnife := True;
          setLength(CutResults, 0);

          AddToKnivesUsed(CurrentKnife);
        end
        else
        begin
          if SingleKnifeNoAtThisAngle = -1 then
          begin
            //Single knife at the correct angle
            AddToKnivesUsed(CurrentKnife);
            SingleKnifeNoAtThisAngle := CurrentKnife;
          end;
        end;

        InitialisePackResults;

        //Check whether the knife (or gang) is too
        //big for one to fit at the current angle
        TooBigPatternToMaterialRatio := ((Knife.Height > UsableMaterialLength) or (Knife.Width > UsableMaterialWidth));

        PackType := 0;
        while (PackType < DIAGONAL) and (not AbortLayplanning) do
        begin
          inc(PackType);

          Way := 0;
          while (Way < BOTH) and (not AbortLayplanning) do
          begin
            inc(Way);

            Pat2w := 0;
            while (Pat2w < MaxW) and (not AbortLayplanning) do
            begin
              inc(Pat2w);
              Pat2W2 := (Pat2w = 2);

              Line2w := 0;
              while (Line2w < MaxW) and (not AbortLayplanning) do
              begin
                inc(Line2w);
                Line2W2 := (Line2w = 2);

                //'Top to Bottom' or 'Left to Right'
                Side := 0;
                while (Side < 2) and (not AbortLayplanning) do
                begin
                  inc(Side);

                  Pack := NONE;

                  if (PackType = SQUARE) then
                  begin
                    if (Way = HORIZONTAL) then
                    begin
                      if (not Pat2W2) and (not Line2W2) and (Side = TTOP) and ((PatternStart = LI_NONE) or (PatternStart = LI_W2)) then
                        Pack := SQUARE_HORIZONTAL
                      else if (not Pat2W2) and (not Line2W2) and (Side = BOTTOM) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (not Pat2W2) and (Line2W2) and (Side = TTOP) and (PatternStart = LI_NONE) then
                        Pack := SQUARE_HORIZONTAL
                      else if (not Pat2W2) and (Line2W2) and (Side = BOTTOM) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (Pat2W2) and (not Line2W2) and (Side = TTOP) and (PatternStart = LI_NONE) then
                        Pack := SQUARE_HORIZONTAL_P2_INVERTED
                      else if (Pat2W2) and (not Line2W2) and (Side = BOTTOM) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (Pat2W2) and (Line2W2) and (Side = TTOP) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (Pat2W2) and (Line2W2) and (Side = BOTTOM) and (PatternStart = LI_NONE) then
                        Pack := NONE;
                    end
                    else if (Way = VERTICAL) then
                    begin
                      if (not Pat2W2) and (not Line2W2) and (Side = LLEFT)  and ((PatternStart = LI_NONE) or (PatternStart = LI_W2)) then
                        Pack := SQUARE_VERTICAL
                      else if (not Pat2W2) and (not Line2W2) and (Side = RIGHT) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (not Pat2W2) and (Line2W2) and (Side = LLEFT) and (PatternStart = LI_NONE) then
                        Pack := SQUARE_VERTICAL
                      else if (not Pat2W2) and (Line2W2) and (Side = RIGHT) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (Pat2W2) and (not Line2W2) and (Side = LLEFT) and (PatternStart = LI_NONE) then
                        Pack := SQUARE_VERTICAL_P2_INVERTED
                      else if (Pat2W2) and (not Line2W2) and (Side = RIGHT) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (Pat2W2) and (Line2W2) and (Side = LLEFT) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (Pat2W2) and (Line2W2) and (Side = RIGHT) and (PatternStart = LI_NONE) then
                        Pack := NONE;
                    end
                    else if (Way = BOTH) then
                      Pack := NONE;
                  end
                  else if (PackType = OFFSET) then
                  begin
                    if (Way = HORIZONTAL) then
                    begin
                      if (not Pat2W2) and (not Line2W2) and (Side = TTOP) and ((PatternStart = LI_NONE) or (PatternStart = LI_W2)) then
                        Pack := OFFSET_HORIZONTAL_TOP
                      else if (not Pat2W2) and (not Line2W2) and (Side = BOTTOM) and (PatternStart = LI_NONE) then
                        Pack := NONE //Same as above
                      else if (not Pat2W2) and (Line2W2) and (Side = TTOP) and (PatternStart = LI_NONE) then
                        Pack := OFFSET_HORIZONTAL_TOP
                      else if (not Pat2W2) and (Line2W2) and (Side = BOTTOM) and (PatternStart = LI_NONE) then
                        Pack := OFFSET_HORIZONTAL_BOTTOM
                      else if (Pat2W2) and (not Line2W2) and (Side = TTOP) and (PatternStart = LI_NONE) then
                        Pack := OFFSET_HORIZONTAL_P2_INVERTED
                      else if (Pat2W2) and (not Line2W2) and (Side = BOTTOM) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (Pat2W2) and (Line2W2) and (Side = TTOP) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (Pat2W2) and (Line2W2) and (Side = BOTTOM) and (PatternStart = LI_NONE) then
                        Pack := NONE;
                    end
                    else if (Way = VERTICAL) then
                    begin
                      if (not Pat2W2) and (not Line2W2) and (Side = LLEFT)  and ((PatternStart = LI_NONE) or (PatternStart = LI_W2)) then
                        Pack := OFFSET_VERTICAL_LEFT
                      else if (not Pat2W2) and (not Line2W2) and (Side = RIGHT) and (PatternStart = LI_NONE) then
                        Pack := NONE //Same as above
                      else if (not Pat2W2) and (Line2W2) and (Side = LLEFT) and (PatternStart = LI_NONE) then
                        Pack := OFFSET_VERTICAL_LEFT
                      else if (not Pat2W2) and (Line2W2) and (Side = RIGHT) and (PatternStart = LI_NONE) then
                        Pack := OFFSET_VERTICAL_RIGHT
                      else if (Pat2W2) and (not Line2W2) and (Side = LLEFT) and (PatternStart = LI_NONE) then
                        Pack := OFFSET_VERTICAL_P2_INVERTED
                      else if (Pat2W2) and (not Line2W2) and (Side = RIGHT) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (Pat2W2) and (Line2W2) and (Side = LLEFT) and (PatternStart = LI_NONE) then
                        Pack := NONE
                      else if (Pat2W2) and (Line2W2) and (Side = RIGHT) and (PatternStart = LI_NONE) then
                        Pack := NONE;
                    end
                    else if (Way = BOTH) then
                      Pack := NONE;
                  end
                  else if (PackType = DIAGONAL) then
                  begin
                    if (Way = HORIZONTAL) then
                    begin
                      if (Side = TTOP) then
                      begin
                        if (not Pat2W2) and (not Line2W2) and ((PatternStart = LI_NONE) or (PatternStart = LI_W2)) then
                          Pack := DIAGONAL_HORIZONTAL
                        else if (not Pat2W2) and (Line2W2) and (PatternStart = LI_NONE) then
                          Pack := DIAGONAL_HORIZONTAL
                        else if (Pat2W2) and (not Line2W2) and (PatternStart = LI_NONE) then
                          Pack := DIAGONAL_HORIZONTAL_P2_INVERTED
                        else if (Pat2W2) and (Line2W2) and (PatternStart = LI_NONE) then
                          Pack := NONE;
                      end;
                    end
                    else if (Way = VERTICAL) then
                    begin
                      if (Side = LLEFT) then
                      begin
                        if (not Pat2W2) and (not Line2W2) and ((PatternStart = LI_NONE) or (PatternStart = LI_W2)) then
                          Pack := DIAGONAL_VERTICAL
                        else if (not Pat2W2) and (Line2W2) and (PatternStart = LI_NONE) then
                          Pack := DIAGONAL_VERTICAL
                        else if (Pat2W2) and (not Line2W2) and (PatternStart = LI_NONE) then
                          Pack := DIAGONAL_VERTICAL_P2_INVERTED
                        else if (Pat2W2) and (Line2W2) and (PatternStart = LI_NONE) then
                          Pack := NONE;
                      end;
                    end
                    else if (Way = BOTH) then
                    begin
                    if (Side = LLEFT) then
                      begin
                        if (not Pat2W2) and (not Line2W2) and ((PatternStart = LI_NONE) or (PatternStart = LI_W2)) then
                          Pack := DIAGONAL_FREE
                        else if (not Pat2W2) and (Line2W2) and (PatternStart = LI_NONE) then
                          Pack := DIAGONAL_FREE
                        else if (Pat2W2) and (not Line2W2) and (PatternStart = LI_NONE) then
                          Pack := NONE
                        else if (Pat2W2) and (Line2W2) and (PatternStart = LI_NONE) then
                          Pack := NONE;
                      end;
                    end
                  end;

                  //Decide which 'Paired' packs to try
                  if ((Concavity > 1) and (PatternStart = LI_NONE)) or
                     ((Concavity = 1) and (PatternStart <> LI_NONE) and (NoValidConcavities = 0)) then
                    Pack := NONE;

                  //BasicComplexity
                  case Pack of
                    SQUARE_HORIZONTAL,
                    SQUARE_HORIZONTAL_P2_INVERTED,
                    SQUARE_VERTICAL,
                    SQUARE_VERTICAL_P2_INVERTED:
                    begin
                      BasicComplexity := 1;
                      if PatternStart = LI_W2 then
                        BasicComplexity := 3;
                    end;
                    OFFSET_HORIZONTAL_TOP,
                    OFFSET_HORIZONTAL_BOTTOM,
                    OFFSET_HORIZONTAL_P2_INVERTED:
                    begin
                      BasicComplexity := 2;
                      if PatternStart = LI_W2 then
                        BasicComplexity := 5;
                    end;
                    OFFSET_VERTICAL_LEFT,
                    OFFSET_VERTICAL_RIGHT,
                    OFFSET_VERTICAL_P2_INVERTED:
                    begin
                      BasicComplexity := 2;
                      if PatternStart = LI_W2 then
                        BasicComplexity := 6;
                    end;
                    DIAGONAL_HORIZONTAL,
                    DIAGONAL_HORIZONTAL_P2_INVERTED:
                    begin
                      BasicComplexity := 4;
                      if PatternStart = LI_W2 then
                        BasicComplexity := 8;
                    end;
                    DIAGONAL_VERTICAL,
                    DIAGONAL_VERTICAL_P2_INVERTED:
                    begin
                      BasicComplexity := 7;
                      if PatternStart = LI_W2 then
                        BasicComplexity := 9;
                    end;
                    DIAGONAL_FREE:
                    begin
                      BasicComplexity := 10;
                      if PatternStart = LI_W2 then
                        BasicComplexity := 11;
                    end;
                  end;

                  if (Pack = NONE) or (BasicComplexity > Capability) then
                    DoPack := False
                  else
                    DoPack := ((Pack = SQUARE_HORIZONTAL) and SquarePacks) or
                              ((Pack = SQUARE_HORIZONTAL_P2_INVERTED) and SquarePacks) or
                              ((Pack = SQUARE_VERTICAL) and SquarePacks) or
                              ((Pack = SQUARE_VERTICAL_P2_INVERTED) and SquarePacks) or
                              ((Pack = OFFSET_HORIZONTAL_TOP) and OffsetPacks) or
                              ((Pack = OFFSET_HORIZONTAL_BOTTOM) and OffsetPacks) or
                              ((Pack = OFFSET_HORIZONTAL_P2_INVERTED) and OffsetPacks) or
                              ((Pack = OFFSET_VERTICAL_LEFT) and OffsetPacks) or
                              ((Pack = OFFSET_VERTICAL_RIGHT) and OffsetPacks) or
                              ((Pack = OFFSET_VERTICAL_P2_INVERTED) and OffsetPacks) or
                              ((Pack = DIAGONAL_HORIZONTAL) and DiagonalPacks) or
                              ((Pack = DIAGONAL_HORIZONTAL_P2_INVERTED) and DiagonalPacks) or
                              ((Pack = DIAGONAL_VERTICAL) and DiagonalPacks) or
                              ((Pack = DIAGONAL_VERTICAL_P2_INVERTED) and DiagonalPacks) or
                              ((Pack = DIAGONAL_FREE) and DiagonalFreePacks);

                  if DoPack then
                  begin
                    inc(PlanNo);

                    NumberOfPatterns := 0;
                    setlength(CutResults, 0);

                    //Pack type
                    case (Pack mod 100) of
                      1..2: PackCode := 'S_';
                      3..5: PackCode := 'O_';
                      6..7: PackCode := 'D_';
                    end;

                    //Specific pack
                    case Pack of
                      SQUARE_HORIZONTAL: PackCode := PackCode + 'H';
                      SQUARE_HORIZONTAL_P2_INVERTED: PackCode := PackCode + 'H_PI';
                      SQUARE_VERTICAL: PackCode := PackCode + 'V';
                      SQUARE_VERTICAL_P2_INVERTED: PackCode := PackCode + 'V_PI';
                      OFFSET_HORIZONTAL_TOP: PackCode := PackCode + 'H_T';
                      OFFSET_HORIZONTAL_BOTTOM: PackCode := PackCode + 'H_B';
                      OFFSET_HORIZONTAL_P2_INVERTED: PackCode := PackCode + 'H_PI';
                      OFFSET_VERTICAL_LEFT: PackCode := PackCode + 'V_L';
                      OFFSET_VERTICAL_RIGHT: PackCode := PackCode + 'V_R';
                      OFFSET_VERTICAL_P2_INVERTED: PackCode := PackCode + 'V_PI';
                      DIAGONAL_HORIZONTAL: PackCode := PackCode + 'H';
                      DIAGONAL_HORIZONTAL_P2_INVERTED: PackCode := PackCode + 'H_PI';
                      DIAGONAL_VERTICAL: PackCode := PackCode + 'V';
                      DIAGONAL_VERTICAL_P2_INVERTED: PackCode := PackCode + 'V_PI';
                      DIAGONAL_FREE: PackCode := 'DF';
                    end;
                    if (not Pat2W2) and Line2W2 then
                      PackCode := PackCode + '_LI';  //Inverted

                    //Local Interlock
                    case PatternStart of
                      //LI_NONE:
                      LI_W1: PackCode := PackCode + '_Gs' + intToStr(Concavity);
                      LI_W2: PackCode := PackCode + '_G' + intToStr(Concavity);
                    end;

                    str((Angle - AdjustmentAngle) : 5 : 1, sAngle);
                    str(BasicComplexity : 1, sBasicComplexity);
                    PackCode := intToStr(PlanNo) + '_' + PackCode;

                    gbCalculating.Caption := 'Calculating ' + intToStr(PlanNo) + ' of ' + intToStr(NoPlans * NoAnglesPerPlan);
                    {$IFDEF DEBUG}
                    gbCalculating.Caption := gbCalculating.Caption + '     (' + PackCode + '   ' + sAngle + '   ' + sBasicComplexity + ')';
                    {$ENDIF}

                    application.ProcessMessages;

                    LayPlanInitialise(Angle, LocalInterlock.Used);

                    if TooBigPatternToMaterialRatio then
                    begin
                      NumberOfPatterns := 0;
                      RemHeight := UsableMaterialLength;
                      RemWidth := UsableMaterialWidth;
                      RemArea := UncutArea(UsableMaterialLength, UsableMaterialWidth,
                                           UsableMaterialLength, UsableMaterialWidth);

                      Success := True;
                    end
                    else if LocalSuccess then
                    begin
                      if Pack = DIAGONAL_FREE then
                      begin
                        if PatternStart = LI_NONE then
                        begin
                          if (not Line2W2) then
                            CopyFromPackResult(Knife, KnifeW1, KnifeW2, LIToUse, PackAngle, DiagonalFreePackResults[0])
                          else
                            CopyFromPackResult(Knife, KnifeW1, KnifeW2, LIToUse, PackAngle, DiagonalFreePackResults[1]);
                        end
                        else if PatternStart = LI_W2 then
                          CopyFromPackResult(Knife, KnifeW1, KnifeW2, LIToUse, PackAngle, DiagonalFreePackResults[1 + Concavity]);

                        ActualPackAngle := PackAngle - (Angle - AdjustmentAngle);
                        RotateBackFreeDiagonalPack(ActualPackAngle);
                        PatternHeight := abs(CutResults[0].BoundingRect.Top - CutResults[0].BoundingRect.Bottom);
                        PatternWidth := abs(CutResults[0].BoundingRect.Right - CutResults[0].BoundingRect.Left);

                        //Check pack leans
                        //If it doesn't lean (Vec1x) then just use a Vertical Diagonal Propogation
                        //If it doesn't lean (Vec1y) then just use a Vertical Horizontal Propogation
                        Vec1x := CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left;
                        Vec1y := CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top;

                        //If pack points down, reverse CutResults so pack points up
                        if (Vec1y > 0) then
                        begin
                          PointCutResultsUp;

                          //Recheck pack leanings in case Vec1y now zero (rounding error possibly if = 1 before)
                          Vec1x := CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left;
                          Vec1y := CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top;
                        end
                        else if (Vec1y = 0) then
                          SwapCutResultsFromDiagonalFreeToDiagonalHorizontal;

                        Success := True;
                        try
                          if Vec1y = 0 then
                            PropogateHorizontalDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                                        (rgStartingCriteria.ItemIndex = 1), (rgStartingSide.ItemIndex = 0), Line2W2, (rgCornerAnchoring.ItemIndex = 0),
                                                        LocalInterlock,
                                                        NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft)
                          else if Vec1x = 0 then
                            PropogateVerticalDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                                      (rgStartingCriteria.ItemIndex = 1), (rgStartingSide.ItemIndex = 0), Line2W2, (rgCornerAnchoring.ItemIndex = 0),
                                                      LocalInterlock,
                                                      NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft)
                          else
                            PropogateFreeDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                                  (rgStartingCriteria.ItemIndex = 1), (rgStartingSide.ItemIndex = 0), Line2W2, (rgCornerAnchoring.ItemIndex = 0),
                                                  LocalInterlock, ActualPackAngle,
                                                  NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft);
                        except
                          Success := False;
                        end;
                      end
                      else
                      {$IFDEF DEBUG}
                      begin
                        AllAngles := GetTickCount - AllAngles;
                        TotalAllAngles := TotalAllAngles + AllAngles;
                      {$ENDIF}
                        Success := Plan(UsableMaterialLength, UsableMaterialWidth, Knife.Height, Knife.Width, Pack, True, Line2W2,
                                        (rgCornerAnchoring.ItemIndex = 0), False, False, (rgStartingCriteria.ItemIndex = 1),
                                        (rgStartingSide.ItemIndex = 0), LocalInterlock,
                                        NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft, InterlockingToleranceLayplans);
                      {$IFDEF DEBUG}
                        AllAngles := GetTickCount;
                      end;
                      {$ENDIF}
                    end
                    else
                      Success := False;
                    if not Success then
                      Errors := True;
                    application.processmessages;

                    SetLength(LayPlans, length(LayPlans) + 1);
                    if Success then
                    begin
                      //Check for 'off edge' Patterns when using
                      //relatively large patterns and remove them
                      if LargePatternToMaterialRatio and (not TooBigPatternToMaterialRatio) then
                        PostPlan(UsableMaterialLength, UsableMaterialWidth,
                                 SingleKnifeWidth, StartLeft, NumberOfPatterns,
                                 RemHeight, RemWidth, RemArea);

                      if RemArea < 0 then
                        RemArea := 0;
                      Layplans[length(LayPlans) - 1].StartLeft := StartLeft;
                      Layplans[length(LayPlans) - 1].RemHeight := RemHeight;
                      Layplans[length(LayPlans) - 1].RemWidth := RemWidth;

                      Layplans[length(LayPlans) - 1].Pack := copy(PackResults);
                      Layplans[length(Layplans) - 1].PropogationInput := PropogationInput;
                      Layplans[length(LayPlans) - 1].PropogationNo := PropogationNo;
                    end;
                    application.processmessages;

                    //Utilisation
                    Utilisation := KnivesUsed[0, 0].PatternNettArea * NumberOfPatterns; //SqFt
                    Utilisation := Utilisation / 9 * 0.8361;  //SqM
                    if MaterialAreaM2 <> 0 then
                      Utilisation := Utilisation / MaterialAreaM2 * 100
                    else
                      Utilisation := 999;

                    sgLayPlans.RowCount := length(Layplans);
                    if not ReleasedVersion then
                      sgLayPlans.Cells[0, sgLayPlans.RowCount - 1] := PackCode
                    else
                      sgLayPlans.Cells[0, sgLayPlans.RowCount - 1] := intToStr(PlanNo);
                    sgLayPlans.Cells[9, sgLayPlans.RowCount - 1] := PackCode;

                    sgLayPlans.Cells[1, sgLayPlans.RowCount - 1] := sAngle;
                    sgLayPlans.Cells[2, sgLayPlans.RowCount - 1] := sBasicComplexity;

                    //No Result (Error) is possibly because of hump problem when
                    //rotated OR Interlocking error caused by merge. Also now set
                    //Success false if Utilisation > 100
                    UtilisationError := (Utilisation > 100);
                    if UtilisationError then
                      Success := False;
                    if not Success then
                      Utilisation := -1;

                    str(Utilisation : 5 : 1, s);
                    sgLayPlans.Cells[3, sgLayPlans.RowCount - 1] := s;

                    if Success then
                      s := intToStr(NumberOfPatterns)
                    else
                      s := '0';
                    sgLayPlans.Cells[4, sgLayPlans.RowCount - 1] := s;
                    if Success then
                      str(RemArea : 5 : 2 , s)
                    else
                      s := '0';
                    sgLayPlans.Cells[5, sgLayPlans.RowCount - 1] := s;
                    sgLayPlans.Cells[6, sgLayPlans.RowCount - 1] := intToStr(PlanNo);  //Plan #
                    str(PlanNo : 10, s);
                    sgLayPlans.Cells[7, sgLayPlans.RowCount - 1] := s; //intToStr(PlanNo);  //Lay plan #
                    if Success then
                      str((NumberOfPatterns * 10000) + RemArea : 16 : 2, s)
                    else
                      s := '                '; //Put Errors at the bottom
                    sgLayPlans.Cells[8, sgLayPlans.RowCount - 1] := s;
                    sgLayPlans.Row := sgLayPlans.RowCount - 1;

                    if NumberOfPatterns <> Length(CutResults) then
                    begin
                      sgDebug.Cells[0, sgDebug.RowCount - 1] := sgLayPlans.Cells[0, sgLayPlans.RowCount - 1] +
                        ' ' + sgLayPlans.Cells[1, sgLayPlans.RowCount - 1];
                      sgDebug.Cells[1, sgDebug.RowCount - 1] := sgLayPlans.Cells[4, sgLayPlans.RowCount - 1];
                      sgDebug.Cells[2, sgDebug.RowCount - 1] := intToStr(Length(CutResults));
                      sgDebug.Cells[3, sgDebug.RowCount - 1] := sgLayPlans.Cells[7, sgLayPlans.RowCount - 1];
                      sgDebug.Cells[4, sgDebug.RowCount - 1] := IntToStr(sgLayPlans.RowCount - 1);
                      sgDebug.RowCount := sgDebug.RowCount + 1;
                    end;

                    if (Success and PreviewThis) and (NumberOfPatterns > 0) then
                      DisplayResults(imgLayPlan);

                    //Scroll bar
                    a := PlanNo;
                    b := NoPlans * NoAnglesPerPlan;
                    a := a / b * 100;
                    pbLayplans.Position := round(a);

                    //Best so far
                    if NumberOfPatterns > BestNumberOfPatterns then
                      BestNumberOfPatterns := NumberOfPatterns;

                    lblBestPieces.Caption := intToStr(BestNumberOfPatterns);

                    lblElapsedTime.Caption := ElapsedTime(Now - StartTime);
                    application.processmessages;

//                    if (not Success) or (Utilisation > 90) then
                    if (not Success) then
                    begin
                      ErrorFileExists := FileExists('Layplans_Log.txt');

                      AssignFile(OutFile, 'Layplans_Log.txt');
                      if ErrorFileExists then
                        Append(OutFile)
                      else
                        ReWrite(outFile);

                      if rgOptimisation.ItemIndex = 0 then
                        s := '   Type: Speed   Cutgap: '
                      else
                        s := '   Type: Accuracy   Cutgap: ';
                      s := DateTimeToStr(Now) +
                           '   Knife: ' + KnifeCode +
                           '   Start Angle: ' + lblAdjustmentAngle.Caption +
                           '   Pack Code: ' + PackCode +
                           '   Angle: ' + sAngle + s + intToStr(sedtExpand.Value) +
                           '   Complexity: ' + sBasicComplexity;

                      if UtilisationError then
                        writeln(OutFile, s + ' UTILISATION ERROR (>100%)')
                      else if (not Success) then
                        writeln(OutFile, s + ' ERROR');
//                      else if Utilisation > 90 then
//                        writeln(OutFile, s + ' Utilisation Warning (>90%)');
                      CloseFile(OutFile);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    {$IFDEF DEBUG}
    AllAngles := GetTickCount - AllAngles;
    TotalAllAngles := TotalAllAngles + AllAngles;
    {$ENDIF}

    Angle := Angle + AngleStep;
  end;

  sgDebug.RowCount := sgDebug.RowCount - 1;

  Calculating := False;
  LayPlansLoaded := (PlanNo <> 0);

  {
  case rgNumberOfResults.ItemIndex of
    0: sNoOfLayPlans := intToStr(NoPlans * NoAnglesPerPlan);
    1: sNoOfLayPlans := intToStr(NoPlans);
    2: sNoOfLayPlans := intToStr(NoPlans);
    3: sNoOfLayPlans := intToStr(NoPlans);
  end;

  if rgNumberOfResults.ItemIndex > 1 then
    ResultsCaption := 'Results : Best of '
  else
    ResultsCaption := 'Results : ';
  ResultsCaption := ResultsCaption + sNoOfLayplans;
  }
  ResultsCaption := 'Results';
  if not ReleasedVersion then
  begin
    ResultsCaption := ResultsCaption + '  (Angles ';
    if rgNumberOfResults.ItemIndex = 1 then
      ResultsCaption := ResultsCaption + '''Best of ' + intToStr(NoAnglesPerPlan) + ''''
    else
      ResultsCaption := ResultsCaption + intToStr(NoAnglesPerPlan);
    ResultsCaption := ResultsCaption + ', Plans per angle ' + intToStr(NoPlans) + ')';
  end;

  //Clear Results if not showing all and have aborted
  if AbortLayplanning and (rgNumberOfResults.ItemIndex <> 0) then
  begin
    //Minimum of 1 row so blank it;
    sgLayPlans.RowCount := 1;
    sgLayPlans.Cells[0, 0] := '';
    sgLayPlans.Cells[1, 0] := '';
    sgLayPlans.Cells[2, 0] := '';
    sgLayPlans.Cells[3, 0] := '';
    sgLayPlans.Cells[4, 0] := '';
    sgLayPlans.Cells[5, 0] := '';
    sgLayPlans.Cells[6, 0] := '';
    sgLayPlans.Cells[7, 0] := '';
    sgLayPlans.Cells[8, 0] := '';
    sgLayPlans.Cells[9, 0] := '';
  end;

  //Filter results so only 1 per pack
  if (not AbortLayplanning) and (rgNumberOfResults.ItemIndex <> 0) then
    FilterResults(NoPlans, NoAnglesPerPlan);

  //Sort and display in order best
  if (not AbortLayplanning) then
  begin
    SortResults;
    lblSelectedLayplan.Caption := '<None>';
  end;

  //Delete all but best
  if (not AbortLayplanning) then
  begin
    TrimRowCount := 999999;
    if rgNumberOfResults.ItemIndex = 2 then
      TrimRowCount := 10
    else if rgNumberOfResults.ItemIndex = 3 then
      TrimRowCount := ResultsCutOff(sedtSelectionsNo.value, sedtSelectionsGrade.value, sedtSelectionsPerc.value);

    if sgLayPlans.RowCount > TrimRowCount then
      sgLayPlans.RowCount := TrimRowCount;
  end;

  screen.cursor := crDefault;

  pnlCalculating.Visible := False;
  if BestNumberOfPatterns = 0 then
  begin
    CanSave := False;
    SelectedLayplanChanged := False;
    LayPlansLoaded := False;
  end
  else if PlanNo <> 0 then
  begin
    CanSave := not AbortLayplanning;
    SelectedLayplanChanged := False;
  end
  else if (not AbortLayplanning) then
    messagedlg('No Layplans were created', mtInformation, [mbOk], 0);

  if not(ReleasedVersion) and (sgDebug.RowCount > 1) then
    tsDebug.TabVisible := True;

  UpdateScreen;

  if (not FromBulkLayplanning) and (not Option_ProductionSystem) and (CanSave or SelectedLayplanChanged) then
  begin
    sgLayPlansDblClick(self);
    CheckAndSaveLayplan;
  end;

{$IFDEF DEBUG}
  WholeCreate := GetTickCount - WholeCreate;
  MessageDlg('KnifeCode - ' + KnifeCode + #13 + #13 +
             'Pattern - ' + #13 +
             'No Points: ' + IntToStr(NoPointsInOriginal) + #13 +
             'Height: ' + IntToStr(KeepHeight) + #13 +
             'Width: ' + IntToStr(KeepWidth) + #13 +
             'Area: ' + FloatToStr(KeepArea) + #13 + #13 +
             'Of Create Layplans (Total ' + IntToStr(round(WholeCreate / 1000)) + ' Secs) -' + #13 +
             'Find Interlocks: ' + IntToStr(round(TotalInFindInterlocks / 1000)) + ' Secs = ' +
                                   IntToStr(round(TotalInFindInterlocks / WholeCreate * 100)) + '%' + #13 +
             'Plan (Other than FindInterlocks): ' + IntToStr(round(TotalPlan / 1000)) + ' Secs = ' +
                                                    IntToStr(round(TotalPlan / WholeCreate * 100)) + '%' + #13 +
             'Total time in Merge routine : ' + IntToStr(round(TotalInMerge / 1000)) + ' Secs = ' +
                                                IntToStr(round(TotalInMerge / WholeCreate * 100)) + '%' + #13 +
             'In Diagonal Free (not including Plan): ' + IntToStr(round(AllDiagonalFrees / WholeCreate * 100)) + '%' + #13 +
             'Loop through angles (without Plan): ' + IntToStr(round(TotalAllAngles / WholeCreate * 100)) + '%' + #13 + #13 +
             'Of FindInterlocks -' + #13 +
             'Measuring Area: ' + IntToStr(round(TotalInOverlappingCPs / TotalInFindInterlocks * 100)) + '%' + #13 +
             'Describe Patterns: ' + IntToStr(round(TotalDescs / TotalInFindInterlocks * 100)) + '%' + #13 + #13 +
             'Of Plan -' + #13 +
             'Update Synthetic Results: ' + IntToStr(round(TotalUpdateSynthRes / TotalFullPlan * 100)) + '%' + #13 +
             'Find Interlocks: ' + IntToStr(round(TotalFI / TotalFullPlan * 100)) + '%' + #13 +
             'Propogations: ' + IntToStr(round(TotalProp / TotalFullPlan * 100)) + '%' + #13 + #13 +
             'Of Update Synthetic Results - ' + #13 +
             'Create Patterns (3 times): ' + IntToStr(round(TotalDoCreate / TotalUpdateSynthRes * 100)) + '%' + #13 +
             'Merge Patterns: ' + IntToStr(round(TotalDoMerge / TotalUpdateSynthRes * 100)) + '%', mtInformation, [mbOK], 0);
{$ENDIF}
end;

procedure TfmLayplan.DisplayResults(img: TImage);
var
  bmp: TBitmap;
  xOffset, yOffset: integer;
  ShowEdges, ShowNumbers: Boolean;
  clMaterialEdge: TColor;
  Offset, TopEdge: integer;
  Display_VisibleMaterialLength, Display_MaterialLength, Display_MaterialWidth,
  Display_PAGE_EDGE_WIDTH, Display_Edge, Display_ResultsRemHeight,
  Display_ResultsRemWidth: integer;
  x1, y1, x2, y2: Integer;

begin
//  if Option_ProductionSystem then //Now available in Costings Only version too
  begin
    Display_VisibleMaterialLength := round(VisibleMaterialLength * DisplayScale);
    Display_MaterialLength := round(MaterialLength * DisplayScale);
    Display_MaterialWidth := round(MaterialWidth * DisplayScale);
    Display_PAGE_EDGE_WIDTH := round(PAGE_EDGE_WIDTH * DisplayScale);
    Display_Edge := round(Edge * DisplayScale);
    Display_ResultsRemHeight := round(ResultsRemHeight * DisplayScale);
    Display_ResultsRemWidth := round(ResultsRemWidth * DisplayScale);

    if not SimpleDrawing then
      clMaterialEdge := clBackVeryDark
    else
      clMaterialEdge := clEditing;

    ShowEdges := mnuLayplansShowRemainingEdges.Checked and (Zoom = 1) and (not Calculating);

    //Create Bitmap
    bmp := TBitmap.Create;
    bmp.PixelFormat := pf4bit;
    bmp.Height := Display_VisibleMaterialLength;
    bmp.Width := Display_MaterialWidth;

    SmallScale := 1;
    if bmp.Width > 0 then
    begin
      if bmp.Width < img.Width then
      begin
        SmallScale := img.Width / bmp.Width;
        bmp.Height := round(bmp.Height * SmallScale);
        bmp.Width := round(bmp.Width * SmallScale);
      end;
    end;

    //Material
    if (not ShowEdges) or SimpleDrawing then
    begin
      bmp.Canvas.brush.color := clMaterial;
      bmp.Canvas.pen.Width := Display_PAGE_EDGE_WIDTH;
      if clMaterial <> clEditing then
        bmp.Canvas.pen.Color := clMaterial
      else
        bmp.Canvas.pen.Color := clBlack;
    end
    else
    begin
      bmp.Canvas.pen.Color := clDkGray;
      bmp.Canvas.brush.color := clDkGray;
    end;
    x1 := 0;
    y1 := 0;
    x2 := Display_MaterialWidth;
    y2 := Display_VisibleMaterialLength;
    bmp.Canvas.Rectangle(round(x1 * SmallScale), round(y1 * SmallScale), round(x2 * SmallScale), round(y2 * SmallScale));

    //Edge
    if (Zoom = 1) then
    begin
      bmp.Canvas.brush.Color := clMaterialEdge;
      bmp.Canvas.pen.Width := Display_PAGE_EDGE_WIDTH;
      if clMaterialEdge <> clEditing then
        bmp.Canvas.pen.Color := clMaterialEdge
      else
        bmp.Canvas.pen.Color := clBlack;
      if not (IsRoll and (not mnuLayPlansShowWholeLength.Checked)) then
      begin
        x1 := 0;
        y1 := 0;
        x2 := Display_MaterialWidth;
        y2 := Display_Edge;
      end;
      bmp.Canvas.Rectangle(round(x1 * SmallScale), round(y1 * SmallScale), round(x2 * SmallScale), round(y2 * SmallScale));
      if not ResultsLeft then
      begin
        x1 := 0;
        y1 := 0;
        x2 := Display_Edge;
        y2 := Display_VisibleMaterialLength;
      end
      else
      begin
        x1 := Display_MaterialWidth - Display_Edge;
        y1 := 0;
        x2 := Display_MaterialWidth;
        y2 := Display_VisibleMaterialLength;
      end;
      bmp.Canvas.Rectangle(round(x1 * SmallScale), round(y1 * SmallScale), round(x2 * SmallScale), round(y2 * SmallScale));
    end;

    //Remaining area
    if ShowEdges and (Zoom = 1) then
    begin
      Offset := Display_MaterialLength - Display_VisibleMaterialLength;

      bmp.Canvas.brush.Color := clMaterial;
      bmp.Canvas.pen.Width := Display_PAGE_EDGE_WIDTH;
      if clMaterial <> clEditing then
        bmp.Canvas.pen.Color := clMaterial
      else
        bmp.Canvas.pen.Color := clBlack;

      TopEdge := Display_Edge;
      if (IsRoll and (not mnuLayPlansShowWholeLength.Checked)) then
        TopEdge := 0;

      if not ResultsLeft then
      begin
        x1 := Display_Edge;
        y1 := Display_Edge;
        x2 := Display_MaterialWidth;
        y2 := Display_Edge + Display_ResultsRemHeight - Offset;
        bmp.Canvas.Rectangle(round(x1 * SmallScale), round(y1 * SmallScale), round(x2 * SmallScale), round(y2 * SmallScale));
        x1 := Display_Edge;
        y1 := TopEdge;
        x2 := Display_Edge + Display_ResultsRemWidth;
        y2 := Display_VisibleMaterialLength;
        bmp.Canvas.Rectangle(round(x1 * SmallScale), round(y1 * SmallScale), round(x2 * SmallScale), round(y2 * SmallScale));
      end
      else
      begin
        x1 := 0;
        y1 := Display_Edge;
        x2 := Display_MaterialWidth - Display_Edge;
        y2 := Display_Edge + Display_ResultsRemHeight - Offset;
bmp.Canvas.pen.Color := clRed;
bmp.Canvas.brush.Color := clRed;
//        bmp.Canvas.Rectangle(round(x1 * SmallScale), round(y1 * SmallScale), round(x2 * SmallScale), round(y2 * SmallScale));
        bmp.Canvas.Rectangle(x1, y1, x2, y2);
        x1 := Display_MaterialWidth - Display_ResultsRemWidth - Display_Edge;
        y1 := TopEdge;
        x2 := Display_MaterialWidth - Display_Edge;
        y2 := Display_VisibleMaterialLength;
bmp.Canvas.pen.Color := clYellow;
bmp.Canvas.brush.Color := clYellow;
//        bmp.Canvas.Rectangle(round(x1 * SmallScale), round(y1 * SmallScale), round(x2 * SmallScale), round(y2 * SmallScale));
      end;
    end;

    //Cuts
    if ResultsLeft then
      xOffset := 0
    else
    begin
      xOffset := (- (Zoom - 1) * MaterialWidth) + (Zoom * Edge);
    end;
    yOffset := (- (Zoom - 1) * MaterialLength - (MaterialLength - VisibleMaterialLength)) + (Zoom * Edge);
    ShowNumbers := mnuLayPlansShowCount.Checked;
    if Zoom > 1 then
      ShowNumbers := False;

    DrawResults(bmp.Canvas, xOffset, yOffset, Zoom, mnuLayplansShowBorder.Checked,
                mnuLayPlansShowCutGaps.Checked, False, False, ShowNumbers,
                False, False, SimpleDrawing, SmallScale);

    //Assign to image
    img.Visible := False;
    img.Picture.Bitmap := bmp;
    img.Visible := True;

    //Destroy Bitmap
    FreeAndNil(bmp);

    imgJaggyEdgeLeft.Visible := (Zoom > 1) and (not ResultsLeft);
    imgJaggyEdgeRight.Visible := (Zoom > 1) and ResultsLeft;

    //Width of Right Jaggy Edge
    imgJaggyEdgeRight.Width := 30 + imgLayPlan.Width -
                              (imgLayPlan.Height * imgLayPlan.Picture.Bitmap.Width div
                               imgLayPlan.Picture.Bitmap.Height);
    if imgJaggyEdgeRight.Width < 30 then
      imgJaggyEdgeRight.Width := 30;

    //Override ruler
    DrawLayplanRulers;
  end;
end;

procedure TfmLayplan.DisplayMaterial(img: TImage; ShowPretendKnife: Boolean);
var
  bmp: TBitmap;
  s: string;

begin
  if (Zoom = 0) or (Zoom = 1) then
  begin
    if not SimpleDrawing then
      clMaterial := clHide
    else
      clMaterial := clEditing;
  end
  else
  begin
    if not SimpleDrawing then
      clMaterial := clRed
    else
      clMaterial := clEditing;
  end;

//  pnlLayPlanAndRulerBottom.color := clMaterial;

  VisibleMaterialLength := MaterialLength;
  if (MaterialLength > MaterialWidth) and (not mnuLayPlansShowWholeLength.Checked) then
    VisibleMaterialLength := MaterialWidth;

  //Create Bitmap
  bmp := TBitmap.Create;
  bmp.PixelFormat := pf4bit;
  bmp.Height := round(VisibleMaterialLength * DisplayScale);
  bmp.Width := round(MaterialWidth * DisplayScale);

  SmallScale := 1;
  if bmp.Width > 0 then
  begin
    if bmp.Width < img.Width then
    begin
      SmallScale := img.Width / bmp.Width;
      bmp.Height := round(bmp.Height * SmallScale);
      bmp.Width := round(bmp.Width * SmallScale);
    end;
  end;

  //Material
  bmp.Canvas.pen.Color := clMaterial;
  bmp.Canvas.brush.color := clMaterial;
  bmp.Canvas.Rectangle(0, 0, round(MaterialWidth * SmallScale), round(VisibleMaterialLength * SmallScale));

  //Pretend cut
  if Option_ProductionSystem and ShowPretendKnife and (Length(ActualPoints) <> 0) and
     (MaterialLength >= Knife.Height) and (MaterialWidth >= Knife.Width) then
    DrawPretendKnife(bmp.Canvas);

  str(SmallScale : 10 : 2, s);
  label1.caption := s;

  //Assign to image
  img.Picture.Bitmap := bmp;

  //Destroy Bitmap
  bmp.Free;
end;

function TfmLayplan.KerfWidth: integer;
var
  KerfWidthThousIn: real;

begin
  //Cut gap is entered in mm but stored in 1/1000ths inch
  //because digitising returns 1/1000 inches.
  //Kerf Width is half the Cut gap.
  KerfWidthThousIn := (sedtExpand.value / 2) * 0.03937 * 1000;

  Result := round(KerfWidthThousIn);
end;

procedure TfmLayplan.DrawPretendKnife(Canvas: TCanvas);
var
  i, PossibleMaterialLength: integer;
  xy: TPointArray;
  xOffset, yOffset: real;

begin
  if ResultsLeft then
    xOffset := 0
  else
    xOffset := MaterialWidth - Knife.Width;
  PossibleMaterialLength := MaterialLength;
  if isRoll and (not mnuLayPlansShowWholeLength.checked) then
    PossibleMaterialLength := MaterialWidth;
  yOffset := PossibleMaterialLength - Knife.Height;

  SetLength(xy, Length(Knife.PatternPoints));
  for i := 0 to Length(Knife.PatternPoints) - 1 do
  begin
//    xy[i].x := round(Knife.PatternPoints[i].x + xOffset);
//    xy[i].y := round(Knife.PatternPoints[i].y + yOffset);
    xy[i].x := round((Knife.PatternPoints[i].x + xOffset) * SmallScale);
    xy[i].y := round((Knife.PatternPoints[i].y + yOffset) * SmallScale);
  end;

  if not SimpleDrawing then
  begin
    Canvas.Pen.Color := clCut;
    Canvas.Brush.Color := clCut;
  end
  else
  begin
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color := clBlack;
  end;
  Canvas.Polygon(xy);
end;

procedure TfmLayplan.SetPiecesCaps;
begin
  if ((pedtMaterialLength.value = 2500.00) and (cbUnitsMaterial.Text = 'M')) or
     ((pedtMaterialLength.value = 984.24) and (cbUnitsMaterial.Text = 'FT'))then
  begin
    pnlTitles5.Caption := 'Pieces*';
    pnlExplanation.Visible := True;
  end
  else
  begin
    pnlTitles5.Caption := 'Pieces';
    pnlExplanation.Visible := False;
  end;
end;

procedure TfmLayplan.MaterialSizeChange;
var
  MatHeightFt, MatWidthFt, EdgeFt: real;

begin
  if pedtMaterialLength.value > pedtMaterialLength.MaxValue then
    pedtMaterialLength.value := pedtMaterialLength.MaxValue;
  if pedtMaterialLength.Value < pedtMaterialLength.MinValue then
    pedtMaterialLength.value := pedtMaterialLength.MinValue;
  if pedtMaterialWidth.value > pedtMaterialWidth.MaxValue then
    pedtMaterialWidth.value := pedtMaterialWidth.MaxValue;
  if pedtMaterialWidth.Value < pedtMaterialWidth.MinValue then
    pedtMaterialWidth.value := pedtMaterialWidth.MinValue;

  //Material Sizes are entered in Centimetres but stored in Feet
  //because digitising returns 1/1000 inches
  MatHeightFt := pedtMaterialLength.value * SummsToFtMultiplier;
  MatWidthFt := pedtMaterialWidth.value * SummsToFtMultiplier;
  try
    EdgeFt := sedtEdge.value / 1000 * 1.0936 * 3;
  except
    EdgeFt := 0;
  end;

  MaterialLength := round(MatHeightFt * 12000 / PATTERNRES);
  MaterialWidth := round(MatWidthFt * 12000 / PATTERNRES);
  Edge := round(EdgeFt * 12000 / PATTERNRES);

  UsableMaterialLength := round((MatHeightFt - EdgeFt) * 12000 / PATTERNRES);
  UsableMaterialWidth := round((MatWidthFt - EdgeFt) * 12000 / PATTERNRES);

  IsRoll := (MaterialLength > MaterialWidth);

  //Only allow seeing Whole Length up to ROLL_LENGTH_WIDTH_RATIO x width (Initially as 2)
  if MaterialLength > (ROLL_LENGTH_WIDTH_RATIO * MaterialWidth) then
  begin
    if mnuLayPlansShowWholeLength.checked then
    begin
      mnuLayPlansShowWholeLength.checked := False;
      if not FromBulkLayplanning then
        messagedlg('Whole Length viewable only up to ' + intToStr(ROLL_LENGTH_WIDTH_RATIO) + ' x Width', mtInformation, [mbOk], 0);
    end;
    btnView.enabled := False;
  end
  else
    btnView.enabled := (MaterialLength > MaterialWidth);

  if IsRoll and mnuLayPlansShowWholeLength.Checked and (Zoom = 1) then
    tbZoom.Position := 1;

  DisplayMaterial(imgLayPlan, True);
  DrawLayPlanRulers;

  imgJaggyEdgeTop.Visible := (Zoom > 1) or (IsRoll and (not mnuLayPlansShowWholeLength.Checked));
  imgJaggyEdgeLeft.Visible := (Zoom > 1);
  imgJaggyEdgeRight.Visible := False;
  sgLayPlansClick(Sender);
  SetPiecesCaps;
end;

procedure TfmLayplan.CheckMenuItem(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;
end;

procedure TfmLayplan.mnuLayPlansClearClick(Sender: TObject);
begin
  UnminimizeLayMain;

  if CanSave or SelectedLayplanChanged then
    CheckAndSaveLayplan;

  ClearLayPlans;
end;

procedure TfmLayplan.btnAllPatternsClick(Sender: TObject);
begin
  mnuLayplansOpenKnifeClick(Sender);
end;

procedure TfmLayplan.ClearLayPlans;
begin
  if Zoom <> 1 then
    tbZoom.Position := 1;

  LayPlanInitialise(AdjustmentAngle, False);
  FindInitialise(True);
end;

procedure TfmLayplan.mnuLayPlansCreateClick(Sender: TObject);
var
  Start: Boolean;
  NumPoints: integer;
  h: TButton;

begin
{$IFDEF DEBUG}
  WholeCreate := 0;
  TotalInOverlappingCPs := 0;
  TotalInFindInterlocks := 0;
  TotalDescs := 0;
  TotalPlan := 0;
  TotalAllAngles := 0;
  AllDiagonalFrees := 0;
  TotalUpdateSynthRes := 0;
  TotalDoMerge := 0;
  TotalDoCreate := 0;
  TotalFullPlan := 0;
  TotalProp := 0;
  TotalFI := 0;
  TotalInMerge := 0;
{$ENDIF}

  UnminimizeLayMain;

  //Decide whether to use Filtered
  //Pattern or original shape
  OriginalPoints := Copy(ActualPoints);
  if rgOptimisation.ItemIndex = 0 then
  begin
    NumPoints := Length(OriginalPoints);
    if Length(OriginalPoints) > MaximumPatternPoints then
    begin
      Tolerance := 0;
      while (NumPoints > MaximumPatternPoints) do
      begin
        Tolerance := Tolerance + 1;
        NumPoints := PolySimplifyInt2D(Tolerance, ActualPoints, OriginalPoints);
      end;
    end;
  end
  else
    NumPoints := PolySimplifyInt2D(4, ActualPoints, OriginalPoints);
  SetLength(OriginalPoints, NumPoints);

  Start := True;
  if (not FromSATRASumm) or (not LayplansLoaded) then
  begin
    if LayplanExists then
    begin
      if CustomMessagedlg('Layplan Set already exists. This can' + #13 +
                          'be loaded or new Layplans calculated.', mtConfirmation,
                          [mbYes, mbNo], ['Load', 'Calculate']) = mrYes then
      begin
        ReadLayplans;
        Start := False;
      end;
    end;
  end;

  if Start then
    CreateLayplans;
end;

procedure TfmLayplan.btnCreateLayPlansClick(Sender: TObject);
begin
  mnuLayPlansCreateClick(Sender);
end;

procedure TfmLayplan.sgLayPlansClick(Sender: TObject);
var
  PatWidth, NumberOfPatterns: integer;
  DisplayPlan: Boolean;

begin
  if LayPlansLoaded then
  begin
    DisplayPlan := True;

    ResultsLeft := LayPlans[strToInt(sgLayPlans.Cells[7, sgLayPlans.Row]) - 1].StartLeft;
    ResultsRemHeight := round(LayPlans[strToInt(sgLayPlans.Cells[7, sgLayPlans.Row]) - 1].RemHeight);
    ResultsRemWidth := round(LayPlans[strToInt(sgLayPlans.Cells[7, sgLayPlans.Row]) - 1].RemWidth);

    PropogationInput := LayPlans[strToInt(sgLayPlans.Cells[7, sgLayPlans.Row]) - 1].PropogationInput;
    PropogationNo := LayPlans[strToInt(sgLayPlans.Cells[7, sgLayPlans.Row]) - 1].PropogationNo;

    //Copy the Pack into CutResults in preparation
    //for recreation of Layplan below.
    SetLength(CutResults, 0);
    SetLength(PackResults, 0);
    NumberOfPatterns := strToInt(sgLayPlans.Cells[4, sgLayPlans.Row]);
    CutResults := Copy(LayPlans[strToInt(sgLayPlans.Cells[7, sgLayPlans.Row]) - 1].Pack);
    PackResults := Copy(LayPlans[strToInt(sgLayPlans.Cells[7, sgLayPlans.Row]) - 1].Pack);
    if NumberOfPatterns > 0 then
    begin
      CurrentKnife := PackResults[0].KnifeNo;

      //Recreate Layplan
      if PropogationInput.LocalInterlock.Used then
        PatWidth := PropogationInput.LocalInterlock.SinglePatternWidth
      else
        PatWidth := PropogationInput.PatternWidth;
      ReCreateLoadedLayplan(UsableMaterialLength, UsableMaterialWidth, PatWidth,
                            PropogationInput.StartLeft);
    end
    else
      DisplayPlan := False;

    if DisplayPlan then
      DisplayResults(imgLayPlan);
  end;
end;

procedure TfmLayplan.FormResize(Sender: TObject);
begin
  imgLayPlan.Left := 0;
  imgLayPlan.Top := 0;
  imgLayPlan.Height := pnlLayPlanAndRulerBottom.Height - pnlLayPlanRulerBottom.Height;
  imgLayPlan.Width := pnlLayPlanAndRulerBottom.Width;

  if (PreviewThis or (not Calculating)) and (Length(CutResults) > 0) then
    DisplayResults(imgLayPlan)
  else
    DisplayMaterial(imgLayPlan, (not Calculating));
  DrawLayPlanRulers;

  pnlCalculating.Left := (imgLayPlan.Width div 2) - (pnlCalculating.Width div 2);
  pnlCalculating.Top := (imgLayPlan.Height div 2) - (pnlCalculating.Height div 2);

  pnlPrintPreviewOpen.Left := (imgLayPlan.Width div 2) - (pnlPrintPreviewOpen.Width div 2);
  pnlPrintPreviewOpen.Top := (imgLayPlan.Height div 2) - (pnlPrintPreviewOpen.Height div 2);

  lblNoVisibleLayplan.Left := (imgLayPlan.Width div 2) - (lblNoVisibleLayplan.Width div 2);
  lblNoVisibleLayplan.Top := (imgLayPlan.Height div 2) - (lblNoVisibleLayplan.Height div 2);
end;

procedure TfmLayplan.DrawLayPlanRulers;
var
  ActualMaterialLength, ActualMaterialWidth: real;
  PossibleMaterialLength, PossibleMaterialWidth: real;
  RatioMaterial, RatioImages, RatioRuler, RatioUnits: real;

begin
  //Dimensions can become zero during changing
  if (MaterialLength <> 0) and (MaterialWidth <> 0) and (Zoom <> 0) then
  begin
    PossibleMaterialLength := MaterialLength;
    PossibleMaterialWidth := MaterialWidth;

    if isRoll and (not mnuLayPlansShowWholeLength.checked) then
      PossibleMaterialLength := PossibleMaterialWidth;

    RatioMaterial := PossibleMaterialLength / MaterialWidth;
    RatioImages := imgLayPlan.Height / imgLayPlan.Width;

    if (RatioImages < (RatioMaterial)) then
      PossibleMaterialWidth := MaterialWidth / RatioImages * RatioMaterial
    else if (RatioMaterial < RatioImages) then
      PossibleMaterialLength := PossibleMaterialLength * RatioImages / RatioMaterial;

    ActualMaterialLength := (MaterialLength / (1000 div PATTERNRES)) * 2.54; //cm
    ActualMaterialWidth := (MaterialWidth / (1000 div PATTERNRES)) * 2.54; //cm
    PossibleMaterialLength := (PossibleMaterialLength / (1000 div PATTERNRES)) * 2.54; //cm
    PossibleMaterialWidth := (PossibleMaterialWidth / (1000 div PATTERNRES)) * 2.54;   //cm

    //Make it readable
    RatioRuler := max(PossibleMaterialLength, PossibleMaterialWidth) / min(PossibleMaterialLength, PossibleMaterialWidth);

    rulerLayPlanLeft.UnitSize := rulerLayPlanLeft.Height / (PossibleMaterialLength / 10) * RatioRuler;
    rulerLayPlanLeft.UnitPrice := 10 / Zoom * RatioRuler;
    rulerLayPlanRight.UnitSize := rulerLayPlanRight.Height / (PossibleMaterialLength / 10) * RatioRuler;
    rulerLayPlanRight.UnitPrice := 10 / Zoom * RatioRuler;
    rulerLayPlanBottom.UnitSize := rulerLayPlanBottom.Width / (PossibleMaterialWidth / 10) * RatioRuler;
    rulerLayPlanBottom.UnitPrice := 10 / Zoom * RatioRuler;

    //Adjust Units (& offset for Rolls or Zoom)
    RatioUnits := 10 / rulerLayPlanLeft.UnitPrice;
    rulerLayPlanLeft.UnitPrice := 10;
    rulerLayPlanLeft.UnitSize := rulerLayPlanLeft.UnitSize * RatioUnits;
    if mnuLayPlansShowWholeLength.Checked then
      rulerLayPlanLeft.StartValue := 0
    else
      rulerLayPlanLeft.StartValue := ((ActualMaterialWidth - (ActualMaterialWidth / Zoom)) / 10 * Zoom / RatioRuler / RatioUnits) +
                                     ((ActualMaterialLength - min(ActualMaterialLength, ActualMaterialWidth)) / 10);

    rulerLayPlanRight.UnitPrice := rulerlayPlanLeft.UnitPrice;
    rulerLayPlanRight.UnitSize := rulerlayPlanLeft.UnitSize;
    rulerLayPlanRight.StartValue := rulerlayPlanLeft.StartValue;

    RatioUnits := 10 / rulerLayPlanBottom.UnitPrice;
    rulerLayPlanBottom.UnitPrice := 10;
    rulerLayPlanBottom.UnitSize := rulerLayPlanBottom.UnitSize * RatioUnits;
    if ResultsLeft then
      rulerLayPlanBottom.StartValue := 0
    else
      rulerLayPlanBottom.StartValue := (ActualMaterialWidth - (ActualMaterialWidth / Zoom)) / 10 * Zoom / RatioRuler / RatioUnits;

    rulerLayPlanBottom.UnitSize := rulerLayPlanBottom.UnitSize * SummsToCmMultiplier;
    rulerLayPlanLeft.UnitSize := rulerLayPlanLeft.UnitSize * SummsToCmMultiplier;
    rulerLayPlanRight.UnitSize := rulerLayPlanRight.UnitSize * SummsToCmMultiplier;

    rulerLayPlanBottom.StartValue := rulerLayPlanBottom.StartValue / SummsToCmMultiplier;
    rulerLayPlanLeft.StartValue := rulerLayPlanLeft.StartValue / SummsToCmMultiplier;
    rulerLayPlanRight.StartValue := rulerLayPlanRight.StartValue / SummsToCmMultiplier;
  end;

  //Ensure both on together to calibrate units...
  pnlLayPlanRulerLeft.Visible := True;
  pnlLayPlanRulerRight.Visible := True;

  //...& turn one off
  pnlLayPlanRulerLeft.Visible := ResultsLeft;
  pnlLayPlanRulerRight.Visible := not ResultsLeft;
end;

procedure TfmLayplan.UpdateScreen;
begin
  if FromSATRASumm then
    caption := 'Synthetic Layplanning (Specific Material / Knife / Width combination)'
  else
    caption := 'Synthetic Layplanning';

  mnuLayplansOpenKnife.enabled := (not FromBulkLayplanning) and (not Calculating) and ((not FromSATRASumm) or FromSATRASummSized);
  mnuLayplansOpenLayplan.enabled := (not FromBulkLayplanning) and (not Calculating) and KnifeLoaded and (not FromSATRASumm);
  mnuLayplansOpenMaterial.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded) and (not FromSATRASumm);
  mnuLayplansWithoutSelection.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and (not Calculating) and (not FromSATRASumm);
  mnuLayPlansClear.enabled := (not FromBulkLayplanning) and LayPlansLoaded;
  mnuLayPlansCreate.enabled := (not FromBulkLayplanning) and KnifeLoaded and (not Calculating);
  mnuLayPlansSave.enabled := (not FromBulkLayplanning) and KnifeLoaded and (not Calculating) and (CanSave or SelectedLayplanChanged);
  mnuLayPlansDelete.enabled := (not FromBulkLayplanning) and KnifeLoaded and (not Calculating) and LayPlansLoaded and (not CanSave) and (not AbortLayplanning);
  mnuLayPlansPrintPreview.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and KnifeLoaded and (not Calculating) and LayPlansLoaded;
  mnuLayPlansPrint.enabled := mnuLayPlansPrintPreview.enabled and (not FromBulkLayplanning);
  mnuLayPlansShowCutGaps.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and (not Calculating);
  mnuLayPlansShowWholeLength.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and (not Calculating);
  mnuLayPlansShowRemainingEdges.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and (not Calculating);
  mnuLayPlansShowBorder.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and (not Calculating) and (not SimpleDrawing);
  mnuLayPlansShowCount.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and (not Calculating);
  mnuLayPlansPreview.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and (not Calculating);
  mnuLayPlansSort.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and (not Calculating);
  mnuLayplansSimpleDrawing.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and (not Calculating);

  btnAllPatterns.enabled := mnuLayplansOpenKnife.enabled;
  btnAllLayplans.enabled := mnuLayplansOpenLayplan.enabled;
  btnAllMaterials.enabled := mnuLayplansOpenMaterial.enabled;
  btnLayplansWithoutSelection.enabled := mnuLayplansWithoutSelection.enabled;
  btnCreateLayPlans.enabled := mnuLayPlansCreate.enabled;
  btnClearLayPlans.enabled := mnuLayPlansClear.enabled;
  btnSaveLayPlans.enabled := mnuLayPlansSave.enabled;
  btnDeleteLayPlans.enabled := mnuLayPlansDelete.enabled;
  btnPrintPreview.enabled := mnuLayPlansPrintPreview.enabled;
  btnPrint.enabled := mnuLayPlansPrint.enabled;

  pedtMaterialLength.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded) and (not FromSATRASumm);
  pedtMaterialWidth.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded) and (not FromSATRASumm);
  btnRoll.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded) and (not FromSATRASumm);
  sedtExpand.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded) and ((not FromSATRASumm) or CanChangeCutGapFromSATRASumm);
  sedtEdge.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  pedtRestrictiveMaterial.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded) and (not FromSATRASumm);

  pnlInitialAngle.enabled := (not FromBulkLayplanning) and KnifeLoaded and (not Calculating) and (not LayPlansLoaded);
  btnNudgeLeft10.enabled := pnlInitialAngle.enabled;
  btnNudgeLeft1.enabled := pnlInitialAngle.enabled;
  btnNudgeLeftPoint1.enabled := pnlInitialAngle.enabled;
  btnNudgeRightPoint1.enabled := pnlInitialAngle.enabled;
  btnNudgeRight1.enabled := pnlInitialAngle.enabled;
  btnNudgeRight10.enabled := pnlInitialAngle.enabled;
  shpWheel.enabled := pnlInitialAngle.enabled;

  cbPacksSquareExcluded.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  cbPacksOffsetExcluded.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  cbPacksDiagonalExcluded.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  cbPacksDiagonalFreeExcluded.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  gbCuttingGuide.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  tbCuttingGuide.enabled := (not FromBulkLayplanning) and gbCuttingGuide.enabled;
  rgShowGangs.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  rgAdjustmentsAllowed.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  rgRotationalIncrements.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  rgAllowInvertion.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  rgCornerAnchoring.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  rgStartingSide.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  rgStartingCriteria.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  rgOptimisation.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  rgMaxGangs.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  rgNumberOfResults.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  gbSuggestions.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  sedtSelectionsNo.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  sedtSelectionsGrade.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  sedtSelectionsPerc.enabled := (not FromBulkLayplanning) and (not Calculating) and (not LayPlansLoaded);
  sgLayPlans.enabled := (not FromBulkLayplanning) and LayPlansLoaded;
  tbZoom.enabled := Option_ProductionSystem and (not FromBulkLayplanning) and (not Calculating) and LayPlansLoaded;
  if (IsRoll and mnuLayPlansShowWholeLength.Checked) then
    tbZoom.enabled := False;
  lblZoomNo.Enabled := tbZoom.enabled;
  lblNoVisibleLayplan.Visible := (not Option_ProductionSystem) and (not FromBulkLayplanning) and LayPlansLoaded;
  cbGrid.enabled := (not FromBulkLayplanning) and KnifeLoaded and (not Calculating) and (not LayPlansLoaded);

  cbUnitsMaterial.enabled := (not FromBulkLayplanning);
  cbUnitsKnife.enabled := (not FromBulkLayplanning);
{
  if AbortLayplanning then
    gbResults.Caption := 'Results (Aborted)'
  else if LayPlansLoaded then
    gbResults.Caption := ResultsCaption
  else
    gbResults.Caption := 'Results';

  if (not AbortLayplanning) then
  begin
    gbResults.Font.Color := OurColor(clWindowText);
    gbResults.Font.Style := [];
  end
  else
  begin
    gbResults.Font.Color := clRed;
    gbResults.Font.Style := [fsBold];
  end;
}
  lblZoomNo.caption := 'x ' + intToStr(Zoom);

  //First time through tbMain is not enabled but ok to be enabled once all of
  //the above 'per button' enabling has taken place. Doing this stops buttons
  //which shouldn't be pressed being pressed BEFORE they are disabled above.
  tbMain.Enabled := True;

  SetPiecesCaps;

  application.processmessages;
end;

procedure TfmLayplan.mnuLayplansShowCutGapsClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;

  UnminimizeLayMain;
  if LayPlansLoaded then
    sgLayPlansClick(Sender);
end;

procedure TfmLayplan.btnClearLayPlansClick(Sender: TObject);
begin
  mnuLayPlansClearClick(Sender);
end;

procedure TfmLayplan.btnAbortClick(Sender: TObject);
begin
  AbortLayplanning := True;
end;

procedure TfmLayplan.mnuLayPlansShowWholeLengthClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;

  if (Sender as TMenuItem).Checked then
    SetZoom(Sender, 1);

  MaterialSizeChange(Sender);
  UpdateScreen;
end;

procedure TfmLayplan.KnifeAtActualRotation(Angle: real; No: integer);
var
  RotatedKnife: TPattern;

begin
  if Angle > 180 then
    Angle := Angle - 360
  else if Angle <= -180 then
    Angle := Angle + 360;
  if not(ActualPoints = nil) then
  begin
    RotatedKnife := CreatePattern(ActualPoints, Angle, KerfWidth, True, False);
    MakeBitmap(RotatedKnife, KnifeLoaded and cbGrid.checked or (No = 2), No, False);
  end;
end;

function TfmLayplan.W2sUsed: Boolean;
var
  i: integer;
  W2s: Boolean;

begin
  W2s := False;
  for i := 0 to Length(CutResults) - 1 do
  begin
    if CutResults[i].W2 then
      W2s := True;
  end;

  Result := W2s;
end;

procedure TfmLayplan.PrintOutsTopJaggyEdge;
var
  i, j, k, l: integer;
  Prop: real;
  rm: TFPURoundingMode;

begin
  rm := GetRoundMode;
  setRoundMode(rmUp);

  Prop := (TfrxPictureView(frLayplan.FindObject('picLayplan')).Picture.Bitmap.Width / imgJaggyEdgeTop.Picture.Bitmap.Width);

  for i := 0 to imgJaggyEdgeTop.Picture.Bitmap.Width - 1  do
  begin
    for j := 0 to imgJaggyEdgeTop.Picture.Bitmap.Height - 1 do
    begin
      if imgJaggyEdgeTop.Picture.Bitmap.Canvas.Pixels[i, j] <> clBlack then
      begin
        for k := 0 to Round(Prop) - 1 do
          for l := 0 to Round(Prop) - 1 do
            TfrxPictureView(frLayplan.FindObject('picLayplan')).Picture.Bitmap.Canvas.Pixels[round((i * Prop)) + k, round(j * Prop) + l] := clEditing;
      end;
    end;
  end;

  setRoundMode(rm);
end;

procedure TfmLayplan.PrintOutsLeftJaggyEdge;
var
  i, j, k, l: integer;
  Prop: real;
  rm: TFPURoundingMode;

begin
  rm := GetRoundMode;
  setRoundMode(rmUp);

  Prop := (TfrxPictureView(frLayplan.FindObject('picLayplan')).Picture.Bitmap.Height / imgJaggyEdgeLeft.Picture.Bitmap.Height);

  for i := 0 to imgJaggyEdgeLeft.Picture.Bitmap.Width - 1  do
  begin
    for j := 0 to imgJaggyEdgeLeft.Picture.Bitmap.Height - 1 do
    begin
      if imgJaggyEdgeLeft.Picture.Bitmap.Canvas.Pixels[i, j] <> clBlack then
      begin
        for k := 0 to Round(Prop) - 1 do
          for l := 0 to Round(Prop) - 1 do
            TfrxPictureView(frLayplan.FindObject('picLayplan')).Picture.Bitmap.Canvas.Pixels[round((i * Prop)) + k, round(j * Prop) + l] := clEditing;
      end;
    end;
  end;

  setRoundMode(rm);
end;

procedure TfmLayplan.PrintOutsRightJaggyEdge;
var
  i, j, k, l, xOffset: integer;
  Prop: real;
  rm: TFPURoundingMode;

begin
  rm := GetRoundMode;
  setRoundMode(rmUp);

  Prop := (TfrxPictureView(frLayplan.FindObject('picLayplan')).Picture.Bitmap.Height / imgJaggyEdgeRight.Picture.Bitmap.Height);
  xOffset := TfrxPictureView(frLayplan.FindObject('picLayplan')).Picture.Bitmap.Width - (round(Prop * imgJaggyEdgeRight.Picture.Bitmap.Width));

  for i := 0 to imgJaggyEdgeRight.Picture.Bitmap.Width - 1  do
  begin
    for j := 0 to imgJaggyEdgeRight.Picture.Bitmap.Height - 1 do
    begin
      if imgJaggyEdgeRight.Picture.Bitmap.Canvas.Pixels[i, j] <> clBlack then
      begin
        for k := 0 to Round(Prop) - 1 do
          for l := 0 to Round(Prop) - 1 do
            TfrxPictureView(frLayplan.FindObject('picLayplan')).Picture.Bitmap.Canvas.Pixels[round((i * Prop)) + k + xOffset, round(j * Prop) + l] := clEditing;
      end;
    end;
  end;

  setRoundMode(rm);
end;

procedure TfmLayplan.SetZoom(Sender: TObject; Level: integer);
begin
  Zoom := Level;

  MaterialSizeChange(Sender);
  UpdateScreen;
end;

procedure TfmLayplan.btnPreviewClick(Sender: TObject);
begin
  PreviewThis := not PreviewThis;

  if PreviewThis then
    btnPreview.Caption := 'Preview OFF'
  else
    btnPreview.Caption := 'Preview ON';
end;

procedure TfmLayplan.mnuLayPlansPreviewClick(Sender: TObject);
begin
  mnuLayplansPreview.Checked := not mnuLayplansPreview.Checked;

  UnminimizeLayMain;
end;

procedure TfmLayplan.rgStartingSideClick(Sender: TObject);
begin
  ResultsLeft := (rgStartingSide.ItemIndex = 0);

  pnlLayPlanRulerLeft.Visible := ResultsLeft;
  pnlLayPlanRulerRight.Visible := not ResultsLeft;
//  FormResize(Sender);
  DisplayMaterial(imgLayPlan, True);
end;

procedure TfmLayplan.mnuLayPlansShowRemainingEdgesClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;

  UnminimizeLayMain;
  if LayPlansLoaded then
    sgLayPlansClick(Sender);
end;

procedure TfmLayplan.AddToKnivesUsed(var CurrentKnife: integer);
begin
  inc(CurrentKnife);
  SetLength(KnivesUsed, CurrentKnife);
  KnivesUsed[CurrentKnife - 1, 0].Height := KnifeW1.Height;
  KnivesUsed[CurrentKnife - 1, 0].Width := KnifeW1.Width;
  KnivesUsed[CurrentKnife - 1, 0].PatternPoints := Copy(KnifeW1.PatternPoints);
  KnivesUsed[CurrentKnife - 1, 0].ExpandedPoints := Copy(KnifeW1.ExpandedPoints);
  KnivesUsed[CurrentKnife - 1, 0].ConvexHull := Copy(KnifeW1.ConvexHull);
  KnivesUsed[CurrentKnife - 1, 0].ButtSquare := Copy(KnifeW1.ButtSquare);
  KnivesUsed[CurrentKnife - 1, 0].PatternNettArea := KnifeW1.PatternNettArea;
  KnivesUsed[CurrentKnife - 1, 0].ExpandedNettArea := KnifeW1.ExpandedNettArea;
  KnivesUsed[CurrentKnife - 1, 0].ExpandedGrossArea := KnifeW1.ExpandedGrossArea;
  KnivesUsed[CurrentKnife - 1, 0].W2 := KnifeW1.W2;

  KnivesUsed[CurrentKnife - 1, 1].Height := KnifeW2.Height;
  KnivesUsed[CurrentKnife - 1, 1].Width := KnifeW2.Width;
  KnivesUsed[CurrentKnife - 1, 1].PatternPoints := Copy(KnifeW2.PatternPoints);
  KnivesUsed[CurrentKnife - 1, 1].ExpandedPoints := Copy(KnifeW2.ExpandedPoints);
  KnivesUsed[CurrentKnife - 1, 1].ConvexHull := Copy(KnifeW2.ConvexHull);
  KnivesUsed[CurrentKnife - 1, 1].ButtSquare := Copy(KnifeW2.ButtSquare);
  KnivesUsed[CurrentKnife - 1, 1].PatternNettArea := KnifeW2.PatternNettArea;
  KnivesUsed[CurrentKnife - 1, 1].ExpandedNettArea := KnifeW2.ExpandedNettArea;
  KnivesUsed[CurrentKnife - 1, 1].ExpandedGrossArea := KnifeW2.ExpandedGrossArea;
  KnivesUsed[CurrentKnife - 1, 1].W2 := KnifeW2.W2;
end;

procedure TfmLayplan.mnuLayPlansSortClick(Sender: TObject);
begin
  mnuLayplansSort.Checked := not mnuLayplansSort.Checked;

  UnminimizeLayMain;
  SortResults;
end;

procedure TfmLayplan.mnuLayplansWithoutSelectionClick(Sender: TObject);
begin
  if CanSave or SelectedLayplanChanged then
    CheckAndSaveLayplan;

  fmAllLayplansWithoutSelection.UnitMultiplier := (PATTERNRES / 12000) / SummsToFtMultiplier;
  if fmAllLayplansWithoutSelection.ShowModal = mrOk then
  begin
    LoadKnife(fmAllLayplansWithoutSelection.qLayPlans.FieldByName('KnifeCode').value,
              fmAllLayplansWithoutSelection.qLayPlans.FieldByName('KnifeSizeScale').value,
              fmAllLayplansWithoutSelection.qLayPlans.FieldByName('KnifeSize').value,
              fmAllLayplansWithoutSelection.qLayPlans.FieldByName('KnifeAngle').value);

    pedtMaterialLength.value := (fmAllLayplansWithoutSelection.qLayPlans.FieldByName('MaterialLength').value * PATTERNRES / 12000) / SummsToFtMultiplier;
    pedtMaterialWidth.value := (fmAllLayplansWithoutSelection.qLayPlans.FieldByName('MaterialWidth').value * PATTERNRES / 12000) / SummsToFtMultiplier;
    sedtExpand.Value := fmAllLayplansWithoutSelection.qLayPlans.FieldByName('MaterialCutGap').value;
    sedtEdge.Value := fmAllLayplansWithoutSelection.qLayPlans.FieldByName('MaterialEdge').value;
    if fmAllLayplansWithoutSelection.qLayPlans.FieldByName('MaterialCodeRestrictive').isNull then
      pedtRestrictiveMaterial.Text := ''
    else
      pedtRestrictiveMaterial.Text := fmAllLayplansWithoutSelection.qLayPlans.FieldByName('MaterialCodeRestrictive').value;

    ReadLayplans;
    pcSelectionsResults.Activepage := tsResults;
  end;
end;

procedure TfmLayplan.SortResults;
begin
  if mnuLayplansSort.Checked or (rgNumberOfResults.ItemIndex > 1) then
    SortStringGrid(sgLayplans, 8, False)
  else
    SortStringGrid(sgLayplans, 7, True);
  sgLayPlans.Row := 0;
  sgLayPlansClick(Self);
end;

procedure TfmLayplan.ReadIni;
var
  DisplaySimpleDrawing: integer;
  ShowGrid: Boolean;

begin
  KnifeUnits := SummsLayplanINI.ReadString('Knife', 'KNIFE_UNITS', '');
  KnifePreview := SummsLayplanINI.ReadBool('Knife', 'KNIFE_PREVIEW', True);
  cbUnitsKnife.ItemIndex := FindUnitsIndex(KnifeUnits);
  cbUnitsKnifeChange(Self);
  mnuLayplansShowKnifePreview.Checked := KnifePreview;

  pedtMaterialLength.Value := SummsLayplanINI.ReadFloat('Material', 'MATERIAL_HEIGHT', 100.0);
  pedtMaterialWidth.Value := SummsLayplanINI.ReadFloat('Material', 'MATERIAL_WIDTH', 100.0);

  sedtExpand.value := SummsLayplanINI.ReadInteger('Material', 'MATERIAL_CUTGAP', 0);
  sedtEdge.value := SummsLayplanINI.ReadInteger('Material', 'MATERIAL_SELVEDGE', 0);
  SummsUnits := SummsLayplanINI.ReadString('Material', 'MATERIAL_UNITS', '');
  cbUnitsMaterial.ItemIndex := FindUnitsIndex(SummsUnits);
  cbUnitsMaterialChange(Self);

  mnuLayplansShowCutGaps.checked := SummsLayplanINI.ReadBool('Display', 'DISPLAY_SHOW_KERFS', False);
  mnuLayplansShowWholeLength.checked := SummsLayplanINI.ReadBool('Display', 'DISPLAY_SHOW_WHOLE_LENGTH', False);
  mnuLayplansShowRemainingEdges.checked := SummsLayplanINI.ReadBool('Display', 'DISPLAY_SHOW_REMAINING_EDGES', False);
  mnuLayplansShowBorder.checked := SummsLayplanINI.ReadBool('Display', 'DISPLAY_SHOW_BORDER', False);
  mnuLayPlansShowCount.checked := SummsLayplanINI.ReadBool('Display', 'DISPLAY_SHOW_COUNT', False);
  mnuLayplansPreview.checked := SummsLayplanINI.ReadBool('Display', 'DISPLAY_PREVIEW', True);
  mnuLayplansSort.checked := SummsLayplanINI.ReadBool('Display', 'DISPLAY_SORT', True);
  DisplaySimpleDrawing := SummsLayplanINI.ReadInteger('Display', 'DISPLAY_SIMPLE_DRAWING', 1);
  mnuLayplansSimpleDrawingOff.checked := (DisplaySimpleDrawing = 1);
  mnuLayplansSimpleDrawingPrintoutsOnly.checked := (DisplaySimpleDrawing = 2);
  mnuLayplansSimpleDrawingOn.checked := (DisplaySimpleDrawing = 3);
  SimpleDrawing := (DisplaySimpleDrawing = 3);
  SimpleDrawingPrintoutsOnly := (DisplaySimpleDrawing = 2);

  cbPacksSquareExcluded.checked := SummsLayPlanINI.ReadBool('Excluded Packs', 'PACKS_SQUARE', False);
  cbPacksOffsetExcluded.checked := SummsLayPlanINI.ReadBool('Excluded Packs', 'PACKS_OFFSET', False);
  cbPacksDiagonalExcluded.checked := SummsLayPlanINI.ReadBool('Excluded Packs', 'PACKS_DIAGONAL', False);
  cbPacksDiagonalFreeExcluded.checked := SummsLayPlanINI.ReadBool('Excluded Packs', 'PACKS_DIAGONAL_FREE', False);

  rgShowGangs.ItemIndex := SummsLayplanINI.ReadInteger('Gangs', 'GANGS_SHOW', 1);

  tbCuttingGuide.Position := SummsLayplanINI.ReadInteger('Cutting Guide', 'CUTTING_GUIDE', 11);

  rgAdjustmentsAllowed.ItemIndex := SummsLayplanINI.ReadInteger('Rotations', 'ROTATIONS_ADJUSTMENTS', 1);
  rgRotationalIncrements.ItemIndex := SummsLayplanINI.ReadInteger('Rotations', 'ROTATIONS_INCREMENTS', 1);

  rgAllowInvertion.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_ALLOWINVERTION', 0);
  rgCornerAnchoring.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_CORNER_ANCHORING', 1);
  rgStartingSide.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_STARTING_SIDE', 0);
  rgStartingCriteria.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_STARTING_CRITERIA', 0);
  rgOptimisation.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_OPTIMISATION', 0);
  rgMaxGangs.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_MAXGANGS', 5);
  rgNumberOfResults.ItemIndex := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_NUMBER_OF_RESULTS', 0);
  sedtSelectionsNo.value := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_SELECTIONS_NO', 2);
  sedtSelectionsGrade.value := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_SELECTIONS_GRADE', 5);
  sedtSelectionsPerc.value := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_SELECTIONS_PERC', 100);
  MaximumPatternPoints := SummsLayplanINI.ReadInteger('Options', 'OPTIONS_MAXIMUMPATTERNPOINTS', 100);
  //Crashes if this gets accidently set to 0
  if MaximumPatternPoints <= 0  then
    MaximumPatternpoints := 100;
  CanChangeCutGapFromSATRASumm := SummsLayplanINI.ReadBool('Options', 'OPTIONS_OVERRIDECUTGAP', False);

  //Lastly...
  ShowGrid := SummsLayplanINI.ReadBool('Knife', 'KNIFE_SHOWGRID', False);
  cbGrid.checked := ShowGrid;
end;

procedure TfmLayplan.WriteIni;
var
  DisplaySimpleDrawing: integer;
  ShowGrid: Boolean;

begin
  try
    SummsLayplanINI.WriteString('Knife', 'KNIFE_UNITS', KnifeUnits);
    SummsLayplanINI.WriteBool('Knife', 'KNIFE_PREVIEW', KnifePreview);
    ShowGrid := cbGrid.Checked;
    SummsLayplanINI.WriteBool('Knife', 'KNIFE_SHOWGRID', ShowGrid);

    SummsLayplanINI.WriteFloat('Material', 'MATERIAL_HEIGHT', pedtMaterialLength.value);
    SummsLayplanINI.WriteFloat('Material', 'MATERIAL_WIDTH', pedtMaterialWidth.value);
    SummsLayplanINI.WriteInteger('Material', 'MATERIAL_CUTGAP', sedtExpand.value);
    SummsLayplanINI.WriteInteger('Material', 'MATERIAL_SELVEDGE', sedtEdge.value);
    SummsLayplanINI.WriteString('Material', 'MATERIAL_UNITS', SummsUnits);

    SummsLayplanINI.WriteBool('Display', 'DISPLAY_SHOW_KERFS', mnuLayplansShowCutGaps.checked);
    SummsLayplanINI.WriteBool('Display', 'DISPLAY_SHOW_WHOLE_LENGTH', mnuLayplansShowWholeLength.checked);
    SummsLayplanINI.WriteBool('Display', 'DISPLAY_SHOW_REMAINING_EDGES', mnuLayplansShowRemainingEdges.checked);
    SummsLayplanINI.WriteBool('Display', 'DISPLAY_SHOW_BORDER', mnuLayplansShowBorder.checked);
    SummsLayplanINI.WriteBool('Display', 'DISPLAY_SHOW_COUNT', mnuLayPlansShowCount.checked);
    SummsLayplanINI.WriteBool('Display', 'DISPLAY_PREVIEW', mnuLayplansPreview.checked);
    SummsLayplanINI.WriteBool('Display', 'DISPLAY_SORT', mnuLayplansSort.checked);
    if SimpleDrawing then
      DisplaySimpleDrawing := 3
    else if SimpleDrawingPrintoutsOnly then
      DisplaySimpleDrawing := 2
    else
      DisplaySimpleDrawing := 1;
    SummsLayplanINI.WriteInteger('Display', 'DISPLAY_SIMPLE_DRAWING', DisplaySimpleDrawing);

    SummsLayplanINI.WriteBool('Excluded Packs', 'PACKS_SQUARE', cbPacksSquareExcluded.checked);
    SummsLayplanINI.WriteBool('Excluded Packs', 'PACKS_OFFSET', cbPacksOffsetExcluded.checked);
    SummsLayplanINI.WriteBool('Excluded Packs', 'PACKS_DIAGONAL', cbPacksDiagonalExcluded.checked);
    SummsLayplanINI.WriteBool('Excluded Packs', 'PACKS_DIAGONAL_FREE', cbPacksDiagonalFreeExcluded.checked);

    SummsLayplanINI.WriteInteger('Gangs', 'GANGS_SHOW', rgShowGangs.ItemIndex);

    SummsLayplanINI.WriteInteger('Cutting Guide', 'CUTTING_GUIDE', tbCuttingGuide.Position);

    SummsLayplanINI.WriteInteger('Rotations', 'ROTATIONS_ADJUSTMENTS', rgAdjustmentsAllowed.ItemIndex);
    SummsLayplanINI.WriteInteger('Rotations', 'ROTATIONS_INCREMENTS', rgRotationalIncrements.ItemIndex);

    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_ALLOWINVERTION', rgAllowInvertion.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_CORNER_ANCHORING', rgCornerAnchoring.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_STARTING_SIDE', rgStartingSide.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_STARTING_CRITERIA', rgStartingCriteria.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_OPTIMISATION', rgOptimisation.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_MAXGANGS', rgMaxGangs.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_NUMBER_OF_RESULTS', rgNumberOfResults.ItemIndex);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_SELECTIONS_NO', sedtSelectionsNo.value);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_SELECTIONS_GRADE', sedtSelectionsGrade.value);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_SELECTIONS_PERC', sedtSelectionsPerc.value);
    SummsLayplanINI.WriteInteger('Options', 'OPTIONS_MAXIMUMPATTERNPOINTS', MaximumPatternPoints);
    SummsLayplanINI.WriteBool('Options', 'OPTIONS_OVERRIDECUTGAP', CanChangeCutGapFromSATRASumm);
  except
    on E: Exception do
      fmErrorHandler.DebugMessageDlg('SummsLayplan.ini NOT saved', E.Message, '');
  end;
end;

procedure TfmLayplan.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (not HasClosed) then
  begin
    HasClosed := True;

    fmLayplan.OnResize := nil;

    WriteINI;
    SummsLayplanINI.Free;

  {$IFNDEF STANDALONE}
    fmAllPatterns.Release;
    fmAllLayplans.Release;
    fmAllLayplansWithoutSelection.Release;
    fmAllSyntheticMaterials.Release;
  {$IFDEF DEBUGFULL}
    fmDebugger.Release;
  {$ENDIF}

    //Shouldn't need these but when you open the form again, even though you
    //create a NEW instance of the form, the old one having been destroyed
    //(see below), these variables take their old values because we go to
    //FormResize before FormCreate i.e. before they are initialised. I can only
    //assume that we are just using the same part of memory. If defies logic
    //otherwise as e.g zoom is a variable defined within fmCaller.
    Zoom := 1;
    setlength(ActualPoints, 0);
    setlength(CutResults, 0);
    //Note also that CutResults is shared with BulkAssessKnives so MUST be cleared.

    action := caFree;
  {$ENDIF}
  end;
end;

procedure TfmLayplan.UpdateInitialisation(a, b: real; StartTime: TTime);
begin
  gbCalculating.Caption := 'Preparing packs ' + intToStr(round(a)) + ' of ' + intToStr(round(b));

  //Scroll bar
  a := a / b * 100;
  pbLayplans.Position := round(a);

  lblElapsedTime.Caption := ElapsedTime(Now - StartTime);
  application.processmessages;
end;

procedure TfmLayplan.mnuLayPlansShowCountClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;

  UnminimizeLayMain;
  if LayPlansLoaded then
    sgLayPlansClick(Sender);
end;

procedure TfmLayplan.tbZoomChange(Sender: TObject);
begin
  SetZoom(Sender, tbZoom.Position);
end;

procedure TfmLayplan.mnuLayPlansShowBorderClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;

  UnminimizeLayMain;
  if LayPlansLoaded then
    sgLayPlansClick(Sender);
end;

procedure TfmLayplan.FilterResults(NoPlans, NoAnglesPerPlan: integer);
var
  i, j, k: integer;
  s: string;
  Usek: Boolean;
  Piecesj, Piecesk: integer;
  Anglej, Anglek, Remainj, Remaink, DiffRemain: real;

begin
  for i := 1 to NoAnglesPerPlan - 1 do //Starting at 0 would have compared with self
  begin
    for j := 0 to NoPlans - 1 do
    begin
      k := (i * NoPlans) + j;

      Anglej := strToFloat(sgLayPlans.Cells[1, j]);
      Anglek := strToFloat(sgLayPlans.Cells[1, k]);
      Piecesj := strToInt(sgLayPlans.Cells[4, j]);
      Piecesk := strToInt(sgLayPlans.Cells[4, k]);
      Remainj := strToFloat(sgLayPlans.Cells[5, j]);
      Remaink := strToFloat(sgLayPlans.Cells[5, k]);

      DiffRemain := Remaink - Remainj;
      if abs(DiffRemain) < NegligableRemain then
        DiffRemain := 0;

      Usek := False;

      if Piecesk > Piecesj then
        Usek := True;

      if Piecesk = Piecesj then
      begin
        if (DiffRemain > 0) then
          Usek := True
        else if (DiffRemain = 0) and (abs(Anglek) < abs(Anglej)) then
          Usek := True;
      end;

      if Usek then
      begin
        sgLayPlans.Cells[0, j] := sgLayPlans.Cells[0, k];
        sgLayPlans.Cells[1, j] := sgLayPlans.Cells[1, k];
        sgLayPlans.Cells[2, j] := sgLayPlans.Cells[2, k];
        sgLayPlans.Cells[3, j] := sgLayPlans.Cells[3, k];
        sgLayPlans.Cells[4, j] := sgLayPlans.Cells[4, k];
        sgLayPlans.Cells[5, j] := sgLayPlans.Cells[5, k];
        sgLayPlans.Cells[6, j] := sgLayPlans.Cells[6, k];
        sgLayPlans.Cells[7, j] := sgLayPlans.Cells[7, k];
        sgLayPlans.Cells[8, j] := sgLayPlans.Cells[8, k];
        sgLayPlans.Cells[9, j] := sgLayPlans.Cells[9, k];
      end;

    end;
  end;

  sgLayPlans.RowCount := NoPlans;

  //Adjust Plan nos to keep in order if not sorted
  for i := 0 to NoPlans - 1 do
  begin
    j := strToInt(sgLayPlans.Cells[6, i]);
    k := ((j - 1) mod NoPlans) + 1;
    str(k, s);
    sgLayPlans.Cells[6, i] := s;
  end;
end;

procedure TfmLayplan.sgDebugClick(Sender: TObject);
begin
  sgLayplans.Row := StrToInt(sgDebug.Cells[4, sgDebug.Row]);
  sgLayplansClick(Sender);
end;

procedure TfmLayplan.pcSelectionsResultsChange(Sender: TObject);
begin
  if pcSelectionsResults.TabIndex = 4 then
    sgDebugClick(Sender);
end;

procedure TfmLayplan.mnuLayplansOpenKnifeClick(Sender: TObject);
begin
  sgLayPlans.OnClick := nil;
  OpenKnife;
  sgLayPlans.OnClick := sgLayPlansClick;

  if FromSATRASumm and FromSATRASummSized and LayPlanExists then
    ReadLayplans;
end;

procedure TfmLayplan.UnminimizeLayMain;
begin
  if windowState = wsminimized then
    windowState := wsNormal;
end;

procedure TfmLayplan.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (not Calculating) and (not Saving);

  if (not CanClose) then
    messagedlg('Can not close whilst calculating or saving', mtInformation, [mbOk], 0);

{$IFNDEF STANDALONE}
  if CanClose and (CanSave or SelectedLayplanChanged) and (not fmSumms.ClosingSystem) and (not FromBulkLayplanning) then
    CanClose := (messagedlg('Close without saving?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
{$ENDIF}
end;

procedure TfmLayplan.FormShow(Sender: TObject);
begin
  //Sorts out rulers and imgLayplan at initialisation of form
  FormResize(Sender);
end;

procedure TfmLayplan.frLayplanBeforePrint(Sender: TfrxReportComponent);
begin
  frLayplan.PreviewOptions.AllowEdit := False;
  frLayplan.PreviewOptions.Buttons := frLayplan.PreviewOptions.Buttons - [frxClass.pbEdit, pbOutline, pbFind];

  frLayplan.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frLayplan.PreviewOptions.ZoomMode := zmDefault
  else
    frLayplan.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmLayplan.frLayplanGetValue(const VarName: string;
  var Value: Variant);
var
  s: string;

begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := SystemName + 'Layplan';

  if (VarName = 'Length Title') then
    Value := lblMaterialLength.caption + ' ' + lblUnits4.caption;
  if (VarName = 'Width Title') then
    Value := lblMaterialWidth.caption + ' ' + lblUnits5.caption;
  if (VarName = 'Length') then
    Value := pedtMaterialLength.text;
  if (VarName = 'Width') then
    Value := pedtMaterialWidth.text;
  if (VarName = 'Cut Gap') then
    Value := sedtExpand.text;
  if (VarName = 'Edge') then
    Value := sedtEdge.text;
  if (VarName = 'Restrictive Material') then
    Value := pedtRestrictiveMaterial.text;
  if (VarName = 'Knife Code') then
    Value := KnifeCode;
  if (VarName = 'Knife Size') then
    Value := KnifeSize;
  if (VarName = 'Area Units Title') then
    Value := '(' + lblNettAreaUnits1.Caption + ')';
  if (VarName = 'Area Sub Units Title') then
    Value := '(' + lblNettAreaUnits2.Caption + ')';
  if (VarName = 'Area Units') then
    Value := lblNettArea1.Caption;
  if (VarName = 'Area Sub Units') then
    Value := lblNettArea2.Caption;
  if (VarName = 'Utilisation') then
    Value := sgLayPlans.Cells[3, sgLayPlans.Row];
  if (VarName = 'Pieces') then
    Value := sgLayPlans.Cells[4, sgLayPlans.Row];
  if (VarName = 'Edges') then
    Value := sgLayPlans.Cells[5, sgLayPlans.Row];
  if (VarName = 'Layplan Code') then
    Value := KnifeCode + ' / ' + KnifeSize + ' / ' + lblAdjustmentAngle.Caption + ' / ' + sgLayPlans.Cells[1, sgLayPlans.Row] + ' / ' + sgLayPlans.Cells[9, sgLayPlans.Row];

  if (VarName = 'Description') then
  begin
    if (not IsRoll) then
    begin
      if (Zoom = 1) then
        s := 'Layplan of the whole sheet'
      else
        s := 'Corner of the lay plan';
    end
    else
    begin
      if mnuLayPlansShowWholeLength.Checked then
        s := 'Layplan of the whole length'
      else if (Zoom = 1) then
        s := 'Layplan of the first ' + pedtMaterialWidth.text + ' ' + lblUnits5.caption
      else
        s := 'Corner of the lay plan';
    end;
    Value := s;
  end;
end;

function TfmLayplan.ResultsCutOff(No, Grade, Perc: integer): integer;
var
  Finished: Boolean;
  Complexity: integer;
  Utilisation, BestUtilisation: real;
  NoOfGradeFound: integer;
  i: integer;

begin
  BestUtilisation := strToFloat(sgLayPlans.Cells[3, 0]);

  Finished := False;
  NoOfGradeFound := 0;
  i := 0;
  while (not Finished) and (i < sgLayplans.RowCount) do
  begin
    inc(i);

    Complexity := strToInt(sgLayPlans.Cells[2, i - 1]);
    Utilisation := strToFloat(sgLayPlans.Cells[3, i - 1]);

    if ((BestUtilisation - Utilisation) > Perc) then
    begin
      dec(i);
      Finished := True;
    end
    else
    begin
      if Complexity <= Grade then
        inc(NoOfGradeFound);

      if (NoOfGradeFound >= No) then
        Finished := True;
    end;
  end;

  ResultsCutOff := i;
end;

function TfmLayplan.SATRASummInterface(CallingForm: TForm; Code, Scale, Size, SubUnitDesc, SubUnitAbbrev: string;
  MatLength, MatWidth: Real; Units: string; MatCutGap: integer; RestrictiveMaterialCode: string): Boolean;
var
  LayplanLoaded: Boolean;

begin
  LayplanLoaded := False;
  TheCallingForm := CallingForm;

  cbUnitsMaterial.ItemIndex := FindUnitsIndex(Units);
  cbUnitsMaterialChange(Self);

  if Zoom <> 1 then
    tbZoom.Position := 1;

  PatternInitialise;

  if (Size <> '') and (not tblKnives.FindKey([Code, Scale, Size])) then
  begin
    if not FromBulkLayplanning then
      messagedlg('Knife ' + Code + ', Size ' + Size + ' not found.', mtInformation, [mbOk], 0);
  end
  else
  begin
    pedtMaterialLength.OnChange := nil;
    pedtMaterialWidth.OnChange := nil;
    sedtEdge.OnChange := nil;

    pedtMaterialLength.Value := MatLength;
    pedtMaterialWidth.Value := MatWidth;
    sedtExpand.Value := MatCutGap;
//    sedtEdge.value := 0;
    pedtRestrictiveMaterial.Text := RestrictiveMaterialCode;

    pedtMaterialLength.OnChange := MaterialSizeChange;
    pedtMaterialWidth.OnChange := MaterialSizeChange;
    sedtEdge.OnChange := MaterialSizeChange;

    MaterialSizeChange(Self);

    if Size <> '' then
    begin
      ActualPoints := ReadPattern(tblKnivesCode.Value, tblKnivesSizeScale.Value, tblKnivesMeasuredSize.Value);

      PictureSize := -1;
      AdjustmentAngle := tblKnivesAngle.value;
      MainKnifeInitialise(True, False);

      if Length(ActualPoints) <= 3 then
      begin
        if not FromBulkLayplanning then
          messagedlg('This a manual knife or there are ' + #13 +
                     'not enough points for this knife.', mtInformation, [mbOk], 0);
        KnifeLoaded := False;
        UpdateScreen;
      end;

      KnifeCode := tblKnivesCode.Value;
      KnifeScale := tblKnivesSizeScale.Value;
      KnifeSize := tblKnivesMeasuredSize.Value;
      KnifeArea := Knife.PatternNettArea; //SqFt

      lblKnifeCode.Caption := KnifeCode;
      lblKnifeSize.Caption := KnifeSize;
      cbUnitsKnifeChange(Self);

      LayplanLoaded := False;
      if LayplanExists then
      begin
        ReadLayPlans;
        LayplanLoaded := True;
      end;

      UpdateScreen;
    end;

    FromSATRASumm := True;
    FromSATRASummSized := (Size = '');

    fmAllPatterns.edSearch.enabled := (not FromSATRASummSized);
    fmAllPatterns.cbExact.enabled := (not FromSATRASummSized);

    UpdateScreen;
  end;

  Result := LayplanLoaded;
end;

procedure TfmLayplan.LoadUnitsDropDown;
begin
  cbUnitsKnife.Items.Clear;
  cbUnitsMaterial.Items.Clear;
  qMaterialUnits.open;
  qMaterialUnits.RecNo := 1; //CJY changed from qMaterialUnits.First
  qMaterialUnits.Prior; //CJY changed from qMaterialUnits.First
  while not qMaterialUnits.eof do
  begin
    cbUnitsKnife.Items.Add(qMaterialUnitsCode.value);
    cbUnitsMaterial.Items.Add(qMaterialUnitsCode.value);

    qMaterialUnits.next;
  end;

  cbUnitsKnife.ItemIndex := 0;
  cbUnitsMaterial.ItemIndex := 0;
end;

procedure TfmLayplan.cbUnitsMaterialChange(Sender: TObject);
var
  OldSummsToFtMultiplier: Real;

begin
  //Temporary maximum
  pedtMaterialWidth.MaxValue := 1000;

  qMaterialUnits.findkey([cbUnitsMaterial.Text]);

  OldSummsToFtMultiplier := SummsToFtMultiplier;

  SummsUnits := qMaterialUnitsCode.value;
  SummsToFtMultiplier := qMaterialUnitsToFeet.Value / qMaterialUnitsSubUnitsPerUnit.value;
  SummsToCmMultiplier := SummsToFtMultiplier * 12 * 2.54;

  if OldSummsToFtMultiplier <> 0 then
  begin
    pedtMaterialLength.Value := pedtMaterialLength.Value * OldSummsToFtMultiplier / SummsToFtMultiplier;
    pedtMaterialWidth.Value := pedtMaterialWidth.Value * OldSummsToFtMultiplier / SummsToFtMultiplier;
  end;

  if pedtMaterialWidth.value > (pedtMaterialWidth.MaxValue * 2 / 3) then
    DisplayScale := 0.33333333333333
  else if pedtMaterialWidth.value > (pedtMaterialWidth.MaxValue / 2) then
    DisplayScale := 0.5
  else
    DisplayScale := 1.0;

  pnlUnits2.Caption := qMaterialUnitsSubUnitAbbreviation.value;
  pnlUnits3.Caption := qMaterialUnitsSubUnitAbbreviation.value;
  lblUnits4.Caption := '(' + qMaterialUnitsSubUnitAbbreviation.value + ')';
  lblUnits5.Caption := '(' + qMaterialUnitsSubUnitAbbreviation.value + ')';

  //*3 gives 3 times as much possible width but larger
  //widths will be scaled later by factor of 2 or 3
  if cbUnitsMaterial.Text = 'M' then
    pedtMaterialWidth.MaxValue := 200 * 3
  else
    pedtMaterialWidth.MaxValue := 200 / 2.54 * 3;
end;

function TfmLayplan.FindUnitsIndex(UnitsCode: string): integer;
var
  FoundUnits: Boolean;
  i, IndexToUse: integer;
  s: string;

begin
  FoundUnits := False;

  IndexToUse := -1;
  for i := 0 to cbUnitsMaterial.DropDownCount - 1 do
  begin
    s := cbUnitsMaterial.Items[i];
    if s = UnitsCode then
      IndexToUse := i;
  end;

  FindUnitsIndex := IndexToUse;
end;

procedure TfmLayplan.cbGridClick(Sender: TObject);
begin
  if KnifeLoaded then
    MainKnifeInitialise(True, False);
end;

procedure TfmLayplan.cbUnitsKnifeChange(Sender: TObject);
var
  OldKnifeToFtMultiplier: Real;
  s: string;
  AreaSqUnits, AreaSqSubUnits: Real;

begin
  //Initialise if necesary
  if KnifeToFtMultiplier = 0 then
  begin
    //Initially in cm
    qMaterialUnits.findkey(['M']);
    KnifeToFtMultiplier := qMaterialUnitsToFeet.Value / qMaterialUnitsSubUnitsPerUnit.value;
    KnifeToCmMultiplier := KnifeToFtMultiplier * 12 * 2.54;
  end;

  qMaterialUnits.findkey([cbUnitsKnife.Text]);

  OldKnifeToFtMultiplier := KnifeToFtMultiplier;

  KnifeUnits := qMaterialUnitsCode.value;
  KnifeToFtMultiplier := qMaterialUnitsToFeet.Value / qMaterialUnitsSubUnitsPerUnit.value;
  KnifeToCmMultiplier := KnifeToFtMultiplier * 12 * 2.54;

  rulerKnifeLeft.UnitSize := rulerKnifeLeft.UnitSize * 10 / rulerKnifeLeft.UnitPrice;
  rulerKnifeLeft.UnitSize := rulerKnifeLeft.UnitSize / OldKnifeToFtMultiplier * KnifeToFtMultiplier;
  rulerKnifeLeft.UnitPrice := 10;
  rulerKnifeBottom.UnitSize := rulerKnifeBottom.UnitSize * 10 / rulerKnifeBottom.UnitPrice;
  rulerKnifeBottom.UnitSize := rulerKnifeBottom.UnitSize / OldKnifeToFtMultiplier * KnifeToFtMultiplier;
  rulerKnifeBottom.UnitPrice := 10;

  AdjustRulersScale;

  pnlUnits1.Caption := qMaterialUnitsSubUnitAbbreviation.value;

  lblNettAreaUnits1.caption := ' Sq ' + qMaterialUnitsUnitAbbreviation.value;
  lblNettAreaUnits2.caption := ' Sq ' + qMaterialUnitsSubUnitAbbreviation.value;
  if KnifeCode <> '' then
  begin
    AreaSqUnits := KnifeArea / (qMaterialUnitsToFeet.Value * qMaterialUnitsToFeet.Value);
    AreaSqSubUnits := AreaSqUnits * (qMaterialUnitsSubUnitsPerUnit.Value * qMaterialUnitsSubUnitsPerUnit.Value);
    Str(AreaSqUnits : 6 : 2, s);
    lblNettArea1.caption := s;
    Str(AreaSqSubUnits : 6 : 2, s);
    lblNettArea2.caption := s;
  end;
end;

procedure TfmLayplan.pcSelectionsResultsDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

procedure TfmLayplan.SaveLayplanSet;
var
  SQLString: string;
  i, j, KnifeNo, W2: integer;
  sMaterialLength, sMaterialWidth, sSqFtPerPiece, sCutGap, sEdge, sKnifeAngle, sSeq: string;
  sW2: string;
  sLeft, sTop, sRight, sBottom: string;
  sX, sY: string;
  sStartLeft, sRemHeight, sRemWidth: string;
  sReference1, sReference2: string;
  AlreadyExists, CompleteSave: Boolean;
  sInput_UsableMaterialLength: string;
  sInput_UsableMaterialWidth: string;
  sInput_PatternHeight: string;
  sInput_PatternWidth: string;
  sInput_Square: string;
  sInput_FixedStart: string;
  sInput_StartLeft: string;
  sInput_W2: string;
  sInput_FirstCutInCorner: string;
  sInput_ForceW1First: string;
  sInput_ForceW2First: string;
  sInput_LocalInterlock_Used: string;
  sInput_LocalInterlock_Reversed: string;
  sInput_LocalInterlock_PairedPatternHeight: string;
  sInput_LocalInterlock_PairedPatternWidth: string;
  sInput_LocalInterlock_SinglePatternHeight: string;
  sInput_LocalInterlock_SinglePatternWidth: string;
  sInput_LocalInterlock_Vec1x: string;
  sInput_LocalInterlock_Vec1y: string;
  sInput_LocalInterlock_W2: string;
  sInput_LocalInterlock_Pat1_Left: string;
  sInput_LocalInterlock_Pat1_Top: string;
  sInput_LocalInterlock_Pat1_Right: string;
  sInput_LocalInterlock_Pat1_Bottom: string;
  sInput_LocalInterlock_Pat2_Left: string;
  sInput_LocalInterlock_Pat2_Top: string;
  sInput_LocalInterlock_Pat2_Right: string;
  sInput_LocalInterlock_Pat2_Bottom: string;
  sInput_LocalInterlock_LeftPat: string;
  sInput_LocalInterlock_BottomPat: string;
  sInput_PackAngle: string;
  sPropogationNo: string;
  NoKnivesToSave: integer;
  sKnifeNo: string;
  sToleranceUsed: string;
  LayplanCode, sSelected: string;
  NewKnifeNo: short;
  MatHeightFt, MatWidthFt, MatAreaFt, SqFtPerPiece: Real;
  Pieces: integer;

begin
  SQLString := '';

  //Set Details
  str(MaterialLength, sMaterialLength);
  str(MaterialWidth, sMaterialWidth);
  str(sedtExpand.Value, sCutGap);
  str(sedtEdge.Value, sEdge);
  str(AdjustmentAngle : 5 : 1, sKnifeAngle);
  if pedtRestrictiveMaterial.Text = '' then
  begin
    sReference1 := 'IS NULL';
    sReference2 := 'NULL';
  end
  else
  begin
    sReference1 := '= ''' + QS(pedtRestrictiveMaterial.text) + '''';
    sReference2 := '''' + QS(pedtRestrictiveMaterial.text) + '''';
  end;
  sSelected := intToStr(SelectedLayplan);

  //Clear existing Layplan Set
  SQLString := SQLString + 'DELETE FROM LayplanSets ' +
                           'WHERE (KnifeCode = ''' + QS(KnifeCode) + ''') AND ' +
                           '(KnifeSizeScale = ''' + QS(KnifeScale) + ''') AND ' +
                           '(KnifeSize = ''' + QS(KnifeSize) + ''') AND ' +
                           '(MaterialLength = ' + sMaterialLength + ') AND ' +
                           '(MaterialWidth = ' + sMaterialWidth + ') AND ' +
                           '(MaterialCutGap = ' + sCutGap + ') AND ' +
                           '(MaterialCodeRestrictive ' + sReference1 + ');' + #13;

  //Add new Layplan Set
  SQLString := SQLString + 'INSERT INTO LayplanSets (KnifeCode, ' +
                                                    'KnifeSizeScale, ' +
                                                    'KnifeSize, ' +
                                                    'MaterialLength, ' +
                                                    'MaterialWidth, ' +
                                                    'MaterialCutGap, ' +
                                                    'MaterialCodeRestrictive, ' +
                                                    'MaterialEdge, ' +
                                                    'KnifeAngle, ' +
                                                    'SelectedNo) ' +
                           'VALUES(''' + QS(KnifeCode) + '''' + ', ' +
                                   '''' + QS(KnifeScale) + '''' + ', ' +
                                   '''' + QS(KnifeSize) + '''' + ', ' +
                                   sMaterialLength + ', ' +
                                   sMaterialWidth + ', ' +
                                   sCutGap + ', ' +
                                   sReference2 + ', ' +
                                   sEdge + ', ' +
                                   sKnifeAngle + ', ' +
                                   sSelected + '); ' + #13;

  //Add Knives actually used
  NewKnifeNo := 0;
  for j := 0 to Length(KnivesToSave) - 1 do
  begin
    if KnivesToSave[j].Save then
    begin
      inc(NewKnifeNo);
      KnivesToSave[j].NewNo := NewKnifeNo;

      sKnifeNo := intToStr(NewKnifeNo);

      //Real points
      for W2 := 0 to 1 do
        for i := 0 to Length(KnivesUsed[j, W2].PatternPoints) - 1 do
        begin
          if (W2 = 1) then
            sW2 := 'True'
          else
            sW2 := 'False';
          str(i + 1, sSeq);
          str(KnivesUsed[j, W2].PatternPoints[i].X, sX);
          str(KnivesUsed[j, W2].PatternPoints[i].Y, sY);

          SQLString := SQLString + 'INSERT INTO LayplanSetKnives (KnifeCode, ' +
                                                                 'KnifeSizeScale, ' +
                                                                 'KnifeSize, ' +
                                                                 'MaterialLength, ' +
                                                                 'MaterialWidth, ' +
                                                                 'MaterialCutGap, ' +
                                                                 'MaterialCodeRestrictive, ' +
                                                                 'KnifeNo, ' +
                                                                 'RealNotExpanded, ' +
                                                                 'W2, ' +
                                                                 'Seq, ' +
                                                                 'X, ' +
                                                                 'Y) ' +
                      'VALUES(''' + QS(KnifeCode) + '''' + ', ' +
                              '''' + QS(KnifeScale) + '''' + ', ' +
                              '''' + QS(KnifeSize) + '''' + ', ' +
                              sMaterialLength + ', ' +
                              sMaterialWidth + ', ' +
                              sCutGap + ', ' +
                              sReference2 + ', ' +
                              sKnifeNo + ', ' +
                              'True' + ', ' +
                              sW2 + ', ' +
                              sSeq + ', ' +
                              sX + ', ' +
                              sY + '); ' + #13;
        end;

      //Expanded Points
      for W2 := 0 to 1 do
        for i := 0 to Length(KnivesUsed[j, W2].ExpandedPoints) - 1 do
        begin
          if (W2 = 1) then
            sW2 := 'True'
          else
            sW2 := 'False';
          str(i + 1, sSeq);
          str(KnivesUsed[j, W2].ExpandedPoints[i].X, sX);
          str(KnivesUsed[j, W2].ExpandedPoints[i].Y, sY);

          SQLString := SQLString + 'INSERT INTO LayplanSetKnives (KnifeCode, ' +
                                                                 'KnifeSizeScale, ' +
                                                                 'KnifeSize, ' +
                                                                 'MaterialLength, ' +
                                                                 'MaterialWidth, ' +
                                                                 'MaterialCutGap, ' +
                                                                 'MaterialCodeRestrictive, ' +
                                                                 'KnifeNo, ' +
                                                                 'RealNotExpanded, ' +
                                                                 'W2, ' +
                                                                 'Seq, ' +
                                                                 'X, ' +
                                                                 'Y) ' +
                        'VALUES(''' + QS(KnifeCode) + '''' + ', ' +
                                '''' + QS(KnifeScale) + '''' + ', ' +
                                '''' + QS(KnifeSize) + '''' + ', ' +
                                sMaterialLength + ', ' +
                                sMaterialWidth + ', ' +
                                sCutGap + ', ' +
                                sReference2 + ', ' +
                                sKnifeNo + ', ' +
                                'False' + ', ' +
                                sW2 + ', ' +
                                sSeq + ', ' +
                                sX + ', ' +
                                sY + '); ' + #13;
        end;
    end;
  end;

  //Add Layplans for the Set
  for i := 0 to sgLayPlans.RowCount - 1 do
  begin
    sgLayPlans.Row := i;
//    application.processmessages;

    Pieces := strToInt(sgLayPlans.Cells[4, sgLayPlans.Row]);

    if Pieces <> 0 then
    begin
      MatHeightFt := pedtMaterialLength.value * SummsToFtMultiplier;
      MatWidthFt := pedtMaterialWidth.value * SummsToFtMultiplier;
      MatAreaFt := MatHeightFt * MatWidthFt;

      SqFtPerPiece := MatAreaFt / Pieces;

      //Layplan Details
      LayplanCode := sgLayPlans.Cells[9, sgLayPlans.Row];

      str(SqFtPerPiece : 15 : 10, sSqFtPerPiece);
      if ResultsLeft then
        sStartLeft := 'True'
      else
        sStartLeft := 'False';
      str(ResultsRemHeight, sRemHeight);
      str(ResultsRemWidth, sRemWidth);

      str(PropogationInput.UsableMaterialLength, sInput_UsableMaterialLength);
      str(PropogationInput.UsableMaterialWidth, sInput_UsableMaterialWidth);
      str(PropogationInput.PatternHeight, sInput_PatternHeight);
      str(PropogationInput.PatternWidth, sInput_PatternWidth);
      if PropogationInput.Square then
        sInput_Square := 'True'
      else
        sInput_Square := 'False';
      if PropogationInput.FixedStart then
        sInput_FixedStart := 'True'
      else
        sInput_FixedStart := 'False';
      if PropogationInput.StartLeft then
        sInput_StartLeft := 'True'
      else
        sInput_StartLeft := 'False';
      if PropogationInput.W2 then
        sInput_W2 := 'True'
      else
        sInput_W2 := 'False';
      if PropogationInput.FirstCutInCorner then
        sInput_FirstCutInCorner := 'True'
      else
        sInput_FirstCutInCorner := 'False';
      if PropogationInput.ForceW1First then
        sInput_ForceW1First := 'True'
      else
        sInput_ForceW1First := 'False';
      if PropogationInput.ForceW2First then
        sInput_ForceW2First := 'True'
      else
        sInput_ForceW2First := 'False';
      if PropogationInput.LocalInterlock.Used then
        sInput_LocalInterlock_Used := 'True'
      else
        sInput_LocalInterlock_Used := 'False';
      if PropogationInput.LocalInterlock.Reversed then
        sInput_LocalInterlock_Reversed := 'True'
      else
        sInput_LocalInterlock_Reversed := 'False';
      str(PropogationInput.LocalInterlock.PairedPatternHeight, sInput_LocalInterlock_PairedPatternHeight);
      str(PropogationInput.LocalInterlock.PairedPatternWidth, sInput_LocalInterlock_PairedPatternWidth);
      str(PropogationInput.LocalInterlock.SinglePatternHeight, sInput_LocalInterlock_SinglePatternHeight);
      str(PropogationInput.LocalInterlock.SinglePatternWidth, sInput_LocalInterlock_SinglePatternWidth);
      str(PropogationInput.LocalInterlock.Vec1x, sInput_LocalInterlock_Vec1x);
      str(PropogationInput.LocalInterlock.Vec1y, sInput_LocalInterlock_Vec1y);
      if PropogationInput.LocalInterlock.W2 then
        sInput_LocalInterlock_W2 := 'True'
      else
        sInput_LocalInterlock_W2 := 'False';
      str(PropogationInput.LocalInterlock.Pat1.Left, sInput_LocalInterlock_Pat1_Left);
      str(PropogationInput.LocalInterlock.Pat1.Top, sInput_LocalInterlock_Pat1_Top);
      str(PropogationInput.LocalInterlock.Pat1.Right, sInput_LocalInterlock_Pat1_Right);
      str(PropogationInput.LocalInterlock.Pat1.Bottom, sInput_LocalInterlock_Pat1_Bottom);
      str(PropogationInput.LocalInterlock.Pat2.Left, sInput_LocalInterlock_Pat2_Left);
      str(PropogationInput.LocalInterlock.Pat2.Top, sInput_LocalInterlock_Pat2_Top);
      str(PropogationInput.LocalInterlock.Pat2.Right, sInput_LocalInterlock_Pat2_Right);
      str(PropogationInput.LocalInterlock.Pat2.Bottom, sInput_LocalInterlock_Pat2_Bottom);
      str(PropogationInput.LocalInterlock.LeftPat, sInput_LocalInterlock_LeftPat);
      str(PropogationInput.LocalInterlock.BottomPat, sInput_LocalInterlock_BottomPat);
      str(PropogationInput.PackAngle : 5 : 1, sInput_PackAngle);
      str(PropogationNo, sPropogationNo);
      str(InterlockingToleranceLayplans, sToleranceUsed);
      str(KnivesToSave[CutResults[0].KnifeNo - 1].NewNo, sKnifeNo);

      //Plan
      sSeq := intToStr(i);
      SQLString := SQLString + 'INSERT INTO LayplanPlans (KnifeCode, ' +
                                                         'KnifeSizeScale, ' +
                                                         'KnifeSize, ' +
                                                         'MaterialLength, ' +
                                                         'MaterialWidth, ' +
                                                         'MaterialCutGap, ' +
                                                         'MaterialCodeRestrictive, ' +
                                                         'LayplanCode, ' +
                                                         'Seq, ' +
                                                         'SqFtPerPiece, ' +
                                                         'StartLeft, ' +
                                                         'RemHeight, ' +
                                                         'RemWidth, ' +
                                                         'Details2, ' +
                                                         'Details3, ' +
                                                         'Details4, ' +
                                                         'Details5, ' +
                                                         'Details6, ' +
                                                         'ToleranceUsed, ' +
                                                         'Input_UsableMaterialLength, ' +
                                                         'Input_UsableMaterialWidth, ' +
                                                         'Input_PatternHeight, ' +
                                                         'Input_PatternWidth, ' +
                                                         'Input_Square, ' +
                                                         'Input_FixedStart, ' +
                                                         'Input_StartLeft, ' +
                                                         'Input_W2, ' +
                                                         'Input_FirstCutInCorner, ' +
                                                         'Input_ForceW1First, ' +
                                                         'Input_ForceW2First, ' +
                                                         'Input_LocalInterlock_Used, ' +
                                                         'Input_LocalInterlock_Reversed, ' +
                                                         'Input_LocalInterlock_PairedPatternHeight, ' +
                                                         'Input_LocalInterlock_PairedPatternWidth, ' +
                                                         'Input_LocalInterlock_SinglePatternHeight, ' +
                                                         'Input_LocalInterlock_SinglePatternWidth, ' +
                                                         'Input_LocalInterlock_Vec1x, ' +
                                                         'Input_LocalInterlock_Vec1y, ' +
                                                         'Input_LocalInterlock_W2, ' +
                                                         'Input_LocalInterlock_Pat1_Left, ' +
                                                         'Input_LocalInterlock_Pat1_Top, ' +
                                                         'Input_LocalInterlock_Pat1_Right, ' +
                                                         'Input_LocalInterlock_Pat1_Bottom, ' +
                                                         'Input_LocalInterlock_Pat2_Left, ' +
                                                         'Input_LocalInterlock_Pat2_Top, ' +
                                                         'Input_LocalInterlock_Pat2_Right, ' +
                                                         'Input_LocalInterlock_Pat2_Bottom, ' +
                                                         'Input_LocalInterlock_LeftPat, ' +
                                                         'Input_LocalInterlock_BottomPat, ' +
                                                         'Input_PackAngle, ' +
                                                         'PropogationNo, ' +
                                                         'KnifeNo) ' +

                  'VALUES(''' + QS(KnifeCode) + '''' + ', ' +
                          '''' + QS(KnifeScale) + '''' + ', ' +
                          '''' + QS(KnifeSize) + '''' + ', ' +
                          sMaterialLength + ', ' +
                          sMaterialWidth + ', ' +
                          sCutGap + ', ' +
                          sReference2 + ', ' +
                          '''' + LayplanCode + '''' + ', ' +
                          sSeq + ', ' +
                          sSqFtPerPiece + ', ' +
                          sStartLeft + ', ' +
                          sRemHeight + ', ' +
                          sRemWidth + ', ' +
                          '''' + sgLayPlans.Cells[1, sgLayPlans.Row] + '''' + ', ' +
                          '''' + sgLayPlans.Cells[2, sgLayPlans.Row] + '''' + ', ' +
                          '''' + sgLayPlans.Cells[3, sgLayPlans.Row] + '''' + ', ' +
                          '''' + sgLayPlans.Cells[4, sgLayPlans.Row] + '''' + ', ' +
                          '''' + sgLayPlans.Cells[5, sgLayPlans.Row] + '''' + ', ' +
                          sToleranceUsed + ', ' +
                          sInput_UsableMaterialLength + ', ' +
                          sInput_UsableMaterialWidth + ', ' +
                          sInput_PatternHeight + ', ' +
                          sInput_PatternWidth + ', ' +
                          sInput_Square + ', ' +
                          sInput_FixedStart + ', ' +
                          sInput_StartLeft + ', ' +
                          sInput_W2 + ', ' +
                          sInput_FirstCutInCorner + ', ' +
                          sInput_ForceW1First + ', ' +
                          sInput_ForceW2First + ', ' +
                          sInput_LocalInterlock_Used + ', ' +
                          sInput_LocalInterlock_Reversed + ', ' +
                          sInput_LocalInterlock_PairedPatternHeight + ', ' +
                          sInput_LocalInterlock_PairedPatternWidth + ', ' +
                          sInput_LocalInterlock_SinglePatternHeight + ', ' +
                          sInput_LocalInterlock_SinglePatternWidth + ', ' +
                          sInput_LocalInterlock_Vec1x + ', ' +
                          sInput_LocalInterlock_Vec1y + ', ' +
                          sInput_LocalInterlock_W2 + ', ' +
                          sInput_LocalInterlock_Pat1_Left + ', ' +
                          sInput_LocalInterlock_Pat1_Top + ', ' +
                          sInput_LocalInterlock_Pat1_Right + ', ' +
                          sInput_LocalInterlock_Pat1_Bottom + ', ' +
                          sInput_LocalInterlock_Pat2_Left + ', ' +
                          sInput_LocalInterlock_Pat2_Top + ', ' +
                          sInput_LocalInterlock_Pat2_Right + ', ' +
                          sInput_LocalInterlock_Pat2_Bottom + ', ' +
                          sInput_LocalInterlock_LeftPat + ', ' +
                          sInput_LocalInterlock_BottomPat + ', ' +
                          sInput_PackAngle + ', ' +
                          sPropogationNo + ', ' +
                          sKnifeNo + '); ' + #13;

      //Pack
      for j := 0 to Length(PackResults) - 1 do
      begin
        str(j, sSeq);
        if PackResults[j].W2 then
          sW2 := 'True'
        else
          sW2 := 'False';
        str(PackResults[j].BoundingRect.Left, sLeft);
        str(PackResults[j].BoundingRect.Top, sTop);
        str(PackResults[j].BoundingRect.Right, sRight);
        str(PackResults[j].BoundingRect.Bottom, sBottom);

        SQLString := SQLString + 'INSERT INTO LayplanPlanPacks (KnifeCode, ' +
                                                               'KnifeSizeScale, ' +
                                                               'KnifeSize, ' +
                                                               'MaterialLength, ' +
                                                               'MaterialWidth, ' +
                                                               'MaterialCutGap, ' +
                                                               'MaterialCodeRestrictive, ' +
                                                               'LayplanCode, ' +
                                                               'Seq, ' +
                                                               'W2, ' +
                                                               'BR_Left, ' +
                                                               'BR_Top, ' +
                                                               'BR_Right, ' +
                                                               'BR_Bottom) ' +
                    'VALUES(''' + QS(KnifeCode) + '''' + ', ' +
                            '''' + QS(KnifeScale) + '''' + ', ' +
                            '''' + QS(KnifeSize) + '''' + ', ' +
                            sMaterialLength + ', ' +
                            sMaterialWidth + ', ' +
                            sCutGap + ', ' +
                            sReference2 + ', ' +
                            '''' + LayplanCode + '''' + ', ' +
                            sSeq + ', ' +
                            sW2 + ', ' +
                            sLeft + ', ' +
                            sTop + ', ' +
                            sRight + ', ' +
                            sBottom + '); ' + #13;
      end;
    end;
  end;

  //Run the query
  CompleteSave := True;
  qSaveLayplan.SQL.Text := SQLString;
  LocalConnectionSumms.StartTransaction;
  try
    qSaveLayplan.ExecSQL;
  except
    on E: Exception do
    begin
      if (Pos('Error 7200', E.Message) > 0) and (Pos('Error 7076', E.Message) > 0) and (Pos('MATERIALCODERESTRICTIVE', E.Message) > 0) then
        fmErrorHandler.DebugMessageDlg('Layplan NOT saved. Material Code cannot be found', E.Message, qSaveLayplan.Text)
      else if (Pos('Error 7200', E.Message) > 0) and (Pos('Error 7087', E.Message) > 0) then
        fmErrorHandler.DebugMessageDlg('Permission denied. Layplan NOT saved.', E.Message, qSaveLayplan.Text)
      else
        fmErrorHandler.DebugMessageDlg('Unexpected Error. Layplan NOT saved.', E.Message, qSaveLayplan.Text);

      CompleteSave := False;
    end;
  end;

  if CompleteSave then
  begin
    LocalConnectionSumms.commit;
    ResultsCaption := '';
  end
  else
    LocalConnectionSumms.Rollback;
end;

procedure TfmLayplan.DeleteLayplanSet;
begin
  qDeleteLayplan.ParamByName('KnifeCode').value := KnifeCode;
  qDeleteLayplan.ParamByName('KnifeSizeScale').value := KnifeScale;
  qDeleteLayplan.ParamByName('KnifeSize').value := KnifeSize;
  qDeleteLayplan.ParamByName('MaterialLength').value := MaterialLength;
  qDeleteLayplan.ParamByName('MaterialWidth').value := MaterialWidth;
  qDeleteLayplan.ParamByName('MaterialCutGap').value := sedtExpand.Value;
  if pedtRestrictiveMaterial.Text = '' then
    qDeleteLayPlan.ParamByName('MaterialCodeRestrictive').value := NULL
  else
    qDeleteLayPlan.ParamByName('MaterialCodeRestrictive').value := pedtRestrictiveMaterial.Text;

  LocalConnectionSumms.StartTransaction;
  try
    qDeleteLayplan.ExecSQL;
    LocalConnectionSumms.commit;
  except
    LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmLayplan.btnAllLayplansClick(Sender: TObject);
begin
  mnuLayplansOpenLayplanClick(Sender);
end;

procedure TfmLayplan.mnuLayplansOpenLayplanClick(Sender: TObject);
begin
  if CanSave or SelectedLayplanChanged then
    CheckAndSaveLayplan;

  fmAllLayplans.UnitMultiplier := (PATTERNRES / 12000) / SummsToFtMultiplier;
  if fmAllLayplans.ShowModal = mrOk then
  begin
    AdjustmentAngle := fmAllLayplans.qLayPlans.FieldByName('KnifeAngle').value;
    sedtEdge.Value := fmAllLayplans.qLayPlans.FieldByName('MaterialEdge').value;
    MainKnifeInitialise(True, False);

    pedtMaterialLength.value := (fmAllLayplans.qLayPlans.FieldByName('MaterialLength').value * PATTERNRES / 12000) / SummsToFtMultiplier;
    pedtMaterialWidth.value := (fmAllLayplans.qLayPlans.FieldByName('MaterialWidth').value * PATTERNRES / 12000) / SummsToFtMultiplier;
    sedtExpand.Value := fmAllLayplans.qLayPlans.FieldByName('MaterialCutGap').value;
    if fmAllLayplans.qLayPlans.FieldByName('MaterialCodeRestrictive').isNull then
      pedtRestrictiveMaterial.Text := ''
    else
      pedtRestrictiveMaterial.Text := fmAllLayplans.qLayPlans.FieldByName('MaterialCodeRestrictive').value;

    ReadLayplans;
    pcSelectionsResults.Activepage := tsResults;
  end;
end;

procedure TfmLayplan.btnSaveLayplansClick(Sender: TObject);
begin
  CheckAndSaveLayplan;
end;

procedure TfmLayplan.mnuLayplansSaveClick(Sender: TObject);
begin
  CheckAndSaveLayplan;
end;

procedure TfmLayplan.btnDeleteLayplansClick(Sender: TObject);
begin
  mnuLayplansDeleteClick(Sender);
end;

procedure TfmLayplan.btnLayplansWithoutSelectionClick(Sender: TObject);
begin
  mnuLayplansWithoutSelectionClick(Sender);
end;

procedure TfmLayplan.mnuLayplansDeleteClick(Sender: TObject);
begin
  if messagedlg('Delete saved Layplan Set?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DeleteLayplanSet;
    ClearLayplans;
  end;
end;

procedure TfmLayplan.PrintLayplan(PreviewThis, ShowProgress: Boolean);
var
  Angle: real;
  rMaterialLength, rMaterialWidth: real;

begin
  frLayplan.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);


  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  if SimpleDrawingPrintoutsOnly then
  begin
    SimpleDrawing := True;
    RedrawBMPs;
  end;

  if PreviewThis then
    pnlPrintPreviewOpen.Visible := True;

  TfrxMemoView(frLayplan.FindObject('mExplanation')).Visible := pnlExplanation.Visible;
  TfrxMemoView(frLayplan.FindObject('mPiecesStar')).Visible := pnlExplanation.Visible;

  TfrxPictureView(frLayplan.FindObject('picKnifeW1')).Left := 272;
  TfrxPictureView(frLayplan.FindObject('picKnifeW2')).Left := 497;
  TfrxPictureView(frLayplan.FindObject('picKnifeW2')).Visible := True;

  Angle := strToFloat(lblAdjustmentAngle.Caption) + strToFloat(sgLayPlans.Cells[1, sgLayPlans.Row]);
  KnifeAtActualRotation(Angle, 2);

  TfrxPictureView(frLayplan.FindObject('picKnifeW1')).Picture := imgRotatedKnife.Picture;

  if W2sUsed then
  begin
    Angle := Angle + 180;
    KnifeAtActualRotation(Angle, 2);
    TfrxPictureView(frLayplan.FindObject('picKnifeW2')).Picture := imgRotatedKnife.Picture;
  end
  else
  begin
    TfrxPictureView(frLayplan.FindObject('picKnifeW1')).Left := 498;
    TfrxPictureView(frLayplan.FindObject('picKnifeW2')).Visible := False;
  end;

  rMaterialLength := MaterialLength;
  rMaterialWidth := MaterialWidth;

  TfrxPictureView(frLayplan.FindObject('picLayplan')).Height := 620;
  TfrxPictureView(frLayplan.FindObject('picLayplan')).Width := 620;

  if MaterialLength < MaterialWidth then
    TfrxPictureView(frLayplan.FindObject('picLayplan')).Height := round(TfrxPictureView(frLayplan.FindObject('picLayplan')).Height * rMaterialLength / rMaterialWidth)
  else if (MaterialWidth < MaterialLength) and (not IsRoll) then
    TfrxPictureView(frLayplan.FindObject('picLayplan')).Width := round(TfrxPictureView(frLayplan.FindObject('picLayplan')).Width * rMaterialWidth / rMaterialLength)
  else if IsRoll and mnuLayPlansShowWholeLength.Checked then
    TfrxPictureView(frLayplan.FindObject('picLayplan')).Width := round(TfrxPictureView(frLayplan.FindObject('picLayplan')).Width * rMaterialWidth / rMaterialLength);

  TfrxPictureView(frLayplan.FindObject('picLayplan')).Picture := imgLayPlan.Picture;
  if imgJaggyEdgeTop.visible then
    PrintoutsTopJaggyEdge;
  if imgJaggyEdgeLeft.visible then
    PrintoutsLeftJaggyEdge;
  if imgJaggyEdgeRight.visible then
    PrintoutsRightJaggyEdge;

  try
  begin
    frLayplan.PrintOptions.PrintMode := pmScale;
    frLayplan.PrintOptions.PrintOnSheet := GetPaperSize;
    frLayplan.PrepareReport;
    if PreviewThis then
      frLayplan.ShowPreparedReport
    else
      frLayplan.Print;
  end
  except
{$IFNDEF STANDALONE}
    fmMemoryError.showError(self);
{$ENDIF}
  end;

  if PreviewThis then
  begin
    pnlPrintPreviewOpen.Visible := False;
    if ForceRedraw then
      FormResize(self);
  end;

  if SimpleDrawingPrintoutsOnly then
  begin
    SimpleDrawing := False;
    RedrawBMPs;
  end;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmLayplan.mnuLayplansPrintPreviewClick(Sender: TObject);
begin
  PrintLayplan(True, True);
end;

procedure TfmLayplan.mnuLayplansPrintClick(Sender: TObject);
begin
  PrintLayplan(False, True);
end;

procedure TfmLayplan.btnPrintPreviewClick(Sender: TObject);
begin
  PrintLayplan(True, True);
end;

procedure TfmLayplan.btnPrintClick(Sender: TObject);
begin
  PrintLayplan(False, True);
end;

procedure TfmLayplan.mnuLayplansOpenMaterialClick(Sender: TObject);
begin
  if fmAllSyntheticMaterials.ShowModal = mrOk then
  begin
    cbUnitsMaterial.ItemIndex := FindUnitsIndex(fmAllSyntheticMaterials.qMaterials.FieldByName('Units').value);
    cbUnitsMaterialChange(Self);

    if fmAllSyntheticMaterials.qMaterials.FieldByName('Type').Value <> 'R' then
      pedtMaterialLength.value := fmAllSyntheticMaterials.qMaterials.FieldByName('Length').value
    else
      SetAsRoll;

    pedtMaterialWidth.value := fmAllSyntheticMaterials.qMaterials.FieldByName('Width').value;
    sedtExpand.Value := fmAllSyntheticMaterials.qMaterials.FieldByName('CutGap').value;
//    sedtEdge.Value := 0;
    if fmAllSyntheticMaterials.qMaterials.FieldByName('CutType').Value <> 'R' then
      pedtRestrictiveMaterial.Text := ''
    else
      pedtRestrictiveMaterial.Text := fmAllSyntheticMaterials.qMaterials.FieldByName('Code').value;
  end;
end;

procedure TfmLayplan.btnAllMaterialsClick(Sender: TObject);
begin
  mnuLayplansOpenMaterialClick(Sender);
end;

procedure TfmLayplan.btnRollClick(Sender: TObject);
begin
  SetAsRoll;
end;

procedure TfmLayplan.SetAsRoll;
begin
  qMaterialUnits.findkey([cbUnitsMaterial.Text]);

  SummsUnits := qMaterialUnitsCode.value;
  SummsToFtMultiplier := qMaterialUnitsToFeet.Value / qMaterialUnitsSubUnitsPerUnit.value;
  SummsToCmMultiplier := SummsToFtMultiplier * 12 * 2.54;

  pedtMaterialLength.Value := ROLLLENGTH_FT / SummsToFtMultiplier;
end;

procedure TfmLayplan.LocalConnectionSummsBeforeConnect(Sender: TObject);
begin
{$IFNDEF STANDALONE}
  ConnectionSettings(Sender);
{$ENDIF}
{$IFDEF STANDALONE}
  LocalConnectionSumms.Username := 'AdsSys';
  LocalConnectionSumms.Password := MasterPassword;
{$ENDIF}
end;

procedure TfmLayplan.btnViewClick(Sender: TObject);
begin
  mnuLayPlansShowWholeLength.click;
end;

procedure TfmLayplan.Bulk1Click(Sender: TObject);
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

procedure TfmLayplan.mnuLayplansShowKnifePreviewClick(Sender: TObject);
begin
  KnifePreview := not KnifePreview;
  mnuLayplansShowKnifePreview.Checked := KnifePreview;
end;

procedure TfmLayplan.tbCuttingGuideChange(Sender: TObject);
begin
  lblCuttingGuide.caption := intToStr(tbCuttingGuide.Position);
end;

procedure TfmLayplan.SortStringGrid(var TheStringGrid: TStringGrid; SortCol: Integer; Ascending: Boolean);
const
  Separator = '@';

var
  NoRows, FixedRows, RowIndex, i, j, k: integer;
  MyList: TStringList;
  s, s1: string;

begin
  NoRows := TheStringGrid.RowCount;
  FixedRows := TheStringGrid.FixedRows;
  MyList := TStringList.Create;
  MyList.Sorted := False;
  try
    begin
      for i := FixedRows to (NoRows - 1) do
        MyList.Add(TheStringGrid.Rows[i].Strings[SortCol] + Separator +
          TheStringGrid.Rows[i].Text);
      Mylist.Sort;
      for k := 1 to Mylist.Count do
      begin
        s := MyList.Strings[(k - 1)];
        s1  := '';
        //Eliminate the Text of the column on which we have sorted the StringGrid
        s1 := Copy(s, (Pos(Separator, s) + 1), Length(s));
        MyList.Strings[(k - 1)] := '';
        MyList.Strings[(k - 1)] := s1;
      end;

      for j := FixedRows to (NoRows - 1) do
      begin
        if Ascending then
          RowIndex := j
        else
          RowIndex := NoRows - j - 1;

        TheStringGrid.Rows[RowIndex].Text := MyList.Strings[(j - FixedRows)];
      end;
    end;
  finally
    MyList.Free;
  end;
end;

procedure TfmLayplan.sgLayPlansDblClick(Sender: TObject);
begin
  if SelectedLayplan = sgLayplans.Row then
  begin
    SelectedLayplan := -1;
    lblSelectedLayplan.Caption := '<None>';
  end
  else
  begin
    SelectedLayplan := sgLayplans.Row;
    lblSelectedLayplan.Caption := sgLayplans.Cells[0, sgLayplans.Row];
  end;

  SelectedLayplanChanged := True;
  UpdateScreen;

  sgLayplans.Refresh;
end;

procedure TfmLayplan.sgLayPlansDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  sCad: string;
  i: integer;

begin
  //Selected Layplan colour
  if ARow = SelectedLayplan then
    sgLayPlans.Canvas.Font.color := clRed;

  if (sgLayplans.Cells[ACol, ARow] <> '') then
  begin
    sCad := sgLayplans.Cells[ACol, ARow];

    with sgLayplans.Canvas, Rect do
    begin
      if ACol = 0 then
        i := 3
      else
        i := Right - TextWidth(sCad + ' ');
      sgLayplans.Canvas.FillRect(Rect);
      sgLayplans.Canvas.TextOut(i, Top + 2, sCad);
    end;
  end;
end;

procedure TfmLayplan.shpWheelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  HoldWheel := True;
  lblWheelHelp1.visible := True;
  lblWheelHelp2.visible := True;
  lblWheelHelp3.visible := True;
  screen.Cursor := crHandPoint;
end;

procedure TfmLayplan.shpWheelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  q, h2, w2: integer;
  adj: real;
  HandleAdj: integer;
  ClockWise: Boolean;

begin
  if HoldWheel then
  begin
    //Quarters
    //  4  1
    //  3  2
    h2 := shpWheel.Height div 2;
    w2 := shpWheel.Width div 2;
    if (X >= w2) and (Y < h2) then
      q := 1
    else if (X >= w2) and (Y >= h2) then
      q := 2
    else if (X < w2) and (Y >= h2) then
      q := 3
    else if (X < w2) and (Y < h2) then
      q := 4
    else
      q := 0;

    //If off the shape area then ignore
    if (X < 0) or (X > w2 * 2) or (Y < 0) or (Y > h2 * 2) then
      q := 0;

    //Check keys
    if ssCtrl in Shift then
    begin
      adj := 10;
      HandleAdj := 25;
    end
    else if ssAlt in Shift then
    begin
      adj := 0.1;
      HandleAdj := 5;
    end
    else
    begin
      adj := 1;
      HandleAdj := 15;
    end;

    //Movement
    if (q = 1) then
    begin
      if (X > LastWheelX) and (Y > LastWheelY) then
        ClockWise := True
      else if (X < LastWheelX) and (Y < LastWheelY) then
        ClockWise := False
      else
        q := 0;
    end
    else if (q = 2) then
    begin
      if (X < LastWheelX) and (Y > LastWheelY) then
        ClockWise := True
      else if (X > LastWheelX) and (Y < LastWheelY) then
        ClockWise := False
      else
        q := 0;
    end
    else if (q = 3) then
    begin
      if (X < LastWheelX) and (Y < LastWheelY) then
        ClockWise := True
      else if (X > LastWheelX) and (Y > LastWheelY) then
        ClockWise := False
      else
        q := 0;
    end
    else if (q = 4) then
    begin
      if (X > LastWheelX) and (Y < LastWheelY) then
        ClockWise := True
      else if (X < LastWheelX) and (Y > LastWheelY) then
        ClockWise := False
      else
        q := 0;
    end;

    //Adjust
    if q <> 0 then
    begin
      if ClockWise then
      begin
        AdjustmentAngle := AdjustmentAngle + adj;
        HandleAngle := HandleAngle + HandleAdj;
      end
      else
      begin
        AdjustmentAngle := AdjustmentAngle - adj;
        HandleAngle := HandleAngle - HandleAdj;
      end;

      //Correct AdjustmentAngle
      while AdjustmentAngle >= 360 do
        AdjustmentAngle := AdjustmentAngle - 360;
      while AdjustmentAngle < 0 do
        AdjustmentAngle := AdjustmentAngle + 360;

      MainKnifeInitialise(False, True);
    end;

    AngleHandle(HandleAngle);

    LastWheelX := X;
    LastWheelY := Y;
  end;
end;

procedure TfmLayplan.shpWheelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  HoldWheel := False;
  lblWheelHelp1.visible := False;
  lblWheelHelp2.visible := False;
  lblWheelHelp3.visible := False;
  MainKnifeInitialise(True, False);

  screen.Cursor := crDefault;
end;

function TfmLayplan.LayplanExists: Boolean;
var
  sMaterialLength, sMaterialWidth, sCutGap, sReference1, SQLString: string;
  Exists: Boolean;

begin
  str(MaterialLength, sMaterialLength);
  str(MaterialWidth, sMaterialWidth);
  str(sedtExpand.Value, sCutGap);

  if pedtRestrictiveMaterial.Text = '' then
    sReference1 := 'IS NULL'
  else
    sReference1 := '= ''' + QS(pedtRestrictiveMaterial.text) + '''';

  //Check if already exists
  SQLString := '';
  SQLString := SQLString + 'SELECT * FROM LayplanSets ' +
                           'WHERE (KnifeCode = ''' + QS(KnifeCode) + ''') AND ' +
                           '(KnifeSizeScale = ''' + QS(KnifeScale) + ''') AND ' +
                           '(KnifeSize = ''' + QS(KnifeSize) + ''') AND ' +
                           '(MaterialLength = ' + sMaterialLength + ') AND ' +
                           '(MaterialWidth = ' + sMaterialWidth + ') AND ' +
                           '(MaterialCutGap = ' + sCutGap + ') AND ' +
                           '(MaterialCodeRestrictive ' + sReference1 + ')' + #13;
  qSaveLayplan.SQL.Text := SQLString;
  qSaveLayplan.open;
  //CJY qSaveLayPlan.FetchOptions.RecordCountMode set to cmTotal
  Exists := (qSaveLayPlan.RecordCount >= 1);
  qSaveLayplan.close;

  LayplanExists := Exists;
end;

procedure TfmLayplan.RedrawBMPs;
begin
  UnminimizeLayMain;
  KnifeAtActualRotation(AdjustmentAngle, 1);
  DisplayMaterial(imgLayPlan, not LayplansLoaded);
  if LayPlansLoaded then
    sgLayPlansClick(Self);
end;

procedure TfmLayplan.AngleHandle(HandleAngle: real);
var
  SmallWheelX, SmallWheelY: integer;
  AngleRadians: real;

begin
  AngleRadians := (90 - HandleAngle) *  Pi / 180;
  SmallWheelX := round(35 * Cos(AngleRadians));
  SmallWheelY := round(35 * Sin(AngleRadians));

  SmallWheelX := SmallWheelX + shpWheel.Left + (shpWheel.Width div 2) - (shpWheelHandle.Width div 2);
  SmallWheelY := - SmallWheelY + shpWheel.Top + (shpWheel.Height div 2) - (shpWheelHandle.Height div 2);

  shpWheelHandle.left := SmallWheelX;
  shpWheelHandle.top := SmallWheelY;
end;

procedure TfmLayplan.AngleHand;
var
  SmallWheelX, SmallWheelY: integer;
  AngleRadians: real;
  i: integer;

begin
  i := 0;
  while i <= 25 do
  begin
    AngleRadians := (90 - AdjustmentAngle) *  Pi / 180;
    SmallWheelX := round(i * Cos(AngleRadians));
    SmallWheelY := - round(i * Sin(AngleRadians));

    SmallWheelX := SmallWheelX + shpWheel.Left + (shpWheel.Width div 2);
    SmallWheelY := SmallWheelY + shpWheel.Top + (shpWheel.Height div 2);

    case i of
      0: begin
           shpActualAngle0.left := SmallWheelX - (shpActualAngle0.Width div 2);
           shpActualAngle0.top := SmallWheelY - (shpActualAngle0.Height div 2);
         end;
      5: begin
           shpActualAngle5.left := SmallWheelX - (shpActualAngle5.Width div 2);
           shpActualAngle5.top := SmallWheelY - (shpActualAngle5.Height div 2);
         end;
      10: begin
           shpActualAngle10.left := SmallWheelX - (shpActualAngle10.Width div 2);
           shpActualAngle10.top := SmallWheelY - (shpActualAngle10.Height div 2);
         end;
      15: begin
           shpActualAngle15.left := SmallWheelX - (shpActualAngle15.Width div 2);
           shpActualAngle15.top := SmallWheelY - (shpActualAngle15.Height div 2);
         end;
      20: begin
           shpActualAngle20.left := SmallWheelX - (shpActualAngle20.Width div 2);
           shpActualAngle20.top := SmallWheelY - (shpActualAngle20.Height div 2);
         end;
      25: begin
           shpActualAngle25.left := SmallWheelX - (shpActualAngle25.Width div 2);
           shpActualAngle25.top := SmallWheelY - (shpActualAngle25.Height div 2);
         end;
    end;

    i := i + 5;
  end;
end;

procedure TfmLayplan.ReadLayplans;
var
  i, j: integer;
  NoKnivesToLoad: integer;
  PlanNo: short;
  LayplanCode, LayplanCodeNoOnly: string;

begin
  ClearLayplans;

  //Initialise
  sgLayPlans.RowCount := 1;
  CurrentKnife := 1;
  SetLength(KnivesUsed, 0);

  //Layplan Set
  qReadLayplanSets.ParamByName('KnifeCode').value := KnifeCode;
  qReadLayplanSets.ParamByName('KnifeSizeScale').value := KnifeScale;
  qReadLayplanSets.ParamByName('KnifeSize').value := KnifeSize;
  qReadLayplanSets.ParamByName('MaterialLength').value := MaterialLength;
  qReadLayplanSets.ParamByName('MaterialWidth').value := MaterialWidth;
  qReadLayplanSets.ParamByName('MaterialCutGap').value := sedtExpand.Value;
  if pedtRestrictiveMaterial.Text = '' then
    qReadLayplanSets.ParamByName('MaterialCodeRestrictive').value := NULL
  else
    qReadLayplanSets.ParamByName('MaterialCodeRestrictive').value := pedtRestrictiveMaterial.Text;
  qReadLayplanSets.Open;

  sedtEdge.Value := qReadLayplanSetsMaterialEdge.value;

  AdjustmentAngle := qReadLayplanSetsKnifeAngle.value;
  MainKnifeInitialise(True, False); //Adjust to Angle above

  SelectedLayplan := qReadLayplanSetsSelectedNo.value;
  SelectedLayplanWhenLoaded := Selectedlayplan;

  qReadLayplanSets.Close;

  //Knives
  qReadNumberOfLayPlanKnives.ParamByName('KnifeCode').value := KnifeCode;
  qReadNumberOfLayPlanKnives.ParamByName('KnifeSizeScale').value := KnifeScale;
  qReadNumberOfLayPlanKnives.ParamByName('KnifeSize').value := KnifeSize;
  qReadNumberOfLayPlanKnives.ParamByName('MaterialLength').value := MaterialLength;
  qReadNumberOfLayPlanKnives.ParamByName('MaterialWidth').value := MaterialWidth;
  qReadNumberOfLayPlanKnives.ParamByName('MaterialCutGap').value := sedtExpand.Value;
  if pedtRestrictiveMaterial.Text = '' then
    qReadNumberOfLayPlanKnives.ParamByName('MaterialCodeRestrictive').value := NULL
  else
    qReadNumberOfLayPlanKnives.ParamByName('MaterialCodeRestrictive').value := pedtRestrictiveMaterial.Text;

  qReadNumberOfLayPlanKnives.Open;
  NoKnivesToLoad := qReadNumberOfLayPlanKnivesNoKnives.value;
  qReadNumberOfLayPlanKnives.Close;

  qReadLayPlanKnives.ParamByName('KnifeCode').value := KnifeCode;
  qReadLayPlanKnives.ParamByName('KnifeSizeScale').value := KnifeScale;
  qReadLayPlanKnives.ParamByName('KnifeSize').value := KnifeSize;
  qReadLayPlanKnives.ParamByName('MaterialLength').value := MaterialLength;
  qReadLayPlanKnives.ParamByName('MaterialWidth').value := MaterialWidth;
  qReadLayPlanKnives.ParamByName('MaterialCutGap').value := sedtExpand.Value;
  if pedtRestrictiveMaterial.Text = '' then
    qReadLayPlanKnives.ParamByName('MaterialCodeRestrictive').value := NULL
  else
    qReadLayPlanKnives.ParamByName('MaterialCodeRestrictive').value := pedtRestrictiveMaterial.Text;
  qReadLayPlanKnives.Open;

  SetLength(KnivesUsed, NoKnivesToLoad);
  for j := 1 to NoKnivesToLoad do
  begin
    SetLength(KnivesUsed[j - 1, 0].PatternPoints, 0);
    SetLength(KnivesUsed[j - 1, 1].PatternPoints, 0);
    SetLength(KnivesUsed[j - 1, 0].ExpandedPoints, 0);
    SetLength(KnivesUsed[j - 1, 1].ExpandedPoints, 0);
  end;

  for j := 1 to NoKnivesToLoad do
  begin
    qReadLayPlanKnives.Filter := '(KnifeNo = ' + intToStr(j) + ') AND (RealNotExpanded = TRUE) AND (W2 = FALSE)';
    i := 0;
    qReadLayPlanKnives.RecNo := 1; //CJY changed from qReadLayPlanKnives.First
    qReadLayPlanKnives.Prior; //CJY changed from qReadLayPlanKnives.First
    while not qReadLayPlanKnives.eof do
    begin
      inc(i);
      SetLength(KnivesUsed[j - 1, 0].PatternPoints, i);

      KnivesUsed[j - 1, 0].PatternPoints[i - 1].X := qReadLayPlanKnivesX.value;
      KnivesUsed[j - 1, 0].PatternPoints[i - 1].Y := qReadLayPlanKnivesY.value;

      qReadLayPlanKnives.Next;
    end;

    qReadLayPlanKnives.Filter := '(KnifeNo = ' + intToStr(j) + ') AND (RealNotExpanded = TRUE) AND (W2 = TRUE)';
    i := 0;
    qReadLayPlanKnives.RecNo := 1; //CJY changed from qReadLayPlanKnives.First
    qReadLayPlanKnives.Prior; //CJY changed from qReadLayPlanKnives.First
    while not qReadLayPlanKnives.eof do
    begin
      inc(i);
      SetLength(KnivesUsed[j - 1, 1].PatternPoints, i);

      KnivesUsed[j - 1, 1].PatternPoints[i - 1].X := qReadLayPlanKnivesX.value;
      KnivesUsed[j - 1, 1].PatternPoints[i - 1].Y := qReadLayPlanKnivesY.value;

      qReadLayPlanKnives.Next;
    end;

    qReadLayPlanKnives.Filter := '(KnifeNo = ' + intToStr(j) + ') AND (RealNotExpanded = FALSE) AND (W2 = FALSE)';
    i := 0;
    qReadLayPlanKnives.RecNo := 1; //CJY changed from qReadLayPlanKnives.First
    qReadLayPlanKnives.Prior; //CJY changed from qReadLayPlanKnives.First
    while not qReadLayPlanKnives.eof do
    begin
      inc(i);
      SetLength(KnivesUsed[j - 1, 0].ExpandedPoints, i);

      KnivesUsed[j - 1, 0].ExpandedPoints[i - 1].X := qReadLayPlanKnivesX.value;
      KnivesUsed[j - 1, 0].ExpandedPoints[i - 1].Y := qReadLayPlanKnivesY.value;

      qReadLayPlanKnives.Next;
    end;

    qReadLayPlanKnives.Filter := '(KnifeNo = ' + intToStr(j) + ') AND (RealNotExpanded = FALSE) AND (W2 = TRUE)';
    i := 0;
    qReadLayPlanKnives.RecNo := 1; //CJY changed from qReadLayPlanKnives.First
    qReadLayPlanKnives.Prior; //CJY changed from qReadLayPlanKnives.First
    while not qReadLayPlanKnives.eof do
    begin
      inc(i);
      SetLength(KnivesUsed[j - 1, 1].ExpandedPoints, i);

      KnivesUsed[j - 1, 1].ExpandedPoints[i - 1].X := qReadLayPlanKnivesX.value;
      KnivesUsed[j - 1, 1].ExpandedPoints[i - 1].Y := qReadLayPlanKnivesY.value;

      qReadLayPlanKnives.Next;
    end;
  end;

  qReadLayPlanKnives.Close;

  //Layplans
  qReadLayPlans.ParamByName('KnifeCode').value := KnifeCode;
  qReadLayPlans.ParamByName('KnifeSizeScale').value := KnifeScale;
  qReadLayPlans.ParamByName('KnifeSize').value := KnifeSize;
  qReadLayPlans.ParamByName('MaterialLength').value := MaterialLength;
  qReadLayPlans.ParamByName('MaterialWidth').value := MaterialWidth;
  qReadLayPlans.ParamByName('MaterialCutGap').value := sedtExpand.Value;
  if pedtRestrictiveMaterial.Text = '' then
    qReadLayPlans.ParamByName('MaterialCodeRestrictive').value := NULL
  else
    qReadLayPlans.ParamByName('MaterialCodeRestrictive').value := pedtRestrictiveMaterial.Text;
  qReadLayplans.Open;

  PlanNo := -1;
  qReadLayplans.RecNo := 1; //CJY changed from qReadLayplans.First
  qReadLayplans.Prior; //CJY changed from qReadLayplans.First
  while not qReadLayplans.eof do
  begin
    inc(PlanNo);
    sgLayPlans.RowCount := PlanNo + 1;

    LayplanCode := qReadLayplansLayplanCode.value;

    //Layplan Details
    ResultsLeft := qReadLayplansStartLeft.value;
    ResultsRemHeight := qReadLayplansRemHeight.value;
    ResultsRemWidth := qReadLayplansRemWidth.value;
    if not ReleasedVersion then
      sgLayPlans.Cells[0, PlanNo] := LayplanCode
    else
    begin
      LayPlanCodeNoOnly := Copy(LayPlanCode, 1, Pos('_', LayplanCode) - 1);
      sgLayPlans.Cells[0, PlanNo] := LayplanCodeNoOnly;
    end;
    sgLayPlans.Cells[1, PlanNo] := qReadLayplansDetails2.value;
    sgLayPlans.Cells[2, PlanNo] := qReadLayplansDetails3.value;
    sgLayPlans.Cells[3, PlanNo] := qReadLayplansDetails4.value;
    sgLayPlans.Cells[4, PlanNo] := qReadLayplansDetails5.value;
    sgLayPlans.Cells[5, PlanNo] := qReadLayplansDetails6.value;
    sgLayPlans.Cells[7, PlanNo] := intToStr(PlanNo + 1);
    sgLayPlans.Cells[9, PlanNo] := LayplanCode;

    PropogationInput.UsableMaterialLength := qReadLayplansInput_UsableMaterialLength.value;
    PropogationInput.UsableMaterialWidth := qReadLayplansInput_UsableMaterialWidth.value;
    PropogationInput.PatternHeight := qReadLayplansInput_PatternHeight.value;
    PropogationInput.PatternWidth := qReadLayplansInput_PatternWidth.value;
    PropogationInput.Square := qReadLayplansInput_Square.value;
    //Below would naturally read as below but psuedo fix the start side to the
    //one which we actually picked. This is because occasionally, the opposite
    //one was selected when it was read back in.
    //    PropogationInput.FixedStart := qReadLayplansInput_FixedStart.value;
    //    PropogationInput.StartLeft := qReadLayplansInput_StartLeft.value;
    PropogationInput.FixedStart := True;
    PropogationInput.StartLeft := qReadLayplansStartLeft.value;
    PropogationInput.W2 := qReadLayplansInput_W2.value;
    PropogationInput.FirstCutInCorner := qReadLayplansInput_FirstCutInCorner.value;
    PropogationInput.ForceW1First := qReadLayplansInput_ForceW1First.value;
    PropogationInput.ForceW2First := qReadLayplansInput_ForceW2First.value;
    PropogationInput.LocalInterlock.Used := qReadLayplansInput_LocalInterlock_Used.Value;
    PropogationInput.LocalInterlock.Reversed := qReadLayplansInput_LocalInterlock_Reversed.Value;
    PropogationInput.LocalInterlock.PairedPatternHeight := qReadLayplansInput_LocalInterlock_PairedPatternHeight.Value;
    PropogationInput.LocalInterlock.PairedPatternWidth := qReadLayplansInput_LocalInterlock_PairedPatternWidth.Value;
    PropogationInput.LocalInterlock.SinglePatternHeight := qReadLayplansInput_LocalInterlock_SinglePatternHeight.Value;
    PropogationInput.LocalInterlock.SinglePatternWidth := qReadLayplansInput_LocalInterlock_SinglePatternWidth.Value;
    PropogationInput.LocalInterlock.Vec1x := qReadLayplansInput_LocalInterlock_Vec1x.Value;
    PropogationInput.LocalInterlock.Vec1y := qReadLayplansInput_LocalInterlock_Vec1y.Value;
    PropogationInput.LocalInterlock.W2 := qReadLayplansInput_LocalInterlock_W2.Value;
    PropogationInput.LocalInterlock.Pat1.Left := qReadLayplansInput_LocalInterlock_Pat1_Left.Value;
    PropogationInput.LocalInterlock.Pat1.Top := qReadLayplansInput_LocalInterlock_Pat1_Top.Value;
    PropogationInput.LocalInterlock.Pat1.Right := qReadLayplansInput_LocalInterlock_Pat1_Right.Value;
    PropogationInput.LocalInterlock.Pat1.Bottom := qReadLayplansInput_LocalInterlock_Pat1_Bottom.Value;
    PropogationInput.LocalInterlock.Pat2.Left := qReadLayplansInput_LocalInterlock_Pat2_Left.Value;
    PropogationInput.LocalInterlock.Pat2.Top := qReadLayplansInput_LocalInterlock_Pat2_Top.Value;
    PropogationInput.LocalInterlock.Pat2.Right := qReadLayplansInput_LocalInterlock_Pat2_Right.Value;
    PropogationInput.LocalInterlock.Pat2.Bottom := qReadLayplansInput_LocalInterlock_Pat2_Bottom.Value;
    PropogationInput.LocalInterlock.LeftPat := qReadLayplansInput_LocalInterlock_LeftPat.Value;
    PropogationInput.LocalInterlock.BottomPat := qReadLayplansInput_LocalInterlock_BottomPat.Value;
    PropogationInput.LocalInterlock.SingleKnifeNo := qReadLayplansKnifeNo.Value;
    PropogationInput.PackAngle := qReadLayplansInput_PackAngle.Value;

    PropogationNo := qReadLayplansPropogationNo.Value;

    //Layplan Pack
    qReadLayplanPacks.ParamByName('KnifeCode').value := KnifeCode;
    qReadLayplanPacks.ParamByName('KnifeSizeScale').value := KnifeScale;
    qReadLayplanPacks.ParamByName('KnifeSize').value := KnifeSize;
    qReadLayplanPacks.ParamByName('MaterialLength').value := MaterialLength;
    qReadLayplanPacks.ParamByName('MaterialWidth').value := MaterialWidth;
    qReadLayplanPacks.ParamByName('MaterialCutGap').value := sedtExpand.Value;
    if pedtRestrictiveMaterial.Text = '' then
      qReadLayplanPacks.ParamByName('MaterialCodeRestrictive').value := NULL
    else
      qReadLayplanPacks.ParamByName('MaterialCodeRestrictive').value := pedtRestrictiveMaterial.Text;
    qReadLayplanPacks.ParamByName('LayplanCode').value := LayplanCode;
    qReadLayplanPacks.Open;

    SetLength(PackResults, 0);
    i := 0;
    while not qReadLayplanPacks.eof do
    begin
      inc(i);
      SetLength(PackResults, i);

      PackResults[i - 1].KnifeNo := qReadLayplansKnifeNo.value;
      PackResults[i - 1].W2 := qReadLayplanPacksW2.Value;
      PackResults[i - 1].Ghost := False; //No Ghosts for Synthetics
      PackResults[i - 1].BoundingRect.Left := qReadLayplanPacksBR_Left.Value;
      PackResults[i - 1].BoundingRect.Top := qReadLayplanPacksBR_Top.Value;
      PackResults[i - 1].BoundingRect.Right := qReadLayplanPacksBR_Right.Value;
      PackResults[i - 1].BoundingRect.Bottom := qReadLayplanPacksBR_Bottom.Value;
      PackResults[i - 1].Colour := 0;

      qReadLayplanPacks.Next;
    end;
    qReadLayplanPacks.Close;

    //Whole Layplan
    SetLength(LayPlans, length(LayPlans) + 1);

    Layplans[length(LayPlans) - 1].StartLeft := ResultsLeft;
    Layplans[length(LayPlans) - 1].RemHeight := ResultsRemHeight;
    Layplans[length(LayPlans) - 1].RemWidth := ResultsRemWidth;
    Layplans[length(LayPlans) - 1].Pack := copy(PackResults);
    Layplans[length(Layplans) - 1].PropogationInput := PropogationInput;
    Layplans[length(LayPlans) - 1].PropogationNo := PropogationNo;

    qReadLayplans.next;
  end;
  qReadLayplans.Close;

  LayPlansLoaded := True;

  //Select Row & Recreate Layplan
  if SelectedLayplan <> -1 then
  begin
    sgLayplans.Row := SelectedLayplan;
    lblSelectedLayplan.Caption := sgLayplans.Cells[0, sgLayplans.Row];
  end
  else
  begin
    sgLayPlans.Row := 0;
    lblSelectedLayplan.Caption := '<None>';
  end;
  sgLayPlansClick(Self);

  CanSave := False;
  SelectedLayplanChanged := False;
  UpdateScreen;
end;

procedure TfmLayplan.UpdateSelectedLayplan;
var
  SQLString: string;
  sMaterialLength, sMaterialWidth, sCutGap, sReference1, sSelected: string;

begin
  str(MaterialLength, sMaterialLength);
  str(MaterialWidth, sMaterialWidth);
  str(sedtExpand.Value, sCutGap);

  if pedtRestrictiveMaterial.Text = '' then
    sReference1 := 'IS NULL'
  else
    sReference1 := '= ''' + QS(pedtRestrictiveMaterial.text) + '''';

  sSelected := intToStr(SelectedLayplan);

  SQLString := '';
  SQLString := SQLString + 'UPDATE LayplanSets ' +
                           'SET SelectedNo = ' + sSelected + ' ' +
                           'WHERE (KnifeCode = ''' + QS(KnifeCode) + ''') AND ' +
                           '(KnifeSizeScale = ''' + QS(KnifeScale) + ''') AND ' +
                           '(KnifeSize = ''' + QS(KnifeSize) + ''') AND ' +
                           '(MaterialLength = ' + sMaterialLength + ') AND ' +
                           '(MaterialWidth = ' + sMaterialWidth + ') AND ' +
                           '(MaterialCutGap = ' + sCutGap + ') AND ' +
                           '(MaterialCodeRestrictive ' + sReference1 + ')';
  qSaveLayplan.SQL.Text := SQLString;

  LocalConnectionSumms.StartTransaction;
  try
    qSaveLayplan.ExecSQL;
    LocalConnectionSumms.commit;
  except
    on E: Exception do
    begin
      LocalConnectionSumms.Rollback;
      if (Pos('Error 7200', E.Message) > 0) and (Pos('Error 7076', E.Message) > 0) and (Pos('MATERIALCODERESTRICTIVE', E.Message) > 0) then
        fmErrorHandler.DebugMessageDlg('Layplan NOT saved. Material Code cannot be found', E.Message, qSaveLayplan.Text)
      else if (Pos('Error 7200', E.Message) > 0) and (Pos('Error 7087', E.Message) > 0) then
        fmErrorHandler.DebugMessageDlg('Permission denied. Layplan NOT saved.', E.Message, qSaveLayplan.Text)
      else
        fmErrorHandler.DebugMessageDlg('Unexpected Error. Layplan NOT saved.', E.Message, qSaveLayplan.Text);
    end;
  end;

  SelectedLayplanChanged := False;
end;

function TfmLayplan.CheckAndSaveLayplan: Boolean;
var
  i, HoldRow: integer;
  SaveLayplans, SaveSelectedLayplan: Boolean;
  s: string;
  SQLString: string;
  AlreadyExists: Boolean;
  sMaterialLength, sMaterialWidth, sCutGap, sReference1: string;
  Pieces: integer;

begin
  if CanSave then
  begin
    if SelectedLayplan = -1 then
      s := 'Save Layplans (No Layplan Selected)?'
    else
      s := 'Save Layplans?';
  end
  else if SelectedLayplanChanged then
    s := 'Save new choice for Selected Layplan?';

  SaveLayplans := False;
  SaveSelectedlayplan := False;
  if FromBulkLayplanning or (not Option_ProductionSystem) then
    SaveLayplans := True
  else if messagedlg(s, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if CanSave then
      SaveLayplans := True
    else if SelectedLayplanChanged then
      SaveSelectedlayplan := True;
  end;

  if SaveSelectedLayplan then
    UpdateSelectedLayplan
  else if SaveLayplans then
  begin
    str(MaterialLength, sMaterialLength);
    str(MaterialWidth, sMaterialWidth);
    str(sedtExpand.Value, sCutGap);
    if pedtRestrictiveMaterial.Text = '' then
      sReference1 := 'IS NULL'
    else
      sReference1 := '= ''' + QS(pedtRestrictiveMaterial.text) + '''';

    //Check for overwriting
    SQLString := '';
    SQLString := SQLString + 'SELECT * FROM LayplanSets ' +
                             'WHERE (KnifeCode = ''' + QS(KnifeCode) + ''') AND ' +
                             '(KnifeSizeScale = ''' + QS(KnifeScale) + ''') AND ' +
                             '(KnifeSize = ''' + QS(KnifeSize) + ''') AND ' +
                             '(MaterialLength = ' + sMaterialLength + ') AND ' +
                             '(MaterialWidth = ' + sMaterialWidth + ') AND ' +
                             '(MaterialCutGap = ' + sCutGap + ') AND ' +
                             '(MaterialCodeRestrictive ' + sReference1 + ')' + #13;
    qSaveLayplan.SQL.Text := SQLString;
    qSaveLayplan.open;
    //CJY qSaveLayPlan.FetchOptions.RecordCountMode set to cmTotal
    AlreadyExists := (qSaveLayPlan.RecordCount = 1);
    qSaveLayplan.close;

    if AlreadyExists then
    begin
      if AutoOverwrite = AUTO_OVERWRITE_OFF then
      begin
        if messagedlg('Layplans already exist. Saving new layplans over' + #13 +
                      'current ones will affect existing allowances.' + #13#13 +
                      'Save new Layplans?',
                      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
          SaveLayplans := False;
      end
      else if AutoOverwrite = AUTO_OVERWRITE_NO then
        SaveLayplans := False
      else if AutoOverwrite = AUTO_OVERWRITE_YES then
        SaveLayplans := True;
    end;

    if SaveLayplans then
    begin
      //Check Pieces on Best isn't 0
      Pieces := strToInt(sgLayPlans.Cells[4, 0]);
      if Pieces > 0 then
      begin
        screen.cursor := crHourglass;
        Saving := True;

        HoldRow := sgLayPlans.Row;

        setlength(KnivesToSave, Length(KnivesUsed));
        for i := 0 to Length(KnivesToSave) -1 do
        begin
          KnivesToSave[i].Save := False;
          KnivesToSave[i].NewNo := -1;
        end;

        for i := 0 to sgLayPlans.RowCount - 1 do
        begin
          sgLayPlans.Row := i;
  //        application.processmessages;

          Pieces := strToInt(sgLayPlans.Cells[4, sgLayPlans.Row]);

          if Pieces > 0 then
            KnivesToSave[CutResults[0].KnifeNo - 1].Save := True;
        end;

        SaveLayplanSet;

        sgLayPlans.Row := HoldRow;

        CanSave := False;
        SelectedLayplanChanged := False;
        Saving := False;

        screen.cursor := crDefault;
      end
      else
        SaveLayplans := False;
    end;
  end;

  UpdateScreen;

  Result := SaveLayplans;
end;

procedure TfmLayplan.LoadKnife(Code, Scale, Size: string; Angle: Real);
begin
  if Zoom <> 1 then
    tbZoom.Position := 1;

  PatternInitialise;

  tblKnives.FindKey([Code, Scale, Size]);

  ActualPoints := ReadPattern(tblKnivesCode.Value,  tblKnivesSizeScale.Value, tblKnivesMeasuredSize.Value);

  PictureSize := -1;
  AdjustmentAngle := Angle;
  MainKnifeInitialise(True, False);

{$IFDEF DEBUG}
  NoPointsInOriginal := Length(ActualPoints);
{$ENDIF}

  if Length(ActualPoints) <= 3 then
  begin
    if not FromBulkLayplanning then
      messagedlg('This a manual knife or there are ' + #13 +
                 'not enough points for this knife.', mtInformation, [mbOk], 0);
    KnifeLoaded := False;
  end;

  KnifeCode := tblKnivesCode.Value;
  KnifeScale := tblKnivesSizeScale.Value;
  KnifeSize := tblKnivesMeasuredSize.Value;
  KnifeArea := Knife.PatternNettArea; //SqFt

  lblKnifeCode.Caption := KnifeCode;
  lblKnifeSize.Caption := KnifeSize;

  rgStartingSideClick(Self);
  pcSelectionsResults.TabIndex := 1;
  cbUnitsKnifeChange(Self);

  CanSave := False;
  SelectedLayplanChanged := False;
  UpdateScreen;
end;

function TfmLayplan.ElapsedTime(TheTime: TDateTime): string;
var
  s: string;

begin
  DateTimeToString(s, 'h:nn:ss', TheTime);

  //Get rid of 0 hour bit
  if copy(s, 1, 2) = '0:' then
  begin
    s := copy(s, 3, Length(s) - 2);

    //Get rid of 0 min bit
    if copy(s, 1, 1) = '0' then
      s := copy(s, 2, Length(s) - 1);
  end;

  Result := s;
end;

procedure TfmLayplan.AdjustRulersScale;
var
  iUnitPrice: integer;
  rUnitPrice: real;

begin
  //Reset
  rUnitPrice := rulerKnifeLeft.UnitPrice;
  rulerKnifeLeft.UnitSize := rulerKnifeLeft.UnitSize / rUnitPrice * 10;
  rulerKnifeLeft.UnitPrice := rulerKnifeLeft.UnitPrice / rUnitprice * 10;

  while rulerKnifeLeft.UnitSize > 50 do
  begin
    rulerKnifeLeft.UnitSize := rulerKnifeLeft.UnitSize / 2;
    rulerKnifeLeft.UnitPrice := rulerKnifeLeft.UnitPrice / 2;
  end;

  iUnitPrice := round(rulerKnifeLeft.UnitPrice);
  if iUnitPrice = 0 then
    iUnitPrice := 1;
  rulerKnifeLeft.UnitSize := rulerKnifeLeft.UnitSize / rulerKnifeLeft.UnitPrice * iUnitPrice;
  rulerKnifeLeft.UnitPrice := rulerKnifeLeft.UnitPrice / rulerKnifeLeft.UnitPrice * iUnitPrice;

  //Match bottom to left
  rulerKnifeBottom.UnitSize := rulerKnifeLeft.UnitSize;
  rulerKnifeBottom.UnitPrice := rulerKnifeLeft.UnitPrice;
end;

end.

