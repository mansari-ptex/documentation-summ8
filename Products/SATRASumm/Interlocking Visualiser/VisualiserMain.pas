unit VisualiserMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, CButton,  AllPatterns, ToolWin,
  ComCtrls, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDTablePlus,   Interlocking, Results,
  Const_Interlocking, General_Interlocking, Spin, PBSpinEdit, Merge,
  Math, Planit, PBNumEdit, FastGeo, Expansion, concavities, CompareOldNew,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.ADS, CmnVars;

type
  TfmLayplan = class(TForm)
    tbMain: TToolBar;
    pnlSpacer1: TPanel;
    btnAllKnives: TSpeedButton;
    Panel1: TPanel;
    odBitmap: TOpenDialog;
    LocalConnectionSumms: TFDConnection;
    tblKnives: TFDTablePlus;
    tblKnivesCode: TStringField;
    qPatterns: TFDQuery;
    qPatternsKnife: TStringField;
    qPatternsSeq: TSmallintField;
    qPatternsX: TSmallintField;
    qPatternsY: TSmallintField;
    btnAllKnives2: TSpeedButton;
    rgAutoTransfer: TRadioGroup;
    imgInterlock: TImage;
    tblKnivesMeasuredSize: TStringField;
    tblKnifeSets: TFDTablePlus;
    tblKnifeSetsCode: TStringField;
    tblKnifeSetsDescription: TStringField;
    tblKnifeSetsSizeScale: TStringField;
    tblKnifeSetsType: TStringField;
    tblKnifeSetsManualEntry: TBooleanField;
    tblKnifeSetsCutGap: TSmallintField;
    tblKnifeSetsDoubleSided: TBooleanField;
    tblKnifeSetsThin: TBooleanField;
    tblKnifeSetsPieces: TSmallintField;
    tblKnifeSetsPunches: TSmallintField;
    tblKnifeSetsClears: TSmallintField;
    tblKnifeSetsBands: TFloatField;
    tblKnifeSetsMarks: TFloatField;
    tblKnivesInterlockAreaPrimeSynthetic: TFloatField;
    tblKnivesInterlockAreaNonPrime: TFloatField;
    tblKnivesOldInterlockArea: TFloatField;
    dsKnives: TDataSource;
    tblKnivesNewInterlockArea: TFloatField;
    tblKnivesSizeScale: TStringField;
    qParameters: TFDQuery;
    qParametersAutoCreateConstruction: TBooleanField;
    qParametersAutoDeleteConstruction: TBooleanField;
    qParametersBatchSize: TSmallintField;
    qParametersCompany: TStringField;
    qParametersCADDirectory: TStringField;
    qParametersTicketsDirectory: TStringField;
    qParametersStylePicDirectory: TStringField;
    qParametersDifficultLeatherFacilty: TBooleanField;
    qParametersLinesInLeatherGrid: TSmallintField;
    qParametersRowsInLeatherGrid: TSmallintField;
    qParametersTableLength: TFloatField;
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
    qParametersAuditPathName: TStringField;
    qParametersOldAudit: TBooleanField;
    qParametersIssuedCutWeek: TStringField;
    qParametersTicketCostedAlw: TStringField;
    qParametersSummarisedDetailed: TStringField;
    qParametersPrintCutterValue: TBooleanField;
    qParametersCutterPageThrow: TBooleanField;
    qParametersSplitTickets: TBooleanField;
    qParametersSplittingScheme: TSmallintField;
    qParametersSaveOutBasic: TStringField;
    qParametersMaterialDefaultUnits: TStringField;
    qParametersClearAuditAfterSave: TBooleanField;
    qParametersShowWaste: TBooleanField;
    qParametersGroupPrintSyntheticTickets: TBooleanField;
    qParametersCreateSyntheticTicketsList: TBooleanField;
    qParametersUpdatedInitialisation: TBooleanField;
    qParametersInterlockingToleranceInterlock: TSmallintField;
    qParametersInterlockingToleranceLayplans: TSmallintField;
    qParametersMadeInPairsDefault: TBooleanField;
    gbKnife: TGroupBox;
    gbKnifeW1: TGroupBox;
    gbKnifeW2: TGroupBox;
    imgKnife: TImage;
    imgKnifeW1: TImage;
    imgKnifeW2: TImage;
    gbPresets: TGroupBox;
    btnCopyAngle: TButton;
    gbAngle1: TGroupBox;
    sedtAngle: TPBNumEdit;
    gbAngle2: TGroupBox;
    sedtAngle2: TPBNumEdit;
    Label1: TLabel;
    sedtExpand: TPBSpinEdit;
    lblExpandBy: TLabel;
    gbAreas: TGroupBox;
    lblGrossArea: TLabel;
    lblGross: TLabel;
    lblNett: TLabel;
    lblNettArea: TLabel;
    lblPrime: TLabel;
    lblPrimeInterlockArea: TLabel;
    lblNonPrime: TLabel;
    lblNonPrimeInterlockArea: TLabel;
    gbDrawingSettings: TGroupBox;
    cbShowHulls: TCheckBox;
    cbShowExpansions: TCheckBox;
    cbShowBoundingRects: TCheckBox;
    cbShowNumbers: TCheckBox;
    cbShowHullOverlaps: TCheckBox;
    cbShowMerges: TCheckBox;
    btnDraw: TButton;
    gbMaterialSize: TGroupBox;
    Label5: TLabel;
    Label4: TLabel;
    eWidth: TEdit;
    eHeight: TEdit;
    gbSyntheticLayplanning: TGroupBox;
    rgRecipe: TRadioGroup;
    btnSynthetics: TButton;
    cbW2: TCheckBox;
    eConcavityNumber: TEdit;
    lblConcavityNumber: TLabel;
    rgStartingSide: TRadioGroup;
    rgCornerAnchoring: TRadioGroup;
    rgStartingCriteria: TRadioGroup;
    gbStepByStep: TGroupBox;
    btnW1: TButton;
    btnW2: TButton;
    btnW1W2: TButton;
    gbStops: TGroupBox;
    cbLeft: TCheckBox;
    cbRight: TCheckBox;
    cbTop: TCheckBox;
    cbBottom: TCheckBox;
    gbInterlockSettings: TGroupBox;
    cbOriginalHullTakeOut: TCheckBox;
    cbButt: TCheckBox;
    cbLeather: TCheckBox;
    cbSpeedRotate: TCheckBox;
    gbNumberOfPatterns: TGroupBox;
    lblNumPats: TLabel;
    gbGangStart: TGroupBox;
    rbNone: TRadioButton;
    rbGangs2: TRadioButton;
    rbGangs3: TRadioButton;
    cbSimpleDraw: TCheckBox;
    dbDebugger: TGroupBox;
    seDebuggerZoom: TPBSpinEdit;
    Zoom: TLabel;
    btnDebug: TButton;
    gbLeatherInterlocking: TGroupBox;
    btnSATRASummLeather: TButton;
    btnStep: TButton;
    btnFinish: TButton;
    btnCancel: TButton;
    gbDiagFreeAngle: TGroupBox;
    btnDiagonalFreeAngle: TButton;
    lblGetDiagonalFreeAngle: TLabel;
    cbTrueSize: TCheckBox;
    btnGang: TButton;
    odFullInterlockFile: TOpenDialog;
    odDescribe: TOpenDialog;
    btnDrawInterlock: TButton;
    btnDescribe: TButton;
    FDPhysADSDriverLink1: TFDPhysADSDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure btnAllKnivesClick(Sender: TObject);
    procedure UpdateResults(Interlock: TInterlock; Knife2: TPattern);
    procedure DisplayResults(RemHeight, RemWidth: integer; LayPlan: Boolean);
    function ReadPattern(Code, Size: string): TPointArray;
    procedure btnW1W2Click(Sender: TObject);
    procedure btnW1Click(Sender: TObject);
    procedure btnW2Click(Sender: TObject);
    procedure btnAllKnives2Click(Sender: TObject);
    procedure btnCopyAngleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSATRASummLeatherClick(Sender: TObject);
    procedure btnDrawClick(Sender: TObject);
    procedure btnSyntheticsClick(Sender: TObject);
    procedure btnDebugClick(Sender: TObject);
    function PackNo(No: integer): integer;
    procedure LayPlanInitialise(Angle: real; UseLocalInterlock: Boolean);
    procedure btnDiagonalFreeAngleClick(Sender: TObject);
    procedure tblKnivesCalcFields(DataSet: TDataSet);
    procedure DoCalc(var PrimeInterlockArea, NonPrimeInterlockArea: real);
    function OverlappingHulls: Boolean;
    procedure SetCutResultsColour;
    procedure btnStepClick(Sender: TObject);
    procedure Hold;
    procedure AddToKnivesUsed(var CurrentKnife: integer);
    procedure qParametersAfterOpen(DataSet: TDataSet);
    procedure rbNoneClick(Sender: TObject);
    procedure rbGangsClick(Sender: TObject);
    procedure cbOriginalHullTakeOutClick(Sender: TObject);
    procedure cbSpeedRotateClick(Sender: TObject);
    procedure btnFinishClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure DrawBitmap(Pattern: TPattern;
                         var imgKnf: TImage);
    procedure seDebuggerZoomChange(Sender: TObject);
    procedure cbTrueSizeClick(Sender: TObject);
    procedure btnGangClick(Sender: TObject);
    procedure btnDrawInterlockClick(Sender: TObject);
    procedure btnDescribeClick(Sender: TObject);
  private
    RemH, RemW: integer;
  public
    { Public declarations }
  end;

