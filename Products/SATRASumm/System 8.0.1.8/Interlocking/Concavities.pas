unit Concavities;

interface

uses
  Windows, General_Interlocking, FastGEO;

const
  MinimumConcavityArea = 100;

type
  TConcavityBounds = record
    Start, Finish: integer;
    TheArea: real;
    Used: boolean;
  end;
  TConcavityBoundsArray = array of TConcavityBounds;

function PointOnHull(ThePoint: TPoint;
                     TheHull: TPolygon2D): boolean;
function PointAndHullPoint(i: integer;
                           ThePoint: TPoint;
                           TheHull: TPolygon2D): Boolean;
procedure ConcavityBound(ThisPointIndex, NextPointIndex: integer;
                         TheKnife: TPointArray;
                         TheHull: TPolygon2D;
                         var ConcavityIndex: integer;
                         var FoundPoint, Start: Boolean);
procedure GetConcavityBounds(TheKnife: TPointArray;
                             TheHull: TPolygon2D;
                             UseMinConArea: boolean;
                             ExistingLength: integer;
                             var NumValidConcavities: integer;
                             var Concavities: TConcavityBoundsArray);
procedure MakeMaskKnifeShape(TheKnife: TPointArray;
                             Concavity: integer;
                             var MaskConcavities: TConcavityBoundsArray;
                             var MaskKnife: TPointArray);
procedure SingleConcavityOpen(LeaveConcavityOpen: integer;
                              Concavities: TConcavityBoundsArray;
                              var MaskKnife1, MaskKnife2: TPointArray);

procedure Selectionsort(var Concavities: TConcavityBoundsArray);

implementation

procedure Selectionsort(var Concavities: TConcavityBoundsArray);
var
  i, j, BestJ: integer;
  BestConcavity: TConcavityBounds;

begin
  for i := 0 to Length(Concavities) - 2 do     
  begin
    BestConcavity := Concavities[i];
    BestJ := i;
    for j := i + 1 to Length(Concavities) - 1 do
    begin
      if (Concavities[j].TheArea > BestConcavity.TheArea) Then
      begin
        BestConcavity := Concavities[j];
        BestJ := j;
      end;
    end;
    Concavities[BestJ] := Concavities[i];
    Concavities[i] := BestConcavity;
  end;
end;

function PointOnHull(ThePoint: TPoint;
                     TheHull: TPolygon2D): boolean;       //don't need this, but useful for debugging file output at mo.
var
  i: integer;

begin
  i := 0;
  while not(Result or (i = Length(TheHull))) do
  begin
    if (ThePoint.X = round(TheHull[i].x)) and (ThePoint.Y = round(TheHull[i].y)) then
      Result := True
    else
      Result := False;
    inc(i);
  end;
end;

function PointAndHullPoint(i: integer;
                           ThePoint: TPoint;
                           TheHull: TPolygon2D): Boolean;
begin
  if (ThePoint.X = round(TheHull[i].x)) and (ThePoint.Y = round(TheHull[i].y)) then
    Result := True
  else
    Result := False;
end;

procedure ConcavityBound(ThisPointIndex, NextPointIndex: integer;
                         TheKnife: TPointArray;
                         TheHull: TPolygon2D;
                         var ConcavityIndex: integer;
                         var FoundPoint, Start: Boolean);
var
  i, Nexti: integer;
  ThisPointOnHull, NextPointOnHull: Boolean;

begin
  FoundPoint := False;
  Start := False;
  i := 0;
  while not(FoundPoint or (i = Length(TheHull) - 1)) do     //ignore last point because hulls are closed
  begin
    Nexti := i + 1;
    if Nexti = Length(TheHull) - 1 then                     //ignore last point because hulls are closed
      Nexti := 0;
    ThisPointOnHull := PointAndHullPoint(i, TheKnife[ThisPointIndex], TheHull);
    NextPointOnHull := PointAndHullPoint(Nexti, TheKnife[NextPointIndex], TheHull);

    if ThisPointOnHull and (not NextPointOnHull) then
    begin
      FoundPoint := True;
      Start := True;
      ConcavityIndex := ThisPointIndex;
    end;

    if (not ThisPointOnHull) and NextPointOnHull then
    begin
      FoundPoint := True;
      Start := False;
      ConcavityIndex := NextPointIndex;
    end;

    inc(i);
  end;
