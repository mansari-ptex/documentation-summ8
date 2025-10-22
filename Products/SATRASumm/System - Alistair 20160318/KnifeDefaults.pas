unit KnifeDefaults;

interface

uses
  Forms, Dialogs, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DBCtrls, StdCtrls, ExtCtrls,
  Buttons, ComCtrls,  Mask, Controls, Classes, ToolWin, General,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FDConnectionPlus;

type
  TfmKnifeDefaults = class(TForm)
    tblKnifeDefaults: TFDTablePlus;
    dsKnifeDefaults: TDataSource;
    LocalConnectionSumms: TFDConnectionPlus;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnRefresh: TSpeedButton;
    pnlTop: TPanel;
    lblPieces: TLabel;
    lblMatCats: TLabel;
    lblCutGap: TLabel;
    dbePieces: TDBEdit;
    dbcbCutGap: TDBComboBox;
    tblKnifeDefaultsType: TStringField;
    tblKnifeDefaultsCutGap: TSmallintField;
    tblKnifeDefaultsPieces: TSmallintField;
    tblKnifeDefaultsDoubleSided: TBooleanField;
    tblKnifeDefaultsThin: TBooleanField;
    tblKnifeDefaultsPunches: TSmallintField;
    tblKnifeDefaultsBands: TFloatField;
    tblKnifeDefaultsMarks: TFloatField;
    tblKnifeDefaultsClears: TSmallintField;
    qMatCats: TFDQueryPlus;
    qMatCatsCode: TStringField;
    dsMatCats: TDataSource;
    cbMatCat: TDBComboBox;
    tblKnifeDefaultsMaterialType: TStringField;
    pnlView1: TPanel;
    dbtMaterialCat: TDBText;
    dbtCutGap: TDBText;
    dbtPieces: TDBText;
    tblKnifeDefaultsCutsLRYesNo: TStringField;
    tblKnifeDefaultsThinsYesNo: TStringField;
    pnlCuttingTimes: TPanel;
    dbcbDoubleSidedQ: TDBCheckBox;
    dbcbThinQ: TDBCheckBox;
    lblPunches: TLabel;
    lblBands: TLabel;
    lblMarks: TLabel;
    lblClears: TLabel;
    pnlView3: TPanel;
    dbtBands: TDBText;
    dbtMarks: TDBText;
    dbtClears: TDBText;
    dbtCutsLRYesNo: TDBText;
    dbtThinYesNo: TDBText;
    dbtPunches: TDBText;
    dbePunches: TDBEdit;
    dbeBands: TDBEdit;
    dbeMarks: TDBEdit;
    dbeClears: TDBEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure UpdateScreen(Editing : boolean);
    procedure tblKnifeDefaultsAfterOpen(DataSet: TDataSet);
    procedure tblKnifeDefaultsCalcFields(DataSet: TDataSet);
    procedure cbMatCatDropDown(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure Pass;
    procedure SetTabStops(Editing: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmKnifeDefaults: TfmKnifeDefaults;

implementation

uses
  Summs, Graphics, Cmnvars, SummsVars, SizeScaleDetails, OutOfMemory;

{$R *.DFM}

procedure TfmKnifeDefaults.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if tblKnifeDefaults.state in [dsEdit, dsInsert] then
  begin
    if MessageDlgPos('Save Changes to Knife Defaults?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
      btnSave.click
    else
      btnCancel.click;
  end;

  action := caFree;
end;

procedure TfmKnifeDefaults.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  if not Option_CuttingTimes then
  begin
    lblClears.Enabled := false;
    lblPunches.Enabled := false;
    lblBands.Enabled := false;
    lblMarks.Enabled := false;

    dbcbDoubleSidedQ.Enabled := false;
    dbcbThinQ.Enabled := false;
    dbcbDoubleSidedQ.DataField := '';
    dbcbThinQ.DataField := '';

    dbeClears.Enabled := false;
    dbePunches.Enabled := false;
    dbeBands.Enabled := false;
    dbeMarks.Enabled := false;

    dbePunches.Color := clBack;
    dbeBands.Color := clBack;
    dbeMarks.Color := clBack;
    dbeClears.Color := clBack;

    dbePunches.DataField := '';
    dbeBands.DataField := '';
    dbeMarks.DataField := '';
    dbeClears.DataField := '';

    dbtCutsLRYesNo.Enabled := false;
    dbtThinYesNo.Enabled := false;
    dbtPunches.Enabled := false;
    dbtBands.Enabled := false;
    dbtMarks.Enabled := false;
    dbtClears.Enabled := false;

    dbtCutsLRYesNo.DataField := '';
    dbtThinYesNo.DataField := '';
    dbtPunches.DataField := '';
    dbtBands.DataField := '';
    dbtMarks.DataField := '';
    dbtClears.DataField := '';
  end;

  if not Option_LegacySynthetics then
  begin
    lblCutGap.Visible := false;
    dbcbCutgap.Visible := false;
    dbtCutgap.visible := false;
  end;

  SetTabStops(False);
end;

procedure TfmKnifeDefaults.btnEditClick(Sender: TObject);
var
  LockSuccess : boolean;

begin
  LocalConnectionSumms.StartTransaction;

  //Attempt Lock
  LockSuccess := LockSingleOption(oKnifeDefaults, tblKnifeDefaults);

  if LockSuccess then
    UpdateScreen(True)
  else
    LocalConnectionSumms.Rollback;
end;

procedure TfmKnifeDefaults.btnSaveClick(Sender: TObject);
begin
  tblKnifeDefaults.post;
  LocalConnectionSumms.commit;

  //Opening sets all Parameters
  try
    fmSumms.qParameters.open;
    fmSumms.qParameters.close;
  except
  end;

  UpdateScreen(False);
end;

procedure TfmKnifeDefaults.btnCancelClick(Sender: TObject);
begin
  LocalConnectionSumms.Rollback;

  //Release lock
  tblKnifeDefaults.cancel;

  UpdateScreen(False);
end;

procedure TfmKnifeDefaults.btnRefreshClick(Sender: TObject);
begin
  tblKnifeDefaults.refresh;
end;

procedure TfmKnifeDefaults.UpdateScreen(Editing : boolean);
begin
  if editing then
     tbMain.color := clEditing
  else
     tbMain.color := clBack;

  btnEdit.enabled := not Editing;
  btnSave.enabled := Editing;
  btnCancel.enabled := Editing;
  btnRefresh.enabled := not Editing;

  pnlView1.visible := not Editing;
  if Option_CuttingTimes then
    pnlView3.visible := not Editing;

  dbcbDoubleSidedQ.ReadOnly := not Editing;
  dbcbThinQ.ReadOnly := not Editing;

  SetTabStops(Editing);

  if Editing then
    cbMatCat.setfocus
  else
    tbMain.setfocus;
end;

procedure TfmKnifeDefaults.tblKnifeDefaultsAfterOpen(DataSet: TDataSet);
begin
  cbMatCat.DataField := '';
  cbMatCat.Items.Add(tblKnifeDefaultsType.value);
  cbMatCat.DataField := 'Type';

  tbMain.enabled := True;
end;

procedure TfmKnifeDefaults.tblKnifeDefaultsCalcFields(DataSet: TDataSet);
begin
  if tblKnifeDefaultsType.value = 'N' then
    tblKnifeDefaultsMaterialType.value := 'Non Prime'
  else if tblKnifeDefaultsType.value = 'P' then
    tblKnifeDefaultsMaterialType.value := 'Prime'
  else if tblKnifeDefaultsType.value = 'S' then
    tblKnifeDefaultsMaterialType.value := 'Synthetic';

  if tblKnifeDefaultsDoubleSided.value then
    tblKnifeDefaultsCutsLRYesNo.value := 'Yes'
  else
    tblKnifeDefaultsCutsLRYesNo.value := 'No';

  if tblKnifeDefaultsThin.value then
    tblKnifeDefaultsThinsYesNo.value := 'Yes'
  else
    tblKnifeDefaultsThinsYesNo.value := 'No';
end;

procedure TfmKnifeDefaults.cbMatCatDropDown(Sender: TObject);
var
  AddThisOne: Boolean;

begin
  screen.cursor := crHourGlass;

  if not qMatCats.active then
  begin
    qMatCats.open;

    //Load list box
    cbMatCat.DataField := '';
    cbMatCat.Items.Clear;
    qMatCats.RecNo := 1; //CJY changed from qMatCats.First
    qMatCats.Prior; //CJY changed from qMatCats.First
    while not qMatCats.eof do
    begin
      AddThisOne := True;

      if (not Option_Leather) and ((qMatCatsCode.value = 'P') or (qMatCatsCode.value = 'N')) then
        AddThisOne := False;
      if (not Option_Synthetics) and (qMatCatsCode.value = 'S') then
        AddThisOne := False;

      if AddThisOne then
        cbMatCat.Items.Add(qMatCatsCode.value);
      qMatCats.next;
    end;
    
    cbMatCat.DataField := 'Type';
  end;

  screen.cursor := crDefault;
end;

procedure TfmKnifeDefaults.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmKnifeDefaults.Pass;
begin
  tblKnifeDefaults.open;
end;

procedure TfmKnifeDefaults.SetTabStops(Editing: Boolean);
begin
  cbMatCat.TabStop := Editing;
  dbcbCutGap.TabStop := Editing;
  dbePieces.TabStop := Editing;
  dbePunches.TabStop := Editing;
  dbcbDoubleSidedQ.TabStop := Editing;
  dbcbThinQ.TabStop := Editing;
  dbeBands.TabStop := Editing;
  dbeMarks.TabStop := Editing;
  dbeClears.TabStop := Editing;
end;

end.

