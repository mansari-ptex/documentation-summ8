unit OpenWidthRange;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin, SysUtils;

type
  TfmOpenWidthRange = class(TForm)
    eOpenWidthRangeCode: TEdit;
    tbMain: TPanel;
    btnOpen: TSpeedButton;
    btnCancel: TSpeedButton;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure eOpenWidthRangeCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOpenWidthRange: TfmOpenWidthRange;

implementation

uses
  Windows, WidthDetails, Summs, OutOfMemory, General, SummsVars;

{$R *.DFM}

procedure TfmOpenWidthRange.btnOpenClick(Sender: TObject);

var
  Code:string;
  Failed:boolean;

begin
  Code := eOpenWidthRangeCode.text;

  if Code = '' then
    abort;  

  if not ExistingToFront('Width Range', Code) then
  begin
    Screen.cursor := crHourGlass;
    Failed := false;
    try
      fmWidthDetails := TfmWidthDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmWidthDetails.PassWidthRangeName(Code);
  end;

  Close;
end;

procedure TfmOpenWidthRange.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmOpenWidthRange.FormActivate(Sender: TObject);
begin
  eopenWidthRangecode.Text := '';
  eOpenWidthRangeCode.SetFocus;
end;

procedure TfmOpenWidthRange.eOpenWidthRangeCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOpen.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmOpenWidthRange.FormShow(Sender: TObject);
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

procedure TfmOpenWidthRange.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