const
  SINGLE_INTERLOCK = 0;
  REPEATED_SINGLE_INTERLOCK = 1;
  GROUP_INTERLOCK = 2;
  TOLERANCE = 1000;
  Option_LegacySynthetics = FALSE;

var
  fmLayplan: TfmLayplan;
  InterlockType: integer;
  OriginalPoints: TPointArray;
  KeepPoints: TPointArray;
  LeatherStep, LeatherFinish, LeatherCancel: Boolean;
  InterlockingToleranceInterlock, InterlockingToleranceLayplans: integer;
  LIKnifeW1, LIKnifeW2: TPattern;  

implementation

uses Debugger, PolygonOverlaps, FILT, ConvexHull;

{$R *.dfm}

function TfmLayplan.OverlappingHulls: Boolean;
var
  APoint0, APoint1 :TPoint2D;
  ConvexHull0, ConvexHull1: TPolygon2D;

begin
  //Only ever used for checking overlaps of in a W1 situation so can use KnifeW1
  //Always looking at the realative position of the last positioned shape and
  //the original shape.

  APoint0.x := CutResults[0].BoundingRect.Left;
  APoint0.y := CutResults[0].BoundingRect.Top;
  APoint1.x := CutResults[Length(CutResults) - 1].BoundingRect.Left;
  APoint1.y := CutResults[Length(CutResults) - 1].BoundingRect.Top;

  ConvexHull0 := Translate(APoint0, KnifeW1.ConvexHull);
  ConvexHull1 := Translate(APoint1, KnifeW1.ConvexHull);

  Result := intersect(ConvexHull0, ConvexHull1)
end;

procedure TfmLayplan.UpdateResults(Interlock: TInterlock; Knife2: TPattern);
var
  MergedPattern: TPointArray;
  OriginalPos, GhostPos: TPoint;
  ShapeNoToGhost: integer;
  InterlockToGhost: TInterlock;
  Direction, GhostNo: integer;
  EnoughGhosts: Boolean;

begin
  //Add to Results
  AddToResults(Interlock, (InterlockType = GROUP_INTERLOCK) and (not NewKnife), Knife2.W2, False, cbOriginalHullTakeout.checked);
  NewKnife := False;

  //Merge ready to continue
  MergedPattern := MergePatterns(Knife, Knife2, Interlock, False).Points;
  Knife := CreatePattern(MergedPattern, 0, 0, False, False);

  if cbOriginalHullTakeOut.Checked and (InterlockType = REPEATED_SINGLE_INTERLOCK) then
    Hold;

  //Possible Ghosts
  if (not LeatherCancel) and cbOriginalHullTakeOut.Checked and (InterlockType = REPEATED_SINGLE_INTERLOCK) and (not Knife2.W2) then
  begin
    //Shape to ghost
    ShapeNoToGhost := Length(CutResults) - 1;
    InterlockToGhost := Interlock;

    //We have to go in both directions because since we are looking for
    //biggest 'hull on hull' overlap we sometimes get 'other side' interlocks
    //and the original one is the 'wrong' side of the interlocked knife.
    //This is perfectly ok as it is always symetrical as we are in W1
    //situation here. It is very difficult to find the biggest hull on hull
    //which is always the right way around. It does not really matter as all
    //that happens is occasionally we get a few extra '-ve' ghosts on
    //'boomerang' shaped patterns. Since this shape pattern only accounts for
    //a small proportion of total patterns, this minor overhead is perfectly
    //acceptable.
    for Direction := 1 to 2 do
    begin
      GhostNo := 0;
      EnoughGhosts := False;
      while not EnoughGhosts do
      begin
        //Position the ghosted shape...
        if Direction = 1 then
          inc(GhostNo)
        else
          dec(GhostNo);
        Interlock := InterlockToGhost;
        GhostPos := GhostPosition(Interlock.Knife1BoundingRect, ShapeNoToGhost, GhostNo);

        OriginalPos.x := Interlock.Knife2BoundingRect.Left;
        OriginalPos.y := Interlock.Knife2BoundingRect.Top;
        Interlock.Knife2BoundingRect.Left := GhostPos.x;
        Interlock.Knife2BoundingRect.Top := GhostPos.y;
        Interlock.Knife2BoundingRect.Right := Interlock.Knife2BoundingRect.Right + GhostPos.x - OriginalPos.x;
        Interlock.Knife2BoundingRect.Bottom := Interlock.Knife2BoundingRect.Bottom + GhostPos.y - OriginalPos.y;

        {$IFDEF DEBUGFULL}
        Interlock.ConvexHull1 := MakeConvexHull(Knife.ExpandedPoints);
        {$ENDIF}

        //...& Add to Results
        AddToResults(Interlock, False, False, True, False);

        //Merge (the ghost) ready to continue
        MergedPattern := MergePatterns(Knife, Knife2, Interlock, True).Points;
        Knife := CreatePattern(MergedPattern, 0, 0, False, False);

        Hold;

        //Always include 1 more in either direction as even if another W1
        //ghost wont fit, a proper W2 might get in there.
        if not OverlappingHulls then
          EnoughGhosts := True;
      end;
    end;
  end;

  //Update Patterns - this bit doens't belong in the real copy, it's just for caller
  if InterlockType = GROUP_INTERLOCK then
  begin
    KnifeW1 := CreatePattern(MergedPattern, 0, 0, False, False);
    KnifeW2 := CreatePattern(MergedPattern, 0, 0, False, True);
  end;
end;

procedure TfmLayplan.DisplayResults(RemHeight, RemWidth: integer; LayPlan: Boolean);
var
  ClipRect: TRect;
  bmpResults: TBitmap;
  i, MatHeight, MatWidth, minx, miny, maxx, maxy: integer;

begin
  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;

  for i := 0 to Length(CutResults) - 1 do
  begin
    if CutResults[i].BoundingRect.Left < minx then
      minx := CutResults[i].BoundingRect.Left;
    if CutResults[i].BoundingRect.Top < miny then
      miny := CutResults[i].BoundingRect.Top;
    if CutResults[i].BoundingRect.Right > maxx then
      maxx := CutResults[i].BoundingRect.Right;
    if CutResults[i].BoundingRect.Bottom > maxy then
      maxy := CutResults[i].BoundingRect.Bottom;
  end;

  MatHeight := round(StrToFloat(eHeight.Text) * 1.0936 * 3 * 12000 / PATTERNRES);
  MatWidth := round(StrToFloat(eWidth.Text) * 1.0936 * 3 * 12000 / PATTERNRES);

  if Layplan then
  begin
    ClipRect.Left := 0;   //always 0?
    ClipRect.Top := 0;    //always 0?
    ClipRect.Right := MatWidth div 1;              //Blows it up by 5
    ClipRect.Bottom := MatHeight div 1;            //Blows it up by 5
  end
  else
  begin
    ClipRect.Left := minx;   //always 0?
    ClipRect.Top := miny;    //always 0?
    ClipRect.Right := maxx;
    ClipRect.Bottom := maxy;
  end;

  bmpResults := TBitmap.Create;
  bmpResults.PixelFormat := pf4bit;
  bmpResults.Height := ClipRect.Bottom - ClipRect.Top;
  bmpResults.Width := ClipRect.Right - ClipRect.Left;

  bmpResults.Canvas.brush.Color := clTeal;
  bmpResults.Canvas.FillRect(ClipRect);

{  bmpResults.Canvas.pen.Color := clGreen;
  bmpResults.Canvas.brush.Color := clGreen;
  bmpResults.Canvas.Rectangle(0, 0, MatWidth, RemHeight);
  bmpResults.Canvas.Rectangle(0, 0, RemWidth, MatHeight);}

  DrawResults(bmpResults.Canvas, 0, 0, 1, False, cbShowExpansions.Checked, cbShowHulls.Checked, cbShowBoundingRects.Checked, cbShowNumbers.Checked, cbShowHullOverlaps.Checked, cbShowMerges.Checked, cbSimpleDraw.Checked);

  imgInterlock.Visible := False;
  imgInterlock.Picture.Bitmap := bmpResults;
  imgInterlock.Visible := True;

  bmpResults.Free;

  DrawBitmap(Knife, imgKnife);
  DrawBitmap(KnifeW1, imgKnifeW1);
  DrawBitmap(KnifeW2, imgKnifeW2);

