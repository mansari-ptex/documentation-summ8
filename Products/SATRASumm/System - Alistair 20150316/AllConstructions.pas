unit AllConstructions;

interface

uses
  Classes,  Controls, Forms, Types, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls, ExtCtrls, Menus, Buttons,
  ComCtrls, ToolWin, Grids, XStringGrid, XStringGridPlus, frxClass, frxDBSet,
  DBGridPlus, DBGrids, Generics.Collections, frxReportPlus;

type
  TfmAllConstructions = class(TForm)
    dbgConstructions: TDBGridPlus;
    pmnuDragOperation: TPopupMenu;
    Insert1: TMenuItem;
    Append1: TMenuItem;
    N1: TMenuItem;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    btnGroup: TSpeedButton;
    pnlSearch: TPanel;
    edSearch: TEdit;
    tblConstructions: TFDTablePlus;
    tblConstructionsConstruction: TStringField;
    qGroupDelete: TFDQueryPlus;
    tblConstructionsDescription: TStringField;
    pnlPrintButtons: TPanel;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    pnlGroupButtons: TPanel;
    btnGroupPrint: TSpeedButton;
    btnGroupDelete: TSpeedButton;
    btnSelectAll: TSpeedButton;
    btnDeselectAll: TSpeedButton;
    dbgConstructionsSelected: TDBGridPlus;
    qConstructions: TFDQueryPlus;
    qConstructionsConstruction: TStringField;
    qConstructionsDescription: TStringField;
    qConstructionsSelected: TBooleanField;
    dsqConstructions: TDataSource;
    sbMain: TStatusBar;
    frAllConstructions: TfrxReportPlus;
    frdbAllConstructions: TfrxDBDataset;
    lblSearch: TLabel;
    qConstructionsRecNo: TIntegerField;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgConstructionsDblClick(Sender: TObject);
    procedure edSearchChange(Sender: TObject);
    procedure dbgConstructionsKeyPress(Sender: TObject; var Key: Char);
    procedure btnPrintClick(Sender: TObject);
    procedure btnGroupClick(Sender: TObject);
    procedure Insert1Click(Sender: TObject);
    procedure Append1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnDeselectAllClick(Sender: TObject);
    procedure btnGroupDeleteClick(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure btnGroupPrintClick(Sender: TObject);
    procedure FillArray(Flag: Boolean);
    procedure dbgConstructionsSelectedColumnMoved(Sender: TObject;
      FromIndex, ToIndex: Integer);
    procedure qConstructionsCalcFields(DataSet: TDataSet);
    procedure dbgConstructionsSelectedCellClick(Column: TColumn);
    procedure dbgConstructionsTitleClick(Column: TColumn);
    procedure dbgConstructionsCellClick(Column: TColumn);
    procedure frAllConstructionsBeforePrint(Sender: TfrxReportComponent);
    procedure frAllConstructionsGetValue(const VarName: string;
      var Value: Variant);
    procedure qConstructionsBeforeOpen(DataSet: TDataSet);
    procedure qConstructionsAfterOpen(DataSet: TDataSet);
    procedure dbgConstructionsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure qConstructionsAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
    RefreshWarn: boolean;
    ActiveSearch : String;
    ColumnSelectedPosition: integer;
    Selected: array of Boolean;
//    Selected: TDictionary<string,boolean>;
  public
    { Public declarations }
  end;

var
  fmAllConstructions: TfmAllConstructions;

implementation

uses
  SysUtils, Windows, OutOfMemory, Summs, ConstructionDetails, Graphics, Dialogs, General,
  CmnVars, SummsVars, CancelPrinting, Dongle_Green;

{$R *.DFM}

procedure TfmAllConstructions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  try
    if btnGroup.Down then
    begin
      btnGroup.Down := False;
      btnGroup.Click;
    end;

    tblConstructions.close;
    qConstructions.close;
    action := caFree;
  except
    action := caNone;
    Raise;
  end;
end;

procedure TfmAllConstructions.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
  RefreshWarn := True;
end;

procedure TfmAllConstructions.dbgConstructionsDblClick(Sender: TObject);
var
  fmConstructionDetails: TfmConstructionDetails;
  Code: string;
  Failed: boolean;

begin
  Code := qConstructionsConstruction.value;

  if not (Code = '') then
  begin
    if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
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
end;

procedure TfmAllConstructions.edSearchChange(Sender: TObject);

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

procedure TfmAllConstructions.dbgConstructionsKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgConstructionsDblClick(Self);
end;

procedure TfmAllConstructions.frAllConstructionsBeforePrint(
  Sender: TfrxReportComponent);
begin
  frAllConstructions.PreviewOptions.AllowEdit := False;
  frAllConstructions.PreviewOptions.Buttons := frAllConstructions.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllConstructions.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllConstructions.PreviewOptions.ZoomMode := zmDefault
  else
    frAllConstructions.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllConstructions.frAllConstructionsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'SearchStr') then
    Value := edSearch.Text;
