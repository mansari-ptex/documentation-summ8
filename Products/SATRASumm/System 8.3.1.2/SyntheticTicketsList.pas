unit SyntheticTicketsList;

interface

uses
  Forms, StdCtrls, Types, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, ExtCtrls, Buttons, ComCtrls, Controls,
  ToolWin, Classes, Grids, DBGridPlus, DBGrids, Menus, XStringGrid,
  XStringGridPlus, frxClass, frxDBSet, frxReportPlus, Variants;

type
  TfmSyntheticTicketsList = class(TForm)
    dsSyntheticTickets: TDataSource;
    qSyntheticTickets: TFDQueryPlus;
    tbMain: TPanel;
    pnlPrintButtons: TPanel;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    pnlGroupButtons: TPanel;
    btnSelectAll: TSpeedButton;
    btnDeselectAll: TSpeedButton;
    btnGroupPrint: TSpeedButton;
    dbgLayplansSelected: TDBGridPlus;
    qSyntheticTicketsSelected: TBooleanField;
    qSyntheticTicketsFullTicketNumber: TStringField;
    qSyntheticTicketsWeekNo: TSmallintField;
    qSyntheticTicketsSequenceNo: TSmallintField;
    qSyntheticTicketsTicketNo: TSmallintField;
    qSyntheticTicketsMaterialCode: TStringField;
    qSyntheticTicketsKnifeCode: TStringField;
    qSyntheticTicketsSizeScale: TStringField;
    qSyntheticTicketsSize: TStringField;
    qSyntheticTicketsLength: TFloatField;
    qSyntheticTicketsWidth: TFloatField;
    qSyntheticTicketsCutgap: TSmallintField;
    qSyntheticTicketsRestrictiveMaterial: TStringField;
    qSyntheticTicketsPairs: TIntegerField;
    qSyntheticTicketsMaterialSubUnitDesc: TStringField;
    qSyntheticTicketsMaterialSubUnitAbbreviation: TStringField;
    qSyntheticTicketsMaterialUnits: TStringField;
    qSyntheticTicketsSLMAllowance: TBooleanField;
    pnlListButtons: TPanel;
    btnLayplans: TSpeedButton;
    btnGroupPrintPreview: TSpeedButton;
    frSyntheticsList: TfrxReportPlus;
    frdbSyntheticsList: TfrxDBDataset;
    qSyntheticTicketsRecNo: TIntegerField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnDeselectAllClick(Sender: TObject);
    procedure qSyntheticTicketsCalcFields(DataSet: TDataSet);
    procedure btnGroupPrintClick(Sender: TObject);
    procedure FillArray(Flag: Boolean);
    procedure dbgLayplansSelectedColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure dbgLayplansSelectedCellClick(Column: TColumn);
    procedure btnLayplansClick(Sender: TObject);
    procedure qSyntheticTicketsAfterOpen(DataSet: TDataSet);
    procedure CreateQuery(WeekNosString: string);
    procedure GroupPrint(Preview: Boolean);
    procedure btnGroupPrintPreviewClick(Sender: TObject);
    procedure frSyntheticsListBeforePrint(Sender: TfrxReportComponent);
    procedure frSyntheticsListGetValue(const VarName: string;
      var Value: Variant);
    procedure qSyntheticTicketsAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
    BusyPrinting: boolean;
    ColumnSelectedPosition: integer;
    Selected: array of Boolean;
  public
    { Public declarations }
  end;

var
  fmSyntheticTicketsList: TfmSyntheticTicketsList;

const
  INITIALSELECTEDCOLUMN = 9;

implementation

uses
  Windows, SysUtils, Graphics, Dialogs, General, MaterialDetails, Summs, OutOfMemory,
  SummsVars, CmnVars, CancelPrinting, Layplanning, LayMain, AllPatterns, AllSyntheticMaterials,
  AllLayplans, Const_Interlocking
  {$IFDEF DEBUGFULL}
  , Debugger
  {$ENDIF}
  ;

{$R *.DFM}

procedure TfmSyntheticTicketsList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    qSyntheticTickets.close;
    action := caFree;
  end;
end;

