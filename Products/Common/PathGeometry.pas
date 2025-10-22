unit PathGeometry;

//Unit is basically a pascal rewrite of Tom Bayes' CSPLINE.CPP

interface

uses
  SysUtils, PathGlobals, CmnVars;

function distance(x1, y1, x2, y2: single): double;
function AnalyseLine(SplineType: TSplineType): single;
function AnalyseCurve(SplineType: TSplineType): single;
function Analyse2Points(SplineType: TSplineType; start, stop: integer; ProcessLastPoint: boolean): single;
procedure cspline;
function GetRadius(xx0, xx1, yy0, yy1, zz0, zz1: single): double;
function adotb(a1, a2, b1, b2: single): single;
function intsect(a1, a2, b1, b2, c1, c2, d1, d2: single; var uu, vv: single): boolean;
procedure matrixr(xo, yo, ang: single);
procedure matmultir(var x1, y1: single);
function FileName(FileRef, extension: string): string;
function CalculateArea: single;

implementation

uses
  Math, Graphics, TypInfo;

var
  DigFileXY: TextFile;
  DigFilePTH: TextFile;

  knot, tng, dc, vc: array[0..2, 0..MaxRawPoints] of single;
  rc, hc, mc: array[0..MaxRawPoints] of single;
  ktpt: array[0..MaxRawPoints] of integer;
  qc, c1, c2, q1c: single;
  nc, extrabeg, extraend, pinc, fc, smooth, count: integer;
  ave: double;
  matrix: array[1..3, 1..3] of double;
  uc: double;

function distance(x1, y1, x2, y2: single): double;
var
  xm, ym : double;

begin
  xm := (x1 - x2);
  ym := (y1 - y2);
  distance := sqrt((xm * xm) + (ym * ym));
end;

function AnalyseLine(SplineType: TSplineType): single;
// if bClosed then the entity to be splined is joined and the algorithm
// will allow for this by smoothing over the join and forcing tangents to
// coincide. The shape may be closed but the join point may be a corner
// denoted by the last point being a corner.
// NOTE: need to treat loose ends in a better way??????

type ent = record
             start, stop, bclosed: integer;
           end;

var
  theta, theta1: double;
  TotalLineLength, uu, vv: single;
  ii, jj, kk, dd, sign: integer;
  a, b, c, d, r, first, second: array [0..2] of single;
  noofent: integer;
  entity: array[0..MaxRawPoints] of ent;
  ProcessLastPoint: boolean;

