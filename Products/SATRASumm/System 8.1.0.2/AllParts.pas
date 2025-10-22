unit AllParts;

interface

uses
  Classes, Controls, Forms, Types,  DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls, ExtCtrls, Menus, Buttons,
  ComCtrls, ToolWin, Grids,  XStringGrid, XStringGridPlus, frxClass, frxDBSet,
  DBGridPlus, Vcl.DBGrids, frxReportPlus;

type
  TfmAllParts = class(TForm)
    dbgParts: TDBGridPlus;
    dsqParts: TDataSource;
    pmnuDragOperation: TPopupMenu;
    Insert1: TMenuItem;
    Append1: TMenuItem;
    N1: TMenuItem;
    tblParts: TFDTablePlus;
    qParts: TFDQueryPlus;
    qPartsCode: TStringField;
    qPartsDescription: TStringField;
    pnlSearch: TPanel;
    edSearch: TEdit;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    btnGroup: TSpeedButton;
    qGroupDelete: TFDQueryPlus;
    tblPartsCode: TStringField;
    tblPartsDescription: TStringField;
    pnlPrintButtons: TPanel;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    pnlGroupButtons: TPanel;
    btnGroupPrint: TSpeedButton;
    btnGroupDelete: TSpeedButton;
    btnSelectAll: TSpeedButton;
    btnDeselectAll: TSpeedButton;
    tblPartsMaterial: TStringField;
    tblPartsSizeRange: TStringField;
    tblPartsWidthRange: TStringField;
    tblPartsCostedSize: TStringField;
    tblPartsSampleSize: TStringField;
    tblPartsCostedAllowance: TFloatField;
    dbgPartsSelected: TDBGridPlus;
    qPartsSelected: TBooleanField;
    sbMain: TStatusBar;
    frAllParts: TfrxReportPlus;
    frdbAllParts: TfrxDBDataset;
    qPartsMaterial: TStringField;
    qPartsMatDesc: TStringField;
    lblSearch: TLabel;
    qPartsRecNo: TIntegerField;
    procedure dbgPartsDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edSearchChange(Sender: TObject);
    procedure dbgPartsKeyPress(Sender: TObject; var Key: Char);
    procedure Insert1Click(Sender: TObject);
    procedure Append1Click(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGroupClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnDeselectAllClick(Sender: TObject);
    procedure btnGroupDeleteClick(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure btnGroupPrintClick(Sender: TObject);
    procedure FillArray(Flag: Boolean);
    procedure dbgPartsSelectedColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure qPartsCalcFields(DataSet: TDataSet);
    procedure dbgPartsSelectedCellClick(Column: TColumn);
    procedure dbgPartsTitleClick(Column: TColumn);
    procedure dbgPartsCellClick(Column: TColumn);
    procedure frAllPartsBeforePrint(Sender: TfrxReportComponent);
    procedure frAllPartsGetValue(const VarName: string; var Value: Variant);
    procedure qPartsAfterOpen(DataSet: TDataSet);
    procedure qPartsBeforeOpen(DataSet: TDataSet);
    procedure dbgPartsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure qPartsAfterScroll(DataSet: TDataSet);
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
  fmAllParts: TfmAllParts;

implementation

uses
  SysUtils, Windows, Graphics, Dialogs, General, SummsVars, CmnVars, PartDetails, Summs, OutOfMemory,
  CancelPrinting, Dongle_Green;

{$R *.DFM}

procedure TfmAllParts.FormClose(Sender: TObject;
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

      tblParts.close;
      qParts.close;
      action := caFree;
    except
      action := caNone;
      Raise;
    end;
  end;
end;

procedure TfmAllParts.FormActivate(Sender: TObject);
begin
  Screen.Cursor := crDefault;
  RefreshWarn := True;
end;

procedure TfmAllParts.dbgPartsDblClick(Sender: TObject);
var
  fmPartDetails : TfmPartDetails;
  Code : string;
  Failed : boolean;

begin
  Code := qPartsCode.value;

  if not (Code = '') then
  begin
    if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
    begin
      if not ExistingToFront('Part', Code) then
      begin
        Screen.cursor := crHourGlass;
        Failed := false;
        try
          fmPartDetails := TfmPartDetails.create(fmSumms);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;
        if not Failed then
          fmPartDetails.PassPartName(fmPartDetails, Code);
      end;

      if fmSumms.mmMinimiseAllonOpen.checked then
        WindowState := wsMinimized;
    end;
  end;
end;

procedure TfmAllParts.edSearchChange(Sender: TObject);
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

procedure TfmAllParts.dbgPartsKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgPartsDblClick(Self);
end;

procedure TfmAllParts.dbgPartsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if y > TStringGrid(Sender).RowHeights[0] then
  begin
    if (ssLeft in Shift) then
    begin
      DragType := dragPart;
      DragSort := dragAppend;
      DragCode := qPartsCode.value;

      TDBGridPlus(Sender).BeginDrag(False, MouseMovePixels);
    end;
  end;
end;

procedure TfmAllParts.Insert1Click(Sender: TObject);
begin
  DragType := dragPart;
  DragSort := dragInsert;
  DragCode := qPartsCode.value;
  dbgParts.BeginDrag(false);
end;

procedure TfmAllParts.Append1Click(Sender: TObject);
begin
  DragType := dragPart;
  DragSort := dragAppend;
  DragCode := qPartsCode.value;
  dbgParts.BeginDrag(false);
end;

procedure TfmAllParts.frAllPartsBeforePrint(
  Sender: TfrxReportComponent);
begin
  frAllParts.PreviewOptions.AllowEdit := False;
  frAllParts.PreviewOptions.Buttons := frAllParts.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllParts.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllParts.PreviewOptions.ZoomMode := zmDefault
  else
    frAllParts.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllParts.frAllPartsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'SearchStr') then
    Value := edSearch.Text;
end;

procedure TfmAllParts.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frAllParts.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qParts.GetBookmark;
  qParts.DisableControls;
  qParts.Refresh;

  frAllParts.PrintOptions.PrintMode := pmScale;
  frAllParts.PrintOptions.PrintOnSheet := GetPaperSize;
  frAllParts.PrepareReport;

  try
    qParts.GotoBookmark(MyBookmark);
  except
  end;
  qParts.EnableControls;
  qParts.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frAllParts do
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
    frAllParts.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllParts.btnGroupClick(Sender: TObject);
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
    //CJY btlParts replaced with qParts
    if not(qParts.Active) then
      qParts.Open
    //CJY Refresh for record count if previously active
    else
      qParts.Refresh;

    //CJY: qParts.FetchOptions.RecordCountMode set to cmTotal
    if qParts.RecordCount = 0 then
      btnGroup.Down := False
    else
    begin
       //Attempt Lock
      LockSuccess := LockGroupIncStatusBar(oPart, fmSumms.tblLocks, tblParts, sbMain);

      if not LockSuccess then
        btnGroup.Down := False
      else
      begin
//        tblParts.first;
        dbgPartsSelected.Visible := True;
        dbgParts.Visible := False;
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
    dbgParts.Visible := True;
    dbgPartsSelected.Visible := False;
    pnlGroupButtons.Visible := False;
    pnlPrintButtons.Visible := True;
    pnlPrintButtons.Left := 72;
    edSearch.Enabled := True;

    //Release Lock
    LocksUnLockRecordIncStatusBar(fmSumms.tblLocks, 'GROUP_PARTS', sbMain)
  end;

  //Change Columns if Status of button
  //hasn't changed with this procedure
  //CJY: qParts.FetchOptions.RecordCountMode set to cmTotal
  if (btnGroup.Down = btnGroupDownStatus) or ((qParts.RecordCount = 0) and (Sender = btnGroupDelete)) then
    SetColumnWidthsAll3a(fmAllParts, dbgParts, dbgPartsSelected, ColumnSelectedPosition, 4, btnGroup.Down);

  WindowState := HoldWindowState;
  LockWindowUpdate(0);

  Screen.cursor := crDefault;
end;

procedure TfmAllParts.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;

  ActiveSearch := '';
  qParts.ParamByName('Search').AsString := '%';
  qParts.Open;

//CJY Moved to qParts.AfterOpen Event
{
  //CJY: qParts.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qParts.RecordCount + 1);
  FillArray(False);
}

  ColumnSelectedPosition := 4;

  dbgParts.SortColumn := 0;
  dbgParts.SortOrder := soAscending;
  dbgParts.Refresh;
end;

procedure TfmAllParts.FillArray(Flag: Boolean);
var
  i: integer;

begin
  for i := 1 to Length(Selected) - 1 do
    Selected[i] := Flag;
end;

procedure TfmAllParts.btnRefreshClick(Sender: TObject);
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
    qParts.Close;
    if edSearch.Font.Color = clRed then
      qParts.ParamByName('Search').AsString := edSearch.text + '%';
    qParts.Open;

    if btnGroup.Down then
    begin
//CJY Redundant as it exists in qParts.AfterOpen
{
      //CJY: qParts.FetchOptions.RecordCountMode set to cmTotal
      SetLength(Selected, qParts.RecordCount + 1);
      FillArray(False);
}
      qParts.Refresh;
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

procedure TfmAllParts.btnSelectAllClick(Sender: TObject);
begin
  FillArray(True);
  qParts.Refresh;
end;

procedure TfmAllParts.btnDeselectAllClick(Sender: TObject);
begin
  FillArray(False);
  qParts.Refresh;
end;

procedure TfmAllParts.btnGroupDeleteClick(Sender: TObject);
var
  QueryString: string;

begin
  Screen.cursor := crHourGlass;

  if MessageDlgPos('Delete selected Parts?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
  begin
    application.processmessages;

    qGroupDelete.SQL.Clear;
    QueryString := '';
    qParts.DisableControls;
    qParts.RecNo := 1; //CJY changed from qParts.First
    qParts.Prior; //CJY changed from qParts.First

    repeat
      if qPartsSelected.Value then
      begin
        QueryString := QueryString + 'TRY ' + #13 +
                                     'DELETE FROM Parts ' + #13 +
                                     'WHERE Code = ''' + QS(qPartsCode.Value) + ''';' + #13 +
                                     'CATCH ALL ' + #13 +
                                     'END TRY; ' + #13;
      end;
      qParts.Next;
    until qParts.Eof;

    if QueryString <> '' then
    begin
      qGroupDelete.SQL.Text := QueryString;
      qGroupDelete.ExecSQL;
    end;

    RefreshWarn := False;
    btnRefresh.Click;
    RefreshWarn := True;

    MessageDlgPos('Deletion complete.' + #13#13 + 'Note: Only Parts that are not' + #13 + 'in use have been deleted.', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end;

  qParts.EnableControls;
  Screen.cursor := crDefault;

  //CJY: qParts.FetchOptions.RecordCountMode set to cmTotal
  if qParts.RecordCount = 0 then
    btnGroupClick(Sender);
end;

procedure TfmAllParts.edSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllParts.btnGroupPrintClick(Sender: TObject);
var
  Code: string;
  Failed: boolean;
  fmPartDetails: TfmPartDetails;

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

  qParts.DisableControls;
  qParts.RecNo := 1; //CJY changed from qParts.First
  qParts.Prior; //CJY changed from qParts.First
  repeat
    if qPartsSelected.Value then
    begin
      Failed := false;
      try
        fmPartDetails := TfmPartDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
      begin
        fmPartDetails.Enabled := False;
        Code := qPartsCode.Value;
        fmCancelPrinting.lblItem.caption := Code;
        fmPartDetails.PassPartName(fmPartDetails, Code);
        while fmPartDetails.SecondProcessInUse do
          application.ProcessMessages;
        fmPartDetails.btnPrint.Click;
        GroupPrinting := True;
        fmPartDetails.Close;
      end;
    end;
    qParts.Next;
  until qParts.eof or not fmCancelPrinting.visible or PrintingCancelled;

  btnGroupPrint.Enabled := True;

  Screen.cursor := crDefault;

  GroupPrinting := False;

  qParts.EnableControls;

  fmCancelPrinting.visible := False;
  fmSumms.enabled := True;
  tbMain.enabled := True;
  tbMain.setFocus;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllParts.dbgPartsSelectedColumnMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
begin
  ColumnSelectedPosition := GetColumnSelectedPosition3(dbgPartsSelected, 2);
end;

procedure TfmAllParts.qPartsAfterOpen(DataSet: TDataSet);
begin
  //CJY: qParts.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qParts.RecordCount + 1);
  FillArray(False);

  qParts.OnCalcFields := qPartsCalcFields;
end;

procedure TfmAllParts.qPartsAfterScroll(DataSet: TDataSet);
begin
  //CJY - qConstructions.RecNo sometimes returns 0 when attached to a DataGrid (when
  //      using .First and .Last). When scrolling is is possible to miss the first
  //      last values, especially when jumping to the start or the end (Ctrl + Home).
  if not (DataSet.FieldByName('RecNo').AsInteger > 0) then
    DataSet.Refresh;
end;

procedure TfmAllParts.qPartsBeforeOpen(DataSet: TDataSet);
begin
  qParts.OnCalcFields := Nil;
end;

procedure TfmAllParts.qPartsCalcFields(DataSet: TDataSet);
begin
  //CJY - Recording return of RecNo for workaround RecNo = 0 issue
  DataSet.FieldByName('RecNo').AsInteger := DataSet.RecNo;

  if btnGroup.Down and
     (qParts.RecNo < Length(Selected)) then
    qParts.FieldByName('Selected').Value := Selected[qParts.RecNo];
end;

procedure TfmAllParts.dbgPartsSelectedCellClick(Column: TColumn);
begin
  if Column.Field.FieldName = 'Selected' then
  begin
    Selected[qParts.RecNo] := not(Selected[qParts.RecNo]);
    qParts.Refresh;
  end;
end;

procedure TfmAllParts.dbgPartsTitleClick(Column: TColumn);
var
  SQLString, ColumnDesc: string;

begin
  if fmSumms.ActiveMDIChild = Self then
  begin
    dbgParts.OnDblClick := nil;

    if (Column.FieldName = 'Code') or (Column.Fieldname = 'Description') or
      (Column.FieldName = 'Material') or (Column.Fieldname = 'MatDesc') then
    begin
      dbgParts.SortColumn := Column.Index;

      if dbgParts.SortOrder = soAscending then
      begin
        dbgParts.SortOrder := soDescending;
        SQLString := ' DESC';
      end
      else
      begin
        dbgParts.SortOrder := soAscending;
        SQLString := ' ASC';
      end;

      if Column.FieldName = 'MatDesc' then
        ColumnDesc := 'M.Description'
      else
        ColumnDesc := 'P.' + Column.FieldName;

      qParts.Close;

      qParts.SQL.Text := 'SELECT P.Code, P.Description, P.Material, M.Description as MatDesc ' +
        'FROM Parts P, Material M WHERE P.Code LIKE :Search AND M.Code = P.Material Order By UPPER(' +
        ColumnDesc + ') ' + SQLString + ', P.Code ' + SQLString ;
      qParts.Open;
    end;
  end;
end;

procedure TfmAllParts.dbgPartsCellClick(Column: TColumn);
begin
  dbgParts.OnDblClick := dbgPartsDblClick;
end;

end.
