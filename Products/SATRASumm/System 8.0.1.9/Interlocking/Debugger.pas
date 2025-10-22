unit Debugger;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, General_Interlocking, StdCtrls, FastGEO, Math,
  Const_Interlocking, SummsVars;

type
  Exps = record
    c1, c2, m1, m2: double;
    GuideX, GuideY: double;
    BisX, BisY, ParaInterX, ParaInterY, XPlus, XMinus, YPoint: double;
  end;
  TExps = array of Exps;
  TBoolArray = array of Boolean;

  TfmDebugger = class(TForm)
    pcDebugger: TPageControl;
    tsExpansion: TTabSheet;
    sbExpansion: TScrollBox;
    imgExpansion: TImage;
    tsMerge: TTabSheet;
    sbMerge: TScrollBox;
    imgMerge: TImage;
    tsEdges1: TTabSheet;
    sbEdges1: TScrollBox;
    tsErrors: TTabSheet;
    lbErrors: TListBox;
    tsEdges2: TTabSheet;
    sbEdges2: TScrollBox;
    imgEdges2: TImage;
    tsPack: TTabSheet;
    sbPack: TScrollBox;
    imgPack: TImage;
    tsOverlapping: TTabSheet;
    imgEdges1: TImage;
    Image1: TImage;
    sbOverlapping: TScrollBox;
    imgOverlapping: TImage;
    TabSheet1: TTabSheet;
    sbHullPoints: TScrollBox;
    imgHullPoints: TImage;
    tsPatternsB4: TTabSheet;
    sbPatternsB4: TScrollBox;
    imgPatternsB4: TImage;
    tsPatternsAfter: TTabSheet;
    sbPAtternsAfter: TScrollBox;
    imgPatternsAfter: TImage;
    tsDistances: TTabSheet;
    sbDistances: TScrollBox;
    imgDistances: TImage;
    tsDistancesRemaining: TTabSheet;
    sbDistancesRemaining: TScrollBox;
    imgDistancesRemaining: TImage;
    tsFinal: TTabSheet;
    sbFinal: TScrollBox;
    imgFinal: TImage;
    tsPattern: TTabSheet;
    Image2: TImage;
    sbPattern: TScrollBox;
    imgPattern: TImage;
    tsNoSpikes: TTabSheet;
    Image3: TImage;
    sbNoSpikes: TScrollBox;
    imgNoSpikes: TImage;
    TabSheet2: TTabSheet;
    sbBisectors: TScrollBox;
    imgBisectors: TImage;
    tsGuidePoints: TTabSheet;
    Image4: TImage;
    sbGuidePoints: TScrollBox;
    imgGuidePoints: TImage;
    tsParas: TTabSheet;
    sbParas: TScrollBox;
    imgParas: TImage;
    tsXs: TTabSheet;
    sbXs: TScrollBox;
    imgXs: TImage;
    tsFirstExp: TTabSheet;
    sbFirstExp: TScrollBox;
    imgfirstExp: TImage;
    tsLoopFree: TTabSheet;
    sbLoopLessFirst: TScrollBox;
    imgLooplessFirst: TImage;
    tsInts: TTabSheet;
    sbInts: TScrollBox;
    imgInts: TImage;
    tsLoopsGone: TTabSheet;
    sbLoopsGone: TScrollBox;
    imgLoopsGone: TImage;
    tsFilter: TTabSheet;
    sbFilter: TScrollBox;
    imgFilter: TImage;
    tsDrawInterlock: TTabSheet;
    sbDrawInterlock: TScrollBox;
    imgDrawInterlock: TImage;
    tsDescribePattern: TTabSheet;
    sbDescribePattern: TScrollBox;
    imgDescribePattern: TImage;
    procedure DrawEdges(Pattern: TIntPolygon2D; Lefts, Rights: TSideEdges; No: integer);
    procedure CheckForDuplicatePoints(Pattern: TIntPolygon2D; s: string);
    procedure DrawFiltering(KeepPoints, OriginalPoints: TPointArray);
    procedure DrawPattern(Pattern: TPointArray);
    procedure DrawIntLines(Pattern: TPointArray; PointFound, xInt, yInt: integer);
    procedure DrawPatternSpikesGone(Pattern: TPointArray);
    procedure DrawBisector(Pattern: TPointArray; LineEqs: TExps);
    procedure DrawGuidePoints(Pattern: TPointArray; GPs: TExps);
    procedure DrawParas(Pattern: TPointArray; Paras: TExps);
    procedure DrawExpInters(Pattern: TPointArray; ExpInters: TExps);
    procedure DrawExpBis(Pattern: TPointArray; ExpBis: TExps);
    procedure DrawFirstExp(ExpandedPattern: TPointArray);
    procedure DrawLoopFreeFirstExp(Pattern, ExpandedPattern: TPointArray);
    procedure DrawExpansions(ActualPattern, ExpandedPattern: TPointArray);
//    procedure DrawLoopsGone(ActualPattern, ExpandedPattern: TPointArray; TrueSize: Boolean);
    procedure DrawLoopsGone(ExpandedPattern: TPointArray);
    procedure DrawPack;
    procedure DrawOverlappingHullLeftAndRights(LeftsHull1, RightsHull1, LeftsHull2, RightsHull2: TSideEdges;
                                               x, y, WidthHull2: integer);
    procedure DrawPointsB4Clockwise(Points: TPointArray);
    procedure DrawPointsAfterClockwise(Pattern1: TPointArray);
    procedure DrawDistanceLines(PatternWithDist1, PatternWithDist2: TPatternWithDist);
    procedure DrawDistanceLinesRemaining(PatternWithDist1, PatternWithDist2: TPatternWithDist);
    procedure DrawFinalPatterns(FinalPattern1, FinalPattern2: TFinalPattern;
                                StartPoint, StartPointPattern: integer);
    procedure DrawMerge(MergedPattern: TPointArray);
    procedure DrawHull(Hull: TPolygon2D);
    procedure FormCreate(Sender: TObject);
    procedure DrawInterlocked(Pattern1, Pattern2: TPointArray;
                              Bound1, Bound2: TRect;
                              LeftsPattern1, RightsPattern1, LeftsPattern2, RightsPattern2: TSideEdges);
    procedure DrawDescribedPattern(Pattern: TPointArray;
                                   LeftsPattern, RightsPattern: TSideEdges);

  private
    { Private declarations }
  public
    { Public declarations }
    Zoom: integer;
    TrueSize: boolean;
  end;

var
  fmDebugger: TfmDebugger;

implementation

{$R *.dfm}

uses
  Results;

procedure TfmDebugger.DrawEdges(Pattern: TIntPolygon2D; Lefts, Rights: TSideEdges; No: integer);
const
  MAGNIFY = 1;
  OFFSET = 25;

var
  minx, miny, maxx, maxy, longest: integer;
  i, j, yCount, yIndex: integer;
  PointColor: TColor;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern) - 1 do
  begin
    if Pattern[i].X < minx then
      minx := Pattern[i].x;
    if Pattern[i].Y < miny then
      miny := Pattern[i].y;
    if Pattern[i].X > maxx then
      maxx := Pattern[i].x;
    if Pattern[i].Y > maxy then
      maxy := Pattern[i].y;
  end;
  longest := max((maxx - minx), (maxy - miny));

  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;
  Bitmap.Height := (longest * MAGNIFY) + (OFFSET * 2);
  Bitmap.Width := Bitmap.Height;

  setLength(Picture, Length(Pattern) + 1);
  for i := 0 to Length(Pattern) - 1 do
  begin
    yIndex := Pattern[i].y;

    PointColor := clGreen;

    try
    yCount := Lefts[yIndex, 0];
    except
      beep
    end;
    for j := 1 to yCount do
    begin
    try
      if Lefts[yIndex, j] = Pattern[i].x then
        PointColor := clYellow;
    except
      beep;
    end;
    end;

    yCount := Rights[yIndex, 0];
    for j := 1 to yCount do
    begin
      if Rights[yIndex, j] = Pattern[i].x then
      begin
        if PointColor = clYellow then
          PointColor := clBlue
        else if PointColor <> clBlue then
          PointColor := clRed;
      end;
    end;

    //Drawing Positions
    x := (Pattern[i].x * MAGNIFY) + OFFSET;
    y := (Pattern[i].y * MAGNIFY) + OFFSET;
    Picture[i].x := x;
    Picture[i].y := y;

