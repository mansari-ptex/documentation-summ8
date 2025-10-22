unit NewSizeRange;

interface

uses
  Classes, Controls, Forms, StdCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls, Db, ToolWin;

type
  TfmNewSizeRange = class(TForm)
    eNewSizeRangesCode: TEdit;
    qSizeRanges: TFDQueryPlus;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    eSizeScale: TEdit;
    btnBrowse: TSpeedButton;
    lblCode: TLabel;
    lblSizeScale: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eSizeScaleEnter(Sender: TObject);
    procedure eSizeScaleExit(Sender: TObject);
    procedure eAnyCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNewSizeRange: TfmNewSizeRange;

implementation

uses
  Windows, SysUtils, Graphics, Dialogs, Summs, SizeRangeDetails,
  BrowseSizeScales, OutOfMemory, AdvErrorHandler, SummsVars, General;

{$R *.DFM}

procedure TfmNewSizeRange.btnSaveClick(Sender: TObject);
var
  fmSizeRangeDetails: TfmSizeRangeDetails;
  Code : string;
  Failed, RangeFocus, SizeRangeCreated : boolean;

begin
  RangeFocus := True;

  Code := eNewSizeRangesCode.Text;
  if  Code = '' then
    abort;

  qSizeRanges.ParamByName('Scale').AsString := eSizeScale.Text;
  qSizeRanges.ParamByName('Range').AsString := Code;

  SizeRangeCreated := True;
  try
    qSizeRanges.ExecSQL;
  except
    on E: EFDDBEngineException do
    begin
      if pos('SIZERANGES:SCALE',E.Message) > 0 then
      begin
        fmErrorHandler.DebugMessageDlg('Size Scale does not exist', E.Message, qSizeRanges.Text);
        RangeFocus := False;
      end
      else
      begin
        fmErrorHandler.DebugMessageDlg('Size Range already exists', E.Message, qSizeRanges.Text);
        RangeFocus := True;
      end;
      SizeRangeCreated := False;
    end
    else
      Raise;
  end;

  if SizeRangeCreated then
  begin
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmSizeRangeDetails := TfmSizeRangeDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
    begin
      fmSizeRangeDetails.PassSizeRangeName(fmSizeRangeDetails, Code);
      if fmSumms.mmAutoEdit.Checked then
        fmSizeRangeDetails.btnEdit.Click;
    end;

    Close;
  end
  else
  begin
    if RangeFocus then
    begin
      eNewSizeRangesCode.SetFocus;
      eNewSizeRangesCode.SelectAll;
    end
    else
    begin
      eSizeScale.SetFocus;
      eSizeScale.SelectAll;
    end;
  end;
end;

procedure TfmNewSizeRange.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewSizeRange.btnBrowseClick(Sender: TObject);
begin
  fmBrowseSizeScales.ShowModal;
  eSizeScale.text := fmBrowseSizeScales.lblScale.caption;
end;

procedure TfmNewSizeRange.FormActivate(Sender: TObject);
begin
  eNewSizeRangesCode.Text := '';
  eSizeScale.Text := '';
  eNewSizeRangesCode.SetFocus;  
end;

procedure TfmNewSizeRange.eSizeScaleEnter(Sender: TObject);
begin
  btnBrowse.enabled := True;
end;

procedure TfmNewSizeRange.eSizeScaleExit(Sender: TObject);
begin
  btnBrowse.enabled := False;
end;

procedure TfmNewSizeRange.eAnyCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmNewSizeRange.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);
end;

procedure TfmNewSizeRange.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