procedure TfmSyntheticTicketsList.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frSyntheticsList.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  //Preparation
  if not btnLayplans.Down then
  begin
    //Normal printout
    TfrxMemoView(frSyntheticsList.FindObject('mLengthTitle')).Visible := False;
    TfrxMemoView(frSyntheticsList.FindObject('mWidthTitle')).Visible := False;
    TfrxMemoView(frSyntheticsList.FindObject('mCutgapTitle')).Visible := False;
    TfrxMemoView(frSyntheticsList.FindObject('mRestrictiveMaterialTitle')).Visible := False;

    TfrxMemoView(frSyntheticsList.FindObject('mLength')).Visible := False;
    TfrxMemoView(frSyntheticsList.FindObject('mWidth')).Visible := False;
    TfrxMemoView(frSyntheticsList.FindObject('mCutgap')).Visible := False;
    TfrxMemoView(frSyntheticsList.FindObject('mRestrictiveMaterial')).Visible := False;

    TfrxMemoView(frSyntheticsList.FindObject('mPairsTitle')).Left := 410;
    TfrxMemoView(frSyntheticsList.FindObject('mPairs')).Left := 410;

    TfrxMemoView(frSyntheticsList.FindObject('mLayplan')).Visible := False;
  end
  else
  begin
    //Layplans printout
    TfrxMemoView(frSyntheticsList.FindObject('mLengthTitle')).Visible := True;
    TfrxMemoView(frSyntheticsList.FindObject('mWidthTitle')).Visible := True;
    TfrxMemoView(frSyntheticsList.FindObject('mCutgapTitle')).Visible := True;
    TfrxMemoView(frSyntheticsList.FindObject('mRestrictiveMaterialTitle')).Visible := True;

    TfrxMemoView(frSyntheticsList.FindObject('mLength')).Visible := True;
    TfrxMemoView(frSyntheticsList.FindObject('mWidth')).Visible := True;
    TfrxMemoView(frSyntheticsList.FindObject('mCutgap')).Visible := True;
    TfrxMemoView(frSyntheticsList.FindObject('mRestrictiveMaterial')).Visible := True;

    TfrxMemoView(frSyntheticsList.FindObject('mPairsTitle')).Left := 680;
    TfrxMemoView(frSyntheticsList.FindObject('mPairs')).Left := 680;

    TfrxMemoView(frSyntheticsList.FindObject('mLayplan')).Visible := True;
  end;

  qSyntheticTickets.DisableControls;
  MyBookmark := qSyntheticTickets.GetBookmark;

  frSyntheticsList.PrintOptions.PrintMode := pmScale;
  frSyntheticsList.PrintOptions.PrintOnSheet := GetPaperSize;
  frSyntheticsList.PrepareReport;

  try
    qSyntheticTickets.GotoBookmark(MyBookmark);
  except
  end;
  qSyntheticTickets.EnableControls;
  qSyntheticTickets.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frSyntheticsList do
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
    frSyntheticsList.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmSyntheticTicketsList.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;

  pnlListButtons.Visible := Option_FullSynthetics;
  ColumnSelectedPosition := INITIALSELECTEDCOLUMN;
end;

procedure TfmSyntheticTicketsList.frSyntheticsListBeforePrint(
  Sender: TfrxReportComponent);