end;

procedure TfmAllConstructions.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  frAllConstructions.ReportOptions.Name := 'Preview ' + Caption;
  ClosePreviewForm(Caption);

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qConstructions.GetBookmark;
  qConstructions.DisableControls;
  qConstructions.Refresh;

  frAllConstructions.PrintOptions.PrintMode := pmScale;
  frAllConstructions.PrintOptions.PrintOnSheet := GetPaperSize;
  frAllConstructions.PrepareReport;

  try
    qConstructions.GotoBookmark(MyBookmark);
  except
  end;
  qConstructions.EnableControls;
  qConstructions.FreeBookmark(MyBookmark);

  if ((Sender as TSpeedButton) = btnPrintPreview) then
    frAllConstructions.ShowPreparedReport
  else
    frAllConstructions.Print;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;
end;

procedure TfmAllConstructions.btnGroupClick(Sender: TObject);
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
    //CJY tblConstructions replaced with qConstructions
    if not(qConstructions.Active) then
      qConstructions.Open
    //CJY Refresh for record count if previously active
    else
      qConstructions.Refresh;

    //CJY qConstructions.FetchOptions.RecordCountMode set to cmTotal
    if qConstructions.RecordCount = 0 then
      btnGroup.Down := False
    else
    begin
      //Attempt Lock
      LockSuccess := LockGroupIncStatusBar(oConstruction, fmSumms.tblLocks, tblConstructions, sbMain);

      if not LockSuccess then
        btnGroup.Down := False
      else
      begin
//        tblConstructions.first;
        dbgConstructionsSelected.Visible := True;
        dbgConstructions.Visible := False;
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
    dbgConstructions.Visible := True;
    dbgConstructionsSelected.Visible := False;
    pnlGroupButtons.Visible := False;
    pnlPrintButtons.Visible := True;
    pnlPrintButtons.Left := 72;
    edSearch.Enabled := True;

    //Release Lock
    LocksUnLockRecordIncStatusBar(fmSumms.tblLocks, 'GROUP_CONSTRUCTIONS', sbMain)
  end;

  //Change Columns if Status of button
  //hasn't changed with this procedure
  //CJY: qConstructions.FetchOptions.RecordCountMode set to cmTotal
  if (btnGroup.Down = btnGroupDownStatus) or ((qConstructions.RecordCount = 0) and (Sender = btnGroupDelete)) then
    SetColumnWidthsAll3a(fmAllConstructions, dbgConstructions, dbgConstructionsSelected, ColumnSelectedPosition, 2, btnGroup.Down);

  WindowState := HoldWindowState;
  LockWindowUpdate(0);

  Screen.cursor := crDefault;
end;

procedure TfmAllConstructions.dbgConstructionsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if y > TStringGrid(Sender).RowHeights[0] then
  begin
    if (ssLeft in Shift) then
    begin
      DragType := dragConstruction;
      DragSort := dragAppend;
      DragCode := qConstructionsConstruction.value;

      TDBGridPlus(Sender).BeginDrag(False, MouseMovePixels);
    end;
  end;
end;

procedure TfmAllConstructions.Insert1Click(Sender: TObject);
begin
  DragType := dragConstruction;
  DragSort := dragInsert;
  DragCode := qConstructionsConstruction.value;
  dbgConstructions.BeginDrag(false);
end;

