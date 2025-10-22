unit PatternDrawing;

interface

uses
  SysUtils, Classes, Types, Graphics, DB, ExtCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,
  General_Interlocking, CmnVars, SummsVars, Forms, FDConnectionPlus;

type
  TdmPatternDrawing = class(TDataModule)
    qPatterns: TFDQueryPlus;
    qPatternsKnife: TStringField;
    qPatternsSeq: TSmallintField;
    qPatternsX: TSmallintField;
    qPatternsY: TSmallintField;
    qPatternsSizeScale: TStringField;
    qPatternsMeasuredSize: TStringField;
    qPattInts: TFDQueryPlus;
    qPattIntsKnife: TStringField;
    qPattIntsInterlockNo: TSmallintField;
    qPattIntsTrxx: TSmallintField;
    qPattIntsTryy: TSmallintField;
    qPattIntsRev: TBooleanField;
    qPattIntsW2: TBooleanField;
    procedure DisplayPattern(Code, Scale, Size: String;
                             clBackground, clPattern: integer;
                             imgPattern: TImage;
                             var KnifeIn: TPointArray;
                             RotationAngle: Real);
    procedure DrawVersion6Interlock(Code, Scale, Size: String;
                                    clBackground, clPattern: integer;
                                    ImgInterlock: TImage;
                                    Knife: TPointArray);
    procedure Pass(Connection: TFDConnectionPlus);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmPatternDrawing: TdmPatternDrawing;

implementation

{$R *.dfm}

procedure TdmPatternDrawing.DisplayPattern(Code, Scale, Size: String;
                                           clBackground, clPattern: integer;
                                           imgPattern: TImage;
                                           var KnifeIn: TPointArray;
                                           RotationAngle: Real);
var
  minx, miny, maxx, maxy, midx, midy, transx, transy: integer;
  i, j, k: integer;
  factor: real;
  Picture: TPointArray;

begin
  qPatterns.ParamByName('KnifeCode').AsString := Code;
  qPatterns.ParamByName('KnifeSizeScale').AsString := Scale;
  qPatterns.ParamByName('MeasuredSize').AsString := Size;
  qPatterns.open;

  imgPattern.Canvas.Brush.Color := clBackground;
  imgPattern.Canvas.FillRect(Rect(0, 0, imgPattern.Picture.Bitmap.Width, imgPattern.Picture.Bitmap.Height));

  SetLength(KnifeIn, 0);

  //Read Pattern
  qPatterns.RecNo := 1; //CJY changed from qPatterns.First
  qPatterns.Prior; //CJY changed from qPatterns.First
  while not qPatterns.eof do
  begin
    SetLength(KnifeIn, Length(KnifeIn) + 1);
    KnifeIn[Length(KnifeIn) - 1].X := qPatternsX.Value;
    KnifeIn[Length(KnifeIn) - 1].Y := qPatternsY.Value;
    qPatterns.Next;
  end;

  //Add last point
  SetLength(KnifeIn, Length(KnifeIn) + 1);
  KnifeIn[Length(KnifeIn) - 1].X := KnifeIn[0].X;
  KnifeIn[Length(KnifeIn) - 1].Y := KnifeIn[0].Y;

  if RotationAngle <> 0 then
    RotatePattern(RotationAngle, KnifeIn);

  //Centre original knife
  maxx := -999999;
  maxy := -999999;
  minx := 999999;
  miny := 999999;

  for i := 0 to Length(KnifeIn) - 1 do
  begin
    if KnifeIn[i].X < minx then minx := round(KnifeIn[i].X);
    if KnifeIn[i].Y < miny then miny := round(KnifeIn[i].Y);
    if KnifeIn[i].X > maxx then maxx := round(KnifeIn[i].X);
    if KnifeIn[i].Y > maxy then maxy := round(KnifeIn[i].Y);
  end;

  for i := 0 to Length(KnifeIn) - 1 do
  begin
    KnifeIn[i].X := KnifeIn[i].X - round(minx + ((maxx - minx) / 2));
    KnifeIn[i].Y := KnifeIn[i].Y - round(miny + ((maxy - miny) / 2));
  end;

  if (maxx - minx) = 0 then
    factor := 1  //No points for this knife
  else if (imgPattern.width / (maxx - minx)) < (imgPattern.height / (maxy - miny)) then
    factor := imgPattern.width / (maxx - minx)
  else
    factor := imgPattern.height / (maxy - miny);

  factor := factor * 0.8; // border;
  midx := minx + round((maxx - minx) / 2);
  midy := miny + round((maxy - miny) / 2);
  transx := round(imgPattern.width / 2);
  transy := round(imgPattern.height / 2);

  SetLength(Picture, Length(KnifeIn));
  //Draw Knife
  for i := 0 to Length(Picture) - 1 do
  begin
    Picture[i].x := round((KnifeIn[i].X - midx) * factor) + transx;
    Picture[i].y := imgPattern.height - (round((KnifeIn[i].Y - midy) * factor) + transy);
  end;
  imgPattern.Canvas.pen.Color := clPattern;
  imgPattern.Canvas.brush.color := clPattern;
  imgPattern.Canvas.Polygon(Picture);

  qPatterns.close;
end;

procedure TdmPatternDrawing.DrawVersion6Interlock(Code, Scale, Size: String;
                                                  clBackground, clPattern: integer;
                                                  ImgInterlock: TImage;
                                                  Knife: TPointArray);
var
  i, j, k, Int, NoPoints, minx, miny, maxx, maxy, midx, midy, transx, transy: integer;
  Ints: array[0..8] of TPointArray;
  IndInt: TPointArray;
  Picture: TPointArray;
  Assessed, Ghost: boolean;
  Ghosts: array[0..8] of boolean;
  factor: real;

