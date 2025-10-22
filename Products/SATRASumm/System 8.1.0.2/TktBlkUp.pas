unit TktBlkUp;

interface

uses
  Windows, Classes, Controls, Forms, Dialogs, Types, StdCtrls, Grids, DBGridPlus,
  Db,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, ComCtrls, Tabnotbk, Mask, DBCtrls, ExtCtrls,
  DBCGrids,  Buttons, ToolWin, TicketUpdateCommon, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, Vcl.DBGrids, TicketsAllDM, FDConnectionPlus;
  
type
  TfmTicketBulkUpdate = class(TForm)
    tblTicketUpdate: TFDTablePlus;
    dsTktBlkUpdate: TDataSource;
    tblTicketUpdateCutWeek: TSmallintField;
    tblTicketUpdateCutter: TStringField;
    tblTicketUpdateCutterLocation: TStringField;
    tblTicketUpdateMatSupplier: TStringField;
    tblTicketUpdateMatPrice: TCurrencyField;
    tblTicketUpdateQuality: TSmallintField;
    tblTicketUpdateActualUsage: TFloatField;
    tblTicketUpdateIssuedAllowance: TFloatField;
    tblTicketUpdateSMVs: TFloatField;
    tblTicketUpdateBulkUpdate: TBooleanField;
    tblTicketBulkUpdate: TFDTablePlus;
    dsBulkUpdate: TDataSource;
    dlgOpenTicketFile: TOpenDialog;
    tblTicketBulkUpdateWeekNo: TIntegerField;
    tblTicketBulkUpdateSequenceNo: TIntegerField;
    tblTicketBulkUpdateTicketNo: TIntegerField;
    LocalConnectionSumms: TFDConnectionPlus;
    qReadTicketFile: TFDQueryPlus;
    tbMain: TPanel;
    btnLoad: TSpeedButton;
    btnUpdateTickets: TSpeedButton;
    qUpdateTicketsPreUpdate: TFDQueryPlus;
    qTotals: TFDQueryPlus;
    dsTicketUpdateAudit: TDataSource;
    tblTicketUpdateAudit: TFDTablePlus;
    tblTicketUpdateAuditWeekNo: TIntegerField;
    tblTicketUpdateAuditSequenceNo: TIntegerField;
    tblTicketUpdateAuditTicketNo: TIntegerField;
    tblTicketUpdateAuditErrorLevel: TSmallintField;
    tblTicketUpdateAuditMessage: TStringField;
    tblTicketUpdateAuditActualErrorLevel: TStringField;
    tblTicketUpdateIdentifier: TStringField;
    tblTicketBulkUpdateIdentifier: TStringField;
    tblTicketUpdateAuditIdentifier: TStringField;
    tblTicketUpdateArea: TSmallintField;
    tblTicketTickets: TFDTablePlus;
    dsTicketTickets: TDataSource;
    tblTicketBulkUpdateMaterial: TStringField;
    tblTicketBulkUpdateMatPrice: TCurrencyField;
    tblTicketBulkUpdateIssuedAllowance: TFloatField;
    tblTicketBulkUpdateSMVs: TFloatField;
    pcTicketsAndErrors: TPageControl;
    tsTickets: TTabSheet;
    tsWarnings: TTabSheet;
    pnlLeft: TPanel;
    lblCutWeek: TLabel;
    lblCutter: TLabel;
    lblCutterLocation: TLabel;
    lblMaterialSupplier: TLabel;
    lblMatPrice: TLabel;
    lblMaterialUsed: TLabel;
    lblSms: TLabel;
    lblIssuedAllowance: TLabel;
    dbeCutWeek: TDBEdit;
    dbeCutter: TDBEdit;
    dbeCutterLocation: TDBEdit;
    dbeMatSupplier: TDBEdit;
    dbeMatPrice: TDBEdit;
    dbeMatUsed: TDBEdit;
    dbeSms: TDBEdit;
    dbeIssuedAllowanced: TDBEdit;
    cbUseDefault: TCheckBox;
    cbUseExisting: TCheckBox;
    cbUseTicketSms: TCheckBox;
    dbgTktBlkUpdate: TDBGridPlus;
    dbgTicketUpdateAudit: TDBGridPlus;
    tblTicketBulkUpdateBulkUpdate: TBooleanField;
    tblTicketUpdateAuditSeq: TIntegerField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpdateTickets;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbUseDefaultClick(Sender: TObject);
    procedure cbUseExistingClick(Sender: TObject);
    procedure cbUseTicketSmsClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure ReadTicketUpdateFile;
    procedure tblTicketUpdateAuditCalcFields(DataSet: TDataSet);
    procedure btnUpdateTicketsClick(Sender: TObject);
    procedure tblTicketUpdateAuditBeforeOpen(DataSet: TDataSet);
    procedure tblTicketUpdateBeforeOpen(DataSet: TDataSet);
    procedure tblTicketBulkUpdateBeforeOpen(DataSet: TDataSet);
    procedure tblTicketUpdateAfterInsert(DataSet: TDataSet);
    procedure tblTicketBulkUpdateAfterInsert(DataSet: TDataSet);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure Pass;
    procedure pcTicketsAndErrorsChange(Sender: TObject);
    procedure pcTicketsAndErrorsDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure dlgOpenTicketFileShow(Sender: TObject);
  private
    { Private declarations }
    dmTicketUpdateCommon: TdmTicketsAll;
  public
    { Public declarations }
  end;

