unit General_Interlocking;

interface

uses Windows, Types, Math, Graphics, Dialogs, Classes, FastGEO, Const_Interlocking;

type
  TIntPoint2D = record
    x, y: integer
  end;
  TIntPolygon2D = array of TIntPoint2D;
  TPointArray = array of TPoint;
  TPattern = record
    Height, Width: integer;
    PatternPoints, ExpandedPoints: TPointArray;
    ConvexHull, ButtOctogan, ButtSquare: TPolygon2D;
    PatternNettArea, ExpandedNettArea, ExpandedGrossArea: Real;
    W2: Boolean;
  end;
  TSideEdges = array of array of integer;  //To hold specific edges i.e. Lefts or Rights
  TPointsWithDist = record
    OriginalPoint, ClosePoint: TPoint;
    Dist: real;
    AddIn, PossibleMergePoint: boolean;
    Index: integer;
  end;
  TPatternWithDist = array of TPointsWithDist;
  TFinalPoint = record
    Point: TPoint;
    ActualMergePoint, AddedPoint, InsideOtherPattern, PossibleMergePoint: Boolean;
    MergePointPoint: TPoint;
    OtherPatternMergePointIndex: integer;
  end;
  TFinalPattern = array of TFinalPoint;

function PointInAndOnPolygon(const Px,Py:TFloat; const Polygon: TPolygon2D): Boolean; overload;
function PointInAndOnPolygon(x, y: double; NPoints: integer; Pat: TPointArray): Boolean; overload;
function ConvertTPointArray_TPolygon2D(OldArray: TPointArray): TPolygon2D;
function ConvertTPointArray_TPoint2DArray(OldArray: TPointArray): TPoint2DArray;
function ConvertTPolygon2D_TPointArray(OldArray: TPolygon2D): TPointArray;
function Distance(x, y, x2, y2: double): double;
procedure LineIntersect(C1, C2, M1, M2, x1, x2: double; var x, y: double);
procedure MakeLine(Point1, Point2: TPoint; var c, m: double; var x: integer);
function FloatIsEqual(n1, n2: double): Boolean;
procedure CheckInterLockCall(Butt, StopLeft, StopRight, StopTop, StopBottom: Boolean;
                             PatternWidth1, PatternHeight1, PatternWidth2, PatternHeight2: integer);
procedure RemoveConsecutiveIndenticalPoints(var ThePattern: TPointArray);
procedure RotatePattern(RotationAngle: real;
                        var ThePoints: TPointArray);

var
  Knife, KnifeW1, KnifeW2: TPattern;
  NewKnife: Boolean;
  ShowGangs: Boolean;
  FileNumber, MaximumPatternPoints: integer;

implementation

function PointInAndOnPolygon(x, y: double; NPoints: integer; Pat: TPointArray): Boolean;
var
  i: integer;
  ConvexHull: TPolygon2D;

begin
  i := -1;
  SetLength(ConvexHull, Length(Pat));
  while not(i = Length(Pat) - 1) do
  begin
    inc(i);
    ConvexHull[i].x := Pat[i].x;
    ConvexHull[i].y := Pat[i].y;
  end;
  result := PointInAndOnPolygon(x, y, ConvexHull);
end;

function PointInAndOnPolygon(const Px,Py:TFloat; const Polygon:TPolygon2D):Boolean;
var
  i, i2: Integer;
  j: Integer;
begin
  Result := False;
  if Length(Polygon) < 3 then Exit;
  j := Length(Polygon) - 1;
  for i := 0 to Length(Polygon) - 1 do
  begin
    if ((Polygon[i].y <= Py) and (Py < Polygon[j].y)) or    // an upward crossing
       ((Polygon[j].y <= Py) and (Py < Polygon[i].y)) then  // a downward crossing
    begin
      (* compute the edge-ray intersect @ the x-coordinate *)
      if (Px - Polygon[i].x < ((Polygon[j].x - Polygon[i].x) * (Py - Polygon[i].y) / (Polygon[j].y - Polygon[i].y))) then
        Result := not Result;
    end;
    j := i;
  end;

  //Tims patch to find colinear points on same y and on the same x.
  //Above got some but not all of these.
  if not Result then
  begin
    for i := 0 to Length(Polygon) - 1 do
    begin
      //Find next point
      i2 := i + 1;
      if i2 > Length(Polygon) - 1 then
        i2 := 0;

      if ((Polygon[i].y = Py) and (Polygon[i2].y = Py)) and
        (((Polygon[i].x <= Px) and (Polygon[i2].x >= Px)) or ((Polygon[i2].x <= Px) and (Polygon[i].x >= Px))) then
        Result := True;

      if ((Polygon[i].x = Px) and (Polygon[i2].x = Px)) and
        (((Polygon[i].y <= Py) and (Polygon[i2].y >= Py)) or ((Polygon[i2].y <= Py) and (Polygon[i].y >= Py))) then
        Result := True;
    end;
  end;
  //End of Tims patch.
end;
(* End PointInAndOnPolygon *)

function ConvertTPointArray_TPolygon2D(OldArray: TPointArray): TPolygon2D;
var
  NewArray: TPolygon2D;
  i: integer;

begin
  SetLength(NewArray, Length(OldArray));
  for i := 0 to Length(OldArray) - 1 do
  begin
    NewArray[i].x := OldArray[i].x;
    NewArray[i].y := OldArray[i].y;
  end;

  Result := NewArray;
end;

function ConvertTPointArray_TPoint2DArray(OldArray: TPointArray): TPoint2DArray;
var
  NewArray: TPoint2DArray;
  i: integer;