//if (Pattern[i].y <> 836) then
//  PointColor := clSilver;

    Bitmap.Canvas.pen.color := PointColor;
    Bitmap.Canvas.brush.color := PointColor;
    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
  end;

  //Close JUST for Drawing
  Picture[Length(Pattern)] := Picture[0];

  Bitmap.Canvas.pen.Color := clCut;
  Bitmap.Canvas.brush.color := clCut;
  Bitmap.Canvas.Polyline(Picture);

  if No = 1 then
    imgEdges1.Picture.Bitmap := Bitmap
  else
    imgEdges2.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawOverlappingHullLeftAndRights(LeftsHull1, RightsHull1, LeftsHull2, RightsHull2: TSideEdges;
                                                       x, y, WidthHull2: integer);
const
  MAGNIFY = 1;
  OFFSET = 25;

var
  minx, miny, maxx, maxy, longest, xx, yy: integer;
  i, j, yCount, yIndex: integer;
  PointColor: TColor;
  Picture: array of TPoint;
  Bitmap: TBitmap;

  Left1, Right1, Left2, Right2: integer;
  Overlap, Overlaps: integer;
  yIn1, yIn2: integer;
  HeightHull1, HeightHull2: integer;

begin
  HeightHull1 := Length(LeftsHull1);
  HeightHull2 := Length(LeftsHull2);

  longest := max(HeightHull1, WidthHull2) * 3;

  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;
  Bitmap.Height := (longest * MAGNIFY) + (OFFSET * 2);
  Bitmap.Width := Bitmap.Height;

  Overlaps := 0;
  for i := y + 1 to (y + HeightHull2 - 1) - 1 do      //the +1 and -1 are because at the extremes there can never be an overlap, they will skirt past.
  begin
    yIn1 := i - HeightHull2 - 1;
    yIn2 := i - y;

    if (yIn1 >= 0) and (yIn1 <= (HeightHull1 - 1)) then
    begin
      Left1 := LeftsHull1[yIn1, 1] + WidthHull2 + 1;
      Bitmap.Canvas.pen.color := clYellow;
      Bitmap.Canvas.brush.color := clYellow;
      xx := (Left1 * MAGNIFY) + OFFSET;
      yy := (yIn1 * MAGNIFY) + OFFSET;
      Bitmap.Canvas.MoveTo(xx, yy);
      Bitmap.Canvas.Ellipse(xx - 2, yy - 2, xx + 2, yy + 2);

      Right1 := RightsHull1[yIn1, 1] + WidthHull2 + 1;
      Bitmap.Canvas.pen.color := clRed;
      Bitmap.Canvas.brush.color := clRed;
      xx := (Right1 * MAGNIFY) + OFFSET;
      yy := (yIn1 * MAGNIFY) + OFFSET;
      Bitmap.Canvas.MoveTo(xx, yy);
      Bitmap.Canvas.Ellipse(xx - 2, yy - 2, xx + 2, yy + 2);

      Left2 := LeftsHull2[yIn2, 1] + x;
      Bitmap.Canvas.pen.color := clYellow;
      Bitmap.Canvas.brush.color := clYellow;
      xx := (Left2 * MAGNIFY) + OFFSET;
      Bitmap.Canvas.MoveTo(xx, yy);
      Bitmap.Canvas.Ellipse(xx - 2, yy - 2, xx + 2, yy + 2);

      Right2 := RightsHull2[yIn2, 1] + x;
      Bitmap.Canvas.pen.color := clRed;
      Bitmap.Canvas.brush.color := clRed;
      xx := (Right2 * MAGNIFY) + OFFSET;
      Bitmap.Canvas.MoveTo(xx, yy);
      Bitmap.Canvas.Ellipse(xx - 2, yy - 2, xx + 2, yy + 2);

      if (Right2 >= Left1) and (Right2 <= Right1) and (Left2 <= Left1) then
      begin
//        Overlap := Right2 - Left1 + 1
        Bitmap.Canvas.pen.color := clGreen;
        Bitmap.Canvas.brush.color := clGreen;
        Bitmap.Canvas.MoveTo((Right2 * MAGNIFY) + OFFSET, yy);
        Bitmap.Canvas.LineTo((Left1 * MAGNIFY) + OFFSET, yy);
      end
      else if (Left2 >= Left1) and (Left2 <= Right1) and (Right2 >= Right1) then
      begin
//        Overlap := Right1 - Left2 + 1
        Bitmap.Canvas.pen.color := clBlack;
        Bitmap.Canvas.brush.color := clBlack;
        Bitmap.Canvas.MoveTo((Right1 * MAGNIFY) + OFFSET, yy);
        Bitmap.Canvas.LineTo((Left2 * MAGNIFY) + OFFSET, yy);
      end
      else if (Left2 <= Left1) and (Right2 >= Right1) then
      begin
//        Overlap := Right1 - Left1 + 1
        Bitmap.Canvas.pen.color := clBlue;
        Bitmap.Canvas.brush.color := clBlue;
        Bitmap.Canvas.MoveTo((Right1 * MAGNIFY) + OFFSET, yy);
        Bitmap.Canvas.LineTo((Left1 * MAGNIFY) + OFFSET, yy);
      end
      else if (Left2 >= Left1) and (Right2 <= Right1) then
      begin
//        Overlap := Right2 - Left2 + 1;
        Bitmap.Canvas.pen.color := clSilver;
        Bitmap.Canvas.brush.color := clSilver;
        Bitmap.Canvas.MoveTo((Right2 * MAGNIFY) + OFFSET, yy);
        Bitmap.Canvas.LineTo((Left2 * MAGNIFY) + OFFSET, yy);
      end;

//      Overlaps := Overlaps + Overlap;
    end;
  end;

  imgOverlapping.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.CheckForDuplicatePoints(Pattern: TIntPolygon2D; s: string);
var
  i, i1: integer;

begin
  //Needs extending to Check for crossing lines AND Non consecutive duplicate points
  //Needs calling from Load, Expand, merge etc etc. Maybe not before AddPointsEvery1IN then.

  for i := 0 to Length(Pattern) - 1 do
  begin
    i1 := i + 1;
    if i1 > (Length(Pattern) - 1) then
      i1 := 0;

    //Do this as a TList
    if (Pattern[i].x = Pattern[i1].x) and (Pattern[i].y = Pattern[i1].y) then
      lbErrors.Items.Add('Duplicate Points (' + s + ')  Points ' + intToStr(i) + ' and ' + intToStr(i1));
  end;
end;

