unit NewSizeScale;

interface

uses
  Classes, Controls, Forms, StdCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls, ToolWin;

type
  TfmNewSizeScale = class(TForm)
    eNewSizeScaleCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qSizeScales: TFDQueryPlus;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eNewSizeScaleCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNewSizeScale: TfmNewSizeScale;

implementation

uses
  Windows, SysUtils, Dialogs,Summs, SizeScaleDetails, OutOfMemory,
  AdvErrorHandler, SummsVars, General;

{$R *.DFM}

procedure TfmNewSizeScale.btnSaveClick(Sender: TObject);
var
  fmSizeScaleDetails: TfmSizeScaleDetails;
  Code : string;
  Failed, SizeScaleCreated : boolean;

begin
  Code := eNewSizeScaleCode.Text;
  if Code = '' then
    abort;

  qSizeScales.Params[0].AsString := Code;

  SizeScaleCreated := True;
  try
    qSizeScales.ExecSQL;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('SizeScale already exists', E.Message, qSizeScales.Text);
      SizeScaleCreated := False;
    end;
  end;

  if not SizeScaleCreated then
  begin
    eNewSizeScaleCode.SetFocus;
    eNewSizeScaleCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmSizeScaleDetails := TfmSizeScaleDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
    begin
      fmSizeScaleDetails.PassSizeScaleName(fmSizeScaleDetails, Code);
      if fmSumms.mmAutoEdit.Checked then
        fmSizeScaleDetails.btnEdit.Click;
    end;

    Close;
  end;
end;

procedure TfmNewSizeScale.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewSizeScale.FormActivate(Sender: TObject);
begin
  eNewSizeScaleCode.text := '';
  eNewSizeScaleCode.SetFocus;
  eNewSizeScaleCode.SelectAll;
end;

procedure TfmNewSizeScale.eNewSizeScaleCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmNewSizeScale.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);
//
//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);
end;

procedure TfmNewSizeScale.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