begin
  NoSmoothPts := 0;
  TotalLineLength := 0;

  // initialise entity structures.
  for ii := 0 to NoRawPts do
  begin
    // initialise as 0
    entity[ii].start := 0;
    entity[ii].stop := 0;
    entity[ii].bclosed := 0;
  end;

  // before sorting out entitys, reorder points array
  // this is done because it is the simplest way of ensuring that
  // joins that are continuous stay that way
  // the first point in the array will always be a new path or a corner

  if NoRawPts > 1 then
  begin
    jj := 1;
    entity[jj].start := 1;
    for ii := 2 to NoRawPts do
    begin
      if ((( ((RawPts[ii].c = Corner) or (RawPts[ii+1].c = NewPath)) or (ii = NoRawPts)) and
        (entity[jj].start > 0)) and (entity[jj].start <> ii)) then
      begin
        entity[jj].stop := ii;
        if (ii <> NoRawPts) then
        begin
          inc(jj);
          if (RawPts[ii].c = Corner) then
            entity[jj].start := ii;
          if (RawPts[ii + 1].c = NewPath) then
            entity[jj].start := ii + 1;
        end;
      end;
      if ((entity[jj].start <> ii) and ((RawPts[ii + 1].c = NewPath) and (RawPts[ii].c = NewPath))) then
        entity[jj].stop := ii;       //BUG IN TOMS HERE ?
    end;

    entity[jj].stop := NoRawPts;
    noofent := jj;
  end
  else
    noofent := 0;

  if SplineType = SaveOutputFiles then
  begin
    assignfile(DigFileXY, FileName(FileRef, 'xy'));
    rewrite(DigFileXY);

    assignfile(DigFilePTH, FileName(FileRef, 'pth'));
    rewrite(DigFilePTH);
  end;

  // add bclosed to record
  // bclosed indicates wether the entity is closed
  // if several entities form a closed pattern then the joint
  // needs to have the potential to be smoothed

  for kk := 1 to noofent do
  begin
    if ((RawPts[entity[kk].start].x = RawPts[entity[kk].stop].x) and
      (RawPts[entity[kk].start].y = RawPts[entity[kk].stop].y)) then
    entity[kk].bclosed := -1;   // closed with itself
  end;

  //  smooth each start stop
  for kk := 1 to noofent do
  begin
    if ((entity[kk].stop - entity[kk].start) > 1) then
    begin
      if (entity[kk].start <> entity[kk].stop) then
      begin
        for ii := 0 to NoRawPts do
          ktpt[ii] := 0;

        dd := 0;
        extrabeg := 0;
        extraend := 0;
        if ((RawPts[entity[kk].stop].c <> Corner) and (entity[kk].bclosed < 0)) then
         //add begining
        begin
          knot[0, dd] := RawPts[entity[kk].stop - 2].x;
          knot[1, dd] := RawPts[entity[kk].stop - 2].y;
          knot[2, dd] := 1;
          inc(extrabeg);
          inc(dd);
          knot[0, dd] := RawPts[entity[kk].stop - 1].x;
          knot[1, dd] := RawPts[entity[kk].stop - 1].y;
          knot[2, dd] := 1;
          inc(extrabeg);
          inc(dd);
        end;

        if ((extrabeg = 0) and ((entity[kk].stop - entity[kk].start) > 1)) then
        begin
          // all done in inches to avoid v larg nos
          a[0] := (RawPts[entity[kk].start + 1].x - RawPts[entity[kk].start].x) / 1000.0;
          a[1] := (RawPts[entity[kk].start + 1].y - RawPts[entity[kk].start].y) / 1000.0;
          c[0] := (RawPts[entity[kk].start + 2].x - RawPts[entity[kk].start + 1].x) / 1000.0;
          c[1] := (RawPts[entity[kk].start + 2].y - RawPts[entity[kk].start + 1].y) / 1000.0;

          //rot 90
          b[0] := -(a[1] * 0.5);
          b[1] := a[0] * 0.5;
          d[0] := -(c[1] * 0.5);
          d[1] := c[0] * 0.5;

          a[0] := (RawPts[entity[kk].start].x / 1000.0) + (a[0] * 0.5);
          a[1] := (RawPts[entity[kk].start].y / 1000.0) + (a[1] * 0.5);
          c[0] := (RawPts[entity[kk].start + 1].x / 1000.0) + (c[0] * 0.5);
          c[1] := (RawPts[entity[kk].start + 1].y / 1000.0) + (c[1] * 0.5);

          intsect(a[0], a[1], b[0], b[1], c[0], c[1], d[0], d[1], uu, vv);

          first[0] := RawPts[entity[kk].start].x / 1000.0;
          first[1] := RawPts[entity[kk].start].y / 1000.0;
          second[0] := RawPts[entity[kk].start + 1].x / 1000.0;
          second[1] := RawPts[entity[kk].start + 1].y / 1000.0;

          theta := arccos(adotb(b[0], b[1], d[0], d[1]));
          theta1 := ((vv*d[0])*(vv*d[0])) + ((vv*d[1])*(vv*d[1]));
          theta1 := sqrt(theta1);

          if ((theta > ((5 / 180.0) * PI)) and (theta1 < 6)) then
          begin
            r[0] := (c[0] + (d[0] * vv));
            r[1] := (c[1] + (d[1] * vv));

            // measure angle between first point and second point

            // first now point
            first[0] := RawPts[entity[kk].start].x / 1000.0;
            first[1] := RawPts[entity[kk].start].y / 1000.0;
            second[0] := RawPts[entity[kk].start + 1].x / 1000.0;
            second[1] := RawPts[entity[kk].start + 1].y / 1000.0;
            theta := arccos(adotb((first[0] - r[0]), (first[1] - r[1]), (second[0] - r[0]), (second[1] - r[1])));

            // see if the angle used to generate new point is +ve or -ve
            // rotate first vector point by theta
            matrixr(r[0], r[1], theta);
            matmultir(first[0], first[1]);
            theta := arccos(adotb((first[0] - r[0]), (first[1] - r[1]), (second[0] - r[0]), (second[1] - r[1])));

            sign := 1;
            if (theta < (0.5 / 180.0) * PI) then
              sign := -1;

            // reset first
            first[0] := RawPts[entity[kk].start].x / 1000.0;
            first[1] := RawPts[entity[kk].start].y / 1000.0;

            //rotate 5 and 10 degrees to generate new points
            // -5
            theta := 0.087266462;
            matrixr(r[0], r[1], (theta * sign));
            matmultir(first[0], first[1]);
            knot[0, 1] := first[0] * 1000;
            knot[1, 1] := first[1] * 1000;
            knot[2, 1] := 1;
            inc(extrabeg);
            inc(dd);
            // -10
            matmultir(first[0], first[1]);
            knot[0, 0] := first[0] * 1000;
            knot[1, 0] := first[1] * 1000;
            knot[2, 0] := 1;
            inc(extrabeg);
            inc(dd);
          end;
        end;

        // rest of points
        for ii := entity[kk].start to entity[kk].stop do
        begin
          knot[0, dd] := RawPts[ii].x;
          knot[1, dd] := RawPts[ii].y;
          knot[2, dd] := 1;
          // keep track of knots to points
          ktpt[dd] := ii;
          inc(dd);
        end;

        if ((RawPts[entity[kk].stop].c <> Corner) and (entity[kk].bclosed < 0)) then
        //add end
        begin
          knot[0, dd] := RawPts[entity[kk].start + 1].x;
          knot[1, dd] := RawPts[entity[kk].start + 1].y;
          knot[2, dd] := 1;
          inc(extraend);
          inc(dd);

          knot[0, dd] := RawPts[entity[kk].start + 2].x;
          knot[1, dd] := RawPts[entity[kk].start + 2].y;
          knot[2, dd] := 1;
          inc(extraend);
          inc(dd);
        end;

        // if its open then add 2 points at the end which form a circle
        // this cleans up the end of the cspline

        // these need to be changed to be at general ends of entities
        if ((extraend = 0) and ((entity[kk].stop - entity[kk].start) > 1)) then
        begin
          a[0] := (RawPts[entity[kk].stop - 1].x - RawPts[entity[kk].stop].x) / 1000.0;
          a[1] := (RawPts[entity[kk].stop - 1].y - RawPts[entity[kk].stop].y) / 1000.0;
          c[0] := (RawPts[entity[kk].stop - 2].x - RawPts[entity[kk].stop - 1].x) / 1000.0;
          c[1] := (RawPts[entity[kk].stop - 2].y - RawPts[entity[kk].stop - 1].y) / 1000.0;

          //rot 90
          b[0] := -(a[1] * 0.5);
          b[1] := a[0] * 0.5;
          d[0] := -(c[1] * 0.5);
          d[1] := c[0] * 0.5;

          a[0] := (RawPts[entity[kk].stop].x / 1000.0) + (a[0] * 0.5);
          a[1] := (RawPts[entity[kk].stop].y / 1000.0) + (a[1] * 0.5);
          c[0] := (RawPts[entity[kk].stop - 1].x / 1000.0) + (c[0] * 0.5);
          c[1] := (RawPts[entity[kk].stop - 1].y / 1000.0) + (c[1] * 0.5);

          intsect(a[0], a[1], b[0], b[1], c[0], c[1], d[0], d[1], uu, vv);

          theta := arccos(adotb(b[0], b[1], d[0], d[1]));
          theta1 := ((vv * d[0]) * (vv * d[0])) + ((vv*d[1]) * (vv * d[1]));
          theta1 := sqrt(theta1);

          // if angle is greater than 3 degs and radius is less than 12 inches
          if ((theta > ((5 / 180.0) * PI)) and (theta1 < 6)) then
          begin
            r[0] := c[0] + (d[0] * vv);
            r[1] := c[1] + (d[1] * vv);

            // measure angle between first point and second point

            // first now point
            first[0] := RawPts[entity[kk].stop].x / 1000.0;
            first[1] := RawPts[entity[kk].stop].y / 1000.0;
            second[0] := RawPts[entity[kk].stop - 1].x / 1000.0;
            second[1] := RawPts[entity[kk].stop - 1].y / 1000.0;
            theta := arccos(adotb((first[0] - r[0]), (first[1] - r[1]),
                                  (second[0] - r[0]), (second[1] - r[1])));

            // see if the angle used to generate new point is +ve or -ve
            // rotate first vector point by theta
            matrixr(r[0], r[1], theta);
            matmultir(first[0], first[1]);
            theta := arccos(adotb((first[0] - r[0]), (first[1] - r[1]), (second[0] - r[0]), (second[1] - r[1])));

            sign := 1;
            if (theta < (0.5 / 180.0) * PI) then
              sign := -1;

            // reset first
            first[0] := RawPts[entity[kk].stop].x / 1000.0;
            first[1] := RawPts[entity[kk].stop].y / 1000.0;

            //rotate 5 and 10 degrees to generate new points
            // -5
            theta := 0.087266462;
            matrixr(r[0], r[1], (theta * sign));
            matmultir(first[0], first[1]);
            knot[0, dd] := first[0] * 1000;
            knot[1, dd] := first[1] * 1000;
            knot[2, dd] := 1;
            inc(extraend);
            inc(dd);

            // -10
            matmultir(first[0], first[1]);
            knot[0, dd] := first[0] * 1000;
            knot[1, dd] := first[1] * 1000;
            knot[2, dd] := 1;
            inc(extraend);
            inc(dd);
          end;
        end;

        nc := dd - 1;

        smooth := 10;
        cspline;

        count := 0;
        if (extraend > 0) then
        begin
          nc := nc - extraend;
          count := 0;
        end;
        if (extrabeg > 0) then
          count := extrabeg;

        TotalLineLength := TotalLineLength + AnalyseCurve(SplineType);
      end;
    end
    else
    begin
      if ((kk + 1 <= noofent) and (entity[kk].stop = entity[kk + 1].start)) then
        // prevent end feature from being processed
        ProcessLastPoint := false
      else
        ProcessLastPoint := true;
      TotalLineLength := TotalLineLength + Analyse2Points(SplineType, entity[kk].start, entity[kk].stop, ProcessLastPoint);
    end;
  end;

  if SplineType = SaveOutputFiles then
  begin
    writeln(DigFilePTH, 'end');
    closefile(DigFileXY);
    closefile(DigFilePTH);
  end;

  AnalyseLine := TotalLineLength;
