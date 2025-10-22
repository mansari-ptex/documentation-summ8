unit Interlocking;

interface

//{$DEFINE DEBUGFULL}

uses Windows, SysUtils, Types, Math, Graphics, ExtCtrls, Forms, Expansion,
     Classes, ConvexHull, PolygonOverlaps, Const_Interlocking,
     General_Interlocking, FastGEO, Edges
     {$IFDEF DEBUGFULL}
     , Debugger
     {$ENDIF}
     ;

type
  TStrip = record
    Top: integer;
    Bottom: integer;
  end;
  TTakeout = record
    W2: Boolean;
    Overlap: TPolygon2D;
  end;
  TInterlock = record
    Error, Found: Boolean;
    W2: Boolean;
    Size: Real;
    Knife1BoundingRect: TRect;
    Knife2BoundingRect: TRect;
    {$IFDEF DEBUGFULL}
    ConvexHull1, ConvexHull2: TPolygon2D;
    {$ENDIF}
    Overlap: TPolygon2D;
  end;

var
  OriginalHullOverlaps: array of TTakeout;
  DisplayScale: Real;

procedure BoundAndCentre(SATRASummRaw: boolean; var PictureHeight, PictureWidth: integer; var PatternPoints, ExpandedPoints: TPointArray);
function CreatePattern(OriginalPoints: TPointArray; RotationAngle: real; Expansion: integer; SATRASummRaw, Rotate180: Boolean): TPattern;
procedure DescribePattern(Points: TPointArray; var LeftsPattern, RightsPattern: TSideEdges; var maxx, maxy: integer; No: integer);
function AddPointsEvery1(Pattern: TIntPolygon2D): TIntPolygon2D;
function FindInterlock(Knife1, Knife2, OriginalKnife: TPattern;
                       FirstInterlock, OriginalHullTakeOut: Boolean;
                       OriginalKnifeNow: TPoint;
                       Butt, StopLeft, StopRight, StopTop, StopBottom,
                       Layplanning, LayPlanSpeedUp: Boolean; InterlockZero: integer): TInterlock;
function MakeConvexHull(Points: TPointArray): TPolygon2D;
function MakeButtOctogan(Points: TPointArray): TPolygon2D;
function MakeButtSquare(Points: TPointArray): TPolygon2D;
function OverlapStrip(Strip1, Strip2: TStrip): TStrip;
procedure SpeedRotatePattern(var Knife: TPattern);
procedure SpeedRotateHull(var Hull: TPolygon2D);
procedure SpeedRotateRect(var Rect: TRect);
function OverlappingHullLeftAndRights(LeftsHull1, RightsHull1, LeftsHull2, RightsHull2: TSideEdges; x, y, WidthHull2: integer): integer;
procedure RemoveConsecutiveDuplicatePoints(var Points: TPointArray);
procedure MakeClockwise(var Pattern: TPointArray);

{$IFDEF DEBUG}
var
  TotalInOverlappingCPs, TotalInFindInterlocks, DescPatt, TotalDescs: real;
{$ENDIF}

implementation

procedure DebugFile(Knife1, Knife2, OriginalKnife: TPattern;
                    FirstInterlock, OriginalHullTakeOut: Boolean;
                    OriginalKnifeNow: TPoint;
                    Butt, StopLeft, StopRight, StopTop, StopBottom,
                    Layplanning, LayPlanSpeedUp: Boolean; InterlockZero: integer);
var
  f: TextFile;
  i: integer;
  Patt1File, Patt2File, FullFile: string;

begin
  inc(FileNumber);
  Patt1File := ExtractFilePath(Application.ExeName) + 'PattKnife1File' + IntToStr(FileNumber) + '.txt';
  AssignFile(f, Patt1File);
  Rewrite(f);
  Writeln(f, Length(Knife1.ExpandedPoints));
  for i := 0 to Length(Knife1.ExpandedPoints) - 1 do
    Writeln(f, Knife1.ExpandedPoints[i].X, ' ', Knife1.ExpandedPoints[i].Y);
  CloseFile(f);

  Patt2File := ExtractFilePath(Application.ExeName) + 'PattKnife2File' + IntToStr(FileNumber) + '.txt';
  AssignFile(f, Patt2File);
  Rewrite(f);
  Writeln(f, Length(Knife2.ExpandedPoints));
  for i := 0 to Length(Knife2.ExpandedPoints) - 1 do
    Writeln(f, Knife2.ExpandedPoints[i].X, ' ', Knife2.ExpandedPoints[i].Y);
  CloseFile(f);

  FullFile := ExtractFilePath(Application.ExeName) + 'FullFile' + IntToStr(FileNumber) + '.txt';
  AssignFile(f, FullFile);
  Rewrite(f);
  Writeln(f, Knife1.Height);
  Writeln(f, Knife1.Width);
  Writeln(f, Length(Knife1.PatternPoints));
  for i := 0 to Length(Knife1.PatternPoints) - 1 do
    Writeln(f, Knife1.PatternPoints[i].X, ' ', Knife1.PatternPoints[i].Y);
  Writeln(f, Length(Knife1.ExpandedPoints));
  for i := 0 to Length(Knife1.ExpandedPoints) - 1 do
    Writeln(f, Knife1.ExpandedPoints[i].X, ' ', Knife1.ExpandedPoints[i].Y);
  Writeln(f, Length(Knife1.ConvexHull));
  for i := 0 to Length(Knife1.ConvexHull) - 1 do
    Writeln(f, Knife1.ConvexHull[i].X, ' ', Knife1.ConvexHull[i].Y);
  Writeln(f, Length(Knife1.ButtOctogan));
  for i := 0 to Length(Knife1.ButtOctogan) - 1 do
    Writeln(f, Knife1.ButtOctogan[i].X, ' ', Knife1.ButtOctogan[i].Y);
  Writeln(f, Length(Knife1.ButtSquare));
  for i := 0 to Length(Knife1.ButtSquare) - 1 do
    Writeln(f, Knife1.ButtSquare[i].X, ' ', Knife1.ButtSquare[i].Y);
  Writeln(f, Knife1.PatternNettArea);
  Writeln(f, Knife1.ExpandedNettArea);
  Writeln(f, Knife1.ExpandedGrossArea);
  Writeln(f, Knife1.W2);
  Writeln(f);
  Writeln(f, Knife2.Height);
  Writeln(f, Knife2.Width);
  Writeln(f, Length(Knife2.PatternPoints));
  for i := 0 to Length(Knife2.PatternPoints) - 1 do
    Writeln(f, Knife2.PatternPoints[i].X, ' ', Knife2.PatternPoints[i].Y);
  Writeln(f, Length(Knife2.ExpandedPoints));
  for i := 0 to Length(Knife2.ExpandedPoints) - 1 do
    Writeln(f, Knife2.ExpandedPoints[i].X, ' ', Knife2.ExpandedPoints[i].Y);
  Writeln(f, Length(Knife2.ConvexHull));
  for i := 0 to Length(Knife2.ConvexHull) - 1 do
    Writeln(f, Knife2.ConvexHull[i].X, ' ', Knife2.ConvexHull[i].Y);
  Writeln(f, Length(Knife2.ButtOctogan));
  for i := 0 to Length(Knife2.ButtOctogan) - 1 do
    Writeln(f, Knife2.ButtOctogan[i].X, ' ', Knife2.ButtOctogan[i].Y);
  Writeln(f, Length(Knife2.ButtSquare));
  for i := 0 to Length(Knife2.ButtSquare) - 1 do
    Writeln(f, Knife2.ButtSquare[i].X, ' ', Knife2.ButtSquare[i].Y);
  Writeln(f, Knife2.PatternNettArea);
  Writeln(f, Knife2.ExpandedNettArea);
  Writeln(f, Knife2.ExpandedGrossArea);
  Writeln(f, Knife2.W2);
  Writeln(f);
  Writeln(f, OriginalKnife.Height);
  Writeln(f, OriginalKnife.Width);
  Writeln(f, Length(OriginalKnife.PatternPoints));
  for i := 0 to Length(OriginalKnife.PatternPoints) - 1 do
    Writeln(f, OriginalKnife.PatternPoints[i].X, ' ', OriginalKnife.PatternPoints[i].Y);
  Writeln(f, Length(OriginalKnife.ExpandedPoints));
  for i := 0 to Length(OriginalKnife.ExpandedPoints) - 1 do
    Writeln(f, OriginalKnife.ExpandedPoints[i].X, ' ', OriginalKnife.ExpandedPoints[i].Y);
  Writeln(f, Length(OriginalKnife.ConvexHull));
  for i := 0 to Length(OriginalKnife.ConvexHull) - 1 do
    Writeln(f, OriginalKnife.ConvexHull[i].X, ' ', OriginalKnife.ConvexHull[i].Y);
  Writeln(f, Length(OriginalKnife.ButtOctogan));
  for i := 0 to Length(OriginalKnife.ButtOctogan) - 1 do
    Writeln(f, OriginalKnife.ButtOctogan[i].X, ' ', OriginalKnife.ButtOctogan[i].Y);
  Writeln(f, Length(OriginalKnife.ButtSquare));
  for i := 0 to Length(OriginalKnife.ButtSquare) - 1 do
    Writeln(f, OriginalKnife.ButtSquare[i].X, ' ', OriginalKnife.ButtSquare[i].Y);
  Writeln(f, OriginalKnife.PatternNettArea);
  Writeln(f, OriginalKnife.ExpandedNettArea);
  Writeln(f, OriginalKnife.ExpandedGrossArea);
  Writeln(f, OriginalKnife.W2);
  Writeln(f);
  Writeln(f, FirstInterlock);
  Writeln(f, OriginalHullTakeOut);
  Writeln(f, OriginalKnifeNow.x, ' ', OriginalKnifeNow.y);
  Writeln(f, Butt);
  Writeln(f, StopLeft);
  Writeln(f, StopRight);
  Writeln(f, StopTop);
  Writeln(f, StopBottom);
  Writeln(f, Layplanning);
  Writeln(f, LayPlanSpeedUp);
  Writeln(f, InterlockZero);

  CloseFile(f);