procedure TfmDebugger.DrawFiltering(KeepPoints, OriginalPoints: TPointArray);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture, Picture1, Picture2: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(KeepPoints) - 1 do
  begin
    if KeepPoints[i].X < minx then
      minx := KeepPoints[i].x;
    if KeepPoints[i].Y < miny then
      miny := KeepPoints[i].y;
    if KeepPoints[i].X > maxx then
      maxx := KeepPoints[i].x;
    if KeepPoints[i].Y > maxy then
      maxy := KeepPoints[i].y;
  end;

  if TrueSize then
  begin
    Bitmap.Height := abs(maxy - miny) + 10;
    Bitmap.Width := abs(maxx - minx) + 10;
  end
  else
  begin
    Bitmap.Height := 1000 * Zoom;
    Bitmap.Width := Bitmap.Height;
    Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));
  end;

  Bitmap.Canvas.pen.color := clRed;
  Bitmap.Canvas.Font.Color := clRed;
  Bitmap.Canvas.brush.color := clRed;
  Bitmap.Canvas.brush.Style := bsClear;
  setLength(Picture1, Length(OriginalPoints) + 1);
  for i := 0 to Length(OriginalPoints) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := OriginalPoints[i].x + ((maxx - minx) div 2) + 5;
      y := OriginalPoints[i].y + ((maxy - miny) div 2) + 5;
    end
    else
    begin
      x := round((OriginalPoints[i].x - minx) / Ratio) + 100;
      y := round((OriginalPoints[i].y - miny) / Ratio) + 100;
      x := x * Zoom;
      y := y * Zoom;
    end;

    Picture1[i].x := x;
    Picture1[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture1[Length(Picture1) - 1] := Picture1[0];
  Bitmap.Canvas.Polyline(Picture1);

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(KeepPoints) + 1);
  for i := 0 to Length(KeepPoints) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := KeepPoints[i].x + ((maxx - minx) div 2) + 5;
      y := KeepPoints[i].y + ((maxy - miny) div 2) + 5;
    end
    else
    begin
      x := round((KeepPoints[i].x - minx) / Ratio) + 100;
      y := round((KeepPoints[i].y - miny) / Ratio) + 100;
      x := x * Zoom;
      y := y * Zoom;
    end;

    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgFilter.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawPattern(Pattern: TPointArray);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern) - 1 do
  begin
    if Pattern[i].X < minx then
      minx := Pattern[i].x;
    if Pattern[i].Y < miny then
      miny := Pattern[i].y;
    if Pattern[i].X > maxx then
      maxx := Pattern[i].x;
    if Pattern[i].Y > maxy then
      maxy := Pattern[i].y;
  end;

  if TrueSize then
  begin
    Bitmap.Height := abs(maxy - miny) + 1;
    Bitmap.Width := abs(maxx - minx) + 1;
  end
  else
  begin
    Bitmap.Height := 1000 * Zoom;
    Bitmap.Width := Bitmap.Height;
    Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));
  end;

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern) + 1);
  for i := 0 to Length(Pattern) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := Pattern[i].x + 2000;
      y := Pattern[i].y + 2500;
    end
    else
    begin
      x := round((Pattern[i].x - minx) / Ratio) + 100;
      y := round((Pattern[i].y - miny) / Ratio) + 100;
      x := x * Zoom;
      y := y * Zoom;
    end;

    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgPattern.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawIntLines(Pattern: TPointArray;
                                   PointFound, xInt, yInt: integer);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern) - 1 do
  begin
    if Pattern[i].X < minx then
      minx := Pattern[i].x;
    if Pattern[i].Y < miny then
      miny := Pattern[i].y;
    if Pattern[i].X > maxx then
      maxx := Pattern[i].x;
    if Pattern[i].Y > maxy then
      maxy := Pattern[i].y;
  end;

  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;
  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern) + 1);
  for i := 0 to Length(Pattern) - 1 do
  begin
    //Drawing Positions
    x := round((Pattern[i].x - minx) / Ratio) + 100;
    y := round((Pattern[i].y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;

    Picture[i].x := x;
    Picture[i].y := y;

    if (i = PointFound) then
    begin
      Bitmap.Canvas.pen.color := clRed;
      Bitmap.Canvas.MoveTo(x, y);
      xInt := round((xInt - minx) / Ratio) + 100;
      yInt := round((yInt - miny) / Ratio) + 100;
      xInt := xInt * Zoom;
      yint := yInt * Zoom;

      Bitmap.Canvas.LineTo(xInt, yInt);
      Bitmap.Canvas.pen.color := clGreen;
    end;

    Bitmap.Canvas.MoveTo(x, y);    
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgInts.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawPatternSpikesGone(Pattern: TPointArray);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern) - 1 do
  begin
    if Pattern[i].X < minx then
      minx := Pattern[i].x;
    if Pattern[i].Y < miny then
      miny := Pattern[i].y;
    if Pattern[i].X > maxx then
      maxx := Pattern[i].x;
    if Pattern[i].Y > maxy then
      maxy := Pattern[i].y;
  end;

  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;
  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern) + 1);
  for i := 0 to Length(Pattern) - 1 do
  begin
    //Drawing Positions
    x := round((Pattern[i].x - minx) / Ratio) + 100;
    y := round((Pattern[i].y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;

    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgNoSpikes.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

function XVal(y, c, m: double): double;
begin
  result := (y - c) / m;
end;

function YVal(x, c, m: double): double;
begin
  result := (m * x) + c;
end;

procedure TfmDebugger.DrawBisector(Pattern: TPointArray;
                                   LineEqs: TExps);
var
  minx, miny, maxx, maxy, x1a, x2a, x3a, x4a, x1b, x2b, x3b, x4b, y1a, y2a, y3a, y4a, y1b, y2b, y3b, y4b, LineLength : integer;
  y1ad, y1bd, x2ad, x2bd, y3ad, y3bd, x4ad, x4bd: double;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern) - 1 do
  begin
    if Pattern[i].X < minx then
      minx := Pattern[i].x;
    if Pattern[i].Y < miny then
      miny := Pattern[i].y;
    if Pattern[i].X > maxx then
      maxx := Pattern[i].x;
    if Pattern[i].Y > maxy then
      maxy := Pattern[i].y;
  end;

  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;
  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern) + 1);
  for i := 0 to Length(Pattern) - 1 do
  begin
    //Drawing Positions
    x := round((Pattern[i].x - minx) / Ratio) + 100;
    y := round((Pattern[i].y - miny) / Ratio) + 100;

    LineLength := 100;

    try
      if (LineEqs[i].c1 <> UNDEFINED) and (LineEqs[i].m1 <> UNDEFINED) and (LineEqs[i].c1 <> 0) and
        (LineEqs[i].m1 <> 0) then
      begin
        y1ad := Pattern[i].y + LineLength;
        x1a := (round((XVal(y1ad, LineEqs[i].c1, LineEqs[i].m1) - minx) / Ratio) + 100) * Zoom;
        y1a := (round((y1ad - miny) / Ratio) + 100) * Zoom;
        y1bd := Pattern[i].y - LineLength;
        x1b := (round((XVal(y1bd, LineEqs[i].c1, LineEqs[i].m1) - minx) / Ratio) + 100) * Zoom;
        y1b := (round((y1bd - miny) / Ratio) + 100) * Zoom;

        x2ad := Pattern[i].x + LineLength;
        y2a := (round((YVal(x2ad, LineEqs[i].c1, LineEqs[i].m1) - miny) / Ratio) + 100) * Zoom;
        x2a := (round((x2ad - minx) / Ratio) + 100) * Zoom;
        x2bd := Pattern[i].x - LineLength;
        y2b := (round((YVal(x2bd, LineEqs[i].c1, LineEqs[i].m1) - miny) / Ratio) + 100) * Zoom;
        x2b := (round((x2bd - minx) / Ratio) + 100) * Zoom;
      end;

      if (LineEqs[i].c2 <> UNDEFINED) and (LineEqs[i].m2 <> UNDEFINED) and (LineEqs[i].c2 <> 0) and
        (LineEqs[i].m2 <> 0) then
      begin
        y3ad := Pattern[i].y + LineLength;
        x3a := (round((XVal(y3ad, LineEqs[i].c2, LineEqs[i].m2) - minx) / Ratio) + 100) * Zoom;
        y3a := (round((y3ad - miny) / Ratio) + 100) * Zoom;
        y3bd := Pattern[i].y - LineLength;
        x3b := (round((XVal(y3bd, LineEqs[i].c2, LineEqs[i].m2) - minx) / Ratio) + 100) * Zoom;
        y3b := (round((y3bd - miny) / Ratio) + 100) * Zoom;

        x4ad := Pattern[i].x + LineLength;
        y4a := (round((YVal(x4ad, LineEqs[i].c2, LineEqs[i].m2) - miny) / Ratio) + 100) * Zoom;
        x4a := (round((x4ad - minx) / Ratio) + 100) * Zoom;
        x4bd := Pattern[i].x - LineLength;
        y4b := (round((YVal(x4bd, LineEqs[i].c2, LineEqs[i].m2) - miny) / Ratio) + 100) * Zoom;
        x4b := (round((x4bd - minx) / Ratio) + 100) * Zoom;
      end;

      x := x * Zoom;
      y := y * Zoom;

      Picture[i].x := x;
      Picture[i].y := y;

      Bitmap.Canvas.MoveTo(x, y);
      Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
      Bitmap.Canvas.TextOut(x, y, intTostr(i));

      Bitmap.Canvas.Pen.Color := clBlack;
      Bitmap.Canvas.MoveTo(x1a, y1a);
      Bitmap.Canvas.LineTo(x1b, y1b);
      Bitmap.Canvas.LineTo(x2a, y2a);
      Bitmap.Canvas.LineTo(x2b, y2b);
      Bitmap.Canvas.MoveTo(x3a, y3a);
      Bitmap.Canvas.LineTo(x3b, y3b);
      Bitmap.Canvas.LineTo(x4a, y4a);
      Bitmap.Canvas.LineTo(x4b, y4b);
      Bitmap.Canvas.Pen.Color := clGreen;
    except
    end;
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgBisectors.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawGuidePoints(Pattern: TPointArray;
                                      GPs: TExps);