end;

function AnalyseCurve(SplineType: TSplineType): single;
var
  LineLength: single;
  Knotlength, SegmentLength, onemmtot, ax, bx: double;
  lc, icou, kc, jcou, onemmcnt, i: integer;
  qq, xx, yy, zz, prev1, prev2: array [0..2] of single;
  cc, crvcnt, prevcrv, prx, pry: single;
  newtype, crvtype, onemm: integer;
  firsttime: boolean;
  s1, s2, s: string;
  j: integer;
  ss: string;
  CurrentPathType, CurrentPathType2: string;
  IsRawPointWithFeature, IsRawPointWithPathTypeChange: Boolean;
  RawPointA, RawpointB: TPathPoint;
  PathTypeA, PathTypeB: string;
  SameRawPoint: Boolean;

begin
  newtype := 0;
  crvtype := 0;
  LineLength := 0;

  // x Points smoothing
  prev1[0] := knot[0, count];
  prev1[1] := knot[1, count];
  prev1[2] := knot[2, count];

  // 1mm per point smoothing
  prev2[0] := knot[0, count];
  prev2[1] := knot[1, count];
  prev2[2] := knot[2, count];

  prx := knot[0, count];
  pry := knot[1, count];

  ave := 0.0;
  onemm := 0;
  crvcnt := 0.0;
  prevcrv := 0.0;
  onemmcnt := 0;
  firsttime := true;

  if SplineType = SaveOutputFiles then
  begin
    if RawPts[ktpt[count]].c = NewPath then
    begin
      if ktpt[count] = 1 then
        s := 'first_path'
      else
        s := 'next_path';
      writeln(DigFileXY, s);
      writeln(DigFilePTH, s);
    end;

    //Removed because can not see why this should be so
    //if RawPts[ktpt[count]].c = Corner then
    //  writeln(DigFileXY, 'new_path');

    writeln(DigFileXY, 'p');
    str(trunc(knot[0, count]), s);
    writeln(DigFileXY, s);
    str(trunc(knot[1, count]), s);
    writeln(DigFileXY, s);

    for j := 1 to 6 do
    begin
      if RawPts[ktpt[count]].Feature[j].Code <> 'no_feature' then
        writeln(DigFileXY, 'feature ' + RawPts[ktpt[count]].Feature[j].Code);
    end;

    CurrentPathType := GetEnumName(TypeInfo(TPath), ord(RawPts[ktpt[count]].PathType));
    writeln(DigFileXY, CurrentPathType);
  end;

  inc(NoSmoothPts);
  SmoothPts[NoSmoothPts].x := trunc(knot[0, count]);
  SmoothPts[NoSmoothPts].y := trunc(knot[1, count]);
  SmoothPts[NoSmoothPts].c := NewPath;
  SmoothPts[NoSmoothPts].PathType := RawPts[ktpt[count]].PathType;

  //Initialise
  RawPointB.x := -1000;
  PathTypeB := GetEnumName(TypeInfo(TPath), ord(RawPts[1].PathType));

  for icou := count to (nc - 1) do
  begin
    Knotlength := 0.0;
    smooth := SmoothPointsPerPoint;

    cc := smooth;
    for kc := 1 to smooth do
    begin
      uc := (kc / cc);
      for lc := 0 to 1 do
      begin
        yy[lc] := knot[lc, icou] + (uc * (hc[icou] * tng[lc, icou] + uc * (3 *
                  dc[lc, (icou + 1)] - 2 * hc[icou] * tng[lc, icou] -
                  mc[(icou + 1)] * tng[lc, (icou + 1)] + uc * (hc[icou] *
                  tng[lc, icou] + mc[(icou + 1)] * tng[lc, (icou + 1)] - 2 *
                  dc[lc, (icou + 1)]))));
      end;

      inc(NoSmoothPts);
      SmoothPts[NoSmoothPts].x := trunc(yy[0]);
      SmoothPts[NoSmoothPts].y := trunc(yy[1]);
      SmoothPts[NoSmoothPts].c := Normal;
      SmoothPts[NoSmoothPts - 1].PathType := RawPts[ktpt[icou + 0]].PathType;
