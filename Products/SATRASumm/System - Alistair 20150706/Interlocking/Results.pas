unit Results;

interface

uses Types, Graphics, SysUtils, FastGEO, Interlocking, General_Interlocking,
     Const_Interlocking, SummsVars, CmnVars;

type
  TWholeShape = record
    Hull: TPolygon2D;
    BoundingRect: TRect;
  end;
  TCut = record
    KnifeNo: integer;
    W2, Ghost: Boolean;
    BoundingRect: TRect;
    Colour: TColor;
  end;
  TCutResult = array of TCut;
  TWhere = record
    xy: TPointArray;
    minx, miny: integer;
  end;
  TLocalInterlock = record
    Used, Reversed: Boolean;
    PairedPatternHeight, PairedPatternWidth, SinglePatternHeight, SinglePatternWidth: integer;
    Vec1x, Vec1y: integer;
    BottomIsLeft, W2: Boolean;
    Pat1, Pat2: TRect;
    LeftPat, BottomPat: integer;
    SingleKnifeNo: integer;
  end;
  TPropogationInput = record
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
    PackAngle: Double;
  end;

var
  WholeShape0, WholeShape1: TWholeShape;
  CutResults, CopyResults, PackResults: TCutResult;
  ResultsLeft: Boolean;
  ResultsRemHeight, ResultsRemWidth: integer;
  KnivesUsed: array of array[0..1] of TPattern;
  CurrentKnife: integer;
  PropogationInput: TPropogationInput;
  PropogationNo: integer;
  ResultsParallelogram: TPolygon2D;
  ResultsParallelogramAreaForKnife: real;

procedure AddToResults(Interlock: TInterlock; AddResultSet, W2, Ghost, AddOverlap: Boolean);
procedure AddResult_Single(Cut: TCut);
procedure AddResult_Set(OriginalRect, InterlockRect: TRect; SetW2: Boolean);
procedure TranslateExistingResults(BoundingRect: TRect);
procedure TranslateExistingOverlaps(BoundingRect: TRect);
procedure DrawResults(Canvas: TCanvas; XOffset, YOffset, Zoom: integer; ShowBorder, ShowExpansions, ShowHulls, ShowBoundingRect, ShowNumbers, ShowHullOverlaps, ShowMerges, SimpleDraw: Boolean; SmallScale: Real);
function PlotHull(Hull: TPolygon2D; BoundingRect: TRect): TWhere;
procedure AdjustBoundingRects(var OriginalRect, InterlockRect: TRect);
function OriginalKnifeNow: TPoint;
procedure AddToOverlaps(Interlock: TInterlock);
function GhostPosition(OriginalRect: TRect; ShapeNoToGhost, No: integer): TPoint;

implementation

procedure AddToResults(Interlock: TInterlock; AddResultSet, W2, Ghost, AddOverlap: Boolean);
var
  OriginalRect, InterlockRect: TRect;
  Cut: TCut;

begin
  OriginalRect := Interlock.Knife1BoundingRect;
  InterlockRect := Interlock.Knife2BoundingRect;
  AdjustBoundingRects(OriginalRect, InterlockRect);

  TranslateExistingResults(OriginalRect);
  if Length(CutResults) = 0 then
  begin
    //First Knife
    Cut.KnifeNo := CurrentKnife;
    Cut.W2 := False;
    Cut.Ghost := False;
    Cut.BoundingRect := OriginalRect;
    AddResult_Single(Cut);
  end;

  if AddResultSet then
    AddResult_Set(OriginalRect, InterlockRect, W2)
  else
  begin
    //Second knife
    Cut.KnifeNo := CurrentKnife;
    Cut.W2 := W2;
    Cut.Ghost := Ghost;
    Cut.BoundingRect := InterlockRect;
    AddResult_Single(Cut);
  end;

  {$IFDEF DEBUGFULL}
  WholeShape0.Hull := Interlock.ConvexHull1;
  WholeShape1.Hull := Interlock.ConvexHull2;
  {$ENDIF}
  WholeShape0.BoundingRect := OriginalRect;
  WholeShape1.BoundingRect := InterlockRect;

  TranslateExistingOverlaps(OriginalRect);
  if AddOverlap then
    AddToOverlaps(Interlock);
end;

procedure AddResult_Single(Cut: TCut);
begin
  SetLength(CutResults, Length(CutResults) + 1);
  CutResults[Length(CutResults) - 1].KnifeNo := Cut.KnifeNo;
  CutResults[Length(CutResults) - 1].W2 := Cut.W2;
  CutResults[Length(CutResults) - 1].Ghost := Cut.Ghost;
  CutResults[Length(CutResults) - 1].BoundingRect := Cut.BoundingRect;