end;

procedure BoundAndCentre(SATRASummRaw: boolean;
                         var PictureHeight, PictureWidth: integer;
                         var PatternPoints, ExpandedPoints: TPointArray);
var
  i, j, minx, miny, maxx, maxy: integer;
  PatternPoints1, ExpandedPoints1: TPointArray;

begin
  if SATRASummRaw then
  begin
    SetLength(PatternPoints1, Length(PatternPoints));
    SetLength(ExpandedPoints1, Length(ExpandedPoints));
  end;

  PictureHeight := 0;
  PictureWidth := 0;

  maxx := -99999999;
  maxy := -99999999;
  minx := 99999999;
  miny := 99999999;

  for i := 0 to Length(ExpandedPoints) - 1 do
  begin
    if ExpandedPoints[i].x < minx then
      minx := ExpandedPoints[i].x;
    if ExpandedPoints[i].y < miny then
      miny := ExpandedPoints[i].y;
    if ExpandedPoints[i].x > maxx then
      maxx := ExpandedPoints[i].x;
    if ExpandedPoints[i].y > maxy then
      maxy := ExpandedPoints[i].y;
  end;

  j := Length(PatternPoints);
  for i := 0 to Length(PatternPoints) - 1 do
  begin
    if SATRASummRaw then
    begin
      dec(j);
      PatternPoints1[j].x := PatternPoints[i].x - minx;
      PatternPoints1[j].y := abs(maxy - miny) - (PatternPoints[i].y - miny);     //orientates pattern correctly
    end
    else
    begin
      PatternPoints[i].x := PatternPoints[i].x - minx;
      PatternPoints[i].y := PatternPoints[i].y - miny;
    end;
  end;

  j := Length(ExpandedPoints);
  for i := 0 to Length(ExpandedPoints) - 1 do
  begin
    if SATRASummRaw then
    begin
      dec(j);
      ExpandedPoints1[j].x := ExpandedPoints[i].x - minx;
      ExpandedPoints1[j].y := abs(maxy - miny) - (ExpandedPoints[i].y - miny);   //orientates pattern correctly
    end
    else
    begin
      ExpandedPoints[i].x := ExpandedPoints[i].x - minx;
      ExpandedPoints[i].y := ExpandedPoints[i].y - miny;

      if ExpandedPoints[i].x > PictureWidth then
        PictureWidth := ExpandedPoints[i].x;
      if ExpandedPoints[i].y > PictureHeight then
        PictureHeight := ExpandedPoints[i].y;
    end;
  end;

  if SATRASummRaw then
  begin
    for i := 0 to Length(PatternPoints) - 1 do
    begin
      PatternPoints[i].x := PatternPoints1[i].x;
      PatternPoints[i].y := PatternPoints1[i].y;
    end;

    for i := 0 to Length(ExpandedPoints) - 1 do
    begin
      ExpandedPoints[i].x := ExpandedPoints1[i].x;
      ExpandedPoints[i].y := ExpandedPoints1[i].y;

      if ExpandedPoints[i].x > PictureWidth then
        PictureWidth := ExpandedPoints[i].x;
      if ExpandedPoints[i].y > PictureHeight then
        PictureHeight := ExpandedPoints[i].y;
    end;
  end;

  RemoveConsecutiveIndenticalPoints(PatternPoints);
  RemoveConsecutiveIndenticalPoints(ExpandedPoints);
end;

function CreatePattern(OriginalPoints: TPointArray; RotationAngle: real; Expansion: integer; SATRASummRaw, Rotate180: Boolean): TPattern;
var
  PatternPoints, ExpandedPoints: TPointArray;
  i: integer;
  PictureHeight, PictureWidth: integer;

begin
  if SATRASummRaw then
  begin
  //Filter Loops
    if (Length(OriginalPoints) > 3) then
      EliminatePatternLoops(OriginalPoints);
    RemoveConsecutiveDuplicatePoints(OriginalPoints);
    {$IFDEF DEBUGFULL}
      if Assigned(fmDebugger) then fmDebugger.DrawPointsB4Clockwise(OriginalPoints);
    {$ENDIF}
    MakeClockwise(OriginalPoints);
    {$IFDEF DEBUGFULL}
      if Assigned(fmDebugger) then fmDebugger.DrawPointsAfterClockwise(OriginalPoints);
    {$ENDIF}
  end;

  //Create PatternPoints
  SetLength(PatternPoints, Length(OriginalPoints));
  SetLength(ExpandedPoints, Length(OriginalPoints));
  for i := 0 to Length(OriginalPoints) - 1 do
  begin
    PatternPoints[i] := OriginalPoints[i];
    ExpandedPoints[i] := OriginalPoints[i];
  end;

  if SATRASummRaw and (Length(OriginalPoints) > 3) then
    EliminatePatternLoops(PatternPoints);

  //Expand Pattern and create 'ExpandedPoints'
  //which is what is used for all the interlocking
  if not(Expansion = 0) and (Length(OriginalPoints) > 0) then
    ExpandPattern(PatternPoints, ExpandedPoints, Expansion);

