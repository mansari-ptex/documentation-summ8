//IMPORTANT: One procedure rewritten by TAH due to memory leak in the original

unit ConvexHull;

interface

uses
  FastGEO;

type
  TCHullPoint2D = record
    x: TFloat;
    y: TFloat;
    ang: TFloat;
  end;
  TCompareResult = (eGreaterThan, eLessThan, eEqual);
  TSortCompare = function(const P1, P2: TCHullPoint2D): TCompareResult of object;
  TBaseConvexHull = class
  public
    function ConvexHull(const Pnt: array of TPoint2D): TPolygon2D; virtual; abstract;
  end;
  TConvexHull2D = class (TBaseConvexHull)
  private
    Point: array of TCHUllPoint2D;
    Stack: array of TCHUllPoint2D;
    StackHeadPosition: Integer;
    Anchor : TCHullPoint2D;
    function IsEqual(const P1, P2: TCHullPoint2D): Boolean;
    function CompareAngles(const P1, P2: TCHullPoint2D): TCompareResult;
    function Orientation(P1, P2, P3: TCHUllPoint2D): integer;
    procedure Swap(i, j: Longint; var Point: array of TCHullPoint2D);
    procedure RQSort(Left, Right: Longint; var Point: array of TCHullPoint2D; Compare: TSortCompare);
    procedure GrahamScan;

    //Stack related methods
    procedure Push(Pnt: TCHullPoint2D);
    function  Pop: Boolean; overload;
    function  Pop(out Head: TCHullPoint2D): Boolean; overload;
    function  Head: TCHullPoint2D;
    function  PreHead: TCHullPoint2D;
    function  PreHeadExist: Boolean;
  public
    function ConvexHull(const Pnt: array of TPoint2D) : TPolygon2D; override;
  end;

function CreateConvexHull(const Point: array of TPoint2D): TPolygon2D;

implementation

function CreateConvexHull(const Point : array of TPoint2D): TPolygon2D;
var
  Hull: TConvexHull2D;
  Hull2: TPolygon2D;

begin
  //IMPORTANT: Rewritten by TAH due to memory leak in the original
  Hull := TConvexHull2D.Create;
  Hull2 := Hull.ConvexHull(Point);
  Hull.Free;

  Result := Hull2;
end;

function TConvexHull2D.CompareAngles(const P1, P2: TCHullPoint2D): TCompareResult;
begin
  if P1.ang < P2.ang then
    Result := eLessThan
  else if P1.ang > P2.ang then
    Result := eGreaterThan
  else If IsEqual(P1,P2) then
    Result := eEqual
  else if LayDistance(Anchor.x, Anchor.y, P1.x, P1.y) < LayDistance(Anchor.x, Anchor.y, P2.x, P2.y) then
    Result := eLessThan
  else
    Result := eGreaterThan;
end;

function TConvexHull2D.IsEqual(const P1, P2: TCHullPoint2D): Boolean;
begin
  Result := FastGEO.IsEqual(P1.x, P2.x) and FastGEO.IsEqual(P1.y, P2.y);
end;

function TConvexHull2D.ConvexHull(const Pnt: array of TPoint2D): TPolygon2D;
var
  i: integer;
  j: integer;

begin
  if Length(Pnt) <= 3 then
  begin
    SetLength(Result, Length(Pnt));
    for i := 0 to Length(Pnt) - 1 do
    begin
      Result[i].x := Pnt[I].x;
      Result[i].y := Pnt[I].y;
    end;
    exit;
  end;

  StackHeadPosition := -1;

  try
    SetLength(Point, Length(Pnt));
    Setlength(Stack, Length(Pnt));

    j := 0;
    for i := 0 to Length(Point) - 1 do
    begin
      Point[i].x := Pnt[i].x;
      Point[i].y := Pnt[i].y;
      Point[i].Ang := 0.0;

      if Point[i].y < Point[j].y then
        j := i
      else if Point[i].y = Point[j].y then
        if Point[i].x < Point[j].x then
          j := i;
    end;

    Swap(0, j, Point);

    Point[0].Ang := 0;
    Anchor := Point[0];

    //Calculate angle of the vertex ([ith point]-[anchorpoint]-[most left point])
    for i := 1 to Length(Point) - 1 do
      Point[i].Ang := CartesianAngle(Point[i].x - Anchor.x, Point[i].y - Anchor.y);

    //Sort points in ascending order according to their angles
    RQSort(1,Length(Point) - 1,Point, CompareAngles);

    GrahamScan;

    SetLength(Result, StackHeadPosition + 1);

    for i := 0 to StackHeadPosition do
    begin
      Result[i].x := Stack[i].x;
      Result[i].y := Stack[i].y;
    end;

  finally
    //Final clean-up
    Finalize(Stack);
    Finalize(Point);
  end;
