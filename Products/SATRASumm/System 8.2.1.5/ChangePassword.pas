unit ChangePassword;

interface

uses
  Classes, Controls, Forms, StdCtrls, Mask, Buttons, ExtCtrls, ComCtrls,
  ToolWin, Data.DB,   FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FDQueryPlus, FDTablePlus;

type
  TfmChangePassword = class(TForm)
    tbMain: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    pnlMain: TPanel;
    lblOld: TLabel;
    lblNew: TLabel;
    lblVerify: TLabel;
    edtVerify: TMaskEdit;
    edtNew: TMaskEdit;
    edtOld: TMaskEdit;
    qPassword: TFDQueryPlus;
    qVersion: TFDQueryPlus;
    qPassword10: TFDQueryPlus;
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure eAnyKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function IsAdvantage11OrLater: Boolean;
  public
    { Public declarations }
  end;

var
  fmChangePassword: TfmChangePassword;

implementation

uses
  Windows, Dialogs, General, Summs, CmnVars, SysUtils,
  AdvErrorHandler, SummsVars;

{$R *.DFM}

procedure TfmChangePassword.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmChangePassword.FormActivate(Sender: TObject);
begin
  edtOld.text := '';
  edtNew.text := '';
  edtVerify.text := '';
  edtOld.SetFocus;
  edtOld.SelectAll;
end;

procedure TfmChangePassword.eAnyKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnSave.Click
  else if Key = VK_ESCAPE then
    btnCancel.Click;
end;

procedure TfmChangePassword.FormShow(Sender: TObject);
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

function TfmChangePassword.IsAdvantage11OrLater: Boolean;
var
  Advantage11OrLater: Boolean;
  VersionInfo: string;
  FirstDecimal: SmallInt;
  MainVersion: SmallInt;

begin
  Advantage11OrLater := False;

  try
    qVersion.Open;
    VersionInfo := qVersion.FieldByName('Version').Value;
    qVersion.Close;

    FirstDecimal := pos('.', VersionInfo);
    if FirstDecimal > 0 then
    begin
      MainVersion := strToInt(copy(VersionInfo, 1, FirstDecimal - 1));

      Advantage11OrLater := (MainVersion >= 11);
    end;
  except
    // Do Nothing
  end;

  Result := Advantage11OrLater;
end;

procedure TfmChangePassword.btnSaveClick(Sender: TObject);
var
  l: integer;
  tryPassword: AnsiString;

begin
  if edtOld.text <> SystemPassword then
    MessageDlgPos('Password NOT changed - Old Password incorrect', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else if edtNew.text <> edtVerify.text then
    MessageDlgPos('Password NOT changed - Verify does not match', mtInformation, [mbOk], 0, ((Application.MainForm.Width div 3) + Application.MainForm.Left), ((Application.MainForm.Height div 3) + Application.MainForm.Top))
  else
    try
      tryPassword := edtNew.text;
      l := length(tryPassword) + 1;

      if IsAdvantage11OrLater then
      begin
        qPassword.ParamByName('OldPassword').Value := SystemPassword;
        qPassword.ParamByName('NewPassword').Value := TryPassword;
        qPassword.ExecSQL;
      end
      else
      begin
        qPassword10.ParamByName('UserName').Value := SystemUserName;
        qPassword10.ParamByName('NewPassword').Value := TryPassword;
        qPassword10.ExecSQL;
      end;

      SystemPassword := tryPassword;
      close;
    except
      on E: Exception do
        fmErrorHandler.DebugMessageDlg('Operation could not be performed', E.Message, '');
    end;
end;

procedure TfmChangePassword.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
