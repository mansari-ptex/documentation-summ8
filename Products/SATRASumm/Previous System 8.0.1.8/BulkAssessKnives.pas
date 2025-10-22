unit BulkAssessKnives;

//Interlocks Knifes
//tblKnivesAssessedVersion shows version used to Assess the knife
//6  SATRASumm 6.x (Toms original routines)
//7  SATRASumm 7.0 (New interlocking engine)
//71 SATRASumm 7.1 (Fixes to expand multiple ghosts and in both directions,
//                  New merge routine included too.)
//Flag on Knife form can be set to reassess any knife that
//was assessed with any previous interlocking engine.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, CButton, 
  ToolWin, ComCtrls, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,   Interlocking, Results,
  Const_Interlocking, General_Interlocking, Merge, Math, FastGeo, Concavities,
  Grids, DBGridPlus, AdvErrorHandler, CmnVars, General, SummsVars, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, Vcl.DBGrids, FDConnectionPlus;

type
  TAssessResult = record
    Assessed: Boolean;
    NettArea: real;
    GrossArea: real;
    PrimeInterlockArea: real;
    NonPrimeInterlockArea: real;
  end;

  TfmAssessKnives = class(TForm)
    pnlKnives: TPanel;
    LocalConnectionSumms: TFDConnectionPlus;
    qPatterns: TFDQueryPlus;
    qPatternsKnife: TStringField;
    qPatternsSeq: TSmallintField;
    qPatternsX: TSmallintField;
    qPatternsY: TSmallintField;
    dsKnives: TDataSource;
    dbgKnives: TDBGridPlus;
    tbMain: TPanel;
    btnStart: TSpeedButton;
    btnCancel: TSpeedButton;
    btnRefresh: TSpeedButton;
    pnlImage: TPanel;
    imgInterlock: TImage;
    qSaveInterlocks: TFDQueryPlus;
    StringField1: TStringField;
    SmallintField1: TSmallintField;
    SmallintField2: TSmallintField;
    SmallintField3: TSmallintField;
    tblKnifeSets: TFDTablePlus;
    tblKnifeSetsCode: TStringField;
    tblKnifeSetsDescription: TStringField;
    tblKnifeSetsCutGap: TSmallintField;
    tblKnifeSetsType: TStringField;
    tblKnives: TFDTablePlus;
    tblKnivesCode: TStringField;
    tblKnivesMeasuredSize: TStringField;
    tblKnivesSizeScale: TStringField;
    tblKnivesGrossArea: TFloatField;
    tblKnivesNettArea: TFloatField;
    tblKnivesInterlockAreaPrimeSynthetic: TFloatField;
    tblKnivesInterlockAreaNonPrime: TFloatField;
    tblKnivesToBeAssessed: TBooleanField;
    tblKnivesImportFilename: TStringField;
    tblKnivesPiecename: TStringField;
    tblKnivesAssessedVersion: TSmallintField;
    tblKnivesToleranceUsed: TIntegerField;
    tblKnivesSeq: TFloatField;
    tblKnivesKnifeSetType: TStringField;
    qKnives: TFDQueryPlus;
    qKnivesCode: TStringField;
    qKnivesSizeScale: TStringField;
    qKnivesMeasuredSize: TStringField;
    qKnivesGrossArea: TFloatField;
    qKnivesNettArea: TFloatField;
    qKnivesInterlockAreaPrimeSynthetic: TFloatField;
    qKnivesInterlockAreaNonPrime: TFloatField;
    qKnivesToBeAssessed: TBooleanField;
    qKnivesImportFilename: TStringField;
    qKnivesPiecename: TStringField;
    qKnivesAssessedVersion: TSmallintField;
    qKnivesToleranceUsed: TIntegerField;
    qKnivesSeq: TFloatField;
    procedure UpdateResults(Interlock: TInterlock; Knife2: TPattern);
    procedure DisplayResults;
    function ReadPattern(Code, Size: string): TPointArray;
    procedure FormCreate(Sender: TObject);
    function LeatherInterlocking: TAssessResult;
    procedure SetCutResultsColour;
    procedure MakeClearCanvas;
    function AssessKnife: TAssessResult;
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    function SaveInterlocks: Boolean;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    function OverlappingHulls: Boolean;
  private
  public
    { Public declarations }
    Assessing: Boolean;
  end;

