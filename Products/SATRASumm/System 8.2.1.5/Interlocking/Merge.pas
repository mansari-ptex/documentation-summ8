unit Merge;

interface

//{$DEFINE DEBUGFULL}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Math,
  General_Interlocking, FastGEO, ConvexHull, Interlocking
  {$IFDEF DEBUGFULL}
  , Debugger
  {$ENDIF}
  ;

type
  TMerge = record
    Points: TPointArray;
    Success: Boolean;
  end;
  TMap = record
    LocalIndex, OtherIndex: integer;
  end;
  TPatternMap = array of TMap;

function MergePatterns(Knife, Knife2: TPattern; Interlock: TInterlock; MergeDistantPatterns: boolean): TMerge;

var
  Tolerance: integer;

{$IFDEF DEBUG}
  InMerge, TotalInMerge: real;
{$ENDIF}

implementation

{$IFDEF DEBUGFULL}
  {$IFDEF SATRASUMM}
    uses Summs;
  {$ELSE}
    uses VisualiserMain;
  {$ENDIF}
{$ENDIF}

function Distance(x1, y1, x2, y2: TFloat): TFloat;
var
  dx, dy: TFloat;

begin
  dx := x2 - x1;
  dy := y2 - y1;
  Result := Sqrt(dx * dx + dy * dy);
end;

function MinimumDistanceFromPointToLine(ThePoint, LinePoint1, LinePoint2: TPoint;
                                        var ClosePoint: TPoint;
                                        var Is1, Is2: boolean): TFloat;
var
  Px, Py, x1, y1, x2, y2, Nx, Ny: TFloat;

const
  Root2 = 1.4142;

begin
  Px := ThePoint.X;
  Py := ThePoint.Y;
  x1 := LinePoint1.X;
  y1 := LinePoint1.Y;
  x2 := LinePoint2.X;
  y2 := LinePoint2.Y;
  ClosestPointOnSegmentFromPoint(x1, y1, x2, y2, Px, Py, Nx, Ny);

  Is1 := False;
  Is2 := False;

  if Distance(Nx, Ny, x1, y1) < Root2 then
  begin
    Is1 := True;
    ClosePoint := LinePoint1;
    Result := Distance(Px, Py, x1, y1);
  end
  else if Distance(Nx, Ny, x2, y2) < Root2 then
  begin
    Is2 := True;
    ClosePoint := LinePoint2;
    Result := Distance(Px, Py, x2, y2);
  end
  else
  begin
    ClosePoint.X := round(Nx);
    ClosePoint.Y := round(Ny);
    Result := Distance(Px, Py, Nx, Ny);
  end;
end;

function DistanceLineCrossesOwnPatternOrDupPoint(ThePoint, ClosePoint: TPoint;
                                                 AddIn, EnclosedPattern: boolean;
                                                 Index: integer;
                                                 ThisPattern, OtherPattern: TPointArray): boolean;
var
  i, dupcount: integer;
  Point1, Point2, Point3, Point4: TPoint2D;
  Intersected: boolean;

begin
  Intersected := False;
  Point1.x := ThePoint.x;
  Point1.y := ThePoint.y;
  //Distance line is ThePoint to Point2
  if AddIn then
  begin
    Point2.x := ClosePoint.x;
    Point2.y := ClosePoint.y;
  end
  else
  begin
    Point2.x := OtherPattern[Index].x;
    Point2.y := OtherPattern[Index].y;
  end;

  DupCount := 0;
  i := 0;
  while (i <> Length(ThisPattern) - 1) and (not Intersected) and (DupCount < 2) do
  begin
    Point3.x := ThisPattern[i].x;
    Point3.y := ThisPattern[i].y;
    Point4.x := ThisPattern[i + 1].x;
    Point4.y := ThisPattern[i + 1].y;
    if EnclosedPattern then
      if (Point1.x = Point3.x) and (Point1.y = Point3.y) then
        inc(DupCount);
    if (Point1.x <> Point3.x) and (Point1.y <> Point3.y) and
       (Point1.x <> Point4.x) and (Point1.y <> Point4.y) then
      Intersected := Intersect(Point1, Point2, Point3, Point4);
    inc(i);
  end;

  if (not Intersected) then
  begin
    Point3.x := ThisPattern[Length(ThisPattern) - 1].x;
    Point3.y := ThisPattern[Length(ThisPattern) - 1].y;
    Point4.x := ThisPattern[0].x;
    Point4.y := ThisPattern[0].y;
    if EnclosedPattern then
      if (Point1.x = Point3.x) and (Point1.y = Point3.y) then
        inc(DupCount);
    if (Point1.x <> Point3.x) and (Point1.y <> Point3.y) and
       (Point1.x <> Point4.x) and (Point1.y <> Point4.y) then
      Intersected := Intersect(Point1, Point2, Point3, Point4);
  end;

  Result := Intersected or (DupCount > 1);
end;

function PointAndMinimumDistanceToPolygon(ThePoint: TPoint; Polygon: TPointArray;
                                          var ClosePoint: TPoint;
                                          var AddIn: Boolean;
                                          var Index: integer): TFloat;
var
  i, j: Integer;
  TempDist: TFloat;
  ThisClosePoint: TPoint;
  Is1, Is2: boolean;

