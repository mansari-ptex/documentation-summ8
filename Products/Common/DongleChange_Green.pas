unit DongleChange_Green;
{$A-}

interface

//VSTITCH is defined in the Project Options - Directories/Conditionals
//for the VisionStitch project only.

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ToolWin, ComCtrls, CmnVars, General
{$IFDEF VSTITCH}
  ,TranSys, Data, CallDlg, VStitchMain
{$ENDIF}
  ;

type
  TfmDongleChangeGreen = class(TForm)
    tbMain: TPanel;
    btnUpdateDongle: TSpeedButton;
    btnCancel: TSpeedButton;
    btnInformation: TSpeedButton;
    odReadCode: TOpenDialog;
    btnRead: TSpeedButton;
    lblError: TLabel;
    lblExtendedError: TLabel;
    pnlMain: TPanel;
    lblMessage1: TLabel;
    lblMessage2: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    gbUpdateCode: TGroupBox;
    eUpdateCode: TEdit;
    pnlError: TPanel;
    procedure btnInformationClick(Sender: TObject);
    procedure btnUpdateDongleClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure eUpdateCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure odReadCodeShow(Sender: TObject);
  private
    { Private declarations }
    MainColor, MainFontColor: TColor;
  public
    { Public declarations }
  end;

var
  fmDongleChangeGreen: TfmDongleChangeGreen;

  { constants }
  const MAX_USB_DEVICES = 128;                  { maximum number of USB devices that can be attached to the system at one time }
  const MAX_PRODCODE_LEN = 8;                   { maximum length of a Product Code }

  { mask values }
  const TYPE_MASK_PRO = 1;
  const TYPE_MASK_FD  = 2;
  const TYPE_MASK_ALL = TYPE_MASK_PRO or TYPE_MASK_FD;

  const MODEL_MASK_LITE    = 1;
  const MODEL_MASK_PLUS    = 2;
  const MODEL_MASK_NET     = 4;
  const MODEL_MASK_ALL	   = MODEL_MASK_LITE or MODEL_MASK_PLUS or MODEL_MASK_NET;
  const MODEL_MASK_DEFAULT = MODEL_MASK_PLUS or MODEL_MASK_NET;

  { type values (returned in the array) }
  const TYPE_PRO = 1;
  const TYPE_FD	 = 2;

  { model values (returned in the array) }
  const MODEL_LITE  = 1;
  const MODEL_PLUS  = 2;
  const MODEL_NET5  = 4;
  const MODEL_NETU  = 7;

  {$IFDEF WIN32}
  function DCDoUpdateCodeString(UpdateCodeString: PAnsiChar; confirmation_code, extended_error: PLongInt): LongInt; stdcall; external 'DinkeyChange.dll';
  {$ENDIF}
  {$IFDEF WIN64}
  function DCDoUpdateCodeString(UpdateCodeString: PAnsiChar; confirmation_code, extended_error: PLongInt): LongInt; stdcall; external 'DinkeyChange64.dll';
  {$ENDIF}

implementation

uses
  DongleInfo_Green;

{$R *.DFM}

procedure TfmDongleChangeGreen.btnInformationClick(Sender: TObject);
begin
  fmDongleInformationGreen.ShowModal;
end;

procedure TfmDongleChangeGreen.btnUpdateDongleClick(Sender: TObject);
var
  ret_code, confirmation_code, extended_error: LongInt;
  update_code: array[0..255] of AnsiChar;

begin
  screen.cursor := crHourGlass;
  btnUpdateDongle.Enabled := False;

  StrPCopy(update_code, AnsiString(eUpdateCode.Text));  //to get a null-terminated string
  ret_code := DCDoUpdateCodeString(@update_code, @confirmation_code, @extended_error);

  screen.cursor := crDefault;

  if (ret_code <> 0) then
  begin
    {$IFDEF VSTITCH}
    trnMessageDlg(lblError.Caption + ': ' + IntToStr(ret_code) + ' ' + lblExtendedError.Caption + ': ' +
                  IntToStr(extended_error), 'Error', application.MainForm.color,
                  application.MainForm.font.color, False);
    {$ELSE}
    messagedlg (lblError.Caption + ': ' + IntToStr(ret_code) + ' ' + lblExtendedError.Caption + ': ' +
                IntToStr(extended_error), mterror, [mbok], 0);
    {$ENDIF}
  end
  else
  begin
    {$IFDEF VSTITCH}
    trnMessageDlg('Licence updated successfully', 'Information',
                   application.MainForm.color, application.MainForm.font.color, True);
    {$ELSE}
    messagedlg('Licence updated successfully', mtInformation, [mbok], 0);
    {$ENDIF}
  end;

  btnUpdateDongle.Enabled := True;
  Close;
end;

procedure TfmDongleChangeGreen.eUpdateCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    btnUpdateDongle.Click;
end;

procedure TfmDongleChangeGreen.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfmDongleChangeGreen.btnReadClick(Sender: TObject);
var
  F: TextFile;
  DriveLetter, UpdateCode: string;
  WindowsDir: array[0..255] of Char;

begin
  GetWindowsDirectory(WindowsDir, 256);

  DriveLetter := ExtractFileDrive(WindowsDir);

  odReadCode.InitialDir := DriveLetter + '\TranCode';

  if odReadCode.Execute then
  begin
    assignfile(F, odReadCode.FileName);
    reset(F);
    readln(F, UpdateCode);

    eUpdateCode.Text := UpdateCode;
    closefile(F);
  end;
end;

procedure TfmDongleChangeGreen.FormCreate(Sender: TObject);
begin
  {$IFDEF VSTITCH}
  LoadTags(dm.tblSystemWords, dm.tblTranslationLookUp, (Sender as TForm));
  Translate(dm.tblGeneralLanguage.value, dm.tblTranslation, dm.tblTranslationLookUp, (Sender as TForm));
  {$ENDIF}

  AutoColor(Self);
end;

procedure TfmDongleChangeGreen.FormShow(Sender: TObject);
var
  Form: TForm;

begin
  {$IFDEF VSTITCH}
  if fmVisionStitch.lblError.Visible then
  begin
    pnlError.caption := fmVisionStitch.lblError.caption;
    pnlError.visible := True;
    Height := 200;
  end
  else
  begin
    pnlError.visible := False;
    Height := 200 - pnlError.Height;
  end;
  {$ELSE}
  pnlError.visible := False;
  Height := 200 - pnlError.Height;
  {$ENDIF}

//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);
end;

procedure TfmDongleChangeGreen.odReadCodeShow(Sender: TObject);
var
  dlgRect: TRect;

begin
  //Believed to work the first time but windows overrides the location after this
  //  to the last location of the OpenDialog.
  with odReadCode do
  begin
    GetWindowRect(GetParent(handle), dlgRect);
    SetWindowPos(GetParent(handle), 0, Application.MainForm.Left + (Application.MainForm.Width div 3), Application.MainForm.Top + (Application.MainForm.Height div 3), 0, 0, SWP_NOSIZE);
    Abort;
  end;
end;

end.
