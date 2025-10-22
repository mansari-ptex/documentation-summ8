unit TktUpdate;

interface

uses
  Windows, Classes, Controls, Forms, Dialogs, Grids, Db, cmnTypes,
   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, ComCtrls, Tabnotbk,  Buttons, ExtCtrls, ToolWin,
  TicketUpdateCommon, TicketsAllDM, StdCtrls, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, Vcl.DBGrids, DBGridPlus, TicketsBreakdown, FDConnectionPlus;

type
  TfmTicketUpdate = class(TForm)
    dsTicketUpdate: TDataSource;
    dlgOpenTicketFile: TOpenDialog;
    tbMain: TPanel;
    btnLoad: TSpeedButton;
    btnUpdateTickets: TSpeedButton;
    LocalConnectionSumms: TFDConnectionPlus;
    tblTicketUpdateAudit: TFDTablePlus;
    dsTicketUpdateAudit: TDataSource;
    qReadTicketFile: TFDQueryPlus;
    tblTicketUpdateAuditWeekNo: TIntegerField;
    tblTicketUpdateAuditSequenceNo: TIntegerField;
    tblTicketUpdateAuditTicketNo: TIntegerField;
    tblTicketUpdateAuditErrorLevel: TSmallintField;
    tblTicketUpdateAuditMessage: TStringField;
    tblTicketUpdateAuditActualErrorLevel: TStringField;
    tblTicketUpdateAuditIdentifier: TStringField;
    tblTicketUpdate: TFDTablePlus;
    tblTicketUpdateIdentifier: TStringField;
    tblTicketUpdateBulkUpdate: TBooleanField;
    tblTicketUpdateWeekNo: TIntegerField;
    tblTicketUpdateSequenceNo: TIntegerField;
    tblTicketUpdateTicketNo: TIntegerField;
    tblTicketUpdateCutWeek: TSmallintField;
    tblTicketUpdateCutter: TStringField;
    tblTicketUpdateCutterLocation: TStringField;
    tblTicketUpdateMatSupplier: TStringField;
    tblTicketUpdateMatPrice: TCurrencyField;
    tblTicketUpdateQuality: TSmallintField;
    tblTicketUpdateArea: TSmallintField;
    tblTicketUpdateActualUsage: TFloatField;
    tblTicketUpdateIssuedAllowance: TFloatField;
    tblTicketUpdateSMVs: TFloatField;
    tblTicketUpdateAutoCutterLocation: TStringField;
    tblTicketUpdateAutoMatPrice: TCurrencyField;
    tblTicketUpdateAutoIssuedAllowance: TFloatField;
    tblTicketUpdateAutoSMVs: TFloatField;
    tblTicketUpdatePreviousActualUsage: TFloatField;
    pcTicketsUpdate: TPageControl;
    tsTickets: TTabSheet;
    tsWarningsErrors: TTabSheet;
    dbgTktUpdate: TDBGridPlus;
    dbgTicketUpdateAudit: TDBGridPlus;
    tblTicketUpdateAuditSeq: TIntegerField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure tblTicketUpdateBeforeScroll(DataSet: TDataSet);
    procedure tblTicketUpdateNewRecord(DataSet: TDataSet);
    procedure ReadTicketUpdateFile;
    procedure btnUpdateClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure tblTicketUpdateAuditCalcFields(DataSet: TDataSet);
    procedure tnbTicketsAndErrorsChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure tblTicketUpdateBeforeDelete(DataSet: TDataSet);
    procedure tblTicketUpdateBeforeInsert(DataSet: TDataSet);
    procedure tblTicketUpdateAfterInsert(DataSet: TDataSet);
    procedure tblTicketUpdateBeforeOpen(DataSet: TDataSet);
    procedure tblTicketUpdateAuditBeforeOpen(DataSet: TDataSet);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure Pass;
    procedure dbgTktUpdateKeyPress(Sender: TObject; var Key: Char);
    procedure pcTicketsUpdateDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure tblTicketUpdateAfterPost(DataSet: TDataSet);
    procedure dlgOpenTicketFileShow(Sender: TObject);
  private
    { Private declarations }
    ComponentNest: Array of TComponentConnection;

    dmTicketUpdateCommon: TdmTicketsAll;
    CurrentCutWeek: short;
    CurrentCutter: string;
  public
    { Public declarations }
    function ChangeAllConnections(Connection: TFDCustomConnection): Boolean;
    procedure RevertAllConnections();
  end;

