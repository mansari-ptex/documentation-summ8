unit CopyWidthRange;

interface

uses
  Classes, Controls, Forms, StdCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls,  Db, ToolWin, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FDConnectionPlus;

type
  TfmCopyWidthRange = class(TForm)
    eNewWidthRangeCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qWidthRanges: TFDQueryPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eNewWidthRangeCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BaseCode : string;
  end;

var
  fmCopyWidthRange: TfmCopyWidthRange;

implementation

uses
  Windows, SysUtils, Dialogs, General, WidthDetails, Summs, OutOfMemory,
  AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmCopyWidthRange.btnSaveClick(Sender: TObject);

var
  Code : string;
  Failed, WidthRangeCreated : boolean;

begin
  Code := eNewWidthRangeCode.Text;
  if Code = '' then
    abort;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  LocalConnectionSumms.StartTransaction;

  qWidthRanges.SQL.Text := 'INSERT INTO WRngs (Code, Description, WidthNo) SELECT ''' + QS(Code) + ''', Description, WidthNo FROM WRngs ' +
                           'WHERE Code = ''' + QS(BaseCode) + ''';' + #13 +
                           'INSERT INTO WRngWs (Range, WidthNo) SELECT ''' + QS(Code) + ''', WidthNo FROM WRngWs ' +
                           'WHERE Range = ''' + QS(BaseCode) + ''';';

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
    LocalConnectionSumms.Rollback;
    eNewWidthRangeCode.SetFocus;
    eNewWidthRangeCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;

    LocalConnectionSumms.Commit;

    Failed := False;
    try
      fmWidthDetails := TfmWidthDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmWidthDetails.PassWidthRangeName(Code);

    Close;
  end;
end;

procedure TfmCopyWidthRange.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmCopyWidthRange.FormActivate(Sender: TObject);
begin
  eNewWidthRangeCode.Text := '';
  eNewWidthRangeCode.SetFocus;
end;

procedure TfmCopyWidthRange.eNewWidthRangeCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmCopyWidthRange.FormShow(Sender: TObject);
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

procedure TfmCopyWidthRange.LocalConnectionSummsAfterConnect(Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmCopyWidthRange.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmCopyWidthRange.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
