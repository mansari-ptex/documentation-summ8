unit CutterNames;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DBGridPlus, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons, ComCtrls,
  ToolWin, Grids, frxClass, frxDBSet, General, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, DBGrids, frxReportPlus, FDConnectionPlus;

type
  TfmCutterNames = class(TForm)
    tblCutterNames: TFDTablePlus;
    dsCutterNames: TDataSource;
    dbgCutterNames: TDBGridPlus;
    sbAppend: TSpeedButton;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnRefresh: TSpeedButton;
    LocalConnectionSumms: TFDConnectionPlus;
    tblCutterNamesCode: TStringField;
    tblCutterNamesName: TStringField;
    tblCutterNamesLocation: TStringField;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frCutterNames: TfrxReportPlus;
    frdbCutterNames: TfrxDBDataset;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPrintClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure UpdateScreen;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure tblCutterNamesAfterOpen(DataSet: TDataSet);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure Pass;
    procedure dbgCutterNamesKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure frCutterNamesBeforePrint(Sender: TfrxReportComponent);
    procedure frCutterNamesGetValue(const VarName: string; var Value: Variant);
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
  private
    { Private declarations }
    BusyPrinting: boolean;
    Editing : boolean;
  public
    { Public declarations }
  end;

var
  fmCutterNames: TfmCutterNames;

implementation

uses
  Graphics, Dialogs, Summs, OutOfMemory, CmnVars, SummsVars;

{$R *.DFM}

procedure TfmCutterNames.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    if Editing then
    begin
      if MessageDlgPos('Save Changes to Cutter Names?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
        btnSave.click
      else
        btnCancel.click;
    end;

    action := caFree;
  end;
end;

procedure TfmCutterNames.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmCutterNames.frCutterNamesBeforePrint(
  Sender: TfrxReportComponent);
begin
  frCutterNames.PreviewOptions.AllowEdit := False;
  frCutterNames.PreviewOptions.Buttons := frCutterNames.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frCutterNames.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frCutterNames.PreviewOptions.ZoomMode := zmDefault
  else
    frCutterNames.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmCutterNames.frCutterNamesGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmCutterNames.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frCutterNames.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := tblCutterNames.GetBookmark;
  tblCutterNames.DisableControls;

  frCutterNames.PrintOptions.PrintMode := pmScale;
  frCutterNames.PrintOptions.PrintOnSheet := GetPaperSize;
  frCutterNames.PrepareReport;

  try
    tblCutterNames.GotoBookmark(MyBookmark);
  except
  end;
  tblCutterNames.EnableControls;
  tblCutterNames.FreeBookmark(MyBookmark);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frCutterNames do
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
    frCutterNames.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;


procedure TfmCutterNames.btnEditClick(Sender: TObject);
var
  LockSuccess: boolean;

begin
  //Attempt Lock
  LockSuccess := LockOption(fmSumms.tblLocks, oCutterNames);

  if LockSuccess then
  begin
    Editing := true;

    LocalConnectionSumms.StartTransaction;

    dbgCutterNames.Options := dbgCutterNames.Options + [dgEditing];

    UpdateScreen;
  end;
end;

procedure TfmCutterNames.UpdateScreen;
begin
  if Editing then
  begin
    tbMain.color := clEditing;
    dbgCutterNames.color := clEditing;
    dbgCutterNames.Columns[0].color := clEditing;
    dbgCutterNames.Columns[1].color := clEditing;
    dbgCutterNames.Columns[2].color := clEditing;
  end
  else
  begin
    tbMain.color := clBack;
    dbgCutterNames.color := clBack;
    dbgCutterNames.Columns[0].color := clBack;
    dbgCutterNames.Columns[1].color := clBack;
    dbgCutterNames.Columns[2].color := clBack;
  end;

  btnEdit.enabled := not Editing;
  btnSave.enabled := Editing;
  btnCancel.enabled := Editing;
  btnRefresh.enabled := not Editing;

  btnPrint.enabled := not Editing;
  btnPrintPreview.enabled := not Editing;
end;


procedure TfmCutterNames.btnSaveClick(Sender: TObject);
begin
  if tblCutterNames.state in [dsEdit, dsInsert] then
    tblCutterNames.post;

  dbgCutterNames.Options := dbgCutterNames.Options - [dgEditing];

  //Stops Inplace editor showing when save/cancel non posted record
  dbgCutterNames.Enabled := false;
  dbgCutterNames.Enabled := true;

  LocalConnectionSumms.commit;

  //Release Lock
  LocksUnLockRecord(fmSumms.tblLocks, 'CUTTER_NAMES');
  Editing := false;

  UpdateScreen;
end;

procedure TfmCutterNames.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblCutterNames.cancel;

  //Turn off editing
  dbgCutterNames.Options := dbgCutterNames.Options - [dgEditing];

  //Stops Inplace editor showing when save/cancel non posted record
  dbgCutterNames.Enabled := false;
  dbgCutterNames.Enabled := true;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock (& Non saved edits)
  tblCutterNames.cancel;

  //Refresh Grids
  tblCutterNames.refresh;
  dbgCutterNames.refresh;

  //Release Lock
  LocksUnLockRecord(fmSumms.tblLocks, 'CUTTER_NAMES');
  Editing := false;

  UpdateScreen;
end;

procedure TfmCutterNames.btnRefreshClick(Sender: TObject);
begin
  tblCutterNames.refresh;
end;

procedure TfmCutterNames.tblCutterNamesAfterOpen(
  DataSet: TDataSet);
begin
  tbMain.enabled := true;
end;

procedure TfmCutterNames.LocalConnectionSummsAfterConnect(Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmCutterNames.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmCutterNames.Pass;
begin
  tblCutterNames.open;
end;

procedure TfmCutterNames.dbgCutterNamesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (dbgCutterNames.SelectedField.Fieldname = 'Code') or (dbgCutterNames.SelectedField.Fieldname = 'Location') then
    Key := upcase(Key);
end;

procedure TfmCutterNames.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;
end;

end.