//  {$IFDEF DEBUGFULL}
//  fmDebugger.DrawExpansions(PatternPoints, ExpandedPoints, True);
//  {$ENDIF}

  //Shrink pattern
  if SATRASummRaw then
  begin
    for i := 0 to Length(PatternPoints) - 1 do
    begin
      PatternPoints[i].x := PatternPoints[i].x div PATTERNRES;
      PatternPoints[i].y := PatternPoints[i].y div PATTERNRES;
    end;

    for i := 0 to Length(ExpandedPoints) - 1 do
    begin
      ExpandedPoints[i].x := ExpandedPoints[i].x div PATTERNRES;
      ExpandedPoints[i].y := ExpandedPoints[i].y div PATTERNRES;
    end;
  end;

  //Rotate pattern
  RotatePattern(RotationAngle, PatternPoints);
  RotatePattern(RotationAngle, ExpandedPoints);

  if SATRASummRaw then
  begin
    RemoveConsecutiveDuplicatePoints(PatternPoints);
    RemoveConsecutiveDuplicatePoints(ExpandedPoints);
  end;

  {$IFDEF DEBUGFULL}
  if Assigned(fmDebugger) then fmDebugger.DrawExpansions(PatternPoints, ExpandedPoints);
  {$ENDIF}

  //Filter Loops
  if SATRASummRaw and (Length(OriginalPoints) > 3) then
    EliminatePatternLoops(ExpandedPoints);

  {$IFDEF DEBUGFULL}
  if Assigned(fmDebugger) then fmDebugger.DrawLoopsGone(ExpandedPoints);
  {$ENDIF}

  //Make W2
  if Rotate180 then
  begin
    for i := 0 to Length(PatternPoints) - 1 do
    begin
      PatternPoints[i].x := -PatternPoints[i].x;
      PatternPoints[i].y := -PatternPoints[i].y;
    end;

    for i := 0 to Length(ExpandedPoints) - 1 do
    begin
      ExpandedPoints[i].x := -ExpandedPoints[i].x;
      ExpandedPoints[i].y := -ExpandedPoints[i].y;
    end;
  end;

  //Shift it
  BoundAndCentre(SATRASummRaw, PictureHeight, PictureWidth, PatternPoints, ExpandedPoints);

  Result.Height := PictureHeight;
  Result.Width := PictureWidth;
  Result.PatternPoints := PatternPoints;
  Result.ExpandedPoints := ExpandedPoints;
  Result.ConvexHull := MakeConvexHull(ExpandedPoints);
  Result.ButtOctogan := MakeButtOctogan(ExpandedPoints);
  Result.ButtSquare := MakeButtSquare(ExpandedPoints);

  //Close Shapes for NettArea Calculations (Must not be returned 'closed')
  setlength(PatternPoints, length(PatternPoints) + 1);
  PatternPoints[length(PatternPoints) - 1] := PatternPoints[0];
  setlength(ExpandedPoints, length(ExpandedPoints) + 1);
  ExpandedPoints[length(ExpandedPoints) - 1] := ExpandedPoints[0];

  //We don't need Pattern Gross Area as there is nowhere that it is ever used.
  //If there is no cutgap, the Expanded Gross Area will obviously be the same.
  //In the current SATRASumm Assess routines, Leathers have no cutgap and so
  //that is fine. For LEGACY Synthetics we always stored the Expanded Nett &
  //Gross areas anyway and so again, that is essential for compatibility.
  Result.PatternNettArea := PolyArea(ConvertTPointArray_TPolygon2D(PatternPoints)) / ((1000 div PATTERNRES) * (1000 div PATTERNRES) * 144);
  Result.ExpandedNettArea := PolyArea(ConvertTPointArray_TPolygon2D(ExpandedPoints)) / ((1000 div PATTERNRES) * (1000 div PATTERNRES) * 144);
  Result.ExpandedGrossArea := PolyArea(Result.ConvexHull) / ((1000 div PATTERNRES) * (1000 div PATTERNRES) * 144);
  Result.W2 := Rotate180;
end;

procedure DescribePattern(Points: TPointArray; var LeftsPattern, RightsPattern: TSideEdges; var maxx, maxy: integer; No: integer);
var
  Pattern: TIntPolygon2D;
  i, x, y: integer;

begin
  setLength(Pattern, Length(Points));

  //Find bounding rect of knife (It is already at 0, 0)
  maxx := -999999;
  maxy := -999999;

  for i := 0 to Length(Points) - 1 do
  begin
    x := Points[i].x;
    y := Points[i].y;

    if x > maxx then
      maxx := x;
    if y > maxy then
      maxy := y;

    Pattern[i].x := x;
    Pattern[i].y := y;
  end;

  //Add extra points into Pattern
  Pattern := AddPointsEvery1(Pattern);

  //Find the Edges of the Pattern
  FindEdges(Pattern, LeftsPattern, RightsPattern, maxy);

  {$IFDEF DEBUGFULL}
  if Assigned(fmDebugger) then fmDebugger.DrawEdges(Pattern, LeftsPattern, RightsPattern, No);
  {$ENDIF}
end;

function AddPointsEvery1(Pattern: TIntPolygon2D): TIntPolygon2D;
var
  PatternOut: TIntPolygon2D;
  i, j, j2, i1, i2, k: integer;
  yA: double;
  xDiff, yDiff: double;
  m, c, xB, yB: double;
  NextOut: integer;

begin
  //Check for Duplicate Points
  {$IFDEF DEBUGFULL}
  if Assigned(fmDebugger) then fmDebugger.CheckForDuplicatePoints(Pattern, 'AddPointsEvery1 IN');
  {$ENDIF}

  //Don't allow closed shape as FindEdges expects pattern to have different first and last point.
  if (Pattern[0].x = Pattern[Length(Pattern) - 1].x) and (Pattern[0].y = Pattern[Length(Pattern) - 1].y) then
    k := Length(Pattern) - 2
  else
    k := Length(Pattern) - 1;

  NextOut := -1;
  for j := 0 to k do
  begin
    //Find next point
    j2 := j + 1;
    if j2 > k then
      j2 := 0;

    i1 := Pattern[j].y;
    i2 := Pattern[j2].y;
    i := i1;
    while abs(i - i2) > 1 do
    begin
      if (i1 > i2) then
        dec(i)
      else if (i1 < i2) then
        inc(i);

      yA := i;

      //Find pairs of points in Pattern which are intersected by line y = yA
      if ((Pattern[j].Y > yA) and (Pattern[j2].Y < yA)) or
         ((Pattern[j].Y < yA) and (Pattern[j2].Y > yA)) then
      begin
        //Equation of line from jth to j2th points in Pattern B
        xDiff := Pattern[j].X - Pattern[j2].X;
        yDiff := Pattern[j].Y - Pattern[j2].Y;
        if XDiff <> 0 then
          m := yDiff / xDiff
        else
          m := 99999999999999;
        c := Pattern[j].Y - (m * Pattern[j].X);

        //Intersection of above line with line y = yA
        yB := yA;
        xB := (yB - c) / m;

        //Insert point
        inc(NextOut);
        setlength(PatternOut, NextOut + 1);
        PatternOut[NextOut].X := round(xB);
        PatternOut[NextOut].Y := round(yB);
      end;
    end;

    //Insert Second Original point
    inc(NextOut);
    setlength(PatternOut, NextOut + 1);
    PatternOut[NextOut].X := Pattern[j2].x;
    PatternOut[NextOut].Y := Pattern[j2].y;
  end;

  //Check for Duplicate Points
  {$IFDEF DEBUGFULL}
  if Assigned(fmDebugger) then fmDebugger.CheckForDuplicatePoints(PatternOut, 'AddPointsEvery1 OUT');
  {$ENDIF}

  Result := PatternOut;
end;

function Distance(x1, y1, x2, y2: TFloat): TFloat;
var
  dx, dy: TFloat;

begin
  dx := x2 - x1;
  dy := y2 - y1;
  Result := Sqrt(dx * dx + dy * dy);
end;

function Overlapping(Hull, Shape: TPolygon2D): boolean;
var
  i: integer;