end;

procedure TfmLayplan.btnAllKnivesClick(Sender: TObject);
var
  NumPoints: integer;
  Tolerance: TFloat;

begin
  RemH := 0;
  RemW := 0;
//  Knife.bmpShape := nil;
  imgKnife.Picture.Bitmap := nil;
  imgInterlock.Picture.Bitmap := nil;       //Kill ACTUAL bitmap

  fmAllPatterns.ShowModal;

  tblKnives.Open;
  tblKnives.FindKey([fmAllPatterns.KnifeCode, fmAllPatterns.KnifeScale, fmAllPatterns.KnifeSize]);
//  if not(tblKnivesManualEntry.Value) then
  begin
    //Initialise Results
    SetLength(CutResults, 0);
    InitialisePackResults;

    SetLength(OriginalHullOverlaps, 0);

    OriginalPoints := ReadPattern(tblKnivesCode.Value, tblKnivesMeasuredSize.Value);

    SetLength(KeepPoints, Length(OriginalPoints));
    KeepPoints := Copy(OriginalPoints);

    NumPoints := Length(OriginalPoints);
    Tolerance := 0;
//    while (NumPoints > 100) do
    begin
      Tolerance := Tolerance + 1;
//      NumPoints := PolySimplifyInt2D(Tolerance, KeepPoints, OriginalPoints); //speed
      NumPoints := PolySimplifyInt2D(4, KeepPoints, OriginalPoints);           //accuracy
      SetLength(OriginalPoints, NumPoints);
    end;

  {$IFDEF DEBUGFULL}
    fmDebugger.DrawPattern(OriginalPoints);
    fmDebugger.DrawFiltering(KeepPoints, OriginalPoints);
  {$ENDIF}

    Knife := CreatePattern(OriginalPoints, sedtAngle.value, sedtExpand.Value, True, False);
    DrawBitmap(Knife, imgKnife);
    KnifeW1 := CreatePattern(OriginalPoints, sedtAngle2.value, sedtExpand.Value, True, False);
    DrawBitmap(KnifeW1,imgKnifeW1);
    KnifeW2 := CreatePattern(OriginalPoints, sedtAngle2.value, sedtExpand.Value, True, True);
    DrawBitmap(KnifeW2, imgKnifeW2);

    //Always First knife when loaded here
    CurrentKnife := 1;
    SetLength(KnivesUsed, CurrentKnife);
    KnivesUsed[CurrentKnife - 1, 0] := KnifeW1;
    KnivesUsed[CurrentKnife - 1, 1] := KnifeW2;

    NewKnife := True;              
  end;
//  else
//    messagedlg('This is a manual knife', mtInformation, [mbOK], 0);

  gbKnifeW1.Caption := 'Knife 1: ' + tblKnivesCode.Value;
  gbKnifeW2.Caption := 'Knife 2: ' + tblKnivesCode.Value;          //is this right?
  tblKnives.Close;

  btnSATRASummLeather.enabled := True;
  btnStep.enabled := False;
  btnFinish.enabled := False;
  btnCancel.enabled := False;
  btnSynthetics.enabled := True;
end;

function TfmLayplan.ReadPattern(Code, Size: string): TPointArray;
var
  Pattern: TPointArray;
  i: integer;

begin
  qPatterns.ParamByName('KnifeCode').value := Code;
  qPatterns.ParamByName('Size').value := Size;
  qPatterns.open;

  //Read Pattern
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

//  EliminatePointsWithinIntersections(Pattern);

  Result := Pattern;
end;

procedure TfmLayplan.btnW1W2Click(Sender: TObject);
var
  BestInterlockW1, BestInterlockW2: TInterlock;

begin
  InterlockType := rgAutoTransfer.itemIndex;

  FileNumber := 0;
  BestInterlockW1 := FindInterlock(Knife, KnifeW1, KnivesUsed[0, 0], (Length(CutResults) = 0), cbOriginalHullTakeOut.Checked, OriginalKnifeNow, cbButt.Checked, cbLeft.Checked, cbRight.Checked, cbTop.Checked, cbBottom.Checked, (not cbLeather.Checked), cbSpeedRotate.Checked, TOLERANCE);
  BestInterlockW2 := FindInterlock(Knife, KnifeW2, KnivesUsed[0, 0], (Length(CutResults) = 0), cbOriginalHullTakeOut.Checked, OriginalKnifeNow, cbButt.Checked, cbLeft.Checked, cbRight.Checked, cbTop.Checked, cbBottom.Checked, (not cbLeather.Checked), cbSpeedRotate.Checked, TOLERANCE);
  if cbLeather.Checked then
    BestInterlockW2.Size := BestInterlockW2.Size / 2;

  if (not BestInterlockW1.Found) and (not BestInterlockW2.Found) then
    messagedlg('No Soln', mtInformation, [mbOk], 0)
  else
  begin
    if BestInterlockW1.Size > BestInterlockW2.Size then
      UpdateResults(BestInterlockW1, KnifeW1)
    else
      UpdateResults(BestInterlockW2, KnifeW2);

    DisplayResults(0, 0, False);
  end;
end;

procedure TfmLayplan.btnW1Click(Sender: TObject);
var
  BestInterlock: TInterlock;
  s: string;

begin
  InterlockType := rgAutoTransfer.itemIndex;

  FileNumber := 0;
  BestInterlock := FindInterlock(Knife, KnifeW1, KnivesUsed[0, 0], (Length(CutResults) = 0), cbOriginalHullTakeOut.Checked, OriginalKnifeNow, cbButt.Checked, cbLeft.Checked, cbRight.Checked, cbTop.Checked, cbBottom.Checked, (not cbLeather.Checked), cbSpeedRotate.Checked, TOLERANCE);

  if BestInterlock.Found then
  begin
    UpdateResults(BestInterlock, KnifeW1);
    DisplayResults(0, 0, False);

    str(BestInterlock.Size : 7 : 3, s);
    lblPrimeInterlockArea.Caption := s;
  end
  else
    messagedlg('No Soln', mtInformation, [mbOk], 0);
end;

{procedure TfmCaller.LayPlanInitialise(Angle: real; UseLocalInterlock: Boolean);
begin
  SetLength(CutResults, 0);
  ResultsRemHeight := 0;
  ResultsRemWidth := 0;

  SetLength(OriginalHullOverlaps, 0);

  if UseLocalInterlock then
  begin
    Knife.Height := LIKnifeW1.Height;
    Knife.Width := LIKnifeW1.Width;
    Knife.RealPoints := Copy(LIKnifeW1.RealPoints);
    Knife.ExpandedPoints := Copy(LIKnifeW1.ExpandedPoints);
    Knife.ConvexHull := Copy(LIKnifeW1.ConvexHull);
    Knife.ButtOctogan := Copy(LIKnifeW1.ButtOctogan);
    Knife.NettArea := LIKnifeW1.NettArea;
    Knife.GrossArea := LIKnifeW1.GrossArea;
    Knife.W2 := LIKnifeW1.W2;

    KnifeW1.Height := LIKnifeW1.Height;
    KnifeW1.Width := LIKnifeW1.Width;
    KnifeW1.RealPoints := Copy(LIKnifeW1.RealPoints);
    KnifeW1.ExpandedPoints := Copy(LIKnifeW1.ExpandedPoints);
    KnifeW1.ConvexHull := Copy(LIKnifeW1.ConvexHull);
    KnifeW1.ButtOctogan := Copy(LIKnifeW1.ButtOctogan);
    KnifeW1.NettArea := LIKnifeW1.NettArea;
    KnifeW1.GrossArea := LIKnifeW1.GrossArea;
    KnifeW1.W2 := LIKnifeW1.W2;

    KnifeW2.Height := LIKnifeW2.Height;
    KnifeW2.Width := LIKnifeW2.Width;
    KnifeW2.RealPoints := Copy(LIKnifeW2.RealPoints);
    KnifeW2.ExpandedPoints := Copy(LIKnifeW2.ExpandedPoints);
    KnifeW2.ConvexHull := Copy(LIKnifeW2.ConvexHull);
    KnifeW2.ButtOctogan := Copy(LIKnifeW2.ButtOctogan);
    KnifeW2.NettArea := LIKnifeW2.NettArea;
    KnifeW2.GrossArea := LIKnifeW2.GrossArea;
    KnifeW2.W2 := LIKnifeW2.W2;
  end
  else
  begin
    Knife := CreatePattern(OriginalPoints, Angle, 0, True, False);
    KnifeW1 := CreatePattern(OriginalPoints, Angle, 0, True, False);
    KnifeW2 := CreatePattern(OriginalPoints, Angle, 0, True, True);
  end;

  NewKnife := True;
end;           }

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
    Knife := CreatePattern(OriginalPoints, Angle, sedtExpand.Value, True, False);
    KnifeW1 := CreatePattern(OriginalPoints, Angle, sedtExpand.Value, True, False);
    KnifeW2 := CreatePattern(OriginalPoints, Angle, sedtExpand.Value, True, True);
  end;

  NewKnife := True;