end;

procedure AddResult_Set(OriginalRect, InterlockRect: TRect; SetW2: Boolean);
var
  Firsti, Lasti, i: integer;
  Cut: TCut;
  NewRect: TRect;

begin
  if not SetW2 then
  begin
    Firsti := 0;
    Lasti := Length(CutResults) - 1 + 1;  //1 added for while loop
  end
  else
  begin
    Firsti := Length(CutResults) - 1;
    Lasti := 0 - 1;                       //1 taken off for while loop
  end;

  i := Firsti;
  while i <> Lasti do
  begin
    Cut := CutResults[i];

    Cut.BoundingRect.Left := Cut.BoundingRect.Left + InterlockRect.Left - OriginalRect.Left;
    Cut.BoundingRect.Right := Cut.BoundingRect.Right + InterlockRect.Left - OriginalRect.Left;
    Cut.BoundingRect.Top := Cut.BoundingRect.Top + InterlockRect.Top - OriginalRect.Top;
    Cut.BoundingRect.Bottom := Cut.BoundingRect.Bottom + InterlockRect.Top - OriginalRect.Top;

    if SetW2 then
    begin
      Cut.W2 := not Cut.W2;

      NewRect.Right := InterlockRect.Right - (Cut.BoundingRect.Left - InterlockRect.Left);
      NewRect.Left := InterlockRect.Left + (InterlockRect.Right - Cut.BoundingRect.Right);
      NewRect.Bottom := InterlockRect.Bottom - (Cut.BoundingRect.Top - InterlockRect.Top);
      NewRect.Top := InterlockRect.Top + (InterlockRect.Bottom - Cut.BoundingRect.Bottom);

      Cut.BoundingRect := NewRect;
    end;

    AddResult_Single(Cut);

    if not SetW2 then
      inc(i)
    else
      dec(i);
  end;
end;

procedure TranslateExistingResults(BoundingRect: TRect);
var
  i: integer;

begin
  for i := 0 to Length(CutResults) - 1 do
  begin
    CutResults[i].BoundingRect.Left := CutResults[i].BoundingRect.Left + BoundingRect.Left;
    CutResults[i].BoundingRect.Top := CutResults[i].BoundingRect.Top + BoundingRect.Top;
    CutResults[i].BoundingRect.Right := CutResults[i].BoundingRect.Right + BoundingRect.Left;
    CutResults[i].BoundingRect.Bottom := CutResults[i].BoundingRect.Bottom + BoundingRect.Top;
  end;
end;

procedure TranslateExistingOverlaps(BoundingRect: TRect);
var
  i, j: integer;

begin
  for i := 0 to Length(OriginalHullOverlaps) - 1 do
  begin
    for j := 0 to Length(OriginalHullOverlaps[i].Overlap) - 1 do
    begin
      OriginalHullOverlaps[i].Overlap[j].x := OriginalHullOverlaps[i].Overlap[j].x + BoundingRect.Left;
      OriginalHullOverlaps[i].Overlap[j].y := OriginalHullOverlaps[i].Overlap[j].y + BoundingRect.Top;
    end;
  end;
end;

procedure DrawResults(Canvas: TCanvas; XOffset, YOffset, Zoom: integer; ShowBorder, ShowExpansions, ShowHulls, ShowBoundingRect, ShowNumbers, ShowHullOverlaps, ShowMerges, SimpleDraw: Boolean; SmallScale: Real);
var
  i, j: integer;
  xy: TPointArray;
  Pattern: TPattern;
  Parallelogram: TPointArray;

