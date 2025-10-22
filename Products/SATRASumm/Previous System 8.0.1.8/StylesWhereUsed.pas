unit StylesWhereUsed;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus,
  Buttons, ToolWin, ComCtrls, frxClass, frxDBSet, Vcl.DBGrids, frxReportPlus, System.SysUtils,
  Vcl.Dialogs;

type
  TfmStylesWhereUsed = class(TForm)
    pnlTicketSequences: TPanel;
    dbgTicketSequences: TDBGridPlus;
    dsTicketSequences: TDataSource;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    qTicketSequences: TFDQueryPlus;
    qTicketSequencesWeekNo: TSmallintField;
    qTicketSequencesSequenceNo: TSmallintField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frdbTicketSequences: TfrxDBDataset;
    frStylesWhereUsed: TfrxReportPlus;
    pnlTitlesMain: TPanel;
    pnlTitles1: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure PassPartName(var Code: string);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgTicketSequencesDblClick(Sender: TObject);
    procedure dbgTicketSequencesKeyPress(Sender: TObject; var Key: Char);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frStylesWhereUsedBeforePrint(Sender: TfrxReportComponent);
    procedure frStylesWhereUsedGetValue(const VarName: string;
      var Value: Variant);
  private
    { Private declarations }
    BusyPrinting: boolean;
  public
    { Public declarations }
  end;

var
  fmStylesWhereUsed: TfmStylesWhereUsed;

implementation

uses
  Windows, Graphics, Summs, TicketsBreakdown, General, OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmStylesWhereUsed.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    action := caFree
  end;
end;

procedure TfmStylesWhereUsed.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmStylesWhereUsed.PassPartName(var Code: string);
begin
  Caption := 'Where Used for Style : ' + Code;

  qTicketSequences.ParamByName('Style').AsString := Code;
  qTicketSequences.Open;
end;

procedure TfmStylesWhereUsed.frStylesWhereUsedBeforePrint(
  Sender: TfrxReportComponent);
begin
  frStylesWhereUsed.PreviewOptions.AllowEdit := False;
  frStylesWhereUsed.PreviewOptions.Buttons := frStylesWhereUsed.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frStylesWhereUsed.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frStylesWhereUsed.PreviewOptions.ZoomMode := zmDefault
  else
    frStylesWhereUsed.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmStylesWhereUsed.frStylesWhereUsedGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmStylesWhereUsed.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frStylesWhereUsed.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qTicketSequences.GetBookmark;
  qTicketSequences.DisableControls;

  frStylesWhereUsed.PrintOptions.PrintMode := pmScale;
  frStylesWhereUsed.PrintOptions.PrintOnSheet := GetPaperSize;
  frStylesWhereUsed.PrepareReport;

  try
    qTicketSequences.GotoBookmark(MyBookmark);
  except
  end;
  qTicketSequences.EnableControls;
  qTicketSequences.FreeBookmark(MyBookmark);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frStylesWhereUsed do
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
    frStylesWhereUsed.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmStylesWhereUsed.dbgTicketSequencesDblClick(Sender: TObject);
var
  TicketCaption: string;
  TicketCode: string;
  SequenceNo, WeekNo : integer;
  Failed : boolean;
  fmTicketsBreakdown : TfmTicketsBreakdown;

begin
  WeekNo := qTicketSequencesWeekNo.value;
  SequenceNo := qTicketSequencesSequenceNo.value;

  TicketCaption := 'Ticket(s)';
  TicketCode := IntToStr(WeekNo) + '/' + IntToStr(SequenceNo) + '/xx    ';

  if (WeekNo > 0) and (WeekNo < 54) then
  begin
    if not ExistingToFront(TicketCaption, TicketCode) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmTicketsBreakdown := TfmTicketsBreakDown.Create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmTicketsBreakdown.PassTicketSequenceReference(fmTicketsBreakdown, WeekNo, SequenceNo);

    end;
  end;
end;

procedure TfmStylesWhereUsed.dbgTicketSequencesKeyPress(Sender: TObject;
                                                        var Key: Char);
begin
  if (ord(Key) = VK_RETURN) then
    dbgTicketSequencesDblClick(Self);
end;

procedure TfmStylesWhereUsed.btnRefreshClick(Sender: TObject);
begin
  qTicketSequences.close;
  qTicketSequences.open;
end;

procedure TfmStylesWhereUsed.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;
end;

end.
