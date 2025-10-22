unit Dongle_Info;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Dongle_Base;

type
  TfmDongleInformation = class(TForm)
    lblExtendedError: TLabel;
    pnlBackground: TPanel;
    lblNoDongleDetected: TLabel;
    pnlInfo: TPanel;
    lblFeatures: TLabel;
    lblExpiry: TLabel;
    lblSerial_Number: TLabel;
    lblUpdates: TLabel;
    lblFeaturesTitle: TLabel;
    lblExpiryTitle: TLabel;
    lblSerial_NumberTitle: TLabel;
    lblUpdatesTitle: TLabel;
    lblProductCode: TLabel;
    lblProductCodeTitle: TLabel;
    lblSystemTitle: TLabel;
    lblSystem: TLabel;
    imgDongle: TImage;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  protected
    FDongle: TDongle;
    procedure InitialiseScreen; virtual;
    procedure UpdateScreen; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Initialise(ADongle: TDongle);
  end;

var
  fmDongleInformation: TfmDongleInformation;

implementation

{$R *.DFM}



{ fmDongleInformation }



constructor TfmDongleInformation.Create(AOwner: TComponent);
begin
  inherited;

  FDongle := nil;
end;


procedure TfmDongleInformation.FormShow(Sender: TObject);
begin
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;

  if Assigned(FDongle) then
    UpdateScreen;
end;


procedure TfmDongleInformation.UpdateScreen;
begin
  InitialiseScreen;

  if Assigned(FDongle) then
  begin
    pnlInfo.Visible := True;
    lblNoDongleDetected.Visible := False;

    if (not FDongle.DongleDetected) or (not FDongle.CorrectDongle) then
    begin
      pnlInfo.Visible := False;
      lblNoDongleDetected.Visible := True;
    end
    else
    begin
      lblFeatures.Caption := IntToStr(FDongle.Features);
      if FDongle.ExpiryDateUsed then
        lblExpiry.Caption := FDongle.ExpiryDateAsString;
      lblSerial_Number.Caption := IntToStr(FDongle.SerialNumber);
      lblUpdates.Caption := IntToStr(FDongle.UpdateNumber);
      lblProductCode.Caption := FDongle.ProductCode;
      lblSystem.Caption := IntToStr(FDongle.CheckCode);
    end;
  end;
end;


procedure TfmDongleInformation.Initialise(ADongle: TDongle);
begin
  FDongle := ADongle;
end;


procedure TfmDongleInformation.InitialiseScreen;
begin
  lblFeatures.Caption := '---';
  lblExpiry.Caption := '---';
  lblSerial_Number.Caption := '---';
  lblUpdates.Caption := '---';
  lblProductCode.Caption := '---';
  lblSystem.Caption := '---';
end;


end.
