unit Visualiser;

interface

uses Windows, General_Interlocking
     {$IFDEF DEBUGFULL}
     , Debugger
     {$ENDIF}
     ;

type
  TLineDirection = record
    HorizDir, VertDir: char;
  end;

const
  //Point types
  NOTDEFINED = -1;
  NOEDGE = 0;
  LEFTEDGE = 1;
  RIGHTEDGE = 2;
  LEFTRIGHTEDGE = 3;

  //Minimum Slot Width
  MINSLOTWIDTH = 2;

procedure FindEdges(var Pattern: TIntPolygon2D; var LeftsPattern, RightsPattern: TSideEdges; maxy: integer);

implementation

procedure AddToEdgeArray(var EdgePattern: TSideEdges;
                         PatternPoint: TIntPoint2D);
var
  i, Swap, x, yCount, yIndex: integer;

begin
  //EdgePattern will either be LeftsPattern or RightsPattern,
  //depending which array the point needs adding to.
  x := PatternPoint.x;
  yIndex := PatternPoint.y;
  yCount := EdgePattern[yIndex, 0];
  inc(yCount);
  setlength(EdgePattern[yIndex], yCount + 1);
  EdgePattern[yIndex, 0] := yCount;
  EdgePattern[yIndex, yCount] := x;

  //Keep in order
  for i := yCount downto 2 do
  begin
    if EdgePattern[yIndex, i] < EdgePattern[yIndex, i - 1] then
    begin
      Swap := EdgePattern[yIndex, i];
      EdgePattern[yIndex, i] := EdgePattern[yIndex, i - 1];
      EdgePattern[yIndex, i - 1] := Swap;
    end;
  end;
end;

function PointInOther(Pointx: integer;
                      OtherEdgeLine: array of integer): integer;
var
  i: integer;

begin
  Result := -1;
  i := 1;
  while not(i > Length(OtherEdgeLine) - 1) and not (Result > -1) do
  begin
    if (Pointx = OtherEdgeLine[i]) then
      Result := i;
    inc(i);
  end;
end;

procedure RemovePoint(ThePoint: integer;
                      var PatternEdge: array of integer);
var
  i: integer;

begin
  for i := ThePoint to Length(PatternEdge) - 2 do
    PatternEdge[i] := PatternEdge[i + 1];
  PatternEdge[0] := PatternEdge[0] - 1;
end;

procedure RemoveSlots(var Lefts, Rights: array of integer);
var
  i: integer;

begin
  i := 2;     //Start at index 2 because the first left point must never go
  while (i <= Lefts[0]) do
  begin
    if (Lefts[i] - Rights[i - 1] <= MINSLOTWIDTH ) then
    begin
      RemovePoint(i, Lefts);
      RemovePoint(i - 1, Rights);
    end
    else
      inc(i);
  end;
end;

procedure ProblemPoints(Pattern: TIntPolygon2D;
                        i: integer;
                        var ProbPnts: TPointArray;
                        var Pi: integer);
var
  Lasti, Nexti: integer;

begin
  Lasti := i - 1;
  if (Lasti < 0) then
    Lasti := Length(Pattern) - 1;
  Nexti := i + 1;
  if (Nexti > Length(Pattern) - 1) then
    Nexti := 0;

  while (abs(Pattern[Lasti].x - Pattern[Nexti].x) < 2) and (Pattern[Lasti].y = Pattern[Nexti].y) do
  begin
    inc(Pi);
    SetLength(ProbPnts, Pi + 1);
    ProbPnts[Pi].x := Pattern[Lasti].x;
    ProbPnts[Pi].y := Pattern[Lasti].y;

    Lasti := Lasti - 1;
    if (Lasti < 0) then
      Lasti := Length(Pattern) - 1;
    Nexti := Nexti + 1;
    if (Nexti > Length(Pattern) - 1) then
      Nexti := 0;
  end;
end;

procedure RemoveTurningPointsFromProblemPoints(TurnPnts: TPointArray;
                                               var ProbPnts: TPointArray);
var
  i, j, k: integer;
  ProbPnt: Tpoint;

begin
  i := 0;
  while not(i > Length(ProbPnts) - 1) do
  begin
    ProbPnt := ProbPnts[i];
    for j := 0 to Length(TurnPnts) - 1 do
    begin
      if (ProbPnt.x = TurnPnts[j].x) and (ProbPnt.y = TurnPnts[j].y) then
      begin
        for k := i to Length(ProbPnts) - 2 do
          ProbPnts[k] := ProbPnts[k + 1];
        SetLength(ProbPnts, Length(ProbPnts) - 1);
      end;
    end;
    inc(i);
  end;