begin
  if not SimpleDraw then
    Canvas.Pen.Width := 1
  else
    Canvas.Pen.Width := SHAPE_EDGE_WIDTH;

  //Whole Shape Hulls
  if ShowHulls and (not SimpleDraw) then
  begin
    Canvas.Pen.Color := clCut;
    Canvas.Brush.Color := clCut;

    Canvas.Polygon(PlotHull(WholeShape0.Hull, WholeShape0.BoundingRect).xy);

    Canvas.Pen.Color := clBackVeryDark;
    Canvas.Brush.Color := clBackVeryDark;

    Canvas.Polygon(PlotHull(WholeShape1.Hull, WholeShape1.BoundingRect).xy);
  end;

  //Points
  for i := 0 to Length(CutResults) - 1 do
  begin
    if (yOffset + CutResults[i].BoundingRect.Bottom * Zoom) > 0 then
    begin
      //Select knife
      if not CutResults[i].W2 then
        Pattern := KnivesUsed[CutResults[i].KnifeNo - 1, 0]
      else
        Pattern := KnivesUsed[CutResults[i].KnifeNo - 1, 1];

      if ShowExpansions then
      begin
        SetLength(xy, Length(Pattern.ExpandedPoints) + 1);
        for j := 0 to Length(Pattern.ExpandedPoints) - 1 do
        begin
          xy[j].x := XOffset + (CutResults[i].BoundingRect.Left + round(Pattern.ExpandedPoints[j].x)) * Zoom;
          xy[j].y := YOffset + (CutResults[i].BoundingRect.Top + round(Pattern.ExpandedPoints[j].y)) * Zoom;
          xy[j].x := round(xy[j].x * DisplayScale * SmallScale);
          xy[j].y := round(xy[j].y * DisplayScale * SmallScale);
        end;
        xy[Length(Pattern.ExpandedPoints)] := xy[0];

        if not SimpleDraw then
        begin
          Canvas.Pen.Color := clLime;
          Canvas.Brush.Color := clLime;
        end
        else
        begin
          Canvas.Pen.Color := clCut;
          Canvas.Brush.Color := clCut;
        end;

        if CutResults[i].Ghost or SimpleDraw then
          Canvas.Polyline(xy)
        else
          Canvas.Polygon(xy);
      end;

      SetLength(xy, Length(Pattern.PatternPoints) + 1);
      for j := 0 to Length(Pattern.PatternPoints) - 1 do
      begin
        xy[j].x := XOffset + (CutResults[i].BoundingRect.Left + round(Pattern.PatternPoints[j].x)) * Zoom;
        xy[j].y := YOffset + (CutResults[i].BoundingRect.Top + round(Pattern.PatternPoints[j].y)) * Zoom;
        xy[j].x := round(xy[j].x * DisplayScale * SmallScale);
        xy[j].y := round(xy[j].y * DisplayScale * SmallScale);
      end;
      xy[Length(Pattern.PatternPoints)] := xy[0];

      if not SimpleDraw then
      begin
        if CutResults[i].Colour <> 0 then
        begin
          Canvas.Pen.Color := CutResults[i].Colour;
          Canvas.Brush.Color := CutResults[i].Colour;
        end
        else
        begin
          Canvas.Pen.Color := clCut;
          Canvas.Brush.Color := clCut;
        end;
        Canvas.Polygon(xy);
      end
      else
      begin
        Canvas.Pen.Color := clBlack;
        Canvas.Brush.Color := clBlack;
        Canvas.Polyline(xy);
      end;

      if ShowBorder and (not SimpleDraw) then
      begin
        Canvas.Pen.Width := 3;
        Canvas.Pen.Color := clEditing;
        Canvas.Brush.Color := clEditing;
        Canvas.Polyline(xy);
      end;
    end;
  end;

  //Individual Hulls
  if ShowHulls and (not SimpleDraw) then
  begin
    Canvas.Pen.Color := clBlue;
    Canvas.Brush.Color := clBlue;

    for i := 0 to Length(CutResults) - 1 do
    begin
      //Select knife
      if not CutResults[i].W2 then
        Pattern := KnivesUsed[CutResults[i].KnifeNo - 1, 0]
      else
        Pattern := KnivesUsed[CutResults[i].KnifeNo - 1, 1];

      Canvas.Polyline(PlotHull(Pattern.ConvexHull, CutResults[i].BoundingRect).xy);
    end;
  end;

  //Bounding Rectangles
  if ShowBoundingRect and (not SimpleDraw) then
  begin
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color := clBlack;

    for i := 0 to Length(CutResults) - 1 do
      Canvas.FrameRect(CutResults[i].BoundingRect);

    Canvas.Pen.Color := clBlue;
    Canvas.Brush.Color := clBlue;

    Canvas.FrameRect(WholeShape0.BoundingRect);
    Canvas.FrameRect(WholeShape1.BoundingRect);
  end;

  //Overlaps
  if ShowHullOverlaps and (not SimpleDraw) then
  begin
    Canvas.Pen.Color := clYellow;
    Canvas.Brush.Color := clYellow;
    for i := 0 to Length(OriginalHullOverlaps) - 1 do
    begin
      if not OriginalHullOverlaps[i].W2 then
      begin
        setlength(xy, Length(OriginalHullOverlaps[i].Overlap));

        for j := 0 to Length(OriginalHullOverlaps[i].Overlap) - 1 do
        begin
          xy[j].x := round(OriginalHullOverlaps[i].Overlap[j].x);
          xy[j].y := round(OriginalHullOverlaps[i].Overlap[j].y);
        end;

        Canvas.Polygon(xy);
      end;
    end;
  end;

  //Numbers
  if ShowNumbers and (not SimpleDraw) then
  begin
    for i := 0 to Length(CutResults) - 1 do
    begin
      Canvas.Brush.Color := clBackVeryDark;
      Canvas.Font.Color := clEditing;
      Canvas.Font.Size := 96;
      Canvas.Font.Style := [fsBold];                                                                   //+ 1 when finished
      Canvas.TextOut(xOffset + CutResults[i].BoundingRect.Left + 1,
                     yOffset + CutResults[i].BoundingRect.Top + 1, intToStr(i + 0));
    end;
  end;

  //Merges
  if ShowMerges and (not SimpleDraw) then
  begin
    SetLength(xy, Length(Knife.ExpandedPoints) + 1);
    for j := 0 to Length(Knife.ExpandedPoints) - 1 do
    begin
      xy[j].x := round(Knife.ExpandedPoints[j].x);
      xy[j].y := round(Knife.ExpandedPoints[j].y);
    end;
    xy[Length(Knife.ExpandedPoints) - 1] := xy[0];

    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color := clBlack;
    Canvas.Pen.Width := 5;
    Canvas.Polyline(xy);
  end;
