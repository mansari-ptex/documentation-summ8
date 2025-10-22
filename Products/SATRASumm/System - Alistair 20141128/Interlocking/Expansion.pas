unit Expansion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Math, FastGEO, ConvexHull,
  Const_Interlocking, General_Interlocking, Vcl.Dialogs
  {$IFDEF DEBUGFULL}
  , Debugger
  {$ENDIF}
  ;

const
  MINIMUMANGLE = 1;

type
  PPatternList = ^TPoint2D;

  ExpPoints = record
    c1, c2, m1, m2, GuideX, GuideY: double;
    BisX, BisY, ParaInterX, ParaInterY, XPlus, XMinus, YPoint: double;
  end;
  TExpansion = array of ExpPoints;

procedure ExpandPattern(OriginalPattern: TPointArray; var ExpandedPattern: TPointArray; Expansion: integer);
//procedure EliminatePointsWithinIntersections(var ExpandedPattern: TPointArray);
procedure EliminatePatternLoops(var Pattern: TPointArray);
procedure EliminateSpikes(var Pattern: TPointArray);
{procedure EliminatePointsTooClose(var Pat: TPointArray;
                                  var ExpandedPattern: TPointArray;
                                  var Expansion: integer);}
function Intersected(Line1Point1, Line1Point2, Line2Point1, Line2Point2: TPoint;
                     c1, c2, m1, m2: double;
                     var x, y: double): Boolean;

implementation

procedure EliminateSpikes(var Pattern: TPointArray);
var
  PatternList: TList;
  PointsRec: PPatternList;
  i: integer;
  PriorPoint, ThePoint, NextPoint: TPoint2D;

begin
  PatternList := TList.Create;
  for i := 0 to Length(Pattern) - 1 do
  begin
    //Add points to list
    New(PointsRec);
    PointsRec^.x := Pattern[i].X;
    PointsRec^.y := Pattern[i].Y;
    PatternList.Add(PointsRec);
  end;

  i := 0;
  while not(i = PatternList.Count) do
  begin
    if (i = 0) then
      PointsRec := PatternList[PatternList.Count - 1]    //Last point
    else
      PointsRec := PatternList[i - 1];
    PriorPoint := PointsRec^;

    PointsRec := PatternList[i];
    ThePoint := PointsRec^;

    if (i = PatternList.Count - 1) then
      PointsRec := PatternList[0]
    else
      PointsRec := PatternList[i + 1];
    NextPoint := PointsRec^;

    if (VertexAngle(PriorPoint, ThePoint, NextPoint) < MINIMUMANGLE) then
    begin
      PointsRec := PatternList[i];
      ThePoint := PointsRec^;
      Dispose(PointsRec);
      PatternList.Delete(i);
      if (i > 0) then
        dec(i);
    end
    else
      inc(i);
  end;

  SetLength(Pattern, PatternList.Count);
  for i := 0 to PatternList.Count - 1 do
  begin
    PointsRec := PatternList[i];
    ThePoint := PointsRec^;
    Pattern[i].x := round(ThePoint.x);
    Pattern[i].y := round(ThePoint.y);
    Dispose(PointsRec);
  end;

  PatternList.Free;
end;

//Procedure to find the parallel line either side of line through Point1, Point2 and dist away from it.
procedure ParallelLines(Point1, Point2: TPoint;
                        Dist: double;
                        var m, NegParaC, PosParaC: double);
var
  c: double;

begin
  if (Point1.y - Point2.y) = 0 then
    m := 0
  else if (Point1.x - Point2.x) = 0 then
    m := UNDEFINED
  else
    m := (Point1.y - Point2.y) / (Point1.x - Point2.x);

  c := (Point1.y) - (m * Point1.x);
  NegParaC := c - Dist * SqRt(Power(m, 2) + 1);
  PosParaC := c + Dist * SqRt(Power(m, 2) + 1);
end;

//Intersect line through Point with circle - there will be two intersections, xPlus and xMinus.
procedure IntersectCircle(Point: TPoint;
                          r, m, c: double;
                          var xPlus, xMinus: double);
var
  RootIt, mcy2: double;

begin
  if c = UNDEFINED then
  begin
    xPlus := Point.X;
    xMinus := Point.X;
  end
  else
  begin
    mcy2 := 2 * m * (c - Point.Y);
    RootIt := abs(Power((-2 * Point.X) + mcy2, 2) - (4 * (1 + Power(m, 2)) * (Power(Point.X, 2) + Power(c - Point.Y, 2) - Power(r, 2))));

    xPlus := (- ((-2 * Point.X) + mcy2) + sqrt(RootIt)) / (2 * (1 + Power(m, 2)));
    xMinus := (- ((-2 * Point.X) + mcy2) - sqrt(RootIt)) / (2 * (1 + Power(m, 2)));
  end;
end;

//Find the equation of the line which bisects the angle described by the 3 points and the line perpendicular to the bisector.
procedure LineBisector(Point1, Point2, Point3: TPoint;
                       var c1, c2, m1, m2: double);
const
  BISRAD = 500;  //This can be anything as it is used to find the line - small number leads to less accuracy.

var
  c1to2, m1to2, c2to3, m2to3, xp1, xm1, xp2, xm2, yp1, yp2: double;

begin
  if Point1.x - Point2.x = 0 then
  begin
    m1to2 := UNDEFINED;
    c1to2 := UNDEFINED;
  end
  else
  begin
    m1to2 := (Point1.y - Point2.y) / (Point1.x - Point2.x);
    c1to2 := Point2.y - (m1to2 * Point2.x);
  end;

  if Point2.x - Point3.x = 0 then
  begin
    m2to3 := UNDEFINED;
    c2to3 := UNDEFINED;
  end
  else
  begin
    m2to3 := (Point2.y - Point3.y) / (Point2.x - Point3.x);
    c2to3 := Point2.y - (m2to3 * Point2.x);
  end;

  if (m1to2 = m2to3) then       //if the gradient of the lines is the same then bisector has a perpendicular
  begin                         //gradient and passes through Point2.  Other line is just same as line.
    if not(m1to2 = 0) then
    begin
      m1 := -1 / m1to2;           //set bisector in c1, m1 as this is what will then be tested first in FindGuidePoint.
      c1 := Point2.Y - (m1 * Point2.X);
    end
    else
    begin
      m1 := UNDEFINED;
      c1 := UNDEFINED;
    end;

    c2 := c1to2;
    m2 := m1to2;
  end
  else
  begin
    IntersectCircle(Point2, BISRAD, m1to2, c1to2, xp1, xm1);

    if m1to2 = UNDEFINED then
      yp1 := Point2.Y + BISRAD
    else
      yp1 := (m1to2 * xp1) + c1to2;

    IntersectCircle(Point2, BISRAD, m2to3, c2to3, xp2, xm2);

    if m2to3 = UNDEFINED then
      yp2 := Point2.Y + BISRAD
    else
      yp2 := (m2to3 * xp2) + c2to3;

    //Join pluses to get a line equation - subtracting 2 identical numbers does not always give exactly zero with double precision numbers.
    if abs(xp1 - xp2) < 0.000001 then
    begin
      m1 := UNDEFINED;
      c1 := UNDEFINED;
    end
    else
    begin
      m1 := (yp1 - yp2) / (xp1 - xp2);
      //Take line with this gradient thru Point2 - it's either a bisector or its perpendicular, but we need both anyway.
      c1 := Point2.Y - (m1 * Point2.X);
    end;

    if abs(m1) < 0.000001 then
    begin
      m2 := UNDEFINED;
      c2 := UNDEFINED;
    end
    else
    begin
      if m1 = UNDEFINED then
        m2 := 0
      else
        m2 := -1 / m1;
      c2 := Point2.Y - (m2 * Point2.X);
    end;
  end;
end;

//To check intersection point falls between end points of both lines.
function Intersected(Line1Point1, Line1Point2, Line2Point1, Line2Point2: TPoint;
                     c1, c2, m1, m2: double;
                     var x, y: double): Boolean;
var
  BetweenX1, BetweenX2, BetweenY1: Boolean;
  ThisX, ThisY: Variant;