var
  fmAssessKnives: TfmAssessKnives;
  OriginalPoints: TPointArray;
  AbortAssessing: Boolean;

implementation

uses PolygonOverlaps, Summs;

{$R *.dfm}

procedure TfmAssessKnives.UpdateResults(Interlock: TInterlock; Knife2: TPattern);
var
  MergedPattern: TPointArray;
  OriginalPos, GhostPos: TPoint;
  ShapeNoToGhost: integer;
  InterlockToGhost: TInterlock;
  Direction, GhostNo: integer;
  EnoughGhosts: Boolean;

begin
  //Add to Results
  AddToResults(Interlock, False, Knife2.W2, False, True);
  NewKnife := False;

  //Merge ready to continue
  MergedPattern := MergePatterns(Knife, Knife2, Interlock, False).Points;
  Knife := CreatePattern(MergedPattern, 0, 0, False, False);

  //Possible Ghosts
  if (not Knife2.W2) then
  begin
    //Shape to ghost
    ShapeNoToGhost := Length(CutResults) - 1;
    InterlockToGhost := Interlock;

    //We have to go in both directions because since we are looking for
    //biggest 'hull on hull' overlap we sometimes get 'other side' interlocks
    //and the original one is the 'wrong' side of the interlocked knife.
    //This is perfectly ok as it is always symetrical as we are in W1
    //situation here. It is very difficult to find the biggest hull on hull
    //which is always the right way around. It does not really matter as all
    //that happens is occasionally we get a few extra '-ve' ghosts on
    //'boomerang' shaped patterns. Since this shape pattern only accounts for
    //a small proportion of total patterns, this minor overhead is perfectly
    //acceptable.
    for Direction := 1 to 2 do
    begin
      GhostNo := 0;
      EnoughGhosts := False;
      while not EnoughGhosts do
      begin
        //Position the ghosted shape...
        if Direction = 1 then
          inc(GhostNo)
        else
          dec(GhostNo);
        Interlock := InterlockToGhost;
        GhostPos := GhostPosition(Interlock.Knife1BoundingRect, ShapeNoToGhost, GhostNo);

        OriginalPos.x := Interlock.Knife2BoundingRect.Left;
        OriginalPos.y := Interlock.Knife2BoundingRect.Top;
        Interlock.Knife2BoundingRect.Left := GhostPos.x;
        Interlock.Knife2BoundingRect.Top := GhostPos.y;
        Interlock.Knife2BoundingRect.Right := Interlock.Knife2BoundingRect.Right + GhostPos.x - OriginalPos.x;
        Interlock.Knife2BoundingRect.Bottom := Interlock.Knife2BoundingRect.Bottom + GhostPos.y - OriginalPos.y;

        {$IFDEF DEBUGFULL}
        Interlock.ConvexHull1 := MakeConvexHull(Knife.ExpandedPoints);
        {$ENDIF}

        //...& Add to Results
        AddToResults(Interlock, False, False, True, False);

        //Merge (the ghost) ready to continue
        MergedPattern := MergePatterns(Knife, Knife2, Interlock, True).Points;
        Knife := CreatePattern(MergedPattern, 0, 0, False, False);

        //Always include 1 more in either direction as even if another W1
        //ghost wont fit, a proper W2 might get in there.
        if not OverlappingHulls then
          EnoughGhosts := True;
      end;
    end;
  end;
end;

