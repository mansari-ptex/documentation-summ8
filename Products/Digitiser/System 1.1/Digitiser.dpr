program Digitiser;

uses
  Windows,
  Forms,
  Dialogs,
  IniFiles,
  Controls,
  DigitiserMain in 'DigitiserMain.pas' {fmDigitiser},
  DigitiserAllPatterns in 'DigitiserAllPatterns.pas' {fmPatterns},
  DigitiserCalls in 'DigitiserCalls.pas' {fmDigitiserCalls},
  PathGeometry in '..\..\Common\PathGeometry.pas',
  PathGlobals in '..\..\Common\PathGlobals.pas',
  DigitiserPatternName in 'DigitiserPatternName.pas' {fmPatternName},
  TABCONLib_TLB in 'TABCONLib_TLB.pas',
  General in '..\..\Common\General.pas',
  OutOfMemory in '..\..\Common\OutOfMemory.pas' {fmMemoryError},
  CmnVars in '..\..\Common\CmnVars.pas',
  LockedDialog in '..\..\Common\LockedDialog.pas' {fmLockedDialog},
  AccessDenied in '..\..\Common\AccessDenied.pas' {fmAccessDenied};

{$R *.RES}

begin
  CreateMutex(nil, false, 'Digitiser');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    messagedlg('Digitiser is already running', mtInformation, [mbOk], 0);

    Halt(0);
  end;

  Application.Title := 'Digitiser';
  Application.CreateForm(TfmDigitiser, fmDigitiser);
  Application.CreateForm(TfmMemoryError, fmMemoryError);
  Application.CreateForm(TfmLockedDialog, fmLockedDialog);
  Application.CreateForm(TfmAccessDenied, fmAccessDenied);
  Application.CreateForm(TfmDigitiserCalls, fmDigitiserCalls);
  Application.Initialize;

  Application.Run;
end.

