unit DongleInfo_Green;

interface

//VSTITCH is defined in the Project Options - Directories/Conditionals
//for the VisionStitch project only.

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CmnVars, ExtCtrls, General
{$IFDEF VSTITCH}
  ,TranSys, Data, CallDlg
{$ENDIF}
  ;

type
  TfmDongleInformationGreen = class(TForm)
    lblExtendedError: TLabel;
    pnlBackground: TPanel;
    lblNoDongleDetected: TLabel;
    pnlInfo: TPanel;
    lblFeatures: TLabel;
    lblExpiry: TLabel;
    lblSerial_Number: TLabel;
    lblUpdates: TLabel;
    lblFeaturesTitle: TLabel;
    lblExpiryTitle: TLabel;
    lblSerial_NumberTitle: TLabel;
    lblUpdatesTitle: TLabel;
    lblProductCode: TLabel;
    lblProductCodeTitle: TLabel;
    lblSystemTitle: TLabel;
    lblSystem: TLabel;
    imgDongle: TImage;
    lblCustomerName: TLabel;
    lblCustomerNameTitle: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    MainColor, MainFontColor: TColor;
  public
    { Public declarations }
  end;

var
  fmDongleInformationGreen: TfmDongleInformationGreen;

implementation

uses
  Dongle_Green;

{$R *.DFM}

procedure TfmDongleInformationGreen.FormShow(Sender: TObject);
var
  Dongle: TDongle;
  ExpiryDate: TDateTime;
  RetCode: LongInt;

begin
  lblFeatures.Caption := '---';
  lblFeatures.Enabled := False;
  lblFeaturesTitle.Enabled := False;

  lblExpiry.Caption := '---';
  lblExpiry.Enabled := False;
  lblExpiryTitle.Enabled := False;

  lblSerial_Number.Caption := '---';
  lblSerial_Number.Enabled := False;
  lblSerial_NumberTitle.Enabled := False;

  lblUpdates.Caption := '---';
  lblUpdates.Enabled := False;
  lblUpdatesTitle.Enabled := False;

  lblProductCode.Caption := '---';
  lblProductCode.Enabled := False;
  lblProductCodeTitle.Enabled := False;

  lblSystem.Caption := '-';
  lblSystem.Enabled := True;
  lblSystemTitle.Enabled := True;

  Dongle := ProtCheck(READ_DATA_AREA);

  pnlInfo.Visible := True;
  if (Dongle.Code = 401) or (dris.prodcode <> 'SATRA') then
    pnlInfo.Visible := False
  else
  begin
    try
      lblFeatures.Caption := IntToStr(dris.Features);
      lblFeatures.Enabled := True;
      lblFeaturesTitle.Enabled := True;
    except
    end;

    if (dris.exp_month > 0) and (dris.exp_month < 13) then
    begin
      try
        ExpiryDate := EncodeDate(dris.exp_year, dris.exp_month, dris.exp_day);
        lblExpiry.Caption := DateToStr(ExpiryDate);
        lblExpiry.Enabled := True;
        lblExpiryTitle.Enabled := True;
      except
      end;
    end;

    try
      lblSerial_Number.Caption := IntToStr(dris.dongle_number);
      lblSerial_Number.Enabled := True;
      lblSerial_NumberTitle.Enabled := True;
    except
    end;

    try
      lblUpdates.Caption := IntToStr(dris.update_number);    //was +1 for blue - should it be here?????
      lblUpdates.Enabled := True;
      lblUpdatesTitle.Enabled := True;
    except
    end;

    try
      lblProductCode.Caption := dris.prodcode;
      lblProductCode.Enabled := True;
      lblProductCodeTitle.Enabled := True;
    except
    end;

    lblSystem.Caption := IntToStr(Dongle.Code);
    lblSystem.Enabled := True;
    lblSystemTitle.Enabled := True;

    lblCustomerName.Caption := Dongle.CustomerName;
    lblCustomerName.Enabled := True;
    lblCustomerNameTitle.Enabled := True;
  end;
end;

procedure TfmDongleInformationGreen.FormCreate(Sender: TObject);
var
  Form: TForm;

begin
  {$IFDEF VSTITCH}
  LoadTags(dm.tblSystemWords, dm.tblTranslationLookUp, (Sender as TForm));
  Translate(dm.tblGeneralLanguage.value, dm.tblTranslation, dm.tblTranslationLookUp, (Sender as TForm));
  {$ENDIF}

  AutoColor(Self);

//  Form := (Sender as TForm);

//  Form.left := (Screen.Width div 2) - (Form.Width div 2);
//  Form.top := (Screen.Height div 2) - (Form.Height div 2);

  Form := Application.MainForm;

  Left := Form.Left + (Form.Width div 2) - (Width div 2);
  Top := Form.Top + (Form.Height div 2) - (Height div 2);
end;

end.
