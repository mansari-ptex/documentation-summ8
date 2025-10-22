unit ImportKnife;

// NB This only works with the range checking on because it's all exception driven.  So...
{$R+}

interface

uses
  Classes, Controls, Forms, Windows, SysUtils, ExtCtrls, StdCtrls, Gauges,
  DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, KnifeSetDetails, General_Interlocking,
  ThdTimer, Summs;

type
  PCoord       = ^TPoint;
  NameArray    = array of string;
  IntArray     = array of integer;

  TfmKnifeImport = class(TForm)
    lblOk: TLabel;
    pnlMain: TPanel;
    Image: TImage;
    pbxGrid: TPaintBox;
    sbUpDown: TScrollBar;
    ggLoadProgress: TGauge;
    tmrShowHint: TThreadedTimer;
    tmrHideHint: TThreadedTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CreateKnifeInSet;
    procedure CreateSingleKnife;
    procedure pbxGridPaint(Sender: TObject);
    procedure DrawGrid;
    procedure MakeBitmaps;
    procedure pbxGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SelectPattern(Pos: TPoint; Create: Boolean);
    procedure SetScrollBar;
    procedure sbUpDownChange(Sender: TObject);
    procedure PassKnifeInfo(FileName, Code, Scale: string;
                            KnifeForm: TfmKnifeSetDetails;
                            KnifeType: string);
    procedure pbxGridDblClick(Sender: TObject);
    procedure OpenCad(CadFileName: string;
                      var StyleName: string;
                      var NumberOfPatterns: integer;
                      var AllPatts: TPointArray;
                      var NumberOfPointsArray: IntArray;
                      var PieceName: NameArray);
    procedure RemoveDuplicatePoints;
    procedure RemoveSlots;
    procedure adjverts;
    procedure CentrePattern;
    procedure FormCreate(Sender: TObject);
    procedure pbxGridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tmrShowHintTimer(Sender: TObject);
    procedure tmrHideHintTimer(Sender: TObject);
    procedure pbxGridMouseEnter(Sender: TObject);
  private
    { Private declarations }
    StyleName: string;
    NumberOfPatterns: integer;
    AllPatts: TPointArray;
    NumberOfPointsArray: IntArray;
    PieceName: NameArray;
    PreviousPoints: integer;
    Pattern: integer;
    KnifeCode, SizeScale, SQLString: string;
    BoxPos: TPoint;
    KnifeSetForm: TfmKnifeSetDetails;
    KnifeSet: boolean;
  public
    { Public declarations }
  end;

var
  fmKnifeImport: TfmKnifeImport;
  NumberOfPoints, NumberOfDrwPoints, xoffset, yoffset: integer;
  CoordList: Tlist;
  ACoord, BCoord: PCoord;
  FDSFile: file of byte;
//CJY Delphi 2009 became unicode. Explicitly defining the read string and char
//    to ANSI then converting it to Unicode when completed works around this.
//    The ReadLineStr has also been chonverted to ANSI
  SHMFile: File of ansichar;
  CadFile: TextFile;
  DrawingPattern, MyPatt, Patt: TPointArray;

const
  PATTERNSWIDE = 5;
  PATTERNSHIGH = 4;
  CELLWIDTH = 100;
  CELLHEIGHT = 100;
  LABELHEIGHT = 12;

implementation

uses
  Graphics, Dialogs, General, SelectKnifeSize, SummsVars, AdvErrorHandler,
  NewKnifeSet;

{$R *.DFM}

function Width(Patt: TPointArray;
               NumberOfPoints: integer):integer;
var
  i, max: integer;

begin
  max := 0;
  for i := 0 to NumberOfPoints - 1 do
   if abs(Patt[i].x) > max then
     max := abs(Patt[i].x);
  width := 2 * max;
end;

function Height(Patt: TPointArray;
                NumberOfPoints: integer): integer;
var
  i, max: integer;

begin
  max := 0;
  for i := 0 to NumberOfPoints - 1 do
    if abs(Patt[i].y) > max then
      max := abs(Patt[i].y);
  height := 2 * max;
end;

procedure SizeIt(left, top, right, bottom, NumberOfPoints: integer;
                 Patt: TPointArray;
                 var NumberOfDrwPoints: integer;
                 var DrawingPattern: TPointArray);

var
  i, PatternHeight, PatternWidth, RectWidth, RectHeight, XMargin, YMargin: integer;
  Ratio: real;

begin
  RectWidth := right - left;
  RectHeight := bottom - top;
  XMargin := round(RectWidth * 0.1);
  YMargin := round(RectHeight * 0.1);
  RectWidth := RectWidth - XMargin;
  RectHeight := RectHeight - YMargin;
  PatternHeight := Height(patt, NumberOfPoints);
  PatternWidth := Width(patt, NumberOfPoints);
  Ratio := RectWidth / PatternWidth;
  if (Ratio > RectHeight / PatternHeight) then
    Ratio := RectHeight / PatternHeight;

  NumberOfDrwPoints := NumberOfPoints + 1;
  SetLength(DrawingPattern, NumberOfDrwPoints);
  for i := 0 to NumberOfPoints - 1 do
  begin
    DrawingPattern[i].x := round(Patt[i].x * Ratio) + ((RectWidth + XMargin) div 2);
    DrawingPattern[i].y := round(Patt[i].y * Ratio) + ((RectHeight + YMargin) div 2);
  end;
  DrawingPattern[NumberOfDrwPoints - 1] := DrawingPattern[0];
end;

procedure DrawPattern(NumberOfPoints, XOffset, YOffset: integer;
                      var DrawingPattern: TPointArray);
var
  i:integer;

