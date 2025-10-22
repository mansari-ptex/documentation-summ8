unit CutterLocations;

interface

uses
  Classes, Controls, Forms, ExtCtrls, DBGridPlus, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,  ComCtrls,
  ToolWin, Grids, frxClass, frxDBSet, General, DBGrids, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, frxReportPlus, FDConnectionPlus;

type
  TfmCutterLocations = class(TForm)
    tblCutterLocations: TFDTablePlus;
    dsCutterLocations: TDataSource;
    dbgCutterLocations: TDBGridPlus;
    sbAppend: TSpeedButton;
    tblCutterLocationsCode: TStringField;
    tblCutterLocationsDescription: TStringField;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnRefresh: TSpeedButton;
    LocalConnectionSumms: TFDConnectionPlus;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    frCutterLocations: TfrxReportPlus;
    frdbCutterLocations: TfrxDBDataset;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPrintClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure UpdateScreen;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure tblCutterLocationsAfterOpen(DataSet: TDataSet);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure Pass;
    procedure dbgCutterLocationsKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure frCutterLocationsBeforePrint(Sender: TfrxReportComponent);
    procedure frCutterLocationsGetValue(const VarName: string;
      var Value: Variant);
  private
    { Private declarations }
    BusyPrinting: boolean;
    Editing : boolean;
  public
    { Public declarations }
  end;

var
  fmCutterLocations: TfmCutterLocations;

implementation

uses
  Graphics, Dialogs, Summs, OutOfMemory, Cmnvars, SummsVars;

{$R *.DFM}

procedure TfmCutterLocations.FormClose(Sender: TObject;
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
      if MessageDlgPos('Save Changes to Cutter Locations?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
        btnSave.click
      else
        btnCancel.click;
    end;

    action := caFree;
  end;
end;

procedure TfmCutterLocations.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmCutterLocations.frCutterLocationsBeforePrint(
  Sender: TfrxReportComponent);
begin
  frCutterLocations.PreviewOptions.AllowEdit := False;
  frCutterLocations.PreviewOptions.Buttons := frCutterLocations.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frCutterLocations.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frCutterLocations.PreviewOptions.ZoomMode := zmDefault
  else
    frCutterLocations.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmCutterLocations.frCutterLocationsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := Caption;
end;

procedure TfmCutterLocations.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frCutterLocations.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := tblCutterLocations.GetBookmark;
  tblCutterLocations.DisableControls;

  frCutterLocations.PrintOptions.PrintMode := pmScale;
  frCutterLocations.PrintOptions.PrintOnSheet := GetPaperSize;
  frCutterLocations.PrepareReport;

  try
    tblCutterLocations.GotoBookmark(MyBookmark);
  except
  end;
  tblCutterLocations.EnableControls;
  tblCutterLocations.FreeBookmark(MyBookmark);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frCutterLocations do
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
    frCutterLocations.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmCutterLocations.btnEditClick(Sender: TObject);
var
  LockSuccess : boolean;

begin
  //Attempt Lock
  LockSuccess := LockOption(fmSumms.tblLocks, oCutterLocations);

  if LockSuccess then
  begin
    Editing := true;

    LocalConnectionSumms.StartTransaction;

    dbgCutterLocations.Options := dbgCutterLocations.Options + [dgEditing];

    UpdateScreen;
  end;
end;

procedure TfmCutterLocations.UpdateScreen;
begin
  if Editing then
  begin
    tbMain.color := clEditing;
    dbgCutterLocations.color := clEditing;
    dbgCutterLocations.Columns[0].color := clEditing;
    dbgCutterLocations.Columns[1].color := clEditing;
  end
  else
  begin
    tbMain.color := clBack;
    dbgCutterLocations.color := clBack;
    dbgCutterLocations.Columns[0].color := clBack;
    dbgCutterLocations.Columns[1].color := clBack;
  end;

  btnEdit.enabled := not Editing;
  btnSave.enabled := Editing;
  btnCancel.enabled := Editing;
  btnRefresh.enabled := not Editing;

  btnPrint.enabled := not Editing;
  btnPrintPreview.enabled := not Editing;
end;


procedure TfmCutterLocations.btnSaveClick(Sender: TObject);
begin
  if tblCutterLocations.state in [dsEdit, dsInsert] then
    tblCutterLocations.post;

  dbgCutterLocations.Options := dbgCutterLocations.Options - [dgEditing];

  //Stops Inplace editor showing when save/cancel non posted record
  dbgCutterLocations.Enabled := false;
  dbgCutterLocations.Enabled := true;

  LocalConnectionSumms.commit;

  //Release Lock
  LocksUnLockRecord(fmSumms.tblLocks, 'CUTTER_LOCATIONS');
  Editing := false;

  UpdateScreen;
end;

procedure TfmCutterLocations.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblCutterLocations.cancel;

  //Turn off editing
  dbgCutterLocations.Options := dbgCutterLocations.Options - [dgEditing];

  //Stops Inplace editor showing when save/cancel non posted record
  dbgCutterLocations.Enabled := false;
  dbgCutterLocations.Enabled := true;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock (& Non saved edits)
  tblCutterLocations.cancel;

  //Refresh Grids
  tblCutterLocations.refresh;
  dbgCutterLocations.refresh;

  //Release Lock
  LocksUnLockRecord(fmSumms.tblLocks, 'CUTTER_LOCATIONS');
  Editing := false;

  UpdateScreen;
end;

procedure TfmCutterLocations.btnRefreshClick(Sender: TObject);
begin
  tblCutterLocations.refresh;
end;

procedure TfmCutterLocations.tblCutterLocationsAfterOpen(
  DataSet: TDataSet);
begin
  tbMain.enabled := true;
end;

procedure TfmCutterLocations.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmCutterLocations.Pass;
begin
  tblCutterLocations.open;
end;

procedure TfmCutterLocations.dbgCutterLocationsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (dbgCutterLocations.SelectedField.Fieldname = 'Code') then
    Key := upcase(Key);
end;

procedure TfmCutterLocations.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;
end;

end.
