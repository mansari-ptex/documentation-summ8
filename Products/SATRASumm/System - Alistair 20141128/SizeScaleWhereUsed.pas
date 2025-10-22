unit SizeScaleWhereUsed;

interface

uses
  Classes, Controls, Forms, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus, ExtCtrls, Buttons,
  ToolWin, ComCtrls, frxClass, frxDBSet, Vcl.DBGrids, frxReportPlus;

type
  TfmSizeScaleWhereUsed = class(TForm)
    pnlKnives: TPanel;
    pnlSizeRanges: TPanel;
    dsKnives: TDataSource;
    dsSizeRanges: TDataSource;
    dbgKnives: TDBGridPlus;
    dbgSizeRanges: TDBGridPlus;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    Splitter1: TSplitter;
    qKnives: TFDQueryPlus;
    qSizeRanges: TFDQueryPlus;
    qKnivesCode: TStringField;
    qSizeRangesRange: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frSizeScalesWhereUsed: TfrxReportPlus;
    frdbSizeRanges: TfrxDBDataset;
    frdbKnives: TfrxDBDataset;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassSizeScaleName(var Code: string);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgKnivesDblClick(Sender: TObject);
    procedure dbgKnivesKeyPress(Sender: TObject; var Key: Char);
    procedure dbgSizeRangesDblClick(Sender: TObject);
    procedure dbgSizeRangesKeyPress(Sender: TObject; var Key: Char);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frSizeScalesWhereUsedBeforePrint(Sender: TfrxReportComponent);
    procedure frSizeScalesWhereUsedGetValue(const VarName: string;
      var Value: Variant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSizeScaleWhereUsed: TfmSizeScaleWhereUsed;

implementation

uses
  Windows, Graphics, Summs, KnifeSetDetails, SizeRangeDetails, OutOfMemory, General, SummsVars;

{$R *.DFM}

procedure TfmSizeScaleWhereUsed.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree
end;

procedure TfmSizeScaleWhereUsed.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmSizeScaleWhereUsed.PassSizeScaleName(var Code: string);
begin
  Caption := 'Where Used for Size Scale : ' + Code;

  qKnives.ParamByName('SizeScale').AsString := Code;
  qKnives.Open;

  qSizeRanges.ParamByName('SizeScale').AsString := Code;
  qSizeRanges.Open;
end;

procedure TfmSizeScaleWhereUsed.frSizeScalesWhereUsedBeforePrint(
  Sender: TfrxReportComponent);
begin
  frSizeScalesWhereUsed.PreviewOptions.AllowEdit := False;
  frSizeScalesWhereUsed.PreviewOptions.Buttons := frSizeScalesWhereUsed.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frSizeScalesWhereUsed.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frSizeScalesWhereUsed.PreviewOptions.ZoomMode := zmDefault
  else
    frSizeScalesWhereUsed.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmSizeScaleWhereUsed.frSizeScalesWhereUsedGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmSizeScaleWhereUsed.btnPrintClick(Sender: TObject);
var
  MyBookmark, MyBookmark2: TBookmark;

begin
  frSizeScalesWhereUsed.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qKnives.GetBookmark;
  MyBookmark2 := qSizeRanges.GetBookmark;
  qKnives.DisableControls;
  qSizeRanges.DisableControls;

  frSizeScalesWhereUsed.PrintOptions.PrintMode := pmScale;
  frSizeScalesWhereUsed.PrintOptions.PrintOnSheet := GetPaperSize;
  frSizeScalesWhereUsed.PrepareReport;

  qKnives.GotoBookmark(MyBookmark);
  qKnives.EnableControls;
  qKnives.FreeBookmark(MyBookmark);

  qSizeRanges.GotoBookmark(MyBookmark2);
  qSizeRanges.EnableControls;
  qSizeRanges.FreeBookmark(MyBookmark2);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frSizeScalesWhereUsed.ShowPreparedReport
  else
    frSizeScalesWhereUsed.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmSizeScaleWhereUsed.dbgKnivesDblClick(Sender: TObject);
var
  Code:string;
  Failed:boolean;
  fmKnifeSetDetails : TfmKnifeSetDetails;

begin
  Code := qKnivesCode.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Knife', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmKnifeSetDetails := TfmKnifeSetDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmKnifeSetDetails.PassKnifeName(fmKnifeSetDetails, Code);
    end;
  end;
end;

procedure TfmSizeScaleWhereUsed.dbgKnivesKeyPress(Sender: TObject;
                                                  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgKnivesDblClick(Self);
end;

procedure TfmSizeScaleWhereUsed.dbgSizeRangesDblClick(Sender: TObject);
var
  fmSizeRangeDetails: TfmSizeRangeDetails;
  Code : string;
  Failed : boolean;

begin
  Code := qSizeRangesRange.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Size Range', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmSizeRangeDetails := TfmSizeRangeDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmSizeRangeDetails.PassSizeRangeName(fmSizeRangeDetails, Code);
    end;
  end;
end;

procedure TfmSizeScaleWhereUsed.dbgSizeRangesKeyPress(Sender: TObject;
                                                      var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgSizeRangesDblClick(Self);
end;

procedure TfmSizeScaleWhereUsed.btnRefreshClick(Sender: TObject);
begin
  screen.cursor := crHourGlass;

  qKnives.close;
  qKnives.open;
  qSizeRanges.close;
  qSizeRanges.open;

  screen.cursor := crDefault;
end;

procedure TfmSizeScaleWhereUsed.FormCreate(Sender: TObject);
var
  AddToHeight, AddToWidth: integer;

begin
  AutoColor(Self);
end;

end.


