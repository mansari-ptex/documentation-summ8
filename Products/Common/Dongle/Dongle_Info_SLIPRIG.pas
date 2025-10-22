unit Dongle_Info_SLIPRIG;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dongle_Info, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfmDongleInformationSlipRig = class(TfmDongleInformation)
    lblMachineIDTitle: TLabel;
    lblVersion: TLabel;
    lblMachineID: TLabel;
    lblVersionTitle: TLabel;
  private
    { Private declarations }
  protected
    procedure InitialiseScreen; override;
    procedure UpdateScreen; override;
  public
    { Public declarations }
  end;

var
  fmDongleInformationSlipRig: TfmDongleInformationSlipRig;

implementation

uses
  Dongle_SLIPRIG;

{$R *.dfm}



{ TfmDongleInformationSlipRig }



procedure TfmDongleInformationSlipRig.InitialiseScreen;
begin
  inherited;

  lblVersion.Caption := '---';
  lblMachineID.Caption := '---';
end;


procedure TfmDongleInformationSlipRig.UpdateScreen;
begin
  inherited;

  if Assigned(FDongle) then
  begin
    lblVersion.Caption := TSlipRigDongle(FDongle).Version;
    lblMachineID.Caption := TSlipRigDongle(FDongle).MachineID;
  end;
end;


end.