//NEATEN!!!!                ^^^^                               ^^^^^^   changed line
      if SplineType = SaveOutputFiles then
      begin
        if ((((distance(yy[0], yy[1], prx, pry) / 1000.0) * 25.4) > 3) or (kc = cc)) then
        begin
          writeln(DigFileXY, 'p');
          str(trunc(yy[0]), s);
          writeln(DigFileXY, s);
          str(trunc(yy[1]), s);
          writeln(DigFileXY, s);

          prx := yy[0];
          pry := yy[1];

          for j := 1 to 6 do
          begin
            if ((RawPts[ktpt[icou + 1]].Feature[j].Code <> 'no_feature') and (kc = smooth))then
              writeln(DigFileXY, 'feature ' + RawPts[ktpt[icou + 1]].Feature[j].Code);
          end;

          if kc = smooth then
            CurrentPathType := GetEnumName(TypeInfo(TPath), ord(RawPts[ktpt[icou + 1]].PathType))
          else
            CurrentPathType := GetEnumName(TypeInfo(TPath), ord(RawPts[ktpt[icou]].PathType));

          writeln(DigFileXY, CurrentPathType);
        end;
      end;

      Knotlength := Knotlength + (((distance(yy[0], yy[1], prev1[0], prev1[1])) / 1000.0) * 25.4);
      prev1[0] := yy[0];
      prev1[1] := yy[1];
    end;

    //Now work out points again - this time every 1mm
    smooth := trunc(Knotlength);
    if (smooth < 4) then
      smooth := 4;

    Knotlength := 0.0;
    cc := smooth;

    // calculate the first two
    for lc := 0 to 1 do
      yy[lc] := knot[lc, icou];

    kc := 1;
    uc := (kc / cc);
    for lc := 0 to 1 do
    begin
      zz[lc] := knot[lc, icou] + (uc * (hc[icou] * tng[lc, icou] + uc *
                (3 * dc[lc, (icou + 1)] - 2 * hc[icou] * tng[lc, icou] -
                mc[(icou + 1)] * tng[lc, (icou + 1)] + uc * (hc[icou] *
                tng[lc, icou] + mc[(icou + 1)] * tng[lc, (icou + 1)] - 2 *
                dc[lc, (icou + 1)]))));
    end;

    // now for rest
    for kc := 2 to (smooth + 1) do
    begin
      if (kc <= smooth) then // cheap fix
      begin
        xx[0] := yy[0];
        xx[1] := yy[1];
        yy[0] := zz[0];
        yy[1] := zz[1];
      end
      else
      begin
        // oldx
        qq[0] := xx[0];
        qq[1] := xx[1];
        xx[0] := yy[0];
        xx[1] := yy[1];
        yy[0] := zz[0];
        yy[1] := zz[1];
        zz[0] := qq[0];
        zz[1] := qq[1];
      end;

      uc := (kc / cc);
      if (kc <= smooth) then // cheap fix
      begin
        for lc := 0 to 1 do
        begin
          zz[lc] := knot[lc, icou] + (uc * (hc[icou] * tng[lc, icou] +
                     uc * (3 * dc[lc, (icou + 1)] - 2 * hc[icou] *
                     tng[lc, icou] - mc[(icou + 1)] * tng[lc, (icou + 1)] +
                     uc * (hc[icou] * tng[lc, icou] + mc[(icou + 1)] *
                     tng[lc, (icou + 1)] - 2 * dc[lc, (icou + 1)]))));
        end;
      end;

      SegmentLength := (((distance(yy[0], yy[1], prev2[0], prev2[1])) / 1000.0) * 25.4);
      LineLength := LineLength + SegmentLength;
      Knotlength := Knotlength + SegmentLength;
      crvcnt := crvcnt + SegmentLength;
      prev2[0] := yy[0];
      prev2[1] := yy[1];

      if SplineType = SaveOutputFiles then
      begin
        // average over each mm

        if (kc <= smooth) then // cheap fix
          ave := ave + GetRadius(xx[0], xx[1], yy[0], yy[1], zz[0], zz[1])
        else
          ave := ave + GetRadius(zz[0], zz[1], xx[0], xx[1], yy[0], yy[1]);

        inc(onemmcnt);


        //          IsRawPointWithFeature := (kc = 2) and (RawPts[ktpt[icou]].Feature[1].Code <> 'no_feature');

        RawPointA := RawPointB;
        RawPointB := RawPts[ktpt[icou]];
        SameRawPoint := ((RawPointA.x = RawPointB.x) and (RawPointA.y = RawPointB.y));
        IsRawPointWithFeature := (not SameRawpoint) and (RawPts[ktpt[icou]].Feature[1].Code <> 'no_feature');

        PathTypeA := PathTypeB;         //needs initialising
        PathTypeB := GetEnumName(TypeInfo(TPath), ord(RawPts[ktpt[icou]].PathType));
        IsRawPointWithPathTypeChange := (PathTypeA <> PathTypeB);

        //this bit determines the distance of measurement

        if ((((LineLength + 0.5) >= (onemm + 10)) or
//             ((RawPts[ktpt[icou]].Feature[1].Code <> 'no_feature') and (kc = 2))) or
              IsRawPointWithFeature or IsRawPointWithPathTypeChange) or
              (firsttime)) then  // ie 4.5 true
        begin
          if ((LineLength + 0.5) >= (onemm + 10)) then
            onemm := onemm + 10;
          ave := ave / onemmcnt;

          if (ave > 105) then
            ave := 1000.0; //  straight line

          onemmcnt := 0;

          if ((ave > 0) and (ave <= 7.5)) then
            newtype := 5;
          if ((ave > 7.5) and (ave <= 12.5)) then
            newtype := 10;
          if ((ave > 12.5) and (ave <= 17.5)) then
            newtype := 15;
          if ((ave > 17.5) and (ave <= 25)) then
            newtype := 20;
          if ((ave > 25) and (ave <= 35)) then
            newtype := 30;
          if ((ave > 35) and (ave <= 45)) then
            newtype := 40;
          if ((ave > 45) and (ave <= 55)) then
            newtype := 50;
          if ((ave > 55) and (ave <= 65)) then
            newtype := 60;
          if ((ave > 65) and (ave <= 85)) then
            newtype := 80;
          if (ave > 85) then
            newtype := 110;

          if firsttime then
          begin
            crvtype := newtype;
            firsttime := false;
            prevcrv := LineLength;
          end;

          if (crvtype <> newtype) or IsRawPointWithFeature or IsRawPointWithPathTypeChange then
          begin
            if IsRawPointWithFeature or IsRawPointWithPathTypeChange then
            begin
              if SplineType = SaveOutputFiles then
              begin
                if (icou <> count) then
                begin
                  str(crvtype : 4, s1);
                  str((crvcnt - SegmentLength) : 10 : 2, s2);
                  CurrentPathType2 := GetEnumName(TypeInfo(TPath), ord(RawPts[ktpt[icou] - 1].PathType));
                  writeln(DigFilePTH, CurrentPathType2 + ' ', s1, s2);
                end;

                for j := 1 to 6 do
                  if (RawPts[ktpt[icou]].Feature[j].Code <> 'no_feature') then
                    writeln(DigFilePTH, RawPts[ktpt[icou]].Feature[j].Code);
              end;

              crvcnt := Segmentlength;
              firsttime := true;
            end
            else
            begin
              if (crvtype <> newtype) then
              begin
                if SplineType = SaveOutputFiles then
                begin
                  str(crvtype : 4, s1);
                  str(prevcrv : 10 : 2, s2);
                  CurrentPathType2 := GetEnumName(TypeInfo(TPath), ord(RawPts[ktpt[icou]].PathType));
                  writeln(DigFilePTH, CurrentPathType2 + ' ', s1, s2);
                end;
                crvcnt := crvcnt - prevcrv;
                crvtype := newtype;
              end;
            end;
          end;

          prevcrv := crvcnt;
          ave := 0.0;
        end;
      end;
    end;
  end;

  if SplineType = SaveOutputFiles then
  begin
    str(crvtype : 4, s1);
    str(crvcnt : 10 : 2, s2);
    CurrentPathType2 := GetEnumName(TypeInfo(Tpath), ord(RawPts[ktpt[icou] - 1].PathType));
    writeln(DigFilePTH, CurrentPathType2 + ' ', s1, s2);

    if ((RawPts[ktpt[nc]].Feature[1].Code <> 'no_feature') and (not (RawPts[ktpt[nc]].c = Corner))) then
      for j := 1 to 6 do
        if (RawPts[ktpt[nc]].Feature[j].Code <> 'no_feature') then
          writeln(DigFilePTH, RawPts[ktpt[nc]].Feature[j].Code);
  end;

  AnalyseCurve := LineLength;