begin
  i := -1;
  Result := False;
  while not((i = Length(Shape) - 1) or Result) do
  begin
    inc(i);
    Result := PointInAndOnPolygon(Shape[i].x, Shape[i].y, Hull);
  end;
end;

function FindInterlock(Knife1, Knife2, OriginalKnife: TPattern;
                       FirstInterlock, OriginalHullTakeOut: Boolean;
                       OriginalKnifeNow: TPoint;
                       Butt, StopLeft, StopRight, StopTop, StopBottom,
                       Layplanning, LayPlanSpeedUp: Boolean; InterlockZero: integer): TInterlock;
var
  Pattern1, Pattern2: array of array of integer;
  LeftsPattern1, RightsPattern1: TSideEdges;
  LeftsPattern2, RightsPattern2: TSideEdges;
  PatternMaxX1, PatternMaxY1, PatternMaxX2, PatternMaxY2: integer;
  LeftsHull1, RightsHull1: TSideEdges;
  LeftsHull2, RightsHull2: TSideEdges;
  HullMaxX1, HullMaxY1: integer;
  HullMaxX2, HullMaxY2: integer;
  ConvexHullKnife1, ConvexHullKnife2, ConvexHull1, ConvexHull2, ConvexHull0, ConvexHulln, Shape2: TPolygon2D;
  APoint: TPoint2D;
  Knife1Rect: TRect;
  Strip1, Strip2, StripInStrip1, StripInStrip2: TStrip;
  TotalTries: integer;
  BestInterlock: TInterlock;
  y, x: integer;
  StripLastX, xMoveRight, Dist: integer;
  i, j, k, i2, j2: integer;
  FirstY, LastY, FirstX, LastX: integer;
  NoPossibleXs, StartingX, PossibleX: integer;
  IndexPattern1, IndexPattern2: integer;
  PossibleXs: array of integer;
  Shunt: Boolean;
  HighDist: integer;
  ThisInterlock, CorrectOverlapCheck, ThisMiniInterlock, BestThisMiniInterlock: Real;
  OriginalRect, InterlockRect, NewRect: TRect;
  APoint2 : TPoint2D;
  HullOverlap: TOverlap;
  OverlappingTakeOuts: Boolean;
  MovedOverlap: TPolygon2D;
  LeftEdge, RightEdge: integer;
  YsInUsePattern1, YsInUsePattern2: array of Boolean;
  SpeedRotate: Boolean;
  HoldStopLeft, HoldStopRight, HoldStopTop, HoldStopBottom: Boolean;
  LastPossibleX: integer;
  AddExtraPointAtFirstX, AddExtraPointAtLastX: Boolean;
  {$IFDEF DEBUG}
  FITickCount, OCPTickCount: real;
  {$ENDIF}
  CheckInterpolatedPoints, Finished: Boolean;
  Error: Boolean;

