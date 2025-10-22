unit AllKnifeSets;

interface

uses
  Classes, Controls, Forms, Types, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls, ExtCtrls, Menus, Buttons,
  ComCtrls, ToolWin, Grids, XStringGrid, XStringGridPlus, frxClass, frxDBSet,
  DBGridPlus, Vcl.DBGrids, frxReportPlus;

type
  TfmAllKnifeSets = class(TForm)
    dsqKnifeSets: TDataSource;
    dbgKnifeSets: TDBGridPlus;
    pmnuDragOperation: TPopupMenu;
    Insert1: TMenuItem;
    Append1: TMenuItem;
    N1: TMenuItem;
    tblKnifeSets: TFDTablePlus;
    pnlSearch: TPanel;
    edSearch: TEdit;
    qKnifeSets: TFDQueryPlus;
    qKnifeSetsCode: TStringField;
    qKnifeSetsDescription: TStringField;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    btnGroup: TSpeedButton;
    qGroupDelete: TFDQueryPlus;
    tblKnifeSetsCode: TStringField;
    tblKnifeSetsDescription: TStringField;
    pnlPrintButtons: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    pnlGroupButtons: TPanel;
    btnGroupPrint: TSpeedButton;
    btnGroupDelete: TSpeedButton;
    btnSelectAll: TSpeedButton;
    btnDeselectAll: TSpeedButton;
    dbgKnifeSetsSelected: TDBGridPlus;
    qKnifeSetsSelected: TBooleanField;
    sbMain: TStatusBar;
    rgType: TRadioGroup;
    frAllKnifeSets: TfrxReportPlus;
    frdbAllKinfeSets: TfrxDBDataset;
    lblSearch: TLabel;
    qKnifeSetsRecNo: TIntegerField;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edSearchChange(Sender: TObject);
    procedure dbgKnifeSetsOldKeyPress(Sender: TObject; var Key: Char);
    procedure dbgKnifeSetsDblClick(Sender: TObject);
    procedure dbgKnifeSetsKeyPress(Sender: TObject; var Key: Char);
    procedure Insert1Click(Sender: TObject);
    procedure Append1Click(Sender: TObject);
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
    procedure dbgKnifeSetsSelectedColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure qKnifeSetsCalcFields(DataSet: TDataSet);
    procedure dbgKnifeSetsSelectedCellClick(Column: TColumn);
    procedure dbgKnifeSetsTitleClick(Column: TColumn);
    procedure dbgKnifeSetsCellClick(Column: TColumn);
    procedure rgTypeClick(Sender: TObject);
    procedure frAllKnifeSetsGetValue(const VarName: string; var Value: Variant);
    procedure frAllKnifeSetsBeforePrint(Sender: TfrxReportComponent);
    procedure dbgKnifeSetsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure qKnifeSetsAfterScroll(DataSet: TDataSet);
    procedure qKnifeSetsAfterOpen(DataSet: TDataSet);
    procedure qKnifeSetsBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
    BusyPrinting: boolean;
    RefreshWarn: boolean;
    ActiveSearch : String;
    ColumnSelectedPosition: integer;
    Selected: array of Boolean;
  public
    { Public declarations }
  end;

var
  fmAllKnifeSets: TfmAllKnifeSets;

implementation

uses
  SysUtils, Windows, Graphics, Dialogs, General, SummsVars, CmnVars,
  KnifeSetDetails, Summs, OutOfMemory, CancelPrinting,
  Dongle_Green;

{$R *.DFM}