end;

function Analyse2Points(SplineType: TSplineType; start, stop: integer; ProcessLastPoint: boolean): single;
var
  KnotLength: double;
  s: string;
  j: integer;
  CurrentPathType: string;

begin
  CurrentPathType := GetEnumName(TypeInfo(TPath), ord(RawPts[start].PathType));
  inc(NoSmoothPts);
  SmoothPts[NoSmoothPts].x := RawPts[start].x;
  SmoothPts[NoSmoothPts].y := RawPts[start].y;
  SmoothPts[NoSmoothPts].c := NewPath;
  SmoothPts[NoSmoothPts].PathType := RawPts[start].PathType;
  inc(NoSmoothPts);
  SmoothPts[NoSmoothPts].x := RawPts[stop].x;
  SmoothPts[NoSmoothPts].y := RawPts[stop].y;
  SmoothPts[NoSmoothPts].c := Normal;
  SmoothPts[NoSmoothPts].PathType := RawPts[stop].PathType;

  KnotLength := ((((distance(RawPts[start].x, RawPts[start].y, RawPts[stop].x, RawPts[stop].y))) / 1000) * 25.4);

  if SplineType = SaveOutputFiles then
  begin
    if (RawPts[start].c = NewPath) then
    begin
      if start = 1 then
        s := 'first_path'
      else
        s := 'next_path';
      writeln(DigFileXY, s);
      writeln(DigFilePTH, s);
    end;

    writeln(DigFileXY, 'p');
    str(RawPts[start].x, s);
    writeln(DigFileXY, s);
    str(RawPts[start].y, s);
    writeln(DigFileXY, s);

    for j := 1 to 6 do
    begin
      if (RawPts[start].Feature[j].Code <> 'no_feature') then
        writeln(DigFileXY, 'feature ' + RawPts[start].Feature[j].Code);
    end;
    writeln(DigFileXY, CurrentPathType);

    for j := 1 to 6 do
      if (RawPts[start].Feature[j].Code <> 'no_feature') then
        writeln(DigFilePTH, RawPts[start].Feature[j].Code);

    str(KnotLength : 10 : 2, s);
    writeln(DigFilePTH, CurrentPathType + '  110', s);

    writeln(DigFileXY, 'p');
    str(RawPts[stop].x, s);
    writeln(DigFileXY, s);
    str(RawPts[stop].y, s);
    writeln(DigFileXY, s);

    for j := 1 to 6 do
    begin
      if (RawPts[stop].Feature[j].Code <> 'no_feature') then
        writeln(DigFileXY, 'feature ' + RawPts[stop].Feature[j].Code);
    end;
    writeln(DigFileXY, CurrentPathType);

    if ProcessLastPoint then
    begin
      for j := 1 to 6 do
        if (RawPts[stop].Feature[j].Code <> 'no_feature') then
          writeln(DigFilePTH, RawPts[stop].Feature[j].Code);
    end;
  end;

  Analyse2Points := Knotlength;
