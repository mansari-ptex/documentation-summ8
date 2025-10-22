unit AllMaterials;

interface
                                                                                                         
uses
  Forms, StdCtrls, Types, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, ExtCtrls, Buttons, ComCtrls, Controls,
  ToolWin, Classes, Grids, DBGridPlus, Menus, XStringGrid, XStringGridPlus,
  frxClass, frxDBSet, DBGrids, frxReportPlus;

type
  TfmAllMaterials = class(TForm)
    dsqMaterials: TDataSource;
    dbgMaterials: TDBGridPlus;
    tblMaterials: TFDTablePlus;
    qMaterials: TFDQueryPlus;
    qMaterialsCode: TStringField;
    qMaterialsDescription: TStringField;
    pnlSearch: TPanel;
    edSearch: TEdit;
    tbMain: TPanel;
    btnRefresh: TSpeedButton;
    btnGroup: TSpeedButton;
    tblMaterialsCode: TStringField;
    tblMaterialsDescription: TStringField;
    qGroupDelete: TFDQueryPlus;
    qMaterialsType: TStringField;
    qMaterialsCutType: TStringField;
    qMaterialsStandardPrice: TCurrencyField;
    qMaterialsDegDiff: TSmallintField;
    qMaterialsQualCoeff: TSmallintField;
    qMaterialsAreaCoeff: TSmallintField;
    qMaterialsLength: TFloatField;
    qMaterialsWidth: TFloatField;
    qMaterialsSkinSize: TFloatField;
    qMaterialsTrimmed: TBooleanField;
    qMaterialsUnits: TStringField;
    qMaterialsLayers: TSmallintField;
    qMaterialsStrokeDepth: TFloatField;
    qMaterialsCalcSkinSize: TStringField;
    qMaterialsCalcLength: TStringField;
    qMaterialsCalcWidth: TStringField;
    qMaterialsCalcTrimmed: TStringField;
    qMaterialsCalcStrokeDepth: TStringField;
    qMaterialsCalcQualCoeff: TStringField;
    qMaterialsCalcAreaCoeff: TStringField;
    qMaterialsCalcDegDiff: TStringField;
    dbgMaterialsList: TDBGridPlus;
    btnList: TSpeedButton;
    pnlPrintButtons: TPanel;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    pnlGroupButtons: TPanel;
    btnGroupDelete: TSpeedButton;
    btnSelectAll: TSpeedButton;
    btnDeselectAll: TSpeedButton;
    btnGroupPrint: TSpeedButton;
    pmnuDragOperation: TPopupMenu;
    Insert1: TMenuItem;
    Append1: TMenuItem;
    N1: TMenuItem;
    qMaterialsSelected: TBooleanField;
    dbgMaterialsSelected: TDBGridPlus;
    sbMain: TStatusBar;
    frAllMaterials: TfrxReportPlus;
    frdbAllMaterials: TfrxDBDataset;
    frListMaterials: TfrxReportPlus;
    qMaterialsCalcLinearPrice: TStringField;
    qMaterialsLinearMatPrice: TBooleanField;
    qMaterialsCutGap: TSmallintField;
    qMaterialsCalcCutGap: TStringField;
    lblSearch: TLabel;
    cbLeather: TCheckBox;
    cbWool: TCheckBox;
    cbKip: TCheckBox;
    cbRoll: TCheckBox;
    cbSheet: TCheckBox;
    tblMaterialsType: TStringField;
    qMaterialsRecNo: TIntegerField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure general(Sender: TObject);
    procedure dbgMaterialsDblClick(Sender: TObject);
    procedure edSearchChange(Sender: TObject);
    procedure dbgMaterialsKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnGroupClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnDeselectAllClick(Sender: TObject);
    procedure btnGroupDeleteClick(Sender: TObject);
    procedure qMaterialsCalcFields(DataSet: TDataSet);
    procedure btnListClick(Sender: TObject);
    procedure edSearchKeyPress(Sender: TObject; var Key: Char);
    procedure btnGroupPrintClick(Sender: TObject);
    procedure Insert1Click(Sender: TObject);
    procedure Append1Click(Sender: TObject);
    procedure FillArray(Flag: Boolean);
    procedure dbgMaterialsSelectedColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure dbgMaterialsSelectedCellClick(Column: TColumn);
    procedure dbgMaterialsTitleClick(Column: TColumn);
    procedure dbgMaterialsCellClick(Column: TColumn);
    procedure dbgMaterialsListCellClick(Column: TColumn);
    procedure dbgMaterialsListTitleClick(Column: TColumn);
    procedure frAllMaterialsBeforePrint(Sender: TfrxReportComponent);
    procedure frAllMaterialsGetValue(const VarName: string; var Value: Variant);
    procedure frListMaterialsBeforePrint(Sender: TfrxReportComponent);
    procedure frListMaterialsGetValue(const VarName: string;
      var Value: Variant);
    procedure qMaterialsAfterOpen(DataSet: TDataSet);
    procedure qMaterialsBeforeOpen(DataSet: TDataSet);
    procedure dbgMaterialsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SetFilter;
    procedure cbLeatherClick(Sender: TObject);
    procedure qMaterialsAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
    BusyPrinting: boolean;
    RefreshWarn: boolean;
    ActiveSearch: String;
    ColumnSelectedPosition: integer;
    Selected: array of Boolean;
    MatTypes: string;
  public
    { Public declarations }
    CreatedFormWidth: integer;
  end;

