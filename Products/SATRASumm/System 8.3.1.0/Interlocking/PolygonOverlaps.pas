//Seem to be 1 pixel out on hulls - test all bitmaps and arrays to make sure they are the same 0th or 1st point based

unit PolygonOverlaps;

interface

uses FastGEO, General_Interlocking;

type
  TOverlap = record
    Overlap: Boolean;
    Polygon: TPolygon2D;
    Area: single;
  end;

  TPointRec = record
    InPoint: TPoint2D;
    IntNo: integer;
  end;
  TOverlapPoints = array of TPointRec;

function PolyArea(APolygon: TPolygon2D): TFloat;
function OverlappingConvexPolygon(ConvexHull1, ConvexHull2: TPolygon2D): TOverlap;

implementation

function PolyArea(APolygon: TPolygon2D): TFloat;
var
  i: integer;

begin
  Result := 0;
  for i := 0 to Length(APolygon) - 2 do
    Result := Result + ((APolygon[i + 1].X - APolygon[i].X) * (APolygon[i + 1].Y + APolygon[i].Y) / 2);

  Result := abs(Result);
end;

//This function runs round each convex hull in turn looking for intersections and points which are inside the other
//convex hull. It stores the points in the 'FROM' arrays then orders them so that the intersection points are at either
//end of the list of points in the other polygon (hull) - stored the FROMxFILTERED arrays.
//Finally it joins the two arrays together at the common points (the intersections) to make the overlapping area).

function OverlappingConvexPolygon(ConvexHull1, ConvexHull2: TPolygon2D): TOverlap;
var
  i, j, k, Count1, Count2, Ints1, Ints2, Start1, Start2, End1, End2: integer;
  Done, Intersected, PIP, TouchOnly, TouchOnly1, TouchOnly2: Boolean;
  OverlapPolygon: TPolygon2D;
  PolygonArea: single;
  APoint: TPoint2D;
  From1, From1Filtered, From2, From2Filtered: TOverlapPoints;

