unit Dongle_Change;
{$A-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,
  ToolWin, ComCtrls, Dongle_Base;

type
  TfmDongleChange = class(TForm)
    tbMain: TPanel;
    btnUpdateDongle: TSpeedButton;
    btnCancel: TSpeedButton;
    btnInformation: TSpeedButton;
    odReadCode: TOpenDialog;
    btnRead: TSpeedButton;
    pnlMain: TPanel;
    lblMessage1: TLabel;
    lblMessage2: TLabel;
    gbUpdateCode: TGroupBox;
    edtUpdateCode: TEdit;
    procedure btnInformationClick(Sender: TObject);
    procedure btnUpdateDongleClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
    procedure edtUpdateCodeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FDongle: TDongle;
    procedure ReadCode;
    function UpdateDongle: Boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Initialise(ADongle: TDongle);
  end;

var
  fmDongleChange: TfmDongleChange;

implementation

uses
  Dongle_Info, const_for_change;

 {$R *.DFM}



{ fmDongleChange }



procedure TfmDongleChange.btnInformationClick(Sender: TObject);
begin
  fmDongleInformation.ShowModal;
end;


procedure TfmDongleChange.btnUpdateDongleClick(Sender: TObject);
begin
   if UpdateDongle then
     ModalResult := mrOk
   else
     ModalResult := mrCancel;
end;


constructor TfmDongleChange.Create(AOwner: TComponent);
begin
  inherited;

  FDongle := nil;
end;


procedure TfmDongleChange.edtUpdateCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    btnUpdateDongle.Click;
end;


procedure TfmDongleChange.FormShow(Sender: TObject);
begin
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;

  edtUpdateCode.Text := '';
end;


procedure TfmDongleChange.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;


procedure TfmDongleChange.btnReadClick(Sender: TObject);
begin
  ReadCode;
end;


procedure TfmDongleChange.Initialise(ADongle: TDongle);
begin
  FDongle := ADongle;
end;


procedure TfmDongleChange.ReadCode;
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

    edtUpdateCode.Text := UpdateCode;
    closefile(F);
  end;
end;


function TfmDongleChange.UpdateDongle: Boolean;
var
  Updated: Boolean;
  iUpdateCode, iUpdateConfirmationCode, iUpdateExtendedError: LongInt;
  s: string;

begin
  Updated := False;

  if FDongle <> nil then
  begin
    btnUpdateDongle.Enabled := False;

    screen.cursor := crHourGlass;
    iUpdateCode := FDongle.UpdateCode(edtUpdateCode.Text);
    screen.cursor := crDefault;

    if (iUpdateCode <> 0) then
    begin
      s := 'Error : ' + IntToStr(iUpdateCode) + ' Extended Error: ' + IntToStr(FDongle.UpdateExtendedError);
      messagedlg(s, mtError, [mbOk], 0);
    end
    else
    begin
      Updated := True;

      messagedlg('Licence updated successfully', mtInformation, [mbok], 0);
    end;

    btnUpdateDongle.Enabled := True;
  end
  else
    messagedlg('Error: Function DongleChange requires a TDongle', mtError, [mbOk], 0);

  Result := Updated;
end;


end.
