unit SizeRangeDetails;

interface

uses
  Classes, Controls, Forms, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, StdCtrls, Grids, DBGridPlus, DBGrids,
  DBCtrls, ExtCtrls, Buttons, ToolWin, ComCtrls, Menus, Mask, frxClass,
  frxDBSet, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  frxReportPlus, FDConnectionPlus;

type
  TfmSizeRangeDetails = class(TForm)
    tblSizeRanges: TFDTablePlus;
    dsSizeRanges: TDataSource;
    tblSizeRangeSizes: TFDTablePlus;
    dsSizeRangeSizes: TDataSource;
    tblSizeRangesRange: TStringField;
    tblSizeRangesScale: TStringField;
    tblSizeRangesDescription: TStringField;
    tblSizeRangeSizesRange: TStringField;
    tblSizeRangeSizesSize: TStringField;
    tblSizeRangeSizesSeq: TFloatField;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnDelete: TSpeedButton;
    btnRefresh: TSpeedButton;
    pnlMain: TPanel;
    lblDescription: TLabel;
    lblSizeScale: TLabel;
    dbtSizeScale: TDBText;
    dbeDescription: TDBEdit;
    pnlView1: TPanel;
    dbtDescription: TDBText;
    pnlSizes: TPanel;
    dbgSizes: TDBGridPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    dbtSampleSize: TDBText;
    dbtCostedSize: TDBText;
    tblSizeRangesSampleSize: TStringField;
    tblSizeRangesCostedSize: TStringField;
    lblSampleSize: TLabel;
    lblCostedSize: TLabel;
    qValidSampleCostedSizes: TFDQueryPlus;
    tblSizeRangeSizesScale: TStringField;
    qRedoIndex: TFDQueryPlus;
    qRelationShipsExist: TFDQueryPlus;
    qRelationShipsExistEXPR: TIntegerField;
    pnlKeepPreview: TPanel;
    btnWhereUsed: TSpeedButton;
    btnCopy: TSpeedButton;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    btnSampleSize: TSpeedButton;
    btnCostedSize: TSpeedButton;
    frSizeRanges: TfrxReportPlus;
    frdbSizeRanges: TfrxDBDataset;
    frdbSizeRangeSizes: TfrxDBDataset;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassSizeRangeName(SizeRangeForm : TfmSizeRangeDetails; var Code: string);
    procedure tblSizeRangeSizesBeforeInsert(DataSet: TDataSet);
    procedure tblSizeRangeSizesAfterInsert(DataSet: TDataSet);
    procedure SizeRangeSizesRedoIndex;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnWhereUsedClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure dbgSizesCellClick(Column: TColumn);
    procedure btnEditClick(Sender: TObject);
    procedure UpdateScreen(Editing, InUse: boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure dbtSizeScaleDblClick(Sender: TObject);
    procedure SetTabStops(Editing: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnSampleSizeClick(Sender: TObject);
    procedure btnCostedSizeClick(Sender: TObject);
    procedure tblSizeRangeSizesBeforeDelete(DataSet: TDataSet);
    procedure frSizeRangesBeforePrint(Sender: TfrxReportComponent);
    procedure frSizeRangesGetValue(const VarName: string; var Value: Variant);
  private
    { Private declarations }
    BusyPrinting: boolean;
    NewIndex : real;
    fmSizeRangeDetails: TfmSizeRangeDetails;
  public
    { Public declarations }
    SizeRangeCode : string;
  end;

var
  WhichField : string;

implementation

uses
  SysUtils, Graphics, Dialogs, SizeRangeWhereUsed, Summs, CopySizeRange,
  General, SizeScaleDetails, OutOfMemory, CmnVars, AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmSizeRangeDetails.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    if tblSizeRanges.state in [dsEdit, dsInsert] then
    begin
      if MessageDlgPos('Save Changes to Size Range ' + SizeRangeCode + '?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
        btnSave.click
      else
        btnCancel.click;
    end;

    action := caFree;
  end;
end;

procedure TfmSizeRangeDetails.PassSizeRangeName(SizeRangeForm : TfmSizeRangeDetails; var Code: string);
begin
  try
    fmSizeRangeDetails := SizeRangeForm;
    SizeRangeCode := Code;

    Caption := 'Size Range : ' + SizeRangeCode;

    screen.cursor := crHourGlass;
    tblSizeRanges.open;
    tblSizeRanges.setRange([SizeRangeCode], [SizeRangeCode]);
    tblSizeRangeSizes.open;
    screen.cursor := crDefault;

    if tblSizeRanges.recordcount = 0 then
    begin
      MessageDlgPos('Size Range ' + SizeRangeCode + ' does not exist', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      close;
    end;
  except
    Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure TfmSizeRangeDetails.tblSizeRangeSizesBeforeInsert(
  DataSet: TDataSet);
var
   BookMark : TBookMark;
   PriorIndex, NextIndex : real;

begin
  {Set current position in table}
  BookMark := tblSizeRangeSizes.GetBookMark;
  if tblSizeRangeSizes.RecordCount = 0 then
    NewIndex := 1
  else if tblSizeRangeSizes.EOF then
    NewIndex := tblSizeRangeSizesSeq.value + 1
  else
  begin
    tblSizeRangeSizes.Prior;
    if tblSizeRangeSizes.BOF then
    begin
      PriorIndex := 0;
      NewIndex := tblSizeRangeSizesSeq.value / 2
    end
    else
    begin
      PriorIndex := tblSizeRangeSizesSeq.value;
      tblSizeRangeSizes.Next;
      NextIndex := tblSizeRangeSizesSeq.value;
      NewIndex := (PriorIndex + NextIndex) / 2;
    end;

    {Allow 17 inserts before index gets too small}
    if (NewIndex - PriorIndex) < 0.00001 then
    begin
      MessageDlgPos('Unable to insert Sizes, Close Size Range and try again', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

      sysutils.abort;
    end;
  end;

  {Return to/Release position in table}
  try
    tblSizeRangeSizes.GotoBookMark(BookMark);
  except
  end;
  tblSizeRangeSizes.FreeBookMark(BookMark);
end;

procedure TfmSizeRangeDetails.tblSizeRangeSizesAfterInsert(
  DataSet: TDataSet);
begin
  tblSizeRangeSizesSeq.value := NewIndex;
end;

procedure TfmSizeRangeDetails.SizeRangeSizesRedoIndex;
var
  SQLString: string;
  i: integer;

begin
  SQLString := 'UPDATE SizeRangeSizes ' +
               'SET Seq = (' +
               '           SELECT ((COUNT(SSS.Seq) * CONVERT(10000, SQL_DOUBLE)) + SizeRangeSizes.Seq) ' +
               '           FROM SizeRangeSizes SSS ' +
               '           WHERE (SSS.Range = ''' + QS(SizeRangeCode) + ''') AND ' +
               '                 ((SSS.Seq - (TRUNCATE(SSS.Seq / CONVERT(10000, SQL_DOUBLE), 0) * CONVERT(10000, SQL_DOUBLE))) <= SizeRangeSizes.Seq) AND ' +
               '                 (SizeRangeSizes.Range = SSS.Range) ' +
               '           ) ' +
               'WHERE Range = ''' + QS(SizeRangeCode) + ''';';

  SQLString := SQLString + #13 + 'UPDATE SizeRangeSizes ' +
               'SET Seq = TRUNCATE(Seq / CONVERT(10000, SQL_DOUBLE), 0) ' +
               'WHERE Range = ''' + QS(SizeRangeCode) + ''';';
  qRedoIndex.SQL.Text := SQLString;

  qRedoIndex.ExecSQL;
end;

procedure TfmSizeRangeDetails.btnDeleteClick(Sender: TObject);
var
  LockSuccess : boolean;
  CanDelete : boolean;

begin
  if ItemGone(tblSizeRanges, SizeRangeCode) then
    Close
  else
  begin
    CanDelete := False;

    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingleWithoutOption(oSizeRange, tblSizeRanges, SizeRangeCode);

    if LockSuccess then
    begin
      CanDelete := (MessageDlgPos('Delete Size Range?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes);
      if CanDelete then
      begin
        try
          tblSizeRanges.delete;
        except
          on E: Exception do
          begin
            fmErrorHandler.DebugMessageDlg('Size Range in use', E.Message, '');
            CanDelete := false
          end;
        end;
      end;
    end;

    //Unlock
    if CanDelete then
      LocalConnectionSumms.Commit
    else
      LocalConnectionSumms.RollBack;

    //Ensure table not in Edit mode and Close if deleted
    tblSizeRangeSizes.Cancel;
    tblSizeRanges.cancel;
    if CanDelete then
      Close;
  end;
end;

procedure TfmSizeRangeDetails.btnWhereUsedClick(Sender: TObject);
var
  Failed : boolean;

begin
  if ItemGone(tblSizeRanges, SizeRangeCode) then
    Close
  else if not ExistingToFront('Where Used for Size Range', SizeRangeCode) then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmSizeRangeWhereUsed := TfmSizeRangeWhereUsed.create(fmSumms);
    except
      fmMemoryError.TidyUp(Self);
      Failed := True;
    end;

    if not Failed then
      fmSizeRangeWhereUsed.PassSizeRangeName(SizeRangeCode);
  end;
end;

procedure TfmSizeRangeDetails.btnPrintClick(Sender: TObject);
var
  MyBookmark : TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  if ItemGone(tblSizeRanges, SizeRangeCode) then
    Close
  else
  begin
    frSizeRanges.ReportOptions.Name := 'Preview ' + Caption;
    ClosePreviewForm(Caption);

    btnPrint.Enabled := False;
    btnPrintPreview.Enabled := False;

    MyBookmark := tblSizeRangeSizes.GetBookmark;
    tblSizeRangeSizes.DisableControls;

    frSizeRanges.PrintOptions.PrintMode := pmScale;
    frSizeRanges.PrintOptions.PrintOnSheet := GetPaperSize;
    frSizeRanges.PrepareReport;

    try
      tblSizeRangeSizes.GotoBookmark(MyBookmark);
    except
    end;
    tblSizeRangeSizes.EnableControls;
    tblSizeRangeSizes.FreeBookmark(MyBookmark);

    if ((Sender as TSpeedButton) = btnPrintPreview) then
    begin
      with frSizeRanges do
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
      frSizeRanges.Print;

    btnPrint.Enabled := True;
    btnPrintPreview.Enabled := True;
  end;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmSizeRangeDetails.btnCopyClick(Sender: TObject);
begin
  if ItemGone(tblSizeRanges, SizeRangeCode) then
    Close
  else
  begin
    fmCopySizeRange.BaseCode := tblSizeRangesRange.Value;
    fmCopySizeRange.ShowModal
  end;
end;

procedure TfmSizeRangeDetails.dbgSizesCellClick(Column: TColumn);
begin
  WhichField:=Column.FieldName;
end;

procedure TfmSizeRangeDetails.btnEditClick(Sender: TObject);
var
  LockSuccess, InUse : boolean;

begin
  if ItemGone(tblSizeRanges, SizeRangeCode) then
    Close
  else
  begin
    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingleWithoutOption(oSizeRange, tblSizeRanges, SizeRangeCode);
    InUse := False;

    //Check Range not used on Relationship
    if LockSuccess then
    begin
      qRelationshipsExist.paramByName('Range').value := SizeRangeCode;
      qRelationshipsExist.open;
      InUse := (qRelationshipsExistEXPR.value > 0);
      qRelationshipsExist.close;
      if InUse then
        MessageDlgPos('Size Range ' + SizeRangeCode + ' used on a Size Relationship' + #13 +
                   'Can only change Description and Sample/Costed Sizes', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
    end;

    if LockSuccess then
      UpdateScreen(True, InUse)
    else
      LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmSizeRangeDetails.UpdateScreen(Editing, InUse: boolean);
begin
  if Editing then
    tbMain.color := clEditing
  else
    tbMain.color := clBack;

  btnEdit.enabled := not Editing;
  btnSave.enabled := Editing;
  btnCancel.enabled := Editing;
  btnDelete.enabled := not Editing;
  btnRefresh.enabled := not Editing;

  btnPrint.enabled := not Editing;
  btnPrintPreview.enabled := not Editing;
  btnCopy.enabled := not Editing;
  btnWhereUsed.enabled := not Editing;

  btnSampleSize.enabled := Editing;
  btnCostedSize.enabled := Editing;

  pnlView1.visible := not Editing;

  SetTabStops(Editing);

  if Editing and (not InUse) then
  begin
    dbgSizes.Options := dbgSizes.Options + [dgEditing, dgConfirmDelete];
    dbgSizes.Color := clEditing;
    dbgSizes.Columns[0].color := clEditing;
  end
  else
  begin
    dbgSizes.Options := dbgSizes.Options - [dgEditing, dgConfirmDelete];
    dbgSizes.Color := clBack;
    dbgSizes.Columns[0].color := clBack;
  end;

  if Editing then
    dbeDescription.setfocus
  else
    tbMain.setfocus;
end;

procedure TfmSizeRangeDetails.btnSaveClick(Sender: TObject);
var
  ValidSizes : boolean;

begin
  if tblSizeRangeSizes.state in [dsEdit, dsInsert] then
    tblSizeRangeSizes.post;

  if tblSizeRangeSizes.RecordCount = 0 then
  begin
    tblSizeRangesSampleSize.value := '';
    tblSizeRangesCostedSize.value := '';
  end
  else
  begin
    qValidSampleCostedSizes.paramByName('Range').value := tblSizeRangesRange.value;
    qValidSampleCostedSizes.paramByName('SampleSize').value := tblSizeRangesSampleSize.value;
    qValidSampleCostedSizes.paramByName('CostedSize').value := tblSizeRangesCostedSize.value;
    qValidSampleCostedSizes.open;
    //CJY: qValidSampleCostedSizes.FetchOptions.RecordCountMode set to cmTotal
    ValidSizes := (qValidSampleCostedSizes.recordcount = 1);
    qValidSampleCostedSizes.close;
    if not ValidSizes then
    begin
      MessageDlgPos('Sample/Costed Sizes not in Size Range', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      abort;
    end;
  end;

  tblSizeRanges.post;
  SizeRangeSizesRedoIndex;
  LocalConnectionSumms.commit;

  UpdateScreen(False, False);
end;

procedure TfmSizeRangeDetails.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblSizeRangeSizes.cancel;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock (& Non saved edits)
  tblSizeRanges.cancel;

  //Refresh Grids
  tblSizeRangeSizes.refresh;
  dbgSizes.refresh;

  UpdateScreen(False, False);
end;

procedure TfmSizeRangeDetails.btnRefreshClick(Sender: TObject);
begin
  if ItemGone(tblSizeRanges, SizeRangeCode) then
    Close
  else
    tblSizeRangeSizes.refresh;
end;

procedure TfmSizeRangeDetails.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmSizeRangeDetails.dbtSizeScaleDblClick(Sender: TObject);
var
  fmSizeScaleDetails: TfmSizeScaleDetails;
  Code : string;
  Failed : boolean;

begin
  Code := tblSizeRangesScale.value;

  if not(Code = '') then
  begin
    if not ExistingTofront('Size Scale', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmSizeScaleDetails := TfmSizeScaleDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmSizeScaleDetails.PassSizeScaleName(fmSizeScaleDetails, Code);
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmSizeRangeDetails.SetTabStops(Editing: Boolean);
begin
  dbeDescription.TabStop := Editing;
end;

procedure TfmSizeRangeDetails.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;

  SetTabStops(False);
end;

procedure TfmSizeRangeDetails.frSizeRangesBeforePrint(
  Sender: TfrxReportComponent);
begin
  frSizeRanges.PreviewOptions.AllowEdit := False;
  frSizeRanges.PreviewOptions.Buttons := frSizeRanges.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frSizeRanges.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frSizeRanges.PreviewOptions.ZoomMode := zmDefault
  else
    frSizeRanges.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmSizeRangeDetails.frSizeRangesGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
    Value := 'Size Range : ' + SizeRangeCode;
end;

procedure TfmSizeRangeDetails.btnSampleSizeClick(Sender: TObject);
begin
  tblSizeRangesSampleSize.value := tblSizeRangeSizesSize.value;
end;

procedure TfmSizeRangeDetails.btnCostedSizeClick(Sender: TObject);
begin
  tblSizeRangesCostedSize.value := tblSizeRangeSizesSize.value;
end;

procedure TfmSizeRangeDetails.tblSizeRangeSizesBeforeDelete(
  DataSet: TDataSet);
begin
  if dbgSizes.Columns[0].color = clBack then
    Abort;
end;

end.


