unit SizeRelationshipDetails;

interface

uses
  Classes, Controls, Forms,   FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DB, ExtCtrls, DBCtrls, Grids, DBGridPlus,
  DBGrids, StdCtrls, Mask, Buttons, ToolWin, ComCtrls, frxClass, frxDBSet,
  Types, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  frxReportPlus, FDConnectionPlus;
                               
type
  TfmSizeRelationshipDetails = class(TForm)
    dsSizeRelationships: TDataSource;
    tblSizeRelationshipSizes: TFDTablePlus;
    dsSizeRelationshipSizes: TDataSource;
    tblSizeRelationshipSizesRelationship: TStringField;
    tblSizeRelationships: TFDTablePlus;
    tblSizeRelationshipsRelationship: TStringField;
    tblSizeRelationshipsRange: TStringField;
    tblSizeRelationshipsDescription: TStringField;
    tblSizeRelationshipSizesShoeSize: TStringField;
    tblSizeRelationshipSizesKnifeSize: TStringField;
    tblSizeRelationshipSizesSeq: TFloatField;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnDelete: TSpeedButton;
    btnRefresh: TSpeedButton;
    pnlMain: TPanel;
    lblDescription: TLabel;
    lblSizeRange: TLabel;
    dbeDescription: TDBEdit;
    pnlView1: TPanel;
    dbtDescription: TDBText;
    LocalConnectionSumms: TFDConnectionPlus;
    dbtSizeRange: TDBText;
    qSizeInScale: TFDQueryPlus;
    qSizeInScaleTotal: TIntegerField;
    tblSizeRelationshipsScale: TStringField;
    tblSizeRelationshipSizesScale: TStringField;
    tblSizeRelationshipSizesRange: TStringField;
    pnlKeepPreview: TPanel;
    btnWhereUsed: TSpeedButton;
    btnCopy: TSpeedButton;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    dsFirstLast: TDataSource;
    qFirstLast: TFDQueryPlus;
    qFirstLastSize: TStringField;
    qFirstLastFirstSeq: TFloatField;
    qFirstLastLastSeq: TFloatField;
    tblSizeRangeSizes: TFDTablePlus;
    tblSizeRangeSizesScale: TStringField;
    tblSizeRangeSizesRange: TStringField;
    tblSizeRangeSizesSize: TStringField;
    tblSizeRangeSizesSeq: TFloatField;
    qFirstLastFirstseqSize: TStringField;
    qFirstLastScale: TStringField;
    qFirstLastRange: TStringField;
    qFirstLastLastSeqSize: TStringField;
    frSizeRelationship: TfrxReportPlus;
    frdbSizeRelationshipSizes: TfrxDBDataset;
    frdbFirstLast: TfrxDBDataset;
    pnlGrids: TPanel;
    dbgSizes: TDBGridPlus;
    dbgFirstLast: TDBGridPlus;
    pnlTitlesMain: TPanel;
    pnlTitles1: TPanel;
    pnlTitles3: TPanel;
    pnlTitles4: TPanel;
    pnlTitles2: TPanel;
    pnlTitles5: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassSizeRelationshipName(SizeRelationshipForm : TfmSizeRelationshipDetails; var Code: string);
    procedure tblSizeRelationshipSizesBeforeInsert(DataSet: TDataSet);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnWhereUsedClick(Sender: TObject);
    procedure tblSizeRelationshipSizesBeforePost(DataSet: TDataSet);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure UpdateScreen(Editing : boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure tblSizeRelationshipSizesBeforeDelete(DataSet: TDataSet);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure dbtSizeRangeDblClick(Sender: TObject);
    procedure SetTabStops(Editing: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure tblSizeRelationshipSizesBeforeOpen(DataSet: TDataSet);
    procedure frSizeRelationshipGetValue(const VarName: string; var Value: Variant);
    procedure frSizeRelationshipBeforePrint(Sender: TfrxReportComponent);
    procedure pcMainDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
  private
    { Private declarations }
    BusyPrinting: boolean;
    fmSizeRelationshipDetails: TfmSizeRelationshipDetails;
  public
    { Public declarations }
    SizeRelationshipCode : string;
  end;

implementation

uses
  SysUtils, Graphics, Dialogs, SizeRelationshipWhereUsed, Summs, CopySizeReln,
  General, OutOfMemory, CmnVars, SizeRangeDetails, SummsVars, AdvErrorHandler;

{$R *.DFM}

procedure TfmSizeRelationshipDetails.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    if tblSizeRelationships.state in [dsEdit, dsInsert] then
    begin
      if MessageDlgPos('Save Changes to Size Relationship ' + SizeRelationshipCode + '?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
        btnSave.click
      else
        btnCancel.click;
    end;

    action := caFree;
  end;
end;

procedure TfmSizeRelationshipDetails.PassSizeRelationshipName(SizeRelationshipForm : TfmSizeRelationshipDetails; var Code: string);
begin
  try
    fmSizeRelationshipDetails := SizeRelationshipForm;
    SizeRelationshipCode := Code;

    Caption := 'Size Relationship : ' + SizeRelationshipCode;

    screen.cursor := crHourGlass;
    tblSizeRelationships.open;
    tblSizeRelationships.setRange([SizeRelationshipCode], [SizeRelationshipCode]);
    tblSizeRelationshipSizes.open;
    tblSizeRangeSizes.Open;
    qFirstLast.ParamByName('SReln').value := SizeRelationshipCode;
    qFirstLast.open;
    screen.cursor := crDefault;

    if tblSizeRelationships.recordcount = 0 then
    begin
      MessageDlgPos('Size Relationship ' + SizeRelationshipCode + ' does not exist', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      close;
    end;
  except
    Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure TfmSizeRelationshipDetails.pcMainDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

procedure TfmSizeRelationshipDetails.tblSizeRelationshipSizesBeforeInsert(
  DataSet: TDataSet);
begin
  Abort;
end;

procedure TfmSizeRelationshipDetails.btnDeleteClick(Sender: TObject);
var
  LockSuccess : boolean;
  CanDelete : boolean;

begin
  if ItemGone(tblSizeRelationships, SizeRelationshipCode) then
    Close
  else
  begin
    CanDelete := False;

    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingleWithoutOption(oSizeRelationship, tblSizeRelationships, SizeRelationshipCode);

    if LockSuccess then
    begin
      CanDelete := (MessageDlgPos('Delete Size Relationship?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes);
      if CanDelete then
      begin
        try
          tblSizeRelationships.delete;
        except
          on E: Exception do
          begin
            fmErrorHandler.DebugMessageDlg('Size Relationship in use', E.Message, '');
            CanDelete := false;
          end;
        end;
      end;
    end;

    //Unlock
    if CanDelete then
      LocalConnectionSumms.Commit
    else
      LocalConnectionSumms.RollBack;

    //Ensure table not in Edit mode and Close if deleted
    tblSizeRelationshipSizes.Cancel;
    tblSizeRelationships.cancel;
    if CanDelete then
      Close;
  end;
end;

procedure TfmSizeRelationshipDetails.btnWhereUsedClick(Sender: TObject);
var
  Failed : boolean;

begin
  if ItemGone(tblSizeRelationships, SizeRelationshipCode) then
    Close
  else if not ExistingToFront('Where Used for Size Relationship', SizeRelationshipCode) then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmSizeRelationshipWhereUsed := TfmSizeRelationshipWhereUsed.create(fmSumms);
    except
      fmMemoryError.TidyUp(Self);
      Failed := True;
    end;

    if not Failed then
      fmSizeRelationshipWhereUsed.PassSizeRelationshipName(SizeRelationshipCode);
  end;
end;

procedure TfmSizeRelationshipDetails.tblSizeRelationshipSizesBeforePost(
  DataSet: TDataSet);
var
  SizeExists : boolean;

begin
  qSizeInScale.parambyName('Range').value := tblSizeRelationshipsRange.value;
  qSizeInScale.parambyName('Size').value := tblSizeRelationshipSizesKnifeSize.value;

  qSizeInScale.open;
  SizeExists := (qSizeInScaleTotal.value = 1);
  qSizeInScale.close;

  if not SizeExists then
  begin
    MessageDlgPos('Knife Size does not exist', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    abort;
  end;
end;

procedure TfmSizeRelationshipDetails.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  if ItemGone(tblSizeRelationships, SizeRelationshipCode) then
    Close
  else
  begin
    frSizeRelationship.ReportOptions.Name := 'Preview ' + Caption;
    ClosePreviewForm(Caption);

    btnPrint.Enabled := False;
    btnPrintPreview.Enabled := False;

    MyBookmark := tblSizeRelationshipSizes.GetBookmark;
    tblSizeRelationshipSizes.DisableControls;

    frSizeRelationship.PrintOptions.PrintMode := pmScale;
    frSizeRelationship.PrintOptions.PrintOnSheet := GetPaperSize;
    frSizeRelationship.PrepareReport;

    try
    tblSizeRelationshipSizes.GotoBookmark(MyBookmark);
    except
    end;
    tblSizeRelationshipSizes.FreeBookmark(MyBookmark);
    tblSizeRelationshipSizes.EnableControls;

    if ((Sender as TSpeedButton) = btnPrintPreview) then
    begin
      with frSizeRelationship do
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
      frSizeRelationship.Print;

    btnPrint.Enabled := True;
    btnPrintPreview.Enabled := True;
  end;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmSizeRelationshipDetails.btnCopyClick(Sender: TObject);
begin
  if ItemGone(tblSizeRelationships, SizeRelationshipCode) then
    Close
  else
  begin
    fmCopySizeRelationship.BaseCode := tblSizeRelationshipsRelationship.Value;
    fmCopySizeRelationship.ShowModal;
  end;
end;

procedure TfmSizeRelationshipDetails.UpdateScreen(Editing : boolean);
begin
  if editing then
    tbMain.color := clEditing
  else
    tbMain.color := clBack;

  btnEdit.enabled := not Editing;
  btnSave.enabled := Editing;
  btnCancel.enabled := Editing;
  btnDelete.enabled := not Editing;
  btnRefresh.enabled := not Editing;

  btnPrint.enabled := not Editing;
  btnPrintPreview.enabled := not Editing;
  btnCopy.enabled := not Editing;
  btnWhereUsed.enabled := not Editing;

  pnlView1.visible := not Editing;

  SetTabStops(Editing);

  if Option_ProductionSystem then
  begin
    dbgSizes.Columns[1].ReadOnly := not Editing;
    if Editing then
    begin
      dbgSizes.Options := dbgSizes.Options + [dgEditing];
      dbgSizes.Color := clEditing;
      dbgSizes.Columns[1].color := clEditing;
    end
    else
    begin
      dbgSizes.Options := dbgSizes.Options - [dgEditing];
      dbgSizes.Color := clBack;
      dbgSizes.Columns[1].color := clBack;
    end;
  end;

  if Editing then
    dbeDescription.setfocus
  else
    tbMain.setfocus;

  dbgFirstLast.Visible := not Editing;
end;

procedure TfmSizeRelationshipDetails.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblSizeRelationshipSizes.cancel;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock (& Non saved edits)
  tblSizeRelationships.cancel;

  //Refresh Grids
  tblSizeRelationshipSizes.refresh;
  dbgSizes.refresh;

  UpdateScreen(False);
end;

procedure TfmSizeRelationshipDetails.btnSaveClick(Sender: TObject);
begin
  if tblSizeRelationshipSizes.state in [dsEdit, dsInsert] then
    tblSizeRelationshipSizes.post;

  tblSizeRelationships.post;
  LocalConnectionSumms.commit;

  UpdateScreen(False);

  //Refresh Summary
  qFirstLast.close;
  qFirstLast.open;
end;

procedure TfmSizeRelationshipDetails.btnEditClick(Sender: TObject);
var
  LockSuccess : boolean;

begin
  if ItemGone(tblSizeRelationships, SizeRelationshipCode) then
    Close
  else
  begin
    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingleWithoutOption(oSizeRelationship, tblSizeRelationships, SizeRelationshipCode);

    if LockSuccess then
      UpdateScreen(True)
    else
      LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmSizeRelationshipDetails.btnRefreshClick(Sender: TObject);
begin
  if ItemGone(tblSizeRelationships, SizeRelationshipCode) then
    Close
  else
    tblSizeRelationshipSizes.refresh;
end;

procedure TfmSizeRelationshipDetails.tblSizeRelationshipSizesBeforeDelete(
  DataSet: TDataSet);
begin
  Abort;
end;

procedure TfmSizeRelationshipDetails.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmSizeRelationshipDetails.dbtSizeRangeDblClick(Sender: TObject);
var
  fmSizeRangeDetails: TfmSizeRangeDetails;
  Code : string;
  Failed : boolean;

begin
  Code := tblSizeRelationshipsRange.value;

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

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmSizeRelationshipDetails.SetTabStops(Editing: Boolean);
begin
  dbeDescription.TabStop := Editing;
end;

procedure TfmSizeRelationshipDetails.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;

  SetTabStops(False);
end;

procedure TfmSizeRelationshipDetails.frSizeRelationshipBeforePrint(
  Sender: TfrxReportComponent);
begin
  frSizeRelationship.PreviewOptions.AllowEdit := False;
  frSizeRelationship.PreviewOptions.Buttons := frSizeRelationship.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frSizeRelationship.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frSizeRelationship.PreviewOptions.ZoomMode := zmDefault
  else
    frSizeRelationship.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmSizeRelationshipDetails.frSizeRelationshipGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
    Value := 'Size Relationship : ' + SizeRelationshipCode
  else if (VarName = 'Description') then
    Value := dbtDescription.Caption
  else if (VarName = 'SizeRange') then
    Value := dbtSizeRange.Caption;
end;

procedure TfmSizeRelationshipDetails.tblSizeRelationshipSizesBeforeOpen(
  DataSet: TDataSet);
begin
  if not Option_ProductionSystem then
    dbgSizes.ReadOnly := True;
end;

end.