begin
  if (XOffset > 0) then
    for i := 0 to NumberOfPoints - 1 do
      DrawingPattern[i].x := DrawingPattern[i].x + XOffset;
  if (YOffset > 0) then
    for i := 0 to NumberOfPoints - 1 do
      DrawingPattern[i].y := DrawingPattern[i].y + YOffset;
end;

function PointTooClose: boolean;
const
  MinDist = 20;
var
  xDiff, yDiff: integer;

begin
  xDiff := ACoord^.x - BCoord^.x;
  yDiff := ACoord^.y - BCoord^.y;
  Result := (sqrt((xDiff * xDiff) + (yDiff * yDiff)) < MinDist);
end;

procedure TfmKnifeImport.RemoveDuplicatePoints;
var
  i: integer;

begin
  i := 0;
  repeat
    ACoord := CoordList.Items[i];
    BCoord := CoordList.Items[i + 1];
    if ((ACoord^.x = BCoord^.x) and (ACoord^.y = BCoord^.y)) or PointTooClose then
    begin
      Dispose(BCoord);
      CoordList.Delete(i + 1);
      NumberOfPoints := NumberOfPoints - 1;
    end
    else
      i := i + 1;
  until (i = NumberOfPoints - 1);
  ACoord := CoordList.Items[0];
  BCoord := CoordList.Items[NumberOfPoints - 1];
  if ((ACoord^.x = BCoord^.x) and (ACoord^.y = BCoord^.y)) or PointTooClose then
  begin
    Dispose(BCoord);
    CoordList.Delete(NumberOfPoints - 1);
    NumberOfPoints := NumberOfPoints - 1;
  end
end;

procedure TfmKnifeImport.RemoveSlots;
var
  answer, diff, dupe, i, j: integer;
  Current: PCoord;

begin
//RemoveSlots removed from this version. Can not thing of any reason why we
//would want to 'doctor' the origianl shapes now that we are using the new
//assessment routines
{
  j := 0;
  repeat
    Current := CoordList.Items[j];
    i := 0;
    repeat
      ACoord := CoordList.Items[i];
      if ((not(i = j)) and (Current^.x = ACoord^.x) and (Current^.y = ACoord^.y)) then
      begin
        diff := i - j;
        if NumberOfPoints - diff > diff then
          answer := j + 1
        else
          if i < NumberOfPoints - 1 then
            answer := NumberOfPoints - 1
          else
            answer := 0;

        if answer = 0 then
          dupe := NumberOfPoints - 2
        else
          dupe := answer - 1;

        if (i = numberofpoints - 1) and (j = 1) then
        begin
          dupe := 0;                        //has to be this way round 'cos if it deletes
          answer := numberofpoints - 1;     //the lower number first the higher number has become
        end;                                //one less by the time it's due to be deleted.
        CoordList.Delete(answer);
        CoordList.Delete(dupe);
        j := j - 1;
        NumberOfPoints := NumberOfPoints - 2;
      end;
      i := i + 1;
    until i >= NumberOfPoints;
    j := j + 1;
  until j = NumberOfPoints
}
end;

//CJY Delphi in 2009 became unicode. Explicitly defining the read string and char
//    to ANSI then converting it to Unicode when completed works around this.
//    The SHMFile has also been changed to File of ANSIChar
//    N.B. TStrings has the ability to import from a textfile (it'll attempt to
//    work out what format the file is and read the file as such)
procedure ReadLineStr(var MyString: string);
var
  MyANSIChar: AnsiChar;
  MyANSIString: AnsiString;
  Progress: real;