end;

procedure TfmLayplan.btnW2Click(Sender: TObject);
var
  BestInterlock: TInterlock;
  s: string;

begin
  InterlockType := rgAutoTransfer.itemIndex;

  FileNumber := 0;
  BestInterlock := FindInterlock(Knife, KnifeW2, KnivesUsed[0, 0], (Length(CutResults) = 0), cbOriginalHullTakeOut.Checked, OriginalKnifeNow, cbButt.Checked, cbLeft.Checked, cbRight.Checked, cbTop.Checked, cbBottom.Checked, (not cbLeather.Checked), cbSpeedRotate.Checked, TOLERANCE);
  if cbLeather.Checked then
    BestInterlock.Size := BestInterlock.Size / 2;

  if BestInterlock.Found then
  begin
    UpdateResults(BestInterlock, KnifeW2);
    DisplayResults(0, 0, False);

    str(BestInterlock.Size : 7 : 3, s);
    lblPrimeInterlockArea.Caption := s;
  end
  else
    messagedlg('No Soln', mtInformation, [mbOk], 0);
end;

procedure TfmLayplan.btnGangClick(Sender: TObject);
var
  i, Concavity, NoConcavities, NoValidConcavities, ValidConcavity: integer;
  HoldKnife1, HoldKnife2, MaskKnife1, MaskKnife2: TPointArray;
  Knife2: TPattern;
  Interlock: TInterlock;
  Concavities: TConcavityBoundsArray;
  Merge: TMerge;

begin
  InterlockType := rgAutoTransfer.itemIndex;
  Concavity := StrToInt(eConcavityNumber.Text);
  if Concavity > 0 then
  begin
    GetConcavityBounds(Knife.ExpandedPoints, Knife.ConvexHull, True, 0, NoValidConcavities, Concavities);
    NoConcavities := Length(Concavities);

    application.processmessages;

    CurrentKnife := 0;

    //Find the interlock for concavity at 0 degrees
    Knife2 := KnifeW2;

    HoldKnife1 := copy(Knife.ExpandedPoints);
    HoldKnife2 := copy(Knife2.ExpandedPoints);

    ValidConcavity := 0;

    LayPlanInitialise(0, False);
    Knife2 := KnifeW2;

    SingleConcavityOpen(Concavity - 1, Concavities, MaskKnife1, MaskKnife2);

    Knife.ExpandedPoints := copy(MaskKnife1);
    Knife2.ExpandedPoints := copy(MaskKnife2);

    FileNumber := 0;
    Interlock := FindInterlock(Knife, Knife2, KnivesUsed[0, 0], (Length(CutResults) = 0), False, OriginalKnifeNow, False, False, False, False, False, True, True, InterlockingToleranceLayplans);

    if Interlock.Found then
    begin
{      Knife.ExpandedPoints := copy(HoldKnife1);
      Knife2.ExpandedPoints := copy(HoldKnife2);

      Merge := MergePatterns(Knife, Knife2, Interlock, False);}

      UpdateResults(Interlock, KnifeW2);
      for i := 0 to Length(CutResults) - 1 do
        CutResults[i].KnifeNo := 1;

      DisplayResults(0, 0, False);
    end;
  end;
end;

procedure TfmLayplan.cbOriginalHullTakeOutClick(Sender: TObject);
begin
  if cbOriginalHullTakeOut.Checked then
    cbSpeedRotate.Checked := False;
end;

procedure TfmLayplan.cbSpeedRotateClick(Sender: TObject);
begin
  if cbSpeedRotate.Checked then
    cbOriginalHullTakeOut.Checked := False;
end;

procedure TfmLayplan.cbTrueSizeClick(Sender: TObject);
begin
  fmDebugger.TrueSize := cbTrueSize.Checked;
end;

procedure TfmLayplan.btnAllKnives2Click(Sender: TObject);
var
  OriginalPoints: TPointArray;
  NumPoints, Tolerance: integer;

begin
  RemH := 0;
  RemW := 0;

  fmAllPatterns.ShowModal;

  tblKnives.Open;
  tblKnives.FindKey([fmAllPatterns.KnifeCode, fmAllPatterns.KnifeScale, fmAllPatterns.KnifeSize]);
//  if not(tblKnivesManualEntry.Value) then
  begin
    OriginalPoints := ReadPattern(tblKnivesCode.Value, tblKnivesMeasuredSize.Value);

    SetLength(KeepPoints, Length(OriginalPoints));
    KeepPoints := Copy(OriginalPoints);

    NumPoints := Length(OriginalPoints);
    Tolerance := 0;
    while (NumPoints > 100) do
    begin
      Tolerance := Tolerance + 1;
      NumPoints := PolySimplifyInt2D(Tolerance, KeepPoints, OriginalPoints);
      SetLength(OriginalPoints, NumPoints);
    end;

    KnifeW1 := CreatePattern(OriginalPoints, sedtAngle2.value, sedtExpand.Value, True, False);
    DrawBitmap(KnifeW1, imgKnifeW1);
    KnifeW2 := CreatePattern(OriginalPoints, sedtAngle2.value, sedtExpand.Value, True, True);
    DrawBitmap(KnifeW2, imgKnifeW2);

    inc(CurrentKnife);
    SetLength(KnivesUsed, CurrentKnife);
    KnivesUsed[CurrentKnife - 1, 0] := KnifeW1;
    KnivesUsed[CurrentKnife - 1, 1] := KnifeW2;

    NewKnife := True;
  end;
//  else
//    messagedlg('This is a manual knife', mtInformation, [mbOK], 0);

  gbKnifeW2.Caption := 'Knife: ' + tblKnivesCode.Value;
  tblKnives.Close;
end;

procedure TfmLayplan.btnCancelClick(Sender: TObject);
begin
  LeatherCancel := True;
end;

procedure TfmLayplan.btnCopyAngleClick(Sender: TObject);
begin
  sedtAngle2.value := sedtAngle.Value;
end;

procedure TfmLayplan.FormCreate(Sender: TObject);
begin
  SetLength(KnivesUsed, 0);
  CurrentKnife := 0;
  NewKnife := False;
  qParameters.Open;
  DisplayScale := 1;

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
end;

procedure TfmLayplan.btnSATRASummLeatherClick(Sender: TObject);
var
  FirstInterlock, Complete: Boolean;
  NettArea, GrossArea, PrimeInterlockArea, NonPrimeInterlockArea, InterlockArea: Real;
  BestInterlockW1, BestInterlockW2: TInterlock;
  W2Taken: Boolean;
  s: string;

begin
  btnSATRASummLeather.enabled := False;
  btnStep.enabled := True;
  btnFinish.enabled := True;
  btnCancel.enabled := True;
  btnSynthetics.enabled := False;

  rgAutoTransfer.ItemIndex := REPEATED_SINGLE_INTERLOCK;
  InterlockType := REPEATED_SINGLE_INTERLOCK;
  cbLeft.Checked := False;
  cbTop.Checked := False;
  cbRight.Checked := False;
  cbBottom.Checked := False;
  cbOriginalHullTakeOut.Checked := True;
  cbButt.Checked := False;
  cbLeather.Checked := True;

  FirstInterlock := True;
  Complete := False;

  PrimeInterlockArea := 0;
  NonPrimeInterlockArea := 0;

  LeatherStep := True;
  LeatherFinish := False;
  LeatherCancel := False;

  W2Taken := False;
  while not (Complete or LeatherCancel) do
  begin
    FileNumber := 0;
    if not W2Taken then
      BestInterlockW1 := FindInterlock(Knife, KnifeW1, KnivesUsed[0, 0], (Length(CutResults) = 0), cbOriginalHullTakeOut.Checked, OriginalKnifeNow, cbButt.Checked, cbLeft.Checked, cbRight.Checked, cbTop.Checked, cbBottom.Checked, (not cbLeather.Checked), cbSpeedRotate.Checked, TOLERANCE)
    else
    begin
      BestInterlockW1.Found := False;
      BestInterlockW1.Size := 0;
    end;
    BestInterlockW2 := FindInterlock(Knife, KnifeW2, KnivesUsed[0, 0], (Length(CutResults) = 0), cbOriginalHullTakeOut.Checked, OriginalKnifeNow, cbButt.Checked, cbLeft.Checked, cbRight.Checked, cbTop.Checked, cbBottom.Checked, (not cbLeather.Checked), cbSpeedRotate.Checked, TOLERANCE);
    BestInterlockW2.Size := BestInterlockW2.Size / 2;

    if (not BestInterlockW1.Found) and (not BestInterlockW2.Found) then
      Complete := True
    else
    begin
      InterlockArea := max(BestInterlockW1.Size, BestInterlockW2.Size);
      if FirstInterlock then
      begin
        PrimeInterlockArea := InterlockArea;
        NonPrimeInterlockArea := (0.8 * InterlockArea);
        FirstInterlock := False;
      end
      else
      begin
        PrimeInterlockArea := PrimeInterlockArea + (0.5 * InterlockArea);
        NonPrimeInterlockArea := NonPrimeInterlockArea + (0.5 * InterlockArea);
      end;

      if BestInterlockW1.Size > BestInterlockW2.Size then
        UpdateResults(BestInterlockW1, KnifeW1)
      else
      begin
        UpdateResults(BestInterlockW2, KnifeW2);
        W2Taken := True;
      end;
    end;
  end;

