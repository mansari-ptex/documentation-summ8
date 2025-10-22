program SATRASummDowngrade83to82;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fmDowngrade};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmDowngrade, fmDowngrade);
  Application.Run;
end.
