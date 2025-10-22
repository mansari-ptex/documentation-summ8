unit SupplierDetails;

interface

uses
  Classes, Controls, Forms, StdCtrls, Mask, DBCtrls, DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons, ExtCtrls,
  ToolWin, ComCtrls, frxClass, frxDBSet, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, frxReportPlus, FDConnectionPlus;

type
  TfmSupplierDetails = class(TForm)
    tblSuppliers: TFDTablePlus;
    dsSuppliers: TDataSource;
    tblSuppliersCode: TStringField;
    tblSuppliersDescription: TStringField;
    tblSuppliersContact: TStringField;
    tblSuppliersAddress1: TStringField;
    tblSuppliersAddress2: TStringField;
    tblSuppliersAddress3: TStringField;
    tblSuppliersAddress4: TStringField;
    tblSuppliersPhone: TStringField;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnDelete: TSpeedButton;
    btnRefresh: TSpeedButton;
    pnlTop: TPanel;
    lblPhone: TLabel;
    lblDescription: TLabel;
    lblContact: TLabel;
    lblAddress: TLabel;
    dbeAddress4: TDBEdit;
    dbeAddress3: TDBEdit;
    dbePhone: TDBEdit;
    dbeDescription: TDBEdit;
    dbeContact: TDBEdit;
    dbeAddress1: TDBEdit;
    dbeAddress2: TDBEdit;
    pnlView1: TPanel;
    dbtDescription: TDBText;
    dbtContact: TDBText;
    dbtAddress1: TDBText;
    dbtAddress2: TDBText;
    dbtAddress3: TDBText;
    dbtAddress4: TDBText;
    dbtPhone: TDBText;
    LocalConnectionSumms: TFDConnectionPlus;
    pnlKeepPreview: TPanel;
    btnWhereUsed: TSpeedButton;
    btnPrint: TSpeedButton;
    btnPrintPreview: TSpeedButton;
    frSupplier: TfrxReportPlus;
    frdbSuppliers: TfrxDBDataset;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PassSupplierName(var Code: string);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnWhereUsedClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure UpdateScreen(Editing : boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetTabStops(Editing: Boolean);
    procedure frSupplierGetValue(const VarName: string; var Value: Variant);
    procedure frSupplierBeforePrint(Sender: TfrxReportComponent);
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
  private
    { Private declarations }
    BusyPrinting: boolean;
  public
    { Public declarations }
    SupplierCode : string;
  end;

var
  fmSupplierDetails: TfmSupplierDetails;
  GroupPrinting, PrintingCancelled: boolean;

implementation

uses
  Graphics, Dialogs, SuppliersWhereUsed, Summs, OutOfMemory, General,
  SummsVars, CmnVars, SysUtils, AdvErrorHandler, Dongle_Green;

{$R *.DFM}

procedure TfmSupplierDetails.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if BusyPrinting or (Pos('Loading...', Caption) > 0) then
  begin
    ShowMessage('Can not close busy window ''' + Caption + '''.');
    action := caNone;
  end
  else
  begin
    if tblSuppliers.state in [dsEdit, dsInsert] then
    begin
      if MessageDlgPos('Save Changes to Supplier ' + SupplierCode + '?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
        btnSave.click
      else
        btnCancel.click;
    end;

    action := caFree;
  end;
end;

procedure TfmSupplierDetails.FormActivate(Sender: TObject);
begin
  Screen.cursor := crDefault;
end;

procedure TfmSupplierDetails.PassSupplierName(var Code: string);
begin
  try
    SupplierCode := Code;

    Caption := 'Supplier : ' + SupplierCode;

    screen.cursor := crHourGlass;
    tblSuppliers.open;
    tblSuppliers.setRange([SupplierCode], [SupplierCode]);
    screen.cursor := crDefault;

    if tblSuppliers.recordcount = 0 then
    begin
      MessageDlgPos('Supplier ' + SupplierCode + ' does not exist', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top));
      close;
    end;
  except
    Close;
    HasClosed := True;
    Raise;
  end;
end;

procedure TfmSupplierDetails.btnDeleteClick(Sender: TObject);
var
  LockSuccess : boolean;
  CanDelete : boolean;

begin
  if ItemGone(tblSuppliers, SupplierCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    CanDelete := False;

    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oSupplier, fmSumms.tblLocks, tblSuppliers, SupplierCode, True);

    if LockSuccess then
    begin
      CanDelete := (MessageDlgPos('Delete Supplier?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes);
      if CanDelete then
      begin
        try
          tblSuppliers.delete;
        except
          on E: Exception do
          begin
            fmErrorHandler.DebugMessageDlg('Supplier in use', E.Message, '');
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

    //Ensure table not in Edit mode and Close if deleted
    tblSuppliers.Cancel;
    if CanDelete then
      Close;
  end;
end;

procedure TfmSupplierDetails.btnWhereUsedClick(Sender: TObject);
var
  Failed : boolean;

begin
  if ItemGone(tblSuppliers, SupplierCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    if not ExistingToFront('Where Used for Supplier', SupplierCode) then
    begin
      Screen.cursor := crHourGlass;
      Failed := false;
      try
        fmSupplierWhereUsed := TfmSupplierWhereUsed.create(fmSumms);
      except
        fmMemoryError.TidyUp(self);
        Failed := true;
      end;

      if not Failed then
        fmSupplierWhereUsed.PassSupplierName(SupplierCode);
     end;
  end;
end;

procedure TfmSupplierDetails.btnPrintClick(Sender: TObject);
begin
  BusyPrinting := true;
  screen.cursor := crHourGlass;

  if ItemGone(tblSuppliers, SupplierCode) then
    Close
  else
  begin
    frSupplier.ReportOptions.Name := 'Preview ' + Caption;
    ClosePreviewForm(Caption);

    btnPrint.Enabled := False;
    btnPrintPreview.Enabled := False;

    tblSuppliers.DisableControls;

    frSupplier.PrintOptions.PrintMode := pmScale;
    frSupplier.PrintOptions.PrintOnSheet := GetPaperSize;
    frSupplier.PrepareReport;
    frSupplier.PrintOptions.ShowDialog := not GroupPrinting;
    if ((Sender as TSpeedButton) = btnPrintPreview) then
    begin
      with frSupplier do
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
      PrintingCancelled := not frSupplier.Print;

    tblSuppliers.EnableControls;

    btnPrint.Enabled := True;
    btnPrintPreview.Enabled := True;
  end;

  screen.cursor := crDefault;
  BusyPrinting := false;
end;

procedure TfmSupplierDetails.btnEditClick(Sender: TObject);
var
   LockSuccess : boolean;

begin
  if ItemGone(tblSuppliers, SupplierCode) then
    Close
  else if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    LocalConnectionSumms.StartTransaction;

    //Attempt Lock
    LockSuccess := LockSingle(oSupplier, fmSumms.tblLocks, tblSuppliers, SupplierCode, True);

    if LockSuccess then
      UpdateScreen(True)
    else
      LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmSupplierDetails.UpdateScreen(Editing : boolean);
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
  btnWhereUsed.enabled := not Editing;

  pnlView1.visible := not Editing;

  SetTabStops(Editing);

  if Editing then
    dbeDescription.setfocus
  else
    tbMain.setfocus;
end;

procedure TfmSupplierDetails.btnSaveClick(Sender: TObject);
begin
  if not fmSumms.CheckDongle(FAST_PRESENCE_CHECK) then
  begin
    tblSuppliers.post;
    LocalConnectionSumms.commit;
    UpdateScreen(False);
  end;
end;

procedure TfmSupplierDetails.btnCancelClick(Sender: TObject);
begin
  LocalConnectionSumms.Rollback;

  //Release lock
  tblSuppliers.cancel;

  UpdateScreen(False);
end;

procedure TfmSupplierDetails.btnRefreshClick(Sender: TObject);
begin
  if ItemGone(tblSuppliers, SupplierCode) then
    Close
end;

procedure TfmSupplierDetails.LocalConnectionSummsAfterConnect(Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmSupplierDetails.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmSupplierDetails.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  BusyPrinting := false;

  if GroupPrinting then
  begin
    Enabled := False;
    Position := poMainFormCenter;
  end;

  SetTabStops(False);
end;

procedure TfmSupplierDetails.frSupplierBeforePrint(Sender: TfrxReportComponent);
begin
  frSupplier.PreviewOptions.AllowEdit := False;
  frSupplier.PreviewOptions.Buttons := frSupplier.PreviewOptions.Buttons - [pbEdit, pbOutline, pbFind];
  frSupplier.PreviewOptions.Maximized := fmSumms.mmPrintPreviewMax.checked;
  if fmSumms.mmPrintPreview100.checked then
    frSupplier.PreviewOptions.ZoomMode := zmDefault
  else
    frSupplier.PreviewOptions.ZoomMode := zmWholePage;
end;

procedure TfmSupplierDetails.frSupplierGetValue(const VarName: string;
  var Value: Variant);
begin
  if (VarName = 'Company') then
    Value := Company
  else if (VarName = 'ReportTitle') then
    Value := 'Supplier : ' + tblSuppliersCode.value;
end;

procedure TfmSupplierDetails.SetTabStops(Editing: Boolean);
begin
  dbeDescription.TabStop := Editing;
  dbeContact.TabStop := Editing;
  dbeAddress1.TabStop := Editing;
  dbeAddress2.TabStop := Editing;
  dbeAddress3.TabStop := Editing;
  dbeAddress4.TabStop := Editing;
  dbePhone.TabStop := Editing;
end;

end.