//  NettArea := KnivesUsed[0, 0].NettArea;
//  GrossArea := KnivesUsed[0, 0].GrossArea;
  PrimeInterlockArea := GrossArea - PrimeInterlockArea;
  NonPrimeInterlockArea := GrossArea - NonPrimeInterlockArea;

  //SATRASumm Leather Results
  str(NettArea : 7 : 3, s);
  lblNettArea.Caption := s;
  str(GrossArea : 7 : 3, s);
  lblGrossArea.Caption := s;
  str(PrimeInterlockArea : 7 : 3, s);
  lblPrimeInterlockArea.Caption := s;
  str(NonPrimeInterlockArea : 7 : 3, s);
  lblNonPrimeInterlockArea.Caption := s;

  SetCutResultsColour;
  DisplayResults(0, 0, False);

  if LeatherCancel then
    messagedlg('Aborted', mtInformation, [mbOk], 0);

  btnStep.enabled := False;
  btnFinish.enabled := False;
  btnCancel.enabled := False;
end;

procedure TfmLayplan.btnDrawClick(Sender: TObject);
begin
  DisplayResults(RemH, RemW, False);
end;

procedure TfmLayplan.btnDrawInterlockClick(Sender: TObject);
var
  Knife1, Knife2, OriginalKnife: TPattern;
  FirstInterlock, OriginalHullTakeOut: Boolean;
  OriginalKnifeNow: TPoint;
  Butt, StopLeft, StopRight, StopTop, StopBottom, Layplanning, LayPlanSpeedUp: Boolean;
  InterlockZero: integer;
  f: TextFile;
  i, NP: integer;
  TempString: string;
  LeftsPattern, RightsPattern: TSideEdges;

begin
  FileNumber := -1;
  if odFullInterlockFile.Execute then
  begin
    Assignfile(f, odFullInterlockFile.FileName);
    reset(f);
    readln(f, Knife1.Height);
    readln(f, Knife1.Width);
    readln(f, NP);
    SetLength(Knife1.PatternPoints, NP);
    for i := 0 to NP - 1 do
      readln(f, Knife1.PatternPoints[i].X, Knife1.PatternPoints[i].Y);
    readln(f, NP);
    SetLength(Knife1.ExpandedPoints, NP);
    for i := 0 to NP - 1 do
      readln(f, Knife1.ExpandedPoints[i].X, Knife1.ExpandedPoints[i].Y);
    readln(f, NP);
    SetLength(Knife1.ConvexHull, NP);
    for i := 0 to NP - 1 do
      readln(f, Knife1.ConvexHull[i].X, Knife1.ConvexHull[i].Y);
    readln(f, NP);
    SetLength(Knife1.ButtOctogan, NP);
    for i := 0 to NP - 1 do
      readln(f, Knife1.ButtOctogan[i].X, Knife1.ButtOctogan[i].Y);
    readln(f, NP);
    SetLength(Knife1.ButtSquare, NP);
    for i := 0 to NP - 1 do
      readln(f, Knife1.ButtSquare[i].X, Knife1.ButtSquare[i].Y);
    readln(f, Knife1.PatternNettArea);
    readln(f, Knife1.ExpandedNettArea);
    readln(f, Knife1.ExpandedGrossArea);
    readln(f, TempString);
    Knife1.W2 := (TempString = 'TRUE');
    readln(f);
    readln(f, Knife2.Height);
    readln(f, Knife2.Width);
    readln(f, NP);
    SetLength(Knife2.PatternPoints, NP);
    for i := 0 to NP - 1 do
      readln(f, Knife2.PatternPoints[i].X, Knife2.PatternPoints[i].Y);
    readln(f, NP);
    SetLength(Knife2.ExpandedPoints, NP);
    for i := 0 to NP - 1 do
      readln(f, Knife2.ExpandedPoints[i].X, Knife2.ExpandedPoints[i].Y);
    readln(f, NP);
    SetLength(Knife2.ConvexHull, NP);
    for i := 0 to NP - 1 do
      readln(f, Knife2.ConvexHull[i].X, Knife2.ConvexHull[i].Y);
    readln(f, NP);
    SetLength(Knife2.ButtOctogan, NP);
    for i := 0 to NP - 1 do
      readln(f, Knife2.ButtOctogan[i].X, Knife2.ButtOctogan[i].Y);
    readln(f, NP);
    SetLength(Knife2.ButtSquare, NP);
    for i := 0 to NP - 1 do
      readln(f, Knife2.ButtSquare[i].X, Knife2.ButtSquare[i].Y);
    readln(f, Knife2.PatternNettArea);
    readln(f, Knife2.ExpandedNettArea);
    readln(f, Knife2.ExpandedGrossArea);
    readln(f, TempString);
    Knife2.W2 := (TempString = 'TRUE');
    readln(f);
    readln(f, OriginalKnife.Height);
    readln(f, OriginalKnife.Width);
    readln(f, NP);
    SetLength(OriginalKnife.PatternPoints, NP);
    for i := 0 to NP - 1 do
      readln(f, OriginalKnife.PatternPoints[i].X, OriginalKnife.PatternPoints[i].Y);
    readln(f, NP);
    SetLength(OriginalKnife.ExpandedPoints, NP);
    for i := 0 to NP - 1 do
      readln(f, OriginalKnife.ExpandedPoints[i].X, OriginalKnife.ExpandedPoints[i].Y);
    readln(f, NP);
    SetLength(OriginalKnife.ConvexHull, NP);
    for i := 0 to NP - 1 do
      readln(f, OriginalKnife.ConvexHull[i].X, OriginalKnife.ConvexHull[i].Y);
    readln(f, NP);
    SetLength(OriginalKnife.ButtOctogan, NP);
    for i := 0 to NP - 1 do
      readln(f, OriginalKnife.ButtOctogan[i].X, OriginalKnife.ButtOctogan[i].Y);
    readln(f, NP);
    SetLength(OriginalKnife.ButtSquare, NP);
    for i := 0 to NP - 1 do
      readln(f, OriginalKnife.ButtSquare[i].X, OriginalKnife.ButtSquare[i].Y);
    readln(f, OriginalKnife.PatternNettArea);
    readln(f, OriginalKnife.ExpandedNettArea);
    readln(f, OriginalKnife.ExpandedGrossArea);
    readln(f, TempString);
    OriginalKnife.W2 := (TempString = 'TRUE');
    readln(f);
    readln(f, TempString);
    firstInterlock := (TempString = 'TRUE');
    readln(f, TempString);
    OriginalHullTakeOut := (TempString = 'TRUE');
    readln(f, OriginalKnifeNow.x, OriginalKnifeNow.y);
    readln(f, TempString);
    Butt := (TempString = 'TRUE');
    readln(f, TempString);
    StopLeft := (TempString = 'TRUE');
    readln(f, TempString);
    StopRight := (TempString = 'TRUE');
    readln(f, TempString);
    StopTop := (TempString = 'TRUE');
    readln(f, TempString);
    StopBottom := (TempString = 'TRUE');
    readln(f, TempString);
    Layplanning := (TempString = 'TRUE');
    readln(f, TempString);
    LayPlanSpeedUp := (TempString = 'TRUE');
    readln(f, InterlockZero);

    Closefile(f);

    if (FileNumber = -1) then
      FindInterlock(Knife1, Knife2, OriginalKnife, FirstInterlock, OriginalHullTakeOut, OriginalKnifeNow,
                    Butt, StopLeft, StopRight, StopTop, StopBottom, Layplanning, LayPlanSpeedUp, InterlockZero);
  end;
