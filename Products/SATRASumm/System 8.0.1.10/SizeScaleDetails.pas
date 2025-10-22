unit SizeScaleDetails;

interface

uses
  Classes, Controls, Forms, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DB, StdCtrls, Mask, DBCtrls, ExtCtrls,
  Buttons, Grids, DBGridPlus, DBGrids, ComCtrls,  ToolWin, frxClass, frxDBSet,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  frxReportPlus, FDConnectionPlus;

type
  TfmSizeScaleDetails = class(TForm)
    tblSizeScales: TFDTablePlus;
    dsSizeScales: TDataSource;
    tblSizeScaleSizes: TFDTablePlus;
    dsSizeScaleSizes: TDataSource;
    tblSizeScaleSizesLength: TSmallintField;
    tblSizeScaleSizesSize: TStringField;
    tblSizeScalesScale: TStringField;
    tblSizeScalesDescription: TStringField;
    tblSizeScaleSizesScale: TStringField;
    tblSizeScaleSizesSeq: TFloatField;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnRefresh: TSpeedButton;
    pnlMain: TPanel;
    lblDescription: TLabel;
    dbeDescription: TDBEdit;
    pnlView1: TPanel;
    dbtDescription: TDBText;
    pnlScales: TPanel;
    dbgSizes: TDBGridPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    qRedoIndex: TFDQueryPlus;
    pnlKeepPreview: TPanel;
    btnWhereUsed: TSpeedButton;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    frSizeScales: TfrxReportPlus;
    frdbSizeScaleSizes: TfrxDBDataset;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassSizeScaleName(SizeScaleForm : TfmSizeScaleDetails; var Code: string);
    procedure tblSizeScaleSizesBeforeInsert(DataSet: TDataSet);
    procedure tblSizeScaleSizesAfterInsert(DataSet: TDataSet);
    procedure SizeScaleSizesRedoIndex;
    procedure btnWhereUsedClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure UpdateScreen(Editing : boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure SetTabStops(Editing: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure tblSizeScaleSizesBeforeDelete(DataSet: TDataSet);
    procedure tblSizeScaleSizesBeforePost(DataSet: TDataSet);
    procedure frSizeScalesGetValue(const VarName: string; var Value: Variant);
    procedure frSizeScalesBeforePrint(Sender: TfrxReportComponent);
  private
    { Private declarations }
    BusyPrinting: boolean;
    fmSizeScaleDetails: TfmSizeScaleDetails;
    NewIndex : real;
  public
    { Public declarations }
    SizeScaleCode : string;
  end;

implementation

uses
  SysUtils, Graphics, Dialogs, SizeScaleWhereUsed, Summs, OutOfMemory, General,
  CmnVars, AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmSizeScaleDetails.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    if tblSizeScales.state in [dsEdit, dsInsert] then
    begin
      if MessageDlgPos('Save Changes to Size Scale ' + SizeScaleCode + '?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
        btnSave.click
      else
        btnCancel.click;
    end;

    action := caFree;
  end;
end;

procedure TfmSizeScaleDetails.PassSizeScaleName(SizeScaleForm : TfmSizeScaleDetails; var Code: string);
begin
  try
    fmSizeScaleDetails := SizeScaleForm;
    SizeScaleCode := Code;

    Caption := 'Size Scale : ' + SizeScaleCode;

    screen.cursor := crHourGlass;
    tblSizeScales.open;
    tblSizeScales.setRange([SizeScaleCode], [SizeScaleCode]);
    tblSizeScaleSizes.open;
    screen.cursor := crDefault;

    if tblSizeScales.recordcount = 0 then
    begin
      MessageDlgPos('Size Scale ' + SizeScaleCode + ' does not exist', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      close;
    end;
  except
    Close;
    HasClosed := True;
    Raise;
  end;  
end;

procedure TfmSizeScaleDetails.tblSizeScaleSizesBeforeInsert(
  DataSet: TDataSet);
var
   BookMark : TBookMark;
   PriorIndex, NextIndex : real;

begin
  {Set current position in table}
  BookMark := tblSizeScaleSizes.GetBookMark;

  if tblSizeScaleSizes.RecordCount = 0 then
    NewIndex := 1
  else if tblSizeScaleSizes.EOF then
    NewIndex := tblSizeScaleSizesSeq.value + 1
  else
  begin
    tblSizeScaleSizes.Prior;
    if tblSizeScaleSizes.BOF then
    begin
      PriorIndex := 0;
      NewIndex := tblSizeScaleSizesSeq.value / 2
    end
    else
    begin
      PriorIndex := tblSizeScaleSizesSeq.value;
      tblSizeScaleSizes.Next;
      NextIndex := tblSizeScaleSizesSeq.value;
      NewIndex := (PriorIndex + NextIndex) / 2;
    end;

    {Allow 17 inserts before index gets too small}
    if (NewIndex - PriorIndex) < 0.00001 then
    begin
      MessageDlgPos('Unable to insert Sizes, Close Size Scale and try again', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      sysutils.abort;
    end;
  end;

  {Return to/Release position in table}
  try
    tblSizeScaleSizes.GotoBookMark(BookMark);
  except
  end;
  tblSizeScaleSizes.FreeBookMark(BookMark);
end;

procedure TfmSizeScaleDetails.tblSizeScaleSizesAfterInsert(
  DataSet: TDataSet);
begin
  tblSizeScaleSizesSeq.value := NewIndex;
end;

procedure TfmSizeScaleDetails.SizeScaleSizesRedoIndex;
var
  SQLString: string;
  i: integer;

begin
  SQLString := 'UPDATE SizeScaleSizes ' +
               'SET Seq = (' +
               '           SELECT ((COUNT(SSS.Seq) * CONVERT(10000, SQL_DOUBLE)) + SizeScaleSizes.Seq) ' +
               '           FROM SizeScaleSizes SSS ' +
               '           WHERE (SSS.Scale = ''' + QS(SizeScaleCode) + ''') AND ' +
               '                 ((SSS.Seq - (TRUNCATE(SSS.Seq / CONVERT(10000, SQL_DOUBLE), 0) * CONVERT(10000, SQL_DOUBLE))) <= SizeScaleSizes.Seq) AND ' +
               '                 (SizeScaleSizes.Scale = SSS.Scale) ' +
               '           ) ' +
               'WHERE Scale = ''' + QS(SizeScaleCode) + ''';' + #13 +
               'UPDATE SizeScaleSizes ' +
               'SET Seq = TRUNCATE(Seq / CONVERT(10000, SQL_DOUBLE), 0) ' +
               'WHERE Scale = ''' + QS(SizeScaleCode) + ''';';
  qRedoIndex.SQL.Text := SQLString;

  qRedoIndex.ExecSQL;
end;

procedure TfmSizeScaleDetails.btnWhereUsedClick(Sender: TObject);
var
  Failed : boolean;

begin
  if ItemGone(tblSizeScales, SizeScaleCode) then
    Close
  else if not ExistingToFront('Where Used for Size Scale', SizeScaleCode) then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmSizeScaleWhereUsed := TfmSizeScaleWhereUsed.create(fmSumms);
    except
      fmMemoryError.TidyUp(Self);
      Failed := True;
    end;

    if not Failed then
      fmSizeScaleWhereUsed.PassSizeScaleName(SizeScaleCode);
  end;
end;

procedure TfmSizeScaleDetails.btnPrintClick(Sender: TObject);
var
  MyBookmark: TBookmark;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  if ItemGone(tblSizeScales, SizeScaleCode) then
    Close
  else
  begin
    frSizeScales.ReportOptions.Name := 'Preview ' + Caption;
    ClosePreviewForm(Caption);

    btnPrint.Enabled := False;
    btnPrintPreview.Enabled := False;

    MyBookmark := tblSizeScaleSizes.GetBookmark;
    tblSizeScaleSizes.DisableControls;

    frSizeScales.PrintOptions.PrintMode := pmScale;
    frSizeScales.PrintOptions.PrintOnSheet := GetPaperSize;
    frSizeScales.PrepareReport;

    try
      tblSizeScaleSizes.GotoBookmark(MyBookmark);
    except
    end;
    tblSizeScaleSizes.EnableControls;
    tblSizeScaleSizes.FreeBookmark(MyBookmark);

    if ((Sender as TSpeedButton) = btnPrintPreview) then
    begin
      with frSizeScales do
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
      frSizeScales.Print;

    btnPrint.Enabled := True;
    btnPrintPreview.Enabled := True;
  end;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmSizeScaleDetails.btnEditClick(Sender: TObject);
var
  LockSuccess : boolean;

begin
  if ItemGone(tblSizeScales, SizeScaleCode) then
    Close
  else
  begin
    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingleWithoutOption(oSizeScale, tblSizeScales, SizeScaleCode);

    if LockSuccess then
      UpdateScreen(True)
    else
      LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmSizeScaleDetails.btnSaveClick(Sender: TObject);
begin
  if tblSizeScaleSizes.state in [dsEdit, dsInsert] then
    tblSizeScaleSizes.post;

  tblSizeScales.post;
  SizeScaleSizesRedoIndex;
  LocalConnectionSumms.commit;

  UpdateScreen(False);
end;

procedure TfmSizeScaleDetails.UpdateScreen(Editing : boolean);
begin
  if editing then
    tbMain.color := clEditing
  else
    tbMain.color := clBack;

  btnEdit.enabled := not Editing;
  btnSave.enabled := Editing;
  btnCancel.enabled := Editing;
  btnRefresh.enabled := not Editing;

  btnPrint.enabled := not Editing;
  btnPrintPreview.enabled := not Editing;
  btnWhereUsed.enabled := not Editing;

  pnlView1.visible := not Editing;

  SetTabStops(Editing);

  dbgSizes.Columns[1].ReadOnly := not Editing;
  if Editing then
  begin
    dbgSizes.Options := dbgSizes.Options + [dgEditing, dgConfirmDelete];
    dbgSizes.Color := clEditing;
    dbgSizes.Columns[0].color := clEditing;
    dbgSizes.Columns[1].color := clEditing;
  end
  else
  begin
    dbgSizes.Options := dbgSizes.Options - [dgEditing, dgConfirmDelete];
    dbgSizes.Color := clBack;
    dbgSizes.Columns[0].color := clBack;
    dbgSizes.Columns[1].color := clBack;
  end;

  if Editing then
    dbeDescription.setfocus
  else
    tbMain.setfocus;
end;

procedure TfmSizeScaleDetails.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblSizeScaleSizes.cancel;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock (& Non saved edits)
  tblSizeScales.cancel;

  //Refresh Grids
  tblSizeScaleSizes.refresh;
  dbgSizes.refresh;

  UpdateScreen(False);
end;

procedure TfmSizeScaleDetails.btnRefreshClick(Sender: TObject);
begin
  if ItemGone(tblSizeScales, SizeScaleCode) then
    Close
  else
    tblSizeScaleSizes.refresh;
end;

procedure TfmSizeScaleDetails.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmSizeScaleDetails.SetTabStops(Editing: Boolean);
begin
  dbeDescription.TabStop := Editing;
end;

procedure TfmSizeScaleDetails.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;

  SetTabStops(False);
end;

procedure TfmSizeScaleDetails.frSizeScalesBeforePrint(
  Sender: TfrxReportComponent);
begin
  frSizeScales.PreviewOptions.AllowEdit := False;
  frSizeScales.PreviewOptions.Buttons := frSizeScales.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frSizeScales.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frSizeScales.PreviewOptions.ZoomMode := zmDefault
  else
    frSizeScales.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmSizeScaleDetails.frSizeScalesGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
    Value := 'Size Scale : ' + SizeScaleCode
  else if (VarName = 'Description') then
    Value := dbtDescription.Caption;
end;

procedure TfmSizeScaleDetails.tblSizeScaleSizesBeforeDelete(
  DataSet: TDataSet);
begin
  if dbgSizes.Columns[0].color = clBack then
    Abort;
end;

procedure TfmSizeScaleDetails.tblSizeScaleSizesBeforePost(
  DataSet: TDataSet);
var
  NoStr: string;
  SizeFloat: real;

begin
  try
    if not(tblSizeScaleSizesSize.Value = '') then
    begin
      if tblSizeScalesScale.Value = 'ENGLISH' then
      begin
        if pos('c', tblSizeScaleSizesSize.Value) > 0 then
        begin
          NoStr := tblSizeScaleSizesSize.Value;
          Delete(NoStr, Length(NoStr), 1);
          SizeFloat := StrToFloat(NoStr);
        end
        else
          SizeFloat := StrToFloat(tblSizeScaleSizesSize.Value) + 13;

        tblSizeScaleSizesLength.Value := round(101.6 + (SizeFloat * 8.47) - 17);
      end
      else if tblSizeScalesScale.Value = 'CONTINENTAL' then
      begin
        SizeFloat := StrToFloat(tblSizeScaleSizesSize.Value);
        tblSizeScaleSizesLength.Value := round((SizeFloat * 6.67) - 13.34);
      end
      else if tblSizeScalesScale.Value = 'MONDOPOINT' then
        tblSizeScaleSizesLength.Value := StrToInt(tblSizeScaleSizesSize.Value);
    end;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('Invalid Size', E.Message, '');
      abort;
    end;
  end;
end;

end.