begin
  Result := 0.0;
  if Length(Polygon) > 2 then
  begin
    j := Length(Polygon) - 1;
    i := 0;
    Result := MinimumDistanceFromPointToLine(ThePoint, Polygon[i], Polygon[j], ThisClosePoint, Is1, Is2);
    ClosePoint := ThisClosePoint;
    if (Is1 or Is2) then
    begin
      if Is1 then
        Index := i
      else
        Index := j;
      AddIn := False;
    end
    else
    begin
      Index := j;
      AddIn := True;
    end;

    j := 0;
    for i := 1 to Length(Polygon) - 1 do
    begin
      TempDist := MinimumDistanceFromPointToLine(ThePoint, Polygon[i], Polygon[j], ThisClosePoint, Is1, Is2);
      if TempDist < Result then
      begin
        Result := TempDist;
        ClosePoint := ThisClosePoint;
        if (Is1 or Is2) then
        begin
          if Is1 then
            Index := i
          else
            Index := j;
          AddIn := False;
        end
        else
        begin
          Index := j;
          AddIn := True;
        end;
      end;
      j := i;
    end;
  end;
end;

procedure FindAllMinimumDistances(Pattern1, Pattern2: TPointArray;
                                  EnclosedPattern: boolean;
                                  var PatternWithDist1, PatternWithDist2: TPatternWithDist;
                                  var OverallMinDist: real);
var
  ClosePoint, ThePoint: TPoint;
  AddIn: Boolean;
  i, Index: integer;

begin
  OverallMinDist := 9999;
  SetLength(PatternWithDist1, Length(Pattern1));
  for i := 0 to Length(Pattern1) - 1 do
  begin
    ThePoint := Pattern1[i];
    PatternWithDist1[i].OriginalPoint := Pattern1[i];
    PatternWithDist1[i].Dist := PointAndMinimumDistanceToPolygon(ThePoint, Pattern2, ClosePoint, AddIn, Index);
    PatternWithDist1[i].ClosePoint := ClosePoint;
    PatternWithDist1[i].AddIn := AddIn;
    PatternWithDist1[i].PossibleMergePoint := not DistanceLineCrossesOwnPatternOrDupPoint(ThePoint, ClosePoint,
      AddIn, EnclosedPattern, Index, Pattern1, Pattern2);
    PatternWithDist1[i].Index := Index;
    if (PatternWithDist1[i].Dist < OverallMinDist) and PatternWithDist1[i].PossibleMergePoint then
      OverallMinDist := PatternWithDist1[i].Dist;
  end;
  SetLength(PatternWithDist2, Length(Pattern2));
  for i := 0 to Length(Pattern2) - 1 do
  begin
    ThePoint := Pattern2[i];
    PatternWithDist2[i].OriginalPoint := Pattern2[i];
    PatternWithDist2[i].Dist := PointAndMinimumDistanceToPolygon(ThePoint, Pattern1, ClosePoint, AddIn, Index);
    PatternWithDist2[i].ClosePoint := ClosePoint;
    PatternWithDist2[i].AddIn := AddIn;
    PatternWithDist2[i].PossibleMergePoint := not DistanceLineCrossesOwnPatternOrDupPoint(ThePoint, ClosePoint,
      AddIn, EnclosedPattern, Index, Pattern2, Pattern1);
    PatternWithDist2[i].Index := Index;
    if (PatternWithDist2[i].Dist < OverallMinDist) and PatternWithDist2[i].PossibleMergePoint then
      OverallMinDist := PatternWithDist2[i].Dist;
  end;
end;

procedure EliminatePointsOutsideTolerance(var PatternWithDist: TPatternWithDist;
                                          Tolerance: integer);
var
  i: integer;

begin
  for i := 0 to Length(PatternWithDist) - 1 do
  begin
    if PatternWithDist[i].PossibleMergePoint and (PatternWithDist[i].Dist > Tolerance) then
      PatternWithDist[i].PossibleMergePoint := False;
  end;
end;

function IndexOfPointFromHullLine(ThePoint: TPoint;
                                  FinalPattern: TFinalPattern;
                                  HullLineStartPoint: integer): integer;
var
  i: integer;
  JustStarted: boolean;

begin
  i := HullLineStartPoint;
  JustStarted := True;
  while not((i = HullLineStartPoint) and (JustStarted = False)) and not((ThePoint.x = FinalPattern[i].Point.x) and (ThePoint.y = FinalPattern[i].Point.y)) do
  begin
    JustStarted := False;
    dec(i);

    if (i = -1) then
      i := Length(FinalPattern) - 1;
  end;

  Result := i;
end;

function IndexOfPoint(ThePoint: TPoint;
                      FinalPattern: TFinalPattern): integer;
var
  i: integer;

begin
  i := 0;
  while not(i = Length(FinalPattern)) and not((ThePoint.x = FinalPattern[i].Point.x) and (ThePoint.y = FinalPattern[i].Point.y)) do
    inc(i);

  Result := i;
end;

function PointIsOnPattern(HullPoint: TPoint2D;
                          FinalPattern: TFinalPattern;
                          var i: integer): boolean;
var
  FoundPoint: boolean;