begin
  //Note 64 bit appears to initialise to True whereas 32 bit initialises
  //to false. Without this line 64 bit version always fails.
  BestInterlock.Error := False;

  {$IFDEF DEBUG}
  FITickCount := GetTickCount;
  if (FileNumber > -1) then
    DebugFile(Knife1, Knife2, OriginalKnife, FirstInterlock, OriginalHullTakeOut, OriginalKnifeNow,
              Butt, StopLeft, StopRight, StopTop, StopBottom, Layplanning, LayPlanSpeedUp, InterlockZero);
  {$ENDIF}

  //NOTE: Following speeds it up on W1 but ONLY
  //allowed if interlocking with itself.
  //
  //If W1 then we only need to go halfway down as
  //any interlocks will be found one way around or the other by then.
  if Layplanning and (Knife1.Height = Knife2.Height) and (Knife1.width = Knife2.width) then
  begin
    if (not Knife2.W2) and (not StopTop) and (not StopBottom) then
      StopBottom := True;
  end;

  SpeedRotate := LayPlanSpeedUp and (Knife1.Height > Knife1.Width);
  if SpeedRotate then
  begin
    SpeedRotatePattern(Knife1);
    SpeedRotatePattern(Knife2);

    HoldStopLeft := StopLeft;
    HoldStopRight := StopRight;
    HoldStopTop := StopTop;
    HoldStopBottom := StopBottom;

    StopLeft := HoldStopTop;
    StopRight := HoldStopBottom;
    StopTop := HoldStopLeft;
    StopBottom := HoldStopRight;
  end;

  //Describe Patterns
  //This returns PatternMaxX and PatternMaxY. Note:
  //PatternWidth = PatternMaxX + 1 as pattern goes from 0...PatternMaxX
  //PatternHeight = PatternMaxY + 1 as pattern goes from 0...PatternMaxY
  {$IFDEF DEBUG}
  DescPatt := GetTickCount;
  {$ENDIF}
  DescribePattern(Knife1.ExpandedPoints, LeftsPattern1, RightsPattern1, PatternMaxX1, PatternMaxY1, 1);
  DescribePattern(Knife2.ExpandedPoints, LeftsPattern2, RightsPattern2, PatternMaxX2, PatternMaxY2, 2);

  //Check for errors in Describing patterns - show up when #Lefts <> #Rights
  Error := False;
  j := -1;
  while (not Error) and (j <> Length(LeftsPattern1) - 1) do
  begin
    inc(j);

    if LeftsPattern1[j, 0] <> RightsPattern1[j, 0] then
      Error := True;
  end;
  j := -1;
  while (not Error) and (j <> Length(LeftsPattern2) - 1) do
  begin
    inc(j);

    if LeftsPattern2[j, 0] <> RightsPattern2[j, 0] then
      Error := True;
  end;

  if not Error then
  begin
    {$IFDEF DEBUG}
    DescPatt := GetTickCount - DescPatt;
    TotalDescs := TotalDescs + DescPatt;
    {$ENDIF}

    {$IFDEF DEBUGFULL}
    CheckInterlockCall(Butt, StopLeft, StopRight, StopTop, StopBottom,
                       PatternMaxX1 + 1, PatternMaxY1 + 1, PatternMaxX2 + 1, PatternMaxY2 + 1);
    {$ENDIF}

    //Find Y's on Patterns that are in use
    setLength(YsInUsePattern1, PatternMaxY1 + 1);
    setLength(YsInUsePattern2, PatternMaxY2 + 1);
    for i := 0 to Length(YsInUsePattern1) - 1 do
      YsInUsePattern1[i] := False;
    for i := 0 to Length(YsInUsePattern2) - 1 do
      YsInUsePattern2[i] := False;
    for i := 0 to Length(Knife1.ExpandedPoints) - 1 do
      YsInUsePattern1[Knife1.ExpandedPoints[i].y] := True;
    for i := 0 to Length(Knife2.ExpandedPoints) - 1 do
      YsInUsePattern2[Knife2.ExpandedPoints[i].y] := True;

    //Convex Hulls
    if not Butt then
    begin
      ConvexHullKnife1 := Knife1.ConvexHull;
      ConvexHullKnife2 := Knife2.ConvexHull;
    end
    else
    begin
      if not Layplanning then
      begin
        ConvexHullKnife1 := Knife1.ButtOctogan;
        ConvexHullKnife2 := Knife2.ButtOctogan;
      end
      else
      begin
        ConvexHullKnife1 := Knife1.ButtSquare;
        ConvexHullKnife2 := Knife2.ButtSquare;
      end
    end;
    SetLength(ConvexHull1, length(ConvexHullKnife1));
    SetLength(ConvexHull2, length(ConvexHullKnife2));
    APoint.x := PatternMaxX2;
    APoint.y := PatternMaxY2;
    ConvexHull1 := Translate(APoint, ConvexHullKnife1);
    if not FirstInterlock then
    begin
      APoint.x := APoint.x + OriginalKnifeNow.x;
      APoint.y := APoint.y + OriginalKnifeNow.y;
    end;
    ConvexHull0 := Translate(APoint, OriginalKnife.ConvexHull);

    //Initial Bounding Rect for Knife1
    Knife1Rect.Left := PatternMaxX2;
    Knife1Rect.Top := PatternMaxY2;
    Knife1Rect.Right := PatternMaxX2 + PatternMaxX1;
    Knife1Rect.Bottom := PatternMaxY2 + PatternMaxY1;

    TotalTries := 0;
    FirstY := 1;                                     //Wont want to do the 0's as they will miss
    LastY := (PatternMaxY2 + PatternMaxY1) - 1;      //Same at other end......(4 Directions)

    if StopTop then
      FirstY := (FirstY - 1) + PatternMaxY2;
    if StopBottom then
      LastY := (LastY + 1) - PatternMaxY2;

    BestInterlock.Error := False;  //CJY - Unset boolean var 32bit True/64bit False initialisation issue
    BestInterlock.Found := False;
    BestInterlock.W2 := Knife2.W2;
    BestInterlock.Size := -1;
    {$IFDEF DEBUGFULL}
    BestInterlock.ConvexHull1 := ConvexHull1;
    BestInterlock.ConvexHull2 := ConvexHull2;
    {$ENDIF}

    //Describe Hulls (Currently only for layplanning because not yet finished)
    if Layplanning then
    begin
      DescribePattern(ConvertTPolygon2D_TPointArray(ConvexHullKnife1), LeftsHull1, RightsHull1, HullMaxX1, HullMaxY1, 1);
      DescribePattern(ConvertTPolygon2D_TPointArray(ConvexHullKnife2), LeftsHull2, RightsHull2, HullMaxX2, HullMaxY2, 2);
    end;

    y := FirstY;
    while y <= LastY do
    begin
      //Calculate First and Last Xs that we are allowed to consider,
      //they will be different if stoppers are used.
      FirstX := 0;
      LastX := PatternMaxX2 + PatternMaxX1;
      if StopLeft then
        FirstX := FirstX + PatternMaxX2;
      if StopRight then
        LastX := LastX - PatternMaxX2;

      AddExtraPointAtFirstX := False;
      AddExtraPointAtLastX := False;

      //Find intersecting Strip
      Strip1.Top := Knife1Rect.Top;
      Strip1.Bottom := Knife1Rect.Bottom;
      Strip2.Top := y;
      Strip2.Bottom := y + PatternMaxY2;

      StripInStrip1 := OverlapStrip(Strip1, Strip2);
      StripInStrip2 := OverlapStrip(Strip2, Strip1);

      //Find Last X for this strip
      xMoveRight := 99999999;
      j := StripInStrip1.Top;
      while (j <= StripInStrip1.Bottom) do
      begin
        j2 := StripInStrip2.Top + (j - StripInStrip1.Top);

        i := RightsPattern1[j, RightsPattern1[j, 0]];
        i2 := LeftsPattern2[j2, 1];
        Dist := ((i2 + PatternMaxX2) - i) - 1;
        if Dist < xMoveRight then
          xMoveRight := Dist;

        j := j + 1;
      end;
      StripLastX := (PatternMaxX2 + PatternMaxX1) - XMoveRight;

      //Find Possible X's for this strip
      NoPossibleXs := 0;
      setlength(PossibleXs, NoPossibleXs);

      x := 0;
      while x <= StripLastX do
      begin
        StartingX := x;
        PossibleX := 99999999;

        j := StripInStrip1.Top;
        while (j <= StripInStrip1.Bottom) do
        begin
          j2 := StripInStrip2.Top + (j - StripInStrip1.Top);

          //Only Check on actual points
          for IndexPattern1 := 1 to LeftsPattern1[j, 0] do
          begin
            i := LeftsPattern1[j, IndexPattern1];

            for IndexPattern2 := 1 to RightsPattern2[j2, 0] do
            begin
              i2 := RightsPattern2[j2, IndexPattern2] + StartingX;

              Dist := ((i + PatternMaxX2) - i2);
              if (Dist >= 0) and (Dist < PossibleX) then
                PossibleX := Dist;
            end;
          end;

          j := j + 1;
        end;

        //Check Possible Point Found
        if PossibleX <> 99999999 then
        begin
          //If the 'Stopper' boundaries do not overlap i.e. they are valid positions
          //even if they do not necessarily touch in x, add them to the array of
          //possible x positions. This is just for x stoppers as we do not care
          //about y ones as they are taken care of elsewhere.
          if NoPossibleXs = 0 then
            LastPossibleX := 0
          else
            LastPossibleX := PossibleXs[NoPossibleXs - 1];
          PossibleX := PossibleX + StartingX;

          if StopLeft and (LastPossibleX < FirstX) and (PossibleX > FirstX) then
            AddExtraPointAtFirstX := True;
          if StopRight and (LastPossibleX < LastX) and (PossibleX > LastX) then
            AddExtraPointAtLastX := True;

          inc(NoPossibleXs);
          setlength(PossibleXs, NoPossibleXs);
          PossibleXs[NoPossibleXs - 1] := PossibleX;

          //Into the shape...
          inc(PossibleX);

          //...& drag through
          //Now we do this twice. First, for speed, with just the Actual points.
          //Once there is no possible shunt, do it once more with all the
          //interpolated points to make sure that there are no overlaps.
          //If this produces a shunt, continue again with the actual points and
          //repeat.
          CheckInterpolatedPoints := False;
          Finished := False;
          Shunt := True;
          while not Finished do
          begin
            Shunt := False;
            HighDist := 0;
            j := StripInStrip1.Top;
            while (j <= StripInStrip1.Bottom) do
            begin
              j2 := StripInStrip2.Top + (j - StripInStrip1.Top);

              //Only Check on actual points UNLESS Interpolated points option
              if CheckInterpolatedPoints or YsInUsePattern1[j] or YsInUsePattern2[j2] then
              begin
                for IndexPattern1 := 1 to LeftsPattern1[j, 0] do
                begin
                  for IndexPattern2 := 1 to RightsPattern2[j2, 0] do
                  begin
                    if ((RightsPattern2[j2, IndexPattern2] + PossibleX) >=
                        (LeftsPattern1[j, IndexPattern1] + PatternMaxX2)) and
                       ((LeftsPattern2[j2, IndexPattern2] + PossibleX) <=
                        (RightsPattern1[j, IndexPattern1] + PatternMaxX2)) then
                    begin
                      i := RightsPattern1[j, IndexPattern1];
                      i2 := LeftsPattern2[j2, IndexPattern2] + PossibleX;
                      Dist := ((i + PatternMaxX2) - i2) + 1;
                      if Dist > HighDist then
                      begin
                        Shunt := True;
                        HighDist := Dist;
                      end;
                    end;
                   //This code commented out will output a file which can be read by my debugging 'Drawer' program to help
                   //find problems if we get more range check errors (which usually originate in merge). Get rid of it
                   //once we're not having these problems anymore.
                  end;
                end;
              end;

              //Must Check EVERY line whether its the REAL points or the
              //INTERPOLATEDPOINTS (Previously did every 2nd one of these (all
              //that was necessary since PATTERRES became 10 not 20), always had
              //to do EVERY real one.
              inc(j);
            end;

            PossibleX := PossibleX + HighDist;

            //Decide on mode to carry on
            if (not Shunt) then
            begin
              if (not CheckinterpolatedPoints) then
                CheckInterpolatedPoints := True
              else
                Finished := True;
            end
            else
              CheckInterpolatedPoints := False;

          end;

          inc(NoPossibleXs);
          setlength(PossibleXs, NoPossibleXs);
          PossibleXs[NoPossibleXs - 1] := PossibleX;
        end;

        x := PossibleX;
      end;

      //Check if we should add an extra point at a stopper
      //Note: They could also have been added above if they
      //were in valid gaps
      if StopLeft and (PossibleXs[NoPossibleXs - 1] < FirstX) then
        AddExtraPointAtFirstX := True;
      if StopRight and (PossibleXs[0] > LastX) then
        AddExtraPointAtLastX := True;

      //Add Extra PossibleXs if applicable, checking that we haven't
      //just added the same point in second case which would be true
      //if FirstX = LastX and AddExtraPointAtFirstX is true
      if AddExtraPointAtFirstX then
      begin
        //Note these MAY be floating but BEST should touch in Y
        inc(NoPossibleXs);
        setlength(PossibleXs, NoPossibleXs);
        PossibleXs[NoPossibleXs - 1] := FirstX;
      end;
      if AddExtraPointAtLastX and (PossibleXs[NoPossibleXs - 1] <> LastX) then
      begin
        //Note these MAY be floating but BEST should touch in Y
        inc(NoPossibleXs);
        setlength(PossibleXs, NoPossibleXs);
        PossibleXs[NoPossibleXs - 1] := LastX;
      end;

      //Try all the Possible x positions
      TotalTries := TotalTries + NoPossibleXs;
      for i := 1 to NoPossibleXs do
      begin
        x := PossibleXs[i - 1];

        if (x >= FirstX) and (x <= LastX) then
        begin
          APoint.x := x;
          APoint.y := y;
          ConvexHull2 := Translate(APoint, ConvexHullKnife2);

          if OriginalHullTakeOut then
          begin
            OverlappingTakeOuts := False;
            for j := 0 to Length(OriginalHullOverlaps) - 1 do
            begin
              if (Knife2.W2 = OriginalHullOverlaps[j].W2) and (not OverlappingTakeouts) then
              begin
                //The overlaps transposed onto this shape
                //Compare this with original shape
                APoint2.x := x - OriginalKnifeNow.x;
                APoint2.y := y - OriginalKnifeNow.y;
                MovedOverlap := Translate(APoint2, OriginalHullOverlaps[j].Overlap);

                {$IFDEF DEBUG}
                OCPTickCount := GetTickCount;
                {$ENDIF}

                if OverlappingConvexPolygon(ConvexHull0, MovedOverlap).Overlap then
                  OverlappingTakeouts := True;

                {$IFDEF DEBUG}
                OCPTickCount := GetTickCount - OCPTickCount;
                TotalInOverlappingCPs := TotalInOverlappingCPs + OCPTickCount;
                {$ENDIF}
              end;
            end;

            if OverlappingTakeouts then
              ThisInterlock := 0
            else
            begin
              //Knife2 MUST overlap ConvexHull0
              Shape2 := Translate(APoint, ConvertTPointArray_TPolygon2D(Knife2.ExpandedPoints));

              if not Overlapping(ConvexHull0, Shape2) then
                ThisInterlock := 0
              else
              begin
                {$IFDEF DEBUG}
                OCPTickCount := GetTickCount;
                {$ENDIF}

                //Always look for the overlaps of the 2 hulls - we can't look
                //at one shape and original hull as it is not always the same.
                HullOverlap := OverlappingConvexPolygon(ConvexHull0, ConvexHull2);
                ThisInterlock := HullOverlap.Area;

                {$IFDEF DEBUG}
                OCPTickCount := GetTickCount - OCPTickCount;
                TotalInOverlappingCPs := TotalInOverlappingCPs + OCPTickCount;
                {$ENDIF}

              end;
            end;
          end
          else
          begin
            {$IFDEF DEBUG}
            OCPTickCount := GetTickCount;
            {$ENDIF}

            //Original way of measuring area. Leave for reference
            //until this method totally replaced above too.
            //HullOverlap := OverlappingConvexPolygon(ConvexHull1, ConvexHull2);
            //ThisInterlock := HullOverlap.Area;
            ThisInterlock := OverlappingHullLeftAndRights(LeftsHull1, RightsHull1, LeftsHull2, RightsHull2, x, y, PatternMaxX2);

            {$IFDEF DEBUG}
            OCPTickCount := GetTickCount - OCPTickCount;
            TotalInOverlappingCPs := TotalInOverlappingCPs + OCPTickCount;
            {$ENDIF}
          end;

          //Keep biggest interlock
          if (ThisInterlock >= BestInterlock.Size) then
          begin
            BestInterlock.Found := True;
            BestInterlock.Size := ThisInterlock;
            BestInterlock.Knife1BoundingRect.Left := Knife1Rect.Left;
            BestInterlock.Knife1BoundingRect.Top := Knife1Rect.Top;
            BestInterlock.Knife1BoundingRect.Right := Knife1Rect.Right;
            BestInterlock.Knife1BoundingRect.Bottom := Knife1Rect.Bottom;
            BestInterlock.Knife2BoundingRect.Left := x;
            BestInterlock.Knife2BoundingRect.Top := y;
            BestInterlock.Knife2BoundingRect.Right := x + PatternMaxX2;
            BestInterlock.Knife2BoundingRect.Bottom := y + PatternMaxY2;
            if not Layplanning then
              BestInterlock.Overlap := HullOverlap.Polygon; //Hull on Original Hull
          end;
        end;
      end;

      //Check every other line (all that is necesary since PATTERRES
      //became 10 not 20). Ensure that we check the very bottom line.
      if y = Lasty then
        inc(y)
      else if (Lasty - y) <= 2 then
        y := Lasty
      else
        y := y + 2;
    end;

    if (not Butt) and BestInterlock.Found and (BestInterlock.Size <= InterlockZero) then
    begin
      BestInterlock.Found := False;
      BestInterlock.Size := 0;
    end;

    if Butt and (not BestInterlock.Found) then
    begin
      BestInterlock.Found := True;
      BestInterlock.Size := 0;
      BestInterlock.Knife1BoundingRect.Left := Knife1Rect.Left;
      BestInterlock.Knife1BoundingRect.Top := Knife1Rect.Top;
      BestInterlock.Knife1BoundingRect.Right := Knife1Rect.Right;
      BestInterlock.Knife1BoundingRect.Bottom := Knife1Rect.Bottom;
      if (StopLeft and StopRight) then
      begin
        if not StopTop then
        begin
          BestInterlock.Knife2BoundingRect.Left := Knife1Rect.Left;
          BestInterlock.Knife2BoundingRect.Top := Knife1Rect.Top - PatternMaxY2;
          BestInterlock.Knife2BoundingRect.Right := Knife1Rect.Right;
          BestInterlock.Knife2BoundingRect.Bottom := Knife1Rect.Top - 1;
        end
        else
        begin
          BestInterlock.Knife2BoundingRect.Left := Knife1Rect.Left;
          BestInterlock.Knife2BoundingRect.Top := Knife1Rect.Bottom + 1;
          BestInterlock.Knife2BoundingRect.Right := Knife1Rect.Right;
          BestInterlock.Knife2BoundingRect.Bottom := Knife1Rect.Bottom + PatternMaxY2;
        end;
      end
      else if (StopTop and StopBottom) then
      begin
        if not StopLeft then
        begin
          BestInterlock.Knife2BoundingRect.Left := Knife1Rect.Left - PatternMaxX2;
          BestInterlock.Knife2BoundingRect.Top := Knife1Rect.Top;
          BestInterlock.Knife2BoundingRect.Right := Knife1Rect.Left - 1;
          BestInterlock.Knife2BoundingRect.Bottom := Knife1Rect.Bottom;
        end
        else
        begin
          BestInterlock.Knife2BoundingRect.Left := Knife1Rect.Right + 1;
          BestInterlock.Knife2BoundingRect.Top := Knife1Rect.Top;
          BestInterlock.Knife2BoundingRect.Right := Knife1Rect.Right + PatternMaxX2;
          BestInterlock.Knife2BoundingRect.Bottom := Knife1Rect.Bottom;
        end;
      end;
      BestInterlock.Overlap := nil;
    end;

    {$IFDEF DEBUGFULL}
    x := BestInterlock.Knife2BoundingRect.Left;
    y := BestInterlock.Knife2BoundingRect.Top;
    ThisInterlock := OverlappingHullLeftAndRights(LeftsHull1, RightsHull1, LeftsHull2, RightsHull2, x, y, PatternMaxX2);
    if Assigned(fmDebugger) then fmDebugger.DrawOverlappingHullLeftAndRights(LeftsHull1, RightsHull1, LeftsHull2, RightsHull2, x, y, PatternMaxX2);
    {$ENDIF}

    //Convert to Square Feet
    BestInterlock.Size := BestInterlock.Size / ((1000 div PATTERNRES) * (1000 div PATTERNRES) * 144);

    if SpeedRotate then
    begin
      SpeedRotatePattern(Knife1);
      SpeedRotatePattern(Knife2);

      {$IFDEF DEBUGFULL}
      SpeedRotateHull(BestInterlock.ConvexHull1);
      SpeedRotateHull(BestInterlock.ConvexHull2);
      {$ENDIF}

      SpeedRotateRect(BestInterlock.Knife1BoundingRect);
      SpeedRotateRect(BestInterlock.Knife2BoundingRect);
    end;
  end
  else
  begin
    BestInterlock.Error := True;
    if (FileNumber > -1) then
    begin
      FileNumber := 99999;
      {$IFDEF DEBUG}
      DebugFile(Knife1, Knife2, OriginalKnife, FirstInterlock, OriginalHullTakeOut, OriginalKnifeNow,
        Butt, StopLeft, StopRight, StopTop, StopBottom, Layplanning, LayPlanSpeedUp, InterlockZero);
      {$ENDIF}
    end;
  end;

  Result := BestInterlock;

  {$IFDEF DEBUG}
  FITickCount := GetTickCount - FITickCount;
  TotalInFindInterlocks := TotalInFindInterlocks + FITickCount;
  if (FileNumber = -1) then
    if Assigned(fmDebugger) then
      fmDebugger.DrawInterlocked(Knife1.ExpandedPoints, Knife2.ExpandedPoints, BestInterlock.Knife1BoundingRect,
                           BestInterlock.Knife2BoundingRect, LeftsPattern1, RightsPattern1, LeftsPattern2,
                           RightsPattern2);
  {$ENDIF}
