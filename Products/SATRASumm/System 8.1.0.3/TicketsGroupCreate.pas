unit TicketsGroupCreate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gauges, ExtCtrls, jpeg, General, ComCtrls;

type
  TfmTicketsGroupCreate = class(TForm)
    pnlProgressBar: TPanel;
    lblTicketCode: TLabel;
    pbTicketsCreated: TGauge;
    imgScreen: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    DefaultHeight, DefaultWidth: integer;
  public
    { Public declarations }
  end;

var
  fmTicketsGroupCreate: TfmTicketsGroupCreate;

implementation

uses
  Summs, AllTickets, SummsVars;

{$R *.dfm}

procedure TfmTicketsGroupCreate.FormShow(Sender: TObject);
begin
  Height := DefaultHeight;
  Width := DefaultHeight;
  Left := -1000;
  Top := -1000;
end;

procedure TfmTicketsGroupCreate.FormActivate(Sender: TObject);
var
  bm: Graphics.TBitmap;
  P: TPoint;
  pbPos: TPoint;

begin
  P.x := fmSumms.left;
  P.y := fmSumms.top;

  //Draw section of screen using Screenshot and not
  //fmSumms.GetFormImage which is buggy
  bm := Graphics.tBitmap.create;
  ScreenShot(P.x, P.y, fmSumms.Width, fmSumms.Height, bm);
  fmTicketsGroupCreate.imgScreen.Picture.Assign(bm);

  fmTicketsGroupCreate.Height := fmSumms.Height;
  fmTicketsGroupCreate.Width := fmSumms.Width;
  fmTicketsGroupCreate.Left := fmSumms.Left;
  fmTicketsGroupCreate.Top := fmSumms.Top;

  pbPos.X := (fmAllTickets.Width div 2) - (pnlProgressBar.Width div 2);
  pbPos.Y := (fmAllTickets.Height div 2) - (pnlProgressBar.Height div 2);
  pnlProgressBar.Left := fmAllTickets.Left + pbPos.X;
  pnlProgressBar.Top := GetSystemMetrics(SM_CYCAPTION) * 2 + fmAllTickets.Top + pbPos.Y;
  if fmSumms.tbMain.Visible then
    pnlProgressBar.Top := pnlProgressBar.Top + fmSumms.tbMain.height;
end;

procedure TfmTicketsGroupCreate.FormCreate(Sender: TObject);
begin
  AutoColor(Self);
  DefaultHeight := Height;
  DefaultWidth := Width;
end;

end.
