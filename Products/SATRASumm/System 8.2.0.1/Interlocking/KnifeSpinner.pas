unit KnifeSpinner;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, CButton,  INIfiles,
  ToolWin, ComCtrls, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,   Interlocking,
  Const_Interlocking, General_Interlocking, Spin, PBSpinEdit, Math,
  PBNumEdit, Menus, Ruler, Grids, jpeg, PBEdit, Summs, SummsVars,
  OutOfMemory, CmnVars, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FDConnectionPlus;

type
  TfmKnifeSpinner = class(TForm)
    LocalConnectionSumms: TFDConnectionPlus;
    tblKnives: TFDTablePlus;
    tblKnivesCode: TStringField;
    qPatterns: TFDQueryPlus;
    qPatternsKnife: TStringField;
    qPatternsSeq: TSmallintField;
    qPatternsX: TSmallintField;
    qPatternsY: TSmallintField;
    tblKnivesMeasuredSize: TStringField;
    qMaterialUnits: TFDQueryPlus;
    qMaterialUnitsCode: TStringField;
    qMaterialUnitsUnitDescription: TStringField;
    qMaterialUnitsUnitAbbreviation: TStringField;
    qMaterialUnitsToFeet: TFloatField;
    qMaterialUnitsSubUnitDesc: TStringField;
    qMaterialUnitsSubUnitAbbreviation: TStringField;
    qMaterialUnitsSubUnitsPerUnit: TSmallintField;
    dsMaterialUnits: TDataSource;
    tblKnivesSizeScale: TStringField;
    tblKnivesToBeAssessed: TBooleanField;
    qPatternsSizeScale: TStringField;
    qPatternsMeasuredSize: TStringField;
    pnlLayplans: TPanel;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnSaveAll: TSpeedButton;
    pnlPatternTop: TPanel;
    pnlPatternControls: TPanel;
    pnlInitialAngle: TPanel;
    btnNudgeLeft10: TColButton;
    btnNudgeLeft1: TColButton;
    btnNudgeLeftPoint1: TColButton;
    btnNudgeRight10: TColButton;
    btnNudgeRight1: TColButton;
    btnNudgeRightPoint1: TColButton;
    shpWheel: TShape;
    shpWheelHandle: TShape;
    imgRotatedKnife: TImage;
    shpActualAngle0: TShape;
    shpActualAngle10: TShape;
    shpActualAngle15: TShape;
    shpActualAngle20: TShape;
    shpActualAngle25: TShape;
    shpActualAngle5: TShape;
    lblNettArea2: TLabel;
    lblNettArea1: TLabel;
    lblNettAreaUnits1: TLabel;
    lblNettAreaUnits2: TLabel;
    lblKnifeAreaText: TLabel;
    lblKnifeSizeText: TLabel;
    lblKnifeCodeText: TLabel;
    lblKnifeSize: TLabel;
    lblKnifeCode: TLabel;
    pnlPatternKnife: TPanel;
    pnlKnifeIncRulers: TPanel;
    pnlKnifeRulerRight: TPanel;
    rulerKnifeLeft: TRuler;
    pnlKnifeRulerCorner: TPanel;
    pnlKnifeAndRuler: TPanel;
    pnlKnife: TPanel;
    imgKnife: TImage;
    pnlKnifeRulerBottom: TPanel;
    rulerKnifeBottom: TRuler;
    cbUnitsKnife: TComboBox;
    lblUnitsText: TLabel;
    cbGrid: TCheckBox;
    lblWheelHelp1: TLabel;
    lblWheelHelp2: TLabel;
    lblWheelHelp3: TLabel;
    lblAdjustmentAngle: TLabel;
    imgDegrees: TImage;
    procedure PatternInitialise;
    procedure MainKnifeInitialise(UpdateMaterial, Spinning: Boolean);
    procedure btnNudgeLeft10Click(Sender: TObject);
    procedure btnNudgeLeft1Click(Sender: TObject);
    procedure btnNudgeLeftPoint1Click(Sender: TObject);
    procedure btnNudgeRight10Click(Sender: TObject);
    procedure btnNudgeRight1Click(Sender: TObject);
    procedure btnNudgeRightPoint1Click(Sender: TObject);
    procedure MakeBitmap(Pattern: TPattern; ShowGrid: Boolean; No: integer; Spinning: Boolean);
    function ReadPattern(Code, Scale, Size: string): TPointArray;
    procedure FormCreate(Sender: TObject);
    procedure UpdateScreen;
    procedure KnifeAtActualRotation(Angle: real; No: integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadUnitsDropDown;
    procedure cbUnitsKnifeChange(Sender: TObject);
    procedure pcSelectionsResultsDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure RedrawBMPs;
    procedure shpWheelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shpWheelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure shpWheelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AngleHandle(HandleAngle: real);
    procedure AngleHand;
    procedure LoadKnife(Code, Scale, Size: string; Angle: Real);
    function FindUnitsIndex(UnitsCode: string): integer;
    procedure Initialise;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveAllClick(Sender: TObject);
    procedure AdjustRulersScale;
    procedure cbGridClick(Sender: TObject);
  private
    LastWheelX, LastWheelY, HandleAngle: integer;
    HoldWheel: Boolean;
    FirstTime: Boolean;
  public
    { Public declarations }
    KnifeCode, KnifeScale, KnifeSize: string;
    KnifeArea: Real;
    AdjustmentAngle: Real;
  end;

var
  fmKnifeSpinner: TfmKnifeSpinner;
  OldWindowProc: Pointer;
  MyMsg: DWord;
  TheCallingForm: TForm;

implementation

uses General;

{$R *.dfm}

var
  ActualPoints: TPointArray;
  PictureSize: integer;
  KnifeLoaded: Boolean;
  SummsUnits, KnifeUnits: string;
  SummsToFtMultiplier, KnifeToFtMultiplier, KnifeToCmMultiplier: Real;

procedure TfmKnifeSpinner.PatternInitialise;
begin
  imgKnife.Picture.Bitmap := nil;

  NewKnife := True;
  AdjustmentAngle := 0;

  AngleHand;
end;

procedure TfmKnifeSpinner.MainKnifeInitialise(UpdateMaterial, Spinning: Boolean);
var
  s: string;
  ImageHeight10CM: real;

begin
  KnifeLoaded := True;

  if AdjustmentAngle > 180 then
    AdjustmentAngle := AdjustmentAngle - 360
  else if AdjustmentAngle <= -180 then
    AdjustmentAngle := AdjustmentAngle + 360;

  str(AdjustmentAngle : 4 : 1, s);
  lblAdjustmentAngle.Caption := s;

  Knife := CreatePattern(ActualPoints, AdjustmentAngle, 0, True, False);

  MakeBitmap(Knife, cbGrid.checked, 1, Spinning);
  AngleHand;

  qMaterialUnits.findkey(['M']);
  ImageHeight10CM := (PictureSize / (1000 div PATTERNRES)) * 0.254;  //Units of 10cm
  rulerKnifeLeft.UnitSize := rulerKnifeLeft.Height / ImageHeight10CM;
  rulerKnifeLeft.UnitPrice := 10;
  rulerKnifeBottom.UnitSize := rulerKnifeBottom.Width / ImageHeight10CM;
  rulerKnifeBottom.UnitPrice := 10;

  AdjustRulersScale;

  UpdateScreen;
end;

procedure TfmKnifeSpinner.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmKnifeSpinner.btnNudgeLeft10Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle - 10;
  MainKnifeInitialise(True, False);
end;

procedure TfmKnifeSpinner.btnNudgeLeft1Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle - 1;
  MainKnifeInitialise(True, False);
end;

procedure TfmKnifeSpinner.btnNudgeLeftPoint1Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle - 0.1;
  MainKnifeInitialise(True, False);
end;

procedure TfmKnifeSpinner.btnNudgeRight10Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle + 10;
  MainKnifeInitialise(True, False);
end;

procedure TfmKnifeSpinner.btnNudgeRight1Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle + 1;
  MainKnifeInitialise(True, False);
end;

procedure TfmKnifeSpinner.btnNudgeRightPoint1Click(Sender: TObject);
begin
  AdjustmentAngle := AdjustmentAngle + 0.1;
  MainKnifeInitialise(True, False);
end;

procedure TfmKnifeSpinner.btnSaveAllClick(Sender: TObject);
begin
  if MessageDlgPos('This will overwrite Angle for ALL Knives for this Set - Are you Sure?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
    ModalResult := mrYesToAll;
end;

procedure TfmKnifeSpinner.btnSaveClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

procedure TfmKnifeSpinner.MakeBitmap(Pattern: TPattern; ShowGrid: Boolean; No: integer; Spinning: Boolean);
var
  bmp: TBitmap;
  Points: TPointArray;
  i: integer;
  maxx, maxy, minx, miny: real;
  PenWidth: integer;
  clBackground: TColor;

begin
  //Disabling this panel stops user being able to hold down the
  //button and spin the knife which exentually leads to a 'lock'.
  pnlInitialAngle.Enabled := False;

  if PictureSize = -1 then
  begin
    PictureSize := max(Pattern.Height, Pattern.Width);
    PictureSize := round(sqrt(2 * PictureSize * PictureSize)) + 10;
  end;

  maxx := -999999;
  maxy := -999999;
  minx := 999999;
  miny := 999999;
  Points := copy(Pattern.PatternPoints);
  for i := 0 to Length(Points) - 1 do
  begin
    Points[i].x := Points[i].x + (PictureSize - Pattern.Width) div 2;
    Points[i].y := Points[i].y + (PictureSize - Pattern.Height) div 2;

    if maxx < Points[i].x then
      maxx := Points[i].x;
    if maxy < Points[i].y then
      maxy := Points[i].y;
    if minx > Points[i].x then
      minx := Points[i].x;
    if miny > Points[i].y then
      miny := Points[i].y;
  end;

  //Close shape just for drawing
  setLength(Points, Length(Points) + 1);
  Points[Length(Points) - 1] := Points[0];

  bmp := TBitmap.Create;
  bmp.PixelFormat := pf4Bit;

  bmp.Height := PictureSize;
  bmp.Width := PictureSize;

  if (not SimpleDrawing) and (not Spinning) then
  begin
    clBackground := clHide;
    pnlKnife.Color := clHide;
  end
  else
  begin
    clBackground := clEditing;
    pnlKnife.Color := clEditing;
  end;
  bmp.Canvas.pen.Color := clBackground;
  bmp.Canvas.brush.color := clBackground;
  bmp.Canvas.FloodFill(10, 10, clBackground, fsBorder);

  if not SimpleDrawing then
  begin
    bmp.Canvas.Pen.Width := 1;
    bmp.Canvas.pen.Color := clCut;
    bmp.Canvas.brush.color := clCut;
    bmp.Canvas.Polygon(Points);
  end
  else
  begin
    bmp.Canvas.Pen.Width := (PictureSize div 200) + 1;
    bmp.Canvas.pen.Color := clBlack;
    bmp.Canvas.brush.color := clBlack;
    bmp.Canvas.Polyline(Points);
  end;

  if ShowGrid then
  begin
    PenWidth := (PictureSize div 200) + 1;

    bmp.Canvas.Pen.Width := PenWidth;
    if not SimpleDrawing then
    begin
      bmp.Canvas.pen.Color := clEditing;
      bmp.Canvas.brush.color := clEditing;
    end
    else
    begin
      bmp.Canvas.pen.Color := clCut;
      bmp.Canvas.brush.color := clCut;
    end;
    bmp.Canvas.MoveTo(0, round(maxy));
    bmp.Canvas.LineTo(PictureSize, round(maxy));
    bmp.Canvas.MoveTo(0, round(miny));
    bmp.Canvas.LineTo(PictureSize, round(miny));
    bmp.Canvas.MoveTo(round(maxx), 0);
    bmp.Canvas.LineTo(round(maxx), PictureSize);
    bmp.Canvas.MoveTo(round(minx), 0);
    bmp.Canvas.LineTo(round(minx), PictureSize);
  end;

  //Result := bmp;
  if No = 1 then
    imgKnife.Picture.Bitmap := bmp
  else if No = 2 then
    imgRotatedKnife.Picture.Bitmap := bmp;

  bmp.Free;

  pnlInitialAngle.Enabled := True;
end;

function TfmKnifeSpinner.ReadPattern(Code, Scale, Size: string): TPointArray;
var
  Pattern: TPointArray;
  i: integer;

begin
  qPatterns.ParamByName('KnifeCode').value := Code;
  qPatterns.ParamByName('KnifeScale').value := Scale;
  qPatterns.ParamByName('KnifeSize').value := Size;
  qPatterns.open;

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

procedure TfmKnifeSpinner.FormCreate(Sender: TObject);
begin
  KnifeCode := '';
  KnifeScale := '';
  KnifeSize := '';
  KnifeArea := 0;

  AutoColor(Self);
  shpWheel.Brush.Color := OurColor(clLime);

  application.processmessages;

  SummsToFtMultiplier := 0;

  if not SimpleDrawing then
    pnlKnife.color := clHide
  else
    pnlKnife.color := clEditing;

  FirstTime := True;
end;

procedure TfmKnifeSpinner.Initialise;
var
  SummsLayplanINI: TIniFile;
  ShowGrid: Boolean;

begin
  if Firsttime then
  begin
    LoadUnitsDropDown;
    FirstTime := False;
  end;

  SetLength(ActualPoints, 0);
  NewKnife := False;
  KnifeLoaded := False;

  PatternInitialise;

  HandleAngle := 0;
  AngleHandle(HandleAngle);

  //Read but never write KnifeUnits & ShowGrid settings
  SummsLayplanINI := TIniFile.Create(LayplanIniName);
  KnifeUnits := SummsLayplanINI.ReadString('Knife', 'KNIFE_UNITS', '');
  cbUnitsKnife.ItemIndex := FindUnitsIndex(KnifeUnits);
  cbUnitsKnifeChange(Self);
  ShowGrid := SummsLayplanINI.ReadBool('Knife', 'KNIFE_SHOWGRID', False);
  cbGrid.checked := ShowGrid;

  SummsLayplanINI.Free;
end;

procedure TfmKnifeSpinner.UpdateScreen;
begin
  pnlInitialAngle.enabled := KnifeLoaded;
  btnNudgeLeft10.enabled := pnlInitialAngle.enabled;
  btnNudgeLeft1.enabled := pnlInitialAngle.enabled;
  btnNudgeLeftPoint1.enabled := pnlInitialAngle.enabled;
  btnNudgeRightPoint1.enabled := pnlInitialAngle.enabled;
  btnNudgeRight1.enabled := pnlInitialAngle.enabled;
  btnNudgeRight10.enabled := pnlInitialAngle.enabled;
  shpWheel.enabled := pnlInitialAngle.enabled;

  cbUnitsKnife.enabled := true;

  application.processmessages;
end;

procedure TfmKnifeSpinner.KnifeAtActualRotation(Angle: real; No: integer);
var
  RotatedKnife: TPattern;

begin
  if Angle > 180 then
    Angle := Angle - 360
  else if Angle <= -180 then
    Angle := Angle + 360;

  RotatedKnife := CreatePattern(ActualPoints, Angle, 0, True, False);

  MakeBitmap(RotatedKnife, cbGrid.checked or (No = 2), No, False);
end;

procedure TfmKnifeSpinner.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  setlength(ActualPoints, 0);
end;

procedure TfmKnifeSpinner.LoadUnitsDropDown;
begin
  cbUnitsKnife.Items.Clear;
  qMaterialUnits.open;
  qMaterialUnits.RecNo := 1; //CJY changed from qMaterialUnits.First
  qMaterialUnits.Prior; //CJY changed from qMaterialUnits.First
  while not qMaterialUnits.eof do
  begin
    cbUnitsKnife.Items.Add(qMaterialUnitsCode.value);

    qMaterialUnits.next;
  end;

  cbUnitsKnife.ItemIndex := 0;
end;

procedure TfmKnifeSpinner.cbGridClick(Sender: TObject);
begin
  if KnifeLoaded then
    MainKnifeInitialise(True, False);
end;

procedure TfmKnifeSpinner.cbUnitsKnifeChange(Sender: TObject);
var
  OldKnifeToFtMultiplier: Real;
  s: string;
  AreaSqUnits, AreaSqSubUnits: Real;

begin
  //Initialise if necesary
  if KnifeToFtMultiplier = 0 then
  begin
    //Initially in cm
    qMaterialUnits.findkey(['M']);
    KnifeToFtMultiplier := qMaterialUnitsToFeet.Value / qMaterialUnitsSubUnitsPerUnit.value;
    KnifeToCmMultiplier := KnifeToFtMultiplier * 12 * 2.54;
  end;

  qMaterialUnits.findkey([cbUnitsKnife.Text]);

  OldKnifeToFtMultiplier := KnifeToFtMultiplier;

  KnifeUnits := qMaterialUnitsCode.value;
  KnifeToFtMultiplier := qMaterialUnitsToFeet.Value / qMaterialUnitsSubUnitsPerUnit.value;
  KnifeToCmMultiplier := KnifeToFtMultiplier * 12 * 2.54;

  rulerKnifeLeft.UnitSize := rulerKnifeLeft.UnitSize * 10 / rulerKnifeLeft.UnitPrice;
  rulerKnifeLeft.UnitSize := rulerKnifeLeft.UnitSize / OldKnifeToFtMultiplier * KnifeToFtMultiplier;
  rulerKnifeLeft.UnitPrice := 10;
  rulerKnifeBottom.UnitSize := rulerKnifeBottom.UnitSize * 10 / rulerKnifeBottom.UnitPrice;
  rulerKnifeBottom.UnitSize := rulerKnifeBottom.UnitSize / OldKnifeToFtMultiplier * KnifeToFtMultiplier;
  rulerKnifeBottom.UnitPrice := 10;

  AdjustRulersScale;

  pnlKnifeRulerCorner.Caption := qMaterialUnitsSubUnitAbbreviation.value;

  lblNettAreaUnits1.caption := ' Sq ' + qMaterialUnitsUnitAbbreviation.value;
  lblNettAreaUnits2.caption := ' Sq ' + qMaterialUnitsSubUnitAbbreviation.value;
  if KnifeCode <> '' then
  begin
    AreaSqUnits := KnifeArea / (qMaterialUnitsToFeet.Value * qMaterialUnitsToFeet.Value);
    AreaSqSubUnits := AreaSqUnits * (qMaterialUnitsSubUnitsPerUnit.Value * qMaterialUnitsSubUnitsPerUnit.Value);
    Str(AreaSqUnits : 6 : 2, s);
    lblNettArea1.caption := s;
    Str(AreaSqSubUnits : 6 : 2, s);
    lblNettArea2.caption := s;
  end;
end;

procedure TfmKnifeSpinner.pcSelectionsResultsDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

procedure TfmKnifeSpinner.LocalConnectionSummsBeforeConnect(Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmKnifeSpinner.shpWheelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  HoldWheel := True;
  lblWheelHelp1.visible := True;
  lblWheelHelp2.visible := True;
  lblWheelHelp3.visible := True;
  screen.Cursor := crHandPoint;
end;

procedure TfmKnifeSpinner.shpWheelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  q, h2, w2: integer;
  adj: real;
  HandleAdj: integer;
  ClockWise: Boolean;

begin
  if HoldWheel then
  begin
    //Quarters
    //  4  1
    //  3  2
    h2 := shpWheel.Height div 2;
    w2 := shpWheel.Width div 2;
    if (X >= w2) and (Y < h2) then
      q := 1
    else if (X >= w2) and (Y >= h2) then
      q := 2
    else if (X < w2) and (Y >= h2) then
      q := 3
    else if (X < w2) and (Y < h2) then
      q := 4
    else
      q := 0;

    //If off the shape area then ignore
    if (X < 0) or (X > w2 * 2) or (Y < 0) or (Y > h2 * 2) then
      q := 0;

    //Check keys
    if ssCtrl in Shift then
    begin
      adj := 10;
      HandleAdj := 25;
    end
    else if ssAlt in Shift then
    begin
      adj := 0.1;
      HandleAdj := 5;
    end
    else
    begin
      adj := 1;
      HandleAdj := 15;
    end;

    //Movement
    if (q = 1) then
    begin
      if (X > LastWheelX) and (Y > LastWheelY) then
        ClockWise := True
      else if (X < LastWheelX) and (Y < LastWheelY) then
        ClockWise := False
      else
        q := 0;
    end
    else if (q = 2) then
    begin
      if (X < LastWheelX) and (Y > LastWheelY) then
        ClockWise := True
      else if (X > LastWheelX) and (Y < LastWheelY) then
        ClockWise := False
      else
        q := 0;
    end
    else if (q = 3) then
    begin
      if (X < LastWheelX) and (Y < LastWheelY) then
        ClockWise := True
      else if (X > LastWheelX) and (Y > LastWheelY) then
        ClockWise := False
      else
        q := 0;
    end
    else if (q = 4) then
    begin
      if (X > LastWheelX) and (Y < LastWheelY) then
        ClockWise := True
      else if (X < LastWheelX) and (Y > LastWheelY) then
        ClockWise := False
      else
        q := 0;
    end;

    //Adjust
    if q <> 0 then
    begin
      if ClockWise then
      begin
        AdjustmentAngle := AdjustmentAngle + adj;
        HandleAngle := HandleAngle + HandleAdj;
      end
      else
      begin
        AdjustmentAngle := AdjustmentAngle - adj;
        HandleAngle := HandleAngle - HandleAdj;
      end;

      //Correct AdjustmentAngle
      while AdjustmentAngle >= 360 do
        AdjustmentAngle := AdjustmentAngle - 360;
      while AdjustmentAngle < 0 do
        AdjustmentAngle := AdjustmentAngle + 360;

      MainKnifeInitialise(False, True);
    end;

    AngleHandle(HandleAngle);

    LastWheelX := X;
    LastWheelY := Y;
  end;
end;

procedure TfmKnifeSpinner.shpWheelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  HoldWheel := False;
  lblWheelHelp1.visible := False;
  lblWheelHelp2.visible := False;
  lblWheelHelp3.visible := False;
  MainKnifeInitialise(True, False);

  screen.Cursor := crDefault;
end;

procedure TfmKnifeSpinner.RedrawBMPs;
begin
  KnifeAtActualRotation(AdjustmentAngle, 1);
end;

procedure TfmKnifeSpinner.AngleHandle(HandleAngle: real);
var
  SmallWheelX, SmallWheelY: integer;
  AngleRadians: real;

begin
  AngleRadians := (90 - HandleAngle) *  Pi / 180;
  SmallWheelX := round(35 * Cos(AngleRadians));
  SmallWheelY := round(35 * Sin(AngleRadians));

  SmallWheelX := SmallWheelX + shpWheel.Left + (shpWheel.Width div 2) - (shpWheelHandle.Width div 2);
  SmallWheelY := - SmallWheelY + shpWheel.Top + (shpWheel.Height div 2) - (shpWheelHandle.Height div 2);

  shpWheelHandle.left := SmallWheelX;
  shpWheelHandle.top := SmallWheelY;
end;

procedure TfmKnifeSpinner.AngleHand;
var
  SmallWheelX, SmallWheelY: integer;
  AngleRadians: real;
  i: integer;

begin
  i := 0;
  while i <= 25 do
  begin
    AngleRadians := (90 - AdjustmentAngle) *  Pi / 180;
    SmallWheelX := round(i * Cos(AngleRadians));
    SmallWheelY := - round(i * Sin(AngleRadians));

    SmallWheelX := SmallWheelX + shpWheel.Left + (shpWheel.Width div 2);
    SmallWheelY := SmallWheelY + shpWheel.Top + (shpWheel.Height div 2);

    case i of
      0: begin
           shpActualAngle0.left := SmallWheelX - (shpActualAngle0.Width div 2);
           shpActualAngle0.top := SmallWheelY - (shpActualAngle0.Height div 2);
         end;
      5: begin
           shpActualAngle5.left := SmallWheelX - (shpActualAngle5.Width div 2);
           shpActualAngle5.top := SmallWheelY - (shpActualAngle5.Height div 2);
         end;
      10: begin
           shpActualAngle10.left := SmallWheelX - (shpActualAngle10.Width div 2);
           shpActualAngle10.top := SmallWheelY - (shpActualAngle10.Height div 2);
         end;
      15: begin
           shpActualAngle15.left := SmallWheelX - (shpActualAngle15.Width div 2);
           shpActualAngle15.top := SmallWheelY - (shpActualAngle15.Height div 2);
         end;
      20: begin
           shpActualAngle20.left := SmallWheelX - (shpActualAngle20.Width div 2);
           shpActualAngle20.top := SmallWheelY - (shpActualAngle20.Height div 2);
         end;
      25: begin
           shpActualAngle25.left := SmallWheelX - (shpActualAngle25.Width div 2);
           shpActualAngle25.top := SmallWheelY - (shpActualAngle25.Height div 2);
         end;
    end;

    i := i + 5;
  end;
end;

procedure TfmKnifeSpinner.LoadKnife(Code, Scale, Size: string; Angle: Real);
begin
  Initialise;
  PatternInitialise;

  tblKnives.open;
  tblKnives.FindKey([Code, Scale, Size]);

  ActualPoints := ReadPattern(tblKnivesCode.Value,  tblKnivesSizeScale.Value, tblKnivesMeasuredSize.Value);

  PictureSize := -1;
  AdjustmentAngle := Angle;

  MainKnifeInitialise(True, False);

  if Length(ActualPoints) <= 3 then
  begin
    MessageDlgPos('This a manual knife or there are ' + #13 +
               'not enough points for this knife.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    KnifeLoaded := False;
  end;

  KnifeCode := tblKnivesCode.Value;
  KnifeScale := tblKnivesSizeScale.Value;
  KnifeSize := tblKnivesMeasuredSize.Value;
  KnifeArea := Knife.PatternNettArea; //SqFt

  lblKnifeCode.Caption := KnifeCode;
  lblKnifeSize.Caption := KnifeSize;

  cbUnitsKnifeChange(Self);

  tblKnives.Close;

  UpdateScreen;
end;

function TfmKnifeSpinner.FindUnitsIndex(UnitsCode: string): integer;
var
  FoundUnits: Boolean;
  i, IndexToUse: integer;
  s: string;

begin
  FoundUnits := False;

  IndexToUse := -1;
  for i := 0 to cbUnitsKnife.DropDownCount - 1 do
  begin
    s := cbUnitsKnife.Items[i];
    if s = UnitsCode then
      IndexToUse := i;
  end;

  FindUnitsIndex := IndexToUse;
end;

procedure TfmKnifeSpinner.AdjustRulersScale;
var
  iUnitPrice: integer;
  rUnitPrice: real;

begin
  //Reset
  rUnitPrice := rulerKnifeLeft.UnitPrice;
  rulerKnifeLeft.UnitSize := rulerKnifeLeft.UnitSize / rUnitPrice * 10;
  rulerKnifeLeft.UnitPrice := rulerKnifeLeft.UnitPrice / rUnitprice * 10;

  while rulerKnifeLeft.UnitSize > 50 do
  begin
    rulerKnifeLeft.UnitSize := rulerKnifeLeft.UnitSize / 2;
    rulerKnifeLeft.UnitPrice := rulerKnifeLeft.UnitPrice / 2;
  end;

  iUnitPrice := round(rulerKnifeLeft.UnitPrice);
  if iUnitPrice = 0 then
    iUnitPrice := 1;
  rulerKnifeLeft.UnitSize := rulerKnifeLeft.UnitSize / rulerKnifeLeft.UnitPrice * iUnitPrice;
  rulerKnifeLeft.UnitPrice := rulerKnifeLeft.UnitPrice / rulerKnifeLeft.UnitPrice * iUnitPrice;

  //Match bottom to left
  rulerKnifeBottom.UnitSize := rulerKnifeLeft.UnitSize;
  rulerKnifeBottom.UnitPrice := rulerKnifeLeft.UnitPrice;
end;

end.

