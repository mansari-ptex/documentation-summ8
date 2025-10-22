unit DigitiserMain;

interface

uses
  Classes, Graphics, Controls, Forms, Buttons, ExtCtrls, Messages, StdCtrls,
  ToolWin, ImgList, PathGlobals, ComCtrls, Dialogs, Types, TypInfo, Mask,
  DBCtrls, jpeg, CButton, VLabel, Vcl.Menus, IniFiles, DigitiserCalls;

type
  TSystem = (SATRASumm, TimeLine);
  TPointShape = (Dot, Triangle, Square, DigCursor);
  TNearestPoint = record
    Index: integer;
    Pt: TPathPoint;
    Distance: single;
  end;
  TArrowLocation = (TopLeft, TopRight, BottomLeft, BottomRight);
  TZoom = record
    Ratio: real;
    OffsetX: integer;
    OffsetY: integer;
  end;

  TfmDigitiser = class(TForm)
    sdDigFiles: TSaveDialog;
    odDigFiles: TOpenDialog;
    pnlMain: TPanel;
    tbMain: TPanel;
    btnNew: TSpeedButton;
    btnOpen: TSpeedButton;
    btnSave: TSpeedButton;
    btnListPatterns: TSpeedButton;
    btnZoomReset: TSpeedButton;
    btnHelp: TSpeedButton;
    btnDigOnOff: TSpeedButton;
    pnlDigitiser: TPanel;
    imgDigitiser: TImage;
    imgCross: TImage;
    pnlYesNo: TPanel;
    btnYes: TButton;
    btnNo: TButton;
    lblCloseShape: TLabel;
    Label1: TLabel;
    pnlHelp: TPanel;
    pnlZoom: TPanel;
    pnlDigitiserHelp: TPanel;
    imgDigitiserMap: TImage;
    pnlZoomHeader: TPanel;
    pnlDigitiserHelpHeader: TPanel;
    Button2: TButton;
    lblButton0: TLabel;
    lblButton1: TLabel;
    lblButton2: TLabel;
    lblButton3: TLabel;
    pnlMouseHelp: TPanel;
    lblMouse2: TLabel;
    lblMouse4: TLabel;
    lblMouse3: TLabel;
    pnlMouseHelpHeader: TPanel;
    imgCursor3: TImage;
    imgCursor2: TImage;
    imgCursor1: TImage;
    imgCursor0: TImage;
    imgCursor: TImage;
    imgMouseLeft: TImage;
    imgMouseRight: TImage;
    imgKeyboard: TImage;
    imgMouse: TImage;
    imgKeyboardShift: TImage;
    imgKeyboardCtrl: TImage;
    lblMouse5: TLabel;
    imgMouseWheel: TImage;
    pnlBottom: TPanel;
    sbBottom: TStatusBar;
    mMain: TMainMenu;
    mSystem: TMenuItem;
    mTimeLine: TMenuItem;
    N1: TMenuItem;
    mExit: TMenuItem;
    mSATRASumm: TMenuItem;
    pnlLogo: TPanel;
    imgSATRASumm: TImage;
    imgTimeLine: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnZoomResetClick(Sender: TObject);
    procedure btnDigOnOffClick(Sender: TObject);
    procedure SizeDigitiser;
    procedure MapDigitiser;
    procedure ClearDigitiser;
    procedure DrawPath(HighlightPoint: integer);
    procedure ResetZoom;
    procedure UpdateZoom;
    procedure ProcessButton(DigPt: TPathPoint; DigitiserButtonPressed: integer);
    procedure FileNew;
    procedure FileOpen;
    procedure FileSave;
    function FileSaveCheck : Boolean;
    procedure OpenFile(DigFileName : string);
    procedure SaveFile(DigFileName : string);
    procedure Drawline(DigPt1, DigPt2 : TPathPoint; pmode : TPenMode; pcol : TColor; pThickness : integer);
    procedure MarkPoint(DigPt: TPathPoint; Shape: TPointShape; pcol: TColor; pThickness : integer);
    procedure imgDigitiserMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgDigitiserMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function DigPtVisible(DigPt: TPathPoint) : Boolean;
    function DigPtToCanvasPt(DigPt: TPathPoint) : TPathPoint;
    function CanvasPtToDigPt(CanvasPt: TPathPoint) : TPathPoint;
    procedure ShowHelp;
    procedure PatternSave;
    procedure PatternNew;
    procedure PatternOpen;
    procedure SetDigitiser(X, Y, Button, Transducer, Pressure, Prox, TimeStamp: integer);
    procedure TimeDelay(Secs: real);
    procedure btnListPatternsClick(Sender: TObject);
    procedure btnYesClick(Sender: TObject);
    procedure PositionPanel(ThePanel: TPanel);
    procedure btnNoClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure imgDigitiserMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure sbBottomResize(Sender: TObject);
    procedure lblButton0MouseLeave(Sender: TObject);
    procedure lblButton0MouseEnter(Sender: TObject);
    procedure lblButton1MouseEnter(Sender: TObject);
    procedure lblButton1MouseLeave(Sender: TObject);
    procedure lblButton2MouseLeave(Sender: TObject);
    procedure lblButton2MouseEnter(Sender: TObject);
    procedure lblButton3MouseEnter(Sender: TObject);
    procedure lblButton3MouseLeave(Sender: TObject);
    procedure lblMouse2MouseEnter(Sender: TObject);
    procedure lblMouse2MouseLeave(Sender: TObject);
    procedure lblMouse4MouseEnter(Sender: TObject);
    procedure lblMouse4MouseLeave(Sender: TObject);
    procedure lblMouse3MouseLeave(Sender: TObject);
    procedure lblMouse3MouseEnter(Sender: TObject);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ZoomIn(X, Y: integer);
    procedure ZoomOut(X, Y: integer);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure lblMouse5MouseEnter(Sender: TObject);
    procedure lblMouse5MouseLeave(Sender: TObject);
    procedure ProcessPointAdding(DigPt: TPathPoint);
    procedure UpdateScreen;
    procedure mSATRASummClick(Sender: TObject);
    procedure mTimeLineClick(Sender: TObject);
    procedure ReadDigitiserIni;
    procedure WriteDigitiserIni;
    procedure mExitClick(Sender: TObject);
  private
    { Private declarations }
    AddingPoint: Boolean;
    DefinitionFound: Boolean;
  public
    { Public declarations }
    SystemIni: TIniFile;
    DragXStart, DragYStart: integer;
    DigitiserState: TDigitiserState;
  end;

var
  fmDigitiser: TfmDigitiser;
  System: TSystem;
  SATRASummDirectory, TimeLineDirectory: string;

const
  clZoomRed = $003124A4;

implementation

uses
  Windows, SysUtils, PathGeometry, DigitiserPatternName, DigitiserAllPatterns,
  General, Cmnvars, OutOfMemory, SHFolder;

{$R *.DFM}

var
  DigPtToCanvasPtRatio: real;
  Zoom: TZoom;
  CursorPrev, CursorPos, HoldPoint: TPathPoint;
  DigitiserButtonPressed: integer;
  IgnoreButtons, PatternNotClosed: boolean;
  LineLength, AreaSqIns: single;
  NearestPoint, ChosenPoint: TNearestPoint;
  DigitiserSizeInt, DigitiserSizeX, DigitiserSizeY: integer;
  DigitiserSizeXYRatio: real;
  ReadyToDraw: boolean;
  fmDigitiserCalls: TfmDigitiserCalls;
  TabletThere: boolean;
  LastButtonPressed: integer;

const
  clHighlightKey = $007171FF;
  clPoint = clBlack;
  clLine = clWhite;

