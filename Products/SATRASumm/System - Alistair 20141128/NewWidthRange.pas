unit NewWidthRange;

interface

uses
  Classes, Controls, Forms, StdCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls, ToolWin;

type
  TfmNewWidthRange = class(TForm)
    eNewWidthRangeCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qWidthRanges: TFDQueryPlus;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eNewWidthRangeCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNewWidthRange: TfmNewWidthRange;

implementation

uses
  Windows, SysUtils, Dialogs, WidthDetails, Summs, OutOfMemory,
  AdvErrorHandler, SummsVars, General;

{$R *.DFM}

procedure TfmNewWidthRange.btnSaveClick(Sender: TObject);

var
  Code : string;
  Failed, WidthRangeCreated : boolean;

begin
  Code := eNewWidthRangeCode.Text;
  if Code = '' then
    abort;

  qWidthRanges.Params[0].AsString := Code;

  WidthRangeCreated := True;
  try
    qWidthRanges.ExecSQL;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('Width Range already exists', E.Message, qWidthRanges.Text);
      WidthRangeCreated := False;
    end;
  end;

  if not WidthRangeCreated then
  begin
    eNewWidthRangeCode.SetFocus;    
    eNewWidthRangeCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmWidthDetails := TfmWidthDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
    begin
      fmWidthDetails.PassWidthRangeName(Code);
      if fmSumms.mmAutoEdit.Checked then
        fmWidthDetails.btnEdit.Click;
    end;

    Close;
  end;
end;

procedure TfmNewWidthRange.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewWidthRange.FormActivate(Sender: TObject);
begin
  eNewWidthRangeCode.text := '';
  eNewWidthRangeCode.SetFocus;
end;

procedure TfmNewWidthRange.eNewWidthRangeCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmNewWidthRange.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);
end;

procedure TfmNewWidthRange.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
