unit OpenConstruction;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, ToolWin, ComCtrls, SysUtils;

type
  TfmOpenConstruction = class(TForm)
    eOpenConstructionCode: TEdit;
    tbMain: TPanel;
    btnOpen: TSpeedButton;
    btnCancel: TSpeedButton;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure eOpenConstructionCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOpenConstruction: TfmOpenConstruction;

implementation

uses
  Windows, General, ConstructionDetails, Summs, OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmOpenConstruction.btnOpenClick(Sender: TObject);
var
  fmConstructionDetails: TfmConstructionDetails;
  Code : string;
  Failed:boolean;

begin
  Code := eOpenConstructionCode.text;

  if Code = '' then
    abort;

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

  Close;
end;

procedure TfmOpenConstruction.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmOpenConstruction.FormActivate(Sender: TObject);
begin
  eOpenConstructionCode.Text := '';
  eOpenConstructionCode.SetFocus
end;

procedure TfmOpenConstruction.eOpenConstructionCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOpen.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmOpenConstruction.FormShow(Sender: TObject);
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

procedure TfmOpenConstruction.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