end;

function MakeConvexHull(Points: TPointArray): TPolygon2D;
var
  Hull: TPolygon2D;

begin
  //Create Hull and close it
  Hull := CreateConvexHull(ConvertTPointArray_TPoint2DArray(Points));
  SetLength(Hull, length(Hull) + 1);
  Hull[length(Hull) - 1] := Hull[0];

  Result := Hull;
end;

function MakeButtOctogan(Points: TPointArray): TPolygon2D;
var
  Octogan: TPolygon2D;
  i, Left, Top, Right, Bottom: integer;

begin
  Left := 999999;
  Top := 999999;
  Right := -999999;
  Bottom := -999999;
  for i := 0 to Length(Points) - 1 do
  begin
    if Points[i].x < Left then
      Left := Points[i].x;
    if Points[i].y < Top then
      Top := Points[i].y;
    if Points[i].x > Right then
      Right := Points[i].x;
    if Points[i].y > Bottom then
      Bottom := Points[i].y;
  end;

  SetLength(Octogan, 9);
  Octogan[0].x := Left;
  Octogan[0].y := Top;
  Octogan[1].x := Left + ((Right - Left) / 2);
  Octogan[1].y := Top - 1;
  Octogan[2].x := Right;
  Octogan[2].y := Top;
  Octogan[3].x := Right + 1;
  Octogan[3].y := Top + ((Bottom - Top) / 2);
  Octogan[4].x := Right;
  Octogan[4].y := Bottom;
  Octogan[5].x := Left + ((Right - Left) / 2);
  Octogan[5].y := Bottom + 1;
  Octogan[6].x := Left;
  Octogan[6].y := Bottom;
  Octogan[7].x := Left - 1;
  Octogan[7].y := Top + ((Bottom - Top) / 2);
  Octogan[8].x := Left;
  Octogan[8].y := Top;

  Result := Octogan;