begin
  BetweenX1 := False;
  BetweenX2 := False;
  BetweenY1 := False;
  Result := False;

  x := Line1Point2.X;
  y := Line1Point2.Y;
  LineIntersect(c1, c2, m1, m2, Line1Point1.x, Line2Point1.x, x, y);
  
  if IsEqual(x, round(x)) then
    ThisX := round(x)
  else
    ThisX := x;

  if IsEqual(y, round(y)) then
    ThisY := round(y)
  else
    ThisY := y;

  if (Line1Point1.X - Line1Point2.X < 0) and (Line1Point1.X - ThisX <= 0) and (abs(Line1Point1.X - Line1Point2.X) >= abs(Line1Point1.X - ThisX)) then
    BetweenX1 := True
  else if (Line1Point1.X - Line1Point2.X >= 0) and (Line1Point1.X - ThisX >= 0) and (abs(Line1Point1.X - Line1Point2.X) >= abs(Line1Point1.X - ThisX)) then
    BetweenX1 := True
  else if (Line1Point1.X - Line1Point2.X = 0) and (Line1Point1.X - ThisX = 0) then
    BetweenX1 := True;

  if BetweenX1 then
  begin
    if (Line1Point1.Y - Line1Point2.Y < 0) and (Line1Point1.Y - ThisY <= 0) and (abs(Line1Point1.Y - Line1Point2.Y) >= abs(Line1Point1.Y - ThisY)) then
      BetweenY1 := True
    else if (Line1Point1.Y - Line1Point2.Y >= 0) and (Line1Point1.Y - ThisY >= 0) and (abs(Line1Point1.Y - Line1Point2.Y) >= abs(Line1Point1.Y - ThisY)) then
      BetweenY1 := True
    else if (Line1Point1.Y - Line1Point2.Y = 0) and (Line1Point1.Y - ThisY = 0) then
      BetweenY1 := True;
  end;

  if BetweenY1 then
  begin
    if (Line2Point1.X - Line2Point2.X < 0) and (Line2Point1.X - ThisX <= 0) and (abs(Line2Point1.X - Line2Point2.X) >= abs(Line2Point1.X - ThisX)) then
      BetweenX2 := True
    else if (Line2Point1.X - Line2Point2.X >= 0) and (Line2Point1.X - ThisX >= 0) and (abs(Line2Point1.X - Line2Point2.X) >= abs(Line2Point1.X - ThisX)) then
      BetweenX2 := True
    else if (Line2Point1.X - Line2Point2.X = 0) and (Line2Point1.X - ThisX = 0) then
      BetweenX2 := True;
  end;

  if BetweenX2 then
  begin
    if (Line2Point1.Y - Line2Point2.Y < 0) and (Line2Point1.Y - ThisY <= 0) and (abs(Line2Point1.Y - Line2Point2.Y) >= abs(Line2Point1.Y - ThisY)) then
      Result := True
    else if (Line2Point1.Y - Line2Point2.Y >= 0) and (Line2Point1.Y - ThisY >= 0) and (abs(Line2Point1.Y - Line2Point2.Y) >= abs(Line2Point1.Y - ThisY)) then
      Result := True
    else if (Line2Point1.Y - Line2Point2.Y = 0) and (Line2Point1.Y - ThisY = 0) then
      Result := True;
  end;
end;

//Adds point to array if it is NOT a duplicate.
procedure AddPointToArray(x, y: double;
                          var ExpandedPattern: TPointArray);
begin
  if (Length(ExpandedPattern) = 0) or not((ExpandedPattern[Length(ExpandedPattern) - 1].X = round(x)) and (ExpandedPattern[Length(ExpandedPattern) - 1].Y = round(y))) then
  begin
    SetLength(ExpandedPattern, Length(ExpandedPattern) + 1);
    ExpandedPattern[Length(ExpandedPattern) - 1].X := round(x);
    ExpandedPattern[Length(ExpandedPattern) - 1].Y := round(y);
  end;
end;

//Adds point to array whether it's a duplicate or not.
procedure AddAnyPointToArray(x, y: double;
                             var ExpandedPattern: TPointArray);
begin
  SetLength(ExpandedPattern, Length(ExpandedPattern) + 1);
  ExpandedPattern[Length(ExpandedPattern) - 1].X := round(x);
  ExpandedPattern[Length(ExpandedPattern) - 1].Y := round(y);
end;

//Find where the expansion lines intersect each other - it's the same place as where they intersect the bisector, hence
//the bisector is used to find it.
procedure GetExpandedIntersections(Point1, Point2, Point3: TPoint;
                                   c, Expansion, GuideX, GuideY, m: double;
                                   var ParaInterX, ParaInterY: double);
var
  m1, NegParaC, PosParaC,  x, x2, y, y2: double;

begin
  //Find Parallel lines and which one to use (there are 2 parallels to every line).
  ParallelLines(Point1, Point2, Expansion, m1, NegParaC, PosParaC);
  if m1 = UNDEFINED then
    ParallelLines(Point2, Point3, Expansion, m1, NegParaC, PosParaC);

  //Find intersection of Parallels with bisector line.
  //Seed x and y values with a proper point.
  x := Point2.X;
  y := Point2.Y;
  x2 := x;
  y2 := y;
  LineIntersect(c, NegParaC, m, m1, x, x2, x, y);
  LineIntersect(c, PosParaC, m, m1, x, x2, x2, y2);

  //Determine which intersection is outside the pattern - i.e. the furthest from the Guide Point.
  if Distance(GuideX, GuideY, x, y) > Distance(GuideX, GuideY, x2, y2) then
  begin
    ParaInterX := x;
    ParaInterY := y;
  end
  else
  begin
    ParaInterX := x2;
    ParaInterY := y2;
  end;
end;

//Find where Expanded lines (parallel to originals) intersect corner circles
procedure FindCircleExpansionIntersections(Point1, Point2, Point3: TPoint;
                                           Expansion, ParaInterX, ParaInterY: double;
                                           var PreInterX, PreInterY, PostInterX, PostInterY: double);
var
  c, m: double;

begin
  //Lines are tangents, so plus and minus should be the 'same'.  Therefore only bother with xPlus.
  if Point1.X - Point2.X = 0 then
  begin
    PreInterX := ParaInterX;
    PreInterY := Point2.Y;
  end
  else if Point1.Y - Point2.Y = 0 then
  begin
    PreInterX := Point2.X;
    PreInterY := ParaInterY;
  end
  else
  begin
    m := (Point1.Y - Point2.Y) / (Point1.X - Point2.X);
    c := ParaInterY - (m * ParaInterX);
    IntersectCircle(Point2, Expansion, m, c, PreInterX, PreInterX);
    PreInterY := (m * PreInterX) + c;
  end;

  if Point2.X - Point3.X = 0 then
  begin
    PostInterX := ParaInterX;
    PostInterY := Point2.Y;
  end
  else if Point2.Y - Point3.Y = 0 then
  begin
    PostInterX := Point2.X;
    PostInterY := ParaInterY;
  end
  else
  begin
    m := (Point2.Y - Point3.Y) / (Point2.X - Point3.X);
    c := ParaInterY - (m * ParaInterX);
    IntersectCircle(Point2, Expansion, m, c, PostInterX, PostInterX);
    PostInterY := (m * PostInterX) + c;
  end;
end;

//Calculate where a circle of tiny radius intersects the bisectors and their perpendiculars.
//Find which of the 4 circle intersections are inside the pattern. This is Guide Point.
procedure FindGuidePoint(PrePoint, ThePoint, PostPoint: Tpoint;
                         c1, c2, m1, m2: double;
                         Pat: TPointArray;
                         NPoints: integer;
                         var c, m, GuideX, GuideY: double);
const
  GUIDEDIST = 1;

var
  xPlus, xMinus, y1, y2: double;
  P1In, P2In, GPSet, HorizontalLine, VerticalLine: boolean;
  Count: integer;
  PrePoint2D, ThePoint2D, PostPoint2D: TPoint2D;

begin
  PrePoint2D.x := PrePoint.x;
  PrePoint2D.y := PrePoint.y;
  ThePoint2D.x := ThePoint.x;
  ThePoint2D.y := ThePoint.y;
  PostPoint2D.x := PostPoint.x;
  PostPoint2D.y := PostPoint.y;
  GPSet := False;
  Count := 0;
  repeat
    m := m1;
    c := c1;
    HorizontalLine := (c = UNDEFINED);
    VerticalLine := (trunc(m * 1000) = 0);

    if VerticalLine then
    begin
      y1 := ThePoint.y + GUIDEDIST;
      y2 := ThePoint.y - GUIDEDIST;
      xPlus := ThePoint.X;
      xMinus := ThePoint.X;
    end
    else if HorizontalLine then
    begin
      y1 := ThePoint.y;
      y2 := ThePoint.y;
      xPlus := ThePoint.X + GUIDEDIST;
      xMinus := ThePoint.X - GUIDEDIST;
    end
    else
    begin
      IntersectCircle(ThePoint, GUIDEDIST, m, c, xPlus, xMinus);
      y1 := (m * XPlus) + c;
      y2 := (m * XMinus) + c;
    end;

    P1In := PointInAndOnPolygon(xPlus, y1, NPoints, Pat);
    P2In := PointInAndOnPolygon(xMinus, y2, NPoints, Pat);

    if (P1In or P2In) and (not(P1In and P2In)) and not((IsPointCollinear(PrePoint2D, ThePoint2D, xPlus, y1)) or
      (IsPointCollinear(ThePoint2D, PostPoint2D, xPlus, y1)) or
      (IsPointCollinear(PrePoint2D, ThePoint2D, xMinus, y2)) or
      (IsPointCollinear(ThePoint2D, PostPoint2D, xMinus, y2))) then           //either inside but not both.
    begin
      GPSet := True;
      if P1In then
      begin
        GuideX := xPlus;
        GuideY := y1;
      end
      else
      begin
        GuideX := xMinus;
        GuideY := y2;
      end;
    end;

    if (not GPset) or (GPSet and (IsPointCollinear(PrePoint2D, ThePoint2D, GuideX, GuideY) or
      IsPointCollinear(ThePoint2D, PostPoint2D, GuideX, GuideY))) then
    begin
      m := m2;
      c := c2;
      HorizontalLine := (c = UNDEFINED);
      VerticalLine := (trunc(m * 1000) = 0);

      if VerticalLine then
      begin
        y1 := ThePoint.y + GUIDEDIST;
        y2 := ThePoint.y - GUIDEDIST;
        xPlus := ThePoint.X;
        xMinus := ThePoint.X;
      end
      else if HorizontalLine then
      begin
        y1 := ThePoint.y;
        y2 := ThePoint.y;
        xPlus := ThePoint.X + GUIDEDIST;
        xMinus := ThePoint.X - GUIDEDIST;
      end
      else
      begin
        IntersectCircle(ThePoint, GUIDEDIST, m, c, xPlus, xMinus);
        y1 := (m * XPlus) + c;
        y2 := (m * XMinus) + c;
      end;

      P1In := PointInAndOnPolygon(xPlus, y1, NPoints, Pat);
      P2In := PointInAndOnPolygon(xMinus, y2, NPoints, Pat);

      if (P1In or P2In) and not(P1In and P2In) then            //either inside but not both.
      begin
        GPSet := True;
        if P1In then
        begin
          GuideX := xPlus;
          GuideY := y1;
        end
        else
        begin
          GuideX := xMinus;
          GuideY := y2;
        end;
      end;
    end;
    if not GPSet then
    begin
      c1 := UNDEFINED;
      c2 := UNDEFINED;
    end;
    inc(Count);
  until GPSet or (Count = 2);