procedure TfmAllKnifeSets.FormClose(Sender: TObject;
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

      tblKnifeSets.close;
      qKnifeSets.close;
      action := caFree;
    except
      action := caNone;
      Raise;
    end;
  end;
end;

procedure TfmAllKnifeSets.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
  RefreshWarn := True;
end;

procedure TfmAllKnifeSets.dbgKnifeSetsDblClick(Sender: TObject);
var
  Code : string;
  Failed : boolean;
  fmKnifeSetDetails : TfmKnifeSetDetails;

begin
  Code := qKnifeSetsCode.value;

  if not (Code = '') then
  begin
    if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
    begin
      if not ExistingToFront('Knife', Code) then
      begin
        Screen.cursor := crHourGlass;
        Failed := false;
        try
          fmKnifeSetDetails := TfmKnifeSetDetails.create(fmSumms);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;

        if not Failed then
          fmKnifeSetDetails.PassKnifeName(fmKnifeSetDetails, Code);
      end;

      if fmSumms.mmMinimiseAllonOpen.checked then
        WindowState := wsMinimized;
    end;
  end;
end;

procedure TfmAllKnifeSets.edSearchChange(Sender: TObject);

begin
  if edSearch.Text = ActiveSearch then
  begin
    edSearch.Font.Color := OurColor(clWindowText);
    btnPrintPreview.Enabled := True;
    btnPrint.Enabled := True;
  end
  else
  begin
    edSearch.Font.Color := clRed;
    btnPrintPreview.Enabled := False;
    btnPrint.Enabled := False;
  end;
end;

procedure TfmAllKnifeSets.dbgKnifeSetsOldKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgKnifeSetsDblClick(Self);
end;

procedure TfmAllKnifeSets.dbgKnifeSetsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if y > TStringGrid(Sender).RowHeights[0] then
  begin
    if (ssLeft in Shift) then
    begin
      DragType := dragKnife;
      DragSort := dragAppend;
      DragCode := qKnifeSetsCode.value;

      TDBGridPlus(Sender).BeginDrag(False, MouseMovePixels);
    end;
  end;
end;

procedure TfmAllKnifeSets.dbgKnifeSetsKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgKnifeSetsDblClick(Self);
end;

procedure TfmAllKnifeSets.Insert1Click(Sender: TObject);
begin
  DragType := dragKnife;
  DragSort := dragInsert;
  DragCode := qKnifeSetsCode.value;
  dbgKnifeSets.BeginDrag(false);
end;

procedure TfmAllKnifeSets.Append1Click(Sender: TObject);
begin
  DragType := dragKnife;
  DragSort := dragAppend;
  DragCode := qKnifeSetsCode.value;
  dbgKnifeSets.BeginDrag(false);
end;

procedure TfmAllKnifeSets.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frAllKnifeSets.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qKnifeSets.GetBookmark;
  qKnifeSets.DisableControls;
  qKnifeSets.Refresh;

  frAllKnifeSets.PrintOptions.PrintMode := pmScale;
  frAllKnifeSets.PrintOptions.PrintOnSheet := GetPaperSize;
  frAllKnifeSets.PrepareReport;

  try
    qKnifeSets.GotoBookmark(MyBookmark);
  except
  end;
  qKnifeSets.EnableControls;
  qKnifeSets.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frAllKnifeSets do
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
    frAllKnifeSets.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllKnifeSets.btnGroupClick(Sender: TObject);
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
    //CJY tblKnifeSets replaced with qKnifeSets
    if not(qKnifeSets.Active) then
      qKnifeSets.Open
    //CJY Refresh for record count if previously active
    else
      qKnifeSets.Refresh;

    //CJY: qKnifeSets.FetchOptions.RecordCountMode set to cmTotal
    if qKnifeSets.RecordCount = 0 then
      btnGroup.Down := False
    else
    begin
      //Attempt Lock
      LockSuccess := LockGroupIncStatusBar(oKnifeSet, fmSumms.tblLocks, tblKnifeSets, sbMain);

      if not LockSuccess then
        btnGroup.Down := False
      else
      begin
  //      tblKnifeSets.first;
        dbgKnifeSetsSelected.Visible := True;
        dbgKnifeSets.Visible := False;
        pnlPrintButtons.Visible := False;
        pnlGroupButtons.Visible := True;
        pnlGroupButtons.Left := 72;
        edSearch.Enabled := False;
      end;
    end;
  end
  else
  begin
    btnGroup.Down := False;
    btnDeselectAll.Click;
    dbgKnifeSets.Visible := True;
    dbgKnifeSetsSelected.Visible := False;
    pnlPrintButtons.Visible := True;
    pnlGroupButtons.Visible := False;
    pnlPrintButtons.Left := 72;
    edSearch.Enabled := True;

    //Release Lock
    LocksUnLockRecordIncStatusBar(fmSumms.tblLocks, 'GROUP_KNIFESETS', sbMain)
  end;

  //Change Columns if Status of button
  //hasn't changed with this procedure
  //CJY: qKnifeSets.FetchOptions.RecordCountMode set to cmTotal
  if (btnGroup.Down = btnGroupDownStatus) or ((qKnifeSets.RecordCount = 0) and (Sender = btnGroupDelete)) then
    SetColumnWidthsAll3a(fmAllKnifeSets, dbgKnifeSets, dbgKnifeSetsSelected, ColumnSelectedPosition, 2, btnGroup.Down);

  WindowState := HoldWindowState;
  LockWindowUpdate(0);

  Screen.cursor := crDefault;
end;

procedure TfmAllKnifeSets.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;

  ActiveSearch := '';
  qKnifeSets.ParamByName('Search').AsString := '%';
  qKnifeSets.Open;

//CJY Moved to qKnifeSets.AfterOpen Event
{
  //CJY: qKnifeSets.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qKnifeSets.RecordCount + 1);
  FillArray(False);
}

  if not Option_ProductionSystem then
    dbgKnifeSets.Options := dbgKnifeSets.Options + [dgMultiSelect];

  ColumnSelectedPosition := 2;

  dbgKnifeSets.SortColumn := 0;
  dbgKnifeSets.SortOrder := soAscending;
  dbgKnifeSets.Refresh;
end;

procedure TfmAllKnifeSets.frAllKnifeSetsBeforePrint(
  Sender: TfrxReportComponent);
begin
  frAllKnifeSets.PreviewOptions.AllowEdit := False;
  frAllKnifeSets.PreviewOptions.Buttons := frAllKnifeSets.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllKnifeSets.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllKnifeSets.PreviewOptions.ZoomMode := zmDefault
  else
    frAllKnifeSets.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllKnifeSets.frAllKnifeSetsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'SearchStr') then
    Value := edSearch.Text;
  if (VarName = 'Type') then
  begin
    if (rgType.ItemIndex = 0) then
      Value := 'Leather & Synthetic'
    else if (rgType.ItemIndex = 1) then
      Value := 'Leather'
    else
      Value := 'Synthetic';
  end;
