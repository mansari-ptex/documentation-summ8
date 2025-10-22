program Caller;

uses
  Forms,
  CallerMain in 'CallerMain.pas' {fmCaller},
  FastGEO in 'FastGEO.pas',
  Interlocking in 'Interlocking.pas',
  PolygonOverlaps in 'PolygonOverlaps.pas',
  ConvexHull in 'ConvexHull.pas',
  Results in 'Results.pas',
  Expansion in 'Expansion.pas',
  Merge in 'Merge.pas',
  Debugger in 'Debugger.pas' {fmDebugger},
  PlanIt in 'PlanIt.pas',
  Concavities in 'Concavities.pas',
  General_Interlocking in 'General_Interlocking.pas',
  CompareOldNew in 'CompareOldNew.pas' {fmCompareOldNew},
  AllPatterns in 'AllPatterns.pas' {fmAllPatterns},
  Filt in '..\Filt.pas',
  SummsVars in '..\SummsVars.pas',
  General in '..\..\..\Common\General.pas',
  CmnVars in '..\..\..\Common\CmnVars.pas',
  OutOfMemory in '..\..\..\Common\OutOfMemory.pas' {fmMemoryError},
  AccessDenied in '..\..\..\Common\AccessDenied.pas' {fmAccessDenied},
  LockedDialog in '..\..\..\Common\LockedDialog.pas' {fmLockedDialog},
  PatternDrawing in '..\PatternDrawing.pas' {dmPatternDrawing: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmCaller, fmCaller);
  Application.CreateForm(TfmDebugger, fmDebugger);
  Application.CreateForm(TfmCompareOldNew, fmCompareOldNew);
  Application.CreateForm(TfmAllPatterns, fmAllPatterns);
  Application.CreateForm(TfmMemoryError, fmMemoryError);
  Application.CreateForm(TfmAccessDenied, fmAccessDenied);
  Application.CreateForm(TfmLockedDialog, fmLockedDialog);
  Application.CreateForm(TdmPatternDrawing, dmPatternDrawing);
  dmPatternDrawing.Pass(fmCaller.LocalConnectionSumms);

  Application.Run;
end.