begin
  frSyntheticsList.PreviewOptions.AllowEdit := False;
  frSyntheticsList.PreviewOptions.Buttons := frSyntheticsList.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frSyntheticsList.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frSyntheticsList.PreviewOptions.ZoomMode := zmDefault
  else
    frSyntheticsList.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmSyntheticTicketsList.frSyntheticsListGetValue(
  const VarName: string; var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;

  if (VarName = 'ReportTitle') then
  begin
    if not btnLayplans.Down then
    begin
      //Normal printout
      Value := 'Synthetic Tickets List';
    end
    else
    begin
      //Layplans printout
      Value := 'Synthetic Tickets List (Layplans)';
    end;
  end;
end;

procedure TfmSyntheticTicketsList.FillArray(Flag: Boolean);
var
  i: integer;

begin
  for i := 1 to Length(Selected) - 1 do
    Selected[i] := Flag;
end;

procedure TfmSyntheticTicketsList.btnSelectAllClick(Sender: TObject);
begin
  FillArray(True);
  qSyntheticTickets.Refresh;
end;

procedure TfmSyntheticTicketsList.btnDeselectAllClick(Sender: TObject);
begin
  FillArray(False);
  qSyntheticTickets.Refresh;
end;

procedure TfmSyntheticTicketsList.qSyntheticTicketsCalcFields(DataSet: TDataSet);
var
  TicketNo, s : string;

begin
  //CJY - Recording return of RecNo for workaround RecNo = 0 issue
  DataSet.FieldByName('RecNo').AsInteger := DataSet.RecNo;

  str(qSyntheticTicketsWeekNo.value, s);
  TicketNo := s;
  str(qSyntheticTicketsSequenceNo.value, s);
  TicketNo := TicketNo + '/' + s;
  str(qSyntheticTicketsTicketNo.value, s);
  TicketNo := TicketNo + '/' + s;

  qSyntheticTicketsFullTicketNumber.value := TicketNo;

  if (Length(Selected) <> 0) and
     (qSyntheticTickets.RecNo < Length(Selected)) then
    qSyntheticTicketsSelected.Value := Selected[qSyntheticTickets.RecNo];
end;

procedure TfmSyntheticTicketsList.btnGroupPrintClick(Sender: TObject);
begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  GroupPrint(False);

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmSyntheticTicketsList.dbgLayplansSelectedColumnMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
begin
  ColumnSelectedPosition := GetColumnSelectedPosition3(dbgLayplansSelected, INITIALSELECTEDCOLUMN);
end;

procedure TfmSyntheticTicketsList.dbgLayplansSelectedCellClick(Column: TColumn);
begin
  if Column.Field.FieldName = 'Selected' then
  begin
    Selected[qSyntheticTickets.RecNo] := not(Selected[qSyntheticTickets.RecNo]);
    qSyntheticTickets.Refresh;
  end;
end;

procedure TfmSyntheticTicketsList.btnLayplansClick(Sender: TObject);
var
  SyntheticTicketCount: integer;

begin
  if btnLayplans.Down then
  begin
    fmSyntheticTicketsList.caption := 'Synthetic Tickets List (Layplans)';

    SyntheticTicketCount := qSyntheticTickets.RecordCount;

    qSyntheticTickets.Filtered := True;
    //CJY skipping first / last row and Filtered
    if qSyntheticTickets.Active then
      qSyntheticTickets.Refresh;

    SyntheticTicketCount := SyntheticTicketCount - qSyntheticTickets.RecordCount;

    if (SyntheticTicketCount > 0) then
    begin
      MessageDlgPos(IntToStr(SyntheticTicketCount) + ' parts are using Legacy Synthetics Allowance.' + sLinebreak + sLinebreak +
                 'To include a part, disable its Legacy Synthetics Allowance'+ sLinebreak +
                 'and recreate the ticket.', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    end;


    pnlGroupButtons.Visible := True;

    fmSyntheticTicketsList.Width := 939;
    dbgLayplansSelected.Columns[4].Visible := True;
    dbgLayplansSelected.Columns[5].Visible := True;
    dbgLayplansSelected.Columns[6].Visible := True;
    dbgLayplansSelected.Columns[7].Visible := True;
    dbgLayplansSelected.Columns[9].Visible := True;
  end
  else
  begin
    fmSyntheticTicketsList.caption := 'Synthetic Tickets List';
    qSyntheticTickets.Filtered := False;
    //CJY skipping first / last row and Filtered
    if qSyntheticTickets.Active then
      qSyntheticTickets.Refresh;

    pnlGroupButtons.Visible := False;

    dbgLayplansSelected.Columns[4].Visible := False;
    dbgLayplansSelected.Columns[5].Visible := False;
    dbgLayplansSelected.Columns[6].Visible := False;
    dbgLayplansSelected.Columns[7].Visible := False;
    dbgLayplansSelected.Columns[9].Visible := False;
    fmSyntheticTicketsList.Width := 584;
  end;
end;

procedure TfmSyntheticTicketsList.qSyntheticTicketsAfterOpen(
  DataSet: TDataSet);
begin
  //CJY: qSyntheticTickets.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qSyntheticTickets.RecordCount + 1);
  FillArray(False);
end;

procedure TfmSyntheticTicketsList.qSyntheticTicketsAfterScroll(
  DataSet: TDataSet);
begin
  //CJY - qConstructions.RecNo sometimes returns 0 when attached to a DataGrid (when
  //      using .First and .Last). When scrolling is is possible to miss the first
  //      last values, especially when jumping to the start or the end (Ctrl + Home).
  if not (DataSet.FieldByName('RecNo').AsInteger > 0) then
    DataSet.Refresh;
end;

procedure TfmSyntheticTicketsList.CreateQuery(WeekNosString: string);
var
  s: string;

begin
  qSyntheticTickets.SQL.Clear;

  s := 'SELECT P.WeekNo, P.SequenceNo, P.TicketNo, TS.MaterialCode, P.KnifeCode,' +
       '       TS.SizeScale, P.Size, ' +
       '       IIF(M.Type = ''R'', ' + FloatToStrSQL(ROLLLENGTH_FT) + ' / (U.ToFeet / U.SubUnitsPerUnit), ' +
       '         M.Length) as Length, ' +
       '       M.Width as Width, ' +
       '       M.Cutgap, ' +
       '       IIF(M.CutType = ''R'', M.Code, '''') as RestrictiveMaterial, ' +
       '       P.Pairs, P.KnifeIndex, P.SizeIndex, ' +
       '       TS.MaterialSubUnitDesc, TS.MaterialSubUnitAbbreviation, TS.MaterialUnits, TS.SLMAllowance ' +
       'FROM TicketPairage P, TicketTickets TS, Material M, MatUnits U ' +
       'WHERE TS.WeekNo = P.WeekNo AND ' +
       '      TS.SequenceNo = P.SequenceNo AND ' +
       '      TS.TicketNo = P.TicketNo AND ' + '(' + WeekNosString + ') AND ' +
  //	    ((TS.MaterialType = 'R' OR TS.MaterialType = 'S') AND (TS.SLMAllowance = FALSE)) AND
       '     (TS.MaterialType = ''R'' OR TS.MaterialType = ''S'') AND ' +
       '     M.Code = TS.MaterialCode AND ' +
       '     U.Code = M.Units ' +
       'Order By P.WeekNo, P.WeekNo, P.SequenceNo, P.TicketNo, TS.MaterialCode, P.KnifeIndex, TS.SizeScale, P.SizeIndex ';

  qSyntheticTickets.SQL.Text := s;
  qSyntheticTickets.Open;
  qSyntheticTickets.RecNo := 1;
end;

procedure TfmSyntheticTicketsList.GroupPrint(Preview: Boolean);
var
  LayplanLoaded: Boolean;
  LayplanUnitsCreated: Boolean;

begin
  PrintingCancelled := False;
  LayplanUnitsCreated := False;

  if not ExistingToFront('Pattern Assessment', '') then
  begin
    if ExistingToFront('Synthetic Layplanning', '') then
      MessageDlgPos('Synthetic Layplanning already in use.', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
    begin
      Screen.cursor := crHourGlass;
      fmCancelPrinting.visible := True;

      try
        qSyntheticTickets.RecNo := 1; //CJY changed from qSyntheticTickets.First
        qSyntheticTickets.Prior; //CJY changed from qSyntheticTickets.First

        repeat
          if qSyntheticTicketsSelected.Value then
          begin
            if not LayplanUnitsCreated then
            begin
              fmLayplan := TfmLayplanAsChildViewer.create(fmSumms);
              fmAllPatterns := TfmAllPatterns.create(fmSumms);
              fmAllSyntheticMaterials := TfmAllSyntheticMaterials.create(fmSumms);
              fmAllLayplans := TfmAllLayplans.create(fmSumms);
              {$IFDEF DEBUGFULL}
              fmDebugger := TfmDebugger.create(fmSumms);
              {$ENDIF}
              fmLayplan.LoadingLayplanning := false;
              LayplanUnitsCreated := True;
            end;

            LayplanLoaded := fmLayplan.SATRASummInterface(fmSyntheticTicketsList,
                               qSyntheticTicketsKnifeCode.value,
                               qSyntheticTicketsSizeScale.value,
                               qSyntheticTicketsSize.value,
                               qSyntheticTicketsMaterialSubUnitDesc.value,
                               qSyntheticTicketsMaterialSubUnitAbbreviation.value,
                               qSyntheticTicketsLength.value,
                               qSyntheticTicketsWidth.value,
                               qSyntheticTicketsMaterialUnits.value,
                               qSyntheticTicketsCutGap.value,
                               qSyntheticTicketsRestrictiveMaterial.value);
            if LayplanLoaded then
              fmLayplan.PrintLayplan(Preview, False)
            else
              MessageDlgPos('Layplan for Ticket ' + qSyntheticTicketsFullTicketNumber.value + ' is not available', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

            GroupPrinting := True;
          end;

          qSyntheticTickets.Next;
        until qSyntheticTickets.eof or not fmCancelPrinting.visible or PrintingCancelled;

        qSyntheticTickets.RecNo := 1; //CJY changed from qSyntheticTickets.First
        qSyntheticTickets.Prior; //CJY changed from qSyntheticTickets.First

        if LayplanUnitsCreated then
          fmLayplan.Close;
      except
        fmMemoryError.TidyUp(self);
      end;
      GroupPrinting := False;

      fmCancelPrinting.visible := False;
      Screen.cursor := crDefault;
    end;
  end
  else
    MessageDlgPos('Close Pattern Assessment first', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
end;

procedure TfmSyntheticTicketsList.btnGroupPrintPreviewClick(
  Sender: TObject);
begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  GroupPrint(True);

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

end.