end;

procedure cspline;
var
  icou, jcou: integer;

begin
  pinc := 0;
  for jcou := 0 to 2 do
  begin
    for icou := 1 to (nc - 1) do
    begin
      tng[jcou, icou] := knot[jcou, (icou + 1)] - knot[jcou, (icou - 1)];
    end;
    tng[jcou, 0] := knot[jcou, 1] - knot[jcou, 0];
    tng[jcou, nc] := knot[jcou, nc] - knot[jcou, (nc - 1)];
  end;

  for icou := 1 to nc do
  begin
    qc := 0.0;
    for jcou := 0 to 2 do
    begin
      dc[jcou, icou] := knot[jcou, icou] - knot[jcou, (icou - 1)];
      qc := qc + (dc[jcou, icou] * dc[jcou, icou]);
    end;
    rc[icou] := sqrt(qc);
  end;

  for icou := 0 to nc do
  begin
    qc := sqrt(((tng[0, icou] * tng[0, icou]) + (tng[1, icou] * tng[1, icou]) + (tng[2, icou] * tng[2, icou])));
    if (qc = 0.0) then
      tng[0, icou] := 1.0
    else
    begin
      for jcou := 0 to 2 do
        tng[jcou, icou] := (tng[jcou, icou] / qc);
    end;
  end;

  repeat
    for icou := 0 to (nc-1) do
    begin
      c2 := rc[(icou + 1)] + (dc[0, (icou + 1)] * tng[0, (icou + 1)]) +
                             (dc[1, (icou + 1)] * tng[1, (icou + 1)]) +
                             (dc[2, (icou + 1)] * tng[2, (icou + 1)]);
      c1 := rc[(icou + 1)] + (dc[0, (icou + 1)] * tng[0, icou]) +
                             (dc[1, (icou + 1)] * tng[1, icou]) +
                             (dc[2, (icou + 1)] * tng[2, icou]);
      hc[icou] := (6 * rc[(icou + 1)] * rc[(icou + 1)]) / ((2 * c2) + c1);
      mc[(icou + 1)] := (6 * rc[(icou + 1)] * rc[(icou + 1)]) / ((2 * c1) + c2);
    end;
    for jcou := 0 to 2 do
    begin
      for icou := 1 to (nc-1) do
        vc[jcou, icou] := hc[icou] * hc[icou] * (hc[(icou - 1)] *
                          tng[jcou, (icou-1)] - 3 * dc[jcou, icou]) +
                          mc[icou] * mc[icou] * (mc[(icou + 1)] *
                          tng[jcou, (icou+1)] - 3 * dc[jcou, (icou+1)]);
    end;
    fc := 0;
    for icou := 1 to (nc-1) do
    begin
      qc := 0.0;
      q1c := 0.0;
      for jcou := 0 to 2 do
      begin
        qc := qc + vc[jcou, icou] * vc[jcou, icou];
        q1c := q1c + vc[jcou, icou] * tng[jcou, icou];
      end;
      qc := -(sqrt(qc));
      if ((q1c / qc) <= 1.0) then   //changed from Toms
      begin
        for jcou := 0 to 2 do
          tng[jcou, icou] := vc[jcou, icou] / qc;
        fc := 1;
      end;
    end;
  until fc <> 0;
  inc(pinc);