var
  fmAllMaterials: TfmAllMaterials;

implementation

uses
  Windows, SysUtils, Graphics, Dialogs, General, MaterialDetails, Summs,
  OutOfMemory, SummsVars, CmnVars, CancelPrinting, Dongle_Green;

{$R *.DFM}

procedure TfmAllMaterials.FormClose(Sender: TObject;
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

      tblMaterials.close;
      qMaterials.close;
      action := caFree;
    except
      action := caNone;
      Raise;
    end;
  end;
end;

procedure TfmAllMaterials.general(Sender: TObject);
begin
  Screen.cursor := crDefault;
  RefreshWarn := True;
end;

procedure TfmAllMaterials.dbgMaterialsDblClick(Sender: TObject);

var
  Code : string;
  Failed : boolean;
  fmMaterialDetails : TfmMaterialDetails;

begin
  Code := qMaterialsCode.value;

  if not (Code = '') then
  begin
    if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
    begin
      if not ExistingToFront('Material', Code) then
      begin
        Screen.cursor := crHourGlass;
        Failed:=False;
        try
          fmMaterialDetails := TfmMaterialDetails.create(fmSumms);
        except
          fmMemoryError.TidyUp(Self);
          Failed := True;
        end;

        if not Failed then
          fmMaterialDetails.PassMaterialName(fmMaterialDetails, Code)
      end;

      if fmSumms.mmMinimiseAllonOpen.checked then
        WindowState := wsMinimized;
    end;
  end;
end;

procedure TfmAllMaterials.edSearchChange(Sender: TObject);
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

procedure TfmAllMaterials.dbgMaterialsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    dbgMaterialsDblClick(Self);
end;


procedure TfmAllMaterials.frAllMaterialsBeforePrint(
  Sender: TfrxReportComponent);
begin
  frAllMaterials.PreviewOptions.AllowEdit := False;
  frAllMaterials.PreviewOptions.Buttons := frAllMaterials.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frAllMaterials.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frAllMaterials.PreviewOptions.ZoomMode := zmDefault
  else
    frAllMaterials.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllMaterials.frAllMaterialsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'SearchStr') then
    Value := edSearch.Text;
  if (VarName = 'Type') then
    Value := matTypes;
end;

procedure TfmAllMaterials.frListMaterialsBeforePrint(
  Sender: TfrxReportComponent);
var
  DegDiff: TfrxMemoView;