procedure TfmAssessKnives.DisplayResults;
var
  ClipRect: TRect;
  bmpResults: TBitmap;
  i, minx, miny, maxx, maxy: integer;
  InterlockHeight, InterlockWidth, InterlockXOffset, InterlockYOffset: integer;
  SquareSize: integer;
  BigSquareSize: real;

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

  ClipRect.Left := minx;
  ClipRect.Top := miny;
  ClipRect.Right := maxx;
  ClipRect.Bottom := maxy;

  InterlockHeight := ClipRect.Bottom - ClipRect.Top;
  InterlockWidth := ClipRect.Right - ClipRect.Left;
  SquareSize := max(InterlockHeight, InterlockWidth);

  if SquareSize < min(imgInterlock.Height, imgInterlock.Width) then
    SquareSize := min(imgInterlock.Height, imgInterlock.Width);

  BigSquareSize := 1.1 * SquareSize;

  InterlockXOffset := 0;
  InterlockYOffset := 0;
  if InterlockWidth < SquareSize then
    InterlockXOffset := (SquareSize - InterlockWidth) div 2;
  if InterlockHeight < SquareSize then
    InterlockYOffset := (SquareSize - InterlockHeight) div 2;
  InterlockXOffset := InterlockXOffset + ((round(BigSquareSize) - SquareSize) div 2);
  InterlockYOffset := InterlockYOffset + ((round(BigSquareSize) - SquareSize) div 2);

  bmpResults := TBitmap.Create;
  bmpResults.PixelFormat := pf16bit;
  bmpResults.Height := round(BigSquareSize);
  bmpResults.Width := round(BigSquareSize);

  bmpResults.Canvas.brush.Color := clHide;
  bmpResults.Canvas.FillRect(Rect(0, 0, bmpResults.Width, bmpResults.Height));

  DisplayScale := 1;
  DrawResults(bmpResults.Canvas, InterlockXOffset, InterlockYOffset, 1, False, False, False, False, False, False, False, False, 1);

  imgInterlock.Visible := False;
  imgInterlock.Picture.Bitmap:= bmpResults;
  imgInterlock.Visible := True;

  bmpResults.Free;

  application.processmessages;
end;

function TfmAssessKnives.ReadPattern(Code, Size: string): TPointArray;
var
  Pattern: TPointArray;
  i: integer;

begin
  qPatterns.ParamByName('KnifeCode').AsString := Code;
  qPatterns.ParamByName('Size').AsString := Size;
  qPatterns.open;

  //Read Pattern
  i := 0;
  qPatterns.RecNo := 1; //CJY changed from qPatterns.First
  qPatterns.Prior; //CJY changed from qPatterns.First
  while not qPatterns.eof do
  begin
    inc(i);
    SetLength(Pattern, i);
    Pattern[i - 1].x := qPatternsX.Value;
    Pattern[i - 1].y := qPatternsY.Value;

    qPatterns.Next;
  end;

  qPatterns.close;

  Result := Pattern;
end;

procedure TfmAssessKnives.FormCreate(Sender: TObject);
var
  s: string;

begin
  AutoColor(Self);
  pnlImage.Color := clHide;


  Assessing := False;

  SetLength(KnivesUsed, 0);
  CurrentKnife := 0;
  NewKnife := False;
  MakeClearCanvas;

  s := 'SELECT K.*' + #13 +
       'FROM Knives K, KnifeSets KS' + #13 +
       'WHERE (K.ToBeAssessed = True) AND (KS.Code = K.Code) ';
  if not Option_LegacySynthetics then
    s := s + 'AND (KS.Type <> ''S'')';
  s := s + #13 + 'Order By K.Code, K.Code, K.MeasuredSize';
  qKnives.SQL.Text := s;

  tblKnifeSets.Open;
  tblKnives.Open;
  qKnives.Open;
end;

function TfmAssessKnives.LeatherInterlocking: TAssessResult;
var
  FirstInterlock, Complete: Boolean;
  PrimeInterlockArea, NonPrimeInterlockArea, InterlockArea: Real;
  BestInterlockW1, BestInterlockW2: TInterlock;
  W2Taken: Boolean;

