unit Splash;

interface

uses
  WinTypes, WinProcs, Classes, Controls, Forms, StdCtrls, ExtCtrls,
  Mask, Buttons, CButton, VLabel, Graphics, jpeg, SysUtils, General;

type
  TfmSplashScreen = class(TForm)
    pnlMain: TPanel;
    pnlLogin: TPanel;
    lblUserName: TLabel;
    lblPassword: TLabel;
    edtUserName: TEdit;
    medtPassword: TMaskEdit;
    btnLogin: TColButton;
    btnCancel: TColButton;
    imgSystem: TImage;
    procedure edtUserNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Initialise;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    { Public declarations }
    Login, Cancel: Boolean;
    UserName, Password: string;
  end;

implementation

{$R *.DFM}

procedure TfmSplashScreen.edtUserNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ord(key) = VK_ESCAPE then
  begin
    Login := True;
    Cancel := True;
  end
  else if ord(key) = VK_RETURN then
    btnLogin.click;
end;

procedure TfmSplashScreen.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Stop 'Closing' the splash screen by
  //e.g. pressing the X on the task bar
  abort;
end;

procedure TfmSplashScreen.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

procedure TfmSplashScreen.btnLoginClick(Sender: TObject);
begin
  UserName := edtUserName.text;
  Password := medtPassword.text;

  Login := True;

  Screen.cursor := crHourGlass;
end;

procedure TfmSplashScreen.btnCancelClick(Sender: TObject);
begin
  Login := True;
  Cancel := True;
end;

procedure TfmSplashScreen.Initialise;
begin
  edtUserName.text := '';
  medtPassword.text := '';

  Login := False;
  Cancel := False;

  pnlLogin.Enabled := True;
  edtUserName.setfocus;

  Screen.cursor := crDefault;
end;

end.