end;

//Find the bisector/expansion circle intersection which lies furthest from Guide Point - i.e. outside the pattern.
procedure OutsideCircleBisectorIntersection(Point: TPoint;
                                            c, Expansion, GuideX, GuideY, m, xPlus, xMinus: double;
                                            xMax, xMin, yMax, yMin: integer;
                                            var BisX, BisY: double);
var
  yPlus, yMinus: double;
  TryAgain: Boolean;
  Count: integer;

begin
  Count := 0;
  TryAgain := False;
  repeat
    inc(Count);
    if m = UNDEFINED then
    begin
      yPlus := Point.Y + Expansion;
      yMinus := Point.Y - Expansion;
    end
    else
    begin
      yPlus := (m * xPlus) + c;
      yMinus := (m * xMinus) + c;
    end;

    if Distance(GuideX, GuideY, xMinus, yMinus) > Distance(GuideX, GuideY, xPlus, yPlus) then
    begin
      BisX := xMinus;
      BisY := yMinus;
    end
    else
    begin
      BisX := xPlus;
      BisY := yPlus;
    end;

    if (BisX > xMax) or (BisX < xMin) or (BisY > yMax) or (BisY < yMin) then
    begin
      m := UNDEFINED;
      TryAgain := True;
    end;
  until (not TryAgain) or (Count = 2);
end;

function LineOnLine(Pi1, Pi2, Pj: TPoint;
                    var x, y: double): boolean;
var
  ThePoint: TPoint2D;
  TheLine: TLine2D;

begin
  Result := False;
  if not(((Pj.x = Pi1.x) and (Pj.y = Pi1.y)) or ((Pj.x = Pi2.x) and (Pj.y = Pi2.y))) then
  begin
    ThePoint.x := Pj.X;               //         i ______
    ThePoint.y := Pj.Y;               //          |
    TheLine[1].x := Pi1.X;            //    j2____|j
    TheLine[1].y := Pi1.Y;            //          ||
    TheLine[2].x := Pi2.X;            //          ||            || shows where line goes back on itself
    TheLine[2].y := Pi2.Y;            //         i2
    Result := PointInObject(ThePoint, TheLine);     //tests Colinearity
    if Result and ((((ThePoint.x >= TheLine[1].x) and (ThePoint.x <= TheLine[2].x)) or    //makes sure point is within line
                    ((ThePoint.x >= TheLine[2].x) and (ThePoint.x <= TheLine[1].x))) and
                   (((ThePoint.y >= TheLine[1].y) and (ThePoint.y <= TheLine[2].y)) or
                    ((ThePoint.y >= TheLine[2].y) and (ThePoint.y <= TheLine[1].y)))) then
    begin
      x := Pj.X;
      y := Pj.Y;
    end
    else
      Result := False;

    if not Result then
    begin
      ThePoint.x := Pi1.X;            //        i2||            || shows where line goes back on itself
      ThePoint.y := Pi1.Y;            //          ||
      TheLine[1].x := Pi2.X;          //         i||______
      TheLine[1].y := Pi2.Y;          //          |
      TheLine[2].x := Pj.X;           //     _____|
      TheLine[2].y := Pj.Y;           //    j2   j
      Result := PointInObject(ThePoint, TheLine);   //tests Colinearity
      if Result and ((((ThePoint.x >= TheLine[1].x) and (ThePoint.x <= TheLine[2].x)) or  //makes sure point is within line
                      ((ThePoint.x >= TheLine[2].x) and (ThePoint.x <= TheLine[1].x))) and
                     (((ThePoint.y >= TheLine[1].y) and (ThePoint.y <= TheLine[2].y)) or
                      ((ThePoint.y >= TheLine[2].y) and (ThePoint.y <= TheLine[1].y)))) then
      begin
        x := Pi1.X;
        y := Pi1.Y;
      end
      else
        Result := False;
    end;
  end;
end;

procedure EliminatePatternLoops(var Pattern: TPointArray);
type
  TijIntersection = record
    i, i2, j, j2: integer;
    iLineEndInt, jLineEndInt: boolean;
    IntPoint: TPoint;
  end;

var
  i, i2, j, j2, k, Endj, EndList, ListPos1, ListPos2, PointOnHull, xLine, Temp: integer;
  c1, c2, m1, m2, x, y, PatBit, Perim: double;
  Points: array of TPoint2D;
  Hull: TPolygon2D;
  FoundIntersection, FoundPoint: boolean;
  Intersection: TijIntersection;
  PatternList: TList;
  PointsRec, PointsRec2: PPatternList;
  APoint, APoint2: TPoint2D;