procedure TfmDigitiser.FormCreate(Sender: TObject);
var
  AppDirPath: string;

begin
  clMain := $00F6F6F6;
  clBack := $00EAEAEA;
  clBackDark := $00DDDDDD;
  clBackVeryDark := $00A0A0A0;
  clText := $00707070;
  clData := clBlack;
  clEditing := clWindow;

  AutoColor(Self);

  FileNeedsSaving := FALSE;
  DigitiserState := _Off;
  PatternNotClosed := FALSE;
  NumberOfPatterns := 0;
  AddingPoint := False;
  DefinitionFound := False;

  //Start Position off screen
  CursorPrev.x := -100;
  CursorPrev.y := -100;
  LastButtonPressed := 0;

  System := SATRASumm;
  imgSATRASumm.Visible := True;

  SystemName := 'Digitiser';
  AppDirPath := GetSpecialFolderPath(CSIDL_COMMON_APPDATA) + '\SATRA\Digitiser';
  ForceDirectories(AppDirPath);
  SystemIniName := AppDirPath + '\Digitiser.ini';

  SystemIni := TIniFile.Create(SystemIniName);
  ReadDigitiserIni;

  FileRef := 'Untitled';
  Caption := 'Digitiser : ' + FileRef;

  NoRawPts := 0;
  NoSmoothPts := 0;
  LineLength := 0;

  NearestPoint.Index := 0;
  NearestPoint.Distance := 999999999;

  ResetZoom;

  fmDigitiserCalls := TfmDigitiserCalls.Create(self);
  if not fmDigitiserCalls.CreateDigitiserControl then
  begin
    TabletThere := False;

    DigitiserSizeX := 18000;
    DigitiserSizeY := 12000;
    DigitiserSizeXYRatio := DigitiserSizeX / DigitiserSizeY;
    DigitiserSizeInt := 1;
    btnDigOnOff.Enabled := False;

    SizeDigitiser;
  end
  else
  begin
    try
      TabletThere := True;
      fmDigitiserCalls.StartDigitiser(True);
      fmDigitiserCalls.DigitiserSizeInfo(DigitiserSizeX, DigitiserSizeY, DigitiserSizeInt, DigitiserSizeXYRatio);
      fmDigitiserCalls.StopDigitiser;
      SizeDigitiser;
    except
      TabletThere := False;
      fmDigitiserCalls.DestroyDigitiserControl;

      DigitiserSizeX := 18000;
      DigitiserSizeY := 12000;
      DigitiserSizeXYRatio := DigitiserSizeX / DigitiserSizeY;
      DigitiserSizeInt := 1;
      btnDigOnOff.Enabled := False;

      SizeDigitiser;
    end;
  end;

  FileNew;
end;

procedure TfmDigitiser.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  X, Y: integer;

begin
  X := round(imgDigitiser.width / 2);
  Y := round(imgDigitiser.height / 2);

  ZoomOut(X, Y);
  Handled := True;
end;

procedure TfmDigitiser.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  X, Y: integer;

begin
  X := round(imgDigitiser.width / 2);
  Y := round(imgDigitiser.height / 2);

  ZoomIn(X, Y);
  Handled := True;
end;

procedure TfmDigitiser.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not tbMain.enabled then
    CanClose := False
  else
  begin
    if DigitiserState = _On then
      btnDigOnOff.Click;

    CanClose := FileSaveCheck;
  end;

  if CanClose then
  begin
    WriteDigitiserIni;
    SystemIni.Free;
  end;
end;

procedure TfmDigitiser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfmDigitiser.FormPaint(Sender: TObject);
var
  s, ss: string;

begin
  DrawPath(0);

  sbBottom.Panels.Items[4].Text := 'Points : ' + inttostr(NoRawPts);

  if System = TimeLine then
  begin
    if (DigitiserState = _Off) then
    begin
      if LineLength = 0 then
        ss := 'Length :'
      else
      begin
        str((LineLength / 10) : 5 : 2, s);
        ss := 'Length : ' + s + ' cm / ';
        str((LineLength / 10 * CMS_TO_INCHES) : 5 : 2, s);
        ss := ss + s + ' in';
      end;
      sbBottom.Panels.Items[5].Text := ss;

      if AreaSqIns = 0 then
        ss := 'Area :'
      else
      begin
        str((AreaSqIns * SQINCHES_TO_SQFT * SQFT_TO_SQCMS) : 5 : 2, s);
        ss := 'Area : ' + s + ' cm² / ';
        str((AreaSqIns * SQINCHES_TO_SQFT) : 5 : 4, s);
        ss := ss + s + ' ft²';
      end;
      sbBottom.Panels.Items[6].Text := ss;
    end;
  end;
end;

procedure TfmDigitiser.FormResize(Sender: TObject);
begin
  SizeDigitiser;
  DrawPath(0);

  //Logo
  if pnlDigitiserHelp.Left < 323 then
    pnlLogo.Width := 314 - (323 - pnlDigitiserHelp.Left)
  else
    pnlLogo.Width := 314;
end;

procedure TfmDigitiser.btnNewClick(Sender: TObject);
begin
  //Clear Digitiser area
  ClearDigitiser;
  FileNew;

  UpdateScreen;
end;

procedure TfmDigitiser.btnNoClick(Sender: TObject);
begin
  pnlYesNo.Visible := False;
  IgnoreButtons := False;

  tbMain.Enabled := True;
end;

procedure TfmDigitiser.btnOpenClick(Sender: TObject);
begin
  FileOpen;

  UpdateScreen;
end;

procedure TfmDigitiser.ProcessPointAdding(DigPt: TPathPoint);
var
  i: integer;

begin
  if (NoRawPts + 1) < MaxRawPoints then
  begin
    inc(NoRawPts);
    for i := NoRawPts - 1 downto ChosenPoint.Index do
      RawPts[i + 1] := RawPts[i];
    //insert new point at i
    RawPts[ChosenPoint.Index + 1].x := digpt.x;
    RawPts[ChosenPoint.Index + 1].y := digpt.y;
    RawPts[ChosenPoint.Index + 1].c := Normal;
    for i := 1 to 6 do
    begin
      RawPts[ChosenPoint.index + 1].Feature[i].Code := 'no_feature';
      RawPts[ChosenPoint.index + 1].Feature[i].Description := '';
    end;
    AnalyseLine(MakeDrawingPoints);
    DrawPath(0);
  end
  else
    messagedlg('Number of points already at maximum', mtInformation, [mbOK], 0);
end;

procedure TfmDigitiser.btnSaveClick(Sender: TObject);
begin
  FileSave;

  UpdateScreen;
end;

procedure TfmDigitiser.btnHelpClick(Sender: TObject);
begin
  ShowHelp;
end;

procedure TfmDigitiser.btnZoomResetClick(Sender: TObject);
begin
  ResetZoom;
end;

procedure TfmDigitiser.Button2Click(Sender: TObject);
begin
  messagedlg(intToStr(Height) + ' - ' + intToStr(Width), mtInformation, [mbOk], 0);
end;

procedure TfmDigitiser.btnYesClick(Sender: TObject);
begin
  pnlYesNo.Visible := False;
  RawPts[NoRawPts] := HoldPoint;
  RawPts[NoRawPts].c := Normal;

  if System = SATRASumm then
    PatternSave;

  PatternNotClosed := FALSE;
  IgnoreButtons := False;

  tbMain.Enabled := True;
end;

procedure TfmDigitiser.btnListPatternsClick(Sender: TObject);
begin
  PatternOpen;

  UpdateScreen;
end;

