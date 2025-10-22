unit SeverVersion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfmServerVersion = class(TForm)
    rgServerVersion: TRadioGroup;
    btnBack: TButton;
    btnNext: TButton;
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmServerVersion: TfmServerVersion;

implementation

uses Main;

{$R *.dfm}

procedure TfmServerVersion.btnNextClick(Sender: TObject);
begin
  fmServerVersion.Visible := False;

  fmSetup.visible := False;

  if rgServerVersion.ItemIndex = 0 then
    fmSetup.RunExternalAndWait('setup.exe', '', fmSetup.ThisDir + 'Advantage Servers\11.1\32 Bit')
  else if rgServerVersion.ItemIndex = 1 then
    fmSetup.RunExternalAndWait('setup.exe', '', fmSetup.ThisDir + 'Advantage Servers\11.1\64 Bit')
  else if rgServerVersion.ItemIndex = 2 then
    fmSetup.RunExternalAndWait('setup.exe', '', fmSetup.ThisDir + 'Advantage Servers\10.1\32 Bit')
  else if rgServerVersion.ItemIndex = 3 then
    fmSetup.RunExternalAndWait('setup.exe', '', fmSetup.ThisDir + 'Advantage Servers\10.1\64 Bit')
  else if rgServerVersion.ItemIndex = 4 then
    fmSetup.RunExternalAndWait('setup.exe', '', fmSetup.ThisDir + 'Advantage Servers\9.1\32 Bit')
  else if rgServerVersion.ItemIndex = 5 then
    fmSetup.RunExternalAndWait('setup.exe', '', fmSetup.ThisDir + 'Advantage Servers\9.1\64 Bit')
  else if rgServerVersion.ItemIndex = 6 then
    fmSetup.RunExternalAndWait('setup.exe', '', fmSetup.ThisDir + 'Advantage Servers\8.1\NT');

  ChDir(fmSetup.ThisDir);
  fmSetup.visible := True;

  close;
end;

procedure TfmServerVersion.btnBackClick(Sender: TObject);
begin
  close;
end;

end.