var
  minx, miny, maxx, maxy, GPx, GPy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern) - 1 do
  begin
    if Pattern[i].X < minx then
      minx := Pattern[i].x;
    if Pattern[i].Y < miny then
      miny := Pattern[i].y;
    if Pattern[i].X > maxx then
      maxx := Pattern[i].x;
    if Pattern[i].Y > maxy then
      maxy := Pattern[i].y;
  end;

  //Can only show these accurately if expansion is shown full size - the moment it is reduced the guide points
  //(mostly) just become the same as the points.
  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;
  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

//  Bitmap.Height := abs(maxy - miny) + 1;
//  Bitmap.Width := abs(maxx - minx) + 1;

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern) + 1);
  for i := 0 to Length(Pattern) - 1 do
  begin
    //Drawing Positions
    x := round((Pattern[i].x - minx) / Ratio) + 100;
    y := round((Pattern[i].y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;

//    x := round(Pattern[i].x);
//    y := round(Pattern[i].y);

    GPx := (round((GPs[i].GuideX - minx) / Ratio) + 100) * zoom;
    GPy := (round((GPs[i].GuideY - miny) / Ratio) + 100) * zoom;
//    GPx := round(GPs[i].GuideX);
//    GPy := round(GPs[i].GuideY);

    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));

    Bitmap.Canvas.Pen.Color := clBlack;
    Bitmap.Canvas.MoveTo(GPx, GPy);
    Bitmap.Canvas.Ellipse(GPx - 2, GPy - 2, GPx + 2, GPy + 2);
    Bitmap.Canvas.Pen.Color := clGreen;
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgGuidePoints.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawParas(Pattern: TPointArray; Paras: TExps);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Parax, Paray: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern) - 1 do
  begin
    if Pattern[i].X < minx then
      minx := Pattern[i].x;
    if Pattern[i].Y < miny then
      miny := Pattern[i].y;
    if Pattern[i].X > maxx then
      maxx := Pattern[i].x;
    if Pattern[i].Y > maxy then
      maxy := Pattern[i].y;
  end;

  if TrueSize then
  begin
    Bitmap.Height := abs(maxy - miny) + 1;
    Bitmap.Width := abs(maxx - minx) + 1;
  end
  else
  begin
    Bitmap.Height := 1000 * Zoom;
    Bitmap.Width := Bitmap.Height;
    Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));
  end;

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern) + 1);
  for i := 0 to Length(Pattern) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := Pattern[i].x;
      y := Pattern[i].y;
    end
    else
    begin
      x := round((Pattern[i].x - minx) / Ratio) + 100;
      y := round((Pattern[i].y - miny) / Ratio) + 100;
      x := x * Zoom;
      y := y * Zoom;
    end;

    if TrueSize then
    begin
      ParaX := round(Paras[i].ParaInterX);
      ParaY := round(Paras[i].ParaInterY);
    end
    else
    begin
      Parax := (round((Paras[i].ParaInterX - minx) / Ratio) + 100) * zoom;
      Paray := (round((Paras[i].ParaInterY - miny) / Ratio) + 100) * zoom;
    end;

    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
    Bitmap.Canvas.Pen.Color := clBlack;
    Bitmap.Canvas.MoveTo(ParaX, ParaY);
    Bitmap.Canvas.Ellipse(ParaX - 2, ParaY - 2, ParaX + 2, ParaY + 2);
    Bitmap.Canvas.Pen.Color := clGreen;
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgParas.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawExpInters(Pattern: TPointArray;
                                    ExpInters: TExps);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  XPlus, XMinus: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern) - 1 do
  begin
    if Pattern[i].X < minx then
      minx := Pattern[i].x;
    if Pattern[i].Y < miny then
      miny := Pattern[i].y;
    if Pattern[i].X > maxx then
      maxx := Pattern[i].x;
    if Pattern[i].Y > maxy then
      maxy := Pattern[i].y;
  end;

  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;
  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern) + 1);
  for i := 0 to Length(Pattern) - 1 do
  begin
    //Drawing Positions
    x := round((Pattern[i].x - minx) / Ratio) + 100;
    y := round((Pattern[i].y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;

    XPlus := (round((ExpInters[i].XPlus - minx) / Ratio) + 100) * zoom;;
    XMinus := (round((ExpInters[i].XMinus - miny) / Ratio) + 100) * zoom;;

    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
    Bitmap.Canvas.Pen.Color := clBlack;
    Bitmap.Canvas.MoveTo(XMinus, y);
    Bitmap.Canvas.Ellipse(XMinus - 2, y - 2, XMinus + 2, y + 2);
    Bitmap.Canvas.Pen.Color := clRed;    
    Bitmap.Canvas.MoveTo(XPlus, y);
    Bitmap.Canvas.Ellipse(XPlus - 2, y - 2, XPlus + 2, y + 2);
    Bitmap.Canvas.Pen.Color := clGreen;
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgXs.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawExpBis(Pattern: TPointArray;
                                 ExpBis: TExps);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  XBis, YBis: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern) - 1 do
  begin
    if Pattern[i].X < minx then
      minx := Pattern[i].x;
    if Pattern[i].Y < miny then
      miny := Pattern[i].y;
    if Pattern[i].X > maxx then
      maxx := Pattern[i].x;
    if Pattern[i].Y > maxy then
      maxy := Pattern[i].y;
  end;

  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;
  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern) + 1);
  for i := 0 to Length(Pattern) - 1 do
  begin
    //Drawing Positions
    x := round((Pattern[i].x - minx) / Ratio) + 100;
    y := round((Pattern[i].y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;

    XBis := (round((ExpBis[i].BisX - minx) / Ratio) + 100) * zoom;;
    YBis := (round((ExpBis[i].BisY - miny) / Ratio) + 100) * zoom;;

    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
    Bitmap.Canvas.Pen.Color := clRed;
    Bitmap.Canvas.MoveTo(XBis, YBis);
    Bitmap.Canvas.Ellipse(XBis - 2, YBis - 2, XBis + 2, YBis + 2);
    Bitmap.Canvas.Pen.Color := clGreen;
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgXs.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawFirstExp(ExpandedPattern: TPointArray);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  XBis, YBis: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(ExpandedPattern) - 1 do
  begin
    if ExpandedPattern[i].X < minx then
      minx := ExpandedPattern[i].x;
    if ExpandedPattern[i].Y < miny then
      miny := ExpandedPattern[i].y;
    if ExpandedPattern[i].X > maxx then
      maxx := ExpandedPattern[i].x;
    if ExpandedPattern[i].Y > maxy then
      maxy := ExpandedPattern[i].y;
  end;

  if TrueSize then
  begin
    Bitmap.Height := abs(maxy - miny) + 1;
    Bitmap.Width := abs(maxx - minx) + 1;
  end
  else
  begin
    Bitmap.Height := 1000 * Zoom;
    Bitmap.Width := Bitmap.Height;
    Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));
  end;

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(ExpandedPattern) + 1);
  for i := 0 to Length(ExpandedPattern) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := ExpandedPattern[i].x;
      y := ExpandedPattern[i].y;
    end
    else
    begin
      x := round((ExpandedPattern[i].x - minx) / Ratio) + 100;
      y := round((ExpandedPattern[i].y - miny) / Ratio) + 100;
      x := x * Zoom;
      y := y * Zoom;
    end;

    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgFirstExp.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawLoopFreeFirstExp(Pattern, ExpandedPattern: TPointArray);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  XBis, YBis: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(ExpandedPattern) - 1 do
  begin
    if ExpandedPattern[i].X < minx then
      minx := ExpandedPattern[i].x;
    if ExpandedPattern[i].Y < miny then
      miny := ExpandedPattern[i].y;
    if ExpandedPattern[i].X > maxx then
      maxx := ExpandedPattern[i].x;
    if ExpandedPattern[i].Y > maxy then
      maxy := ExpandedPattern[i].y;
  end;

  if TrueSize then
  begin
    Bitmap.Height := abs(maxy - miny) + 1;
    Bitmap.Width := abs(maxx - minx) + 1;
  end
  else
  begin
    Bitmap.Height := 1000 * Zoom;
    Bitmap.Width := Bitmap.Height;
    Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));
  end;

  //Draw Pattern
  Bitmap.Canvas.pen.color := clCut;
  Bitmap.Canvas.Font.Color := clCut;
  Bitmap.Canvas.brush.color := clCut;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern) + 1);
  for i := 0 to Length(Pattern) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := Pattern[i].x;
      y := Pattern[i].y;
    end
    else
    begin
      x := round((Pattern[i].x - minx) / Ratio) + 100;
      y := round((Pattern[i].y - miny) / Ratio) + 100;
      x := x * Zoom;
      y := y * Zoom;
    end;

    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);  

  //Draw First expansion
  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(ExpandedPattern) + 1);
  for i := 0 to Length(ExpandedPattern) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := ExpandedPattern[i].x;
      y := ExpandedPattern[i].y;
    end
    else
    begin
      x := round((ExpandedPattern[i].x - minx) / Ratio) + 100;
      y := round((ExpandedPattern[i].y - miny) / Ratio) + 100;
      x := x * Zoom;
      y := y * Zoom;
    end;

    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgLooplessFirst.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawExpansions(ActualPattern, ExpandedPattern: TPointArray);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(ExpandedPattern) - 1 do
  begin
    if ExpandedPattern[i].X < minx then
      minx := ExpandedPattern[i].x;
    if ExpandedPattern[i].Y < miny then
      miny := ExpandedPattern[i].y;
    if ExpandedPattern[i].X > maxx then
      maxx := ExpandedPattern[i].x;
    if ExpandedPattern[i].Y > maxy then
      maxy := ExpandedPattern[i].y;
  end;

  if TrueSize then
  begin
    Bitmap.Height := (abs(maxy - miny) + 1) * 2;
    Bitmap.Width := (abs(maxx - minx) + 1) * 2;
  end
  else
  begin
    Bitmap.Height := 1000 * Zoom;
    Bitmap.Width := Bitmap.Height;
    Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));
  end;

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(ActualPattern) + 1);
  for i := 0 to Length(ActualPattern) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := ActualPattern[i].x + abs(MinX) + 100;
      y := ActualPattern[i].y + abs(MinY) + 100;
    end
    else
    begin
      x := round((ActualPattern[i].x - minx) / Ratio) + 100;
      y := round((ActualPattern[i].y - miny) / Ratio) + 100;
      x := x * Zoom;
      y := y * Zoom;
    end;
    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  Bitmap.Canvas.pen.color := clRed;
  Bitmap.Canvas.Font.Color := clRed;
  Bitmap.Canvas.brush.color := clRed;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(ExpandedPattern) + 1);
  for i := 0 to Length(ExpandedPattern) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := ExpandedPattern[i].x + abs(MinX) + 100;
      y := ExpandedPattern[i].y + abs(MinY) + 100;
    end
    else
    begin
      x := round((ExpandedPattern[i].x - minx) / Ratio) + 100;
      y := round((ExpandedPattern[i].y - miny) / Ratio) + 100;
      x := x * Zoom;
      y := y * Zoom;
    end;
    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
