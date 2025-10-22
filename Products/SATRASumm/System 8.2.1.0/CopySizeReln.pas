unit CopySizeReln;

interface

uses
  Classes, Controls, Forms, StdCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, DBCtrls,
  Buttons, ExtCtrls, ToolWin, ComCtrls,  Db, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FDConnectionPlus;

type
  TfmCopySizeRelationship = class(TForm)
    eNewSizeRelationshipCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qSizeRelationships: TFDQueryPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eNewSizeRelationshipCodeKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
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
  fmCopySizeRelationship: TfmCopySizeRelationship;

implementation

uses
  Windows, SysUtils, Dialogs, General, Summs, SizeRelationshipDetails, OutOfMemory,
  AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmCopySizeRelationship.btnSaveClick(Sender: TObject);
var
  fmSizeRelationshipDetails: TfmSizeRelationshipDetails;
  Code : string;
  Failed, SizeRelationshipCreated : boolean;

begin
  Code := eNewSizeRelationshipCode.Text;
  if Code = '' then
    abort;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  LocalConnectionSumms.StartTransaction;

  qSizeRelationships.SQL.Text := 'INSERT INTO SizeRelationships (Scale, Range, Relationship, Description) ' +
                                 'SELECT Scale, Range, ''' + QS(Code) + ''', Description FROM SizeRelationships ' +
                                 'WHERE Relationship = ''' + QS(BaseCode) + ''';' + #13 +
                                 'INSERT INTO SizeRelationshipSizes (Scale, Range, Relationship, ShoeSize, KnifeSize, ' +
                                 'Seq) SELECT Scale, Range, ''' + QS(Code) + ''', ShoeSize, KnifeSize, Seq ' +
                                 'FROM SizeRelationshipSizes WHERE Relationship = ''' + QS(BaseCode) + ''';';

  SizeRelationshipCreated := True;
  try
    qSizeRelationships.ExecSQL;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('Size Relationship already exists', E.Message, qSizeRelationships.Text);
      SizeRelationshipCreated := False;
    end;
  end;

  if not SizeRelationshipCreated then
  begin
    LocalConnectionSumms.Rollback;
    eNewSizeRelationshipCode.SetFocus;
    eNewSizeRelationshipCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;

    LocalConnectionSumms.Commit;

    Failed := False;
    try
      fmSizeRelationshipDetails := TfmSizeRelationshipDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmSizeRelationshipDetails.PassSizeRelationshipName(fmSizeRelationshipDetails, Code);

    Close;
  end;
end;

procedure TfmCopySizeRelationship.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmCopySizeRelationship.FormActivate(Sender: TObject);
begin
  eNewSizeRelationshipCode.Text := '';
  eNewSizeRelationshipCode.SetFocus
end;

procedure TfmCopySizeRelationship.eNewSizeRelationshipCodeKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmCopySizeRelationship.FormShow(Sender: TObject);
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

procedure TfmCopySizeRelationship.LocalConnectionSummsAfterConnect(
  Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmCopySizeRelationship.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmCopySizeRelationship.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
