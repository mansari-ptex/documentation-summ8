program SATRASummUpgrade80to81;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fmMain},
  KnifeNettArea in '..\System 8.1.0.0\KnifeNettArea.pas' {dmKnifeNettArea: TDataModule},
  General_Interlocking in '..\System 8.1.0.0\Interlocking\General_Interlocking.pas',
  Interlocking in '..\System 8.1.0.0\Interlocking\Interlocking.pas',
  FastGEO in '..\System 8.1.0.0\Interlocking\FastGEO.pas',
  Const_Interlocking in '..\System 8.1.0.0\Interlocking\Const_Interlocking.pas',
  Expansion in '..\System 8.1.0.0\Interlocking\Expansion.pas',
  ConvexHull in '..\System 8.1.0.0\Interlocking\ConvexHull.pas',
  PolygonOverlaps in '..\System 8.1.0.0\Interlocking\PolygonOverlaps.pas',
  Edges in '..\System 8.1.0.0\Interlocking\Edges.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmKnifeNettArea, dmKnifeNettArea);
  Application.Run;
end.
