unit TicketsBreakdown;

interface

uses
  Windows, Messages, Classes, Controls, Forms, StdCtrls, ExtCtrls, Grids, DBGridPlus,
  Mask, DBCtrls, Buttons, ToolWin, ComCtrls, Db, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,
  XStringGrid, XStringGridPlus, frxClass, frxDBSet, frxCross, Tabload, FireDAC.UI.Intf, DBGrids,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys;

type
  TDBGridEdit = class(TDBGridPlus);
  TfmTicketsBreakdown = class(TForm)
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnDelete: TSpeedButton;
    pcTicketsBreakdown: TPageControl;
    tsPairage: TTabSheet;
    tsTickets: TTabSheet;
    dbgTickets: TDBGridPlus;
    sgPairage: TXStringGridPlus;
    dsGetPairage: TDataSource;
    qUpdatePairage: TFDQueryPlus;
    qChangeTicketsInput: TFDQueryPlus;
    sgCompareGrid: TXStringGridPlus;
    btnCreate: TSpeedButton;
    sbTicketsBreakdown: TStatusBar;
    lblGetWidth: TLabel;
    dsTicketTickets: TDataSource;
    tblTicketTickets: TFDTablePlus;
    tblTicketSequences: TFDTablePlus;
    dsTicketSequences: TDataSource;
    tblTicketTicketsFullTicketNumber: TStringField;
    tblTicketTicketsWeekNo: TSmallintField;
    tblTicketTicketsSequenceNo: TSmallintField;
    tblTicketTicketsTicketNo: TSmallintField;
    tblTicketTicketsPartCode: TStringField;
    tblTicketTicketsPartDescription: TStringField;
    tblTicketTicketsMaterialCode: TStringField;
    tblTicketTicketsMaterialDescription: TStringField;
    tblTicketTicketsMaterialType: TStringField;
    tblTicketTicketsMaterialCutType: TStringField;
    tblTicketTicketsMaterialLength: TFloatField;
    tblTicketTicketsMaterialWidth: TFloatField;
    tblTicketTicketsMaterialSkinSize: TFloatField;
    tblTicketTicketsMaterialSkinTrimmed: TBooleanField;
    tblTicketTicketsMaterialUnits: TStringField;
    tblTicketTicketsMaterialLayers: TSmallintField;
    tblTicketTicketsAdjFactorResult: TSmallintField;
    tblTicketTicketsCutWeek: TSmallintField;
    tblTicketTicketsCutter: TStringField;
    tblTicketTicketsCutterLocation: TStringField;
    tblTicketTicketsQuality: TSmallintField;
    tblTicketTicketsIssuedAllowance: TFloatField;
    tblTicketTicketsCostedAllowance: TFloatField;
    tblTicketTicketsActualUsage: TFloatField;
    tblTicketTicketsSMVs: TFloatField;
    tblTicketTicketsBulked: TBooleanField;
    tblTicketTicketsCostedResult: TFloatField;
    tblTicketTicketsTotalPairs: TSmallintField;
    tblTicketTicketsMatSupplier: TStringField;
    tblTicketTicketsMatPrice: TCurrencyField;
    tblTicketTicketsSpecialInstructions: TMemoField;
    tblTicketSequencesWeekNo: TSmallintField;
    tblTicketSequencesSequenceNo: TSmallintField;
    tblTicketSequencesStyle: TStringField;
    tblTicketSequencesConstruction: TStringField;
    tblTicketSequencesCustomer: TStringField;
    qClearTickets: TFDQueryPlus;
    qGetPairage: TFDQueryPlus;
    qGetPairageWidth: TStringField;
    qGetPairageSize: TStringField;
    qGetPairagePairs: TIntegerField;
    tblTicketTicketsPrinted: TBooleanField;
    tblTicketTicketsPrintYN: TStringField;
    tblTicketTicketsPrintedYN: TStringField;
    tblTicketTicketsPrint: TBooleanField;
    btnCopy: TSpeedButton;
    btnClearPairage: TSpeedButton;
    tblTicketTicketsID: TIntegerField;
    btnClearTickets: TSpeedButton;
    btnRefresh: TSpeedButton;
    pnlTop: TPanel;
    lblStyle: TLabel;
    dbtConstruction: TDBText;
    lblConstruction: TLabel;
    btnUpdateTickets: TSpeedButton;
    qTicketsToUpdate: TFDQueryPlus;
    tblTicketSequencesAllPrinted: TBooleanField;
    tblTicketTicketsArea: TSmallintField;
    PairsCell: TEditCellEditor;
    tblTicketSequencesLinesInLeatherGrid: TIntegerField;
    tblTicketSequencesRowsInLeatherGrid: TIntegerField;
    qAddToAudit: TFDQueryPlus;
    dbtStyle: TDBText;
    pnlKeepPreview: TPanel;
    btnPrintMaterialSummary: TSpeedButton;
    btnPrintPreviewMaterialSummary: TSpeedButton;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    lblTagNumber: TLabel;
    lblCustomerReference: TLabel;
    dbeTagNo: TDBEdit;
    dbeCustomerRef: TDBEdit;
    pnlView1: TPanel;
    dbtTagNo: TDBText;
    pnlView2: TPanel;
    dbtCustomerRef: TDBText;
    tblTicketTicketsSLMAllowance: TBooleanField;
    tblTicketSequencesMadeInPairs: TBooleanField;
    tblTicketSequencesConstrucMadeInPairs: TBooleanField;
    qGetMadeInPairsFromConstruction: TFDQueryPlus;
    qGetMadeInPairsFromConstructionMadeInPairs: TBooleanField;
    tblTicketSequencesTagNo: TStringField;
    tlFillCompareGrid: TTabularLoad;
    tlMakeGrid: TTabularLoad;
    qTrans: TFDQueryPlus;
    qStyleConstructionExists: TFDQueryPlus;
    procedure PassTicketSequenceReference(TicketForm : TfmTicketsBreakdown; WeekNo, SequenceNo : integer);
    function MakeTIQuery(WeekNo, SequenceNo : string; WhichLine1 : short) : string;
    function MakeTCGQuery(WeekNo, SequenceNo : string; WhichLine1 : short) : string;
    function TicketGridChanged: boolean;
    procedure UpdatePairageScreen;
    procedure UpdateTicketsScreen;
    procedure btnCreateClick(Sender: TObject);
    procedure btnEditPairsClick(Sender: TObject);
    procedure btnSavePairsClick(Sender: TObject);
    procedure btnCancelPairsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnClearPairageClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pcTicketsBreakdownChange(Sender: TObject);
    procedure EncodeAddWidths;
    procedure CalcPairsOnWidths;
    procedure sgPairageSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgPairageSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure btnDeleteClick(Sender: TObject);
    procedure sgPairageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sgPairageDblClick(Sender: TObject);
    procedure SetAddWidthsFlag;
    procedure sgPairageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AddTotalsColumn;
    procedure SetWidthTitlesWidth;
    procedure SetDataColumnWidths;
    procedure SetFormWidth;
    procedure SetUpPairageGrid;
    procedure btnCopyClick(Sender: TObject);
    procedure tblTicketTicketsCalcFields(DataSet: TDataSet);
    procedure btnPrintClick(Sender: TObject);
    procedure dbgTicketsDblClick(Sender: TObject);
    procedure btnPrintMaterialSummaryClick(Sender: TObject);
    procedure UpdateButtonsState;
    procedure tblTicketTicketsBeforeDelete(DataSet: TDataSet);
    procedure tblTicketTicketsBeforeInsert(DataSet: TDataSet);
    procedure pcTicketsBreakdownChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure btnClearTicketsClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    function BlankGrid: boolean;
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateTicketsClick(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure dbgTicketsKeyPress(Sender: TObject; var Key: Char);
    procedure dbtStyleDblClick(Sender: TObject);
    procedure dbtConstructionDblClick(Sender: TObject);
    procedure SetTabStops(Editing: Boolean);
    procedure pcTicketsBreakdownDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure SetUpQueriesForPrinting;
    procedure CloseQueries;
    procedure SetPairageGridColors;
  private
    { Private declarations }
    fmTicketsBreakdown: TfmTicketsBreakdown;
    TIQuery, TCGQuery: string;
    Editing: Boolean;
    TotalPairs, TotalWidth: integer;
  public
    { Public declarations }
    TicketCode: string;
    iWeekNo, iSequenceNo: integer;
    sWeekNo, sSequenceNo, Style, Construction: string;
    FromNew, JustClicked: boolean;
    CellColumn, CellRow, XMouse, YMouse: integer;
    procedure TC();
  end;

implementation

uses
  SysUtils, Graphics, Dialogs, NewTicket, Summs, TicketsCreate, CopyTicket,
  OutOfMemory, fr_Ticket, fr_MaterialSummary, TktUpdate, General,
  SummsVars, CmnVars, TicketsGeneral, TicketsAllDM, PartDetails, MaterialDetails,
  AdvErrorHandler, StyleDetails, ConstructionDetails, Dongle_Green;

{$R *.DFM}

procedure TfmTicketsBreakdown.TC();
begin
  qTrans.Close;
  qTrans.Open;
  ShowMessage(IntToStr(qTrans.FieldByName('TC').AsInteger));
end;


function TfmTicketsBreakdown.TicketGridChanged: boolean;
var
  Changed, ChangeConnection, CarryTransaction, updated: boolean;
  CarryTransactionCount: integer;
  slSQL: TStrings;

begin
  screen.cursor := crHourGlass;
  sbTicketsBreakdown.Panels[1].Text := 'Preparing...';
  sbTicketsBreakdown.Refresh;

  if not dmTicketsAll.LocalConnectionSumms.Connected then
    dmTicketsAll.LocalConnectionSumms.Connected := true;

  dmTicketsAll.LocalConnectionSumms.StartTransaction;

  Changed := False;

  dmTicketsAll.FillCompareGrid(sWeekNo, sSequenceNo, Style);
  try
    dmTicketsAll.qReadCompareGrid.paramByName('Identifier').value := Identifier;
    dmTicketsAll.qReadCompareGrid.paramByName('WeekNo').AsInteger := iWeekNo;
    dmTicketsAll.qReadCompareGrid.paramByName('SequenceNo').AsInteger := iSequenceNo;
    dmTicketsAll.qReadCompareGrid.Open;

    //CJY: dmTicketsAll.qReadCompareGrid.FetchOptions.RecordCountMode set to cmTotal
    if (dmTicketsAll.qReadCompareGrid.RecordCount > 0) then
    begin
      TIQuery := MakeTIQuery(sWeekNo, sSequenceNo, 3);
      TCGQuery := MakeTCGQuery(sWeekNo, sSequenceNo, 2);
      dmTicketsAll.qCompareGrids.SQL.Text := TIQuery + ' UNION ' + TCGQuery;
      dmTicketsAll.qCompareGrids.Open;

      //CJY: dmTicketsAll.qCompareGrids.FetchOptions.RecordCountMode set to cmTotal
      if dmTicketsAll.qCompareGrids.RecordCount > 0 then
      begin
        Changed := TRUE;
        if MessageDlg('Widths/Sizes on Style now differ from Ticket -' + #13 +
                      'Update grid and keep quantities where possible?', mtInformation, [mbYes, mbNo], 0) = mrYes then
        begin
          dmTicketsAll.qCompareGrids.Close;

          //Had to split this into 2 queries instead of a script
          //because if there's nothing to delete it crashes with
          //exception 2138 - "No data found" and fails to run
          //the INSERT line of the script.

          try
//            dmTicketsAll.LocalConnectionSumms.StartTransaction;

            qChangeTicketsInput.SQL.Text := 'SELECT DISTINCT Ti.WidthNo AS WidthNo, Ti.Width AS WidthOld, Wi.Width AS WidthNew FROM TicketsInput Ti ' +
                                              'JOIN Widths Wi ON Ti.WidthNo = Wi.No AND Ti.Width <> Wi.Width ' +
                                              'WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' + sSequenceNo + ';';
            qChangeTicketsInput.Open;

            qChangeTicketsInput.RecNo := 1;
            qChangeTicketsInput.Prior;

            slSQL := TStringList.Create();
            slSQL.Clear;
            while not qChangeTicketsInput.Eof do
            begin
              slSql.Add('UPDATE TicketsInput SET Width = ''' + qChangeTicketsInput.FieldByName('WidthNew').AsString + ''' ' +
                          'WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' + sSequenceNo + ' AND ' +
                            'WidthNo = '+ qChangeTicketsInput.FieldByName('WidthNo').AsString + ' AND ' +
                            'Width = ''' + qChangeTicketsInput.FieldByName('WidthOld').AsString + ''';');
              qChangeTicketsInput.Next;
            end;

            while slSQL.Count > 0 do
            begin
              qChangeTicketsInput.SQL.Text := slSQL[0];
              qChangeTicketsInput.ExecSQL;
              slSQL.Delete(0);
            end;

            FreeAndNil(slSQL);

            dmTicketsAll.FillCompareGrid(sWeekNo, sSequenceNo, Style);

            dmTicketsAll.qReadCompareGrid.Close;
            dmTicketsAll.qReadCompareGrid.Open;
            if (dmTicketsAll.qReadCompareGrid.RecordCount > 0) then
            begin
              dmTicketsAll.qCompareGrids.Close;
              dmTicketsAll.qCompareGrids.Open;
              updated := (dmTicketsAll.qCompareGrids.RecordCount = 0);
            end
            else
              updated := false;
          except
            updated := false;
          end;

          if updated then
          begin
            dmTicketsAll.LocalConnectionSumms.Commit;
          end
          else
          begin
            dmTicketsAll.LocalConnectionSumms.Rollback;
            try
              dmTicketsAll.LocalConnectionSumms.StartTransaction;
              qChangeTicketsInput.SQL.Text := 'DELETE FROM TicketsInput ' +
                                              'WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' + sSequenceNo + ' AND ' +
                                              '(Width IN (' + MakeTIQuery(sWeekNo, sSequenceNo, 1) + ')) AND (Size IN (' +
                                               MakeTIQuery(sWeekNo, sSequenceNo, 2) + '));';
              qChangeTicketsInput.ExecSQL;

//              qChangeTicketsInput.SQL.Text := 'INSERT INTO TicketsInput ' + MakeTCGQuery(sWeekNo, sSequenceNo, 1) + ';';
              qChangeTicketsInput.SQL.Text := 'INSERT INTO TicketsInput (Width, Weekno, SequenceNo, Size, Pairs, WidthNo, SizeSeq) ' +
                                             'SELECT DISTINCT(Width), ' + sWeekNo + ', ' + sSequenceNo + ', ''AddWidth'', 1, No, 0 ' +
                                             'FROM TicketSequences TS, Widths W, WRngWs WRW, Parts P, ConParts CP, Styles S, SizeRangeSizes SRS, Construc C ' +
                                               'WHERE W.No = WRW.WidthNo AND WRW.Range = P.WidthRange AND ' +
                                               'P.Code = CP.Part AND CP.Construction = S.CurrentCon AND ' +
                                               'SRS.Range = C.SizeRange AND C.Construction = S.CurrentCon AND ' +
                                               'S.Style = ''' + QS(Style) + ''' AND TS.WeekNo = ' + sWeekNo + ' AND ' +
                                               'TS.SequenceNo = ' + sSequenceNo + ' AND ' +
                                               'W.Width IN (SELECT W.Width ' +
                                                           'FROM PtWidKnf PWK, Widths W, Parts P, WRngWs WRW ' +
                                                           'WHERE PWK.Seq = 1 AND ' +
                                                                 'PWK.Part IN (SELECT Part ' +
                                                                              'FROM ConParts ' +
                                                                              'WHERE Construction IN (SELECT CurrentCon ' +
                                                                                                     'FROM Styles ' +
                                                                                                     'WHERE Style = ''' + QS(Style) + ''')) AND ' +
                                                                 'P.Code = PWK.Part AND ' +
                                                                 'WRW.Range = P.WidthRange AND ' +
                                                                 'WRW.WidthNo = PWK.WidthNo AND '+
                                                                 'PWK.WidthNo = W.No ' +
                                                          'GROUP BY W.Width ' +
                                                          'HAVING COUNT(*) = (SELECT COUNT(*) FROM ConParts ' +
                                                                             'WHERE Construction IN (SELECT CurrentCon ' +
                                                                                                    'FROM Styles ' +
                                                                                                    'WHERE Style = ''' + QS(Style) + '''))) ' +
                                                'GROUP BY WeekNo, SequenceNo, W.Width, W.No, SRS.Seq;' + #13 +
                                                'INSERT INTO TicketsInput (Size, Weekno, SequenceNo, Width, WidthNo, SizeSeq, Pairs) ' +
                                                'SELECT DISTINCT(SRS.Size), ' + sWeekNo + ', ' + sSequenceNo + ', W.Width, W.No, SRS.Seq, 0 ' +
                                                'FROM TicketSequences TS, Widths W, WRngWs WRW, Parts P, ConParts CP, Styles S, SizeRangeSizes SRS, Construc C ' +
                                                'WHERE W.No = WRW.WidthNo AND WRW.Range = P.WidthRange AND ' +
                                                  'P.Code = CP.Part AND CP.Construction = S.CurrentCon AND ' +
                                                  'SRS.Range = C.SizeRange AND C.Construction = S.CurrentCon AND ' +
                                                  'S.Style = ''' + QS(Style) + ''' AND TS.WeekNo = ' + sWeekNo + ' AND ' +
                                                  'TS.SequenceNo = ' + sSequenceNo + ' AND ' +
                                                  'W.Width IN (SELECT W.Width ' +
                                                              'FROM PtWidKnf PWK, Widths W, Parts P, WRngWs WRW ' +
                                                              'WHERE PWK.Seq = 1 AND ' +
                                                                    'PWK.Part IN (SELECT Part ' +
                                                                                 'FROM ConParts ' +
                                                                                 'WHERE Construction IN (SELECT CurrentCon ' +
                                                                                                        'FROM Styles ' +
                                                                                                        'WHERE Style = ''' + QS(Style) + ''')) AND ' +
                                                                    'P.Code = PWK.Part AND ' +
                                                                    'WRW.Range = P.WidthRange AND ' +
                                                                    'WRW.WidthNo = PWK.WidthNo AND '+
                                                                    'PWK.WidthNo = W.No ' +
                                                             'GROUP BY W.Width ' +
                                                             'HAVING COUNT(*) = (SELECT COUNT(*) FROM ConParts ' +
                                                                                'WHERE Construction IN (SELECT CurrentCon ' +
                                                                                                       'FROM Styles ' +
                                                                                                       'WHERE Style = ''' + QS(Style) + '''))) ' +
                                                  'GROUP BY W.Width, W.No, P.Code, SRS.Seq, SRS.Size;';
              qChangeTicketsInput.ExecSQL;
              dmTicketsAll.LocalConnectionSumms.Commit;
            except
              dmTicketsAll.LocalConnectionSumms.Rollback;
            end;
          end;

          btnRefresh.Click;
{
          qGetPairage.Close;
          qGetPairage.Open;
          tlMakeGrid.Execute;
          tlFillCompareGrid.Execute;
          SetUpPairageGrid;
}
        end;
      end;
    end
    else
    begin
      messagedlg('Style, Construction or Part deleted or empty' + #13 + 'OR' + #13 +
                 'Construction has duplicate Parts' + #13 + 'OR' + #13 +
                 'Parts have no common width(s).', mtInformation, [mbOK], 0);
      Changed := TRUE;
    end;

    dmTicketsAll.qReadCompareGrid.Close;
  finally
    dmTicketsAll.qClearCompareGrid.paramByName('Identifier').value := Identifier;
    dmTicketsAll.qClearCompareGrid.paramByName('WeekNo').AsInteger := iWeekNo;
    dmTicketsAll.qClearCompareGrid.paramByName('SequenceNo').AsInteger := iSequenceNo;
    dmTicketsAll.qClearCompareGrid.execSQL;
  end;

  dmTicketsAll.LocalConnectionSumms.Commit;

  screen.cursor := crDefault;

  Result := Changed;
end;

procedure TfmTicketsBreakdown.btnEditPairsClick(Sender: TObject);
var
   LockSuccess: boolean;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    dmTicketsAll.LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oTicket, fmSumms.tblLocks, tblTicketSequences, TicketCode, True);

    if LockSuccess then
    begin
      btnRefresh.Click;
{
      tlMakeGrid.Execute;
      SetUpPairageGrid;

      tblTicketTickets.refresh;
      dbgTickets.refresh;
}
      if pcTicketsBreakdown.ActivePage = tsPairage then
      begin
        if tblTicketTickets.Recordcount > 0 then
          messagedlg('Ticket ' + TicketCode + ' already created', mtInformation, [mbOk], 0)
        else
        begin
          Editing := True;
          UpdatePairageScreen;
        end;
      end
      else
      begin
        if tblTicketTickets.Recordcount = 0 then
          messagedlg('Ticket ' + TicketCode + ' not yet created', mtInformation, [mbOk], 0)
        else
        begin
          Editing := True;
          UpdateTicketsScreen;
        end;
      end;

      if not Editing then
      begin
        //Unlock
        tblTicketSequences.cancel;
        dmTicketsAll.LocalConnectionSumms.Rollback;
      end;
    end
    else
      dmTicketsAll.LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmTicketsBreakdown.CalcPairsOnWidths;
var
  i, j, PairsOnWidth :integer;

begin
  TotalPairs := 0;
  for j := 1 to sgPairage.RowCount - 1 do
  begin
    PairsOnWidth := 0;
    for i := 2 to sgPairage.ColCount - 2 do
      if sgPairage.Cells[i, j] <> '' then
        PairsOnWidth := PairsOnWidth + StrToInt(sgPairage.Cells[i, j]);
    sgPairage.Cells[sgPairage.ColCount - 1, j] := IntToStr(PairsOnWidth);
    TotalPairs := TotalPairs + PairsOnWidth;
    sbTicketsBreakdown.Panels[0].Text := 'Total: ' + IntToStr(TotalPairs);
  end;
end;

procedure TfmTicketsBreakdown.AddTotalsColumn;
begin
  sgPairage.ColCount := sgPairage.ColCount + 1;
  sgPairage.Cells[sgPairage.ColCount - 1, 0] := 'Total';
  sgPairage.ColWidths[sgPairage.ColCount - 1] := 50;
end;

procedure TfmTicketsBreakdown.SetWidthTitlesWidth;
var
  i, MaxWidth : integer;

begin
  MaxWidth := 0;
  for i := 1 to sgPairage.RowCount -1 do
  begin
    lblGetWidth.Caption := sgPairage.Cells[0, i];
    if lblGetWidth.Width > MaxWidth then
      MaxWidth := lblGetWidth.Width;
  end;
  sgPairage.ColWidths[0] := MaxWidth + 15;
end;

procedure TfmTicketsBreakdown.SetDataColumnWidths;
var
  i, MaxWidth : integer;

begin
  sgPairage.ColWidths[1] := 35;  //Add column is a constant 35 width.

  MaxWidth := 0;
  for i := 2 to sgPairage.ColCount - 2 do
  begin
    lblGetWidth.Caption := sgPairage.Cells[i,0];
    if lblGetWidth.Width > MaxWidth then
      MaxWidth := lblGetWidth.Width;
  end;

  if MaxWidth + 10 < 35 then
    MaxWidth := 35
  else
    MaxWidth := MaxWidth + 10;

  for i := 2 to sgPairage.ColCount - 2 do
    sgPairage.ColWidths[i] := MaxWidth;
end;

procedure TfmTicketsBreakdown.SetFormWidth;
var
  i : integer;

begin
  TotalWidth := 35;
  for i := 0 to sgPairage.ColCount - 1 do
    TotalWidth := TotalWidth + sgPairage.ColWidths[i];
end;

procedure TfmTicketsBreakdown.EncodeAddWidths;
var
  i : integer;

begin
  sgPairage.Cells[1, 0] := 'Add';
  sgCompareGrid.Cells[1, 0] := 'Add';

  for i := 1 to sgPairage.RowCount - 1 do
  begin
    if sgPairage.Cells[1, i] = '0' then
    begin
      sgPairage.Cells[1, i] := 'No';
      sgCompareGrid.Cells[1, i] := 'No';
    end
    else
    begin
      sgPairage.Cells[1, i] := 'Yes';
      sgCompareGrid.Cells[1, i] := 'Yes';
    end;
  end;
  CalcPairsOnWidths;
end;

procedure TfmTicketsBreakdown.SetUpPairageGrid;
begin
  if (not BlankGrid) then
    AddTotalsColumn;
  SetWidthTitlesWidth;
  SetDataColumnWidths;
  SetFormWidth;
  EncodeAddWidths;
  SetPairageGridColors;

  sgPairage.visible := true;
end;

procedure TfmTicketsBreakdown.btnSavePairsClick(Sender: TObject);
var
  i, j : integer;
  SQLString: string;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if pcTicketsBreakdown.ActivePage = tsPairage then
    begin
      Editing := False;
      UpdatePairageScreen;

      qUpdatePairage.SQL.Clear;
      SQLString := '';

      for i := 1 to sgPairage.ColCount - 2 do
        for j := 1 to sgPairage.RowCount - 1 do
        begin
          if i = 1 then
          begin
            if not(sgPairage.Cells[i, j] = sgCompareGrid.Cells[i, j]) then
            begin
              if sgPairage.Cells[1, j] = 'No' then
                SQLString := SQLString + 'UPDATE TicketsInput SET Pairs = 0' +
                                         ' WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' +
                                         sSequenceNo + ' AND Width = ''' + QS(sgPairage.Cells[0, j]) +
                                         ''' AND Size = ''AddWidth'';' + #13
              else
                SQLString := SQLString + 'UPDATE TicketsInput SET Pairs = 1' +
                                         ' WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' +
                                          sSequenceNo + ' AND Width = ''' + QS(sgPairage.Cells[0, j]) +
                                         ''' AND Size = ''AddWidth'';' + #13;
            end;
          end
          else
            if not(sgPairage.Cells[i, j] = sgCompareGrid.Cells[i, j]) then
              SQLString := SQLString + 'UPDATE TicketsInput SET Pairs = ' + sgPairage.Cells[i, j] +
                                       ' WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' +
                                       sSequenceNo + ' AND Width = ''' + QS(sgPairage.Cells[0, j]) +
                                       ''' AND Size = ''' + QS(sgPairage.Cells[i, 0]) + ''';' + #13;
        end;

      if not(SQLString = '') then
      begin
        qUpdatePairage.SQL.Text := SQLString;
        qUpdatePairage.ExecSQL;
      end;

      SetPairageGridColors;
    end
    else
    begin
      try
        if (tblTicketTickets.state in [dsEdit, dsInsert]) then
          tblTicketTickets.post;
      except
      end;

      Editing := False;
      UpdateTicketsScreen;

      dbgTickets.Options := dbgTickets.Options - [dgEditing];
      dbgTickets.EditorMode := false;
    end;

    //Release lock & Post any changes to TagNo, CustomerNo
    if (tblTicketSequences.state in [dsEdit, dsInsert]) then
      tblTicketSequences.post;

    dmTicketsAll.LocalConnectionSumms.commit;

    btnRefresh.Click;
    //CJY FireDAC needs to refresh query results after alterations to source tables.
{
    qGetPairage.Close;
    qGetPairage.Open;
    tlFillCompareGrid.Execute;
}
  end;
end;

procedure TfmTicketsBreakdown.btnCancelPairsClick(Sender: TObject);
begin
  Editing := False;

  tblTicketTickets.cancel;

  if pcTicketsBreakdown.ActivePage = tsPairage then
  begin
    UpdatePairageScreen;

    btnRefresh.Click;
{
    tlMakeGrid.Execute;
    SetUpPairageGrid;
}
  end
  else
  begin
    UpdateTicketsScreen;

    dbgTickets.Options := dbgTickets.Options - [dgEditing];
    dbgTickets.EditorMode := false;
  end;

  //Release lock
  tblTicketSequences.cancel;
  dmTicketsAll.LocalConnectionSumms.Rollback;

  if pcTicketsBreakdown.ActivePage = tsTickets then
  begin
    tblTicketTickets.refresh;
    dbgTickets.refresh;
  end;
end;

function TfmTicketsBreakdown.MakeTIQuery(WeekNo, SequenceNo : string; WhichLine1 : short) : string;
var
  Line1 : string;

begin
  case WhichLine1 of
    1 : Line1 := 'SELECT DISTINCT(TI.Width) AS Width ';
    2 : Line1 := 'SELECT DISTINCT(TI.Size) AS Size ';
    3 : Line1 := 'SELECT TI.Width AS Width, TI.Size AS Size ';
  end;

  Result := Line1 +
            'FROM TicketsInput TI LEFT OUTER JOIN TicketsCompareGrid TCG ' +
            'ON TI.WeekNo = TCG.WeekNo AND TI.SequenceNo = TCG.SequenceNo AND TI.Width = TCG.Width AND TI.Size = TCG.Size AND TI.WidthNo = TCG.WidthNo AND TI.SizeSeq = TCG.SizeSeq ' +
            'WHERE TCG.WeekNo IS NULL AND TI.WeekNo = ' + WeekNo + ' AND TI.SequenceNo = ' + SequenceNo + ' AND ' +
            '(TCG.Identifier IS NULL OR TCG.Identifier <> ''' + Identifier + ''')';
end;

function TfmTicketsBreakdown.MakeTCGQuery(WeekNo, SequenceNo : string; WhichLine1 : short) : string;
var
  Line1 : string;

begin
  case WhichLine1 of
    1 : Line1 := 'SELECT TCG.WeekNo, TCG.SequenceNo, TCG.Width AS Width, TCG.Size AS Size, 0 AS Pairs, TCG.WidthNo As WidthNo, TCG.SizeSeq AS SizeSeq ';
    2 : Line1 := 'SELECT TCG.Width AS Width, TCG.Size AS Size ';
  end;

  Result := Line1 +
            'FROM TicketsCompareGrid TCG LEFT OUTER JOIN TicketsInput TI ' +
            'ON TI.WeekNo = TCG.WeekNo AND TI.SequenceNo = TCG.SequenceNo AND TI.Width = TCG.Width AND TI.Size = TCG.Size AND TI.WidthNo = TCG.WidthNo AND TI.SizeSeq = TCG.SizeSeq ' +
            'WHERE TI.WeekNo IS NULL AND TCG.WeekNo = ' + WeekNo + ' AND TCG.SequenceNo = ' + SequenceNo + ' AND TCG.Identifier = ''' + Identifier + '''';
end;

procedure TfmTicketsBreakdown.UpdatePairageScreen;
var
  i : integer;

begin
  if Editing then
  begin
    for i := 1 to sgPairage.ColCount - 2 do     //-2 because Total Col not edited
    begin
      sgPairage.Columns[i].Color := clEditing;
      if i > 1 then                              //don't add editor to AddWidthsFlag column - doubleclick is used instead.
        sgPairage.Columns[i].Editor := PairsCell;
    end;
    sgPairage.Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs];
  end
  else
  begin
    for i := 1 to sgPairage.ColCount - 2 do
    begin
      if i > 1 then
        sgPairage.Columns[i].Editor.Clear;  //prevents cell which was being edited being left with an editable appearance.
    end;
    sgPairage.Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goTabs];
  end;

  UpdateButtonsState;
end;

procedure TfmTicketsBreakdown.UpdateTicketsScreen;
begin
  tblTicketTickets.refresh;
  dbgTickets.Refresh;

  if Editing = True then
    dbgTickets.Columns[1].Color := clEditing
  else
    dbgTickets.Columns[1].Color := OurColor(clAqua);

  dbgTickets.Refresh;

  UpdateButtonsState;
end;

procedure TfmTicketsBreakdown.UpdateButtonsState;
begin
  btnEdit.enabled := (not Editing) and (not BlankGrid);
  btnSave.enabled := Editing;
  btnCancel.enabled := Editing;
  btnDelete.enabled := not Editing;
  btnRefresh.enabled := (not Editing) and (not BlankGrid);
  btnClearPairage.enabled := (not Editing) and (not BlankGrid);
  btnCreate.enabled := (not Editing) and (not BlankGrid);
  btnClearTickets.enabled := (not Editing) and (not BlankGrid);
  btnUpdateTickets.enabled := (not Editing) and (not BlankGrid);

  if not PrintTagNumbers then
    pnlView1.Visible := True
  else
    pnlView1.visible := (not Editing);
  if not PrintCustomer then
    pnlView2.Visible := True
  else
    pnlView2.visible := (not Editing);

  if pcTicketsBreakdown.ActivePage = tsPairage then
  begin
    btnPrintPreview.enabled := FALSE;
    btnPrint.enabled := FALSE;
    btnPrintPreviewMaterialSummary.enabled := FALSE;
    btnPrintMaterialSummary.enabled := FALSE;
    btnCopy.enabled := (not Editing) and (not BlankGrid);

    dbtTagNo.Enabled := PrintTagNumbers;
    dbtCustomerRef.Enabled := PrintCustomer;
    dbeTagNo.Enabled := PrintTagNumbers;
    dbeCustomerRef.Enabled := PrintCustomer;

    //labels are here purely to allow a disabled appearance for the group box titles.
    lblTagNumber.Enabled := PrintTagNumbers;
    lblCustomerReference.Enabled := PrintCustomer;
  end
  else
  begin
    btnPrintPreview.Enabled := not Editing;
    btnPrint.Enabled := not Editing;
    btnPrintMaterialSummary.Enabled := not Editing;
    btnPrintPreviewMaterialSummary.Enabled := not Editing;
    btnCopy.enabled := FALSE;
  end;

  SetTabStops(Editing);
  if not Editing then
    tbMain.setfocus;
end;

procedure TfmTicketsBreakdown.FormShow(Sender: TObject);
begin
  if fmNewTicket.Visible then
    fmNewTicket.Hide;
end;

procedure TfmTicketsBreakdown.btnCreateClick(Sender: TObject);
var
  LockSuccess: boolean;
  TicketsCreated, ChangeConnection, GridChanged: boolean;
  EMessage: string;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    TicketsCreated := False;
    GridChanged := false;

    if not dmTicketsAll.LocalConnectionSumms.Connected then
      dmTicketsAll.LocalConnectionSumms.Connected := true;
    dmTicketsAll.LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oTicket, fmSumms.tblLocks, tblTicketSequences, TicketCode, True);

    if LockSuccess then
    begin
      if tblTicketTickets.Recordcount > 0 then
        messagedlg('Ticket ' + TicketCode + ' already created', mtInformation, [mbOk], 0)
      else
      begin
        //CJY Check that style/construction exists. One query checks two tables, results should equal 2
        qStyleConstructionExists.Close;
        qStyleConstructionExists.Params.ParamByName('Style').AsString := dbtStyle.Caption;
        qStyleConstructionExists.Params.ParamByName('Construction').AsString := dbtConstruction.Caption;
        qStyleConstructionExists.Open;
        if qStyleConstructionExists.RecordCount < 2 then
        begin
          messagedlg('Style or Construction does not exist', mtInformation, [mbOK], 0);
        end
        else
        if (not TicketGridChanged) then
        begin
          if (TotalPairs > 0) then
          begin
            screen.cursor := crHourGlass;

            sbTicketsBreakdown.Panels[1].Text := 'Creating...';
            sbTicketsBreakdown.Refresh;

            try
              TicketsCreated := True;
              dmTicketsAll.qWidthKnives.Close;
              dmTicketsAll.qWidthKnives.ParamByName('WeekNo').Value := sWeekNo;
              dmTicketsAll.qWidthKnives.ParamByName('SequenceNo').Value := sSequenceNo;
              dmTicketsAll.qWidthKnives.Open;
              //CJY: dmTicketsCreate.qWidthKnives.FetchOptions.RecordCountMode set to cmTotal
              if dmTicketsAll.qWidthKnives.RecordCount > 0 then
                dmTicketsAll.MakeTickets(sWeekNo, sSequenceNo, False);
            except on E: EDatabaseError do
              begin
                TicketsCreated := False;
                EMessage := E.message;
              end;
            end;

            sbTicketsBreakdown.Panels[1].Text := '';

            screen.cursor := crDefault;

            tblTicketTickets.refresh;
            dbgTickets.refresh;

            pcTicketsBreakdown.ActivePage := tsTickets;
            UpdateButtonsState;

            if not TicketsCreated then
              fmErrorHandler.DebugMessageDlg('Unexpected Error' + #13 + 'Ticket NOT Created.', EMessage, '');
          end
          else
            messagedlg('No quantities on Ticket', mtInformation, [mbOK], 0);
        end
        else
        begin
          GridChanged := true;
          if (TotalPairs > 0) then
            messagedlg('Grid adjusted. Please Create tickets.', mtInformation, [mbOk], 0)
          else
            messagedlg('No quantities on Ticket', mtInformation, [mbOK], 0);
        end;
        qStyleConstructionExists.Close;
      end;
    end;

    if (TicketsCreated or GridChanged) then
    begin
      if (tblTicketSequences.State = dsEdit) then
      begin
        tblTicketSequencesLinesInLeatherGrid.value := LinesInLeatherGrid;
        tblTicketSequencesRowsInLeatherGrid.value := RowsInLeatherGrid;
        tblTicketSequencesMadeInPairs.Value := tblTicketSequencesConstrucMadeInPairs.Value;
        tblTicketSequences.post;
      end;

      //Post and release lock.
      dmTicketsAll.LocalConnectionSumms.Commit;

      //Refresh tblTickets out of the lock
      btnRefresh.Click;
      //      tblTicketTickets.refresh;
    end
    else
    begin
      //Release lock
      tblTicketSequences.cancel;
      dmTicketsAll.LocalConnectionSumms.Rollback;
    end;
  end;
end;

procedure TfmTicketsBreakdown.PassTicketSequenceReference(TicketForm : TfmTicketsBreakdown; WeekNo, SequenceNo : integer);
var
  MadeInPairs: boolean;

begin
  try
    fmTicketsBreakdown := TicketForm;

    iWeekNo := WeekNo;
    iSequenceNo := SequenceNo;
    sWeekNo := intToStr(WeekNo);
    sSequenceNo := intToStr(SequenceNo);
    TicketCode := sWeekNo + '/' + sSequenceNo + '/xx';
    Caption := 'Ticket(s) : ' + sWeekNo + '/' + sSequenceNo + '/xx    ';

    tblTicketSequences.open;
    tblTicketTickets.open;

    tblTicketSequences.Setrange([WeekNo, SequenceNo], [WeekNo, SequenceNo]);
    if tblTicketSequences.recordcount = 0 then
    begin
      messagedlg('Ticket ' + TicketCode + ' does not exist', mtInformation, [mbOk], 0);
      close;
    end
    else
    begin
      screen.Cursor := crHourGlass;

      Style := tblTicketSequencesStyle.value;
      Construction := tblTicketSequencesConstruction.value;

      if not tblTicketSequencesMadeInPairs.IsNull then
        MadeInPairs := tblTicketSequencesMadeInPairs.Value
      else
      begin
        qGetMadeInPairsFromConstruction.ParamByName('Construction').Value := Construction;
        qGetMadeInPairsFromConstruction.Open;
        MadeInPairs := qGetMadeInPairsFromConstructionMadeInPairs.Value;
        qGetMadeInPairsFromConstruction.Close;
      end;

      if MadeInPairs then
        tsPairage.Caption := 'Pairage'
      else
        tsPairage.Caption := 'Items';

      qGetPairage.ParamByName('WeekNo').AsSmallInt := WeekNo;
      qGetPairage.ParamByName('SequenceNo').AsSmallInt := SequenceNo;

      btnRefresh.Click;
{
      qGetPairage.Open;


      tlMakeGrid.Execute;
      tlFillCompareGrid.Execute;

      SetUpPairageGrid;
}

      UpdateButtonsState;

//      tblTicketTickets.Refresh;
      tblTicketTickets.SetRange([sWeekNo, sSequenceNo], [sWeekNo, sSequenceNo]);

      if FromNew and (not BlankGrid) then
        btnEdit.Click;

      screen.Cursor := crDefault;
    end;
  except
    Close;                                 
    HasClosed := True;
    Raise;
  end;
end;

procedure TfmTicketsBreakdown.btnClearPairageClick(Sender: TObject);
var
  LockSuccess, CanClear: boolean;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    dmTicketsAll.LocalConnectionSumms.StartTransaction;

    CanClear := false;

    //Attempt Lock
    LockSuccess := LockSingle(oTicket, fmSumms.tblLocks, tblTicketSequences, TicketCode, True);

    if LockSuccess then
    begin
      if tblTicketTickets.Recordcount > 0 then
        messagedlg('Ticket ' + TicketCode + ' already created', mtInformation, [mbOk], 0)
      else
      begin
        CanClear := (messagedlg('Clear Quantities?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
        if CanClear then
        begin
          screen.cursor := crHourGlass;

          sbTicketsBreakdown.Panels[1].Text := 'Clearing...';
          sbTicketsBreakdown.Refresh;

          //Clear pairage
          qUpdatePairage.SQL.Add('UPDATE TicketsInput SET Pairs = 0 WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' +
                                      sSequenceNo + ' AND NOT Size = ''AddWidth'';');
          qUpdatePairage.SQL.Add('UPDATE TicketsInput SET Pairs = 1 WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' +
                                      sSequenceNo + ' AND Size = ''AddWidth'';');
          qUpdatePairage.ExecSQL;

          sbTicketsBreakdown.Panels[1].Text := '';

          screen.cursor := crDefault;
        end;
      end;

      pcTicketsBreakdown.ActivePage := tsPairage;
      UpdateButtonsState;
    end;

    if CanClear then
    begin
      dmTicketsAll.LocalConnectionSumms.Commit;

      btnRefresh.Click;
{
      qGetPairage.Close;
      qGetPairage.Open;
      tlMakeGrid.Execute;
      tlFillCompareGrid.Execute;

      SetUpPairageGrid;

      tblTicketTickets.refresh;
      dbgTickets.refresh;
}
    end
    else
    begin
      tblTicketSequences.cancel;
      dmTicketsAll.LocalConnectionSumms.Rollback;
    end;
  end;
end;

procedure TfmTicketsBreakdown.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Editing then
  begin
    if messagedlg('Save Changes to Ticket ' + TicketCode + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      btnSave.click
    else
      btnCancel.click;
  end;

  action := caFree;
end;

procedure TfmTicketsBreakdown.pcTicketsBreakdownChange(Sender: TObject);
begin
  UpdateButtonsState;
end;

procedure TfmTicketsBreakdown.sgPairageSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ARow = 0) or (ACol = 0) then
    CanSelect := False
  else
    CalcPairsOnWidths;
end;

procedure TfmTicketsBreakdown.sgPairageSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  CalcPairsOnWidths;
end;

procedure TfmTicketsBreakdown.btnDeleteClick(Sender: TObject);
var
  LockSuccess: boolean;
  CanDelete: boolean;
  SQLString: string;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    dmTicketsAll.LocalConnectionSumms.StartTransaction;

    CanDelete := false;

    //Attempt Lock
    LockSuccess := LockSingle(oTicket, fmSumms.tblLocks, tblTicketSequences, TicketCode, True);

    if LockSuccess then
    begin
      CanDelete := (messagedlg('Delete Ticket?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
      if CanDelete then
      begin
        try
          SQLString := 'INSERT INTO Audit ' +
                       '(Type, UserName, WeekNo, SequenceNo, TicketNo, TransactionDate, Printed) ' +
                       'SELECT ''D'', ''' + QS(SystemUserName) + ''', WeekNo, SequenceNo, TicketNo, CurDate(), Printed ' +
                       'FROM TicketTickets ' +
                       'WHERE WeekNo = ' + IntToStr(tblTicketSequencesWeekNo.Value) + ' AND SequenceNo = ' + IntToStr(tblTicketSequencesSequenceNo.Value);

          qAddToAudit.SQL.Text := SQLString;
          qAddToAudit.ExecSQL;

          tblTicketSequences.delete;
        except
          //This Shouldn't be possible
          on E: Exception do
          begin
            fmErrorHandler.DebugMessageDlg('Ticket in use', E.Message, qAddToAudit.Text);
            CanDelete := false
          end;
        end;
      end;
    end;

    if CanDelete then
    begin
      dmTicketsAll.LocalConnectionSumms.Commit;
      close;
    end
    else
    begin
      tblTicketSequences.cancel;
      dmTicketsAll.LocalConnectionSumms.Rollback;
    end;
  end;
end;

procedure TfmTicketsBreakdown.sgPairageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  XMouse := X;
  YMouse := Y;
end;

procedure TfmTicketsBreakdown.SetAddWidthsFlag;
var
  CurrentFlag: string;

begin
  if Editing then
  begin
    sgPairage.Options := [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRowSizing,goColSizing,goTabs];

    sgPairage.MouseToCell(Xmouse, YMouse, CellColumn, CellRow);

    if (CellColumn = 1) and (CellRow > 0) then
    begin
      CurrentFlag := sgPairage.Cells[1,CellRow];
      if CurrentFlag = 'Yes' then
        sgPairage.Cells[1,CellRow] := 'No'
      else
        sgPairage.Cells[1,CellRow] := 'Yes';

      JustClicked := True;
    end;
  end;
end;

procedure TfmTicketsBreakdown.sgPairageDblClick(Sender: TObject);
begin
  SetAddWidthsFlag;
end;

procedure TfmTicketsBreakdown.sgPairageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //This is to get around the fact that the SetAddWidthsFlag will not update
  //the cell contents until the cell is exited unless goEditing and goTabs are
  //FALSE. If you try and set them off then on again within the DoubleClick
  //event it is as if they are never switched off.

  if Editing and JustClicked then
  begin
    sgPairage.Options := [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRowSizing,goColSizing,goEditing,goTabs];
    JustClicked := False;
  end;
end;

procedure TfmTicketsBreakdown.btnCopyClick(Sender: TObject);
var
  LockSuccess: Boolean;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    dmTicketsAll.LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oTicket, fmSumms.tblLocks, tblTicketSequences, TicketCode, True);

    if LockSuccess then
    begin
      fmCopyTicket.fmTicketsBreakdown := fmTicketsBreakdown;
      fmCopyTicket.ShowModal;

      //Release lock
      tblTicketSequences.cancel;
      dmTicketsAll.LocalConnectionSumms.Rollback;
    end;
  end;
end;

procedure TfmTicketsBreakdown.tblTicketTicketsCalcFields(DataSet: TDataSet);
var
  TicketNo, s : string;

begin
  str(tblTicketTicketsWeekNo.value, s);
  TicketNo := s;
  str(tblTicketTicketsSequenceNo.value, s);
  TicketNo := TicketNo + '/' + s;
  str(tblTicketTicketsTicketNo.value, s);
  TicketNo := TicketNo + '/' + s;

  tblTicketTicketsFullTicketNumber.value := TicketNo;

  if tblTicketTicketsPrinted.value then
    tblTicketTicketsPrintedYN.value := 'Yes'
  else
    tblTicketTicketsPrintedYN.value := 'No';

  if tblTicketTicketsPrint.value then
    tblTicketTicketsPrintYN.value := 'Yes'
  else
    tblTicketTicketsPrintYN.value := 'No';
end;

procedure TfmTicketsBreakdown.SetUpQueriesForPrinting;
var
  OrderBy: string;

begin
  if fmSumms.mmGroupPrintByMaterial.Checked then
    OrderBy := 'Order By TT.MaterialCode, TT.MaterialCode, TT.WeekNo, TT.SequenceNo, TT.TicketNo'
  else
    OrderBy := 'Order By TT.WeekNo, TT.WeekNo, TT.SequenceNo, TT.TicketNo';

  fmfrTicket.qTickets.SQL.Text := 'SELECT TT.*, TS.Style, TS.Construction, TS.TagNo, TS.Customer, TS.Picture, TS.RowsInLeatherGrid, TS.LinesInLeatherGrid ' +
                                  'FROM TicketTickets TT, TicketSequences TS ' +
                                  'WHERE TS.WeekNo = ' + sWeekNo + ' AND TS.SequenceNo = ' + sSequenceNo + ' AND ' +
                                  'TT.WeekNo = TS.WeekNo AND TT.SequenceNo = TS.SequenceNo AND TT.Print = TRUE ' + OrderBy;

  fmfrTicket.qShoeSizes.SQL.Text := 'SELECT TI.WeekNo, TI.SequenceNo, TS.TicketNo, TI.Width, TI.Size, TI.Pairs, TI.WidthNo, TI.SizeSeq ' +
                                    'FROM TicketsInput TI, TicketTicketsWidths TS ' +
                                    'WHERE TS.WeekNo = ' + sWeekNo + ' AND TS.SequenceNo = ' + sSequenceNo + ' AND ' +
                                          'TS.WeekNo = TI.WeekNo AND TS.SequenceNo = TI.SequenceNo AND TS.Width = TI.Width AND ' +
                                          'TI.Size <> ''AddWidth'' AND NOT EXISTS ' +
                                          '(SELECT * ' +
                                           'FROM TicketsSplitInput ' +
//                                                   'WHERE WeekNo = TS.WeekNo AND SequenceNo = TS.SequenceNo AND TicketNo = TS.TicketNo) ' +
                                           'WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' + sSequenceNo + ' AND TicketNo = TS.TicketNo) ' +
                                    'UNION ' +
                                    'SELECT TS.WeekNo, TS.SequenceNo, TS.TicketNo, TS.Width, TS.Size, TS.Pairs, TS.WidthNo, TS.SizeSeq ' +
                                    'FROM TicketsSplitInput TS ' +
                                    'WHERE TS.WeekNo = ' + sWeekNo + ' AND TS.SequenceNo = ' + sSequenceNo + ' AND TS.Size <> ''AddWidth'' ' +
                                    'UNION ' +
                                    'SELECT DISTINCT TS.WeekNo, TS.SequenceNo, TS.TicketNo, TSI2.Width, TS.Size, 0 as Pairs, TSI2.WidthNo, TS.SizeSeq ' +
                                    'FROM TicketsSplitInput TS, TicketsSplitInput TSI2 ' +
                                    'WHERE TS.WeekNo = ' + sWeekNo + ' AND TS.SequenceNo = ' + sSequenceNo + ' AND TS.Size <> ''AddWidth'' AND ' +
                                           'TSI2.WeekNo = TS.WeekNo AND TSI2.SequenceNo = TS.SequenceNo AND ' +
                                           'TSI2.TicketNo = TS.TicketNo AND TSI2.Size <> ''AddWidth'' AND ' +
                                           'NOT EXISTS (SELECT 1 ' +
                                                       'FROM TicketsSplitInput ' +
//                                                               'WHERE WeekNo = TS.WeekNo AND ' +
                                                       'WHERE WeekNo = ' + sWeekNo + ' AND ' +
//                                                               'SequenceNo = TS.SequenceNo AND ' +
                                                       'SequenceNo = ' + sSequenceNo + ' AND ' +
                                                       'TicketNo = TS.TicketNo AND ' +
                                                       'Width = TSI2.Width AND Size = TS.Size) ' +
                                       'UNION ' +
                                       'SELECT 0 as WeekNo, 0 as SequenceNo, 0 as TicketNo, ''0'' as Width, ''0'' as Size, 0 as Pairs, 0 as WidthNo, 0 as SizeSeq ' +
                                       'FROM Params ' +               //***LATER*** This UNION forces Order By to, to create index by ensuring there is more than one record returned
                                       'Order By 1, 1, 2, 3, 7, 8 ';     //with only one line the Order By clause, clause isn't used so no index is created - find a better way when more time.

//          fmfrTicket.qrTicket.ShowProgress := False;

  fmfrTicket.qTickets.Open;
  fmfrTicket.qShoeSizes.Open;
  fmfrTicket.qNominalSizes.ParamByName('WeekNo').AsSmallInt := iWeekNo;
  fmfrTicket.qNominalSizes.ParamByName('SequenceNo').AsSmallInt := iSequenceNo;
  fmfrTicket.qNominalSizes.ExecSQL;
  fmfrTicket.qNominalSizes2.Open;

  if Option_CuttingTimes and PrintTimes then
  begin
    fmfrTicket.qTicketTimes.SQL.Text := 'SELECT TS.WeekNo, TS.SequenceNo, TS.TicketNo, TS.Quality, TS.Time ' +
                                        'FROM TicketTicketsTimes TS ' +
                                        'WHERE TS.WeekNo = ' + sWeekNo + ' AND TS.SequenceNo = ' + sSequenceNo +
                                        ' UNION ' +
                                        'SELECT 0 as WeekNo, 0 as SequenceNo, 0 as TicketNo, 0 as Quality, 0 as Time ' +
                                        'FROM Params ' +
                                        'Order By 1, 1, 2, 3, 4';
                 //***LATER*** This UNION forces Order By to, to create index by ensuring there is more than one record returned
                 //with only one line the Order By clause, clause isn't used so no index is created - find a better way when more time.
    try
      fmfrTicket.qTicketTimes.Open;
    except
      PrintTimes := False;
    end;
  end;
end;

procedure TfmTicketsBreakdown.CloseQueries;
begin
  fmfrTicket.qTickets.Close;
  fmfrTicket.qShoeSizes.Close;
  fmfrTicket.qNominalSizes2.Close;
  fmfrTicket.qTicketTimes.Close;
end;

procedure TfmTicketsBreakdown.btnPrintClick(Sender: TObject);
var
  Failed, LockSuccess: Boolean;

begin
  Failed := True;
  tblTicketSequences.refresh;

  dmTicketsAll.LocalConnectionSumms.StartTransaction;

  //Lock it because we don't want someone else deleting the Ticket while it's being printed.
  LockSuccess := LockSingle(oTicket, fmSumms.tblLocks, tblTicketSequences, TicketCode, True);

  if LockSuccess then
  begin
    if tblTicketSequences.recordcount = 0 then
    begin
      messagedlg('Ticket ' + TicketCode + ' has been deleted', mtInformation, [mbOk], 0);
      close;
    end
    else
    begin
      ThisTicketMadeInPairs := tblTicketSequencesMadeInPairs.AsBoolean;

      //Stop accidental double click
      btnPrintPreview.enabled := False;
      btnPrint.enabled := False;

      if tblTicketTickets.Recordcount = 0 then
        messagedlg('Ticket ' + TicketCode + ' not yet created', mtInformation, [mbOk], 0)
      else
      begin
        Failed := false;
        try
          fmfrTicket := TfmfrTicket.Create(fmTicketsBreakdown);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;

        if not Failed then
        begin
          fmfrTicket.GroupPrint := False;
          fmfrTicket.qTickets.Close;

          SetupQueriesForPrinting;
          fmfrTicket.Setup;

          try
          begin
            fmfrTicket.frTicket.ReportOptions.Name := 'Preview ' + Caption;
            ClosePreviewForm(Caption);

//            fmfrTicket.qPrinted.SQL.Text := '';
            fmfrTicket.frTicket.PrintOptions.PrintMode := pmScale;
            fmfrTicket.frTicket.PrintOptions.PrintOnSheet := GetPaperSize;
            fmfrTicket.frTicket.PrepareReport;
            fmfrTicket.qTickets.AfterScroll := nil;
            if (Sender as TControl).Name = btnPrintPreview.Name then
              fmfrTicket.frTicket.ShowPreparedReport
            else
              fmfrTicket.frTicket.Print;
          end
          except
            fmMemoryError.ShowError(self);
          end;

          tblTicketTickets.Refresh;
        end;
      end;
    end;

    btnPrintPreview.enabled := True;
    btnPrint.enabled := True;

    //Release lock
    tblTicketSequences.Cancel;
    dmTicketsAll.LocalConnectionSumms.Rollback;

    if not Failed then
      CloseQueries;
  end;
end;

procedure TfmTicketsBreakdown.dbgTicketsDblClick(Sender: TObject);
var
  Code, Whichfield: string;
  Failed: Boolean;
  fmPartDetails: TfmPartDetails;
  fmMaterialDetails: TfmMaterialDetails;

begin
  Failed := FALSE;
  WhichField := dbgTickets.Columns.Grid.SelectedField.FieldName;

  if Editing then
  begin
    if (WhichField = 'PrintYN') then
    begin
      if not(tblTicketTickets.state in [dsEdit, dsInsert]) then
        tblTicketTickets.edit;
      if tblTicketTicketsPrint.value then
        tblTicketTicketsPrint.value := false
      else
        tblTicketTicketsPrint.value := true;
    end;
  end
  else
  begin
    if (WhichField = 'MaterialCode') then
    begin
      Code := tblTicketTicketsMaterialCode.Value;
      if not(Code = '') then
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
      Code := tblTicketTicketsPartCode.value;
      if not(Code = '') then
      begin
        if not ExistingToFront('Part', Code) then
        begin
          Screen.cursor := crHourGlass;
          try
            fmPartDetails := TfmPartDetails.create(fmSumms);
          except
            fmMemoryError.TidyUp(self);
            Failed := true;
          end;

          if not Failed then
            fmPartDetails.PassPartName(fmPartDetails, Code);
        end;
      end;
    end;
  end;
end;

procedure TfmTicketsBreakdown.btnPrintMaterialSummaryClick(
  Sender: TObject);
var
  LockSuccess: Boolean;
  Failed: Boolean;
  SQLString: string;

begin
  ClosePreviewForm('');

  //Stop accidental double click
  btnPrintPreviewMaterialSummary.enabled := False;
  btnPrintMaterialSummary.enabled := False;

  SQLString := 'TT.WeekNo = ' + sWeekNo + ' AND TT.SequenceNo = ' + sSequenceNo;

  dmTicketsAll.LocalConnectionSumms.StartTransaction;

  //Attempt Lock
  LockSuccess := LockSingle(oTicket, fmSumms.tblLocks, tblTicketSequences, TicketCode, True);

  if LockSuccess then
  begin
    if tblTicketTickets.Recordcount = 0 then
      messagedlg('Ticket ' + TicketCode + ' not yet created', mtInformation, [mbOk], 0)
    else
    begin
      Failed := false;
      try
        fmfrMaterialSummary := TfmfrMaterialSummary.Create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
      begin
        fmfrMaterialSummary.MakeMaterialSummary(SQLString, ((Sender as TControl).Name = btnPrintPreviewMaterialSummary.Name));
//        fmfrMaterialSummary.Release;
      end;

      //Release lock
      tblTicketSequences.cancel;
      dmTicketsAll.LocalConnectionSumms.Rollback;
    end;
  end;

  btnPrintPreviewMaterialSummary.enabled := True;
  btnPrintMaterialSummary.enabled := True;
end;

procedure TfmTicketsBreakdown.tblTicketTicketsBeforeDelete(
  DataSet: TDataSet);
begin
  abort;
end;

procedure TfmTicketsBreakdown.tblTicketTicketsBeforeInsert(
  DataSet: TDataSet);
begin
  abort;
end;

procedure TfmTicketsBreakdown.pcTicketsBreakdownChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := not Editing;
end;

procedure TfmTicketsBreakdown.btnClearTicketsClick(Sender: TObject);
var
  LockSuccess, CanClear, MadeInPairs: boolean;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    dmTicketsAll.LocalConnectionSumms.StartTransaction;

    CanClear := false;

    //Attempt Lock
    LockSuccess := LockSingle(oTicket, fmSumms.tblLocks, tblTicketSequences, TicketCode, True);

    if LockSuccess then
    begin
      if tblTicketTickets.Recordcount = 0 then
        messagedlg('Ticket ' + TicketCode + ' not yet created', mtInformation, [mbOk], 0)
      else
      begin
        CanClear := (messagedlg('Clear Tickets?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
        if CanClear then
        begin
          screen.cursor := crHourGlass;

          sbTicketsBreakdown.Panels[1].Text := 'Clearing...';
          sbTicketsBreakdown.Refresh;

          //heading for Cleared Ticket line should read 'Updated' NOT 'Amended'
          qClearTickets.SQL.Text := 'INSERT INTO Audit ' +
                                    '(Type, UserName, WeekNo, SequenceNo, TicketNo, TransactionDate, Printed, Amended) ' +
                                    'SELECT ''C'', ''' + QS(SystemUserName) + ''', WeekNo, SequenceNo, TicketNo, CurDate(), ' +
                                    'Printed, IIF(ActualUsage <> 0, TRUE, FALSE) ' +
                                    'FROM TicketTickets ' +
                                    'WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' + sSequenceNo + ';' + #13 +
                                    'DELETE FROM TicketTickets ' +
                                    'WHERE WeekNo = ' + sWeekNo + ' AND SequenceNo = ' + sSequenceNo + ';';

          qClearTickets.ExecSQL;

          tblTicketSequencesAllPrinted.value := FALSE;
          tblTicketSequencesMadeInPairs.Clear;

          sbTicketsBreakdown.Panels[1].Text := '';

          screen.cursor := crDefault;
        end;

//        tblTicketTickets.refresh;
//        dbgTickets.refresh;

        pcTicketsBreakdown.ActivePage := tsPairage;
        UpdateButtonsState;
      end;
    end;

    //Check what the Construction is made in - it might have changed if they deleted and remade since making ticket.
    qGetMadeInPairsFromConstruction.ParamByName('Construction').Value := Construction;
    qGetMadeInPairsFromConstruction.Open;
    MadeInPairs := qGetMadeInPairsFromConstructionMadeInPairs.Value;
    qGetMadeInPairsFromConstruction.Close;

    if MadeInPairs then
      tsPairage.Caption := 'Pairage'
    else
      tsPairage.Caption := 'Items';

    if CanClear then
    begin
      dmTicketsAll.LocalConnectionSumms.Commit;
      tblTicketTickets.refresh;
      dbgTickets.refresh;
    end
    else
    begin
      tblTicketSequences.cancel;
      dmTicketsAll.LocalConnectionSumms.Rollback;
    end;
  end;
end;

procedure TfmTicketsBreakdown.btnRefreshClick(Sender: TObject);
begin
  tblTicketSequences.refresh;
  if tblTicketSequences.recordcount = 0 then
  begin
    messagedlg('Ticket ' + TicketCode + ' has been deleted', mtInformation, [mbOk], 0);
    close;
  end
  else
  begin
    if qGetPairage.Active then
      qGetPairage.Refresh
    else
      qGetPairage.Open;

    tlMakeGrid.Execute;
    tlFillCompareGrid.Execute;

    SetUpPairageGrid;

    tblTicketTickets.refresh;
    dbgTickets.refresh;
  end;
end;

function TfmTicketsBreakdown.BlankGrid: boolean;
begin
  BlankGrid := ((sgPairage.ColCount = 2) and (sgPairage.RowCount = 2));
end;

procedure TfmTicketsBreakdown.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  if not Option_CuttingTimes then
    dbgTickets.Columns[14].visible := false;

  AddTotalsColumn;

  if fmSumms.mmOpenTicketsInCentre.Checked then
    position := poScreenCenter;

  SetTabStops(False);

  lblTagNumber.Caption := TicketTranslation[8];
  lblCustomerReference.Caption := TicketTranslation[18];
end;

procedure TfmTicketsBreakdown.btnUpdateTicketsClick(Sender: TObject);
var
  LockSuccess: Boolean;

begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if ExistingToFront('Tickets Update (Group)', '') then
      messagedlg('Tickets Update (Group) already open', mtInformation, [mbOk], 0)
    else if ExistingToFront('Tickets Update (Bulk)', '') then
      messagedlg('Tickets Update (Bulk) already open', mtInformation, [mbOk], 0)
    else
    begin
      if tblTicketTickets.Recordcount = 0 then
        messagedlg('Ticket ' + TicketCode + ' not yet created.', mtInformation, [mbOk], 0)
      else
      begin
        dmTicketsAll.LocalConnectionSumms.StartTransaction;

        //Attempt Lock
        LockSuccess := LockSingle(oTicket, fmSumms.tblLocks, tblTicketSequences, TicketCode, True);

        if LockSuccess then
        begin
          Screen.cursor := crHourGlass;
          try
            qTicketsToUpdate.SQL.clear;

            qTicketsToUpdate.SQL.Text  := 'DELETE FROM TicketUpdate ' +
                                          'WHERE Identifier = ''' + Identifier + ''';' + #13 +
                                          'INSERT INTO TicketUpdate(Identifier, WeekNo, SequenceNo, TicketNo) ' +
                                          'SELECT ''' + Identifier + ''', WeekNo, SequenceNo, TicketNo ' +
                                          'FROM TicketTickets ' +
                                          'WHERE WeekNo = ' + sWeekNo + ' AND ' +
                                          '      SequenceNo = ' + sSequenceNo + ' AND '+
                                          '      Printed = TRUE;';

            qTicketsToUpdate.ExecSQL;
            fmTicketUpdate := TfmTicketUpdate.create(fmSumms);
            fmTicketUpdate.ChangeAllConnections(dmTicketsAll.LocalConnectionSumms);
            fmTicketUpdate.left := (Screen.Width div 2) - (fmTicketUpdate.Width div 2);
            fmTicketUpdate.top := (Screen.Height div 2) - (fmTicketUpdate.Height div 2);
            fmTicketUpdate.formStyle := fsNormal;
            fmTicketUpdate.visible := false;
            fmTicketUpdate.caption := 'Tickets Update (' + TicketCode + ')';
            fmTicketUpdate.btnUpdateTickets.left := 3;
            fmTicketUpdate.btnLoad.visible := false;
            fmTicketUpdate.dbgTktUpdate.Columns[0].ReadOnly := true;
            fmTicketUpdate.dbgTktUpdate.Columns[1].ReadOnly := true;
            fmTicketUpdate.dbgTktUpdate.Columns[2].ReadOnly := true;
            fmTicketUpdate.dbgTktUpdate.Columns[0].Color := OurColor(clAqua);
            fmTicketUpdate.dbgTktUpdate.Columns[1].Color := OurColor(clAqua);
            fmTicketUpdate.dbgTktUpdate.Columns[2].Color := OurColor(clAqua);
            fmTicketUpdate.tblTicketUpdate.BeforeDelete := fmTicketUpdate.tblTicketUpdateBeforeDelete;
            fmTicketUpdate.tblTicketUpdate.BeforeInsert := fmTicketUpdate.tblTicketUpdateBeforeInsert;
            fmTicketUpdate.Pass;
            if fmTicketUpdate.tblTicketUpdate.recordcount = 0 then
            begin
              messagedlg('There are No Printed Tickets to Update.', mtInformation, [mbOk], 0);
              fmTicketUpdate.close;
            end
            else
              fmTicketUpdate.showmodal;

            fmTicketUpdate.RevertAllConnections();

            FreeAndNil(fmTicketUpdate);

            tblTicketTickets.refresh;
            dbgTickets.refresh;
          except
            fmMemoryError.TidyUp(self);
          end;

          //Release lock
          tblTicketSequences.cancel;
          dmTicketsAll.LocalConnectionSumms.Commit;

          Screen.cursor := crDefault;
        end
        else
        begin
          dmTicketsAll.LocalConnectionSumms.Rollback;
        end;
      end;
    end;
  end;
end;

procedure TfmTicketsBreakdown.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmTicketsBreakdown.dbgTicketsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (ord(Key) = VK_RETURN) and not Editing then
    dbgTicketsDblClick(Self);
end;

procedure TfmTicketsBreakdown.dbtStyleDblClick(Sender: TObject);
var
  Code: string;
  Failed: boolean;
  fmStyleDetails: TfmStyleDetails;

begin
  Code := tblTicketSequencesStyle.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Style', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed:=False;
      try
        fmStyleDetails := TfmStyleDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(Self);
        Failed := True
      end;

      if not Failed then fmStyleDetails.PassStyleName(fmStyleDetails, Code)
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmTicketsBreakdown.dbtConstructionDblClick(Sender: TObject);
var
  fmConstructionDetails: TfmConstructionDetails;
  Code: string;
  Failed: boolean;

begin
  Code := tblTicketSequencesConstruction.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Construction', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmConstructionDetails := TfmConstructionDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;
      if not Failed then
        fmConstructionDetails.PassConstructionName(fmConstructionDetails, Code);
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmTicketsBreakdown.SetTabStops(Editing: Boolean);
begin
  sgPairage.TabStop := not Editing;
  dbeTagNo.TabStop := Editing;
  dbeCustomerRef.TabStop := Editing;
end;

procedure TfmTicketsBreakdown.pcTicketsBreakdownDrawTab(
  Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
begin
  DrawTab(Control, TabIndex, Rect, Active);
end;

procedure TfmTicketsBreakdown.SetPairageGridColors;
var
  i: integer;

begin
  for i := 1 to sgPairage.ColCount - 1 do
  begin
    sgPairage.Columns[i].HeaderColor := Ourcolor(clLime);
    sgPairage.Columns[i].HeaderFont.Color := Ourcolor(clWindowText);
    sgPairage.Columns[i].Color := Ourcolor(clAqua);
  end;
end;

end.

