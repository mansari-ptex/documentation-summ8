unit OpenSupplier;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin, SysUtils;

type
  TfmOpenSupplier = class(TForm)
    tbMain: TPanel;
    btnOpen: TSpeedButton;
    btnCancel: TSpeedButton;
    eOpenSupplierCode: TEdit;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure eOpenSupplierCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOpenSupplier: TfmOpenSupplier;

implementation

uses
  Windows, Summs, SupplierDetails, OutofMemory, General, SummsVars;

{$R *.DFM}

procedure TfmOpenSupplier.btnOpenClick(Sender: TObject);

var
  Code : string;
  Failed:boolean;

begin
  Code := eOpenSupplierCode.text;

  if Code = '' then
    abort;  

  if not ExistingToFront('Supplier', Code) then
  begin
    Screen.cursor := crHourGlass;
    Failed := false;
    try
      fmSupplierDetails := TfmSupplierDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmSupplierDetails.PassSupplierName(Code)
  end;

  Close;
end;

procedure TfmOpenSupplier.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmOpenSupplier.FormActivate(Sender: TObject);
begin
  eOpenSupplierCode.Text := '';
  eOpenSupplierCode.SetFocus;
end;

procedure TfmOpenSupplier.eOpenSupplierCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOpen.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmOpenSupplier.FormShow(Sender: TObject);
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

procedure TfmOpenSupplier.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
