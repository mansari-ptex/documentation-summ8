unit AllCosts;

interface

uses
  Windows, Forms, DBGridPlus, Buttons, ExtCtrls, ToolWin, ComCtrls, XStringGrid,
  XStringGridPlus, Controls, Classes, Grids, StdCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, frxClass, frxDBSet,
  frxReportPlus, Vcl.Dialogs;

type
  TfmAllCosts = class(TForm)
    sgResults: TXStringGridPlus;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    pnlTop: TPanel;
    lblInfo: TLabel;
    tblParts: TFDTablePlus;
    tblPartsCode: TStringField;
    tblPartsDescription: TStringField;
    tblPartsSizeScale: TStringField;
    tblPartsSizeRange: TStringField;
    tblPartsWidthRange: TStringField;
    tblPartsMaterial: TStringField;
    tblPartsCostedSize: TStringField;
    tblPartsSampleSize: TStringField;
    tblMaterial: TFDTablePlus;
    tblMaterialCode: TStringField;
    tblMaterialDescription: TStringField;
    Panel1: TPanel;
    btnPrintPreviewIncPartInfo: TSpeedButton;
    btnPrintIncPartInfo: TSpeedButton;
    Panel2: TPanel;
    tblPartsMaterialDescription: TStringField;
    frAllCosts: TfrxReportPlus;
    frudsAllCosts: TfrxUserDataSet;
    frdbdsParts: TfrxDBDataset;
    procedure PassPartCodeWidthNo(Code, Width, SampSize: string; WidthNo: short; ToFeet: real);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPrintClick(Sender: TObject);
    procedure Allowances;
    procedure btnRefreshClick(Sender: TObject);
    procedure sgResultsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure frudsAllCostsGetValue(const VarName: string; var Value: Variant);
    procedure frAllCostsGetValue(const VarName: string; var Value: Variant);
    procedure frAllCostsBeforePrint(Sender: TfrxReportComponent);
  private
    { Private declarations }
    BusyPrinting: boolean;
    PartCode, PartWidth, SampleSize: string;
    PartWidthNo: short;
//    SqFtToUnits: real;
  public
    { Public declarations }
  end;

var
  fmAllCosts: TfmAllCosts;

implementation

uses
  Graphics, Summs, OutOfMemory, BasicAlw, General, SummsVars;

{$R *.DFM}

procedure TfmAllCosts.PassPartCodeWidthNo(Code, Width, SampSize: string; WidthNo: short; ToFeet: real);
begin
  PartCode := Code;
  PartWidth := Width;
  SampleSize := SampSize;
  PartWidthNo := WidthNo;
//  SqftToUnits := 1 / (ToFeet * ToFeet);

  Caption := 'Allowances for Part : ' + PartCode + ' (' + PartWidth + ')';
  Allowances;
end;

procedure TfmAllCosts.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    action := caFree;
  end;
end;

