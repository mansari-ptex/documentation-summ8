program SATRASummSetup;

uses
  Forms,
  Main in 'Main.pas' {fmSetup},
  SeverVersion in 'SeverVersion.pas' {fmServerVersion};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmSetup, fmSetup);
  Application.CreateForm(TfmServerVersion, fmServerVersion);
  Application.Run;
end.