begin
  SetLength(NewArray, Length(OldArray));
  for i := 0 to Length(OldArray) - 1 do
  begin
    NewArray[i].x := OldArray[i].x;
    NewArray[i].y := OldArray[i].y;
  end;

  Result := NewArray;
end;

function ConvertTPolygon2D_TPointArray(OldArray: TPolygon2D): TPointArray;
var
  NewArray: TPointArray;
  i: integer;

begin
  SetLength(NewArray, Length(OldArray));
  for i := 0 to Length(OldArray) - 1 do
  begin
    NewArray[i].x := round(OldArray[i].x);
    NewArray[i].y := round(OldArray[i].y);
  end;

  Result := NewArray;
end;

//Measure distance between 2 points.
function Distance(x, y, x2, y2: double): double;
begin
  result := sqrt(abs(Power(x - x2, 2) + Power(y - y2, 2)));
end;

procedure LineIntersect(C1, C2, M1, M2, x1, x2: double;
                        var x, y: double);
begin
  if not(M1 = M2) then
  begin
    if not(M1 = UNDEFINED) and not(M2 = UNDEFINED) then
      x := (C2 - C1) / (M1 - M2);

    if M1 = UNDEFINED then
    begin
      x := x1;
      y := (M2 * x) + C2;
    end
    else if M2 = UNDEFINED then
    begin
      x := x2;
      y := (M1 * x) + C1;
    end
    else
      y := (M1 * x) + C1;
  end;
end;

//Returns gradient and yintercept of line passing through Point1 and Point2.
procedure MakeLine(Point1, Point2: TPoint; var c, m: double; var x: integer);
begin
  if (Point2.X = Point1.X) then
  begin
    m := UNDEFINED;
    c := UNDEFINED;
    x := Point1.X;
  end
  else
  begin
    m := (Point2.Y - Point1.Y) / (Point2.X - Point1.X);
    c := Point1.Y - (m * Point1.X);
    x := UNDEFINED;
  end;
end;

function FloatIsEqual(n1, n2: double): Boolean;
begin
  Result := (abs(n1 - n2) < 0.00001);
end;

procedure CheckInterLockCall(Butt, StopLeft, StopRight, StopTop, StopBottom: Boolean;
                             PatternWidth1, PatternHeight1, PatternWidth2, PatternHeight2: integer);
var
  NoStoppers, NoLRStoppers, NoTBStoppers: integer;
  s: string;

begin
  NoStoppers := 0;
  NoLRStoppers := 0;
  NoTBStoppers := 0;
  if StopLeft then
  begin
    inc(NoStoppers);
    inc(NoLRStoppers);
  end;
  if StopRight then
  begin
    inc(NoStoppers);
    inc(NoLRStoppers);
  end;
  if StopTop then
  begin
    inc(NoStoppers);
    inc(NoTBStoppers);
  end;
  if StopBottom then
  begin
    inc(NoStoppers);
    inc(NoTBStoppers);
  end;

  s := '';
  if Butt then
  begin
    if (NoStoppers = 2) then
    begin
      if (NoLRStoppers <> 2) and (NoTBStoppers <> 2) then
        s := 'Invalid pair of Stoppers for Butt';
    end
    else if (NoStoppers <> 3) then
      s := 'Invalid number of Stoppers for Butt';

    if not ((PatternWidth1 = PatternWidth2) and (PatternHeight1 = PatternHeight2)) then
      s := 'Undefined - Butting with different size shapes';
  end;

  if s <> '' then
    messagedlg(s, mtError, [mbOk], 0);
end;

procedure RemoveConsecutiveIndenticalPoints(var ThePattern: TPointArray);
type
  PPoint = ^TPoint;

var
  i, j: integer;
  LastPoint, MyPoint: PPoint;
  PointsList: TList;

begin
  PointsList := TList.Create;
  for i := 0 to Length(ThePattern) - 1 do
  begin
    New(MyPoint);
    MyPoint^ := ThePattern[i];
    PointsList.Add(MyPoint);
  end;

  //Transfer list points back into ThePattern, eliminating duplicate points
  j := 0;
  LastPoint := nil;
  for i := 0 to PointsList.Count - 1 do
  begin
    MyPoint := PointsList[i];

    if (LastPoint = nil) or (not((MyPoint^.x = LastPoint^.x) and (MyPoint^.y = LastPoint^.y))) then
    begin
      inc(j);
      SetLength(ThePattern, j);

      ThePattern[j - 1] := MyPoint^;
    end;
    LastPoint := MyPoint;
  end;

  //If last point same as first point then chop last point out of final array.
  if Length(ThePattern) > 0 then
  begin
    MyPoint := PointsList[0];
    if (MyPoint^.x = LastPoint^.x) and (MyPoint^.y = LastPoint^.y) then
      SetLength(ThePattern, j - 1);
  end;

  for i := 0 to PointsList.Count - 1 do
    Dispose(PointsList[i]);

  PointsList.Free;
end;

procedure RotatePattern(RotationAngle: real;
                        var ThePoints: TPointArray);
var
  i: integer;
  Point: TPoint2D;

begin
  if RotationAngle >= 360 then
    RotationAngle := RotationAngle - 360;

  if not(RotationAngle = 0) then
  begin
    for i := 0 to Length(ThePoints) - 1 do
    begin
      Point.x := ThePoints[i].x;
      Point.y := ThePoints[i].y;
      Point := Rotate(-RotationAngle, Point);
      ThePoints[i].x := round(Point.x);
      ThePoints[i].y := round(Point.y);
    end;
  end;
end;

end.
