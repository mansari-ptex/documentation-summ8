unit ConstructionsWhereUsed;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DBGridPlus, Buttons,
  ToolWin, ComCtrls, Grids, frxClass, frxDBSet, Vcl.DBGrids, frxReportPlus, Vcl.Dialogs;

type
  TfmConstructionsWhereUsed = class(TForm)
    dsStyleConstructions: TDataSource;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    pnlStyles: TPanel;
    dbgStyConstructionsUsing: TDBGridPlus;
    qStyleConstructions: TFDQueryPlus;
    qStyleConstructionsStyle: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frConstructionsWhereUsed: TfrxReportPlus;
    frdbStyleConstructions: TfrxDBDataset;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure PassConstructionName(var Code: string);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgStyConstructionsUsingDblClick(Sender: TObject);
    procedure dbgStyConstructionsUsingKeyPress(Sender: TObject;
      var Key: Char);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frConstructionsWhereUsedBeforePrint(Sender: TfrxReportComponent);
    procedure frConstructionsWhereUsedGetValue(const VarName: string;
      var Value: Variant);
  private
    { Private declarations }
    BusyPrinting: boolean;
  public
    { Public declarations }
  end;

var
  fmConstructionsWhereUsed: TfmConstructionsWhereUsed;

implementation

uses
  Windows, Graphics, General, Summs, StyleDetails, OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmConstructionsWhereUsed.FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TfmConstructionsWhereUsed.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfmConstructionsWhereUsed.PassConstructionName(var Code: string);
begin
  Caption := 'Where Used for Construction : ' + Code;

  qStyleConstructions.ParamByName('Construction').AsString := Code;
  qStyleConstructions.Open;
end;

procedure TfmConstructionsWhereUsed.frConstructionsWhereUsedBeforePrint(
  Sender: TfrxReportComponent);
begin
  frConstructionsWhereUsed.PreviewOptions.AllowEdit := False;
  frConstructionsWhereUsed.PreviewOptions.Buttons := frConstructionsWhereUsed.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frConstructionsWhereUsed.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frConstructionsWhereUsed.PreviewOptions.ZoomMode := zmDefault
  else
    frConstructionsWhereUsed.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmConstructionsWhereUsed.frConstructionsWhereUsedGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmConstructionsWhereUsed.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frConstructionsWhereUsed.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qStyleConstructions.GetBookmark;
  qStyleConstructions.DisableControls;

  frConstructionsWhereUsed.PrintOptions.PrintMode := pmScale;
  frConstructionsWhereUsed.PrintOptions.PrintOnSheet := GetPaperSize;
  frConstructionsWhereUsed.PrepareReport;

  try
    qStyleConstructions.GotoBookmark(MyBookmark);
  except
  end;
  qStyleConstructions.EnableControls;
  qStyleConstructions.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frConstructionsWhereUsed do
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
    frConstructionsWhereUsed.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmConstructionsWhereUsed.dbgStyConstructionsUsingDblClick(Sender: TObject);

var
  Code : string;
  Failed:boolean;
  fmStyleDetails : TfmStyleDetails;

begin
  Code := qStyleConstructionsStyle.value;

  if not(Code = '') then
  begin
    if not ExistingToFront('Style', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmStyleDetails := TfmStyleDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true
      end;

      if not Failed then
        fmStyleDetails.PassStyleName(fmStyleDetails, Code)
    end;
  end;
end;

procedure TfmConstructionsWhereUsed.dbgStyConstructionsUsingKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgStyConstructionsUsingDblClick(Self);
end;

procedure TfmConstructionsWhereUsed.btnRefreshClick(Sender: TObject);
begin
  qStyleConstructions.close;
  qStyleConstructions.open;
end;

procedure TfmConstructionsWhereUsed.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;
end;

end.
