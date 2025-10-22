unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, CButton, ExtCtrls, jpeg, ShellApi;

type
  TfmSetup = class(TForm)
    pnlSkin: TPanel;
    btnClose: TColButton;
    btnDatabase: TColButton;
    btnClient32: TColButton;
    btnAdvantage: TBitBtn;
    imgAds: TImage;
    imgAdsNeg: TImage;
    imgMain: TImage;
    btnAssistant32: TColButton;
    btnDigitiser: TColButton;
    btnClient64: TColButton;
    btnAssistant64: TColButton;
    procedure FormCreate(Sender: TObject);
    procedure btnClient32Click(Sender: TObject);
    function RunExternalAndWait(Command, Parameters, Directory: String): Boolean;
    procedure pnlSkinMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDatabaseClick(Sender: TObject);
    procedure btnClient32MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnDatabaseMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCloseMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnAdvantageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnAssistant32Click(Sender: TObject);
    procedure btnAssistant32MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnDigitiserClick(Sender: TObject);
    procedure btnClient64Click(Sender: TObject);
    procedure btnClient64MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnDigitiserMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnAssistant64Click(Sender: TObject);
    procedure btnAssistant64MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    AdvantageButtonBlack : Boolean;
  public
    { Public declarations }
    ThisDir: string;
  end;

var
  fmSetup: TfmSetup;

implementation

uses SeverVersion;

{$R *.DFM}

procedure TfmSetup.FormCreate(Sender: TObject);
begin
  ThisDir := ExtractFilePath(Application.ExeName);
  if copy(ThisDir, length(ThisDir), 1) <> '\' then
    ThisDir := ThisDir + '\';

  btnClient32.Caption := 'Client' + sLineBreak + '(&32 bit)';
  btnClient64.Caption := 'Client' + sLineBreak + '(&64 bit)';
  btnAssistant32.Caption := 'Assistant' + sLineBreak + '(3&2 bit)';
  btnAssistant64.Caption := 'Assistant' + sLineBreak + '(6&4 bit)';
  btnClient64.Enabled := TOSVersion.Architecture = arIntelX64;
  btnAssistant64.Enabled := TOSVersion.Architecture = arIntelX64;

  AdvantageButtonBlack := False;
end;

procedure TfmSetup.imgMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  btnDigitiser.color := clWhite;
  btnDigitiser.font.color := $00430403;
  btnClient32.color := clWhite;
  btnClient32.font.color := $00430403;
  btnClient64.color := clWhite;
  btnClient64.font.color := $00430403;
  btnAssistant32.color := clWhite;
  btnAssistant32.font.color := $00430403;
  btnAssistant64.color := clWhite;
  btnAssistant64.font.color := $00430403;
  btnDatabase.color := clWhite;
  btnDatabase.font.color := $00430403;
  btnClose.color := clWhite;
  btnClose.font.color := $00430403;
  if AdvantageButtonBlack then
    btnAdvantage.Glyph := imgAds.Picture.Bitmap;
  AdvantageButtonBlack := False;
end;

procedure TfmSetup.btnClient32Click(Sender: TObject);
begin
  RunExternalAndWait('Setup.exe', '/w', ThisDir + 'Client32');
end;

function TfmSetup.RunExternalAndWait(Command, Parameters, Directory: String): Boolean;
var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;

begin
  fmSetUp.visible := False;

  FillChar(SEInfo, SizeOf(SEInfo), 0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);
  with SEInfo do
  begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar(Command);
    lpParameters := PChar(Parameters);
    lpDirectory := PChar(Directory);
    nShow := SW_SHOWNORMAL;
  end;

  if ShellExecuteEx(@SEInfo) then
  begin
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(SEInfo.hProcess, ExitCode);
    until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
  end
  else
    ShowMessage('Error starting external application') ;

  fmSetUp.visible := True;
end;

