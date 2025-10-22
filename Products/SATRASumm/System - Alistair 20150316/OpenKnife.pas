unit OpenKnife;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, ToolWin, ComCtrls, SysUtils;

type
  TfmOpenKnife = class(TForm)
    eOpenKnifeCode: TEdit;
    tbMain: TPanel;
    btnOpen: TSpeedButton;
    btnCancel: TSpeedButton;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure eOpenKnifeCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOpenKnife: TfmOpenKnife;

implementation

uses
  Windows, General, KnifeSetDetails, Summs, OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmOpenKnife.btnOpenClick(Sender: TObject);

var
  Code: string;
  Failed: boolean;
  fmKnifeSetDetails: TfmKnifeSetDetails;

begin
  Code := eOpenKnifeCode.text;

  if Code = '' then
    abort;

  if not ExistingToFront('Knife', Code) then
  begin
    Screen.cursor := crHourGlass;
    Failed := false;
    try
      fmKnifeSetDetails := TfmKnifeSetDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmKnifeSetDetails.PassKnifeName(fmKnifeSetDetails, Code);
  end;

  Close;
end;

procedure TfmOpenKnife.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmOpenKnife.FormActivate(Sender: TObject);
begin
  eOpenKnifeCode.Text := '';
  eOpenKnifeCode.SetFocus;
end;

procedure TfmOpenKnife.eOpenKnifeCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOpen.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmOpenKnife.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);
end;

procedure TfmOpenKnife.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