//    if (i = 111) or (i =110) or (i = 139) or (i = 140) or (i = 154) or (i = 155) or (i = 184) or (i = 185) then
//if i <> 64 then
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgExpansion.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

//procedure TfmDebugger.DrawLoopsGone(ActualPattern, ExpandedPattern: TPointArray;
procedure TfmDebugger.DrawLoopsGone(ExpandedPattern: TPointArray);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(ExpandedPattern) - 1 do
  begin
    if ExpandedPattern[i].X < minx then
      minx := ExpandedPattern[i].x;
    if ExpandedPattern[i].Y < miny then
      miny := ExpandedPattern[i].y;
    if ExpandedPattern[i].X > maxx then
      maxx := ExpandedPattern[i].x;
    if ExpandedPattern[i].Y > maxy then
      maxy := ExpandedPattern[i].y;
  end;

  if TrueSize then
  begin
    Bitmap.Height := abs(maxy - miny) + 1;
    Bitmap.Width := abs(maxx - minx) + 1;
  end
  else
  begin
    Bitmap.Height := 1000 * Zoom;
    Bitmap.Width := Bitmap.Height;
    Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));
  end;

{  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(ActualPattern) + 1);
  for i := 0 to Length(ActualPattern) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := ActualPattern[i].x;
      y := ActualPattern[i].y;
    end
    else
    begin
      x := round((ActualPattern[i].x - minx) / Ratio) + 100;
      y := round((ActualPattern[i].y - miny) / Ratio) + 100;
      x := x * Zoom;
      y := y * Zoom;
    end;
    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);}

  Bitmap.Canvas.pen.color := clRed;
  Bitmap.Canvas.Font.Color := clRed;
  Bitmap.Canvas.brush.color := clRed;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(ExpandedPattern) + 1);
  for i := 0 to Length(ExpandedPattern) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := ExpandedPattern[i].x;
      y := ExpandedPattern[i].y;
    end
    else
    begin
      x := round((ExpandedPattern[i].x - minx) / Ratio) + 100;
      y := round((ExpandedPattern[i].y - miny) / Ratio) + 100;
      x := x * Zoom;
      y := y * Zoom;
    end;
    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