begin
  //NOT A CLOSED PATTERN
  repeat
    i := 0;
    FoundIntersection := False;

    i2 := i + 1;
    while not(i = Length(Pattern) - 1) and not FoundIntersection do
    begin
      MakeLine(Pattern[i], Pattern[i2], c1, m1, xLine);

      j := i2 + 1;
      if j = Length(Pattern) then
        j := 0;

      j2 := j + 1;
      if j2 = Length(Pattern) then
        j2 := 0;

      Endj := i - 2;                           //ensure we never touch either end of i line with a j line.
      if Endj < 0 then
        Endj := Length(Pattern) - 1;

      while not(j = Endj) and not FoundIntersection do
      begin
        if j = i2 + 1 then                          //check we don't go up and down same line.
         FoundIntersection := LineOnLine(Pattern[i], Pattern[i2], Pattern[j], x, y);

        if not FoundIntersection then
        begin
          MakeLine(Pattern[j], Pattern[j2], c2, m2, xLine);
          //don't want to test if the gradients are equal because colinear line intersections are not what we want
          if (m1 <> m2) then
            FoundIntersection := Intersected(Pattern[i], Pattern[i2], Pattern[j], Pattern[j2],
                                             c1, c2, m1, m2, x, y);
        end;

        if not FoundIntersection then
        begin
          if ((Pattern[i].x = Pattern[j].x) and (Pattern[i].y = Pattern[j].y)) or
             ((Pattern[i].x = Pattern[j2].x) and (Pattern[i].y = Pattern[j2].y)) then
          begin
            FoundIntersection := True;
            x := Pattern[i].x;
            y := Pattern[i].y;
          end
          else if ((Pattern[i2].x = Pattern[j].x) and (Pattern[i2].y = Pattern[j].y)) or
                  ((Pattern[i2].x = Pattern[j2].x) and (Pattern[i2].y = Pattern[j2].y)) then
          begin
            FoundIntersection := True;
            x := Pattern[i2].x;
            y := Pattern[i2].y;
          end

          else if (Pattern[j].y = Pattern[j2].y) and (Pattern[i].y = Pattern[j].y) and
                  (((Pattern[i].X <= Pattern[j].X) and (Pattern[i].X >= Pattern[j2].X)) or
                   ((Pattern[i].X >= Pattern[j].X) and (Pattern[i].X <= Pattern[j2].X))) then
          begin
            FoundIntersection := True;
            x := Pattern[i].x;
            y := Pattern[i].y;
          end
          else if (Pattern[j].y = Pattern[j2].y) and (Pattern[i2].y = Pattern[j].y) and
                  (((Pattern[i2].X <= Pattern[j].X) and (Pattern[i2].X >= Pattern[j2].X)) or
                   ((Pattern[i2].X >= Pattern[j].X) and (Pattern[i2].X <= Pattern[j2].X))) then
          begin
            FoundIntersection := True;
            x := Pattern[i2].x;
            y := Pattern[i2].y;
          end
          else if (Pattern[i].y = Pattern[i2].y) and (Pattern[j].y = Pattern[i].y) and
                  (((Pattern[j].X <= Pattern[i].X) and (Pattern[j].X >= Pattern[i2].X)) or
                   ((Pattern[j].X >= Pattern[i].X) and (Pattern[j].X <= Pattern[i2].X))) then
          begin
            FoundIntersection := True;
            x := Pattern[j].x;
            y := Pattern[j].y;
          end
          else if (Pattern[i].y = Pattern[i2].y) and (Pattern[j2].y = Pattern[i].y) and
                  (((Pattern[j2].X <= Pattern[i].X) and (Pattern[j2].X >= Pattern[i2].X)) or
                   ((Pattern[j2].X >= Pattern[i].X) and (Pattern[j2].X <= Pattern[i2].X))) then
          begin
            FoundIntersection := True;
            x := Pattern[j2].x;
            y := Pattern[j2].y;
          end
          else if (Pattern[j].X = Pattern[j2].X) and (Pattern[i].X = Pattern[j].X) and
                  (((Pattern[i].Y <= Pattern[j].Y) and (Pattern[i].Y >= Pattern[j2].Y)) or
                   ((Pattern[i].Y >= Pattern[j].Y) and (Pattern[i].Y <= Pattern[j2].Y))) then
          begin
            FoundIntersection := True;
            x := Pattern[i].Y;
            y := Pattern[i].X;
          end
          else if (Pattern[j].X = Pattern[j2].X) and (Pattern[i2].X = Pattern[j].X) and
                  (((Pattern[i2].Y <= Pattern[j].Y) and (Pattern[i2].Y >= Pattern[j2].Y)) or
                   ((Pattern[i2].Y >= Pattern[j].Y) and (Pattern[i2].Y <= Pattern[j2].Y))) then
          begin
            FoundIntersection := True;
            x := Pattern[i2].Y;
            y := Pattern[i2].X;
          end
          else if (Pattern[i].X = Pattern[i2].X) and (Pattern[j].X = Pattern[i].X) and
                  (((Pattern[j].Y <= Pattern[i].Y) and (Pattern[j].Y >= Pattern[i2].Y)) or
                   ((Pattern[j].Y >= Pattern[i].Y) and (Pattern[j].Y <= Pattern[i2].Y))) then
          begin
            FoundIntersection := True;
            x := Pattern[j].Y;
            y := Pattern[j].X;
          end
          else if (Pattern[i].X = Pattern[i2].X) and (Pattern[j2].X = Pattern[i].X) and
                  (((Pattern[j2].Y <= Pattern[i].Y) and (Pattern[j2].Y >= Pattern[i2].Y)) or
                   ((Pattern[j2].Y >= Pattern[i].Y) and (Pattern[j2].Y <= Pattern[i2].Y))) then
          begin
            FoundIntersection := True;
            x := Pattern[j2].Y;
            y := Pattern[j2].X;
          end;
        end;

        if FoundIntersection then
        begin
          if ((Pattern[i].X = round(x)) and (Pattern[i].Y = round(y))) or
             ((Pattern[i2].X = round(x)) and (Pattern[i2].Y = round(y))) then
            Intersection.iLineEndInt := True
          else
            Intersection.iLineEndInt := False;

          Intersection.i := i;
          Intersection.i2 := i2;

          if ((Pattern[j].X = round(x)) and (Pattern[j].Y = round(y))) or
             ((Pattern[j2].X = round(x)) and (Pattern[j2].Y = round(y))) then
            Intersection.jLineEndInt := True
          else
            Intersection.jLineEndInt := False;

          Intersection.j := j;
          Intersection.j2 := j2;

          Intersection.IntPoint.x := round(x);
          Intersection.IntPoint.y := round(y);
        end
        else
          FoundIntersection := False;  //If problems start looking here.

        inc(j);
        if j = Length(Pattern) then
          j := 0;

        j2 := j + 1;
        if j2 = Length(Pattern) then
          j2 := 0;
      end;

      inc(i);
      if i = Length(Pattern) then
        i := 0;

      i2 := i + 1;
      if i2 = Length(Pattern) then
        i2 := 0;
    end;

    k := 0;
    if FoundIntersection then
    begin
      if (Intersection.i > Intersection.j) then   //order points ascending
      begin
        Temp := Intersection.i;
        Intersection.i := Intersection.j;
        Intersection.j := Temp;

        Temp := Intersection.i2;
        Intersection.i2 := Intersection.j2;
        Intersection.j2 := Temp;
      end;

      PatternList := TList.Create;

      while not(k > Intersection.i) do
      begin
        //Add points to list
        New(PointsRec);
        PointsRec^.x := Pattern[k].X;
        PointsRec^.y := Pattern[k].Y;
        PatternList.Add(PointsRec);
        inc(k);
      end;

      if not(Intersection.iLineEndInt) then
      begin
        New(PointsRec);
        PointsRec^.x := Intersection.IntPoint.X;
        PointsRec^.y := Intersection.IntPoint.Y;
        PatternList.Add(PointsRec);
        ListPos1 := k;
      end
      else if (Pattern[Intersection.i].X = Intersection.IntPoint.X)  and
              (Pattern[Intersection.i].Y = Intersection.IntPoint.Y) then
        ListPos1 := Intersection.i
      else
        ListPos1 := Intersection.i2;

      while not(k > Intersection.j) do
      begin
        //Add points to list
        New(PointsRec);
        PointsRec^.x := Pattern[k].X;
        PointsRec^.y := Pattern[k].Y;
        PatternList.Add(PointsRec);
        inc(k);
      end;

      if not(Intersection.jLineEndInt) then
      begin
        New(PointsRec);
        PointsRec^.x := Intersection.IntPoint.X;
        PointsRec^.y := Intersection.IntPoint.Y;
        PatternList.Add(PointsRec);
        ListPos2 := k;
      end
      else if (Pattern[Intersection.j].X = Intersection.IntPoint.X)  and
              (Pattern[Intersection.j].Y = Intersection.IntPoint.Y) then
        ListPos2 := Intersection.j
      else
        ListPos2 := Intersection.j2;

      while not(k >= Length(Pattern)) do
      begin
        //Load points into list
        New(PointsRec);
        PointsRec^.x := Pattern[k].X;
        PointsRec^.y := Pattern[k].Y;
        PatternList.Add(PointsRec);
        inc(k);
      end;

      //delete loop or spike from pattern
      //Find distance around pattern...
      Perim := 0;
      for i := 0 to Length(Pattern) - 2 do
        Perim := Perim + Distance(Pattern[i].x, Pattern[i].y, Pattern[i + 1].x, Pattern[i + 1].y);
      Perim := Perim + Distance(Pattern[Length(Pattern) - 1].x, Pattern[Length(Pattern) - 1].y, Pattern[0].x, Pattern[0].y);   //close it

      //...and distance between ListPos1 and ListPos2 - it won't cross zero
      PatBit := 0;
      for i := ListPos1 to ListPos2 - 1 do
      begin
        PointsRec := PatternList[i];
        APoint := PointsRec^;
        PointsRec2 := PatternList[i + 1];
        APoint2 := PointsRec2^;
        PatBit := PatBit + Distance(APoint.x, APoint.y, APoint2.x, APoint2.y);
      end;

      EndList := PatternList.Count - 1;
      //Test sizes of both bits of pattern...
      if (PatBit > Perim - PatBit) then         //keep ListPos1 to ListPos2 - delete 0 to ListPos1 and ListPos2 to end
      begin
        for i := EndList downto ListPos2 + 2 do //1 do  ensure we keep one instance of intersection point
        begin
          Dispose(PatternList[i]);
          PatternList.Delete(i);
        end;

        for i := ListPos1 downto 0 do  //includes removal of duplicate intersection point
        begin
          Dispose(PatternList[i]);
          PatternList.Delete(i);
        end;
      end
      else                     //delete between ListPos1 and ListPos2
        for i := ListPos2 downto ListPos1 + 1 do  //includes removal of duplicate intersection point if it was inserted by us
        begin
          Dispose(PatternList[i]);
          PatternList.Delete(i);
        end;  

      //Copy Patternlist back to Pattern Array.
      SetLength(Pattern, PatternList.Count);
      for i := 0 to PatternList.Count - 1 do
      begin
        PointsRec := PatternList[i];
        APoint := PointsRec^;
        Pattern[i].X := round(APoint.x);
        Pattern[i].Y := round(APoint.y);
        Dispose(PointsRec);      //this disposes of the blocks of memory allocated to the pointer locations
      end;                       //of each entry in PatternList
      FreeAndNil(PatternList);
    end;
  until (i = Length(Pattern) - 1) and not FoundIntersection;
end;