end;

procedure TfmLayplan.btnFinishClick(Sender: TObject);
begin
  LeatherFinish := True;
end;

{procedure TfmCaller.btnSyntheticsClick(Sender: TObject);
var
  MaterialHeight, MaterialWidth, PatternHeight, PatternWidth,NumberOfPatterns,
  RemHeight, RemWidth: integer;
  StartLeft: Boolean;
  RemArea: real;
  Success: Boolean;
  LocalInterlock: TLocalInterlock;

begin
  btnSATRASummLeather.enabled := False;
  btnGoOn.enabled := False;
  btnSynthetics.enabled := False;

  screen.Cursor := crHourGlass;

  rgAutoTransfer.ItemIndex := GROUP_INTERLOCK;
  InterlockType := GROUP_INTERLOCK;
  cbOriginalHullTakeOut.checked := False;
  cbLeather.Checked := False;

  MaterialHeight := round(StrToFloat(eHeight.Text) * 1.0936 * 3 * 12000 / PATTERNRES);
  MaterialWidth := round(StrToFloat(eWidth.Text) * 1.0936 * 3 * 12000 / PATTERNRES);
  PatternHeight := KnivesUsed[CurrentKnife - 1, 0].Height;
  PatternWidth := KnivesUsed[CurrentKnife - 1, 0].Width;

  LocalInterlock.Used := False;
  Success := Plan(MaterialHeight, MaterialWidth, PatternHeight, PatternWidth, PackNo(rgRecipe.itemIndex + 1),
                  True, cbW2.Checked, cbFirstCutInCorner.Checked, cbForceW1Start.Checked, cbForceW2Start.Checked,
                  cbFixed.Checked, (rgStart.ItemIndex = 0), LocalInterlock, NumberOfPatterns, RemHeight,
                  RemWidth, RemArea, StartLeft, TOLERANCE);

  if Success then
  begin
    DisplayResults(RemHeight, RemWidth, True);

    label6.Caption := IntToStr(NumberOfPatterns);
  end;

  screen.Cursor := crDefault;
end;        }

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

function BoundingRectsAreSame(RectA, RectB: TRect): boolean;
begin
  if (RectA.Left = RectB.Left) and (RectA.Top = RectB.Top) and
     (RectA.Right = RectB.Right) and (RectA.Bottom = RectB.Bottom) then
    Result := True
  else
    Result := False;
end;

procedure TfmLayplan.btnSyntheticsClick(Sender: TObject);
const
  LI_None = 1;
  LI_W2 = 2;
  LI_W1 = 3;  //Don't actually bother with these, either repeats or stupid

var
  PackCode: string;
  MaterialLength, MaterialWidth, PatternHeight, PatternWidth, NumberOfPatterns, RemHeight, RemWidth,
  UsableMaterialLength, UsableMaterialWidth: integer;
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
  Gangs: array of TInterlock;
  Merge: TMerge;
  Capability, BasicComplexity: integer;
  Vec1x, Vec1y: integer;
  SquarePacks, OffsetPacks, DiagonalPacks, DiagonalFreePacks: Boolean;
  SquareGangs, OffsetGangs, DiagonalGangs, DiagonalFreeGangs: Boolean;
  OffsetGangsInverted, DiagonalVerticalPacks, DiagonalGangsInverted: Boolean;
  sNoOfLayPlans, sAngle: string;
  TrimRowCount: integer;
  LargePatternToMaterialRatio, TooBigPatternToMaterialRatio: Boolean;

begin
  screen.cursor := crHourGlass;

  MaterialLength := round(StrToFloat(eHeight.Text) * 1.0936 * 3 * 12000 / PATTERNRES);
  MaterialWidth := round(StrToFloat(eWidth.Text) * 1.0936 * 3 * 12000 / PATTERNRES);
  UsableMaterialLength := round(StrToFloat(eHeight.Text) * 1.0936 * 3 * 12000 / PATTERNRES);
  UsableMaterialWidth := round(StrToFloat(eWidth.Text) * 1.0936 * 3 * 12000 / PATTERNRES);
  PatternHeight := KnivesUsed[CurrentKnife - 1, 0].Height;
  PatternWidth := KnivesUsed[CurrentKnife - 1, 0].Width;

  case rgRecipe.ItemIndex of
    0: Pack := SQUARE_HORIZONTAL;
    1: Pack := SQUARE_HORIZONTAL_P2_INVERTED;
    2: Pack := SQUARE_VERTICAL;
    3: Pack := SQUARE_VERTICAL_P2_INVERTED;
    4: Pack := OFFSET_HORIZONTAL_TOP;
    5: Pack := OFFSET_HORIZONTAL_BOTTOM;
    6: Pack := OFFSET_HORIZONTAL_P2_INVERTED;
    7: Pack := OFFSET_VERTICAL_LEFT;
    8: Pack := OFFSET_VERTICAL_RIGHT;
    9: Pack := OFFSET_VERTICAL_P2_INVERTED;
    10: Pack := DIAGONAL_HORIZONTAL;
    11: Pack := DIAGONAL_HORIZONTAL_P2_INVERTED;
    12: Pack := DIAGONAL_VERTICAL;
    13: Pack := DIAGONAL_VERTICAL_P2_INVERTED;
    14: Pack := DIAGONAL_FREE;
  end;

  LayPlanInitialise(0, False);

//  ShowGangs := (rgShowGangs.ItemIndex = 0);
  ShowGangs := True;

  //Check if Knife/Material ratio large
  LargePatternToMaterialRatio := False;
  if max(Knife.Height, Knife.Width) >= (min(UsableMaterialLength, UsableMaterialWidth) / 4) then
    LargePatternToMaterialRatio := True;

  LayPlanInitialise(0, False);

  MaterialAreaM2 := (MaterialLength / (1000 div PATTERNRES) * 0.0254) *
                    (MaterialWidth / (1000 div PATTERNRES) * 0.0254);

  GetConcavityBounds(Knife.ExpandedPoints, Knife.ConvexHull, True, 0, NoValidConcavities, Concavities);
  NoConcavities := Length(Concavities);

  application.processmessages;

  CurrentKnife := 0;

  //Find the interlock for each concavity at 0 degrees
  Knife2 := KnifeW2;

  HoldKnife1 := copy(Knife.ExpandedPoints);
  HoldKnife2 := copy(Knife2.ExpandedPoints);
  //Not yet doing a free interlock, just doing concavities 1..n open one at a time
  ValidConcavity := 0;
  FileNumber := 0;
  for Concavity := 1 to NoValidConcavities do
  begin
    LayPlanInitialise(0, False);
    Knife2 := KnifeW2;

    SingleConcavityOpen(Concavity - 1, Concavities, MaskKnife1, MaskKnife2);

    Knife.ExpandedPoints := copy(MaskKnife1);
    Knife2.ExpandedPoints := copy(MaskKnife2);

    Interlock := FindInterlock(Knife, Knife2, Knife, True, False, OriginalKnifeNow, False, False, False, False, False, True, True, InterlockingToleranceLayplans);

    if Interlock.Found then
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

  //Can not start with 2nd part of gang if there are no concavities
  if NoValidConcavities = 0 then
    NoPatternStarts := 1;

  Concavity := 0;
  if StrToInt(eConcavityNumber.Text) <= NoValidConcavities then
    Concavity := StrToInt(eConcavityNumber.Text);

  DiagonalFreePacks := (Pack = DIAGONAL_FREE);

  NoPlans := 1;

  //Pre process packs for Diagonal Free as the PACKS
  //will be the same at every angle that we might use
  NoDiagonalFreePacks := 0;
  setlength(DiagonalFreePackResults, 0);
  if DiagonalFreePacks then
  begin
    NoDiagonalFreePacks := 2 + (NoValidConcavities);
    setlength(DiagonalFreePackResults, NoDiagonalFreePacks);

    LayPlanInitialise(0, False);
    AddToKnivesUsed(CurrentKnife);
    GetFreeAngle(PackAngle);

    LayPlanInitialise(PackAngle, False);
    AddToKnivesUsed(CurrentKnife);
    InitialisePackResults;

    Line2W2 := cbW2.Checked;

    Success := Plan(UsableMaterialLength, UsableMaterialWidth, Knife.Height, Knife.Width, DIAGONAL_VERTICAL, False, Line2W2,
                    (rgCornerAnchoring.ItemIndex = 0), False, False, (rgStartingCriteria.ItemIndex = 1),
                    (rgStartingSide.ItemIndex = 0), LocalInterlock,
                    NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft, InterlockingToleranceLayplans);

    ActualPackAngle := PackAngle;

    if Line2W2 then
      CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, ActualPackAngle, DiagonalFreePackResults[1])
    else
      CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, ActualPackAngle, DiagonalFreePackResults[0]);

    //Not yet doing a free interlock, just do chosen concavity interlock
    if Concavity > 0 then
    begin
      LayPlanInitialise(0, False);
      Knife2 := KnifeW2;

      SingleKnifeHeight := Knife.Height;
      SingleKnifeWidth := Knife.Width;

      HoldKnife1 := Copy(Knife.ExpandedPoints);
      HoldKnife2 := Copy(Knife2.ExpandedPoints);

      Interlock := Gangs[Concavity - 1];

      UpdateSyntheticResults(Interlock, Knife2, False, False);
      GetFreeAngle(PackAngle);

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
      Success := Plan(UsableMaterialLength, UsableMaterialWidth, Knife.Height, Knife.Width, DIAGONAL_VERTICAL, False, Line2W2,
                      (rgCornerAnchoring.ItemIndex = 0), False, False, (rgStartingCriteria.ItemIndex = 1),
                      (rgStartingSide.ItemIndex = 0), LocalInterlock,
                       NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft, InterlockingToleranceLayplans);

      ActualPackAngle := PackAngle;
      CopyToPackResult(Knife, KnifeW1, KnifeW2, LocalInterlock, ActualPackAngle, DiagonalFreePackResults[Concavity + 1]);
    end;
  end;

  PlanNo := 0;
