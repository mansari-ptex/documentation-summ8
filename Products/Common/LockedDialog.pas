unit LockedDialog;

interface

uses
  Controls, Forms, ExtCtrls, StdCtrls, Classes, Buttons, CButton,
  CmnVars, Graphics, General;

type
  TfmLockedDialog = class(TForm)
    imgKey: TImage;
    lblMessage: TLabel;
    btnOk: TColButton;
    lblUser: TLabel;
    lblComputer: TLabel;
    lblAddress: TLabel;
    lblActualUser: TLabel;
    lblActualComputer: TLabel;
    lblActualAddress: TLabel;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LockMessage(TheMessage: string; LockedBy: TlockedBy);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmLockedDialog: TfmLockedDialog;

implementation

{$R *.DFM}

procedure TfmLockedDialog.btnOkClick(Sender: TObject);
begin
  close;
end;

procedure TfmLockedDialog.FormShow(Sender: TObject);
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

procedure TfmLockedDialog.LockMessage(TheMessage: string; LockedBy: TlockedBy);
begin
  if LockedBy.Locked then
  begin
    lblMessage.caption := TheMessage  + ' by';
    if not FullLockingInfo then
      lblMessage.caption := lblMessage.caption + ' user ' + LockedBy.User;

    lblActualUser.caption := LockedBy.User;
    lblActualComputer.caption := LockedBy.Computer;
    lblActualAddress.caption := LockedBy.Address;

    lblUser.Visible := FullLockingInfo;
    lblActualUser.Visible := FullLockingInfo;
    lblComputer.Visible := FullLockingInfo;
    lblActualComputer.Visible := FullLockingInfo;
    lblAddress.Visible := FullLockingInfo;
    lblActualAddress.Visible := FullLockingInfo;
  end
  else
  begin
    lblMessage.caption := TheMessage + '.';

    lblUser.Visible := False;
    lblActualUser.Visible := False;
    lblComputer.Visible := False;
    lblActualComputer.Visible := False;
    lblAddress.Visible := False;
    lblActualAddress.Visible := False;
  end;

  ShowModal;
end;

procedure TfmLockedDialog.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
