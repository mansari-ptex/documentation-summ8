unit AllTickets;

interface

uses                                                                                                  
  Classes, Controls, Forms, Types, Dialogs, StdCtrls, Grids, DB,                         
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus,
  FDTablePlus, ExtCtrls, Buttons, ComCtrls, ToolWin, DBGridPlus, DBGrids,
  Gauges, XStringGrid, XStringGridPlus, frxClass, frxDBSet, PBNumEdit,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  frxReportPlus, FDConnectionPlus;

type
  TfmAllTickets = class(TForm)
    pnlMain: TPanel;
    dbgTicketSeqs: TDBGridPlus;
    pnlSearch: TPanel;
    lblDash: TLabel;
    rgPrinted: TRadioGroup;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    btnGroup: TSpeedButton;
    pnlPrintButtons: TPanel;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    pnlGroupButtons: TPanel;
    btnGroupPrint: TSpeedButton;
    btnGroupDelete: TSpeedButton;
    btnSelectAll: TSpeedButton;
    btnDeselectAll: TSpeedButton;
    btnCreate: TSpeedButton;
    btnPreviewMaterialSummary: TSpeedButton;
    btnPrintMaterialSummary: TSpeedButton;
    btnExternalOut: TSpeedButton;
    btnUpdatedOut: TSpeedButton;
    tblTicketSequences: TFDTablePlus;
    tblTicketSequencesWeekNo: TSmallintField;
    tblTicketSequencesSequenceNo: TSmallintField;
    tblTicketSequencesStyle: TStringField;
    tblTicketSequencesConstruction: TStringField;
    tblTicketSequencesTagNo: TStringField;
    tblTicketSequencesAllPrinted: TBooleanField;
    tblTicketSequencesCustomer: TStringField;
    tblTicketSequencesPicture: TBlobField;
    tblTicketSequencesLinesInLeatherGrid: TSmallintField;
    tblTicketSequencesRowsInLeatherGrid: TSmallintField;
    sdFileOut: TSaveDialog;
    qTicketSequences: TFDQueryPlus;
    qTicketSequencesWeekNo: TSmallintField;
    qTicketSequencesSequenceNo: TSmallintField;
    qTicketSequencesStyle: TStringField;
    qTicketSequencesConstruction: TStringField;
    dsTicketSeqs: TDataSource;
    qGroupDelete: TFDQueryPlus;
    qExternalOut: TFDQueryPlus;
    qExternalOutKnives: TFDQueryPlus;
    qExternalOutTimes: TFDQueryPlus;
    qCreated: TFDQueryPlus;
    dbgGroupTickets: TDBGridPlus;
    qTicketSequencesSelected: TBooleanField;
    pnlExpandedSearch: TPanel;
    lblDash1: TLabel;
    lblSlash1: TLabel;
    lblSlash2: TLabel;
    qUpdatedOut: TFDQueryPlus;
    qCountCreated: TFDQueryPlus;
    qCountCreatedTicketsCreated: TIntegerField;
    qCreatedCreated: TIntegerField;
    qCreatedWeekNo: TSmallintField;
    qCreatedSequenceNo: TSmallintField;
    btnSyntheticsTicketsList: TSpeedButton;
    sbMain: TStatusBar;
    btnClearTickets: TSpeedButton;
    qGroupClear: TFDQueryPlus;
    frAllTickets: TfrxReportPlus;
    frdbAllTickets: TfrxDBDataset;
    qTicketSequencesTagNo: TStringField;
    ineStartWeek: TPBNumEdit;
    ineEndWeek: TPBNumEdit;
    ineEndSeq: TPBNumEdit;
    ineSearchStart: TPBNumEdit;
    ineSearchEnd: TPBNumEdit;
    ineStartSeq: TPBNumEdit;
    btnSize: TButton;
    LocalConnectionSumms: TFDConnectionPlus;
    qTicketSequencesRecNo: TIntegerField;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGroupClick(Sender: TObject);
    procedure dbgTicketSeqsDblClick(Sender: TObject);
    procedure dbgTicketSeqsKeyPress(Sender: TObject; var Key: Char);
    procedure btnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DisableMyControls;
    procedure EnableMyControls;
    procedure btnRefreshClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnDeselectAllClick(Sender: TObject);
    procedure btnGroupDeleteClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnGroupPrintClick(Sender: TObject);
    procedure btnPrintMaterialSummaryClick(Sender: TObject);
    procedure ineSearchEndChange(Sender: TObject);
    procedure ineSearchStartChange(Sender: TObject);
    procedure btnExternalOutClick(Sender: TObject);
    procedure SaveExternalOut(FileName: string);
    procedure btnUpdatedOutClick(Sender: TObject);
    procedure SaveUpdatedOut(FileName: string);
    procedure ineSearchEndKeyPress(Sender: TObject; var Key: Char);
    procedure ineSearchStartKeyPress(Sender: TObject; var Key: Char);
    procedure tblTicketSequencesBeforeInsert(DataSet: TDataSet);
    procedure tblTicketSequencesBeforeDelete(DataSet: TDataSet);
    procedure FinishSecondProcess(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RunGroup;
    procedure FormShow(Sender: TObject);
    procedure FillArray(Flag: Boolean);
    procedure dbgGroupTicketsColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure qTicketSequencesCalcFields(DataSet: TDataSet);
    procedure dbgGroupTicketsCellClick(Column: TColumn);
    function WeekSeqString(TableAlias: String): string;
    procedure ineStartSeqChange(Sender: TObject);
    procedure ineEndSeqChange(Sender: TObject);
    function NumberSelected: integer;
    procedure btnSyntheticsTicketsListClick(Sender: TObject);
    function OpenSyntheticsTicketsList: Boolean;
    procedure btnClearTicketsClick(Sender: TObject);
    procedure frAllTicketsBeforePrint(Sender: TfrxReportComponent);
    procedure frAllTicketsGetValue(const VarName: string; var Value: Variant);
    procedure qTicketSequencesAfterOpen(DataSet: TDataSet);
    procedure qTicketSequencesBeforeOpen(DataSet: TDataSet);
    procedure btnSizeClick(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure qTicketSequencesAfterScroll(DataSet: TDataSet);
    procedure sdFileOutShow(Sender: TObject);
  private
    { Private declarations }
    BusyPrinting: boolean;
    RefreshWarn: boolean;
    ActiveSearchStart, ActiveSearchEnd, ActiveSeqStart, ActiveSeqEnd: Real;
    ColumnSelectedPosition, SelectedCount: integer;
    Errors, JustDown, MadeTicket: boolean;
    Selected: array of Boolean;

  public
    { Public declarations }
    SecondProcessInUse: Boolean;
  end;

var
  fmAllTickets: TfmAllTickets;

implementation

uses
  Windows, SysUtils, Graphics, General, SummsVars, CmnVars, CmnTypes, Summs,
  OutOfMemory, TicketsBreakdown, TicketsCreate, TicketsGeneral, TicketsAllDM, TicketsGroupError,
  FileCtrl, CancelPrinting, SummsThreads, fr_MaterialSummary,
  TicketsGroupCreate, SyntheticTicketsList, Dongle_Green, fr_Ticket;

{$R *.DFM}

procedure TfmAllTickets.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    try
      if btnGroup.Down then
      begin
        btnGroup.Down := False;
        btnGroup.Click;
      end;

      action := caFree;
    except
      action := caNone;
      Raise;
    end;
  end;
end;

procedure TfmAllTickets.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
  RefreshWarn := True;
  tblTicketSequences.Open;
end;

procedure TfmAllTickets.btnGroupClick(Sender: TObject);
var
  LockSuccess, btnGroupDownStatus: Boolean;
  HoldWindowState: TWindowState;

begin
  Screen.cursor := crHourGlass;

  JustDown := btnGroup.Down;

  LockWindowUpdate(Application.MainForm.Handle);
  HoldWindowState := WindowState;
  if WindowState = wsMaximized then
    WindowState := wsNormal;

  RefreshWarn := False;
  btnRefresh.Click;
  RefreshWarn := True;

  btnGroupDownStatus := btnGroup.Down;
  if btnGroup.Down and not(Sender = btnGroupDelete) then
  begin
    if not(tblTicketSequences.Active) then
      tblTicketSequences.Active := True;

    try
      qCreated.Open;     //This query is ONLY here to prevent the unnecessary running of other queries later.
    except               //It won't open with an empty dataset, but that's okay because it means that there are
    end;                 //no created tickets anyway.  Therefore, suppress exception.

    //CJY: qTicketSequences.FetchOptions.RecordCountMode set to cmTotal
    if qTicketSequences.RecordCount = 0 then
    begin
      btnGroup.Down := False;
      MessageDlgPos('No tickets to group', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    end
    else
    begin
      //Attempt Lock
      LockSuccess := LockGroupIncStatusBar(oTicket, fmSumms.tblLocks, tblTicketSequences, sbMain);

      if not LockSuccess then
        btnGroup.Down := False
      else
      begin
        dbgGroupTickets.Visible := True;
        dbgTicketSeqs.Visible := False;
        pnlPrintButtons.Visible := False;
        pnlGroupButtons.Visible := True;
        pnlGroupButtons.Left := 72;

        ineSearchStart.Enabled := False;
        ineSearchEnd.Enabled := False;
        ineStartWeek.Enabled := False;
        ineEndWeek.Enabled := False;
        ineStartSeq.Enabled := False;
        ineEndSeq.Enabled := False;
        rgPrinted.Enabled := False;
      end;
    end;
  end
  else
  begin
    btnGroup.Down := False;
    btnDeselectAll.Click;
    dbgTicketSeqs.Visible := True;
    dbgGroupTickets.Visible := False;
    pnlGroupButtons.Visible := False;
    pnlPrintButtons.Visible := True;
    pnlPrintButtons.Left := 72;

    ineSearchStart.Enabled := True;
    ineSearchEnd.Enabled := True;
    ineStartWeek.Enabled := True;
    ineEndWeek.Enabled := True;
    ineStartSeq.Enabled := True;
    ineEndSeq.Enabled := True;
    rgPrinted.Enabled := True;

    if qCreated.Active then
      qCreated.Close;

    //Release Lock
    LocksUnLockRecordIncStatusBar(fmSumms.tblLocks, 'GROUP_TICKETS', sbMain)
  end;

  //Change Columns if Status of button
  //hasn't changed with this procedure
  //CJY: qTicketSequences.FetchOptions.RecordCountMode set to cmTotal
  if (btnGroup.Down = btnGroupDownStatus) or ((qTicketSequences.RecordCount = 0) and (Sender = btnGroupDelete)) then
    SetColumnWidthsAll3a(fmAllTickets, dbgTicketSeqs, dbgGroupTickets, ColumnSelectedPosition, 5, btnGroup.Down);

  WindowState := HoldWindowState;
  LockWindowUpdate(0);

  JustDown := False;

  Screen.cursor := crDefault;
end;

procedure TfmAllTickets.dbgTicketSeqsDblClick(Sender: TObject);
var
  TicketCaption: string;
  SequenceNo, WeekNo: integer;
  sSequenceNo, sWeekNo: string;
  Failed: boolean;
  fmTicketsBreakdown: TfmTicketsBreakdown;

begin
  WeekNo := qTicketSequencesWeekNo.value;
  SequenceNo := qTicketSequencesSequenceNo.value;

  if (WeekNo > 0) and (WeekNo < 54) then
  begin
    sWeekNo := intToStr(WeekNo);
    sSequenceNo := intToStr(SequenceNo);
    TicketCaption := 'Ticket(s) : ' + sWeekNo + '/' + sSequenceNo + '/xx    ';
    if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
    begin
      if not ExistingToFront(TicketCaption, '') then
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

      if fmSumms.mmMinimiseAllonOpen.checked then
        WindowState := wsMinimized;
    end;
  end;
end;

procedure TfmAllTickets.dbgTicketSeqsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgTicketSeqsDblClick(Self);
end;

procedure TfmAllTickets.frAllTicketsBeforePrint(
  Sender: TfrxReportComponent);
begin
  frAllTickets.PreviewOptions.AllowEdit := False;
  frAllTickets.PreviewOptions.Buttons := frAllTickets.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllTickets.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllTickets.PreviewOptions.ZoomMode := zmDefault
  else
    frAllTickets.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllTickets.frAllTicketsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;

  if fmSumms.mmExpandedTicketSearch.Checked then
  begin
    if (VarName = 'mFromWeek') then
      Value := ineStartWeek.Text + ' / ' + ineStartSeq.Text;
    if (VarName = 'mToWeek') then
      Value := ineEndWeek.Text + ' / ' + ineEndSeq.Text;
  end
  else
  begin
    if (VarName = 'mFromWeek') then
      Value := ineSearchStart.Text;
    if (VarName = 'mToWeek') then
      Value := ineSearchEnd.Text;
  end;

  if (VarName = 'ReportTitle') then
  begin
    if rgPrinted.ItemIndex = 0 then
      Value := 'Tickets'
    else if rgPrinted.ItemIndex = 1 then
      Value := 'Tickets (Not Created)'
    else if rgPrinted.ItemIndex = 2 then
      Value := 'Tickets (Not Printed)';
  end;

  if (VarName = 'Tag') then
    Value := TicketTranslation[8];
end;

procedure TfmAllTickets.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;
  mMemo: TfrxMemoView;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frAllTickets.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qTicketSequences.GetBookmark;
  qTicketSequences.DisableControls;
  qTicketSequences.Refresh;

  frAllTickets.PrintOptions.PrintMode := pmScale;
  frAllTickets.PrintOptions.PrintOnSheet := GetPaperSize;

  mMemo := frAllTickets.FindObject('mTagTitle') as TfrxMemoView;
  mMemo.Visible := PrintTagNumbers;
  mMemo := frAllTickets.FindObject('mTag') as TfrxMemoView;
  mMemo.Visible := PrintTagNumbers;

  frAllTickets.PrepareReport;

  try
    qTicketSequences.GotoBookmark(MyBookmark);
  except
  end;
  qTicketSequences.EnableControls;
  qTicketSequences.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frAllTickets do
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
    frAllTickets.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllTickets.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;
  //SecondProcessInUse := False;
  
  if fmSumms.mmExpandedTicketSearch.Checked then
    pnlExpandedSearch.Visible := True
  else
    pnlExpandedSearch.Visible := False;

  ActiveSearchStart := 0;
  ActiveSearchEnd := 0;
  ActiveSeqStart := 0;
  ActiveSeqEnd := 0;

  qTicketSequences.ParamByName('SearchStart').AsString := '1';
  qTicketSequences.ParamByName('SearchEnd').AsString := '53';
  qTicketSequences.ParamByName('SeqStart').AsString := '1';
  qTicketSequences.ParamByName('SeqEnd').AsString := '32000';
  qTicketSequences.Open;
//CJY Moved to qTicketSequences.AfterOpen
{
  //CJY: qTicketSequences.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qTicketSequences.RecordCount + 1);
  FillArray(False);
}

  if PrintTagNumbers then
  begin
    ClientWidth := 842;

    dbgTicketSeqs.Columns[4].Visible := True;
    dbgGroupTickets.Columns[4].Visible := True;
    dbgTicketSeqs.Columns[4].Title.Caption := TicketTranslation[8];
    dbgGroupTickets.Columns[4].Title.Caption := TicketTranslation[8];
  end
  else
    ClientWidth := 507;

  ColumnSelectedPosition := 5;

  btnExternalOut.enabled := Option_TicketsOut;
  btnUpdatedOut.enabled := Option_TicketsOut;
  btnSyntheticsTicketsList.enabled := Option_Synthetics;

  //Ensure Searches are 'set' before we start
  btnRefresh.Click;
end;

procedure TfmAllTickets.FillArray(Flag: Boolean);
var
  i: integer;

begin
  for i := 1 to Length(Selected) - 1 do
    Selected[i] := Flag;
end;

procedure TfmAllTickets.DisableMyControls;
begin
  btnPrint.enabled := false;
  btnPrintPreview.enabled := false;
  btnGroup.enabled := false;
  ineSearchStart.enabled := false;
  ineSearchEnd.enabled := false;
  rgPrinted.enabled := False;
end;

procedure TfmAllTickets.EnableMyControls;
begin
  btnPrint.enabled := true;
  btnPrintPreview.enabled := true;
  btnGroup.enabled := true;
  ineSearchStart.enabled := true;
  ineSearchEnd.enabled := true;
  rgPrinted.Enabled := True;
end;

procedure TfmAllTickets.btnRefreshClick(Sender: TObject);
var
  SQLString : String;
  DoIt: boolean;

begin
  if btnGroup.Down then
  begin
    DoIt := False;
    if RefreshWarn then
      DoIt := (MessageDlgPos('Refresh will clear selections. ' + #13 + 'Continue?', mtWarning, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes)
    else
      DoIt := True;
  end
  else
    DoIt := True;

  if DoIt then
  begin
    screen.Cursor := crHourGlass;
    qTicketSequences.Close;

    //N.B.  The DISTINCT is here in this query purely to stop it being live and therefore force to have its own
    //      record number generated and thus keep the selected array properly in synch.
    SQLString := 'SELECT DISTINCT WeekNo, SequenceNo, Style, Construction, TagNo ' +
                 'FROM TicketSequences ' +
                 'WHERE (';

    if fmSumms.mmExpandedTicketSearch.Checked then
    begin
      if StrToInt(ineStartWeek.Text) = StrToInt(ineEndWeek.Text) then
        SQLString := SQLString + 'WeekNo = ' + ineStartWeek.Text + ' and (SequenceNo BETWEEN ' + ineStartSeq.Text + ' and ' + ineEndSeq.Text + ')'
      else
      begin
        if StrToInt(ineStartWeek.Text) < StrToInt(ineEndWeek.Text) then
        begin
          SQLString := SQLString + '(WeekNo = ' + ineStartWeek.Text + ' and SequenceNo >= ' + ineStartSeq.Text +
                                   ') or (WeekNo = ' + ineEndWeek.Text + ' and SequenceNo <= ' + ineEndSeq.Text + ')';
          if StrToInt(ineEndWeek.Text) - StrToInt(ineStartWeek.Text) > 1 then
            SQLString := SQLString + ' or (WeekNo BETWEEN ' + IntToStr(StrToInt(ineStartWeek.Text) + 1) + ' and ' + IntToStr(StrToInt(ineEndWeek.Text) - 1) + ')';
        end
        else
        begin
          SQLString := SQLString + '(WeekNo = ' + ineStartWeek.Text + ' and SequenceNo >= ' + ineStartSeq.Text +
                                   ') or (WeekNo = ' + ineEndWeek.Text + ' and SequenceNo <= ' + ineEndSeq.Text + ')';
          if StrToInt(ineEndWeek.Text) - StrToInt(ineStartWeek.Text) < 52 then
            SQLString := SQLString + ' or (WeekNo BETWEEN ' + IntToStr(StrToInt(ineStartWeek.Text) + 1) + ' and 53 or WeekNo BETWEEN 1 and ' + IntToStr(StrToInt(ineEndWeek.Text) - 1) + ')';
        end
      end
    end
    else
    begin
      if StrToInt(ineSearchStart.Text) = StrToInt(ineSearchEnd.Text) then
        SQLString := SQLString + 'WeekNo = ' + ineSearchStart.Text
      else
        if StrToInt(ineSearchStart.Text) < StrToInt(ineSearchEnd.Text) then
          SQLString := SQLString + 'WeekNo BETWEEN ' + ineSearchStart.Text + ' and ' + ineSearchEnd.Text
        else
          SQLString := SQLString + '(WeekNo BETWEEN ' + ineSearchStart.Text + ' and 53 or WeekNo BETWEEN 1 and ' + ineSearchEnd.Text + ')';
    end;

    if rgPrinted.ItemIndex = 0 then
      SQLString := SQLString + ') '
    else if rgPrinted.ItemIndex = 1 then
      SQLString := SQLString + ') AND (0 = (SELECT COUNT(TicketNo) ' +
                                            'FROM TicketTickets ' +
                                            'WHERE WeekNo = TicketSequences.WeekNo and SequenceNo = TicketSequences.SequenceNo)) '
    else
      SQLString := SQLString + ') AND (0 <> (SELECT COUNT(TicketNo) ' +
                                            'FROM TicketTickets ' +
                                            'WHERE WeekNo = TicketSequences.WeekNo and SequenceNo = TicketSequences.SequenceNo and ' +
                                            'Printed = False)) ';

    qTicketSequences.SQL.Text := SQLString;
    qTicketSequences.Open;

    if btnGroup.Down then
    begin
//CJY Redundant as it exists in qSuppliers.AfterOpen
{
      //CJY: qTicketSequences.FetchOptions.RecordCountMode set to cmTotal
      SetLength(Selected, qTicketSequences.RecordCount + 1);
      FillArray(False);
}
      qTicketSequences.Refresh;
    end;
  end;

  rgPrinted.Font.Color := clData;

  btnPrintPreview.Enabled := True;
  btnPrint.Enabled := True;

  if fmSumms.mmExpandedTicketSearch.Checked then
  begin
    ineStartWeek.Font.Color := clData;
    ineEndWeek.Font.Color := clData;
    ineStartSeq.Font.Color := clData;
    ineEndSeq.Font.Color := clData;
    ActiveSearchStart := ineStartWeek.Value;
    ActiveSearchEnd := ineEndWeek.Value;
    ActiveSeqStart := ineStartSeq.Value;
    ActiveSeqEnd := ineEndSeq.Value;
  end
  else
  begin
    ineSearchStart.Font.Color := clData;
    ineSearchEnd.Font.Color := clData;
    ActiveSearchStart := ineSearchStart.Value;
    ActiveSearchEnd := ineSearchEnd.Value;
  end;

  if fmSumms.mmExpandedTicketSearch.Checked then
  begin
    ActiveSeqStart := ineStartSeq.Value;
    ActiveSeqEnd := ineEndSeq.Value;
  end;
  screen.Cursor := crDefault;

  //Fixes Missing Scrollbar on Windows 8
  //if Refresh with nothing selected then
  //refresh again with enough selected that
  //it SHOULD show Scrollbar. Was working
  //as it should on Windows 7 but needs
  //this 'twitch' to work with Windows 8.
  //Included in all 'All' forms.
  Width := Width + 1;
  Width := Width - 1;
end;

procedure TfmAllTickets.btnSelectAllClick(Sender: TObject);
begin
  FillArray(True);
  qTicketSequences.Refresh;
end;

procedure TfmAllTickets.btnSizeClick(Sender: TObject);
begin
  showmessage(inttostr(fmAllTickets.height) + ' - ' + inttostr(fmAllTickets.Width));
end;

procedure TfmAllTickets.btnDeselectAllClick(Sender: TObject);
begin
  FillArray(False);
  qTicketSequences.Refresh;
end;

procedure TfmAllTickets.btnGroupDeleteClick(Sender: TObject);
var
  QueryString: string;

begin
  try
    tbMain.enabled := False;
    fmSumms.enabled := False;

    if MessageDlgPos('Delete selected Tickets?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
    begin
      application.processmessages;
      Screen.cursor := crHourGlass;
      qTicketSequences.DisableControls;

      if Option_TicketAudit then
      begin
        //Only Tickets which were Created (i.e. in TicketTickets) will be added
        //to the Audit trail for deletion - this was the same in Summs 4.
        QueryString := 'INSERT INTO Audit ' +
                       '(Type, UserName, WeekNo, SequenceNo, TicketNo, TransactionDate, Printed) ' +
                       'SELECT ''D'', ''' + QS(SystemUserName) + ''', TT.WeekNo, TT.SequenceNo, TT.TicketNo, CurDate(), TT.Printed ' +
                       'FROM TicketTickets TT, TicketSequences TS ' +
                       'WHERE TT.WeekNo = TS.WeekNo AND TT.SequenceNo = TS.SequenceNo AND ( ' + WeekSeqString('TT') + ');';
      end
      else
        QueryString := '';

      QueryString := QueryString + 'TRY ' + #13 +
                                   'DELETE FROM TicketSequences ' + #13 +
                                   'WHERE ( ' + WeekSeqString('') + ');' + #13 +
                                   'CATCH ALL ' + #13 +
                                   'END TRY; ' + #13;

      if SelectedCount > 0 then
      begin
        qGroupDelete.SQL.Text := QueryString;
        qGroupDelete.ExecSQL;
      end;

      RefreshWarn := False;
      btnRefresh.Click;
      RefreshWarn := True;

      //Tickets ALWAYS deleted
      MessageDlgPos('Deletion complete.', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

      qTicketSequences.EnableControls;
    end;
  finally
    fmSumms.enabled := True;
    tbMain.enabled := True;
    tbMain.setFocus;
  end;

  Screen.cursor := crDefault;

  //CJY: qTicketSequences.FetchOptions.RecordCountMode set to cmTotal
  if qTicketSequences.RecordCount = 0 then
    btnGroupClick(Sender);
end;

procedure TfmAllTickets.RunGroup;
var
  TicketCode: string;
  LockSuccess, Pairage, TicketCreated: boolean;
  ErrorString, TIQuery, TCGQuery, s: string;
  i: integer;
  fmTicketsBreakdown: TfmTicketsBreakdown;

begin
  i := -1;
  ErrorString := '';

  Screen.Cursor := crHourGlass;

  tblTicketSequences.MasterSource := dsTicketSeqs;
  tblTicketSequences.MasterFields := 'WeekNo;SequenceNo';

  qTicketSequences.DisableControls;
  qTicketSequences.RecNo := 1; //CJY changed from qTicketSequences.First
  qTicketSequences.Prior; //CJY changed from qTicketSequences.First
  repeat
    MadeTicket := False;
    LockSuccess := false;
    TicketCode := IntToStr(qTicketSequencesWeekNo.Value) + '/' + IntToStr(qTicketSequencesSequenceNo.Value);
    if qTicketSequencesSelected.Value then
      fmTicketsGroupCreate.lblTicketCode.caption := 'Creating  ' + TicketCode
    else
    begin
      MadeTicket := True;
      fmTicketsGroupCreate.lblTicketCode.caption := 'Checking  ' + TicketCode;
    end;
    application.processmessages;

    if qTicketSequencesSelected.Value then
    begin
      qCreated.Close;
      qCreated.Open;
      TicketCreated := (qCreatedCreated.Value > 0);

      if TicketCreated then
      begin
        MadeTicket := True;
        Errors := True;
        inc(i);
        ErrorString := TicketCode + ' already created by another user';
        fmTicketsGroupError.sgOtherErrors.Cells[0, i] := ErrorString;
      end
      else
      begin
        LocalConnectionSumms.StartTransaction;

        //Attempt Lock
        LockSuccess := LockSingle(oTicket, fmSumms.tblLocks, tblTicketSequences, TicketCode, False);

        if not LockSuccess then
        begin
          MadeTicket := True;
          Errors := True;
          inc(i);
          ErrorString := TicketCode + ' locked';
          fmTicketsGroupError.sgOtherErrors.Cells[0, i] := ErrorString;
        end;

        if LockSuccess then
        begin
          if not LocalConnectionSumms.Connected then
            LocalConnectionSumms.Connected := true;

          dmTicketsAll.ChangeAllConnections(LocalConnectionSumms);
          LocalConnectionSumms.StartTransaction;

          dmTicketsAll.FillCompareGrid(IntToStr(qTicketSequencesWeekNo.Value), IntToStr(qTicketSequencesSequenceNo.Value), qTicketSequencesStyle.Value);
          try
            TIQuery := fmTicketsBreakdown.MakeTIQuery(IntToStr(qTicketSequencesWeekNo.Value), IntToStr(qTicketSequencesSequenceNo.Value), 3);
            TCGQuery := fmTicketsBreakdown.MakeTCGQuery(IntToStr(qTicketSequencesWeekNo.Value), IntToStr(qTicketSequencesSequenceNo.Value), 2);

            dmTicketsAll.qCompareGrids.SQL.Text := TIQuery + ' UNION ' + TCGQuery;
            dmTicketsAll.qCompareGrids.Open;

            //CJY: dmTicketsAll.qCompareGrids.FetchOptions.RecordCountMode set to cmTotal
            if dmTicketsAll.qCompareGrids.RecordCount > 0 then
            begin
              MadeTicket := True;
              Errors := True;
              inc(i);
              ErrorString := TicketCode + ' - Widths/Sizes do not match original entry';
              fmTicketsGroupError.sgOtherErrors.Cells[0, i] := ErrorString;
            end
            else
            begin
              dmTicketsAll.qWidthKnives.Close;
              dmTicketsAll.qWidthKnives.ParamByName('WeekNo').value := qTicketSequencesWeekNo.Value;
              dmTicketsAll.qWidthKnives.ParamByName('SequenceNo').value := qTicketSequencesSequenceNo.Value;
              dmTicketsAll.qWidthKnives.Open;
              try
                MadeTicket := dmTicketsAll.MakeTickets(IntToStr(qTicketSequencesWeekNo.Value), IntToStr(qTicketSequencesSequenceNo.Value), True);
              except
                MadeTicket := True;
                Errors := True;
                inc(i);
                ErrorString := TicketCode + ' already created or cannot be created';
                fmTicketsGroupError.sgOtherErrors.Cells[0, i] := ErrorString;
              end;
            end;

            dmTicketsAll.qCompareGrids.Close;
          finally
            dmTicketsAll.qClearCompareGrid.paramByName('Identifier').value := Identifier;
            dmTicketsAll.qClearCompareGrid.paramByName('WeekNo').AsInteger := qTicketSequencesWeekNo.Value;
            dmTicketsAll.qClearCompareGrid.paramByName('SequenceNo').AsInteger := qTicketSequencesSequenceNo.Value;
            dmTicketsAll.qClearCompareGrid.execSQL;
          end;
          LocalConnectionSumms.Commit;
          dmTicketsAll.RevertAllConnections;
        end
        else
        begin
          MadeTicket := True;
          Errors := True;
          inc(i);
          ErrorString := TicketCode + ' - Ticket validation in use.';
          fmTicketsGroupError.sgOtherErrors.Cells[0, i] := ErrorString;
        end;

        if not Errors then
        begin
          tblTicketSequencesLinesInLeatherGrid.value := LinesInLeatherGrid;
          tblTicketSequencesRowsInLeatherGrid.value := RowsInLeatherGrid;
          //Post and release lock.
          tblTicketSequences.post;
          LocalConnectionSumms.Commit;
        end
        else
        begin
          //Release lock
          tblTicketSequences.cancel;
          LocalConnectionSumms.Rollback;
        end;
      end;

      application.processmessages;
    end;
    fmTicketsGroupCreate.pbTicketsCreated.Progress := fmTicketsGroupCreate.pbTicketsCreated.Progress + 1;

    qTicketSequences.Next;
  until qTicketSequences.Eof or not MadeTicket;
  qTicketSequences.EnableControls;

  tblTicketSequences.MasterSource := nil;
  tblTicketSequences.MasterFields := '';

  if Errors then
    fmTicketsGroupError.sgOtherErrors.RowCount := i + 1;

  fmTicketsGroupCreate.Close;
end;

procedure TfmAllTickets.btnClearTicketsClick(Sender: TObject);
var
  SQLString: string;

begin
  try
    tbMain.enabled := False;
    fmSumms.enabled := False;

    if MessageDlgPos('Clear selected Tickets?' + #13 + 'This may take a few minutes', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
    begin
      application.processmessages;
      screen.cursor := crHourGlass;
      qTicketSequences.DisableControls;

      if Option_TicketAudit then
      begin
        //Only Tickets which were Created (i.e. in TicketTickets) can be cleared.
        SQLString := 'INSERT INTO Audit ' +
                     '(Type, UserName, WeekNo, SequenceNo, TicketNo, TransactionDate, Printed) ' +
                     'SELECT ''C'', ''' + QS(SystemUserName) + ''', TT.WeekNo, TT.SequenceNo, TT.TicketNo, CurDate(), TT.Printed ' +
                     'FROM TicketTickets TT, TicketSequences TS ' +
                     'WHERE TT.WeekNo = TS.WeekNo AND TT.SequenceNo = TS.SequenceNo AND ( ' + WeekSeqString('TT') + ');';
      end
      else
        SQLString := '';

      SQLString := SQLString + 'DELETE FROM TicketTickets' + #13 +
                               'WHERE ( ' + WeekSeqString('') + ');' + #13;

      SQLString := SQLString + 'UPDATE TicketSequences' + #13 +
                   'SET AllPrinted = False' + #13 +
                   'WHERE ( ' + WeekSeqString('') + ');' + #13;

      if SelectedCount > 0 then
      begin
        qGroupClear.SQL.Text := SQLString;
        try
          qGroupClear.ExecSQL;
          MessageDlgPos('Clear completed', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
        except
          MessageDlgPos('Clear failed', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
        end;
      end
      else
        MessageDlgPos('No tickets selected', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

      qTicketSequences.EnableControls;
    end;
  finally
    fmSumms.enabled := True;
    tbMain.enabled := True;
    tbMain.setFocus;
  end;

  Screen.cursor := crDefault;
end;

procedure TfmAllTickets.btnCreateClick(Sender: TObject);
var
  s: string;
  HoldFilter: string;
  SecondProcess: TicketsGroupCreateThread;

begin
  //Unlike previous versions tickets are never deselected as group functions
  //are performed - this is because leaving them selected provides better
  //functionality e.g. can now print same selection after create.  Better
  //error reporting removes need for deselection.

  Screen.Cursor := crHourGlass;

  Errors := False;
  fmTicketsGroupError.sgOtherErrors.RowCount := 0;

  fmTicketsGroupCreate.pbTicketsCreated.MinValue := 0;
  //CJY: qTicketSequences.FetchOptions.RecordCountMode set to cmTotal
  fmTicketsGroupCreate.pbTicketsCreated.MaxValue := qTicketSequences.RecordCount;
  fmTicketsGroupCreate.pbTicketsCreated.Progress := 0;

  //Start Thread to Create Tickets
  if not SecondProcessInUse then
  begin
    SecondProcessInUse := True;
    SecondProcess := TicketsGroupCreateThread.Create(true);
    SecondProcess.FreeOnTerminate := True;
    SecondProcess.OnTerminate := FinishSecondProcess;
    SecondProcess.PassDetails(fmAllTickets);
    SecondProcess.resume;
  end;

  fmTicketsGroupCreate.ShowModal;

  qTicketSequences.RecNo := 1; //CJY changed from qTicketSequences.First
  qTicketSequences.Prior; //CJY changed from qTicketSequences.First

  Screen.Cursor := crDefault;

  s := 'Ticket Creation Complete';
  if Errors then
    s := s + ' - There are Errors.'
  else
    s := s + '.';
  if MadeTicket then
    MessageDlgPos(s, mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

  if Errors then
    fmTicketsGroupError.ShowModal;
end;

function TfmAllTickets.NumberSelected: integer;
var
  i: integer;

begin
  Result := 0;
  //CJY: qTicketSequences.FetchOptions.RecordCountMode set to cmTotal
  for i := 1 to qTicketSequences.RecordCount do
    if Selected[i] then
      inc(Result);
end;

procedure TfmAllTickets.btnGroupPrintClick(Sender: TObject);
var
  fmfrTicket: TfmfrTicket;
  AllNotCreated, Failed, SomeNotCreated: boolean;
  SelectedCount: integer;
  WeekNosString, WeekNosString2, OrderBy, PrintSyntheticsString: string;
  SyntheticsListCreated: Boolean;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  SyntheticsListCreated := False;

  SelectedCount := NumberSelected;
  if SelectedCount > 0 then
  begin
    tbMain.enabled := False;
    fmSumms.enabled := False;
    fmCancelPrinting.visible := True;
    fmCancelPrinting.lblItem.Caption := 'Pre-processing ...';
    Application.ProcessMessages;

    btnGroupPrint.Enabled := False;

    SomeNotCreated := False;

    Failed := false;
    try
      fmfrTicket := TfmfrTicket.Create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    try
      if not Failed then
      begin
        fmfrTicket.GroupPrint := True;      
        WeekNosString := WeekSeqString('TS');
        WeekNosString2 := WeekSeqString('');

        if fmSumms.mmGroupPrintByMaterial.Checked then
          OrderBy := 'Order By TT.MaterialCode, TT.MaterialCode, TT.WeekNo, TT.SequenceNo, TT.TicketNo'
        else
          OrderBy := 'Order By TT.WeekNo, TT.WeekNo, TT.SequenceNo, TT.TicketNo';

        if not Option_Synthetics then
          PrintSyntheticsString := 'FALSE'
        else
        begin
          if GroupPrintSyntheticTickets then
            PrintSyntheticsString := 'TRUE'
          else
            PrintSyntheticsString := 'FALSE';
        end;

        if fmCancelPrinting.Visible then
          fmfrTicket.qTickets.SQL.Text := 'SELECT TT.*, TS.Style, TS.Construction, TS.TagNo, TS.Customer, TS.Picture, TS.RowsInLeatherGrid, TS.LinesInLeatherGrid ' +
                                          'FROM TicketTickets TT, TicketSequences TS ' +
                                          'WHERE TT.WeekNo = TS.WeekNo AND TT.SequenceNo = TS.SequenceNo AND (' +
                                           WeekNosString + ') AND TT.Print = TRUE AND ' +
                                          '((NOT (TT.MaterialType = ''R'' OR TT.MATERIALTYPE = ''S'')) OR ' +
                                          '((TT.MaterialType = ''R'' OR TT.MATERIALTYPE = ''S'') AND (' +
                                          PrintSyntheticsString + ' = TRUE))) ' + OrderBy;

        if fmCancelPrinting.Visible then
          fmfrTicket.qShoeSizes.SQL.Text := 'SELECT TI.WeekNo, TI.SequenceNo, TS.TicketNo, TI.Width, TI.Size, TI.Pairs, TI.WidthNo, TI.SizeSeq ' +
                                            'FROM TicketsInput TI, TicketTicketsWidths TS ' +
                                            'WHERE (' +  WeekNosString + ') AND TS.WeekNo = TI.WeekNo AND ' +
                                                   'TS.SequenceNo = TI.SequenceNo AND TS.Width = TI.Width AND ' +
                                                   'TI.Size <> ''AddWidth'' AND NOT EXISTS ' +
                                                   '(SELECT * ' +
                                                    'FROM TicketsSplitInput ' +
                                                    'WHERE (' + WeekNosString2 + ') AND WeekNo = TS.WeekNo AND SequenceNo = TS.SequenceNo AND TicketNo = TS.TicketNo) ' +
                                            'UNION ' +
                                            'SELECT TS.WeekNo, TS.SequenceNo, TS.TicketNo, TS.Width, TS.Size, TS.Pairs, TS.WidthNo, TS.SizeSeq ' +
                                            'FROM TicketsSplitInput TS ' +
                                            'WHERE (' +  WeekNosString + ') AND TS.Size <> ''AddWidth'' ' +
                                            'UNION ' +
                                            'SELECT DISTINCT TS.WeekNo, TS.SequenceNo, TS.TicketNo, TSI2.Width, TS.Size, 0 as Pairs, TSI2.WidthNo, TS.SizeSeq ' +
                                            'FROM TicketsSplitInput TS, TicketsSplitInput TSI2 ' +
                                            'WHERE (' +  WeekNosString + ') AND TS.Size <> ''AddWidth'' AND ' +
                                                   'TSI2.WeekNo = TS.WeekNo AND TSI2.SequenceNo = TS.SequenceNo AND ' +
                                                   'TSI2.TicketNo = TS.TicketNo AND TSI2.Size <> ''AddWidth'' AND ' +
                                                   'NOT EXISTS (SELECT 1 ' +
                                                               'FROM TicketsSplitInput ' +
                                                               'WHERE (' + WeekNosString2 + ') AND WeekNo = TS.WeekNo AND ' +
                                                               'SequenceNo = TS.SequenceNo AND ' +
                                                               'TicketNo = TS.TicketNo AND ' +
                                                               'Width = TSI2.Width AND Size = TS.Size) ' +
                                            'UNION ' +
                                            'SELECT 0 as WeekNo, 0 as SequenceNo, 0 as TicketNo, ''0'' as Width, ''0'' as Size, 0 as Pairs, 0 as WidthNo, 0 as SizeSeq ' +
                                            'FROM Params ' +               //***LATER*** This UNION forces Order By to, to create index by ensuring there is more than one record returned
                                            'Order By 1, 1, 2, 3, 7, 8 ';     //with only one line the Order By clause, clause isn't used so no index is created - find a better way when more time.

        if fmCancelPrinting.Visible then
          // CJY formerly qNominalSizes
          fmfrTicket.qNominalSizes2.SQL.Text := 'SELECT DISTINCT TP.WeekNo, TP.SequenceNo, TP.TicketNo, PWK.Seq, TP2.SizeIndex, TP.KnifeCode, TP2.Size, ' +
                                               'IIF((TP.Size = TP2.Size), TP.Pairs, 0) as Pairs ' +
                                               'FROM TicketPairage TP, TicketPairage TP2, TicketTickets TS, PtWidKnf PWK ' +
                                               'WHERE (' +  WeekNosString + ') AND ' +
                                               'TP.WeekNo = TS.WeekNo AND TP.SequenceNo = TS.SequenceNo AND TP.TicketNo = TS.TicketNo AND ' +
                                               'TP2.WeekNo = TS.WeekNo AND TP2.SequenceNo = TS.SequenceNo AND TP2.TicketNo = TS.TicketNo AND ' +
                                               'TS.PartCode = PWK.Part AND TP.KnifeCode = PWK.Knife AND ' +
                                               'NOT EXISTS (SELECT * ' +
                                                           'FROM TicketPairage ' +
                                                           'WHERE WeekNo = TS.WeekNo AND SequenceNo = TS.SequenceNo AND ' +
                                                           'TicketNo = TS.TicketNo AND Pairs > 0 AND ' +
                                                           'KnifeCode = TP.KnifeCode AND Size = TP2.Size) AND ' +
                                               '((PWK.WidthNo = (SELECT MIN(W.No) ' +
                                                                'FROM Widths W, TicketTicketsWidths TTW ' +
                                                                'WHERE TTW.WeekNo = TS.WeekNo AND ' +
                                                                      'TTW.SequenceNo = TS.SequenceNo AND ' +
                                                                      'TTW.TicketNo = TS.TicketNo AND ' +
                                                                      'TTW.Width = W.Width)) OR ' +
                                               '(PWK.WidthNo = (SELECT MIN(WidthNo) ' +
                                                               'FROM TicketsSplitInput ' +
                                                               'WHERE WeekNo = TS.WeekNo AND ' +
                                                                     'SequenceNo = TS.SequenceNo AND ' +
                                                                     'TicketNo = TS.TicketNo AND ' +
                                                                     'Size <> ''AddWidth''))) ' +
                                               'UNION ' +
                                               'SELECT TP.WeekNo, TP.SequenceNo, TP.TicketNo, PWK.Seq, TP.SizeIndex, TP.KnifeCode, TP.Size, TP.Pairs ' +
                                               'FROM TicketPairage TP,  TicketTickets TS, PtWidKnf PWK ' +
                                               'WHERE (' +  WeekNosString + ') AND TS.PartCode = PWK.Part AND ' +
                                                     'TP.KnifeCode = PWK.Knife AND TP.WeekNo = TS.WeekNo AND ' +
                                                     'TP.SequenceNo = TS.SequenceNo AND TP.TicketNo = TS.TicketNo AND ' +
                                               '((PWK.WidthNo = (SELECT MIN(W.No) ' +
                                                                'FROM Widths W, TicketTicketsWidths TTW ' +
                                                                'WHERE TTW.WeekNo = TS.WeekNo AND ' +
                                                                      'TTW.SequenceNo = TS.SequenceNo AND ' +
                                                                      'TTW.TicketNo = TS.TicketNo AND ' +
                                                                      'TTW.Width = W.Width)) OR ' +
                                               '(PWK.WidthNo = (SELECT MIN(WidthNo) ' +
                                                               'FROM TicketsSplitInput ' +
                                                               'WHERE WeekNo = TS.WeekNo AND ' +
                                                                     'SequenceNo = TS.SequenceNo AND ' +
                                                                     'TicketNo = TS.TicketNo AND ' +
                                                                     'Size <> ''AddWidth''))) '  +
                                               'UNION ' +
                                               'SELECT 0 as WeekNo, 0 as SequenceNo, 0 as TicketNo, 0 as Seq, 0 as SizeIndex, ''0'' as KnifeCode, ''0'' as Size, 0 as Pairs ' +
                                               'FROM Params ' +               //***LATER*** This UNION forces Order By to, to create index by ensuring there is more than one record returned
                                               'Order By 1, 1, 2, 3, 4, 5 ';     //with only one line the Order By clause, clause isn't used so no index is created - find a better way when more time.

        try
          Application.ProcessMessages;
          fmfrTicket.qTickets.AfterScroll := nil;
          if fmCancelPrinting.Visible then
            fmfrTicket.qTickets.Open;
          fmfrTicket.qTickets.AfterScroll := fmfrTicket.qTicketsAfterScroll;
          Application.ProcessMessages;
          if fmCancelPrinting.Visible then
            fmfrTicket.qShoeSizes.Open;
          Application.ProcessMessages;
          if fmCancelPrinting.Visible then
          // CJY formerly qNominalSizes
            fmfrTicket.qNominalSizes2.Open;

          Application.ProcessMessages;
          if fmCancelPrinting.Visible and Option_CuttingTimes and PrintTimes then
          begin
            fmfrTicket.qTicketTimes.SQL.Text := 'SELECT TS.WeekNo, TS.SequenceNo, TS.TicketNo, TS.Quality, TS.Time ' +
                                                'FROM TicketTicketsTimes TS ' +
                                                'WHERE (' +  WeekNosString + ') ' +
                                                ' UNION ' +
                                                'SELECT 0 as WeekNo, 0 as SequenceNo, 0 as TicketNo, 0 as Quality, 0 as Time ' +
                                                'FROM Params ' +
                                                'Order By 1, 1, 2, 3, 4';
                         //***LATER*** This UNION forces Order By to, to create index by ensuring there is more than one record returned
                         //with only one line the Order By clause, clause isn't used so no index is created - find a better way when more time.
            fmfrTicket.qTicketTimes.Open;
          end;
        except
          AllNotCreated := True;
        end;

        Application.ProcessMessages;
        //CJY: fmfrTicket.qTickets..FetchOptions.RecordCountMode set to cmTotal
        if (fmfrTicket.qTickets.recordcount > 0) and (fmCancelPrinting.Visible) then
        begin
          AllNotCreated := False;
          fmfrTicket.Setup;
          fmfrTicket.qPrinted.SQL.Text := '';
          try
            fmfrTicket.frTicket.PrintOptions.PrintMode := pmScale;
            fmfrTicket.frTicket.PrintOptions.PrintOnSheet := GetPaperSize;
            fmfrTicket.frTicket.PrepareReport;
            if fmCancelPrinting.Visible then
            begin
              fmCancelPrinting.Visible := False;
              fmfrTicket.qTickets.AfterScroll := nil;
              fmfrTicket.frTicket.Print;
            end;
          except
            fmMemoryError.showError(self);
          end;
          fmfrTicket.release;   //all queries are destroyed here, so no need to close them.
        end
        else
          AllNotCreated := True;

        //Note: It maybe that the tickets ARE created but that
        //none of the individual tickets are set to be printed.
        if AllNotCreated then
          MessageDlgPos('None of the selected tickets can be printed', mtWarning, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
        else
        begin
          qCountCreated.SQL.Text := 'SELECT COUNT(*) as TicketsCreated ' +    //only using TS to save redoing string.
                                    'FROM TicketTickets TS ' +
                                    'WHERE (' + WeekNosString + ') and TS.TicketNo = 1';
          qCountCreated.Open;
          if not(SelectedCount = qCountCreatedTicketsCreated.Value) then
            MessageDlgPos('Not all of the selected tickets can be printed', mtWarning, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
        end;

        //Optional Synthetic Tickets List
        if Option_Synthetics and CreateSyntheticTicketsList then
          SyntheticsListCreated := OpenSyntheticsTicketsList;
      end;
    finally
      fmSumms.enabled := True;
      tbMain.enabled := True;
      if not SyntheticsListCreated then
        tbMain.setFocus;

      btnGroupPrint.Enabled := True;
    end;
  end
  else
    MessageDlgPos('No tickets selected', mtWarning, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllTickets.btnExternalOutClick(Sender: TObject);
begin
  if DirectoryExists(TicketsDirectory) then
    sdFileOut.InitialDir := TicketsDirectory
  else
  begin
    MessageDlgPos('Parameters | Tickets directory does not exist', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    sdFileOut.InitialDir := ExtractFileDrive(ExpandFileName(Application.EXEName));
  end;

  if sdFileOut.Execute then
    SaveExternalOut(sdFileOut.FileName);
end;

procedure TfmAllTickets.SaveExternalOut(FileName: string);
var
  F: TextFile;
  s: string;
  i: short;
  TS: TStrings;
  LastKnife: string;
  FileSaved: boolean;
  TagNoLength: integer;

begin
  screen.cursor := crHourGlass;

  if ShortTagNo then
    TagNoLength := 25
  else
    TagNoLength := 55;

  FileSaved := False;

  qExternalOut.SQL.Text := 'SELECT TT.WeekNo, TT.SequenceNo, TT.TicketNo, TS.TagNo, TS.Customer, ' +
                           'TS.Style, TT.PartCode, TT.MaterialCode, TT.MaterialDescription, ' +
                           'TT.MaterialCutType, TT.MaterialSkinTrimmed, TT.MaterialLayers, ' +
                           'TT.MaterialSkinSize, TT.MaterialWidth, TT.TotalPairs, TT.AdjFactorResult, ' +
                           'TT.IssuedAllowance, TT.MaterialQualCoeff, TT.MaterialLength, ' +
                           'TT.MaterialAreaCoeff, TT.SpecialInstructions, TT.MaterialType, ' +
                           'TT.BasicAllowance, TT.AdjustedAllowance, TP.KnifeIndex as NoKnives ' +
                           'FROM TicketSequences TS, TicketTickets TT, TicketPairage TP ' +
                           'WHERE (' + WeekSeqString('TT') + ') AND TT.WeekNo = TS.WeekNo AND ' +
                                 'TT.SequenceNo = TS.SequenceNo AND ' +
                                 'TP.WeekNo = TT.WeekNo AND ' +
                                 'TP.SequenceNo = TT.SequenceNo AND ' +
                                 'TP.TicketNo = TT.TicketNo AND ' +
                           'TP.KnifeIndex = ' +
                           '(SELECT COUNT(DISTINCT KnifeIndex) ' +
                           'FROM TicketPairage ' +
                           'WHERE WeekNo = TT.WeekNo AND SequenceNo = TT.SequenceNo AND TicketNo = TT.TicketNo) AND ' +
                           'TP.SizeIndex = ' +
                           '(SELECT MIN(SizeIndex) ' +
                           'FROM TicketPairage ' +
                           'WHERE WeekNo = TT.WeekNo AND SequenceNo = TT.SequenceNo AND TicketNo = TT.TicketNo AND ' +
                              'KnifeIndex =(SELECT COUNT(DISTINCT KnifeIndex) ' +
                                           'FROM TicketPairage ' +
                                           'WHERE WeekNo = TT.WeekNo AND SequenceNo = TT.SequenceNo AND TicketNo = TT.TicketNo)) ' +
                           'Order By TT.WeekNo, TT.WeekNo, TT.SequenceNo, TT.TicketNo';

  qExternalOut.open;
  qExternalOutKnives.open;
  if Option_CuttingTimes then
    qExternalOutTimes.open;

  if qExternalOut.IsEmpty then
    MessageDlgPos('No created tickets selected', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else
  begin
    assignfile(F, FileName);
    rewrite(F);

    qExternalOut.RecNo := 1; //CJY changed from qExternalOut.First
    qExternalOut.Prior; //CJY changed from qExternalOut.First
    while not qExternalOut.eof do
    begin
      str(qExternalOut.FieldByName('WeekNo').value : 2 : 0, s);
      write(F, s);
      qExternalOutKnives.Filter := 'WeekNo = ' + s;
      qExternalOutTimes.Filter := 'WeekNo = ' + s;
      write(F, '/');
      str(qExternalOut.FieldByName('SequenceNo').value : 5 : 0, s);
      write(F, s);
      qExternalOutKnives.Filter := qExternalOutKnives.Filter + ' AND SequenceNo = ' + s;
      qExternalOutTimes.Filter := qExternalOutKnives.Filter + ' AND SequenceNo = ' + s;
      write(F, '/');
      str(qExternalOut.FieldByName('TicketNo').value : 4 : 0, s);
      write(F, s);
      qExternalOutKnives.Filter := qExternalOutKnives.Filter + ' AND TicketNo = ' + s;
      qExternalOutTimes.Filter := qExternalOutKnives.Filter + ' AND TicketNo = ' + s;
      write(F, ' ');
      s := Copy(qExternalOut.FieldByName('TagNo').asstring, 1, TagNoLength);
      write(F, s + StringOfChar(' ', TagNoLength - length(s)));
      write(F,' ');
      s := qExternalOut.FieldByName('Customer').asstring;
      write(F, s + StringOfChar(' ', 20 - length(s)));
      write(F,' ');
      s := qExternalOut.FieldByName('Style').asstring;
      write(F, s + StringOfChar(' ', 20 - length(s)));
      write(F,' ');
      s := qExternalOut.FieldByName('PartCode').asstring;
      write(F, s + StringOfChar(' ', 20 - length(s)));
      write(F,' ');
      s := qExternalOut.FieldByName('MaterialCode').asstring;
      write(F, s + StringOfChar(' ', 20 - length(s)));
      write(F,' ');
      s := qExternalOut.FieldByName('MaterialDescription').asstring;
      write(F, s + StringOfChar(' ', 30 - length(s)));
      write(F,' ');
      s := qExternalOut.FieldByName('MaterialCutType').asstring;
      write(F, s + StringOfChar(' ', 1 - length(s)));
      write(F,' ');
      if qExternalOut.FieldByName('MaterialType').asString[1] in Leathers then
      begin
        if qExternalOut.FieldByName('MaterialSkinTrimmed').value then
          s := 'Y'
        else
          s := 'N';
      end
      else
        s := qExternalOut.FieldByName('MaterialType').asstring;
      write(F, s + StringOfChar(' ', 1 - length(s)));
      write(F, ' ');
      str(qExternalOut.FieldByName('MaterialLayers').value : 2 : 0, s);
      write(F, s);
      write(F, ' ');
      str(qExternalOut.FieldByName('MaterialSkinSize').value : 5 : 2, s);
      write(F, s);
      write(F,' ');
      str(qExternalOut.FieldByName('MaterialWidth').value : 6 : 2, s);
      write(F, s);
      write(F, ' ');
      str(qExternalOut.FieldByName('TotalPairs').value : 5 : 0, s);
      write(F, s);
      write(F, ' ');
      str(qExternalOut.FieldByName('AdjFactorResult').value : 3 : 0, s);
      write(F, s);
      write(F, ' ');
      if SaveOutBasic = '1' then
        str(qExternalOut.FieldByName('AdjustedAllowance').value : 8 : 2, s)
      else
        str(qExternalOut.FieldByName('BasicAllowance').value : 8 : 5, s);
      write(F, s);
      write(F, ' ');
      str(qExternalOut.FieldByName('MaterialQualCoeff').value : 3 : 0, s);
      write(F, s);
      write(F, ' ');
      str(qExternalOut.FieldByName('MaterialLength').value : 6 : 2, s);
      write(F, s);
      write(F, ' ');
      str(qExternalOut.FieldByName('MaterialAreaCoeff').value : 3 : 0, s);
      write(F, s);
      write(F, ' ');
      str(qExternalOut.FieldByName('NoKnives').value : 3 : 0, s);
      write(F, s);
      write(F, ' ');

      s := '';
      try
        TS := TStringList.Create;
        TS.Text := qExternalOut.FieldByName('SpecialInstructions').value;
        if TS.Count > 0 then
        begin
          s := TS.Strings[0];
          for i := 0 to (TS.Count - 1) do
            s := s + '**' + TS.Strings[i];
        end;
      finally
        TS.Free;
      end;
      write(F, s);

      LastKnife := '';
      qExternalOutKnives.RecNo := 1; //CJY changed from qExternalOutKnives.First
      qExternalOutKnives.Prior; //CJY changed from qExternalOutKnives.First
      while not qExternalOutKnives.eof do
      begin
        if qExternalOutKnives.FieldByName('KnifeCode').asstring <> LastKnife then
        begin
          writeln(F,'');

          s := qExternalOutKnives.FieldByName('KnifeCode').asstring;
          write(F, s + StringOfChar(' ', 20 - length(s)));
          write(F,' ');
        end;

        s := qExternalOutKnives.FieldByName('Size').asstring;
        write(F, s + StringOfChar(' ', 10 - length(s)));
        write(F, ' ');

        str(qExternalOutKnives.FieldByName('Pairs').value : 5 : 0, s);
        write(F, s);
        write(F, ' ');

        LastKnife := qExternalOutKnives.FieldByName('KnifeCode').asstring;
        qExternalOutKnives.next;
      end;
      writeln(F, '');

      if Option_CuttingTimes then
      begin
        qExternalOutTimes.RecNo := 1; //CJY changed from qExternalOutTimes.First
        qExternalOutTimes.Prior; //CJY changed from qExternalOutTimes.First
        while not qExternalOutTimes.eof do
        begin
          str(qExternalOutTimes.FieldByName('Time').value : 9 : 2, s);
          write(F, s);
          qExternalOutTimes.next;
        end;
        writeln(F, '')
      end;

      qExternalOut.next;
    end;

    closefile(F);
    FileSaved := True;
  end;

  if Option_CuttingTimes then
    qExternalOutTimes.close;
  qExternalOutKnives.close;
  qExternalOut.close;

  screen.cursor := crDefault;

  if FileSaved then
    MessageDlgPos(FileName + ' file saved', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
end;

function TfmAllTickets.WeekSeqString(TableAlias: String): string;
var
  PrevWeekNo: integer;
  ORString: string;

begin
  SelectedCount := 0;
  qTicketSequences.DisableControls;
  qTicketSequences.RecNo := 1; //CJY changed from qTicketSequences.First
  qTicketSequences.Prior; //CJY changed from qTicketSequences.First

  if not(TableAlias = '') then
    TableAlias := TableAlias + '.';

  Result := '(';
  PrevWeekNo := 0;
  repeat
    if qTicketSequencesSelected.Value then
    begin
      inc(SelectedCount);
      if not(qTicketSequencesWeekNo.Value = PrevWeekNo) then
      begin
        ORString := '';
        if PrevWeekNo > 0 then
          Result := Result + ') ) OR (';

        PrevWeekNo := qTicketSequencesWeekNo.Value;
        Result := Result + ' (' + TableAlias + 'WeekNo = ' + IntToStr(PrevWeekNo) + ') AND ( ';
      end;

      Result := Result + ORString + '(' + TableAlias + 'SequenceNo = ' + IntToStr(qTicketSequencesSequenceNo.Value) + ') ';
      ORString := 'OR ';
    end;
    qTicketSequences.Next;
  until qTicketSequences.eof;

  Result := Result + ' ) ) ';

  //If blank then select none
  if Result = '( ) ) ' then
    Result := '1 = 0';

  qTicketSequences.EnableControls;
  qTicketSequences.RecNo := 1; //CJY changed from qTicketSequences.First
  qTicketSequences.Prior; //CJY changed from qTicketSequences.First
end;

procedure TfmAllTickets.btnPrintMaterialSummaryClick(Sender: TObject);
var
  SQLString: string;
  Failed: boolean;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  SQLString := WeekSeqString('TT');  //here because it also makes SelectedCount

  if SelectedCount = 0 then
    MessageDlgPos('No Tickets Selected', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else
  begin
    Failed := false;
    try
      fmfrMaterialSummary := TfmfrMaterialSummary.Create(fmAllTickets);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
    begin
      fmfrMaterialSummary.frMaterialSummary.ReportOptions.Name := 'Preview ' + Caption + ' (Material Summary)';
      ClosePreviewForm(Caption + ' (Material Summary)');

      fmfrMaterialSummary.MakeMaterialSummary(SQLString, ((Sender as TSpeedButton) = btnPreviewMaterialSummary));
    end;
  end;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllTickets.btnUpdatedOutClick(Sender: TObject);
begin
  sdFileOut.InitialDir := TicketsDirectory;

  if sdFileOut.Execute then
    SaveUpdatedOut(sdFileOut.FileName);
end;

procedure TfmAllTickets.SaveUpdatedOut(FileName: string);
var
  F: TextFile;
  s: string;
  FileSaved: boolean;
  TagNoLength: integer;

begin
  screen.cursor := crHourGlass;

  if ShortTagNo then
    TagNoLength := 25
  else
    TagNoLength := 55;

  FileSaved := False;

  qUpdatedOut.SQL.Text := 'SELECT TT.WeekNo, TT.SequenceNo, TT.TicketNo, TS.TagNo, TS.Customer, ' +
                                 'TT.PartCode, TT.PartDescription, TT.MaterialCode, TT.MaterialDescription, ' +
                                 'TT.TotalPairs, TT.MaterialAreaCoeff, TT.MaterialQualCoeff, ' +
                                 'TT.IssuedAllowance, TT.CostedAllowance, TT.ActualUsage, TT.MaterialUnits, ' +
                                 'TT.MatSupplier, TT.MatPrice, TT.CutWeek, TT.Cutter, TT.CutterLocation, TT.SMVs ' +
                          'FROM TicketSequences TS, TicketTickets TT ' +
                          'WHERE (' + WeekSeqString('TT') + ') AND ' +
                                'TT.WeekNo = TS.WeekNo AND ' +
                                'TT.SequenceNo = TS.SequenceNo ' +
                          'Order By TT.WeekNo, TT.WeekNo, TT.SequenceNo, TT.TicketNo';

  qUpdatedOut.open;

  if qUpdatedOut.IsEmpty then
    MessageDlgPos('No created tickets selected', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else
  begin
    assignfile(F,FileName);
    rewrite(F);

    qUpdatedOut.RecNo := 1; //CJY changed from qUpdatedOut.First
    qUpdatedOut.Prior; //CJY changed from qUpdatedOut.First
    while not qUpdatedOut.eof do
    begin
      str(qUpdatedOut.FieldByName('WeekNo').value : 2 : 0, s);
      write(F, s);
      write(F, '/');
      str(qUpdatedOut.FieldByName('SequenceNo').value : 5 : 0, s);
      write(F, s);
      write(F, '/');
      str(qUpdatedOut.FieldByName('TicketNo').value : 4 : 0, s);
      write(F, s);
      write(F, ' ');
      s := Copy(qUpdatedOut.FieldByName('TagNo').asstring, 1, TagNoLength);
      write(F, s + StringOfChar(' ', TagNoLength - length(s)));
      write(F,' ');
      s := qUpdatedOut.FieldByName('Customer').asstring;
      write(F, s + StringOfChar(' ', 20 - length(s)));
      write(F,' ');
      s := qUpdatedOut.FieldByName('PartCode').asstring;
      write(F, s + StringOfChar(' ', 20 - length(s)));
      write(F,' ');
      s := qUpdatedOut.FieldByName('PartDescription').asstring;
      write(F, s + StringOfChar(' ', 30 - length(s)));
      write(F,' ');
      s := qUpdatedOut.FieldByName('MaterialCode').asstring;
      write(F, s + StringOfChar(' ', 20 - length(s)));
      write(F,' ');
      s := qUpdatedOut.FieldByName('MaterialDescription').asstring;
      write(F, s + StringOfChar(' ', 30 - length(s)));
      write(F,' ');
      str(qUpdatedOut.FieldByName('TotalPairs').value : 5 : 0, s);
      write(F, s);
      write(F, ' ');
      str(qUpdatedOut.FieldByName('MaterialAreaCoeff').value : 3 : 0, s);
      write(F, s);
      write(F, ' ');
      str(qUpdatedOut.FieldByName('MaterialQualCoeff').value : 3 : 0, s);
      write(F, s);
      write(F, ' ');
      if not qUpdatedOut.FieldByName('IssuedAllowance').isNull then
        str(qUpdatedOut.FieldByName('IssuedAllowance').value : 9 : 3, s)
      else
        s := '         ';
      write(F, s);
      write(F, ' ');
      if not qUpdatedOut.FieldByName('CostedAllowance').isNull then
        str(qUpdatedOut.FieldByName('CostedAllowance').value : 9 : 3, s)
      else
        s := '         ';
      write(F, s);
      write(F, ' ');
      if not qUpdatedOut.FieldByName('ActualUsage').isNull then
        str(qUpdatedOut.FieldByName('ActualUsage').value : 9 : 3, s)
      else
        s := '         ';
      write(F, s);
      write(F, ' ');
      if ExtendedUpdatedOUT then
      begin
        s := qUpdatedOut.FieldByName('MaterialUnits').asstring;
        write(F, s + StringOfChar(' ', 20 - length(s)));
        write(F,' ');
        str(qUpdatedOut.FieldByName('MatPrice').value : 6 : 2, s);
        write(F, s);
        write(F, ' ');
        str(qUpdatedOut.FieldByName('CutWeek').value : 2 : 0, s);
        write(F, s);
        write(F, ' ');
        s := qUpdatedOut.FieldByName('Cutter').asstring;
        write(F, s + StringOfChar(' ', 20 - length(s)));
        write(F,' ');
        s := qUpdatedOut.FieldByName('CutterLocation').asstring;
        write(F, s + StringOfChar(' ', 20 - length(s)));
        write(F,' ');
        str(qUpdatedOut.FieldByName('SMVs').value : 9 : 3, s);
        write(F, s);
        write(F,' ');
        s := qUpdatedOut.FieldByName('MatSupplier').asstring;
        write(F, s + StringOfChar(' ', 20 - length(s)));
      end;
      writeln(F, '');

      qUpdatedOut.next;
    end;

    closefile(F);

    FileSaved := True;
  end;

  qUpdatedOut.close;

  screen.cursor := crDefault;

  if FileSaved then
    MessageDlgPos(FileName + ' file saved', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
end;

procedure TfmAllTickets.sdFileOutShow(Sender: TObject);
var
  dlgRect: TRect;

begin
  //Believed to work the first time but windows overrides the location after this
  //  to the last location of the OpenDialog.
  with sdFileOut do
  begin
    GetWindowRect(GetParent(handle), dlgRect);
    SetWindowPos(GetParent(handle), 0, Application.MainForm.Left + (Application.MainForm.Width div 3), Application.MainForm.Top + (Application.MainForm.Height div 3), 0, 0, SWP_NOSIZE);
    Abort;
  end;
end;

procedure TfmAllTickets.ineSearchEndKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllTickets.ineSearchStartKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllTickets.tblTicketSequencesBeforeInsert(DataSet: TDataSet);
begin
  abort;
end;

procedure TfmAllTickets.tblTicketSequencesBeforeDelete(DataSet: TDataSet);
begin
  abort;
end;

procedure TfmAllTickets.FinishSecondProcess(Sender: TObject);
begin
  SecondProcessInUse := False;
end;

procedure TfmAllTickets.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not SecondProcessInUse;

  if SecondProcessInUse then
    MessageDlgPos('Cannot close whilst creating tickets', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
end;

procedure TfmAllTickets.FormShow(Sender: TObject);
begin
  btnGroupDelete.Enabled := AllowGroupDeleteTickets;
end;

procedure TfmAllTickets.dbgGroupTicketsColumnMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
begin
  ColumnSelectedPosition := GetColumnSelectedPosition3(dbgGroupTickets, 5);
end;

procedure TfmAllTickets.qTicketSequencesAfterOpen(DataSet: TDataSet);
begin
  //CJY: qTicketSequences.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qTicketSequences.RecordCount + 1);
  FillArray(False);

  qTicketSequences.OnCalcFields := qTicketSequencesCalcFields;
end;

procedure TfmAllTickets.qTicketSequencesAfterScroll(DataSet: TDataSet);
begin
  //CJY - qConstructions.RecNo sometimes returns 0 when attached to a DataGrid (when
  //      using .First and .Last). When scrolling is is possible to miss the first
  //      last values, especially when jumping to the start or the end (Ctrl + Home).
  if not (DataSet.FieldByName('RecNo').AsInteger > 0) then
    DataSet.Refresh;
end;

procedure TfmAllTickets.qTicketSequencesBeforeOpen(DataSet: TDataSet);
begin
  qTicketSequences.OnCalcFields := Nil;
end;

procedure TfmAllTickets.qTicketSequencesCalcFields(DataSet: TDataSet);
begin
  //CJY - Recording return of RecNo for workaround RecNo = 0 issue
  DataSet.FieldByName('RecNo').AsInteger := DataSet.RecNo;

  if btnGroup.Down then
    if JustDown then
      qTicketSequencesSelected.Value := False
    else
      if (qTicketSequences.RecNo < Length(Selected)) then
        qTicketSequencesSelected.Value := Selected[qTicketSequences.RecNo];
end;

procedure TfmAllTickets.dbgGroupTicketsCellClick(Column: TColumn);
begin
  if Column.Field.FieldName = 'Selected' then
    Selected[qTicketSequences.RecNo] := not(Selected[qTicketSequences.RecNo]);
end;

procedure TfmAllTickets.ineSearchEndChange(Sender: TObject);
begin
  if (Sender as TPBNumEdit).Value = ActiveSearchEnd then
  begin
    (Sender as TPBNumEdit).Font.Color := clData;
    btnPrintPreview.Enabled := True;
    btnPrint.Enabled := True;
  end
  else
  begin
    (Sender as TPBNumEdit).Font.Color := clRed;
    btnPrintPreview.Enabled := False;
    btnPrint.Enabled := False;
  end;
end;

procedure TfmAllTickets.ineSearchStartChange(Sender: TObject);
begin
  if (Sender as TPBNumEdit).Value = ActiveSearchStart then
  begin
    (Sender as TPBNumEdit).Font.Color := clData;
    btnPrintPreview.Enabled := True;
    btnPrint.Enabled := True;
  end
  else
  begin
    (Sender as TPBNumEdit).Font.Color := clRed;
    btnPrintPreview.Enabled := False;
    btnPrint.Enabled := False;
  end;
end;

procedure TfmAllTickets.ineEndSeqChange(Sender: TObject);
begin
  if ineEndSeq.Value = ActiveSeqEnd then
  begin
    ineEndSeq.Font.Color := clData;
    btnPrintPreview.Enabled := True;
    btnPrint.Enabled := True;
  end
  else
  begin
    ineEndSeq.Font.Color := clRed;
    btnPrintPreview.Enabled := False;
    btnPrint.Enabled := False;
  end;
end;

procedure TfmAllTickets.ineStartSeqChange(Sender: TObject);
begin
  if ineStartSeq.Value = ActiveSeqStart then
  begin
    ineStartSeq.Font.Color := clData;
    btnPrintPreview.Enabled := True;
    btnPrint.Enabled := True;
  end
  else
  begin
    ineStartSeq.Font.Color := clRed;
    btnPrintPreview.Enabled := False;
    btnPrint.Enabled := False;
  end;
end;

procedure TfmAllTickets.LocalConnectionSummsBeforeConnect(Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmAllTickets.btnSyntheticsTicketsListClick(Sender: TObject);
begin
  OpenSyntheticsTicketsList;
end;

function TfmAllTickets.OpenSyntheticsTicketsList: Boolean;
var
  WeekNosString: string;
  SyntheticsListCreated: Boolean;

begin
  screen.Cursor := crHourGlass;

  WeekNosString := WeekSeqString('TS');

  try
    if SelectedCount = 0 then
      MessageDlgPos('No Tickets Selected', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
    begin
      SyntheticsListCreated := False;
      fmSyntheticTicketsList := TfmSyntheticTicketsList.create(fmSumms);
      fmSyntheticTicketsList.CreateQuery(WeekNosString);
      SyntheticsListCreated := True;
    end;
  except
    fmMemoryError.TidyUp(self);
  end;

  screen.Cursor := crDefault;

  Result := SyntheticsListCreated;
end;

end.