end;

function GetRadius(xx0, xx1, yy0, yy1, zz0, zz1: single): double;
var
  theta: double;
  curve: double;
  a, b, c, d, first, second: array [0..1] of single;
  uu, vv: single;
  intret: boolean;

begin
  // all done in inches to avoid v larg nos
  a[0] := (yy0 - xx0) / 1000.0;
  a[1] := (yy1 - xx1) / 1000.0;
  c[0] := (zz0 - yy0) / 1000.0;
  c[1] := (zz1 - yy1) / 1000.0;

  //rot 90
  b[0] := -(a[1] * 0.5);
  b[1] := a[0] * 0.5;
  d[0] := -(c[1] * 0.5);
  d[1] := c[0] * 0.5;

  a[0] := (xx0 / 1000.0) + (a[0] * 0.5);
  a[1] := (xx1 / 1000.0) + (a[1] * 0.5);
  c[0] := (yy0 / 1000.0) + (c[0] * 0.5);
  c[1] := (yy1 / 1000.0) + (c[1] * 0.5);

  intret := intsect(a[0], a[1], b[0], b[1], c[0], c[1], d[0], d[1], uu, vv);

  first[0] := (xx0 / 1000.0);
  first[1] := (xx1 / 1000.0);
  second[0] := (yy0 / 1000.0);
  second[1] := (yy1 / 1000.0);

  theta := ((vv * d[0]) * (vv * d[0])) + ((vv * d[1]) * (vv * d[1]));
  theta := sqrt(theta);
  if ((theta > 12) or (not intret)) then
    curve := 1000.0
  else
    curve := theta * 25.4;

  GetRadius := curve;