procedure TfmSetup.pnlSkinMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  btnDigitiser.color := clWhite;
  btnDigitiser.font.color := $00430403;
  btnClient32.color := clWhite;
  btnClient32.font.color := $00430403;
  btnClient64.color := clWhite;
  btnClient64.font.color := $00430403;
  btnAssistant32.color := clWhite;
  btnAssistant32.font.color := $00430403;
  btnAssistant64.color := clWhite;
  btnAssistant64.font.color := $00430403;
  btnDatabase.color := clWhite;
  btnDatabase.font.color := $00430403;
  btnClose.color := clWhite;
  btnClose.font.color := $00430403;
  if AdvantageButtonBlack then
    btnAdvantage.Glyph := imgAds.Picture.Bitmap;
  AdvantageButtonBlack := False;
end;

procedure TfmSetup.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfmSetup.btnDatabaseClick(Sender: TObject);
begin
  RunExternalAndWait('Setup.exe', '/w', ThisDir + 'Database');
end;

procedure TfmSetup.btnClient32MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  btnDigitiser.color := clWhite;
  btnDigitiser.font.color := $00430403;
  btnClose.color := clWhite;
  btnClose.font.color := $00430403;
  btnDatabase.color := clWhite;
  btnDatabase.font.color := $00430403;
  btnAssistant32.color := clWhite;
  btnAssistant32.font.color := $00430403;
  btnAssistant64.color := clWhite;
  btnAssistant64.font.color := $00430403;
  btnClient32.color := clBlack;
  btnClient32.font.color := $00BCFBFC;
  btnClient64.color := clWhite;
  btnClient64.font.color := $00430403;
  if AdvantageButtonBlack then
    btnAdvantage.Glyph := imgAds.Picture.Bitmap;
  AdvantageButtonBlack := False;
end;

procedure TfmSetup.btnClient64Click(Sender: TObject);
begin
  RunExternalAndWait('Setup.exe', '/w', ThisDir + 'Client64');
end;

procedure TfmSetup.btnClient64MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  btnDigitiser.color := clWhite;
  btnDigitiser.font.color := $00430403;
  btnClose.color := clWhite;
  btnClose.font.color := $00430403;
  btnDatabase.color := clWhite;
  btnDatabase.font.color := $00430403;
  btnAssistant32.color := clWhite;
  btnAssistant32.font.color := $00430403;
  btnAssistant64.color := clWhite;
  btnAssistant64.font.color := $00430403;
  btnClient32.color := clWhite;
  btnClient32.font.color := $00430403;
  btnClient64.color := clBlack;
  btnClient64.font.color := $00BCFBFC;
  if AdvantageButtonBlack then
    btnAdvantage.Glyph := imgAds.Picture.Bitmap;
  AdvantageButtonBlack := False;
end;

procedure TfmSetup.btnDatabaseMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  btnDigitiser.color := clWhite;
  btnDigitiser.font.color := $00430403;
  btnClient32.color := clWhite;
  btnClient32.font.color := $00430403;
  btnClient64.color := clWhite;
  btnClient64.font.color := $00430403;
  btnAssistant32.color := clWhite;
  btnAssistant32.font.color := $00430403;
  btnAssistant64.color := clWhite;
  btnAssistant64.font.color := $00430403;
  btnClose.color := clWhite;
  btnClose.font.color := $00430403;
  btnDatabase.color := clBlack;
  btnDatabase.font.color := $00BCFBFC;
  if AdvantageButtonBlack then
    btnAdvantage.Glyph := imgAds.Picture.Bitmap;
  AdvantageButtonBlack := False;
end;

procedure TfmSetup.btnDigitiserClick(Sender: TObject);
begin
  RunExternalAndWait('Setup.exe', '/w', ThisDir + 'Digitiser');
end;

procedure TfmSetup.btnDigitiserMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  btnDigitiser.color := clBlack;
  btnDigitiser.font.color := $00BCFBFC;
  btnClient32.color := clWhite;
  btnClient32.font.color := $00430403;
  btnClient64.color := clWhite;
  btnClient64.font.color := $00430403;
  btnDatabase.color := clWhite;
  btnDatabase.font.color := $00430403;
  btnClose.color := clWhite;
  btnClose.font.color := $00430403;
  btnAssistant32.color := clWhite;
  btnAssistant32.font.color := $00430403;
  btnAssistant64.color := clWhite;
  btnAssistant64.font.color := $00430403;
  if AdvantageButtonBlack then
    btnAdvantage.Glyph := imgAds.Picture.Bitmap;
  AdvantageButtonBlack := False;