end;

function PlotHull(Hull: TPolygon2D; BoundingRect: TRect): TWhere;
var
  j, minx, miny: integer;
  xy: TPointArray;

begin
  SetLength(xy, Length(Hull));
  minx := 9999999;
  miny := 9999999;
  for j := 0 to Length(Hull) - 1 do
  begin
    xy[j].x := round(Hull[j].x);
    xy[j].y := round(Hull[j].y);
    if xy[j].x < minx then
      minx := xy[j].x;
    if xy[j].y < miny then
      miny := xy[j].y;
  end;
  for j := 0 to Length(Hull) - 1 do
  begin
    xy[j].x := BoundingRect.Left + xy[j].x - minx;
    xy[j].y := BoundingRect.Top + xy[j].y - miny
  end;

  Result.xy := xy;
  Result.minx := minx;
  Result.miny := miny;
end;

procedure AdjustBoundingRects(var OriginalRect, InterlockRect: TRect);
begin
  if OriginalRect.Left < InterlockRect.Left then
  begin
    OriginalRect.Right := OriginalRect.Right - OriginalRect.Left;
    InterlockRect.Left := InterlockRect.Left - OriginalRect.Left;
    InterlockRect.Right := InterlockRect.Right - OriginalRect.Left;
    OriginalRect.Left := 0;
  end
  else
  begin
    InterlockRect.Right := InterlockRect.Right - InterlockRect.Left;
    OriginalRect.Left := OriginalRect.Left - InterlockRect.Left;
    OriginalRect.Right := OriginalRect.Right - InterlockRect.Left;
    InterlockRect.Left := 0;
  end;
  if OriginalRect.Top < InterlockRect.Top then
  begin
    OriginalRect.Bottom := OriginalRect.Bottom - OriginalRect.Top;
    InterlockRect.Top := InterlockRect.Top - OriginalRect.Top;
    InterlockRect.Bottom := InterlockRect.Bottom - OriginalRect.Top;
    OriginalRect.Top := 0;
  end
  else
  begin
    InterlockRect.Bottom := InterlockRect.Bottom - InterlockRect.Top;
    OriginalRect.Top := OriginalRect.Top - InterlockRect.Top;
    OriginalRect.Bottom := OriginalRect.Bottom - InterlockRect.Top;
    InterlockRect.Top := 0;
  end;
end;

function OriginalKnifeNow: TPoint;
var
  Point: TPoint;

begin
  if Length(CutResults) > 0 then
  begin
    Point.x := CutResults[0].BoundingRect.Left;
    Point.y := CutResults[0].BoundingRect.Top;
  end
  else
  begin
    Point.x := -1;
    Point.y := -1;
  end;

  Result := Point;
end;

procedure AddToOverlaps(Interlock: TInterlock);
var
  i, j: integer;
  Where: TWhere;

