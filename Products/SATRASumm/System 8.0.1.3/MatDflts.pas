unit MatDflts;

interface

uses
  Classes, Controls, Forms, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,  DBCtrls,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, ToolWin, CmnVars, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FDConnectionPlus;

type
  TfmMaterialDefaults = class(TForm)
    tblMaterialDefaults: TFDTablePlus;
    dsMaterialDefaults: TDataSource;
    LocalConnectionSumms: TFDConnectionPlus;
    tbMain: TPanel;
    btnEdit: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnRefresh: TSpeedButton;
    pnlTop: TPanel;
    tblMaterialDefaultsType: TStringField;
    tblMaterialDefaultsCutType: TStringField;
    tblMaterialDefaultsUnits: TStringField;
    lblMatTypes: TLabel;
    cbType: TDBComboBox;
    lblCutType: TLabel;
    cbCutType: TDBComboBox;
    lblMatUnits: TLabel;
    cbUnits: TDBComboBox;
    pnlView1: TPanel;
    lblUnitsType: TLabel;
    lblMaterialType: TLabel;
    lblCuttingType: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEditClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure UpdateScreen(Editing : boolean);
    procedure tblMaterialDefaultsAfterOpen(DataSet: TDataSet);
    procedure AllTypes;
    procedure cbTypeChange(Sender: TObject);
    procedure cbCutTypeChange(Sender: TObject);
    procedure cbUnitsChange(Sender: TObject);
    procedure LoadUnitsDropDown;
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure Pass;
    procedure SetTabStops(Editing: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure LoadTypesDropDown;
    procedure LoadCutTypesDropDown;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMaterialDefaults: TfmMaterialDefaults;

implementation

uses
  Graphics, Dialogs, General, Summs, SummsVars;

{$R *.DFM}

procedure TfmMaterialDefaults.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if tblMaterialDefaults.state in [dsEdit, dsInsert] then
  begin
    if MessageDlgPos('Save Changes to Material Defaults?', mtConfirmation, [mbYes, mbNo], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top)) = mrYes then
      btnSave.click
    else
      btnCancel.click;
  end;

  action := caFree;
end;

procedure TfmMaterialDefaults.btnEditClick(Sender: TObject);
var
  LockSuccess : boolean;

begin
  LocalConnectionSumms.StartTransaction;

  //Attempt Lock
  LockSuccess := LockSingleOption(oMaterialDefaults, tblMaterialDefaults);

  if LockSuccess then
    UpdateScreen(True)
  else
    LocalConnectionSumms.Rollback;
end;

procedure TfmMaterialDefaults.btnSaveClick(Sender: TObject);
var
  s: string;
  Leather, Invalid: Boolean;