end;

function MakeButtSquare(Points: TPointArray): TPolygon2D;
var
  Square: TPolygon2D;
  i, Left, Top, Right, Bottom: integer;

begin
  Left := 999999;
  Top := 999999;
  Right := -999999;
  Bottom := -999999;
  for i := 0 to Length(Points) - 1 do
  begin
    if Points[i].x < Left then
      Left := Points[i].x;
    if Points[i].y < Top then
      Top := Points[i].y;
    if Points[i].x > Right then
      Right := Points[i].x;
    if Points[i].y > Bottom then
      Bottom := Points[i].y;
  end;

  SetLength(Square, 5);
  Square[0].x := Left;
  Square[0].y := Top;
  Square[1].x := Right;
  Square[1].y := Top;
  Square[2].x := Right;
  Square[2].y := Bottom;
  Square[3].x := Left;
  Square[3].y := Bottom;
  Square[4].x := Left;
  Square[4].y := Top;

  Result := Square;
end;

function OverlapStrip(Strip1, Strip2: TStrip): TStrip;
var
  StripHeight1, StripHeight2: integer;

begin
  StripHeight1 := Strip1.Bottom - Strip1.Top;
  StripHeight2 := Strip2.Bottom - Strip2.Top;

  //Just Tops and bottoms
  Result.Top := Strip2.Top - Strip1.Top;
  Result.Bottom := Result.Top + StripHeight2;

  if Result.Top < 0 then
    Result.Top := 0;
  if Result.Bottom > StripHeight1 then
    Result.Bottom := StripHeight1;
end;

procedure SpeedRotatePattern(var Knife: TPattern);
var
  i, j, x, y: integer;
  xd, yd: double;
  RotKnife: TPattern;