end;

function ThisLine(Point1, Point2: TIntPoint2D): TLineDirection;
var
  Diffx, Diffy: integer;

begin
  Diffx := Point1.x - Point2.x;
  if (Diffx = 0) then
    ThisLine.HorizDir := 'N'
  else if (Diffx > 0) then
    ThisLine.HorizDir := 'L'
  else
    ThisLine.HorizDir := 'R';

  Diffy := Point1.y - Point2.y;
  if (Diffy = 0) then
    ThisLine.VertDir := 'N'
  else if (Diffy > 0) then
    ThisLine.VertDir := 'U'
  else
    ThisLine.VertDir := 'D';
end;

function GetPointType(LineBefore, LineAfter: TLineDirection): integer;
begin
  if (LineBefore.VertDir = 'U') then
  begin
    Result := LEFTEDGE;
    if (LineAfter.HorizDir = 'L') and (LineAfter.VertDir = 'N') then
      Result := NOEDGE
    else if (LineAfter.HorizDir = 'R') and (LineAfter.VertDir = 'D') then
      Result := LEFTRIGHTEDGE
    else if (LineAfter.HorizDir = 'L') and (LineAfter.VertDir = 'D') then
    begin
      if (LineBefore.HorizDir <> 'R') then
        Result := NOEDGE
      else
        Result := LEFTRIGHTEDGE;
    end
    else if (LineAfter.HorizDir = 'N') and (LineAfter.VertDir = 'D') then
    begin
      if (LineBefore.HorizDir = 'L') then
        Result := NOEDGE
      else
        Result := LEFTRIGHTEDGE;
    end;
  end
  else if (LineBefore.VertDir = 'D') then
  begin
    Result := RIGHTEDGE;
    if (LineAfter.HorizDir = 'L') and (LineAfter.VertDir = 'U') then
      Result := LEFTRIGHTEDGE
    else if (LineAfter.HorizDir = 'R') and (LineAfter.VertDir = 'N') then
      Result := NOEDGE
    else if (LineAfter.HorizDir <> 'L') and (LineAfter.VertDir = 'U') then
    begin
      if (LineBefore.HorizDir <> 'R') then
        Result := LEFTRIGHTEDGE
      else
        Result := NOEDGE;
    end;
  end
  else if (LineBefore.VertDir = 'N') then
  begin
    if (LineBefore.HorizDir = 'L') then
    begin
      if (LineAfter.VertDir = 'U') or ((LineAfter.HorizDir = 'R') and (LineAfter.VertDir = 'N') and
        (LineAfter.HorizDir <> LineBefore.HorizDir)) then
        Result := LEFTEDGE
      else
        Result := NOEDGE;
    end
    else
    begin
      if (LineAfter.VertDir = 'D') or ((LineAfter.VertDir = 'N') and (LineBefore.VertDir = 'N') and
       (LineAfter.HorizDir <> LineBefore.HorizDir)) then
        Result := RIGHTEDGE
      else
        Result := NOEDGE;
    end;
  end;
end;

procedure FindEdges(var Pattern: TIntPolygon2D; var LeftsPattern, RightsPattern: TSideEdges; maxy: integer);
var
  i, j, Pi, y, Diff, FlatTurnPointType, Lastj, LastVertChangei, LastVertChangePointType, NextVertChangePointType, FlatTurni,
  Nexti, Nextj, pio, yIndex: integer;
  BeenRoundPattern, KeepLooking, PointWasAdded, DoubledBack: boolean;
  LineAfterVertDirChange, LineBeforeVertDirChange, LineAfter, LineBefore: TLineDirection;
  ProbPnts, TurnPnts: TPointArray;
  PointType: byte;

