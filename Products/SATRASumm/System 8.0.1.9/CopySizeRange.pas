unit CopySizeRange;

interface

uses
  Classes, Controls, Forms, StdCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ToolWin, ComCtrls,  Db, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FDConnectionPlus;

type
  TfmCopySizeRange = class(TForm)
    eNewSizeRangeCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qSizeRanges: TFDQueryPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eNewSizeRangeCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BaseCode : string;
  end;

var
  fmCopySizeRange: TfmCopySizeRange;

implementation

uses
  Windows, SysUtils, Dialogs, General, Summs, SizeRangeDetails, OutOfMemory,
  AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmCopySizeRange.btnSaveClick(Sender: TObject);
var
  fmSizeRangeDetails: TfmSizeRangeDetails;
  Code : string;
  Failed, SizeRangeCreated : boolean;

begin
  Code := eNewSizeRangeCode.Text;
  if Code = '' then
    abort;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  LocalConnectionSumms.StartTransaction;

  qSizeRanges.SQL.Text := 'INSERT INTO SizeRanges (Scale, Range, Description, SampleSize, CostedSize) SELECT Scale, ''' +
                           QS(Code) + ''', Description, SampleSize, CostedSize FROM SizeRanges WHERE Range = ''' +
                           QS(BaseCode) + ''';' + #13 +
                          'INSERT INTO SizeRangeSizes (Scale, Range, Size, Seq) SELECT Scale, ''' + QS(Code) +
                          ''', Size, Seq FROM SizeRangeSizes WHERE Range = ''' + QS(BaseCode) + ''';';

  SizeRangeCreated := True;
  try
    qSizeRanges.ExecSQL;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('Size Range already exists', E.Message, qSizeRanges.Text);
      SizeRangeCreated := False;
    end;
  end;

  if not SizeRangeCreated then
  begin
    LocalConnectionSumms.Rollback;
    eNewSizeRangeCode.SetFocus;
    eNewSizeRangeCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;

    LocalConnectionSumms.Commit;

    Failed := False;
    try
      fmSizeRangeDetails := TfmSizeRangeDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmSizeRangeDetails.PassSizeRangeName(fmSizeRangeDetails, Code);

    Close;
  end;
end;

procedure TfmCopySizeRange.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmCopySizeRange.FormActivate(Sender: TObject);
begin
  eNewSizeRangeCode.text := '';
  eNewSizeRangeCode.SetFocus;
end;

procedure TfmCopySizeRange.eNewSizeRangeCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmCopySizeRange.FormShow(Sender: TObject);
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

procedure TfmCopySizeRange.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmCopySizeRange.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