//Used a memo because a shape has a black line edge which cannot be removed.
begin

  DegDiff := frListMaterials.FindObject('mDDTitle') as TfrxMemoView;
  DegDiff.Visible := DifficultLeatherFacility;
  DegDiff := frListMaterials.FindObject('mDD') as TfrxMemoView;
  DegDiff.Visible := DifficultLeatherFacility;

  frListMaterials.PreviewOptions.AllowEdit := False;
  frListMaterials.PreviewOptions.Buttons := frListMaterials.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frListMaterials.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frListMaterials.PreviewOptions.ZoomMode := zmDefault
  else
    frListMaterials.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmAllMaterials.frListMaterialsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'SearchStr') then
    Value := edSearch.Text;
  if (VarName = 'Type') then
    Value := MatTypes;
end;

procedure TfmAllMaterials.btnPrintClick(Sender: TObject);
var
  MyBookmark:TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  btnPrint.Enabled := False;
  btnPrintPreview.Enabled := False;

  MyBookmark := qMaterials.GetBookmark;
  qMaterials.DisableControls;
  qMaterials.Refresh;

  if btnList.Down then
  begin
    frListMaterials.ReportOptions.Name := 'Preview ' + Caption;
    ClosePreviewForm(Caption);

    frListMaterials.PrintOptions.PrintMode := pmScale;
    frListMaterials.PrintOptions.PrintOnSheet := GetPaperSize;
    frListMaterials.PrepareReport;

    try
      qMaterials.GotoBookmark(MyBookmark);
    except
    end;
    qMaterials.EnableControls;
    qMaterials.FreeBookmark(MyBookmark);

    if ((Sender as TSpeedButton) = btnPrintPreview) then
    begin
      with frListMaterials do
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
      frListMaterials.Print;
  end
  else
  begin
    frAllMaterials.ReportOptions.Name := 'Preview ' + Caption;
    ClosePreviewForm(Caption);

    frAllMaterials.PrintOptions.PrintMode := pmScale;
    frAllMaterials.PrintOptions.PrintOnSheet := GetPaperSize;
    frAllMaterials.PrepareReport;

    try
      qMaterials.GotoBookmark(MyBookmark);
    except
    end;
    qMaterials.EnableControls;
    qMaterials.FreeBookmark(MyBookmark);

    if ((Sender as TSpeedButton) = btnPrintPreview) then
    begin
      with frAllMaterials do
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
      frAllMaterials.Print;
  end;

  btnPrint.Enabled := True;
  btnPrintPreview.Enabled := True;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllMaterials.btnGroupClick(Sender: TObject);
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
    //CJY tblMaterials replaced with qMaterials
    if not(qMaterials.Active) then
      qMaterials.Open
    //CJY Refresh for record count if previously active
    else
      qMaterials.Refresh;

    //CJY: qMaterials.FetchOptions.RecordCountMode set to cmTotal
    if qMaterials.RecordCount = 0 then
      btnGroup.Down := False
    else
    begin
      //Attempt Lock
      LockSuccess := LockGroupIncStatusBar(oMaterial, fmSumms.tblLocks, tblMaterials, sbMain);

      if not LockSuccess then
        btnGroup.Down := False
      else
      begin
//      tblMaterials.first;
        dbgMaterialsSelected.Visible := True;
        dbgMaterials.Visible := False;
        btnList.Enabled := False;
        pnlPrintButtons.Visible := False;
        pnlGroupButtons.Visible := True;
        pnlGroupButtons.Left := 95;
        edSearch.Enabled := False;
//        cbLeather.Enabled := False;
//        cbWool.Enabled := False;
//        cbKip.Enabled := False;
//        cbRoll.Enabled := False;
//        cbSheet.Enabled := False;
      end;
    end;
  end
  else
  begin
    btnGroup.Down := False;
    btnDeselectAll.Click;
    dbgMaterials.Visible := True;
    dbgMaterialsList.Visible := False;
    dbgMaterialsSelected.Visible := False;
    pnlGroupButtons.Visible := False;
    btnList.Enabled := True;
    pnlPrintButtons.Visible := True;
    pnlPrintButtons.Left := 95;
    edSearch.Enabled := True;