begin
  Pi := NOTDEFINED;
  BeenRoundPattern := False;  //Need to be able to look forward through the pattern array if FlatTurn is found
                              //at the end. This variable will prevent infinite looping round the pattern afterwards
  LastVertChangePointType := NOTDEFINED;
  SetLength(TurnPnts, 0);
  SetLength(LeftsPattern, maxy + 1);
  SetLength(RightsPattern, maxy + 1);

  //Initialise Counts
  for i := 0 to Length(LeftsPattern) - 1 do
  begin
    setlength(LeftsPattern[i], 1);
    LeftsPattern[i, 0] := 0;
    setlength(RightsPattern[i], 1);
    RightsPattern[i, 0] := 0;
  end;

  i := 0;
  while not(i > Length(Pattern) - 1) and not BeenRoundPattern do
  begin
    if (i = 0) then
      LineBefore := ThisLine(Pattern[Length(Pattern) - 1], Pattern[i])
    else
      LineBefore := LineAfter;

    Nexti := i + 1;
    if (Nexti > Length(Pattern) - 1) then
      Nexti := 0;
    LineAfter := ThisLine(Pattern[i], Pattern[Nexti]);

    //See if we have doubled back on ourselves in a horizontal direction
    //i.e. a 'flat turn'
    DoubledBack := ((LineBefore.VertDir = 'N') and (LineAfter.VertDir = 'N') and (LineBefore.HorizDir <> LineAfter.HorizDir) and
      (LineBefore.HorizDir <> 'N') and (LineAfter.HorizDir <> 'N'));

    if not DoubledBack  then
    begin
      //Main routine - Normal points (not flat turns)

      PointType := GetPointType(LineBefore, LineAfter);

      if (PointType > NOEDGE) then
      begin
        if (PointType = LEFTEDGE) or (PointType = LEFTRIGHTEDGE) then
          AddToEdgeArray(LeftsPattern, Pattern[i]);
        if (PointType = RIGHTEDGE) or (PointType = LEFTRIGHTEDGE) then
          AddToEdgeArray(RightsPattern, Pattern[i]);

        if (PointType = LEFTRIGHTEDGE) then
        begin
          ProblemPoints(Pattern, i, ProbPnts, Pi);
          SetLength(TurnPnts, Length(TurnPnts) + 1);
          TurnPnts[Length(TurnPnts) - 1].x := Pattern[i].x;
          TurnPnts[Length(TurnPnts) - 1].y := Pattern[i].y;
        end;
      end;
    end
    else
    begin
      //Routine for Flat turns

      if (LastVertChangePointType = NOTDEFINED) then
      begin
        LineBeforeVertDirChange.VertDir := 'N';
        //Backtrack to find the last change in Vertical Direction before Flatline.
        while (LineBeforeVertDirChange.VertDir = 'N') do
        begin
          j := i;
          dec(j);
          if (j < 0) then
            j := Length(Pattern) - 1;

          Lastj := j - 1;
          if (Lastj < 0) then
            Lastj := Length(Pattern) - 1;

          LineBeforeVertDirChange := ThisLine(Pattern[Lastj], Pattern[j]);

          Nextj := j + 1;
          if (Nextj > Length(Pattern) - 1) then
            Nextj := 0;
          LineAfterVertDirChange := ThisLine(Pattern[j], Pattern[Nextj]);
        end;
        PointType := GetPointType(LineBeforeVertDirChange, LineAfterVertDirChange);
        LastVertChangePointType := PointType;
        LastVertChangei := j;
        PointWasAdded := False;
      end
      else
        PointWasAdded := True;

      yIndex := Pattern[i].y;
      //Remove last point from whichever array it got put in because we want to replace it with one we're sure of -
      //it might be wrong because FlatTurns change the local 'clockwiseness' of the pattern.
      //Can never be a LEFTRIGHTEDGE so don't bother to check for it. If it was a NOEDGE nothing will have been added.
      if PointWasAdded then
      begin
        if (LastVertChangePointType = LEFTEDGE) then
        begin
          LeftsPattern[yIndex, 0] := LeftsPattern[yIndex, 0] - 1;
          SetLength(LeftsPattern[yIndex], Length(LeftsPattern[yIndex]) - 1);
        end
        else if (LastVertChangePointType = RIGHTEDGE) then
        begin
          RightsPattern[yIndex, 0] := RightsPattern[yIndex, 0] - 1;
          SetLength(RightsPattern[yIndex], Length(RightsPattern[yIndex]) - 1);
        end;
      end;

      FlatTurni := i;
      FlatTurnPointType := GetPointType(LineBefore, LineAfter);

      while (LineAfter.VertDir = 'N') do
      begin
        LineBefore := LineAfter;
        inc(i);
        if (i > Length(Pattern) - 1) then
        begin
          i := 0;
          BeenRoundPattern := True;   //record the fact that we have been round pattern, so the loop will
                                      //not continue indefinitely. Must check beyond start of pattern again
                                      //if FlatTurn is at the end and the NextVertChangeType comes afterwards.
        end;
        Nexti := i + 1;
        if (Nexti > Length(Pattern) - 1) then
          Nexti := 0;
        LineAfter := ThisLine(Pattern[i], Pattern[Nexti]);
      end;
      NextVertChangePointType := GetPointType(LineBefore, LineAfter);

      //Work out Lefts and Rights for turning flat lines
      if (LastVertChangePointType = LEFTEDGE) and (NextVertChangePointType = LEFTEDGE) then
      begin
        if (Pattern[LastVertChangei].x < Pattern[i].x) then
          AddToEdgeArray(LeftsPattern, Pattern[LastVertChangei])
        else
          AddToEdgeArray(LeftsPattern, Pattern[i]);
      end
      else if (LastVertChangePointType = RIGHTEDGE) and (NextVertChangePointType = RIGHTEDGE) then
      begin
        if (Pattern[LastVertChangei].x > Pattern[i].x) then
          AddToEdgeArray(RightsPattern, Pattern[LastVertChangei])
        else
          AddToEdgeArray(RightsPattern, Pattern[i]);
      end
      else if (LastVertChangePointType = NOEDGE) and (NextVertChangePointType = NOEDGE) then
      begin
        if (FlatTurnPointType = LEFTEDGE) then
          AddToEdgeArray(LeftsPattern, Pattern[FlatTurni])
        else
          AddToEdgeArray(RightsPattern, Pattern[FlatTurni])
      end
      else if (LastVertChangePointType = LEFTEDGE) and (NextVertChangePointType = NOEDGE) then
      begin
        AddToEdgeArray(LeftsPattern, Pattern[LastVertChangei]);
        AddToEdgeArray(RightsPattern, Pattern[FlatTurni]);
      end
      else if (LastVertChangePointType = RIGHTEDGE) and (NextVertChangePointType = NOEDGE) then
      begin
        AddToEdgeArray(LeftsPattern, Pattern[FlatTurni]);
        AddToEdgeArray(RightsPattern, Pattern[LastVertChangei]);
      end
      else if (LastVertChangePointType = NOEDGE) and (NextVertChangePointType = LEFTEDGE) then
      begin
        if (Pattern[LastVertChangei].x > Pattern[i].x) then
        begin
          AddToEdgeArray(RightsPattern, Pattern[FlatTurni]);
          AddToEdgeArray(LeftsPattern, Pattern[i]);
        end;
      end
      else if (LastVertChangePointType = NOEDGE) and (NextVertChangePointType = RIGHTEDGE) then
      begin
        if (Pattern[LastVertChangei].x < Pattern[i].x) then
        begin
          AddToEdgeArray(LeftsPattern, Pattern[FlatTurni]);
          AddToEdgeArray(RightsPattern, Pattern[i]);
        end;
      end;
    end;

    if (LineAfter.VertDir = 'N') and (LineBefore.VertDir <> LineAfter.VertDir) then
    begin
      LastVertChangePointType := PointType;
      LastVertChangei := i;
    end;
    inc(i);
  end;

  //Preserve Turning points exactly as they are by
  //ensuring that they are not problem points
  RemoveTurningPointsFromProblemPoints(TurnPnts, ProbPnts);

  //Remove Slots (Gap in pattern)
  for y := 0 to maxy do
    RemoveSlots(LeftsPattern[y], RightsPattern[y]);

  //'Fatten' narrow parts of pattern
  if (Pi > -1) then
  begin
    for i := 0 to Length(ProbPnts) - 1 do
    begin
      KeepLooking := True;
      y := ProbPnts[i].y;
      j := 0;
      if ProbPnts[i].x > 0 then
      begin
        //Move Left point to the left
        while not(j = LeftsPattern[y, 0]) and KeepLooking do
        begin
          inc(j);
          if (LeftsPattern[y, j] = ProbPnts[i].x) then
          begin
            KeepLooking := False;
            LeftsPattern[y, j] := LeftsPattern[y, j] - 1;
            pio := PointInOther(LeftsPattern[y, j], RightsPattern[y]);
            if (pio > -1) then
            begin
              RemovePoint(j, LeftsPattern[y]);
              RemovePoint(pio, RightsPattern[y]);
            end;
          end;
        end;
      end
      else
      begin
        RightsPattern[y, 1] := RightsPattern[y, 1] + 1;   //if x is 0 then must be 1st x in this line, so index 1
        pio := PointInOther(RightsPattern[y, 1], LeftsPattern[y]);
        if (pio > -1) then
        begin
          RemovePoint(1, RightsPattern[y]);
          RemovePoint(pio, LeftsPattern[y]);
        end;
      end;
    end;
  end;
end;

end.
