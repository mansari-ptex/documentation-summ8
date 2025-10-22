unit OpenMaterial;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, ToolWin, ComCtrls, SysUtils;

type
  TfmOpenMaterial = class(TForm)
    eOpenMaterialCode: TEdit;
    tbMain: TPanel;
    btnOpen: TSpeedButton;
    btnCancel: TSpeedButton;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure eOpenMaterialCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOpenMaterial: TfmOpenMaterial;

implementation

uses
  Windows, General, Summs, MaterialDetails, OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmOpenMaterial.btnOpenClick(Sender: TObject);

var
  Code : string;
  Failed : boolean;
  fmMaterialDetails : TfmMaterialDetails;

begin
  Code := eOpenMaterialCode.text;

  if Code = '' then
    abort;

  if not ExistingToFront('Material', Code) then
  begin
    Screen.cursor := crHourGlass;
    Failed := false;
    try
      fmMaterialDetails := TfmMaterialDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmMaterialDetails.PassMaterialName(fmMaterialDetails, Code);
  end;

  Close;
end;

procedure TfmOpenMaterial.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmOpenMaterial.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  eOpenMaterialCode.SetFocus
end;

procedure TfmOpenMaterial.FormActivate(Sender: TObject);
begin
  eOpenMaterialCode.Text := '';
  eOpenMaterialCode.SetFocus;
end;

procedure TfmOpenMaterial.eOpenMaterialCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOpen.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmOpenMaterial.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