//  Angle := 0;
  Angle := StrToFloat(sedtAngle.Text);
  if rbNone.Checked then  
    PatternStart := 1
  else if rbGangs2.Checked then
    PatternStart := 2
  else if rbGangs3.Checked then
    PatternStart := 3;

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

    //Single knife at the correct angle
    AddToKnivesUsed(CurrentKnife);

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
    LocalInterlock.SingleKnifeNo := CurrentKnife;
    RelativePositionLocalInterlockPatterns(LocalInterlock);

    NewKnife := True;
    setLength(CutResults, 0);
  end;

  AddToKnivesUsed(CurrentKnife);
  InitialisePackResults;

  //Check whether the knife (or gang) is too
  //big for one to fit at the current angle
  TooBigPatternToMaterialRatio := ((Knife.Height > UsableMaterialLength) or (Knife.Width > UsableMaterialWidth));

  //Decide which 'Paired' packs to try
  if ((Concavity > 1) and (PatternStart = LI_NONE)) or
     ((Concavity = 1) and (PatternStart <> LI_NONE) and (NoValidConcavities = 0)) then
    Pack := NONE;

  if (Pack = NONE) then
    DoPack := False
  else
    DoPack := True;

  if DoPack then
  begin
    NumberOfPatterns := 0;
    setlength(CutResults, 0);

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
          if (not cbW2.Checked) then
            CopyFromPackResult(Knife, KnifeW1, KnifeW2, LIToUse, PackAngle, DiagonalFreePackResults[0])
          else
            CopyFromPackResult(Knife, KnifeW1, KnifeW2, LIToUse, PackAngle, DiagonalFreePackResults[1]);
        end
        else if PatternStart = LI_W2 then
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, LIToUse, PackAngle, DiagonalFreePackResults[1 + Concavity]);

        ActualPackAngle := PackAngle - StrToFloat(sedtAngle.Text);
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

        if Vec1y = 0 then
          PropogateHorizontalDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                      (rgStartingCriteria.ItemIndex = 1), (rgStartingSide.ItemIndex = 0), cbW2.Checked, (rgCornerAnchoring.ItemIndex = 0),
                                      LocalInterlock,
                                      NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft)
        else if Vec1x = 0 then
          PropogateVerticalDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                    (rgStartingCriteria.ItemIndex = 1), (rgStartingSide.ItemIndex = 0), cbW2.Checked, (rgCornerAnchoring.ItemIndex = 0),
                                    LocalInterlock,
                                    NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft)
       else
          PropogateFreeDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                (rgStartingCriteria.ItemIndex = 1), (rgStartingSide.ItemIndex = 0), cbW2.Checked, (rgCornerAnchoring.ItemIndex = 0),
                                LocalInterlock, ActualPackAngle,
                                NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft);

        Success := True;
      end
      else
        Success := Plan(UsableMaterialLength, UsableMaterialWidth, Knife.Height, Knife.Width, Pack, True, cbW2.Checked,
                        (rgCornerAnchoring.ItemIndex = 0), False, False, (rgStartingCriteria.ItemIndex = 1),
                        (rgStartingSide.ItemIndex = 0), LocalInterlock,
                        NumberOfPatterns, RemHeight, RemWidth, RemArea, StartLeft, InterlockingToleranceLayplans);
    end
    else
      Success := False;
  end;

  if Success then
  begin
    DisplayResults(RemHeight, RemWidth, True);
    RemH := RemHeight;
    RemW := RemWidth;

    lblNumPats.Caption := IntToStr(NumberOfPatterns);
  end;
  screen.cursor := crDefault;
end;

procedure TfmLayplan.DrawBitmap(Pattern: TPattern;
                               var imgKnf: TImage);

var
  bmpPicture: TBitmap;

begin
  bmpPicture := TBitmap.Create;
  bmpPicture.PixelFormat := pf4Bit;
  bmpPicture.Height := Pattern.Height;
  bmpPicture.Width := Pattern.Width;
  bmpPicture.Transparent := True;

  bmpPicture.Canvas.pen.Color := clGreen;
  bmpPicture.Canvas.brush.color := clGreen;
  bmpPicture.Canvas.Polygon(Pattern.ExpandedPoints);

  imgKnf.Picture.Bitmap := bmpPicture;

  bmpPicture.Free;
end;

procedure TfmLayplan.btnDebugClick(Sender: TObject);
begin
  fmDebugger.visible := True;
end;

procedure TfmLayplan.btnDescribeClick(Sender: TObject);
var
  f: TextFile;
  Points, RotPoints: TPointArray;
  LeftsPattern, RightsPattern: TSideEdges;
  i, j, maxx, maxy, No, NumPts, x, y: integer;

begin
  if odDescribe.Execute then
  begin
    AssignFile(f, odDescribe.FileName);
    Reset(f);
    Readln(f, NumPts);
    SetLength(Points, NumPts);
    for i := 0 to NumPts - 1 do
     Readln(f, Points[i].X, Points[i].Y);
    CloseFile(f);

    if cbSpeedRotate.Checked then
    begin
      j := Length(Points);
      SetLength(RotPoints, j);
      for i := 0 to Length(Points) - 1 do
      begin
        dec(j);
        x := Points[i].x;
        y := Points[i].y;
        RotPoints[j].x := y;
        RotPoints[j].y := x;
      end;

      for i := 0 to Length(Points) - 1 do
      begin
        Points[i].x := RotPoints[i].x;
        Points[i].y := RotPoints[i].y;
      end;
    end;

    DescribePattern(Points, LeftsPattern, RightsPattern, maxx, maxy, No);

    fmDebugger.DrawDescribedPattern(Points, LeftsPattern, RightsPattern);
  end;
end;

function TfmLayplan.PackNo(No: integer): integer;
begin
  case No of
    1: PackNo := SQUARE_HORIZONTAL;
    2: PackNo := SQUARE_HORIZONTAL_P2_INVERTED;
    3: PackNo := SQUARE_VERTICAL;
    4: PackNo := SQUARE_VERTICAL_P2_INVERTED;
    5: PackNo := OFFSET_HORIZONTAL_TOP;
    6: PackNo := OFFSET_HORIZONTAL_BOTTOM;
    7: PackNo := OFFSET_HORIZONTAL_P2_INVERTED;
    8: PackNo := OFFSET_VERTICAL_LEFT;
    9: PackNo := OFFSET_VERTICAL_RIGHT;
    10: PackNo := OFFSET_VERTICAL_P2_INVERTED;
    11: PackNo := DIAGONAL_HORIZONTAL;
    12: PackNo := DIAGONAL_HORIZONTAL_P2_INVERTED;
    13: PackNo := DIAGONAL_VERTICAL;
    14: PackNo := DIAGONAL_VERTICAL_P2_INVERTED;
  end;
end;

procedure TfmLayplan.seDebuggerZoomChange(Sender: TObject);
begin
  fmDebugger.Zoom := seDebuggerZoom.value;
end;

procedure TfmLayplan.qParametersAfterOpen(DataSet: TDataSet);
begin
  InterlockingToleranceInterlock := qParametersInterlockingToleranceInterlock.value;
  InterlockingToleranceLayplans := qParametersInterlockingToleranceLayplans.value;
end;

procedure TfmLayplan.rbGangsClick(Sender: TObject);
begin
  lblConcavityNumber.Enabled := True;
  eConcavityNumber.Enabled := True;
  eConcavityNumber.Text := '1';
end;

