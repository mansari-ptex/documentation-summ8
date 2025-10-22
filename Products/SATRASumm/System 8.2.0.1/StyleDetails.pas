unit StyleDetails;

interface

uses
  Classes, Controls, Forms, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Grids, DBGridPlus, StdCtrls, Mask, DBCtrls,
  ExtCtrls, Buttons, ExtDlgs, DBGrids, ToolWin, ComCtrls, XStringGrid, XStringGridPlus, Dialogs,
  math, frxClass, frxDBSet, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, TotalReport, TotalReport2, frxReportPlus, FDConnectionPlus;

type
  TfmStyleDetails = class(TForm)
    tblStyles: TFDTablePlus;
    dsStyles: TDataSource;
    tblStylesStyle: TStringField;
    tblStylesPicturePath: TStringField;
    tblStyConstructions: TFDTablePlus;
    dsStyConstructions: TDataSource;
    tblStyConstructionsStyle: TStringField;
    tblStyConstructionsConstruction: TStringField;
    tblStyConstructionsDescription: TStringField;
    LocalConnectionSumms: TFDConnectionPlus;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnDelete: TSpeedButton;
    btnRefresh: TSpeedButton;
    btnCopy: TSpeedButton;
    btnWhereUsed: TSpeedButton;
    btnAllowance: TSpeedButton;
    pnlTop: TPanel;
    lblDescription: TLabel;
    dbeDescription: TDBEdit;
    tblStylesPicture: TBlobField;
    btnPictureAdd: TSpeedButton;
    pnlLeft: TPanel;
    dbiPicture: TDBImage;
    pnlRight: TPanel;
    imgOriginalSizeToFit: TImage;
    imgOriginalStretched: TImage;
    dbePicturePath: TDBEdit;
    opdPicture: TOpenPictureDialog;
    dbgStyConstructions: TDBGridPlus;
    tblStyConstructionsCurrentYesNo: TStringField;
    pnlView1: TPanel;
    pnlView2: TPanel;
    sgStyConstructions: TXStringGridPlus;
    dbtDescription: TDBText;
    tblStylesCurrentCon: TStringField;
    lblCurrent: TLabel;
    dbtCurrCon: TDBText;
    tblStylesDescription: TStringField;
    btnPictureClear: TSpeedButton;
    pnlKeepPreview: TPanel;
    btnPrintPreview: TSpeedButton;
    btnPrint: TSpeedButton;
    qConParts: TFDQueryPlus;
    tblStylesCurrentConMadeInPairs: TBooleanField;
    dbtMadeInPairs: TDBText;
    lblMadeInPairs: TLabel;
    tblStylesCurrentConMadeInPairsYesNo: TStringField;
    frStyle: TfrxReportPlus;
    frdbStyConsts: TfrxDBDataset;
    frdbStyles: TfrxDBDataset;
    sbPreviewTotal: TSpeedButton;
    sbPrintTotal: TSpeedButton;
    sbPreviewTotal2: TSpeedButton;
    sbPrintTotal2: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassStyleName(StyleForm : TfmStyleDetails; var Code: string);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnWhereUsedClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure dbgStyConstructionsCellClick(Column: TColumn);
    procedure dbgStyConstructionsDblClick(Sender: TObject);
    procedure dbgStyConstructionsKeyPress(Sender: TObject; var Key: Char);
    procedure dbgStyConstructionsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dbgStyConstructionsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure dbePicturePathChange(Sender: TObject);
    procedure btnAllowanceClick(Sender: TObject);
    procedure btnPictureAddClick(Sender: TObject);
    procedure tblStyConstructionsCalcFields(DataSet: TDataSet);
    procedure btnEditClick(Sender: TObject);
    procedure UpdateScreen(Editing : boolean);
    procedure UpdateConstructionsCopy;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure tblStyConstructionsBeforeDelete(DataSet: TDataSet);
    procedure tblStyConstructionsBeforePost(DataSet: TDataSet);
    procedure sgStyConstructionsDblClick(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure sgStyConstructionsKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure sgStyConstructionsSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure btnPictureClearClick(Sender: TObject);
    procedure SetTabStops(Editing: Boolean);
    procedure tblStylesCalcFields(DataSet: TDataSet);
    procedure frStyleGetValue(const VarName: string; var Value: Variant);
    procedure frStyleBeforePrint(Sender: TfrxReportComponent);
  private
    { Private declarations }
    BusyPrinting: boolean;
    fmStyleDetails: TfmStyleDetails;
    dmTotalReport: TdmTotalReport;
    dmTotalReport2: TdmTotalReport2;
  public
    { Public declarations }
    StyleCode : string;
  end;

const
  IMAGESIZE = 200;

var
  GroupPrinting, PrintingCancelled: boolean;
    
implementation

uses
  Windows, Messages, SysUtils, Graphics, FileCtrl, StylesWhereUsed, Summs, CopyStyle,
  ConstructionDetails, ConstructionAllowance, OutOfMemory, General, SummsVars, CmnVars,
  AdvErrorHandler, Dongle_Green;

{$R *.DFM}

var
  WhichField : string;

procedure TfmStyleDetails.FormClose(Sender: TObject; var Action: TCloseAction);
var
  CanClose : boolean;

begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    if tblStyles.state in [dsEdit, dsInsert] then
    begin
      if MessageDlgPos('Save Changes to Style ' + StyleCode + '?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
        btnSave.click
      else
        btnCancel.click;
    end;

    dmTotalReport.Free;
    dmTotalReport2.Free;
    action := caFree;
  end;
end;

procedure TfmStyleDetails.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmStyleDetails.PassStyleName(StyleForm : TfmStyleDetails; var Code: string);
begin
  try
    fmStyleDetails := StyleForm;
    StyleCode := Code;

//    Caption := 'Style : ' + StyleCode;
    Caption := 'Style Loading...';

    screen.cursor := crHourGlass;
    tblStyles.open;
    tblStyles.setRange([StyleCode], [StyleCode]);
    tblStyConstructions.open;
    UpdateConstructionsCopy;
    screen.cursor := crDefault;

    if tblStyles.recordcount = 0 then
    begin
      MessageDlgPos('Style ' + StyleCode + ' does not exist', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      Caption := 'Style : Not Found';
      close;
    end;

    Caption := 'Style : ' + StyleCode;
  except
    Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure TfmStyleDetails.btnWhereUsedClick(Sender: TObject);
var
  Failed: boolean;

begin
  if ItemGone(tblStyles, StyleCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Where Used for Style', StyleCode) then
    begin
      Screen.cursor := crHourGlass;
      Failed := False;
      try
        fmStylesWhereUsed := TfmStylesWhereUsed.create(fmSumms);
      except
        fmMemoryError.TidyUp(Self);
        Failed := True
      end;

      if not Failed then
        fmStylesWhereUsed.PassPartName(StyleCode);
    end;
  end;
end;

procedure TfmStyleDetails.btnDeleteClick(Sender: TObject);
var
  LockSuccess: boolean;
  CanDelete: boolean;

begin
  if ItemGone(tblStyles, StyleCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    CanDelete := False;

    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oStyle, fmSumms.tblLocks, tblStyles, StyleCode, True);

    if LockSuccess then
    begin
      CanDelete := (MessageDlgPos('Delete Style?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes);
      if CanDelete then
      begin
        tblStyles.Edit;
        tblStylesCurrentCon.Clear;
        tblStyles.post;

        try
          tblStyles.delete;
        except
          //Just for consistency - Shouldn't ever get here.
          //Styles are the top level.
          on E: Exception do
          begin
            fmErrorHandler.DebugMessageDlg('Style in use', E.Message, '');
            CanDelete := false;
          end;
        end;
      end;
    end;

    //Unlock
    if CanDelete then
      LocalConnectionSumms.Commit
    else
      LocalConnectionSumms.RollBack;

    //Try and delete the corresponding Construction if applicable
    if (CanDelete and AutoDeleteConstruction) then
    begin
      if fmSumms.tblConstructions.findkey([StyleCode]) then
      try
        fmSumms.tblConstructions.delete;
      except
        on E: Exception do
          fmErrorHandler.DebugMessageDlg('Construction cannot automatically be deleted', E.Message, '');
      end;
    end;

    //Ensure table not in Edit mode and Close if deleted
    tblStyles.Cancel;
    if CanDelete then
      Close;
  end;
end;

procedure TfmStyleDetails.btnPrintClick(Sender: TObject);
var
  mMemo: TFrxMemoView;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  if ItemGone(tblStyles, StyleCode) then
    Close
  else if CreatingFullReport then
    MessageDlgPos('Already creating another Total Report', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else
  begin
    btnPrint.Enabled := False;
    btnPrintPreview.Enabled := False;
    sbPreviewTotal.Enabled := False;
    sbPrintTotal.Enabled := False;
    sbPreviewTotal2.Enabled := False;
    sbPrintTotal2.Enabled := False;

    tblStyles.DisableControls;

    if ((Sender as TSpeedButton) = btnPrint) or ((Sender as TSpeedButton) = btnPrintPreview) then
    begin
      frStyle.ReportOptions.Name := 'Preview ' + Caption;
      ClosePreviewForm(Caption);

      mMemo := frStyle.FindObject('mMadeInPairsTitle') as TfrxMemoView;
      mMemo.Visible := lblMadeInPairs.Visible;
      mMemo := frStyle.FindObject('mMadeInPairs') as TfrxMemoView;
      mMemo.Visible := dbtMadeInPairs.Visible;

      frStyle.PrintOptions.PrintMode := pmScale;
      frStyle.PrintOptions.PrintOnSheet := GetPaperSize;
      frStyle.PrepareReport;
      frStyle.PrintOptions.ShowDialog := not GroupPrinting;
      if ((Sender as TSpeedButton) = btnPrintPreview) then
      begin
        with frStyle do
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
        PrintingCancelled := not frStyle.Print;
    end
    else if ((Sender as TSpeedButton) = sbPrintTotal) or ((Sender as TSpeedButton) = sbPreviewTotal) then
    begin
      dmTotalReport.frWholeStyle.ReportOptions.Name := 'Preview ' + Caption;
      ClosePreviewForm(Caption);

      dmTotalReport.PrintTotalReport(StyleCode, dbiPicture.Visible, ((Sender as TSpeedButton) = sbPreviewTotal));
    end
    else if ((Sender as TSpeedButton) = sbPrintTotal2) or ((Sender as TSpeedButton) = sbPreviewTotal2) then
    begin
      dmTotalReport2.frWholeStyle.ReportOptions.Name := 'Preview ' + Caption;
      ClosePreviewForm(Caption);

      dmTotalReport2.PrintTotalReport(StyleCode, dbiPicture.Visible, ((Sender as TSpeedButton) = sbPreviewTotal2));
    end;

    tblStyles.EnableControls;

    btnPrint.Enabled := True;
    btnPrintPreview.Enabled := True;
    sbPreviewTotal.Enabled := True;
    sbPrintTotal.Enabled := True;
    sbPreviewTotal2.Enabled := True;
    sbPrintTotal2.Enabled := True;
  end;
//      if not tblStylesPicture.isNull then
//        fmrpStyleDetails.qrimgPicture.Picture.Assign(dbiPicture.Picture);
//      fmrpStyleDetails.lblNoImage.enabled := tblStylesPicture.isNull;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmStyleDetails.btnCopyClick(Sender: TObject);
begin
  if ItemGone(tblStyles, StyleCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    fmCopyStyle.BaseCode := tblStylesStyle.Value;
    fmCopyStyle.ShowModal;
  end;
end;

procedure TfmStyleDetails.dbgStyConstructionsCellClick(Column: TColumn);
begin
  WhichField:=Column.FieldName;
end;

procedure TfmStyleDetails.dbgStyConstructionsDblClick(Sender: TObject);
begin
  if (WhichField = 'CurrentYesNo') then
  begin
    tblStylesCurrentCon.value := tblStyConstructionsConstruction.value;
    tblStyConstructions.refresh;
  end;
end;

procedure TfmStyleDetails.dbgStyConstructionsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (ord(Key) = VK_RETURN) then
    dbgStyConstructionsDblClick(Self);

  if (dbgStyConstructions.SelectedField.Fieldname = 'Construction') then
    Key := upcase(Key);

  if (dbgStyConstructions.SelectedField.Fieldname = 'CurrentYesNo') then
  begin
    Key := upcase(Key);

    if Key = 'Y' then
    begin
      tblStylesCurrentCon.value := tblStyConstructionsConstruction.value;
      tblStyConstructions.refresh;
    end;
  end;
end;

procedure TfmStyleDetails.dbgStyConstructionsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  BringToFront;

  if DragType = dragConstruction then
  begin
    if DragSort = dragInsert then
      tblStyConstructions.insert
    else if DragSort = dragAppend then
    begin
      tblStyConstructions.Last;
      tblStyConstructions.append;
    end;

    tblStyConstructionsConstruction.value := DragCode;
    tblStyConstructions.post;
  end;
  dbeDescription.SetFocus;
  dbgStyConstructions.SetFocus;
end;

procedure TfmStyleDetails.dbgStyConstructionsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := false;
  if (DragType = dragConstruction) and (tblStyConstructions.state in [dsBrowse]) and (tblStyConstructionsConstruction.readonly = false) then
    Accept := true;
end;

procedure TfmStyleDetails.dbePicturePathChange(Sender: TObject);
begin
  dbiPicture.Hint := tblStylesPicturePath.value;
  dbiPicture.visible := not tblStylesPicture.isNull;

  if dbiPicture.Visible then
    pnlLeft.Caption := ''
  else
    pnlLeft.Caption := 'No image';
end;

procedure TfmStyleDetails.btnAllowanceClick(Sender: TObject);
var
  fmConstructionAllowance: TfmConstructionAllowance;
  Code: string;
  i: integer;
  Failed: boolean;
  NoParts: Integer;

begin
  if ItemGone(tblStyles, StyleCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if tblStyConstructions.RecordCount = 0 then
      MessageDlgPos('No Constructions on Style', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
    begin
      tblStyConstructions.First;
      i := 0;
      Failed := False;
      while not(i = tblStyConstructions.RecordCount) and not(Failed) do
      begin
        inc(i);
        Code := tblStyConstructionsConstruction.value;

        qConParts.ParamByName('Code').Value := Code;
        qConParts.Open;
        //CJY: qConParts.FetchOptions.RecordCountMode set to cmTotal
        NoParts := qConParts.recordcount;
        qConParts.Close;

        if NoParts = 0 then
          MessageDlgPos('No Parts on Construction ' + Code, mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
        else
        begin
          Screen.cursor := crHourGlass;
          Failed := false;
          try
            fmConstructionAllowance := TfmConstructionAllowance.create(fmSumms);

            if not Option_CuttingTimes then
              fmConstructionAllowance.Width := fmConstructionAllowance.Width - 70;
          except
            fmMemoryError.TidyUp(self);
            Failed := true;
          end;
        end;

        if (not Failed) and (NoParts > 0) then
          fmConstructionAllowance.PassConstructionName(fmConstructionAllowance, Code);

        tblStyConstructions.Next;
      end;
    end;
  end;
end;

procedure TfmStyleDetails.btnPictureAddClick(Sender: TObject);
var
  newBMP : TBitmap;
  picRect : TRect;
  origHeight, origWidth : real;
  newHeight, newWidth : real;
  ImageSizeAdj : real;

begin
  if ItemGone(tblStyles, StyleCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if DirectoryExists(StylePicDirectory) then
      opdPicture.InitialDir := StylePicDirectory
    else
    begin
      MessageDlgPos('Parameters | Style Pictures directory does not exist', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      opdPicture.InitialDir := ExtractFileDrive(ExpandFileName('SSumm7.exe'));
    end;

    if opdPicture.Execute then
    begin
      imgOriginalSizeToFit.height := IMAGESIZE;
      imgOriginalSizeToFit.width := IMAGESIZE;
      try
        imgOriginalSizeToFit.Picture.LoadFromFile(opdPicture.filename);
        OrigHeight := imgOriginalSizeToFit.height;
        OrigWidth := imgOriginalSizeToFit.width;

        //Shrinks Bigger images but doesn't 'Blow up' smaller ones.
        if (OrigHeight > IMAGESIZE) or (OrigWidth > IMAGESIZE) then
          ImageSizeAdj := IMAGESIZE
        else
          ImageSizeAdj := Max(OrigHeight, OrigWidth);

        if OrigHeight > OrigWidth then
        begin
          newHeight := ImageSizeAdj;
          newWidth := ImageSizeAdj * (OrigWidth / OrigHeight);
        end
        else
        begin
          newHeight := ImageSizeAdj * (OrigHeight / OrigWidth);
          newWidth := ImageSizeAdj;
        end;
        imgOriginalStretched.height := round(newHeight);
        imgOriginalStretched.width := round(newWidth);

        imgOriginalStretched.Picture.LoadFromFile(opdPicture.filename);

        newBMP := TBitmap.create;
        with newBMP do
        begin
          height := imgOriginalStretched.height;
          width := imgOriginalStretched.Width;
        end;

        picRect := rect(0, 0, newBmp.width, newBMP.height);
        newBMP.canvas.stretchdraw(picrect, imgOriginalStretched.picture.graphic);

        if not (tblStyles.State in [dsEdit, dsInsert]) then
          tblStyles.Edit;
        tblStylesPicture.Assign(newBMP);
        tblStylesPicturepath.value := opdPicture.filename;
        dbePicturePathChange(Self);

        newBMP.free;
      except
        on E: Exception do
          fmErrorHandler.DebugMessageDlg('Not a valid picture file', E.Message, '');
      end;
    end;
  end;
end;

procedure TfmStyleDetails.tblStyConstructionsCalcFields(DataSet: TDataSet);
begin
  if (tblStyConstructionsConstruction.value = tblStylesCurrentCon.value) and
     (not tblStyConstructionsConstruction.isNull) then
    tblStyConstructionsCurrentYesNo.value := 'Yes'
  else
    tblStyConstructionsCurrentYesNo.value := 'No';
end;

procedure TfmStyleDetails.tblStylesCalcFields(DataSet: TDataSet);
begin
  if tblStylesCurrentConMadeInPairs.isNull then
    tblStylesCurrentConMadeInPairsYesNo.value := ''
  else if tblStylesCurrentConMadeInPairs.value then
    tblStylesCurrentConMadeInPairsYesNo.value := 'Yes'
  else
    tblStylesCurrentConMadeInPairsYesNo.value := 'No';
end;

procedure TfmStyleDetails.btnEditClick(Sender: TObject);
var
  LockSuccess : boolean;
  CurrentCon : string;

begin
  if ItemGone(tblStyles, StyleCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oStyle, fmSumms.tblLocks, tblStyles, StyleCode, True);

    if LockSuccess then
    begin
      CurrentCon := tblStylesCurrentCon.value;
      tblStylesCurrentCon.Clear;
      tblStyles.post;

      tblStyles.Edit;
      if CurrentCon <> '' then
        tblStylesCurrentCon.value := CurrentCon;
      UpdateScreen(True);
    end
    else
      LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmStyleDetails.UpdateScreen(Editing : boolean);
begin
  if editing then
  begin
    tbMain.color := clEditing;
    dbgStyConstructions.Columns[0].Color := clEditing;
    dbgStyConstructions.Columns[2].Color := clEditing;
  end
  else
  begin
    tbMain.color := clBack;
    dbgStyConstructions.Columns[0].Color := clBack;
    dbgStyConstructions.Columns[2].Color := clBack;
  end;

  btnEdit.enabled := not Editing;
  btnSave.enabled := Editing;
  btnCancel.enabled := Editing;
  btnDelete.enabled := not Editing;
  btnRefresh.enabled := not Editing;

  btnPrint.enabled := not Editing;
  btnPrintPreview.enabled := not Editing;
  sbPreviewTotal.enabled := not Editing;
  sbPrintTotal.enabled := not Editing;
  sbPreviewTotal2.enabled := not Editing;
  sbPrintTotal2.enabled := not Editing;
  btnCopy.enabled := not Editing;
  if Option_ProductionSystem then
    btnWhereUsed.enabled := not Editing;
  btnPictureAdd.enabled := Editing;
  btnPictureClear.enabled := Editing;
  btnAllowance.enabled := not Editing;

  pnlView1.visible := not Editing;
  pnlView2.visible := not Editing;

  SetTabStops(Editing);

  SetColumnWidthsDetails1(fmStyleDetails, sgStyConstructions, dbgStyConstructions, 2, Editing);

  if Editing then
    dbeDescription.setfocus
  else
    tbMain.setfocus;
end;

procedure TfmStyleDetails.UpdateConstructionsCopy;
var
   i : integer;
   s : string;

begin
  if tblStyConstructions.active then
  begin
    sgStyConstructions.RowCount := 2;
    sgStyConstructions.Cells[0, 1] := '';
    sgStyConstructions.Cells[1, 1] := '';
    sgStyConstructions.Cells[2, 1] := '';

    i := 0;
    tblStyConstructions.refresh;
    tblStyConstructions.first;
    while not tblStyConstructions.eof do
    begin
      inc(i);
      if i > 1 then
         sgStyConstructions.RowCount := sgStyConstructions.RowCount + 1;
      sgStyConstructions.Cells[0, i] := tblStyConstructionsConstruction.value;
      sgStyConstructions.Cells[1, i] := tblStyConstructionsDescription.value;
      if tblStyConstructionsConstruction.value = tblStylesCurrentCon.value then
        s := 'Yes'
      else
        s := 'No';
      sgStyConstructions.Cells[2, i] := s;
      tblStyConstructions.next;
    end;
  end;
end;

procedure TfmStyleDetails.btnSaveClick(Sender: TObject);
begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if tblStylesCurrentCon.value = '' then
       MessageDlgPos('No Current construction selected', mtWarning, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));

    if tblStyConstructions.state in [dsEdit, dsInsert] then
      tblStyConstructions.post;

    //Temporarily disable TDBImage to avoid
    //'Bitmap image is not valid' error.
    dbiPicture.DataField := '';

    tblStyles.post;

    LocalConnectionSumms.commit;
    UpdateScreen(False);
    UpdateConstructionsCopy;

    //Reenable TDBImage.
    dbiPicture.DataField := 'Picture';
  end;
end;

procedure TfmStyleDetails.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblStyConstructions.cancel;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock (& Non saved edits)
  tblStyles.cancel;

  UpdateScreen(False);

  btnRefresh.Click;
end;

procedure TfmStyleDetails.btnRefreshClick(Sender: TObject);
begin
  if ItemGone(tblStyles, StyleCode) then
    Close
  else
    UpdateConstructionsCopy;
end;

procedure TfmStyleDetails.tblStyConstructionsBeforeDelete(
  DataSet: TDataSet);
begin
  if tblStyConstructionsCurrentYesNo.value = 'Yes' then
    tblStylesCurrentCon.Clear;
end;

procedure TfmStyleDetails.tblStyConstructionsBeforePost(DataSet: TDataSet);
begin
  //CJY Uppercasing a Null returns a blank string which can upset RI
  if not tblStyConstructionsConstruction.IsNull then
    tblStyConstructionsConstruction.value := UpperCase(tblStyConstructionsConstruction.value);
  if tblStyConstructionsConstruction.oldvalue = tblStylesCurrentCon.value then
    tblStylesCurrentCon.value := tblStyConstructionsConstruction.value;
end;

procedure TfmStyleDetails.sgStyConstructionsDblClick(Sender: TObject);
var
  RowNo, ColNo: integer;
  Failed: boolean;
  Code: string;
  fmConstructionDetails : TfmConstructionDetails;

begin
  RowNo := sgStyConstructions.Row;
  ColNo := sgStyConstructions.Col;

  if (RowNo >= 1) and (RowNo <= sgStyConstructions.RowCount) and
    (sgStyConstructions.Columns[sgStyConstructions.Col].Caption = 'Construction') then
  begin
    Code := sgStyConstructions.Cells[sgStyConstructions.Col, sgStyConstructions.Row];

    Failed := false;
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
    end;
  end;
end;

procedure TfmStyleDetails.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmStyleDetails.sgStyConstructionsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    sgStyConstructionsDblClick(Self);
end;

procedure TfmStyleDetails.FormCreate(Sender: TObject);
var
  i: integer;
  
begin
  AutoColor(Self);
  GroupPrinting := false;
  BusyPrinting := false;

  if not Option_ProductionSystem then
    btnWhereUsed.enabled := False;

  if (not Option_SinglesAllowed) then
  begin
    lblMadeInPairs.visible := False;
    dbtMadeInPairs.visible := False;
    pnlTop.Height := pnlTop.Height - 25;
    Height := Height - 25;
  end;

  if GroupPrinting then
  begin
    Enabled := False;
    Position := poMainFormCenter;
  end;

  SetTabStops(False);

  dmTotalReport := TdmTotalReport.create(fmSumms);//fmStyleDetails);
  dmTotalReport2 := TdmTotalReport2.create(fmSumms);//fmStyleDetails);
end;

procedure TfmStyleDetails.frStyleBeforePrint(
  Sender: TfrxReportComponent);
begin
  frStyle.PreviewOptions.AllowEdit := False;
  frStyle.PreviewOptions.Buttons := frStyle.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frStyle.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frStyle.PreviewOptions.ZoomMode := zmDefault
  else
    frStyle.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmStyleDetails.frStyleGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
    Value := 'Style : ' + StyleCode;
end;

procedure TfmStyleDetails.sgStyConstructionsSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if ARow = 0 then
    CanSelect := False;
end;

procedure TfmStyleDetails.btnPictureClearClick(Sender: TObject);
begin
  if ItemGone(tblStyles, StyleCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not (tblStyles.State in [dsEdit, dsInsert]) then
      tblStyles.Edit;
    tblStylesPicture.Clear;
    dbiPicture.Visible := False;
    pnlLeft.Caption := 'No image';
  end;
end;

procedure TfmStyleDetails.SetTabStops(Editing: Boolean);
begin
  dbeDescription.TabStop := Editing;
  sgStyConstructions.TabStop := not Editing;
  dbgStyConstructions.TabStop := Editing;
end;

end.

