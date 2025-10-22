unit SMRate;

interface

uses
  Classes, Controls, Forms, StdCtrls, XStringGrid, XStringGridPlus, Buttons,
  ExtCtrls, ToolWin, ComCtrls, Grids, frxClass, frxDBSet, PBNumEdit,
  frxReportPlus, Vcl.Dialogs;

type
  TfmSMRateTable = class(TForm)
    tbMain: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    pnlInput: TPanel;
    Label1: TLabel;
    lblSms: TLabel;
    Label2: TLabel;
    lblPercBonus: TLabel;
    lblAverageValue: TLabel;
    eBaseRate: TPBNumEdit;
    eSms: TPBNumEdit;
    eLeatherValue: TPBNumEdit;
    ePercBonus: TPBNumEdit;
    lblAveVal: TLabel;
    pnlOutput: TPanel;
    sgRateTable: TXStringGridPlus;
    frSMRateTable: TfrxReportPlus;
    frudsSMRateTable: TfrxUserDataSet;
    procedure CalcRates(StrLeatherValue,StrSms,StrPercBonus,StrBaseRate:String);
    procedure btnPrintPreviewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure eBaseRateChange(Sender: TObject);
    procedure sgRateTableSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure frudsSMRateTableGetValue(const VarName: string;
      var Value: Variant);
    procedure frSMRateTableBeforePrint(Sender: TfrxReportComponent);
    procedure frSMRateTableGetValue(const VarName: string; var Value: Variant);
  private
    { Private declarations }
    BusyPrinting: boolean;
  public
    { Public declarations }
  end;

var
  fmSMRateTable: TfmSMRateTable;

implementation

uses
  Graphics, Summs, OutOfMemory, General, SummsVars;

{$R *.DFM}

procedure TfmSMRateTable.CalcRates(StrLeatherValue,StrSms,StrPercBonus,StrBaseRate:String);
var
  Code, Saved: integer;
  Average,Increment,Rate,LeatherValue,Sms,PercBonus,BaseRate:real;
  Percentage,RateStr,StrAverage:string;
  Rates: Array [0..80] of Real;

begin
  val(StrLeatherValue, LeatherValue, Code);
  val(StrSms, Sms, Code);
  val(StrPercBonus, PercBonus, Code);
  val(StrBaseRate, BaseRate, Code);

  if (LeatherValue <> 0) and (Sms <> 0) and (PercBonus <> 0) and (BaseRate <> 0) then
  begin
    Average := LeatherValue / Sms;

    Str(Average : 4 : 2, StrAverage);
    lblAveVal.caption := StrAverage;

    Increment := Average / 1000 * (PercBonus/100);

    Rate := BaseRate - Increment;
    for Saved := 0 to 80 do
    begin
      Rate := Rate + Increment;
      Rates[Saved] := Rate;
      str(Saved / 10 : 3 :1, Percentage);
      sgRateTable.Cells[0, Saved + 1] := Percentage;
      str(Rates[Saved] : 7 : 4, RateStr);
      sgRateTable.Cells[1, Saved + 1] := RateStr;
    end;
  end
  else
  begin
    for Saved := 0 to 80 do
    begin
      sgRateTable.Cells[0, Saved + 1] := '';
      sgRateTable.Cells[1, Saved + 1] := '';
    end;

    lblAveVal.caption := '';
  end;
end;

procedure TfmSMRateTable.frSMRateTableBeforePrint(Sender: TfrxReportComponent);
begin
  frSMRateTable.PreviewOptions.AllowEdit := False;
  frSMRateTable.PreviewOptions.Buttons := frSMRateTable.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frSMRateTable.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frSMRateTable.PreviewOptions.ZoomMode := zmDefault
  else
    frSMRateTable.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmSMRateTable.frSMRateTableGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
    Value := Caption
end;

procedure TfmSMRateTable.frudsSMRateTableGetValue(
  const VarName: string; var Value: Variant);
begin
  if (frudsSMRateTable.RecNo = 0) then
    frudsSMRateTable.Next;

  if VarName = 'PercSaved' then
    Value := sgRateTable.Cells[0, frudsSMRateTable.RecNo]
  else if VarName = 'SMRate' then
    Value := sgRateTable.Cells[1, frudsSMRateTable.RecNo];
end;

procedure TfmSMRateTable.btnPrintPreviewClick(Sender: TObject);
begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frSMRateTable.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  frudsSMRateTable.RangeEnd := reCount;

  frudsSMRateTable.RangeEndCount := sgRateTable.RowCount;

  frSMRateTable.PrintOptions.PrintMode := pmScale;
  frSMRateTable.PrintOptions.PrintOnSheet := GetPaperSize;
  frSMRateTable.PrepareReport;

  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frSMRateTable do
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
    frSMRateTable.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmSMRateTable.FormClose(Sender: TObject;
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

procedure TfmSMRateTable.eBaseRateChange(Sender: TObject);
begin
  CalcRates(eLeatherValue.text, eSms.text, ePercBonus.text, eBaseRate.text);
end;

procedure TfmSMRateTable.sgRateTableSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow = 0 then
    CanSelect := False;
end;

procedure TfmSMRateTable.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;
end;

end.
