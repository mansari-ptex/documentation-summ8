unit NewConstruction;

interface

uses
  Classes, Controls, Forms, StdCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls, Db, ToolWin;

type
  TfmNewConstruction = class(TForm)
    eNewConstructionCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qConstructions: TFDQueryPlus;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eNewConstructionCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNewConstruction: TfmNewConstruction;

implementation

uses
  Windows, SysUtils, Dialogs, Summs, ConstructionDetails, OutOfMemory,
  AdvErrorHandler, SummsVars, General;

{$R *.DFM}

procedure TfmNewConstruction.btnSaveClick(Sender: TObject);
var
  fmConstructionDetails: TfmConstructionDetails;
  Code : string;
  Failed, ConstructionCreated : boolean;

begin
  Code := eNewConstructionCode.Text;
  if Code = '' then
    abort;

  qConstructions.Params[0].AsString := Code;

  ConstructionCreated := True;
  try
    qConstructions.ExecSQL;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('Construction already exists', E.Message, qConstructions.Text);
      ConstructionCreated := False;
    end;
  end;

  if not ConstructionCreated then
  begin
    eNewConstructionCode.SetFocus;
    eNewConstructionCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmConstructionDetails := TfmConstructionDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
    begin
      fmConstructionDetails.PassConstructionName(fmConstructionDetails, Code);
      if fmSumms.mmAutoEdit.Checked then
        fmConstructionDetails.btnEdit.Click;
    end;

    Close;
  end;
end;

procedure TfmNewConstruction.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewConstruction.FormActivate(Sender: TObject);
begin
  eNewConstructionCode.Text := '';
  eNewConstructionCode.SetFocus;
end;

procedure TfmNewConstruction.eNewConstructionCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmNewConstruction.FormShow(Sender: TObject);
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

procedure TfmNewConstruction.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
