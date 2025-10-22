unit NewMaterial;

interface

uses
  Classes, Controls, Forms, StdCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls, ToolWin, DBCtrls;

type
  TfmNewMaterial = class(TForm)
    eNewMaterialCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qMaterials: TFDQueryPlus;
    cbType: TComboBox;
    qMaterialDefaults: TFDQueryPlus;
    lblNewMaterialCode: TLabel;
    lblType: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eAnyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNewMaterial: TfmNewMaterial;

implementation

uses
  Windows, SysUtils, Graphics, Dialogs, Summs, MaterialDetails, OutOfMemory, SummsVars,
  AdvErrorHandler, General;

{$R *.DFM}

procedure TfmNewMaterial.btnSaveClick(Sender: TObject);

var
  Code, MaterialType: string;
  Failed, MaterialCreated: boolean;
  fmMaterialDetails: TfmMaterialDetails;

begin
  Code := eNewMaterialCode.Text;
  MaterialType := cbType.Text[1];
  if Code = '' then
    abort;

  qMaterials.Params[0].AsString := Code;
  qMaterials.Params[1].AsString := MaterialType;

  MaterialCreated := True;
  try
    qMaterials.ExecSQL;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('Material already exists', E.Message, qMaterials.Text);
      MaterialCreated := False;
    end;
  end;

  if not MaterialCreated then
  begin
    eNewMaterialCode.SetFocus;
    eNewMaterialCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmMaterialDetails := TfmMaterialDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
    begin
      fmMaterialDetails.PassMaterialName(fmMaterialDetails, Code);
      if fmSumms.mmAutoEdit.Checked then
        fmMaterialDetails.btnEdit.Click;
    end;

    Close;
  end;
end;

procedure TfmNewMaterial.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewMaterial.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  eNewMaterialCode.SetFocus;

  cbType.Items.Clear;
  if Option_Leather then
  begin
    cbType.Items.Add('Leather');
    cbType.Items.Add('Wool');
    cbType.Items.Add('Kip');
  end;
  if Option_Synthetics then
  begin
    cbType.Items.Add('Roll');
    cbType.Items.Add('Sheet');
  end;
end;

procedure TfmNewMaterial.FormActivate(Sender: TObject);
var
  MatType: string;
  MatTypeIndex: integer;

begin
  qMaterialDefaults.open;
  MatType := qMaterialDefaults.FieldByname('Type').value;
  qMaterialDefaults.close;

  if MatType = 'L' then
    MatTypeIndex := 0
  else if MatType = 'W' then
    MatTypeIndex := 1
  else if MatType = 'K' then
    MatTypeIndex := 2
  else if MatType = 'R' then
    MatTypeIndex := 3
  else if MatType = 'S' then
    MatTypeIndex := 4;

  eNewMaterialCode.Text := '';
  cbType.ItemIndex := MatTypeIndex;
end;

procedure TfmNewMaterial.eAnyKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmNewMaterial.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