begin
  qPattInts.ParamByName('KnifeCode').AsString := Code;
  qPattInts.ParamByName('KnifeSizeScale').AsString := Scale;
  qPattInts.ParamByName('MeasuredSize').AsString := Size;
  qPattInts.open;
  //CJY: qPattInts.FetchOptions.RecordCountMode set to cmTotal
  Assessed := (qPattInts.RecordCount > 0);

  if Assessed then
  begin
    NoPoints := Length(Knife) - 1;
    //Copy original knife
    SetLength(Ints[0], Length(Knife));
    for i := 0 to NoPoints do
      Ints[0, i] := Knife[i];
    Ghosts[0] := false;

    //For each interlock...
    Int := 0;
    qPattInts.RecNo := 1; //CJY changed from qPattInts.First
    qPattInts.Prior; //CJY changed from qPattInts.First

    //CJY:Begin removing dependence on RecordCount
    //CJY Would require qPattInts.FetchOptions.RecordCountMode set to cmTotal
    //for i := 1 to qPattInts.recordCount do
    while not qPattInts.eof do
    begin
      inc(Int);
      Ghosts[Int] := false;

      SetLength(IndInt, Length(Knife));
      //Copy original knife
      for j := 0 to NoPoints do
        IndInt[j] := Knife[j];

      if qPattIntsW2.value = true then
      begin
        Ghost := false;
        RotatePattern(180, IndInt);
      end
      else
        Ghost := true;

      SetLength(Ints[Int], Length(Knife));
      Ints[Int] := IndInt;

      if qPattIntsRev.value = true then
      begin
        transx := qPattIntsTrxx.value;
        transy := qPattIntsTryy.value;
      end
      else
      begin
        transx := -qPattIntsTrxx.value;
        transy := -qPattIntsTryy.value;
      end;

      for j := 0 to NoPoints do
      begin
        Ints[Int, j].x := Ints[Int, j].x + transx;
        Ints[Int, j].y := Ints[Int, j].y + transy;
      end;

      if Ghost then
      begin
        //Make Ghost
        inc(Int);
        Ghosts[Int] := true;

        SetLength(Ints[Int], Length(Knife));
        for j := 0 to NoPoints do
          Ints[Int, j] := Knife[j];

        //Do opposite translation as well
        transx := -transx;
        transy := -transy;

        for j := 0 to NoPoints do
        begin
          Ints[Int, j].x := Ints[Int, j].x + transx;
          Ints[Int, j].y := Ints[Int, j].y + transy;
        end;
      end;

      //Recentre patterns so far
      maxx := -999999;
      maxy := -999999;
      minx := 999999;
      miny := 999999;

      for j := 0 to Int do
      begin
        for k := 0 to NoPoints do
        begin
          if Ints[j, k].x < minx then minx := round(Ints[j, k].x);
          if Ints[j, k].y < miny then miny := round(Ints[j, k].y);
          if Ints[j, k].x > maxx then maxx := round(Ints[j, k].x);
          if Ints[j, k].y > maxy then maxy := round(Ints[j, k].y);
        end;
      end;

      for j := 0 to Int do
        for k := 0 to NoPoints do
        begin
          Ints[j, k].x := Ints[j, k].x - round(minx + ((maxx - minx) / 2));
          Ints[j, k].y := Ints[j, k].y - round(miny + ((maxy - miny) / 2));
        end;

      qPattInts.Next;
    end;

    //Centre Interlock picture
    maxx := -999999;
    maxy := -999999;
    minx := 999999;
    miny := 999999;

    for i := 0 to Int do
    begin
      for j := 0 to NoPoints do
      begin
        if Ints[i, j].x < minx then minx := round(Ints[i,j].x);
        if Ints[i, j].y < miny then miny := round(Ints[i,j].y);
        if Ints[i, j].x > maxx then maxx := round(Ints[i,j].x);
        if Ints[i, j].y > maxy then maxy := round(Ints[i,j].y);
      end;
    end;

    if (imgInterlock.width / (maxx - minx)) < (imgInterlock.height / (maxy - miny)) then
      factor := imgInterlock.width / (maxx - minx)
    else
      factor := imgInterlock.height / (maxy - miny);

    factor := factor * 0.8; // border;
    midx := minx + round((maxx - minx) / 2);
    midy := miny + round((maxy - miny) / 2);
    transx := round(imgInterlock.width / 2);
    transy := round(imgInterlock.height / 2);

    //Draw Interlocks including original
    if Int > 0 then
    begin
      imgInterlock.Canvas.pen.Color := clPattern;
      imgInterlock.Canvas.brush.color := clPattern;
      for i := 0 to Int do
      begin
        SetLength(Picture, Length(Knife));
        for j := 0 to NoPoints do
        begin
          Picture[j].x := round((Ints[i, j].x - midx) * factor) + transx;
          Picture[j].y := imgInterlock.height - (round((Ints[i, j].y - midy) * factor) + transy);
        end;

        if i = 0 then
          imgInterlock.Canvas.Polygon(Picture)
        else
        begin
          if Ghosts[i] = false then
          begin
            imgInterlock.Canvas.pen.Color := clInterlock;
            imgInterlock.Canvas.brush.Color := clInterlock;
          end
          else
          begin
            imgInterlock.Canvas.pen.Color := clGhost;
            imgInterlock.Canvas.brush.Color := clGhost;
          end;

          imgInterlock.Canvas.Polygon(Picture);
        end;
      end;
    end;
  end;

  qPattInts.close;
end;

procedure TdmPatternDrawing.Pass(Connection: TFDConnectionPlus);
begin
  qPatterns.Connection := Connection;
  qPattInts.Connection := Connection;
end;

end.