procedure TfmAllCosts.btnPrintClick(Sender: TObject);
var
  frmdParts: TfrxMasterData;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frAllCosts.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  frmdParts := frAllCosts.FindObject('frmdParts') as TfrxMasterData;
  if ((Sender as TSpeedButton) = btnPrintPreview) or ((Sender as TSpeedButton) = btnPrint) then
    frmdParts.Visible := False
  else
  begin
    frmdParts.Visible := True;

    tblParts.Open;
    tblParts.FindKey([PartCode]);
  end;

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;
  btnPrintIncPartInfo.Enabled := False;
  btnPrintPreviewIncPartInfo.Enabled := False;

  frudsAllCosts.RangeEnd := reCount;
  frudsAllCosts.RangeEndCount := sgResults.RowCount;

  frAllCosts.PrintOptions.PrintMode := pmScale;
  frAllCosts.PrintOptions.PrintOnSheet := GetPaperSize;
  frAllCosts.PrepareReport;

  if ((Sender as TSpeedButton) = btnPrintPreview) or ((Sender as TSpeedButton) = btnPrintPreviewIncPartInfo) then
  begin
    with frAllCosts do
    begin
      ShowPreparedReport;
      if (((PreviewForm.Left + (PreviewForm.Width div 2)) > Application.MainForm.Width) or 
          (((PreviewForm.Left + (PreviewForm.Width div 2)) < 0))) then
        PreviewForm.Left := ((Application.MainForm.Width - PreviewForm.Width) div 2);
      if (((PreviewForm.Top + (PreviewForm.Height div 2)) > Application.MainForm.Height) or 
          (((PreviewForm.Top + (PreviewForm.Height div 2)) < 0))) then
        PreviewForm.Top := ((Application.MainForm.Height - PreviewForm.Height) div 2);
    end;
  end
  else
    frAllCosts.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
  btnPrintIncPartInfo.Enabled := True;
  btnPrintPreviewIncPartInfo.Enabled := True;

  if not(((Sender as TSpeedButton) = btnPrintPreview) or ((Sender as TSpeedButton) = btnPrint)) then
    tblParts.Close;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllCosts.Allowances;
var
  i: integer;
  AllowanceStr, MatStr, UnitsStr: string;
  CostingGrid: GridArray;
  NumberOfSizes: integer;

begin
  MatStr := '';
  Screen.cursor := crHourGlass;

  btnRefresh.enabled := FALSE;
  btnPrintPreview.enabled := FALSE;
  btnPrint.enabled := FALSE;
  btnPrintPreviewIncPartInfo.enabled := FALSE;
  btnPrintIncPartInfo.enabled := FALSE;

  dmBasAll.AllowanceAllCosts(PartCode, PartWidthNo, CostingGrid, NumberOfSizes, MatStr, UnitsStr);

  sgResults.Cells[0,0] := 'Size';
  sgResults.Cells[1,0] := 'Allowance';

  for i := 1 to NumberOfSizes do
  begin
    sgResults.Cells[0,i] := CostingGrid[i].Size;
    if CostingGrid[i].AdjustedAllowance > 0 then
      str(CostingGrid[i].AdjustedAllowance: 7: 4, AllowanceStr)
    else
      AllowanceStr := 'Unavailable';
    sgResults.Cells[1,i] := AllowanceStr;
  end;

  sgResults.RowCount := NumberOfSizes + 1;

  btnRefresh.enabled := TRUE;
  btnPrintPreview.enabled := TRUE;
  btnPrint.enabled := TRUE;
  btnPrintPreviewIncPartInfo.enabled := TRUE;
  btnPrintIncPartInfo.enabled := TRUE;

  Screen.cursor := crDefault;
end;

procedure TfmAllCosts.btnRefreshClick(Sender: TObject);
begin
  Allowances;
end;

procedure TfmAllCosts.sgResultsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow = 0 then
    CanSelect := False;
end;

procedure TfmAllCosts.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;
end;

procedure TfmAllCosts.frAllCostsBeforePrint(Sender: TfrxReportComponent);
begin
  frAllCosts.PreviewOptions.AllowEdit := False;
  frAllCosts.PreviewOptions.Buttons := frAllCosts.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllCosts.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllCosts.PreviewOptions.ZoomMode := zmDefault
  else
    frAllCosts.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllCosts.frAllCostsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := 'Allowances for Part : ' + PartCode + ' (' + PartWidth + ')';
end;

procedure TfmAllCosts.frudsAllCostsGetValue(const VarName: string;
  var Value: Variant);
begin
  if frudsAllCosts.RecNo = 0 then
    frudsAllCosts.Next;
  
  if VarName = 'Size' then
    Value := sgResults.Cells[0, frudsAllCosts.RecNo];
  if VarName = 'Allowance' then
    Value := sgResults.Cells[1, frudsAllCosts.RecNo];
end;

end.