{procedure EliminatePointsWithinIntersections(var ExpandedPattern: TPointArray);
type
  ijIntersection = record
    i, j: integer;
    IntPoint: TPoint;
  end;

var
  i, i2, j, j2, Endj, EndPoint, IntCount, PointOnHull, xLine: integer;
  c1, c2, m1, m2, x, y: double;
  Points: array of TPoint2D;
  Hull: TPolygon2D;
  FoundIntersection, FoundPoint: boolean;
  IntsInExpandedPattern: TPointArray;
  IntersectionArray: array of ijIntersection;
  Eliminate: array of boolean;

begin
  //NOT A CLOSED PATTERN
  IntCount := 0;

  SetLength(Points, Length(ExpandedPattern));
  for i := 0 to Length(ExpandedPattern) - 1 do
  begin
    Points[i].x := ExpandedPattern[i].X;
    Points[i].y := ExpandedPattern[i].Y;
  end;
  Hull := CreateConvexHull(Points);

  i := 0;
  FoundPoint := False;
  while not FoundPoint and not(i = Length(ExpandedPattern)) do
  begin
    j := 0;
    while not FoundPoint and not(j = Length(Hull)) do
    begin
      if (Points[i].x = Hull[j].x) and (Points[i].y = Hull[j].y) then
        FoundPoint := True
      else
        inc(j);
    end;

    if not FoundPoint then
      inc(i);
  end;

  PointOnHull := i;

  if (i = 0) then
    EndPoint := Length(ExpandedPattern) - 1
  else
    EndPoint := i - 1;

  i2 := i + 1;
  if i2 = Length(ExpandedPattern) then
    i2 := 0;

  while not(i = EndPoint) do
  begin
    MakeLine(ExpandedPattern[i], ExpandedPattern[i2], c1, m1, xLine);

    j := i2 + 1;
    if j = Length(ExpandedPattern) then
      j := 0;

    j2 := j + 1;
    if j2 = Length(ExpandedPattern) then
      j2 := 0;

    Endj := i - 2;                           //ensure we never touch either end of i line with a j line.
    if Endj = -1 then
      Endj := Length(ExpandedPattern) - 1
    else if Endj = -2 then
      Endj := Length(ExpandedPattern) - 2;

    while not(j = Endj) do
    begin
      MakeLine(ExpandedPattern[j], ExpandedPattern[j2], c2, m2, xLine);

      FoundIntersection := Intersected(ExpandedPattern[i], ExpandedPattern[i2], ExpandedPattern[j], ExpandedPattern[j2],
                                       c1, c2, m1, m2, x, y);

      if FoundIntersection and (j > i ) then
      begin
        inc(IntCount);
        SetLength(IntersectionArray, IntCount);
        IntersectionArray[IntCount - 1].i := i;
        IntersectionArray[IntCount - 1].j := j;
        IntersectionArray[IntCount - 1].IntPoint.x := round(x);
        IntersectionArray[IntCount - 1].IntPoint.y := round(y);
      end;

      inc(j);
      if j = Length(ExpandedPattern) then
        j := 0;

      j2 := j + 1;
      if j2 = Length(ExpandedPattern) then
        j2 := 0;
    end;

    inc(i);
    if i = Length(ExpandedPattern) then
      i := 0;

    i2 := i + 1;
    if i2 = Length(ExpandedPattern) then
      i2 := 0;
  end;

  SetLength(Eliminate, Length(ExpandedPattern));
  SetLength(IntsInExpandedPattern, Length(ExpandedPattern));
  for i := 0 to Length(ExpandedPattern) - 1 do
  begin
    Eliminate[i] := False;
    IntsInExpandedPattern[i] := ExpandedPattern[i];
  end;

  for i := 0 to IntCount - 1 do
  begin
    IntsInExpandedPattern[IntersectionArray[i].i + 1] := IntersectionArray[i].IntPoint;

    if (IntersectionArray[i].i < PointOnHull) and (IntersectionArray[i].j > PointOnHull) then
      for j := IntersectionArray[i].j to IntersectionArray[i].i + 2 do
        Eliminate[j] := True
    else
      for j := IntersectionArray[i].i + 2 to IntersectionArray[i].j do
        Eliminate[j] := True;
  end;

  j := 0;
  for i := 0 to Length(IntsInExpandedPattern) - 1 do
  begin
    if not Eliminate[i] then
    begin
      inc(j);
      SetLength(ExpandedPattern, j);
      ExpandedPattern[j - 1] := IntsInExpandedPattern[i];
    end;
  end;
end;

//Eliminates areas of the expanded pattern which lie too close to the original pattern
procedure EliminatePointsTooClose(var Pat: TPointArray;
                                  var ExpandedPattern: TPointArray;
                                  var Expansion: integer);
type
  PPatList = ^TPoint2D;

const
  DistanceAdjuster = 1;

var
  i, j, NPoints, xLine: integer;
  c1, c2, m1, m2, x, y: double;
  ExpPatList: TList;
  P1i, P2i, P1j, P2j, PointsRec, NextPointsRec: PPatList;
  PatPolygon: TPolygon2D;
  APoint, Point2D, NextPoint2D: TPoint2D;
  ATPoint1, ATPoint2, ATPoint3, ATPoint4: TPoint;

begin
  if not((ExpandedPattern[0].X = ExpandedPattern[Length(ExpandedPattern) - 1].X) and (ExpandedPattern[0].Y = ExpandedPattern[Length(ExpandedPattern) - 1].Y)) then   //ensure shape is closed
  begin
    SetLength(ExpandedPattern, Length(ExpandedPattern) + 1);
    ExpandedPattern[Length(ExpandedPattern) - 1].X := ExpandedPattern[0].X;
    ExpandedPattern[Length(ExpandedPattern) - 1].Y := ExpandedPattern[0].Y;
  end;

  NPoints := Length(Pat);

  SetLength(PatPolygon, NPoints);
  for i := 0 to NPoints - 1 do
  begin
    PatPolygon[i].x := Pat[i].X;
    PatPolygon[i].y := Pat[i].Y;
  end;

  ExpPatList := TList.Create;
  for i := 0 to Length(ExpandedPattern) - 1 do
  begin
    //Load points into list
    New(PointsRec);
    PointsRec^.x := ExpandedPattern[i].X;
    PointsRec^.y := ExpandedPattern[i].Y;
    ExpPatList.Add(PointsRec);
  end;

  //Don't forget lists are zero based
  i := 0;
  while not(i = ExpPatList.Count - 2) do    //minus 1 for zero basedness and 1 for i + 1 use.  Therefore 2.
  begin
    P1i := ExpPatList[i];
    P2i := ExpPatList[i + 1];

    ATPoint1.X := round(P1i^.X);            //okay to round here because points are still integers really
    ATPoint1.Y := round(P1i^.Y);
    ATPoint2.X := round(P2i^.X);
    ATPoint2.Y := round(P2i^.Y);

    MakeLine(ATPoint1, ATPoint2, c1, m1, xLine);

    j := i + 2;
    while not(j >= ExpPatList.Count - 2) do
    begin
      P1j := ExpPatList[j];
      P2j := ExpPatList[j + 1];

      ATPoint3.X := round(P1j^.X);          //okay to round here because points are still integers really
      ATPoint3.Y := round(P1j^.Y);
      ATPoint4.X := round(P2j^.X);
      ATPoint4.Y := round(P2j^.Y);

      MakeLine(ATPoint3, ATPoint4, c2, m2, xLine);

      if Intersected(ATPoint1, ATPoint2, ATPoint3, ATPoint4, c1, c2, m1, m2, x, y) then
      begin
        //replace the i + 1 point with the intersection point if there is an intersection.
        APoint.X := x;
        APoint.Y := y;
        New(PointsRec);
        PointsRec^ := APoint;
        ExpPatList.Insert(i + 1, PointsRec);
        inc(i);        //need to inc everything by 1 because of the insert
        inc(j);
      end;
      inc(j);
    end;
    inc(i);
  end;

  //Check for points too close.
  i := 0;
  while not(i = ExpPatList.Count) do
  begin
    PointsRec := ExpPatList[i];
    Point2D.x := PointsRec^.X;
    Point2D.y := PointsRec^.Y;
    if (round(MinimumDistanceFromPointToPolygon(Point2D, PatPolygon)) + DistanceAdjuster < Expansion) or      //-1 needed because rounding errors creep in
       (PointInAndOnPolygon(Point2D.x, Point2D.y, NPoints, Pat)) then
    begin
      Dispose(ExpPatList[i]);
      ExpPatList.Delete(i);
    end
    else
      inc(i);
  end;

  ExpPatList.Capacity := ExpPatList.Count;
  SetLength(ExpandedPattern, 0);

  //Now put points back in array
  for i := 0 to ExpPatList.Count - 1 do
  begin
    PointsRec := ExpPatList[i];
    APoint := PointsRec^;
    SetLength(ExpandedPattern, Length(ExpandedPattern) + 1);
    ExpandedPattern[Length(ExpandedPattern) - 1].X := round(APoint.x);
    ExpandedPattern[Length(ExpandedPattern) - 1].Y := round(APoint.y);
    Dispose(PointsRec);     //frees each section of memory used to store points.
  end;

  FreeAndNil(ExpPatList);
end;                  }

function IsClosePoint(ThePointX, ThePointY: Double;
                      var ThePattern: TPointArray;
                      var Expansion: integer): boolean;

const
  DistanceAdjuster = 1;

var
  i: integer;
  Point2D: TPoint2D;
  PatPolygon: TPolygon2D;