procedure TfmDigitiser.btnClearClick(Sender: TObject);
begin
  FileNeedsSaving := True;
  LineLength := AnalyseLine(MakeDrawingPoints);
end;

procedure TfmDigitiser.btnDigOnOffClick(Sender: TObject);
begin
  if (DigitiserState = _Off) then
  begin
    DigitiserState := _On;
    fmDigitiser.Refresh;
    fmDigitiserCalls.StartDigitiser(False);
  end
  else
  begin
    DigitiserState := _Off;

    imgCross.Visible := False;

    fmDigitiserCalls.StopDigitiser;

    if System = TimeLine then
      LineLength := AnalyseLine(MakeDrawingPoints);

    AreaSqIns := CalculateArea;

    //Put the Cursor away again
    CursorPrev.x := -100;
    CursorPrev.y := -100;

    sbBottom.Panels.Items[1].Text := 'x : ';
    sbBottom.Panels.Items[2].Text := 'y : ';
    sbBottom.Panels.Items[3].Text := 'Button : ';
  end;
  fmDigitiser.Refresh;

  UpdateScreen;
end;

procedure TfmDigitiser.SizeDigitiser;
var
  FormAreaWidth, FormAreaHeight: integer;
  DigAreaWidth, DigAreaHeight: single;
  WidthFactor, HeightFactor, SizeFactor: single;
  Failed: boolean;

begin
  Failed := FALSE;

  //Find available space
  FormAreaWidth := pnlMain.width;
  FormAreaHeight := pnlMain.height;

  //Decide which space to use
  DigAreaHeight := 1;
  DigAreaWidth := DigAreaHeight * DigitiserSizeXYRatio;
  HeightFactor := (FormAreaHeight * 1.00) / DigAreaHeight;
  WidthFactor := (FormAreaWidth * 1.00) / DigAreaWidth;
  if WidthFactor < HeightFactor then
    SizeFactor := WidthFactor
  else
    SizeFactor := HeightFactor;
  DigAreaHeight := DigAreaHeight * SizeFactor;
  DigAreaWidth := DigAreaWidth * SizeFactor;

  //Create new image
  if not(imgDigitiser = nil) then
    FreeAndNil(imgDigitiser);

  try
    imgDigitiser := TImage.create(self);
  except
    fmMemoryError.TidyUp(self);
    Failed := TRUE;
  end;

  if not Failed then
  begin
    pnlDigitiser.parent := pnlMain;
    pnlDigitiser.left := round((FormAreaWidth - DigAreaWidth) / 2);
    pnlDigitiser.top := round((FormAreaHeight - DigAreaHeight) / 2);
    pnlDigitiser.width := round(DigAreaWidth);
    pnlDigitiser.height := round(DigAreaHeight);
    imgDigitiser.OnMouseUp := imgDigitiserMouseUp;
    imgDigitiser.OnMouseDown := imgDigitiserMouseDown;
    imgDigitiser.OnMouseMove := imgDigitiserMouseMove;
    imgDigitiser.Width := pnlDigitiser.Width;
    imgDigitiser.Height := pnlDigitiser.Height;
    imgDigitiser.Parent := pnlDigitiser;
    imgDigitiser.Align := alClient;
    imgDigitiser.SendToBack;


    //Set main ratio
    DigPtToCanvasPtRatio := pnlDigitiser.width / DigitiserSizeX;
  end;

  //Digitiser Extent
  imgDigitiserMap.destroy;
  try
    imgDigitiserMap := TImage.create(self);
  except
    fmMemoryError.TidyUp(self);
    Failed := TRUE;
  end;

  if not Failed then
  begin
    imgDigitiserMap.Parent := pnlZoom;
    imgDigitiserMap.width := 80;
    imgDigitiserMap.height := round(imgDigitiserMap.width / DigitiserSizeXYRatio);
    imgDigitiserMap.left := ((pnlZoom.Width - imgDigitiserMap.width) div 2);
    imgDigitiserMap.top := (((pnlZoom.Height - pnlZoomHeader.Height) - imgDigitiserMap.Height) div 2) + pnlZoomHeader.Height;
    ResetZoom;

    //Clear Digitiser area
    ClearDigitiser;
  end;
  ReadyToDraw := True;
end;

procedure TfmDigitiser.MapDigitiser;
var
  InnerBorderWidth, InnerBorderHeight: integer;
  OuterWidth, OuterHeight, InnerWidth, InnerHeight: integer;
  DigExtentLeft, DigExtentTop, DigExtentRight, DigExtentBottom: integer;

begin
  InnerBorderWidth := round(imgDigitiserMap.width * 0.25);
  InnerBorderHeight := round(imgDigitiserMap.height * 0.25);

  OuterWidth := imgDigitiserMap.width;
  OuterHeight := imgDigitiserMap.height;

  InnerWidth := OuterWidth - (InnerBorderWidth * 2);
  InnerHeight := OuterHeight - (InnerBorderHeight * 2);

  if (imgDigitiser.width = 0) or (imgDigitiser.height = 0) then
  begin
    DigExtentLeft := 0;
    DigExtentRight := 0;
    DigExtentBottom := 0;
    DigExtentTop := 0;
  end
  else
  begin
    DigExtentLeft := InnerBorderWidth + round((Zoom.OffsetX / (imgDigitiser.width * Zoom.Ratio)) * InnerWidth);
    DigExtentRight := DigExtentLeft + round(InnerWidth / Zoom.Ratio);
    DigExtentBottom := imgDigitiserMap.height - (InnerBorderHeight - (round((Zoom.OffsetY / (imgDigitiser.height * Zoom.Ratio)) * InnerHeight)));
    DigExtentTop := DigExtentBottom - round(InnerHeight / Zoom.Ratio);
  end;

  imgDigitiserMap.canvas.brush.color := OurColor(clBtnFace);
  imgDigitiserMap.canvas.FillRect(Rect(0, 0, OuterWidth, OuterHeight));

  imgDigitiserMap.canvas.brush.color := OurColor(clAqua);
  imgDigitiserMap.canvas.FillRect(Rect(InnerBorderWidth, InnerBorderHeight, InnerBorderWidth + InnerWidth,
                                       InnerBorderHeight + InnerHeight));

  imgDigitiserMap.canvas.brush.color := clZoomRed;
  imgDigitiserMap.canvas.FillRect(Rect(DigExtentLeft, DigExtentTop, DigExtentRight, DigExtentBottom));

  imgDigitiserMap.canvas.brush.color := clBlack;
  imgDigitiserMap.canvas.FrameRect(Rect(0, 0, InnerBorderWidth + InnerWidth + InnerBorderWidth,
                                        InnerBorderHeight + InnerHeight + InnerBorderHeight));
  imgDigitiserMap.canvas.FrameRect(Rect(InnerBorderWidth, InnerBorderHeight, InnerBorderWidth + InnerWidth,
                                        InnerBorderHeight + InnerHeight));
end;

procedure TfmDigitiser.ClearDigitiser;
begin
  if not ((imgDigitiser.width <= 0) or (imgDigitiser.height <= 0)) then
  begin
    imgDigitiser.canvas.brush.color := clGray;
    imgDigitiser.canvas.FillRect(Rect(0, 0, imgDigitiser.width, imgDigitiser.height));
  end;
end;

procedure TfmDigitiser.DrawPath(HighlightPoint: integer);
var
  i, j: integer;
  FeaturesList: string;
  pcol: TColor;
  pThickness: integer;
  pShape: TPointShape;

