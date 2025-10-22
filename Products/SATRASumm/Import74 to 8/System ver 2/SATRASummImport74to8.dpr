program SATRASummImport74to8;

{$R 'Create Resource\Elements.res'}
{$R 'Create Resource\CuttingElements.res'}

uses
  Forms,
  Main in 'Main.pas' {fmUpgrade};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmUpgrade, fmUpgrade);
  Application.Run;
end.
