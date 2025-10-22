unit WidthRangeWhereUsed;

interface

uses
  Classes, Controls, Forms, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus, ExtCtrls, Buttons,
  ToolWin, ComCtrls, frxClass, frxDBSet, Vcl.DBGrids, frxReportPlus;

type
  TfmWidthRangeWhereUsed = class(TForm)
    pnlParts: TPanel;
    dbgParts: TDBGridPlus;
    dsParts: TDataSource;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    qParts: TFDQueryPlus;
    qPartsCode: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frWidthRangeWhereUsed: TfrxReportPlus;
    frdbPart: TfrxDBDataset;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassWidthRangeName(var Code: string);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgPartsDblClick(Sender: TObject);
    procedure dbgPartsKeyPress(Sender: TObject; var Key: Char);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frWidthRangeWhereUsedBeforePrint(Sender: TfrxReportComponent);
    procedure frWidthRangeWhereUsedGetValue(const VarName: string;
      var Value: Variant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmWidthRangeWhereUsed: TfmWidthRangeWhereUsed;

implementation

uses
  Windows, Graphics, Summs, PartDetails, ConstructionDetails, OutOfMemory, General, SummsVars;

{$R *.DFM}

procedure TfmWidthRangeWhereUsed.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree
end;

procedure TfmWidthRangeWhereUsed.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmWidthRangeWhereUsed.PassWidthRangeName(var Code: string);
begin
  Caption := 'Where Used for Width Range : ' + Code;

  qParts.ParamByName('WidthRange').AsString := Code;
  qParts.Open;
end;

procedure TfmWidthRangeWhereUsed.frWidthRangeWhereUsedBeforePrint(
  Sender: TfrxReportComponent);

begin
  frWidthRangeWhereUsed.PreviewOptions.AllowEdit := False;
  frWidthRangeWhereUsed.PreviewOptions.Buttons := frWidthRangeWhereUsed.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frWidthRangeWhereUsed.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frWidthRangeWhereUsed.PreviewOptions.ZoomMode := zmDefault
  else
    frWidthRangeWhereUsed.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmWidthRangeWhereUsed.frWidthRangeWhereUsedGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmWidthRangeWhereUsed.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  frWidthRangeWhereUsed.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qParts.GetBookmark;
  qParts.DisableControls;

  frWidthRangeWhereUsed.PrintOptions.PrintMode := pmScale;
  frWidthRangeWhereUsed.PrintOptions.PrintOnSheet := GetPaperSize;
  frWidthRangeWhereUsed.PrepareReport;

  try
    qParts.GotoBookmark(MyBookmark);
  except
  end;
  qParts.EnableControls;
  qParts.FreeBookmark(MyBookmark);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frWidthRangeWhereUsed.ShowPreparedReport
  else
    frWidthRangeWhereUsed.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;


procedure TfmWidthRangeWhereUsed.dbgPartsDblClick(Sender: TObject);
var
  fmPartDetails : TfmPartDetails;
  Code:string;
  Failed:boolean;

begin
  Code := qPartsCode.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Part', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmPartDetails := TfmPartDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmPartDetails.PassPartName(fmPartDetails, Code);
    end;
  end;
end;

procedure TfmWidthRangeWhereUsed.dbgPartsKeyPress(Sender: TObject;
                                                  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgPartsDblClick(Self)
end;

procedure TfmWidthRangeWhereUsed.btnRefreshClick(Sender: TObject);
begin
  qParts.close;
  qParts.open;
end;

procedure TfmWidthRangeWhereUsed.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