begin
  i := 0;
  FoundPoint := False;
  while (i <= Length(FinalPattern) - 1) and (not FoundPoint) do
  begin
    if (HullPoint.x = FinalPattern[i].Point.x) and (HullPoint.y = FinalPattern[i].Point.y) then
      FoundPoint := True
    else
      inc(i);
  end;
  Result := FoundPoint;
end;

function ValidStartPoint(FinalPattern: TFinalPattern;
                         PointIndex: integer): boolean;
var
  i, x, y: integer;
  Duplicated: boolean;

begin
  Duplicated := False;
  x := FinalPattern[PointIndex].Point.X;
  y := FinalPattern[PointIndex].Point.Y;

  i := PointIndex + 1;
  while (not Duplicated) and (not(i > Length(FinalPattern) - 1)) do
  begin
    Duplicated := ((FinalPattern[i].Point.X = x) and (FinalPattern[i].Point.Y = y));
    inc(i);
  end;

  Result := not Duplicated;
end;

function EnclosedPattern(Hull, Points1, Points2: TPolygon2D): integer;
var
  i, j: integer;
  Found1, Found2: boolean;

begin
  Found1 := False;
  Found2 := False;
  i := 0;
  while (i < length(Hull)) do
  begin
    j := 0;
    while (j < length(Points1)) and not Found1 do
    begin
      if (Hull[i].x = Points1[j].x) and (Hull[i].y = Points1[j].y) then
        Found1 := True
      else
        inc(j);
    end;

    j := 0;
    while (j < length(Points2)) and not Found2 do
    begin
      if (Hull[i].x = Points2[j].x) and (Hull[i].y = Points2[j].y) then
        Found2 := True
      else
        inc(j);
    end;
    inc(i);
  end;
  if Found1 and Found2 then
    Result := 0
  else if Found1 then
    Result := 2
  else if Found2 then
    Result := 1;
end;

procedure FindActualMergePoints(Hull: TPolygon2D;
                                var FinalPattern1, FinalPattern2: TFinalPattern;
                                var StartPoint, StartPointPattern: integer);

var
  i, j, PointIndex1, PointIndex2: integer;
  StartPoint1a, StartPoint1b, StartPoint2a, StartPoint2b: integer;

begin
  i := 0;
  StartPointPattern := 0;
  StartPoint := -1;
  StartPoint1a := -1;
  StartPoint1b := -1;
  StartPoint2a := -1;
  StartPoint2b := -1;
  while (i <= Length(Hull) - 1) do
  begin
    j := i + 1;
    if (j > Length(Hull) - 1) then
      j := 0;
    if (PointIsOnPattern(Hull[i], FinalPattern1, PointIndex1)) then
    begin
      if (PointIsOnPattern(Hull[j], FinalPattern2, PointIndex2)) then
      begin
        //This is where the Hull crosses from Pattern1 to Pattern2 when travelling clockwise.
        StartPoint1a := PointIndex1;
        StartPoint2a := PointIndex2;
      end
      else if (StartPoint = -1) and (not FinalPattern1[PointIndex1].PossibleMergePoint) and
        (ValidStartPoint(FinalPattern1, PointIndex1)) then
      begin
        StartPoint := PointIndex1;
        StartPointPattern := 1;
      end;
    end;

    if (PointIsOnPattern(Hull[i], FinalPattern2, PointIndex2)) then
    begin
      if (PointIsOnPattern(Hull[j], FinalPattern1, PointIndex1)) then
      begin
        //This is where the Hull crosses from Pattern2 to Pattern1 when travelling clockwise.
        StartPoint1b := PointIndex1;
        StartPoint2b := PointIndex2;
      end
      else if (StartPoint = -1) and (not FinalPattern2[PointIndex2].PossibleMergePoint) and
        (ValidStartPoint(FinalPattern2, PointIndex2)) then
      begin
        StartPoint := PointIndex2;
        StartPointPattern := 2;
      end;
    end;

    inc(i);
  end;

  //Find ActualMergePoint in Pattern1
  if (StartPoint1a > -1) then
  begin
    i := StartPoint1a;
    while (not FinalPattern1[i].PossibleMergePoint) do
    begin
      inc(i);
      if (i > Length(FinalPattern1) - 1) then
        i := 0;
    end;

    FinalPattern1[i].ActualMergePoint := True;
    FinalPattern1[i].OtherPatternMergePointIndex := IndexOfPointFromHullLine(FinalPattern1[i].MergePointPoint, FinalPattern2, StartPoint2a);
    FinalPattern2[FinalPattern1[i].OtherPatternMergePointIndex].ActualMergePoint := True;
    FinalPattern2[FinalPattern1[i].OtherPatternMergePointIndex].OtherPatternMergePointIndex := i;
  end
  else if (StartPointPattern = 1) then
  begin
    i := StartPoint;
    while (not FinalPattern1[i].PossibleMergePoint) do
    begin
      inc(i);
      if (i > Length(FinalPattern1) - 1) then
        i := 0;
    end;
    FinalPattern1[i].ActualMergePoint := True;
    FinalPattern1[i].OtherPatternMergePointIndex := IndexOfPoint(FinalPattern1[i].MergePointPoint, FinalPattern2);
    FinalPattern2[FinalPattern1[i].OtherPatternMergePointIndex].ActualMergePoint := True;
    FinalPattern2[FinalPattern1[i].OtherPatternMergePointIndex].OtherPatternMergePointIndex := i;

    i := StartPoint;
    while (not FinalPattern1[i].PossibleMergePoint) do
    begin
      dec(i);
      if (i < 0) then
        i := Length(FinalPattern1) - 1;
    end;
    FinalPattern1[i].ActualMergePoint := True;
    FinalPattern1[i].OtherPatternMergePointIndex := IndexOfPoint(FinalPattern1[i].MergePointPoint, FinalPattern2);
    FinalPattern2[FinalPattern1[i].OtherPatternMergePointIndex].ActualMergePoint := True;
    FinalPattern2[FinalPattern1[i].OtherPatternMergePointIndex].OtherPatternMergePointIndex := i;
  end;

  //Find ActualMergePoint in Pattern2
  if (StartPoint2b > -1) then
  begin
    i := StartPoint2b;
    while (not FinalPattern2[i].PossibleMergePoint) do
    begin
      inc(i);
      if (i > Length(FinalPattern2) - 1) then
        i := 0;
    end;

    FinalPattern2[i].ActualMergePoint := True;
    FinalPattern2[i].OtherPatternMergePointIndex := IndexOfPointFromHullLine(FinalPattern2[i].MergePointPoint, FinalPattern1, StartPoint1b);
    FinalPattern1[FinalPattern2[i].OtherPatternMergePointIndex].ActualMergePoint := True;
    FinalPattern1[FinalPattern2[i].OtherPatternMergePointIndex].OtherPatternMergePointIndex := i;
  end
  else if (StartPointPattern = 2) then
  begin
    i := StartPoint;
    while (not FinalPattern2[i].PossibleMergePoint) do
    begin
      inc(i);
      if (i > Length(FinalPattern2) - 1) then
        i := 0;
    end;
    FinalPattern2[i].ActualMergePoint := True;
    FinalPattern2[i].OtherPatternMergePointIndex := IndexOfPoint(FinalPattern2[i].MergePointPoint, FinalPattern1);
    FinalPattern1[FinalPattern2[i].OtherPatternMergePointIndex].ActualMergePoint := True;
    FinalPattern1[FinalPattern2[i].OtherPatternMergePointIndex].OtherPatternMergePointIndex := i;

    i := StartPoint;
    while (not FinalPattern2[i].PossibleMergePoint) do
    begin
      dec(i);
      if (i < 0) then
        i := Length(FinalPattern2) - 1;
    end;
    FinalPattern2[i].ActualMergePoint := True;
    FinalPattern2[i].OtherPatternMergePointIndex := IndexOfPoint(FinalPattern2[i].MergePointPoint, FinalPattern1);
    FinalPattern1[FinalPattern2[i].OtherPatternMergePointIndex].ActualMergePoint := True;
    FinalPattern1[FinalPattern2[i].OtherPatternMergePointIndex].OtherPatternMergePointIndex := i;
  end;