end;

procedure TfmAllKnifeSets.FillArray(Flag: Boolean);
var
  i: integer;

begin
  for i := 1 to Length(Selected) - 1 do
    Selected[i] := Flag;
end;

procedure TfmAllKnifeSets.btnRefreshClick(Sender: TObject);
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
    qKnifeSets.Close;
    if edSearch.Font.Color = clRed then
      qKnifeSets.ParamByName('Search').AsString := edSearch.text + '%';
    qKnifeSets.Open;

    if btnGroup.Down then
    begin
//CJY Redundant as it exists in qKnifeSets.AfterOpen
{
      //CJY: qKnifeSets.FetchOptions.RecordCountMode set to cmTotal
      SetLength(Selected, qKnifeSets.RecordCount + 1);
      FillArray(False);
}
      qKnifeSets.Refresh;
    end;

    edSearch.Font.Color := OurColor(clWindowText);
    btnPrintPreview.Enabled := True;
    btnPrint.Enabled := True;
    ActiveSearch := edSearch.Text;
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

procedure TfmAllKnifeSets.btnSelectAllClick(Sender: TObject);
begin
  FillArray(True);
  qKnifeSets.Refresh;
end;

procedure TfmAllKnifeSets.btnDeselectAllClick(Sender: TObject);
begin
  FillArray(False);
  qKnifeSets.Refresh;
