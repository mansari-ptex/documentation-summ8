program SATRASummUpgrade74to8;

uses
  Forms,
  Main in 'Main.pas' {fmUpgrade};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmUpgrade, fmUpgrade);
  Application.Run;
end.
