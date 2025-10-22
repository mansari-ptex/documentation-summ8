unit DigitiserAllPatterns;

interface

uses
  Forms, Buttons, ExtCtrls, ComCtrls, Controls, ToolWin, Classes, Grids,
  XStringGrid, General;

type
  TfmPatterns = class(TForm)
    tbMain: TPanel;
    btnDelete: TSpeedButton;
    pnlLeft: TPanel;
    sgPatternNames: TXStringGrid;
    spDigitiserOpen: TSplitter;
    pnlPattern: TPanel;
    imgPattern: TImage;
    procedure ViewPattern;
    procedure SelectPattern;
    procedure DeletePattern;
    procedure btnDeleteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FillNamesGrid;
    procedure sgPatternNamesSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure FormResize(Sender: TObject);
    procedure ResizePattern;
    procedure spDigitiserOpenMoved(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ThisPattern: integer;
  public
    { Public declarations }
  end;

var
  fmPatterns: TfmPatterns;

implementation

uses
  SysUtils, Dialogs, Graphics, PathGlobals, DigitiserMain, OutOfMemory;

{$R *.DFM}

procedure TfmPatterns.ViewPattern;
var
  i, minx, miny, maxx, maxy, midx, midy, transx, transy: integer;
  factor: real;
  DrawPoints: array [1..MaxRawPoints] of TSummsPoint;

begin
  imgPattern.Canvas.brush.color := OurColor(clAqua);
  imgPattern.Canvas.FillRect(Rect(0, 0, imgPattern.width, imgPattern.height));

  for i := 1 to SummsCollection[ThisPattern].NoPoints do
  begin
    DrawPoints[i].x := SummsCollection[ThisPattern].Points[i].x;
    DrawPoints[i].y := SummsCollection[ThisPattern].Points[i].y;
  end;

  MinX := 64000;
  MaxX := -64000;
  MinY := 64000;
  MaxY := -64000;

  for i := 1 to SummsCollection[ThisPattern].NoPoints do
  begin
    if DrawPoints[i].x < minx then
      minx := DrawPoints[i].x;
    if DrawPoints[i].y < miny then
      miny := DrawPoints[i].y;
    if DrawPoints[i].x > maxx then
      maxx := DrawPoints[i].x;
    if DrawPoints[i].y > maxy then
      maxy :=  DrawPoints[i].y;
  end;
  if (imgPattern.width / (maxx - minx))<(imgPattern.height / (maxy - miny)) then
    factor := imgPattern.width / (maxx - minx)
  else
    factor := imgPattern.height / (maxy - miny);

  factor := factor * 0.8; // border;
  midx := minx + round((maxx - minx) / 2);
  midy := miny + round((maxy - miny) / 2);
  transx := round(imgPattern.width / 2);
  transy := round(imgPattern.height / 2);

  imgPattern.canvas.moveto(round((DrawPoints[1].x - midx) * factor) + transx, transy - round((DrawPoints[1].y - midy) * factor));

  for i := 1 to SummsCollection[ThisPattern].NoPoints do
    imgPattern.canvas.lineto(round((DrawPoints[i].x - midx) * factor) + transx, transy - round((DrawPoints[i].y - midy) * factor));

  imgPattern.canvas.lineto(round((DrawPoints[1].x - midx) * factor) + transx, transy - round((DrawPoints[1].y - midy) * factor));
end;

procedure TfmPatterns.SelectPattern;
var
  i: integer;

begin
  PatternRef := SummsCollection[ThisPattern].PatternName;

  NoRawPts := SummsCollection[ThisPattern].NoPoints;

  for i := 1 to NoRawPts do
  begin
    RawPts[i].x := SummsCollection[ThisPattern].Points[i].x;
    RawPts[i].y := SummsCollection[ThisPattern].Points[i].y;
  end;

  RawPts[1].c := NewPath;

  for i := 1 to 6 do
  begin
    RawPts[1].Feature[i].Code := 'no_feature';
    RawPts[1].Feature[i].Description := 'No Feature';
  end;
end;

procedure TfmPatterns.btnDeleteClick(Sender: TObject);
begin
  if messagedlg('Delete Pattern?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    DeletePattern;
end;

procedure TfmPatterns.DeletePattern;
var
  i: integer;

begin
  if NumberOfPatterns > 0 then
  begin
    dec(NumberOfPatterns);

    if ThisPattern <= NumberOfPatterns then
      for i := ThisPattern to NumberOfPatterns do
        SummsCollection[i] := SummsCollection[i + 1];

    sgPatternNames.Cells[0, NumberOfPatterns + 1] := '';
    FillNamesGrid;

    ViewPattern;

    if NumberOfPatterns = 0 then
    begin
      btnDelete.Enabled := FALSE;
      imgPattern.Canvas.Rectangle(0, 0, imgPattern.width, imgPattern.height);
    end;
  end;

  FileNeedsSaving := (NumberOfPatterns > 0);
end;

procedure TfmPatterns.FormShow(Sender: TObject);
begin
  if NumberOfPatterns > 0 then
    btnDelete.Enabled := TRUE;

  FillNamesGrid;
  ThisPattern := 1;
  ViewPattern;
  sgPatternNames.SetFocus;
end;

procedure TfmPatterns.FillNamesGrid;
var
  i : integer;

begin
  if NumberOfPatterns > 0 then
  begin
    for i := 1 to NumberOfPatterns do
      sgPatternNames.Cells[0, i] := SummsCollection[i].PatternName;

    sgPatternNames.RowCount := NumberOfPatterns + 1;
  end
  else
    sgPatternNames.RowCount := 2;
end;

procedure TfmPatterns.sgPatternNamesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ARow > 0) and not(sgPatternNames.Cells[0, 1] = '') then
  begin
    ThisPattern := ARow;
    ViewPattern;
  end
  else
    CanSelect := False;
end;

procedure TfmPatterns.ResizePattern;
var
  Failed: boolean;

begin
  Failed := False;

  //Create new image
  imgPattern.destroy;
  try
    imgPattern := TImage.create(self);
  except
    fmMemoryError.TidyUp(self);
    Failed := True;
  end;

  if not Failed then
  begin
    imgPattern.visible := True;
    imgPattern.parent := pnlPattern;
    imgPattern.align := alClient;
  end;

  ViewPattern;
end;

procedure TfmPatterns.FormResize(Sender: TObject);
begin
  ResizePattern;
end;

procedure TfmPatterns.spDigitiserOpenMoved(Sender: TObject);
begin
  ResizePattern;
end;

procedure TfmPatterns.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfmPatterns.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