begin
  s := cbType.Text;
  Leather := (s[1] in ['L', 'W', 'K']);

  Invalid := False;
  if Leather and (cbCutType.Text = 'E') then
    Invalid := True;
  if (not Leather) and ((cbCutType.Text = 'S') or (cbCutType.Text = 'M')) then
    Invalid := True;

  if Invalid then
    MessageDlgPos('Invalid Type and Cut Type combination', mtError, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else
  begin
    tblMaterialDefaults.post;
    LocalConnectionSumms.commit;

    //Opening sets all Parameters
    try
      fmSumms.qParameters.open;
      fmSumms.qParameters.close;
    except
    end;

    UpdateScreen(False);
  end;
end;

procedure TfmMaterialDefaults.btnCancelClick(Sender: TObject);
begin
  LocalConnectionSumms.Rollback;

  //Release lock
  tblMaterialDefaults.cancel;

  UpdateScreen(False);
end;

procedure TfmMaterialDefaults.btnRefreshClick(Sender: TObject);
begin
  tblMaterialDefaults.refresh;
end;

procedure TfmMaterialDefaults.UpdateScreen(Editing : boolean);
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

  SetTabStops(Editing);

  AllTypes;

  if Editing then
    cbType.setfocus
  else
    tbMain.setfocus;
end;

procedure TfmMaterialDefaults.tblMaterialDefaultsAfterOpen(DataSet: TDataSet);
begin
  cbUnits.DataField := '';
  cbUnits.Items.Add(tblMaterialDefaultsUnits.value);
  cbUnits.DataField := 'Units';

  AllTypes;
  LoadUnitsDropDown;

  tbMain.enabled := True;
end;

procedure TfmMaterialDefaults.AllTypes;
var
   MaterialType : string;
   CuttingType : string;

begin
  MaterialType := cbType.text;

  if MaterialType = 'L' then
    lblMaterialType.caption := 'Leather'
  else if MaterialType = 'W' then
    lblMaterialType.caption := 'Wool'
  else if MaterialType = 'K' then
    lblMaterialType.caption := 'Kip'
  else if MaterialType = 'R' then
    lblMaterialType.caption := 'Roll'
  else if MaterialType = 'S' then
    lblMaterialType.caption := 'Sheet';

  CuttingType := cbCutType.text;

  if CuttingType = 'E' then
    lblCuttingType.caption := 'Exhaustive'
  else if CuttingType = 'M' then
    lblCuttingType.caption := 'Match Marked'
  else if CuttingType = 'R' then
    lblCuttingType.caption := 'Restrictive'
  else if CuttingType = 'S' then
    lblCuttingType.caption := 'Selective';

  fmSumms.qMaterialUnits.findkey([cbUnits.text]);
  lblUnitsType.caption := fmSumms.qMaterialUnitsUnitDescription.value;
end;

procedure TfmMaterialDefaults.cbTypeChange(Sender: TObject);
begin
  AllTypes;
end;

procedure TfmMaterialDefaults.cbCutTypeChange(Sender: TObject);
begin
  AllTypes;
end;

procedure TfmMaterialDefaults.cbUnitsChange(Sender: TObject);
begin
  AllTypes;
end;

procedure TfmMaterialDefaults.LoadUnitsDropDown;
begin
  cbUnits.DataField := '';
  cbUnits.Items.Clear;
  fmSumms.qMaterialUnits.RecNo := 1; //CJY changed from qMaterialUnits.First
  fmSumms.qMaterialUnits.Prior; //CJY changed from qMaterialUnits.First
  while not fmSumms.qMaterialUnits.eof do
  begin
    cbUnits.Items.Add(fmSumms.qMaterialUnitsCode.value);

    fmSumms.qMaterialUnits.next;
  end;
  cbUnits.DataField := 'Units';
end;

procedure TfmMaterialDefaults.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmMaterialDefaults.Pass;
begin
  tblMaterialDefaults.open;
end;

procedure TfmMaterialDefaults.SetTabStops(Editing: Boolean);
begin
  cbType.TabStop := Editing;
  cbCutType.TabStop := Editing;
  cbUnits.TabStop := Editing;
end;

procedure TfmMaterialDefaults.FormCreate(Sender: TObject);
begin
  AutoColor(Self);

  SetTabStops(False);

  LoadTypesDropDown;
  LoadCutTypesDropDown;
end;

procedure TfmMaterialDefaults.LoadTypesDropDown;
begin
  cbType.DataField := '';
  cbType.Items.Clear;

  if Option_Leather then
  begin
    cbType.Items.Add('L');
    cbType.Items.Add('W');
    cbType.Items.Add('K');
  end;
  if Option_Synthetics then
  begin
    cbType.Items.Add('R');
    cbType.Items.Add('S');
  end;

  cbType.DataField := 'Type';
end;

procedure TfmMaterialDefaults.LoadCutTypesDropDown;
begin
  cbCutType.DataField := '';
  cbCutType.Items.Clear;

  if Option_Synthetics then
    cbCutType.Items.Add('E');
  if Option_Leather then
    cbCutType.Items.Add('M');
  cbCutType.Items.Add('R');
  if Option_Leather then
    cbCutType.Items.Add('S');

  cbCutType.DataField := 'CutType';
end;

end.