end;

function SecondMergePoint(StartPointIndex: integer;
                          FirstFinalPattern, SecondFinalPattern: TFinalPattern): integer;
var
  i: integer;

begin
  i := StartPointIndex;
  while not(FirstFinalPattern[i].ActualMergePoint) do
  begin
    dec(i);
    if i = -1 then
      i := Length(FirstFinalPattern) - 1;
  end;
  Result := FirstFinalPattern[i].OtherPatternMergePointIndex;
end;

function MustDec(AlteredPatt, Patt: TPolygon2D): boolean;
var
  i: integer;
  ThePoint: TPoint2D;

begin
  Result := False;
  i := 0;
  while not(i = Length(Patt)) and not Result do
  begin
    ThePoint.x := Patt[i].x;
    ThePoint.y := Patt[i].y;
    if (PointInAndOnPolygon(Patt[i].x, Patt[i].y, AlteredPatt) and not PointOnPerimeter(ThePoint, AlteredPatt)) then
      Result := True
    else
      inc(i);
  end;
end;

procedure DoMerge(StartPoint: integer;
                  FirstFinalPattern, SecondFinalPattern: TFinalPattern;
                  var MergedPattern: TPointArray);
var
  i, j, k, SecondMergeIndex: integer;
  CrossedFrom: TPoint;
  KeepGoing: boolean;
  FirstK, SecondK, FirstMergeIndex: integer;
  AddedPointAtCrossover, DecIt, Nudge: Boolean;
  HoldPoint: TPoint;
  ThePoint: TPoint2D;
  Patt1, Patt2: TPolygon2D;