//    cbLeather.Enabled := True;
//    cbWool.Enabled := True;
//    cbKip.Enabled := True;
//    cbRoll.Enabled := True;
//    cbSheet.Enabled := True;

    //Release Lock
    LocksUnLockRecordIncStatusBar(fmSumms.tblLocks, 'GROUP_MATERIALS', sbMain)
  end;

  //Change Columns if Status of button
  //hasn't changed with this procedure
  //CJY: qMaterials.FetchOptions.RecordCountMode set to cmTotal
  if (btnGroup.Down = btnGroupDownStatus) or ((qMaterials.RecordCount = 0) and (Sender = btnGroupDelete)) then
    SetColumnWidthsAll3a(fmAllMaterials, dbgMaterials, dbgMaterialsSelected, ColumnSelectedPosition, 2, btnGroup.Down);

  WindowState := HoldWindowState;
  LockWindowUpdate(0);

  Screen.cursor := crDefault;
end;

procedure TfmAllMaterials.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;

  ActiveSearch := '';
  qMaterials.ParamByName('Search').AsString := '%';
  qMaterials.Open;

//CJY Moved to qMaterials.AfterOpen Event
{
  //CJY: qMaterials.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qMaterials.RecordCount + 1);
  FillArray(False);
}

  ColumnSelectedPosition := 2;

  dbgMaterials.SortColumn := 0;
  dbgMaterials.SortOrder := soAscending;
  dbgMaterials.Refresh;
  dbgMaterialsList.SortColumn := 0;
  dbgMaterialsList.SortOrder := soAscending;
  dbgMaterialsList.Refresh;

  SetFilter;

  CreatedFormWidth := Width;
end;

procedure TfmAllMaterials.FillArray(Flag: Boolean);
var
  i: integer;

begin
  for i := 1 to Length(Selected) - 1 do
    Selected[i] := Flag;
end;

procedure TfmAllMaterials.btnRefreshClick(Sender: TObject);
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
    qMaterials.Close;
    if edSearch.Font.Color = clRed then
      qMaterials.ParamByName('Search').AsString := edSearch.text + '%';
    qMaterials.Open;

    if btnGroup.Down then
    begin
//CJY Redundant as it exists in qMaterials.AfterOpen
{
      //CJY: qMaterials.FetchOptions.RecordCountMode set to cmTotal
      SetLength(Selected, qMaterials.RecordCount + 1);
      FillArray(False);
}
      qMaterials.Refresh;
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

procedure TfmAllMaterials.btnSelectAllClick(Sender: TObject);
begin
  FillArray(True);
  qMaterials.Refresh;
end;

procedure TfmAllMaterials.cbLeatherClick(Sender: TObject);
begin
  SetFilter;
  btnRefresh.Click;
end;

procedure TfmAllMaterials.btnDeselectAllClick(Sender: TObject);
begin
  FillArray(False);
  qMaterials.Refresh;
end;

procedure TfmAllMaterials.btnGroupDeleteClick(Sender: TObject);
var
  QueryString: string;