begin
  FirstInterlock := True;
  Complete := False;

  PrimeInterlockArea := 0;
  NonPrimeInterlockArea := 0;

  W2Taken := False;
  while not Complete do
  begin
    if not W2Taken then
      BestInterlockW1 := FindInterlock(Knife, KnifeW1, KnivesUsed[0, 0], (Length(CutResults) = 0), True, OriginalKnifeNow, False, False, False, False, False, False, False, InterlockingToleranceInterlock)
    else
    begin
      BestInterlockW1.Found := False;
      BestInterlockW1.Size := 0;
    end;
    BestInterlockW2 := FindInterlock(Knife, KnifeW2, KnivesUsed[0, 0], (Length(CutResults) = 0), True, OriginalKnifeNow, False, False, False, False, False, False, False, InterlockingToleranceInterlock);
    BestInterlockW2.Size := BestInterlockW2.Size / 2;
    if BestInterlockW1.Error or BestInterlockW2.Error or
       (not BestInterlockW1.Found) and (not BestInterlockW2.Found) then
      Complete := True
    else
    begin
      InterlockArea := max(BestInterlockW1.Size, BestInterlockW2.Size);
      if FirstInterlock then
      begin
        PrimeInterlockArea := InterlockArea;
        NonPrimeInterlockArea := (0.8 * InterlockArea);
        FirstInterlock := False;
      end
      else
      begin
        PrimeInterlockArea := PrimeInterlockArea + (0.5 * InterlockArea);
        NonPrimeInterlockArea := NonPrimeInterlockArea + (0.5 * InterlockArea);
      end;

      if BestInterlockW1.Size > BestInterlockW2.Size then
        UpdateResults(BestInterlockW1, KnifeW1)
      else
      begin
        UpdateResults(BestInterlockW2, KnifeW2);
        W2Taken := True;
      end;
    end;

    SetCutResultsColour;
    DisplayResults;
  end;

  //Always Save the Expanded Area. For Leathers the Cutgap will be Zero anyway
  //and so they will be the same anyway. The Only other place these areas will
  //be used are for Legacy Synthetics and so for consistency with previous
  //versions of Summs we need to store the Expanded areas. The New layplanning
  //routines ignore the saved settings anyway and recalculate the area
  //automatically as part of Createpattern routine.
  Result.Assessed := True;
  Result.NettArea := KnivesUsed[0, 0].ExpandedNettArea;
  Result.GrossArea := KnivesUsed[0, 0].ExpandedGrossArea;
  Result.PrimeInterlockArea := Result.GrossArea - PrimeInterlockArea;
  Result.NonPrimeInterlockArea := Result.GrossArea - NonPrimeInterlockArea;
end;

procedure TfmAssessKnives.SetCutResultsColour;
var
  i: integer;

begin
  if Length(CutResults) > 0 then
  begin
    CutResults[0].Colour := clCut;
    for i := 1 to Length(CutResults) - 1 do
    begin
      if CutResults[i].Ghost then
        CutResults[i].Colour := clGhost
      else
        CutResults[i].Colour := clInterlock;
    end;
  end;
end;

procedure TfmAssessKnives.MakeClearCanvas;
var
  bmpResults: TBitmap;

begin
  bmpResults := TBitmap.Create;
  bmpResults.PixelFormat := pf16bit;
  //Needs to be bigger than image so that it can be maximised
  bmpResults.Height := imgInterlock.Height * 2;
  bmpResults.Width := imgInterlock.Width * 2;

  bmpResults.Canvas.brush.Color := clHide;

  bmpResults.Canvas.FillRect(Rect(0, 0, bmpResults.Width, bmpResults.Height));

  imgInterlock.Picture.Bitmap := bmpResults;

  bmpResults.Free;

  application.processmessages;
end;

function TfmAssessKnives.AssessKnife: TAssessResult;
var
  KerfWidth: integer;
  LeatherResult: TAssessResult;

