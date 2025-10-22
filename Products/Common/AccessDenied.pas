unit AccessDenied;

interface

uses
  Controls, Forms, ExtCtrls, StdCtrls, Classes, Buttons, CButton, Graphics,
  General;

type
  TfmAccessDenied = class(TForm)
    imgNoEntry: TImage;
    lblMessage: TLabel;
    btnOk: TColButton;
    imgNoAds: TImage;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAccessDenied: TfmAccessDenied;

implementation

{$R *.DFM}

procedure TfmAccessDenied.btnOkClick(Sender: TObject);
begin
  close;
end;

procedure TfmAccessDenied.FormShow(Sender: TObject);
var
  Form: TForm;

begin
//  Form := (Sender as TForm);

  Form := Application.MainForm;

  //Resorts out message Height. Can't
  //see why its necesary but it is!
  lblMessage.AutoSize := False;
  lblMessage.Height := 65;
  lblMessage.Width := 200;
  lblMessage.AutoSize := True;

  Height := 147;
  if lblMessage.Height > 65 then
    Height := Height + lblMessage.Height - 65;
  btnOk.Top := Height - 60;

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);
end;

procedure TfmAccessDenied.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
