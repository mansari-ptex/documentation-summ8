unit CopyStyle;

interface

uses
  Classes, Controls, Forms, StdCtrls,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus, Buttons,
  ExtCtrls, ComCtrls,  Db, ToolWin, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FDConnectionPlus;

type
  TfmCopyStyle = class(TForm)
    eNewStyleCode: TEdit;
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    qStyles: TFDQueryPlus;
    LocalConnectionSumms: TFDConnectionPlus;
    lblCode: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eNewStyleCodeKeyDown(Sender: TObject; var Key: Word;
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
  fmCopyStyle: TfmCopyStyle;

implementation

uses
  Windows, SysUtils, Dialogs, General, OutOfMemory, Summs, StyleDetails,
  AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmCopyStyle.btnSaveClick(Sender: TObject);

var
  Code : string;
  Failed, StyleCreated : boolean;
  fmStyleDetails : TfmStyleDetails;

begin
  Code := eNewStyleCode.Text;
  if Code = '' then
    abort;

  if not LocalConnectionSumms.Connected then
    LocalConnectionSumms.Connected := True;

  LocalConnectionSumms.StartTransaction;

  qStyles.SQL.Text := 'INSERT INTO Styles (Style, Description, PicturePath, Picture) SELECT ''' +
                         QS(Code) + ''', Description, PicturePath, Picture FROM Styles WHERE Style = ''' + QS(BaseCode) + ''';' + #13 +
                      'INSERT INTO StyConst (Style, Construction) SELECT ''' +
                         QS(Code) + ''', Construction FROM StyConst WHERE Style = ''' + QS(BaseCode) + ''';' + #13 +
                      'UPDATE S SET S.CurrentCon = S1.CurrentCon ' +
                      'FROM Styles S, Styles S1 ' +
                      'WHERE S1.Style = ''' + QS(BaseCode) +  ''' AND S.Style = ''' + QS(Code) + ''';';

  StyleCreated := True;
  try
    qStyles.ExecSQL;
  except
    on E: Exception do
    begin
      fmErrorHandler.DebugMessageDlg('Style already exists', E.Message, qStyles.Text);
      StyleCreated := False;
    end;
  end;

  if not StyleCreated then
  begin
    LocalConnectionSumms.Rollback;
    eNewStyleCode.SetFocus;
    eNewStyleCode.SelectAll;
  end
  else
  begin
    Screen.cursor := crHourGlass;

    LocalConnectionSumms.Commit;

    Failed := False;
    try
      fmStyleDetails := TfmStyleDetails.create(fmSumms);
    except
      fmMemoryError.TidyUp(self);
      Failed := true;
    end;

    if not Failed then
      fmStyleDetails.PassStyleName(fmStyleDetails, Code);

    Close;
  end;
end;

procedure TfmCopyStyle.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmCopyStyle.FormActivate(Sender: TObject);
begin
  eNewStyleCode.Text := '';
  eNewStyleCode.SetFocus;
end;

procedure TfmCopyStyle.eNewStyleCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmCopyStyle.FormShow(Sender: TObject);
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

procedure TfmCopyStyle.LocalConnectionSummsAfterConnect(Sender: TObject);
begin
  ConnectionModification(Sender);
end;

procedure TfmCopyStyle.LocalConnectionSummsBeforeConnect(
  Sender: TObject);
begin
  ConnectionSettings(Sender);
end;

procedure TfmCopyStyle.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