begin
  //Initialise Results
  SetLength(CutResults, 0);

  SetLength(OriginalHullOverlaps, 0);

  OriginalPoints := ReadPattern(qKnivesCode.Value, qKnivesMeasuredSize.Value);

  //Cut gap is entered in mm but stored in 1/1000ths inch
  //because digitising returns 1/1000 inches.
  //Kerf Width is half the Cut gap.
  //NOTE: This is always be Zero now EXCEPT when using Legacy Synthetics
  KerfWidth := round((tblKnifeSetsCutGap.value / 2) * 0.03937 * 1000);
  if not Option_LegacySynthetics then
    KerfWidth := 0;

  Knife := CreatePattern(OriginalPoints, 0, KerfWidth, True, False);
  KnifeW1 := CreatePattern(OriginalPoints, 0, KerfWidth, True, False);
  KnifeW2 := CreatePattern(OriginalPoints, 0, KerfWidth, True, True);

  //Always First knife when loaded here
  CurrentKnife := 1;
  SetLength(KnivesUsed, CurrentKnife);
  KnivesUsed[CurrentKnife - 1, 0] := KnifeW1;
  KnivesUsed[CurrentKnife - 1, 1] := KnifeW2;

  NewKnife := True;

  if Length(OriginalPoints) <= 3 then
    // This a manual knife or there are not enough points for this knife.
    LeatherResult.Assessed := False
  else
    //Assess
    LeatherResult := LeatherInterlocking;

  Result := LeatherResult;
end;