procedure TfmLayplan.rbNoneClick(Sender: TObject);
begin
  lblConcavityNumber.Enabled := False;
  eConcavityNumber.Enabled := False;
  eConcavityNumber.Text := '0';  
end;

procedure TfmLayplan.btnDiagonalFreeAngleClick(Sender: TObject);
const
  Fudge = 0.1;

var
  BestInterlock: TInterlock;
  OneIsLeft, OneIsTop: boolean;
  KeepPoints: TPointArray;
  s: string;
  Angle: real;

begin
  FileNumber := 0;
  BestInterlock := FindInterlock(Knife, KnifeW1, KnivesUsed[CurrentKnife - 1, 0], (Length(CutResults) = 0), False,
                                 OriginalKnifeNow, False, False, False, False, False, True, True, TOLERANCE);

  if BestInterlock.Knife1BoundingRect.Top < BestInterlock.Knife2BoundingRect.Top then
    OneIsTop := True
  else
    OneIsTop := False;

  if BestInterlock.Knife1BoundingRect.Left < BestInterlock.Knife2BoundingRect.Left then
    OneIsLeft := True
  else
    OneIsLeft := False;

  //Calculate required angle of rotation
  if OneIsTop then
    Angle := VertexAngle(BestInterlock.Knife1BoundingRect.Left, BestInterlock.Knife1BoundingRect.Bottom,
                         BestInterlock.Knife1BoundingRect.Left, BestInterlock.Knife1BoundingRect.Top,
                         BestInterlock.Knife2BoundingRect.Left, BestInterlock.Knife2BoundingRect.Top)
  else
    Angle := VertexAngle(BestInterlock.Knife2BoundingRect.Left, BestInterlock.Knife2BoundingRect.Bottom,
                         BestInterlock.Knife2BoundingRect.Left, BestInterlock.Knife2BoundingRect.Top,
                         BestInterlock.Knife1BoundingRect.Left, BestInterlock.Knife1BoundingRect.Top);

  if (OneIsTop and (not OneIsLeft)) or ((not OneIsTop) and OneIsLeft) then
    Angle := -Angle;

  //Adjustment of Angle to ensure
  //enough room to butt successfully
  if Angle > 0 then
  begin
    Angle := Angle - Fudge;
    if Angle < 0 then
      Angle := 0;
  end
  else if Angle < 0 then
  begin
    Angle := Angle + Fudge;
    if Angle > 0 then
      Angle := 0;
  end;

  str(Angle : 5 : 2, s);
  lblGetDiagonalFreeAngle.Caption := s;
  lblGetDiagonalFreeAngle.Visible := True;
end;

procedure TfmLayplan.btnStepClick(Sender: TObject);
begin
  LeatherStep := True;
end;

procedure TfmLayplan.tblKnivesCalcFields(DataSet: TDataSet);
var
  Prime, NonPrime: real;

begin
  DoCalc(Prime, NonPrime);
  if (tblKnifeSetsType.Value = 'N') then
  begin
    tblKnivesOldInterlockArea.Value := tblKnivesInterlockAreaNonPrime.Value;
    tblKnivesNewInterlockArea.Value := NonPrime;
  end
  else
  begin
    tblKnivesOldInterlockArea.Value := tblKnivesInterlockAreaPrimeSynthetic.Value;
    tblKnivesNewInterlockArea.Value := Prime;
  end;
end;

procedure TfmLayplan.DoCalc(var PrimeInterlockArea, NonPrimeInterlockArea: real);
var
  FirstInterlock, Complete: Boolean;
  NettArea, GrossArea, InterlockArea: Real;
  BestInterlockW1, BestInterlockW2: TInterlock;
  W2Taken: Boolean;
  NumPoints, Tolerance: integer;

begin
  tblKnifeSets.FindKey([tblKnivesCode.Value]);
  if not(tblKnifeSetsManualEntry.Value) then
  begin
      //Initialise Results
    SetLength(CutResults, 0);
    InitialisePackResults;

    SetLength(OriginalHullOverlaps, 0);

    OriginalPoints := ReadPattern(tblKnivesCode.Value, tblKnivesMeasuredSize.Value);

    SetLength(KeepPoints, Length(OriginalPoints));
    KeepPoints := Copy(OriginalPoints);

    NumPoints := Length(OriginalPoints);
    Tolerance := 0;
    while (NumPoints > 100) do
    begin
      Tolerance := Tolerance + 1;
      NumPoints := PolySimplifyInt2D(Tolerance, KeepPoints, OriginalPoints);
      SetLength(OriginalPoints, NumPoints);
    end;

    Knife := CreatePattern(OriginalPoints, sedtAngle.value, sedtExpand.Value, True, False);
    KnifeW1 := CreatePattern(OriginalPoints, sedtAngle2.value, sedtExpand.Value, True, False);
    KnifeW2 := CreatePattern(OriginalPoints, sedtAngle2.value, sedtExpand.Value, True, True);

    //Always First knife when loaded here
    CurrentKnife := 1;
    SetLength(KnivesUsed, CurrentKnife);
    KnivesUsed[CurrentKnife - 1, 0] := KnifeW1;
    KnivesUsed[CurrentKnife - 1, 1] := KnifeW2;

    NewKnife := True;
  end;

  //Do Interlocking
  rgAutoTransfer.ItemIndex := REPEATED_SINGLE_INTERLOCK;
  InterlockType := REPEATED_SINGLE_INTERLOCK;
  cbLeft.Checked := False;
  cbTop.Checked := False;
  cbRight.Checked := False;
  cbBottom.Checked := False;
  cbOriginalHullTakeOut.Checked := True;
  cbButt.Checked := False;
  cbLeather.Checked := True;

  FirstInterlock := True;
  Complete := False;

  PrimeInterlockArea := 0;
  NonPrimeInterlockArea := 0;

  FileNumber := 0;
  W2Taken := False;
  while not Complete do
  begin
    if not W2Taken then
      BestInterlockW1 := FindInterlock(Knife, KnifeW1, KnivesUsed[0, 0], (Length(CutResults) = 0), cbOriginalHullTakeOut.Checked, OriginalKnifeNow, cbButt.Checked, cbLeft.Checked, cbRight.Checked, cbTop.Checked, cbBottom.Checked, (not cbLeather.Checked), cbSpeedRotate.Checked, TOLERANCE)
    else
    begin
      BestInterlockW1.Found := False;
      BestInterlockW1.Size := 0;
    end;
    BestInterlockW2 := FindInterlock(Knife, KnifeW2, KnivesUsed[0, 0], (Length(CutResults) = 0), cbOriginalHullTakeOut.Checked, OriginalKnifeNow, cbButt.Checked, cbLeft.Checked, cbRight.Checked, cbTop.Checked, cbBottom.Checked, (not cbLeather.Checked), cbSpeedRotate.Checked, TOLERANCE);
    BestInterlockW2.Size := BestInterlockW2.Size / 2;

    if (not BestInterlockW1.Found) and (not BestInterlockW2.Found) then
      Complete := True
    else
    begin
      InterlockArea := max(BestInterlockW1.Size, BestInterlockW2.Size);
      if FirstInterlock then
      begin
        PrimeInterlockArea := InterlockArea;
        NonPrimeInterlockArea := (0.8 * InterlockArea);
        FirstInterlock := False;
      end
      else
      begin
        PrimeInterlockArea := PrimeInterlockArea + (0.5 * InterlockArea);
        NonPrimeInterlockArea := NonPrimeInterlockArea + (0.5 * InterlockArea);
      end;

      if BestInterlockW1.Size > BestInterlockW2.Size then
        UpdateResults(BestInterlockW1, KnifeW1)
      else
      begin
        UpdateResults(BestInterlockW2, KnifeW2);
        W2Taken := True;
      end;
    end;
  end;

//  NettArea := KnivesUsed[0, 0].NettArea;
//  GrossArea := KnivesUsed[0, 0].GrossArea;
  PrimeInterlockArea := GrossArea - PrimeInterlockArea;
  NonPrimeInterlockArea := GrossArea - NonPrimeInterlockArea;
end;

procedure TfmLayplan.SetCutResultsColour;
var
  i: integer;

begin
  if Length(CutResults) > 0 then
  begin
    CutResults[0].Colour := clMaroon;
    for i := 1 to Length(CutResults) - 1 do
    begin
      if CutResults[i].Ghost then
        CutResults[i].Colour := clWhite
      else
        CutResults[i].Colour := clSilver;
    end;
  end;
end;

procedure TfmLayplan.Hold;
begin
  SetCutResultsColour;
  DisplayResults(0, 0, False);
  if not LeatherFinish then
    LeatherStep := False;
  while not (LeatherStep or LeatherFinish or LeatherCancel) do
    application.processmessages;
end;

end.