end;

procedure TfmAllKnifeSets.btnGroupDeleteClick(Sender: TObject);
var
  QueryString: string;

begin
  Screen.cursor := crHourGlass;

  if MessageDlgPos('Delete selected Knives?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
  begin
    application.processmessages;

    qGroupDelete.SQL.Clear;
    QueryString := '';
    qKnifeSets.DisableControls;
    qKnifeSets.RecNo := 1; //CJY changed from qKnifeSets.First
    qKnifeSets.Prior; //CJY changed from qKnifeSets.First

    repeat
      if qKnifeSetsSelected.Value then
      begin
        QueryString := QueryString + 'TRY ' + #13 +
                                     'DELETE FROM KnifeSets ' + #13 +
                                     'WHERE Code = ''' + QS(qKnifeSetsCode.Value) + ''';' + #13 +
                                     'CATCH ALL ' + #13 +
                                     'END TRY; ' + #13;
      end;
      qKnifeSets.Next;
    until qKnifeSets.Eof;

    qKnifeSets.RecNo := 1; //CJY changed from qKnifeSets.First
    qKnifeSets.Prior; //CJY changed from qKnifeSets.First

    if QueryString <> '' then
    begin
      qGroupDelete.SQL.Text := QueryString;
      try
        qGroupDelete.ExecSQL;
      except
      end;
    end;

    RefreshWarn := False;
    btnRefresh.Click;
    RefreshWarn := True;

    MessageDlgPos('Deletion complete.' + #13#13 + 'Note: Only Knives that are not' + #13 + 'in use have been deleted.', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end;

  qKnifeSets.EnableControls;
  Screen.cursor := crDefault;

  //CJY: qKnifeSets.FetchOptions.RecordCountMode set to cmTotal
  if qKnifeSets.RecordCount = 0 then
    btnGroupClick(Sender);
end;

procedure TfmAllKnifeSets.edSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllKnifeSets.btnGroupPrintClick(Sender: TObject);
var
  Code: string;
  Failed: boolean;
  fmKnifeSetDetails: TfmKnifeSetDetails;

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

  qKnifeSets.DisableControls;

  repeat
    if qKnifeSetsSelected.Value then
    begin
      Failed := false;
      try
        fmKnifeSetDetails := TfmKnifeSetDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
      begin
        fmKnifeSetDetails.Enabled := False;
        Code := qKnifeSetsCode.Value;
        fmCancelPrinting.lblItem.caption := Code;
        fmKnifeSetDetails.PassKnifeName(fmKnifeSetDetails, Code);
        while fmKnifeSetDetails.SecondProcessInUse do
          application.ProcessMessages;
        fmKnifeSetDetails.btnPrint.Click;
        GroupPrinting := True;
        fmKnifeSetDetails.Close;
      end;
    end;
    qKnifeSets.Next;
  until qKnifeSets.eof or not fmCancelPrinting.visible or PrintingCancelled;

  btnGroupPrint.Enabled := True;

  qKnifeSets.EnableControls;

  Screen.cursor := crDefault;

  GroupPrinting := False;

  fmCancelPrinting.visible := False;
  fmSumms.enabled := True;
  tbMain.enabled := True;
  tbMain.setFocus;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllKnifeSets.dbgKnifeSetsSelectedColumnMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
begin
  ColumnSelectedPosition := GetColumnSelectedPosition3(dbgKnifeSetsSelected, 2);
end;

procedure TfmAllKnifeSets.qKnifeSetsAfterOpen(DataSet: TDataSet);
begin
  //CJY: qKnifeSets.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qKnifeSets.RecordCount + 1);
  FillArray(False);

  qKnifeSets.OnCalcFields := qKnifeSetsCalcFields;
end;

procedure TfmAllKnifeSets.qKnifeSetsAfterScroll(DataSet: TDataSet);
begin
  //CJY - qConstructions.RecNo sometimes returns 0 when attached to a DataGrid (when
  //      using .First and .Last). When scrolling is is possible to miss the first
  //      last values, especially when jumping to the start or the end (Ctrl + Home).
  if not (DataSet.FieldByName('RecNo').AsInteger > 0) then
    DataSet.Refresh;
end;

procedure TfmAllKnifeSets.qKnifeSetsBeforeOpen(DataSet: TDataSet);
begin
  qKnifeSets.OnCalcFields := nil;
end;

procedure TfmAllKnifeSets.qKnifeSetsCalcFields(DataSet: TDataSet);
begin
  //CJY - Recording return of RecNo for workaround RecNo = 0 issue
  DataSet.FieldByName('RecNo').AsInteger := DataSet.RecNo;

  if btnGroup.Down and
     (qKnifeSets.RecNo < Length(Selected)) then
    qKnifeSetsSelected.Value := Selected[qKnifeSets.RecNo];
end;

procedure TfmAllKnifeSets.rgTypeClick(Sender: TObject);
var
  LastPos, sPos: integer;
  Str1, str2: string;

begin
  sPos := Pos(':Search', qKnifeSets.SQL.Text);
  LastPos := Length(qKnifeSets.SQL.Text) - 1;
  str1 := Copy(qKnifeSets.SQL.Text, 1, sPos + 6);            //no space at end
  sPos := Pos('ORDER BY', qKnifeSets.SQL.Text);
  str2 := Copy(qKnifeSets.SQL.Text, sPos, LastPos);          //no space at beginning
  if (rgType.ItemIndex = 0) then
    qKnifeSets.SQL.Text := str1 + ' ' + str2
  else if (rgType.ItemIndex = 1) then
    qKnifeSets.SQL.Text := str1 + ' AND (([Type] = ''P'') or ([Type] = ''N'')) ' + str2
  else
    qKnifeSets.SQL.Text := str1 + ' AND ([Type] = ''S'') ' + str2;
  btnRefresh.Click;
end;

procedure TfmAllKnifeSets.dbgKnifeSetsSelectedCellClick(Column: TColumn);
begin
  if Column.Field.FieldName = 'Selected' then
  begin
    Selected[qKnifeSets.RecNo] := not(Selected[qKnifeSets.RecNo]);
    qKnifeSets.Refresh;
  end;
end;

procedure TfmAllKnifeSets.dbgKnifeSetsTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  if fmSumms.ActiveMDIChild = Self then
  begin
    screen.Cursor := crHourGlass;
    dbgKnifeSets.OnDblClick := nil;

    if (Column.FieldName = 'Code') or (Column.Fieldname = 'Description') then
    begin
      dbgKnifeSets.SortColumn := Column.Index;

      if dbgKnifeSets.SortOrder = soAscending then
      begin
        dbgKnifeSets.SortOrder := soDescending;
        SQLString := ' DESC';
      end
      else
      begin
        dbgKnifeSets.SortOrder := soAscending;
        SQLString := ' ASC';
      end;

      //CJY The Order By needs to be capital to be recognised in the rgType.Click
      //    The rgType.Click needs to be started to apply the rgType filter.
  {
      qKnifeSets.Close;
      qKnifeSets.SQL.Text := 'SELECT Code, Description FROM KnifeSets WHERE Code LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Code ' + SQLString ;
      qKnifeSets.Open;
  }

      qKnifeSets.SQL.Text := 'SELECT Code, Description FROM KnifeSets WHERE Code LIKE :Search ORDER BY UPPER(' + Column.FieldName + ') ' + SQLString + ', Code ' + SQLString ;
      //CJY This is NOT the ideal way of calling this!
      rgTypeClick(nil);
    end;

    screen.Cursor := crDefault;
  end;
end;

procedure TfmAllKnifeSets.dbgKnifeSetsCellClick(Column: TColumn);
begin
  dbgKnifeSets.OnDblClick := dbgKnifeSetsDblClick;
end;

end.