begin
  ClearDigitiser;

  pThickness := 1;

  if System = TimeLine then
  begin
    if (DigitiserState = _On) or (NoRawPts = 0) then
    begin
      sbBottom.Panels.Items[5].Text := 'Length : ';
      sbBottom.Panels.Items[6].Text := 'Area : ';
    end;
  end;

  if NoRawPts > 0 then
  begin
    if DigitiserState = _Off then
    begin
      if System = TimeLine then
      begin
        //Draw Smooth Points
        for i := 1 to NoSmoothPts do
          if (SmoothPts[i].c <> NewPath) then
            Drawline(SmoothPts[i - 1], SmoothPts[i], pmCopy, clLine, pThickness);
      end
      else if System = SATRASumm then
      begin
        //Draw Raw points
        for i := 1 to NoRawPts do
          if (RawPts[i].c <> NewPath) then
            Drawline(RawPts[i - 1], RawPts[i], pmCopy, clLine, pThickness);
      end;
    end;

     //Raw Points marked
    for i := 1 to NoRawPts do
    begin
      if (DigitiserState = _On) and (i > 1) and ((RawPts[i].c <> NewPath)) then
         Drawline(RawPts[i - 1], RawPts[i], pmCopy, clLine, pThickness);

      pCol := clPoint;
      pShape := Dot;
      MarkPoint(RawPts[i], pShape, pcol, pThickness);

      if (RawPts[i].c = NewPath) then
      begin
        pShape := Square;
        MarkPoint(RawPts[i], pShape, pcol, pThickness);
      end
      else if (RawPts[i].c = Corner) then
      begin
        pShape := Triangle;
        MarkPoint(RawPts[i], pShape, pcol, pThickness);
      end;
    end;
  end;
end;

procedure TfmDigitiser.ResetZoom;
begin
  Zoom.Ratio := 1;
  Zoom.OffsetX := 0;
  Zoom.OffsetY := 0;
  UpdateZoom;
end;

procedure TfmDigitiser.UpdateZoom;
begin
  sbBottom.Panels.Items[0].Text := 'Zoom : ' + intToStr(round(Zoom.Ratio * 100)) + '%';
  MapDigitiser;

  ClearDigitiser;
  DrawPath(0);

  if (DigitiserState = _On) then
    MarkPoint(CursorPos, DigCursor, clPoint, 1);
end;

procedure TfmDigitiser.TimeDelay(Secs: real);
var
  Tics: double;

begin
  Tics := Now;
  repeat
  until ((Now - Tics) * 86400) > Secs;
end;

procedure TfmDigitiser.SetDigitiser(X, Y, Button, Transducer, Pressure, Prox, TimeStamp: integer);
var
  s, sx, sy: string;

begin
  Application.ProcessMessages;

  if ReadyToDraw then
  begin
    fmDigitisercalls.TabletEventOff;
    ReadyToDraw := False;

    if Prox = 1 then
    begin
      sx := inttostr(X);
      sy := inttostr(Y);
    end
    else
    begin
      sx := '-';
      sy := '-';
    end;
    sbBottom.Panels.Items[1].Text := 'x : ' + sx;
    sbBottom.Panels.Items[2].Text := 'y : ' + sy;

    case Button of
      0 : DigitiserButtonPressed := 0;
      1 : DigitiserButtonPressed := 1;
      2 : DigitiserButtonPressed := 2;
      4 : DigitiserButtonPressed := 3;
      8 : DigitiserButtonPressed := 4;
    end;

    if DigitiserButtonPressed = LastButtonPressed then
      DigitiserButtonPressed := 0
    else
      LastButtonPressed := DigitiserButtonPressed;

    CursorPos.x := X;
    CursorPos.y := Y;

    if (Prox = 1) then
    begin
      MarkPoint(CursorPos, DigCursor, clPoint, 1);

      CursorPrev := CursorPos;
      if not IgnoreButtons and (DigitiserButtonPressed > 0) then
      begin
        ProcessButton(CursorPos, DigitiserButtonPressed);
        s := inttostr(DigitiserButtonPressed);
      end
      else
        s:= '';
      sbBottom.Panels.Items[3].Text := 'Button : ' + s;
    end;

    ReadyToDraw := True;
    fmDigitisercalls.TabletEventOn;
  end;
end;

procedure TfmDigitiser.ProcessButton(DigPt: TPathPoint;
                                     DigitiserButtonPressed: integer);
var
  i, NewPathPt: integer;
  SavePattern: boolean;

begin
  // 1 Add Point or close
  // 2 Add Corner (Not Summs)
  // 3 New Path   (Not Summs)
  // 4 Delete Point

  HoldPoint := digPt;
  SavePattern := FALSE;

  if System = SATRASumm then
  begin
    if (DigitiserButtonPressed = 2) or (DigitiserButtonPressed = 3) then
      DigitiserButtonPressed := 0;
  end;

  //Add Point or Corner
  if (DigitiserButtonPressed = 1) or (DigitiserButtonPressed = 2) or (DigitiserButtonPressed = 3) then
  begin
    //If at start force New path
    if (NoRawPts = 0) then
    begin
      DigitiserButtonPressed := 3;
      PatternNotClosed := TRUE;
    end;

    //Do not allow 2 consecutive new path points
    if (NoRawPts > 0) then
    begin
      if (DigitiserButtonPressed = 3) and (RawPts[NoRawPts].c = NewPath) then
        DigitiserButtonPressed := 1;
    end;

    //Check for maximum points
    if (NoRawPts + 1) < MaxRawPoints then
    begin
      //Check for proximity to last point
      if (NoRawPts = 0) or (distance(RawPts[NoRawPts].x, RawPts[NoRawPts].y, DigPt.x, DigPt.y) > 100) then
      begin
       //Check for closed shape
        NewPathPt := 1;

        if System = TimeLine then
        begin
          for i := NoRawPts downto 1 do
          begin
            if (RawPts[i].c = NewPath) and (NewPathPt = 1) then
              NewPathPt := i;
          end;
        end;

        inc(NoRawPts);
        RawPts[NoRawPts] := DigPt;

        if DigitiserButtonPressed = 3 then
          //Start Point
          RawPts[NoRawPts].c := NewPath
        else if DigitiserButtonPressed = 2 then
          //Corner Point
          RawPts[NoRawPts].c := Corner
        else
          RawPts[NoRawPts].c := Normal;

        for i := 1 to 6 do
        begin
          RawPts[NoRawPts].Feature[i].Code := 'no_feature';
          RawPts[NoRawPts].Feature[i].Description := '';
        end;
        HoldPoint := RawPts[NoRawPts];

        fmDigitiser.Refresh;

        if (NoRawPts > 1) and (distance(RawPts[NewPathPt].x, RawPts[NewPathPt].y, DigPt.x, DigPt.y) < 100) then
        begin
          HoldPoint := RawPts[NewPathPt];

          IgnoreButtons := True;
          PositionPanel(pnlYesNo);
        end;
      end;
    end;
  end
  //Delete Point
  else if (DigitiserButtonPressed = 4) then
  begin
    if (NoRawPts >= 1) and (distance(RawPts[NoRawPts].x, RawPts[NoRawPts].y, DigPt.x, DigPt.y) < 500) then
    begin
      dec(NoRawPts);

      if NoRawPts = 0 then
        PatternNotClosed := FALSE;

      fmDigitiser.Refresh;
    end;
  end;

  if System = TimeLine then
  begin
    if (DigitiserButtonPressed >= 1) and (DigitiserButtonPressed <= 4) then
      FileNeedsSaving := TRUE;
  end;
end;