end;

function adotb(a1, a2, b1, b2: single): single;
var
  reslt, moda, modb: single;

begin
  reslt := (a1 * b1) + (a2 * b2);
  moda := sqrt(((a1 * a1) + (a2 * a2)));
  modb := sqrt(((b1 * b1) + (b2 * b2)));
  reslt := reslt / (moda * modb);
  if (((abs(reslt) - 1) > -0.000001) and ((abs(reslt) - 1) < 0.000001)) then
    reslt := trunc((reslt + 0.5));
  adotb := reslt;
end;

function intsect(a1, a2, b1, b2, c1, c2, d1, d2: single; var uu, vv: single): boolean;
//gets intersection of A+uB and C+wD (vector eqs of line)
var
  top, bott, tt: single;
  ans: boolean;

begin
  //these are the solutions to the vector equations
  top := -d2;
  bott := d1;
  tt := ((b1 * top) + (b2 * bott));
  if (tt <> 0) then
  begin
    uu := ((c1 * top) + (c2 * bott) - ((a1 * top) + (a2 * bott))) / tt;
    vv := ((a1 * b2) - (a2 * b1) - (c1 * b2) + (c2 * b1)) / ((d1 * b2) - (d2 * b1));
    ans := true;
  end
  else
  begin
    uu := 99999;
    vv := 99999;
    ans := false;
  end;
  intsect := ans;
end;

procedure matrixr(xo, yo, ang: single);
//Rotate by ANG radians about point (X0,Y0)
var
  cosang, sinang: single;

begin
  cosang := cos(ang);
  sinang := sin(ang);
  matrix[1, 1] := cosang;
  matrix[2, 1] := sinang;
  matrix[3, 1] := 0.0;
  matrix[1, 2] := (-sinang);
  matrix[2, 2] := cosang;
  matrix[3, 2] := 0.0;
  matrix[1, 3] := (-(xo * cosang) + (yo * sinang)) + xo;
  matrix[2, 3] := (-(xo * sinang) - (yo * cosang)) + yo;
  matrix[3, 3] := 1.0;
end;

procedure matmultir(var x1, y1: single);
//Multiply single point (X,Y) by transf. matrix
var
  datai, dataj: single;

begin
  datai := x1;
  dataj := y1;
  x1 := ((datai * matrix[1, 1]) + (dataj * matrix[1, 2]) + matrix[1, 3]);
  y1 := ((datai * matrix[2, 1]) + (dataj * matrix[2, 2]) + matrix[2, 3]);
end;

function FileName(FileRef, extension: string): string;
var
  NewFile: string;
  Dot: integer;

begin
{  Dot := pos('.', FileRef);
  if Dot = 0 then
    NewFile := FileRef
  else
    NewFile := Copy(FileRef, 1, Dot - 1);

  FileName := NewFile + '.' + extension;
 }
  FileName := changeFileExt(FileRef, '.' + extension);
end;

function CalculateArea: single;
var
  Pt, NextPt: integer;
  xm, ym: integer;
  ShapeArea, StripArea: single;

begin
  ShapeArea := 0;

  //Only calculate area for a closed shape
  if NoSmoothPts > 0 then
  begin
    if (SmoothPts[1].x = SmoothPts[NoSmoothPts].x) and
       (SmoothPts[1].y = SmoothPts[NoSmoothPts].y) then
    begin
      for Pt := 1 to NoSmoothPts do
      begin
        if Pt = NoSmoothPts then
          NextPt := 1
        else
          NextPt := Pt + 1;

        xm := round(SmoothPts[NextPt].x - SmoothPts[Pt].x);
        ym := round(SmoothPts[NextPt].y - SmoothPts[Pt].y);
        StripArea := (SmoothPts[Pt].y * abs(xm)) + (0.5 * (abs(xm) * ym));
        if (xm > 0) then
          StripArea := - StripArea;
        ShapeArea := ShapeArea + StripArea
      end;
    end;
  end;

  CalculateArea := abs(ShapeArea / 1000000);
end;

end.
