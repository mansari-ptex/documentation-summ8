unit OpenPart;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin,
  SysUtils;

type
  TfmOpenPart = class(TForm)
    eOpenPartCode: TEdit;
    tbMain: TPanel;
    btnOpen: TSpeedButton;
    btnCancel: TSpeedButton;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure eOpenPartCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOpenPart: TfmOpenPart;

implementation

uses
  Windows, General, PartDetails, Summs, OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmOpenPart.btnOpenClick(Sender: TObject);
var
  fmPartDetails : TfmPartDetails; 
  Code : string;
  Failed:boolean;

begin
  Code := eOpenPartCode.text;

  if Code = '' then
    abort;

  if not ExistingToFront('Part', Code) then
  begin
    Screen.cursor := crHourGlass;
    Failed := false;
    try
      fmPartDetails := TfmPartDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmPartDetails.PassPartName(fmPartDetails, Code);
  end;

  Close;
end;

procedure TfmOpenPart.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmOpenPart.FormActivate(Sender: TObject);
begin
  eOpenPartCode.Text := '';
  eOpenPartCode.SetFocus;
end;

procedure TfmOpenPart.eOpenPartCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOpen.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmOpenPart.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);
end;

procedure TfmOpenPart.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
