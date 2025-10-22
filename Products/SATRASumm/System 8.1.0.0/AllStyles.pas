unit AllStyles;

interface

uses
  Classes, Controls, Forms, Types, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls, ExtCtrls, Buttons, ToolWin,
  ComCtrls, Grids, DBGridPlus, XStringGrid, XStringGridPlus, Dialogs, frxClass,
  frxDBSet, DBGrids, frxReportPlus;

type
  TfmAllStyles = class(TForm)
    dbgStyles: TDBGridPlus;
    dsqStyles: TDataSource;
    tblStyles: TFDTablePlus;
    qStyles: TFDQueryPlus;
    pnlSearch: TPanel;
    edSearch: TEdit;
    qStylesStyle: TStringField;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    btnGroup: TSpeedButton;
    qGroupDelete: TFDQueryPlus;
    tblStylesStyle: TStringField;
    tblStylesDescription: TStringField;
    qStylesDescription: TStringField;
    pnlPrintButtons: TPanel;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    pnlGroupButtons: TPanel;
    btnGroupPrint: TSpeedButton;
    btnGroupDelete: TSpeedButton;
    btnSelectAll: TSpeedButton;
    btnDeselectAll: TSpeedButton;
    dbgStylesSelected: TDBGridPlus;
    qStylesSelected: TBooleanField;
    sbMain: TStatusBar;
    qStylesCurrentCon: TStringField;
    btnStyleAllCostsOut: TSpeedButton;
    qGetStyleAllCostsInfo: TFDQueryPlus;
    sdFileOut: TSaveDialog;
    frAllStyles: TfrxReportPlus;
    frdbAllStyles: TfrxDBDataset;
    qTempTable: TFDQueryPlus;
    qGetStyleAllCostsInfoStyle: TStringField;
    qGetStyleAllCostsInfoSampleSize: TStringField;
    qGetStyleAllCostsInfoPart: TStringField;
    qGetStyleAllCostsInfoAltMaterial: TStringField;
    qGetStyleAllCostsInfoWidthNo: TSmallintField;
    qGetStyleAllCostsInfoWidth: TStringField;
    lblSearch: TLabel;
    qStylesRecNo: TIntegerField;
    cbSearchDescription: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgStylesDblClick(Sender: TObject);
    procedure edSearchChange(Sender: TObject);
    procedure dbgStylesKeyPress(Sender: TObject; var Key: Char);
    procedure btnPrintClick(Sender: TObject);
    procedure btnGroupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnDeselectAllClick(Sender: TObject);
    procedure btnGroupDeleteClick(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure btnGroupPrintClick(Sender: TObject);
    procedure FillArray(Flag: Boolean);
    procedure dbgStylesSelectedColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure qStylesCalcFields(DataSet: TDataSet);
    procedure dbgStylesSelectedCellClick(Column: TColumn);
    procedure dbgStylesTitleClick(Column: TColumn);
    procedure dbgStylesCellClick(Column: TColumn);
    procedure btnStyleAllCostsOutClick(Sender: TObject);
    procedure frAllStylesBeforePrint(Sender: TfrxReportComponent);
    procedure frAllStylesGetValue(const VarName: string; var Value: Variant);
    procedure qStylesAfterOpen(DataSet: TDataSet);
    procedure qStylesBeforeOpen(DataSet: TDataSet);
    procedure qStylesAfterScroll(DataSet: TDataSet);
    procedure sdFileOutShow(Sender: TObject);
    procedure cbSearchDescriptionClick(Sender: TObject);
  private
    { Private declarations }
    BusyPrinting: boolean;
    RefreshWarn: boolean;
    ActiveSearch: String;
    ActiveSearchDescription: Boolean;
    ColumnSelectedPosition: integer;
    Selected: array of Boolean;
    procedure SearchChanged;
    procedure SetSearchQuerySQL;
  public
    { Public declarations }
  end;

var
  fmAllStyles: TfmAllStyles;

implementation

uses
  SysUtils, Windows, Graphics, General, StyleDetails, Summs, OutOfMemory,
  SummsVars, CancelPrinting, Dongle_Green, BasicAlw, CmnVars;

{$R *.DFM}

procedure TfmAllStyles.FormClose(Sender: TObject;
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

      tblStyles.close;
      qStyles.close;
      action := caFree;
    except
      action := caNone;
      Raise;
    end;
  end;
end;

procedure TfmAllStyles.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
  RefreshWarn := True;
end;

procedure TfmAllStyles.dbgStylesDblClick(Sender: TObject);

var
  Code: string;
  Failed: boolean;
  fmStyleDetails: TfmStyleDetails;

begin
  Code := qStylesStyle.value;

  if not (Code = '') then
  begin
    if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
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
end;

procedure TfmAllStyles.edSearchChange(Sender: TObject);
begin
  SearchChanged;
end;

procedure TfmAllStyles.dbgStylesKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgStylesDblClick(Self);
end;

procedure TfmAllStyles.frAllStylesBeforePrint(
  Sender: TfrxReportComponent);
begin
  frAllStyles.PreviewOptions.AllowEdit := False;
  frAllStyles.PreviewOptions.Buttons := frAllStyles.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllStyles.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllStyles.PreviewOptions.ZoomMode := zmDefault
  else
    frAllStyles.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllStyles.frAllStylesGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;

  if (VarName = 'SearchStr') then
    Value := edSearch.Text;

  if (VarName = 'SearchInc') then
  begin
    if not cbSearchDescription.Checked then
      Value := ''
    else
      Value := 'Search Includes Description';
  end;
end;

procedure TfmAllStyles.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frAllStyles.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qStyles.GetBookmark;
  qStyles.DisableControls;
  qStyles.Refresh;

  frAllStyles.PrintOptions.PrintMode := pmScale;
  frAllStyles.PrintOptions.PrintOnSheet := GetPaperSize;
  frAllStyles.PrepareReport;

  try
    qStyles.GotoBookmark(MyBookmark);
  except
  end;
  qStyles.EnableControls;
  qStyles.FreeBookmark(MyBookmark);
  
  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frAllStyles do
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
    frAllStyles.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllStyles.btnGroupClick(Sender: TObject);
var
  LockSuccess, btnGroupDownStatus: Boolean;
  HoldWindowState: TWindowState;
  
begin
  Screen.cursor := crHourGlass;

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
    //CJY tblStyles replaced with qStyles
    if not(qStyles.Active) then
      qStyles.Open
    //CJY Refresh for record count if previously active
    else
      qStyles.Refresh;

    //CJY: qStyles.FetchOptions.RecordCountMode set to cmTotal
    if qStyles.RecordCount = 0 then
      btnGroup.Down := False
    else
    begin
      //Attempt Lock
      LockSuccess := LockGroupIncStatusBar(oStyle, fmSumms.tblLocks, tblStyles, sbMain);

      if not LockSuccess then
        btnGroup.Down := False
      else
      begin
//        tblStyles.first;
        dbgStylesSelected.Visible := True;
        dbgStyles.Visible := False;
        pnlPrintButtons.Visible := False;
        pnlGroupButtons.Visible := True;
        pnlGroupButtons.Left := 72;
        edSearch.Enabled := False;
        cbSearchDescription.Enabled := False;
      end;
    end;
  end
  else
  begin
    btnGroup.Down := False;
    btnDeselectAll.Click;
    dbgStyles.Visible := True;
    dbgStylesSelected.Visible := False;
    pnlGroupButtons.Visible := False;
    pnlPrintButtons.Visible := True;
    pnlPrintButtons.Left := 72;
    edSearch.Enabled := True;
    cbSearchDescription.Enabled := True;

    //Release Lock
    LocksUnLockRecordIncStatusBar(fmSumms.tblLocks, 'GROUP_STYLES', sbMain)
  end;

  //Change Columns if Status of button
  //hasn't changed with this procedure
  //CJY: qStyles.FetchOptions.RecordCountMode set to cmTotal
  if (btnGroup.Down = btnGroupDownStatus) or ((qStyles.RecordCount = 0) and (Sender = btnGroupDelete)) then
    SetColumnWidthsAll3a(fmAllStyles, dbgStyles, dbgStylesSelected, ColumnSelectedPosition, 2, btnGroup.Down);

  WindowState := HoldWindowState;
  LockWindowUpdate(0);

  Screen.cursor := crDefault;
end;

procedure TfmAllStyles.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;

  dbgStyles.SortColumn := 0;
  dbgStyles.SortOrder := soAscending;

  ActiveSearch := '';
  ActiveSearchDescription := cbSearchDescription.Checked;
  SetSearchQuerySQL;
  qStyles.Open;

  cbSearchDescription.Checked := SearchStyleDescriptionDefault;

//CJY Moved to qSuppliers.AfterOpen Event
{
  //CJY: qStyles.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qStyles.RecordCount + 1);
  FillArray(False);
}

  ColumnSelectedPosition := 2;
end;

procedure TfmAllStyles.FillArray(Flag: Boolean);
var
  i: integer;

begin
  for i := 1 to Length(Selected) - 1 do
    Selected[i] := Flag;
end;

procedure TfmAllStyles.btnRefreshClick(Sender: TObject);
var
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
    qStyles.Close;
    if edSearch.Font.Color = clRed then
      SetSearchQuerySQL;
    qStyles.Open;

    if btnGroup.Down then
    begin
//CJY Redundant as it exists in qStyles.AfterOpen
{
      //CJY: qStyles.FetchOptions.RecordCountMode set to cmTotal
      SetLength(Selected, qStyles.RecordCount + 1);
      FillArray(False);
}
      qStyles.Refresh;
    end;

    edSearch.Font.Color := OurColor(clWindowText);
    btnPrintPreview.Enabled := True;
    btnPrint.Enabled := True;
    ActiveSearch := edSearch.Text;
    ActiveSearchDescription := cbSearchDescription.Checked;
  end;

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

procedure TfmAllStyles.btnSelectAllClick(Sender: TObject);
begin
  FillArray(True);
  qStyles.Refresh;
end;

function Padded(TheString: string; ReqLength: integer): string;
var
  RemLen: integer;
begin
  RemLen := ReqLength - Length(TheString);
  Result := TheString + StringOfChar(' ', RemLen);
end;

procedure TfmAllStyles.btnStyleAllCostsOutClick(Sender: TObject);
var
  AltMat, CGAlw, ErrorString, PartCode, QueryString, SampleSizeCode, StyleCode, UnitsStr: string;
  CostingGrid: GridArray;
  i, NumberOfSizes: integer;
  WidthNum: short;
  OutFile: TextFile;
  FirstTime: Boolean;

begin
  ErrorString := '';

  if DirectoryExists(TicketsDirectory) then
    sdFileOut.InitialDir := TicketsDirectory
  else
  begin
    MessageDlgPos('Parameters | Tickets directory does not exist', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    sdFileOut.InitialDir := ExtractFileDrive(ExpandFileName(Application.EXEName));
  end;

  if sdFileOut.Execute then
  begin
    if MessageDlgPos('This may take a significant amount of time depending' + #13 +
                  'upon the number of styles selected. Continue?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
    begin
      screen.Cursor := crHourGlass;
      application.processmessages;

      qStyles.DisableControls;

      qTempTable.SQL.Text := 'TRY' +
                             ' DROP TABLE #Temp1; ' +
                             'CATCH ALL ' +
                             'END TRY; ' +

                             'CREATE TABLE #Temp1(Style char(20), SampleSize char(10), Part char(20), ' +
                              'AltMaterial char(20), WidthNo integer, Width Char(10)); ' +

                             'INSERT INTO #Temp1 ' +
                              'SELECT DISTINCT S.Style, C.SampleSize, CP.Part,' +
                              ' CP.AltMaterial, PWK.WidthNo, W.Width ' +
                              'FROM ConParts CP, PtWidKnf PWK, Construc C, Styles S, Widths W ' +
                              'WHERE PWK.Part = CP.Part AND W.No = PWK.WidthNo AND' +
                              ' C.Construction = S.CurrentCon AND C.Construction = CP.Construction;';
      qTempTable.ExecSQL;

      qStyles.RecNo := 1; //CJY changed from qStyles.First
      qStyles.Prior; //CJY changed from qStyles.First
      FirstTime := True;
      repeat
        if qStylesSelected.Value and not qStylesCurrentCon.IsNull then
        begin
          if FirstTime then
          begin
            QueryString := 'SELECT Style, SampleSize, Part, AltMaterial, WidthNo, Width ' +
                           'FROM #Temp1 ' +
                           'WHERE Style = ''' + qStylesStyle.Value + ''' ';

            FirstTime := False;
          end
          else
            QueryString := QueryString + 'OR Style = ''' + qStylesStyle.Value + ''' ';
        end;

        qStyles.Next;
      until qStyles.eof;

      qGetStyleAllCostsInfo.SQL.Text := QueryString;

      if QueryString <> '' then
      begin
        assignfile(OutFile, sdFileOut.FileName);
        rewrite(OutFile);
        qGetStyleAllCostsInfo.Open;

        writeln(OutFile, 'Style                ', 'Part                 ', 'Sample Sz  ',
          'Material             ', 'Width      ', 'Size       ', 'Allowance ' + UnitsStr);

        qGetStyleAllCostsInfo.RecNo := 1; //CJY changed from qGetStyleAllCostsInfo.First
        qGetStyleAllCostsInfo.Prior; //CJY changed from qGetStyleAllCostsInfo.First
        while not qGetStyleAllCostsInfo.eof  do
        begin
          if qGetStyleAllCostsInfoAltMaterial.IsNull then
            AltMat := ''
          else
            AltMat := qGetStyleAllCostsInfoAltMaterial.Value;

          StyleCode := qGetStyleAllCostsInfoStyle.Value;
          PartCode := qGetStyleAllCostsInfoPart.Value;
          WidthNum := qGetStyleAllCostsInfoWidthNo.Value;

          dmBasAll.AllowanceAllCosts(PartCode, WidthNum, CostingGrid, NumberOfSizes, AltMat, UnitsStr);

          for i := 1 to NumberOfSizes do
          begin
            if not(CostingGrid[i].Error = '') and not(Pos(CostingGrid[i].Error, ErrorString) > 0) then
              ErrorString := ErrorString + CostingGrid[i].Error + #13
            else
            begin
              str(CostingGrid[i].AdjustedAllowance: 7: 4, CGAlw);

              writeln(OutFile, Padded(qGetStyleAllCostsInfoStyle.Value, 21),
                Padded(qGetStyleAllCostsInfoPart.Value, 21),
                Padded(qGetStyleAllCostsInfoSampleSize.Value, 11),
                Padded(AltMat, 21), Padded(qGetStyleAllCostsInfoWidth.Value, 11),
                Padded(CostingGrid[i].Size, 11), CGAlw);
            end;
          end;
          qGetStyleAllCostsInfo.Next;
        end;
        CloseFile(OutFile);
        MessageDlgPos('Style allowances saved', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      end
      else
        MessageDlgPos('No data', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

      RefreshWarn := False;
      btnRefresh.Click;
      RefreshWarn := True;

      if not (ErrorString = '') then
        MessageDlgPos('File contains some zero allowances due to errors shown:- ' + #13 + #13 +
          ErrorString, mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    end;
  end;
  qGetStyleAllCostsInfo.Close;
  qGetStyleAllCostsInfo.Disconnect;  //AdsCloseSQLStatement replaced by Disconnect when converted to FireDac

  qTempTable.SQL.Text := 'TRY' +
                         ' DROP TABLE #Temp1; ' +
                         'CATCH ALL ' +
                         'END TRY; ';
  qTempTable.ExecSQL;

  qStyles.EnableControls;
  Screen.cursor := crDefault;
end;

procedure TfmAllStyles.cbSearchDescriptionClick(Sender: TObject);
begin
  SearchChanged;
end;

procedure TfmAllStyles.btnDeselectAllClick(Sender: TObject);
begin
  FillArray(False);
  qStyles.Refresh;
end;

procedure TfmAllStyles.btnGroupDeleteClick(Sender: TObject);
var
  QueryString: string;

begin
  Screen.cursor := crHourGlass;

  if MessageDlgPos('Delete selected Styles?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
  begin
    application.processmessages;

    qGroupDelete.SQL.Clear;
    QueryString := '';
    qStyles.DisableControls;
    qStyles.RecNo := 1; //CJY changed from qStyles.First
    qStyles.Prior; //CJY changed from qStyles.First

    repeat
      if qStylesSelected.Value then
      begin
        QueryString := QueryString + 'UPDATE Styles ' + #13 +
                                     'SET CurrentCon = NULL' + #13 +
                                     'WHERE Style = ''' + QS(qStylesStyle.Value) + ''';' + #13;

        QueryString := QueryString + 'TRY ' + #13 +
                                     'DELETE FROM Styles ' + #13 +
                                     'WHERE Style = ''' + QS(qStylesStyle.Value) + ''';' + #13 +
                                     'CATCH ALL ' + #13 +
                                     'END TRY; ' + #13;

        if AutoDeleteConstruction then
        begin
          QueryString := QueryString + 'TRY ' + #13 +
                                       'DELETE FROM Construc ' + #13 +
                                       'WHERE Construction = ''' + QS(qStylesStyle.Value) + ''';' + #13 +
                                       'CATCH ALL ' + #13 +
                                       'END TRY; ' + #13;
        end;
      end;
      qStyles.Next;
    until qStyles.eof;

    qStyles.RecNo := 1; //CJY changed from qStyles.First
    qStyles.Prior; //CJY changed from qStyles.First

    if QueryString <> '' then
    begin
      qGroupDelete.SQL.Text := QueryString;
      qGroupDelete.ExecSQL;
    end;

    RefreshWarn := False;
    btnRefresh.Click;
    RefreshWarn := True;

    //Styles ALWAYS deleted
    MessageDlgPos('Deletion complete', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  end;

  qStyles.EnableControls;
  Screen.cursor := crDefault;

  //CJY: qStyles.FetchOptions.RecordCountMode set to cmTotal
  if qStyles.RecordCount = 0 then
    btnGroupClick(Sender);
end;

procedure TfmAllStyles.edSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllStyles.btnGroupPrintClick(Sender: TObject);
var
  Code: string;
  Failed: boolean;
  fmStyleDetails: TfmStyleDetails;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  PrintingCancelled := False;
  tbMain.enabled := False;
  fmSumms.enabled := False;
  fmCancelPrinting.visible := True;

  GroupPrinting := False;

  Screen.cursor := crHourGlass;

  btnGroupPrint.Enabled := False;

  qStyles.DisableControls;
  qStyles.RecNo := 1; //CJY changed from qStyles.First
  qStyles.Prior; //CJY changed from qStyles.First
  repeat
    if qStylesSelected.Value then
    begin
      Failed := false;
      try
        fmStyleDetails := TfmStyleDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
      begin
        fmStyleDetails.Enabled := False;
        Code := qStylesStyle.Value;
        fmCancelPrinting.lblItem.caption := Code;
        fmStyleDetails.PassStyleName(fmStyleDetails, Code);
        fmStyleDetails.btnPrint.Click;
        GroupPrinting := True;
        fmStyleDetails.Close;
      end;
    end;
    qStyles.Next;
  until qStyles.eof or not fmCancelPrinting.visible or PrintingCancelled;

  btnGroupPrint.Enabled := True;

  Screen.cursor := crDefault;

  qStyles.EnableControls;

  GroupPrinting := False;

  fmCancelPrinting.visible := False;
  fmSumms.enabled := True;
  tbMain.enabled := True;
  tbMain.setFocus;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllStyles.dbgStylesSelectedColumnMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
begin
  ColumnSelectedPosition := GetColumnSelectedPosition3(dbgStylesSelected, 2);
end;

procedure TfmAllStyles.qStylesAfterOpen(DataSet: TDataSet);
begin
  //CJY: qStyles.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qStyles.RecordCount + 1);
  FillArray(False);

  qStyles.OnCalcFields := qStylesCalcFields;
end;

procedure TfmAllStyles.qStylesAfterScroll(DataSet: TDataSet);
begin
  //CJY - qConstructions.RecNo sometimes returns 0 when attached to a DataGrid (when
  //      using .First and .Last). When scrolling is is possible to miss the first
  //      last values, especially when jumping to the start or the end (Ctrl + Home).
  if not (DataSet.FieldByName('RecNo').AsInteger > 0) then
    DataSet.Refresh;
end;

procedure TfmAllStyles.qStylesBeforeOpen(DataSet: TDataSet);
begin
  qStyles.OnCalcFields := nil;
end;

procedure TfmAllStyles.qStylesCalcFields(DataSet: TDataSet);
begin
  //CJY - Recording return of RecNo for workaround RecNo = 0 issue
  DataSet.FieldByName('RecNo').AsInteger := DataSet.RecNo;

  if btnGroup.Down and
     (qStyles.RecNo < Length(Selected)) then
    qStylesSelected.Value := Selected[qStyles.RecNo];
end;

procedure TfmAllStyles.sdFileOutShow(Sender: TObject);
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

procedure TfmAllStyles.SearchChanged;
begin
  if (edSearch.Text = ActiveSearch) and (cbSearchDescription.Checked = ActiveSearchDescription) then
  begin
    edSearch.Font.Color := OurColor(clWindowText);
    btnPrintPreview.Enabled := True;
    btnPrint.Enabled := True;
  end
  else
  begin
    btnPrintPreview.Enabled := False;
    btnPrint.Enabled := False;
    edSearch.Font.Color := clRed;
  end;
end;

procedure TfmAllStyles.SetSearchQuerySQL;
var
  SQLUpDown: string;

begin
  if dbgStyles.SortOrder = soAscending then
    SQLUpDown := 'ASC'
  else
    SQLUpDown := 'DESC';

  qStyles.SQL.Clear;
  qStyles.SQL.Add('SELECT Style, Description, CurrentCon');
  qStyles.SQL.Add('FROM Styles');
  if edSearch.Text <> '' then
  begin
    if not cbSearchDescription.Checked then
      qStyles.SQL.Add('WHERE UPPER(Style) LIKE ''' + edSearch.text + '%''')
    else
    begin
      qStyles.SQL.Add('WHERE ((UPPER(Style) LIKE ''' + edSearch.text + '%'') OR ');
      qStyles.SQL.Add('       (UPPER(Description) LIKE ''%' + edSearch.text + '%''))');
    end;
  end;
  if (dbgStyles.SortColumn = 0) then
    qStyles.SQL.Add('ORDER BY Style ' + SQLUpDown + ', Style ' + SQLUpDown)
  else
    qStyles.SQL.Add('ORDER BY UPPER(Description) ' + SQLUpDown + ', Style ' + SQLUpDown);
end;

procedure TfmAllStyles.dbgStylesSelectedCellClick(Column: TColumn);
begin
  if Column.Field.FieldName = 'Selected' then
  begin
    Selected[qStyles.RecNo] := not(Selected[qStyles.RecNo]);
    qStyles.Refresh;
  end;
end;

procedure TfmAllStyles.dbgStylesTitleClick(Column: TColumn);
begin
  if fmSumms.ActiveMDIChild = Self then
  begin
    dbgStyles.OnDblClick := nil;

    if (Column.FieldName = 'Style') or (Column.Fieldname = 'Description') then
    begin
      dbgStyles.SortColumn := Column.Index;

      if dbgStyles.SortOrder = soAscending then
        dbgStyles.SortOrder := soDescending
      else
        dbgStyles.SortOrder := soAscending;

      qStyles.Close;
      SetSearchQuerySQL;
      qStyles.Open;
    end;
  end;
end;

procedure TfmAllStyles.dbgStylesCellClick(Column: TColumn);
begin
  dbgStyles.OnDblClick := dbgStylesDblClick;
end;

end.