begin
  with Knife do
  begin
    j := Length(PatternPoints);
    SetLength(RotKnife.PatternPoints, j);
    for i := 0 to Length(PatternPoints) - 1 do
    begin
      dec(j);
      x := PatternPoints[i].x;
      y := PatternPoints[i].y;
      RotKnife.PatternPoints[j].x := y;
      RotKnife.PatternPoints[j].y := x;
    end;

    for i := 0 to Length(PatternPoints) - 1 do
    begin
      PatternPoints[i].x := RotKnife.PatternPoints[i].x;
      PatternPoints[i].y := RotKnife.PatternPoints[i].y;
    end;

    j := Length(ExpandedPoints);
    SetLength(RotKnife.ExpandedPoints, j);
    for i := 0 to Length(ExpandedPoints) - 1 do
    begin
      dec(j);
      x := ExpandedPoints[i].x;
      y := ExpandedPoints[i].y;
      RotKnife.ExpandedPoints[j].x := y;
      RotKnife.ExpandedPoints[j].y := x;
    end;

    for i := 0 to Length(ExpandedPoints) - 1 do
    begin
      ExpandedPoints[i].x := RotKnife.ExpandedPoints[i].x;
      ExpandedPoints[i].y := RotKnife.ExpandedPoints[i].y;
    end;

    j := Length(ConvexHull);
    SetLength(RotKnife.ConvexHull, j);
    for i := 0 to Length(ConvexHull) - 1 do
    begin
      dec(j);
      xd := ConvexHull[i].x;
      yd := ConvexHull[i].y;
      RotKnife.ConvexHull[j].x := yd;
      RotKnife.ConvexHull[j].y := xd;
    end;

    for i := 0 to Length(ConvexHull) - 1 do
    begin
      ConvexHull[i].x := RotKnife.ConvexHull[i].x;
      ConvexHull[i].y := RotKnife.ConvexHull[i].y;
    end;

    j := Length(ButtOctogan);
    SetLength(RotKnife.ButtOctogan, j);
    for i := 0 to Length(ButtOctogan) - 1 do
    begin
      dec(j);
      xd := ButtOctogan[i].x;
      yd := ButtOctogan[i].y;
      RotKnife.ButtOctogan[j].x := yd;
      RotKnife.ButtOctogan[j].y := xd;
    end;

    for i := 0 to Length(ButtOctogan) - 1 do
    begin
      ButtOctogan[i].x := RotKnife.ButtOctogan[i].x;
      ButtOctogan[i].y := RotKnife.ButtOctogan[i].y;
    end;

    j := Length(ButtSquare);
    SetLength(RotKnife.ButtSquare, j);
    for i := 0 to Length(ButtSquare) - 1 do
    begin
      dec(j);
      xd := ButtSquare[i].x;
      yd := ButtSquare[i].y;
      RotKnife.ButtSquare[j].x := yd;
      RotKnife.ButtSquare[j].y := xd;
    end;

    for i := 0 to Length(ButtSquare) - 1 do
    begin
      ButtSquare[i].x := RotKnife.ButtSquare[i].x;
      ButtSquare[i].y := RotKnife.ButtSquare[i].y;
    end;

    x := Knife.Width;
    Knife.Width := Knife.Height;
    Knife.Height := x;
  end;
end;

procedure SpeedRotateHull(var Hull: TPolygon2D);
var
  i, j: integer;
  xd, yd: double;
  ConvexHull: TPolygon2D;

begin
    j := Length(Hull);
    SetLength(ConvexHull, j);
    for i := 0 to Length(Hull) - 1 do
    begin
      dec(j);
      xd := Hull[i].x;
      yd := Hull[i].y;
      ConvexHull[j].x := yd;
      ConvexHull[j].y := xd;
    end;

    for i := 0 to Length(ConvexHull) - 1 do
    begin
      Hull[i].x := ConvexHull[i].x;
      Hull[i].y := ConvexHull[i].y;
    end;
end;

procedure SpeedRotateRect(var Rect: TRect);
var
  x: integer;

begin
  x := Rect.Left;
  Rect.Left := Rect.Top;
  Rect.Top := x;
  x := Rect.Right;
  Rect.Right := Rect.Bottom;
  Rect.Bottom := x;
end;

function OverlappingHullLeftAndRights(LeftsHull1, RightsHull1, LeftsHull2, RightsHull2: TSideEdges; x, y, WidthHull2: integer): integer;
var
  i: integer;
  Left1, Right1, Left2, Right2: integer;
  Overlap, Overlaps: integer;
  yIn1, yIn2: integer;
  HeightHull1, HeightHull2: integer;

begin
  HeightHull1 := Length(LeftsHull1);
  HeightHull2 := Length(LeftsHull2);

  Overlaps := 0;
  //Look from +1 to -1 because there are no overlaps
  //at the extremes because they skate past
  for i := y + 1 to (y + HeightHull2 - 1) - 1 do
  begin
    yIn1 := i - HeightHull2;  
    yIn2 := i - y - 1;

    if (yIn1 >= 0) and (yIn1 <= (HeightHull1 - 1)) then
    begin
      Left1 := LeftsHull1[yIn1, 1] + WidthHull2 + 1;
      Right1 := RightsHull1[yIn1, 1] + WidthHull2 + 1;
      Left2 := LeftsHull2[yIn2, 1] + x;
      Right2 := RightsHull2[yIn2, 1] + x;

      Overlap := 0;
      if (Right2 >= Left1) and (Right2 <= Right1) and (Left2 <= Left1) then
        Overlap := Right2 - Left1 + 1
      else if (Left2 >= Left1) and (Left2 <= Right1) and (Right2 >= Right1) then
        Overlap := Right1 - Left2 + 1
      else if (Left2 <= Left1) and (Right2 >= Right1) then
        Overlap := Right1 - Left1 + 1
      else if (Left2 >= Left1) and (Right2 <= Right1) then
        Overlap := Right2 - Left2 + 1;

      Overlaps := Overlaps + Overlap;
    end;
  end;

  Result := Overlaps;
end;

procedure RemoveConsecutiveDuplicatePoints(var Points: TPointArray);
var
  DuplicateMap: array of Boolean;
  Thisi, Nexti, Ini, Outi: integer;
  Duplicates: integer;
  NewPoints: TPointArray;

begin
  Duplicates := 0;
  SetLength(DuplicateMap, Length(Points));

  for Thisi := 0 to Length(Points) - 1 do
  begin
    Nexti := Thisi + 1;
    if Nexti = length(Points) then
      Nexti := 0;

    if (Points[Nexti].x = Points[Thisi].x) and (Points[Nexti].y = Points[Thisi].y) then
    begin
      inc(Duplicates);
      DuplicateMap[Thisi] := True;
    end
    else
      DuplicateMap[Thisi] := False;
  end;

  SetLength(NewPoints, Length(Points) - Duplicates);

  Outi := -1;
  for Ini := 0 to Length(Points) - 1 do
  begin
    if not DuplicateMap[Ini] then
    begin
      inc(Outi);
      NewPoints[Outi] := Points[Ini];
    end;

  end;

  if Length(Points) <> length(NewPoints) then
    Points := NewPoints;
end;

procedure MakeClockwise(var Pattern: TPointArray);
var
  i, j, Count1, Count2, FirstIndex: integer;
  Hull: TPolygon2D;
  Clockwise, FoundIt: boolean;
  Points: array of TPoint2D;

begin
  ClockWise := True;
  SetLength(Points, Length(Pattern));

  for i := 0 to Length(Pattern) - 1 do
  begin
    Points[i].x := Pattern[i].x;
    Points[i].y := Pattern[i].y;
  end;

  //Fact - Hulls are always clockwise
  Hull := CreateConvexHull(Points);

  {$IFDEF DEBUGFULL}
    if Assigned(fmDebugger) then fmDebugger.DrawHull(Hull);
  {$ENDIF}

  //Look for Pattern point index where the point is the same as Hull[0]
  j := 0;
  FirstIndex := 0;
  while not((round(Hull[0].x) = Pattern[j].x) and (round(Hull[0].y) = Pattern[j].y)) do
  begin
    inc(j);
    FirstIndex := j;
  end;

  //Principle - if there are more actual pattern points (when going in a positive index direction through
  //the pattern array) between Hull[0] and Hull[1] than there are between Hull[0] and Hull[2] then we must
  //be going anti-clockwise.
  j := FirstIndex;
  Count1 := 0;
  while not((round(Hull[1].x) = Pattern[j].x) and (round(Hull[1].y) = Pattern[j].y)) do
  begin
    inc(j);
    if (j > Length(Pattern) - 1) then
      j := 0;
    inc(Count1);
  end;

  j := FirstIndex;
  Count2 := 0;
  while not((round(Hull[2].x) = Pattern[j].x) and (round(Hull[2].y) = Pattern[j].y)) do
  begin
    inc(j);
    if (j > Length(Pattern) - 1) then
      j := 0;
    inc(Count2);
  end;

  if Count1 > Count2 then
    Clockwise := False;

  if not Clockwise then
  begin
    for i := 0 to Length(Points) - 1 do
    begin
      Pattern[i].x := round(Points[Length(Points) - 1 - i].x);
      Pattern[i].y := round(Points[Length(Points) - 1 - i].y);
    end;
  end;
end;

end.