begin
  SetLength(PatPolygon, Length(ThePattern));
  for i := 0 to Length(PatPolygon) - 1 do
  begin
    PatPolygon[i].x := ThePattern[i].X;
    PatPolygon[i].y := ThePattern[i].Y;
  end;

  Point2D.x := ThePointX;
  Point2D.y := ThePointY;

  if (round(MinimumDistanceFromPointToPolygon(Point2D, PatPolygon)) + DistanceAdjuster < Expansion) or      //DistanceAdjuster needed because rounding errors creep in
     (PointInAndOnPolygon(ThePointX, ThePointY, Length(ThePattern), ThePattern)) then
    Result := True
  else
    Result := False;
end;

//Calculate a point on the circle half way between Point1 and Point2.
procedure RadiusPoint(ThePoint, Point1, Point2: TPoint;
                      Expansion: integer;
                      var x, y: double);
var
  c, m, xPlus, xMinus, yPlus, yMinus: double;

begin
  if (Point2.Y - Point1.Y = 0) then          //Find Perpendicular to chord joining 2 circle expansion points
  begin                                      //which goes through ThePoint - this will bisect the new angle.
    m := UNDEFINED;
    c := UNDEFINED;
  end
  else
  begin
    m := - (Point2.X - Point1.X) / (Point2.Y - Point1.Y);
    c := ThePoint.Y - (m * ThePoint.X);
  end;
  IntersectCircle(ThePoint, Expansion, m, c, xPlus, xMinus);
  if m = UNDEFINED then
  begin
    yPlus := ThePoint.Y + Expansion;
    yMinus := ThePoint.Y - Expansion;
  end
  else
  begin
    yPlus := (m * xPlus) + c;
    yMinus := (m * xMinus) + c;
  end;
  if Distance(Point1.X, Point1.Y, round(xPlus), round(yPlus)) >
     Distance(Point1.X, Point1.Y, round(xMinus), round(yMinus)) then
  begin
    x := xMinus;
    y := yMinus;
  end
  else
  begin
    x := xPlus;
    y := yPlus;
  end;
end;

procedure CloseNarrowGaps(Expansion, DoneToPoint: integer;
                          var Pattern: TPointArray);
type
  TIntInfo = record
    Dist: double;
    i, i2, j, j2, ClosePoint: integer;
    Intersected: TPoint2D;
  end;

//CJY Index Safe Incrementation
  procedure IncIndex(var x: integer; n, max: integer);
  begin
    if max > 0 then
    begin
      Inc(x, n);
      while x < 0 do
        x := x + (max + 1);
      x := x mod (max + 1);
    end
    else
      x := 0;
  end;

var
  i, i2, j, j2, k, k2, After, Before, ClosestPointToInt, DuplicatePointIndex, Testi2, Testj2: integer;
  PatternInters: TIntInfo;
  Hull, Pattern2D: TPolygon2D;
  IntPoint: TPoint2D;
  ThisDist, ThisDist1, ThisDist2, jDist: double;
  FoundIntersection, jWithinDup, j2WithinDup: boolean;
  temp1, temp2: double;
  temp3: boolean;
  temp4: TPoint2D;
//CJY For the point safe Updated Pattern Array
  PatternKept: TPointArray;
  PatternSetA: TPolygon2D;
  PatternSetB: TPolygon2D;

const
  DUPLICATELIMIT = 10;

begin
  FoundIntersection := False;
  DuplicatePointIndex := -1;
  SetLength(Pattern2D, Length(Pattern));
  for i := 0 to Length(Pattern2D) - 1 do
  begin
    Pattern2D[i].x := Pattern[i].x;
    Pattern2D[i].y := Pattern[i].y;
    PatternInters.Dist := 99999;
  end;

  Hull := CreateConvexHull(Pattern2D);
  //Hull Pattern and reorder points so point 0 is definitely a hull point.
  //Look for Pattern point index where the point is the same as Hull[0]
  i := 0;
  while not((round(Hull[0].x) = Pattern2D[i].x) and (round(Hull[0].y) = Pattern2D[i].y)) do
    inc(i);

  if (i > 0) then
  begin
    k := 0;
    for j := i to Length(Pattern) - 1 do
    begin
      Pattern2D[k].x := Pattern[j].x;
      Pattern2D[k].y := Pattern[j].y;
      inc(k);
    end;

    for j := 0 to i - 1 do
    begin
      Pattern2D[k].x := Pattern[j].x;
      Pattern2D[k].y := Pattern[j].y;
      inc(k);
    end;

    for i := 0 to Length(Pattern) - 1 do
    begin
      Pattern[i].x := round(Pattern2D[i].x);
      Pattern[i].y := round(Pattern2D[i].y);
    end;
  end;

  i := DoneToPoint;
  while (i <= Length(Pattern2D) - 1) and (not FoundIntersection) do
  begin
    i2 := i + 1;
    if i2 = Length(Pattern2D) then
      i2 := 0;
    Testi2 := i2 + 1;
    if Testi2 = Length(Pattern2D) then
      Testi2 := 0;

    j := 0;
    while (j <= Length(Pattern2D) - 1) do
    begin
      j2 := j + 1;
      if j2 = Length(Pattern2D) then
        j2 := 0;
      Testj2 := j2 + 1;
      if Testj2 = Length(Pattern2D) then
        Testj2 := 0;

      if (j <> i) and (j2 <> i) and (j <> i2) and (j2 <> i2) and
        (not Parallel(Pattern2D[i], Pattern2D[i2], Pattern2D[j], Pattern2D[j2])) then
      begin
        IntPoint := IntersectionPoint(Pattern2D[i], Pattern2D[i2], Pattern2D[j], Pattern2D[j2]);
        jDist := Distance(Pattern2D[j].x, Pattern2D[j].y, Pattern2D[j2].x, Pattern2D[j2].y);
        ThisDist1 := Distance(Pattern2D[i].x, Pattern2D[i].y, IntPoint.x, IntPoint.y);
        ThisDist2 := Distance(Pattern2D[i2].x, Pattern2D[i2].y, IntPoint.x, IntPoint.y);
        if (ThisDist1 < ThisDist2) then
        begin
          ClosestPointToInt := i;
          ThisDist := ThisDist1;
        end
        else
        begin
          ClosestPointToInt := i2;
          ThisDist := ThisDist2;
        end;

        jWithinDup := (abs(round(IntPoint.x) - round(Pattern2D[j].x)) <= DUPLICATELIMIT) and (abs(round(IntPoint.y) - round(Pattern2D[j].y)) <= DUPLICATELIMIT);
        j2WithinDup := (abs(round(IntPoint.x) - round(Pattern2D[j2].x)) <= DUPLICATELIMIT) and (abs(round(IntPoint.y) - round(Pattern2D[j2].y)) <= DUPLICATELIMIT);

//        temp1 := Distance(Pattern2D[j].x, Pattern2D[j].y, IntPoint.x, IntPoint.y);
//        temp2 := Distance(Pattern2D[j2].x, Pattern2D[j2].y, IntPoint.x, IntPoint.y);
//        temp3 := PointInPolygon(SegmentMidPoint(Pattern2D[ClosestPointToInt], IntPoint), Pattern2D);
//        temp4 := SegmentMidPoint(Pattern2D[ClosestPointToInt], IntPoint);

        if ((Distance(Pattern2D[j].x, Pattern2D[j].y, IntPoint.x, IntPoint.y) <= jDist) and   //point is between j's
          (Distance(Pattern2D[j2].x, Pattern2D[j2].y, IntPoint.x, IntPoint.y) <= jDist) and
          (not((Testi2 = j) and jWithinDup)) and (not((Testj2 = i) and j2WithinDup))) then
        begin
          if not PointInPolygon(SegmentMidPoint(Pattern2D[ClosestPointToInt], IntPoint), Pattern2D) and
            (ThisDist < 2 * Expansion) and (ThisDist < PatternInters.Dist) then
          begin
            PatternInters.Dist := ThisDist;
            PatternInters.i := i;
            PatternInters.i2 := i2;
            PatternInters.j := j;
            PatternInters.j2 := j2;
            PatternInters.ClosePoint := ClosestPointToInt;
            PatternInters.Intersected := IntPoint;
            FoundIntersection := True;

            if jWithinDup then
              DuplicatePointIndex := j
            else if j2WithinDup then
              DuplicatePointIndex := j2
            else
               DuplicatePointIndex := -1;
          end;
        end;
      end;
      inc(j);
    end;
    inc(i);
  end;

  if (FoundIntersection) then
  begin
  {$IFDEF DEBUGFULL}
    fmDebugger.DrawIntLines(Pattern, ClosestPointToInt, round(PatternInters.Intersected.x), round(PatternInters.Intersected.y));
//    fmDebugger.Show;
  {$ENDIF}