var
  fmTicketBulkUpdate: TfmTicketBulkUpdate;

implementation

uses
  SysUtils, FileCtrl, Graphics, Summs, OutOfMemory, General, SummsVars, CmnVars,
  TktBlkUpErrors, AdvErrorHandler;

{$R *.DFM}

procedure TfmTicketBulkUpdate.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;

begin
  if tblTicketBulkUpdate.recordcount <> 0 then
    if MessageDlgPos('Close Without Updating these Tickets?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrNo then
      abort;

  tblTicketUpdate.cancel;
  tblTicketBulkUpdate.cancel;
  dmTicketUpdateCommon.qClearBothTables.ExecSQL;
  FreeAndNil(dmTicketUpdateCommon);

  action := caFree;
end;

procedure TfmTicketBulkUpdate.UpdateTickets;
var
  fmTicketBulkUpdateErrors: TfmTicketBulkUpdateErrors;
  SQLError, AnyError, ChangedConnection: boolean;
  s, ErrorMessage: string;

begin
  AnyError := FALSE;
  SQLError := FALSE;

  LocalConnectionSumms.StartTransaction;

  screen.cursor := crHourGlass;
  try
    dmTicketUpdateCommon.qUpdateTickets.ExecSQL;
  except
    on E: Exception do
    begin
      ErrorMessage := E.Message;
      SQLError := TRUE;
    end;
  end;
  screen.cursor := crDefault;

  if SQLError then
    AnyError := TRUE
  else
  begin
    s := tblTicketUpdateAudit.filter;
    tblTicketUpdateAudit.filter := '(' + s + ') AND ' + '(Errorlevel = 1)';
    tblTicketUpdateAudit.refresh;
    if tblTicketUpdateAudit.recordcount > 0 then
      AnyError := TRUE;
    tblTicketUpdateAudit.filter := s;

    if AnyError then
    begin
      //View Errors Before essential Rollback
      try
        fmTicketBulkUpdateErrors := TfmTicketBulkUpdateErrors.create(self);
        fmTicketBulkUpdateErrors.showModal;
        fmTicketBulkUpdateErrors.Destroy;
      except
        fmMemoryError.TidyUp(self);
      end;
    end;
  end;

  if AnyError then
  begin
    LocalConnectionSumms.Rollback;
    fmErrorHandler.DebugMessageDlg('Update could not be Completed.', ErrorMessage, dmTicketUpdateCommon.qUpdateTickets.Text);
  end
  else if not AnyError then
  begin
    LocalConnectionSumms.Commit;

    //They may have been just Warnings
    //which WILL have been committed.
    s := 'Update Complete';
    tblTicketUpdateAudit.refresh;
    if tblTicketUpdateAudit.recordcount > 0 then
      s := s + ' - There are Warnings';
    fmErrorHandler.DebugMessageDlg(s, 'No additional information.', '');
  end;

  tblTicketBulkUpdate.refresh;
  tblTicketUpdateAudit.refresh;
end;

procedure TfmTicketBulkUpdate.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  if not Option_CuttingTimes then
  begin
    lblSms.enabled := false;
    dbeSms.enabled := false;
    cbUseTicketSms.enabled := false;
  end;
end;

procedure TfmTicketBulkUpdate.FormActivate(Sender: TObject);
begin
  if pcTicketsAndErrors.ActivePage = tsTickets then
    dbeCutWeek.SetFocus;
end;

procedure TfmTicketBulkUpdate.pcTicketsAndErrorsChange(Sender: TObject);
begin
  if pcTicketsAndErrors.ActivePage = tsTickets then
    dbeCutWeek.SetFocus;
end;

procedure TfmTicketBulkUpdate.cbUseDefaultClick(Sender: TObject);
begin
  dbeIssuedAllowanced.enabled := (cbUseDefault.State = cbUnchecked);
end;

procedure TfmTicketBulkUpdate.cbUseExistingClick(Sender: TObject);
begin
  dbeMatPrice.enabled := (cbUseExisting.State = cbUnchecked);
end;

procedure TfmTicketBulkUpdate.cbUseTicketSmsClick(Sender: TObject);
begin
  dbeSms.enabled := (cbUseTicketSms.State = cbUnchecked);
end;

procedure TfmTicketBulkUpdate.dlgOpenTicketFileShow(Sender: TObject);
var
  dlgRect: TRect;

begin
  //Believed to work the first time but windows overrides the location after this
  //  to the last location of the OpenDialog.
  with dlgOpenTicketFile do
  begin
    GetWindowRect(GetParent(handle), dlgRect);
    SetWindowPos(GetParent(handle), 0, Application.MainForm.Left + (Application.MainForm.Width div 3), Application.MainForm.Top + (Application.MainForm.Height div 3), 0, 0, SWP_NOSIZE);
    Abort;
  end;
end;

procedure TfmTicketBulkUpdate.btnLoadClick(Sender: TObject);
begin
  if DirectoryExists(TicketsDirectory) then
    dlgOpenTicketFile.InitialDir := TicketsDirectory
  else
  begin
    MessageDlgPos('Parameters | Tickets directory does not exist', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    dlgOpenTicketFile.InitialDir := ExtractFileDrive(ExpandFileName(Application.EXEName));
  end;

  dlgOpenTicketFile.FileName := '';
  if dlgOpenTicketFile.Execute then
    ReadTicketUpdateFile;

  tblTicketUpdate.refresh;
  tblTicketBulkUpdate.refresh;
end;

procedure TfmTicketBulkUpdate.ReadTicketUpdateFile;
var
  ReadErrors, SQLError: boolean;
  TicketFile: TextFile;
  SQLString, TicketInfo, s: string;
  WeekNo, SequenceNo, TicketNo, CutWeek, Cutter, CutterLocation: string;
  MatSupplier, MatPrice, ActualUsage: string;
  IssuedAllowance, SMVs: string;
  LineNo: integer;

begin
  ReadErrors := FALSE;
  LineNo := 0;

  dlgOpenTicketFile.FileName;

  if FileExists(dlgOpenTicketFile.FileName) then
  begin
    SQLString := 'DELETE FROM TicketUpdate ' +
                 'WHERE Identifier = ''' + Identifier + ''';';

    assignfile(TicketFile, dlgOpenTicketFile.FileName);
    reset(TicketFile);
    try
      inc(LineNo);
      readln(TicketFile, TicketInfo);

      CutWeek := copy(TicketInfo, 1, 2);
      Cutter := '''' + QS(copy(TicketInfo, 4, 20)) + '''';
      CutterLocation := '''' + QS(copy(TicketInfo, 25, 20)) + '''';
      MatSupplier := '''' + QS(copy(TicketInfo, 46, 20)) + '''';
      MatPrice := copy(TicketInfo, 67, 8);
      ActualUsage := copy(TicketInfo, 84, 10);
      IssuedAllowance := copy(TicketInfo, 95, 10);
      SMVs := copy(TicketInfo, 106, 10);

      SQLString := SQLString + #13 + 'INSERT INTO TicketUpdate ' +
                   '(Identifier, BulkUpdate, CutWeek, Cutter, CutterLocation, ' +
                   ' MatSupplier, MatPrice, ActualUsage, ' +
                   ' IssuedAllowance, SMVs) ' +
                   'VALUES (''' + Identifier + ''', TRUE, ' + CutWeek + ', ' + Cutter + ', ' + CutterLocation + ', ' +
                            MatSupplier + ', ' + MatPrice + ', ' + ActualUsage + ', ' +
                            IssuedAllowance + ', ' + SMVs + ');';

      while not eof(TicketFile) do
      begin
        inc(LineNo);
        readln(TicketFile, TicketInfo);

        WeekNo := copy(TicketInfo, 1, 2);
        SequenceNo := copy(TicketInfo, 4, 5);
        TicketNo := copy(TicketInfo, 10, 4);

        SQLString := SQLString + #13 + 'INSERT INTO TicketUpdate ' +
                     '(Identifier, WeekNo, SequenceNo, TicketNo) ' +
                     'VALUES (''' + Identifier + ''', ' + WeekNo + ', ' + SequenceNo + ', ' + TicketNo + ');';
      end;
      qReadTicketFile.SQL.Text := SQLString;
    except
      on E: Exception do
      begin
        fmErrorHandler.DebugMessageDlg('Error Reading Ticket File - Line ' + s, E.Message, qReadTicketFile.Text);
        ReadErrors := TRUE;
        str(LineNo, s);
      end;
    end;

    closeFile(TicketFile);
  end
  else
  begin
    ReadErrors := TRUE;
    MessageDlgPos('Illegal File name', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end;

  SQLError := FALSE;
  LocalConnectionSumms.StartTransaction;
  if not ReadErrors then
    try
      qReadTicketFile.ExecSQL
    except on E:EDatabaseError do
      begin
        fmErrorHandler.DebugMessageDlg('Error Reading Ticket File', E.Message, qReadTicketFile.Text);
        SQLError := TRUE;
      end
      else
      begin
        SQLError := TRUE;

        raise;
      end;
    end;

  if SQLError then
    LocalConnectionSumms.Rollback
  else
    LocalConnectionSumms.Commit;
end;

procedure TfmTicketBulkUpdate.tblTicketUpdateAuditCalcFields(
  DataSet: TDataSet);
begin
  if tblTicketUpdateAuditErrorLevel.value = 1 then
    tblTicketUpdateAuditActualErrorLevel.value := 'Error'
  else if tblTicketUpdateAuditErrorLevel.value = 2 then
    tblTicketUpdateAuditActualErrorLevel.value := 'Warning'
  else
    tblTicketUpdateAuditActualErrorLevel.value := '? ? ?';
end;

procedure TfmTicketBulkUpdate.btnUpdateTicketsClick(Sender: TObject);
var
  TotalAllowance, TotalSms: real;
  sTotalSms: string;
  DoBulkUpdate, SameMaterial: boolean;
  Material: string;
  SavePlace: TBookmark;
  sTotalAllowance, SQLString: string;

begin
  //CJY Issue with posting data aware dbEdit stlye components not committing a
  //  change to the database when clicking a menu button (that does not focus).
  //  Focus is sent to a non-data aware component to force the commit.
  pcTicketsAndErrors.SetFocus;

  //Ensure current record can be posted
  if tblTicketUpdate.state in [dsEdit, dsInsert] then
    tblTicketUpdate.post;
  if tblTicketBulkUpdate.state in [dsEdit, dsInsert] then
    tblTicketBulkUpdate.post;

  DoBulkUpdate := True;
  if tblTicketBulkUpdate.recordcount = 0 then
  begin
    DoBulkUpdate := False;
    MessageDlgPos('No Tickets to Update', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end
  else
  begin
  //Note:  if statements are written with 2 ifs to prevent unnecessary accessing of tables.
    if not cbUseExisting.Checked then
    begin
//      tblTicketBulkUpdate.Filter := 'BulkUpdate = True';
      tblTicketBulkUpdate.Filter := '(Identifier = ''' + Identifier + ''') AND (BulkUpdate = True)';
      if tblTicketBulkUpdateMatPrice.IsNull then
      begin
        DoBulkUpdate := False;
        MessageDlgPos('Material Price required', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      end;
//      tblTicketBulkUpdate.Filter := 'BulkUpdate = False';
      tblTicketBulkUpdate.Filter := '(Identifier = ''' + Identifier + ''') AND (BulkUpdate = False)';
    end;

    if not cbUseDefault.Checked and DoBulkUpdate then
    begin
//      tblTicketBulkUpdate.Filter := 'BulkUpdate = True';
      tblTicketBulkUpdate.Filter := '(Identifier = ''' + Identifier + ''') AND (BulkUpdate = True)';
      if tblTicketBulkUpdateIssuedAllowance.IsNull then
      begin
        DoBulkUpdate := False;
        MessageDlgPos('Issued Allowance required', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      end;
//      tblTicketBulkUpdate.Filter := 'BulkUpdate = False';
      tblTicketBulkUpdate.Filter := '(Identifier = ''' + Identifier + ''') AND (BulkUpdate = False)';
    end;

    if not cbUseTicketSms.Checked and DoBulkUpdate then
    begin
//      tblTicketBulkUpdate.Filter := 'BulkUpdate = True';
      tblTicketBulkUpdate.Filter := '(Identifier = ''' + Identifier + ''') AND (BulkUpdate = True)';
      if tblTicketBulkUpdateSMVs.IsNull then
      begin
        DoBulkUpdate := False;
        MessageDlgPos('Sms required', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      end;
//      tblTicketBulkUpdate.Filter := 'BulkUpdate = False';
      tblTicketBulkUpdate.Filter := '(Identifier = ''' + Identifier + ''') AND (BulkUpdate = False)';
    end;
  end;

  if DoBulkUpdate then
  begin
    tblTicketBulkUpdate.DisableControls;
    SavePlace := tblTicketBulkUpdate.GetBookmark;

    tblTicketBulkUpdate.first;
    Material := tblTicketBulkUpdateMaterial.value;
    SameMaterial := True;
    if Material = '' then
      SameMaterial := False;
    tblTicketBulkUpdate.next;
    while (not tblTicketBulkUpdate.eof) and SameMaterial do
    begin
      if tblTicketBulkUpdateMaterial.value <> Material then
        SameMaterial := False;
      tblTicketBulkUpdate.next;
    end;

    try
      tblTicketBulkUpdate.GotoBookmark(SavePlace);
    except
    end;
    tblTicketBulkUpdate.FreeBookmark(SavePlace);
    tblTicketBulkUpdate.EnableControls;

    if not SameMaterial then
      MessageDlgPos('No common Material on selected Tickets', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
    begin
      TotalAllowance := 0;
      TotalSms := 0;
      if not cbUseDefault.checked then
        TotalAllowance := tblTicketUpdateIssuedAllowance.value;
      if not cbUseTicketSms.checked then
        TotalSms := tblTicketUpdateSMVs.value;

      if cbUseDefault.checked or cbUseTicketSms.checked then
      begin
        qTotals.open;
        if cbUseDefault.checked then
        begin
          if not qTotals.FieldByName('aNum').IsNull then
            TotalAllowance := qTotals.FieldByName('aNum').value;
        end;
        qTotals.next;
        if cbUseTicketSms.checked then
        begin
          if not qTotals.FieldByName('aNum').IsNull then
            TotalSms := qTotals.FieldByName('aNum').value;
        end;
        qTotals.close;
      end;

      str(TotalAllowance, sTotalAllowance);

      SQLString :=
        'UPDATE TU ' +
        'SET CutWeek = TU_BULK.CutWeek, ' +
        '    Cutter = TU_BULK.Cutter, ' +
        '    CutterLocation = TU_BULK.CutterLocation, ' +
        '    MatSupplier = TU_BULK.MatSupplier, ';
      if not cbUseExisting.checked then
        SQLString := SQLString + '    MatPrice = TU_BULK.MatPrice, ';

{ ActualUsage is the ONLY thing affected by the input of IssuedAllowance.  If an IssuedAllowance is entered it is used
  to work out a ratio for the apportioning of the ActualUsage.  In this way the ActualUsage is adjusted in line with
  the entered IssuedAllowance such that the savings or losses are distributed correctly and therefore the overall analysis
  totals for this set of bulked tickets shows the correct total saving or loss.

  Issued Allowance does NOT change ever.  Therefore the Material Usage may not add up to the figure you enter because
  it is the Material Allowance which is adjusted to reflect the saving or losses when Analysed.

  In Summs4 the Issued Allowance and SMVs could be changed by altering the Quality and Area of the Material on the Ticket.
  We have deemed this to be wrong and have not provided any means of altering Issued Allowance and SMVs in this version.}

      SQLString := SQLString + '     ActualUsage = (TT.IssuedAllowance / ' + sTotalAllowance + ') * TU_BULK.ActualUsage ' +
                               'FROM TicketUpdate TU, TicketUpdate TU_BULK, TicketTickets TT ' +
                               'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
                               '      TU.BulkUpdate = FALSE AND ' +
                               '      TU_BULK.Identifier = ''' + Identifier + ''' AND ' +
                               '      TU_BULK.Bulkupdate = TRUE AND ' +
                               '      TT.WeekNo = TU.WeekNo AND ' +
                               '      TT.SequenceNo = TU.SequenceNo AND ' +
                               '      TT.TicketNo = TU.TicketNo;';

      if not cbUseTicketSms.checked then
      begin
        str(TotalSms : 10 : 4, sTotalSms);
        SQLString := SQLString + #13 + 'UPDATE TU ' +
                                       'SET SMVs = TTT.Time / ' + sTotalSms + ' * TU_BULK.SMVs ' +
                                       'FROM TicketUpdate TU, TicketUpdate TU_BULK, TicketTickets TT, TicketTicketsTimes TTT ' +
                                       'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
                                       '      TU.BulkUpdate = FALSE AND ' +
                                       '      TU_BULK.Identifier = ''' + Identifier + ''' AND ' +
                                       '      TU_BULK.Bulkupdate = TRUE AND ' +
                                       '      TT.WeekNo = TU.WeekNo AND ' +
                                       '      TT.SequenceNo = TU.SequenceNo AND ' +
                                       '      TT.TicketNo = TU.TicketNo AND ' +
                                       '      TTT .WeekNo = TU.WeekNo AND ' +
                                       '      TTT.SequenceNo = TU.SequenceNo AND ' +
                                       '      TTT.TicketNo = TU.TicketNo AND ' +
                                       '      TTT.Quality = TT.MaterialQualCoeff;';
      end;

//      qUpdateTicketsPreUpdate.paramByName('TotalAllowance').value := TotalAllowance;
      try
        screen.cursor := crHourGlass;
        qUpdateTicketsPreUpdate.SQL.Text := SQLString;
        qUpdateTicketsPreUpdate.ExecSQL;
      finally
        screen.cursor := crDefault;
      end;

      UpdateTickets;
    end;
  end;
end;

procedure TfmTicketBulkUpdate.tblTicketUpdateAuditBeforeOpen(
  DataSet: TDataSet);
begin
  tblTicketUpdateAudit.Filter := 'Identifier = ''' + Identifier + '''';
end;

procedure TfmTicketBulkUpdate.tblTicketUpdateBeforeOpen(DataSet: TDataSet);
begin
  tblTicketUpdate.Filter := '(Identifier = ''' + Identifier + ''') AND (BulkUpdate = True)';
end;

procedure TfmTicketBulkUpdate.tblTicketBulkUpdateBeforeOpen(
  DataSet: TDataSet);
begin
  tblTicketBulkUpdate.Filter := '(Identifier = ''' + Identifier + ''') AND (BulkUpdate = False)';
end;

procedure TfmTicketBulkUpdate.tblTicketUpdateAfterInsert(
  DataSet: TDataSet);
begin
  tblTicketUpdateIdentifier.value := Identifier;
end;

procedure TfmTicketBulkUpdate.tblTicketBulkUpdateAfterInsert(
  DataSet: TDataSet);
begin
  tblTicketBulkUpdateIdentifier.value := Identifier;
end;

procedure TfmTicketBulkUpdate.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmTicketBulkUpdate.Pass;
var
  s: string;

begin
  try
    if not LocalConnectionSumms.Connected then
      LocalConnectionSumms.Connected := true;

    dmTicketUpdateCommon := TdmTicketsAll.create(self);

    dmTicketUpdateCommon.ChangeAllConnections(LocalConnectionSumms);
    dmTicketUpdateCommon.TicketUpdateCommonCreate;
  except
    fmMemoryError.TidyUp(self);
    close;
  end;

  tblTicketUpdate.open;
  tblTicketBulkUpdate.open;
  tblTicketUpdateAudit.open;

  //Create one Bulk updating record
  tblTicketUpdate.insert;
  tblTicketUpdateBulkUpdate.value := true;
  tblTicketUpdate.post;

  btnLoad.enabled := Option_TicketUpdating;

  //------------------
  // FORMULATE qTotals
  //------------------
  s :=
//  'SELECT 1 as Code, ''Allowance'', SUM(TT.IssuedAllowance) as aNum ' +
  'SELECT 1 as Code, SUM(TT.IssuedAllowance) as aNum ' +
  'FROM TicketUpdate TU, TicketTickets TT ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo ';

  s := s + #13 +
  'UNION ';

  s := s + #13 +
//  'SELECT 2 as Code, ''Time'', SUM(TTT.Time) as aNum ' +
  'SELECT 2 as Code, SUM(TTT.Time) as aNum ' +
  'FROM TicketUpdate TU, TicketTickets TT, TicketTicketsTimes TTT ' +
  'WHERE TU.Identifier = ''' + Identifier + ''' AND ' +
  '      TU.BulkUpdate = FALSE AND ' +
  '      TT.WeekNo = TU.WeekNo AND ' +
  '      TT.SequenceNo = TU.SequenceNo AND ' +
  '      TT.TicketNo = TU.TicketNo AND ' +
  '      TTT .WeekNo = TU.WeekNo AND ' +
  '      TTT.SequenceNo = TU.SequenceNo AND ' +
  '      TTT.TicketNo = TU.TicketNo AND ' +
  '      TTT.Quality = TT.MaterialQualCoeff ';

  qTotals.SQL.Text := s;
end;

procedure TfmTicketBulkUpdate.pcTicketsAndErrorsDrawTab(
  Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

end.

