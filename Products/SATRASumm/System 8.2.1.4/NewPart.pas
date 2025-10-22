unit NewPart;

interface

uses
  Classes, Controls, Forms, StdCtrls, DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls,  ToolWin, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FDConnectionPlus;

type
  TfmNewPart = class(TForm)
    eNewPartCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnBrowse: TSpeedButton;
    eSizeRange: TEdit;
    eWidthRange: TEdit;
    eMaterial: TEdit;
    qParts: TFDQueryPlus;
    qPartsGetError: TFDQueryPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    qPartsGetErrorEXPR: TIntegerField;
    lblCode: TLabel;
    lblMaterial: TLabel;
    lblSizeRange: TLabel;
    lblWidthRange: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eAnyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eAnyEnter(Sender: TObject);
    procedure eAnyExit(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LocalConnectionSummsBeforeConnect(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LocalConnectionSummsAfterConnect(Sender: TObject);
  private
    { Private declarations }
    BrowseNum : shortint;
  public
    { Public declarations }
  end;

var
  fmNewPart: TfmNewPart;

implementation

uses
  Windows, SysUtils, Dialogs, Summs, PartDetails, BrowseSizeRanges,
  BrowseWidthRanges, BrowseMaterials, OutOfMemory, CmnVars, SummsVars,
  AdvErrorHandler, General;

{$R *.DFM}

procedure TfmNewPart.btnSaveClick(Sender: TObject);
var
  fmPartDetails: TfmPartDetails;
  Code, SizeRange, WidthRange, Material: string;
  Failed: boolean;
  ErrorType: integer;
  errList: TStringList;
  EMessage: string;
  SQLCode, NativeCode: integer;

begin
  Code := eNewPartCode.Text;
  SizeRange := eSizeRange.Text;
  WidthRange := eWidthRange.Text;
  Material := eMaterial.Text;

  if  Code = '' then
    abort;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  LocalConnectionSumms.StartTransaction;

  qParts.ParamByName('Code').value := Code;
  qParts.ParamByName('SizeRange').value := SizeRange;
  qParts.ParamByName('WidthRange').value := WidthRange;
  qParts.ParamByName('Material').value := Material;
  qParts.ParamByName('MadeInPairs').value := MadeInPairsDefault;
  qParts.ParamByName('SLMAllowance').value := Option_FullSynthetics;

  ErrorType := 0;
  try
    qParts.ExecSQL;
    if (qParts.RowsAffected = 0) then
    begin
      qPartsGetError.ParamByName('SizeRange').value := SizeRange;
      qPartsGetError.open;
      if (qPartsGetErrorEXPR.value = 0) then
        //Size Range
        ErrorType := 1
      else
        //Material
        ErrorType := 2;
      qPartsGetError.close;
    end;
  except
    on E: EFDDBEngineException do
    begin
      errList := TStringList.Create();
      errList := fmErrorHandler.ErrRegMatch((E as EFDDBEngineException).Message);

      EMessage := errList.Values['Message'];
      SQLCode := strToInt(errList.Values['SQLErrorCode']);
      NativeCode := strToInt(errList.Values['NativeErrorCode']);
      errList.Free;

      if (SQLCode = 7200) and (NativeCode = 7057) then
        ErrorType := 6
      else if (SQLCode = 7200) and (NativeCode = 5147) then
        ErrorType := 7
      else if pos('PARTS:SIZERANGE', EMessage) > 0 then
        ErrorType := 1
      else if pos('PARTS:MATERIAL', EMessage) > 0 then
        ErrorType := 2
      else if pos('PARTS:WIDTHRANGE', EMessage) > 0 then
        ErrorType := 3
      else if pos('PARTS:SAMPLESIZE', EMessage) > 0 then
        ErrorType := 4
      else if pos('PARTS:COSTEDSIZE', EMessage) > 0 then
        ErrorType := 5
      else
        ErrorType := 8;
    end
    else
    begin
      ErrorType := 8;

      Raise;
    end;
  end;

  if ErrorType = 0 then
  begin
    LocalConnectionSumms.Commit;
    Screen.cursor := crHourGlass;
    Failed := False;
    try
      fmPartDetails := TfmPartDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
    begin
      fmPartDetails.PassPartName(fmPartDetails, Code);
      if fmSumms.mmAutoEdit.Checked then
        fmPartDetails.btnEdit.Click;
    end;

    Close;
  end
  else
  begin
    if ErrorType = 1 then
      fmErrorHandler.DebugMessageDlg('Size Range does not exist', EMessage, '')
    else if ErrorType = 2 then
      fmErrorHandler.DebugMessageDlg('Material does not exist', EMessage, '')
    else if ErrorType = 3 then
      fmErrorHandler.DebugMessageDlg('Width Range does not exist', EMessage, '')
    else if ErrorType = 4 then
      fmErrorHandler.DebugMessageDlg('Invalid Sample Size for Size Range', EMessage, '')
    else if ErrorType = 5 then
      fmErrorHandler.DebugMessageDlg('Invalid Costed Size for Size Range', EMessage, '')
    else if ErrorType = 6 then
      fmErrorHandler.DebugMessageDlg('Part already exists', EMessage, '')
    else if ErrorType = 7 then
      fmErrorHandler.DebugMessageDlg('Size Range empty', EMessage, '')
    else if ErrorType = 8 then
      fmErrorHandler.DebugMessageDlg('Unknown error', EMessage, '');

    eNewPartCode.SetFocus;
    eNewPartCode.SelectAll;

    LocalConnectionSumms.Rollback;
  end;
end;

procedure TfmNewPart.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmNewPart.FormActivate(Sender: TObject);
begin
  eNewPartCode.text := '';
  eMaterial.text := '';
  eNewPartCode.SetFocus;
end;

procedure TfmNewPart.eAnyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmNewPart.eAnyEnter(Sender: TObject);
begin
  btnBrowse.enabled := True;

  if (Sender as TControl).Name = eSizeRange.Name then
  begin
    BrowseNum := 1;
    btnBrowse.Hint := 'Browse Size Range';
  end
  else
    if (Sender as TControl).Name = eWidthRange.Name then
    begin
      BrowseNum := 2;
      btnBrowse.Hint := 'Browse Width Range';
    end
    else
      if (Sender as TControl).Name = eMaterial.Name then
      begin
        BrowseNum := 3;
        btnBrowse.Hint := 'Browse Material';
      end;
end;

procedure TfmNewPart.eAnyExit(Sender: TObject);
begin
  btnBrowse.enabled := False;
end;

procedure TfmNewPart.btnBrowseClick(Sender: TObject);
begin
  case BrowseNum of
    1 : begin
          if fmBrowseSizeRanges.ShowModal = mrOK then
            eSizeRange.text := fmBrowseSizeRanges.lblRange.caption;
        end;
    2 : begin
          if fmBrowseWidthRanges.ShowModal = mrOK then
            eWidthRange.text := fmBrowseWidthRanges.lblWidthRange.caption;
        end;
    3 : begin
          if fmBrowseMaterials.ShowModal = mrOK then
            eMaterial.text := fmBrowseMaterials.lblMaterial.caption;
        end;
  end;
end;

procedure TfmNewPart.FormShow(Sender: TObject);
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

  eSizeRange.Text := LastPartSizeRange;
  eWidthRange.Text := LastPartWidthRange;
end;

procedure TfmNewPart.LocalConnectionSummsAfterConnect(Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmNewPart.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmNewPart.FormHide(Sender: TObject);
begin
  LastPartSizeRange := eSizeRange.Text;
  LastPartWidthRange := eWidthRange.Text;
end;

procedure TfmNewPart.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