begin
  //W1 Version
  SetLength(OriginalHullOverlaps, Length(OriginalHullOverlaps) + 1);
  i := Length(OriginalHullOverlaps) - 1;
  OriginalHullOverlaps[i].W2 := False;
  SetLength(OriginalHullOverlaps[i].Overlap, length(Interlock.Overlap));

  Where := PlotHull(WholeShape0.Hull, Interlock.Knife1BoundingRect);
  for j := 0 to Length(OriginalHullOverlaps[i].Overlap) - 1 do
  begin
    OriginalHullOverlaps[i].Overlap[j].x := Interlock.Overlap[j].x + WholeShape0.BoundingRect.Left - Where.minx;
    OriginalHullOverlaps[i].Overlap[j].y := Interlock.Overlap[j].y + WholeShape0.BoundingRect.Top - Where.miny;
  end;

  //W2 Version
  SetLength(OriginalHullOverlaps, Length(OriginalHullOverlaps) + 1);
  i := Length(OriginalHullOverlaps) - 1;
  OriginalHullOverlaps[i].W2 := True;
  SetLength(OriginalHullOverlaps[i].Overlap, Length(OriginalHullOverlaps[i - 1].Overlap));

  for j := 0 to Length(OriginalHullOverlaps[i - 1].Overlap) - 1 do
  begin
    OriginalHullOverlaps[i].Overlap[j].x := - (OriginalHullOverlaps[i - 1].Overlap[j].x - CutResults[0].BoundingRect.Left) + CutResults[0].BoundingRect.Right;
    OriginalHullOverlaps[i].Overlap[j].y := - (OriginalHullOverlaps[i - 1].Overlap[j].y - CutResults[0].BoundingRect.Top) + CutResults[0].BoundingRect.Bottom;
  end;

  //2nd Copy for W1 overlaps to block the W1
  //overlap from the second shape in the first
  if not Interlock.W2 then
  begin
    //W1 Version
    SetLength(OriginalHullOverlaps, Length(OriginalHullOverlaps) + 1);
    i := Length(OriginalHullOverlaps) - 1;
    OriginalHullOverlaps[i].W2 := False;
    SetLength(OriginalHullOverlaps[i].Overlap, length(Interlock.Overlap));

    for j := 0 to Length(OriginalHullOverlaps[i].Overlap) - 1 do
    begin
      OriginalHullOverlaps[i].Overlap[j].x := OriginalHullOverlaps[i - 2].Overlap[j].x + CutResults[0].BoundingRect.Left - CutResults[length(CutResults) - 1].BoundingRect.Left;
      OriginalHullOverlaps[i].Overlap[j].y := OriginalHullOverlaps[i - 2].Overlap[j].y + CutResults[0].BoundingRect.Top - CutResults[length(CutResults) - 1].BoundingRect.Top;
    end;

    //W2 Version
    SetLength(OriginalHullOverlaps, Length(OriginalHullOverlaps) + 1);
    i := Length(OriginalHullOverlaps) - 1;
    OriginalHullOverlaps[i].W2 := True;
    SetLength(OriginalHullOverlaps[i].Overlap, Length(OriginalHullOverlaps[i - 1].Overlap));

    for j := 0 to Length(OriginalHullOverlaps[i - 1].Overlap) - 1 do
    begin
      OriginalHullOverlaps[i].Overlap[j].x := - (OriginalHullOverlaps[i - 1].Overlap[j].x - CutResults[0].BoundingRect.Left) + CutResults[0].BoundingRect.Right;
      OriginalHullOverlaps[i].Overlap[j].y := - (OriginalHullOverlaps[i - 1].Overlap[j].y - CutResults[0].BoundingRect.Top) + CutResults[0].BoundingRect.Bottom;
    end;
  end;
end;

function GhostPosition(OriginalRect: TRect; ShapeNoToGhost, No: integer): TPoint;
var
  dx, dy, x, y: integer;

begin
  //Relative Posn of Shape to Ghost to 0th Shape
  dx := CutResults[0].BoundingRect.Left - CutResults[ShapeNoToGhost].BoundingRect.Left;
  dy := CutResults[0].BoundingRect.Top - CutResults[ShapeNoToGhost].BoundingRect.Top;

  //No shows no of ghosts to draw, -ve No means opposite direction
  x := dx * No;
  y := dy * No;
  if No < 0 then
  begin
    x := x - dx;
    y := y - dy;
  end;

  //Move to the other Side, and make relative to Whole Bounding Rect, not just 0th shape
  x := OriginalRect.Left + CutResults[0].BoundingRect.Left + x;
  y := OriginalRect.Top + CutResults[0].BoundingRect.Top + y;

  Result.x := x;
  Result.y := y;
end;

end.

