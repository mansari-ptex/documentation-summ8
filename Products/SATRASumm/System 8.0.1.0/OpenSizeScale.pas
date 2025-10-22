unit OpenSizeScale;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  ToolWin, SysUtils;

type
  TfmOpenSizeScale = class(TForm)
    eOpenSizeScaleCode: TEdit;
    tbMain: TPanel;
    btnOpen: TSpeedButton;
    btnCancel: TSpeedButton;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure eOpenSizeScaleCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOpenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOpenSizeScale: TfmOpenSizeScale;

implementation

uses
  Windows, Summs, SizeScaleDetails, OutOfMemory, General, SummsVars;

{$R *.DFM}

procedure TfmOpenSizeScale.btnOpenClick(Sender: TObject);
var
  fmSizeScaleDetails: TfmSizeScaleDetails;
  Code : string;
  Failed: Boolean;

begin
  Code := eOpenSizeScaleCode.text;

  if Code = '' then
    abort;
      
  if not ExistingToFront('Size Scale', Code) then
  begin
    Screen.cursor := crHourGlass;
    Failed := false;
    try
      fmSizeScaleDetails := TfmSizeScaleDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;
    if not Failed then
      fmSizeScaleDetails.PassSizeScaleName(fmSizeScaleDetails, Code);    
  end;

  Close;
end;

procedure TfmOpenSizeScale.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmOpenSizeScale.FormActivate(Sender: TObject);
begin
  eopenSizeScaleCode.Text := '';
  eOpenSizeScaleCode.SetFocus;
end;

procedure TfmOpenSizeScale.eOpenSizeScaleCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOpen.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmOpenSizeScale.FormShow(Sender: TObject);
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

procedure TfmOpenSizeScale.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