end;

procedure TfmSetup.btnAssistant32Click(Sender: TObject);
begin
  RunExternalAndWait('Setup.exe', '/w', ThisDir + 'Tools32');
end;

procedure TfmSetup.btnAssistant32MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  btnDigitiser.color := clWhite;
  btnDigitiser.font.color := $00430403;
  btnClient32.color := clWhite;
  btnClient32.font.color := $00430403;
  btnClient64.color := clWhite;
  btnClient64.font.color := $00430403;
  btnDatabase.color := clWhite;
  btnDatabase.font.color := $00430403;
  btnClose.color := clWhite;
  btnClose.font.color := $00430403;
  btnAssistant32.color := clBlack;
  btnAssistant32.font.color := $00BCFBFC;
  btnAssistant64.color := clWhite;
  btnAssistant64.font.color := $00430403;
  if AdvantageButtonBlack then
    btnAdvantage.Glyph := imgAds.Picture.Bitmap;
  AdvantageButtonBlack := False;
end;

procedure TfmSetup.btnAssistant64Click(Sender: TObject);
begin
  RunExternalAndWait('Setup.exe', '/w', ThisDir + 'Tools64');
end;

procedure TfmSetup.btnAssistant64MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  btnDigitiser.color := clWhite;
  btnDigitiser.font.color := $00430403;
  btnClient32.color := clWhite;
  btnClient32.font.color := $00430403;
  btnClient64.color := clWhite;
  btnClient64.font.color := $00430403;
  btnDatabase.color := clWhite;
  btnDatabase.font.color := $00430403;
  btnClose.color := clWhite;
  btnClose.font.color := $00430403;
  btnAssistant32.color := clWhite;
  btnAssistant32.font.color := $00430403;
  btnAssistant64.color := clBlack;
  btnAssistant64.font.color := $00BCFBFC;
  if AdvantageButtonBlack then
    btnAdvantage.Glyph := imgAds.Picture.Bitmap;
  AdvantageButtonBlack := False;
end;

procedure TfmSetup.btnCloseMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  btnDigitiser.color := clWhite;
  btnDigitiser.font.color := $00430403;
  btnClient32.color := clWhite;
  btnClient32.font.color := $00430403;
  btnClient64.color := clWhite;
  btnClient64.font.color := $00430403;
  btnAssistant32.color := clWhite;
  btnAssistant32.font.color := $00430403;
  btnAssistant64.color := clWhite;
  btnAssistant64.font.color := $00430403;
  btnDatabase.color := clWhite;
  btnDatabase.font.color := $00430403;
  btnClose.color := clBlack;
  btnClose.font.color := $00BCFBFC;
  if AdvantageButtonBlack then
    btnAdvantage.Glyph := imgAds.Picture.Bitmap;
  AdvantageButtonBlack := False;
end;

procedure TfmSetup.BitBtn1Click(Sender: TObject);
begin
  fmServerVersion.ShowModal;
end;

procedure TfmSetup.btnAdvantageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  btnDigitiser.color := clWhite;
  btnDigitiser.font.color := $00430403;
  btnClient32.color := clWhite;
  btnClient32.font.color := $00430403;
  btnClient64.color := clWhite;
  btnClient64.font.color := $00430403;
  btnAssistant32.color := clWhite;
  btnAssistant32.font.color := $00430403;
  btnAssistant64.color := clWhite;
  btnAssistant64.font.color := $00430403;
  btnDatabase.color := clWhite;
  btnDatabase.font.color := $00430403;
  btnClose.color := clWhite;
  btnClose.font.color := $00430403;
  if not AdvantageButtonBlack then
    btnAdvantage.Glyph := imgAdsNeg.Picture.Bitmap;
  AdvantageButtonBlack := True;
end;

end.

