unit AllSuppliers;

interface

uses
  Classes, Controls, Forms, Types, StdCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, ExtCtrls,
  Buttons, ToolWin, ComCtrls, Menus, XStringGrid, XStringGridPlus, frxClass,
  frxDBSet, DBGridPlus, DBGrids, frxReportPlus;

type
  TfmAllSuppliers = class(TForm)
    dsSuppliers: TDataSource;
    dbgSuppliers: TDBGridPlus;
    tblSuppliers: TFDTablePlus;
    pnlSearch: TPanel;
    edSearch: TEdit;
    qSuppliers: TFDQueryPlus;
    qSuppliersCode: TStringField;
    qSuppliersDescription: TStringField;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    btnGroup: TSpeedButton;
    tblSuppliersCode: TStringField;
    tblSuppliersDescription: TStringField;
    qGroupDelete: TFDQueryPlus;
    pnlPrintButtons: TPanel;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    pnlGroupButtons: TPanel;
    btnGroupPrint: TSpeedButton;
    btnGroupDelete: TSpeedButton;
    btnSelectAll: TSpeedButton;
    btnDeselectAll: TSpeedButton;
    pmnuDragOperation: TPopupMenu;
    Insert1: TMenuItem;
    Append1: TMenuItem;
    N1: TMenuItem;
    dbgSuppliersSelected: TDBGridPlus;
    qSuppliersSelected: TBooleanField;
    sbMain: TStatusBar;
    frdbAllSuppliers: TfrxDBDataset;
    frAllSuppliers: TfrxReportPlus;
    lblSearch: TLabel;
    qSuppliersRecNo: TIntegerField;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgSuppliersDblClick(Sender: TObject);
    procedure edSearchChange(Sender: TObject);
    procedure dbgSuppliersKeyPress(Sender: TObject; var Key: Char);
    procedure btnPrintClick(Sender: TObject);
    procedure btnGroupClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnDeselectAllClick(Sender: TObject);
    procedure btnGroupDeleteClick(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure btnGroupPrintClick(Sender: TObject);
    procedure Insert1Click(Sender: TObject);
    procedure Append1Click(Sender: TObject);
    procedure FillArray(Flag: Boolean);    
    procedure dbgSuppliersSelectedColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure qSuppliersCalcFields(DataSet: TDataSet);
    procedure dbgSuppliersSelectedCellClick(Column: TColumn);
    procedure dbgSuppliersTitleClick(Column: TColumn);
    procedure dbgSuppliersCellClick(Column: TColumn);
    procedure frAllSuppliersBeforePrint(Sender: TfrxReportComponent);
    procedure frAllSuppliersGetValue(const VarName: string; var Value: Variant);
    procedure qSuppliersAfterOpen(DataSet: TDataSet);
    procedure qSuppliersBeforeOpen(DataSet: TDataSet);
    procedure dbgSuppliersMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure qSuppliersAfterScroll(DataSet: TDataSet);
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
  fmAllSuppliers: TfmAllSuppliers;

implementation

uses
  SysUtils, Windows, Graphics, Dialogs, General, SupplierDetails, Summs, OutOfMemory,
  SummsVars, CmnVars, CancelPrinting, Dongle_Green;

{$R *.DFM}

procedure TfmAllSuppliers.FormClose(Sender: TObject;
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

      tblSuppliers.close;
      qSuppliers.close;
      action := caFree;
    except
      action := caNone;
      Raise;
    end;
  end;
end;

procedure TfmAllSuppliers.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
  RefreshWarn := True;
end;

procedure TfmAllSuppliers.dbgSuppliersDblClick(Sender: TObject);

var Code : string;
    Failed:boolean;

begin
  Code := qSuppliersCode.value;

  if not (Code = '') then
  begin
    if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
    begin
      if not ExistingToFront('Supplier', Code) then
      begin
        Screen.cursor := crHourGlass;
        Failed := false;
        try
          fmSupplierDetails := TfmSupplierDetails.create(fmSumms);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;

        if not Failed then
          fmSupplierDetails.PassSupplierName(Code);
      end;

      if fmSumms.mmMinimiseAllonOpen.checked then
        WindowState := wsMinimized;
    end;
  end;
end;

procedure TfmAllSuppliers.edSearchChange(Sender: TObject);

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

procedure TfmAllSuppliers.dbgSuppliersKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgSuppliersDblClick(Self);
end;

procedure TfmAllSuppliers.frAllSuppliersBeforePrint(
  Sender: TfrxReportComponent);
begin
  frAllSuppliers.PreviewOptions.AllowEdit := False;
  frAllSuppliers.PreviewOptions.Buttons := frAllSuppliers.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllSuppliers.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllSuppliers.PreviewOptions.ZoomMode := zmDefault
  else
    frAllSuppliers.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllSuppliers.frAllSuppliersGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'SearchStr') then
    Value := edSearch.Text;
end;

procedure TfmAllSuppliers.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  frAllSuppliers.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qSuppliers.GetBookmark;
  qSuppliers.DisableControls;
  qSuppliers.Refresh;

  frAllSuppliers.PrintOptions.PrintMode := pmScale;
  frAllSuppliers.PrintOptions.PrintOnSheet := GetPaperSize;
  frAllSuppliers.PrepareReport;

  try
    qSuppliers.GotoBookmark(MyBookmark);
  except
  end;
  qSuppliers.EnableControls;
  qSuppliers.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
  begin
    with frAllSuppliers do
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
    frAllSuppliers.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllSuppliers.btnGroupClick(Sender: TObject);
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

  if btnGroup.Down and not(Sender = btnGroupDelete)  then
  begin
    //CJY tblSuppliers replaced with qSuppliers
    if not(qSuppliers.Active) then
      qSuppliers.Open
    //CJY Refresh for record count if previously active
    else
      qSuppliers.Refresh;

    //CJY: qSuppliers.FetchOptions.RecordCountMode set to cmTotal
    if qSuppliers.RecordCount = 0 then
      btnGroup.Down := False
    else
    begin
      //Attempt Lock
      LockSuccess := LockGroupIncStatusBar(oSupplier, fmSumms.tblLocks, tblSuppliers, sbMain);

      if not LockSuccess then
        btnGroup.Down := False
      else
      begin
        dbgSuppliersSelected.Visible := True;
        dbgSuppliers.Visible := False;
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
    dbgSuppliers.Visible := True;
    dbgSuppliersSelected.Visible := False;
    pnlGroupButtons.Visible := False;
    pnlPrintButtons.Visible := True;
    pnlPrintButtons.Left := 72;
    edSearch.Enabled := True;

    //Release Lock
    LocksUnLockRecordIncStatusBar(fmSumms.tblLocks, 'GROUP_SUPPLIERS', sbMain)
  end;

  //Change Columns if Status of button
  //hasn't changed with this procedure
  //CJY: qSuppliers.FetchOptions.RecordCountMode set to cmTotal
  if (btnGroup.Down = btnGroupDownStatus) or ((qSuppliers.RecordCount = 0) and (Sender = btnGroupDelete)) then
    SetColumnWidthsAll3a(fmAllSuppliers, dbgSuppliers, dbgSuppliersSelected, ColumnSelectedPosition, 2, btnGroup.Down);

  WindowState := HoldWindowState;
  LockWindowUpdate(0);

  Screen.cursor := crDefault;
  qSuppliers.EnableControls;  
end;

procedure TfmAllSuppliers.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;

  ActiveSearch := '';
  qSuppliers.ParamByName('Search').AsString := '%';
  qSuppliers.Open;

//CJY Moved to qSuppliers.AfterOpen Event
{
  //CJY: qSuppliers.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qSuppliers.RecordCount + 1);
  FillArray(False);
}

  ColumnSelectedPosition := 2;

  dbgSuppliers.SortColumn := 0;
  dbgSuppliers.SortOrder := soAscending;
  dbgSuppliers.Refresh;
end;

procedure TfmAllSuppliers.FillArray(Flag: Boolean);
var
  i: integer;

begin
  for i := 1 to Length(Selected) - 1 do
    Selected[i] := Flag;
end;

procedure TfmAllSuppliers.btnRefreshClick(Sender: TObject);
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
    qSuppliers.Close;
    if edSearch.Font.Color = clRed then
      qSuppliers.ParamByName('Search').AsString := edSearch.text + '%';
    qSuppliers.Open;

    if btnGroup.Down then
    begin
//CJY Redundant as it exists in qSuppliers.AfterOpen
{
      //CJY: qSuppliers.FetchOptions.RecordCountMode set to cmTotal
      SetLength(Selected, qSuppliers.RecordCount + 1);
      FillArray(False);
}

      qSuppliers.Refresh;
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

procedure TfmAllSuppliers.btnSelectAllClick(Sender: TObject);
begin
  FillArray(True);
  qSuppliers.Refresh;
end;

procedure TfmAllSuppliers.btnDeselectAllClick(Sender: TObject);
begin
  FillArray(False);
  qSuppliers.Refresh;
end;

procedure TfmAllSuppliers.btnGroupDeleteClick(Sender: TObject);
var
  QueryString: string;

begin
  Screen.cursor := crHourGlass;

  if MessageDlgPos('Delete selected Suppliers?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
  begin
    application.processmessages;

    qGroupDelete.SQL.Clear;
    QueryString := '';
    qSuppliers.DisableControls;
    qSuppliers.RecNo := 1; //CJY changed from qSuppliers.First
    qSuppliers.Prior; //CJY changed from qSuppliers.First

    repeat
      if qSuppliersSelected.Value then
      begin
        QueryString := QueryString + 'TRY ' + #13 +
                                     'DELETE FROM Supplier ' + #13 +
                                     'WHERE Code = ''' + QS(qSuppliersCode.Value) + ''';' + #13 +
                                     'CATCH ALL ' + #13 +
                                     'END TRY; ' + #13;
      end;
      qSuppliers.Next;
    until qSuppliers.Eof;

    qSuppliers.RecNo := 1; //CJY changed from qSuppliers.First
    qSuppliers.Prior; //CJY changed from qSuppliers.First

    if QueryString <> '' then
    begin
      qGroupDelete.SQL.Text := QueryString;
      qGroupDelete.ExecSQL;
    end;

    RefreshWarn := False;
    btnRefresh.Click;
    RefreshWarn := True;

    MessageDlgPos('Deletion complete.' + #13#13 + 'Note: Only Suppliers that are not' + #13 + 'in use have been deleted.', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end;

  qSuppliers.EnableControls;
  Screen.cursor := crDefault;

  //CJY: qSuppliers.FetchOptions.RecordCountMode set to cmTotal
  if qSuppliers.RecordCount = 0 then
    btnGroupClick(Sender);
end;

procedure TfmAllSuppliers.edSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllSuppliers.btnGroupPrintClick(Sender: TObject);
var
  Code: string;
  Failed: boolean;
  fmSupplierDetails: TfmSupplierDetails;

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
  qSuppliers.DisableControls;
  qSuppliers.RecNo := 1; //CJY changed from qSuppliers.First
  qSuppliers.Prior; //CJY changed from qSuppliers.First
  repeat
    if qSuppliersSelected.Value then
    begin
      Failed := false;
      try
        fmSupplierDetails := TfmSupplierDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
      begin
        fmSupplierDetails.Enabled := False;
        Code := qSuppliersCode.Value;
        fmCancelPrinting.lblItem.caption := Code;
        fmSupplierDetails.PassSupplierName(Code);
        fmSupplierDetails.btnPrint.Click;
        GroupPrinting := True;
        fmSupplierDetails.Close;
      end;
    end;
    qSuppliers.Next;
  until qSuppliers.eof or not fmCancelPrinting.visible or PrintingCancelled;

  btnGroupPrint.Enabled := True;

  Screen.cursor := crDefault;
  qSuppliers.EnableControls;  

  GroupPrinting := False;

  fmCancelPrinting.visible := False;
  fmSumms.enabled := True;
  tbMain.enabled := True;
  tbMain.setFocus;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllSuppliers.dbgSuppliersMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if y > TStringGrid(Sender).RowHeights[0] then
  begin
    if (ssLeft in Shift) then
    begin
      DragType := dragSupplier;
      DragSort := dragAppend;
      DragCode := qSuppliersCode.value;

      TDBGridPlus(Sender).BeginDrag(False, MouseMovePixels);
    end;
  end;
end;

procedure TfmAllSuppliers.Insert1Click(Sender: TObject);
begin
  DragType := dragSupplier;
  DragSort := dragInsert;
  DragCode := qSuppliersCode.value;
  dbgSuppliers.BeginDrag(false);
end;

procedure TfmAllSuppliers.Append1Click(Sender: TObject);
begin
  DragType := dragSupplier;
  DragSort := dragAppend;
  DragCode := qSuppliersCode.value;
  dbgSuppliers.BeginDrag(false);
end;

procedure TfmAllSuppliers.dbgSuppliersSelectedColumnMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
begin
  ColumnSelectedPosition := GetColumnSelectedPosition3(dbgSuppliersSelected, 2);
end;

procedure TfmAllSuppliers.qSuppliersAfterOpen(DataSet: TDataSet);
begin
  //CJY: qSuppliers.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qSuppliers.RecordCount + 1);
  FillArray(False);

  qSuppliers.OnCalcFields := qSuppliersCalcFields;
end;

procedure TfmAllSuppliers.qSuppliersAfterScroll(DataSet: TDataSet);
begin
  //CJY - qConstructions.RecNo sometimes returns 0 when attached to a DataGrid (when
  //      using .First and .Last). When scrolling is is possible to miss the first
  //      last values, especially when jumping to the start or the end (Ctrl + Home).
  if not (DataSet.FieldByName('RecNo').AsInteger > 0) then
    DataSet.Refresh;
end;

procedure TfmAllSuppliers.qSuppliersBeforeOpen(DataSet: TDataSet);
begin
  qSuppliers.OnCalcFields := Nil;
end;

procedure TfmAllSuppliers.qSuppliersCalcFields(DataSet: TDataSet);
begin
  //CJY - Recording return of RecNo for workaround RecNo = 0 issue
  DataSet.FieldByName('RecNo').AsInteger := DataSet.RecNo;

  if btnGroup.Down and
     (qSuppliers.RecNo < Length(Selected)) then
    qSuppliersSelected.Value := Selected[qSuppliers.RecNo];
end;

procedure TfmAllSuppliers.dbgSuppliersSelectedCellClick(Column: TColumn);
begin
  if Column.Field.FieldName = 'Selected' then
  begin
    Selected[qSuppliers.RecNo] := not(Selected[qSuppliers.RecNo]);
    qSuppliers.Refresh;
  end;
end;

procedure TfmAllSuppliers.dbgSuppliersTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  if fmSumms.ActiveMDIChild = Self then
  begin
    dbgSuppliers.OnDblClick := nil;

    if (Column.FieldName = 'Code') or (Column.Fieldname = 'Description') then
    begin
      SortOrder(dbgSuppliers, Column, SQLString);

      qSuppliers.Close;

      qSuppliers.SQL.Text := 'SELECT Code, Description FROM Supplier WHERE Code LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Code ' + SQLString ;
      qSuppliers.Open;
    end;
  end;
end;

procedure TfmAllSuppliers.dbgSuppliersCellClick(Column: TColumn);
begin
  dbgSuppliers.OnDblClick := dbgSuppliersDblClick;
end;

end.
