unit CancelPrinting;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CButton, General, Vcl.Buttons;

type
  TfmCancelPrinting = class(TForm)
    btnCancel: TColButton;
    lblItem: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCancelPrinting: TfmCancelPrinting;

implementation

{$R *.DFM}

procedure TfmCancelPrinting.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfmCancelPrinting.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  lblItem.caption := '';

//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);
end;

procedure TfmCancelPrinting.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
end;

end.