//    if (i = 111) or (i =110) or (i = 139) or (i = 140) or (i = 154) or (i = 155) or (i = 184) or (i = 185) then
//if i <> 64 then
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgLoopsGone.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawMerge(MergedPattern: TPointArray);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;
  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(MergedPattern) - 1 do
  begin
    if MergedPattern[i].X < minx then
      minx := MergedPattern[i].x;
    if MergedPattern[i].Y < miny then
      miny := MergedPattern[i].y;
    if MergedPattern[i].X > maxx then
      maxx := MergedPattern[i].x;
    if MergedPattern[i].Y > maxy then
      maxy := MergedPattern[i].y;
  end;

  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

  //***Hull***
  Bitmap.Canvas.pen.color := clCut;
  Bitmap.Canvas.pen.Width := 1;
  Bitmap.Canvas.Font.Color := clCut;
  Bitmap.Canvas.brush.color := clCut;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(MergedPattern) + 1);
  for i := 0 to Length(MergedPattern) - 1 do
  begin
    //Drawing Positions
    x := round((MergedPattern[i].x - minx) / Ratio) + 100;
    y := round((MergedPattern[i].y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;
    Picture[i].x := x;
    Picture[i].y := y;

    if (i mod 2 = 0) then
      Bitmap.Canvas.pen.color := clCut
    else
      Bitmap.Canvas.pen.color := clRed;

    Bitmap.Canvas.Font.Color := Bitmap.Canvas.pen.color;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgMerge.Picture.Bitmap := Bitmap;

  Bitmap.free;
end;

procedure TfmDebugger.DrawHull(Hull: TPolygon2D);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;
  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Hull) - 1 do
  begin
    if Hull[i].X < minx then
      minx := round(Hull[i].x);
    if Hull[i].Y < miny then
      miny := round(Hull[i].y);
    if Hull[i].X > maxx then
      maxx := round(Hull[i].x);
    if Hull[i].Y > maxy then
      maxy := round(Hull[i].y);
  end;

  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

  //***First Hull***
  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.pen.Width := 1;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Hull) + 1);
  for i := 0 to Length(Hull) - 1 do
  begin
    //Drawing Positions
    x := round((Hull[i].x - minx) / Ratio) + 100;
    y := round((Hull[i].y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;
    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgHullPoints.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawPointsB4Clockwise(Points: TPointArray);

var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
{  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;
  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Points) - 1 do
  begin
    if Points[i].X < minx then
      minx := round(Points[i].x);
    if Points[i].Y < miny then
      miny := round(Points[i].y);
    if Points[i].X > maxx then
      maxx := round(Points[i].x);
    if Points[i].Y > maxy then
      maxy := round(Points[i].y);
  end;

  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

  //***First Hull***
  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.pen.Width := 1;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Points) + 1);
  for i := 0 to Length(Points) - 1 do
  begin
    //Drawing Positions
    x := round((Points[i].x - minx) / Ratio) + 100;
    y := round((Points[i].y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;
    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgPatternsB4.Picture.Bitmap := Bitmap;

  Bitmap.Free;}
end;

procedure TfmDebugger.FormCreate(Sender: TObject);
begin
  Zoom := 2;
end;

procedure TfmDebugger.DrawPointsAfterClockwise(Pattern1: TPointArray);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;
  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern1) - 1 do
  begin
    if Pattern1[i].X < minx then
      minx := round(Pattern1[i].x);
    if Pattern1[i].Y < miny then
      miny := round(Pattern1[i].y);
    if Pattern1[i].X > maxx then
      maxx := round(Pattern1[i].x);
    if Pattern1[i].Y > maxy then
      maxy := round(Pattern1[i].y);
  end;

  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

  //***First Hull***
  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.pen.Width := 1;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern1) + 1);
  for i := 0 to Length(Pattern1) - 1 do
  begin
    //Drawing Positions
    x := round((Pattern1[i].x - minx) / Ratio) + 100;
    y := round((Pattern1[i].y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;
    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

//  imgPatternsAfter.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawDistanceLines(PatternWithDist1, PatternWithDist2: TPatternWithDist);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y, x1, y1: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;
  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(PatternWithDist1) - 1 do
  begin
    if PatternWithDist1[i].OriginalPoint.X < minx then
      minx := PatternWithDist1[i].OriginalPoint.x;
    if PatternWithDist1[i].OriginalPoint.Y < miny then
      miny := PatternWithDist1[i].OriginalPoint.y;
    if PatternWithDist1[i].OriginalPoint.X > maxx then
      maxx := PatternWithDist1[i].OriginalPoint.x;
    if PatternWithDist1[i].OriginalPoint.Y > maxy then
      maxy := PatternWithDist1[i].OriginalPoint.y;
  end;

  for i := 0 to Length(PatternWithDist2) - 1 do
  begin
    if PatternWithDist2[i].OriginalPoint.X < minx then
      minx := PatternWithDist2[i].OriginalPoint.x;
    if PatternWithDist2[i].OriginalPoint.Y < miny then
      miny := PatternWithDist2[i].OriginalPoint.y;
    if PatternWithDist2[i].OriginalPoint.X > maxx then
      maxx := PatternWithDist2[i].OriginalPoint.x;
    if PatternWithDist2[i].OriginalPoint.Y > maxy then
      maxy := PatternWithDist2[i].OriginalPoint.y;
  end;
  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.pen.Width := 1;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(PatternWithDist1) + 1);
  for i := 0 to Length(PatternWithDist1) - 1 do
  begin
    //Drawing Positions
    x := round((PatternWithDist1[i].OriginalPoint.x - minx) / Ratio) + 100;
    y := round((PatternWithDist1[i].OriginalPoint.y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;
    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));

    //Line end
    if PatternWithDist1[i].PossibleMergePoint then
      Bitmap.Canvas.pen.color := clBlack
    else
      Bitmap.Canvas.pen.color := clSilver;
    x1 := round((PatternWithDist1[i].ClosePoint.x - minx) / Ratio) + 100;
    y1 := round((PatternWithDist1[i].ClosePoint.y - miny) / Ratio) + 100;
    x1 := x1 * Zoom;
    y1 := y1 * Zoom;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.LineTo(x1, y1);
    Bitmap.Canvas.pen.color := clGreen;
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  Bitmap.Canvas.pen.color := clBlue;
  Bitmap.Canvas.pen.Width := 1;
  Bitmap.Canvas.Font.Color := clBlue;
  Bitmap.Canvas.brush.color := clBlue;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(PatternWithDist2) + 1);
  for i := 0 to Length(PatternWithDist2) - 1 do
  begin
    //Drawing Positions
    x := round((PatternWithDist2[i].OriginalPoint.x - minx) / Ratio) + 100;
    y := round((PatternWithDist2[i].OriginalPoint.y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;
    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));

    //Line end
    if PatternWithDist2[i].PossibleMergePoint then
      Bitmap.Canvas.pen.color := clBlack
    else
      Bitmap.Canvas.pen.color := clSilver;
    x1 := round((PatternWithDist2[i].ClosePoint.x - minx) / Ratio) + 100;
    y1 := round((PatternWithDist2[i].ClosePoint.y - miny) / Ratio) + 100;
    x1 := x1 * Zoom;
    y1 := y1 * Zoom;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.LineTo(x1, y1);
    Bitmap.Canvas.pen.color := clBlue;
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgDistances.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawDistanceLinesRemaining(PatternWithDist1, PatternWithDist2: TPatternWithDist);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y, x1, y1: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;
  f: textfile;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;
  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;

  AssignFile(f, 'c:\overlap.txt');
  Rewrite(f);


  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(PatternWithDist1) - 1 do
  begin
    writeln(f, i, ' ', PatternWithDist1[i].OriginalPoint.x, ' ', PatternWithDist1[i].OriginalPoint.y);
    if PatternWithDist1[i].OriginalPoint.X < minx then
      minx := PatternWithDist1[i].OriginalPoint.x;
    if PatternWithDist1[i].OriginalPoint.Y < miny then
      miny := PatternWithDist1[i].OriginalPoint.y;
    if PatternWithDist1[i].OriginalPoint.X > maxx then
      maxx := PatternWithDist1[i].OriginalPoint.x;
    if PatternWithDist1[i].OriginalPoint.Y > maxy then
      maxy := PatternWithDist1[i].OriginalPoint.y;
  end;

  for i := 0 to Length(PatternWithDist2) - 1 do
  begin
    writeln(f, i, ' ', PatternWithDist2[i].OriginalPoint.x, ' ', PatternWithDist2[i].OriginalPoint.y);
    if PatternWithDist2[i].OriginalPoint.X < minx then
      minx := PatternWithDist2[i].OriginalPoint.x;
    if PatternWithDist2[i].OriginalPoint.Y < miny then
      miny := PatternWithDist2[i].OriginalPoint.y;
    if PatternWithDist2[i].OriginalPoint.X > maxx then
      maxx := PatternWithDist2[i].OriginalPoint.x;
    if PatternWithDist2[i].OriginalPoint.Y > maxy then
      maxy := PatternWithDist2[i].OriginalPoint.y;
  end;

  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));
  writeln(f, minx, ' ', miny);
  writeln(f, ratio);