procedure TfmDigitiser.FileNew;
begin
  if FileSaveCheck then
  begin
    NoRawPts := 0;
    NoSmoothPts := 0;
    NumberOfPatterns := 0;

    ResetZoom;

    fmDigitiser.Refresh;
    FileRef := 'Untitled';
    caption := 'Digitiser : ' + FileRef;

    if System = TimeLine then
    begin
      sbBottom.Panels.Items[5].Text := 'Length :';
      sbBottom.Panels.Items[6].Text := 'Area :';
    end
    else if System = SATRASumm then
    begin
      sbBottom.Panels.Items[5].Text := '';
      sbBottom.Panels.Items[6].Text := '';
    end;
  end;
end;

procedure TfmDigitiser.FileOpen;
var
  GoOpen: boolean;

begin
  screen.Cursor := crHourglass;
  GoOpen := FileSaveCheck;

  if GoOpen then
  begin
    if (System = SATRASumm) and DirectoryExists(SATRASummDirectory) then
      odDigFiles.InitialDir := SATRASummDirectory
    else
    begin
      screen.Cursor := crDefault;
      messagedlg('Settings | Paths directory does not exist', mtInformation, [mbOK], 0);
      odDigFiles.InitialDir := ExtractFilePath(ExpandFileName(Application.ExeName));
      if (System = SATRASumm) then
        SATRASummDirectory := odDigFiles.InitialDir;
    end;

    screen.Cursor := crDefault;

    odDigFiles.Title := 'Open';
    if (odDigFiles.Execute) then
    begin
      ResetZoom;

      if FileExists(odDigFiles.FileName) then
        OpenFile(odDigFiles.FileName)
      else
        messagedlg('Error opening Path', mtInformation, [mbOk], 0);

      fmDigitiser.Refresh;

      FileRef := odDigFiles.FileName;
      caption := 'Digitiser : ' + FileRef;
    end;
  end;
end;

procedure TfmDigitiser.FileSave;
begin
  screen.Cursor := crHourglass;
  IgnoreButtons := True;
  if (System = SATRASumm) and DirectoryExists(SATRASummDirectory) then
    sdDigFiles.InitialDir := SATRASummDirectory
  else if (System = TimeLine) and DirectoryExists(TimeLineDirectory) then
    sdDigFiles.InitialDir := TimeLineDirectory
  else
  begin
    screen.Cursor := crDefault;
    messagedlg('Settings | Paths directory does not exist', mtInformation, [mbOK], 0);
    sdDigFiles.InitialDir := ExtractFilePath(ExpandFileName(Application.ExeName));
    if (System = SATRASumm) then
      SATRASummDirectory := sdDigFiles.InitialDir
    else if (System = TimeLine) then
      TimeLineDirectory := sdDigFiles.InitialDir;
  end;
  screen.Cursor := crDefault;

  try
    sdDigFiles.FileName := FileRef;
    if (sdDigFiles.Execute) then
    begin
      FileRef := sdDigFiles.FileName;
      FileRef := changeFileExt(FileRef, '');

      SaveFile(sdDigFiles.FileName);

      if (System = SATRASumm) then
        SATRASummDirectory := ExtractFilePath(ExpandFileName(sdDigFiles.FileName))
      else if (System = TimeLine) then
        TimeLineDirectory := ExtractFilePath(ExpandFileName(sdDigFiles.FileName));
    end;
  except
    on EInOutError do
      MessageDlg('Error saving Path', mtInformation, [mbOK], 0);
  end;
  IgnoreButtons := False;
end;

function TfmDigitiser.FileSaveCheck: Boolean;
var
  Save: word;
  Cancel: boolean;