procedure TfmAssessKnives.btnCancelClick(Sender: TObject);
begin
  AbortAssessing := True;
  MessageDlgPos('Assessing will abort ' + #13 +
             'after current pattern.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
end;

procedure TfmAssessKnives.btnRefreshClick(Sender: TObject);
begin
  qKnives.Close;
  qKnives.Open;
  dbgKnives.refresh;
end;

procedure TfmAssessKnives.btnStartClick(Sender: TObject);
var
  AllowClose, CompleteSave, LockSuccess: Boolean;
  LeatherResult: TAssessResult;

begin
  screen.Cursor := crHourGlass;

  dbgKnives.Enabled := False;

  qKnives.close;
  qKnives.open;

  //CJY: qKnives.FetchOptions.RecordCountMode set to cmTotal
  if qKnives.recordCount = 0 then
    MessageDlgPos('No patterns to assess', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else
  begin
    LockSuccess := LockOption(fmSumms.tblLocks, oAssessKnives);

    if LockSuccess then
    begin
      btnStart.Enabled := False;
      btnCancel.Enabled := True;
      btnRefresh.Enabled := False;

      AbortAssessing := False;
      Assessing := True;

      qKnives.RecNo := 1; //CJY changed from qKnives.First
      qKnives.Prior; //CJY changed from qKnives.First
      while (not qKnives.Eof) and (not AbortAssessing) do
      begin
        //Find Knife in Knife Set
        tblKnives.FindKey([qKnivesCode.value, qKnivesSizeScale.Value, qKnivesMeasuredSize.value]);
        tblKnifeSets.FindKey([qKnivesCode.value]);

        //Simple locking without lock message
        try
          tblKnifeSets.Edit;
          LockSuccess := True;
        except
          LockSuccess := False;
        end;

        if LockSuccess then
        begin

try
          LeatherResult := AssessKnife;
except
  on e:exception do
  begin
    //Do nothing
  end;
end;

          if LeatherResult.Assessed then
          begin
            LocalConnectionSumms.StartTransaction;
            try
              CompleteSave := False;
              if SaveInterlocks then
              begin
                tblKnives.edit;
                tblKnivesGrossArea.Value := LeatherResult.GrossArea;
                tblKnivesNettArea.Value := LeatherResult.NettArea;
                tblKnivesInterlockAreaPrimeSynthetic.Value := LeatherResult.PrimeInterlockArea;
                tblKnivesInterlockAreaNonPrime.Value := LeatherResult.NonPrimeInterlockArea;
                tblKnivesToBeAssessed.Value := False;
                tblKnivesAssessedVersion.Value := 80;   //Denotes Assessed in Version 8
                tblKnivesToleranceUsed.Value := InterlockingToleranceInterlock;
                tblKnives.post;

                CompleteSave := True;
              end;
            except
              on E: Exception do
              begin
                LocalConnectionSumms.Rollback;
                tblKnives.Cancel;
                AbortAssessing := True;
                Assessing := False;
                btnStart.enabled := True;
                btnCancel.enabled := False;

                //Release lock
                LocksUnLockRecord(fmSumms.tblLocks, 'ASSESS_KNIVES');
                raise;
              end;
            end;

            if CompleteSave then
              LocalConnectionSumms.Commit
            else
              LocalConnectionSumms.RollBack;
          end;

          //Unlock Knifeset
          tblKnifeSets.Cancel;
        end;


        qKnives.Next;
      end;

      //Refresh
      qKnives.Close;
      qKnives.Open;

      AllowClose := False;
      //CJY: qKnives.FetchOptions.RecordCountMode set to cmTotal
      if ((qKnives.recordCount > 0) and (not AbortAssessing)) then
         MessageDlgPos('Not all patterns assessed - ' + #13 +
                    'some may be locked', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
      //CJY: qKnives.FetchOptions.RecordCountMode set to cmTotal
      else if ((qKnives.recordCount = 0) and (not AbortAssessing)) then
      begin
        MessageDlgPos('Pattern assessing complete', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
        AllowClose := True;
      end;

      Assessing := False;

      btnRefresh.Enabled := True;
      btnCancel.Enabled := False;
      btnStart.Enabled := True;;

      //Release lock
      LocksUnLockRecord(fmSumms.tblLocks, 'ASSESS_KNIVES');
    end
    else
      qKnives.next;
  end;

  dbgKnives.Enabled := True;
  dbgKnives.Refresh;

  screen.Cursor := crDefault;
  if AllowClose then
    Close;
end;

procedure TfmAssessKnives.FormResize(Sender: TObject);
begin
  imgInterlock.Height := min(pnlImage.Height, pnlImage.Width) - 1;
  imgInterlock.Width := imgInterlock.Height;

  imgInterlock.Left := 0;
  if imgInterlock.Width < pnlImage.Width then
    imginterlock.Left := (pnlImage.Width - imgInterlock.Width) div 2;
  imgInterlock.Top := 0;
  if imgInterlock.Height < pnlImage.Height then
    imgInterlock.Top := (pnlImage.Height - imgInterlock.Height) div 2;
end;

function TfmAssessKnives.SaveInterlocks: Boolean;
var
  CompleteSave: Boolean;
  KnifeCode, KnifeScale, KnifeSize: string;
  SQLString: string;
  i, KnifeNo, W2: integer;
  sSeq, sW2, sGhost: string;
  sLeft, sTop, sRight, sBottom: string;
  sX, sY: string;
  ECode: integer;

begin
  CompleteSave := True;

  if Length(CutResults) > 0 then
  begin
    SQLString := '';

    KnifeCode := qKnivesCode.Value;
    KnifeScale := qKnivesSizeScale.Value;
    KnifeSize := qKnivesMeasuredSize.Value;

    //Interlocks
    for i := 0 to Length(CutResults) - 1 do
    begin
      str(i, sSeq);
      if CutResults[i].W2 then
        sW2 := 'True'
      else
        sW2 := 'False';
      if CutResults[i].Ghost then
        sGhost := 'True'
      else
        sGhost := 'False';
      str(CutResults[i].BoundingRect.Left, sLeft);
      str(CutResults[i].BoundingRect.Top, sTop);
      str(CutResults[i].BoundingRect.Right, sRight);
      str(CutResults[i].BoundingRect.Bottom, sBottom);

      SQLString := SQLString + 'INSERT INTO Interlocks (KnifeCode, ' +
                                                       'KnifeSizeScale, ' +
                                                       'KnifeSize, ' +
                                                       'Seq, ' +
                                                       'W2, ' +
                                                       'Ghost, ' +
                                                       'BR_Left, ' +
                                                       'BR_Top, ' +
                                                       'BR_Right, ' +
                                                       'BR_Bottom) ' +
                  'VALUES(''' + QS(KnifeCode) + '''' + ', ' +
                          '''' + QS(KnifeScale) + '''' + ', ' +
                          '''' + QS(KnifeSize) + '''' + ', ' +
                          sSeq + ', ' +
                          sW2 + ', ' +
                          sGhost + ', ' +
                          sLeft + ', ' +
                          sTop + ', ' +
                          sRight + ', ' +
                          sBottom + '); ' + #13;
    end;

    KnifeNo := CutResults[0].KnifeNo;

    //Real points
    for W2 := 0 to 1 do
      for i := 0 to Length(KnivesUsed[KnifeNo - 1, W2].PatternPoints) - 1 do
      begin
        if (W2 = 1) then
          sW2 := 'True'
        else
          sW2 := 'False';
        str(i + 1, sSeq);
        str(KnivesUsed[KnifeNo - 1, W2].PatternPoints[i].X, sX);
        str(KnivesUsed[KnifeNo - 1, W2].PatternPoints[i].Y, sY);

        SQLString := SQLString + 'INSERT INTO InterlockKnives (KnifeCode, ' +
                                                              'KnifeSizeScale, ' +
                                                              'KnifeSize, ' +
                                                              'RealNotExpanded, ' +
                                                              'W2, ' +
                                                              'Seq, ' +
                                                              'X, ' +
                                                              'Y) ' +
                    'VALUES(''' + QS(KnifeCode) + '''' + ', ' +
                            '''' + QS(KnifeScale) + '''' + ', ' +
                            '''' + QS(KnifeSize) + '''' + ', ' +
                            'True' + ', ' +
                            sW2 + ', ' +
                            sSeq + ', ' +
                            sX + ', ' +
                            sY + '); ' + #13;
      end;

    //Expanded Points
    for W2 := 0 to 1 do
    begin
      for i := 0 to Length(KnivesUsed[KnifeNo - 1, W2].ExpandedPoints) - 1 do
      begin
        if (W2 = 1) then
          sW2 := 'True'
        else
          sW2 := 'False';
        str(i + 1, sSeq);
        str(KnivesUsed[KnifeNo - 1, W2].ExpandedPoints[i].X, sX);
        str(KnivesUsed[KnifeNo - 1, W2].ExpandedPoints[i].Y, sY);

        SQLString := SQLString + 'INSERT INTO InterlockKnives (KnifeCode, ' +
                                                              'KnifeSizeScale, ' +
                                                              'KnifeSize, ' +
                                                              'RealNotExpanded, ' +
                                                              'W2, ' +
                                                              'Seq, ' +
                                                              'X, ' +
                                                              'Y) ' +
                    'VALUES(''' + QS(KnifeCode) + '''' + ', ' +
                            '''' + QS(KnifeScale) + '''' + ', ' +
                            '''' + QS(KnifeSize) + '''' + ', ' +
                            'False' + ', ' +
                            sW2 + ', ' +
                            sSeq + ', ' +
                            sX + ', ' +
                            sY + '); ' + #13;
      end;
    end;

    //Run the query
    qSaveInterlocks.SQL.Text := SQLString;
    try
      qSaveInterlocks.ExecSQL;
    except
      on E: Exception do
      begin
        fmErrorHandler.DebugMessageDlg('Error - Interlock NOT saved.', E.Message, qSaveInterlocks.Text);
        CompleteSave := False;
      end;
    end;
  end;

  Result := CompleteSave;
end;

procedure TfmAssessKnives.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assessing then
  begin
    MessageDlgPos('Cancel assessing before closing', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    abort;
  end
  else
  begin
    //Must ensure that CutResults is empty when this
    //unit closes as it is shared with Layplanning
    SetLength(CutResults, 0);

    Action := caFree;
  end;
end;

procedure TfmAssessKnives.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

function TfmAssessKnives.OverlappingHulls: Boolean;
var
  APoint0, APoint1 :TPoint2D;
  ConvexHull0, ConvexHull1: TPolygon2D;

begin
  //Only ever used for checking overlaps of in a W1 situation so can use KnifeW1
  //Always looking at the realative position of the last positioned shape and
  //the original shape.

  APoint0.x := CutResults[0].BoundingRect.Left;
  APoint0.y := CutResults[0].BoundingRect.Top;
  APoint1.x := CutResults[Length(CutResults) - 1].BoundingRect.Left;
  APoint1.y := CutResults[Length(CutResults) - 1].BoundingRect.Top;

  ConvexHull0 := Translate(APoint0, KnifeW1.ConvexHull);
  ConvexHull1 := Translate(APoint1, KnifeW1.ConvexHull);

  Result := intersect(ConvexHull0, ConvexHull1)
end;

end.