//If any of the i, j points involved are 0 it really complicates things, so renumber the array and things
//in PatternInters
    if (PatternInters.i < PatternInters.j) then
    begin
      Before := PatternInters.i;   //if this is 0 then 0 point will have to go
      if (DuplicatePointIndex = -1) then
        After := PatternInters.j2
      else
        After := DuplicatePointIndex;
    end
    else
    begin
      if (DuplicatePointIndex = -1) then
        Before := PatternInters.j   //if this is 0 we should stop 1 short of i2
      else
        Before := DuplicatePointIndex;
      if Before = 0 then
        After := PatternInters.i2 - 1
      else
        After := PatternInters.i2;
    end;

    //This assumes that as 0 is on the Hull, the only intersection possible is AT point 0 where i < j
    //therefore there will be nothing to insert into the array
    if (Before = 0) and (Before = PatternInters.i) and (PatternInters.ClosePoint = PatternInters.i) then
    begin
      DoneToPoint := 1;
      for i := 1 to After do
        Pattern[i] := Pattern[i - 1];
    end
    else
    begin
      //Pattern is unchanged from 0 to Before. Should not need to add anything to the length of the Pattern array
      //even though it's adding a point in, it should be removing at least 2.
{
      i := Before + 1;
      DoneToPoint := i;
      if (DuplicatePointIndex = -1) then
      begin
        Pattern[i].x := round(PatternInters.Intersected.x);
        Pattern[i].y := round(PatternInters.Intersected.y);
        inc(i);
      end;

      if (After <> 0) and (After < Length(Pattern)) then
      begin
        for j := After to Length(Pattern) - 1 do
        begin
          Pattern[i] := Pattern[j];
          inc(i);
        end;
      end;

      SetLength(Pattern, i);
}
//CJY This version loops around from after the point to the before point, mapping
//    the point index to the modified point index on the fly. It is zero index safe.


      //CJY Start at last good point
      i := After;
      j := After;

      //CJY Store last index value for original pattern
      i2 := Length(Pattern);

      //CJY Calculate how many points are removed
      // + i2 ensures the point difference is positive for modulus calc
      k := ((After - Before - 1 + i2) mod i2);
      k2 := k;
      if (DuplicatePointIndex = -1) then
        Dec(k, 1);

      i2 := i2 - 1;
      j2 := i2 - k;

      if not ((After >= 0) and (After < k)) then
        Dec(j, k);

      IncIndex(Before, 1, i2);
//      IncIndex(After, 1, i2);

      //CJY Adding 0 to the j values will set it to an index safe value.
      IncIndex(j, 0, j2);

//      PatternSetA := TPolygon2D.Create();
//      PatternSetB := TPolygon2D.Create();
//      PatternKept := TPointArray.Create();
      SetLength(PatternSetA, j2 + 1);
      SetLength(PatternSetB, k2 + 1);

      repeat
        PatternSetA[j].x := Pattern[i].X;
        PatternSetA[j].y := Pattern[i].Y;

        IncIndex(i, 1, i2);
        IncIndex(j, 1, j2);
      until i = Before;

      k := 0;
      repeat
        PatternSetB[k].x := Pattern[i].X;
        PatternSetB[k].y := Pattern[i].Y;

        IncIndex(i, 1, i2);
        IncIndex(k, 1, k2);
      until i = After;

      if (DuplicatePointIndex = -1) then
      begin
//        Pattern2[j].x := Round(PatternInters.Intersected.x);
//        Pattern2[j].y := Round(PatternInters.Intersected.y);

//CJY The new point tweak... when the new point is added it can allow for another
//    to happen along the same line (in rare occasions). This intersect can
//    register as valid and despite crossing other intercepts (in rarer occasions).
//    nudging the new point (1, 1) towards the j point (furthest point in the
//    pattern from i on the j, not on the i line) expands the shape within the
//    DUPLICATELIMIT and puts any SegmentMidPoint along the line inside the polygon.
        if Pattern[PatternInters.j].x > PatternInters.Intersected.x then
          PatternSetA[j].x := Round(PatternInters.Intersected.x + 1)
        else
          PatternSetA[j].x := Round(PatternInters.Intersected.x - 1);

        if Pattern[PatternInters.j].y > PatternInters.Intersected.y then
          PatternSetA[j].y := Round(PatternInters.Intersected.y + 1)
        else
          PatternSetA[j].y := Round(PatternInters.Intersected.y - 1);

        PatternSetB[k].x := PatternSetA[j].x;
        PatternSetB[k].y := PatternSetA[j].y;
      end;

//CJY The direction tweak... there isn't any sure way of determining the direction
//    that the points should have been removed. The following calculates the percentage
//    of points that are contained within the boundary of the other set. The one with
//    the highest percentage of points within the other set is most likely the one
//    to be the one to be removed.  This is not efficent.

      DoneToPoint := j;

      i2 := 0;
      for i := 0 to Length(PatternSetB) - 1 do
      begin
        if (PointOnPolygon(PatternSetB[i].x, PatternSetB[i].y, PatternSetA) or
            PointInPolygon(PatternSetB[i].x, PatternSetB[i].y, PatternSetA)) then
        begin
          Inc(i2);
        end;
      end;

      j2 := 0;
      for j := 0 to Length(PatternSetA) - 1 do
      begin
        if (PointOnPolygon(PatternSetA[j].x, PatternSetA[j].y, PatternSetB) or
            PointInPolygon(PatternSetA[j].x, PatternSetA[j].y, PatternSetB)) then
        begin
          Inc(j2);
        end;
      end;

      i := Length(PatternSetB);
      j := Length(PatternSetA);

      if (i < 3) then
      //CJY nothing to remove in PatternSetB or PatternSetB is not a shape
      else if (j < 3) or
              ((i2 / i) < (j2 / j)) or
              (((i2 / i) = (j2 / j)) and (i > j)) then
      begin
        //CJY nothing to remove in PatternSetA or PatternSetA is not a shape
        //    i=0 and j=0 will validate before /i or /j
        //    preventing a divide by 0
        PatternSetA := PatternSetB;
        DoneToPoint := k;
      end;

      SetLength(PatternKept, Length(PatternSetA));

      for i := 0 to Length(PatternSetA) - 1  do
      begin
        PatternKept[i].x := Round(PatternSetA[i].x);
        PatternKept[i].y := Round(PatternSetA[i].y);
      end;

      Pattern := PatternKept;
    end;

    EliminateSpikes(Pattern);
    CloseNarrowGaps(Expansion, DoneToPoint, Pattern); //remember this *MUST* be the pattern with the last lot of points removed
  end;
end;

procedure ExpandMaxMin(Pattern: TPointArray;
                       Expansion: integer;
                       var xMax, xMin, yMax, yMin: integer);
var
  i: integer;

begin
  xMin := 999999;
  yMin := 999999;
  xMax := -999999;
  yMax := -999999;
  for i := 0 to Length(Pattern) - 1 do
  begin
    if Pattern[i].X < xMin then
      xMin := Pattern[i].x;
    if Pattern[i].Y < yMin then
      yMin := Pattern[i].y;
    if Pattern[i].X > xMax then
      xMax := Pattern[i].x;
    if Pattern[i].Y > yMax then
      yMax := Pattern[i].y;
  end;
  xMax := xMax + (Expansion * 2);
  xMin := xMin - (Expansion * 2);
  yMax := yMax + (Expansion * 2);
  yMin := yMin - (Expansion * 2);
end;

//Expand a pattern with radiuses at all 'corners'.
procedure ExpandPattern(OriginalPattern: TPointArray;
                        var ExpandedPattern: TPointArray;
                        Expansion: integer);
var
  x, y, XPlus, XMinus, c, BisX, BisY, c1, c2, GuideX, GuideY, m, m1, m2, ParaInterX, ParaInterY,
  PreInterX, PreInterY, PostInterX, PostInterY, PreParaX, PreParaY, PrePointX, PrePointY: double;
  i, j, NPoints, PrePoint, PostPoint, ThePoint, RadiusStart, RadiusEnd, xMax, xMin, yMax, yMin: integer;
  OnlyOne: boolean;
  Pattern: TPointArray;
  ExpansionCalcs: TExpansion;
  {$IFDEF DEBUGFULL}
  ExpVars: TExps;
  {$ENDIF}