var
  fmTicketUpdate: TfmTicketUpdate;

implementation

uses
  SysUtils, FileCtrl, Summs, OutOfMemory, General, CmnVars, SummsVars,
  AdvErrorHandler;

{$R *.DFM}

procedure TfmTicketUpdate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if tblTicketUpdate.active then
  begin
    if tblTicketUpdate.recordcount <> 0 then
      if MessageDlgPos('Close Without Updating these Tickets?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrNo then
        abort;

    tblTicketUpdate.Cancel;
    dmTicketUpdateCommon.qClearBothTables.ExecSQL;
  end;

  qReadTicketFile.Connection.Commit;
  FreeAndNil(dmTicketUpdateCommon);

  action := caFree;
end;

procedure TfmTicketUpdate.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  
  CurrentCutWeek := 0;
  CurrentCutter := '';

  if not Option_CuttingTimes then
    dbgTktUpdate.Columns[12].visible := false;

  if fmSumms.mmTicketsUpdateQualityArea.Checked then
  begin
    dbgTktUpdate.Columns[11].visible := false;
    dbgTktUpdate.Columns[12].visible := false;
  end
  else if fmSumms.mmTicketsUpdateIssuedAllowanceSms.Checked then
  begin
    dbgTktUpdate.Columns[8].visible := false;
    dbgTktUpdate.Columns[9].visible := false;
  end;

  dbgTktUpdate.Columns[3].visible := fmSumms.mmTicketsUpdateCutWeek.Checked;
  dbgTktUpdate.Columns[4].visible := fmSumms.mmTicketsUpdateCutter.Checked;
  dbgTktUpdate.Columns[5].visible := fmSumms.mmTicketsUpdateCutterLocation.Checked;
  dbgTktUpdate.Columns[6].visible := fmSumms.mmTicketsUpdateMaterialSupplier.Checked;
  dbgTktUpdate.Columns[7].visible := fmSumms.mmTicketsUpdateMaterialPrice.Checked;
  dbgTktUpdate.Columns[10].visible := fmSumms.mmTicketsUpdateMaterialUsed.Checked;

  btnLoad.enabled := Option_TicketUpdating;
end;

procedure TfmTicketUpdate.tblTicketUpdateBeforeScroll(DataSet: TDataSet);
begin
  if not tblTicketUpdateCutWeek.isnull then
    CurrentCutWeek := tblTicketUpdateCutWeek.value;
  if not tblTicketUpdateCutter.isnull then
    CurrentCutter := tblTicketUpdateCutter.value;
end;

procedure TfmTicketUpdate.tblTicketUpdateNewRecord(DataSet: TDataSet);
begin
  if (tblTicketUpdateCutWeek.isnull and (CurrentCutWeek > 0)) then
    tblTicketUpdateCutWeek.value := CurrentCutWeek;
  if (tblTicketUpdateCutter.isnull and (CurrentCutter <> '')) then
    tblTicketUpdateCutter.value := CurrentCutter;
end;

procedure TfmTicketUpdate.ReadTicketUpdateFile;
var
  ReadErrors, SQLError: boolean;
  TicketFile: TextFile;
  SQLString, TicketInfo, s: string;
  WeekNo, SequenceNo, TicketNo, CutWeek, Cutter, CutterLocation: string;
  MatSupplier, MatPrice, Quality, Area, ActualUsage: string;
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
      while not eof(TicketFile) do
      begin
        inc(LineNo);
        readln(TicketFile, TicketInfo);

        WeekNo := copy(TicketInfo, 1, 2);
        WeekNo := TrimRight(WeekNo);
        SequenceNo := copy(TicketInfo, 4, 5);
        SequenceNo := TrimRight(SequenceNo);
        TicketNo := copy(TicketInfo, 10, 4);
        TicketNo := TrimRight(TicketNo);
        CutWeek := copy(TicketInfo, 15, 2);
        CutWeek := TrimRight(CutWeek);
        Cutter := QS(copy(TicketInfo, 18, 20));
        Cutter := TrimRight(Cutter);
        CutterLocation := QS(copy(TicketInfo, 39, 20));
        CutterLocation := TrimRight(CutterLocation);
        MatPrice := copy(TicketInfo, 81, 8);
        MatPrice := TrimRight(MatPrice);
        MatSupplier := QS(copy(TicketInfo, 60, 20));
        MatSupplier := TrimRight(MatSupplier);
        Quality := copy(TicketInfo, 90, 3);
        Quality := TrimRight(Quality);
        Area := copy(TicketInfo, 94, 3);
        Area := TrimRight(Area);
        ActualUsage := copy(TicketInfo, 98, 10);
        ActualUsage := TrimRight(ActualUsage);
        IssuedAllowance := copy(TicketInfo, 109, 10);
        IssuedAllowance := TrimRight(IssuedAllowance);
        SMVs := copy(TicketInfo, 120, 10);
        SMVs := TrimRight(SMVs);

        SQLString := SQLString + #13 + 'INSERT INTO TicketUpdate (Identifier';
        if WeekNo <> '' then
          SQLString := SQLString + ', WeekNo';
        if SequenceNo <> '' then
          SQLString := SQLString + ', SequenceNo';
        if TicketNo <> '' then
          SQLString := SQLString + ', TicketNo';
        if CutWeek <> '' then
          SQLString := SQLString + ', CutWeek';
        if Cutter <> '' then
          SQLString := SQLString + ', Cutter';
        if CutterLocation <> '' then
          SQLString := SQLString + ', CutterLocation';
        if MatSupplier <> '' then
          SQLString := SQLString + ', MatSupplier';
        if MatPrice <> '' then
          SQLString := SQLString + ', MatPrice';
        if Quality <> '' then
          SQLString := SQLString + ', Quality';
        if Area <> '' then
          SQLString := SQLString + ', Area';
        if ActualUsage  <> '' then
          SQLString := SQLString + ', ActualUsage ';
        if IssuedAllowance <> '' then
          SQLString := SQLString + ', IssuedAllowance';
        if SMVs <> '' then
          SQLString := SQLString + ', SMVs';
        SQLString := SQLString + ') VALUES (''' + Identifier + '''';
        if WeekNo <> '' then
          SQLString := SQLString + ', ' + WeekNo;
        if SequenceNo <> '' then
          SQLString := SQLString + ', ' + SequenceNo;
        if TicketNo <> '' then
          SQLString := SQLString + ', ' + TicketNo;
        if CutWeek <> '' then
          SQLString := SQLString + ', ' + CutWeek;
        if Cutter <> '' then
          SQLString := SQLString + ', ''' + Cutter + '''';
        if CutterLocation <> '' then
          SQLString := SQLString + ', ''' + CutterLocation + '''';
        if MatSupplier <> '' then
          SQLString := SQLString + ', ''' + MatSupplier + '''';
        if MatPrice <> '' then
          SQLString := SQLString + ', ' + MatPrice;
        if Quality <> '' then
          SQLString := SQLString + ', ' + Quality;
        if Area <> '' then
          SQLString := SQLString + ', ' + Area;
        if ActualUsage <> '' then
          SQLString := SQLString + ', ' + ActualUsage;
        if IssuedAllowance <> '' then
          SQLString := SQLString + ', ' + IssuedAllowance;
        if SMVs <> '' then
          SQLString := SQLString + ', ' + SMVs;
        SQLString := SQLString + ');';
      end;
      qReadTicketFile.SQL.Text := SQLString;
    except
      on E: Exception do
      begin
        ReadErrors := TRUE;
        str(LineNo, s);
        fmErrorHandler.DebugMessageDlg('Error Reading Ticket File - Line ' + s, E.Message, SQLString);
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
  qReadTicketFile.Connection.StartTransaction;
  if not ReadErrors then
    try
      qReadTicketFile.ExecSQL
    except on E:EDatabaseError do
      begin
        fmErrorHandler.DebugMessageDlg('Error Reading Ticket File', E.Message, qReadTicketFile.Text);
        SQLError := TRUE;
      end;
    end;

  if SQLError then
    qReadTicketFile.Connection.Rollback
  else
    qReadTicketFile.Connection.Commit;
end;

procedure TfmTicketUpdate.btnUpdateClick(Sender: TObject);
var
  SQLError: boolean;
  s: string;

begin
  //Ensure current record can be posted
  if tblTicketUpdate.state in [dsEdit, dsInsert] then
    tblTicketUpdate.post;

  if tblTicketUpdate.recordcount = 0 then
    MessageDlgPos('There are no tickets to update.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else
  begin
    screen.cursor := crHourGlass;

    SQLError := FALSE;

    //CJY This form can be used as a child of another form. Using a known reference
    //    to the correct connection;
    qReadTicketFile.Connection.StartTransaction;
    try
      dmTicketUpdateCommon.qUpdateTickets.ExecSQL;
    except
      on E: Exception do
      begin
        fmErrorHandler.DebugMessageDlg('Update could not be Completed.', E.Message, dmTicketUpdateCommon.qUpdateTickets.Text);
        SQLError := TRUE;
      end;
    end;

    if SQLError then
      qReadTicketFile.Connection.Rollback
    else
    begin
      qReadTicketFile.Connection.Commit;
      s := 'Update Complete';
      tblTicketUpdateAudit.refresh;
      if tblTicketUpdateAudit.recordcount > 0 then
        s := s + ' - There are Warnings/Errors';
      MessageDlgPos(s, mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    end;

    qReadTicketFile.Connection.Commit;
    qReadTicketFile.Connection.StartTransaction;

    tblTicketUpdate.refresh;
    tblTicketUpdateAudit.refresh;

    screen.cursor := crDefault;
  end;
end;

procedure TfmTicketUpdate.btnLoadClick(Sender: TObject);
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
end;

procedure TfmTicketUpdate.tblTicketUpdateAuditCalcFields(
  DataSet: TDataSet);
begin
  if tblTicketUpdateAuditErrorLevel.value = 1 then
    tblTicketUpdateAuditActualErrorLevel.value := 'Error'
  else if tblTicketUpdateAuditErrorLevel.value = 2 then
    tblTicketUpdateAuditActualErrorLevel.value := 'Warning'
  else
    tblTicketUpdateAuditActualErrorLevel.value := '? ? ?';
end;

procedure TfmTicketUpdate.tnbTicketsAndErrorsChange(Sender: TObject;
  NewTab: Integer; var AllowChange: Boolean);
begin
  if tblTicketUpdate.State in [dsBrowse] then
  begin
    AllowChange := True;
    btnLoad.enabled := (NewTab = 0);
    btnUpdateTickets.enabled := (NewTab = 0);
  end
  else
    AllowChange := False;
end;

procedure TfmTicketUpdate.tblTicketUpdateBeforeDelete(DataSet: TDataSet);
begin
  //Routine Not Used unless called from Ticket as SINGLE.
  abort;
end;

procedure TfmTicketUpdate.tblTicketUpdateBeforeInsert(DataSet: TDataSet);
begin
  //Routine Not Used unless called from Ticket as SINGLE.
  abort;
end;

procedure TfmTicketUpdate.tblTicketUpdateAfterInsert(DataSet: TDataSet);
begin
  tblTicketUpdateIdentifier.value := Identifier;
end;

procedure TfmTicketUpdate.tblTicketUpdateAfterPost(DataSet: TDataSet);
begin
  //Following removed 14/05/09 TAH
  //It caused odd behaviour and I can think of no reason whatsoever for it being
  //there. Left here in case reason becomes apparent later.
  {tblTicketUpdate.Last;
  TStringGrid(dbgTktUpdate).Col := 1;}
end;

procedure TfmTicketUpdate.tblTicketUpdateBeforeOpen(DataSet: TDataSet);
begin
  tblTicketUpdate.Filter := '(Identifier =''' + Identifier + ''') AND (BulkUpdate = False)';
end;

procedure TfmTicketUpdate.tblTicketUpdateAuditBeforeOpen(
  DataSet: TDataSet);
begin
  tblTicketUpdateAudit.Filter := 'Identifier = ''' + Identifier + '''';
end;

procedure TfmTicketUpdate.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmTicketUpdate.Pass;
begin
  try
    if not qReadTicketFile.Connection.Connected then
      qReadTicketFile.Connection.Connected := true;

    dmTicketUpdateCommon := TdmTicketsAll.create(self);
    dmTicketUpdateCommon.ChangeAllConnections(qReadTicketFile.Connection);
    qReadTicketFile.Connection.StartTransaction;

    dmTicketUpdateCommon.TicketUpdateCommonCreate;
  except
    fmMemoryError.TidyUp(self);
    close;
  end;

  tblTicketUpdate.open;
  tblTicketUpdateAudit.open;
end;

procedure TfmTicketUpdate.dbgTktUpdateKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (dbgTktUpdate.SelectedField.Fieldname = 'Cutter') or (dbgTktUpdate.SelectedField.Fieldname = 'CutterLocation') or (dbgTktUpdate.SelectedField.Fieldname = 'MatSupplier') then
    Key := upcase(Key);
end;

procedure TfmTicketUpdate.dlgOpenTicketFileShow(Sender: TObject);
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

procedure TfmTicketUpdate.pcTicketsUpdateDrawTab(
  Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

function TfmTicketUpdate.ChangeAllConnections(Connection: TFDCustomConnection): boolean;

  procedure AddConnection(cName: string; cConnection: TFDCustomConnection);
  var
    i, iMax: integer;
    NotFound: boolean;

  begin
    NotFound := true;

    i := 0;
    iMax := Length(ComponentNest);

    while (NotFound) and (i < iMax) do
    begin
      NotFound := not (ComponentNest[i].Name = cName);
      if NotFound then
        Inc(i);
    end;

    if NotFound then
    begin
      SetLength(ComponentNest, iMax + 1);
      i := iMax;
      ComponentNest[i].Name := cName;
    end;

    iMax := Length(ComponentNest[i].Connections);
    SetLength(ComponentNest[i].Connections, iMax + 1);
    ComponentNest[i].Connections[iMax] := cConnection;
  end;

var
  i: integer;

begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TFDQuery) or
       (Components[i] is TFDQueryPlus) then
    begin
      AddConnection(TFDQueryPlus(Components[i]).Name, TFDQueryPlus(Components[i]).Connection);
      TFDQuery(Components[i]).Connection := Connection;
    end
    else
    if (Components[i] is TFDTable) or
       (Components[i] is TFDTablePlus) then
    begin
      AddConnection(TFDTablePlus(Components[i]).Name, TFDTablePlus(Components[i]).Connection);
      TFDTable(Components[i]).Connection := Connection;
    end;
  end;

  Result := true;
end;

procedure TfmTicketUpdate.RevertAllConnections();

  function GetConnection(cName: string): TFDCustomConnection;
  var
    i, iMax: integer;
    NotFound: boolean;
    cConnection: TFDCustomConnection;

  begin
    cConnection := nil;
    NotFound := true;

    i := 0;
    iMax := Length(ComponentNest);

    while (NotFound) and (i < iMax) do
    begin
      NotFound := not (ComponentNest[i].Name = cName);
      if NotFound then
        Inc(i);
    end;

    if not NotFound then
    begin
      iMax := Length(ComponentNest[i].Connections) - 1;
      cConnection := ComponentNest[i].Connections[iMax];
      ComponentNest[i].Connections[iMax] := nil;
      SetLength(ComponentNest[i].Connections, iMax);
    end;

    Result := cConnection;
  end;

var
  i, iConn: integer;
  Connection: TFDCustomConnection;

begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TFDQuery) or
       (Components[i] is TFDQueryPlus) then
      TFDQuery(Components[i]).Connection := GetConnection(TFDQueryPlus(Components[i]).Name)
    else
    if (Components[i] is TFDTable) or
       (Components[i] is TFDTablePlus) then
      TFDTable(Components[i]).Connection := GetConnection(TFDQueryPlus(Components[i]).Name);
  end;
end;

end.