begin
  MyANSIString := '';
  repeat
    read(SHMFile, MyANSIChar);
    MyANSIString := MyANSIString + MyANSIChar;
  until (MyANSIChar = #10);
  MyANSIString := Trim(MyANSIString);
  Progress := (FilePos(SHMFile) / FileSize(SHMFile)) * 100;
  fmKnifeImport.ggLoadProgress.Progress := round(Progress);
  MyString := UnicodeString(MyANSIString);
end;

procedure ReadLineInt(var MyInt: integer);
var
  MyString: string;

begin
  ReadLineStr(MyString);
  MyInt := StrToInt(MyString);
end;

procedure ReadLineCoordinates(var x, y: LongInt);
var
  LengthStr, SpacePos: integer;
  MyString: string;

begin
  ReadLineStr(MyString);
  SpacePos := pos(' ', MyString);
  LengthStr := Length(MyString);
  x := StrToInt(copy(MyString, 1, SpacePos - 1));
  y := StrToInt(copy(MyString, SpacePos + 1, LengthStr - SpacePos))
end;

function GetByte: byte;
var
  TheByte: byte;

begin
  read(FDSFile, TheByte);
  GetByte := TheByte;
end;

function GetInteger: integer;
var
  first, second: integer;

begin
  first := GetByte;
  second := GetByte;
  second := second * 256;
  GetInteger := first + second;
end;

function GetReal: single;
var
  byte1, byte2, byte3, exponent: smallint;

begin
  byte3 := GetByte;
  byte2 := GetByte;
  byte1 := GetByte;
  exponent := GetByte;
  if (byte1 = 0) and (byte2 = 0) and (byte3 = 0) then
    GetReal := 0
  else
  begin
    exponent := ((exponent - 67) * 2) + 1;
    if (byte1 < 128) then
    begin
      byte1 := byte1 + 128;
      exponent := exponent - 1;
    end;
    GetReal := (byte1 * exp(ln(2) * exponent)) + (byte2 * exp(ln(2) * (exponent - 8))) +
               (byte3 * exp(ln(2) * (exponent-16)));
  end;
end;

procedure dummy(lngth: smallint);
var
  i: smallint;

begin
  if (lngth > 0) then
    for i := 2 to lngth + 1 do
      GetByte;
end;

procedure TfmKnifeImport.adjverts;
var
  i: integer;

begin
  for i := 0 to NumberOfPoints - 2 do
  begin
    ACoord := CoordList.Items[i];
    BCoord := CoordList.Items[i + 1];
    if (ACoord^.x = BCoord^.x) then
      ACoord^.x := ACoord^.x + 1;
  end
end;

procedure TfmKnifeImport.CentrePattern;

var
  i, maxx, minx, maxy, miny, xdiff, ydiff, xvector, yvector: integer;

begin
  ACoord := CoordList.Items[0];
  maxx := ACoord^.x;
  maxy := ACoord^.y;
  minx := ACoord^.x;
  miny := ACoord^.y;
  for i := 1 to NumberOfPoints - 1 do
  begin
    ACoord := CoordList.Items[i];
    if maxx < ACoord^.x then
      maxx := ACoord^.x;
    if minx > ACoord^.x then
      minx := ACoord^.x;
    if maxy < ACoord^.y then
      maxy := ACoord^.y;
    if miny > ACoord^.y then
      miny := ACoord^.y;
  end;
  xdiff := maxx - minx;
  ydiff := maxy - miny;
  xvector := minx + round(xdiff / 2);
  yvector := miny + round(ydiff / 2);
  for i := 0 to NumberOfPoints - 1 do
  begin
    ACoord := CoordList.Items[i];
    ACoord^.x := ACoord^.x - xvector;
    ACoord^.y := ACoord^.y - yvector;
  end;
end;

procedure TfmKnifeImport.OpenCad(CadFileName: string;
                                 var StyleName: string;
                                 var NumberOfPatterns: integer;
                                 var AllPatts: TPointArray;
                                 var NumberOfPointsArray: IntArray;
                                 var PieceName: NameArray);

var anint, away, i, j, k, JunkLimit, PointsAlready, x, y: integer;
    achar, filetype, junk: string;     //[20]
    astring, path: string;
    mychar: char;
    areal: real;
    notsvi, StopFlag: boolean;
    control, dbin, DigType, incontrol, lngth, temp: integer;
    rbin: real;
    code: byte;
    canvasrect: TRect;
    Progress: real;
    temp1: longint;
    temp2: integer;
    NotFDS: real;
    CADFILE2: File;
    NumRead: Integer;
    Buf: Char;

begin
  //Main try loop detects problems such as those which
  //occur when software THINKS it has detected the file
  //type but then does not find what it is expecting
  try
    screen.Cursor := crHourGlass;
    JunkLimit := 0;
    PointsAlready := 0;
    notsvi := false;
    filetype := '';
    stylename := '';
    xoffset := 0;
    yoffset := 0;
    numberofpatterns := 0;
    assignfile(CadFile, CadFileName);
    reset(CadFile);
    try
      //Looks for control characters other than line feed and return.
      //If some are found assumes it's FDS file for now.
      while not eof(CadFile) and not(filetype = 'FDS') do
      begin
        read(CadFile, myChar);
        if ((ord(mychar) > 0) and (ord(mychar) < 32)) and ((ord(mychar) <> 10) and (ord(mychar) < 13)) then
          filetype := 'FDS';
      end;

      closefile(CadFile);
      if (filetype <> 'FDS') then
      begin
        StyleName := '';
        AssignFile(CADFile2, CADFilename);
        Reset(CADFile2, 1);	{ Record size = 1 }
        repeat
          BlockRead(CADFile2, Buf, 1, NumRead);
          stylename := stylename + Buf;
        until (NumRead = 0);
        CloseFile(CADFile2);

        if (pos('DIGITISED', StyleName) = 0) then
        begin
          anint:=pos(#10, StyleName);
          if (anint > 0) then
          begin
            AssignFile(CADFile, CADFilename);
            reset(CADFile);
            for i := 1 to anint do
              read(CADFile, mychar);
            read(CADFile, numberofpatterns);
            CloseFile(CADFile);
          end;
          if (numberofpatterns > 0) and (Option_CadFiles) and (pos(#13, StyleName) = 0) then
            filetype := 'SHM';
        end
        else filetype := 'DIG';
      end;
    except
      on exception do
        filetype := 'Not Known';
    end;

    if (filetype <> 'FDS') and (filetype <> 'SHM') and (filetype <> 'Not Known') and
       (filetype <> 'DIG') and (Option_CadFiles) then
    begin
      assignfile(CadFile, CadFileName);
      reset(CadFile);
      try
        readln(CadFile, StyleName);
        readln(CadFile, NumberOfPatterns);
        if (eof(cadfile)) then
          filetype := 'Not Known'
        else
        begin
          readln(cadfile, achar);
          for i := 1 to 4 do
            readln(cadfile,anint);

          for i := 1 to anint do
          begin
            readln(cadfile, away, x, y);
            if (away > 2) then
              notsvi := true;
          end;
          if (anint > 0) then
            filetype := 'SVI'
          else if (numberofpatterns < 1) then
            filetype := 'VIC'
          else filetype := 'Not Known';

          if (notsvi) and (filetype = 'SVI') then
            filetype := 'Not Known';
        end;
      except
        on exception do
        begin
          CloseFile(CADFile);
          AssignFile(CADFile, CADFilename);
          reset(CadFile);
          try
            readln(CadFile, StyleName);
            readln(CadFile, NumberOfPatterns);
            for i := 1 to 2 do
              readln(cadfile, achar);
            for i := 1 to 8 do
              readln(cadfile, anint);
            filetype := 'VIC';
          except
            on exception do
            begin
              CloseFile(CADFile);
              AssignFile(CADFile, CADFilename);
              reset(CadFile);
              try
                readln(CadFile, StyleName);
                readln(CadFile, NumberOfPatterns);
                for i := 1 to 2 do
                  readln(cadfile, achar);
                readln(cadfile, anint);
                readln(cadfile, areal);
                filetype := 'CRI';
              except
                on exception do
                begin
                  CloseFile(CADFile);
                  AssignFile(CADFile, CADFilename);
                  reset(CadFile);
                  try
                    readln(CadFile, StyleName);
                    readln(CadFile, NumberOfPatterns);
                    for i := 1 to (NumberOfPatterns * 2) do
                      readln(cadfile, achar);
                    readln(cadfile, anint);
                    filetype := 'SHM';
                  except
                    on exception do
                      filetype := 'Not Known';
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
      closefile(CadFile);
    end;

    if (filetype = 'Not Known') or (filetype = '') then
    begin
      NumberOfPatterns := 0;
      messagedlg('Unknown File Type', mtInformation, [mbOk], 0);
    end
    else
    begin
      fmKnifeImport.ggLoadProgress.Progress := 0;
      fmKnifeImport.ggLoadProgress.visible := true;

      xoffset := 0;
      yoffset := 0;
      if (Filetype <> 'FDS') then
      begin
        try
          if (FileType <> 'SHM') then
          begin
            assignfile(CadFile, CadFileName);
            reset(CadFile);
            readln(CadFile, StyleName);
            readln(CadFile, NumberOfPatterns);
          end
          else
          begin
            assignfile(SHMFile, CadFileName);
            reset(SHMFile);
            ReadLineStr(StyleName);
            ReadLineInt(NumberOfPatterns);
          end;
        except
          on Exception do
          begin
            FileType := 'Not Known';
            NumberOfPatterns := 0;
          end;
        end;

        if Filetype = 'VIC' then
          JunkLimit := 9;
        if Filetype = 'CRI' then
          JunkLimit := 7;     {0,0 centre}
        if (filetype = 'SVI') or (filetype = 'SHM') or (filetype = 'DIG') then
          JunkLimit := 0;     {0,0 centre}

        try
          if (filetype <> 'SVI') then
          begin
            SetLength(PieceName, NumberOfPatterns);
            for i := 0 to NumberOfPatterns - 1 do
            begin
              if (FileType = 'SHM') then
              begin
                ReadLineStr(PieceName[i]);
                ReadLineStr(junk);
              end
              else
                readln(CadFile, PieceName[i]);

              for j := 1 to JunkLimit do
                readln(CadFile, junk);   {1st 'junk' used to be siwidth}
            end;
          end;
        except
          on Exception do
          begin
            FileType := 'Not Known';
            NumberOfPatterns := 0;
          end;
        end;
        i := -1;
        SetLength(PieceName, NumberOfPatterns);
        SetLength(NumberOfPointsArray, NumberOfPatterns);
        try
          repeat
            inc(i);
            CoordList := Tlist.Create;
            if (filetype = 'SVI') then
              readln(CadFile, PieceName[i]);

            PieceName[i] := uppercase(trim(PieceName[i]));
            if (filetype <> 'SHM') then
            begin
              for j := 1 to 3 do
                readln(CadFile, junk);
              readln(CadFile, NumberOfPoints);
            end
            else
              ReadLineInt(NumberOfPoints);

            if (NumberOfPoints > 0) then
            begin
              for j := 1 to NumberOfPoints do
              begin
                New(ACoord);
                if (filetype = 'SVI') then
                begin
                  readln(CadFile, away, ACoord^.x, ACoord^.y);
                  ACoord^.x := round(ACoord^.x * 1.016);
                  ACoord^.y := round(ACoord^.y * 1.016)
                end
                else if (FileType = 'SHM') then
                  ReadLineCoordinates(ACoord^.x, ACoord^.y)
                else
                  readln(CadFile, ACoord^.x, ACoord^.y);
                CoordList.Add(ACoord);
              end;
             {clockwise;  ensure that all pattern procedures are independant of direction}
              RemoveDuplicatePoints;
              RemoveSlots;
              adjverts;
              CentrePattern;

              SetLength(MyPatt, NumberOfPoints);
              for k := 0 to NumberOfPoints - 1 do
              begin
                ACoord := CoordList.Items[k];
                MyPatt[k].x := ACoord^.x;
                MyPatt[k].y := ACoord^.y;
                Dispose(ACoord);
              end;
    //FILTER WAS HERE
              SetLength(AllPatts, PointsAlready + NumberOfPoints);
              for k := 0 to NumberOfPoints - 1 do
                AllPatts[PointsAlready + k] := MyPatt[k];
              PointsAlready := PointsAlready + NumberOfPoints;
              NumberOfPointsArray[i] := NumberOfPoints;
              CoordList.Free;
            end
            else
            begin
              MessageDlg('Zero points in knife' + piecename[i] + ' - ' + #13 + 'Knife ignored', mtInformation, [mbOk], 0);
              for k := i to NumberOfPatterns - 1 do
                piecename[k] := piecename[k + 1];
              NumberOfPatterns := NumberOfPatterns - 1;
              dec(i);
            end;

            if (FileType <> 'SHM') then
            begin
              temp1 := filepos(cadfile);
              temp2 := filesize(cadfile);
              if (temp2 = 0) then
                progress := 100
              else
                Progress := (temp1 / temp2) * 100;
              fmKnifeImport.ggLoadProgress.Progress := round(Progress);
            end;
          until (i = NumberOfPatterns - 1);
        except
          on Exception do
          begin
            if not(CoordList = nil) then
            begin
              if CoordList.Count > 0 then
              begin
                for i := 0 to CoordList.Count do
                begin
                  ACoord := CoordList.Items[i];
                  Dispose(ACoord);
                end;
              end;
              CoordList.Free;
            end;

            FileType := 'Not Known';
            NumberOfPatterns := 0;
          end;
        end;

        if (FileType = 'DIG') then
          readln(CadFile, DigType);

        fmKnifeImport.ggLoadProgress.visible := false;

        if (FileType = 'SHM') then
          closefile(SHMFile)
        else
          closefile(CadFile);
      end
      else                       {fds here}
      begin
        AssignFile(FDSFile, CADFileName);
        reset(FDSFile);
        try
          CoordList := TList.Create;
          StyleName := '';
          NumberOfPatterns := 0;
          NumberOfPoints := 0;
          StopFlag := false;
          code := GetByte;
          lngth := GetByte;
          dbin := GetInteger;
          dbin := GetInteger;

          for i := 6 to 20 do
            temp := GetByte;

          for i := 21 to 53 do
          begin
            temp := GetByte;
            if ((temp > 31) and (temp < 128)) then
              StyleName := concat(StyleName, chr(temp));
          end;
          stylename := uppercase(trim(stylename));
          dbin := GetInteger;    {number of pieces}

          SetLength(PieceName, dbin);
          for i := 0 to dbin - 1 do
            PieceName[i] := '';

          repeat
            code := GetByte;
            lngth := GetByte;
            case code of
              1 : begin
                    if (NumberOfPatterns > 0) then
                    begin
                      RemoveDuplicatePoints;
                      RemoveSlots;
                      adjverts;
                      if (NumberOfPoints > 3) then
                      begin
                        CentrePattern;

                        SetLength(MyPatt, NumberOfPoints);
                        for i := 0 to NumberOfPoints - 1 do
                        begin
                          ACoord := CoordList.Items[i];
                          MyPatt[i].x := ACoord^.x;
                          MyPatt[i].y := ACoord^.y;
                          Dispose(ACoord);
                        end;
  //FILTER WAS HERE
                        SetLength(AllPatts, PointsAlready + NumberOfPoints);
                        for i := 0 to NumberOfPoints - 1 do
                          AllPatts[PointsAlready + i] := MyPatt[i];
                        PointsAlready := PointsAlready + NumberOfPoints;
                        SetLength(NumberOfPointsArray, NumberOfPatterns);
                        NumberOfPointsArray[NumberOfPatterns - 1] := NumberOfPoints;

                        CoordList.Free;
                        NumberOfPatterns := NumberOfPatterns + 1;
                        CoordList := TList.Create;
                      end
                      else
                      begin
                        MessageDlg('Too few points in knife ' + piecename[NumberOfPatterns - 1] + ' - ' + #13 + 'Knife ignored', mtInformation, [mbOk], 0);
                        PieceName[NumberOfPatterns - 1] := '';
                      end;
                      NumberOfPoints := 0;
                    end
                    else
                      NumberOfPatterns := 1;
                  end;

              2 : begin      {fetch point data}
                    control := getinteger;
                    x := round(getreal);
                    y := round(getreal);
                    incontrol := control mod 2;
                    if ((control > 0) and (incontrol = 1)) then
                    begin
                      if (StopFlag = true) then
                      begin
                        for i := 0 to CoordList.Count - 1 do
                        begin
                          ACoord := CoordList.Items[i];
                          Dispose(ACoord);
                        end;
                        NumberOfPoints := 0;
                        CoordList.Free;
                        CoordList := TList.Create;
                      end;
                      StopFlag := false;
                      NumberOfPoints := NumberOfPoints + 1;
                      New(ACoord);
                      ACoord^.x := x;
                      ACoord^.y := y;
                      CoordList.Add(ACoord);
                    end
                    else
                    begin
                      if (NumberOfPoints > 0) then
                      begin
                        ACoord := CoordList.Items[NumberOfPoints - 1];
                        if (abs(x - ACoord^.x) > 5) or (abs(y - ACoord^.y) > 5) then
                          StopFlag := true;
                      end;
                    end;
                  end;

     3, 7, 8, 9 : begin
                    GetInteger;
                    GetInteger;
                    GetInteger;
                    for i := 8 to lngth + 1 do
                    begin
                      temp := GetByte;
                      if (code = 8) and (temp > 31) then
                        PieceName[NumberOfPatterns - 1] := concat(PieceName[NumberOfPatterns - 1], chr(temp));
                    end;
                    if (code = 8) then
                      PieceName[NumberOfPatterns - 1] := uppercase(trim(PieceName[NumberOfPatterns - 1]));
                  end;

              4 : begin
                    RemoveDuplicatePoints;
                    RemoveSlots;
                    adjverts;
                    if (NumberOfPoints > 3) then
                    begin
                      CentrePattern;

                      SetLength(MyPatt, NumberOfPoints);
                      for i := 0 to NumberOfPoints - 1 do
                      begin
                        ACoord := CoordList.Items[i];
                        MyPatt[i].x := ACoord^.x;
                        MyPatt[i].y := ACoord^.y;
                        Dispose(ACoord);
                      end;
  //FILTER WAS HERE
                      SetLength(AllPatts, PointsAlready + NumberOfPoints);
                      for i := 0 to NumberOfPoints - 1 do
                        AllPatts[PointsAlready + i] := MyPatt[i];
                      PointsAlready := PointsAlready + NumberOfPoints;
                      SetLength(NumberOfPointsArray, NumberOfPatterns);
                      NumberOfPointsArray[NumberOfPatterns - 1] := NumberOfPoints;

                      CoordList.Free;
                    end
                    else
                    begin
                      for i := 0 to CoordList.Count - 1 do
                      begin
                        ACoord := CoordList.Items[i];
                        Dispose(ACoord);
                      end;
                      CoordList.Free;
                      MessageDlg('Too few points in knife ' + piecename[NumberOfPatterns - 1] + ' - ' + #13 + 'Ignoring knife', mtInformation, [mbOk], 0);
                      PieceName[NumberOfPatterns - 1] := '';
                      NumberOfPatterns := NumberOfPatterns - 1;
                    end;
                  end;

             23 : begin
                    for i := 2 to 35 do
                    begin
                      temp := GetByte;
                      if (temp > 31) then
                        PieceName[NumberOfPatterns - 1] := concat(PieceName[NumberOfPatterns - 1], chr(temp));
                    end;
                    for i := 36 to 47 do
                      temp := GetByte;
                    rbin := GetReal;
                    rbin := GetReal;
                    rbin := GetReal;
                    rbin := GetReal;
                    PieceName[NumberOfPatterns - 1] := uppercase(trim(PieceName[NumberOfPatterns - 1]));
                  end;
             else
               dummy(lngth);
            end;

            Progress := (FilePos(FDSFile) / FileSize(FDSFile)) * 100;
            fmKnifeImport.ggLoadProgress.Progress := round(Progress);
          until (code = 5);

          //FDS file reader will happily read almost anything - e.g. exe files without crashing.
          //Empty arrays are then passed through and the program crashes later.  The next line prevents
          //this by forcing the inevitable "Floating point divide by zero error" to occur here and
          //trigger the exception.
          //We can't do this properly because we don't have any documentation to tell us the FDS file spec.
          NotFDS := 10 / NumberOfPointsArray[NumberOfPatterns - 1];

          CloseFile(FDSFile);
        except
          on E: Exception do
          begin
            CloseFile(FDSFile);
            NumberOfPatterns := 0;
            fmErrorHandler.DebugMessageDlg('Unknown File Type', E.Message, '');
          end;
        end;
      end;

      fmKnifeImport.ggLoadProgress.visible := false;
    end;
  except
    //Thinks it has detected the file type
    //but has it wrong and an error occurs
    FileType := 'Not Known'
  end;

  if FileType = 'Not Known' then
  begin
    NumberOfPatterns := 0;
    MessageDlg('Unknown File Type', mtError, [mbOK], 0);
  end;

  screen.cursor := crDefault;
end;

procedure TfmKnifeImport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if KnifeSet then
  begin
    KnifeSetForm.btnAddSize.Enabled := True;
    KnifeSetForm.btnRemoveSize.Enabled := True;
  end;

  action := caFree;
end;

procedure TfmKnifeImport.CreateKnifeInSet;
var
  i: integer;
  s, sx, sy: string;

begin
  PreviousPoints := 0;
  for i := 0 to Pattern - 1 do
    PreviousPoints := PreviousPoints + NumberOfPointsArray[i];

  //Create query and execute
  SQLString := 'INSERT INTO Knives (Code, SizeScale, MeasuredSize, Seq, ToBeAssessed, ImportFilename, Piecename, Angle) ' +
               'SELECT ''' + QS(KnifeCode) + ''', ''' + QS(SizeScale) + ''', ''' +
                QS(fmSelectKnifeSize.cbMeasuredSize.Text) + ''', Seq, TRUE, ''' +
                QS(KnifeFileName) + ''', ''' + QS(PieceName[Pattern]) + ''', 0' +
               ' FROM SizeScaleSizes' +
               ' WHERE Scale = ''' + QS(SizeScale) + ''' AND Size = ''' + QS(fmSelectKnifeSize.cbMeasuredSize.Text) + '''; ';

  for i := 0 to NumberOfPointsArray[Pattern] - 1 do
  begin
    str(i, s);
    str(AllPatts[i + PreviousPoints].x, sx);
    str(AllPatts[i + PreviousPoints].y, sy);
    SQLString := SQLString + #13 + 'INSERT INTO Patterns (Knife, Seq, X, Y, SizeScale, MeasuredSize) VALUES(''' + QS(KnifeCode) +
                 '''' + ', ' + s + ', ' + sx + ', ' + sy +', ''' + SizeScale + ''', ''' + QS(fmSelectKnifeSize.cbMeasuredSize.Text) + '''); ';
  end;

  if not(KnifeSetForm.sgKnives.Cells[0, KnifeSetForm.sgKnives.RowCount - 1] = '') then
    KnifeSetForm.sgKnives.RowCount := KnifeSetForm.sgKnives.RowCount + 1;

  i := KnifeSetForm.sgKnives.RowCount - 1;
  KnifeSetForm.sgKnives.Cells[0, i] := QS(fmSelectKnifeSize.cbMeasuredSize.Text);
  KnifeSetForm.sgKnives.Cells[1, i] := '0.000';
  KnifeSetForm.sgKnives.Cells[2, i] := '0.000';
  KnifeSetForm.sgKnives.Cells[3, i] := '0.000';
  KnifeSetForm.sgKnives.Cells[4, i] := 'No';
  KnifeSetForm.sgKnives.Cells[5, i] := '0.0';
  KnifeSetForm.sgKnives.Cells[6, i] := SQLString;
  KnifeSetForm.RowNo := KnifeSetForm.sgKnives.RowCount - 1;
  KnifeSetForm.sgKnives.Row := KnifeSetForm.RowNo;
end;

procedure TfmKnifeImport.CreateSingleKnife;
var
  i: integer;

begin
  //Set variables on New knife form for this file and piece
  fmNewKnifeSet.Single := True;
  fmNewKnifeSet.Manual := False;
  fmNewKnifeSet.Auto := False;  
  ToBeAssessed := True;
  ImportFilename := KnifeFileName;
  ImportPiecename := PieceName[Pattern];
  ImportPoints := NumberOfPointsArray[Pattern];

  PreviousPoints := 0;
  for i := 0 to Pattern - 1 do
    PreviousPoints := PreviousPoints + NumberOfPointsArray[i];

  for i := 0 to NumberOfPointsArray[Pattern] - 1 do
  begin
    SetLength(ImportPatterns, NumberOfPointsArray[Pattern]);
    ImportPatterns[i].x := AllPatts[i + PreviousPoints].x;
    ImportPatterns[i].y := AllPatts[i + PreviousPoints].y;
  end;

  fmNewKnifeSet.eSizeScale.Text := KnifeSizeScale;
  fmNewKnifeSet.eNewKnifeCode.text := FirstNChars(ImportPieceName, 20);
  fmNewKnifeSet.Height := fmNewKnifeSet.CreatedFormHeight;
  fmNewKnifeSet.ShowModal;
end;

procedure TfmKnifeImport.DrawGrid;
begin
  image.picture.bitmap.Canvas.Brush.Color := OurColor(clAqua);
  pbxGrid.canvas.draw(0, -sbUpDown.position, image.picture.bitmap);
end;

procedure TfmKnifeImport.pbxGridPaint(Sender: TObject);
begin
  DrawGrid;
end;

procedure TfmKnifeImport.MakeBitmaps;
var
  i, j, PreviousPoints, NumberOfDrwPoints: integer;
  XOffset, YOffset: integer;
  TextRect: TRect;
  AnotherLine: integer;

begin
  pbxGrid.OnPaint := pbxGridPaint;
  PreviousPoints := 0;
  image.picture.bitmap.Canvas.pen.width := 1;
  image.picture.bitmap.width := CELLWIDTH * PATTERNSWIDE + 1;
  if (NumberOfPatterns mod PATTERNSWIDE) > 0 then
    AnotherLine := 1
  else
    AnotherLine := 0;
  image.picture.bitmap.height := ((NumberOfPatterns div PATTERNSWIDE) + AnotherLine) * CELLHEIGHT + 1;
  image.picture.bitmap.Canvas.Brush.Color := clHide;

  for i := 0 to NumberOfPatterns - 1 do
  begin
    SetLength(Patt, PreviousPoints + NumberOfPointsArray[i]);
    for j := 0 to NumberOfPointsArray[i] - 1 do
      Patt[j] := AllPatts[j + PreviousPoints];

    //Converts large pattern to cell size
    SizeIt(1, 1, CELLWIDTH - LABELHEIGHT, CELLHEIGHT - LABELHEIGHT,
           NumberOfPointsArray[i], Patt, NumberOfDrwPoints, DrawingPattern);

    //Adjust to windows cordinates
    for j := 0 to NumberOfDrwPoints - 1 do
      DrawingPattern[j].y := (CELLHEIGHT - LABELHEIGHT) - DrawingPattern[j].y;

    //Add Offsets
    XOffset := ((i mod PATTERNSWIDE) * CELLWIDTH);
    YOffset := (i div PATTERNSWIDE) * CELLHEIGHT;
    DrawPattern(NumberOfDrwPoints, XOffset + LABELHEIGHT, YOffset + LABELHEIGHT, DrawingPattern);

    //Display bounding rectangle for Pattern
    image.picture.bitmap.Canvas.pen.color := OurColor(clFuchsia);
    image.picture.bitmap.Canvas.Rectangle(XOffset, YOffset, XOffset + CELLWIDTH + 1, YOffset + CELLHEIGHT + 1);

    //Display Pattern
    image.picture.bitmap.Canvas.pen.color := clCut;
    image.picture.bitmap.Canvas.Polyline(DrawingPattern);

    PreviousPoints := PreviousPoints + NumberOfPointsArray[i];

    //Display Pattern Name
    TextRect.Top := YOffset + 1;
    TextRect.Left := XOffset + 1;
    TextRect.Bottom := YOffset + LABELHEIGHT + 1;
    TextRect.Right := XOffset + CELLWIDTH;
    image.picture.bitmap.Canvas.font.color := OurColor(clWindowText);
//    image.picture.bitmap.Canvas.font.Style := [fsBold];
    image.picture.bitmap.canvas.TextRect(TextRect, XOffset + 1, YOffset + 1, PieceName[i]);
  end;
end;

procedure TfmKnifeImport.pbxGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

begin
  BoxPos.X := x;
  BoxPos.Y := y;
end;

procedure TfmKnifeImport.pbxGridMouseEnter(Sender: TObject);
begin
  pbxGrid.Hint := '';
end;

procedure TfmKnifeImport.tmrHideHintTimer(Sender: TObject);
begin
  tmrHideHint.Enabled := False;
  Application.CancelHint;
end;

procedure TfmKnifeImport.tmrShowHintTimer(Sender: TObject);
var
  P: TPoint;

begin
  GetCursorPos(P);
  Application.ActivateHint(P);
  tmrShowHint.Enabled := False;
  tmrHideHint.Enabled := True;
end;

procedure TfmKnifeImport.pbxGridMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  PatternRow, PatternCol: integer;
  P: TPoint;

begin
  PatternCol := ((X - 1) div CELLWIDTH);
  PatternRow := (((Y + sbUpDown.position) - 1) div CELLHEIGHT);

  Pattern := (PatternRow * PATTERNSWIDE) + PatternCol;
  if (Pattern < NumberOfPatterns) then
  begin
    if not(pbxGrid.Hint = PieceName[Pattern]) then
    begin
      Application.CancelHint;
      pbxGrid.Hint := PieceName[Pattern];
      tmrShowHint.Enabled := False;
      tmrHideHint.Enabled := False;
      tmrShowHint.Enabled := True;
    end;
  end
  else
  begin
    tmrShowHint.Enabled := False;
    tmrHideHint.Enabled := False;
    Application.CancelHint;
  end;
end;

procedure TfmKnifeImport.SelectPattern(Pos: TPoint; Create: Boolean);
var
  PatternRow, PatternCol: integer;

begin
  PatternCol := ((Pos.x - 1) div CELLWIDTH);
  PatternRow := (((Pos.y + sbUpDown.position) - 1) div CELLHEIGHT);

  Pattern := (PatternRow * PATTERNSWIDE) + PatternCol;
  if Create and (Pattern <= NumberOfPatterns - 1) then
    if KnifeSet then
      CreateKnifeInSet
    else
      CreateSingleKnife;
end;

procedure TfmKnifeImport.SetScrollBar;
var
  NoRows: integer;
  PixelsOffScreen: integer;

begin
  NoRows := ((NumberOfPatterns - 1) div PATTERNSWIDE) + 1;
  PixelsOffScreen := (NoRows * CELLHEIGHT) - (PATTERNSHIGH * CELLHEIGHT);
  if PixelsOffScreen > 0 then
  begin
    sbUpDown.enabled := true;
    sbUpDown.Max := PixelsOffScreen;
  end;
end;

procedure TfmKnifeImport.sbUpDownChange(Sender: TObject);
begin
  DrawGrid;
end;

procedure TfmKnifeImport.PassKnifeInfo(FileName, Code, Scale: string;
                                       KnifeForm: TfmKnifeSetDetails;
                                       KnifeType: string);
var
  JustFileName: string;
  Auto, Opened: boolean;
  i: integer;

begin
  Auto := False;
  KnifeSet := (KnifeType = 'Set');
  KnifeCode := Code;
  SizeScale := Scale;
  KnifeFilename := ExtractFileName(Filename);
  if KnifeType = 'Set' then
  begin
    KnifeSetForm := KnifeForm;
    Caption := 'Pattern File: ' + ExtractFileName(FileName) + ' for Knife: ' + Code;
  end
  else if KnifeType = 'Single' then
    Caption := 'Pattern File: ' + ExtractFileName(FileName) + ' for Single Knives'
  else
  begin
    Caption := 'Pattern File: ' + ExtractFileName(FileName) + '(Auto)';
    pbxGrid.OnDblClick := nil;
    Auto := True;
  end;

  {Draw Blank Grid so Coloured whilst loading
   and refresh buttons so visible whilst loading}
  DrawGrid;
  sbUpDown.refresh;

  if FileExists(FileName) then
  begin
    OpenCad(FileName, StyleName, NumberOfPatterns, AllPatts,
            NumberOfPointsArray, PieceName);

    MakeBitmaps;
    DrawGrid;
    SetScrollBar;
    Opened := True;
  end
  else
  begin
    MessageDlg('Illegal File name', mtInformation, [mbAbort], 0);
    Opened := False;
    close;
  end;

  if Opened and Auto then
  begin
    AutoRec.NoPatts := NumberOfPatterns;
    AutoRec.Patts := AllPatts;
    SetLength(AutoRec.PointsInPatts, NumberOfPatterns);
    for i := 0 to NumberOfPatterns - 1 do
      AutoRec.PointsInPatts[i] := NumberOfPointsArray[i];
    fmNewKnifeSet.Single := False;
    fmNewKnifeSet.Manual := False;
    fmNewKnifeSet.Auto := True;

    JustFileName := ExtractFileName(FileName);
    JustFileName := copy(JustFileName, 0, Length(JustFileName) - 4);
    fmNewKnifeSet.eSizeScale.Text := '';
    fmNewKnifeSet.eNewKnifeCode.text := FirstNChars(JustFileName, 20);
    fmNewKnifeSet.Height := fmNewKnifeSet.CreatedFormHeight;
    fmNewKnifeSet.ShowModal;
    close;
  end;
end;

procedure TfmKnifeImport.pbxGridDblClick(Sender: TObject);
var
  SuggestedSize: string;
  FoundSize, FoundSetSize: Boolean;
  i: integer;

begin
  Application.CancelHint;
  if KnifeSet then
  begin
    SelectPattern(BoxPos, False);
    fmSelectKnifeSize.cbMeasuredSize.Items := KnifeSetForm.AvailableSizes;
    fmSelectKnifeSize.cbMeasuredSize.ItemIndex := 0;

    //See if Piecename is a valid size and
    //if so automatically select that size
    SuggestedSize := PieceName[Pattern];
    FoundSize := False;
    FoundSetSize := False;
    for i := 0 to fmSelectKnifeSize.cbMeasuredSize.Items.Count - 1 do
    begin
      if fmSelectKnifeSize.cbMeasuredSize.Items[i] = SuggestedSize then
        FoundSize := True;
      if fmSelectKnifeSize.cbMeasuredSize.Items[i] = NextSetSize then
        FoundSetSize := True;
    end;

    if FoundSize then
      fmSelectKnifeSize.cbMeasuredSize.Text := SuggestedSize
    else if FoundSetSize then
      fmSelectKnifeSize.cbMeasuredSize.Text := NextSetSize;

    fmSelectKnifeSize.ShowModal;

    if fmSelectKnifeSize.ModalResult = mrOK then
    begin
      SelectPattern(BoxPos, True);
      KnifeSetForm.AvailableSizes.Delete(KnifeSetForm.AvailableSizes.IndexOf(fmSelectKnifeSize.cbMeasuredSize.Text));
      //removes sizes from selection as they are used.
    end;
  end
  else
    SelectPattern(BoxPos, True);
end;

procedure TfmKnifeImport.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

//Switch Range checking off again.
{$R-}

end.
