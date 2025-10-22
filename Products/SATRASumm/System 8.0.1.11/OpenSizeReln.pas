unit OpenSizeReln;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  ToolWin, SysUtils;

type
  TfmOpenSizeRelationship = class(TForm)
    eOpenSizeRelationshipCode: TEdit;
    tbMain: TPanel;
    btnOpen: TSpeedButton;
    btnCancel: TSpeedButton;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure eOpenSizeRelationshipCodeKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure btnOpenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmOpenSizeRelationship: TfmOpenSizeRelationship;

implementation

uses
  Windows, Summs, SizeRelationshipDetails, OutOfMemory, General, SummsVars;

{$R *.DFM}

procedure TfmOpenSizeRelationship.btnOpenClick(Sender: TObject);
var
  fmSizeRelationshipDetails: TfmSizeRelationshipDetails;
  code : string;
  Failed : boolean;

begin
  Code := eOpenSizeRelationshipCode.text;

  if Code = '' then
    abort;  

  if not ExistingToFront('Size Relationship', Code) then
  begin
    Screen.cursor := crHourGlass;
    Failed := false;
    try
      fmSizeRelationshipDetails := TfmSizeRelationshipDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmSizeRelationshipDetails.PassSizeRelationshipName(fmSizeRelationshipDetails, Code);
  end;

  Close;
end;

procedure TfmOpenSizeRelationship.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmOpenSizeRelationship.FormActivate(Sender: TObject);
begin
  eOpenSizeRelationshipCode.Text := '';
  eOpenSizeRelationshipCode.SetFocus;
end;

procedure TfmOpenSizeRelationship.eOpenSizeRelationshipCodeKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnOpen.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmOpenSizeRelationship.FormShow(Sender: TObject);
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

procedure TfmOpenSizeRelationship.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