procedure TfmAllConstructions.Append1Click(Sender: TObject);
begin
  DragType := dragConstruction;
  DragSort := dragAppend;
  DragCode := qConstructionsConstruction.value;
  dbgConstructions.BeginDrag(false);
end;

procedure TfmAllConstructions.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);

  ActiveSearch := '';
  qConstructions.ParamByName('Search').AsString := '%';
  qConstructions.Open;

//CJY Moved to qConstructions.AfterOpen Event
{
  //CJY: qConstructions.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qConstructions.RecordCount + 1);
  FillArray(False);
}

  ColumnSelectedPosition := 2;

  dbgConstructions.SortColumn := 0;
  dbgConstructions.SortOrder := soAscending;
  dbgConstructions.Refresh;
end;

procedure TfmAllConstructions.FillArray(Flag: Boolean);
var
  i: integer;

begin
  for i := 1 to Length(Selected) - 1 do
    Selected[i] := Flag;
end;

procedure TfmAllConstructions.btnRefreshClick(Sender: TObject);
var
  DoIt: boolean;

begin
  if btnGroup.Down then
  begin
    DoIt := False;
    if RefreshWarn then
      DoIt := (messagedlg('Refresh will clear selections. ' + #13 + 'Continue?', mtWarning, [mbYes, mbNo], 0) = mrYes)
    else
      DoIt := True;
  end
  else
    DoIt := True;

  if DoIt then
  begin
    qConstructions.Close;
    if edSearch.Font.Color = clRed then
      qConstructions.ParamByName('Search').AsString := edSearch.text + '%';
    qConstructions.Open;

    if btnGroup.Down then
    begin
//CJY Redundant as it exists in qConstructions.AfterOpen
{
      //CJY: qConstructions.FetchOptions.RecordCountMode set to cmTotal
      SetLength(Selected, qConstructions.RecordCount + 1);
      FillArray(False);
}
      qConstructions.Refresh;
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

procedure TfmAllConstructions.btnSelectAllClick(Sender: TObject);
begin
  FillArray(True);
  qConstructions.Refresh;
end;

procedure TfmAllConstructions.btnDeselectAllClick(Sender: TObject);
begin
  FillArray(False);
  qConstructions.Refresh;
end;

procedure TfmAllConstructions.btnGroupDeleteClick(Sender: TObject);
var
  QueryString: string;

begin
  Screen.cursor := crHourGlass;

  if messageDlg('Delete selected Constructions?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    application.processmessages;

    qGroupDelete.SQL.Clear;
    QueryString := '';
    qConstructions.DisableControls;
    qConstructions.RecNo := 1; //CJY changed from qConstructions.First
    qConstructions.Prior; //CJY changed from qConstructions.First

    repeat
      if qConstructionsSelected.Value then
      begin
        QueryString := QueryString + 'TRY ' + #13 +
                                     'DELETE FROM Construc ' + #13 +
                                     'WHERE Construction = ''' + QS(qConstructionsConstruction.Value) + ''';' + #13 +
                                     'CATCH ALL ' + #13 +
                                     'END TRY; ' + #13;
      end;
      qConstructions.Next;
    until qConstructions.Eof;

    qConstructions.RecNo := 1; //CJY changed from qConstructions.First
    qConstructions.Prior; //CJY changed from qConstructions.First

    if QueryString <> '' then
    begin
      qGroupDelete.SQL.Text := QueryString;
      qGroupDelete.ExecSQL;
    end;

    RefreshWarn := False;
    btnRefresh.Click;
    RefreshWarn := True;

    messageDlg('Deletion complete.' + #13#13 + 'Note: Only Constructions that are not' + #13 + 'in use have been deleted.', mtInformation, [mbOK], 0);
  end;

  qConstructions.EnableControls;
  Screen.cursor := crDefault;

  //CJY qConstructions.FetchOptions.RecordCountMode set to cmTotal
  if qConstructions.RecordCount = 0 then
    btnGroupClick(Sender);
end;

procedure TfmAllConstructions.edSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllConstructions.btnGroupPrintClick(Sender: TObject);
var
  fmConstructionDetails: TfmConstructionDetails;
  Code: string;
  Failed: boolean;

begin
  PrintingCancelled := False;
  tbMain.enabled := False;
  fmSumms.enabled := False;
  fmCancelPrinting.visible := True;

  GroupPrinting := False;

  Screen.cursor := crHourGlass;

  qConstructions.DisableControls;

  qConstructions.RecNo := 1; //CJY changed from qConstructions.First
  qConstructions.Prior; //CJY changed from qConstructions.First
  btnGroupPrint.Enabled := False;

  repeat
    if qConstructionsSelected.Value then
    begin
      Failed := false;
      try
        fmConstructionDetails := TfmConstructionDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
      begin
        fmConstructionDetails.Enabled := False;
        Code := qConstructionsConstruction.Value;
        fmCancelPrinting.lblItem.caption := Code;
        fmConstructionDetails.PassConstructionName(fmConstructionDetails, Code);
        fmConstructionDetails.btnPrint.Click;
        GroupPrinting := True;
        fmConstructionDetails.Close;
      end;
    end;
    qConstructions.Next;
  until qConstructions.eof or not fmCancelPrinting.visible or PrintingCancelled;

  Screen.cursor := crDefault;

  btnGroupPrint.Enabled := True;

  qConstructions.EnableControls;

  GroupPrinting := False;

  fmCancelPrinting.visible := False;
  fmSumms.enabled := True;
  tbMain.enabled := True;
  tbMain.setFocus;
end;

procedure TfmAllConstructions.dbgConstructionsSelectedColumnMoved(
  Sender: TObject; FromIndex, ToIndex: Integer);
begin
  ColumnSelectedPosition := GetColumnSelectedPosition3(dbgConstructionsSelected, 2);
end;

procedure TfmAllConstructions.qConstructionsAfterOpen(DataSet: TDataSet);
begin
  //CJY: qConstructions.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qConstructions.RecordCount + 1);
  FillArray(False);

  qConstructions.OnCalcFields := qConstructionsCalcFields;
end;

procedure TfmAllConstructions.qConstructionsAfterScroll(DataSet: TDataSet);
begin
  //CJY - qConstructions.RecNo sometimes returns 0 when attached to a DataGrid (when
  //      using .First and .Last). When scrolling is is possible to miss the first
  //      last values, especially when jumping to the start or the end (Ctrl + Home).
  if not (DataSet.FieldByName('RecNo').AsInteger > 0) then
    DataSet.Refresh;
end;

procedure TfmAllConstructions.qConstructionsBeforeOpen(DataSet: TDataSet);
begin
  qConstructions.OnCalcFields := nil;
end;

procedure TfmAllConstructions.qConstructionsCalcFields(DataSet: TDataSet);
begin
  //CJY - Recording return of RecNo for workaround RecNo = 0 issue
  DataSet.FieldByName('RecNo').AsInteger := DataSet.RecNo;

  if btnGroup.Down and
     (qConstructions.RecNo < Length(Selected)) then
    qConstructions.FieldByName('Selected').Value := Selected[qConstructions.RecNo];
end;

procedure TfmAllConstructions.dbgConstructionsSelectedCellClick(
  Column: TColumn);
begin
  if Column.Field.FieldName = 'Selected' then
  begin
    Selected[qConstructions.RecNo] := not(Selected[qConstructions.RecNo]);
    qConstructions.Refresh;
  end;
end;

procedure TfmAllConstructions.dbgConstructionsTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  dbgConstructions.OnDblClick := nil;

  if (Column.FieldName = 'Construction') or (Column.Fieldname = 'Description') then
  begin
    dbgConstructions.SortColumn := Column.Index;

    if dbgConstructions.SortOrder = soAscending then
    begin
      dbgConstructions.SortOrder := soDescending;
      SQLString := ' DESC';
    end
    else
    begin
      dbgConstructions.SortOrder := soAscending;
      SQLString := ' ASC';
    end;

    qConstructions.Close;

    qConstructions.SQL.Text := 'SELECT Construction, Description FROM Construc WHERE Construction LIKE :Search Order By UPPER(' + Column.FieldName + ') ' + SQLString + ', Construction ' + SQLString ;
    qConstructions.Open;
  end;
end;

procedure TfmAllConstructions.dbgConstructionsCellClick(Column: TColumn);
begin
  dbgConstructions.OnDblClick := dbgConstructionsDblClick;
end;

end.
