unit CopyMaterial;

interface

uses
  Classes, Controls, Forms, StdCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls,  Db, ToolWin, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FDConnectionPlus;

type
  TfmCopyMaterial = class(TForm)
    eNewMaterialCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qMaterials: TFDQueryPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eNewMaterialCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BaseCode : string;
  end;

var
  fmCopyMaterial : TfmCopyMaterial;

implementation

uses
  Windows, SysUtils, Dialogs, General, Summs, MaterialDetails, OutOfMemory,
  AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmCopyMaterial.btnSaveClick(Sender: TObject);

var
  Code : string;
  Failed, MaterialCreated : boolean;
  fmMaterialDetails : TfmMaterialDetails;

begin
  Code := eNewMaterialCode.Text;
  if Code = '' then
    abort;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  LocalConnectionSumms.StartTransaction;

  qMaterials.SQL.Text := 'INSERT INTO Material (Code, Description, Type, CutType, Units, StandardPrice, DegDiff, ' +
                         'QualCoeff, AreaCoeff, Length, Width, SkinSize, Trimmed, Layers, StrokeDepth, Notes, ' +
                         'CutGap, LinearMatPrice, LinearAllowance) SELECT ''' + QS(Code) +
                         ''', Description, Type, CutType, Units, StandardPrice, DegDiff, QualCoeff, ' +
                         'AreaCoeff, Length, Width, SkinSize, Trimmed, Layers, StrokeDepth, Notes, CutGap, ' +
                         'LinearMatPrice, LinearAllowance FROM Material ' +
                         'WHERE Code = ''' + QS(BaseCode) + ''';' + #13 +
                         'INSERT INTO MatSupl (Material, Supplier, Price) SELECT ''' + QS(Code) + ''', Supplier, Price ' +
                         'FROM MatSupl WHERE Material = ''' + QS(BaseCode) + ''';';

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
    LocalConnectionSumms.Rollback;
    eNewMaterialCode.SetFocus;
    eNewMaterialCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;

    LocalConnectionSumms.Commit;

    Failed := False;
    try
      fmMaterialDetails := TfmMaterialDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmMaterialDetails.PassMaterialName(fmMaterialDetails, Code);

    Close;
  end;
end;

procedure TfmCopyMaterial.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmCopyMaterial.FormActivate(Sender: TObject);
begin
  eNewMaterialCode.text := '';
  eNewMaterialCode.setfocus;
end;

procedure TfmCopyMaterial.eNewMaterialCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmCopyMaterial.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);
end;

procedure TfmCopyMaterial.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmCopyMaterial.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
