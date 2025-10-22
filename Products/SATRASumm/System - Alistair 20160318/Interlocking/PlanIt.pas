unit PlanIt;

interface

uses
  Windows, Math, Types, Interlocking, Const_Interlocking, General_Interlocking, Results,
  Merge, FastGeo, Graphics, SummsVars, CmnVars
  {$IFDEF DEBUGFULL}
  , Debugger
  {$ENDIF}
  ;

type
  TStep = record
    SearchInterlock, W2, Left, Right, Top, Bottom, Repeated, LastStep: Boolean;
  end;
  TStepsArray = array of TStep;
  TLineDetails = record
    Start, No: integer;
    W2Start: Boolean;
    ExtraHalfTopNo: integer;     //Probably do not need two sets (Top/Bottom and Left/Right)
    ExtraHalfBottomNo: integer;  //However it makes the code far more readable.
    ExtraHalfLeftNo: integer;
    ExtraHalfRightNo: integer;
  end;
  TLineDetailsFreeDiagonal = record
    Startx, Starty, No: integer;
    W2Start: Boolean;
    ExtraHalfTopNo: integer;
    ExtraHalfTopType: integer;
    ExtraHalfBottomNo: integer;
    ExtraHalfBottomType: integer;
  end;
  THPropogation = record
    PatternHeight, PatternWidth: integer;
    HorizontalBottom: Boolean;
    W2First: Boolean;
    NumberOfPatterns, NoInOddRow, NoInEvenRow, ColCount, RemainingWidth, RemainingHeight: integer;
    RemainingArea: real;
    AnchorRight, OffsetRight: Boolean;
    Vec1x, Vec2x, Vec3x, Vec3y, Vec4x, Vec4y: integer;
    LocalInterlock: TLocalInterlock;
    ExtraHalfOddRow, ExtraHalfEvenRow, ExtraHalfRow: Boolean;
    ExtraHalfOddRowStart, ExtraHalfEvenRowStart: Boolean;
  end;
  THDPropogation = record
    PatternHeight, PatternWidth: integer;
    SecondRowFirst: Boolean;
    ARows: array of TLineDetails;
    NumberOfPatterns, RemainingWidth, RemainingHeight: integer;
    RemainingArea: real;
    Vec1x, Vec3x, Vec3y, Vec4x, Vec4y: integer;
    LocalInterlock: TLocalInterlock;
    ExtraHalfRow: Boolean;
  end;
  THP2IPropogation = record
    PatternHeight, PatternWidth: integer;
    InvertToBegin, W2First: Boolean;
    NumberOfPatterns, NoInOddRow, NoInEvenRow, ColCount, RemainingWidth, RemainingHeight: integer;
    RemainingArea: real;
    Vec1x, Vec2x, Vec3x, Vec3y, Vec4x, Vec4y: integer;
  end;
  THP2IDPropogation = record
    PatternHeight, PatternWidth: integer;
    ARows: array of TLineDetails;
    NumberOfPatterns, RemainingWidth, RemainingHeight: integer;
    RemainingArea: real;
    Vec1x, Vec2x, Vec3x, Vec3y: integer;
  end;
  TVPropogation = record
    PatternHeight, PatternWidth: integer;
    VerticalRight: Boolean;
    NumberOfPatterns, NoInOddColumn, NoInEvenColumn, RowCount, RemainingWidth, RemainingHeight: integer;
    RemainingArea: real;
    Vec1y, Vec3x, Vec3y, Vec4x, Vec4y: integer;
    LocalInterlock: TLocalInterlock;
    ExtraHalfOddColumnTop, ExtraHalfEvenColumnTop, ExtraHalfColumn: Boolean;
    ExtraHalfOddColumnBottom, ExtraHalfEvenColumnBottom: Boolean;
  end;
  TVP2IPropogation = record
    PatternHeight, PatternWidth: integer;
    InvertToBegin, W2First: Boolean;
    NumberOfPatterns, NoInOddColumn, NoInEvenColumn, RowCount, RemainingWidth, RemainingHeight: integer;
    RemainingArea: real;
    Vec1y, Vec2y, Vec3x, Vec3y, Vec4x, Vec4y: integer;
  end;
  TVDPropogation = record
    PatternHeight, PatternWidth: integer;
    SecondColumnFirst: Boolean;
    AColumns: array of TLineDetails;
    NumberOfPatterns, RemainingWidth, RemainingHeight: integer;
    RemainingArea: real;
    Vec1y, Vec3x, Vec3y, Vec4x, Vec4y: integer;
    LocalInterlock: TLocalInterlock;
    ExtraHalfColumn: Boolean;
  end;
  TVP2IDPropogation = record
    PatternHeight, PatternWidth: integer;
    AColumns: array of TLineDetails;
    NumberOfPatterns, RemainingWidth, RemainingHeight: integer;
    RemainingArea: real;
    Vec1y, Vec2y, Vec3x, Vec3y: integer;
  end;
  TFDPropogation = record
    PatternHeight, PatternWidth: integer;
    SecondColumnFirst: Boolean;
    AColumns: array of TLineDetailsFreeDiagonal;
    NumberOfPatterns, RemainingWidth, RemainingHeight: integer;
    RemainingArea: real;
    Vec1x, Vec1y, Vec3x, Vec3y, Vec4x, Vec4y: integer;
    LocalInterlock: TLocalInterlock;
    FirstBackFillColumnNo: integer;
  end;
  TCompleteCutResult = record
    Calculated: Boolean;
    Knife, KnifeW1, KnifeW2: TPattern;
    CutResults: TCutResult;
    NewKnife: Boolean;
    NoIn4: integer;
    LocalInterlock: TLocalInterlock;
    PackAngle:  real;
  end;
  TPackSet = 1..200; //To cover all pack numbers (Diagonal Free not in sets)

function ButtingGhostsRequired: Boolean;
function AddInterlockingGhosts(NoGhosts: integer; UpdateW1W2: Boolean): Boolean;
function RepeatedInterlock(DoubleIt, Merge, UpdateW1W2: Boolean): Boolean;
procedure RepeatedInterlock8to16(CompleteCutResult: TCompleteCutResult; W2: Boolean);
function UpdateSyntheticResults(Interlock: TInterlock; Knife2: TPattern; LastStep, MergeDistantPatterns: Boolean): Boolean;
procedure DoXPullback(var TheInterlock: TInterlock);
procedure DoYPullback(var TheInterlock: TInterlock);
procedure RemoveGhostsFromCutResults(Pack: integer);
function Butt(ThisStep: TStep): TInterlock;
function DoSteps(Angle, Pack: integer; Steps: TStepsArray): Boolean;
function GetSteps(Pack: integer; Line2W2: Boolean): TStepsArray;
function UncutArea(MatHeight, MatWidth, RemHeight, RemWidth: integer): real;
procedure ResultsHorizontal(Propogation: THPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                            StartingLeft, W2: Boolean);
procedure ResultsHorizontalP2Inverted(Propogation: THP2IPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                                      StartingLeft: boolean);
procedure ResultsVertical(Propogation: TVPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                          StartingLeft, W2: Boolean);
procedure ResultsVerticalP2Inverted(Propogation: TVP2IPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                                    StartingLeft: boolean);
procedure ResultsHorizontalDiagonal(Propogation: THDPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                                    StartingLeft, W2: Boolean);
procedure ResultsHorizontalP2InvertedDiagonal(Propogation: THP2IDPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                                              StartingLeft: boolean);
procedure ResultsVerticalDiagonal(Propogation: TVDPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                                  StartingLeft, W2: Boolean);
procedure ResultsVerticalP2InvertedDiagonal(Propogation: TVP2IDPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                                            StartingLeft: Boolean);
procedure ResultsFreeDiagonal(Propogation: TFDPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                              StartingLeft, W2: Boolean);
procedure PropogateHorizontal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                              Square, FixedStart, StartLeft, W2, FirstCutInCorner: boolean;
                              LocalInterlock: TLocalInterlock;
                              var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                              var RemainingArea: real; var StartingLeft: Boolean);
procedure PropogateHorizontalP2Inverted(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                                        Square, FixedStart, StartLeft, FirstCutInCorner, ForceW1First,
                                        ForceW2First: boolean;
                                        var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                        var RemainingArea: real; var StartingLeft: Boolean);
procedure PropogateVertical(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                            Square, FixedStart, StartLeft, W2, FirstCutInCorner: boolean;
                            LocalInterlock: TLocalInterlock;
                            var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                            var RemainingArea: real; var StartingLeft: Boolean);
procedure PropogateVerticalP2Inverted(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                                      Square, FixedStart, StartLeft, FirstCutInCorner, ForceW1First,
                                      ForceW2First: boolean;
                                      var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                      var RemainingArea: real; var StartingLeft: Boolean);
procedure PropogateHorizontalDiagonal(UsableMaterialLength, UsableMaterialWidth,
                                      PatternHeight, PatternWidth: integer;
                                      FixedStart, StartLeft, W2, FirstCutInCorner: boolean;
                                      LocalInterlock: TLocalInterlock;
                                      var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                      var RemainingArea: real; var StartingLeft: Boolean);
procedure PropogateHorizontalP2InvertedDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                                                FixedStart, StartLeft: boolean;
                                                var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                                var RemainingArea: real; var StartingLeft: Boolean);
procedure PropogateVerticalDiagonal(UsableMaterialLength, UsableMaterialWidth,
                                    PatternHeight, PatternWidth: integer;
                                    FixedStart, StartLeft, W2, FirstCutInCorner: boolean;
                                    LocalInterlock: TLocalInterlock;
                                    var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                    var RemainingArea: real; var StartingLeft: Boolean);
procedure PropogateVerticalP2InvertedDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                                              FixedStart, StartLeft: boolean;
                                              var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                              var RemainingArea: real; var StartingLeft: Boolean);
procedure PropogateFreeDiagonal(UsableMaterialLength, UsableMaterialWidth,
                                PatternHeight, PatternWidth: integer;
                                FixedStart, StartLeft, W2, FirstCutInCorner: boolean;
                                LocalInterlock: TLocalInterlock; PackAngle: real;
                                var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                var RemainingArea: real; var StartingLeft: Boolean);
procedure InitialisePackResult(var PackResult: TCompleteCutResult);
procedure InitialisePackResults;
procedure CopyFromPackResult(var Knife, KnifeW1, KnifeW2: TPattern;
                             var LocalInterlock: TLocalInterlock;
                             var PackAngle: real;
                             var PackResult: TCompleteCutResult);
procedure CopyToPackResult(var Knife, KnifeW1, KnifeW2: TPattern;
                           var LocalInterlock: TlocalInterlock;
                           var PackAngle: real;
                           var PackResult: TCompleteCutResult);
procedure DiagonalPack(Pack: integer; Line2W2: Boolean);
function Plan(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth, Pack: integer;
              Propogate, Line2W2, FirstCutInCorner, ForceW1First, ForceW2First, FixedStart, StartLeft: boolean;
              LocalInterlock: TLocalInterlock;
              var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
              var RemainingArea: real; var StartingLeft: Boolean; Tolerance: integer): Boolean;
procedure SwapPairedPatternToSingles(LocalInterlock: TLocalInterlock);
procedure RelativePositionLocalInterlockPatterns(var LocalInterlock: TLocalInterlock);
function LocalInterlockToUse(LocalInterlock: TLocalInterlock; Direction: integer;
                             Reversed, FirstCutInCorner, StartingLeft: Boolean): TLocalInterlock;
function GetFreeAngle(var Angle: real): Boolean;
procedure RotateBackFreeDiagonalPack(ActualPackAngle: real);
function RotatedInterlock(Knife, Knife2: TPattern; Angle: real; Interlock: TInterlock): TInterlock;
function SinglePatternThatFits(x, y, LeftHandEdge, RightHandEdge, UsableMaterialLength: integer; LocalInterlock: TLocalInterlock): integer;
procedure PointCutResultsUp;
procedure SwapCutResultsFromDiagonalFreeToDiagonalHorizontal;
procedure SwapCutResults(i, j: integer);
procedure FillPropogationInput(No: integer;
                               UsableMaterialLength: Integer;
                               UsableMaterialWidth: Integer;
                               PatternHeight: Integer;
                               PatternWidth: Integer;
                               Square: Boolean;
                               FixedStart: Boolean;
                               StartLeft: Boolean;
                               W2: Boolean;
                               FirstCutInCorner: Boolean;
                               ForceW1First: Boolean;
                               ForceW2First: Boolean;
                               LocalInterlock: TLocalInterlock;
                               PackAngle: Double);
function EmptyLocalInterlock: TLocalInterlock;
procedure ReCreateLoadedLayplan(UsableMaterialLength, UsableMaterialWidth, PatWidth: integer;
                                StartLeft: Boolean);
procedure PostPlan(UsableMaterialLength, UsableMaterialWidth, PatWidth: integer;
                   StartLeft: Boolean;
                   var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                   var RemainingArea: real);

const
  SQUARE = 1;
  OFFSET = 2;
  DIAGONAL = 3;

  HORIZONTAL = 1;
  VERTICAL = 2;
  BOTH = 3;

  TTOP = 1;
  BOTTOM = 2;
  LLEFT = 1;
  RIGHT = 2;

  //Packs and Steps
  //Note Vertical Steps are 100+ (Used in code)
  //Note Square Packs mod 100 = 1 to 2 (Used in code)
  //Note Offset Packs mod 100 = 3 to 5 (Used in code)
  //Note Diagonal Packs mod 100 = 6 to 7 (Used in code)
  NONE = 0;
  SQUARE_HORIZONTAL = 1;
  SQUARE_HORIZONTAL_P2_INVERTED = 2;
  OFFSET_HORIZONTAL_TOP = 3;
  OFFSET_HORIZONTAL_BOTTOM = 4;
  OFFSET_HORIZONTAL_P2_INVERTED = 5;
  DIAGONAL_HORIZONTAL = 6;
  DIAGONAL_HORIZONTAL_P2_INVERTED = 7;

  SQUARE_VERTICAL = 101;
  SQUARE_VERTICAL_P2_INVERTED = 102;
  OFFSET_VERTICAL_LEFT = 103;
  OFFSET_VERTICAL_RIGHT = 104;
  OFFSET_VERTICAL_P2_INVERTED = 105;
  DIAGONAL_VERTICAL = 106;
  DIAGONAL_VERTICAL_P2_INVERTED = 107;

  DIAGONAL_FREE = 206;

  FIRST4_HORIZONTAL = 11;
  FIRST4_HORIZONTAL_P2_INVERTED = 12;
  FIRST8_HORIZONTAL = 13;
  FIRST8_HORIZONTAL_P2_INVERTED = 14;

  FIRST4_VERTICAL = 111;
  FIRST4_VERTICAL_P2_INVERTED = 112;
  FIRST8_VERTICAL = 113;
  FIRST8_VERTICAL_P2_INVERTED = 114;

  SECOND_HORIZONTAL_W1 = 21;
  SECOND_HORIZONTAL_W2_TOP = 22;
  SECOND_HORIZONTAL_W2_BOTTOM = 23;
  SECOND_HORIZONTAL_P2_INVERTED = 24;

  SECOND_VERTICAL_W1 = 121;
  SECOND_VERTICAL_W2_LEFT = 122;
  SECOND_VERTICAL_W2_RIGHT = 123;
  SECOND_VERTICAL_P2_INVERTED = 124;

  //Knife Numbers for Local Interlocks
  KBOTH = -1;
  KNONE = 0;
  KLEFT = 1;
  KRIGHT = 2;
  KTOP = 4;
  KBOTTOM = 8;

  //Propogations
  PROPOGATION_HORIZONTAL = 1;
  PROPOGATION_HORIZONTALP2INVERTED = 2;
  PROPOGATION_VERTICAL = 3;
  PROPOGATION_VERTICALP2INVERTED = 4;
  PROPOGATION_HORIZONTALDIAGONAL = 5;
  PROPOGATION_HORIZONTALP2INVERTEDDIAGONAL = 6;
  PROPOGATION_VERTICALDIAGONAL = 7;
  PROPOGATION_VERTICALP2INVERTEDDIAGONAL = 8;
  PROPOGATION_FREEDIAGONAL = 9;

var
  NoIn4: integer; //Pieces per step. Will be 4 unless there are ghosts.
  First4Horizontal, First4HorizontalPI, First4Vertical, First4VerticalPI: TCompleteCutResult;
  First8Horizontal, First8HorizontalPI, First8Vertical, First8VerticalPI: TCompleteCutResult;
  SecondHorizontalW1, SecondHorizontalW2Top, SecondHorizontalW2Bottom, SecondHorizontalPI: TCompleteCutResult;
  SecondVerticalW1, SecondVerticalW2Left, SecondVerticalW2Right, SecondVerticalPI: TCompleteCutResult;
  InterlockingToleranceLayplans_Local: integer;
  KnifeSmallestArea: real;
  KnifeSmallestRatio: real;
  Parallelogram: TPolygon2D;
  ParallelogramCount: integer;

{$IFDEF DEBUG}
  DoCreate, TotalDoCreate, DoMerge, TotalDoMerge, FullPlan, TotalFullPlan,
  Planning, TotalPlan, UpdateSynthRes, TotalUpdateSynthRes, Prop, TotalProp, FI, TotalFI: real;
{$ENDIF}

implementation

function ButtingGhostsRequired: Boolean;
var
  Height4, Width4, UnitHeight, UnitWidth: integer;
  HeightRatio, WidthRatio: real;

begin
  Height4 := abs(CutResults[NoIn4 - 1].BoundingRect.Top - CutResults[0].BoundingRect.Bottom);
  Width4 := abs(CutResults[NoIn4 - 1].BoundingRect.Left - CutResults[0].BoundingRect.Right);

  UnitHeight := abs(CutResults[0].BoundingRect.Top - CutResults[0].BoundingRect.Bottom);
  UnitWidth := abs(CutResults[0].BoundingRect.Left - CutResults[0].BoundingRect.Right);

  HeightRatio := UnitHeight / Height4;
  if HeightRatio = 1 then
    HeightRatio := 0;
  WidthRatio := UnitWidth / Width4;
  if WidthRatio = 1 then
    WidthRatio := 0;

  Result := ((HeightRatio >= 0.5) or (WidthRatio >= 0.5));
end;

function AddInterlockingGhosts(NoGhosts: integer; UpdateW1W2: Boolean): Boolean;
var
  Vecx, Vecy, Vec1x, Vec1y, Vec2x, Vec2y: integer;
  Interlock: TInterlock;
  GhostPos: TRect;
  MergedPattern: TPointArray;
  MPattern: TMerge;
  Ghost: TPattern;
  i: integer;
  W2: Boolean;
  Success: Boolean;

begin
  Success := True;

  //Position the ghosted shapes...
  Vec1x := CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left;
  Vec1y := CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top;
  Vec2x := CutResults[2].BoundingRect.Left - CutResults[1].BoundingRect.Left;
  Vec2y := CutResults[2].BoundingRect.Top - CutResults[1].BoundingRect.Top;

  for i := 1 to NoGhosts do
  begin
    if ((i mod 2) = 0) then
    begin
      Vecx := ((Vec1x + Vec2x) * 0) + Vec1x;
      Vecy := ((Vec1y + Vec2y) * 0) + Vec1y;
      W2 := CutResults[1].W2;
    end
    else //((i mod 2) = 1)
    begin
      Vecx := ((Vec1x + Vec2x) * 0) + Vec2x;
      Vecy := ((Vec1y + Vec2y) * 0) + Vec2y;
      W2 := CutResults[0].W2;
    end;

    //Assumes all same pattern
    if not W2 then
      Ghost := CreatePattern(KnivesUsed[CutResults[0].KnifeNo - 1, 0].ExpandedPoints, 0, 0, False, False)
    else
      Ghost := CreatePattern(KnivesUsed[CutResults[0].KnifeNo - 1, 1].ExpandedPoints, 0, 0, False, False);

    GhostPos.Left := Vecx;
    GhostPos.Top := Vecy;
    GhostPos.Right := GhostPos.Left + (CutResults[0].BoundingRect.Right - CutResults[0].BoundingRect.Left);
    GhostPos.Bottom := GhostPos.Top + (CutResults[0].BoundingRect.Bottom - CutResults[0].BoundingRect.Top);

    Interlock.Knife1BoundingRect.Left := 0;
    Interlock.Knife1BoundingRect.Top := 0;
    Interlock.Knife1BoundingRect.Bottom := Knife.Height;
    Interlock.Knife1BoundingRect.Right := Knife.Width;
    Interlock.Knife2BoundingRect := GhostPos;
    Interlock.W2 := W2;
    {$IFDEF DEBUGFULL}
    Interlock.ConvexHull1 := MakeConvexHull(Knife.ExpandedPoints);
    Interlock.ConvexHull2 := MakeConvexHull(Ghost.ExpandedPoints);
    {$ENDIF}

    //...& Add to Results
    AddToResults(Interlock, False, Interlock.W2, False, False);

    //Merge (the ghost) ready to continue
    MPattern := MergePatterns(Knife, Ghost, Interlock, False);
    if MPattern.Success then
    begin
      MergedPattern := MPattern.Points;
      Knife := CreatePattern(MergedPattern, 0, 0, False, False);
      if UpdateW1W2 then
      begin
        KnifeW1 := CreatePattern(MergedPattern, 0, 0, False, False);
        KnifeW2 := CreatePattern(MergedPattern, 0, 0, False, True);
      end;
    end
    else
      Success := False;
  end;

  Result := Success;
end;

function RepeatedInterlock(DoubleIt, Merge, UpdateW1W2: Boolean): Boolean;
var
  Vecx, Vecy, Vec1x, Vec1y, Vec2x, Vec2y, Vec3x, Vec3y: integer;
  Interlock: TInterlock;
  RepeatPos: TRect;
  MergedPattern: TPointArray;
  MPattern: TMerge;
  Success: Boolean;

begin
  Success := True;

  //Position the repeated shapes...
  Vec1x := CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left;
  Vec1y := CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top;

  if DoubleIt then
  begin
    Vec2x := CutResults[2].BoundingRect.Left - CutResults[1].BoundingRect.Left;
    Vec2y := CutResults[2].BoundingRect.Top - CutResults[1].BoundingRect.Top;

    Vecx := (Vec1x + Vec2x) * (NoIn4 div 2);
    Vecy := (Vec1y + Vec2y) * (NoIn4 div 2);
  end
  else if Length(CutResults) = 2 then
  begin
    Vecx := Vec1x * 2;
    Vecy := Vec1y * 2;
  end
  else if Length(CutResults) = (NoIn4 * 2) then
  begin
    Vec3x := CutResults[NoIn4].BoundingRect.Left - CutResults[0].BoundingRect.Left;
    Vec3y := CutResults[NoIn4].BoundingRect.Top - CutResults[0].BoundingRect.Top;

    Vecx := Vec3x * 2;
    Vecy := Vec3y * 2;
  end;

  RepeatPos.Left := Vecx;
  RepeatPos.Top := Vecy;
  RepeatPos.Right := RepeatPos.Left + Knife.Width;
  RepeatPos.Bottom := RepeatPos.Top + Knife.Height;

  Interlock.Knife1BoundingRect.Left := 0;
  Interlock.Knife1BoundingRect.Top := 0;
  Interlock.Knife1BoundingRect.Bottom := Knife.Height;
  Interlock.Knife1BoundingRect.Right := Knife.Width;
  Interlock.Knife2BoundingRect := RepeatPos;
  Interlock.W2 := False;

  //...& Add to Results
  AddToResults(Interlock, True, Interlock.W2, False, False);

  //Merge ready to continue
  if Merge then
  begin
    MPattern := MergePatterns(Knife, Knife, Interlock, False);
    if MPattern.Success then
    begin
      MergedPattern := MPattern.Points;
      Knife := CreatePattern(MergedPattern, 0, 0, False, False);
      if UpdateW1W2 then
      begin
        KnifeW1 := CreatePattern(MergedPattern, 0, 0, False, False);
        KnifeW2 := CreatePattern(MergedPattern, 0, 0, False, True);
      end;
    end
    else
      Success := False;

    //Decide if Interlocking Ghosts necesary and required
    if Success and (Length(CutResults) = 4) then
    begin
      NoIn4 := 4;
      while ButtingGhostsRequired and Success do
      begin
        NoIn4 := NoIn4 + 2;
        Success := AddInterlockingGhosts((NoIn4 - Length(CutResults)), True);
      end;
    end;
  end;

  Result := Success;
end;

procedure RepeatedInterlock8to16(CompleteCutResult: TCompleteCutResult; W2: Boolean);
var
  Vec1x, Vec1y, Vec2x, Vec2y: integer;
  Interlock: TInterlock;
  RepeatPos: TRect;
  i1, i2: integer;

begin
  if W2 then
  begin
    i1 := NoIn4;
    i2 := 0;
  end
  else
  begin
    i1 := 0;
    i2 := NoIn4;
  end;

  //Position the repeated shapes...
  Vec1x := CutResults[0].BoundingRect.Left - CutResults[NoIn4].BoundingRect.Left;
  Vec1y := CutResults[0].BoundingRect.Top - CutResults[NoIn4].BoundingRect.Top;
  Vec2x := CompleteCutResult.CutResults[i1].BoundingRect.Left - CompleteCutResult.CutResults[i2].BoundingRect.Left;
  Vec2y := CompleteCutResult.CutResults[i1].BoundingRect.Top - CompleteCutResult.CutResults[i2].BoundingRect.Top;

  RepeatPos.Left := (Vec1x + Vec2x);
  RepeatPos.Top := (Vec1y + Vec2y);
  RepeatPos.Right := RepeatPos.Left + Knife.Width;
  RepeatPos.Bottom := RepeatPos.Top + Knife.Height;

  Interlock.Knife1BoundingRect.Left := 0;
  Interlock.Knife1BoundingRect.Top := 0;
  Interlock.Knife1BoundingRect.Bottom := Knife.Height;
  Interlock.Knife1BoundingRect.Right := Knife.Width;
  Interlock.Knife2BoundingRect := RepeatPos;
  Interlock.W2 := False;

  //...& Add to Results
  AddToResults(Interlock, True, Interlock.W2, False, False);
end;

function UpdateSyntheticResults(Interlock: TInterlock; Knife2: TPattern; LastStep, MergeDistantPatterns: Boolean): Boolean;
var
  Merge: TMerge;
  MergedPattern: TPointArray;
  Success: Boolean;

begin
  //Add to Results
  AddToResults(Interlock, (not NewKnife), Knife2.W2, False, False);

  NewKnife := False;

  if LastStep then
    Success := True
  else
  begin
    //Merge ready to continue
{$IFDEF DEBUG}
  DoMerge := GetTickCount;
{$ENDIF}

    Merge := MergePatterns(Knife, Knife2, Interlock, MergeDistantPatterns);

{$IFDEF DEBUG}
  DoMerge := GetTickCount - DoMerge;
  TotalDoMerge := TotalDoMerge + DoMerge;
{$ENDIF}

    if Merge.Success then
    begin
      MergedPattern := Merge.Points;

{$IFDEF DEBUG}
  DoCreate := GetTickCount;
{$ENDIF}

      //Update Patterns
      Knife := CreatePattern(MergedPattern, 0, 0, False, False);
      KnifeW1 := CreatePattern(MergedPattern, 0, 0, False, False);
      KnifeW2 := CreatePattern(MergedPattern, 0, 0, False, True);

{$IFDEF DEBUG}
  DoCreate := GetTickCount - DoCreate;
  TotalDoCreate := TotalDoCreate + DoCreate;
{$ENDIF}
    end;

    Success := Merge.Success;

    //Decide if Interlocking Ghosts necesary and required
    if Success and (Length(CutResults) = 4) then
    begin
      NoIn4 := 4;
      while ButtingGhostsRequired and Success do
      begin
        NoIn4 := NoIn4 + 2;
        Success := AddInterlockingGhosts((NoIn4 - Length(CutResults)), True);
      end;
    end;
  end;

  Result := Success;
end;

procedure DoXPullback(var TheInterlock: TInterlock);
var
  Vec1x, Vec2x: integer;
  NewVecx, Pullback, xOffset: integer;

begin
  //Only Pullback if you have at least 4 already
  if Length(CutResults) >= 4 then
  begin
    Vec1x := abs(CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left);
    Vec2x := abs(CutResults[2].BoundingRect.Left - CutResults[1].BoundingRect.Left);

    if not CutResults[1].W2 then
      NewVecx := Vec1x
    else
      NewVecx := Vec1x + Vec2x;
    xOffset := TheInterlock.Knife1BoundingRect.Left - TheInterlock.Knife2BoundingRect.Left;

    Pullback := (xOffset div NewVecx) * NewVecx;
    TheInterlock.Knife2BoundingRect.Left := TheInterlock.Knife2BoundingRect.Left + Pullback;
    TheInterlock.Knife2BoundingRect.Right := TheInterlock.Knife2BoundingRect.Right + Pullback;

    //The following code squares the pack as much as possible.  So far direction of pullback has relied on xOffset,
    //NewVecx is always positive (abs) - now we need to ensure that when we make it into Pullback we give it the
    //correct sign.  The sign of Pullback is the same as the sign of xOffset.

    xOffset := TheInterlock.Knife1BoundingRect.Left - TheInterlock.Knife2BoundingRect.Left;

    if (abs(xOffset) > abs(abs(xOffset) - NewVecx)) then
    begin
      if xOffset < 0 then
        Pullback := -NewVecx
      else
        Pullback := NewVecx;

      TheInterlock.Knife2BoundingRect.Left := TheInterlock.Knife2BoundingRect.Left + Pullback;
      TheInterlock.Knife2BoundingRect.Right := TheInterlock.Knife2BoundingRect.Right + Pullback;
    end;
  end;
end;

procedure DoYPullback(var TheInterlock: TInterlock);
var
  Vec1y, Vec2y: integer;
  NewVecy, Pullback, yOffset: integer;

begin
  //Only Pullback if you have at least 4 already
  if Length(CutResults) >= 4 then
  begin
    Vec1y := abs(CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top);
    Vec2y := abs(CutResults[2].BoundingRect.Top - CutResults[1].BoundingRect.Top);

    if not CutResults[1].W2 then
      NewVecy := Vec1y
    else
      NewVecy := Vec1y + Vec2y;
    yOffset := TheInterlock.Knife1BoundingRect.Top - TheInterlock.Knife2BoundingRect.Top;

    Pullback := (yOffset div NewVecy) * NewVecy;
    TheInterlock.Knife2BoundingRect.Top := TheInterlock.Knife2BoundingRect.Top + Pullback;
    TheInterlock.Knife2BoundingRect.Bottom := TheInterlock.Knife2BoundingRect.Bottom + Pullback;

    //The following code squares the pack as much as possible.  So far direction of pullback has relied on yOffset,
    //NewVecy is always positive (abs) - now we need to ensure that when we make it into Pullback we give it the
    //correct sign.  The sign of Pullback is the same as the sign of yOffset.

    yOffset := TheInterlock.Knife1BoundingRect.Top - TheInterlock.Knife2BoundingRect.Top;

    if (abs(yOffset) > abs(abs(yOffset) - NewVecy)) then
    begin
      if yOffset < 0 then
        Pullback := -NewVecy
      else
        Pullback := NewVecy;

      TheInterlock.Knife2BoundingRect.Top := TheInterlock.Knife2BoundingRect.Top + Pullback;
      TheInterlock.Knife2BoundingRect.Bottom := TheInterlock.Knife2BoundingRect.Bottom + Pullback;
    end;
  end;
end;

procedure RemoveGhostsFromCutResults(Pack: integer);
var
  i, minx, miny: integer;

begin
  //Remove the extra bits if a pack based on 12's not 4's
  if NoIn4 > 4 then
  begin
    for i := 0 to 3 do
      CutResults[i - 0] := CutResults[i];
    for i := NoIn4 to NoIn4 + 3 do
      CutResults[i - (NoIn4 - 4)] := CutResults[i];

    if not((Pack = DIAGONAL_VERTICAL_P2_INVERTED) or (Pack = DIAGONAL_HORIZONTAL_P2_INVERTED)) then
    begin
      for i := (NoIn4 * 2) to (NoIn4 * 2) + 3 do
        CutResults[i - (2 * (NoIn4 - 4))] := CutResults[i];
      for i := (NoIn4 * 3) to (NoIn4 * 3) + 3 do
        CutResults[i - (3 * (NoIn4 - 4))] := CutResults[i];
      SetLength(CutResults, 16);
    end
    else
      SetLength(CutResults, 8);
  end;

  //Realign the pack to 0,0
  minx := 999999;
  miny := 999999;

  for i := 0 to Length(CutResults) - 1 do
  begin
    if CutResults[i].BoundingRect.Left < minx then
      minx := CutResults[i].BoundingRect.Left;
    if CutResults[i].BoundingRect.Top < miny then
      miny := CutResults[i].BoundingRect.Top;
  end;
  for i := 0 to Length(CutResults) - 1 do
  begin
    CutResults[i].BoundingRect.Left := CutResults[i].BoundingRect.Left - minx;
    CutResults[i].BoundingRect.Right := CutResults[i].BoundingRect.Right - minx;
    CutResults[i].BoundingRect.Top := CutResults[i].BoundingRect.Top - miny;
    CutResults[i].BoundingRect.Bottom := CutResults[i].BoundingRect.Bottom - miny;
  end;
end;

function Butt(ThisStep: TStep): TInterlock;
var
  Knife2: TPattern;

begin
  if ThisStep.W2 then
    Knife2 := KnifeW2
  else
    Knife2 := KnifeW1;

{$IFDEF DEBUG}
  FI := GetTickCount;
  Planning := FI - Planning;
  TotalPlan := TotalPlan + Planning;
{$ENDIF}

  Result := FindInterlock(Knife, Knife2, KnivesUsed[CurrentKnife - 1, 0], (Length(CutResults) = 0), False, OriginalKnifeNow, True, not(ThisStep.Left), not(ThisStep.Right), not(ThisStep.Top), not(ThisStep.Bottom), True, True, InterlockingToleranceLayplans_Local);

{$IFDEF DEBUG}
  Planning := GetTickCount;
  FI := Planning - FI;
  TotalFI := TotalFi + FI;
{$ENDIF}
end;

function DoSteps(Angle, Pack: integer; Steps: TStepsArray): Boolean;
var
  i, j, BackToZeroX, BackToZeroY: integer;
  InterlockSoFar: TInterlock;
  AddKnife, Knife2: TPattern;

begin
  Result := True;
  for i := 0 to Length(Steps) - 1 do
  begin
    if Result then
    begin
      if Steps[i].SearchInterlock then
      begin
        if Steps[i].W2 then
          Knife2 := KnifeW2
        else
          Knife2 := KnifeW1;

      {$IFDEF DEBUG}
        Fi := GetTickCount;
        Planning := FI - Planning;
        TotalPlan := TotalPlan + Planning;
      {$ENDIF}

        InterlockSoFar := FindInterlock(Knife, Knife2, KnivesUsed[CurrentKnife - 1, 0], (Length(CutResults) = 0), False, OriginalKnifeNow, False, not(Steps[i].Left), not(Steps[i].Right), not(Steps[i].Top), not(Steps[i].Bottom), True, True, InterlockingToleranceLayplans_Local);
        if InterlockSoFar.Error then
          Result := False
        else
        begin
        {$IFDEF DEBUG}
          Planning := GetTickCount;
          FI := Planning - FI;
          TotalFI := TotalFI + FI;
        {$ENDIF}

          //Put the 8 back to 4
          Knife.Height := KnifeW1.Height;
          Knife.Width := KnifeW1.Width;
          Knife.PatternPoints := Copy(KnifeW1.PatternPoints);
          Knife.ExpandedPoints := Copy(KnifeW1.ExpandedPoints);
          Knife.ConvexHull := Copy(KnifeW1.ConvexHull);
          Knife.ButtSquare := Copy(KnifeW1.ButtSquare);
          Knife.PatternNettArea := KnifeW1.PatternNettArea;
          Knife.ExpandedNettArea := KnifeW1.ExpandedNettArea;
          Knife.ExpandedGrossArea := KnifeW1.ExpandedGrossArea;
          Knife.W2 := KnifeW1.W2;
          SetLength(CutResults, NoIn4);

          InterlockSoFar.Knife1BoundingRect.Left := InterlockSoFar.Knife1BoundingRect.Right - (InterlockSoFar.Knife2BoundingRect.Right - InterlockSoFar.Knife2BoundingRect.Left);

          //Get CutResults back to where the bounding rectangle of all 4 has a 0,0 origin
          BackToZeroX := CutResults[NoIn4 - 1].BoundingRect.Left;
          BackToZeroY := CutResults[NoIn4 - 1].BoundingRect.Top;

          for j := 0 to NoIn4 - 1 do
          begin
            CutResults[j].BoundingRect.Left := CutResults[j].BoundingRect.Left - BackToZeroX;
            CutResults[j].BoundingRect.Right := CutResults[j].BoundingRect.Right - BackToZeroX;
            CutResults[j].BoundingRect.Top := CutResults[j].BoundingRect.Top - BackToZeroY;
            CutResults[j].BoundingRect.Bottom := CutResults[j].BoundingRect.Bottom - BackToZeroY;
          end;

          if not InterlockSoFar.Found then
          begin
            InterlockSoFar := Butt(Steps[i]);
            if InterlockSoFar.Error then
              Result := False;
          end;
        end;
      end
      else
      begin
        InterlockSoFar := Butt(Steps[i]);
        if InterlockSoFar.Error then
          Result := False;
      end;

      if Result then
      begin

        //Pullbacks
        if (Pack < 100) then
          //Horizontal
          DoXPullback(InterlockSoFar)
        else
          DoYPullback(InterlockSofar);

        if Steps[i].W2 then
          AddKnife := KnifeW2
        else
          AddKnife := KnifeW1;

      {$IFDEF DEBUG}
        UpdateSynthRes := GetTickCount;
      {$ENDIF}

        Result := UpdateSyntheticResults(InterlockSoFar, AddKnife, (Steps[i].LastStep and (not Steps[i].Repeated)), False);
      end;

    {$IFDEF DEBUG}
      UpdateSynthRes := GetTickCount - UpdateSynthRes;
      TotalUpdateSynthRes := TotalUpdateSynthRes + UpdateSynthRes;
    {$ENDIF}

      if Result and Steps[i].Repeated then
        Result := RepeatedInterlock(False, not Steps[i].LastStep, True);
    end;
  end;
end;

function GetSteps(Pack: integer; Line2W2: Boolean): TStepsArray;
var
  LeftButt, LeftSearch, RightButt, RightSearch, TopButt, TopSearch, BottomSearch: TStep;

begin
  LeftButt.SearchInterlock := False;
  LeftButt.W2 := False;
  LeftButt.Left := True;
  LeftButt.Right := False;
  LeftButt.Top := False;
  LeftButt.Bottom := False;
  LeftButt.Repeated := False;
  LeftButt.LastStep := False;

  LeftSearch.SearchInterlock := True;
  LeftSearch.W2 := False;
  LeftSearch.Left := True;
  LeftSearch.Right := False;
  LeftSearch.Top := True;
  LeftSearch.Bottom := True;
  LeftSearch.Repeated := False;
  LeftSearch.LastStep := False;

  RightButt.SearchInterlock := False;
  RightButt.W2 := False;
  RightButt.Left := False;
  RightButt.Right := True;
  RightButt.Top := False;
  RightButt.Bottom := False;
  RightButt.Repeated := False;
  RightButt.LastStep := False;

  RightSearch.SearchInterlock := True;
  RightSearch.W2 := False;
  RightSearch.Left := False;
  RightSearch.Right := True;
  RightSearch.Top := True;
  RightSearch.Bottom := True;
  RightSearch.Repeated := False;
  RightSearch.LastStep := False;

  TopButt.SearchInterlock := False;
  TopButt.W2 := False;
  TopButt.Left := False;
  TopButt.Right := False;
  TopButt.Top := True;
  TopButt.Bottom := False;
  TopButt.Repeated := False;
  TopButt.LastStep := False;

  TopSearch.SearchInterlock := True;
  TopSearch.W2 := False;
  TopSearch.Left := True;
  TopSearch.Right := True;
  TopSearch.Top := True;
  TopSearch.Bottom := False;
  TopSearch.Repeated := False;
  TopSearch.LastStep := False;

  BottomSearch.SearchInterlock := True;
  BottomSearch.W2 := False;
  BottomSearch.Left := True;
  BottomSearch.Right := True;
  BottomSearch.Top := False;
  BottomSearch.Bottom := True;
  BottomSearch.Repeated := False;
  BottomSearch.LastStep := False;

  case Pack of
    //General
    //Note: FIRST8_ type packs same as FIRST4_ but Doubled

    FIRST4_HORIZONTAL:
    begin
      SetLength(Result, 1);

      Result[0] := LeftButt;
      Result[0].Repeated := True;
    end;

    FIRST4_HORIZONTAL_P2_INVERTED:
    begin
      SetLength(Result, 2);

      Result[0] := LeftButt;
      Result[0].W2 := True;

      Result[1] := LeftButt;
    end;

    FIRST4_VERTICAL:
    begin
      SetLength(Result, 1);

      Result[0] := TopButt;
      Result[0].Repeated := True;
    end;

    FIRST4_VERTICAL_P2_INVERTED:
    begin
      SetLength(Result, 2);

      Result[0] := TopButt;
      Result[0].W2 := True;

      Result[1] := TopButt;
    end;

    SECOND_HORIZONTAL_W1:
    begin
      SetLength(Result, 1);

      Result[0] := TopSearch;
      Result[0].Left := False;
      Result[0].Right := False;
    end;

    SECOND_HORIZONTAL_W2_TOP:
    begin
      SetLength(Result, 1);

      Result[0] := TopSearch;
      Result[0].W2 := True;
      Result[0].Left := False;
      Result[0].Right := False;
    end;

    SECOND_HORIZONTAL_W2_BOTTOM:
    begin
      SetLength(Result, 1);

      Result[0] := BottomSearch;
      Result[0].W2 := True;
      Result[0].Left := False;
      Result[0].Right := False;
    end;

    SECOND_HORIZONTAL_P2_INVERTED:
    begin
      SetLength(Result, 1);

      Result[0] := TopSearch;
      Result[0].Left := False;
      Result[0].Right := False;
    end;

    SECOND_VERTICAL_W1:
    begin
      SetLength(Result, 1);

      Result[0] := LeftSearch;
      Result[0].Top := False;
      Result[0].Bottom := False;
    end;

    SECOND_VERTICAL_W2_LEFT:
    begin
      SetLength(Result, 1);

      Result[0] := LeftSearch;
      Result[0].W2 := True;
      Result[0].Top := False;
      Result[0].Bottom := False;
    end;

    SECOND_VERTICAL_W2_RIGHT:
    begin
      SetLength(Result, 1);

      Result[0] := RightSearch;
      Result[0].W2 := True;
      Result[0].Top := False;
      Result[0].Bottom := False;
    end;

    SECOND_VERTICAL_P2_INVERTED:
    begin
      SetLength(Result, 1);

      Result[0] := LeftSearch;
      Result[0].Top := False;
      Result[0].Bottom := False;
    end;

    //Specific Packs (Step 3)
    //Note: DIAGONAL_HORIZONTAL & DIAGONAL_VERTICAL no longer called this way

    SQUARE_HORIZONTAL:
    begin
      if Line2W2 then
      begin
        SetLength(Result, 2);

        Result[0] := TopButt;
        Result[0].W2 := True;

        Result[1] := TopButt;
        Result[1].LastStep := True;
      end
      else
      begin
        SetLength(Result, 1);

        Result[0] := TopButt;
        Result[0].W2 := False;
        Result[0].Repeated := True;
        Result[0].LastStep := True;
      end;
    end;

    SQUARE_HORIZONTAL_P2_INVERTED:
    begin
      SetLength(Result, 1);

      Result[0] := TopButt;
      Result[0].Repeated := True;
      Result[0].LastStep := True;
    end;

    SQUARE_VERTICAL:
    begin
      if Line2W2 then
      begin
        SetLength(Result, 2);

        Result[0] := LeftButt;
        Result[0].W2 := True;

        Result[1] := LeftButt;
        Result[1].LastStep := True;
      end
      else
      begin
        SetLength(Result, 1);

        Result[0] := LeftButt;
        Result[0].W2 := False;
        Result[0].Repeated := True;
        Result[0].LastStep := True;
      end;
    end;

    SQUARE_VERTICAL_P2_INVERTED:
    begin
      SetLength(Result, 1);

      Result[0] := LeftButt;
      Result[0].Repeated := True;
      Result[0].LastStep := True;
    end;

    OFFSET_HORIZONTAL_TOP:
    begin
      SetLength(Result, 1);

      Result[0] := TopButt;
      Result[0].LastStep := True;
    end;

    OFFSET_HORIZONTAL_BOTTOM:
    begin
      SetLength(Result, 1);

      Result[0] := TopButt;
      Result[0].LastStep := True;
    end;

    OFFSET_HORIZONTAL_P2_INVERTED:
    begin
      SetLength(Result, 1);

      Result[0] := TopButt;
      Result[0].LastStep := True;
    end;

    OFFSET_VERTICAL_LEFT:
    begin
      SetLength(Result, 1);

      Result[0] := LeftButt;
      Result[0].LastStep := True;
    end;

    OFFSET_VERTICAL_RIGHT:
    begin
      SetLength(Result, 1);

      Result[0] := LeftButt;
      Result[0].LastStep := True;
    end;

    OFFSET_VERTICAL_P2_INVERTED:
    begin
      SetLength(Result, 1);

      Result[0] := LeftButt;
      Result[0].LastStep := True;
    end;
  end;
end;

function UncutArea(MatHeight, MatWidth, RemHeight, RemWidth: integer): real;
begin
  Result := ((MatHeight * RemWidth) + (MatWidth * RemHeight) - (RemHeight * RemWidth))
            / (12000 * 12000) * (PATTERNRES * PATTERNRES) / 10;  //SqM
end;

procedure ResultsHorizontal(Propogation: THPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                            StartingLeft, W2: Boolean);
var
  CurrentBottom, CurrentLeft, CurrentRight, FirstLeft, FirstRight: integer;
  ColNo, PositionInRow, NoInRow: integer;
  KnifeNo: integer;

begin
  //Clear Results of Pack ready to fill again with results of Layplan
  SetLength(CutResults, 0);

  //Initialisations - take back to add later
  if StartingLeft then
  begin
    if Propogation.Vec3x < 0 then
      FirstLeft := 0
    else
      FirstLeft := Propogation.Vec3x;
  end
  else
  begin
    if Propogation.Vec3x > 0 then
      FirstRight := UsableMaterialWidth - Propogation.Vec3x
    else
      FirstRight := UsableMaterialWidth;
  end;
  CurrentBottom := UsableMaterialLength + abs(Propogation.Vec4y);

  ColNo := 0;
  while (ColNo < Propogation.ColCount) or
        ((ColNo = Propogation.ColCount) and Propogation.ExtraHalfRow) do
  begin
    inc(ColNo);
    if ColNo mod 2 = 1 then
    begin
      //Odd columns
      if StartingLeft then
        CurrentLeft := FirstLeft - Propogation.Vec1x
      else
        CurrentRight := FirstRight + Propogation.Vec1x;

      CurrentBottom := CurrentBottom - abs(Propogation.Vec4y);
{      if StartingLeft then
        NoInRow := Propogation.NoInEvenRow
      else   }
        NoInRow := Propogation.NoInOddRow;
    end
    else
    begin
      //Even columns
      if StartingLeft then
        CurrentLeft := FirstLeft - Propogation.Vec1x - Propogation.Vec3x
      else
        CurrentRight := FirstRight + Propogation.Vec1x + Propogation.Vec3x;

      CurrentBottom := CurrentBottom - abs(Propogation.Vec3y);
{      if StartingLeft then
        NoInRow := Propogation.NoInOddRow
      else        }
        NoInRow := Propogation.NoInEvenRow;
    end;

    if (((ColNo mod 2 = 1) and Propogation.ExtraHalfOddRowStart) or
        ((ColNo mod 2 = 0) and Propogation.ExtraHalfEvenRowStart)) then
    begin
      if StartingLeft then
        CurrentLeft := CurrentLeft - Propogation.Vec1x
      else
        CurrentRight := CurrentRight + Propogation.Vec1x;
      PositionInRow := -1;
    end
    else
      PositionInRow := 0;

    while ((PositionInRow < NoInRow) or
          ((ColNo mod 2 = 1) and (PositionInRow = NoInRow) and Propogation.ExtraHalfOddRow) or
          ((ColNo mod 2 = 0) and (PositionInRow = NoInRow) and Propogation.ExtraHalfEvenRow)) do
    begin
      inc(PositionInRow);

      SetLength(CutResults, Length(CutResults) + 1);
      if StartingLeft then
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CurrentLeft + Propogation.Vec1x;
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CutResults[Length(CutResults) - 1].BoundingRect.Left + Propogation.PatternWidth;
      end
      else
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CurrentRight - Propogation.Vec1x;
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CutResults[Length(CutResults) - 1].BoundingRect.Right - Propogation.PatternWidth;
      end;
      CutResults[Length(CutResults) - 1].BoundingRect.Bottom := CurrentBottom;
      CutResults[Length(CutResults) - 1].BoundingRect.Top := CutResults[Length(CutResults) - 1].BoundingRect.Bottom - Propogation.PatternHeight;
      CutResults[Length(CutResults) - 1].KnifeNo := CurrentKnife;

      KnifeNo := KBOTH;
      //Decide whether either/or/both of pair of Patterns to use when Local Interlocking First
      if Propogation.LocalInterlock.Used then
      begin
        if (PositionInRow = 0) then
        begin
          if StartingLeft then
            KnifeNo := KRIGHT
          else
            KnifeNo := KLEFT;
          if (ColNo > Propogation.ColCount) then
          begin
            if (StartingLeft and Propogation.LocalInterlock.BottomIsLeft) or
               (not StartingLeft) and (not Propogation.LocalInterlock.BottomIsLeft) then
              KnifeNo := KNONE;
          end;
        end
        else if (PositionInRow > NoInRow) then
        begin
          if (ColNo > Propogation.ColCount) then
          begin
            if (StartingLeft and Propogation.LocalInterlock.BottomIsLeft) or
               (not StartingLeft) and (not Propogation.LocalInterlock.BottomIsLeft) then
              KnifeNo := KBOTTOM
            else
              KnifeNo := KNONE;
          end
          else if (((ColNo mod 2 = 1) and Propogation.ExtraHalfOddRow)) or
                  (((ColNo mod 2 = 0) and Propogation.ExtraHalfEvenRow)) then
          begin
            if StartingLeft then
              KnifeNo := KLEFT
            else
              KnifeNo := KRIGHT;
          end;
        end
        else if (ColNo > Propogation.ColCount) then
          KnifeNo := KBOTTOM;
      end;

      if KnifeNo = KBOTH then
        CutResults[Length(CutResults) - 1].KnifeNo := CurrentKnife
      else
        CutResults[Length(CutResults) - 1].KnifeNo := -KnifeNo;

      if W2 and (ColNo mod 2 = 0) then
        CutResults[Length(CutResults) - 1].W2 := True
      else
        CutResults[Length(CutResults) - 1].W2 := False;

      if W2 and Propogation.HorizontalBottom then
        CutResults[Length(CutResults) - 1].W2 := not(CutResults[Length(CutResults) - 1].W2);

      CutResults[Length(CutResults) - 1].Ghost := False;
      if StartingLeft then
        CurrentLeft := CutResults[Length(CutResults) - 1].BoundingRect.Left
      else
        CurrentRight := CutResults[Length(CutResults) - 1].BoundingRect.Right;
    end;
  end;

  //Turn pairs of patterns into single patterns
  if Propogation.LocalInterlock.Used then
    SwapPairedPatternToSingles(Propogation.LocalInterlock);
end;

procedure ResultsHorizontalP2Inverted(Propogation: THP2IPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                                      StartingLeft: boolean);
var
  CurrentBottom, CurrentLeft, CurrentRight, FirstLeft, FirstRight, ColNo, PositionInRow, NoInRow, UseVecx: integer;

begin
  //Clear Results of Pack ready to fill again with results of Layplan
  SetLength(CutResults, 0);

  //Initialisations - take back to add later
  if StartingLeft then
  begin
    if Propogation.Vec3x < 0 then
      FirstLeft := 0
    else
      FirstLeft := Propogation.Vec3x;
  end
  else
  begin
    if Propogation.Vec3x > 0 then
      FirstRight := UsableMaterialWidth - Propogation.Vec3x
    else
      FirstRight := UsableMaterialWidth;
  end;
  CurrentBottom := UsableMaterialLength + abs(Propogation.Vec4y);

  ColNo := 0;
  while not (ColNo = Propogation.ColCount) do
  begin
    inc(ColNo);
    if ColNo mod 2 = 1 then
    begin
      //Odd columns
      if StartingLeft then
        CurrentLeft := FirstLeft - Propogation.Vec2x
      else
        CurrentRight := FirstRight + Propogation.Vec2x;
      CurrentBottom := CurrentBottom - abs(Propogation.Vec4y);

      NoInRow := Propogation.NoInOddRow;
    end
    else
    begin
      //Even columns
      if StartingLeft then
      begin
        if Propogation.InvertToBegin then
          CurrentLeft := FirstLeft - (Propogation.Vec3x + Propogation.Vec1x)
        else
          CurrentLeft := FirstLeft - (Propogation.Vec3x + Propogation.Vec2x);
      end
      else
      begin
        if Propogation.InvertToBegin then
          CurrentRight := FirstRight + Propogation.Vec3x + Propogation.Vec1x
        else
          CurrentRight := FirstRight + Propogation.Vec3x + Propogation.Vec2x;
      end;
      CurrentBottom := CurrentBottom - abs(Propogation.Vec3y);

      NoInRow := Propogation.NoInEvenRow;
    end;

    PositionInRow := 0;
    while not (PositionInRow = NoInRow) do
    begin
      inc(PositionInRow);

      SetLength(CutResults, Length(CutResults) + 1);
      if ((not StartingLeft) and (PositionInRow mod 2 = 1)) or (StartingLeft and (PositionInRow mod 2 = 0))then
      begin
        if StartingLeft then
        begin
          if Propogation.InvertToBegin and (ColNo mod 2 = 0) then
            UseVecx := Propogation.Vec2x
          else
            UseVecx := Propogation.Vec1x;
          CutResults[Length(CutResults) - 1].W2 := True;
        end
        else
        begin
          if Propogation.InvertToBegin and (ColNo mod 2 = 0) then
            UseVecx := Propogation.Vec1x
          else
            UseVecx := Propogation.Vec2x;
          CutResults[Length(CutResults) - 1].W2 := False;
        end;
      end
      else
      begin
        if StartingLeft then
        begin
          if Propogation.InvertToBegin and (ColNo mod 2 = 0) then
            UseVecx := Propogation.Vec1x
          else
            UseVecx := Propogation.Vec2x;
          CutResults[Length(CutResults) - 1].W2 := False;
        end
        else
        begin
          if Propogation.InvertToBegin and (ColNo mod 2 = 0) then
            UseVecx := Propogation.Vec2x
          else
            UseVecx := Propogation.Vec1x;
          CutResults[Length(CutResults) - 1].W2 := True;
        end;
      end;

      if Propogation.InvertToBegin and (ColNo mod 2 = 0) then
        CutResults[Length(CutResults) - 1].W2 := not(CutResults[Length(CutResults) - 1].W2);

      if Propogation.W2First then
        CutResults[Length(CutResults) - 1].W2 := not(CutResults[Length(CutResults) - 1].W2);

      if StartingLeft then
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CurrentLeft + UseVecx;
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CutResults[Length(CutResults) - 1].BoundingRect.Left + Propogation.PatternWidth;
      end
      else
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CurrentRight - UseVecx;
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CutResults[Length(CutResults) - 1].BoundingRect.Right - Propogation.PatternWidth;
      end;
      CutResults[Length(CutResults) - 1].BoundingRect.Bottom := CurrentBottom;
      CutResults[Length(CutResults) - 1].BoundingRect.Top := CutResults[Length(CutResults) - 1].BoundingRect.Bottom - Propogation.PatternHeight;
      CutResults[Length(CutResults) - 1].KnifeNo := CurrentKnife;

      CutResults[Length(CutResults) - 1].Ghost := False;
      if StartingLeft then
        CurrentLeft := CutResults[Length(CutResults) - 1].BoundingRect.Left
      else
        CurrentRight := CutResults[Length(CutResults) - 1].BoundingRect.Right;
    end;
  end;
end;

procedure ResultsVertical(Propogation: TVPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                          StartingLeft, W2: Boolean);
var
  CurrentBottom, CurrentLeft, CurrentRight, FirstBottom: integer;
  RowNo, PositionInColumn, NoInColumn: integer;
  KnifeNo: integer;

begin
  //Clear Results of Pack ready to fill again with results of Layplan
  SetLength(CutResults, 0);

  //Initialisations - take back to add later
  if not StartingLeft then
  begin
    if Propogation.Vec3y > 0 then
      FirstBottom := UsableMaterialLength - Propogation.Vec3y
    else
      FirstBottom := UsableMaterialLength;
  end
  else
  begin
    if Propogation.Vec3y < 0 then
      FirstBottom := UsableMaterialLength + Propogation.Vec3y
    else
      FirstBottom := UsableMaterialLength;
  end;

  if StartingLeft then
    CurrentLeft := -abs(Propogation.Vec4x)
  else
    CurrentRight := UsableMaterialWidth + abs(Propogation.Vec4x);

  RowNo := 0;
  while (RowNo < Propogation.RowCount) or
        ((RowNo = Propogation.RowCount) and Propogation.ExtraHalfColumn) do
  begin
    PositionInColumn := 0;

    inc(RowNo);
    if RowNo mod 2 = 1 then
    begin
      //Odd columns
      CurrentBottom := FirstBottom + Propogation.Vec1y;

      if StartingLeft then
        CurrentLeft := CurrentLeft + abs(Propogation.Vec4x)
      else
        CurrentRight := CurrentRight - abs(Propogation.Vec4x);

      if Propogation.ExtraHalfOddColumnBottom then
      begin
        PositionInColumn := -1;
        CurrentBottom := CurrentBottom + Propogation.Vec1y;
      end;

      NoInColumn := Propogation.NoInOddColumn;
    end
    else
    begin
      //Even columns
      if StartingLeft then
      begin
        CurrentBottom := FirstBottom + Propogation.Vec1y - Propogation.Vec3y;
        CurrentLeft := CurrentLeft + abs(Propogation.Vec3x);
      end
      else
      begin
        CurrentBottom := FirstBottom + Propogation.Vec1y + Propogation.Vec3y;
        CurrentRight := CurrentRight - abs(Propogation.Vec3x);
      end;

      if Propogation.ExtraHalfEvenColumnBottom then
      begin
        PositionInColumn := -1;
        CurrentBottom := CurrentBottom + Propogation.Vec1y;
      end;

      NoInColumn := Propogation.NoInEvenColumn;
    end;

    while ((PositionInColumn < NoInColumn) or
          ((RowNo mod 2 = 1) and (PositionInColumn = NoInColumn) and Propogation.ExtraHalfOddColumnTop) or
          ((RowNo mod 2 = 0) and (PositionInColumn = NoInColumn) and Propogation.ExtraHalfEvenColumnTop)) do
    begin
      inc(PositionInColumn);

      SetLength(CutResults, Length(CutResults) + 1);
      if StartingLeft then
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CurrentLeft;
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CutResults[Length(CutResults) - 1].BoundingRect.Left + Propogation.PatternWidth;
      end
      else
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CurrentRight;
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CutResults[Length(CutResults) - 1].BoundingRect.Right - Propogation.PatternWidth;
      end;
      CutResults[Length(CutResults) - 1].BoundingRect.Bottom := CurrentBottom - Propogation.Vec1y;
      CutResults[Length(CutResults) - 1].BoundingRect.Top := CutResults[Length(CutResults) - 1].BoundingRect.Bottom - Propogation.PatternHeight;

      KnifeNo := KBOTH;
      //Decide whether either/or/both of pair of Patterns to use when Local Interlocking First
      if Propogation.LocalInterlock.Used then
      begin
        if (PositionInColumn = 0) then
        begin
          if (RowNo > Propogation.RowCount) then
          begin
            if (StartingLeft and Propogation.LocalInterlock.BottomIsLeft) or
               ((not StartingLeft) and (not Propogation.LocalInterlock.BottomIsLeft)) then
              KnifeNo := KNONE
            else
              KnifeNo := KTOP;
          end
          else if (((RowNo mod 2 = 1) and Propogation.ExtraHalfOddColumnBottom)) or
                  (((RowNo mod 2 = 0) and Propogation.ExtraHalfEvenColumnBottom)) then
            KnifeNo := KTOP;
        end
        else if (PositionInColumn = 0) then
          KnifeNo := KTOP
        else if (PositionInColumn > NoInColumn) then
        begin
          if (RowNo > Propogation.RowCount) then
          begin
            if (StartingLeft and Propogation.LocalInterlock.BottomIsLeft) or
               ((not StartingLeft) and (not Propogation.LocalInterlock.BottomIsLeft)) then
              KnifeNo := KBOTTOM
            else
              KnifeNo := KNONE;
          end
          else if (((RowNo mod 2 = 1) and Propogation.ExtraHalfOddColumnTop)) or
                  (((RowNo mod 2 = 0) and Propogation.ExtraHalfEvenColumnTop)) then
            KnifeNo := KBOTTOM;
        end
        else if (RowNo > Propogation.RowCount) then
        begin
          if StartingLeft then
            KnifeNo := KLEFT
          else
            KnifeNo := KRIGHT;
        end;
      end;

      if KnifeNo = KBOTH then
        CutResults[Length(CutResults) - 1].KnifeNo := CurrentKnife
      else
        CutResults[Length(CutResults) - 1].KnifeNo := -KnifeNo;

      if ((not StartingLeft) and (W2 and (RowNo mod 2 = 0))) or (StartingLeft and (W2 and (RowNo mod 2 = 1))) then
        CutResults[Length(CutResults) - 1].W2 := True
      else
        CutResults[Length(CutResults) - 1].W2 := False;

      if W2 and Propogation.VerticalRight then
        CutResults[Length(CutResults) - 1].W2 := not(CutResults[Length(CutResults) - 1].W2);

      CutResults[Length(CutResults) - 1].Ghost := False;
      CurrentBottom := CutResults[Length(CutResults) - 1].BoundingRect.Bottom;
    end;
  end;

  //Turn pairs of patterns into single patterns
  if Propogation.LocalInterlock.Used then
    SwapPairedPatternToSingles(Propogation.LocalInterlock);
end;

procedure ResultsVerticalP2Inverted(Propogation: TVP2IPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                                    StartingLeft: boolean);
var
  CurrentBottom, CurrentLeft, CurrentRight, FirstBottom, RowNo, PositionInColumn, NoInColumn, UseVecy: integer;

begin
  //Clear Results of Pack ready to fill again with results of Layplan
  SetLength(CutResults, 0);

  //Initialisations - take back to add later
  if Propogation.Vec3y > 0 then
    FirstBottom := UsableMaterialLength - Propogation.Vec3y
  else
    FirstBottom := UsableMaterialLength;

  if StartingLeft then
    CurrentLeft := - abs(Propogation.Vec4x)
  else
    CurrentRight := UsableMaterialWidth + abs(Propogation.Vec4x);

  RowNo := 0;
  while not (RowNo = Propogation.RowCount) do
  begin
    inc(RowNo);
    if RowNo mod 2 = 1 then
    begin
      //Odd columns
      CurrentBottom := FirstBottom + Propogation.Vec2y;

      if StartingLeft then
        CurrentLeft := CurrentLeft + abs(Propogation.Vec4x)
      else
        CurrentRight := CurrentRight - abs(Propogation.Vec4x);
      NoInColumn := Propogation.NoInOddColumn;
    end
    else
    begin
      //Even columns
      if Propogation.InvertToBegin then
        CurrentBottom := FirstBottom + Propogation.Vec3y + Propogation.Vec1y
      else
        CurrentBottom := FirstBottom + Propogation.Vec3y + Propogation.Vec2y;

      if StartingLeft then
        CurrentLeft := CurrentLeft + abs(Propogation.Vec3x)
      else
        CurrentRight := CurrentRight - abs(Propogation.Vec3x);
      NoInColumn := Propogation.NoInEvenColumn;
    end;

    PositionInColumn := 0;
    while not (PositionInColumn = NoInColumn) do
    begin
      inc(PositionInColumn);

      SetLength(CutResults, Length(CutResults) + 1);
      if PositionInColumn mod 2 = 1 then
      begin
        if Propogation.InvertToBegin and (RowNo mod 2 = 0) then
          UseVecy := Propogation.Vec1y
        else
          UseVecy := Propogation.Vec2y;
        CutResults[Length(CutResults) - 1].W2 := False;
      end
      else
      begin
        if Propogation.InvertToBegin and (RowNo mod 2 = 0) then
          UseVecy := Propogation.Vec2y
        else
          UseVecy := Propogation.Vec1y;
        CutResults[Length(CutResults) - 1].W2 := True;
      end;

      if Propogation.InvertToBegin and (RowNo mod 2 = 0) then
        CutResults[Length(CutResults) - 1].W2 := not(CutResults[Length(CutResults) - 1].W2);

      if Propogation.W2First then
        CutResults[Length(CutResults) - 1].W2 := not(CutResults[Length(CutResults) - 1].W2);

      CutResults[Length(CutResults) - 1].BoundingRect.Bottom := CurrentBottom - Usevecy;
      CutResults[Length(CutResults) - 1].BoundingRect.Top := CutResults[Length(CutResults) - 1].BoundingRect.Bottom - Propogation.PatternHeight;
      if StartingLeft then
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CurrentLeft;
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CutResults[Length(CutResults) - 1].BoundingRect.Left + Propogation.PatternWidth;
      end
      else
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CurrentRight;
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CutResults[Length(CutResults) - 1].BoundingRect.Right - Propogation.PatternWidth;
      end;
      CutResults[Length(CutResults) - 1].KnifeNo := CurrentKnife;

      CutResults[Length(CutResults) - 1].Ghost := False;
      CurrentBottom := CutResults[Length(CutResults) - 1].BoundingRect.Bottom;
    end;
  end;
end;

procedure ResultsHorizontalDiagonal(Propogation: THDPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                                    StartingLeft, W2: Boolean);
var
  CurrentBottom, CurrentLeft, CurrentRight: integer;
  ColNo, PositionInRow: integer;
  KnifeNo: integer;

begin
  //Clear Results of Pack ready to fill again with results of Layplan
  SetLength(CutResults, 0);

  //Initialisations - take back to add later
  CurrentBottom := UsableMaterialLength + abs(Propogation.Vec4y);

  ColNo := 0;
  while (ColNo < Length(Propogation.ARows) - 1) or
        ((ColNo = Length(Propogation.ARows) - 1) and Propogation.ExtraHalfRow) do
  begin
    inc(ColNo);
    if StartingLeft then
      CurrentLeft := Propogation.ARows[ColNo - 1].Start - Propogation.Vec1x
    else
      CurrentRight := Propogation.ARows[ColNo - 1].Start + Propogation.Vec1x;

    if (ColNo mod 2) = 1 then
      //Odd Rows
      CurrentBottom := CurrentBottom - abs(Propogation.Vec4y)
    else
      //Even rows
      CurrentBottom := CurrentBottom - abs(Propogation.Vec3y);

    if StartingLeft and (Propogation.ARows[ColNo - 1].ExtraHalfLeftNo > 0) then
    begin
      PositionInRow := -1;
      CurrentLeft := CurrentLeft - Propogation.Vec1x;
    end
    else if (not StartingLeft) and (Propogation.ARows[ColNo - 1].ExtraHalfRightNo > 0) then
    begin
      PositionInRow := -1;
      CurrentRight := CurrentRight + Propogation.Vec1x;
    end
    else
      PositionInRow := 0;

    while (PositionInRow < Propogation.ARows[ColNo - 1].No) or
          (((PositionInRow = Propogation.ARows[ColNo - 1].No) and (not StartingLeft) and (Propogation.ARows[ColNo - 1].ExtraHalfLeftNo > 0)) or
          ((PositionInRow = Propogation.ARows[ColNo - 1].No) and StartingLeft and (Propogation.ARows[ColNo - 1].ExtraHalfRightNo > 0))) do
    begin
      inc(PositionInRow);
      if StartingLeft then
        CurrentLeft := CurrentLeft + Propogation.Vec1x
      else
        CurrentRight := CurrentRight - Propogation.Vec1x;

      SetLength(CutResults, Length(CutResults) + 1);
      if StartingLeft then
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CurrentLeft;
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CutResults[Length(CutResults) - 1].BoundingRect.Left + Propogation.PatternWidth;
      end
      else
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CurrentRight;
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CutResults[Length(CutResults) - 1].BoundingRect.Right - Propogation.PatternWidth;
      end;
      CutResults[Length(CutResults) - 1].BoundingRect.Bottom := CurrentBottom;
      CutResults[Length(CutResults) - 1].BoundingRect.Top := CutResults[Length(CutResults) - 1].BoundingRect.Bottom - Propogation.PatternHeight;

      KnifeNo := KBOTH;
      //Decide whether either/or/both of pair of Patterns to use when Local Interlocking First
      if Propogation.LocalInterlock.Used then
      begin
        if (PositionInRow = 0) then
        begin
          if StartingLeft then
            KnifeNo := KRIGHT
          else
            KnifeNo := KLEFT;
        end
        else if (not StartingLeft) and (PositionInRow > Propogation.ARows[ColNo - 1].No) and
                (Propogation.ARows[ColNo - 1].ExtraHalfLeftNo > 0) then
          KnifeNo := KRIGHT
        else if StartingLeft and (PositionInRow > Propogation.ARows[ColNo - 1].No) and
                (Propogation.ARows[ColNo - 1].ExtraHalfRightNo > 0) then
          KnifeNo := KLEFT
        else if (ColNo = Length(Propogation.ARows)) then
          KnifeNo := KBOTTOM;
      end;

      if KnifeNo = KBOTH then
        CutResults[Length(CutResults) - 1].KnifeNo := CurrentKnife
      else
        CutResults[Length(CutResults) - 1].KnifeNo := -KnifeNo;

      if W2 and (ColNo mod 2 = 0) then
        CutResults[Length(CutResults) - 1].W2 := True
      else
        CutResults[Length(CutResults) - 1].W2 := False;

      if W2 and Propogation.SecondRowFirst then
        CutResults[Length(CutResults) - 1].W2 := not(CutResults[Length(CutResults) - 1].W2);

      CutResults[Length(CutResults) - 1].Ghost := False;
    end;
  end;

  //Turn pairs of patterns into single patterns
  if Propogation.LocalInterlock.Used then
    SwapPairedPatternToSingles(Propogation.LocalInterlock);
end;

procedure ResultsHorizontalP2InvertedDiagonal(Propogation: THP2IDPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                                              StartingLeft: boolean);
var
  CurrentBottom, CurrentLeft, CurrentRight: integer;
  ColNo, PositionInRow: integer;
  InvertStart: Boolean;

begin
  //Clear Results of Pack ready to fill again with results of Layplan
  SetLength(CutResults, 0);

  //Initialisations - take back to add later
  CurrentBottom := UsableMaterialLength + abs(Propogation.Vec3y);

  for ColNo := 1 to Length(Propogation.ARows) do
  begin
    if StartingLeft then
    begin
      if Propogation.ARows[ColNo - 1].W2Start then
        CurrentLeft := Propogation.ARows[ColNo - 1].Start - Propogation.Vec1x
      else
        CurrentLeft := Propogation.ARows[ColNo - 1].Start - Propogation.Vec2x;
    end
    else
    begin
      if Propogation.ARows[ColNo - 1].W2Start then
        CurrentRight := Propogation.ARows[ColNo - 1].Start + Propogation.Vec1x
      else
        CurrentRight := Propogation.ARows[ColNo - 1].Start + Propogation.Vec2x;
    end;
    CurrentBottom := CurrentBottom - abs(Propogation.Vec3y);

    PositionInRow := 0;
    while not (PositionInRow = Propogation.ARows[ColNo - 1].No) do
    begin
      inc(PositionInRow);

      InvertStart := ((PositionInRow mod 2) = 1);
      if Propogation.ARows[ColNo - 1].W2Start then
        InvertStart := not InvertStart;

      if StartingLeft then
      begin
        if InvertStart then
          CurrentLeft := CurrentLeft + Propogation.Vec2x
        else
          CurrentLeft := CurrentLeft + Propogation.Vec1x;
      end
      else
      begin
        if InvertStart then
          CurrentRight := CurrentRight - Propogation.Vec2x
        else
          CurrentRight := CurrentRight - Propogation.Vec1x;
      end;

      SetLength(CutResults, Length(CutResults) + 1);
      if StartingLeft then
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CurrentLeft;
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CutResults[Length(CutResults) - 1].BoundingRect.Left + Propogation.PatternWidth;
      end
      else
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CurrentRight;
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CutResults[Length(CutResults) - 1].BoundingRect.Right - Propogation.PatternWidth;
      end;
      CutResults[Length(CutResults) - 1].BoundingRect.Bottom := CurrentBottom;
      CutResults[Length(CutResults) - 1].BoundingRect.Top := CutResults[Length(CutResults) - 1].BoundingRect.Bottom - Propogation.PatternHeight;
      CutResults[Length(CutResults) - 1].KnifeNo := CurrentKnife;

      if (PositionInRow mod 2 = 0) then
        CutResults[Length(CutResults) - 1].W2 := True
      else
        CutResults[Length(CutResults) - 1].W2 := False;

      if Propogation.ARows[ColNo - 1].W2Start then
        CutResults[Length(CutResults) - 1].W2 := not(CutResults[Length(CutResults) - 1].W2);

      CutResults[Length(CutResults) - 1].Ghost := False;
    end;
  end;
end;

procedure ResultsVerticalDiagonal(Propogation: TVDPropogation; UsableMaterialLength, UsableMaterialWidth: integer; StartingLeft, W2: Boolean);
var
  CurrentBottom, CurrentLeft, CurrentRight: integer;
  RowNo, PositionInColumn: integer;
  KnifeNo: integer;

begin
  //Clear Results of Pack ready to fill again with results of Layplan
  SetLength(CutResults, 0);

  //Initialisations - take back to add later
  if StartingLeft then
    CurrentLeft := - abs(Propogation.Vec4x)
  else
    CurrentRight := UsableMaterialWidth + abs(Propogation.Vec4x);

  RowNo := 0;
  while (RowNo < Length(Propogation.AColumns) - 1) or
        ((RowNo = Length(Propogation.AColumns) - 1) and Propogation.ExtraHalfColumn) do
  begin
    inc(RowNo);
    CurrentBottom := Propogation.AColumns[RowNo - 1].Start + Propogation.Vec1y;

    if (RowNo mod 2) = 1 then
    begin
      //Odd columns
      if StartingLeft then
        CurrentLeft := CurrentLeft + abs(Propogation.Vec4x)
      else
        CurrentRight := CurrentRight - abs(Propogation.Vec4x);
    end
    else
    begin
      //Even columns
      if StartingLeft then
        CurrentLeft := CurrentLeft + abs(Propogation.Vec3x)
      else
        CurrentRight := CurrentRight - abs(Propogation.Vec3x);
    end;

    if (Propogation.AColumns[RowNo - 1].ExtraHalfBottomNo > 0) then
    begin
      PositionInColumn := -1;
      CurrentBottom := CurrentBottom + Propogation.Vec1y;
    end
    else
      PositionInColumn := 0;

    while ((PositionInColumn < Propogation.AColumns[RowNo - 1].No) or
          ((PositionInColumn = Propogation.AColumns[RowNo - 1].No) and (Propogation.AColumns[RowNo - 1].ExtraHalfTopNo > 0))) do
    begin
      inc(PositionInColumn);
      CurrentBottom := CurrentBottom - Propogation.Vec1y;

      SetLength(CutResults, Length(CutResults) + 1);
      if StartingLeft then
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CurrentLeft;
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CutResults[Length(CutResults) - 1].BoundingRect.Left + Propogation.PatternWidth;
      end
      else
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CurrentRight;
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CutResults[Length(CutResults) - 1].BoundingRect.Right - Propogation.PatternWidth;
      end;
      CutResults[Length(CutResults) - 1].BoundingRect.Bottom := CurrentBottom;
      CutResults[Length(CutResults) - 1].BoundingRect.Top := CutResults[Length(CutResults) - 1].BoundingRect.Bottom - Propogation.PatternHeight;

      KnifeNo := KBOTH;
      //Decide whether either/or/both of pair of Patterns to use when Local Interlocking First
      if Propogation.LocalInterlock.Used then
      begin
        if (PositionInColumn = 0) then
          KnifeNo := KTOP
        else if (PositionInColumn > Propogation.AColumns[RowNo - 1].No) and
                (Propogation.AColumns[RowNo - 1].ExtraHalfTopNo > 0) then
          KnifeNo := KBOTTOM
        else if (RowNo = Length(Propogation.AColumns)) then
        begin
          if StartingLeft then
            KnifeNo := KLEFT
          else
            KnifeNo := KRIGHT;
        end;
      end;

      if KnifeNo = KBOTH then
        CutResults[Length(CutResults) - 1].KnifeNo := CurrentKnife
      else
        CutResults[Length(CutResults) - 1].KnifeNo := -KnifeNo;

      if W2 and (RowNo mod 2 = 0) then
        CutResults[Length(CutResults) - 1].W2 := True
      else
        CutResults[Length(CutResults) - 1].W2 := False;

      if W2 and Propogation.SecondColumnFirst then
        CutResults[Length(CutResults) - 1].W2 := not(CutResults[Length(CutResults) - 1].W2);

      CutResults[Length(CutResults) - 1].Ghost := False;
    end;
  end;

  //Turn pairs of patterns into single patterns
  if Propogation.LocalInterlock.Used then
    SwapPairedPatternToSingles(Propogation.LocalInterlock);
end;

procedure ResultsVerticalP2InvertedDiagonal(Propogation: TVP2IDPropogation; UsableMaterialLength, UsableMaterialWidth: integer;
                                            StartingLeft: Boolean);
var
  CurrentBottom, CurrentLeft, CurrentRight: integer;
  RowNo, PositionInColumn: integer;
  InvertStart: Boolean;

begin
  //Clear Results of Pack ready to fill again with results of Layplan
  SetLength(CutResults, 0);

  //Initialisations - take back to add later
  if StartingLeft then
    CurrentLeft := -abs(Propogation.Vec3x)
  else
    CurrentRight := UsableMaterialWidth + abs(Propogation.Vec3x);

  for RowNo := 1 to Length(Propogation.AColumns) do
  begin
    if Propogation.AColumns[RowNo - 1].W2Start then
      CurrentBottom := Propogation.AColumns[RowNo - 1].Start + Propogation.Vec1y
    else
      CurrentBottom := Propogation.AColumns[RowNo - 1].Start + Propogation.Vec2y;

    if StartingLeft then
      CurrentLeft := CurrentLeft + abs(Propogation.Vec3x)
    else
      CurrentRight := CurrentRight - abs(Propogation.Vec3x);

    PositionInColumn := 0;
    while not (PositionInColumn = Propogation.AColumns[RowNo - 1].No) do
    begin
      inc(PositionInColumn);

      InvertStart := ((PositionInColumn mod 2) = 1);
      if Propogation.AColumns[RowNo - 1].W2Start then
        InvertStart := not InvertStart;

      if InvertStart then
        CurrentBottom := CurrentBottom - Propogation.Vec2y
      else
        CurrentBottom := CurrentBottom - Propogation.Vec1y;

      SetLength(CutResults, Length(CutResults) + 1);
      CutResults[Length(CutResults) - 1].BoundingRect.Bottom := CurrentBottom;
      CutResults[Length(CutResults) - 1].BoundingRect.Top := CutResults[Length(CutResults) - 1].BoundingRect.Bottom - Propogation.PatternHeight;
      if StartingLeft then
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CurrentLeft;
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CutResults[Length(CutResults) - 1].BoundingRect.Left + Propogation.PatternWidth;
      end
      else
      begin
        CutResults[Length(CutResults) - 1].BoundingRect.Right := CurrentRight;
        CutResults[Length(CutResults) - 1].BoundingRect.Left := CutResults[Length(CutResults) - 1].BoundingRect.Right - Propogation.PatternWidth;
      end;
      CutResults[Length(CutResults) - 1].KnifeNo := CurrentKnife;

      if (PositionInColumn mod 2 = 0) then
        CutResults[Length(CutResults) - 1].W2 := True
      else
        CutResults[Length(CutResults) - 1].W2 := False;

      if Propogation.AColumns[RowNo - 1].W2Start then
        CutResults[Length(CutResults) - 1].W2 := not(CutResults[Length(CutResults) - 1].W2);

      CutResults[Length(CutResults) - 1].Ghost := False;
    end;
  end;
end;

procedure ResultsFreeDiagonal(Propogation: TFDPropogation; UsableMaterialLength, UsableMaterialWidth: integer; StartingLeft, W2: Boolean);
var
  CurrentBottom, CurrentLeft, CurrentRight: integer;
  RowNo, PositionInColumn: integer;
  KnifeNo: integer;

begin
  //Clear Results of Pack ready to fill again with results of Layplan
  SetLength(CutResults, 0);

  RowNo := 0;
  while (RowNo < Length(Propogation.AColumns)) do
  begin
    inc(RowNo);
    CurrentLeft := Propogation.AColumns[RowNo - 1].Startx;
    if not StartingLeft then
      CurrentLeft := CurrentLeft - Propogation.Vec1x;
    CurrentBottom := Propogation.AColumns[RowNo - 1].Starty + Propogation.Vec1y;

    if Propogation.AColumns[RowNo - 1].ExtraHalfBottomNo > 0 then
    begin
      PositionInColumn := -Propogation.AColumns[RowNo - 1].ExtraHalfBottomNo;
      CurrentBottom := CurrentBottom + (abs(PositionInColumn) * Propogation.Vec1y);
      CurrentLeft := CurrentLeft - (abs(PositionInColumn) * Propogation.Vec1x);
    end
    else
      PositionInColumn := 0;

    while (PositionInColumn < Propogation.AColumns[RowNo - 1].No + Propogation.AColumns[RowNo - 1].ExtraHalfTopNo) do
    begin
      inc(PositionInColumn);
      CurrentBottom := CurrentBottom - Propogation.Vec1y;

      SetLength(CutResults, Length(CutResults) + 1);
      CurrentLeft := CurrentLeft + Propogation.Vec1x;
      CutResults[Length(CutResults) - 1].BoundingRect.Left := CurrentLeft;
      CutResults[Length(CutResults) - 1].BoundingRect.Right := CutResults[Length(CutResults) - 1].BoundingRect.Left + Propogation.PatternWidth;
      CutResults[Length(CutResults) - 1].BoundingRect.Bottom := CurrentBottom;
      CutResults[Length(CutResults) - 1].BoundingRect.Top := CutResults[Length(CutResults) - 1].BoundingRect.Bottom - Propogation.PatternHeight;

      KnifeNo := KBOTH;
      //Decide whether either/or/both of pair of Patterns to use when Local Interlocking First
      if Propogation.LocalInterlock.Used then
      begin
        if (PositionInColumn <= 0) then
          KnifeNo := Propogation.AColumns[RowNo - 1].ExtraHalfBottomType
        else if (PositionInColumn > Propogation.AColumns[RowNo - 1].No) then
          KnifeNo := Propogation.AColumns[RowNo - 1].ExtraHalfTopType;
      end;

      if KnifeNo = KBOTH then
        CutResults[Length(CutResults) - 1].KnifeNo := CurrentKnife
      else
        CutResults[Length(CutResults) - 1].KnifeNo := -KnifeNo;

      if W2 and (RowNo mod 2 = 0) then
        CutResults[Length(CutResults) - 1].W2 := True
      else
        CutResults[Length(CutResults) - 1].W2 := False;

      if W2 and (RowNo >= Propogation.FirstBackFillColumnNo) and (Propogation.FirstBackFillColumnNo mod 2 = 1) then
        CutResults[Length(CutResults) - 1].W2 := not CutResults[Length(CutResults) - 1].W2;

      if W2 and Propogation.SecondColumnFirst then
        CutResults[Length(CutResults) - 1].W2 := not(CutResults[Length(CutResults) - 1].W2);

      CutResults[Length(CutResults) - 1].Ghost := False;
    end;
  end;

  //Turn pairs of patterns into single patterns
  if Propogation.LocalInterlock.Used then
    SwapPairedPatternToSingles(Propogation.LocalInterlock);
end;

procedure PropogateHorizontal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                              Square, FixedStart, StartLeft, W2, FirstCutInCorner: boolean;
                              LocalInterlock: TLocalInterlock;
                              var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                              var RemainingArea: real; var StartingLeft: Boolean);
var
  i, ColCount, Loops, MaterialLengthAfterFirst, MaterialWidthAfterFirst, RemainingWidth1, RemainingWidth2, NoInOddRow,
  NoInEvenRow, Vec1x, Vec3x, Vec3y, Vec4x, Vec4y: integer;
  LeftPropogation, RightPropogation, Propogation: THPropogation;
  HorizontalBottom: Boolean;
  ExtraHalfOddRow, ExtraHalfEvenRow, ExtraHalfRow: Boolean;
  ExtraHalfOddRowStart, ExtraHalfEvenRowStart: Boolean;
  SpaceForExtraHalf: integer;
  KeepResults: Boolean;
  HoldLocalInterlock: TLocalInterlock;

begin
{$IFDEF DEBUG}
  Prop := GetTickCount;
{$ENDIF}

  //Pre Results
  FillPropogationInput(PROPOGATION_HORIZONTAL, UsableMaterialLength,
                       UsableMaterialWidth, PatternHeight, PatternWidth, Square,
                       FixedStart, StartLeft, W2, FirstCutInCorner, FALSE, FALSE,
                       LocalInterlock, 0.0);

  HoldLocalInterlock := LocalInterlock;
  LeftPropogation.NumberOfPatterns := 0;
  RightPropogation.NumberOfPatterns := 0;

  if (not FixedStart) and LocalInterlock.Used then
    Loops := 4
  else if FixedStart and LocalInterlock.Used then
    Loops := 2
  else if FixedStart or Square or (not FirstCutInCorner) then  //the only time there will be a difference in how many fit is
  begin                                                        //when offset pack and FirstCutInCorner is forced, therefore
    FixedStart := True;                                        //only compare right and left start results then.
    Loops := 1;
  end
  else
    Loops := 2;

  StartingLeft := True;
  for i := 1 to Loops do
  begin
    if FixedStart then
      StartingLeft := StartLeft
    else
      StartingLeft := not StartingLeft;

    if LocalInterlock.Used then
    begin
      //First with normal interlock, then with reversed interlock
      LocalInterlock := LocalInterlockToUse(HoldLocalInterlock, HORIZONTAL, (i > (Loops div 2)), FirstCutInCorner, StartingLeft);
      PatternWidth := LocalInterlock.PairedPatternWidth;
    end;

    //Calculate required vectors
    //Assumes 12, 8, 4, 0 (Interlocked to Left - Normal)
    HorizontalBottom := False;
    Vec1x := abs(CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left);
    Vec3x := CutResults[4].BoundingRect.Left - CutResults[0].BoundingRect.Left;
    Vec3y := CutResults[4].BoundingRect.Top - CutResults[0].BoundingRect.Top;
    Vec4x := CutResults[8].BoundingRect.Left - CutResults[4].BoundingRect.Left;
    Vec4y := CutResults[8].BoundingRect.Top - CutResults[4].BoundingRect.Top;
    if Vec3y > 0 then
    begin
      //Actually 8, 12, 0, 4 (Interlocked to Right - Inverted)
      HorizontalBottom := True;
      Vec3x := -Vec3x;
      Vec3y := -Vec3y;
      Vec4x := CutResults[12].BoundingRect.Left - CutResults[0].BoundingRect.Left;
      Vec4y := CutResults[12].BoundingRect.Top - CutResults[0].BoundingRect.Top;
    end;

    //Adjust so First Cut is in Corner if it is required and presently isn't
    if StartingLeft then
    begin
      if (Vec3x < 0) and FirstCutInCorner then
      begin
        Vec3x := Vec3x + Vec1x;
        Vec4x := Vec4x - Vec1x;
        if Vec4x > (Vec1x / 2) then
          Vec4x := Vec4x + Vec1x;
      end;
    end
    else if (Vec3x > 0) and FirstCutInCorner then
    begin
      Vec3x := Vec3x - Vec1x;
      Vec4x := Vec4x + Vec1x;
      if Vec4x > (Vec1x / 2) then
        Vec4x := Vec4x - Vec1x;
    end;

{    //Calculate Material left after first pattern in Odd Rows
    if Vec3x < 0 then
      MaterialWidthAfterFirst := UsableMaterialWidth - PatternWidth
    else
      MaterialWidthAfterFirst := UsableMaterialWidth - (PatternWidth + Vec3x);
 }
    //Calculate Material left after first pattern in Odd Rows
    if ((not StartingLeft) and (Vec3x > 0)) then
      MaterialWidthAfterFirst := UsableMaterialWidth - (PatternWidth + Vec3x)
    else if (StartingLeft and (Vec3x < 0)) then
      MaterialWidthAfterFirst := UsableMaterialWidth - (PatternWidth - Vec3x)
    else
      MaterialWidthAfterFirst := UsableMaterialWidth - PatternWidth;

    //Calculate number of Patterns in Odd Rows
    NoInOddRow := 1 + (MaterialWidthAfterFirst div Vec1x);
    RemainingWidth1 := MaterialWidthAfterFirst - ((NoInOddRow - 1) * Vec1x);

    //Decide on extra 'half' pattern in Odd Rows
    SpaceForExtraHalf := UsableMaterialWidth - (NoInOddRow * Vec1x);
    if ((not StartingLeft) and (Vec3x > 0)) then
      SpaceForExtraHalf := SpaceForExtraHalf - Vec3x
    else if (StartingLeft and (Vec3x < 0)) then
      SpaceForExtraHalf := SpaceForExtraHalf + Vec3x;
    ExtraHalfOddRow := LocalInterlock.Used and (LocalInterlock.SinglePatternWidth <= SpaceForExtraHalf);
    if ExtraHalfOddRow then
      RemainingWidth1 := SpaceForExtraHalf - LocalInterlock.SinglePatternWidth;

    //Decide on extra 'half' pattern at start of Odd Rows
    if ((not StartingLeft) and (Vec3x > 0)) or (StartingLeft and (Vec3x < 0)) then
      ExtraHalfOddRowStart := LocalInterlock.Used and (LocalInterlock.SinglePatternWidth <= (abs(Vec3x) + (PatternWidth - abs(Vec1x))))
    else
      ExtraHalfOddRowStart := False;

{    //Calculate Material left after first pattern in Even Rows
    if Vec3x < 0 then
      MaterialWidthAfterFirst := UsableMaterialWidth - (PatternWidth - Vec3x)
    else
      MaterialWidthAfterFirst := UsableMaterialWidth - PatternWidth;       }

    //Calculate Material left after first pattern in Even rows
    if ((not StartingLeft) and (Vec3x < 0)) then
      MaterialWidthAfterFirst := UsableMaterialWidth - (PatternWidth - Vec3x)
    else if (StartingLeft and (Vec3x > 0)) then
      MaterialWidthAfterFirst := UsableMaterialWidth - (PatternWidth + Vec3x)
    else
      MaterialWidthAfterFirst := UsableMaterialWidth - PatternWidth;

    //Calculate number of Patterns in Even Rows
    NoInEvenRow := 1 + (MaterialWidthAfterFirst div Vec1x);
    RemainingWidth2 := MaterialWidthAfterFirst - ((NoInEvenRow - 1) * Vec1x);

    //Decide on extra 'half' pattern in Even Rows
    SpaceForExtraHalf := UsableMaterialWidth - (NoInEvenRow * Vec1x);
    if ((not StartingLeft) and (Vec3x < 0)) then
      SpaceForExtraHalf := SpaceForExtraHalf + Vec3x
    else if (StartingLeft and (Vec3x > 0)) then
      SpaceForExtraHalf := SpaceForExtraHalf - Vec3x;
    ExtraHalfEvenRow := LocalInterlock.Used and (LocalInterlock.SinglePatternWidth <= SpaceForExtraHalf);
    if ExtraHalfEvenRow then
      RemainingWidth2 := SpaceForExtraHalf - LocalInterlock.SinglePatternWidth;

    //Decide on extra 'half' pattern at start of Even Rows
    if ((not StartingLeft) and (Vec3x < 0)) or (StartingLeft and (Vec3x > 0)) then
      ExtraHalfEvenRowStart := LocalInterlock.Used and (LocalInterlock.SinglePatternWidth <= (abs(Vec3x) + (PatternWidth - abs(Vec1x))))
    else
      ExtraHalfEvenRowStart := False;

    //Overall Remaining Width
    RemainingWidth := min(RemainingWidth1, RemainingWidth2);

    //Calculate for rest of sheet
    MaterialLengthAfterFirst := UsableMaterialLength - PatternHeight;
    ColCount := 1 + ((MaterialLengthAfterFirst div (abs(Vec3y) + abs(Vec4y))) * 2);
    RemainingHeight := MaterialLengthAfterFirst - ((ColCount div 2) * (abs(Vec3y) + abs(Vec4y)));
    if RemainingHeight > abs(Vec3y) then
    begin
      inc(ColCount);
      RemainingHeight := RemainingHeight - abs(Vec3y);
    end;

    //Decide on extra 'half' Row
    ExtraHalfRow := LocalInterlock.Used and ((((ColCount div 2) * (abs(Vec3y) + abs(Vec4y))) + ((ColCount mod 2) * abs(Vec3y)) + LocalInterlock.SinglePatternHeight) < UsableMaterialLength);
    if ExtraHalfRow then
      RemainingHeight := UsableMaterialLength - (((ColCount div 2) * (abs(Vec3y) + abs(Vec4y))) + ((ColCount mod 2) * abs(Vec3y)) + LocalInterlock.SinglePatternHeight);

    //Calculate number of patterns for sheet
    NumberOfPatterns := (NoInOddRow * ((ColCount div 2) + (ColCount mod 2))) + (NoInEvenRow * (ColCount div 2));
    if LocalInterlock.Used then
    begin
      NumberOfPatterns := NumberOfPatterns * 2;
      if ExtraHalfOddRow then
      begin
{        NumberOfPatterns := NumberOfPatterns + (ColCount div 2);
        if (not StartingLeft) then
}          NumberOfPatterns := NumberOfPatterns + (ColCount div 2) + (ColCount mod 2);
      end;
      if ExtraHalfEvenRow then
      begin
        NumberOfPatterns := NumberOfPatterns + (ColCount div 2);
{        if StartingLeft then
          NumberOfPatterns := NumberOfPatterns + (ColCount mod 2);
}      end;
      if ExtraHalfOddRowStart then
      begin
{        NumberOfPatterns := NumberOfPatterns + (ColCount div 2);
        if (not StartingLeft) then
}          NumberOfPatterns := NumberOfPatterns + (ColCount div 2) + (ColCount mod 2);
      end;
      if ExtraHalfEvenRowStart then
      begin
        NumberOfPatterns := NumberOfPatterns + (ColCount div 2);
{        if StartingLeft then
          NumberOfPatterns := NumberOfPatterns + (ColCount mod 2);
}      end;
      if ExtraHalfRow then
      begin
//        if (((ColCount mod 2) = 0) and (not StartingLeft)) or (((ColCount mod 2) = 1) and StartingLeft) then
        if (ColCount mod 2 = 0) then
        begin
          NumberOfPatterns := NumberOfPatterns + NoInOddRow;
          if ExtraHalfOddRow and ((LocalInterlock.BottomIsLeft and StartingLeft) or ((not LocalInterlock.BottomIsLeft) and (not StartingLeft))) then
            inc(NumberOfPatterns);
          if ExtraHalfOddRowStart and (((not LocalInterlock.BottomIsLeft) and StartingLeft) or (LocalInterlock.BottomIsLeft and (not StartingLeft))) then
            inc(NumberOfPatterns);
        end
        else
        begin
          NumberOfPatterns := NumberOfPatterns + NoInEvenRow;
          if ExtraHalfEvenRow and ((LocalInterlock.BottomIsLeft and StartingLeft) or ((not LocalInterlock.BottomIsLeft) and (not StartingLeft))) then
            inc(NumberOfPatterns);
          if ExtraHalfEvenRowStart and (((not LocalInterlock.BottomIsLeft) and StartingLeft) or (LocalInterlock.BottomIsLeft and (not StartingLeft))) then
            inc(NumberOfPatterns);
        end;
      end;
    end;
    RemainingArea := UncutArea(UsableMaterialLength, UsableMaterialWidth, RemainingHeight, RemainingWidth);

    KeepResults := False;
    if StartingLeft then
    begin
      if (NumberOfPatterns > LeftPropogation.NumberOfPatterns) or
         ((NumberOfPatterns = LeftPropogation.NumberOfPatterns) and
          (RemainingArea > LeftPropogation.RemainingArea)) then
        KeepResults := True;

      if KeepResults then
      begin
        LeftPropogation.PatternHeight := PatternHeight;
        LeftPropogation.PatternWidth := PatternWidth;
        LeftPropogation.HorizontalBottom := HorizontalBottom;
        LeftPropogation.NumberOfPatterns := NumberOfPatterns;
        LeftPropogation.NoInOddRow := NoInOddRow;
        LeftPropogation.NoInEvenRow := NoInEvenRow;
        LeftPropogation.ColCount := ColCount;
        LeftPropogation.RemainingWidth := RemainingWidth;
        LeftPropogation.RemainingHeight := RemainingHeight;
        LeftPropogation.RemainingArea := RemainingArea;
        LeftPropogation.Vec1x := Vec1x;
        LeftPropogation.Vec3x := -Vec3x;
        LeftPropogation.Vec3y := Vec3y;
        LeftPropogation.Vec4x := -Vec4x;
        LeftPropogation.Vec4y := Vec4y;
        LeftPropogation.LocalInterlock := LocalInterlock;
{        LeftPropogation.ExtraHalfOddRow := ExtraHalfEvenRow;           //ExtraHalfOddRow;
        LeftPropogation.ExtraHalfEvenRow := ExtraHalfOddRow;           //ExtraHalfEvenRow;
        LeftPropogation.ExtraHalfOddRowStart := ExtraHalfEvenRowStart; //ExtraHalfOddRowStart
        LeftPropogation.ExtraHalfEvenRowStart := ExtraHalfOddRowStart; //ExtraHalfEvenRowStart}
        LeftPropogation.ExtraHalfOddRow := ExtraHalfOddRow;
        LeftPropogation.ExtraHalfEvenRow := ExtraHalfEvenRow;
        LeftPropogation.ExtraHalfOddRowStart := ExtraHalfOddRowStart;
        LeftPropogation.ExtraHalfEvenRowStart := ExtraHalfEvenRowStart;
        LeftPropogation.ExtraHalfRow := ExtraHalfRow;
      end;
    end
    else
    begin
      if (NumberOfPatterns > RightPropogation.NumberOfPatterns) or
         ((NumberOfPatterns = RightPropogation.NumberOfPatterns) and
          (RemainingArea > RightPropogation.RemainingArea)) then
        KeepResults := True;

      if KeepResults then
      begin
        RightPropogation.PatternHeight := PatternHeight;
        RightPropogation.PatternWidth := PatternWidth;
        RightPropogation.HorizontalBottom := HorizontalBottom;
        RightPropogation.NumberOfPatterns := NumberOfPatterns;
        RightPropogation.NoInOddRow := NoInOddRow;
        RightPropogation.NoInEvenRow := NoInEvenRow;
        RightPropogation.ColCount := ColCount;
        RightPropogation.RemainingWidth := RemainingWidth;
        RightPropogation.RemainingHeight := RemainingHeight;
        RightPropogation.RemainingArea := RemainingArea;
        RightPropogation.Vec1x := Vec1x;
        RightPropogation.Vec3x := Vec3x;
        RightPropogation.Vec3y := Vec3y;
        RightPropogation.Vec4x := Vec4x;
        RightPropogation.Vec4y := Vec4y;
        RightPropogation.LocalInterlock := LocalInterlock;
        RightPropogation.ExtraHalfOddRow := ExtraHalfOddRow;
        RightPropogation.ExtraHalfEvenRow := ExtraHalfEvenRow;
        RightPropogation.ExtraHalfRow := ExtraHalfRow;
        RightPropogation.ExtraHalfOddRowStart := ExtraHalfOddRowStart;
        RightPropogation.ExtraHalfEvenRowStart := ExtraHalfEvenRowStart;
      end;
    end;
  end;

  if FixedStart or (LeftPropogation.NumberOfPatterns = RightPropogation.NumberOfPatterns) then
  begin
    if StartLeft then
      Propogation := LeftPropogation
    else
      Propogation := RightPropogation;

    StartingLeft := StartLeft;
  end
  else if (LeftPropogation.NumberOfPatterns > RightPropogation.NumberOfPatterns) then
  begin
    Propogation := LeftPropogation;
    StartingLeft := True;
  end
  else if (RightPropogation.NumberOfPatterns > LeftPropogation.NumberOfPatterns) then
  begin
    Propogation := RightPropogation;
    StartingLeft := False;
  end;

  ResultsHorizontal(Propogation, UsableMaterialLength, UsableMaterialWidth, StartingLeft, W2);

  //Results
  NumberOfPatterns := Propogation.NumberOfPatterns;
  RemainingHeight := Propogation.RemainingHeight;
  RemainingWidth := Propogation.RemainingWidth;
  RemainingArea := Propogation.RemainingArea;

{$IFDEF DEBUG}
  Prop := GetTickCount - Prop;
  TotalProp := TotalProp + Prop;
{$ENDIF}
end;

procedure PropogateHorizontalP2Inverted(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                                        Square, FixedStart, StartLeft, FirstCutInCorner, ForceW1First,
                                        ForceW2First: boolean;
                                        var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                        var RemainingArea: real; var StartingLeft: Boolean);
var
  i, j, PositionInCol, StartPositionVariations, RowNo, ColCount, FirstBottom, Firstw, Lastw, Lastvec, Loops,
  MaterialLengthAfterFirst, MaterialWidthAfterFirst, Pullback, RemainingWidth1, RemainingWidth2, NoInRow, NoInOddRow,
  NoInEvenRow, TempVecx, Vec1x, Vec1y, Vec2x, Vec3x, Vec3y, Vec4x, Vec4y, w: integer;
  BestPropogation, LeftPropogation, RightPropogation, LeftW1Propogation, RightW1Propogation, LeftW2Propogation,
  RightW2Propogation, LeftW1CornerPropogation, LeftW1OffsetPropogationA, LeftW1OffsetPropogationB,
  LeftW2CornerPropogation, LeftW2OffsetPropogationA, LeftW2OffsetPropogationB, RightW1CornerPropogation,
  RightW1OffsetPropogationA, RightW1OffsetPropogationB, RightW2CornerPropogation, RightW2OffsetPropogationA,
  RightW2OffsetPropogationB: THP2IPropogation;
  FirstCutOffset, InvertToBegin, W2First: boolean;

begin
{$IFDEF DEBUG}
  Prop := GetTickCount;
{$ENDIF}

  //Pre Results
  FillPropogationInput(PROPOGATION_HORIZONTALP2INVERTED, UsableMaterialLength,
                       UsableMaterialWidth, PatternHeight, PatternWidth, Square,
                       FixedStart, StartLeft, FALSE, FirstCutInCorner,
                       ForceW1First, ForceW2First, EmptyLocalInterlock, 0.0);

  LeftPropogation.NumberOfPatterns := 0;
  LeftPropogation.RemainingArea := 0;
  RightPropogation.NumberOfPatterns := 0;
  RightPropogation.RemainingArea := 0;
  LeftW1CornerPropogation.NumberOfPatterns := 0;
  LeftW1CornerPropogation.RemainingArea := 0;
  LeftW1OffsetPropogationA.NumberOfPatterns := 0;
  LeftW1OffsetPropogationA.RemainingArea := 0;
  LeftW1OffsetPropogationB.NumberOfPatterns := 0;
  LeftW1OffsetPropogationB.RemainingArea := 0;
  LeftW2CornerPropogation.NumberOfPatterns := 0;
  LeftW2CornerPropogation.RemainingArea := 0;
  LeftW2OffsetPropogationA.NumberOfPatterns := 0;
  LeftW2OffsetPropogationA.RemainingArea := 0;
  LeftW2OffsetPropogationB.NumberOfPatterns := 0;
  LeftW2OffsetPropogationB.RemainingArea := 0;
  RightW1CornerPropogation.NumberOfPatterns := 0;
  RightW1CornerPropogation.RemainingArea := 0;
  RightW1OffsetPropogationA.NumberOfPatterns := 0;
  RightW1OffsetPropogationA.RemainingArea := 0;
  RightW1OffsetPropogationB.NumberOfPatterns := 0;
  RightW1OffsetPropogationB.RemainingArea := 0;
  RightW2CornerPropogation.NumberOfPatterns := 0;
  RightW2CornerPropogation.RemainingArea := 0;
  RightW2OffsetPropogationA.NumberOfPatterns := 0;
  RightW2OffsetPropogationA.RemainingArea := 0;
  RightW2OffsetPropogationB.NumberOfPatterns := 0;
  RightW2OffsetPropogationB.RemainingArea := 0;

  if (FixedStart or Square) and not FirstCutInCorner and not(ForceW1First or ForceW2First) then
  begin                                                   //the only time there will be a difference in how many fit is
    Loops := 1;                                           //when offset pack and FirstCutInCorner is forced or W1/W2
    StartingLeft := StartLeft;                            //forced starts are used, therefore only compare right
  end                                                     //and left start results then.
  else
  begin
    Loops := 2;
    StartingLeft := False;
  end;

  for i := 1 to Loops do
  begin
    if i = 2 then
      StartingLeft := True;

    //Decide which 'w's to try
    Firstw := 1;
    Lastw := 2;
    if ForceW1First then
      Lastw := 1
    else if ForceW2First then
      Firstw := 2;

    for w := Firstw to Lastw do
    begin
      W2First := (w = 2);

      //Calculate required vectors - must be here as vectors get altered during calculations and need resetting.
      Vec1x := abs(CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left);
      Vec2x := abs(CutResults[2].BoundingRect.Left - CutResults[1].BoundingRect.Left);
      Vec3x := CutResults[4].BoundingRect.Left - CutResults[0].BoundingRect.Left;
      Vec3y := CutResults[4].BoundingRect.Top - CutResults[0].BoundingRect.Top;
      Vec4x := CutResults[8].BoundingRect.Left - CutResults[4].BoundingRect.Left;
      Vec4y := CutResults[8].BoundingRect.Top - CutResults[4].BoundingRect.Top;

      if ((not StartingLeft) and W2First) or ((not W2First) and StartingLeft) then  //Note: pack starts with W2 naturally from Left side
      begin
        TempVecx := Vec1x;
        Vec1x := Vec2x;
        Vec2x := TempVecx;
      end;

      if FirstCutInCorner then
        StartPositionVariations := 1
      else
        StartPositionVariations := 3;

      //InvertToBegin = True means that the first pattern of the second row is the opposite way up to the first pattern
      //of the first row.
      for j := 1 to StartPositionVariations do
      begin
        if StartingLeft then
        begin
          InvertToBegin := False;
          if (j = 1) then
          begin
            if (Vec3x < 0) then             //j = 1 means first cut is in corner.
            begin
              InvertToBegin := True;
              Vec3x := Vec3x + Vec1x;
              Vec4x := Vec4x - Vec1x;
              if (Vec3x < 0) then                //Due to second pattern inverted might need to go back ANOTHER vec to
              begin                              //get correct arrangement/offset.
                InvertToBegin := False;
                Vec3x := Vec3x + Vec2x;
                Vec4x := Vec4x - Vec2x;
              end;
            end
            else
              InvertToBegin := False;
          end
          else if (j = 2) then
          begin
            if (Vec3x > 0) then
            begin
              Vec3x := Vec3x - (Vec1x + Vec2x);
              Vec4x := Vec4x + (Vec1x + Vec2x);
              InvertToBegin := False;
            end;
          end
          else if (j = 3) then
          begin
            if (Vec3x > 0) then
            begin
              Vec3x := Vec3x - Vec2x;
              Vec4x := Vec4x + Vec2x;
              InvertToBegin := True;
            end;
          end;
        end
        else
        begin
          InvertToBegin := False;
          if (j = 1) then
          begin
            if (Vec3x > 0) then             //j = 1 means first cut is in corner.
            begin
              InvertToBegin := True;
              Vec3x := Vec3x - Vec1x;
              Vec4x := Vec4x + Vec1x;
              if (Vec3x > 0) then                //Due to second pattern inverted might need to go back ANOTHER vec to
              begin                              //get correct arrangement/offset.
                InvertToBegin := False;
                Vec3x := Vec3x - Vec2x;
                Vec4x := Vec4x + Vec2x;
              end;
            end
            else
              InvertToBegin := False;
          end
          else if (j = 2) then
          begin
            if (Vec3x < 0) then
            begin
              Vec3x := Vec3x + Vec1x + Vec2x;
              Vec4x := Vec4x - (Vec1x + Vec2x);
              InvertToBegin := False;
            end;
          end
          else if (j = 3) then
          begin
            if (Vec3x < 0) then
            begin
              Vec3x := Vec3x + Vec2x;
              Vec4x := Vec4x - Vec2x;
              InvertToBegin := True;
            end;
          end;
        end;

        //Calculate Material left after first pattern in Odd Rows
        if ((not StartingLeft) and (Vec3x > 0)) then
          MaterialWidthAfterFirst := UsableMaterialWidth - (PatternWidth + Vec3x)
        else if (StartingLeft and (Vec3x < 0)) then
          MaterialWidthAfterFirst := UsableMaterialWidth - (PatternWidth - Vec3x)
        else
          MaterialWidthAfterFirst := UsableMaterialWidth - PatternWidth;

        //Calculate number of Patterns in Odd Rows
        NoInOddRow := 1 + ((MaterialWidthAfterFirst div (Vec1x + Vec2x)) * 2);
        RemainingWidth1 := MaterialWidthAfterFirst - ((NoInOddRow div 2) * (Vec1x + Vec2x));
        if RemainingWidth1 > Vec1x then
        begin
          inc(NoInOddRow);
          RemainingWidth1 := RemainingWidth1 - Vec1x;
        end;

        //Calculate Material left after first pattern in Even rows
        if ((not StartingLeft) and (Vec3x < 0)) then
          MaterialWidthAfterFirst := UsableMaterialWidth - (PatternWidth - Vec3x)
        else if (StartingLeft and (Vec3x > 0)) then
          MaterialWidthAfterFirst := UsableMaterialWidth - (PatternWidth + Vec3x)
        else
          MaterialWidthAfterFirst := UsableMaterialWidth - PatternWidth;

        if InvertToBegin then
          LastVec := Vec2x
        else
          LastVec := Vec1x;  //Normally

        //Calculate number of Patterns in Even rows
        NoInEvenRow := 1 + ((MaterialWidthAfterFirst div (Vec1x + Vec2x)) * 2);
        RemainingWidth2 := MaterialWidthAfterFirst - ((NoInEvenRow div 2) * (Vec1x + Vec2x));
        if RemainingWidth2 > LastVec then
        begin
          inc(NoInEvenRow);
          RemainingWidth2 := RemainingWidth2 - LastVec;
        end;

        //Overall Remaining Width
        RemainingWidth := min(RemainingWidth1, RemainingWidth2);

        //Calculate for rest of sheet                    //ColCount = NoInCol ..do same in other
        MaterialLengthAfterFirst := UsableMaterialLength - PatternHeight;
        ColCount := 1 + ((MaterialLengthAfterFirst div (abs(Vec3y) + abs(Vec4y))) * 2);
        RemainingHeight := MaterialLengthAfterFirst - ((ColCount div 2) * (abs(Vec3y) + abs(Vec4y)));
        if RemainingHeight > abs(Vec3y) then
        begin
          inc(ColCount);
          RemainingHeight := RemainingHeight - abs(Vec3y);
        end;

        //Calculate number of patterns for sheet
        NumberOfPatterns := (NoInOddRow * ((ColCount div 2) + (ColCount mod 2))) + (NoInEvenRow * (ColCount div 2));
        RemainingArea := UncutArea(UsableMaterialLength, UsableMaterialWidth, RemainingHeight, RemainingWidth);

        //Save details for both W1 & W2 starting positions
        if StartingLeft then
        begin
          if not W2First then
          begin
            if (j = 1) then
            begin
              LeftW1CornerPropogation.PatternHeight := PatternHeight;
              LeftW1CornerPropogation.PatternWidth := PatternWidth;
              LeftW1CornerPropogation.W2First := False;
              LeftW1CornerPropogation.InvertToBegin := InvertToBegin;
              LeftW1CornerPropogation.NumberOfPatterns := NumberOfPatterns;
              LeftW1CornerPropogation.NoInOddRow := NoInOddRow;
              LeftW1CornerPropogation.NoInEvenRow := NoInEvenRow;
              LeftW1CornerPropogation.ColCount := ColCount;
              LeftW1CornerPropogation.RemainingWidth := RemainingWidth;
              LeftW1CornerPropogation.RemainingHeight := RemainingHeight;
              LeftW1CornerPropogation.RemainingArea := RemainingArea;
              LeftW1CornerPropogation.Vec1x := Vec1x;
              LeftW1CornerPropogation.Vec2x := Vec2x;
              LeftW1CornerPropogation.Vec3x := -Vec3x;
              LeftW1CornerPropogation.Vec3y := Vec3y;
              LeftW1CornerPropogation.Vec4x := -Vec4x;
              LeftW1CornerPropogation.Vec4y := Vec4y;
            end
            else if (j = 2) then
            begin
              LeftW1OffsetPropogationA.PatternHeight := PatternHeight;
              LeftW1OffsetPropogationA.PatternWidth := PatternWidth;
              LeftW1OffsetPropogationA.W2First := False;
              LeftW1OffsetPropogationA.InvertToBegin := InvertToBegin;
              LeftW1OffsetPropogationA.NumberOfPatterns := NumberOfPatterns;
              LeftW1OffsetPropogationA.NoInOddRow := NoInOddRow;
              LeftW1OffsetPropogationA.NoInEvenRow := NoInEvenRow;
              LeftW1OffsetPropogationA.ColCount := ColCount;
              LeftW1OffsetPropogationA.RemainingWidth := RemainingWidth;
              LeftW1OffsetPropogationA.RemainingHeight := RemainingHeight;
              LeftW1OffsetPropogationA.RemainingArea := RemainingArea;
              LeftW1OffsetPropogationA.Vec1x := Vec1x;
              LeftW1OffsetPropogationA.Vec2x := Vec2x;
              LeftW1OffsetPropogationA.Vec3x := -Vec3x;
              LeftW1OffsetPropogationA.Vec3y := Vec3y;
              LeftW1OffsetPropogationA.Vec4x := -Vec4x;
              LeftW1OffsetPropogationA.Vec4y := Vec4y;
            end
            else if (j = 3) then
            begin
              LeftW1OffsetPropogationB.PatternHeight := PatternHeight;
              LeftW1OffsetPropogationB.PatternWidth := PatternWidth;
              LeftW1OffsetPropogationB.W2First := False;
              LeftW1OffsetPropogationB.InvertToBegin := InvertToBegin;
              LeftW1OffsetPropogationB.NumberOfPatterns := NumberOfPatterns;
              LeftW1OffsetPropogationB.NoInOddRow := NoInOddRow;
              LeftW1OffsetPropogationB.NoInEvenRow := NoInEvenRow;
              LeftW1OffsetPropogationB.ColCount := ColCount;
              LeftW1OffsetPropogationB.RemainingWidth := RemainingWidth;
              LeftW1OffsetPropogationB.RemainingHeight := RemainingHeight;
              LeftW1OffsetPropogationB.RemainingArea := RemainingArea;
              LeftW1OffsetPropogationB.Vec1x := Vec1x;
              LeftW1OffsetPropogationB.Vec2x := Vec2x;
              LeftW1OffsetPropogationB.Vec3x := -Vec3x;
              LeftW1OffsetPropogationB.Vec3y := Vec3y;
              LeftW1OffsetPropogationB.Vec4x := -Vec4x;
              LeftW1OffsetPropogationB.Vec4y := Vec4y;
            end;
          end
          else
          begin
            if (j = 1) then
            begin
              LeftW2CornerPropogation.PatternHeight := PatternHeight;
              LeftW2CornerPropogation.PatternWidth := PatternWidth;
              LeftW2CornerPropogation.W2First := True;
              LeftW2CornerPropogation.InvertToBegin := InvertToBegin;
              LeftW2CornerPropogation.NumberOfPatterns := NumberOfPatterns;
              LeftW2CornerPropogation.NoInOddRow := NoInOddRow;
              LeftW2CornerPropogation.NoInEvenRow := NoInEvenRow;
              LeftW2CornerPropogation.ColCount := ColCount;
              LeftW2CornerPropogation.RemainingWidth := RemainingWidth;
              LeftW2CornerPropogation.RemainingHeight := RemainingHeight;
              LeftW2CornerPropogation.RemainingArea := RemainingArea;
              LeftW2CornerPropogation.Vec1x := Vec1x;
              LeftW2CornerPropogation.Vec2x := Vec2x;
              LeftW2CornerPropogation.Vec3x := -Vec3x;
              LeftW2CornerPropogation.Vec3y := Vec3y;
              LeftW2CornerPropogation.Vec4x := -Vec4x;
              LeftW2CornerPropogation.Vec4y := Vec4y;
            end
            else if (j = 2) then
            begin
              LeftW2OffsetPropogationA.PatternHeight := PatternHeight;
              LeftW2OffsetPropogationA.PatternWidth := PatternWidth;
              LeftW2OffsetPropogationA.W2First := True;
              LeftW2OffsetPropogationA.InvertToBegin := InvertToBegin;
              LeftW2OffsetPropogationA.NumberOfPatterns := NumberOfPatterns;
              LeftW2OffsetPropogationA.NoInOddRow := NoInOddRow;
              LeftW2OffsetPropogationA.NoInEvenRow := NoInEvenRow;
              LeftW2OffsetPropogationA.ColCount := ColCount;
              LeftW2OffsetPropogationA.RemainingWidth := RemainingWidth;
              LeftW2OffsetPropogationA.RemainingHeight := RemainingHeight;
              LeftW2OffsetPropogationA.RemainingArea := RemainingArea;
              LeftW2OffsetPropogationA.Vec1x := Vec1x;
              LeftW2OffsetPropogationA.Vec2x := Vec2x;
              LeftW2OffsetPropogationA.Vec3x := -Vec3x;
              LeftW2OffsetPropogationA.Vec3y := Vec3y;
              LeftW2OffsetPropogationA.Vec4x := -Vec4x;
              LeftW2OffsetPropogationA.Vec4y := Vec4y;
            end
            else if (j = 3) then
            begin
              LeftW2OffsetPropogationB.PatternHeight := PatternHeight;
              LeftW2OffsetPropogationB.PatternWidth := PatternWidth;
              LeftW2OffsetPropogationB.W2First := True;
              LeftW2OffsetPropogationB.InvertToBegin := InvertToBegin;
              LeftW2OffsetPropogationB.NumberOfPatterns := NumberOfPatterns;
              LeftW2OffsetPropogationB.NoInOddRow := NoInOddRow;
              LeftW2OffsetPropogationB.NoInEvenRow := NoInEvenRow;
              LeftW2OffsetPropogationB.ColCount := ColCount;
              LeftW2OffsetPropogationB.RemainingWidth := RemainingWidth;
              LeftW2OffsetPropogationB.RemainingHeight := RemainingHeight;
              LeftW2OffsetPropogationB.RemainingArea := RemainingArea;
              LeftW2OffsetPropogationB.Vec1x := Vec1x;
              LeftW2OffsetPropogationB.Vec2x := Vec2x;
              LeftW2OffsetPropogationB.Vec3x := -Vec3x;
              LeftW2OffsetPropogationB.Vec3y := Vec3y;
              LeftW2OffsetPropogationB.Vec4x := -Vec4x;
              LeftW2OffsetPropogationB.Vec4y := Vec4y;
            end;
          end;
        end
        else
        begin
          if not W2First then
          begin
            if (j = 1) then
            begin
              RightW1CornerPropogation.PatternHeight := PatternHeight;
              RightW1CornerPropogation.PatternWidth := PatternWidth;
              RightW1CornerPropogation.W2First := False;
              RightW1CornerPropogation.InvertToBegin := InvertToBegin;
              RightW1CornerPropogation.NumberOfPatterns := NumberOfPatterns;
              RightW1CornerPropogation.NoInOddRow := NoInOddRow;
              RightW1CornerPropogation.NoInEvenRow := NoInEvenRow;
              RightW1CornerPropogation.ColCount := ColCount;
              RightW1CornerPropogation.RemainingWidth := RemainingWidth;
              RightW1CornerPropogation.RemainingHeight := RemainingHeight;
              RightW1CornerPropogation.RemainingArea := RemainingArea;
              RightW1CornerPropogation.Vec1x := Vec1x;
              RightW1CornerPropogation.Vec2x := Vec2x;
              RightW1CornerPropogation.Vec3x := Vec3x;
              RightW1CornerPropogation.Vec3y := Vec3y;
              RightW1CornerPropogation.Vec4x := Vec4x;
              RightW1CornerPropogation.Vec4y := Vec4y;
            end
            else if (j = 2) then
            begin
              RightW1OffsetPropogationA.PatternHeight := PatternHeight;
              RightW1OffsetPropogationA.PatternWidth := PatternWidth;
              RightW1OffsetPropogationA.W2First := False;
              RightW1OffsetPropogationA.InvertToBegin := InvertToBegin;
              RightW1OffsetPropogationA.NumberOfPatterns := NumberOfPatterns;
              RightW1OffsetPropogationA.NoInOddRow := NoInOddRow;
              RightW1OffsetPropogationA.NoInEvenRow := NoInEvenRow;
              RightW1OffsetPropogationA.ColCount := ColCount;
              RightW1OffsetPropogationA.RemainingWidth := RemainingWidth;
              RightW1OffsetPropogationA.RemainingHeight := RemainingHeight;
              RightW1OffsetPropogationA.RemainingArea := RemainingArea;
              RightW1OffsetPropogationA.Vec1x := Vec1x;
              RightW1OffsetPropogationA.Vec2x := Vec2x;
              RightW1OffsetPropogationA.Vec3x := Vec3x;
              RightW1OffsetPropogationA.Vec3y := Vec3y;
              RightW1OffsetPropogationA.Vec4x := Vec4x;
              RightW1OffsetPropogationA.Vec4y := Vec4y;
            end
            else if (j = 3) then
            begin
              RightW1OffsetPropogationB.PatternHeight := PatternHeight;
              RightW1OffsetPropogationB.PatternWidth := PatternWidth;
              RightW1OffsetPropogationB.W2First := False;
              RightW1OffsetPropogationB.InvertToBegin := InvertToBegin;
              RightW1OffsetPropogationB.NumberOfPatterns := NumberOfPatterns;
              RightW1OffsetPropogationB.NoInOddRow := NoInOddRow;
              RightW1OffsetPropogationB.NoInEvenRow := NoInEvenRow;
              RightW1OffsetPropogationB.ColCount := ColCount;
              RightW1OffsetPropogationB.RemainingWidth := RemainingWidth;
              RightW1OffsetPropogationB.RemainingHeight := RemainingHeight;
              RightW1OffsetPropogationB.RemainingArea := RemainingArea;
              RightW1OffsetPropogationB.Vec1x := Vec1x;
              RightW1OffsetPropogationB.Vec2x := Vec2x;
              RightW1OffsetPropogationB.Vec3x := Vec3x;
              RightW1OffsetPropogationB.Vec3y := Vec3y;
              RightW1OffsetPropogationB.Vec4x := Vec4x;
              RightW1OffsetPropogationB.Vec4y := Vec4y;
            end;
          end
          else
          begin
            if (j = 1) then
            begin
              RightW2CornerPropogation.PatternHeight := PatternHeight;
              RightW2CornerPropogation.PatternWidth := PatternWidth;
              RightW2CornerPropogation.W2First := True;
              RightW2CornerPropogation.InvertToBegin := InvertToBegin;
              RightW2CornerPropogation.NumberOfPatterns := NumberOfPatterns;
              RightW2CornerPropogation.NoInOddRow := NoInOddRow;
              RightW2CornerPropogation.NoInEvenRow := NoInEvenRow;
              RightW2CornerPropogation.ColCount := ColCount;
              RightW2CornerPropogation.RemainingWidth := RemainingWidth;
              RightW2CornerPropogation.RemainingHeight := RemainingHeight;
              RightW2CornerPropogation.RemainingArea := RemainingArea;
              RightW2CornerPropogation.Vec1x := Vec1x;
              RightW2CornerPropogation.Vec2x := Vec2x;
              RightW2CornerPropogation.Vec3x := Vec3x;
              RightW2CornerPropogation.Vec3y := Vec3y;
              RightW2CornerPropogation.Vec4x := Vec4x;
              RightW2CornerPropogation.Vec4y := Vec4y;
            end
            else if (j = 2) then
            begin
              RightW2OffsetPropogationA.PatternHeight := PatternHeight;
              RightW2OffsetPropogationA.PatternWidth := PatternWidth;
              RightW2OffsetPropogationA.W2First := True;
              RightW2OffsetPropogationA.InvertToBegin := InvertToBegin;
              RightW2OffsetPropogationA.NumberOfPatterns := NumberOfPatterns;
              RightW2OffsetPropogationA.NoInOddRow := NoInOddRow;
              RightW2OffsetPropogationA.NoInEvenRow := NoInEvenRow;
              RightW2OffsetPropogationA.ColCount := ColCount;
              RightW2OffsetPropogationA.RemainingWidth := RemainingWidth;
              RightW2OffsetPropogationA.RemainingHeight := RemainingHeight;
              RightW2OffsetPropogationA.RemainingArea := RemainingArea;
              RightW2OffsetPropogationA.Vec1x := Vec1x;
              RightW2OffsetPropogationA.Vec2x := Vec2x;
              RightW2OffsetPropogationA.Vec3x := Vec3x;
              RightW2OffsetPropogationA.Vec3y := Vec3y;
              RightW2OffsetPropogationA.Vec4x := Vec4x;
              RightW2OffsetPropogationA.Vec4y := Vec4y;
            end
            else if (j = 3) then
            begin
              RightW2OffsetPropogationB.PatternHeight := PatternHeight;
              RightW2OffsetPropogationB.PatternWidth := PatternWidth;
              RightW2OffsetPropogationB.W2First := True;
              RightW2OffsetPropogationB.InvertToBegin := InvertToBegin;
              RightW2OffsetPropogationB.NumberOfPatterns := NumberOfPatterns;
              RightW2OffsetPropogationB.NoInOddRow := NoInOddRow;
              RightW2OffsetPropogationB.NoInEvenRow := NoInEvenRow;
              RightW2OffsetPropogationB.ColCount := ColCount;
              RightW2OffsetPropogationB.RemainingWidth := RemainingWidth;
              RightW2OffsetPropogationB.RemainingHeight := RemainingHeight;
              RightW2OffsetPropogationB.RemainingArea := RemainingArea;
              RightW2OffsetPropogationB.Vec1x := Vec1x;
              RightW2OffsetPropogationB.Vec2x := Vec2x;
              RightW2OffsetPropogationB.Vec3x := Vec3x;
              RightW2OffsetPropogationB.Vec3y := Vec3y;
              RightW2OffsetPropogationB.Vec4x := Vec4x;
              RightW2OffsetPropogationB.Vec4y := Vec4y;
            end;
          end;
        end;
      end;
    end;

    if StartingLeft then
    begin
      if (LeftW1CornerPropogation.NumberOfPatterns >= LeftW1OffsetPropogationA.NumberOfPatterns) or
         ((LeftW1CornerPropogation.NumberOfPatterns = LeftW1OffsetPropogationA.NumberOfPatterns) and
         (LeftW1CornerPropogation.RemainingArea > LeftW1OffsetPropogationA.RemainingArea)) then
        LeftW1Propogation := LeftW1CornerPropogation
      else
        LeftW1Propogation := LeftW1OffsetPropogationa;

      if (LeftW1Propogation.NumberOfPatterns >= LeftW1OffsetPropogationB.NumberOfPatterns) or
         ((LeftW1Propogation.NumberOfPatterns = LeftW1OffsetPropogationB.NumberOfPatterns) and
         (LeftW1Propogation.RemainingArea > LeftW1OffsetPropogationB.RemainingArea)) then
        LeftW1Propogation := LeftW1Propogation
      else
        LeftW1Propogation := LeftW1OffsetPropogationB;

      if (LeftW2CornerPropogation.NumberOfPatterns >= LeftW2OffsetPropogationA.NumberOfPatterns) or
         ((LeftW2CornerPropogation.NumberOfPatterns = LeftW2OffsetPropogationA.NumberOfPatterns) and
         (LeftW2Propogation.RemainingArea > LeftW2OffsetPropogationA.RemainingArea)) then
        LeftW2Propogation := LeftW2CornerPropogation
      else
        LeftW2Propogation := LeftW2OffsetPropogationA;

      if (LeftW2Propogation.NumberOfPatterns >= LeftW2OffsetPropogationB.NumberOfPatterns) or
         ((LeftW2Propogation.NumberOfPatterns = LeftW2OffsetPropogationB.NumberOfPatterns) and
         (LeftW2Propogation.RemainingArea > LeftW2OffsetPropogationB.RemainingArea)) then
        LeftW2Propogation := LeftW2Propogation
      else
        LeftW2Propogation := LeftW2OffsetPropogationB;

      //Decide on best, either starting with LeftW1 or W2
      if (LeftW1Propogation.NumberOfPatterns >= LeftW2Propogation.NumberOfPatterns) or
         ((LeftW1Propogation.NumberOfPatterns = LeftW2Propogation.NumberOfPatterns) and
         (LeftW1Propogation.RemainingArea > LeftW2Propogation.RemainingArea)) then
        LeftPropogation := LeftW1Propogation
      else
        LeftPropogation := LeftW2Propogation;
    end
    else
    begin
      if (RightW1CornerPropogation.NumberOfPatterns >= RightW1OffsetPropogationA.NumberOfPatterns) or
         ((RightW1CornerPropogation.NumberOfPatterns = RightW1OffsetPropogationA.NumberOfPatterns) and
         (RightW1CornerPropogation.RemainingArea > RightW1OffsetPropogationA.RemainingArea)) then
        RightW1Propogation := RightW1CornerPropogation
      else
        RightW1Propogation := RightW1OffsetPropogationa;

      if (RightW1Propogation.NumberOfPatterns >= RightW1OffsetPropogationB.NumberOfPatterns) or
         ((RightW1Propogation.NumberOfPatterns = RightW1OffsetPropogationB.NumberOfPatterns) and
         (RightW1Propogation.RemainingArea > RightW1OffsetPropogationB.RemainingArea)) then
        RightW1Propogation := RightW1Propogation
      else
        RightW1Propogation := RightW1OffsetPropogationB;

      if (RightW2CornerPropogation.NumberOfPatterns >= RightW2OffsetPropogationA.NumberOfPatterns) or
         ((RightW2CornerPropogation.NumberOfPatterns = RightW2OffsetPropogationA.NumberOfPatterns) and
         (RightW2Propogation.RemainingArea > RightW2OffsetPropogationA.RemainingArea)) then
        RightW2Propogation := RightW2CornerPropogation
      else
        RightW2Propogation := RightW2OffsetPropogationA;

      if (RightW2Propogation.NumberOfPatterns >= RightW2OffsetPropogationB.NumberOfPatterns) or
         ((RightW2Propogation.NumberOfPatterns = RightW2OffsetPropogationB.NumberOfPatterns) and
         (RightW2Propogation.RemainingArea > RightW2OffsetPropogationB.RemainingArea)) then
        RightW2Propogation := RightW2Propogation
      else
        RightW2Propogation := RightW2OffsetPropogationB;

      //Decide on best, either starting with RightW1 or W2
      if (RightW1Propogation.NumberOfPatterns >= RightW2Propogation.NumberOfPatterns) or
         ((RightW1Propogation.NumberOfPatterns = RightW2Propogation.NumberOfPatterns) and
         (RightW1Propogation.RemainingArea > RightW2Propogation.RemainingArea)) then
        RightPropogation := RightW1Propogation
      else
        RightPropogation := RightW2Propogation;
    end;
  end;

  if FixedStart or (LeftPropogation.NumberOfPatterns = RightPropogation.NumberOfPatterns) then
  begin
    if StartLeft then
      BestPropogation := LeftPropogation
    else
      BestPropogation := RightPropogation;

    StartingLeft := StartLeft;
  end
  else if (LeftPropogation.NumberOfPatterns > RightPropogation.NumberOfPatterns) then
  begin
    BestPropogation := LeftPropogation;
    StartingLeft := True;
  end
  else if (RightPropogation.NumberOfPatterns > LeftPropogation.NumberOfPatterns) then
  begin
    BestPropogation := RightPropogation;
    StartingLeft := False;
  end;

  ResultsHorizontalP2Inverted(BestPropogation, UsableMaterialLength, UsableMaterialWidth, StartingLeft);

  //Results
  NumberOfPatterns := BestPropogation.NumberOfPatterns;
  RemainingHeight := BestPropogation.RemainingHeight;
  RemainingWidth := BestPropogation.RemainingWidth;
  RemainingArea := BestPropogation.RemainingArea;

{$IFDEF DEBUG}
  Prop := GetTickCount - Prop;
  TotalProp := TotalProp + Prop;
{$ENDIF}
end;

procedure PropogateVertical(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                            Square, FixedStart, StartLeft, W2, FirstCutInCorner: boolean;
                            LocalInterlock: TLocalInterlock;
                            var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                            var RemainingArea: real; var StartingLeft: boolean);
var
  i, Loops, RowCount, MaterialLengthAfterFirst, MaterialWidthAfterFirst, RemainingHeight1,
  RemainingHeight2, NoInOddColumn, NoInEvenColumn, Vec1y, Vec3x, Vec3y, Vec4x, Vec4y: integer;
  LeftPropogation, RightPropogation, Propogation: TVPropogation;
  VerticalRight: Boolean;
  ExtraHalfOddColumnTop, ExtraHalfEvenColumnTop, ExtraHalfColumn: Boolean;
  ExtraHalfOddColumnBottom, ExtraHalfEvenColumnBottom: Boolean;
  SpaceForExtraHalf, iTemp: integer;
  KeepResults: Boolean;
  HoldLocalInterlock: TLocalInterlock;
  bTemp: Boolean;

begin
{$IFDEF DEBUG}
  Prop := GetTickCount - Prop;
{$ENDIF}

  //Pre Results
  FillPropogationInput(PROPOGATION_VERTICAL, UsableMaterialLength,
                       UsableMaterialWidth, PatternHeight, PatternWidth, Square,
                       FixedStart, StartLeft, W2, FirstCutInCorner, FALSE,
                       FALSE, LocalInterlock, 0.0);

  HoldLocalInterlock := LocalInterlock;
  LeftPropogation.NumberOfPatterns := 0;
  RightPropogation.NumberOfPatterns := 0;

  if (not FixedStart) and LocalInterlock.Used then
    Loops := 4
  else if FixedStart and LocalInterlock.Used then
    Loops := 2
  else if (FixedStart or Square) and (not FirstCutInCorner) then
  begin
    FixedStart := True;
    Loops := 1;
  end
  else
    Loops := 2;

  StartingLeft := True;
  for i := 1 to Loops do
  begin
    if FixedStart then
      StartingLeft := StartLeft
    else
      StartingLeft := not StartingLeft;

    if LocalInterlock.Used then
    begin
      //First with normal interlock, then with reversed interlock
      LocalInterlock := LocalInterlockToUse(HoldLocalInterlock, VERTICAL, (i > (Loops div 2)), FirstCutInCorner, StartingLeft);
      PatternHeight := LocalInterlock.PairedPatternHeight;
    end;

    //Calculate required vectors
    //Assumes 12, 8, 4, 0 (Interlocked to Left - Normal)
    VerticalRight := False;
    Vec1y := abs(CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top);
    Vec3x := CutResults[4].BoundingRect.Left - CutResults[0].BoundingRect.Left;
    Vec3y := CutResults[4].BoundingRect.Top - CutResults[0].BoundingRect.Top;
    Vec4x := CutResults[8].BoundingRect.Left - CutResults[4].BoundingRect.Left;
    Vec4y := CutResults[8].BoundingRect.Top - CutResults[4].BoundingRect.Top;
    if Vec3x > 0 then
    begin
      //Actually 8, 12, 0, 4 (Interlocked to Right - Inverted)
      VerticalRight := True;
      Vec3x := -Vec3x;
      Vec3y := -Vec3y;
      Vec4x := CutResults[12].BoundingRect.Left - CutResults[0].BoundingRect.Left;
      Vec4y := CutResults[12].BoundingRect.Top - CutResults[0].BoundingRect.Top;
    end;

    //Adjust so First Cut is in Corner if it is required and presently isn't
    if (((not StartingLeft) and (Vec3y > 0)) or (StartingLeft and (Vec3y < 0))) and FirstCutInCorner then
    begin
      if StartingLeft then
      begin
        Vec3y := Vec3y + Vec1y;
        Vec4y := Vec4y - Vec1y;
      end
      else
      begin
        Vec3y := Vec3y - Vec1y;
        Vec4y := Vec4y + Vec1y;
      end;

      if Vec4y > (Vec1y / 2) then
        Vec4y := Vec4y - Vec1y;
    end;

    //Calculate Material left after first pattern in Odd Columns
    if Vec3y < 0 then
      MaterialLengthAfterFirst := UsableMaterialLength - PatternHeight
    else
      MaterialLengthAfterFirst := UsableMaterialLength - (PatternHeight + Vec3y);

    //Calculate number of Patterns in Odd Columns
    NoInOddColumn := 1 + (MaterialLengthAfterFirst div Vec1y);
    RemainingHeight1 := MaterialLengthAfterFirst - ((NoInOddColumn - 1) * Vec1y);

    //Decide on extra 'half' pattern in Odd columns at top
    SpaceForExtraHalf := UsableMaterialLength - (NoInOddColumn * Vec1y);
    if Vec3y > 0 then
      SpaceForExtraHalf := SpaceForExtraHalf - Vec3y;
    ExtraHalfOddColumnTop := LocalInterlock.Used and (LocalInterlock.SinglePatternHeight <= SpaceForExtraHalf);
    if ExtraHalfOddColumnTop then
      RemainingHeight1 := SpaceForExtraHalf - LocalInterlock.SinglePatternHeight;

    //Decide on extra 'half' pattern in Odd columns at bottom
    if Vec3y > 0 then
      ExtraHalfOddColumnBottom := LocalInterlock.Used and (LocalInterlock.SinglePatternHeight <= (Vec3y + (PatternHeight - abs(Vec1y))))
    else
      ExtraHalfOddColumnBottom := False;

    //Calculate Material left after first pattern in Even Columns
    if Vec3y < 0 then
      MaterialLengthAfterFirst := UsableMaterialLength - (PatternHeight - Vec3y)
    else
      MaterialLengthAfterFirst := UsableMaterialLength - PatternHeight;

    //Calculate number of Patterns in Even Columns
    NoInEvenColumn := 1 + (MaterialLengthAfterFirst div Vec1y);
    RemainingHeight2 := MaterialLengthAfterFirst - ((NoInEvenColumn - 1) * Vec1y);

    //Decide on extra 'half' pattern in Even Columns at top
    SpaceForExtraHalf := UsableMaterialLength - (NoInEvenColumn * Vec1y);
    if Vec3y < 0 then
      SpaceForExtraHalf := SpaceForExtraHalf + Vec3y;
    ExtraHalfEvenColumnTop := LocalInterlock.Used and (LocalInterlock.SinglePatternHeight <= SpaceForExtraHalf);
    if ExtraHalfEvenColumnTop then
      RemainingHeight2 := SpaceForExtraHalf - LocalInterlock.SinglePatternHeight;

    //Decide on extra 'half' pattern in Odd columns at bottom
    if Vec3y < 0 then
      ExtraHalfEvenColumnBottom := LocalInterlock.Used and (LocalInterlock.SinglePatternHeight <= (-Vec3y + (PatternHeight - abs(Vec1y))))
    else
      ExtraHalfEvenColumnBottom := False;

    //Overall Remaining Height
    RemainingHeight := min(RemainingHeight1, RemainingHeight2);

    //Calculate for rest of sheet
    MaterialWidthAfterFirst := UsableMaterialWidth - PatternWidth;
    RowCount := 1 + ((MaterialWidthAfterFirst div (abs(Vec3x) + abs(Vec4x))) * 2);
    RemainingWidth := MaterialWidthAfterFirst - ((RowCount div 2) * (abs(Vec3x) + abs(Vec4x)));
    if RemainingWidth > abs(Vec3x) then
    begin
      inc(RowCount);
      RemainingWidth := RemainingWidth - abs(Vec3x);
    end;

    //Decide on extra 'half' column
    ExtraHalfColumn := LocalInterlock.Used and ((((RowCount div 2) * (abs(Vec3x) + abs(Vec4x))) + ((RowCount mod 2) * abs(Vec3x)) + LocalInterlock.SinglePatternWidth) < UsableMaterialWidth);
    if ExtraHalfColumn then
      RemainingWidth := UsableMaterialWidth - (((RowCount div 2) * (abs(Vec3x) + abs(Vec4x))) + ((RowCount mod 2) * abs(Vec3x)) + LocalInterlock.SinglePatternWidth);

    //Calculate number of patterns for sheet
    if StartingLeft then
    begin
      iTemp := NoInOddColumn;
      NoInOddColumn := NoInEvenColumn;
      NoInEvenColumn := iTemp;

      bTemp := ExtraHalfOddColumnTop;
      ExtraHalfOddColumnTop := ExtraHalfEvenColumnTop;
      ExtraHalfEvenColumnTop := bTemp;

      bTemp := ExtraHalfOddColumnBottom;
      ExtraHalfOddColumnBottom := ExtraHalfEvenColumnBottom;
      ExtraHalfEvenColumnBottom := bTemp;
    end;

    NumberOfPatterns := (NoInOddColumn * ((RowCount div 2) + (RowCount mod 2))) + (NoInEvenColumn * (RowCount div 2));
    if LocalInterlock.Used then
    begin
      NumberOfPatterns := NumberOfPatterns * 2;
      if ExtraHalfOddColumnTop then
      begin
{        NumberOfPatterns := NumberOfPatterns + (RowCount div 2);
        if (not StartingLeft) then
          NumberOfPatterns := NumberOfPatterns + (RowCount mod 2);}
        NumberOfPatterns := NumberOfPatterns + (RowCount div 2) + (RowCount mod 2);
      end;
      if ExtraHalfOddColumnBottom then
      begin
{        NumberOfPatterns := NumberOfPatterns + (RowCount div 2);
        if (not StartingLeft) then
          NumberOfPatterns := NumberOfPatterns + (RowCount mod 2);}
        NumberOfPatterns := NumberOfPatterns + (RowCount div 2) + (RowCount mod 2);
      end;
      if ExtraHalfEvenColumnTop then
      begin
        NumberOfPatterns := NumberOfPatterns + (RowCount div 2);
{        if StartingLeft then
          NumberOfPatterns := NumberOfPatterns + (RowCount mod 2);}
      end;
      if ExtraHalfEvenColumnBottom then
      begin
        NumberOfPatterns := NumberOfPatterns + (RowCount div 2);
{        if StartingLeft then
          NumberOfPatterns := NumberOfPatterns + (RowCount mod 2);}
      end;
      if ExtraHalfColumn then
      begin
        if ((RowCount mod 2) = 0) then
        begin
          NumberOfPatterns := NumberOfPatterns + NoInOddColumn;
          if ExtraHalfOddColumnTop and ((LocalInterlock.BottomIsLeft and StartingLeft) or ((not LocalInterlock.BottomIsLeft) and (not StartingLeft))) then
            inc(NumberOfPatterns);
          if ExtraHalfOddColumnBottom and (((not LocalInterlock.BottomIsLeft) and StartingLeft) or (LocalInterlock.BottomIsLeft and (not StartingLeft))) then
            inc(NumberOfPatterns);
        end
        else
        begin
          NumberOfPatterns := NumberOfPatterns + NoInEvenColumn;
          if ExtraHalfEvenColumnTop and ((LocalInterlock.BottomIsLeft and StartingLeft) or ((not LocalInterlock.BottomIsLeft) and (not StartingLeft))) then
            inc(NumberOfPatterns);
          if ExtraHalfEvenColumnBottom and (((not LocalInterlock.BottomIsLeft) and StartingLeft) or (LocalInterlock.BottomIsLeft and (not StartingLeft))) then
            inc(NumberOfPatterns);
        end;
      end;
    end;
    RemainingArea := UncutArea(UsableMaterialLength, UsableMaterialWidth, RemainingHeight, RemainingWidth);

    KeepResults := False;
    if StartingLeft then
    begin
      if (NumberOfPatterns > LeftPropogation.NumberOfPatterns) or
         ((NumberOfPatterns = LeftPropogation.NumberOfPatterns) and
          (RemainingArea > LeftPropogation.RemainingArea)) then
        KeepResults := True;

      if KeepResults then
      begin
        LeftPropogation.PatternHeight := PatternHeight;
        LeftPropogation.PatternWidth := PatternWidth;
        LeftPropogation.VerticalRight := VerticalRight;
        LeftPropogation.NumberOfPatterns := NumberOfPatterns;
        LeftPropogation.NoInOddColumn := NoInOddColumn;
        LeftPropogation.NoInEvenColumn := NoInEvenColumn;
        LeftPropogation.RowCount := RowCount;
        LeftPropogation.RemainingWidth := RemainingWidth;
        LeftPropogation.RemainingHeight := RemainingHeight;
        LeftPropogation.RemainingArea := RemainingArea;
        LeftPropogation.Vec1y := Vec1y;
        LeftPropogation.Vec3x := Vec3x;
        LeftPropogation.Vec3y := Vec3y;
        LeftPropogation.Vec4x := Vec4x;
        LeftPropogation.Vec4y := Vec4y;
        LeftPropogation.LocalInterlock := LocalInterlock;
        LeftPropogation.ExtraHalfOddColumnTop := ExtraHalfOddColumnTop;
        LeftPropogation.ExtraHalfEvenColumnTop := ExtraHalfEvenColumnTop;
        LeftPropogation.ExtraHalfOddColumnBottom := ExtraHalfOddColumnBottom;
        LeftPropogation.ExtraHalfEvenColumnBottom := ExtraHalfEvenColumnBottom;
        LeftPropogation.ExtraHalfColumn := ExtraHalfColumn;
      end;
    end
    else
    begin
      if (NumberOfPatterns > RightPropogation.NumberOfPatterns) or
         ((NumberOfPatterns = RightPropogation.NumberOfPatterns) and
          (RemainingArea > RightPropogation.RemainingArea)) then
        KeepResults := True;

      if KeepResults then
      begin
        RightPropogation.PatternHeight := PatternHeight;
        RightPropogation.PatternWidth := PatternWidth;
        RightPropogation.VerticalRight := VerticalRight;
        RightPropogation.NumberOfPatterns := NumberOfPatterns;
        RightPropogation.NoInOddColumn := NoInOddColumn;
        RightPropogation.NoInEvenColumn := NoInEvenColumn;
        RightPropogation.RowCount := RowCount;
        RightPropogation.RemainingWidth := RemainingWidth;
        RightPropogation.RemainingHeight := RemainingHeight;
        RightPropogation.RemainingArea := RemainingArea;
        RightPropogation.Vec1y := Vec1y;
        RightPropogation.Vec3x := Vec3x;
        RightPropogation.Vec3y := Vec3y;
        RightPropogation.Vec4x := Vec4x;
        RightPropogation.Vec4y := Vec4y;
        RightPropogation.LocalInterlock := LocalInterlock;
        RightPropogation.ExtraHalfOddColumnTop := ExtraHalfOddColumnTop;
        RightPropogation.ExtraHalfEvenColumnTop := ExtraHalfEvenColumnTop;
        RightPropogation.ExtraHalfOddColumnBottom := ExtraHalfOddColumnBottom;
        RightPropogation.ExtraHalfEvenColumnBottom := ExtraHalfEvenColumnBottom;
        RightPropogation.ExtraHalfColumn := ExtraHalfColumn;
      end;
    end;
  end;

  if FixedStart or (LeftPropogation.NumberOfPatterns = RightPropogation.NumberOfPatterns) then
  begin
    if StartLeft then
      Propogation := LeftPropogation
    else
      Propogation := RightPropogation;

    StartingLeft := StartLeft;
  end
  else if (LeftPropogation.NumberOfPatterns > RightPropogation.NumberOfPatterns) then
  begin
    Propogation := LeftPropogation;
    StartingLeft := True;
  end
  else if (RightPropogation.NumberOfPatterns > LeftPropogation.NumberOfPatterns) then
  begin
    Propogation := RightPropogation;
    StartingLeft := False;
  end;

  ResultsVertical(Propogation, UsableMaterialLength, UsableMaterialWidth, StartingLeft, W2);

  //Results
  NumberOfPatterns := Propogation.NumberOfPatterns;
  RemainingHeight := Propogation.RemainingHeight;
  RemainingWidth := Propogation.RemainingWidth;
  RemainingArea := Propogation.RemainingArea;

{$IFDEF DEBUG}
  Prop := GetTickCount - Prop;
  TotalProp := TotalProp + Prop;
{$ENDIF}
end;

procedure PropogateVerticalP2Inverted(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                                      Square, FixedStart, StartLeft, FirstCutInCorner, ForceW1First,
                                      ForceW2First: boolean;
                                      var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                      var RemainingArea: real; var StartingLeft: Boolean);
var
  i, j, Loops, PositionInRow, StartPositionVariations, ColNo, RowCount, FirstRight, Firstw, Lastw, Lastvec,
  MaterialLengthAfterFirst, MaterialWidthAfterFirst, Pullback, RemainingHeight1, RemainingHeight2, NoInColumn,
  NoInOddColumn, NoInEvenColumn, TempVecy, Vec1x, Vec1y, Vec2y, Vec3x, Vec3y, Vec4x, Vec4y, w: integer;
  BestPropogation, LeftPropogation, LeftW1Propogation, LeftW2Propogation, LeftW1CornerPropogation,
  LeftW1OffsetPropogationA, LeftW1OffsetPropogationB, LeftW2CornerPropogation, LeftW2OffsetPropogationA,
  LeftW2OffsetPropogationB, RightPropogation, RightW1Propogation, RightW2Propogation, RightW1CornerPropogation,
  RightW1OffsetPropogationA, RightW1OffsetPropogationB, RightW2CornerPropogation, RightW2OffsetPropogationA,
  RightW2OffsetPropogationB: TVP2IPropogation;
  FirstCutOffset, InvertToBegin, W2First: boolean;

begin
{$IFDEF DEBUG}
  Prop := GetTickCount;
{$ENDIF}

  //Pre Results
  FillPropogationInput(PROPOGATION_VERTICALP2INVERTED, UsableMaterialLength,
                       UsableMaterialWidth, PatternHeight, PatternWidth, Square,
                       FixedStart, StartLeft, FALSE, FirstCutInCorner,
                       ForceW1First, ForceW2First, EmptyLocalInterlock, 0.0);

  LeftW1CornerPropogation.NumberOfPatterns := 0;
  LeftW1CornerPropogation.RemainingArea := 0;
  LeftW1OffsetPropogationA.NumberOfPatterns := 0;
  LeftW1OffsetPropogationA.RemainingArea := 0;
  LeftW1OffsetPropogationB.NumberOfPatterns := 0;
  LeftW1OffsetPropogationB.RemainingArea := 0;
  LeftW2CornerPropogation.NumberOfPatterns := 0;
  LeftW2CornerPropogation.RemainingArea := 0;
  LeftW2OffsetPropogationA.NumberOfPatterns := 0;
  LeftW2OffsetPropogationA.RemainingArea := 0;
  LeftW2OffsetPropogationB.NumberOfPatterns := 0;
  LeftW2OffsetPropogationB.RemainingArea := 0;

  RightW1CornerPropogation.NumberOfPatterns := 0;
  RightW1CornerPropogation.RemainingArea := 0;
  RightW1OffsetPropogationA.NumberOfPatterns := 0;
  RightW1OffsetPropogationA.RemainingArea := 0;
  RightW1OffsetPropogationB.NumberOfPatterns := 0;
  RightW1OffsetPropogationB.RemainingArea := 0;
  RightW2CornerPropogation.NumberOfPatterns := 0;
  RightW2CornerPropogation.RemainingArea := 0;
  RightW2OffsetPropogationA.NumberOfPatterns := 0;
  RightW2OffsetPropogationA.RemainingArea := 0;
  RightW2OffsetPropogationB.NumberOfPatterns := 0;
  RightW2OffsetPropogationB.RemainingArea := 0;

  LeftPropogation.NumberOfPatterns := 0;
  LeftPropogation.RemainingArea := 0;
  RightPropogation.NumberOfPatterns := 0;
  RightPropogation.RemainingArea := 0;

  if (FixedStart or Square) and not FirstCutInCorner and not(ForceW1First or ForceW2First) then
  begin                                                   //the only time there will be a difference in how many fit is
    Loops := 1;                                           //when offset pack and FirstCutInCorner is forced or W1/W2
    StartingLeft := StartLeft;                            //forced starts are used, therefore only compare right
  end                                                     //and left start results then.
  else
  begin
    Loops := 2;
    StartingLeft := False;
  end;

  for i := 1 to Loops do
  begin
    if i = 2 then
      StartingLeft := True;

    //Decide which 'w's to try
    Firstw := 1;
    Lastw := 2;
    if ForceW1First then
      Lastw := 1
    else if ForceW2First then
      Firstw := 2;

    for w := Firstw to Lastw do
    begin
      W2First := (w = 2);

      //Calculate required vectors - must be here as vectors get altered during calculations and need resetting.
      Vec1y := abs(CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top);
      Vec2y := abs(CutResults[2].BoundingRect.Top - CutResults[1].BoundingRect.Top);
      if StartingLeft then
      begin
        Vec3x := CutResults[8].BoundingRect.Left - CutResults[12].BoundingRect.Left;
        Vec3y := CutResults[8].BoundingRect.Top - CutResults[12].BoundingRect.Top;
        Vec4x := CutResults[4].BoundingRect.Left - CutResults[8].BoundingRect.Left;
        Vec4y := CutResults[4].BoundingRect.Top - CutResults[8].BoundingRect.Top;
      end
      else
      begin
        Vec3x := CutResults[4].BoundingRect.Left - CutResults[0].BoundingRect.Left;
        Vec3y := CutResults[4].BoundingRect.Top - CutResults[0].BoundingRect.Top;
        Vec4x := CutResults[8].BoundingRect.Left - CutResults[4].BoundingRect.Left;
        Vec4y := CutResults[8].BoundingRect.Top - CutResults[4].BoundingRect.Top;
      end;

      if W2First then
      begin
        TempVecy := Vec1y;
        Vec1y := Vec2y;
        Vec2y := TempVecy;
      end;

      if FirstCutInCorner then
        StartPositionVariations := 1
      else
        StartPositionVariations := 3;

      for j := 1 to StartPositionVariations do
      begin
        InvertToBegin := False;
        if (j = 1) then
        begin
          if (Vec3y > 0) then             //j = 1 means first cut is in corner.
          begin
            InvertToBegin := True;
            Vec3y := Vec3y - Vec1y;
            Vec4y := Vec4y + Vec1y;
            if (Vec3y > 0) then
            begin
              InvertToBegin := False;
              Vec3y := Vec3y - Vec2y;
              Vec4y := Vec4y + Vec2y;
            end;
          end
          else
            InvertToBegin := False;
        end
        else if (j = 2) then
        begin
          if (Vec3y < 0) then
          begin
            Vec3y := Vec3y + Vec1y + Vec2y;
            Vec4y := Vec4y - (Vec1y + Vec2y);
            InvertToBegin := False;
          end;
        end
        else if (j = 3) then
        begin
          if (Vec3y < 0) then
          begin
            Vec3y := Vec3y + Vec2y;
            Vec4y := Vec4y - Vec2y;
            InvertToBegin := True;
          end;
        end;

        //Calculate Material left after first pattern in Odd Columns
        if Vec3y < 0 then
          MaterialLengthAfterFirst := UsableMaterialLength - PatternHeight
        else
          MaterialLengthAfterFirst := UsableMaterialLength - (PatternHeight + Vec3y);

        //Calculate number of Patterns in Odd Columns
        NoInOddColumn := 1 + ((MaterialLengthAfterFirst div (Vec1y + Vec2y)) * 2);
        RemainingHeight1 := MaterialLengthAfterFirst - ((NoInOddColumn div 2) * (Vec1y + Vec2y));
        if RemainingHeight1 > Vec1y then
        begin
          inc(NoInOddColumn);
          RemainingHeight1 := RemainingHeight1 - Vec1y;
        end;

        //Calculate Material left after first pattern in Even rows
        if Vec3y < 0 then
          MaterialLengthAfterFirst := UsableMaterialLength - (PatternHeight - Vec3y)
        else
          MaterialLengthAfterFirst := UsableMaterialLength - PatternHeight;

        if InvertToBegin then
          LastVec := Vec2y
        else
          LastVec := Vec1y;  //Normally

        //Calculate number of Patterns in Even rows
        NoInEvenColumn := 1 + ((MaterialLengthAfterFirst div (Vec1y + Vec2y)) * 2);
        RemainingHeight2 := MaterialLengthAfterFirst - ((NoInEvenColumn div 2) * (Vec1y + Vec2y));
        if RemainingHeight2 > LastVec then
        begin
          inc(NoInEvenColumn);
          RemainingHeight2 := RemainingHeight2 - LastVec;
        end;

        //Overall Remaining Height
        RemainingHeight := min(RemainingHeight1, RemainingHeight2);

        //Calculate for rest of sheet                    //RowCount = NoInRow ..do same in other
        MaterialWidthAfterFirst := UsableMaterialWidth - PatternWidth;
        RowCount := 1 + ((MaterialWidthAfterFirst div (abs(Vec3x) + abs(Vec4x))) * 2);
        RemainingWidth := MaterialWidthAfterFirst - ((RowCount div 2) * (abs(Vec3x) + abs(Vec4x)));
        if RemainingWidth > abs(Vec3x) then
        begin
          inc(RowCount);
          RemainingWidth := RemainingWidth - abs(Vec3x);
        end;

        //Calculate number of patterns for sheet
        NumberOfPatterns := (NoInOddColumn * ((RowCount div 2) + (RowCount mod 2))) + (NoInEvenColumn * (RowCount div 2));
        RemainingArea := UncutArea(UsableMaterialLength, UsableMaterialWidth, RemainingHeight, RemainingWidth);

        if StartingLeft then
        begin
          //Save details for both W1 & W2 starting positions
          if not W2First then
          begin
            if (j = 1) then
            begin
              LeftW1CornerPropogation.PatternHeight := PatternHeight;
              LeftW1CornerPropogation.PatternWidth := PatternWidth;
              LeftW1CornerPropogation.W2First := False;
              LeftW1CornerPropogation.InvertToBegin := InvertToBegin;
              LeftW1CornerPropogation.NumberOfPatterns := NumberOfPatterns;
              LeftW1CornerPropogation.NoInOddColumn := NoInOddColumn;
              LeftW1CornerPropogation.NoInEvenColumn := NoInEvenColumn;
              LeftW1CornerPropogation.RowCount := RowCount;
              LeftW1CornerPropogation.RemainingWidth := RemainingWidth;
              LeftW1CornerPropogation.RemainingHeight := RemainingHeight;
              LeftW1CornerPropogation.RemainingArea := RemainingArea;
              LeftW1CornerPropogation.Vec1y := Vec1y;
              LeftW1CornerPropogation.Vec2y := Vec2y;
              LeftW1CornerPropogation.Vec3x := Vec3x;
              LeftW1CornerPropogation.Vec3y := Vec3y;
              LeftW1CornerPropogation.Vec4x := Vec4x;
              LeftW1CornerPropogation.Vec4y := Vec4y;
            end
            else if (j = 2) then
            begin
              LeftW1OffsetPropogationA.PatternHeight := PatternHeight;
              LeftW1OffsetPropogationA.PatternWidth := PatternWidth;
              LeftW1OffsetPropogationA.W2First := False;
              LeftW1OffsetPropogationA.InvertToBegin := InvertToBegin;
              LeftW1OffsetPropogationA.NumberOfPatterns := NumberOfPatterns;
              LeftW1OffsetPropogationA.NoInOddColumn := NoInOddColumn;
              LeftW1OffsetPropogationA.NoInEvenColumn := NoInEvenColumn;
              LeftW1OffsetPropogationA.RowCount := RowCount;
              LeftW1OffsetPropogationA.RemainingWidth := RemainingWidth;
              LeftW1OffsetPropogationA.RemainingHeight := RemainingHeight;
              LeftW1OffsetPropogationA.RemainingArea := RemainingArea;
              LeftW1OffsetPropogationA.Vec1y := Vec1y;
              LeftW1OffsetPropogationA.Vec2y := Vec2y;
              LeftW1OffsetPropogationA.Vec3x := Vec3x;
              LeftW1OffsetPropogationA.Vec3y := Vec3y;
              LeftW1OffsetPropogationA.Vec4x := Vec4x;
              LeftW1OffsetPropogationA.Vec4y := Vec4y;
            end
            else if (j = 3) then
            begin
              LeftW1OffsetPropogationB.PatternHeight := PatternHeight;
              LeftW1OffsetPropogationB.PatternWidth := PatternWidth;
              LeftW1OffsetPropogationB.W2First := False;
              LeftW1OffsetPropogationB.InvertToBegin := InvertToBegin;
              LeftW1OffsetPropogationB.NumberOfPatterns := NumberOfPatterns;
              LeftW1OffsetPropogationB.NoInOddColumn := NoInOddColumn;
              LeftW1OffsetPropogationB.NoInEvenColumn := NoInEvenColumn;
              LeftW1OffsetPropogationB.RowCount := RowCount;
              LeftW1OffsetPropogationB.RemainingWidth := RemainingWidth;
              LeftW1OffsetPropogationB.RemainingHeight := RemainingHeight;
              LeftW1OffsetPropogationB.RemainingArea := RemainingArea;
              LeftW1OffsetPropogationB.Vec1y := Vec1y;
              LeftW1OffsetPropogationB.Vec2y := Vec2y;
              LeftW1OffsetPropogationB.Vec3x := Vec3x;
              LeftW1OffsetPropogationB.Vec3y := Vec3y;
              LeftW1OffsetPropogationB.Vec4x := Vec4x;
              LeftW1OffsetPropogationB.Vec4y := Vec4y;
            end;
          end
          else
          begin
            if (j = 1) then
            begin
              LeftW2CornerPropogation.PatternHeight := PatternHeight;
              LeftW2CornerPropogation.PatternWidth := PatternWidth;
              LeftW2CornerPropogation.W2First := True;
              LeftW2CornerPropogation.InvertToBegin := InvertToBegin;
              LeftW2CornerPropogation.NumberOfPatterns := NumberOfPatterns;
              LeftW2CornerPropogation.NoInOddColumn := NoInOddColumn;
              LeftW2CornerPropogation.NoInEvenColumn := NoInEvenColumn;
              LeftW2CornerPropogation.RowCount := RowCount;
              LeftW2CornerPropogation.RemainingWidth := RemainingWidth;
              LeftW2CornerPropogation.RemainingHeight := RemainingHeight;
              LeftW2CornerPropogation.RemainingArea := RemainingArea;
              LeftW2CornerPropogation.Vec1y := Vec1y;
              LeftW2CornerPropogation.Vec2y := Vec2y;
              LeftW2CornerPropogation.Vec3x := Vec3x;
              LeftW2CornerPropogation.Vec3y := Vec3y;
              LeftW2CornerPropogation.Vec4x := Vec4x;
              LeftW2CornerPropogation.Vec4y := Vec4y;
            end
            else if (j = 2) then
            begin
              LeftW2OffsetPropogationA.PatternHeight := PatternHeight;
              LeftW2OffsetPropogationA.PatternWidth := PatternWidth;
              LeftW2OffsetPropogationA.W2First := True;
              LeftW2OffsetPropogationA.InvertToBegin := InvertToBegin;
              LeftW2OffsetPropogationA.NumberOfPatterns := NumberOfPatterns;
              LeftW2OffsetPropogationA.NoInOddColumn := NoInOddColumn;
              LeftW2OffsetPropogationA.NoInEvenColumn := NoInEvenColumn;
              LeftW2OffsetPropogationA.RowCount := RowCount;
              LeftW2OffsetPropogationA.RemainingWidth := RemainingWidth;
              LeftW2OffsetPropogationA.RemainingHeight := RemainingHeight;
              LeftW2OffsetPropogationA.RemainingArea := RemainingArea;
              LeftW2OffsetPropogationA.Vec1y := Vec1y;
              LeftW2OffsetPropogationA.Vec2y := Vec2y;
              LeftW2OffsetPropogationA.Vec3x := Vec3x;
              LeftW2OffsetPropogationA.Vec3y := Vec3y;
              LeftW2OffsetPropogationA.Vec4x := Vec4x;
              LeftW2OffsetPropogationA.Vec4y := Vec4y;
            end
            else if (j = 3) then
            begin
              LeftW2OffsetPropogationB.PatternHeight := PatternHeight;
              LeftW2OffsetPropogationB.PatternWidth := PatternWidth;
              LeftW2OffsetPropogationB.W2First := True;
              LeftW2OffsetPropogationB.InvertToBegin := InvertToBegin;
              LeftW2OffsetPropogationB.NumberOfPatterns := NumberOfPatterns;
              LeftW2OffsetPropogationB.NoInOddColumn := NoInOddColumn;
              LeftW2OffsetPropogationB.NoInEvenColumn := NoInEvenColumn;
              LeftW2OffsetPropogationB.RowCount := RowCount;
              LeftW2OffsetPropogationB.RemainingWidth := RemainingWidth;
              LeftW2OffsetPropogationB.RemainingHeight := RemainingHeight;
              LeftW2OffsetPropogationB.RemainingArea := RemainingArea;
              LeftW2OffsetPropogationB.Vec1y := Vec1y;
              LeftW2OffsetPropogationB.Vec2y := Vec2y;
              LeftW2OffsetPropogationB.Vec3x := Vec3x;
              LeftW2OffsetPropogationB.Vec3y := Vec3y;
              LeftW2OffsetPropogationB.Vec4x := Vec4x;
              LeftW2OffsetPropogationB.Vec4y := Vec4y;
            end;
          end;
        end
        else
        begin
        //Save details for both W1 & W2 starting positions
          if not W2First then
          begin
            if (j = 1) then
            begin
              RightW1CornerPropogation.PatternHeight := PatternHeight;
              RightW1CornerPropogation.PatternWidth := PatternWidth;
              RightW1CornerPropogation.W2First := False;
              RightW1CornerPropogation.InvertToBegin := InvertToBegin;
              RightW1CornerPropogation.NumberOfPatterns := NumberOfPatterns;
              RightW1CornerPropogation.NoInOddColumn := NoInOddColumn;
              RightW1CornerPropogation.NoInEvenColumn := NoInEvenColumn;
              RightW1CornerPropogation.RowCount := RowCount;
              RightW1CornerPropogation.RemainingWidth := RemainingWidth;
              RightW1CornerPropogation.RemainingHeight := RemainingHeight;
              RightW1CornerPropogation.RemainingArea := RemainingArea;
              RightW1CornerPropogation.Vec1y := Vec1y;
              RightW1CornerPropogation.Vec2y := Vec2y;
              RightW1CornerPropogation.Vec3x := Vec3x;
              RightW1CornerPropogation.Vec3y := Vec3y;
              RightW1CornerPropogation.Vec4x := Vec4x;
              RightW1CornerPropogation.Vec4y := Vec4y;
            end
            else if (j = 2) then
            begin
              RightW1OffsetPropogationA.PatternHeight := PatternHeight;
              RightW1OffsetPropogationA.PatternWidth := PatternWidth;
              RightW1OffsetPropogationA.W2First := False;
              RightW1OffsetPropogationA.InvertToBegin := InvertToBegin;
              RightW1OffsetPropogationA.NumberOfPatterns := NumberOfPatterns;
              RightW1OffsetPropogationA.NoInOddColumn := NoInOddColumn;
              RightW1OffsetPropogationA.NoInEvenColumn := NoInEvenColumn;
              RightW1OffsetPropogationA.RowCount := RowCount;
              RightW1OffsetPropogationA.RemainingWidth := RemainingWidth;
              RightW1OffsetPropogationA.RemainingHeight := RemainingHeight;
              RightW1OffsetPropogationA.RemainingArea := RemainingArea;
              RightW1OffsetPropogationA.Vec1y := Vec1y;
              RightW1OffsetPropogationA.Vec2y := Vec2y;
              RightW1OffsetPropogationA.Vec3x := Vec3x;
              RightW1OffsetPropogationA.Vec3y := Vec3y;
              RightW1OffsetPropogationA.Vec4x := Vec4x;
              RightW1OffsetPropogationA.Vec4y := Vec4y;
            end
            else if (j = 3) then
            begin
              RightW1OffsetPropogationB.PatternHeight := PatternHeight;
              RightW1OffsetPropogationB.PatternWidth := PatternWidth;
              RightW1OffsetPropogationB.W2First := False;
              RightW1OffsetPropogationB.InvertToBegin := InvertToBegin;
              RightW1OffsetPropogationB.NumberOfPatterns := NumberOfPatterns;
              RightW1OffsetPropogationB.NoInOddColumn := NoInOddColumn;
              RightW1OffsetPropogationB.NoInEvenColumn := NoInEvenColumn;
              RightW1OffsetPropogationB.RowCount := RowCount;
              RightW1OffsetPropogationB.RemainingWidth := RemainingWidth;
              RightW1OffsetPropogationB.RemainingHeight := RemainingHeight;
              RightW1OffsetPropogationB.RemainingArea := RemainingArea;
              RightW1OffsetPropogationB.Vec1y := Vec1y;
              RightW1OffsetPropogationB.Vec2y := Vec2y;
              RightW1OffsetPropogationB.Vec3x := Vec3x;
              RightW1OffsetPropogationB.Vec3y := Vec3y;
              RightW1OffsetPropogationB.Vec4x := Vec4x;
              RightW1OffsetPropogationB.Vec4y := Vec4y;
            end;
          end
          else
          begin
            if (j = 1) then
            begin
              RightW2CornerPropogation.PatternHeight := PatternHeight;
              RightW2CornerPropogation.PatternWidth := PatternWidth;
              RightW2CornerPropogation.W2First := True;
              RightW2CornerPropogation.InvertToBegin := InvertToBegin;
              RightW2CornerPropogation.NumberOfPatterns := NumberOfPatterns;
              RightW2CornerPropogation.NoInOddColumn := NoInOddColumn;
              RightW2CornerPropogation.NoInEvenColumn := NoInEvenColumn;
              RightW2CornerPropogation.RowCount := RowCount;
              RightW2CornerPropogation.RemainingWidth := RemainingWidth;
              RightW2CornerPropogation.RemainingHeight := RemainingHeight;
              RightW2CornerPropogation.RemainingArea := RemainingArea;
              RightW2CornerPropogation.Vec1y := Vec1y;
              RightW2CornerPropogation.Vec2y := Vec2y;
              RightW2CornerPropogation.Vec3x := Vec3x;
              RightW2CornerPropogation.Vec3y := Vec3y;
              RightW2CornerPropogation.Vec4x := Vec4x;
              RightW2CornerPropogation.Vec4y := Vec4y;
            end
            else if (j = 2) then
            begin
              RightW2OffsetPropogationA.PatternHeight := PatternHeight;
              RightW2OffsetPropogationA.PatternWidth := PatternWidth;
              RightW2OffsetPropogationA.W2First := True;
              RightW2OffsetPropogationA.InvertToBegin := InvertToBegin;
              RightW2OffsetPropogationA.NumberOfPatterns := NumberOfPatterns;
              RightW2OffsetPropogationA.NoInOddColumn := NoInOddColumn;
              RightW2OffsetPropogationA.NoInEvenColumn := NoInEvenColumn;
              RightW2OffsetPropogationA.RowCount := RowCount;
              RightW2OffsetPropogationA.RemainingWidth := RemainingWidth;
              RightW2OffsetPropogationA.RemainingHeight := RemainingHeight;
              RightW2OffsetPropogationA.RemainingArea := RemainingArea;
              RightW2OffsetPropogationA.Vec1y := Vec1y;
              RightW2OffsetPropogationA.Vec2y := Vec2y;
              RightW2OffsetPropogationA.Vec3x := Vec3x;
              RightW2OffsetPropogationA.Vec3y := Vec3y;
              RightW2OffsetPropogationA.Vec4x := Vec4x;
              RightW2OffsetPropogationA.Vec4y := Vec4y;
            end
            else if (j = 3) then
            begin
              RightW2OffsetPropogationB.PatternHeight := PatternHeight;
              RightW2OffsetPropogationB.PatternWidth := PatternWidth;
              RightW2OffsetPropogationB.W2First := True;
              RightW2OffsetPropogationB.InvertToBegin := InvertToBegin;
              RightW2OffsetPropogationB.NumberOfPatterns := NumberOfPatterns;
              RightW2OffsetPropogationB.NoInOddColumn := NoInOddColumn;
              RightW2OffsetPropogationB.NoInEvenColumn := NoInEvenColumn;
              RightW2OffsetPropogationB.RowCount := RowCount;
              RightW2OffsetPropogationB.RemainingWidth := RemainingWidth;
              RightW2OffsetPropogationB.RemainingHeight := RemainingHeight;
              RightW2OffsetPropogationB.RemainingArea := RemainingArea;
              RightW2OffsetPropogationB.Vec1y := Vec1y;
              RightW2OffsetPropogationB.Vec2y := Vec2y;
              RightW2OffsetPropogationB.Vec3x := Vec3x;
              RightW2OffsetPropogationB.Vec3y := Vec3y;
              RightW2OffsetPropogationB.Vec4x := Vec4x;
              RightW2OffsetPropogationB.Vec4y := Vec4y;
            end;
          end;
        end;
      end;
    end;

    if StartingLeft then
    begin
      if (LeftW1CornerPropogation.NumberOfPatterns >= LeftW1OffsetPropogationA.NumberOfPatterns) or
         ((LeftW1CornerPropogation.NumberOfPatterns = LeftW1OffsetPropogationA.NumberOfPatterns) and
         (LeftW1CornerPropogation.RemainingArea > LeftW1OffsetPropogationA.RemainingArea)) then
        LeftW1Propogation := LeftW1CornerPropogation
      else
        LeftW1Propogation := LeftW1OffsetPropogationa;

      if (LeftW1Propogation.NumberOfPatterns >= LeftW1OffsetPropogationB.NumberOfPatterns) or
         ((LeftW1Propogation.NumberOfPatterns = LeftW1OffsetPropogationB.NumberOfPatterns) and
         (LeftW1Propogation.RemainingArea > LeftW1OffsetPropogationB.RemainingArea)) then
        LeftW1Propogation := LeftW1Propogation
      else
        LeftW1Propogation := LeftW1OffsetPropogationB;

      if (LeftW2CornerPropogation.NumberOfPatterns >= LeftW2OffsetPropogationA.NumberOfPatterns) or
         ((LeftW2CornerPropogation.NumberOfPatterns = LeftW2OffsetPropogationA.NumberOfPatterns) and
         (LeftW2Propogation.RemainingArea > LeftW2OffsetPropogationA.RemainingArea)) then
        LeftW2Propogation := LeftW2CornerPropogation
      else
        LeftW2Propogation := LeftW2OffsetPropogationA;

      if (LeftW2Propogation.NumberOfPatterns >= LeftW2OffsetPropogationB.NumberOfPatterns) or
         ((LeftW2Propogation.NumberOfPatterns = LeftW2OffsetPropogationB.NumberOfPatterns) and
         (LeftW2Propogation.RemainingArea > LeftW2OffsetPropogationB.RemainingArea)) then
        LeftW2Propogation := LeftW2Propogation
      else
        LeftW2Propogation := LeftW2OffsetPropogationB;

      //Decide on best, either starting with LeftW1 or W2
      if (LeftW1Propogation.NumberOfPatterns >= LeftW2Propogation.NumberOfPatterns) or
         ((LeftW1Propogation.NumberOfPatterns = LeftW2Propogation.NumberOfPatterns) and
         (LeftW1Propogation.RemainingArea > LeftW2Propogation.RemainingArea)) then
        LeftPropogation := LeftW1Propogation
      else
        LeftPropogation := LeftW2Propogation;
    end
    else
    begin
      if (RightW1CornerPropogation.NumberOfPatterns >= RightW1OffsetPropogationA.NumberOfPatterns) or
         ((RightW1CornerPropogation.NumberOfPatterns = RightW1OffsetPropogationA.NumberOfPatterns) and
         (RightW1CornerPropogation.RemainingArea > RightW1OffsetPropogationA.RemainingArea)) then
        RightW1Propogation := RightW1CornerPropogation
      else
        RightW1Propogation := RightW1OffsetPropogationa;

      if (RightW1Propogation.NumberOfPatterns >= RightW1OffsetPropogationB.NumberOfPatterns) or
         ((RightW1Propogation.NumberOfPatterns = RightW1OffsetPropogationB.NumberOfPatterns) and
         (RightW1Propogation.RemainingArea > RightW1OffsetPropogationB.RemainingArea)) then
        RightW1Propogation := RightW1Propogation
      else
        RightW1Propogation := RightW1OffsetPropogationB;

      if (RightW2CornerPropogation.NumberOfPatterns >= RightW2OffsetPropogationA.NumberOfPatterns) or
         ((RightW2CornerPropogation.NumberOfPatterns = RightW2OffsetPropogationA.NumberOfPatterns) and
         (RightW2Propogation.RemainingArea > RightW2OffsetPropogationA.RemainingArea)) then
        RightW2Propogation := RightW2CornerPropogation
      else
        RightW2Propogation := RightW2OffsetPropogationA;

      if (RightW2Propogation.NumberOfPatterns >= RightW2OffsetPropogationB.NumberOfPatterns) or
         ((RightW2Propogation.NumberOfPatterns = RightW2OffsetPropogationB.NumberOfPatterns) and
         (RightW2Propogation.RemainingArea > RightW2OffsetPropogationB.RemainingArea)) then
        RightW2Propogation := RightW2Propogation
      else
        RightW2Propogation := RightW2OffsetPropogationB;

      //Decide on best, either starting with RightW1 or W2
      if (RightW1Propogation.NumberOfPatterns >= RightW2Propogation.NumberOfPatterns) or
         ((RightW1Propogation.NumberOfPatterns = RightW2Propogation.NumberOfPatterns) and
         (RightW1Propogation.RemainingArea > RightW2Propogation.RemainingArea)) then
        RightPropogation := RightW1Propogation
      else
        RightPropogation := RightW2Propogation;
    end;
  end;  //of loops

  if FixedStart or (LeftPropogation.NumberOfPatterns = RightPropogation.NumberOfPatterns) then
  begin
    if StartLeft then
      BestPropogation := LeftPropogation
    else
      BestPropogation := RightPropogation;

    StartingLeft := StartLeft;
  end
  else if (LeftPropogation.NumberOfPatterns > RightPropogation.NumberOfPatterns) then
  begin
    BestPropogation := LeftPropogation;
    StartingLeft := True;
  end
  else if (RightPropogation.NumberOfPatterns > LeftPropogation.NumberOfPatterns) then
  begin
    BestPropogation := RightPropogation;
    StartingLeft := False;
  end;

  ResultsVerticalP2Inverted(BestPropogation, UsableMaterialLength, UsableMaterialWidth, StartingLeft);

  //Results
  NumberOfPatterns := BestPropogation.NumberOfPatterns;
  RemainingHeight := BestPropogation.RemainingHeight;
  RemainingWidth := BestPropogation.RemainingWidth;
  RemainingArea := BestPropogation.RemainingArea;

{$IFDEF DEBUG}
  Prop := GetTickCount - Prop;
  TotalProp := TotalProp + Prop;
{$ENDIF}
end;

procedure PropogateHorizontalDiagonal(UsableMaterialLength, UsableMaterialWidth,
                                      PatternHeight, PatternWidth: integer;
                                      FixedStart, StartLeft, W2, FirstCutInCorner: boolean;
                                      LocalInterlock: TLocalInterlock;
                                      var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                      var RemainingArea: real; var StartingLeft: Boolean);
var
  RowStart, i, j, RowNo, ColCount, Loops, MaterialLengthAfterFirst, MaterialWidthAfterFirst,
  ThisRemainingWidth, Vec1x, Vec3x, Vec3y, Vec4x, Vec4y: integer;
  TheRows: array of TLineDetails;
  Start: integer;
  LeftRow1StartPropogation, LeftRow2StartPropogation, RightRow1StartPropogation, RightRow2StartPropogation,
  BestLeftPropogation, BestRightPropogation, BestPropogation: THDPropogation;
  ExtraHalfLeft, ExtraHalfRight, ExtraHalfRow: Boolean;
  ExtraHalfLeftNo, ExtraHalfRightNo: integer;
  SpaceForExtraHalf: integer;
  ColsToCount: integer;
  KeepResults: Boolean;
  HoldLocalInterlock: TLocalInterlock;

begin
{$IFDEF DEBUG}
  Prop := GetTickCount;
{$ENDIF}

  //Pre Results
  FillPropogationInput(PROPOGATION_HORIZONTALDIAGONAL, UsableMaterialLength,
                       UsableMaterialWidth, PatternHeight, PatternWidth, FALSE,
                       FixedStart, StartLeft, W2, FirstCutInCorner, FALSE, FALSE,
                       LocalInterlock, 0.0);

  HoldLocalInterlock := LocalInterlock;
  LeftRow1StartPropogation.NumberOfPatterns := 0;
  LeftRow2StartPropogation.NumberOfPatterns := 0;
  RightRow1StartPropogation.NumberOfPatterns := 0;
  RightRow2StartPropogation.NumberOfPatterns := 0;

  if (not FixedStart) and LocalInterlock.Used then
    Loops := 4
  else if FixedStart and LocalInterlock.Used then
    Loops := 2
  else if FixedStart then
  begin
    FixedStart := True;
    Loops := 1;
  end
  else
    Loops := 2;

  StartingLeft := True;
  for j := 1 to Loops do
  begin
    if FixedStart then
      StartingLeft := StartLeft
    else
      StartingLeft := not StartingLeft;

    if LocalInterlock.Used then
    begin
      //First with normal interlock, then with reversed interlock
      LocalInterlock := LocalInterlockToUse(HoldLocalInterlock, HORIZONTAL, (j > (Loops div 2)), FirstCutInCorner, StartingLeft);
      PatternWidth := LocalInterlock.PairedPatternWidth;
    end;

    for RowStart := 1 to 2 do
    begin
      //Calculate required vectors
      //Assumes 4, 0, 12, 8
      Vec1x := abs(CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left);
      if RowStart = 1 then
      begin
        Vec3x := CutResults[12].BoundingRect.Left - CutResults[8].BoundingRect.Left;
        Vec3y := CutResults[12].BoundingRect.Top - CutResults[8].BoundingRect.Top;
        Vec4x := CutResults[0].BoundingRect.Left - CutResults[12].BoundingRect.Left;
        Vec4y := CutResults[0].BoundingRect.Top - CutResults[12].BoundingRect.Top;
      end
      else
      begin
        Vec3x := CutResults[0].BoundingRect.Left - CutResults[12].BoundingRect.Left;
        Vec3y := CutResults[0].BoundingRect.Top - CutResults[12].BoundingRect.Top;
        Vec4x := CutResults[12].BoundingRect.Left - CutResults[8].BoundingRect.Left;
        Vec4y := CutResults[12].BoundingRect.Top - CutResults[8].BoundingRect.Top;
      end;

      //Initialise Remaining Width
      RemainingWidth := UsableMaterialWidth;

      //Calculate Number of Rows and Remaining Height
      MaterialLengthAfterFirst := UsableMaterialLength - PatternHeight;
      ColCount := 1 + ((MaterialLengthAfterFirst div (abs(Vec3y) + abs(Vec4y))) * 2);
      RemainingHeight := MaterialLengthAfterFirst - ((ColCount div 2) * (abs(Vec3y) + abs(Vec4y)));
      if RemainingHeight > abs(Vec3y) then
      begin
        inc(ColCount);
        RemainingHeight := RemainingHeight - abs(Vec3y);
      end;

      //Calculate Start Position for each Row and Number in that row
      //Also 1 extra row in case 'Extra half row' used
      setLength(TheRows, ColCount + 1);
      if StartingLeft then
        Start := -Vec4x
      else
        Start := UsableMaterialWidth - Vec4x;

      for RowNo := 1 to ColCount + 1 do
      begin
        if (RowNo mod 2) = 1 then
          Start := Start + Vec4x
        else
          Start := Start + Vec3x;

        //Push/Pull Rows into Start Position
        if StartingLeft then
        begin
          while Start < 0 do
            Start := Start + Vec1x;
          while Start > Vec1x do
            Start := Start - Vec1x;
        end
        else
        begin
          while Start > UsableMaterialWidth do
            Start := Start - Vec1x;
          while Start < UsableMaterialWidth - Vec1x do
            Start := Start + Vec1x;
        end;

        if StartingLeft then
          MaterialWidthAfterFirst := UsableMaterialWidth - (Start + PatternWidth)
        else
          MaterialWidthAfterFirst := Start - PatternWidth;

        TheRows[RowNo - 1].Start := Start;
        TheRows[RowNo - 1].No := 1 + (MaterialWidthAfterFirst div Vec1x);

        //Decide on extra 'half' pattern at left and at right
        if (not StartingLeft) then
        begin
          SpaceForExtraHalf := Start - (TheRows[RowNo - 1].No * Vec1x);
          ExtraHalfLeft := LocalInterlock.Used and (LocalInterlock.SinglePatternWidth <= SpaceForExtraHalf);
          ExtraHalfRight := LocalInterlock.Used and (LocalInterlock.SinglePatternWidth <= (UsableMaterialWidth - Start + (PatternWidth - abs(Vec1x))));
        end
        else
        begin
          ExtraHalfLeft := LocalInterlock.Used and (LocalInterlock.SinglePatternWidth <= (Start + (PatternWidth - abs(Vec1x))));
          SpaceForExtraHalf := (UsableMaterialWidth - Start) - (TheRows[RowNo - 1].No * Vec1x);
          ExtraHalfRight := LocalInterlock.Used and (LocalInterlock.SinglePatternWidth <= SpaceForExtraHalf);
        end;

        //Check extra 'half' patterns fit in the top left and right corners
        if (RowNo > ColCount) and ExtraHalfLeft and LocalInterlock.BottomIsLeft then
          ExtraHalfLeft := False;
        if ExtraHalfLeft then
          ExtraHalfLeftNo := 1
        else
          ExtraHalfLeftNo := 0;
        TheRows[RowNo - 1].ExtraHalfLeftNo := ExtraHalfLeftNo;
        if (RowNo > ColCount) and ExtraHalfRight and (not LocalInterlock.BottomIsLeft) then
          ExtraHalfRight := False;
        if ExtraHalfRight then
          ExtraHalfRightNo := 1
        else
          ExtraHalfRightNo := 0;
        TheRows[RowNo - 1].ExtraHalfRightNo := ExtraHalfRightNo;

        if ((not StartingLeft) and ExtraHalfLeft) or (StartingLeft and ExtraHalfRight) then
          ThisRemainingWidth := SpaceForExtraHalf - LocalInterlock.SinglePatternWidth
        else
        begin
          if (not StartingLeft) then
            ThisRemainingWidth := Start - (PatternWidth + ((TheRows[RowNo - 1].No - 1) * Vec1x))
          else
            ThisRemainingWidth := (UsableMaterialWidth - Start) - (PatternWidth + ((TheRows[RowNo - 1].No - 1) * Vec1x));
        end;

        if (ThisRemainingWidth < RemainingWidth) and (RowNo <= ColCount) then
          RemainingWidth := ThisRemainingWidth;
      end;

      //Decide on extra 'half' row
      ExtraHalfRow := LocalInterlock.Used and ((((ColCount div 2) * (abs(Vec3y) + abs(Vec4y))) + ((ColCount mod 2) * abs(Vec3y)) + LocalInterlock.SinglePatternHeight) < UsableMaterialLength);
      if ExtraHalfRow then
        RemainingHeight := UsableMaterialLength - (((ColCount div 2) * (abs(Vec3y) + abs(Vec4y))) + ((ColCount mod 2) * abs(Vec3y)) + LocalInterlock.SinglePatternHeight);

      //Calculate number of patterns for sheet
      ColsToCount := ColCount;
      if ExtraHalfRow then
        inc(ColsToCount);
      NumberOfPatterns := 0;
      for RowNo := 1 to ColsToCount do
      begin
        if LocalInterlock.Used then
        begin
          if RowNo > ColCount then
            NumberOfPatterns := NumberOfPatterns + TheRows[RowNo - 1].No
          else
            NumberOfPatterns := NumberOfPatterns + (TheRows[RowNo - 1].No * 2);
          NumberOfPatterns := NumberOfPatterns + TheRows[RowNo - 1].ExtraHalfLeftNo;
          NumberOfPatterns := NumberOfPatterns + TheRows[RowNo - 1].ExtraHalfRightNo;
        end
        else
          NumberOfPatterns := NumberOfPatterns + TheRows[RowNo - 1].No;
      end;
      RemainingArea := UncutArea(UsableMaterialLength, UsableMaterialWidth, RemainingHeight, RemainingWidth);

      KeepResults := False;
      if StartingLeft then
      begin
        if RowStart = 1 then
        begin
          if (NumberOfPatterns > LeftRow1StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = LeftRow1StartPropogation.NumberOfPatterns) and
              (RemainingArea > LeftRow1StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            LeftRow1StartPropogation.PatternHeight := PatternHeight;
            LeftRow1StartPropogation.PatternWidth := PatternWidth;
            LeftRow1StartPropogation.SecondRowFirst := False;
            setLength(LeftRow1StartPropogation.ARows, Length(TheRows));
            for i := 0 to Length(TheRows) - 1 do
              LeftRow1StartPropogation.ARows[i] := TheRows[i];
            LeftRow1StartPropogation.NumberOfPatterns := NumberOfPatterns;
            LeftRow1StartPropogation.RemainingWidth := RemainingWidth;
            LeftRow1StartPropogation.RemainingHeight := RemainingHeight;
            LeftRow1StartPropogation.RemainingArea := RemainingArea;
            LeftRow1StartPropogation.Vec1x := Vec1x;
            LeftRow1StartPropogation.Vec3x := Vec3x;
            LeftRow1StartPropogation.Vec3y := Vec3y;
            LeftRow1StartPropogation.Vec4x := Vec4x;
            LeftRow1StartPropogation.Vec4y := Vec4y;
            LeftRow1StartPropogation.LocalInterlock := LocalInterlock;
            LeftRow1StartPropogation.ExtraHalfRow := ExtraHalfRow;
          end;
        end
        else
        begin
          if (NumberOfPatterns > LeftRow2StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = LeftRow2StartPropogation.NumberOfPatterns) and
              (RemainingArea > LeftRow2StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            LeftRow2StartPropogation.PatternHeight := PatternHeight;
            LeftRow2StartPropogation.PatternWidth := PatternWidth;
            LeftRow2StartPropogation.SecondRowFirst := True;
            setLength(LeftRow2StartPropogation.ARows, Length(TheRows));
            for i := 0 to Length(TheRows) - 1 do
              LeftRow2StartPropogation.ARows[i] := TheRows[i];
            LeftRow2StartPropogation.NumberOfPatterns := NumberOfPatterns;
            LeftRow2StartPropogation.RemainingWidth := RemainingWidth;
            LeftRow2StartPropogation.RemainingHeight := RemainingHeight;
            LeftRow2StartPropogation.RemainingArea := RemainingArea;
            LeftRow2StartPropogation.Vec1x := Vec1x;
            LeftRow2StartPropogation.Vec3x := Vec3x;
            LeftRow2StartPropogation.Vec3y := Vec3y;
            LeftRow2StartPropogation.Vec4x := Vec4x;
            LeftRow2StartPropogation.Vec4y := Vec4y;
            LeftRow2StartPropogation.LocalInterlock := LocalInterlock;
            LeftRow2StartPropogation.ExtraHalfRow := ExtraHalfRow;
          end;
        end;
      end
      else
      begin
        if RowStart = 1 then
        begin
          if (NumberOfPatterns > RightRow1StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = RightRow1StartPropogation.NumberOfPatterns) and
              (RemainingArea > RightRow1StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            RightRow1StartPropogation.PatternHeight := PatternHeight;
            RightRow1StartPropogation.PatternWidth := PatternWidth;
            RightRow1StartPropogation.SecondRowFirst := False;
            setLength(RightRow1StartPropogation.ARows, Length(TheRows));
            for i := 0 to Length(TheRows) - 1 do
              RightRow1StartPropogation.ARows[i] := TheRows[i];
            RightRow1StartPropogation.NumberOfPatterns := NumberOfPatterns;
            RightRow1StartPropogation.RemainingWidth := RemainingWidth;
            RightRow1StartPropogation.RemainingHeight := RemainingHeight;
            RightRow1StartPropogation.RemainingArea := RemainingArea;
            RightRow1StartPropogation.Vec1x := Vec1x;
            RightRow1StartPropogation.Vec3x := Vec3x;
            RightRow1StartPropogation.Vec3y := Vec3y;
            RightRow1StartPropogation.Vec4x := Vec4x;
            RightRow1StartPropogation.Vec4y := Vec4y;
            RightRow1StartPropogation.LocalInterlock := LocalInterlock;
            RightRow1StartPropogation.ExtraHalfRow := ExtraHalfRow;
          end;
        end
        else
        begin
          if (NumberOfPatterns > RightRow2StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = RightRow2StartPropogation.NumberOfPatterns) and
              (RemainingArea > RightRow2StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            RightRow2StartPropogation.PatternHeight := PatternHeight;
            RightRow2StartPropogation.PatternWidth := PatternWidth;
            RightRow2StartPropogation.SecondRowFirst := True;
            setLength(RightRow2StartPropogation.ARows, Length(TheRows));
            for i := 0 to Length(TheRows) - 1 do
              RightRow2StartPropogation.ARows[i] := TheRows[i];
            RightRow2StartPropogation.NumberOfPatterns := NumberOfPatterns;
            RightRow2StartPropogation.RemainingWidth := RemainingWidth;
            RightRow2StartPropogation.RemainingHeight := RemainingHeight;
            RightRow2StartPropogation.RemainingArea := RemainingArea;
            RightRow2StartPropogation.Vec1x := Vec1x;
            RightRow2StartPropogation.Vec3x := Vec3x;
            RightRow2StartPropogation.Vec3y := Vec3y;
            RightRow2StartPropogation.Vec4x := Vec4x;
            RightRow2StartPropogation.Vec4y := Vec4y;
            RightRow2StartPropogation.LocalInterlock := LocalInterlock;
            RightRow2StartPropogation.ExtraHalfRow := ExtraHalfRow;
          end;
        end;
      end;
    end;
  end;

  //Decide on best, either starting with column 1 or column 2
  if (LeftRow1StartPropogation.NumberOfPatterns >= LeftRow2StartPropogation.NumberOfPatterns) or
     ((LeftRow1StartPropogation.NumberOfPatterns = LeftRow2StartPropogation.NumberOfPatterns) and
     (LeftRow1StartPropogation.RemainingArea > LeftRow2StartPropogation.RemainingArea)) then
    BestLeftPropogation := LeftRow1StartPropogation
  else
    BestLeftPropogation := LeftRow2StartPropogation;

  if (RightRow1StartPropogation.NumberOfPatterns >= RightRow2StartPropogation.NumberOfPatterns) or
     ((RightRow1StartPropogation.NumberOfPatterns = RightRow2StartPropogation.NumberOfPatterns) and
     (RightRow1StartPropogation.RemainingArea > RightRow2StartPropogation.RemainingArea)) then
    BestRightPropogation := RightRow1StartPropogation
  else
    BestRightPropogation := RightRow2StartPropogation;

  //If not FixedStart then StartLeft shows the preference
  if FixedStart or (BestLeftPropogation.NumberOfPatterns = BestRightPropogation.NumberOfPatterns) then
  begin
    if StartLeft then
      BestPropogation := BestLeftPropogation
    else
      BestPropogation := BestRightPropogation;

    StartingLeft := StartLeft;
  end
  else if (BestLeftPropogation.NumberOfPatterns > BestRightPropogation.NumberOfPatterns) then
  begin
    BestPropogation := BestLeftPropogation;
    StartingLeft := True;
  end
  else if (BestRightPropogation.NumberOfPatterns > BestLeftPropogation.NumberOfPatterns) then
  begin
    BestPropogation := BestRightPropogation;
    StartingLeft := False;
  end;

  ResultsHorizontalDiagonal(BestPropogation, UsableMaterialLength, UsableMaterialWidth, StartingLeft, W2);

  //Results
  NumberOfPatterns := BestPropogation.NumberOfPatterns;
  RemainingHeight := BestPropogation.RemainingHeight;
  RemainingWidth := BestPropogation.RemainingWidth;
  RemainingArea := BestPropogation.RemainingArea;

{$IFDEF DEBUG}
  Prop := GetTickCount - Prop;
  TotalProp := TotalProp + Prop;
{$ENDIF}
end;

procedure PropogateHorizontalP2InvertedDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                                                FixedStart, StartLeft: boolean;
                                                var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                                var RemainingArea: real; var StartingLeft: Boolean);
var
  ColStart, i, j, RowNo, ColCount, MaterialWidthAfterFirst, MaterialLengthAfterFirst,
  ThisRemainingWidth, NoInRow, Vec1x, Vec2x, Vec3x, Vec3y: integer;
  TheRows: array of TLineDetails;
  Loops, Start: integer;
  LeftCol1StartPropogation, LeftCol2StartPropogation, RightCol1StartPropogation, RightCol2StartPropogation,
  BestLeftPropogation, BestRightPropogation, BestPropogation: THP2IDPropogation;
  InvertStart: Boolean;

begin
{$IFDEF DEBUG}
  Prop := GetTickCount;
{$ENDIF}

  //Pre Results
  FillPropogationInput(PROPOGATION_HORIZONTALP2INVERTEDDIAGONAL,
                       UsableMaterialLength, UsableMaterialWidth, PatternHeight,
                       PatternWidth, FALSE, FixedStart, StartLeft, FALSE, FALSE,
                       FALSE, FALSE, EmptyLocalInterlock, 0.0);

  LeftCol1StartPropogation.NumberOfPatterns := 0;
  RightCol1StartPropogation.NumberOfPatterns := 0;
  LeftCol2StartPropogation.NumberOfPatterns := 0;
  RightCol2StartPropogation.NumberOfPatterns := 0;

  if FixedStart then
  begin
    Loops := 1;
    StartingLeft := StartLeft;
  end
  else
  begin
    Loops := 2;
    StartingLeft := False;
  end;

  for j := 1 to Loops do
  begin
    if j = 2 then
      StartingLeft := True;

    for ColStart := 1 to 2 do
    begin
      //Calculate required vectors
      if StartingLeft then
      begin
        Vec1x := abs(CutResults[2].BoundingRect.Left - CutResults[1].BoundingRect.Left);
        Vec2x := abs(CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left);
      end
      else
      begin
        Vec1x := abs(CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left);
        Vec2x := abs(CutResults[2].BoundingRect.Left - CutResults[1].BoundingRect.Left);
      end;
      Vec3x := CutResults[4].BoundingRect.Left - CutResults[0].BoundingRect.Left;
      Vec3y := CutResults[4].BoundingRect.Top - CutResults[0].BoundingRect.Top;

      //Initialise Remaining Width
      RemainingWidth := UsableMaterialWidth;

      //Calculate Number or Rows and Remaining Height
      MaterialLengthAfterFirst := UsableMaterialLength - PatternHeight;
      ColCount := 1 + (MaterialLengthAfterFirst div abs(Vec3y));
      RemainingHeight := MaterialLengthAfterFirst - ((ColCount - 1) * abs(Vec3y));

      InvertStart := (ColStart = 2);

      //Calculate Start Position for each Row and Number in that row
      setLength(TheRows, ColCount);
      if StartingLeft then
        Start := -Vec3x
      else
        Start := UsableMaterialWidth - Vec3x;
      for RowNo := 1 to ColCount do
      begin
        Start := Start + Vec3x;

        //Push/Pull Cols into Start Position
        if StartingLeft then
        begin
          while Start < 0 do
            Start := Start + Vec1x + Vec2x;
          while Start > (Vec1x + Vec2x) do
            Start := Start - (Vec1x + Vec2x);
        end
        else
        begin
          while Start > UsableMaterialWidth do
            Start := Start - (Vec1x + Vec2x);
          while Start < UsableMaterialWidth - (Vec1x + Vec2x) do
            Start := Start + Vec1x + Vec2x;
        end;

        if StartingLeft then
        begin
          if InvertStart then
          begin
            if Start > Vec1x then
            begin
              Start := Start - Vec1x;
              InvertStart := not InvertStart;
            end;
          end
          else
          begin
            if Start > Vec2x then
            begin
              Start := Start - Vec2x;
              InvertStart := not InvertStart;
            end;
          end;
        end
        else
        begin
          if InvertStart then
          begin
            if Start < UsableMaterialWidth - Vec1x then
            begin
              Start := Start + Vec1x;
              InvertStart := not InvertStart;
            end;
          end
          else
          begin
            if Start < UsableMaterialWidth - Vec2x then
            begin
              Start := Start + Vec2x;
              InvertStart := not InvertStart;
            end;
          end;
        end;

        if StartingLeft then
          MaterialWidthAfterFirst := UsableMaterialWidth - (Start + PatternWidth)
        else
          MaterialWidthAfterFirst := Start - PatternWidth;

        NoInRow := 1 + ((MaterialWidthAfterFirst div (abs(Vec1x) + abs(Vec2x))) * 2);
        ThisRemainingWidth := MaterialWidthAfterFirst - (((NoInRow - 1) div 2) * (abs(Vec1x) + abs(Vec2x)));
        if InvertStart and (ThisRemainingWidth > abs(Vec2x)) then
        begin
          inc(NoInRow);
          ThisRemainingWidth := ThisRemainingWidth - abs(Vec2x);
        end
        else if (not InvertStart) and (ThisRemainingWidth > abs(Vec1x)) then
        begin
          inc(NoInRow);
          ThisRemainingWidth := ThisRemainingWidth - abs(Vec1x);
        end;
        if ThisRemainingWidth < RemainingWidth then
          RemainingWidth := ThisRemainingWidth;

        TheRows[RowNo - 1].Start := Start;
        TheRows[RowNo - 1].No := NoInRow;
        TheRows[RowNo - 1].W2Start := InvertStart;
      end;

      //Calculate number of patterns for sheet
      NumberOfPatterns := 0;
      for RowNo := 1 to ColCount do
        NumberOfPatterns := NumberOfPatterns + TheRows[RowNo - 1].No;
      RemainingArea := UncutArea(UsableMaterialLength, UsableMaterialWidth, RemainingHeight, RemainingWidth);

      if StartingLeft then
      begin
        if ColStart = 1 then
        begin
          LeftCol1StartPropogation.PatternHeight := PatternHeight;
          LeftCol1StartPropogation.PatternWidth := PatternWidth;
          setLength(LeftCol1StartPropogation.ARows, Length(TheRows));
          for i := 0 to Length(TheRows) - 1 do
            LeftCol1StartPropogation.ARows[i] := TheRows[i];
          LeftCol1StartPropogation.NumberOfPatterns := NumberOfPatterns;
          LeftCol1StartPropogation.RemainingWidth := RemainingWidth;
          LeftCol1StartPropogation.RemainingHeight := RemainingHeight;
          LeftCol1StartPropogation.RemainingArea := RemainingArea;
          LeftCol1StartPropogation.Vec1x := Vec1x;
          LeftCol1StartPropogation.Vec2x := Vec2x;
          LeftCol1StartPropogation.Vec3x := Vec3x;
          LeftCol1StartPropogation.Vec3y := Vec3y;
        end
        else
        begin
          LeftCol2StartPropogation.PatternHeight := PatternHeight;
          LeftCol2StartPropogation.PatternWidth := PatternWidth;
          setLength(LeftCol2StartPropogation.ARows, Length(TheRows));
          for i := 0 to Length(TheRows) - 1 do
            LeftCol2StartPropogation.ARows[i] := TheRows[i];
          LeftCol2StartPropogation.NumberOfPatterns := NumberOfPatterns;
          LeftCol2StartPropogation.RemainingWidth := RemainingWidth;
          LeftCol2StartPropogation.RemainingHeight := RemainingHeight;
          LeftCol2StartPropogation.RemainingArea := RemainingArea;
          LeftCol2StartPropogation.Vec1x := Vec1x;
          LeftCol2StartPropogation.Vec2x := Vec2x;
          LeftCol2StartPropogation.Vec3x := Vec3x;
          LeftCol2StartPropogation.Vec3y := Vec3y;
        end;
      end
      else
      begin
        if ColStart = 1 then
        begin
          RightCol1StartPropogation.PatternHeight := PatternHeight;
          RightCol1StartPropogation.PatternWidth := PatternWidth;
          setLength(RightCol1StartPropogation.ARows, Length(TheRows));
          for i := 0 to Length(TheRows) - 1 do
            RightCol1StartPropogation.ARows[i] := TheRows[i];
          RightCol1StartPropogation.NumberOfPatterns := NumberOfPatterns;
          RightCol1StartPropogation.RemainingWidth := RemainingWidth;
          RightCol1StartPropogation.RemainingHeight := RemainingHeight;
          RightCol1StartPropogation.RemainingArea := RemainingArea;
          RightCol1StartPropogation.Vec1x := Vec1x;
          RightCol1StartPropogation.Vec2x := Vec2x;
          RightCol1StartPropogation.Vec3x := Vec3x;
          RightCol1StartPropogation.Vec3y := Vec3y;
        end
        else
        begin
          RightCol2StartPropogation.PatternHeight := PatternHeight;
          RightCol2StartPropogation.PatternWidth := PatternWidth;
           setLength(RightCol2StartPropogation.ARows, Length(TheRows));
          for i := 0 to Length(TheRows) - 1 do
            RightCol2StartPropogation.ARows[i] := TheRows[i];
          RightCol2StartPropogation.NumberOfPatterns := NumberOfPatterns;
          RightCol2StartPropogation.RemainingWidth := RemainingWidth;
          RightCol2StartPropogation.RemainingHeight := RemainingHeight;
          RightCol2StartPropogation.RemainingArea := RemainingArea;
          RightCol2StartPropogation.Vec1x := Vec1x;
          RightCol2StartPropogation.Vec2x := Vec2x;
          RightCol2StartPropogation.Vec3x := Vec3x;
          RightCol2StartPropogation.Vec3y := Vec3y;
        end;
      end;
    end;
  end; //loop

  //Decide on best, either starting with row 1 or row 2
  if (LeftCol1StartPropogation.NumberOfPatterns >= LeftCol2StartPropogation.NumberOfPatterns) or
     ((LeftCol1StartPropogation.NumberOfPatterns = LeftCol2StartPropogation.NumberOfPatterns) and
     (LeftCol1StartPropogation.RemainingArea > LeftCol2StartPropogation.RemainingArea)) then
    BestLeftPropogation := LeftCol1StartPropogation
  else
    BestLeftPropogation := LeftCol2StartPropogation;

  if (RightCol1StartPropogation.NumberOfPatterns >= RightCol2StartPropogation.NumberOfPatterns) or
     ((RightCol1StartPropogation.NumberOfPatterns = RightCol2StartPropogation.NumberOfPatterns) and
     (RightCol1StartPropogation.RemainingArea > RightCol2StartPropogation.RemainingArea)) then
    BestRightPropogation := RightCol1StartPropogation
  else
    BestRightPropogation := RightCol2StartPropogation;

  //If not FixedStart then StartLeft shows the preference
  if FixedStart or (BestLeftPropogation.NumberOfPatterns = BestRightPropogation.NumberOfPatterns) then
  begin
    if StartLeft then
      BestPropogation := BestLeftPropogation
    else
      BestPropogation := BestRightPropogation;

    StartingLeft := StartLeft;
  end
  else if (BestLeftPropogation.NumberOfPatterns > BestRightPropogation.NumberOfPatterns) then
  begin
    BestPropogation := BestLeftPropogation;
    StartingLeft := True;
  end
  else if (BestRightPropogation.NumberOfPatterns > BestLeftPropogation.NumberOfPatterns) then
  begin
    BestPropogation := BestRightPropogation;
    StartingLeft := False;
  end;

  ResultsHorizontalP2InvertedDiagonal(BestPropogation, UsableMaterialLength, UsableMaterialWidth, StartingLeft);
  
  //Results
  NumberOfPatterns := BestPropogation.NumberOfPatterns;
  RemainingHeight := BestPropogation.RemainingHeight;
  RemainingWidth := BestPropogation.RemainingWidth;
  RemainingArea := BestPropogation.RemainingArea;

{$IFDEF DEBUG}
  Prop := GetTickCount - Prop;
  TotalProp := TotalProp + Prop;
{$ENDIF}
end;

procedure PropogateVerticalDiagonal(UsableMaterialLength, UsableMaterialWidth,
                                    PatternHeight, PatternWidth: integer;
                                    FixedStart, StartLeft, W2, FirstCutInCorner: boolean;
                                    LocalInterlock: TLocalInterlock;
                                    var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                    var RemainingArea: real; var StartingLeft: Boolean);
var
  ColumnStart, i, j, ColNo, RowCount, MaterialLengthAfterFirst, MaterialWidthAfterFirst,
  ThisRemainingHeight, Vec1y, Vec3x, Vec3y, Vec4x, Vec4y: integer;
  TheColumns: array of TLineDetails;
  FirstColumn, Loops, Start, VectorDirection: integer;
  Col1StartPropogation, Col2StartPropogation, LeftCol1StartPropogation, LeftCol2StartPropogation, RightCol1StartPropogation, RightCol2StartPropogation,
  BestLeftPropogation, BestRightPropogation, BestPropogation: TVDPropogation;
  ExtraHalfTop, ExtraHalfBottom, ExtraHalfColumn: Boolean;
  ExtraHalfTopNo, ExtraHalfBottomNo: integer;
  SpaceForExtraHalf: integer;
  RowsToCount: integer;
  KeepResults: Boolean;
  HoldLocalInterlock: TLocalInterlock;
  NoCols: integer;

begin
{$IFDEF DEBUG}
  Prop := GetTickCount;
{$ENDIF}

  //Pre Results
  FillPropogationInput(PROPOGATION_VERTICALDIAGONAL, UsableMaterialLength,
                       UsableMaterialWidth, PatternHeight, PatternWidth, FALSE,
                       FixedStart, StartLeft, W2, FirstCutInCorner, FALSE,
                       FALSE, LocalInterlock, 0.0);

  HoldLocalInterlock := LocalInterlock;
  LeftCol1StartPropogation.NumberOfPatterns := 0;
  LeftCol2StartPropogation.NumberOfPatterns := 0;
  RightCol1StartPropogation.NumberOfPatterns := 0;
  RightCol2StartPropogation.NumberOfPatterns := 0;

  if (not FixedStart) and LocalInterlock.Used then
    Loops := 4
  else if FixedStart and LocalInterlock.Used then
    Loops := 2
  else if FixedStart then
    Loops := 1
  else
    Loops := 2;

  StartingLeft := True;
  for j := 1 to Loops do
  begin
    if FixedStart then
      StartingLeft := StartLeft
    else
      StartingLeft := not StartingLeft;

    if LocalInterlock.Used then
    begin
      //First with normal interlock, then with reversed interlock
      LocalInterlock := LocalInterlockToUse(HoldLocalInterlock, VERTICAL, (j > (Loops div 2)), FirstCutInCorner, StartingLeft);
      PatternHeight := LocalInterlock.PairedPatternHeight;
    end;

    if StartingLeft then
    begin
      FirstColumn := 2;
      VectorDirection := -1;
    end
    else
    begin
      FirstColumn := 1;
      VectorDirection := 1;
    end;

    for ColumnStart := 1 to 2 do
    begin
      //Calculate required vectors
      //Assumes 4, 0, 12, 8
      Vec1y := abs(CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top);
      if ColumnStart = FirstColumn then
      begin
        Vec3x := VectorDirection * (CutResults[12].BoundingRect.Left - CutResults[8].BoundingRect.Left);
        Vec3y := VectorDirection * (CutResults[12].BoundingRect.Top - CutResults[8].BoundingRect.Top);
        Vec4x := VectorDirection * (CutResults[0].BoundingRect.Left - CutResults[12].BoundingRect.Left);
        Vec4y := VectorDirection * (CutResults[0].BoundingRect.Top - CutResults[12].BoundingRect.Top);
      end
      else
      begin
        Vec3x := VectorDirection * (CutResults[0].BoundingRect.Left - CutResults[12].BoundingRect.Left);
        Vec3y := VectorDirection * (CutResults[0].BoundingRect.Top - CutResults[12].BoundingRect.Top);
        Vec4x := VectorDirection * (CutResults[12].BoundingRect.Left - CutResults[8].BoundingRect.Left);
        Vec4y := VectorDirection * (CutResults[12].BoundingRect.Top - CutResults[8].BoundingRect.Top);
      end;

      //Initialise Remaining Height
      RemainingHeight := UsableMaterialLength;

      //Calculate Number of Columns and Remaining Width
      MaterialWidthAfterFirst := UsableMaterialWidth - PatternWidth;
      RowCount := 1 + ((MaterialWidthAfterFirst div (abs(Vec3x) + abs(Vec4x))) * 2);
      RemainingWidth := MaterialWidthAfterFirst - ((RowCount div 2) * (abs(Vec3x) + abs(Vec4x)));
      if RemainingWidth > abs(Vec3x) then
      begin
        inc(RowCount);
        RemainingWidth := RemainingWidth - abs(Vec3x);
      end;

      //Decide on extra 'half' column
      ExtraHalfColumn := LocalInterlock.Used and ((((RowCount div 2) * (abs(Vec3x) + abs(Vec4x))) + ((RowCount mod 2) * abs(Vec3x)) + LocalInterlock.SinglePatternWidth) < UsableMaterialWidth);
      if ExtraHalfColumn then
        RemainingWidth := UsableMaterialWidth - (((RowCount div 2) * (abs(Vec3x) + abs(Vec4x))) + ((RowCount mod 2) * abs(Vec3x)) + LocalInterlock.SinglePatternWidth);

      //Calculate Start Position for each Column and Number in that column
      //Also 1 extra column in case 'Extra half column' used
      setLength(TheColumns, RowCount + 1);
      Start := UsableMaterialLength - Vec4y;
      NoCols := RowCount;
      if ExtraHalfColumn then
        inc(NoCols);
      for ColNo := 1 to NoCols do
      begin
        if (ColNo mod 2) = 1 then
          Start := Start + Vec4y
        else
          Start := Start + Vec3y;

        //Push/Pull Columns into Start Position
        while Start > UsableMaterialLength do
          Start := Start - Vec1y;
        while Start < UsableMaterialLength - Vec1y do
          Start := Start + Vec1y;

        MaterialLengthAfterFirst := Start - PatternHeight;

        TheColumns[ColNo - 1].Start := Start;
        TheColumns[ColNo - 1].No := 1 + (MaterialLengthAfterFirst div Vec1y);

        //Decide on extra 'half' pattern at top
        SpaceForExtraHalf := Start - (TheColumns[ColNo - 1].No * Vec1y);
        ExtraHalfTop := LocalInterlock.Used and (LocalInterlock.SinglePatternHeight <= SpaceForExtraHalf);
        if (ColNo > RowCount) and ExtraHalfTop then
        begin
          if ((not StartingLeft) and LocalInterlock.BottomIsLeft) or
             (StartingLeft and (not LocalInterlock.BottomIsLeft)) then
            ExtraHalfTop := False;
        end;
        if ExtraHalfTop then
          ExtraHalfTopNo := 1
        else
          ExtraHalfTopNo := 0;
        TheColumns[ColNo - 1].ExtraHalfTopNo := ExtraHalfTopNo;

        //Decide on extra 'half' pattern at bottom
        ExtraHalfBottom := LocalInterlock.Used and (LocalInterlock.SinglePatternHeight <= (UsableMaterialLength - Start + (PatternHeight - abs(Vec1y))));
        if (ColNo > RowCount) and ExtraHalfBottom then
        begin
          if ((not StartingLeft) and (not LocalInterlock.BottomIsLeft)) or
             (StartingLeft and LocalInterlock.BottomIsLeft) then
            ExtraHalfBottom := False;
        end;
        if ExtraHalfBottom then
          ExtraHalfBottomNo := 1
        else
          ExtraHalfBottomNo := 0;
        TheColumns[ColNo - 1].ExtraHalfBottomNo := ExtraHalfBottomNo;

        if ExtraHalfTop then
          ThisRemainingHeight := SpaceForExtraHalf - LocalInterlock.SinglePatternHeight
        else
          ThisRemainingHeight := Start - (PatternHeight + ((TheColumns[ColNo - 1].No - 1) * Vec1y));

        //Note the 'extra' 'half' column height is check below
        if (ThisRemainingHeight < RemainingHeight) then
          RemainingHeight := ThisRemainingHeight;
      end;

      //Calculate number of patterns for sheet
      RowsToCount := RowCount;
      if ExtraHalfColumn then
        inc(RowsToCount);
      NumberOfPatterns := 0;
      for ColNo := 1 to RowsToCount do
      begin
        if LocalInterlock.Used then
        begin
          if ColNo > RowCount then
            NumberOfPatterns := NumberOfPatterns + TheColumns[ColNo - 1].No
          else
            NumberOfPatterns := NumberOfPatterns + (TheColumns[ColNo - 1].No * 2);
          NumberOfPatterns := NumberOfPatterns + TheColumns[ColNo - 1].ExtraHalfTopNo;
          NumberOfPatterns := NumberOfPatterns + TheColumns[ColNo - 1].ExtraHalfBottomNo;
        end
        else
          NumberOfPatterns := NumberOfPatterns + TheColumns[ColNo - 1].No;
      end;
      RemainingArea := UncutArea(UsableMaterialLength, UsableMaterialWidth, RemainingHeight, RemainingWidth);

      KeepResults := False;
      if StartingLeft then
      begin
        if ColumnStart = 1 then
        begin
          if (NumberOfPatterns > LeftCol1StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = LeftCol1StartPropogation.NumberOfPatterns) and
              (RemainingArea > LeftCol1StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            LeftCol1StartPropogation.PatternHeight := PatternHeight;
            LeftCol1StartPropogation.PatternWidth := PatternWidth;
            LeftCol1StartPropogation.SecondColumnFirst := False;
            setLength(LeftCol1StartPropogation.AColumns, Length(TheColumns));
            for i := 0 to Length(TheColumns) - 1 do
              LeftCol1StartPropogation.AColumns[i] := TheColumns[i];
            LeftCol1StartPropogation.NumberOfPatterns := NumberOfPatterns;
            LeftCol1StartPropogation.RemainingWidth := RemainingWidth;
            LeftCol1StartPropogation.RemainingHeight := RemainingHeight;
            LeftCol1StartPropogation.RemainingArea := RemainingArea;
            LeftCol1StartPropogation.Vec1y := Vec1y;
            LeftCol1StartPropogation.Vec3x := Vec3x;
            LeftCol1StartPropogation.Vec3y := Vec3y;
            LeftCol1StartPropogation.Vec4x := Vec4x;
            LeftCol1StartPropogation.Vec4y := Vec4y;
            LeftCol1StartPropogation.LocalInterlock := LocalInterlock;
            LeftCol1StartPropogation.ExtraHalfColumn := ExtraHalfColumn;
          end
        end
        else
        begin
          if (NumberOfPatterns > LeftCol2StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = LeftCol2StartPropogation.NumberOfPatterns) and
              (RemainingArea > LeftCol2StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            LeftCol2StartPropogation.PatternHeight := PatternHeight;
            LeftCol2StartPropogation.PatternWidth := PatternWidth;
            LeftCol2StartPropogation.SecondColumnFirst := True;
            setLength(LeftCol2StartPropogation.AColumns, Length(TheColumns));
            for i := 0 to Length(TheColumns) - 1 do
              LeftCol2StartPropogation.AColumns[i] := TheColumns[i];
            LeftCol2StartPropogation.NumberOfPatterns := NumberOfPatterns;
            LeftCol2StartPropogation.RemainingWidth := RemainingWidth;
            LeftCol2StartPropogation.RemainingHeight := RemainingHeight;
            LeftCol2StartPropogation.RemainingArea := RemainingArea;
            LeftCol2StartPropogation.Vec1y := Vec1y;
            LeftCol2StartPropogation.Vec3x := Vec3x;
            LeftCol2StartPropogation.Vec3y := Vec3y;
            LeftCol2StartPropogation.Vec4x := Vec4x;
            LeftCol2StartPropogation.Vec4y := Vec4y;
            LeftCol2StartPropogation.LocalInterlock := LocalInterlock;
            LeftCol2StartPropogation.ExtraHalfColumn := ExtraHalfColumn;
          end;
        end
      end
      else
      begin
        if ColumnStart = 1 then
        begin
          if (NumberOfPatterns > RightCol1StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = RightCol1StartPropogation.NumberOfPatterns) and
              (RemainingArea > RightCol1StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            RightCol1StartPropogation.PatternHeight := PatternHeight;
            RightCol1StartPropogation.PatternWidth := PatternWidth;
            RightCol1StartPropogation.SecondColumnFirst := False;
            setLength(RightCol1StartPropogation.AColumns, Length(TheColumns));
            for i := 0 to Length(TheColumns) - 1 do
              RightCol1StartPropogation.AColumns[i] := TheColumns[i];
            RightCol1StartPropogation.NumberOfPatterns := NumberOfPatterns;
            RightCol1StartPropogation.RemainingWidth := RemainingWidth;
            RightCol1StartPropogation.RemainingHeight := RemainingHeight;
            RightCol1StartPropogation.RemainingArea := RemainingArea;
            RightCol1StartPropogation.Vec1y := Vec1y;
            RightCol1StartPropogation.Vec3x := Vec3x;
            RightCol1StartPropogation.Vec3y := Vec3y;
            RightCol1StartPropogation.Vec4x := Vec4x;
            RightCol1StartPropogation.Vec4y := Vec4y;
            RightCol1StartPropogation.LocalInterlock := LocalInterlock;
            RightCol1StartPropogation.ExtraHalfColumn := ExtraHalfColumn;
          end;
        end
        else
        begin
          if (NumberOfPatterns > RightCol2StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = RightCol2StartPropogation.NumberOfPatterns) and
              (RemainingArea > RightCol2StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            RightCol2StartPropogation.PatternHeight := PatternHeight;
            RightCol2StartPropogation.PatternWidth := PatternWidth;
            RightCol2StartPropogation.SecondColumnFirst := True;
            setLength(RightCol2StartPropogation.AColumns, Length(TheColumns));
            for i := 0 to Length(TheColumns) - 1 do
              RightCol2StartPropogation.AColumns[i] := TheColumns[i];
            RightCol2StartPropogation.NumberOfPatterns := NumberOfPatterns;
            RightCol2StartPropogation.RemainingWidth := RemainingWidth;
            RightCol2StartPropogation.RemainingHeight := RemainingHeight;
            RightCol2StartPropogation.RemainingArea := RemainingArea;
            RightCol2StartPropogation.Vec1y := Vec1y;
            RightCol2StartPropogation.Vec3x := Vec3x;
            RightCol2StartPropogation.Vec3y := Vec3y;
            RightCol2StartPropogation.Vec4x := Vec4x;
            RightCol2StartPropogation.Vec4y := Vec4y;
            RightCol2StartPropogation.LocalInterlock := LocalInterlock;
            RightCol2StartPropogation.ExtraHalfColumn := ExtraHalfColumn;
          end;
        end;
      end;
    end;
  end;

  //Decide on best, either starting with column 1 or column 2/start from left or start from right
  if (LeftCol1StartPropogation.NumberOfPatterns >= LeftCol2StartPropogation.NumberOfPatterns) or
     ((LeftCol1StartPropogation.NumberOfPatterns = LeftCol2StartPropogation.NumberOfPatterns) and (LeftCol1StartPropogation.RemainingArea > LeftCol2StartPropogation.RemainingArea)) then
    BestLeftPropogation := LeftCol1StartPropogation
  else
    BestLeftPropogation := LeftCol2StartPropogation;

  if (RightCol1StartPropogation.NumberOfPatterns >= RightCol2StartPropogation.NumberOfPatterns) or
     ((RightCol1StartPropogation.NumberOfPatterns = RightCol2StartPropogation.NumberOfPatterns) and (RightCol1StartPropogation.RemainingArea > RightCol2StartPropogation.RemainingArea)) then
    BestRightPropogation := RightCol1StartPropogation
  else
    BestRightPropogation := RightCol2StartPropogation;

  //If not FixedStart then StartLeft shows the preference
  if FixedStart or (BestLeftPropogation.NumberOfPatterns = BestRightPropogation.NumberOfPatterns) then
  begin
    if StartLeft then
      BestPropogation := BestLeftPropogation
    else
      BestPropogation := BestRightPropogation;

    StartingLeft := StartLeft;
  end
  else if (BestLeftPropogation.NumberOfPatterns > BestRightPropogation.NumberOfPatterns) then
  begin
    BestPropogation := BestLeftPropogation;
    StartingLeft := True;
  end
  else if (BestRightPropogation.NumberOfPatterns > BestLeftPropogation.NumberOfPatterns) then
  begin
    BestPropogation := BestRightPropogation;
    StartingLeft := False;
  end;

  ResultsVerticalDiagonal(BestPropogation, UsableMaterialLength, UsableMaterialWidth, StartingLeft, W2);

  //Results
  NumberOfPatterns := BestPropogation.NumberOfPatterns;
  RemainingHeight := BestPropogation.RemainingHeight;
  RemainingWidth := BestPropogation.RemainingWidth;
  RemainingArea := BestPropogation.RemainingArea;

{$IFDEF DEBUG}
  Prop := GetTickCount - Prop;
  TotalProp := TotalProp + Prop;
{$ENDIF}
end;

procedure PropogateVerticalP2InvertedDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth: integer;
                                              FixedStart, StartLeft: boolean;
                                              var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                              var RemainingArea: real; var StartingLeft: Boolean);
var
  Loops, RowStart, i, j, ColNo, RowCount, MaterialLengthAfterFirst, MaterialWidthAfterFirst,
  ThisRemainingHeight, NoInColumn, Vec1y, Vec2y, Vec3x, Vec3y: integer;
  TheColumns: array of TLineDetails;
  Start, VectorDirection: integer;
  LeftRow1StartPropogation, LeftRow2StartPropogation, RightRow1StartPropogation, RightRow2StartPropogation,
  BestLeftPropogation, BestRightPropogation, BestPropogation: TVP2IDPropogation;
  InvertStart: Boolean;

begin
{$IFDEF DEBUG}
  Prop := GetTickCount;
{$ENDIF}

  //Pre Results
  FillPropogationInput(PROPOGATION_VERTICALP2INVERTEDDIAGONAL,
                       UsableMaterialLength, UsableMaterialWidth, PatternHeight,
                       PatternWidth, FALSE, FixedStart, StartLeft, FALSE, FALSE,
                       FALSE, FALSE, EmptyLocalInterlock, 0.0);

  LeftRow1StartPropogation.NumberOfPatterns := 0;
  LeftRow2StartPropogation.NumberOfPatterns := 0;
  RightRow1StartPropogation.NumberOfPatterns := 0;
  RightRow2StartPropogation.NumberOfPatterns := 0;

  if FixedStart then
  begin
    Loops := 1;
    StartingLeft := StartLeft;
  end
  else
  begin
    Loops := 2;
    StartingLeft := False;
  end;

  for j := 1 to Loops do
  begin
    if j = 2 then
      StartingLeft := True;

    if StartingLeft then
      VectorDirection := -1
    else
      VectorDirection := 1;

    for RowStart := 1 to 2 do
    begin
      //Calculate required vectors
      Vec1y := abs(CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top);
      Vec2y := abs(CutResults[2].BoundingRect.Top - CutResults[1].BoundingRect.Top);
      Vec3x := VectorDirection * (CutResults[4].BoundingRect.Left - CutResults[0].BoundingRect.Left);
      Vec3y := VectorDirection * (CutResults[4].BoundingRect.Top - CutResults[0].BoundingRect.Top);

      //Initialise Remaining Height
      RemainingHeight := UsableMaterialLength;

      //Calculate Number or Columns and Remaining Width
      MaterialWidthAfterFirst := UsableMaterialWidth - PatternWidth;
      RowCount := 1 + (MaterialWidthAfterFirst div abs(Vec3x));
      RemainingWidth := MaterialWidthAfterFirst - ((RowCount - 1) * abs(Vec3x));

      InvertStart := (RowStart = 2);

      //Calculate Start Position for each Column and Number in that column
      setLength(TheColumns, RowCount);
      Start := UsableMaterialLength - Vec3y;
      for ColNo := 1 to RowCount do
      begin
        Start := Start + Vec3y;

        //Push/Pull Columns into Start Position
        while Start > UsableMaterialLength do
          Start := Start - (Vec1y + Vec2y);
        while Start < UsableMaterialLength - (Vec1y + Vec2y) do
          Start := Start + Vec1y + Vec2y;
        if InvertStart then
        begin
          if Start < UsableMaterialLength - Vec1y then
          begin
            Start := Start + Vec1y;
            InvertStart := not InvertStart;
          end;
        end
        else
        begin
          if Start < UsableMaterialLength - Vec2y then
          begin
            Start := Start + Vec2y;
            InvertStart := not InvertStart;
          end;
        end;

        MaterialLengthAfterFirst := Start - PatternHeight;
        NoInColumn := 1 + ((MaterialLengthAfterFirst div (abs(Vec1y) + abs(Vec2y))) * 2);
        ThisRemainingHeight := MaterialLengthAfterFirst - (((NoInColumn - 1) div 2) * (abs(Vec1y) + abs(Vec2y)));
        if InvertStart and (ThisRemainingHeight > abs(Vec2y)) then
        begin
          inc(NoInColumn);
          ThisRemainingHeight := ThisRemainingHeight - abs(Vec2y);
        end
        else if (not InvertStart) and (ThisRemainingHeight > abs(Vec1y)) then
        begin
          inc(NoInColumn);
          ThisRemainingHeight := ThisRemainingHeight - abs(Vec1y);
        end;
        if ThisRemainingHeight < RemainingHeight then
          RemainingHeight := ThisRemainingHeight;

        TheColumns[ColNo - 1].Start := Start;
        TheColumns[ColNo - 1].No := NoInColumn;
        TheColumns[ColNo - 1].W2Start := InvertStart;
      end;

      //Calculate number of patterns for sheet
      NumberOfPatterns := 0;
      for ColNo := 1 to RowCount do
        NumberOfPatterns := NumberOfPatterns + TheColumns[ColNo - 1].No;
      RemainingArea := UncutArea(UsableMaterialLength, UsableMaterialWidth, RemainingHeight, RemainingWidth);

      if StartingLeft then
      begin
        if RowStart = 1 then
        begin
          LeftRow1StartPropogation.PatternHeight := PatternHeight;
          LeftRow1StartPropogation.PatternWidth := PatternWidth;
          setLength(LeftRow1StartPropogation.AColumns, Length(TheColumns));
          for i := 0 to Length(TheColumns) - 1 do
            LeftRow1StartPropogation.AColumns[i] := TheColumns[i];
          LeftRow1StartPropogation.NumberOfPatterns := NumberOfPatterns;
          LeftRow1StartPropogation.RemainingWidth := RemainingWidth;
          LeftRow1StartPropogation.RemainingHeight := RemainingHeight;
          LeftRow1StartPropogation.RemainingArea := RemainingArea;
          LeftRow1StartPropogation.Vec1y := Vec1y;
          LeftRow1StartPropogation.Vec2y := Vec2y;
          LeftRow1StartPropogation.Vec3x := Vec3x;
          LeftRow1StartPropogation.Vec3y := Vec3y;
        end
        else
        begin
          LeftRow2StartPropogation.PatternHeight := PatternHeight;
          LeftRow2StartPropogation.PatternWidth := PatternWidth;
          setLength(LeftRow2StartPropogation.AColumns, Length(TheColumns));
          for i := 0 to Length(TheColumns) - 1 do
            LeftRow2StartPropogation.AColumns[i] := TheColumns[i];
          LeftRow2StartPropogation.NumberOfPatterns := NumberOfPatterns;
          LeftRow2StartPropogation.RemainingWidth := RemainingWidth;
          LeftRow2StartPropogation.RemainingHeight := RemainingHeight;
          LeftRow2StartPropogation.RemainingArea := RemainingArea;
          LeftRow2StartPropogation.Vec1y := Vec1y;
          LeftRow2StartPropogation.Vec2y := Vec2y;
          LeftRow2StartPropogation.Vec3x := Vec3x;
          LeftRow2StartPropogation.Vec3y := Vec3y;
        end;
      end
      else
      begin
        if RowStart = 1 then
        begin
          RightRow1StartPropogation.PatternHeight := PatternHeight;
          RightRow1StartPropogation.PatternWidth := PatternWidth;
          setLength(RightRow1StartPropogation.AColumns, Length(TheColumns));
          for i := 0 to Length(TheColumns) - 1 do
            RightRow1StartPropogation.AColumns[i] := TheColumns[i];
          RightRow1StartPropogation.NumberOfPatterns := NumberOfPatterns;
          RightRow1StartPropogation.RemainingWidth := RemainingWidth;
          RightRow1StartPropogation.RemainingHeight := RemainingHeight;
          RightRow1StartPropogation.RemainingArea := RemainingArea;
          RightRow1StartPropogation.Vec1y := Vec1y;
          RightRow1StartPropogation.Vec2y := Vec2y;
          RightRow1StartPropogation.Vec3x := Vec3x;
          RightRow1StartPropogation.Vec3y := Vec3y;
        end
        else
        begin
          RightRow2StartPropogation.PatternHeight := PatternHeight;
          RightRow2StartPropogation.PatternWidth := PatternWidth;
          setLength(RightRow2StartPropogation.AColumns, Length(TheColumns));
          for i := 0 to Length(TheColumns) - 1 do
            RightRow2StartPropogation.AColumns[i] := TheColumns[i];
          RightRow2StartPropogation.NumberOfPatterns := NumberOfPatterns;
          RightRow2StartPropogation.RemainingWidth := RemainingWidth;
          RightRow2StartPropogation.RemainingHeight := RemainingHeight;
          RightRow2StartPropogation.RemainingArea := RemainingArea;
          RightRow2StartPropogation.Vec1y := Vec1y;
          RightRow2StartPropogation.Vec2y := Vec2y;
          RightRow2StartPropogation.Vec3x := Vec3x;
          RightRow2StartPropogation.Vec3y := Vec3y;
        end;
      end;
    end;
  end;

  //Decide on best, either starting with Row 1 or Row 2
  if (LeftRow1StartPropogation.NumberOfPatterns >= LeftRow2StartPropogation.NumberOfPatterns) or
     ((LeftRow1StartPropogation.NumberOfPatterns = LeftRow2StartPropogation.NumberOfPatterns) and
     (LeftRow1StartPropogation.RemainingArea > LeftRow2StartPropogation.RemainingArea)) then
    BestLeftPropogation := LeftRow1StartPropogation
  else
    BestLeftPropogation := LeftRow2StartPropogation;

  if (RightRow1StartPropogation.NumberOfPatterns >= RightRow2StartPropogation.NumberOfPatterns) or
     ((RightRow1StartPropogation.NumberOfPatterns = RightRow2StartPropogation.NumberOfPatterns) and
     (RightRow1StartPropogation.RemainingArea > RightRow2StartPropogation.RemainingArea)) then
    BestRightPropogation := RightRow1StartPropogation
  else
    BestRightPropogation := RightRow2StartPropogation;

  //If not FixedStart then StartLeft shows the preference
  if FixedStart or (BestLeftPropogation.NumberOfPatterns = BestRightPropogation.NumberOfPatterns) then
  begin
    if StartLeft then
      BestPropogation := BestLeftPropogation
    else
      BestPropogation := BestRightPropogation;

    StartingLeft := StartLeft;
  end
  else if (BestLeftPropogation.NumberOfPatterns > BestRightPropogation.NumberOfPatterns) then
  begin
    BestPropogation := BestLeftPropogation;
    StartingLeft := True;
  end
  else if (BestRightPropogation.NumberOfPatterns > BestLeftPropogation.NumberOfPatterns) then
  begin
    BestPropogation := BestRightPropogation;
    StartingLeft := False;
  end;

  ResultsVerticalP2InvertedDiagonal(BestPropogation, UsableMaterialLength, UsableMaterialWidth, StartingLeft);

  //Results
  NumberOfPatterns := BestPropogation.NumberOfPatterns;
  RemainingHeight := BestPropogation.RemainingHeight;
  RemainingWidth := BestPropogation.RemainingWidth;
  RemainingArea := BestPropogation.RemainingArea;

{$IFDEF DEBUG}
  Prop:= GetTickCount - Prop;
  TotalProp := TotalProp + Prop;
{$ENDIF}
end;

procedure PropogateFreeDiagonal(UsableMaterialLength, UsableMaterialWidth,
                                PatternHeight, PatternWidth: integer;
                                FixedStart, StartLeft, W2, FirstCutInCorner: boolean;
                                LocalInterlock: TLocalInterlock; PackAngle: real;
                                var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                                var RemainingArea: real; var StartingLeft: Boolean);
var
  ColumnStart, i, j, ColNo, RowCount, MaterialLengthAfterFirst, MaterialWidthAfterFirst,
  Vec1x, Vec1y, Vec3x, Vec3y, Vec4x, Vec4y: integer;
  TheColumns: array of TLineDetailsFreeDiagonal;
  Loops, Startx, Starty: integer;
  Col1StartPropogation, Col2StartPropogation, LeftCol1StartPropogation, LeftCol2StartPropogation, RightCol1StartPropogation, RightCol2StartPropogation,
  BestLeftPropogation, BestRightPropogation, BestPropogation: TFDPropogation;
  ExtraHalfTop, ExtraHalfPattern1Fits, ExtraHalfPattern2Fits: Boolean;
  SpaceForExtraHalf: integer;
  RowsToCount: integer;
  KeepResults: Boolean;
  ColsSoFar: integer;
  BackFilled: Boolean;
  PatternsInColumn: integer;
  FirstBackFillColNo: integer;
  PackLeansRight: Boolean;
  LeftHandEdge, RightHandEdge: integer;
  XOffset, YOffset, PossibleStartx, PossibleStarty: integer;
  P1_PossibleStartx, P1_PossibleStarty: integer;
  P2_PossibleStartx, P2_PossibleStarty: integer;
  FinishedSingles: Boolean;
  NoSingles: integer;
  HalfPatternThatFits, LastHalfPatternThatFits: integer;
  HalfPattern1Fits, HalfPattern2Fits: Boolean;
  WithinMinimumNoOfColumns, OneExtraColumnAdded: Boolean;
  NoInColumn: integer;
  Patternsx, Patternsy: integer;
  Right1, Right2, Top1, Top2, Left1, Left2: integer;
  ColumnStarts: integer;

begin
{$IFDEF DEBUG}
  Prop:= GetTickCount;
{$ENDIF}

  //Pre Results
  FillPropogationInput(PROPOGATION_FREEDIAGONAL, UsableMaterialLength,
                       UsableMaterialWidth, PatternHeight, PatternWidth, FALSE,
                       FixedStart, StartLeft, W2, FirstCutInCorner, FALSE,
                       FALSE, LocalInterlock, PackAngle);

  //See which way pack leans
  Vec1x := CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left;
  PackLeansRight := (Vec1x > 0);

  LeftCol1StartPropogation.NumberOfPatterns := 0;
  LeftCol2StartPropogation.NumberOfPatterns := 0;
  RightCol1StartPropogation.NumberOfPatterns := 0;
  RightCol2StartPropogation.NumberOfPatterns := 0;

  if FixedStart then
    Loops := 1
  else
    Loops := 2;

  StartingLeft := True;
  for j := 1 to Loops do
  begin
    if FixedStart then
      StartingLeft := StartLeft
    else
      StartingLeft := not StartingLeft;

    ColumnStarts := 2;
    if LocalInterlock.Used and (not FirstCutInCorner) and
       ((StartingLeft and (not LocalInterlock.BottomIsLeft)) or
        ((not StartingLeft) and LocalInterlock.BottomIsLeft)) then
      Columnstarts := 3;

    //For Ganged patterns, ColumnStart 1 = W1 Pattern, ColumnStart 2 = W2 Pattern
    for ColumnStart := 1 to ColumnStarts do
    begin
      //Calculate required vectors
      //Assumes 4, 0, 12, 8
      Vec1x := CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left;
      Vec1y := abs(CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top);

      if (ColumnStart = 1) or LocalInterlock.Used or (ColumnStart = 3) then
      begin
        Vec3x := CutResults[12].BoundingRect.Left - CutResults[0].BoundingRect.Left;
        Vec3y := CutResults[12].BoundingRect.Top - CutResults[0].BoundingRect.Top;
        Vec4x := CutResults[8].BoundingRect.Left - CutResults[12].BoundingRect.Left;
        Vec4y := CutResults[8].BoundingRect.Top - CutResults[12].BoundingRect.Top;
      end
      else
      begin
        Vec3x := CutResults[8].BoundingRect.Left - CutResults[12].BoundingRect.Left;
        Vec3y := CutResults[8].BoundingRect.Top - CutResults[12].BoundingRect.Top;
        Vec4x := CutResults[12].BoundingRect.Left - CutResults[0].BoundingRect.Left;
        Vec4y := CutResults[12].BoundingRect.Top - CutResults[0].BoundingRect.Top;
      end;

      if StartingLeft then
      begin
        LeftHandEdge := -Vec1x;
        RightHandEdge := UsableMaterialWidth - Vec1x;
      end
      else
      begin
        LeftHandEdge := 0;
        RightHandEdge := UsableMaterialWidth;
      end;

      //Offsets to get correct pattern in the corner
      XOffset := 0;
      YOffset := 0;
      if LocalInterlock.Used then
      begin
        if StartingLeft then
        begin
          if ColumnStart = 1 then
          begin
            if LocalInterlock.Vec1y > 0 then
              yOffset := LocalInterlock.Vec1y;
            if LocalInterlock.Vec1x < 0 then
              XOffset := LocalInterlock.Vec1x;
          end
          else if ColumnStart = 2 then
          begin
            if LocalInterlock.Vec1y < 0 then
              yOffset := -LocalInterlock.Vec1y;
            if LocalInterlock.Vec1x > 0 then
              XOffset := -LocalInterlock.Vec1x;
          end
          else
          begin
            yOffset := 0;
            xOffset := 0;
          end;
        end
        else
        begin
          //Starting Right
          if ColumnStart = 1 then
          begin
            if LocalInterlock.Vec1y > 0 then
              yOffset := LocalInterlock.Vec1y;
            if LocalInterlock.Vec1x > 0 then
              XOffset := LocalInterlock.Vec1x;
          end
          else if ColumnStart = 2 then
          begin
            if LocalInterlock.Vec1y < 0 then
              yOffset := -LocalInterlock.Vec1y;
            if LocalInterlock.Vec1x < 0 then
              XOffset := -LocalInterlock.Vec1x;
          end
          else
          begin
            yOffset := 0;
            xOffset := 0;
          end;
        end;
      end;

      //Calculate Number of Columns
      MaterialWidthAfterFirst := UsableMaterialWidth - PatternWidth;

      //Calculate Start Position for each Column and Number in that column
      //Also 1 extra column in case 'Extra half column' used
      ColNo := 0;

      //Calculate 1st Column and all the Columns to the right of it (Starting Left)
      //or to the left of it (Starting Right). For Packs leaning right and
      //Starting Right (or leaning left and starting left), just calculate 1st
      //piece in bottom right (or left) hand corner.
      if (StartingLeft and PackLeansRight) or
         ((not StartingLeft) and (not PackLeansRight)) then
      begin
        OneExtraColumnAdded := False;
        while ((not LocalInterlock.Used) and (MaterialWidthAfterFirst >= 0)) or
               (LocalInterlock.Used and (not OneExtraColumnAdded)) do
        begin
          inc(ColNo);
          RowCount := ColNo;

          //Denote that this time its the one extra column
          if MaterialWidthAfterFirst < 0 then
            OneExtraColumnAdded := True;

          if PackLeansRight then
          begin
            Starty := YOffset + UsableMaterialLength + ((ColNo - 1) div 2) * (Vec3y + Vec4y);
            if (ColNo mod 2) = 0 then
              Starty := Starty + Vec3y;
            Startx := XOffset + ((Vec3x + Vec4x) * ((ColNo - 1) div 2)) - Vec1x;
            if (ColNo mod 2) = 0 then
              Startx := Startx + Vec3x;
          end
          else
          begin
            Starty := YOffset + UsableMaterialLength - ((ColNo - 1) div 2) * (Vec3y + Vec4y);
            if (ColNo mod 2) = 0 then
              Starty := Starty - Vec4y;
            Startx := XOffset + UsableMaterialWidth - PatternWidth - ((Vec3x + Vec4x) * ((ColNo - 1) div 2));
            if (ColNo mod 2) = 0 then
              Startx := Startx - Vec4x;
          end;

          if PackLeansRight then
          begin
            //Push/Pull Columns into Start Position
            while (Starty > UsableMaterialLength) or ((Startx + Vec1x) < 0) do
            begin
              Startx := Startx + Vec1x;
              Starty := Starty - Vec1y;
            end;
            while (Starty < UsableMaterialLength - Vec1y) and ((Startx - Vec1x) >= LeftHandEdge) do
            begin
              Startx := Startx - Vec1x;
              Starty := Starty + Vec1y;
            end;
          end
          else
          begin
            //Push/Pull Columns into Start Position
            while (Starty > UsableMaterialLength) or ((Startx + PatternWidth) > UsableMaterialWidth) do
            begin
              Startx := Startx + Vec1x;
              Starty := Starty - Vec1y;
            end;
            while (Starty < UsableMaterialLength - Vec1y) and ((Startx + PatternWidth - Vec1x) <= RightHandEdge) do
            begin
              Startx := Startx - Vec1x;
              Starty := Starty + Vec1y;
            end;
          end;

          MaterialLengthAfterFirst := Starty - PatternHeight;
          if PackLeansRight then
          begin
            MaterialWidthAfterFirst := UsableMaterialWidth - Startx - PatternWidth;
            if StartingLeft then
              MaterialWidthAfterFirst := MaterialWidthAfterFirst - Vec1x;
          end
          else
            MaterialWidthAfterFirst := Startx;

          if (MaterialWidthAfterFirst >= 0) or OneExtraColumnAdded then
          begin
            setLength(TheColumns, ColNo);
            if OneExtraColumnAdded then
              TheColumns[ColNo - 1].No := 0
            else
            begin
              if abs(Vec1x) <> 0 then
                Patternsx := MaterialWidthAfterFirst div abs(Vec1x)
              else
                Patternsx := 99999999;
              if Vec1y <> 0 then
                Patternsy := MaterialLengthAfterFirst div Vec1y
              else
                Patternsy := 99999999;

              //Check actually some in the column
              if (Starty - PatternHeight) < 0 then
                TheColumns[ColNo - 1].No := 0
              else
                TheColumns[ColNo - 1].No := 1 + min(Patternsx, Patternsy);
            end;

            if LocalInterlock.Used then
            begin
              //Ensure start lies between left and right edges when no 'pairs' fit,
              //basically anywhere where at least one of the half patterns will fit.
              //This is to ensure a valid starting point when looking for the 'half' patterns.
              if TheColumns[ColNo - 1].No = 0 then
              begin
                if PackLeansRight then
                begin
                  while (Startx + PatternWidth > RightHandEdge) and
                        (SinglePatternThatFits(Startx, Starty, LeftHandEdge, RightHandEdge, UsableMaterialLength, LocalInterlock) = 0) do
                  begin
                    Startx := Startx - Vec1x;
                    Starty := Starty + Vec1y;
                  end;
                  while (Startx < LeftHandEdge) and
                        (SinglePatternThatFits(Startx, Starty, LeftHandEdge, RightHandEdge, UsableMaterialLength, LocalInterlock) = 0) do
                  begin
                    Startx := Startx + Vec1x;
                    Starty := Starty - Vec1y;
                  end;
                end
                else
                begin
                  while (Startx + PatternWidth > RightHandEdge) and
                        (SinglePatternThatFits(Startx, Starty, LeftHandEdge, RightHandEdge, UsableMaterialLength, LocalInterlock) = 0) do
                  begin
                    Startx := Startx + Vec1x;
                    Starty := Starty - Vec1y;
                  end;

                  while (Startx < LeftHandEdge) and
                        (SinglePatternThatFits(Startx, Starty, LeftHandEdge, RightHandEdge, UsableMaterialLength, LocalInterlock) = 0) do
                  begin
                    Startx := Startx - Vec1x;
                    Starty := Starty + Vec1y;
                  end;
                end;
              end;
            end;

            TheColumns[ColNo - 1].Startx := Startx;
            TheColumns[ColNo - 1].Starty := Starty;
          end
          else
            dec(ColNo);
        end;
      end
      else
      begin
        inc(ColNo);
        RowCount := ColNo;
        setLength(TheColumns, ColNo);

        if PackLeansRight then
          TheColumns[ColNo - 1].Startx := XOffset + UsableMaterialWidth - PatternWidth
        else
          TheColumns[ColNo - 1].Startx := XOffset - Vec1x;

        TheColumns[ColNo - 1].Starty := YOffset + UsableMaterialLength;
        TheColumns[ColNo - 1].No := 1;
        TheColumns[ColNo - 1].ExtraHalfTopNo := 0;
        TheColumns[ColNo - 1].ExtraHalfBottomNo := 0;

        //Check both patterns fit
        if LocalInterlock.Used then
        begin
          //Possible Start of next PAIR
          PossibleStartx := TheColumns[ColNo - 1].Startx;
          PossibleStarty := TheColumns[ColNo - 1].Starty;

          //Possible Start of next SINGLE Patterns
          P1_PossibleStartx := PossibleStartx + LocalInterlock.Pat1.Left;
          P1_PossibleStarty := PossibleStarty - (LocalInterlock.PairedPatternHeight - LocalInterlock.Pat1.Bottom);
          P2_PossibleStartx := PossibleStartx + LocalInterlock.Pat2.Left;
          P2_PossibleStarty := PossibleStarty - (LocalInterlock.PairedPatternHeight - LocalInterlock.Pat2.Bottom);

          //See if either or both of singles fit
          HalfPattern1Fits := False;
          HalfPattern2Fits := False;
          if (P1_PossibleStartx >= LeftHandEdge) and
             (P1_PossibleStartx <= (RightHandEdge - LocalInterlock.SinglePatternWidth)) and
             (P1_PossibleStarty >= LocalInterlock.SinglePatternHeight) and
             (P1_PossibleStarty <= UsableMaterialLength) then
            HalfPattern1Fits := True;
          if (P2_PossibleStartx >= LeftHandEdge) and
             (P2_PossibleStartx <= (RightHandEdge - LocalInterlock.SinglePatternWidth)) and
             (P2_PossibleStarty >= LocalInterlock.SinglePatternHeight) and
             (P2_PossibleStarty <= UsableMaterialLength) then
            HalfPattern2Fits := True;

          if (not HalfPattern1Fits) or (not HalfPattern2Fits) then
            TheColumns[ColNo - 1].No := 0;
        end;
      end;

      //BackFill all the Columns from the 1st column
      FirstBackFillColNo := ColNo + 1;
      ColsSoFar := ColNo;
      RowCount := ColNo;
      ColNo := 0;
      BackFilled := False;
      OneExtraColumnAdded := False;
      while ((not LocalInterlock.Used) and (not BackFilled)) or
             (LocalInterlock.Used and (not OneExtraColumnAdded)) do
      begin
        dec(ColNo);

        //Check a minimum number of columns(4) in case there are several columns
        //at the start where the pairs of patterns won't fit but the singles do
        WithinMinimumNoOfColumns := ((ColsSoFar + abs(ColNo)) < 4);

        if BackFilled and (not WithinMinimumNoOfColumns) then
          OneExtraColumnAdded := True;

        if PackLeansRight then
        begin
          Starty := yOffset + UsableMaterialLength + ((ColNo - 1) div 2) * (Vec3y + Vec4y);
          if (abs(ColNo) mod 2) = 1 then
            Starty := Starty + Vec3y;

          if StartingLeft then
            Startx := 0
          else
            Startx := UsableMaterialWidth - PatternWidth + Vec1x;
          Startx := xOffset + Startx + ((Vec3x + Vec4x) * ((ColNo - 1) div 2)) - Vec1x;
          if (abs(ColNo) mod 2) = 1 then
            Startx := Startx + Vec3x;
        end
        else
        begin
          Starty := yOffset + UsableMaterialLength - ((ColNo - 1) div 2) * (Vec3y + Vec4y);
          if (abs(ColNo) mod 2) = 1 then
            Starty := Starty - Vec4y;

          if StartingLeft then
            Startx := - Vec1x
          else
            Startx := UsableMaterialWidth - PatternWidth;
          Startx := xOffset + Startx - ((Vec3x + Vec4x) * ((ColNo - 1) div 2));
          if (abs(ColNo) mod 2) = 1 then
            Startx := Startx - Vec4x;
        end;

        //Push/Pull Columns into Start Position
        while Starty > UsableMaterialLength do
        begin
          Startx := Startx + Vec1x;
          Starty := Starty - Vec1y;
        end;
        while Starty <= UsableMaterialLength - Vec1y do
        begin
          Startx := Startx - Vec1x;
          Starty := Starty + Vec1y;
        end;

        if PackLeansRight then
        begin
          //Remove those off left hand edge
          while Startx < LeftHandEdge do
          begin
            Startx := Startx + Vec1x;
            Starty := Starty - Vec1y;
          end;
        end
        else
        begin
          //Remove those off right hand edge
          while (Startx + PatternWidth) > RightHandEdge do
          begin
            Startx := Startx + Vec1x;
            Starty := Starty - Vec1y;
          end;
        end;

        MaterialLengthAfterFirst := Starty - PatternHeight;
        if PackLeansRight then
        begin
          MaterialWidthAfterFirst := UsableMaterialWidth - Startx - PatternWidth;
          if StartingLeft then
            MaterialWidthAfterFirst := MaterialWidthAfterFirst - Vec1x;
        end
        else
        begin
          MaterialWidthAfterFirst := Startx;
          if StartingLeft then
            MaterialWidthAfterFirst := MaterialWidthAfterFirst + Vec1x;
        end;

        if (MaterialLengthAfterFirst < 0) or (MaterialWidthAfterFirst < 0) or OneExtraColumnAdded then
          PatternsInColumn := 0
        else
        begin
          if abs(Vec1x) <> 0 then
            Patternsx := MaterialWidthAfterFirst div abs(Vec1x)
          else
            Patternsx := 99999999;
          if Vec1y <> 0 then
            Patternsy := MaterialLengthAfterFirst div Vec1y
          else
            Patternsy := 99999999;
          PatternsInColumn := 1 + min(Patternsx, Patternsy);
        end;

        if (PatternsInColumn > 0) or WithinMinimumNoOfColumns or OneExtraColumnAdded then
        begin
          RowCount := ColsSoFar + abs(ColNo);

          setLength(TheColumns, ColsSoFar + abs(ColNo));
          TheColumns[ColsSoFar + abs(ColNo) - 1].No := PatternsInColumn;

          //Ensure start lies between left and right edges when no 'pairs' fit,
          //basically anywhere where at least one of the half patterns will fit.
          //This is to ensure a valid starting point when looking for the 'half' patterns.
          if TheColumns[ColsSoFar + abs(ColNo) - 1].No = 0 then
          begin
            if PackLeansRight then
            begin
              while (Startx + PatternWidth > RightHandEdge) and
                    (SinglePatternThatFits(Startx, Starty, LeftHandEdge, RightHandEdge, UsableMaterialLength, LocalInterlock) = 0) do
              begin
                Startx := Startx - Vec1x;
                Starty := Starty + Vec1y;
              end;
              while (Startx < LeftHandEdge) and
                    (SinglePatternThatFits(Startx, Starty, LeftHandEdge, RightHandEdge, UsableMaterialLength, LocalInterlock) = 0) do
              begin
                Startx := Startx + Vec1x;
                Starty := Starty - Vec1y;
              end;
            end
            else
            begin
              while (Startx + PatternWidth > RightHandEdge) and
                    (SinglePatternThatFits(Startx, Starty, LeftHandEdge, RightHandEdge, UsableMaterialLength, LocalInterlock) = 0) do
              begin
                Startx := Startx + Vec1x;
                Starty := Starty - Vec1y;
              end;

              while (Startx < LeftHandEdge) and
                    (SinglePatternThatFits(Startx, Starty, LeftHandEdge, RightHandEdge, UsableMaterialLength, LocalInterlock) = 0) do
              begin
                Startx := Startx - Vec1x;
                Starty := Starty + Vec1y;
              end;
            end;
          end;

          TheColumns[ColsSoFar + abs(ColNo) - 1].Startx := Startx;
          TheColumns[ColsSoFar + abs(ColNo) - 1].Starty := Starty;
        end
        else
        begin
          inc(ColNo);
          BackFilled := True;
        end;
      end;

      //Extra Half Patterns
      for ColNo := 1 to Length(TheColumns) do
      begin
        //Decide on extra 'half' pattern at right/top
        TheColumns[ColNo - 1].ExtraHalfTopNo := 0;
        if LocalInterlock.Used then
        begin
          NoSingles := 0;
          FinishedSingles := False;

          while not FinishedSingles do
          begin
            //Possible Start of next PAIR
            PossibleStartx := TheColumns[ColNo - 1].Startx + ((TheColumns[ColNo - 1].No - 1 + NoSingles + 1) * Vec1x);
            PossibleStarty := TheColumns[ColNo - 1].Starty - ((TheColumns[ColNo - 1].No - 1 + NoSingles + 1) * Vec1y);

            HalfPatternThatFits := SinglePatternThatFits(PossibleStartx, PossibleStarty, LeftHandEdge, RightHandEdge, UsableMaterialLength, LocalInterlock);
            if HalfPatternThatFits > 0 then
            begin
              //Ensure that the extra halves are all the same 'side' (left or right).
              //If not and it is the first and second that are not the same, move
              //starting position up a level so that we can look in the other direction
              //to find the other 'side'.
              if (NoSingles = 1) and (HalfPatternThatFits <> LastHalfPatternThatFits) then
              begin
                NoSingles := 0;
                TheColumns[ColNo - 1].Startx := PossibleStartx;
                TheColumns[ColNo - 1].Starty := PossibleStarty;
              end;

              inc(NoSingles);
              TheColumns[ColNo - 1].ExtraHalfTopNo := NoSingles;
              if LocalInterlock.LeftPat = HalfPatternThatFits then
                TheColumns[ColNo - 1].ExtraHalfTopType := KLEFT
              else
                TheColumns[ColNo - 1].ExtraHalfTopType := KRIGHT;

              LastHalfPatternThatFits := HalfPatternThatFits;
            end
            else
              FinishedSingles := True;
          end;
        end;

        //Decide on extra 'half' pattern at left/bottom
        TheColumns[ColNo - 1].ExtraHalfBottomNo := 0;
        if LocalInterlock.Used then
        begin
          NoSingles := 0;
          FinishedSingles := False;

          while not FinishedSingles do
          begin
            //Possible Start of next PAIR
            PossibleStartx := TheColumns[ColNo - 1].Startx - ((NoSingles + 1) * Vec1x);
            PossibleStarty := TheColumns[ColNo - 1].Starty + ((NoSingles + 1) * Vec1y);

            HalfPatternThatFits := SinglePatternThatFits(PossibleStartx, PossibleStarty, LeftHandEdge, RightHandEdge, UsableMaterialLength, LocalInterlock);
            if HalfPatternThatFits > 0 then
            begin
              inc(NoSingles);
              TheColumns[ColNo - 1].ExtraHalfBottomNo := NoSingles;
              if LocalInterlock.LeftPat = HalfPatternThatFits then
                TheColumns[ColNo - 1].ExtraHalfBottomType := KLEFT
              else
                TheColumns[ColNo - 1].ExtraHalfBottomType := KRIGHT;
            end
            else
              FinishedSingles := True;
          end;
        end;
      end;

      //Calculate number of patterns for sheet
      RowsToCount := RowCount;
      NumberOfPatterns := 0;
      for ColNo := 1 to RowsToCount do
      begin
        if LocalInterlock.Used then
        begin
          if ColNo > RowCount then
            NumberOfPatterns := NumberOfPatterns + TheColumns[ColNo - 1].No
          else
            NumberOfPatterns := NumberOfPatterns + (TheColumns[ColNo - 1].No * 2);
          NumberOfPatterns := NumberOfPatterns + TheColumns[ColNo - 1].ExtraHalfTopNo + TheColumns[ColNo - 1].ExtraHalfBottomNo;
        end
        else
          NumberOfPatterns := NumberOfPatterns + TheColumns[ColNo - 1].No;
      end;

      //Calculate Remaining Height
      RemainingHeight := UsableMaterialLength;
      for ColNo := 1 to RowsToCount do
      begin
        Top1 := 9999;
        Top2 := 9999;

        if TheColumns[ColNo - 1].No > 0 then
        begin
          Starty := TheColumns[ColNo - 1].Starty - ((TheColumns[ColNo - 1].No - 1) * Vec1y);
          Top1 := Starty - PatternHeight;
        end;
        if TheColumns[ColNo - 1].ExtraHalfTopNo > 0 then
        begin
          Starty := TheColumns[ColNo - 1].Starty;
          if TheColumns[ColNo - 1].No > 0 then
            Starty := Starty - ((TheColumns[ColNo - 1].No - 1) * Vec1y)
          else
            Starty := Starty + Vec1y;
          Starty := Starty - (TheColumns[ColNo - 1].ExtraHalfTopNo * Vec1y);

          Top2 := Starty - LocalInterlock.SinglePatternHeight;
        end;

        if min(Top1, Top2) < RemainingHeight then
          RemainingHeight := min(Top1, Top2) - 1;
      end;

      //Calculate Remaining Width
      if StartingLeft then
      begin
        //Starting Left
        RemainingWidth := 0;

        for ColNo := 1 to RowsToCount do
        begin
          Right1 := 0;
          Right2 := 0;

          if TheColumns[ColNo - 1].No > 0 then
          begin
            if PackLeansRight then
              Startx := TheColumns[ColNo - 1].Startx + ((TheColumns[ColNo - 1].No) * abs(Vec1x))
            else
              Startx := TheColumns[ColNo - 1].Startx - abs(Vec1x);
            Right1 := Startx + PatternWidth;
          end;
          if PackLeansRight then
          begin
            if TheColumns[ColNo - 1].ExtraHalfTopNo > 0 then
            begin
              Startx := TheColumns[ColNo - 1].Startx;
              if TheColumns[ColNo - 1].No > 0 then
                Startx := Startx + (TheColumns[ColNo - 1].No * abs(Vec1x))
              else
                Startx := Startx - abs(Vec1x);
              Startx := Startx + (TheColumns[ColNo - 1].ExtraHalfTopNo * abs(Vec1x));

              Right2 := Startx + LocalInterlock.SinglePatternWidth;
            end;
          end
          else
          begin
            if TheColumns[ColNo - 1].ExtraHalfBottomNo > 0 then
            begin
              Startx := TheColumns[ColNo - 1].Startx - abs(Vec1x);
              Startx := Startx + (TheColumns[ColNo - 1].ExtraHalfBottomNo * abs(Vec1x));

              Right2 := Startx + LocalInterlock.SinglePatternWidth;
            end;
          end;

          if max(Right1, Right2) > RemainingWidth then
            RemainingWidth := max(Right1, Right2);
        end;

        RemainingWidth := UsableMaterialWidth - RemainingWidth - 1;
      end
      else
      begin
        //Starting Right
        RemainingWidth := UsableMaterialWidth;

        for ColNo := 1 to RowsToCount do
        begin
          Left1 := 9999;
          Left2 := 9999;

          if TheColumns[ColNo - 1].No > 0 then
          begin
            if PackLeansRight then
              Startx := TheColumns[ColNo - 1].Startx
            else
              Startx := TheColumns[ColNo - 1].Startx - ((TheColumns[ColNo - 1].No) * abs(Vec1x)) + abs(Vec1x);
            Left1 := Startx;
          end;
          if PackLeansRight then
          begin
            if (TheColumns[ColNo - 1].ExtraHalfBottomNo > 0) then
            begin
              Startx := TheColumns[ColNo - 1].Startx;
              Startx := Startx - ((TheColumns[ColNo - 1].ExtraHalfBottomNo - 1) * abs(Vec1x));

              Left2 := Startx - abs(Vec1x) + PatternWidth - LocalInterlock.SinglePatternWidth;
            end;
          end
          else
          begin
            if (TheColumns[ColNo - 1].ExtraHalfTopNo > 0) then
            begin
              Startx := TheColumns[ColNo - 1].Startx - ((TheColumns[ColNo - 1].No) * abs(Vec1x)) + abs(Vec1x);
              Startx := Startx - ((TheColumns[ColNo - 1].ExtraHalfTopNo - 1) * abs(Vec1x));

              Left2 := Startx - abs(Vec1x) + PatternWidth - LocalInterlock.SinglePatternWidth;
            end;
          end;

          if min(Left1, Left2) < RemainingWidth then
            RemainingWidth := min(Left1, Left2);
        end;
      end;

      //Calculate Remaining Area
      RemainingArea := UncutArea(UsableMaterialLength, UsableMaterialWidth, RemainingHeight, RemainingWidth);

      //Save plan
      KeepResults := False;
      if StartingLeft then
      begin
        if ColumnStart = 1 then
        begin
          if (NumberOfPatterns > LeftCol1StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = LeftCol1StartPropogation.NumberOfPatterns) and
              (RemainingArea > LeftCol1StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            LeftCol1StartPropogation.PatternHeight := PatternHeight;
            LeftCol1StartPropogation.PatternWidth := PatternWidth;
            LeftCol1StartPropogation.SecondColumnFirst := False;
            setLength(LeftCol1StartPropogation.AColumns, Length(TheColumns));
            for i := 0 to Length(TheColumns) - 1 do
              LeftCol1StartPropogation.AColumns[i] := TheColumns[i];
            LeftCol1StartPropogation.NumberOfPatterns := NumberOfPatterns;
            LeftCol1StartPropogation.RemainingWidth := RemainingWidth;
            LeftCol1StartPropogation.RemainingHeight := RemainingHeight;
            LeftCol1StartPropogation.RemainingArea := RemainingArea;
            LeftCol1StartPropogation.Vec1x := Vec1x;
            LeftCol1StartPropogation.Vec1y := Vec1y;
            LeftCol1StartPropogation.Vec3x := Vec3x;
            LeftCol1StartPropogation.Vec3y := Vec3y;
            LeftCol1StartPropogation.Vec4x := Vec4x;
            LeftCol1StartPropogation.Vec4y := Vec4y;
            LeftCol1StartPropogation.LocalInterlock := LocalInterlock;
            LeftCol1StartPropogation.FirstBackFillColumnNo := FirstBackFillColNo;
          end
        end
        else
        begin
          if (NumberOfPatterns > LeftCol2StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = LeftCol2StartPropogation.NumberOfPatterns) and
              (RemainingArea > LeftCol2StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            LeftCol2StartPropogation.PatternHeight := PatternHeight;
            LeftCol2StartPropogation.PatternWidth := PatternWidth;
            LeftCol2StartPropogation.SecondColumnFirst := True;
            setLength(LeftCol2StartPropogation.AColumns, Length(TheColumns));
            for i := 0 to Length(TheColumns) - 1 do
              LeftCol2StartPropogation.AColumns[i] := TheColumns[i];
            LeftCol2StartPropogation.NumberOfPatterns := NumberOfPatterns;
            LeftCol2StartPropogation.RemainingWidth := RemainingWidth;
            LeftCol2StartPropogation.RemainingHeight := RemainingHeight;
            LeftCol2StartPropogation.RemainingArea := RemainingArea;
            LeftCol2StartPropogation.Vec1x := Vec1x;
            LeftCol2StartPropogation.Vec1y := Vec1y;
            LeftCol2StartPropogation.Vec3x := Vec3x;
            LeftCol2StartPropogation.Vec3y := Vec3y;
            LeftCol2StartPropogation.Vec4x := Vec4x;
            LeftCol2StartPropogation.Vec4y := Vec4y;
            LeftCol2StartPropogation.LocalInterlock := LocalInterlock;
            LeftCol2StartPropogation.FirstBackFillColumnNo := FirstBackFillColNo;
          end;
        end
      end
      else
      begin
        if ColumnStart = 1 then
        begin
          if (NumberOfPatterns > RightCol1StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = RightCol1StartPropogation.NumberOfPatterns) and
              (RemainingArea > RightCol1StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            RightCol1StartPropogation.PatternHeight := PatternHeight;
            RightCol1StartPropogation.PatternWidth := PatternWidth;
            RightCol1StartPropogation.SecondColumnFirst := False;
            setLength(RightCol1StartPropogation.AColumns, Length(TheColumns));
            for i := 0 to Length(TheColumns) - 1 do
              RightCol1StartPropogation.AColumns[i] := TheColumns[i];
            RightCol1StartPropogation.NumberOfPatterns := NumberOfPatterns;
            RightCol1StartPropogation.RemainingWidth := RemainingWidth;
            RightCol1StartPropogation.RemainingHeight := RemainingHeight;
            RightCol1StartPropogation.RemainingArea := RemainingArea;
            RightCol1StartPropogation.Vec1x := Vec1x;
            RightCol1StartPropogation.Vec1y := Vec1y;
            RightCol1StartPropogation.Vec3x := Vec3x;
            RightCol1StartPropogation.Vec3y := Vec3y;
            RightCol1StartPropogation.Vec4x := Vec4x;
            RightCol1StartPropogation.Vec4y := Vec4y;
            RightCol1StartPropogation.LocalInterlock := LocalInterlock;
            RightCol1StartPropogation.FirstBackFillColumnNo := FirstBackFillColNo;
          end;
        end
        else
        begin
          if (NumberOfPatterns > RightCol2StartPropogation.NumberOfPatterns) or
             ((NumberOfPatterns = RightCol2StartPropogation.NumberOfPatterns) and
              (RemainingArea > RightCol2StartPropogation.RemainingArea)) then
            KeepResults := True;

          if KeepResults then
          begin
            RightCol2StartPropogation.PatternHeight := PatternHeight;
            RightCol2StartPropogation.PatternWidth := PatternWidth;
            RightCol2StartPropogation.SecondColumnFirst := True;
            setLength(RightCol2StartPropogation.AColumns, Length(TheColumns));
            for i := 0 to Length(TheColumns) - 1 do
              RightCol2StartPropogation.AColumns[i] := TheColumns[i];
            RightCol2StartPropogation.NumberOfPatterns := NumberOfPatterns;
            RightCol2StartPropogation.RemainingWidth := RemainingWidth;
            RightCol2StartPropogation.RemainingHeight := RemainingHeight;
            RightCol2StartPropogation.RemainingArea := RemainingArea;
            RightCol2StartPropogation.Vec1x := Vec1x;
            RightCol2StartPropogation.Vec1y := Vec1y;
            RightCol2StartPropogation.Vec3x := Vec3x;
            RightCol2StartPropogation.Vec3y := Vec3y;
            RightCol2StartPropogation.Vec4x := Vec4x;
            RightCol2StartPropogation.Vec4y := Vec4y;
            RightCol2StartPropogation.LocalInterlock := LocalInterlock;
            RightCol2StartPropogation.FirstBackFillColumnNo := FirstBackFillColNo;
          end;
        end;
      end;
    end;
  end;

  //Decide on best, either starting with column 1 or column 2/start from left or start from right
  if (LeftCol1StartPropogation.NumberOfPatterns >= LeftCol2StartPropogation.NumberOfPatterns) or
     ((LeftCol1StartPropogation.NumberOfPatterns = LeftCol2StartPropogation.NumberOfPatterns) and (LeftCol1StartPropogation.RemainingArea > LeftCol2StartPropogation.RemainingArea)) then
    BestLeftPropogation := LeftCol1StartPropogation
  else
    BestLeftPropogation := LeftCol2StartPropogation;

  if (RightCol1StartPropogation.NumberOfPatterns >= RightCol2StartPropogation.NumberOfPatterns) or
     ((RightCol1StartPropogation.NumberOfPatterns = RightCol2StartPropogation.NumberOfPatterns) and (RightCol1StartPropogation.RemainingArea > RightCol2StartPropogation.RemainingArea)) then
    BestRightPropogation := RightCol1StartPropogation
  else
    BestRightPropogation := RightCol2StartPropogation;

  //If not FixedStart then StartLeft shows the preference
  if FixedStart or (BestLeftPropogation.NumberOfPatterns = BestRightPropogation.NumberOfPatterns) then
  begin
    if StartLeft then
      BestPropogation := BestLeftPropogation
    else
      BestPropogation := BestRightPropogation;

    StartingLeft := StartLeft;
  end
  else if (BestLeftPropogation.NumberOfPatterns > BestRightPropogation.NumberOfPatterns) then
  begin
    BestPropogation := BestLeftPropogation;
    StartingLeft := True;
  end
  else if (BestRightPropogation.NumberOfPatterns > BestLeftPropogation.NumberOfPatterns) then
  begin
    BestPropogation := BestRightPropogation;
    StartingLeft := False;
  end;

  ResultsFreeDiagonal(BestPropogation, UsableMaterialLength, UsableMaterialWidth, StartingLeft, W2);

  //Results
  NumberOfPatterns := BestPropogation.NumberOfPatterns;
  RemainingHeight := BestPropogation.RemainingHeight;
  RemainingWidth := BestPropogation.RemainingWidth;
  RemainingArea := BestPropogation.RemainingArea;

{$IFDEF DEBUG}
  Prop:= GetTickCount - Prop;
  TotalProp := TotalProp + Prop;
{$ENDIF}
end;

procedure InitialisePackResult(var PackResult: TCompleteCutResult);
begin
  PackResult.Calculated := False;
  SetLength(PackResult.Knife.PatternPoints, 0);
  SetLength(PackResult.Knife.ExpandedPoints, 0);
  SetLength(PackResult.Knife.ConvexHull, 0);
  SetLength(PackResult.Knife.ButtSquare, 0);
  SetLength(PackResult.KnifeW1.PatternPoints, 0);
  SetLength(PackResult.KnifeW1.ExpandedPoints, 0);
  SetLength(PackResult.KnifeW1.ConvexHull, 0);
  SetLength(PackResult.KnifeW1.ButtSquare, 0);
  SetLength(PackResult.KnifeW2.PatternPoints, 0);
  SetLength(PackResult.KnifeW2.ExpandedPoints, 0);
  SetLength(PackResult.KnifeW2.ConvexHull, 0);
  SetLength(PackResult.KnifeW2.ButtSquare, 0);
  Setlength(PackResult.CutResults, 0);
end;

procedure InitialisePackResults;
begin
  InitialisePackResult(First4Horizontal);
  InitialisePackResult(First4HorizontalPI);
  InitialisePackResult(First4Vertical);
  InitialisePackResult(First4VerticalPI);
  InitialisePackResult(First8Horizontal);
  InitialisePackResult(First8HorizontalPI);
  InitialisePackResult(First8Vertical);
  InitialisePackResult(First8VerticalPI);
  InitialisePackResult(SecondHorizontalW1);
  InitialisePackResult(SecondHorizontalW2Top);
  InitialisePackResult(SecondHorizontalW2Bottom);
  InitialisePackResult(SecondHorizontalPI);
  InitialisePackResult(SecondVerticalW1);
  InitialisePackResult(SecondVerticalW2Left);
  InitialisePackResult(SecondVerticalW2Right);
  InitialisePackResult(SecondVerticalPI);
end;

procedure CopyFromPackResult(var Knife, KnifeW1, KnifeW2: TPattern;
                             var LocalInterlock: TLocalInterlock;
                             var PackAngle: real;
                             var PackResult: TCompleteCutResult);
begin
  Knife.Height := PackResult.Knife.Height;
  Knife.Width := PackResult.Knife.Width;
  Knife.PatternPoints := Copy(PackResult.Knife.PatternPoints);
  Knife.ExpandedPoints := Copy(PackResult.Knife.ExpandedPoints);
  Knife.ConvexHull := Copy(PackResult.Knife.ConvexHull);
  Knife.ButtSquare := Copy(PackResult.Knife.ButtSquare);
  Knife.PatternNettArea := PackResult.Knife.PatternNettArea;
  Knife.ExpandedNettArea := PackResult.Knife.ExpandedNettArea;
  Knife.ExpandedGrossArea := PackResult.Knife.ExpandedGrossArea;
  Knife.W2 := PackResult.Knife.W2;

  KnifeW1.Height := PackResult.KnifeW1.Height;
  KnifeW1.Width := PackResult.KnifeW1.Width;
  KnifeW1.PatternPoints := Copy(PackResult.KnifeW1.PatternPoints);
  KnifeW1.ExpandedPoints := Copy(PackResult.KnifeW1.ExpandedPoints);
  KnifeW1.ConvexHull := Copy(PackResult.KnifeW1.ConvexHull);
  KnifeW1.ButtSquare := Copy(PackResult.KnifeW1.ButtSquare);
  KnifeW1.PatternNettArea := PackResult.KnifeW1.PatternNettArea;
  KnifeW1.ExpandedNettArea := PackResult.KnifeW1.ExpandedNettArea;
  KnifeW1.ExpandedGrossArea := PackResult.KnifeW1.ExpandedGrossArea;
  KnifeW1.W2 := PackResult.KnifeW1.W2;

  KnifeW2.Height := PackResult.KnifeW2.Height;
  KnifeW2.Width := PackResult.KnifeW2.Width;
  KnifeW2.PatternPoints := Copy(PackResult.KnifeW2.PatternPoints);
  KnifeW2.ExpandedPoints := Copy(PackResult.KnifeW2.ExpandedPoints);
  KnifeW2.ConvexHull := Copy(PackResult.KnifeW2.ConvexHull);
  KnifeW2.ButtSquare := Copy(PackResult.KnifeW2.ButtSquare);
  KnifeW2.PatternNettArea := PackResult.KnifeW2.PatternNettArea;
  KnifeW2.ExpandedNettArea := PackResult.KnifeW2.ExpandedNettArea;
  KnifeW2.ExpandedGrossArea := PackResult.KnifeW2.ExpandedGrossArea;
  KnifeW2.W2 := PackResult.KnifeW2.W2;

  CutResults := Copy(PackResult.CutResults);
  NewKnife := PackResult.NewKnife;
  NoIn4 := PackResult.NoIn4;
  PackAngle := PackResult.PackAngle;

  LocalInterlock := PackResult.LocalInterlock;
end;

procedure CopyToPackResult(var Knife, KnifeW1, KnifeW2: TPattern;
                           var LocalInterlock: TLocalInterlock;
                           var PackAngle: real;
                           var PackResult: TCompleteCutResult);
begin
  PackResult.Calculated := True;

  PackResult.Knife.Height := Knife.Height;
  PackResult.Knife.Width := Knife.Width;
  PackResult.Knife.PatternPoints := Copy(Knife.PatternPoints);
  PackResult.Knife.ExpandedPoints := Copy(Knife.ExpandedPoints);
  PackResult.Knife.ConvexHull := Copy(Knife.ConvexHull);
  PackResult.Knife.ButtSquare := Copy(Knife.ButtSquare);
  PackResult.Knife.PatternNettArea := Knife.PatternNettArea;
  PackResult.Knife.ExpandedNettArea := Knife.ExpandedNettArea;
  PackResult.Knife.ExpandedGrossArea := Knife.ExpandedGrossArea;
  PackResult.Knife.W2 := Knife.W2;

  PackResult.KnifeW1.Height := KnifeW1.Height;
  PackResult.KnifeW1.Width := KnifeW1.Width;
  PackResult.KnifeW1.PatternPoints := Copy(KnifeW1.PatternPoints);
  PackResult.KnifeW1.ExpandedPoints := Copy(KnifeW1.ExpandedPoints);
  PackResult.KnifeW1.ConvexHull := Copy(KnifeW1.ConvexHull);
  PackResult.KnifeW1.ButtSquare := Copy(KnifeW1.ButtSquare);
  PackResult.KnifeW1.PatternNettArea := KnifeW1.PatternNettArea;
  PackResult.KnifeW1.ExpandedNettArea := KnifeW1.ExpandedNettArea;
  PackResult.KnifeW1.ExpandedGrossArea := KnifeW1.ExpandedGrossArea;
  PackResult.KnifeW1.W2 := KnifeW1.W2;

  PackResult.KnifeW2.Height := KnifeW2.Height;
  PackResult.KnifeW2.Width := KnifeW2.Width;
  PackResult.KnifeW2.PatternPoints := Copy(KnifeW2.PatternPoints);
  PackResult.KnifeW2.ExpandedPoints := Copy(KnifeW2.ExpandedPoints);
  PackResult.KnifeW2.ConvexHull := Copy(KnifeW2.ConvexHull);
  PackResult.KnifeW2.ButtSquare := Copy(KnifeW2.ButtSquare);
  PackResult.KnifeW2.PatternNettArea := KnifeW2.PatternNettArea;
  PackResult.KnifeW2.ExpandedNettArea := KnifeW2.ExpandedNettArea;
  PackResult.KnifeW2.ExpandedGrossArea := KnifeW2.ExpandedGrossArea;
  PackResult.KnifeW2.W2 := KnifeW2.W2;

  PackResult.CutResults := Copy(CutResults);
  PackResult.NewKnife := NewKnife;
  PackResult.NoIn4 := NoIn4;
  PackResult.PackAngle := PackAngle;

  PackResult.LocalInterlock := LocalInterlock;
end;

procedure DiagonalPack(Pack: integer; Line2W2: Boolean);
var
  dmyLI: TLocalInterlock;
  dmyPA: real;

begin
  if (Pack = DIAGONAL_HORIZONTAL) and (not Line2W2) then
  begin
    //Note: Should already have done CopyFromPackResult in this case
    CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalW1);
    RepeatedInterlock8to16(SecondHorizontalW1, False); //In this case itself
  end
  else if (Pack = DIAGONAL_HORIZONTAL) and Line2W2 then
  begin
    CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalW2Top);
    RepeatedInterlock8to16(SecondHorizontalW2Bottom, True);
  end
  else if (Pack = DIAGONAL_VERTICAL) and (not Line2W2) then
  begin
  begin
    //Note: Should already have done CopyFromPackResult in this case
    CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalW1);
    RepeatedInterlock8to16(SecondVerticalW1, False); //In this case itself
  end;
  end
  else if (Pack = DIAGONAL_VERTICAL) and Line2W2 then
  begin
    CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalW2Left);
    RepeatedInterlock8to16(SecondVerticalW2Right, True);
  end;
end;

function Plan(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth, Pack: integer;
              Propogate, Line2W2, FirstCutInCorner, ForceW1First, ForceW2First, FixedStart, StartLeft: boolean;
              LocalInterlock: TLocalInterlock;
              var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
              var RemainingArea: real; var StartingLeft: Boolean; Tolerance: integer): Boolean;
var
  PacksHoriz, PacksHorizP2Inv, PacksVert, PacksVertP2Inv, PacksHorizDiag,
  PacksVertDiag, PacksHorizP2InvDiag, PacksVertP2InvDiag, Square: set of TPackSet;
  Steps: TStepsArray;
  PackSuccess: Boolean;
  Step1Pack, Step1aPack, Step2Pack, Step2aPack: integer;
  DoStep1, DoStep1a, DoStep2, DoStep2a, Step2Found: Boolean;
  dmyLI: TLocalInterlock;
  dmyPA: real;
  Pattern: TPattern;

begin
{$IFDEF DEBUG}
  Planning := GetTickCount;
  FullPlan := Planning;
  FileNumber := 0;
{$ENDIF}

  SetLength(Parallelogram, 0);
  ParallelogramCount := 0;

  try
    InterlockingToleranceLayplans_Local := Tolerance;

    PacksHoriz := [SQUARE_HORIZONTAL, OFFSET_HORIZONTAL_TOP, OFFSET_HORIZONTAL_BOTTOM];
    PacksHorizP2Inv := [SQUARE_HORIZONTAL_P2_INVERTED, OFFSET_HORIZONTAL_P2_INVERTED];
    PacksHorizDiag := [DIAGONAL_HORIZONTAL];
    PacksHorizP2InvDiag := [DIAGONAL_HORIZONTAL_P2_INVERTED];
    PacksVert := [SQUARE_VERTICAL, OFFSET_VERTICAL_LEFT, OFFSET_VERTICAL_RIGHT];
    PacksVertP2Inv := [SQUARE_VERTICAL_P2_INVERTED, OFFSET_VERTICAL_P2_INVERTED];
    PacksVertDiag := [DIAGONAL_VERTICAL];
    PacksVertP2InvDiag := [DIAGONAL_VERTICAL_P2_INVERTED];
    Square := [SQUARE_HORIZONTAL, SQUARE_HORIZONTAL_P2_INVERTED, SQUARE_VERTICAL, SQUARE_VERTICAL_P2_INVERTED];

    //Step 1 First Line
    //Step 1a Make the 4 into 8 for searching (Not always required)
    //Step 2 Second Line
    //Step 2a Possible extra step to ensure all searches done (Diagonals only)
    //Step 3 Unique bits for specific pack

    DoStep1 := False;
    DoStep1a := False;
    DoStep2 := False;
    DoStep2a := False;
    Step2Found := True;

    //Step 2
    if (Pack = OFFSET_HORIZONTAL_TOP) and (not Line2W2) then
    begin
      Step2Pack := SECOND_HORIZONTAL_W1;
      if SecondHorizontalW1.Calculated then
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalW1)
      else
        DoStep2 := True;
    end
    else if (Pack = OFFSET_HORIZONTAL_TOP) and Line2W2 then
    begin
      Step2Pack := SECOND_HORIZONTAL_W2_TOP;
      if SecondHorizontalW2Top.Calculated then
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalW2Top)
      else
        DoStep2 := True;
    end
    else if (Pack = OFFSET_HORIZONTAL_BOTTOM) then
    begin
      Step2Pack := SECOND_HORIZONTAL_W2_BOTTOM;
      if SecondHorizontalW2Bottom.Calculated then
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalW2Bottom)
      else
        DoStep2 := True;
    end
    else if (Pack = OFFSET_HORIZONTAL_P2_INVERTED) or (Pack = DIAGONAL_HORIZONTAL_P2_INVERTED) then
    begin
      Step2Pack := SECOND_HORIZONTAL_P2_INVERTED;
      if SecondHorizontalPI.Calculated then
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalPI)
      else
        DoStep2 := True;
    end
    else if (Pack = DIAGONAL_HORIZONTAL) and (not Line2W2) then
    begin
      Step2Pack := SECOND_HORIZONTAL_W1;
      if SecondHorizontalW1.Calculated then
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalW1)
      else
        DoStep2 := True;
    end
    else if (Pack = DIAGONAL_HORIZONTAL) and Line2W2 then
    begin
      Step2Pack := SECOND_HORIZONTAL_W2_TOP;
      Step2aPack := SECOND_HORIZONTAL_W2_BOTTOM;
      if (not SecondHorizontalW2Top.Calculated) and (not SecondHorizontalW2Bottom.Calculated) then
      begin
        DoStep2 := True;
        DoStep2a := True;
      end
      else if (not SecondHorizontalW2Top.Calculated) and (SecondHorizontalW2Bottom.Calculated) then
        DoStep2 := True
      else if (SecondHorizontalW2Top.Calculated) and (not SecondHorizontalW2Bottom.Calculated) then
        DoStep2a := True;

      //Note: No need to copy from Pack Here as Special Case
    end
    else if (Pack = OFFSET_VERTICAL_LEFT) and (not Line2W2) then
    begin
      Step2Pack := SECOND_VERTICAL_W1;
      if SecondVerticalW1.Calculated then
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalW1)
      else
        DoStep2 := True;
    end
    else if (Pack = OFFSET_VERTICAL_LEFT) and Line2W2 then
    begin
      Step2Pack := SECOND_VERTICAL_W2_LEFT;
      if SecondVerticalW2Left.Calculated then
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalW2Left)
      else
        DoStep2 := True;
    end
    else if (Pack = OFFSET_VERTICAL_RIGHT) then
    begin
      Step2Pack := SECOND_VERTICAL_W2_RIGHT;
      if SecondVerticalW2Right.Calculated then
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalW2Right)
      else
        DoStep2 := True;
    end
    else if (Pack = OFFSET_VERTICAL_P2_INVERTED) or (Pack = DIAGONAL_VERTICAL_P2_INVERTED) then
    begin
      Step2Pack := SECOND_VERTICAL_P2_INVERTED;
      if SecondVerticalPI.Calculated then
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalPI)
      else
        DoStep2 := True;
    end
    else if ((Pack = DIAGONAL_VERTICAL) or (Pack = DIAGONAL_FREE))and (not Line2W2) then
    begin
      Step2Pack := SECOND_VERTICAL_W1;
      if SecondVerticalW1.Calculated then
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalW1)
      else
        DoStep2 := True;
    end
    else if ((Pack = DIAGONAL_VERTICAL) or (Pack = DIAGONAL_FREE)) and Line2W2 then
    begin
      Step2Pack := SECOND_VERTICAL_W2_LEFT;
      Step2aPack := SECOND_VERTICAL_W2_RIGHT;
      if (not SecondVerticalW2Left.Calculated) and (not SecondVerticalW2Right.Calculated) then
      begin
        DoStep2 := True;
        DoStep2a := True;
      end
      else if (not SecondVerticalW2Left.Calculated) and (SecondVerticalW2Right.Calculated) then
        DoStep2 := True
      else if (SecondVerticalW2Left.Calculated) and (not SecondVerticalW2Right.Calculated) then
        DoStep2a := True;

      //Note: No need to copy from Pack Here as Special Case
    end
    else
      Step2Found := False;

    //Steps 1 & 1a
    if DoStep2 or (not Step2Found) then
    begin
      if Pack = SQUARE_HORIZONTAL then
      begin
        Step1Pack := FIRST4_HORIZONTAL;
        if not First4Horizontal.Calculated then
          DoStep1 := True
        else
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4Horizontal);
      end
      else if Pack = SQUARE_HORIZONTAL_P2_INVERTED then
      begin
        Step1Pack := FIRST4_HORIZONTAL_P2_INVERTED;
        if not First4HorizontalPI.Calculated then
          DoStep1 := True
        else
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4HorizontalPI);
      end
      else if Pack = SQUARE_VERTICAL then
      begin
        Step1Pack := FIRST4_VERTICAL;
        if not First4Vertical.Calculated then
          DoStep1 := True
        else
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4Vertical);
      end
      else if Pack = SQUARE_VERTICAL_P2_INVERTED then
      begin
        Step1Pack := FIRST4_VERTICAL_P2_INVERTED;
        if not First4VerticalPI.Calculated then
          DoStep1 := True
        else
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4VerticalPI);
      end
      else if (Pack in PacksHoriz) or (Pack in PacksHorizDiag) then
      begin
        Step1Pack := FIRST4_HORIZONTAL;
        Step1aPack := FIRST8_HORIZONTAL;
        if not First4Horizontal.Calculated then
        begin
          DoStep1 := True;
          DoStep1a := True;
        end
        else if not First8Horizontal.Calculated then
        begin
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4Horizontal);
          DoStep1a := True
        end
        else
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8Horizontal);
      end
      else if (Pack in PacksHorizP2Inv) or (Pack in PacksHorizP2InvDiag) then
      begin
        Step1Pack := FIRST4_HORIZONTAL_P2_INVERTED;
        Step1aPack := FIRST8_HORIZONTAL_P2_INVERTED;
        if not First4HorizontalPI.Calculated then
        begin
          DoStep1 := True;
          DoStep1a := True;
        end
        else if not First8HorizontalPI.Calculated then
        begin
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4HorizontalPI);
          DoStep1a := True;
        end
        else
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8HorizontalPI);
      end
      else if (Pack in PacksVert) or (Pack in PacksVertDiag) then
      begin
        Step1Pack := FIRST4_VERTICAL;
        Step1aPack := FIRST8_VERTICAL;
        if not First4Vertical.Calculated then
        begin
          DoStep1 := True;
          DoStep1a := True;
        end
        else if not First8Vertical.Calculated then
        begin
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4Vertical);
          DoStep1a := True;
        end
        else
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8Vertical);
      end
      else if (Pack in PacksVertP2Inv) or (Pack in PacksVertP2InvDiag) then
      begin
        Step1Pack := FIRST4_VERTICAL_P2_INVERTED;
        Step1aPack := FIRST8_VERTICAL_P2_INVERTED;
        if not First4VerticalPI.Calculated then
        begin
          DoStep1 := True;
          DoStep1a := True;
        end
        else if not First8VerticalPI.Calculated then
        begin
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4VerticalPI);
          DoStep1a := True;
        end
        else
          CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8VerticalPI);
      end;
    end;

    if DoStep1 then
    begin
      Steps := GetSteps(Step1Pack, Line2W2);
      PackSuccess := DoSteps(0, Step1Pack, Steps);

      if Step1Pack = FIRST4_HORIZONTAL then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4Horizontal)
      else if Step1Pack = FIRST4_HORIZONTAL_P2_INVERTED then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4HorizontalPI)
      else if Step1Pack = FIRST4_VERTICAL then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4Vertical)
      else if Step1Pack = FIRST4_VERTICAL_P2_INVERTED then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First4VerticalPI)
    end
    else
      PackSuccess := True;

    if DoStep1a then
    begin
      PackSuccess := RepeatedInterlock(True, True, False);

      if PackSuccess then
      begin
        //Note in the 8's we are keeping Knife as an 8, but KnifeW1, KnifeW2 as 4's
        if Step1aPack = FIRST8_HORIZONTAL then
          CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8Horizontal)
        else if Step1aPack = FIRST8_HORIZONTAL_P2_INVERTED then
          CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8HorizontalPI)
        else if Step1aPack = FIRST8_VERTICAL then
          CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8Vertical)
        else if Step1aPack = FIRST8_VERTICAL_P2_INVERTED then
          CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8VerticalPI);
      end;
    end
    else
      PackSuccess := True;

    if DoStep2 then
    begin
      Steps := GetSteps(Step2Pack, Line2W2);
      PackSuccess := DoSteps(0, Step2Pack, Steps);

      if Step2Pack = SECOND_HORIZONTAL_W1 then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalW1)
      else if Step2Pack = SECOND_HORIZONTAL_W2_TOP then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalW2Top)
      else if Step2Pack = SECOND_HORIZONTAL_W2_BOTTOM then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalW2Bottom)
      else if Step2Pack = SECOND_HORIZONTAL_P2_INVERTED then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalPI)
      else if Step2Pack = SECOND_VERTICAL_W1 then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalW1)
      else if Step2Pack = SECOND_VERTICAL_W2_LEFT then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalW2Left)
      else if Step2Pack = SECOND_VERTICAL_W2_RIGHT then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalW2Right)
      else if Step2Pack = SECOND_VERTICAL_P2_INVERTED then
        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalPI);
    end
    else
      PackSuccess := True;

    if DoStep2a then
    begin
      //Only For Diagonal Packs and Must ensure at Correct Start Position
      if Step2aPack = SECOND_HORIZONTAL_W2_TOP then //Diagonal Horizontal
      begin
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8Horizontal);

        Steps := GetSteps(Step2aPack, Line2W2);
        PackSuccess := DoSteps(0, Step2aPack, Steps);

        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalW2Top)
      end
      else if Step2aPack = SECOND_HORIZONTAL_W2_BOTTOM then //Diagonal Horizontal
      begin
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8Horizontal);

        Steps := GetSteps(Step2aPack, Line2W2);
        PackSuccess := DoSteps(0, Step2aPack, Steps);

        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondHorizontalW2Bottom)
      end
      else if Step2aPack = SECOND_VERTICAL_W2_LEFT then //Diagonal Vertical
      begin
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8Vertical);

        Steps := GetSteps(Step2aPack, Line2W2);
        PackSuccess := DoSteps(0, Step2aPack, Steps);

        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalW2Left)
      end
      else if Step2aPack = SECOND_VERTICAL_W2_RIGHT then //Diagonal Vertical
      begin
        CopyFromPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, First8Vertical);

        Steps := GetSteps(Step2aPack, Line2W2);
        PackSuccess := DoSteps(0, Step2aPack, Steps);

        CopyToPackResult(Knife, KnifeW1, KnifeW2, dmyLI, dmyPA, SecondVerticalW2Right)
      end;
    end
    else
      PackSuccess := True;

    //Step 3
    if PackSuccess then
    begin
      if (Pack = DIAGONAL_HORIZONTAL) or (Pack = DIAGONAL_VERTICAL) or (Pack = DIAGONAL_FREE) then
        DiagonalPack(Pack, Line2W2)
      else if not ((Pack = DIAGONAL_HORIZONTAL_P2_INVERTED) or (Pack = DIAGONAL_VERTICAL_P2_INVERTED)) then
      begin
        Steps := GetSteps(Pack, Line2W2);
        PackSuccess := DoSteps(0, Pack, Steps);
      end;
    end;

    if PackSuccess then
      RemoveGhostsFromCutResults(Pack);

    {$IFDEF DEBUGFULL}
    if PackSuccess then
      if Assigned(fmDebugger) then fmDebugger.DrawPack;
    {$ENDIF}

    if PackSuccess then
    begin
      SetLength(Parallelogram, 4);

      //Select knife
      if not CutResults[0].W2 then
        Pattern := KnivesUsed[CutResults[0].KnifeNo - 1, 0]
      else
        Pattern := KnivesUsed[CutResults[0].KnifeNo - 1, 1];

      Parallelogram[0].X := Pattern.PatternPoints[0].X + CutResults[0].BoundingRect.Left;
      Parallelogram[0].Y := Pattern.PatternPoints[0].Y + CutResults[0].BoundingRect.Top;
      Parallelogram[1].X := Pattern.PatternPoints[0].X + CutResults[2].BoundingRect.Left;
      Parallelogram[1].Y := Pattern.PatternPoints[0].Y + CutResults[2].BoundingRect.Top;

      if (Length(CutResults) = 8) then
      begin
        Parallelogram[2].X := Pattern.PatternPoints[0].X + CutResults[6].BoundingRect.Left;
        Parallelogram[2].Y := Pattern.PatternPoints[0].Y + CutResults[6].BoundingRect.Top;
        Parallelogram[3].X := Pattern.PatternPoints[0].X + CutResults[4].BoundingRect.Left;
        Parallelogram[3].Y := Pattern.PatternPoints[0].Y + CutResults[4].BoundingRect.Top;
        ParallelogramCount := 2;
      end
      else
      begin
        Parallelogram[2].X := Pattern.PatternPoints[0].X + CutResults[10].BoundingRect.Left;
        Parallelogram[2].Y := Pattern.PatternPoints[0].Y + CutResults[10].BoundingRect.Top;
        Parallelogram[3].X := Pattern.PatternPoints[0].X + CutResults[8].BoundingRect.Left;
        Parallelogram[3].Y := Pattern.PatternPoints[0].Y + CutResults[8].BoundingRect.Top;
        ParallelogramCount := 4;
      end;

      if LocalInterlock.Used then
        ParallelogramCount := 2 * ParallelogramCount;
    end;

    StartingLeft := False;
    if PackSuccess then
    begin
      //Check it will fit and propogate
      if not ((PatternWidth > UsableMaterialWidth) or (PatternHeight > UsableMaterialLength)) then
      begin
        if Propogate then
        begin
          if (Pack in PacksHoriz) then
            PropogateHorizontal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                (Pack in Square), FixedStart, StartLeft, Line2W2, FirstCutInCorner,
                                LocalInterlock,
                                NumberOfPatterns, RemainingHeight, RemainingWidth, RemainingArea, StartingLeft)
          else if (Pack in PacksHorizP2Inv) then
            PropogateHorizontalP2Inverted(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                          (Pack in Square), FixedStart, StartLeft, FirstCutInCorner, ForceW1First,
                                          ForceW2First, NumberOfPatterns, RemainingHeight, RemainingWidth, RemainingArea, StartingLeft)
          else if (Pack in PacksVert) then
            PropogateVertical(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                              (Pack in Square), FixedStart, StartLeft, Line2W2, FirstCutInCorner,
                              LocalInterlock,
                              NumberOfPatterns, RemainingHeight, RemainingWidth, RemainingArea, StartingLeft)
          else if (Pack in PacksVertP2Inv) then
            PropogateVerticalP2Inverted(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                        (Pack in Square), FixedStart, StartLeft, FirstCutInCorner, ForceW1First,
                                        ForceW2First, NumberOfPatterns, RemainingHeight, RemainingWidth, RemainingArea, StartingLeft)
          else if (Pack in PacksHorizDiag) then
            PropogateHorizontalDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                        FixedStart, StartLeft, Line2W2, FirstCutInCorner,
                                        LocalInterlock,
                                        NumberOfPatterns, RemainingHeight, RemainingWidth, RemainingArea, StartingLeft)
          else if (Pack in PacksHorizP2InvDiag) then
            PropogateHorizontalP2InvertedDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                                  FixedStart, StartLeft,
                                                  NumberOfPatterns, RemainingHeight, RemainingWidth, RemainingArea, StartingLeft)
          else if (Pack in PacksVertDiag) then
            PropogateVerticalDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                      FixedStart, StartLeft, Line2W2, FirstCutInCorner,
                                      LocalInterlock,
                                      NumberOfPatterns, RemainingHeight, RemainingWidth, RemainingArea, StartingLeft)
          else if (Pack in PacksVertP2InvDiag) then
            PropogateVerticalP2InvertedDiagonal(UsableMaterialLength, UsableMaterialWidth, PatternHeight, PatternWidth,
                                                FixedStart, StartLeft,
                                                NumberOfPatterns, RemainingHeight, RemainingWidth, RemainingArea, StartingLeft);
          //Note Never propogate DIAGONAL_FREE here
        end
        else
        begin
          //Just Show pack
          NumberOfPatterns := Length(CutResults);
          RemainingHeight := 0;
          RemainingWidth := 0;
          RemainingArea := 0;
        end;
      end;
    end
    else
    begin
      NumberOfPatterns := -1;
      RemainingHeight := -1;
      RemainingWidth := -1;
      RemainingArea := -1;
    end;
  except
    PackSuccess := False;
  end;

  Result := PackSuccess;

{$IFDEF DEBUG}
  Planning := GetTickCount - Planning;
  FullPlan := GetTickCount - FullPlan;
  TotalPlan := TotalPlan + Planning;
  TotalFullPlan := TotalFullPlan + FullPlan;
{$ENDIF}
end;

procedure SwapPairedPatternToSingles(LocalInterlock: TLocalInterlock);
var
  NewCutResults: TCutResult;
  i, j: integer;
  UseLeft, UseRight, UseTop, UseBottom: Boolean;
  UsePat1, UsePat2: Boolean;
  FirstGangFound: Boolean;
  ReversedNo: integer;

begin
  //Knife No Meanings for negative Knife
  //1 Left
  //2 Right
  //4 Top
  //8 Bottom

  ReversedNo := -1;
  FirstGangFound := False;

  setLength(NewCutResults, 0);
  for i := 0 to Length(CutResults) - 1 do
  begin
    UseLeft := True;
    UseRight := True;
    UseTop := True;
    UseBottom := True;
    if CutResults[i].KnifeNo <= 0 then
    begin
      UseLeft := (abs(CutResults[i].KnifeNo) and 1) = 1;
      UseRight := (abs(CutResults[i].KnifeNo) and 2) = 2;
      UseTop := (abs(CutResults[i].KnifeNo) and 4) = 4;
      UseBottom := (abs(CutResults[i].KnifeNo) and 8) = 8;
    end;

    UsePat1 := ((UseLeft and (LocalInterlock.LeftPat = 1)) or
                (UseRight and (LocalInterlock.LeftPat = 2)) or
                (UseTop and (LocalInterlock.BottomPat = 2)) or
                (UseBottom and (LocalInterlock.BottomPat = 1)));
    UsePat2 := ((UseLeft and (LocalInterlock.LeftPat = 2)) or
                (UseRight and (LocalInterlock.LeftPat = 1)) or
                (UseTop and (LocalInterlock.BottomPat = 1)) or
                (UseBottom and (LocalInterlock.BottomPat = 2)));

    if UsePat1 then
    begin
      setLength(NewCutResults, Length(NewCutResults) + 1);
      j := Length(NewCutResults) - 1;
      NewCutResults[j].KnifeNo := LocalInterlock.SingleKnifeNo;
      NewCutResults[j].W2 := CutResults[i].W2;
      if LocalInterlock.W2 then
        NewCutResults[j].W2 := False;
      NewCutResults[j].Ghost := CutResults[i].Ghost;
      NewCutResults[j].BoundingRect.Top := CutResults[i].BoundingRect.Top + LocalInterlock.Pat1.Top;
      NewCutResults[j].BoundingRect.Left := CutResults[i].BoundingRect.Left + LocalInterlock.Pat1.Left;
      NewCutResults[j].BoundingRect.Bottom := CutResults[i].BoundingRect.Bottom + LocalInterlock.Pat1.Bottom;
      NewCutResults[j].BoundingRect.Right := CutResults[i].BoundingRect.Right + LocalInterlock.Pat1.Right;
      if LocalInterlock.Reversed then
        NewCutResults[j].W2 := not NewCutResults[j].W2;
    end;

    if UsePat2 then
    begin
      setLength(NewCutResults, Length(NewCutResults) + 1);
      j := Length(NewCutResults) - 1;
      NewCutResults[j].KnifeNo := LocalInterlock.SingleKnifeNo;
      NewCutResults[j].W2 := CutResults[i].W2;
      if LocalInterlock.W2 then
        NewCutResults[j].W2 := True;
      NewCutResults[j].Ghost := CutResults[i].Ghost;
      NewCutResults[j].BoundingRect.Top := CutResults[i].BoundingRect.Top + LocalInterlock.Pat2.Top;
      NewCutResults[j].BoundingRect.Left := CutResults[i].BoundingRect.Left + LocalInterlock.Pat2.Left;
      NewCutResults[j].BoundingRect.Bottom := CutResults[i].BoundingRect.Bottom + LocalInterlock.Pat2.Bottom;
      NewCutResults[j].BoundingRect.Right := CutResults[i].BoundingRect.Right + LocalInterlock.Pat2.Right;
      NewCutResults[j].Colour := CutResults[i].Colour;
      if LocalInterlock.Reversed then
        NewCutResults[j].W2 := not NewCutResults[j].W2;
    end;

    if ShowGangs then
    begin
      if UsePat1 and UsePat2 then
      begin
        if (not FirstGangFound) then
        begin
          if not LocalInterlock. Reversed then
          begin
            NewCutResults[j - 1].Colour := clCut;
            NewCutResults[j].Colour := clCut;
          end
          else
          begin
            NewCutResults[j - 1].Colour := clBlue;
            NewCutResults[j].Colour := clBlue;
            ReversedNo := j;
          end;
          FirstGangFound := True;
        end
        else
        begin
          NewCutResults[j - 1].Colour := clBackVeryDark;
          NewCutResults[j].Colour := clBackVeryDark;;
        end;
      end;
    end;
  end;

  if ReversedNo <> -1 then
  begin
    NewCutResults[ReversedNo + 2].Colour := clSkyBlue;
    NewCutResults[ReversedNo + 1].Colour := clSkyBlue;
  end;

  CutResults := copy(NewCutResults);
end;

procedure RelativePositionLocalInterlockPatterns(var LocalInterlock: TLocalInterlock);
begin
  with LocalInterlock do
  begin
    //Position 1st Pattern
    Pat1 := Rect(0, 0, SinglePatternWidth - 1, SinglePatternHeight - 1);
    if LocalInterlock.Vec1x < 0 then
    begin
      Pat1.Left := Pat1.Left - Vec1x;
      Pat1.Right := Pat1.Right - Vec1x;
    end;
    if LocalInterlock.Vec1y < 0 then
    begin
      Pat1.Top := Pat1.Top - Vec1y;
      Pat1.Bottom := Pat1.Bottom - Vec1y;
    end;

    //Position 2nd pattern
    Pat2 := Rect(0, 0, SinglePatternWidth - 1, SinglePatternHeight - 1);
    Pat2.Top := Pat2.Top + Vec1y;
    Pat2.Bottom := Pat2.Bottom + Vec1y;
    Pat2.Left := Pat2.Left + Vec1x;
    Pat2.Right := Pat2.Right + Vec1x;
    if LocalInterlock.Vec1x < 0 then
    begin
      Pat2.Left := Pat2.Left - Vec1x;
      Pat2.Right := Pat2.Right - Vec1x;
    end;
    if LocalInterlock.Vec1y < 0 then
    begin
      Pat2.Top := Pat2.Top - Vec1y;
      Pat2.Bottom := Pat2.Bottom - Vec1y;
    end;

    //Find Left & Right Patterns
    if Pat1.Left <= Pat2.Left then
      LeftPat := 1
    else
      LeftPat := 2;

    //Find Top & Bottom Patterns
    if Pat1.Top <= Pat2.Top then
      BottomPat := 2
    else
      BottomPat := 1;

    BottomIsLeft := ((Vec1x < 0) and (Vec1y > 0)) or ((Vec1x > 0) and (Vec1y < 0));
  end;
end;

function LocalInterlockToUse(LocalInterlock: TLocalInterlock; Direction: integer;
                             Reversed, FirstCutInCorner, StartingLeft: Boolean): TLocalInterlock;
var
  Vec1x, Vec1y: integer;
  LI: TLocalInterlock;

begin
  //Check if valid option
  //If not...adjust it
  if FirstCutInCorner then
  begin
    if StartingLeft then
    begin
      if LocalInterlock.BottomIsLeft and Reversed then
        Reversed := False
      else if (not LocalInterlock.BottomIsLeft) and (not Reversed) then
        Reversed := True
    end
    else
    begin
      if LocalInterlock.BottomIsLeft and (not Reversed) then
        Reversed := True
      else if (not LocalInterlock.BottomIsLeft) and Reversed then
        Reversed := False;
    end;
  end;

  LI := LocalInterlock;
  if Reversed then
  begin
    if Direction = VERTICAL then
    begin
      Vec1y := abs(CutResults[1].BoundingRect.Top - CutResults[0].BoundingRect.Top);

      LI.Vec1x := - LI.Vec1x;
      if LI.Vec1y > 0 then
        LI.Vec1y := Vec1y - LI.Vec1y
      else
        LI.Vec1y := - Vec1y - LI.Vec1y;

      LI.PairedPatternHeight := abs(LI.Vec1y) + LI.SinglePatternHeight;
    end
    else  //HORIZONTAL
    begin
      Vec1x := abs(CutResults[1].BoundingRect.Left - CutResults[0].BoundingRect.Left);

      LI.Vec1y := - LI.Vec1y;
      if LI.Vec1x > 0 then
        LI.Vec1x := Vec1x - LI.Vec1x
      else
        LI.Vec1x := - Vec1x - LI.Vec1x;

      LI.PairedPatternWidth := abs(LI.Vec1x) + LI.SinglePatternWidth;
    end;

    RelativePositionLocalInterlockPatterns(LI);

    LI.Reversed := True;
  end;

  LocalInterlockToUse := LI;
end;

function GetFreeAngle(var Angle: real): Boolean;
const
  Fudge = 0.1;

var
  BestInterlock: TInterlock;
  OneIsLeft, OneIsTop: boolean;
  KeepPoints: TPointArray;

begin
  BestInterlock := FindInterlock(Knife, KnifeW1, KnivesUsed[CurrentKnife - 1, 0], (Length(CutResults) = 0), False,
                                 OriginalKnifeNow, False, False, False, False, False, True, True, InterlockingToleranceLayplans_Local);
  if BestInterlock.Error then
    Result := True
  else
    Result := False;

  if not Result then
  begin
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
  end;
end;

procedure RotateBackFreeDiagonalPack(ActualPackAngle: real);
var
  i, CutResultNo, KnifeNo, minx, miny, OverAllMinX, OverAllMinY, xOffset, yOffset: integer;
  ThisKnife: TPolygon2D;
  Index2: integer;

begin
  OverAllMinX := 99999999;
  OverAllMinY := 99999999;
  for CutResultNo := 0 to Length(CutResults) - 1 do
  begin
    if CutResults[CutResultNo].W2 then
      Index2 := 1
    else
      Index2 := 0;

    KnifeNo := CutResults[CutResultNo].KnifeNo - 1;
    xOffset := CutResults[CutResultNo].BoundingRect.Left;
    yOffset := CutResults[CutResultNo].BoundingRect.Top;
    SetLength(ThisKnife, Length(KnivesUsed[KnifeNo, Index2].ExpandedPoints));
    for i := 0 to Length(KnivesUsed[KnifeNo, Index2].ExpandedPoints) - 1 do
    begin
      ThisKnife[i].x := KnivesUsed[KnifeNo, Index2].ExpandedPoints[i].x + xOffset;
      ThisKnife[i].y := KnivesUsed[KnifeNo, Index2].ExpandedPoints[i].y + yOffset;
    end;

    ThisKnife := Rotate(-ActualPackAngle, ThisKnife);

    minx := 99999999;
    miny := 99999999;
    for i := 0 to Length(ThisKnife) - 1 do
    begin
      if ThisKnife[i].x < minx then
        minx := round(ThisKnife[i].x);
      if ThisKnife[i].y < miny then
        miny := round(ThisKnife[i].y);
    end;

    CutResults[CutResultNo].KnifeNo := CurrentKnife;
    CutResults[CutResultNo].BoundingRect.Left := minx;
    CutResults[CutResultNo].BoundingRect.Top := miny;
    CutResults[CutResultNo].BoundingRect.Right := minx + KnivesUsed[CurrentKnife - 1, Index2].Width;
    CutResults[CutResultNo].BoundingRect.Bottom := miny + KnivesUsed[CurrentKnife - 1, Index2].Height;

    if minx < OverAllMinX then
      OverAllMinX := minx;
    if miny < OverAllMinY then
      OverAllMinY := miny;
  end;

  for CutResultNo := 0 to Length(CutResults) - 1 do
  begin
    CutResults[CutResultNo].BoundingRect.Left := CutResults[CutResultNo].BoundingRect.Left - OverAllMinX;
    CutResults[CutResultNo].BoundingRect.Top := CutResults[CutResultNo].BoundingRect.Top - OverAllMinY;
    CutResults[CutResultNo].BoundingRect.Right := CutResults[CutResultNo].BoundingRect.Right - OverAllMinX;
    CutResults[CutResultNo].BoundingRect.Bottom := CutResults[CutResultNo].BoundingRect.Bottom - OverAllMinY;
  end;
end;

function RotatedInterlock(Knife, Knife2: TPattern; Angle: real; Interlock: TInterlock): TInterlock;
var
  i, CutResultNo, KnifeNo, maxx, maxy, minx, miny, OverAllMinX, OverAllMinY, xOffset, yOffset: integer;
  ThisKnife, ThisOverlap: TPolygon2D;

begin
  Result.Found := Interlock.Found;
  Result.W2 := Interlock.W2;
  Result.Size := Interlock.Size;

  //Knife1
  xOffset := Interlock.Knife1BoundingRect.Left;
  yOffset := Interlock.Knife1BoundingRect.Top;
  SetLength(ThisKnife, Length(Knife.ExpandedPoints));
  for i := 0 to Length(Knife.ExpandedPoints) - 1 do
  begin
    ThisKnife[i].x := Knife.ExpandedPoints[i].x + xOffset;
    ThisKnife[i].y := Knife.ExpandedPoints[i].y + yOffset;
  end;

  ThisKnife := Rotate(Angle, ThisKnife);

  maxx := -99999999;
  maxy := -99999999;
  minx := 99999999;
  miny := 99999999;
  for i := 0 to Length(ThisKnife) - 1 do
  begin
    if ThisKnife[i].x < minx then
      minx := round(ThisKnife[i].x);
    if ThisKnife[i].y < miny then
      miny := round(ThisKnife[i].y);
    if ThisKnife[i].x > maxx then
      maxx := round(ThisKnife[i].x);
    if ThisKnife[i].y > maxy then
      maxy := round(ThisKnife[i].y);
  end;

  Result.Knife1BoundingRect.Left := minx;
  Result.Knife1BoundingRect.Top := miny;
  Result.Knife1BoundingRect.Right := maxx;
  Result.Knife1BoundingRect.Bottom := maxy;

  //Knife2
  xOffset := Interlock.Knife2BoundingRect.Left;
  yOffset := Interlock.Knife2BoundingRect.Top;
  SetLength(ThisKnife, Length(Knife2.ExpandedPoints));
  for i := 0 to Length(Knife2.ExpandedPoints) - 1 do
  begin
    ThisKnife[i].x := Knife2.ExpandedPoints[i].x + xOffset;
    ThisKnife[i].y := Knife2.ExpandedPoints[i].y + yOffset;
  end;

  ThisKnife := Rotate(Angle, ThisKnife);

  maxx := -99999999;
  maxy := -99999999;
  minx := 99999999;
  miny := 99999999;
  for i := 0 to Length(ThisKnife) - 1 do
  begin
    if ThisKnife[i].x < minx then
      minx := round(ThisKnife[i].x);
    if ThisKnife[i].y < miny then
      miny := round(ThisKnife[i].y);
    if ThisKnife[i].x > maxx then
      maxx := round(ThisKnife[i].x);
    if ThisKnife[i].y > maxy then
      maxy := round(ThisKnife[i].y);
  end;

  Result.Knife2BoundingRect.Left := minx;
  Result.Knife2BoundingRect.Top := miny;
  Result.Knife2BoundingRect.Right := maxx;
  Result.Knife2BoundingRect.Bottom := maxy;
end;

function SinglePatternThatFits(x, y, LeftHandEdge, RightHandEdge, UsableMaterialLength: integer; LocalInterlock: TLocalInterlock): integer;
var
  P1_PossibleStartx, P1_PossibleStarty: integer;
  P2_PossibleStartx, P2_PossibleStarty: integer;

begin
  //Possible Start of SINGLE Patterns
  P1_PossibleStartx := x + LocalInterlock.Pat1.Left;
  P1_PossibleStarty := y - (LocalInterlock.PairedPatternHeight - LocalInterlock.Pat1.Bottom);
  P2_PossibleStartx := x + LocalInterlock.Pat2.Left;
  P2_PossibleStarty := y - (LocalInterlock.PairedPatternHeight - LocalInterlock.Pat2.Bottom);

  //See if either singles fit
  if (P1_PossibleStartx >= LeftHandEdge) and
     (P1_PossibleStartx <= (RightHandEdge - LocalInterlock.SinglePatternWidth)) and
     (P1_PossibleStarty >= LocalInterlock.SinglePatternHeight) and
     (P1_PossibleStarty <= UsableMaterialLength) then
    SinglePatternThatFits := 1
  else if
     (P2_PossibleStartx >= LeftHandEdge) and
     (P2_PossibleStartx <= (RightHandEdge - LocalInterlock.SinglePatternWidth)) and
     (P2_PossibleStarty >= LocalInterlock.SinglePatternHeight) and
     (P2_PossibleStarty <= UsableMaterialLength) then
    SinglePatternThatFits := 2
  else
    SinglePatternThatFits := 0;

end;

procedure PointCutResultsUp;
begin
  //Reverse direction
  SwapCutResults(0, 15);
  SwapCutResults(1, 14);
  SwapCutResults(2, 13);
  SwapCutResults(3, 12);
  SwapCutResults(4, 11);
  SwapCutResults(5, 10);
  SwapCutResults(6, 9);
  SwapCutResults(7, 8);

  //Offset it to ensure correct pack if one row W2
  //Note: Effectively turns it into a pack of 12 not 16
  //but this doesn't make any difference. We do it anyway
  //because in W1 case it doesn't make any difference

  CutResults[8] := CutResults[12];
  CutResults[9] := CutResults[13];
  CutResults[10] := CutResults[14];
  CutResults[11] := CutResults[15];

  CutResults[12] := CutResults[0];
  CutResults[13] := CutResults[1];
  CutResults[14] := CutResults[2];
  CutResults[15] := CutResults[3];

  CutResults[0] := CutResults[4];
  CutResults[1] := CutResults[5];
  CutResults[2] := CutResults[6];
  CutResults[3] := CutResults[7];
end;

procedure SwapCutResultsFromDiagonalFreeToDiagonalHorizontal;
begin
  //Swap
{  SwapCutResults(0, 12);         //This is the code which has been in since we wrote diagonal free.
  SwapCutResults(1, 13);          //It failed with lots of patterns (including BAD) and gave overlaps
  SwapCutResults(2, 14);          //in the pack. The replacement code below appears to work... but we
  SwapCutResults(3, 15);          //need to check it works in ALL cases - i.e. why was it written
  SwapCutResults(4, 8);           //like this to start with???
  SwapCutResults(5, 9);
  SwapCutResults(6, 10);
  SwapCutResults(7, 11);}

  SwapCutResults(0, 3);
  SwapCutResults(1, 2);
  SwapCutResults(4, 7);
  SwapCutResults(5, 6);
  SwapCutResults(8, 11);
  SwapCutResults(9, 10);
  SwapCutResults(12, 15);
  SwapCutResults(13, 14);

  {$IFDEF DEBUGFULL}
//    fmDebugger.DrawPack; //comment this out to see pack before swapped
  {$ENDIF}

end;

procedure SwapCutResults(i, j: integer);
var
  Temp: TCut;

begin
  Temp := CutResults[i];
  CutResults[i] := CutResults[j];
  CutResults[j] := Temp;
end;

procedure FillPropogationInput(No: integer;
                               UsableMaterialLength: Integer;
                               UsableMaterialWidth: Integer;
                               PatternHeight: Integer;
                               PatternWidth: Integer;
                               Square: Boolean;
                               FixedStart: Boolean;
                               StartLeft: Boolean;
                               W2: Boolean;
                               FirstCutInCorner: Boolean;
                               ForceW1First: Boolean;
                               ForceW2First: Boolean;
                               LocalInterlock: TLocalInterlock;
                               PackAngle: Double);
begin
  PropogationNo := No;

  PropogationInput.UsableMaterialLength := UsableMaterialLength;
  PropogationInput.UsableMaterialWidth := UsableMaterialWidth;
  PropogationInput.PatternHeight := PatternHeight;
  PropogationInput.PatternWidth := PatternWidth;
  PropogationInput.Square := Square;
  PropogationInput.FixedStart := FixedStart;
  PropogationInput.StartLeft := StartLeft;
  PropogationInput.W2 := W2;
  PropogationInput.FirstCutInCorner := FirstCutInCorner;
  PropogationInput.ForceW1First := ForceW1First;
  PropogationInput.ForceW2First := ForceW2First;
  PropogationInput.LocalInterlock := LocalInterlock;
  PropogationInput.PackAngle := PackAngle;

  PackResults := Copy(CutResults);
end;

function EmptyLocalInterlock: TLocalInterlock;
var
  LocalInterlock: TLocalInterlock;

begin
  with LocalInterlock do
  begin
    Used := FALSE;
    Reversed := FALSE;
    PairedPatternHeight := 0;
    PairedPatternWidth := 0;
    SinglePatternHeight := 0;
    SinglePatternWidth := 0;
    Vec1x := 0;
    Vec1y := 0;
    BottomIsLeft := FALSE;
    W2 := FALSE;
    Pat1.Left := 0;
    Pat1.Top := 0;
    Pat1.Right := 0;
    Pat1.Bottom := 0;
    Pat2.Left := 0;
    Pat2.Top := 0;
    Pat2.Right := 0;
    Pat2.Bottom := 0;
    LeftPat := 0;
    BottomPat := 0;
    SingleKnifeNo := 0;
  end;

  Result := LocalInterlock;
end;

procedure ReCreateLoadedLayplan(UsableMaterialLength, UsableMaterialWidth, PatWidth: integer;
                                StartLeft: Boolean);
var
  NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
  RemainingArea: real;
  StartingLeft: Boolean;
  dmyi1, dmy12, dmyi3: integer;
  dmyr1: real;

begin
  case PropogationNo of
    PROPOGATION_HORIZONTAL:
      PropogateHorizontal(PropogationInput.UsableMaterialLength,
                          PropogationInput.UsableMaterialWidth,
                          PropogationInput.PatternHeight,
                          PropogationInput.PatternWidth,
                          PropogationInput.Square,
                          PropogationInput.FixedStart,
                          PropogationInput.StartLeft,
                          PropogationInput.W2,
                          PropogationInput.FirstCutInCorner,
                          PropogationInput.LocalInterlock,
                          NumberOfPatterns, RemainingHeight, RemainingWidth,
                          RemainingArea, StartingLeft);

    PROPOGATION_HORIZONTALP2INVERTED:
      PropogateHorizontalP2Inverted(PropogationInput.UsableMaterialLength,
                                    PropogationInput.UsableMaterialWidth,
                                    PropogationInput.PatternHeight,
                                    PropogationInput.PatternWidth,
                                    PropogationInput.Square,
                                    PropogationInput.FixedStart,
                                    PropogationInput.StartLeft,
                                    PropogationInput.FirstCutInCorner,
                                    PropogationInput.ForceW1First,
                                    PropogationInput.ForceW2First,
                                    NumberOfPatterns, RemainingHeight,
                                    RemainingWidth, RemainingArea, StartingLeft);

    PROPOGATION_VERTICAL:
      PropogateVertical(PropogationInput.UsableMaterialLength,
                        PropogationInput.UsableMaterialWidth,
                        PropogationInput.PatternHeight,
                        PropogationInput.PatternWidth,
                        PropogationInput.Square,
                        PropogationInput.FixedStart,
                        PropogationInput.StartLeft,
                        PropogationInput.W2,
                        PropogationInput.FirstCutInCorner,
                        PropogationInput.LocalInterlock,
                        NumberOfPatterns, RemainingHeight, RemainingWidth,
                        RemainingArea, StartingLeft);

    PROPOGATION_VERTICALP2INVERTED:
      PropogateVerticalP2Inverted(PropogationInput.UsableMaterialLength,
                                  PropogationInput.UsableMaterialWidth,
                                  PropogationInput.PatternHeight,
                                  PropogationInput.PatternWidth,
                                  PropogationInput.Square,
                                  PropogationInput.FixedStart,
                                  PropogationInput.StartLeft,
                                  PropogationInput.FirstCutInCorner,
                                  PropogationInput.ForceW1First,
                                  PropogationInput.ForceW2First,
                                  NumberOfPatterns, RemainingHeight,
                                  RemainingWidth, RemainingArea, StartingLeft);

    PROPOGATION_HORIZONTALDIAGONAL:
      PropogateHorizontalDiagonal(PropogationInput.UsableMaterialLength,
                                  PropogationInput.UsableMaterialWidth,
                                  PropogationInput.PatternHeight,
                                  PropogationInput.PatternWidth,
                                  PropogationInput.FixedStart,
                                  PropogationInput.StartLeft,
                                  PropogationInput.W2,
                                  PropogationInput.FirstCutInCorner,
                                  PropogationInput.LocalInterlock,
                                  NumberOfPatterns, RemainingHeight,
                                  RemainingWidth, RemainingArea, StartingLeft);

    PROPOGATION_HORIZONTALP2INVERTEDDIAGONAL:
      PropogateHorizontalP2InvertedDiagonal(PropogationInput.UsableMaterialLength,
                                            PropogationInput.UsableMaterialWidth,
                                            PropogationInput.PatternHeight,
                                            PropogationInput.PatternWidth,
                                            PropogationInput.FixedStart,
                                            PropogationInput.StartLeft,
                                            NumberOfPatterns, RemainingHeight,
                                            RemainingWidth, RemainingArea,
                                            StartingLeft);

    PROPOGATION_VERTICALDIAGONAL:
      PropogateVerticalDiagonal(PropogationInput.UsableMaterialLength,
                                PropogationInput.UsableMaterialWidth,
                                PropogationInput.PatternHeight,
                                PropogationInput.PatternWidth,
                                PropogationInput.FixedStart,
                                PropogationInput.StartLeft,
                                PropogationInput.W2,
                                PropogationInput.FirstCutInCorner,
                                PropogationInput.LocalInterlock,
                                NumberOfPatterns, RemainingHeight,
                                RemainingWidth, RemainingArea, StartingLeft);

    PROPOGATION_VERTICALP2INVERTEDDIAGONAL:
      PropogateVerticalP2InvertedDiagonal(PropogationInput.UsableMaterialLength,
                                          PropogationInput.UsableMaterialWidth,
                                          PropogationInput.PatternHeight,
                                          PropogationInput.PatternWidth,
                                          PropogationInput.FixedStart,
                                          PropogationInput.StartLeft,
                                          NumberOfPatterns, RemainingHeight,
                                          RemainingWidth, RemainingArea,
                                          StartingLeft);

    PROPOGATION_FREEDIAGONAL:
      PropogateFreeDiagonal(PropogationInput.UsableMaterialLength,
                            PropogationInput.UsableMaterialWidth,
                            PropogationInput.PatternHeight,
                            PropogationInput.PatternWidth,
                            PropogationInput.FixedStart,
                            PropogationInput.StartLeft,
                            PropogationInput.W2,
                            PropogationInput.FirstCutInCorner,
                            PropogationInput.LocalInterlock,
                            PropogationInput.PackAngle,
                            NumberOfPatterns, RemainingHeight, RemainingWidth,
                            RemainingArea, StartingLeft);
  end;

  //Just in case its a big pattern relative to the material.
  //Not required very often but quick anyway.
  PostPlan(UsableMaterialLength, UsableMaterialWidth, PatWidth, StartLeft,
           dmyi1, dmy12, dmyi3, dmyr1);
end;

procedure PostPlan(UsableMaterialLength, UsableMaterialWidth, PatWidth: integer;
                   StartLeft: Boolean;
                   var NumberOfPatterns, RemainingHeight, RemainingWidth: integer;
                   var RemainingArea: real);
var
  i, j: integer;
  Valid: Boolean;
  ValidResults: array of Boolean;
  NewCutResults: TCutResult;
  NoResults: integer;
  TopPattern, leftPattern, RightPattern: integer;

begin
  //This is included to check for parts which go off the edges when the pattern
  //is a high proporation of the material size. The routines are written
  //assuming that the first couple or so columns/rows are ok. This isn't true
  //when the material is small compared to the pattern. Rather than change all
  //the existing propogation/results routines, this was added as a post check.
  //This has the advantage that it doesn't slow down normal calculations as this
  //routine will hardly ever be called. There MAY be a case when the 'best' is
  //missed due to the internal selections of each plan e.g left/right start,
  //reverse gang start etc but the end result is so unlikely to be wrong that
  //this was deemed insignificant. If this proves not to be the case then start
  //here.

  TopPattern := 99999;
  LeftPattern := 99999;
  RightPattern := -99999;

  //Decide which of Cut Results are actually valid
  setLength(ValidResults, Length(CutResults));
  NoResults := 0;
  for i := 0 to Length(CutResults) - 1 do
  begin
    Valid := True;
    if CutResults[i].BoundingRect.Top < 0 then
      Valid := False;
    if (not StartLeft) and (CutResults[i].BoundingRect.Left < 0) then
      Valid := False;
    if StartLeft and ((CutResults[i].BoundingRect.Left + PatWidth) > UsableMaterialWidth) then
      Valid := False;

    if Valid then
      inc(NoResults);

    ValidResults[i] := Valid;
  end;

  //Put Valid Results from CutResults into New copy of CutResults
  setlength(NewCutResults, NoResults);
  j := -1;
  for i := 0 to Length(CutResults) - 1 do
  begin
    if ValidResults[i] then
    begin
      inc(j);
      NewCutResults[j] := CutResults[i];

      if CutResults[i].BoundingRect.Top < TopPattern then
        TopPattern := CutResults[i].BoundingRect.Top;
      if CutResults[i].BoundingRect.Left < LeftPattern then
        LeftPattern := CutResults[i].BoundingRect.Left;
      if (CutResults[i].BoundingRect.Left + PatWidth) > RightPattern then
        RightPattern := (CutResults[i].BoundingRect.Left + PatWidth);
    end;
  end;

  //Copy New CutResults back into CutResults
  SetLength(CutResults, Length(NewCutResults));
  CutResults := copy(NewCutResults);

  NumberOfPatterns := NoResults;
  RemainingHeight := TopPattern;
  if StartLeft then
    RemainingWidth := (UsableMaterialWidth - RightPattern)
  else
    RemainingWidth := LeftPattern;
  RemainingArea := UncutArea(UsableMaterialLength, UsableMaterialWidth, RemainingHeight, RemainingWidth);
end;

end.