begin
  Pattern := Copy(OriginalPattern);

  {$IFDEF DEBUGFULL}
    fmDebugger.DrawPattern(Pattern);
  {$ENDIF}

  ExpandMaxMin(Pattern, Expansion, xMax, xMin, yMax, yMin);

  CloseNarrowGaps(Expansion, 0, Pattern);

  EliminateSpikes(Pattern);

  {$IFDEF DEBUGFULL}
    fmDebugger.DrawPatternSpikesGone(Pattern);
  {$ENDIF}

  SetLength(ExpandedPattern, 0);
  NPoints := Length(Pattern);
  SetLength(ExpansionCalcs, NPoints);

  {$IFDEF DEBUGFULL}
  SetLength(ExpVars, NPoints);
  {$ENDIF}

  for i := 0 to NPoints - 1 do
  begin
    //Close the pattern
    ThePoint := i;
    if i = 0 then
    begin
      PrePoint := NPoints - 1;
      PostPoint := i + 1;
    end
    else if i = NPoints - 1 then
    begin
      PrePoint := i - 1;
      PostPoint := 0;
    end
    else
    begin
      PrePoint := i - 1;
      PostPoint := i + 1;
    end;

    //Find the equation of the line which bisects the angle described by the 3 points and the line perpendicular to the bisector.
    LineBisector(Pattern[PrePoint], Pattern[ThePoint], Pattern[PostPoint], c1, c2, m1, m2);

    //Calculate where a circle of tiny radius intersects the bisectors and their perpendiculars.
    //Find which of the 4 circle intersections are inside the pattern. This is Guide Point.

    FindGuidePoint(Pattern[PrePoint], Pattern[ThePoint], Pattern[PostPoint], c1, c2, m1, m2, Pattern, NPoints, c, m, GuideX, GuideY);

    if (GuideX = Pattern[ThePoint].X) then
    begin
      ParaInterX := Pattern[ThePoint].x;
      BisX := Pattern[ThePoint].x;
      if (GuideY > Pattern[ThePoint].y) then
      begin
        ParaInterY := Pattern[ThePoint].y - Expansion;
        BisY := Pattern[ThePoint].y - Expansion;
      end
      else
      begin
        ParaInterY := Pattern[ThePoint].y + Expansion;
        BisY := Pattern[ThePoint].y + Expansion;
      end
    end
    else if (GuideY = Pattern[ThePoint].Y) then
    begin
      ParaInterY := Pattern[ThePoint].y;
      BisY := Pattern[ThePoint].y;
      if (GuideX > Pattern[ThePoint].x) then
      begin
        ParaInterX := Pattern[ThePoint].x - Expansion;
        BisX := Pattern[ThePoint].x - Expansion;
      end
      else
      begin
        ParaInterX := Pattern[ThePoint].x + Expansion;
        BisX := Pattern[ThePoint].x + Expansion;
      end
    end
    else
    begin
      //Find where the expansion lines intersect each other - it's the same place as where they intersect the bisector, hence
      //the bisector is used to find it.
      GetExpandedIntersections(Pattern[PrePoint], Pattern[ThePoint], Pattern[PostPoint], c, Expansion, GuideX, GuideY,
                               m, ParaInterX, ParaInterY);

      //Find where the bisector intersects a circle of radius 'expansion'.
      IntersectCircle(Pattern[ThePoint], Expansion, m, c, xPlus, xMinus);

      //Find the bisector/expansion circle intersection which lies furthest from Guide Point - i.e. outside the pattern.
      OutsideCircleBisectorIntersection(Pattern[ThePoint], c, Expansion, GuideX, GuideY, m, xPlus, xMinus,
                                        xMax, xMin, yMax, yMin, BisX, BisY);
    end;

    AddAnyPointToArray(BisX, BisY, ExpandedPattern);

    ExpansionCalcs[i].c1 := c1;
    ExpansionCalcs[i].c2 := c2;
    ExpansionCalcs[i].m1 := m1;
    ExpansionCalcs[i].m2 := m2;
    ExpansionCalcs[i].GuideX := GuideX;
    ExpansionCalcs[i].GuideY := GuideY;
    ExpansionCalcs[i].BisX := BisX;
    ExpansionCalcs[i].BisY := BisY;
    ExpansionCalcs[i].ParaInterX := ParaInterX;
    ExpansionCalcs[i].ParaInterY := ParaInterY;
    ExpansionCalcs[i].YPoint := Pattern[ThePoint].y;
    ExpansionCalcs[i].XPlus := XPlus;
    ExpansionCalcs[i].XMinus := XMinus;

  {$IFDEF DEBUGFULL}
    ExpVars[i].c1 := c1;
    ExpVars[i].c2 := c2;
    ExpVars[i].m1 := m1;
    ExpVars[i].m2 := m2;
    ExpVars[i].GuideX := GuideX;
    ExpVars[i].GuideY := GuideY;
    ExpVars[i].BisX := BisX;
    ExpVars[i].BisY := BisY;
    ExpVars[i].ParaInterX := ParaInterX;
    ExpVars[i].ParaInterY := ParaInterY;
    ExpVars[i].YPoint := Pattern[ThePoint].y;
    ExpVars[i].XPlus := XPlus;
    ExpVars[i].XMinus := XMinus;
  {$ENDIF}
  end;

  {$IFDEF DEBUGFULL}
    fmDebugger.DrawBisector(Pattern, ExpVars);
    fmDebugger.DrawGuidePoints(Pattern, ExpVars);
    fmDebugger.DrawParas(Pattern, ExpVars);
    fmDebugger.DrawExpInters(Pattern, ExpVars);
    fmDebugger.DrawExpBis(Pattern, ExpVars);
    fmDebugger.DrawFirstExp(ExpandedPattern);
  {$ENDIF}

  //Eliminate crossovers from rough point to point expansion to ensure that any remaining internal angles are necessary to
  //describe final shape.
  if (Length(ExpandedPattern) > 3) then
    EliminatePatternLoops(ExpandedPattern);

  {$IFDEF DEBUGFULL}
    fmDebugger.DrawLoopFreeFirstExp(Pattern, ExpandedPattern);
  {$ENDIF}

  SetLength(ExpandedPattern, 0);
  NPoints := Length(Pattern);

  for i := 0 to NPoints - 1 do
  begin
    //Close the pattern
    ThePoint := i;
    if i = 0 then
    begin
      PrePoint := NPoints - 1;
      PostPoint := i + 1;
    end
    else if i = NPoints - 1 then
    begin
      PrePoint := i - 1;
      PostPoint := 0;
    end
    else
    begin
      PrePoint := i - 1;
      PostPoint := i + 1;
    end;

    c1 := ExpansionCalcs[i].c1;
    c2 := ExpansionCalcs[i].c2;
    m1 := ExpansionCalcs[i].m1;
    m2 := ExpansionCalcs[i].m2;
    GuideX := ExpansionCalcs[i].GuideX;
    GuideY := ExpansionCalcs[i].GuideY;
    ParaInterX := ExpansionCalcs[i].ParaInterX;
    ParaInterY := ExpansionCalcs[i].ParaInterY;
    xPlus := ExpansionCalcs[i].xPlus;
    xMinus := ExpansionCalcs[i].xMinus;
    BisX := ExpansionCalcs[i].BisX;
    BisY := ExpansionCalcs[i].BisY;

    if IsClosePoint(BisX, BisY, Pattern, Expansion) then
      AddPointToArray(ParaInterX, ParaInterY, ExpandedPattern)
    else
    begin
      //Find where Expanded lines (parallel to originals) intersect corner circles
      FindCircleExpansionIntersections(Pattern[PrePoint], Pattern[ThePoint], Pattern[PostPoint], Expansion, ParaInterX, ParaInterY,
                                       PreInterX, PreInterY, PostInterX, PostInterY);

      //Add points where lines intersect circle to array.
      if Distance(PreInterX, PreInterY, BisX, BisY) < RADIUSPOINTSDIST then
        OnlyOne := True
      else
        OnlyOne := False;

      if not OnlyOne then
      begin
        AddPointToArray(PreInterX, PreInterY, ExpandedPattern);
        RadiusStart := Length(ExpandedPattern) - 1;
      end;

      AddPointToArray(BisX, BisY, ExpandedPattern);

      if not OnlyOne then
      begin
        RadiusEnd := Length(ExpandedPattern) - 1;
        AddPointToArray(PostInterX, PostInterY, ExpandedPattern);
      end;

      //To smooth out corners add points around the circle until no circle point is more than RADIUSPOINTSDIST thou from another.
      if not(OnlyOne) and not(RadiusStart = RadiusEnd) and not((Pattern[ThePoint].X = ExpandedPattern[RadiusStart].X) and (Pattern[ThePoint].Y = ExpandedPattern[RadiusStart].Y)) and not((Pattern[ThePoint].X = ExpandedPattern[RadiusEnd].X) and (Pattern[ThePoint].Y = ExpandedPattern[RadiusEnd].Y)) then
      begin
        while Distance(ExpandedPattern[Length(ExpandedPattern) - 1].X, ExpandedPattern[Length(ExpandedPattern) - 1].Y, ExpandedPattern[Length(ExpandedPattern) - 2].X, ExpandedPattern[Length(ExpandedPattern) - 2].Y) > RADIUSPOINTSDIST do
        begin
          //Calculate a point on the circle half way between Point1 and Point2.
          RadiusPoint(Pattern[ThePoint], ExpandedPattern[RadiusStart], ExpandedPattern[RadiusEnd], Expansion, x, y);

          SetLength(ExpandedPattern, Length(ExpandedPattern) + 1);
          for j := Length(ExpandedPattern) - 2 downto RadiusEnd do
            ExpandedPattern[j + 1] := ExpandedPattern[j];

          ExpandedPattern[RadiusEnd].X := round(x);
          ExpandedPattern[RadiusEnd].Y := round(y);
          RadiusEnd := RadiusStart + 1;
          if Distance(ExpandedPattern[RadiusStart].X, ExpandedPattern[RadiusStart].Y, ExpandedPattern[RadiusEnd].X, ExpandedPattern[RadiusEnd].Y) < RADIUSPOINTSDIST then
          begin
            RadiusStart := RadiusEnd + 1;
            if RadiusStart >= Length(ExpandedPattern) - 1 then
              RadiusStart := Length(ExpandedPattern) - 2;
            RadiusEnd := RadiusStart + 1;
          end;
        end;
      end;
    end;
  end;

  if (Length(ExpandedPattern) > 3) then
    EliminateSpikes(ExpandedPattern);
end;

end.
