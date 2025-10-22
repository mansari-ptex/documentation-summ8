program Visualiser;

uses
  Forms,
  VisualiserMain in 'VisualiserMain.pas' {fmLayplan},
  AccessDenied in '..\..\Common\AccessDenied.pas' {fmAccessDenied},
  CmnVars in '..\..\Common\CmnVars.pas',
  General in '..\..\Common\General.pas',
  LockedDialog in '..\..\Common\LockedDialog.pas' {fmLockedDialog},
  OutOfMemory in '..\..\Common\OutOfMemory.pas' {fmMemoryError},
  SummsVars in '..\System\SummsVars.pas',
  Filt in '..\System\Filt.pas',
  PatternDrawing in '..\System\PatternDrawing.pas' {dmPatternDrawing: TDataModule},
  AllPatterns in '..\System\Interlocking\AllPatterns.pas' {fmAllPatterns},
  CompareOldNew in '..\System\Interlocking\CompareOldNew.pas' {fmCompareOldNew},
  Concavities in '..\System\Interlocking\Concavities.pas',
  ConvexHull in '..\System\Interlocking\ConvexHull.pas',
  Debugger in '..\System\Interlocking\Debugger.pas' {fmDebugger},
  Expansion in '..\System\Interlocking\Expansion.pas',
  FastGEO in '..\System\Interlocking\FastGEO.pas',
  General_Interlocking in '..\System\Interlocking\General_Interlocking.pas',
  Interlocking in '..\System\Interlocking\Interlocking.pas',
  Merge in '..\System\Interlocking\Merge.pas',
  PlanIt in '..\System\Interlocking\PlanIt.pas',
  PolygonOverlaps in '..\System\Interlocking\PolygonOverlaps.pas',
  Results in '..\System\Interlocking\Results.pas',
  Const_Interlocking in '..\System\Interlocking\Const_Interlocking.pas',
  Edges in '..\System\Interlocking\Edges.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmLayplan, fmLayplan);
  Application.CreateForm(TfmAccessDenied, fmAccessDenied);
  Application.CreateForm(TfmLockedDialog, fmLockedDialog);
  Application.CreateForm(TfmMemoryError, fmMemoryError);
  Application.CreateForm(TdmPatternDrawing, dmPatternDrawing);
  Application.CreateForm(TfmAllPatterns, fmAllPatterns);
  Application.CreateForm(TfmCompareOldNew, fmCompareOldNew);
  Application.CreateForm(TfmDebugger, fmDebugger);
  dmPatternDrawing.Pass(fmLayplan.LocalConnectionSumms);

  Application.Run;
end.
