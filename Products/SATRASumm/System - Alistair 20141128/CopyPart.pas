unit CopyPart;

interface

uses
  SysUtils, Classes, Controls, Forms, StdCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus,
  Buttons, ExtCtrls, ComCtrls,  Db, ToolWin, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys;

type
  TfmCopyPart = class(TForm)
    eNewPartCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qParts: TFDQueryPlus;
    LocalConnectionSumms: TFDConnection;
    lblCode: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eNewPartCodeKeyDown(Sender: TObject; var Key: Word;
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
  fmCopyPart: TfmCopyPart;

implementation

uses
  Windows, Dialogs, General, Summs, PartDetails, OutOfMemory,
  AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmCopyPart.btnSaveClick(Sender: TObject);
var
  fmPartDetails : TfmPartDetails;
  Code : string;
  Failed, PartCreated : boolean;

begin
  Code := eNewPartCode.Text;
  if Code = '' then
    abort;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  LocalConnectionSumms.StartTransaction;

  qParts.SQL.Text := 'INSERT INTO Parts (Code, Description, Rest, Contingency, Material, SizeScale, SizeRange, ' +
                     'WidthRange, CostedSize, SampleSize, ManualAdjFactor, CostedAllowance, MaxPairs, StdBatchSize, ' +
                     'Notes, FeedSystem, SLMAllowance, MadeInPairs, PressTypeLeather, PressTypeSynthetic) SELECT ''' + QS(Code) + ''', Description, Rest, Contingency, ' +
                     'Material, SizeScale, SizeRange, WidthRange, CostedSize, SampleSize, ManualAdjFactor, ' +
                     'CostedAllowance, MaxPairs, StdBatchSize, Notes, FeedSystem, SLMAllowance, MadeInPairs, PressTypeLeather, PressTypeSynthetic FROM Parts WHERE Code = ''' +
                      QS(BaseCode) + ''';' + #13 +
                     'INSERT INTO PtWidAF (Part, WidthNo, AdjFactor) SELECT ''' + QS(Code) + ''', WidthNo, AdjFactor ' +
                     'FROM PtWidAF WHERE Part = ''' + QS(BaseCode) + ''';' + #13 +
                     'INSERT INTO PtWidKnf (Part, WidthNo, Knife, Seq, Frequency, SizeScale, SizeRange, ' +
                     'SizeRelationship, SizeAdjustment) SELECT ''' + QS(Code) + ''', WidthNo, Knife, Seq, Frequency, ' +
                     'SizeScale, SizeRange, SizeRelationship, SizeAdjustment FROM PtWidKnf WHERE Part = ''' +
                      QS(BaseCode) + ''';';

  PartCreated := True;
  try
    qParts.ExecSQL;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('Part already exists', E.Message, qParts.Text);
      PartCreated := False;
    end;
  end;

  if not PartCreated then
  begin
    LocalConnectionSumms.Rollback;
    eNewPartCode.SetFocus;
    eNewPartCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;

    LocalConnectionSumms.Commit;

    Failed := False;
    try
      fmPartDetails := TfmPartDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmPartDetails.PassPartName(fmPartDetails, Code);

    Close;
  end;
end;

procedure TfmCopyPart.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmCopyPart.FormActivate(Sender: TObject);
begin
  eNewPartCode.text := '';
  eNewPartCode.SetFocus;
end;

procedure TfmCopyPart.eNewPartCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmCopyPart.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);
end;

procedure TfmCopyPart.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmCopyPart.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