closefile(f);
  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.pen.Width := 1;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(PatternWithDist1) + 1);
  for i := 0 to Length(PatternWithDist1) - 1 do
  begin
    //Drawing Positions
    x := round((PatternWithDist1[i].OriginalPoint.x - minx) / Ratio) + 100;
    y := round((PatternWithDist1[i].OriginalPoint.y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;
    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    if PatternWithDist1[i].PossibleMergePoint then
    begin
      Bitmap.Canvas.pen.color := clMaroon;
      Bitmap.Canvas.Ellipse(x - 3, y - 3, x + 3, y + 3);
      Bitmap.Canvas.pen.color := clGreen;
    end
    else
      Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);

    if (i = 822) or (i = 1166) then   
      Bitmap.Canvas.TextOut(x, y, intTostr(i));

    //Line end
    if PatternWithDist1[i].PossibleMergePoint then
    begin
      Bitmap.Canvas.pen.color := clRed;
      x1 := round((PatternWithDist1[i].ClosePoint.x - minx) / Ratio) + 100;
      y1 := round((PatternWithDist1[i].ClosePoint.y - miny) / Ratio) + 100;
      x1 := x1 * Zoom;
      y1 := y1 * Zoom;

      Bitmap.Canvas.MoveTo(x, y);
      Bitmap.Canvas.LineTo(x1, y1);
      Bitmap.Canvas.pen.color := clGreen;
    end;
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  Bitmap.Canvas.pen.color := clBlue;
  Bitmap.Canvas.pen.Width := 1;
  Bitmap.Canvas.Font.Color := clBlue;
  Bitmap.Canvas.brush.color := clBlue;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(PatternWithDist2) + 1);
  for i := 0 to Length(PatternWithDist2) - 1 do
  begin
    //Drawing Positions
    x := round((PatternWithDist2[i].OriginalPoint.x - minx) / Ratio) + 100;
    y := round((PatternWithDist2[i].OriginalPoint.y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;
    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    if PatternWithDist2[i].PossibleMergePoint then
    begin
      Bitmap.Canvas.pen.color := clMaroon;
      Bitmap.Canvas.Ellipse(x - 3, y - 3, x + 3, y + 3);
      Bitmap.Canvas.pen.color := clGreen;
    end
    else
      Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);

    if (i = 60) then
      Bitmap.Canvas.TextOut(x, y, intTostr(i));

    //Line end
    if PatternWithDist2[i].PossibleMergePoint then
    begin
      Bitmap.Canvas.pen.color := clRed;
      x1 := round((PatternWithDist2[i].ClosePoint.x - minx) / Ratio) + 100;
      y1 := round((PatternWithDist2[i].ClosePoint.y - miny) / Ratio) + 100;
      x1 := x1 * Zoom;
      y1 := y1 * Zoom;

      Bitmap.Canvas.MoveTo(x, y);
      Bitmap.Canvas.LineTo(x1, y1);
      Bitmap.Canvas.pen.color := clBlue;
    end;
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgDistancesRemaining.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawFinalPatterns(FinalPattern1, FinalPattern2: TFinalPattern;
                                        StartPoint, StartPointPattern: integer);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;
  Bitmap.Height := 1000 * Zoom;
  Bitmap.Width := Bitmap.Height;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(FinalPattern1) - 1 do
  begin
    if FinalPattern1[i].Point.X < minx then
      minx := FinalPattern1[i].Point.x;
    if FinalPattern1[i].Point.Y < miny then
      miny := FinalPattern1[i].Point.y;
    if FinalPattern1[i].Point.X > maxx then
      maxx := FinalPattern1[i].Point.x;
    if FinalPattern1[i].Point.Y > maxy then
      maxy := FinalPattern1[i].Point.y;
  end;

  for i := 0 to Length(FinalPattern2) - 1 do
  begin
    if FinalPattern2[i].Point.X < minx then
      minx := FinalPattern2[i].Point.x;
    if FinalPattern2[i].Point.Y < miny then
      miny := FinalPattern2[i].Point.y;
    if FinalPattern2[i].Point.X > maxx then
      maxx := FinalPattern2[i].Point.x;
    if FinalPattern2[i].Point.Y > maxy then
      maxy := FinalPattern2[i].Point.y;
  end;
  Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));

  //***First Pattern***
  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.pen.Width := 1;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(FinalPattern1) + 1);
  for i := 0 to Length(FinalPattern1) - 1 do
  begin
    //Drawing Positions
    x := round((FinalPattern1[i].Point.x - minx) / Ratio) + 100;
    y := round((FinalPattern1[i].Point.y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;
    Picture[i].x := x;
    Picture[i].y := y;

    if (i = StartPoint) and (StartPointPattern = 1) then
    begin
      Bitmap.Canvas.pen.color := clBlack;
      Bitmap.Canvas.MoveTo(x, y);
      Bitmap.Canvas.Ellipse(x - 5, y - 5, x + 5, y + 5);
    end;

    if FinalPattern1[i].ActualMergePoint then
    begin
      Bitmap.Canvas.pen.color := clMaroon;
      Bitmap.Canvas.Ellipse(x - 3, y - 3, x + 3, y + 3);
    end
    else
    begin
      Bitmap.Canvas.pen.color := clGreen;
      Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    end;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  //***Second Pattern***
  Bitmap.Canvas.pen.color := clBlue;
  Bitmap.Canvas.pen.Width := 1;
  Bitmap.Canvas.Font.Color := clBlue;
  Bitmap.Canvas.brush.color := clBlue;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(FinalPattern2) + 1);
  for i := 0 to Length(FinalPattern2) - 1 do
  begin
    //Drawing Positions
    x := round((FinalPattern2[i].Point.x - minx) / Ratio) + 100;
    y := round((FinalPattern2[i].Point.y - miny) / Ratio) + 100;
    x := x * Zoom;
    y := y * Zoom;
    Picture[i].x := x;
    Picture[i].y := y;

    if (i = StartPoint) and (StartPointPattern = 2) then
    begin
      Bitmap.Canvas.pen.color := clBlack;
      Bitmap.Canvas.MoveTo(x, y);
      Bitmap.Canvas.Ellipse(x - 5, y - 5, x + 5, y + 5);
    end;

    if FinalPattern2[i].ActualMergePoint then
    begin
      Bitmap.Canvas.pen.color := clMaroon;
      Bitmap.Canvas.Ellipse(x - 3, y - 3, x + 3, y + 3);
    end
    else
    begin
      Bitmap.Canvas.pen.color := clGreen;
      Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    end;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  imgFinal.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawPack;
var
  bmpResults: TBitmap;
  i, minx, miny, maxx, maxy: integer;

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

  bmpResults := TBitmap.Create;
  bmpResults.PixelFormat := pf4bit;
  bmpResults.Height := maxy - miny;
  bmpResults.Width := maxx - minx;

  bmpResults.Canvas.brush.Color := clHide;
  bmpResults.Canvas.FillRect(Rect(0, 0, bmpResults.Width, bmpResults.Height));

  DrawResults(bmpResults.Canvas, 0, 0, 1, False, False, False, False, True, False, False, False, 1);
                                                                      //ShowNumbers
  imgPack.Picture.Bitmap := bmpResults;

  bmpResults.Free;
end;

procedure TfmDebugger.DrawInterlocked(Pattern1, Pattern2: TPointArray;
                                      Bound1, Bound2: TRect;
                                      LeftsPattern1, RightsPattern1, LeftsPattern2, RightsPattern2: TSideEdges);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i, j: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern1) - 1 do
  begin
    Pattern1[i].x := Pattern1[i].X + Bound1.Left;
    Pattern1[i].y := Pattern1[i].y + Bound1.Top;

    if Pattern1[i].X < minx then
      minx := Pattern1[i].x;
    if Pattern1[i].Y < miny then
      miny := Pattern1[i].y;
    if Pattern1[i].X > maxx then
      maxx := Pattern1[i].x;
    if Pattern1[i].Y > maxy then
      maxy := Pattern1[i].y;
  end;

  for i := 0 to Length(Pattern2) - 1 do
  begin
    Pattern2[i].x := Pattern2[i].X + Bound2.Left;
    Pattern2[i].y := Pattern2[i].y + Bound2.Top;

    if Pattern2[i].X < minx then
      minx := Pattern2[i].x;
    if Pattern2[i].Y < miny then
      miny := Pattern2[i].y;
    if Pattern2[i].X > maxx then
      maxx := Pattern2[i].x;
    if Pattern2[i].Y > maxy then
      maxy := Pattern2[i].y;
  end;

  if TrueSize then
  begin
    Bitmap.Height := abs(maxy - miny) * (zoom * 2) + 10;
    Bitmap.Width := abs(maxx - minx) * (zoom * 2) + 10 + 2000;
  end
  else
  begin
    Bitmap.Height := 1000 * Zoom;
    Bitmap.Width := Bitmap.Height;
    Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));
  end;

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern1) + 1);
  for i := 0 to Length(Pattern1) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := Pattern1[i].x + ((maxx - minx) div 2) + 5;
      y := Pattern1[i].y + ((maxy - miny) div 2) + 5;
    end
    else
    begin
      x := round((Pattern1[i].x - minx) / Ratio) + 100;
      y := round((Pattern1[i].y - miny) / Ratio) + 100;
    end;

    x := x * Zoom;
    y := y * Zoom;

    Picture[i].x := x;
    Picture[i].y := y;

