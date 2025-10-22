unit OpenSizeRange;

interface

uses
  Classes, Forms, Controls, StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin, SysUtils;

type
  TfmOpenSizeRange = class(TForm)
    eOpenSizeRangeRange: TEdit;
    tbMain: TPanel;
    btnOpen: TSpeedButton;
    btnCancel: TSpeedButton;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure eOpenSizeRangeRangeKeyDown(Sender: TObject; var Key: Word;
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
  fmOpenSizeRange: TfmOpenSizeRange;

implementation

uses
  Windows, Summs, General, SizeRangeDetails, OutOfMemory, SummsVars;

{$R *.DFM}

procedure TfmOpenSizeRange.btnOpenClick(Sender: TObject);
var
  fmSizeRangeDetails: TfmSizeRangeDetails;
  Code : string;
  Failed : boolean;

begin
  Code := eOpenSizeRangeRange.text;

  if Code = '' then
    abort;  

  if not ExistingTofront('Size Range', Code) then
  begin
    Screen.cursor := crHourGlass;
    Failed := false;
    try
      fmSizeRangeDetails := TfmSizeRangeDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmSizeRangeDetails.PassSizeRangeName(fmSizeRangeDetails, Code);
  end;

  Close;
end;

procedure TfmOpenSizeRange.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmOpenSizeRange.FormActivate(Sender: TObject);
begin
  eOpenSizeRangerange.Text := '';
  eOpenSizeRangeRange.SetFocus
end;

procedure TfmOpenSizeRange.eOpenSizeRangeRangeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOpen.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmOpenSizeRange.FormShow(Sender: TObject);
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

procedure TfmOpenSizeRange.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