begin
  i := 0;
  SetLength(MergedPattern, Length(FirstFinalPattern) + Length(SecondFinalPattern) + 2);

  //Run around first pattern until reach crossover point
  j := StartPoint;
  MergedPattern[i].x := FirstFinalPattern[j].Point.x;
  MergedPattern[i].y := FirstFinalPattern[j].Point.y;
  while not(FirstFinalPattern[j].ActualMergePoint) do
  begin
    inc(j);
    if (j = Length(FirstFinalPattern)) then
      j := 0;
    //(Do not add a duplicate point or a 'chipped in' point)
    if (not((MergedPattern[i].x = FirstFinalPattern[j].Point.x) and
      (MergedPattern[i].y = FirstFinalPattern[j].Point.y))) and (not(FirstFinalPattern[j].InsideOtherPattern)) and
      (not((FirstFinalPattern[j].ActualMergePoint = FALSE) and FirstFinalPattern[j].AddedPoint)) then
    begin
      inc(i);
      MergedPattern[i].x := FirstFinalPattern[j].Point.x;
      MergedPattern[i].y := FirstFinalPattern[j].Point.y;
    end
    else if FirstFinalPattern[j].InsideOtherPattern and FirstFinalPattern[j].ActualMergePoint then
    begin
      inc(i);
      MergedPattern[i].x := SecondFinalPattern[FirstFinalPattern[j].OtherPatternMergePointIndex].Point.x;
      MergedPattern[i].y := SecondFinalPattern[FirstFinalPattern[j].OtherPatternMergePointIndex].Point.y;
    end

  end;

  AddedPointAtCrossover := False;
  //Cross to other pattern and run around
  j := FirstFinalPattern[j].OtherPatternMergePointIndex;
  //(Do not add a duplicate point or a 'chipped in' point)
  if (not((MergedPattern[i].x = SecondFinalPattern[j].Point.x) and
    (MergedPattern[i].y = SecondFinalPattern[j].Point.y))) and (not(SecondFinalPattern[j].InsideOtherPattern)) and
    (not((SecondFinalPattern[j].ActualMergePoint = FALSE) and SecondFinalPattern[j].AddedPoint)) then
  begin
    inc(i);
    MergedPattern[i].x := SecondFinalPattern[j].Point.x;
    MergedPattern[i].y := SecondFinalPattern[j].Point.y;
    AddedPointAtCrossover := True;
  end;

  //SecondMergePoint is the first ActualMergePoint reached when travelling anti-clockwise from StartPoint.
  FirstMergeIndex := j;
  SecondMergeIndex := SecondMergePoint(StartPoint, FirstFinalPattern, SecondFinalPattern);
  if SecondMergeIndex = j then
    KeepGoing := True
  else
    KeepGoing := False;

  //Run around SecondFinalPattern to SecondMergePoint
  while KeepGoing or not(j = SecondMergeIndex) do
  begin
    KeepGoing := False;
    inc(j);
    if (j = Length(SecondFinalPattern)) then
      j := 0;
    if (not((MergedPattern[i].x = SecondFinalPattern[j].Point.x) and
      (MergedPattern[i].y = SecondFinalPattern[j].Point.y))) and (not(SecondFinalPattern[j].InsideOtherPattern)) and  //ensure no consecutive equal points added to array
      (not((SecondFinalPattern[j].ActualMergePoint = FALSE) and SecondFinalPattern[j].AddedPoint)) then
    begin
      inc(i);
      MergedPattern[i].x := SecondFinalPattern[j].Point.x;
      MergedPattern[i].y := SecondFinalPattern[j].Point.y;
    end
    else if SecondFinalPattern[j].InsideOtherPattern and SecondFinalPattern[j].ActualMergePoint then
    begin
      inc(i);
      MergedPattern[i].x := FirstFinalPattern[SecondFinalPattern[j].OtherPatternMergePointIndex].Point.x;
      MergedPattern[i].y := FirstFinalPattern[SecondFinalPattern[j].OtherPatternMergePointIndex].Point.y;
    end;
  end;

  //Cross back and run to finish
  j := SecondFinalPattern[j].OtherPatternMergePointIndex;
  while not(j = StartPoint) do
  begin
    if (not((MergedPattern[i].x = FirstFinalPattern[j].Point.x) and
      (MergedPattern[i].y = FirstFinalPattern[j].Point.y))) and (not(FirstFinalPattern[j].InsideOtherPattern)) and   //ensure no consecutive equal points added to array
      (not((FirstFinalPattern[j].ActualMergePoint = FALSE) and FirstFinalPattern[j].AddedPoint)) then
    begin
      inc(i);
      MergedPattern[i].x := FirstFinalPattern[j].Point.x;
      MergedPattern[i].y := FirstFinalPattern[j].Point.y;
    end;
    inc(j);
    if (j = Length(FirstFinalPattern)) then
      j := 0;
  end;
  SetLength(MergedPattern, i + 1);
end;

function MapPattern(LocalPattern, OtherPattern: TPatternWithDist): TPatternMap;
var
  i, j, k, l, l1, l2: integer;
  PatternMap: TPatternMap;
  PointNo, NoOtherPointsSinceLastLocalPoint: integer;
  HoldMap: TMap;

