unit CopyConstruction;

interface

uses
  Classes, Controls, Forms, StdCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls,  Db, ToolWin, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys;

type
  TfmCopyConstruction = class(TForm)
    qConstructions: TFDQueryPlus;
    eNewConstructionCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    LocalConnectionSumms: TFDConnection;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eNewConstructionCodeKeyDown(Sender: TObject; var Key: Word;
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
  fmCopyConstruction: TfmCopyConstruction;

implementation

uses
  Windows, SysUtils, Dialogs, General, Summs, ConstructionDetails, OutOfMemory,
  AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmCopyConstruction.btnSaveClick(Sender: TObject);
var
  fmConstructionDetails: TfmConstructionDetails;
  Code : string;
  Failed, ConstructionCreated : boolean;

begin
  Code := eNewConstructionCode.Text;
  if Code = '' then
    abort;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  LocalConnectionSumms.StartTransaction;

  qConstructions.SQL.Text := 'INSERT INTO Construc (Construction, SizeScale, SizeRange, SampleSize, CostedSize, ' +
                             'Description, MadeInPairs) SELECT ''' + QS(Code) + ''', SizeScale, SizeRange, SampleSize, CostedSize, ' +
                             'Description, MadeInPairs FROM Construc WHERE Construction = ''' + QS(BaseCode) + ''';' + #13 +
                             'INSERT INTO ConParts (Construction, Part, ID, AltMaterial, Use) SELECT ''' + QS(Code) +
                             ''', Part, ID, AltMaterial, Use FROM ConParts WHERE Construction = ''' + QS(BaseCode) + ''';';

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
    LocalConnectionSumms.Rollback;
    eNewConstructionCode.SetFocus;
    eNewConstructionCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;

    LocalConnectionSumms.Commit;

    Failed := False;
    try
      fmConstructionDetails := TfmConstructionDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmConstructionDetails.PassConstructionName(fmConstructionDetails, Code);

    Close;
  end;
end;

procedure TfmCopyConstruction.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmCopyConstruction.FormActivate(Sender: TObject);
begin
  eNewConstructionCode.text := '';
  eNewConstructionCode.SetFocus;
end;

procedure TfmCopyConstruction.eNewConstructionCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmCopyConstruction.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  Form := (Sender as TForm);

  Form.left := (Screen.Width div 2) - (Form.Width div 2);
  Form.top := (Screen.Height div 2) - (Form.Height div 2);
end;

procedure TfmCopyConstruction.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmCopyConstruction.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
