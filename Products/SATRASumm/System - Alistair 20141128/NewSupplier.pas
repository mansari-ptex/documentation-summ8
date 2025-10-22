unit NewSupplier;

interface

uses
  Classes, Controls, Forms, StdCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls, ToolWin;

type
  TfmNewSupplier = class(TForm)
    eNewSupplierCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qSuppliers: TFDQueryPlus;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eNewSupplierCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNewSupplier: TfmNewSupplier;

implementation

uses
  Windows, SysUtils, Dialogs, Summs, SupplierDetails, OutOfMemory,
  AdvErrorHandler, SummsVars, General;

{$R *.DFM}

procedure TfmNewSupplier.btnSaveClick(Sender: TObject);

var
  Code : string;
  Failed, SupplierCreated : boolean;

begin
  Code := eNewSupplierCode.Text;
  if Code = '' then
    abort;

  qSuppliers.Params[0].AsString := Code;

  SupplierCreated := True;
  try
    qSuppliers.ExecSQL;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('Supplier already exists', E.Message, qSuppliers.Text);
      SupplierCreated := False;
    end;
  end;

  if not SupplierCreated then
  begin
    eNewSupplierCode.SetFocus;
    eNewSupplierCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmSupplierDetails := TfmSupplierDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
    begin
      fmSupplierDetails.PassSupplierName(Code);
      if fmSumms.mmAutoEdit.Checked then
        fmSupplierDetails.btnEdit.Click;
    end;

    Close;
  end;
end;

procedure TfmNewSupplier.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewSupplier.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  eNewSupplierCode.SetFocus;
end;

procedure TfmNewSupplier.FormActivate(Sender: TObject);
begin
  eNewSupplierCode.text := '';
  eNewSupplierCode.SetFocus;  
end;

procedure TfmNewSupplier.eNewSupplierCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmNewSupplier.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