begin
  PointNo := -1;

  for i := 0 to Length(LocalPattern) - 1 do
  begin
    //Add in Local Point
    inc(PointNo);
    setLength(PatternMap, PointNo + 1);
    PatternMap[PointNo].LocalIndex := i;
    PatternMap[PointNo].OtherIndex := -1;

    //Add in Other Points
    NoOtherPointsSinceLastLocalPoint := 0;
    for j := 0 to Length(OtherPattern) - 1 do
    begin
      if (OtherPattern[j].Index = i) and OtherPattern[j].AddIn and OtherPattern[j].PossibleMergePoint then
      begin
        inc(NoOtherPointsSinceLastLocalPoint);
        inc(PointNo);
        setLength(PatternMap, PointNo + 1);
        PatternMap[PointNo].LocalIndex := -1;
        PatternMap[PointNo].OtherIndex := j;
      end;

      //Check latest 'Other Point' is further away from last
      //'Local point' than any possible previous one(s)
      if NoOtherPointsSinceLastLocalPoint > 1 then
      begin
        for k := NoOtherPointsSinceLastLocalPoint downto 2 do
        begin
          l := PointNo - NoOtherPointsSinceLastLocalPoint;
          l1 := PointNo - NoOtherPointsSinceLastLocalPoint + k;
          l2 := PointNo - NoOtherPointsSinceLastLocalPoint + k - 1;

          if Distance(LocalPattern[PatternMap[l].LocalIndex].OriginalPoint.x,
                      LocalPattern[PatternMap[l].LocalIndex].OriginalPoint.y,
                      OtherPattern[PatternMap[l1].OtherIndex].OriginalPoint.x,
                      OtherPattern[PatternMap[l1].OtherIndex].OriginalPoint.y) <
             Distance(LocalPattern[PatternMap[l].LocalIndex].OriginalPoint.x,
                      LocalPattern[PatternMap[l].LocalIndex].OriginalPoint.y,
                      OtherPattern[PatternMap[l2].OtherIndex].OriginalPoint.x,
                      OtherPattern[PatternMap[l2].OtherIndex].OriginalPoint.y) then
          begin
            //Swap points
            HoldMap := PatternMap[l1];
            PatternMap[l1] := PatternMap[l2];
            PatternMap[l2] := HoldMap;
          end;
        end;
      end;
    end;
  end;

  Result := PatternMap;
end;

function FinalPattern(LocalPattern, OtherPattern: TPatternWithDist; PatternMap: TPatternMap): TFinalPattern;
var
  i: integer;
  NewPattern: TFinalPattern;

begin
  setlength(NewPattern, length(PatternMap));
  for i := 0 to Length(PatternMap) - 1 do
  begin
    if PatternMap[i].LocalIndex <> -1 then
    begin
      //LocalIndex Used
      //Other Index -1
      NewPattern[i].Point := LocalPattern[PatternMap[i].LocalIndex].OriginalPoint;
      NewPattern[i].AddedPoint := False;
      NewPattern[i].PossibleMergePoint := LocalPattern[PatternMap[i].LocalIndex].PossibleMergePoint;
      NewPattern[i].MergePointPoint := LocalPattern[PatternMap[i].LocalIndex].ClosePoint;
    end
    else
    begin
      //LocalIndex -1
      //Other Index Used
      NewPattern[i].Point := OtherPattern[PatternMap[i].OtherIndex].ClosePoint;
      NewPattern[i].AddedPoint := True;      
      NewPattern[i].PossibleMergePoint := True;
      NewPattern[i].MergePointPoint := OtherPattern[PatternMap[i].OtherIndex].OriginalPoint;
    end;

    //Ensure that Points that are NOT possible
    //merge points are denoted by 0,0
    if not NewPattern[i].PossibleMergePoint then
    begin
      NewPattern[i].MergePointPoint.x := 0;
      NewPattern[i].MergePointPoint.y := 0;
    end;

    NewPattern[i].ActualMergePoint := False;
  end;

  Result := NewPattern;
end;

procedure CheckForPointsInsideOtherPattern(var FinalPattern1, FinalPattern2: TFinalPattern;
                                           Points1, Points2: TPolygon2D);
var
  i: integer;
  ThePoint: TPoint2D;

begin
  for i := 0 to Length(FinalPattern1) - 1 do
  begin
    ThePoint.X := FinalPattern1[i].Point.X;
    ThePoint.Y := FinalPattern1[i].Point.Y;
    if (PointInAndOnPolygon(ThePoint.X, ThePoint.Y, Points2)) and (not(PointOnPerimeter(ThePoint, Points2))) then
      FinalPattern1[i].InsideOtherPattern := True
    else
      FinalPattern1[i].InsideOtherPattern := False;
  end;

  for i := 0 to Length(FinalPattern2) - 1 do
  begin
    ThePoint.X := FinalPattern2[i].Point.X;
    ThePoint.Y := FinalPattern2[i].Point.Y;
    if (PointInAndOnPolygon(ThePoint.X, ThePoint.Y, Points1)) and (not(PointOnPerimeter(ThePoint, Points1))) then
      FinalPattern2[i].InsideOtherPattern := True
    else                                                                    
      FinalPattern2[i].InsideOtherPattern := False;
  end;
end;

function MergePatterns(Knife, Knife2: TPattern; Interlock: TInterlock; MergeDistantPatterns: boolean): TMerge;
var
  i, EnclosedPatternNumber, StartPoint, StartPointPattern: integer;
  Succeeded: Boolean;
  OriginalRect, InterlockRect: TRect;
  Pattern1, Pattern2, MergedPattern: TPointArray;
  PointsAll, Points1, Points2: TPolygon2D;
  Hull: TPolygon2D;
  PatternWithDist1, PatternWithDist2: TPatternWithDist;
  OverallMinDist: real;
  FinalPattern1, FinalPattern2: TFinalPattern;
  P1Map, P2Map: TPatternMap;
  z: integer;
  f: textfile;