{    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);   }
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  Bitmap.Canvas.pen.color := clLime;
  Bitmap.Canvas.brush.color := clLime;
  Bitmap.Canvas.brush.Style := bsSolid;

  for i := 0 to Length(LeftsPattern1) - 1 do
  begin
    for j := 1 to LeftsPattern1[i, 0] do
    begin
      if TrueSize then
      begin
        x := LeftsPattern1[i, j] + Bound1.Left + ((maxx - minx) div 2) + 5;
        y := i + Bound1.Top + ((maxy - miny) div 2) + 5;
      end
      else
      begin
        x := round((LeftsPattern1[i, j] + Bound1.Left - minx) / Ratio) + 100;
        y := round((i + Bound1.Top - miny) / Ratio) + 100;
      end;

      x := x * Zoom;
      y := y * Zoom;

      Bitmap.Canvas.MoveTo(x, y);
      Bitmap.Canvas.Ellipse(x - 4, y - 4, x + 4, y + 4);
    end;
  end;

  Bitmap.Canvas.pen.color := clRed;
  Bitmap.Canvas.brush.color := clRed;
  Bitmap.Canvas.brush.Style := bsSolid;

  for i := 0 to Length(RightsPattern1) - 1 do
  begin
    for j := 1 to RightsPattern1[i, 0] do
    begin
      if TrueSize then
      begin
        x := RightsPattern1[i, j] + Bound1.Left + ((maxx - minx) div 2) + 5;
        y := i + Bound1.Top + ((maxy - miny) div 2) + 5;
      end
      else
      begin
        x := round((RightsPattern1[i, j] + Bound1.Left - minx) / Ratio) + 100;
        y := round((i + Bound1.Top - miny) / Ratio) + 100;
      end;

      x := x * Zoom;
      y := y * Zoom;

      Bitmap.Canvas.MoveTo(x, y);
      Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    end;
  end;

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern2) + 1);
  for i := 0 to Length(Pattern2) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := Pattern2[i].x + ((maxx - minx) div 2) + 5;
      y := Pattern2[i].y + ((maxy - miny) div 2) + 5;
    end
    else
    begin
      x := round((Pattern2[i].x - minx) / Ratio) + 100;
      y := round((Pattern2[i].y - miny) / Ratio) + 100;
    end;

    x := x * Zoom;
    y := y * Zoom;

    Picture[i].x := x;
    Picture[i].y := y;

{    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);   }
    Bitmap.Canvas.TextOut(x, y, intTostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsSolid;

  for i := 0 to Length(LeftsPattern2) - 1 do
  begin
    for j := 1 to LeftsPattern2[i, 0] do
    begin
      if TrueSize then
      begin
        x := LeftsPattern2[i, j] + Bound2.Left + ((maxx - minx) div 2) + 5;
        y := i + Bound2.Top + ((maxy - miny) div 2) + 5;
      end
      else
      begin
        x := round((LeftsPattern2[i, j] + Bound2.Left - minx) / Ratio) + 100;
        y := round((i + Bound2.Top - miny) / Ratio) + 100;
      end;

      x := x * Zoom;
      y := y * Zoom;

      Bitmap.Canvas.MoveTo(x, y);
      Bitmap.Canvas.Ellipse(x - 4, y - 4, x + 4, y + 4);
    end;
  end;

  Bitmap.Canvas.pen.color := clMaroon;
  Bitmap.Canvas.brush.color := clMaroon;
  Bitmap.Canvas.brush.Style := bsSolid;

  for i := 0 to Length(RightsPattern2) - 1 do
  begin
    for j := 1 to RightsPattern2[i, 0] do
    begin
      if TrueSize then
      begin
        x := RightsPattern2[i, j] + Bound2.Left + ((maxx - minx) div 2) + 5;
        y := i + Bound2.Top + ((maxy - miny) div 2) + 5;
      end
      else
      begin
        x := round((RightsPattern2[i, j] + Bound2.Left - minx) / Ratio) + 100;
        y := round((i + Bound2.Top - miny) / Ratio) + 100;
      end;

      x := x * Zoom;
      y := y * Zoom;

      Bitmap.Canvas.MoveTo(x, y);
      Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    end;
  end;

  imgDrawInterlock.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

procedure TfmDebugger.DrawDescribedPattern(Pattern: TPointArray;
                                           LeftsPattern, RightsPattern: TSideEdges);
var
  minx, miny, maxx, maxy: integer;
  Ratio: real;
  i, j: integer;
  x, y: integer;
  Picture: array of TPoint;
  Bitmap: TBitmap;

begin
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf4Bit;

  minx := 999999;
  miny := 999999;
  maxx := -999999;
  maxy := -999999;
  for i := 0 to Length(Pattern) - 1 do
  begin
    if Pattern[i].X < minx then
      minx := Pattern[i].x;
    if Pattern[i].Y < miny then
      miny := Pattern[i].y;
    if Pattern[i].X > maxx then
      maxx := Pattern[i].x;
    if Pattern[i].Y > maxy then
      maxy := Pattern[i].y;
  end;

  if TrueSize then
  begin
    Bitmap.Height := abs(maxy - miny) * (zoom * 2) + 10 + 100;
    Bitmap.Width := abs(maxx - minx) * (zoom * 2) + 10 + 100;
  end
  else
  begin
    Bitmap.Height := 1000 * Zoom;
    Bitmap.Width := Bitmap.Height;
    Ratio := max(((maxx - minx) / 800), ((maxy - miny) / 800));
  end;

  Bitmap.Canvas.pen.color := clGreen;
  Bitmap.Canvas.Font.Color := clBlack;
  Bitmap.Canvas.brush.color := clGreen;
  Bitmap.Canvas.brush.Style := bsClear;

  setLength(Picture, Length(Pattern) + 1);
  for i := 0 to Length(Pattern) - 1 do
  begin
    //Drawing Positions
    if TrueSize then
    begin
      x := Pattern[i].x + ((maxx - minx) div 2) + 5;
      y := Pattern[i].y + ((maxy - miny) div 2) + 5;
    end
    else
    begin
      x := round((Pattern[i].x - minx) / Ratio) + 100;
      y := round((Pattern[i].y - miny) / Ratio) + 100;
    end;

    x := x * Zoom;
    y := y * Zoom;

    Picture[i].x := x;
    Picture[i].y := y;

    Bitmap.Canvas.MoveTo(x, y);
    Bitmap.Canvas.TextOut(x, y, inttostr(i));
  end;

  //Close JUST for Drawing
  Picture[Length(Picture) - 1] := Picture[0];
  Bitmap.Canvas.Polyline(Picture);

  Bitmap.Canvas.pen.color := clLime;
  Bitmap.Canvas.brush.color := clLime;
  Bitmap.Canvas.brush.Style := bsSolid;

  for i := 0 to Length(LeftsPattern) - 1 do
  begin
    Bitmap.Canvas.pen.color := clLime;
    Bitmap.Canvas.brush.color := clLime;
    Bitmap.Canvas.brush.Style := bsSolid;

    for j := 1 to LeftsPattern[i, 0] do
    begin
      if TrueSize then
      begin
        x := LeftsPattern[i, j] + ((maxx - minx) div 2) + 5;
        y := i + ((maxy - miny) div 2) + 5;
      end
      else
      begin
        x := round((LeftsPattern[i, j] - minx) / Ratio) + 100;
        y := round((i - miny) / Ratio) + 100;
      end;

      x := x * Zoom;
      y := y * Zoom;

      Bitmap.Canvas.MoveTo(x, y);
      Bitmap.Canvas.Ellipse(x - 4, y - 4, x + 4, y + 4);
    end;
  end;

  Bitmap.Canvas.pen.color := clRed;
  Bitmap.Canvas.brush.color := clRed;
  Bitmap.Canvas.brush.Style := bsSolid;

  for i := 0 to Length(RightsPattern) - 1 do
  begin
    Bitmap.Canvas.pen.color := clRED;
    Bitmap.Canvas.brush.color := clRED;
    Bitmap.Canvas.brush.Style := bsSolid;

    for j := 1 to RightsPattern[i, 0] do
    begin
      if TrueSize then
      begin
      x := RightsPattern[i, j] + ((maxx - minx) div 2) + 5;
      y := i + ((maxy - miny) div 2) + 5;
      end
      else
      begin
        x := round((RightsPattern[i, j] - minx) / Ratio) + 100;
        y := round((i - miny) / Ratio) + 100;
      end;

      x := x * Zoom;
      y := y * Zoom;

      Bitmap.Canvas.MoveTo(x, y);
      Bitmap.Canvas.Ellipse(x - 2, y - 2, x + 2, y + 2);
    end;
  end;

  imgDescribePattern.Picture.Bitmap := Bitmap;

  Bitmap.Free;
end;

end.