end;

procedure TConvexHull2D.GrahamScan;
var
  i: integer;
  Orin: integer;

begin
  Push(Point[0]);
  Push(Point[1]);

  i := 2;

  while i < Length(Point) do
  begin
    if PreHeadExist then
    begin
      Orin := Orientation(PreHead,Head, Point[i]);
      if Orin = CounterClockwise then
      begin
        Push(Point[i]);
        inc(i);
      end
      else
        Pop;
    end
    else
    begin
      Push(Point[i]);
      inc(i);
    end;
  end;
end;

procedure TConvexHull2D.Push(Pnt: TCHullPoint2D);
begin
  inc(StackHeadPosition);
  Stack[StackHeadPosition] := Pnt;
end;

function TConvexHull2D.Pop: Boolean;
begin
  Result := False;
  if StackHeadPosition >= 0 then
  begin
    Result := True;
    dec(StackHeadPosition);
  end;
end;

function TConvexHull2D.Pop(Out Head: TCHullPoint2D): Boolean;
begin
  Result := False;
  if StackHeadPosition < 0 then
    Exit;
  Head := Stack[StackHeadPosition];
  dec(StackHeadPosition);
    Result := True;
end;

function TConvexHull2D.Head: TCHullPoint2D;
begin
  Assert((StackHeadPosition >= 0) and (StackHeadPosition < Length(Stack)), 'TConvexHull2D.Head:TCHullPoint2D: Invalid stack-head position.');
  Result := Stack[StackHeadPosition];
end;

function TConvexHull2D.PreHead: TCHullPoint2D;
begin
  Assert(((StackHeadPosition - 1) >= 0) and ((StackHeadPosition - 1) < Length(Stack)), 'TConvexHull2D.PreHead:TCHullPoint2D: Invalid pre stack-head position.');
  Result := Stack[StackHeadPosition - 1];
end;

function TConvexHull2D.PreHeadExist: Boolean;
begin
  Result := (StackHeadPosition > 0);
end;

function TConvexHull2D.Orientation(P1, P2, P3: TCHullPoint2D): integer;
begin
 Result := FastGEO.Orientation(P1.x, P1.y, P2.x, P2.y, P3.x, P3.y);
end;

procedure TConvexHull2D.Swap(i, j: Longint; var Point: array of TCHullPoint2D);
var
  Temp : TCHullPoint2D;

begin
  Temp := Point[i];
  Point[i] := Point[j];
  Point[j] := Temp;
end;

procedure TConvexHull2D.RQSort(Left, Right: Longint; var Point: array of TCHullPoint2D; Compare: TSortCompare);
var
  i: integer;
  j: integer;
  Middle: integer;
  Pivot: TCHullPoint2D;

begin
  repeat
    i := Left;
    j := Right;
    Middle := (Left + Right) div 2;

    //Median of 3 Pivot Selection
    if Compare(Point[Middle], Point[Left]) = eLessThan then
      Swap(Left, Middle, Point);
    if Compare(Point[Right], Point[Middle]) = eLessThan then
      Swap(Right,Middle, Point);
    if Compare(Point[Middle], Point[Left]) = eLessThan then
      Swap(Left, Middle,Point);

    Pivot := Point[Right];

    repeat
      while Compare(Point[i], Pivot) = eLessThan do
        inc(i);
      while Compare(Point[j], Pivot) = eGreaterThan do
        dec(j);

      if i <= j then
      begin
        Swap(i, j, Point);
        inc(i);
        dec(j);
      end;
    until i > j;

    if Left < j then
      RQSort(Left, j, Point, Compare);
    Left := i;
  until i >= Right;
end;

end.