begin
  Cancel := FALSE;
  if (FileNeedsSaving = TRUE) then
  begin
    Save := messagedlg('Save File?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    if Save = mrYes then
      FileSave
    else if Save = mrNo then
      FileNeedsSaving := FALSE
    else
    begin
      Cancel := TRUE;
      screen.cursor := crDefault;
    end;
  end;

  FileSaveCheck := not Cancel;
end;

procedure TfmDigitiser.OpenFile(DigFileName: string);
var
  DigFile: TextFile;
  junk, StyleName: string;
  spc: char;
  c, i, j, p, q, r, ExistingPoints, FileDigitiserSizeInteger, TempNoPatterns: integer;
  PatternFits, StopReading, TooManyPoints, ValidSATRASumm, VariableFeatures: boolean;
  StitchingType: string;
  FeaturesRemoved: Boolean;

begin
  TooManyPoints := False;
  ValidSATRASumm := True;
  PatternFits := True;
  StopReading := FALSE;

  assignfile(DigFile, DigFileName);
  reset(DigFile);

  if System = SATRASumm then
  begin
    NumberOfPatterns := 0;

    readln(DigFile, StyleName);

    if StyleName = 'DIGITISED' then
    try
      readln(DigFile, NumberOfPatterns);

      for i := 1 to NumberOfPatterns do
        readln(DigFile, SummsCollection[i].PatternName);

      for i := 1 to NumberOfPatterns do
      begin
        for j := 1 to 3 do
          readln(DigFile, junk);

        readln(DigFile, SummsCollection[i].NoPoints);

        for j := 1 to SummsCollection[i].NoPoints do
          readln(DigFile, SummsCollection[i].Points[j].x, SummsCollection[i].Points[j].y);
      end;
    except
      on eInOutError do
      begin
        ValidSATRASumm := False;
        NumberOfPatterns := 0;
      end;
      on eRangeError do
      begin
        TooManyPoints := True;
        NumberOfPatterns := 0;
      end;
    end
    else
      ValidSATRASumm := False;
    if not ValidSATRASumm then
      messagedlg('Not a SATRASumm digitiser file', mtInformation, [mbOK], 0);
  end;

  if TooManyPoints then
  begin
    messagedlg('Too many points', mtInformation, [mbOK], 0);
    ValidSATRASumm := False;
  end;

  if ValidSATRASumm then
  begin
    try
      if TabletThere then
        fmDigitiserCalls.StartDigitiser(False);
      readln(DigFile, FileDigitiserSizeInteger);
      if TabletThere then
      begin
        PatternFits := (FileDigitiserSizeInteger = DigitiserSizeInt);
        fmDigitiserCalls.StopDigitiser;
      end
      else
      begin
        //size from file
        PatternFits := True;
        case FileDigitiserSizeInteger of
          1: begin
               DigitiserSizeX := 18000;
               DigitiserSizeY := 12000;
             end;
          2:begin
               DigitiserSizeX := 24000;
               DigitiserSizeY := 18000;
             end;
          3: begin
               DigitiserSizeX := 12000;
               DigitiserSizeY := 12000;
             end;
        end;
        DigitiserSizeXYRatio := DigitiserSizeX / DigitiserSizeY;
        SizeDigitiser;
      end;
    except
      PatternFits := False;
    end;

    //Check pattern fits
    if not PatternFits then
    begin
      messagedlg('Pattern too big - Digitised on bigger tablet', mtInformation, [mbOk], 0);
      NoRawPts := 0;

    end
    else
      AreaSqIns := CalculateArea;
  end;

  closefile(DigFile);

  FileNeedsSaving := FALSE;
end;

procedure TfmDigitiser.SaveFile(DigFileName: string);
var
  DigFile: TextFile;
  c, i, j: integer;

begin
  assignfile(DigFile, DigFileName);
  rewrite(DigFile);

  if System = TimeLine then
  begin
    writeln(DigFile, 'blank');
    writeln(DigFile, 'Version 3');
    for i := 1 to 2 do
      writeln(DigFile, 'NO_RECORD');
    writeln(DigFile, '0');
    writeln(DigFile, NoRawPts);

    for i := 1 to NoRawPts do
    begin
      case RawPts[i].c of
        Normal : c := 0;
        Corner : c := 1;
        NewPath : c := 2;
        else
          c := 0;
      end;

      writeln(DigFile, RawPts[i].x, ' ', RawPts[i].y, ' ', c, ' ',
              Format('%-30s', [RawPts[i].Feature[1].Code]), ' ',
              Format('%-30s', [RawPts[i].Feature[2].Code]), ' ',
              Format('%-30s', [RawPts[i].Feature[3].Code]), ' ',
              Format('%-30s', [RawPts[i].Feature[4].Code]), ' ',
              Format('%-30s', [RawPts[i].Feature[5].Code]), ' ',
              Format('%-30s', [RawPts[i].Feature[6].Code]),
              GetEnumName(TypeInfo(TPath), 0));
    end;

    writeln(DigFile, DigitiserSizeInt);
    closefile(DigFile);

    LineLength := AnalyseLine(SaveOutputFiles);
    AreaSqIns := CalculateArea;

    FileNeedsSaving := FALSE;
  end
  else if System = SATRASumm then
  begin
    writeln(DigFile, 'DIGITISED');
    writeln(DigFile, NumberOfPatterns);

    if (NumberOfPatterns > 0) then
    begin
      i := 0;
      repeat
        inc(i);
        writeln(DigFile, SummsCollection[i].PatternName);
      until i = NumberOfPatterns;

      i := 0;
      repeat
        inc(i);

        for j := 1 to 3 do
         writeln(DigFile, '0');

        writeln(DigFile, SummsCollection[i].NoPoints);

        for j := 1 to SummsCollection[i].NoPoints do
          writeln(DigFile, SummsCollection[i].Points[j].x,'   ', SummsCollection[i].Points[j].y);
      until i = NumberOfPatterns;
    end;

    writeln(DigFile, DigitiserSizeInt);

    closefile(DigFile);
  end;

  FileNeedsSaving := FALSE;

  FileRef := DigFileName;
  caption := 'Digitiser : ' + FileRef;
end;

procedure TfmDigitiser.sbBottomResize(Sender: TObject);
begin
{  sbBottom.Panels.Items[7].Width := sbBottom.Width - sbBottom.Panels.Items[0].Width
                                                   - sbBottom.Panels.Items[1].Width
                                                   - sbBottom.Panels.Items[2].Width
                                                   - sbBottom.Panels.Items[3].Width
                                                   - sbBottom.Panels.Items[4].Width
                                                   - sbBottom.Panels.Items[5].Width
                                                   - sbBottom.Panels.Items[6].Width
                                                   - sbBottom.Panels.Items[8].Width;}
end;

procedure TfmDigitiser.Drawline(DigPt1, DigPt2: TPathPoint; pmode: TPenMode; pcol: TColor; pThickness : integer);
var
  CanvasPt1, CanvasPt2: TPathPoint;

begin
  if not ((imgDigitiser.width <= 0) or (imgDigitiser.height <= 0)) then
  begin
    CanvasPt1 := DigPtToCanvasPt(DigPt1);
    CanvasPt2 := DigPtToCanvasPt(DigPt2);

    imgDigitiser.canvas.pen.mode := pmode;
    imgDigitiser.canvas.pen.color := pcol;
    imgDigitiser.canvas.pen.Width := pThickness;
    imgDigitiser.canvas.moveto(CanvasPt1.x, CanvasPt1.y);
    imgDigitiser.canvas.lineto(CanvasPt2.x, CanvasPt2.y);
  end;
end;

procedure TfmDigitiser.MarkPoint(DigPt: TPathPoint;
                                 Shape: TPointShape;
                                 pcol: TColor;
                                 pThickness: integer);
var
  CanvasPt: TPathPoint;

begin
  if not ((imgDigitiser.width <= 0) or (imgDigitiser.height <= 0)) then
  begin
    CanvasPt := DigPtToCanvasPt(DigPt);

    imgDigitiser.canvas.pen.color := pcol;
    imgDigitiser.canvas.pen.Width := pThickness;
    case Shape of
      Dot:
        begin
          imgDigitiser.canvas.moveto(CanvasPt.x, CanvasPt.y);
          imgDigitiser.canvas.lineto(CanvasPt.x + 1, CanvasPt.y + 1);
          imgDigitiser.canvas.lineto(CanvasPt.x - 1, CanvasPt.y + 1);
          imgDigitiser.canvas.lineto(CanvasPt.x - 1, CanvasPt.y - 1);
          imgDigitiser.canvas.lineto(CanvasPt.x + 1, CanvasPt.y - 1);
          imgDigitiser.canvas.lineto(CanvasPt.x + 1, CanvasPt.y + 1);
        end;
      Square:
        begin
          imgDigitiser.canvas.moveto(CanvasPt.x - 6, CanvasPt.y - 6);
          imgDigitiser.canvas.lineto(CanvasPt.x - 6, CanvasPt.y + 6);
          imgDigitiser.canvas.lineto(CanvasPt.x + 6, CanvasPt.y + 6);
          imgDigitiser.canvas.lineto(CanvasPt.x + 6, CanvasPt.y - 6);
          imgDigitiser.canvas.lineto(CanvasPt.x - 6, CanvasPt.y - 6);
        end;
      Triangle:
        begin
          imgDigitiser.canvas.moveto(CanvasPt.x - 7, CanvasPt.y + 5);
          imgDigitiser.canvas.lineto(CanvasPt.x, CanvasPt.y - 9);
          imgDigitiser.canvas.lineto(CanvasPt.x + 7, CanvasPt.y + 5);
          imgDigitiser.canvas.lineto(CanvasPt.x - 7, CanvasPt.y + 5);
        end;
      DigCursor:
        begin
          imgCross.Visible := False;
          imgCross.Left := CanvasPt.x - (imgCross.Width div 2);
          imgCross.Top := CanvasPt.y - (imgCross.Height div 2);
          imgCross.Visible := True;
          imgCross.BringToFront;
        end;
    end;
  end;
end;

procedure TfmDigitiser.mExitClick(Sender: TObject);
begin
  close;
end;

procedure TfmDigitiser.mSATRASummClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;
  System := SATRASumm;

  btnNew.Click;
  UpdateScreen;
end;

procedure TfmDigitiser.mTimeLineClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;
  System := TimeLine;

  btnNew.Click;
  UpdateScreen;
end;

procedure TfmDigitiser.lblButton0MouseEnter(Sender: TObject);
begin
  lblButton0.Font.Color := clHighlightKey;
  imgCursor.visible := False;
  imgCursor0.visible := True;
end;

procedure TfmDigitiser.lblButton0MouseLeave(Sender: TObject);
begin
  lblButton0.Font.Color := clText;
  imgCursor.visible := True;
  imgCursor0.visible := False;
end;

procedure TfmDigitiser.lblButton1MouseEnter(Sender: TObject);
begin
  lblButton1.Font.Color := clHighlightKey;
  imgCursor.visible := False;
  imgCursor1.visible := True;
end;

procedure TfmDigitiser.lblButton1MouseLeave(Sender: TObject);
begin
  lblButton1.Font.Color := clText;
  imgCursor.visible := True;
  imgCursor1.visible := False;
end;

procedure TfmDigitiser.lblButton2MouseEnter(Sender: TObject);
begin
  lblButton2.Font.Color := clHighlightKey;
  imgCursor.visible := False;
  imgCursor2.visible := True;
end;

procedure TfmDigitiser.lblButton2MouseLeave(Sender: TObject);
begin
  lblButton2.Font.Color := clText;
  imgCursor.visible := True;
  imgCursor2.visible := False;
end;

procedure TfmDigitiser.lblButton3MouseEnter(Sender: TObject);
begin
  lblButton3.Font.Color := clHighlightKey;
  imgCursor.visible := False;
  imgCursor3.visible := True;
end;

procedure TfmDigitiser.lblButton3MouseLeave(Sender: TObject);
begin
  lblButton3.Font.Color := clText;
  imgCursor.visible := True;
  imgCursor3.visible := False;
end;

procedure TfmDigitiser.lblMouse2MouseEnter(Sender: TObject);
begin
  lblMouse2.Font.Color := clHighlightKey;
  imgKeyboard.visible := True;
  imgMouse.Visible := False;
  imgMouseLeft.Visible := True;
end;

procedure TfmDigitiser.lblMouse2MouseLeave(Sender: TObject);
begin
  lblMouse2.Font.Color := clText;
  imgKeyboard.visible := True;
  imgMouse.Visible := True;
  imgMouseLeft.Visible := False;
end;

procedure TfmDigitiser.lblMouse4MouseEnter(Sender: TObject);
begin
  lblMouse4.Font.Color := clHighlightKey;
  imgKeyboard.visible := False;
  imgKeyboardCtrl.visible := True;
  imgMouse.Visible := False;
  imgMouseLeft.Visible := True;
end;

procedure TfmDigitiser.lblMouse4MouseLeave(Sender: TObject);
begin
  lblMouse4.Font.Color := clText;
  imgKeyboard.visible := True;
  imgKeyboardCtrl.visible := False;
  imgMouse.Visible := True;
  imgMouseLeft.Visible := False;
end;

procedure TfmDigitiser.lblMouse5MouseEnter(Sender: TObject);
begin
  lblMouse5.Font.Color := clHighlightKey;
  imgMouse.Visible := False;
  imgMouseWheel.Visible := True;
end;

procedure TfmDigitiser.lblMouse5MouseLeave(Sender: TObject);
begin
  lblMouse5.Font.Color := clText;
  imgMouse.Visible := True;
  imgMouseWheel.Visible := False;
end;

procedure TfmDigitiser.lblMouse3MouseEnter(Sender: TObject);
begin
  lblMouse3.Font.Color := clHighlightKey;
  imgKeyboard.visible := False;
  imgKeyboardShift.visible := True;
  imgMouse.Visible := False;
  imgMouseLeft.Visible := True;
end;

procedure TfmDigitiser.lblMouse3MouseLeave(Sender: TObject);
begin
  lblMouse3.Font.Color := clText;
  imgKeyboard.visible := True;
  imgKeyboardShift.visible := False;
  imgMouse.Visible := True;
  imgMouseLeft.Visible := False;
end;

procedure TfmDigitiser.imgDigitiserMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  CanvasPt, DigPt: TPathPoint;
  i: integer;
  DistanceToPoint: single;

begin
  CanvasPt.x := X;
  CanvasPt.y := Y;

  DigPt := CanvasPtToDigPt(CanvasPt);

  if (DigitiserState = _Off) then
  begin
    NearestPoint.Index := 0;
    NearestPoint.Distance := 999999999;
    for i := 1 to NoRawPts do
    begin
      DistanceToPoint := distance(DigPt.x, DigPt.y, RawPts[i].x, RawPts[i].y);
      if (DistanceToPoint < NearestPoint.Distance) and (DistanceToPoint < (500 / Zoom.Ratio)) and (DigPtVisible(RawPts[i])) then
      begin
        NearestPoint.index := i;
        NearestPoint.Pt := RawPts[i];
        NearestPoint.Distance := DistanceToPoint;
      end;
    end;

    DrawPath(NearestPoint.index);
  end;

  if (not ((DragXStart = 0) and (DragYStart = 0))) then
  begin
    Zoom.OffsetX := Zoom.OffsetX + DragXStart - X;
    Zoom.OffsetY := Zoom.OffsetY + DragYStart - Y;
    DragXStart := X;
    DragYStart := Y;
    UpdateZoom;
  end;
end;

procedure TfmDigitiser.imgDigitiserMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  screen.Cursor := crDefault;
  DragXStart := 0;
  DragYStart := 0;
end;

procedure TfmDigitiser.PositionPanel(ThePanel: TPanel);
var
  ThePanelPos: TPathPoint;

begin
  if ThePanel.Name = 'pnlFeatures' then
    ThePanelPos := DigPtToCanvasPt(ChosenPoint.Pt)
  else
    ThePanelPos := DigPtToCanvasPt(HoldPoint);

  //Check and switch sides LR/UD
  if ThePanelPos.x > (imgDigitiser.width / 2) then
  begin
    ThePanelPos.x := ThePanelPos.x - ThePanel.Width;
  end;
  if ThePanelPos.y > (imgDigitiser.height / 2) then
  begin
    ThePanelPos.y := ThePanelPos.y - ThePanel.Height;
  end;
  if (ThePanel.Name <> 'pnlFeatures') then
  begin
    ThePanelPos.x := ThePanelPos.x + pnlDigitiser.Left;
    ThePanelPos.y := ThePanelPos.y + pnlDigitiser.Top;
  end;

  ThePanel.Left := ThePanelPos.x;
  ThePanel.Top := ThePanelPos.Y;

  ThePanel.BringToFront;
  ThePanel.visible := TRUE;

  if (ThePanel.Name = 'pnlYesNo') then
    tbMain.Enabled := False;

  Application.ProcessMessages;
end;

procedure TfmDigitiser.imgDigitiserMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  CanvasPt, DigPt: TPathPoint;
  ButtonProcessed: boolean;

begin
  CanvasPt.x := X;
  CanvasPt.y := Y;

  DigPt := CanvasPtToDigPt(CanvasPt);

  if (Button = mbLeft) and (not ((ssShift in Shift) or (ssCtrl in Shift))) then
  begin
    screen.Cursor := crHandPoint;
    DragXStart := X;
    DragYStart := Y;
  end
  else
  begin
    DragXStart := 0;
    DragYStart := 0;
  end;

  ButtonProcessed := FALSE;
  if (ssShift in Shift) and (Button = mbLeft) then
  begin
    ZoomIn(X, Y);
    ButtonProcessed := TRUE;
  end
  else if (ssCtrl in Shift) and (Button = mbLeft) then
  begin
    Zoomout(X, Y);
    ButtonProcessed := TRUE;
  end;
end;

function TfmDigitiser.DigPtVisible(DigPt: TPathPoint): Boolean;
var
  Visible: boolean;
  aPt, BottomLeft, TopRight: TPathPoint;

begin
  aPt.x := 0;
  aPt.y := 0;
  BottomLeft := CanvasPtToDigPt(aPt);
  aPt.x := imgDigitiser.width;
  aPt.y := imgDigitiser.height;
  TopRight := CanvasPtToDigPt(aPt);

  Visible := TRUE;
  if (DigPt.x < BottomLeft.x) or (DigPt.x > TopRight.x) or
     (DigPt.y > BottomLeft.y) or (DigPt.y < TopRight.y) then
    Visible := FALSE;

  DigPtVisible := Visible;
end;

function TfmDigitiser.DigPtToCanvasPt(DigPt: TPathPoint): TPathPoint;
var
  CanvasPt: TPathPoint;

begin
  CanvasPt.x := round(DigPt.x * DigPtToCanvasPtRatio * Zoom.Ratio) - Zoom.OffsetX;
  CanvasPt.y := imgDigitiser.height - round(DigPt.y * DigPtToCanvasPtRatio * Zoom.Ratio) - Zoom.OffsetY;

  DigPtToCanvasPt := CanvasPt;
end;

function TfmDigitiser.CanvasPtToDigPt(CanvasPt: TPathPoint): TPathPoint;
var
  DigPt: TPathPoint;

begin
  DigPt.x := round((CanvasPt.x + Zoom.OffsetX) / (DigPtToCanvasPtRatio * Zoom.Ratio));
  DigPt.y := round((imgDigitiser.height - (CanvasPt.y + Zoom.OffsetY)) / (DigPtToCanvasPtRatio * Zoom.Ratio));

  CanvasPtToDigPt := DigPt;
end;

procedure TfmDigitiser.ShowHelp;
begin
  pnlHelp.Visible := btnHelp.down;

  SizeDigitiser;
  DrawPath(0);
end;

procedure TfmDigitiser.PatternNew;
begin
  NoRawPts := 0;

  ResetZoom;

  fmDigitiser.Refresh;
end;

procedure TfmDigitiser.PatternOpen;
var
  i: integer;

begin
  Screen.cursor := crHourGlass;
  try
    fmPatterns := TfmPatterns.create(application.MainForm);
  except
    fmMemoryError.TidyUp(self);
  end;
  Screen.cursor := crDefault;

  IgnoreButtons := True;
  fmPatterns.ShowModal;
  IgnoreButtons := False;

  for i := 1 to NumberOfPatterns do
    SummsCollection[i].PatternName := fmPatterns.sgPatternNames.Cells[0, i];

  fmPatterns.Free;
  UpdateScreen;
end;

procedure TfmDigitiser.PatternSave;
var
  i, NamedPattern: integer;
  NameUsed: boolean;

begin
  NameUsed := FALSE;

  Screen.cursor := crHourGlass;
  try
    fmPatternName := TfmPatternName.create(application.MainForm);
  except
    fmMemoryError.TidyUp(self);
  end;
  Screen.cursor := crDefault;

  if (fmPatternName.ShowModal = mrOK) then
  begin
    if (NumberOfPatterns > 0) then
    begin
      i := 0;
      repeat
        inc(i);
        if SummsCollection[i].PatternName = PatternRef then
        begin
          NamedPattern := i;
          NameUsed := TRUE;
        end;
      until NameUsed or (i = NumberOfPatterns);

      if NameUsed then
      begin
        if messagedlg('Replace existing Pattern?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          //delete current pattern with that name.
          dec(NumberOfPatterns);

          if NamedPattern <= NumberOfPatterns then
            for i := NamedPattern to NumberOfPatterns do
              SummsCollection[i] := SummsCollection[i + 1];
        end;
      end;
    end;

    inc(NumberOfPatterns);
    SummsCollection[NumberOfPatterns].PatternName := PatternRef;
    SummsCollection[NumberOfPatterns].NoPoints := NoRawPts;
    for i := 1 to NoRawPts do
    begin
      SummsCollection[NumberOfPatterns].Points[i].x := RawPts[i].x;
      SummsCollection[NumberOfPatterns].Points[i].y := RawPts[i].y;
    end;
    FileNeedsSaving := TRUE;
  end;

  PatternNotClosed := FALSE;

  PatternNew;
end;

procedure TfmDigitiser.ZoomIn(X, Y: integer);
begin
  if Zoom.Ratio < 32 then
  begin
    Zoom.Ratio := Zoom.Ratio * 2;
    Zoom.OffsetX := + (2 * (X + Zoom.OffsetX)) - round(imgDigitiser.width / 2);
    Zoom.OffsetY := - ((2 * (imgDigitiser.height - (Y + Zoom.OffsetY))) - round(imgDigitiser.height / 2));
    UpdateZoom;
  end;
end;

procedure TfmDigitiser.ZoomOut(X, Y: integer);
begin
  if Zoom.Ratio > 0.25 then
  begin
    Zoom.Ratio := Zoom.Ratio / 2;
    Zoom.OffsetX := + round(0.5 * (X + Zoom.OffsetX)) - round(imgDigitiser.width / 2);
    Zoom.OffsetY := - round((0.5 * (imgDigitiser.height - (Y + Zoom.OffsetY))) - round(imgDigitiser.height / 2));
    UpdateZoom;
  end;
end;

procedure TfmDigitiser.UpdateScreen;
begin
  mSystem.Enabled := (DigitiserState = _Off);

  btnOpen.Visible := (System = SATRASumm);
  btnListPatterns.Visible := (System = SATRASumm);

  btnNew.Enabled := (DigitiserState = _Off);
  btnOpen.Enabled := (DigitiserState = _Off);
  btnSave.Enabled := FileNeedsSaving and (DigitiserState = _Off);
  btnListPatterns.Enabled := (NumberOfPatterns > 0) and (DigitiserState = _Off);
  btnDigOnOff.down := (DigitiserState = _On);

  lblButton1.Visible := (System = TimeLine);
  lblButton2.Visible := (System = TimeLine);

  imgSATRASumm.Visible := (System = SATRASumm);
  imgTimeLine.Visible := (System = TimeLine);
  if System = SATRASumm then
  begin
    btnSave.Left := 49;
    btnZoomReset.Left := 141;
    btnHelp.Left := 164;
    btnDigOnOff.Left := 210;
  end
  else if System = TimeLine then
  begin
    btnSave.Left := 26;
    btnZoomReset.Left := 72;
    btnHelp.Left := 95;
    btnDigOnOff.Left := 141;
  end;

  if System = TimeLine then
  begin
    odDigFiles.DefaultExt := 'dig';
    odDigFiles.FileName := '*.dig';
    odDigFiles.Filter := 'Digitiser Files|*.dig|All Files|*.*';

    sdDigFiles.DefaultExt := 'dig';
    sdDigFiles.FileName := 'Untitled';
    sdDigFiles.Filter := 'Digitiser Files|*.dig|All Files|*.*';
  end
  else if System = SATRASumm then
  begin
    odDigFiles.DefaultExt := 'dgt';
    odDigFiles.FileName := '*.dgt';
    odDigFiles.Filter := 'Digitiser Files|*.dgt|All Files|*.*';

    sdDigFiles.DefaultExt := 'dgt';
    sdDigFiles.FileName := 'Untitled';
    sdDigFiles.Filter := 'Digitiser Files|*.dgt|All Files|*.*';
  end;
end;

procedure TfmDigitiser.ReadDigitiserIni;
var
  sSystem: string;

begin
  sSystem := SystemIni.ReadString('Application Options', 'SYSTEM', '');
  SATRASummDirectory := SystemIni.ReadString('Application Options', 'SATRASUMMDIRECTORY', '');
  TimeLineDirectory := SystemIni.ReadString('Application Options', 'TIMELINEDIRECTORY', '');

  if sSystem = 'TimeLine' then
  begin
    mTimeLine.Checked := True;
    System := TimeLine;
  end
  else
    System := SATRASumm;

  UpdateScreen;
end;

procedure TfmDigitiser.WriteDigitiserIni;
var
  sSystem: string;

begin
  try
    case System of
      SATRASumm: sSystem := 'SATRASumm';
      TimeLine: sSystem := 'TimeLine';
    end;

    SystemIni.WriteString('Application Options', 'SYSTEM', sSystem);
    SystemIni.WriteString('Application Options', 'SATRASUMMDIRECTORY', SATRASummDirectory);
    SystemIni.WriteString('Application Options', 'TIMELINEDIRECTORY', TimeLineDirectory);
  except
    on E: Exception do
      messagedlg(SystemAlias + ' NOT saved', mtWarning, [mbOk], 0);
  end;
end;

end.