end;

function ConcavityArea(ConcavBounds: TConcavityBounds;
                       TheKnife: TPointArray): real;
var
  j, k, StopNow: integer;
  Concavity: TPolygon2D;

begin
  k := -1;
  j := ConcavBounds.Start;
  StopNow := ConcavBounds.Finish + 1;
  if StopNow = Length(TheKnife) then
    StopNow := 0;
  while not(j = StopNow) do
  begin
    inc(k);
    SetLength(Concavity, k + 1);
    Concavity[k].X := TheKnife[j].X;
    Concavity[k].Y := TheKnife[j].Y;

    inc(j);
    if (j = Length(TheKnife)) then
      j := 0;
  end;

  result := abs(Area(Concavity));
end;

procedure GetConcavityBounds(TheKnife: TPointArray;
                             TheHull: TPolygon2D;
                             UseMinConArea: boolean;
                             ExistingLength: integer;
                             var NumValidConcavities: integer;
                             var Concavities: TConcavityBoundsArray);

var
  i, ConcavityIndex, NextPoint: integer;
  AllDone, BeenRoundKnife, FoundPoint, Start, Started: Boolean;
  TheArea: real;

begin
  NumValidConcavities := 0;
  SetLength(Concavities, 0);
  BeenRoundKnife := False;
  i := 0;
  Started := False;
  AllDone := False;
  FoundPoint := False;
  while not AllDone do
  begin
    if i = Length(TheKnife) then
      i := 0;

    NextPoint := i + 1;
    if NextPoint = Length(TheKnife) then
    begin
      NextPoint := 0;
      BeenRoundKnife := True;
    end;

    ConcavityBound(i, NextPoint, TheKnife, TheHull, ConcavityIndex, FoundPoint, Start);

    if FoundPoint then
    begin
      if Started and not Start then        //this is a concavity end
      begin
        Concavities[Length(Concavities) - 1].Finish := ConcavityIndex;
        Concavities[Length(Concavities) - 1].Used := False;
        Started := False;
      end
      else if Start and not Started then   //this is a concavity start
      begin
        SetLength(Concavities, Length(Concavities) + 1);
        Concavities[Length(Concavities) - 1].Start := ConcavityIndex;
        Started := True;
      end;

      if not Started then
      begin
        if Length(Concavities) > 0 then
        begin
          TheArea := ConcavityArea(Concavities[Length(Concavities) - 1], TheKnife);
 {         if UseMinConArea then
          begin
{            if TheArea > MinimumConcavityArea then
              Concavities[Length(Concavities) - 1].TheArea := TheArea
            else
              SetLength(Concavities, Length(Concavities) - 1);}

{            if TheArea < MinimumConcavityArea then
              TheArea := 0;

            Concavities[Length(Concavities) - 1].TheArea := TheArea;
          end
          else
            Concavities[Length(Concavities) - 1].TheArea := TheArea;}

          if UseMinConArea and (TheArea < MinimumConcavityArea) then
            TheArea := 0
          else
            inc(NumValidConcavities);

          Concavities[Length(Concavities) - 1].TheArea := TheArea;
        end;
      end;
    end;
    
    if BeenRoundKnife and not Started then
      AllDone := True;

    inc(i);
  end;
  Selectionsort(Concavities);
  if not UseMinConArea then
    SetLength(Concavities, ExistingLength);   //note this might make array longer and add all zero element, so check later.
end;

procedure MakeMaskKnifeShape(TheKnife: TPointArray;
                             Concavity: integer;
                             var MaskConcavities: TConcavityBoundsArray;
                             var MaskKnife: TPointArray);
var
  i, j, BeginLoop, EndLoop, NumberOfEliminatedPoints, ThisStart: integer;

begin
  if not((MaskConcavities[Concavity].Start = 0) and (MaskConcavities[Concavity].Finish = 0)) then
  begin
    NumberOfEliminatedPoints := -999;
    SetLength(MaskKnife, 0);
    i := Concavity;
    if MaskConcavities[i].Finish > MaskConcavities[i].Start then
    begin
      BeginLoop := 0;
      EndLoop := MaskConcavities[i].Start;
    end
    else
    begin
      BeginLoop := MaskConcavities[i].Finish;
      EndLoop := MaskConcavities[i].Start;
      ThisStart := BeginLoop;
    end;

    for j := BeginLoop to EndLoop do
    begin
      SetLength(MaskKnife, Length(MaskKnife) + 1);
      MaskKnife[Length(MaskKnife) - 1].X := TheKnife[j].X;
      MaskKnife[Length(MaskKnife) - 1].Y := TheKnife[j].Y;
    end;

    if MaskConcavities[i].Finish > MaskConcavities[i].Start then
    begin
      BeginLoop := MaskConcavities[i].Finish;
      EndLoop := Length(TheKnife) - 1;
      ThisStart := BeginLoop;
    end
    else
    begin
      BeginLoop := 0;
      EndLoop := -1;
      NumberOfEliminatedPoints := ThisStart;
    end;

    for j := BeginLoop to EndLoop do
    begin
      SetLength(MaskKnife, Length(MaskKnife) + 1);
      MaskKnife[Length(MaskKnife) - 1].X := TheKnife[j].X;
      MaskKnife[Length(MaskKnife) - 1].Y := TheKnife[j].Y;
    end;
    MaskConcavities[i].Used := True;

    //Rejig start/finish numbers to save having to make whole concavities array again.
    if not(NumberOfEliminatedPoints = ThisStart) then
    begin
      if MaskConcavities[i].Finish > MaskConcavities[i].Start then
        NumberOfEliminatedPoints := (MaskConcavities[i].Finish - MaskConcavities[i].Start) - 1
      else
        NumberOfEliminatedPoints := ((Length(TheKnife) - 1) - MaskConcavities[i].Start) + MaskConcavities[i].Finish;
    end;

    for j := 0 to Length(MaskConcavities) - 1 do
    begin
      if MaskConcavities[j].Start >= ThisStart then
      begin
        MaskConcavities[j].Start := MaskConcavities[j].Start - NumberOfEliminatedPoints;
        if MaskConcavities[j].Start < 0 then
          MaskConcavities[j].Start := (Length(TheKnife) - 1) + MaskConcavities[j].Start;
      end;

      if MaskConcavities[j].Finish >= ThisStart then
      begin
        MaskConcavities[j].Finish := MaskConcavities[j].Finish - NumberOfEliminatedPoints;
        if MaskConcavities[j].Finish < 0 then
          MaskConcavities[j].Finish := (Length(TheKnife) - 1) + MaskConcavities[j].Finish;
      end;
    end;
  end;
end;

procedure SingleConcavityOpen(LeaveConcavityOpen: integer;
                              Concavities: TConcavityBoundsArray;
                              var MaskKnife1, MaskKnife2: TPointArray);
var
  i, minx, miny, NumValidConcavities: integer;
  MaskConcavities: TConcavityBoundsArray;

begin
//MaskKnife2 is the W2 version of MaskKnife1.
  MaskKnife1 := Copy(Knife.ExpandedPoints);

  MaskConcavities := Copy(Concavities);

  MaskConcavities[LeaveConcavityOpen].Used := True;

  for i := 0 to Length(MaskConcavities) - 1 do
  begin
    if not MaskConcavities[i].Used then
      MakeMaskKnifeShape(MaskKnife1, i, MaskConcavities, MaskKnife1);
  end;

  //Rotate the MaskKnife1 through 180 degrees to form a MaskKnife2 with identical masking
  SetLength(MaskKnife2, Length(MaskKnife1));
  for i := 0 to Length(MaskKnife1) - 1 do
  begin
    MaskKnife2[i].x := -MaskKnife1[i].x;
    MaskKnife2[i].y := -MaskKnife1[i].y;
  end;

 //Shift it
  minx := 99999999;
  miny := 99999999;

  for i := 0 to Length(MaskKnife2) - 1 do
  begin
    if MaskKnife2[i].x < minx then
      minx := MaskKnife2[i].x;
    if MaskKnife2[i].y < miny then
      miny := MaskKnife2[i].y;
  end;

  for i := 0 to Length(MaskKnife2) - 1 do
  begin
    MaskKnife2[i].x := MaskKnife2[i].x - minx;
    MaskKnife2[i].y := MaskKnife2[i].y - miny;
  end;

  RemoveConsecutiveIndenticalPoints(MaskKnife2);
end;

end.