begin
  TouchOnly := False;
  TouchOnly1 := True;
  TouchOnly2 := True;

  //Find and keep intersections
  Count1 := 0;
  Count2 := 0;
  Ints1 := 0;
  Ints2 := 0;
  i := -1;
  while (i < length(ConvexHull1) - 2) do
  begin
    inc(i);
    j := -1;
    PIP := PointInAndOnPolygon(ConvexHull1[i].x, ConvexHull1[i].y, ConvexHull2);
    if PIP then
    begin
      inc(Count1);
      SetLength(From1, Count1);
      From1[Count1 - 1].InPoint := ConvexHull1[i];
      From1[Count1 - 1].IntNo := 0;
    end;

    while (j < length(ConvexHull2) - 2) do
    begin
      //Hulls are closed (last point equals first point) so only need to do i or j points - never need to check i + 1 or j + 1.
      inc(j);
      {Replaced "Intersect" below with "IntersectExcludingColinearity"
       to match similar call further down. Done to fix incorrect overlaps.
       TAH 14/08/14}
      if IntersectExcludingColinearity(ConvexHull1[i].x, ConvexHull1[i].y,
                                       ConvexHull1[i + 1].x, ConvexHull1[i + 1].y,
                                       ConvexHull2[j].x, ConvexHull2[j].y,
                                       ConvexHull2[j + 1].x, ConvexHull2[j + 1].y,
                                       APoint.x, APoint.y) then
      begin
        if not(PIP and (From1[Count1 - 1].InPoint.x = APoint.x) and (From1[Count1 - 1].InPoint.y = APoint.y)) then
        begin
          inc(Count1);
          SetLength(From1, Count1);
          From1[Count1 - 1].InPoint := APoint;
        end;
        inc(Ints1);
        From1[Count1 - 1].IntNo := Ints1;
      end;
    end;
  end;

  i := -1;
  while (i < length(ConvexHull2) - 2) do
  begin
    inc(i);
    j := -1;
    PIP := PointInAndOnPolygon(ConvexHull2[i].x, ConvexHull2[i].y, ConvexHull1);
    if PIP then
    begin
      inc(Count2);
      SetLength(From2, Count2);
      From2[Count2 - 1].InPoint := ConvexHull2[i];
      From2[Count2 - 1].IntNo := 0;
    end;

    while (j < length(ConvexHull1) - 2) do
    begin
      //Hulls are closed (last point equals first point) so only need to do i or j points - never need to check i + 1 or j + 1.
      inc(j);
      if IntersectExcludingColinearity(ConvexHull2[i].x, ConvexHull2[i].y,
                                       ConvexHull2[i + 1].x, ConvexHull2[i + 1].y,
                                       ConvexHull1[j].x, ConvexHull1[j].y,
                                       ConvexHull1[j + 1].x, ConvexHull1[j + 1].y,
                                       APoint.x, APoint.y) then
      begin
        if not(PIP and (From2[Count2 - 1].InPoint.x = APoint.x) and (From2[Count2 - 1].InPoint.y = APoint.y)) then
        begin
          inc(Count2);
          SetLength(From2, Count2);
          From2[Count2 - 1].InPoint := APoint;
        end;
        inc(Ints2);
        From2[Count2 - 1].IntNo := Ints2;
      end;
    end;
  end;

  for i := 0 to Count1 - 1 do
    if From1[i].IntNo = 0 then
      TouchOnly1 := False;

  for i := 0 to Count2 - 1 do
    if From2[i].IntNo = 0 then
      TouchOnly2 := False;

  if TouchOnly1 and TouchOnly2 then
    TouchOnly := True;

  if not TouchOnly then
  begin
    if not TouchOnly1 then
    begin
      //Go through array (looped) until we find an intersection followed by a non-intersection point
      Start1 := -1;
      End1 := -1;
      i := -1;
      Done := False;
      while (not Done) and ((Start1 = -1) or (End1 = -1)) do
      begin
        inc(i);
        if (i = Count1 - 1) then
        begin
          Done := True;
          if (From1[i].IntNo > 0) and (From1[0].IntNo = 0) then  //test last to first point
            Start1 := i
          else if (From1[i].IntNo = 0) and (From1[0].IntNo > 0) then  //test last to first point
            End1 := 0;
        end
        else
        begin
          if (From1[i].IntNo > 0) and (From1[i + 1].IntNo = 0) then
            Start1 := i
          else if (From1[i].IntNo = 0) and (From1[i + 1].IntNo > 0) then
            End1 := i + 1;
        end;
      end;

      //Organise array in int, point, point, point, int form.
      j := 0;
      i := Start1;
      while not(i = End1) do
      begin
        inc(j);
        SetLength(From1Filtered, j);
        From1Filtered[j - 1] := From1[i];

        inc(i);
        if i > Count1 - 1 then
          i := 0;
      end;
      inc(j);
      SetLength(From1Filtered, j);
      From1Filtered[j - 1] := From1[i];
    end
    else
      From1Filtered := From1;

    if not TouchOnly2 then
    begin
      //Go through array (looped) until we find an intersection followed by a non-intersection point
      Start2 := -1;
      End2 := -1;
      i := -1;
      Done := False;      
      while (not Done) and ((Start2 = -1) or (End2 = -1)) do
      begin
        inc(i);
        if (i = Count2 - 1) then
        begin
          Done := True;
          if (From2[i].IntNo > 0) and (From2[0].IntNo = 0) then  //test last to first point
            Start2 := i
          else if (From2[i].IntNo = 0) and (From2[0].IntNo > 0) then  //test last to first point
            End2 := 0;
        end
        else
        begin
          if (From2[i].IntNo > 0) and (From2[i + 1].IntNo = 0) then
            Start2 := i
          else if (From2[i].IntNo = 0) and (From2[i + 1].IntNo > 0) then
            End2 := i + 1;
        end;
      end;

      //Organise array in int, point, point, point, int form.
      j := 0;
      i := Start2;
      while not(i = End2) do
      begin
        inc(j);
        SetLength(From2Filtered, j);
        From2Filtered[j - 1] := From2[i];

        inc(i);
        if i > Count2 - 1 then
          i := 0;
      end;
      inc(j);
      SetLength(From2Filtered, j);
      From2Filtered[j - 1] := From2[i];
    end
    else
      From2Filtered := From2;

    SetLength(OverlapPolygon, 0);
    for i := 0 to Length(From1Filtered) - 1 do
    begin
      SetLength(OverlapPolygon, Length(OverlapPolygon) + 1);
      OverlapPolygon[i] := From1Filtered[i].InPoint
    end;

    if (From1Filtered[0].InPoint.x = From2Filtered[0].InPoint.x) and
       (From1Filtered[0].InPoint.y = From2Filtered[0].InPoint.y) then
    begin
      for i := Length(From2Filtered) - 2 downto 1 do
      begin
        SetLength(OverlapPolygon, Length(OverlapPolygon) + 1);
        OverlapPolygon[Length(OverlapPolygon) - 1] := From2Filtered[i].InPoint;
      end;
    end
    else
    begin
      for i := 1 to Length(From2Filtered) - 2 do
      begin
        SetLength(OverlapPolygon, Length(OverlapPolygon) + 1);
        OverlapPolygon[Length(OverlapPolygon) - 1] := From2Filtered[i].InPoint;
      end;
    end;

    Result.Overlap := True;
    //Close Polygon
    SetLength(OverlapPolygon, Length(OverlapPolygon) + 1);
    OverlapPolygon[Length(OverlapPolygon) - 1] := OverlapPolygon[0];

    PolygonArea := PolyArea(OverlapPolygon);
  end
  else
  begin
    Result.Overlap := False;
    SetLength(OverlapPolygon, 0);
    PolygonArea := 0;
  end;

  Result.Polygon := OverlapPolygon;
  Result.Area := PolygonArea;
end;

end.
