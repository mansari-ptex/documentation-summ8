unit TicketsNotUpdated;

interface

uses
  Classes, Controls, Forms, StdCtrls, ExtCtrls, Db, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus,
  Spin, ComCtrls, Mask, DBCtrls, Buttons, ToolWin, Windows, PBNumEdit,
  PBSuperSpin, frxClass, frxDBSet, DBGrids, frxReportPlus, Vcl.Dialogs;

type
  TfmTicketsNotUpdated = class(TForm)
    dsNotUpdated: TDataSource;
    qNotUpdated: TFDQueryPlus;
    qNotUpdatedWeekNo: TSmallintField;
    qNotUpdatedSequenceNo: TSmallintField;
    qNotUpdatedTicketNo: TSmallintField;
    qNotUpdatedMaterialCode: TStringField;
    qNotUpdatedMaterialDescription: TStringField;
    qNotUpdatedTicketNumber: TStringField;
    qNotUpdatedValueMaterial: TFloatField;
    dbgNotUpdated: TDBGridPlus;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    qNotUpdatedTotals: TFDQueryPlus;
    qNotUpdatedStyle: TStringField;
    dsNotUpdatedTotals: TDataSource;
    qNotUpdatedTotalsEXPR: TFloatField;
    qNotUpdatedStandardMatPrice: TFloatField;
    qNotUpdatedBasicAllowance: TFloatField;
    qNotUpdatedAdjustedAllowance: TFloatField;
    qNotUpdatedMaterialQualCoeff: TIntegerField;
    qNotUpdatedMaterialAreaCoeff: TIntegerField;
    qNotUpdatedAdjFactorResult: TSmallintField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frTicketsNotUpdated: TfrxReportPlus;
    frNotUpdated: TfrxDBDataset;
    frNotUpdatedTotals: TfrxDBDataset;
    pnlTop: TPanel;
    pnlTotal: TPanel;
    dbtTotalValue: TDBText;
    pnlTotalTop: TPanel;
    pnlWeeks: TPanel;
    lblDash: TLabel;
    seFrom: TPBSuperSpin;
    seTo: TPBSuperSpin;
    pnlWeeksTitle: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgNotUpdatedDblClick(Sender: TObject);
    procedure GoQueries;
    procedure btnRefreshClick(Sender: TObject);
    procedure qNotUpdatedCalcFields(DataSet: TDataSet);
    procedure seFromChange(Sender: TObject);
    procedure seToChange(Sender: TObject);
    procedure Display(Query : boolean);
    procedure dbgNotUpdatedCellClick(Column: TColumn);
    procedure seFromInvalidEntry(Sender: TObject);
    procedure seToInvalidEntry(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frTicketsNotUpdatedGetValue(const VarName: string;
      var Value: Variant);
    procedure frTicketsNotUpdatedBeforePrint(Sender: TfrxReportComponent);
  private
    { Private declarations }
    BusyPrinting: boolean;
    WhichField: string;
    InvalidWeekNo: boolean;
  public
    { Public declarations }
  end;

const
  CurrForm = '###,###.00" "';

var
  fmTicketsNotUpdated: TfmTicketsNotUpdated;

implementation

uses
  SysUtils, Graphics, Summs, OutOfMemory, SummsVars, TicketsBreakdown, MaterialDetails,
  General, BasicAlw, CmnVars;

{$R *.DFM}

procedure TfmTicketsNotUpdated.FormClose(Sender: TObject;
  var Action: TCloseAction);
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

procedure TfmTicketsNotUpdated.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frTicketsNotUpdated.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qNotUpdated.GetBookmark;
  qNotUpdated.DisableControls;

  frTicketsNotUpdated.PrintOptions.PrintMode := pmScale;
  frTicketsNotUpdated.PrintOptions.PrintOnSheet := GetPaperSize;
  frTicketsNotUpdated.PrepareReport;

  try
    qNotUpdated.GotoBookmark(MyBookmark);
  except
  end;
  qNotUpdated.EnableControls;
  qNotUpdated.FreeBookmark(MyBookmark);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frTicketsNotUpdated do
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
    frTicketsNotUpdated.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmTicketsNotUpdated.dbgNotUpdatedDblClick(Sender: TObject);
var
  WeekNo , SequenceNo : Short;
  sWeekNo, sSequenceNo, Style, TicketCaption : string;
  Failed : boolean;
  fmTicketsBreakdown : TfmTicketsBreakdown;
  fmMaterialDetails: TfmMaterialDetails;
  Code: string;

begin
  if WhichField = 'MaterialCode' then
  begin
    Code := qNotUpdatedMaterialCode.Value;

    Failed := false;
    if (not (Code = '')) then
    begin
      if not ExistingToFront('Material', Code) then
      begin
        Screen.cursor := crHourGlass;
        try
          fmMaterialDetails := TfmMaterialDetails.create(fmSumms);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;

        if not Failed then
          fmMaterialDetails.PassMaterialName(fmMaterialDetails, Code);
      end;
    end;
  end
  else
  begin
    WeekNo := qNotUpdatedWeekNo.value;
    SequenceNo := qNotUpdatedSequenceNo.value;
    Style := qNotUpdatedStyle.value;

    sWeekNo := InttoStr(WeekNo);
    sSequenceNo := InttoStr(SequenceNo);
    TicketCaption := 'Ticket(s) : ' + sWeekNo + '/' + sSequenceNo + '/xx    ' + 'Style : ' + Style;

    if not (WeekNo = 0) then
    begin
      if not ExistingToFront(TicketCaption, '') then
      begin
        Screen.cursor := crHourGlass;
        Failed := false;
        try
          fmTicketsBreakdown := TfmTicketsBreakdown.create(fmSumms);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;

        if not Failed then
          fmTicketsBreakdown.PassTicketSequenceReference(fmTicketsBreakdown, WeekNo, SequenceNo);
      end;
    end;
  end;
end;

procedure TfmTicketsNotUpdated.GoQueries;
var
  SQLString1, SQLString2, Line2, Line3, Line4, Line5: string;

begin
  qNotUpdated.close;
  qNotUpdatedTotals.close;

  SQLString1 := 'SELECT T.WeekNo, T.SequenceNo, T.TicketNo, T.MaterialCode, T.MaterialDescription, ' +
                'T.StandardMatPrice, T.MaterialQualCoeff, T.MaterialAreaCoeff, T.AdjFactorResult, ' +
                'T.BasicAllowance, S.Style FROM TicketTickets T, TicketSequences S ';

  SQLString2 := 'SELECT SUM(T.StandardMatPrice * T.BasicAllowance * ' +
                '(100 / T.MaterialAreaCoeff) * ' +
                '(100 / (T.MaterialQualCoeff + (T.AdjFactorResult * (100 - T.MaterialQualCoeff) / 15))) ' +
                ') FROM TicketTickets T ';

  Line2 := 'WHERE ((ActualUsage IS NULL) OR (Cutter IS NULL)) ';
  Line3 := 'AND (T.WeekNo = S.WeekNo) AND (T.SequenceNo = S.SequenceNo) ';
  if (StrToInt(seFrom.Text) > StrToInt(seTo.Text)) then
    Line4 := 'AND (((T.WeekNo >= ' + seFrom.Text + ') AND (T.WeekNo <= 53)) OR ' +
             '((T.WeekNo >= 1) AND (T.WeekNo <= ' + seTo.Text + '))) '
  else
    Line4 := 'AND (T.WeekNo >= ' + seFrom.Text + ') AND (T.WeekNo <= ' + seTo.Text + ') ';
  Line5 := 'Order By T.WeekNo, T.WeekNo, T.SequenceNo, T.TicketNo';

  SQLString1 := SQLString1 + Line2;
  SQLString1 := SQLString1 + Line3;
  SQLString1 := SQLString1 + Line4;
  SQLString1 := SQLString1 + Line5;
  SQLString2 := SQLString2 + Line2;
  SQLString2 := SQLString2 + Line4;

  qNotUpdated.SQL.Text := SQLString1;
  qNotUpdatedTotals.SQL.Text := SQLString2;

  qNotUpdated.open;
  qNotUpdatedTotals.open;
end;

procedure TfmTicketsNotUpdated.btnRefreshClick(Sender: TObject);
begin
  InvalidWeekNo := False;

  tbMain.SetFocus;

  if not InvalidWeekNo then
  begin
    screen.cursor := crHourGlass;

    GoQueries;

    Display(True);

    screen.cursor := crDefault;
  end;
end;

procedure TfmTicketsNotUpdated.qNotUpdatedCalcFields(DataSet: TDataSet);
var
  WeekNo, SequenceNo, TicketNo : string;

begin
  qNotUpdatedAdjustedAllowance.value := dmBasAll.CalcAdjAlw(qNotUpdatedMaterialAreaCoeff.value, qNotUpdatedMaterialQualCoeff.value, qNotUpdatedAdjFactorResult.value, qNotUpdatedBasicAllowance.value);

  str(qNotUpdatedWeekNo.Value, WeekNo);
  str(qNotUpdatedSequenceNo.Value, SequenceNo);
  str(qNotUpdatedTicketNo.Value, TicketNo);

  qNotUpdatedValueMaterial.value := qNotUpdatedAdjustedAllowance.value * qNotUpdatedStandardMatPrice.value;
  qNotUpdatedTicketNumber.value := WeekNo + '/' + SequenceNo + '/' + TicketNo;
end;

procedure TfmTicketsNotUpdated.seFromChange(Sender: TObject);
begin
  Display(false);
end;

procedure TfmTicketsNotUpdated.seToChange(Sender: TObject);
begin
  Display(false);
end;

procedure TfmTicketsNotUpdated.Display(Query : boolean);
var
  ToFromColor : TColor;

begin
  if Query then
    ToFromColor := clData
  else
    ToFromColor := clRed;

  seTo.font.color := ToFromColor;
  seFrom.font.color := ToFromColor;
  dbgNotUpdated.enabled := Query;
  dbgNotUpdated.refresh;

  btnPrintPreview.enabled := Query;
  btnPrint.enabled := Query;

  dbtTotalValue.enabled := Query;
end;

procedure TfmTicketsNotUpdated.dbgNotUpdatedCellClick(Column: TColumn);
begin
  WhichField := Column.FieldName;
end;

procedure TfmTicketsNotUpdated.seFromInvalidEntry(Sender: TObject);
begin
  InvalidWeekNo := True;
  seFrom.Value := 1;
  seFrom.SetFocus;
end;

procedure TfmTicketsNotUpdated.seToInvalidEntry(Sender: TObject);
begin
  InvalidWeekNo := True;
  seTo.Value := 1;
  seTo.SetFocus;
end;

procedure TfmTicketsNotUpdated.FormActivate(Sender: TObject);
begin
  //Can't be set at design time because triggered OnCreate before components are ready - causes crash.
  seFrom.OnChange := seFromChange;
  seTo.OnChange := seToChange;  
end;

procedure TfmTicketsNotUpdated.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;
end;

procedure TfmTicketsNotUpdated.frTicketsNotUpdatedBeforePrint(
  Sender: TfrxReportComponent);
begin
  frTicketsNotUpdated.PreviewOptions.AllowEdit := False;
  frTicketsNotUpdated.PreviewOptions.Buttons := frTicketsNotUpdated.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frTicketsNotUpdated.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frTicketsNotUpdated.PreviewOptions.ZoomMode := zmDefault
  else
    frTicketsNotUpdated.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmTicketsNotUpdated.frTicketsNotUpdatedGetValue(
  const VarName: string; var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'From') then
    Value := seFrom.text
  else if (VarName = 'To') then
    Value := seTo.text;
end;

end.


