unit ConstructionDetails;

interface

uses
  Classes, Controls, Forms, DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DBGridPlus, StdCtrls, DBCtrls, DBGrids,
  ExtCtrls, Buttons, ComCtrls,  XStringGrid, XStringGridPlus, Grids, Mask,
  ToolWin, frxClass, frxDBSet, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, frxReportPlus, FDConnectionPlus;

type
  TAccessDBGrid = class(TDBGridPlus);

  TfmConstructionDetails = class(TForm)
    tblConstructions: TFDTablePlus;
    dsConParts: TDataSource;
    tblConParts: TFDTablePlus;
    dsConstructions: TDataSource;
    tblConPartsPart: TStringField;
    tblConPartsAltMaterial: TStringField;
    tblConstructionsSizeRange: TStringField;
    tblConstructionsDescription: TStringField;
    tblConstructionsSampleSize: TStringField;
    tblConstructionsCostedSize: TStringField;
    tblConPartsPartDescription: TStringField;
    tblConPartsUse: TBooleanField;
    tblConstructionsConstruction: TStringField;
    tblConPartsConstruction: TStringField;
    tblConPartsID: TIntegerField;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnDelete: TSpeedButton;
    btnRefresh: TSpeedButton;
    btnAllowance: TSpeedButton;
    pnlTop: TPanel;
    lblDescription: TLabel;
    dbeDescription: TDBEdit;
    dbtSizeRange: TDBText;
    lblSizeRange: TLabel;
    pnlView1: TPanel;
    dbtDescription: TDBText;
    tblConPartsPartSizeRange: TStringField;
    tblConPartsPartSampleSize: TStringField;
    tblConPartsPartCostedSize: TStringField;
    LocalConnectionSumms: TFDConnectionPlus;
    tblConPartsUseYesNo: TStringField;
    lblSampleSize: TLabel;
    lblCostedSize: TLabel;
    dbtSampleSize: TDBText;
    dbtCostedSize: TDBText;
    pnlMiddle: TPanel;
    dbgConParts: TDBGridPlus;
    pnlView2: TPanel;
    sgConParts: TXStringGridPlus;
    tblConstructionsSizeScale: TStringField;
    tblConPartsPartSizeScale: TStringField;
    pnlKeepPreview: TPanel;
    btnWhereUsed: TSpeedButton;
    btnCopy: TSpeedButton;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    tblConPartsPartMadeInPairs: TBooleanField;
    tblConstructionsMadeInPairs: TBooleanField;
    dbtMadeInPairs: TDBText;
    lblMadeInPairs: TLabel;
    tblConstructionsMadeInPairsYesNo: TStringField;
    frConstructions: TfrxReportPlus;
    frDBdsConstructions: TfrxDBDataset;
    frDBdsConParts: TfrxDBDataset;
    lblTktNote: TLabel;
    btnAllowancesAllOut: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassConstructionName(ConstructionForm : TfmConstructionDetails; var Code: string);
    procedure tblConPartsBeforePost(DataSet: TDataSet);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnWhereUsedClick(Sender: TObject);
    procedure btnAllowanceClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure tblConPartsPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure dbgConPartsCellClick(Column: TColumn);
    procedure dbgConPartsDblClick(Sender: TObject);
    procedure dbgConPartsKeyPress(Sender: TObject; var Key: Char);
    procedure dbgConPartsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dbgConPartsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure dsConPartsDataChange(Sender: TObject; Field: TField);
    procedure btnEditClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure UpdatePartsCopy;
    procedure UpdateScreen(Editing : boolean);
    procedure tblConPartsCalcFields(DataSet: TDataSet);
    procedure tblConPartsAfterPost(DataSet: TDataSet);
    procedure tblConPartsAfterDelete(DataSet: TDataSet);
    procedure sgConPartsDblClick(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure sgConPartsKeyPress(Sender: TObject; var Key: Char);
    procedure dbtSizeRangeDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgConPartsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SetTabStops(Editing: Boolean);
    procedure tblConstructionsCalcFields(DataSet: TDataSet);
    procedure frConstructionsGetValue(const VarName: string;
      var Value: Variant);
    procedure frConstructionsBeforePrint(Sender: TfrxReportComponent);
    procedure tblConstructionsBeforeOpen(DataSet: TDataSet);
    procedure tblConstructionsAfterOpen(DataSet: TDataSet);
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
    procedure tblConPartsBeforeRefresh(DataSet: TDataSet);
    procedure btnAllowancesAllOutClick(Sender: TObject);
  private
    { Private declarations }
    BusyPrinting: boolean;
    BusyAllowances: boolean;
    fmConstructionDetails: TfmConstructionDetails;
    NumberOfConParts: integer;
    procedure SetLoading(const Value: Boolean);
  public
    { Public declarations }
    ConstructionCode : string;
    property Loading: Boolean write SetLoading;
  end;

var
  GroupPrinting, PrintingCancelled: boolean;
    
implementation

uses
  Windows, Messages, SysUtils, Graphics, Dialogs, General, SummsVars, CmnVars, ConstructionsWhereUsed, Summs,
  ConstructionAllowance, SizeRangeDetails, CopyConstruction, PartDetails, MaterialDetails, OutOfMemory,
  AdvErrorHandler, Dongle_Green, ConstructionAllowanceFull;

{$R *.DFM}

var
  WhichField: string;

procedure TfmConstructionDetails.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BusyPrinting or BusyAllowances or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    if tblConstructions.state in [dsEdit, dsInsert] then
    begin
      if MessageDlgPos('Save Changes to Construction ' + ConstructionCode + '?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
        btnSave.click
      else
        btnCancel.click;
    end;

    action := caFree;
  end;
end;

procedure TfmConstructionDetails.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmConstructionDetails.PassConstructionName(ConstructionForm : TfmConstructionDetails; var Code: string);
begin
  try
    fmConstructionDetails := ConstructionForm;
    ConstructionCode := Code;

//    Caption := 'Construction : ' + ConstructionCode;
    Caption := 'Construction Loading...';

    Repaint;
    application.ProcessMessages;

    screen.cursor := crHourGlass;
    tblConstructions.open;
    tblConstructions.setRange([ConstructionCode], [ConstructionCode]);
    tblConParts.open;

    tblConstructions.OnCalcFields := tblConstructionsCalcFields;
    tblConstructions.Refresh;

    application.ProcessMessages;

    UpdatePartsCopy;
    screen.cursor := crDefault;

    if tblConstructions.recordcount = 0 then
    begin
      MessageDlgPos('Construction ' + ConstructionCode + ' does not exist', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      Caption := 'Construction : Not Found';
      close;
    end;
    Caption := 'Construction : ' + ConstructionCode;
  except
    Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure TfmConstructionDetails.tblConPartsBeforePost(DataSet: TDataSet);
begin
  //CJY Uppercasing a Null returns a blank string which can upset RI
  if not tblConPartsPart.IsNull then
    tblConPartsPart.value := UpperCase(tblConPartsPart.value);
  //CJY Uppercasing a Null returns a blank string which can upset RI
  if not tblConPartsAltMaterial.IsNull then
    tblConPartsAltMaterial.value := UpperCase(tblConPartsAltMaterial.value);

  if (NumberOfConParts > 0) and (tblConParts.State in [dsInsert]) then
  begin
  //If sizeRange is blank, Part must not exist...
    if tblConPartsPartSizeRange.IsNull then
    begin
      MessageDlgPos('Part ' + tblConPartsPart.value + ' does not exist', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      abort;
    end
    else if (tblConPartsPartSizeRange.value <> tblConstructionsSizeRange.value) then
    begin
      MessageDlgPos('Cannot add a part with a different Size Range', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      abort;
    end;
    if (tblConPartsPartSampleSize.value <> tblConstructionsSampleSize.value) or
       (tblConPartsPartCostedSize.value <> tblConstructionsCostedSize.value) then
    begin
      MessageDlgPos('Cannot add a part with a different Sample/Costed Size', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      abort;
    end;
    if (tblConPartsPartMadeInPairs.value <> tblConstructionsMadeInPairs.value) then
    begin
      MessageDlgPos('Cannot add a part with a different setting for Made in Pairs', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      abort;
    end;
  end;
end;

procedure TfmConstructionDetails.tblConPartsBeforeRefresh(DataSet: TDataSet);
begin
  fmSumms.qParts.Refresh;
end;

procedure TfmConstructionDetails.btnWhereUsedClick(Sender: TObject);
var
  Failed : boolean;

begin
  if ItemGone(tblConstructions, ConstructionCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Where Used for Construction', ConstructionCode) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmConstructionsWhereUsed := TfmConstructionsWhereUsed.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmConstructionsWhereUsed.PassConstructionName(ConstructionCode);
    end;
  end;
end;

procedure TfmConstructionDetails.btnDeleteClick(Sender: TObject);
var
  LockSuccess : boolean;
  CanDelete : boolean;

begin
  if ItemGone(tblConstructions, ConstructionCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    CanDelete := False;

    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oConstruction, fmSumms.tblLocks, tblConstructions, ConstructionCode, True);

    if LockSuccess then
    begin
      CanDelete := (MessageDlgPos('Delete Construction?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes);
      if CanDelete then
      begin
        try
          tblConstructions.delete;
        except
          on E: Exception do
          begin
            fmErrorHandler.DebugMessageDlg('Construction in use', E.Message, '');
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
    tblConParts.Cancel;
    tblConstructions.Cancel;
    if CanDelete then
      Close;
  end;
end;

procedure TfmConstructionDetails.btnAllowanceClick(Sender: TObject);
var
  fmConstructionAllowance: TfmConstructionAllowance;
  Failed : boolean;

begin
  if ItemGone(tblConstructions, ConstructionCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if tblConParts.recordcount = 0 then
      MessageDlgPos('No Parts on Construction', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
    begin
      if not BusyAllowances then
      begin
        BusyAllowances := True;

        Screen.cursor := crHourGlass;
        Failed := false;
        try
          fmConstructionAllowance := TfmConstructionAllowance.create(fmSumms);

          if not Option_CuttingTimes then
            fmConstructionAllowance.Width := fmConstructionAllowance.Width - 60;
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;

        if not Failed then
          fmConstructionAllowance.PassConstructionName(fmConstructionAllowance, ConstructionCode);

        BusyAllowances := False;
      end
      else
        messagedlg('Already calculating Allowances for this construction', mtInformation, [mbOk], 0);
    end;
  end;
end;

procedure TfmConstructionDetails.btnPrintClick(Sender: TObject);
var
  mMemo: TFrxmemoView;

begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  if ItemGone(tblConstructions, ConstructionCode) then
    Close
  else
  begin
    frConstructions.ReportOptions.Name := 'Preview ' + Caption;
    ClosePreviewForm(Caption);

    btnPrint.Enabled := False;
    btnPrintPreview.Enabled := False;

    mMemo := frConstructions.FindObject('mMadeInPairsTitle') as TfrxMemoView;
    mMemo.Visible := lblMadeInPairs.Visible;
    mMemo := frConstructions.FindObject('mMadeInPairs') as TfrxMemoView;
    mMemo.Visible := dbtMadeInPairs.Visible;

    frConstructions.PrintOptions.PrintMode := pmScale;
    frConstructions.PrintOptions.PrintOnSheet := GetPaperSize;
    frConstructions.PrepareReport;
    frConstructions.PrintOptions.ShowDialog := not GroupPrinting;
    if ((Sender as TSpeedButton) = btnPrintPreview) then
    begin
      with frConstructions do
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
      PrintingCancelled := not frConstructions.Print;

    btnPrint.Enabled := True;
    btnPrintPreview.Enabled := True;
  end;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmConstructionDetails.btnCopyClick(Sender: TObject);
begin
  if ItemGone(tblConstructions, ConstructionCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    fmCopyConstruction.BaseCode := tblConstructionsConstruction.Value;
    fmCopyConstruction.ShowModal;
  end;
end;

procedure TfmConstructionDetails.tblConPartsPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  if Pos('is not unique', E.Message) > 0 then
  begin
    tblConPartsID.value := tblConPartsID.value + 1;
    action := daRetry;
  end;
end;

procedure TfmConstructionDetails.tblConstructionsAfterOpen(DataSet: TDataSet);
begin
//  tblConstructions.OnCalcFields := tblConstructionsCalcFields;
end;

procedure TfmConstructionDetails.tblConstructionsBeforeOpen(DataSet: TDataSet);
begin
//  tblConstructions.OnCalcFields := nil;
end;

procedure TfmConstructionDetails.tblConstructionsCalcFields(DataSet: TDataSet);
begin
  if (tblConParts.RecordCount = 0)  then
    tblConstructionsMadeInPairsYesNo.value := ''
  else if tblConstructionsMadeInPairs.value then
    tblConstructionsMadeInPairsYesNo.value := 'Yes'
  else
    tblConstructionsMadeInPairsYesNo.value := 'No';
end;

procedure TfmConstructionDetails.dbgConPartsCellClick(Column: TColumn);
begin
  WhichField := Column.FieldName;
end;

procedure TfmConstructionDetails.dbgConPartsDblClick(Sender: TObject);
begin
  if (WhichField = 'UseYesNo') then
  begin
    if not (tblConParts.state in [dsEdit]) then
      tblConParts.edit;
    tblConPartsUse.value := not tblConPartsUse.value;
  end;
end;

procedure TfmConstructionDetails.dbgConPartsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (ord(Key) = VK_RETURN) then
    dbgConPartsDblClick(Self);

  if (dbgConParts.SelectedField.Fieldname = 'Part') or (dbgConParts.SelectedField.Fieldname = 'AltMaterial') then
    Key := upcase(Key);

  if (dbgConParts.SelectedField.Fieldname = 'UseYesNo') then
  begin
    Key := upcase(Key);

    if not (tblConParts.state in [dsEdit]) then
      tblConParts.edit;

    if Key = 'Y' then
      tblConPartsUse.value := True
    else if Key = 'N' then
      tblConPartsUse.value := False;
  end;
end;

procedure TfmConstructionDetails.dbgConPartsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  WhichCell: TGridCoord;

begin
  BringToFront;

  if DragType = dragPart then
  begin
    if DragSort = dragInsert then
      tblConParts.insert
    else if DragSort = dragAppend then
    begin
      tblConParts.Last;
      tblConParts.append;
    end;

    tblConPartsPart.value := DragCode;
  end
  else if DragType = dragMaterial then
  begin
    WhichCell := (dbgConParts as TCustomGrid).MouseCoord(X, Y);

  //Have to create new class of DBGrid in order to access the DataLink property.
  //This code sets the current record to the record the dragdrop is released over.
  //When Material is released it is added to the current record.
  //Works correctly even when grid has been scrolled.

    if WhichCell.Y > 0 then
    begin
      TAccessDBgrid(dbgConParts).DataLink.ActiveRecord := WhichCell.Y - 1;
      if tblConParts.state in [dsBrowse] then
        tblConParts.edit;
      tblConPartsAltMaterial.value := DragCode;
    end;
  end;

  if not(tblConParts.state in [dsBrowse]) then
    tblConParts.post;
end;

procedure TfmConstructionDetails.dbgConPartsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := false;
  if (DragType = dragPart) and (tblConPartsPart.readonly = false) then
    Accept := true;
  if (DragType = dragMaterial) and (not tblConPartsPart.isNull) then
    Accept := true;
end;

procedure TfmConstructionDetails.dsConPartsDataChange(Sender: TObject;
  Field: TField);
begin
{  lblSizeRange.enabled := (tblConParts.recordCount > 0);
  lblSampleSize.enabled := (tblConParts.recordCount > 0);
  lblCostedSize.enabled := (tblConParts.recordCount > 0);
  dbtSizeRange.visible := (tblConParts.recordCount > 0);
  dbtSampleSize.visible := (tblConParts.recordCount > 0);
  dbtCostedSize.visible := (tblConParts.recordCount > 0);    }
end;

procedure TfmConstructionDetails.btnEditClick(Sender: TObject);
var
  LockSuccess : boolean;

begin
  if ItemGone(tblConstructions, ConstructionCode) then
    Close
  else
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oConstruction, fmSumms.tblLocks, tblConstructions, ConstructionCode, True);

    if LockSuccess then
    begin
      UpdateScreen(True);
      NumberOfConParts := tblConParts.RecordCount;
    end
    else
      LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmConstructionDetails.btnSaveClick(Sender: TObject);
begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if tblConParts.state in [dsEdit, dsInsert] then
      tblConParts.post;
    tblConstructions.post;
    LocalConnectionSumms.commit;
    UpdateScreen(False);
    UpdatePartsCopy;
  end;
end;

procedure TfmConstructionDetails.btnAllowancesAllOutClick(Sender: TObject);
var
  fmConstructionAllowanceFull: TfmConstructionAllowanceFull;
  Failed : boolean;

begin
  if ItemGone(tblConstructions, ConstructionCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if tblConParts.recordcount = 0 then
      MessageDlgPos('No Parts on Construction', mtInformation, [mbOK], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
    else
    begin
      if not BusyAllowances then
      begin
        BusyAllowances := True;

        Failed := false;
        try
          fmConstructionAllowanceFull := TfmConstructionAllowanceFull.create(fmSumms);
        except
          fmMemoryError.TidyUp(self);
          Failed := true;
        end;

        if not Failed then
          fmConstructionAllowanceFull.AllAllowances(ConstructionCode);

        BusyAllowances := False;
      end
      else
        messagedlg('Already calculating Allowances for this construction', mtInformation, [mbOk], 0);
    end;
  end;
end;

procedure TfmConstructionDetails.btnCancelClick(Sender: TObject);
begin
  //Cancel Non saved edits
  tblConParts.cancel;

  //Cancel saved edits
  LocalConnectionSumms.Rollback;

  //Release lock (& Non saved edits)
  tblConstructions.cancel;

  //Refresh Grids
  tblConParts.refresh;
  dbgConParts.refresh;

  UpdateScreen(False);
end;

procedure TfmConstructionDetails.btnRefreshClick(Sender: TObject);
begin
  if ItemGone(tblConstructions, ConstructionCode) then
    Close
  else
    UpdatePartsCopy;
end;

procedure TfmConstructionDetails.UpdatePartsCopy;
var
   i : integer;
   s : string;

begin
  Loading := True;

  if tblConParts.active then
  begin
    sgConParts.RowCount := 2;
    sgConParts.Cells[0, 1] := '';
    sgConParts.Cells[1, 1] := '';
    sgConParts.Cells[2, 1] := '';
    sgConParts.Cells[3, 1] := '';

    i := 0;

    tblConParts.refresh;
    tblConParts.first;
    while not tblConParts.eof do
    begin
      inc(i);
      if i > 1 then
         sgConParts.RowCount := sgConParts.RowCount + 1;
      sgConParts.Cells[0, i] := tblConPartsPart.value;
      sgConParts.Cells[1, i] := tblConPartsPartDescription.value;
      sgConParts.Cells[2, i] := tblConPartsAltMaterial.value;
      if tblConPartsUse.value then
        s := 'Yes'
      else
        s := 'No';
      sgConParts.Cells[3, i] := s;
      tblConParts.next;
    end;
  end;

  Loading := False;
end;

procedure TfmConstructionDetails.UpdateScreen(Editing : boolean);
begin
  if editing then
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
  btnAllowance.enabled := not Editing;

  pnlView1.visible := not Editing;
  pnlView2.visible := not Editing;

  SetTabStops(Editing);

  SetColumnWidthsDetails1(fmConstructionDetails, sgConParts, dbgConParts, 3, Editing);

  if Editing then
    dbeDescription.setfocus
  else
    tbMain.setfocus;
end;

procedure TfmConstructionDetails.tblConPartsCalcFields(DataSet: TDataSet);
begin
  if tblConPartsUse.value then
    tblConPartsUseYesNo.value := 'Yes'
  else
    tblConPartsUseYesNo.value := 'No';
end;

procedure TfmConstructionDetails.tblConPartsAfterPost(DataSet: TDataSet);
begin
  NumberOfConParts := tblConParts.RecordCount;
  if (NumberOfConParts = 1) then
  begin
    tblConstructionsSizeScale.value := tblConPartsPartSizeScale.value;
    tblConstructionsSizeRange.value := tblConPartsPartSizeRange.value;
    tblConstructionsSampleSize.value := tblConPartsPartSampleSize.value;
    tblConstructionsCostedSize.value := tblConPartsPartCostedSize.value;
    tblConstructionsMadeInPairs.value := tblConPartsPartMadeInPairs.value;
  end;

  lblSizeRange.enabled := (NumberOfConParts > 0);
  lblSampleSize.enabled := (NumberOfConParts > 0);
  lblCostedSize.enabled := (NumberOfConParts > 0);
  dbtSizeRange.visible := (NumberOfConParts > 0);
  dbtSampleSize.visible := (NumberOfConParts > 0);
  dbtCostedSize.visible := (NumberOfConParts > 0);
end;

procedure TfmConstructionDetails.tblConPartsAfterDelete(DataSet: TDataSet);
begin
  NumberOfConParts := tblConParts.RecordCount;
  if (NumberOfConParts = 0) then
  begin
    tblConstructionsSizeScale.value := '';
    tblConstructionsSizeRange.value := '';
    tblConstructionsSampleSize.value := '';
    tblConstructionsCostedSize.value := '';
    tblConstructionsMadeInPairs.Clear;
  end;
end;

procedure TfmConstructionDetails.sgConPartsDblClick(Sender: TObject);
var
  RowNo: integer;
  Failed: boolean;
  Code: string;
  fmPartDetails: TfmPartDetails;
  fmMaterialDetails: TfmMaterialDetails;

begin
  RowNo := sgConParts.Row;
  if RowNo <> -1 then
  begin
    if sgConParts.Columns[sgConParts.Col].Caption = 'Alternative Material' then
      WhichField := 'AltMaterial'
    else if sgConParts.Columns[sgConParts.Col].Caption = 'Part' then         
      WhichField := 'Part'
    else
      WhichField := '';

    if (RowNo >= 1) and (RowNo <= sgConParts.RowCount) then
    begin
      if (WhichField = 'Part') or (WhichField = 'AltMaterial')then
        Code := sgConParts.Cells[sgConParts.Col, sgConParts.Row];

      Failed := false;
      if (not (Code = '')) and (WhichField = 'Part') then
      begin
        if not ExistingToFront('Part', Code) then
        begin
          Screen.cursor := crHourGlass;
          try
            fmPartDetails := TfmPartDetails.create(fmSumms);
          except
            fmMemoryError.TidyUp(self);
            Failed := true;
          end;

          if not Failed then
            fmPartDetails.PassPartName(fmPartDetails, Code);
        end;
      end;

      if (not (Code = '')) and (WhichField = 'AltMaterial') then
      begin
        if not ExistingToFront('Material', Code) then
        begin
          Screen.cursor := crHourGlass;
          try
            fmMaterialDetails := TfmMaterialDetails.create(fmSumms);
          except
            fmMemoryError.TidyUp(self);
            Failed := true;
          end;

          if not Failed then
            fmMaterialDetails.PassMaterialName(fmMaterialDetails, Code);
        end;
      end;
    end;
  end;
end;

procedure TfmConstructionDetails.LocalConnectionSummsAfterConnect(
  Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmConstructionDetails.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmConstructionDetails.sgConPartsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    sgConPartsDblClick(Self);
end;

procedure TfmConstructionDetails.dbtSizeRangeDblClick(Sender: TObject);
var
  fmSizeRangeDetails: TfmSizeRangeDetails;
  Code : string;
  Failed : boolean;

begin
  Code := tblConstructionsSizeRange.value;

  if not (Code = '') then
  begin
    if not ExistingToFront('Size Range', Code) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmSizeRangeDetails := TfmSizeRangeDetails.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmSizeRangeDetails.PassSizeRangeName(fmSizeRangeDetails, Code);
    end;

    if fmSumms.mmMinimiseAllonOpen.checked then
      WindowState := wsMinimized;
  end;
end;

procedure TfmConstructionDetails.FormCreate(Sender: TObject);
var
  i: integer;

begin
  AutoColor(Self);
  BusyPrinting := false;
  BusyAllowances := False;

  Loading := True;

  if (not Option_SinglesAllowed) then
  begin
    lblMadeInPairs.visible := False;
    dbtMadeInPairs.visible := False;
    pnlTop.Height := pnlTop.Height - 25;
    Height := Height - 25;
  end;

  if (not Option_ProductionSystem) then
  begin
    dbgConparts.Columns[3].Visible := False;
    sgConParts.Columns[3].Width := -1;
    Width := Width - 41;
    lblTktNote.visible := False;
  end;

  btnAllowancesAllOut.Visible := Option_AllConstructionAllowancesOut;

  if GroupPrinting then
  begin
    Enabled := False;
    Position := poMainFormCenter;
  end;

  SetTabStops(False);

  application.ProcessMessages;
end;

procedure TfmConstructionDetails.frConstructionsBeforePrint(
  Sender: TfrxReportComponent);
begin
  frConstructions.PreviewOptions.AllowEdit := False;
  frConstructions.PreviewOptions.Buttons := frConstructions.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frConstructions.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frConstructions.PreviewOptions.ZoomMode := zmDefault
  else
    frConstructions.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmConstructionDetails.frConstructionsGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company;
  if (VarName = 'ReportTitle') then
    Value := 'Construction : ' + ConstructionCode;
end;

procedure TfmConstructionDetails.sgConPartsSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if ARow = 0 then
    CanSelect := False;
end;

procedure TfmConstructionDetails.SetLoading(const Value: Boolean);
begin
  Enabled := not Value;
end;

procedure TfmConstructionDetails.SetTabStops(Editing: Boolean);
begin
  dbeDescription.TabStop := Editing;
  sgConParts.TabStop := not Editing;
  dbgConParts.TabStop := Editing;
end;

end.