begin
  Screen.cursor := crHourGlass;

  if MessageDlgPos('Delete selected Materials?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
  begin
    application.processmessages;

    qGroupDelete.SQL.Clear;
    QueryString := '';
    qMaterials.DisableControls;
    qMaterials.RecNo := 1; //CJY changed from qMaterials.First
    qMaterials.Prior; //CJY changed from qMaterials.First

    repeat
      if qMaterialsSelected.Value then
      begin
        QueryString := QueryString + 'TRY ' + #13 +
                                     'DELETE FROM Material ' + #13 +
                                     'WHERE Code = ''' + QS(qMaterialsCode.Value) + ''';' + #13 +
                                     'CATCH ALL ' + #13 +
                                     'END TRY; ' + #13;
      end;
      qMaterials.Next;
    until qMaterials.Eof;

    qMaterials.RecNo := 1; //CJY changed from qMaterials.First
    qMaterials.Prior; //CJY changed from qMaterials.First

    if QueryString <> '' then
    begin
      qGroupDelete.SQL.Text := QueryString;
      qGroupDelete.ExecSQL;
    end;

    RefreshWarn := False;
    btnRefresh.Click;
    RefreshWarn := True;

    MessageDlgPos('Deletion complete.' + #13#13 + 'Note: Only Materials that are not' + #13 + 'in use have been deleted.', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
  end;

  qMaterials.EnableControls;
  Screen.cursor := crDefault;

  //CJY: qMaterials.FetchOptions.RecordCountMode set to cmTotal
  if qMaterials.RecordCount = 0 then
    btnGroupClick(Sender);
end;

procedure TfmAllMaterials.qMaterialsAfterOpen(DataSet: TDataSet);
begin
  //CJY: qMaterials.FetchOptions.RecordCountMode set to cmTotal
  SetLength(Selected, qMaterials.RecordCount + 1);
  FillArray(False);

  qMaterials.OnCalcFields := qMaterialsCalcFields;
end;

procedure TfmAllMaterials.qMaterialsAfterScroll(DataSet: TDataSet);
begin
  //CJY - qConstructions.RecNo sometimes returns 0 when attached to a DataGrid (when
  //      using .First and .Last). When scrolling is is possible to miss the first
  //      last values, especially when jumping to the start or the end (Ctrl + Home).
  if not (DataSet.FieldByName('RecNo').AsInteger > 0) then
    DataSet.Refresh;
end;

procedure TfmAllMaterials.qMaterialsBeforeOpen(DataSet: TDataSet);
begin
  qMaterials.OnCalcFields := nil;
end;

procedure TfmAllMaterials.qMaterialsCalcFields(DataSet: TDataSet);
var
  temp: string;

begin
  //CJY - Recording return of RecNo for workaround RecNo = 0 issue
  DataSet.FieldByName('RecNo').AsInteger := DataSet.RecNo;

  if (qMaterialsType.value = 'L') or (qMaterialsType.value = 'K') or (qMaterialsType.value = 'W') then
  begin
    str(qMaterialsSkinSize.value : 7 : 3,temp);
    qMaterialsCalcSkinSize.value := temp;
    qMaterialsCalcQualCoeff.value := IntToStr(qMaterialsQualCoeff.value);
    qMaterialsCalcAreaCoeff.value := IntToStr(qMaterialsAreaCoeff.value);
    qMaterialsCalcDegDiff.value := IntToStr(qMaterialsDegDiff.value);
    qMaterialsCalcCutGap.value := '-';
    qMaterialsCalcLength.value := '-';
    qMaterialsCalcWidth.value := '-';
    qMaterialsCalcStrokeDepth.value := '-';
    qMaterialsCalcLinearPrice.value := '-';    
    if (qMaterialsTrimmed.value) then
      qMaterialsCalcTrimmed.value := 'Yes'
    else
      qMaterialsCalcTrimmed.value := 'No';
  end
  else
  begin
    qMaterialsCalcSkinSize.value := '-';
    qMaterialsCalcQualCoeff.value := '-';
    qMaterialsCalcAreaCoeff.value := '-';
    qMaterialsCalcDegDiff.value := '-';
    qMaterialsCalcTrimmed.value := '-';
    qMaterialsCalcCutGap.value := IntToStr(qMaterialsCutGap.value);
    str(qMaterialsWidth.value : 7 : 3, temp);
    qMaterialsCalcWidth.value := temp;
    str(qMaterialsStrokeDepth.value : 7 : 3, temp);
    qMaterialsCalcStrokeDepth.value := temp;
    if (qMaterialsLinearMatPrice.value) then
      qMaterialsCalcLinearPrice.value := 'Lin'
    else
      qMaterialsCalcLinearPrice.value := 'Sq';

    if (qMaterialsType.value = 'R') then
      qMaterialsCalcLength.value := '-'
    else
    begin
      str(qMaterialsLength.value : 7 : 3, temp);
      qMaterialsCalcLength.value := temp;
    end;
  end;

  //CJY Extension from RecNo = 0 is to check Selected array is ready for RecNo
  if btnGroup.Down and
     (qMaterials.RecNo < Length(Selected)) then
    qMaterialsSelected.Value := Selected[qMaterials.RecNo];
end;

procedure TfmAllMaterials.btnListClick(Sender: TObject);
begin
  if btnList.Down then
  begin
    btnGroup.Enabled := False;
    qMaterials.Refresh;
    dbgMaterialsList.Visible := True;
    dbgMaterials.Visible := False;

    fmAllMaterials.Width := CreatedFormWidth + 610;
    if DifficultLeatherFacility then
      dbgMaterialsList.Columns[8].Visible := True
    else
    begin
      dbgMaterialsList.Columns[8].Visible := False;
      fmAllMaterials.Width := fmAllMaterials.Width - 41;
    end;
  end
  else
  begin
    btnGroup.Enabled := True;
    dbgMaterialsList.Visible := False;
    dbgMaterials.Visible := True;

    dbgMaterials.Columns[0].Width := 180;
    dbgMaterials.Columns[1].Width := 250;
    fmAllMaterials.Width := CreatedFormWidth;
  end;
end;

procedure TfmAllMaterials.edSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnRefresh.click;
end;

procedure TfmAllMaterials.btnGroupPrintClick(Sender: TObject);
var
  Code: string;
  Failed: boolean;
  fmMaterialDetails: TfmMaterialDetails;

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

  qMaterials.RecNo := 1; //CJY changed from qMaterials.First
  qMaterials.Prior; //CJY changed from qMaterials.First
  qMaterials.DisableControls;

  repeat
    if qMaterialsSelected.Value then
    begin
      Failed := false;
      try
        fmMaterialDetails := TfmMaterialDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(Self);
        Failed := True;
      end;

      if not Failed then
      begin
        fmMaterialDetails.Enabled := False;
        Code := qMaterialsCode.Value;
        fmCancelPrinting.lblItem.caption := Code;
        fmMaterialDetails.PassMaterialName(fmMaterialDetails, Code);
        while fmMaterialDetails.SecondProcessInUse do
          application.ProcessMessages;
        fmMaterialDetails.btnPrint.Click;
        GroupPrinting := True;  //don't want this true for first loop.
        fmMaterialDetails.Close;
      end;
    end;
    qMaterials.Next;
  until qMaterials.eof or not fmCancelPrinting.visible or PrintingCancelled;

  btnGroupPrint.Enabled := True;

  qMaterials.EnableControls;

  Screen.cursor := crDefault;

  GroupPrinting := False;

  fmCancelPrinting.visible := False;
  fmSumms.enabled := True;
  tbMain.enabled := True;
  tbMain.setFocus;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmAllMaterials.dbgMaterialsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if y > TStringGrid(Sender).RowHeights[0] then
  begin
    if (ssLeft in Shift) then
    begin
      DragType := dragMaterial;
      DragSort := dragEdit;
      DragCode := qMaterialsCode.value;

      TDBGridPlus(Sender).BeginDrag(False, MouseMovePixels);
    end;
  end;
end;

procedure TfmAllMaterials.Insert1Click(Sender: TObject);
begin
  DragType := dragMaterial;
  DragSort := dragInsert;
  DragCode := qMaterialsCode.value;
  dbgMaterials.BeginDrag(false);
end;

procedure TfmAllMaterials.Append1Click(Sender: TObject);
begin
  DragType := dragMaterial;
  DragSort := dragAppend;
  DragCode := qMaterialsCode.value;
  dbgMaterials.BeginDrag(false);
end;

procedure TfmAllMaterials.dbgMaterialsSelectedColumnMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
begin
  ColumnSelectedPosition := GetColumnSelectedPosition3(dbgMaterialsSelected, 2);
end;

procedure TfmAllMaterials.dbgMaterialsSelectedCellClick(Column: TColumn);
begin
  if Column.Field.FieldName = 'Selected' then
  begin
    Selected[qMaterials.RecNo] := not(Selected[qMaterials.RecNo]);
    qMaterials.Refresh;
  end;
end;

procedure TfmAllMaterials.dbgMaterialsTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  if fmSumms.ActiveMDIChild = Self then
  begin
    dbgMaterials.OnDblClick := nil;

    if (Column.FieldName = 'Code') or (Column.Fieldname = 'Description') then
    begin
      dbgMaterials.SortColumn := Column.Index;

      if dbgMaterials.SortOrder = soAscending then
      begin
        dbgMaterials.SortOrder := soDescending;
        SQLString := ' DESC';
      end
      else
      begin
        dbgMaterials.SortOrder := soAscending;
        SQLString := ' ASC';
      end;

      qMaterials.Close;

      qMaterials.SQL.Text := 'SELECT Code, Description, Type, CutType, CutGap, StandardPrice, LinearMatPrice, DegDiff, ' +
                             'QualCoeff, AreaCoeff, Length, Width, SkinSize, Trimmed, Units, Layers, StrokeDepth ' +
                             'FROM Material WHERE Code LIKE :Search Order By UPPER(' +
                              Column.FieldName + ') ' + SQLString + ', Code ' + SQLString ;
      qMaterials.Open;
    end;
  end;
end;

procedure TfmAllMaterials.dbgMaterialsCellClick(Column: TColumn);
begin
  dbgMaterials.OnDblClick := dbgMaterialsDblClick;
end;

procedure TfmAllMaterials.dbgMaterialsListCellClick(Column: TColumn);
begin
  dbgMaterialsList.OnDblClick := dbgMaterialsDblClick;
end;

procedure TfmAllMaterials.dbgMaterialsListTitleClick(Column: TColumn);
var
  SQLString: string;

begin
  if fmSumms.ActiveMDIChild = Self then
  begin
    dbgMaterialsList.OnDblClick := nil;

    if (Column.FieldName = 'Code') or (Column.Fieldname = 'Description') then
    begin
      dbgMaterialsList.SortColumn := Column.Index;

      if dbgMaterialsList.SortOrder = soAscending then
      begin
        dbgMaterialsList.SortOrder := soDescending;
        SQLString := ' DESC';
      end
      else
      begin
        dbgMaterialsList.SortOrder := soAscending;
        SQLString := ' ASC';
      end;

      qMaterials.Close;
      qMaterials.SQL.Text := 'SELECT Code, Description, Type, CutType, CutGap, StandardPrice, LinearMatPrice, DegDiff, QualCoeff, AreaCoeff, Length, ' +
                             'Width, SkinSize, Trimmed, Units, Layers, StrokeDepth FROM Material WHERE Code LIKE :Search Order By UPPER(' +
                              Column.FieldName + ') ' + SQLString + ', Code ' + SQLString ;
      qMaterials.Open;
    end;
  end;
end;

procedure TfmAllMaterials.SetFilter;
var
  f, m: string;

begin
  f := '';
  m := '';

  if cbLeather.Checked then
  begin
    f := 'Type = ''L''';
    m := 'Leather';
  end;

  if cbWool.Checked then
  begin
    if f <> '' then
      f := f + ' or ';
    f := f + 'Type = ''W''';

    if m <> '' then
      m := m + ', ';
    m := m + 'Wool';
  end;

  if cbKip.Checked then
  begin
    if f <> '' then
      f := f + ' or ';
    f := f + 'Type = ''K''';

    if m <> '' then
      m := m + ', ';
    m := m + 'Kip';
  end;

  if cbRoll.Checked then
  begin
    if f <> '' then
      f := f + ' or ';
    f := f + 'Type = ''R''';

    if m <> '' then
      m := m + ', ';
    m := m + 'Roll';
  end;

  if cbSheet.Checked then
  begin
    if f <> '' then
      f := f + ' or ';
    f := f + 'Type = ''S''';

    if m <> '' then
      m := m + ', ';
    m := m + 'Sheet';
  end;

  //Something it will not find
  if f = '' then
    f := 'Type =''XXX''';

  tblMaterials.Filter := f;
  tblMaterials.Filtered := True;

  qMaterials.Filter := f;
  qMaterials.Filtered := True;

  //CJY skipping first / last row and Filtered
  if qMaterials.Active then
    qMaterials.Refresh;

  MatTypes := m;
end;

end.
