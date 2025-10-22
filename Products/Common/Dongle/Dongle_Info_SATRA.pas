unit Dongle_Info_SATRA;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Dongle_Info, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfmDongleInformationSATRA = class(TfmDongleInformation)
    lblCustomerName: TLabel;
    lblCustomerNameTitle: TLabel;
  private
    { Private declarations }
  protected
    procedure InitialiseScreen; override;
    procedure UpdateScreen; override;
  public
    { Public declarations }
  end;

var
  fmDongleInformationSATRA: TfmDongleInformationSATRA;

implementation

uses
  Dongle_SATRA;

{$R *.dfm}



{ TfmDongleInformationSATRA }



procedure TfmDongleInformationSATRA.InitialiseScreen;
begin
  inherited;

  lblCustomerName.Caption := '---';
end;


procedure TfmDongleInformationSATRA.UpdateScreen;
begin
  inherited;

  if Assigned(FDongle) then
    lblCustomerName.Caption := TSATRADongle(FDongle).CustomerName;
end;


end.
