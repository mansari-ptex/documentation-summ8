program LayPlan;

uses
  Windows,
  Forms,
  LayMain in 'LayMain.pas' {fmCaller},
  AllKnives in 'AllKnives.pas' {fmAllKnives},
  FastGEO in 'FastGEO.pas',
  Interlocking in 'Interlocking.pas',
  PolygonOverlaps in 'PolygonOverlaps.pas',
  ConvexHull in 'ConvexHull.pas',
  Results in 'Results.pas',
  Expansion in 'Expansion.pas',
  Merge in 'Merge.pas',
  Debugger in 'Debugger.pas' {fmDebugger},
  PlanIt in 'PlanIt.pas',
  PrintOut in 'PrintOut.pas' {fmrpLayPlan},
  DDCheck in '..\..\Common\DDCheck.pas',
  Concavities in 'Concavities.pas',
  AllSyntheticMaterials in 'AllSyntheticMaterials.pas' {fmAllSyntheticMaterials},
  AllLayplans in 'AllLayplans.pas' {fmAllLayplans},
  AdvErrorHandler in '..\..\Common\AdvErrorHandler.pas' {fmErrorHandler},
  CmnVars in '..\..\Common\CmnVars.pas',
  ScreenDimensions in '..\..\Common\ScreenDimensions.pas',
  General_Interlocking in 'General_Interlocking.pas';

{$R *.res}

begin
  {Attempt to create a named mutex}
  CreateMutex(nil, false, 'Layplanning');
  {if it failed then there is another instance}
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    {Send all windows our custom message - only our other}
    {instance will recognise it, and restore itself}
    SendMessage(HWND_BROADCAST, RegisterWindowMessage('Layplanning'), 0, 0);

    {Lets quit}
    Halt(0);
  end;

  Application.Initialize;
  Application.CreateForm(TfmCaller, fmCaller);
  Application.CreateForm(TfmAllKnives, fmAllKnives);
  Application.CreateForm(TfmDebugger, fmDebugger);
  Application.CreateForm(TfmAllSyntheticMaterials, fmAllSyntheticMaterials);
  Application.CreateForm(TfmAllLayplans, fmAllLayplans);
  Application.CreateForm(TfmErrorHandler, fmErrorHandler);
  Application.Run;
end.