begin
{$IFDEF DEBUGFULL}
//  ASSIGNFILE(F, 'C:\FULLMERGE.TXT');
//  REWRITE(F);
//  WRITELN(F, Knife.Height);
//  WRITELN(F, Knife.Width);
//  WRITELN(F, LENGTH(Knife.PatternPoints));
//  for Z := 0 to LENGTH(Knife.PatternPoints) - 1 do
//    WRITELN(F, z, ' ', Knife.PatternPoints[z].X, ' ', Knife.PatternPoints[z].Y);
//  WRITELN(F, LENGTH(Knife.ExpandedPoints));
//  for Z := 0 to LENGTH(Knife.ExpandedPoints) - 1 do
//    WRITELN(F, z, ' ', Knife.ExpandedPoints[z].X, ' ', Knife.ExpandedPoints[z].Y);
//  WRITELN(F, LENGTH(Knife.ConvexHull));
//  for Z := 0 to LENGTH(Knife.ConvexHull) - 1 do
//    WRITELN(F, Knife.ConvexHull[z].X, ' ', Knife.ConvexHull[z].Y);
//  WRITELN(F, LENGTH(Knife.ButtOctogan));
//  for Z := 0 to LENGTH(Knife.ButtOctogan) - 1 do
//    WRITELN(F, Knife.ButtOctogan[z].X, ' ', Knife.ButtOctogan[z].Y);
//  WRITELN(F, LENGTH(Knife.ButtSquare));
//  for Z := 0 to LENGTH(Knife.ButtSquare) - 1 do
//    WRITELN(F, Knife.ButtSquare[z].X, ' ', Knife.ButtSquare[z].Y);
//  WRITELN(F, Knife.PatternNettArea);
//  WRITELN(F, Knife.ExpandedNettArea);
//  WRITELN(F, Knife.ExpandedGrossArea);
//  WRITELN(F, Knife.W2);
//  WRITELN(F);
//  WRITELN(F, Knife2.Height);
//  WRITELN(F, Knife2.Width);
//  WRITELN(F, LENGTH(Knife2.PatternPoints));
//  for Z := 0 to LENGTH(Knife2.PatternPoints) - 1 do
//    WRITELN(F, z, ' ', Knife2.PatternPoints[z].X, ' ', Knife2.PatternPoints[z].Y);
//  WRITELN(F, LENGTH(Knife2.ExpandedPoints));
//  for Z := 0 to LENGTH(Knife2.ExpandedPoints) - 1 do
//    WRITELN(F, z, ' ', Knife2.ExpandedPoints[z].X, ' ', Knife2.ExpandedPoints[z].Y);
//  WRITELN(F, LENGTH(Knife2.ConvexHull));
//  for Z := 0 to LENGTH(Knife2.ConvexHull) - 1 do
//    WRITELN(F, Knife2.ConvexHull[z].X, ' ', Knife2.ConvexHull[z].Y);
//  WRITELN(F, LENGTH(Knife2.ButtOctogan));
//  for Z := 0 to LENGTH(Knife2.ButtOctogan) - 1 do
//    WRITELN(F, Knife2.ButtOctogan[z].X, ' ', Knife2.ButtOctogan[z].Y);
//  WRITELN(F, LENGTH(Knife2.ButtSquare));
//  for Z := 0 to LENGTH(Knife2.ButtSquare) - 1 do
//    WRITELN(F, Knife2.ButtSquare[z].X, ' ', Knife2.ButtSquare[z].Y);
//  WRITELN(F, Knife2.PatternNettArea);
//  WRITELN(F, Knife2.ExpandedNettArea);
//  WRITELN(F, Knife2.ExpandedGrossArea);
//  WRITELN(F, Knife2.W2);
//  WRITELN(F);
//  WRITELN(F, Interlock.Found);
//  WRITELN(F, Interlock.W2);
//  WRITELN(F, Interlock.Size);
//  WRITELN(F, Interlock.Knife1BoundingRect.Left);
//  WRITELN(F, Interlock.Knife1BoundingRect.Top);
//  WRITELN(F, Interlock.Knife1BoundingRect.Right);
//  WRITELN(F, Interlock.Knife1BoundingRect.Bottom);
//  WRITELN(F, Interlock.Knife2BoundingRect.Left);
//  WRITELN(F, Interlock.Knife2BoundingRect.Top);
//  WRITELN(F, Interlock.Knife2BoundingRect.Right);
//  WRITELN(F, Interlock.Knife2BoundingRect.Bottom);
//
//  WRITELN(F, LENGTH(Interlock.Overlap));
//  for Z := 0 to LENGTH(Interlock.Overlap) - 1 do
//    WRITELN(F, Interlock.Overlap[z].X, ' ', Interlock.Overlap[z].Y);
//
//  WRITELN(F);
//  WRITELN(F, MergeDistantPatterns);
//
//  CLOSEFILE(F);
{$ENDIF}

