unit OpenStyle;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin, SysUtils;

type
  TfmOpenStyle = class(TForm)
    tbMain: TPanel;
    btnOpen: TSpeedButton;
    btnCancel: TSpeedButton;
    eOpenStyleCode: TEdit;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure eOpenStyleCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOpenStyle: TfmOpenStyle;

implementation

uses
  Windows, StyleDetails, Summs, OutOfMemory, General, SummsVars;

{$R *.DFM}

procedure TfmOpenStyle.btnOpenClick(Sender: TObject);
var
  Code : string;
  Failed : boolean;
  fmStyleDetails : TfmStyleDetails;

begin
  Code := eOpenStyleCode.text;

  if Code = '' then
    abort;

  if not ExistingToFront('Style', Code) then
  begin
    Screen.cursor := crHourGlass;
    Failed:=False;
    try
      fmStyleDetails := TfmStyleDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(Self);
      Failed := True
    end;

    if not Failed then
      fmStyleDetails.PassStyleName(fmStyleDetails, Code);
  end;

  Close;
end;

procedure TfmOpenStyle.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmOpenStyle.FormActivate(Sender: TObject);
begin
  eOpenStyleCode.Text := '';
  eOpenStyleCode.SetFocus;
end;

procedure TfmOpenStyle.eOpenStyleCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOpen.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmOpenStyle.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);
end;

procedure TfmOpenStyle.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