{$IFDEF DEBUG}
  InMerge := GetTickCount;
{$ENDIF}

  Tolerance := 5;

  //Location of 2 patterns
  OriginalRect := Interlock.Knife1BoundingRect;
  InterlockRect := Interlock.Knife2BoundingRect;

  SetLength(Pattern1, Length(Knife.ExpandedPoints));
  SetLength(Pattern2, Length(Knife2.ExpandedPoints));

  SetLength(Points1, Length(Pattern1));
  SetLength(Points2, Length(Pattern2));
  SetLength(PointsAll, Length(Pattern1) + Length(Pattern2));

  for i := 0 to Length(Pattern1) - 1 do
  begin
    //Position Pattern1 correctly
    Pattern1[i].x := OriginalRect.Left + Knife.ExpandedPoints[i].x;
    Pattern1[i].y := OriginalRect.Top + Knife.ExpandedPoints[i].y;
    //Copy Pattern1 into the array which will be sent to the ConvexHull routine - type is different
    Points1[i].x := Pattern1[i].X;
    Points1[i].y := Pattern1[i].Y;
    //Copy Pattern1 into the joint array which will be sent to the ConvexHull routine - type is different
    PointsAll[i].x := Pattern1[i].X;
    PointsAll[i].y := Pattern1[i].Y;
  end;

  for i := 0 to Length(Pattern2) - 1 do
  begin
    //Position Pattern2 correctly
    Pattern2[i].x := InterlockRect.Left + Knife2.ExpandedPoints[i].x;
    Pattern2[i].y := InterlockRect.Top + Knife2.ExpandedPoints[i].y;
    //Copy Pattern2 into the array which will be sent to the ConvexHull routine - type is different
    Points2[i].x := Pattern2[i].X;
    Points2[i].y := Pattern2[i].Y;
    //Copy Pattern2 into the joint array which will be sent to the ConvexHull routine - type is different
    PointsAll[i + Length(Pattern1)].x := Pattern2[i].X;
    PointsAll[i + Length(Pattern1)].y := Pattern2[i].Y;
  end;

  Hull := CreateConvexHull(PointsAll);

  EnclosedPatternNumber := EnclosedPattern(Hull, Points1, Points2);
  if (EnclosedPatternNumber > 0) then
    MergeDistantPatterns := True;   //Opening up to the possibility that we may ignore duplicate points and so end up
                                    //needing to merge at a distance of more than 5.

  FindAllMinimumDistances(Pattern1, Pattern2, (EnclosedPatternNumber <> 0), PatternWithDist1, PatternWithDist2, OverallMinDist);

  {$IFDEF DEBUGFULL}
    if Assigned(fmDebugger) then fmDebugger.DrawDistanceLines(PatternWithDist1, PatternWithDist2);
  {$ENDIF}

  //If nothing's within Tolerance something's up with the interlock UNLESS we intend it to be a Distant Pattern -
  //e.g. some ghosts which get added in mirrored positions but are not near the main shape.
  if (OverallMinDist > Tolerance) and not MergeDistantPatterns then
    Result.Success := False
  else
  begin
    if (OverallMinDist > Tolerance) and MergeDistantPatterns then
     Tolerance := Trunc(OverallMinDist) + 1;

    EliminatePointsOutsideTolerance(PatternWithDist1, Tolerance);
    EliminatePointsOutsideTolerance(PatternWithDist2, Tolerance);

    {$IFDEF DEBUGFULL}
      if Assigned(fmDebugger) then fmDebugger.DrawDistanceLinesRemaining(PatternWithDist1, PatternWithDist2);
    {$ENDIF}

    P1Map := MapPattern(PatternWithDist1, PatternWithDist2);
    P2Map := MapPattern(PatternWithDist2, PatternWithDist1);
    FinalPattern1 := FinalPattern(PatternWithDist1, PatternWithDist2, P1Map);
    FinalPattern2 := FinalPattern(PatternWithDist2, PatternWithDist1, P2Map);

    CheckForPointsInsideOtherPattern(FinalPattern1, FinalPattern2, Points1, Points2);

    {$IFDEF DEBUGFULL}
      if Assigned(fmDebugger) then fmDebugger.DrawFinalPatterns(FinalPattern1, FinalPattern2, StartPoint, StartPointPattern);
    {$ENDIF}

    FindActualMergePoints(Hull, FinalPattern1, FinalPattern2, StartPoint, StartPointPattern);

//    {$IFDEF DEBUGFULL}
//      fmDebugger.DrawFinalPatterns(FinalPattern1, FinalPattern2, StartPoint, StartPointPattern);
//    {$ENDIF}

    if (StartPointPattern = 1) then
      DoMerge(StartPoint, FinalPattern1, FinalPattern2, MergedPattern)
    else
      DoMerge(StartPoint, FinalPattern2, FinalPattern1, MergedPattern);

    {$IFDEF DEBUGFULL}
     if Assigned(fmDebugger) then fmDebugger.DrawMerge(MergedPattern);
    {$ENDIF}

    Result.Points := MergedPattern;
    Result.Success := True;
  end;

  {$IFDEF DEBUG}
    InMerge := GetTickCount - InMerge;
    TotalInMerge := TotalInMerge + InMerge;
  {$ENDIF}

  {$IFDEF DEBUGFULL}
    ASSIGNFILE(F, 'C:\PATTSMerged.TXT');
    REWRITE(F);
    WRITELN(F, LENGTH(MergedPattern));
    for Z := 0 to LENGTH(MergedPattern) - 1 do
      WRITELN(F, MergedPattern[Z].X, ' ', MergedPattern[Z].Y);
    CLOSEFILE(F);
  {$ENDIF}
end;

end.

